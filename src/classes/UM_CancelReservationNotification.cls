/***
*Name: UM_CancelReservationNotification.cls
*Description: as part of UMR 174 to update phone no. status to cancel
*Date: 13/03/2017
*Created By: Abhimanyu Sharma
***/

global class UM_CancelReservationNotification implements Database.batchable<SObject>, database.allowscallouts {

    global String query;
    public static list<UM_Asset_Process_Association__c> records;
    public set<id> assetIDs = new set<id>();
    public list<asset> phoneNumbers = new list<asset>();
    public map<id,UM_PortingProcess__c> assetProcessMap = new map<id,UM_PortingProcess__c>();
    private String endpoint;
    public Set<id> opptyLIstID=new set<id>();
    public  Set<String> idStrs;
    public  List<Opportunity>  cancelledOpptyList;


    global UM_CancelReservationNotification(set<id> cancelledOpportunities){
        /*cancelledOpptyList=[select id,name,stagename from opportunity where id in :cancelledOpportunities];

        if(cancelledOpptyList!=null){
            for( Opportunity o:cancelledOpptyList){
                opptyLIstID.add(o.id);
        }*/

        //idStrs = (Set<String>)JSON.deserialize(JSON.serialize(opptyLIstID), Set<String>.class);
        opptyLIstID = cancelledOpportunities;
        query='select id,name,status, LG_TelephonyProductConfiguration__c,LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__c'+
                ',account.Name,UM_StartNumber__c,UM_EndNumber__c,UM_AreaCode__c from Asset '+
                ' where LG_TelephonyProductConfiguration__r.cscfga__Product_Family__c=\'Number Range\' '+
                ' and RecordType.Name=\'Number Block\''+
                ' and LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c in :opptyLIstID';
      // }

    }

    global Database.QueryLocator start(Database.batchableContext bc) {

        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Asset> scope) {
        set<id> productConfigIds = new set<id>();
        map<id,cscfga__Attribute__c> prodConfigAttributeMap = new map<id,cscfga__Attribute__c>();
        list<cscfga__Attribute__c> attributeList = new list<cscfga__Attribute__c>();

        InfoportServiceConnection__c connection = InfoportServiceConnection__c.getInstance();
        infportwsUnitymediaCom.InfportWSPort pbWebService = new infportwsUnitymediaCom.InfportWSPort();
        pbWebservice.endpoint_x = connection.Connection_URL__c; //'http://172.25.46.55:8001/infportWebservice12/ipWS';
        pbWebservice.inputHttpHeaders_x = new Map<String, String>();
        pbWebservice.inputHttpHeaders_x.put('Authorization', connection.Authentication_Token__c);
        if(connection.Session_Timeout__c!=null)
            pbWebservice.timeout_x = Integer.valueOf(connection.Session_Timeout__c);

        for(Asset a :(list<asset>) scope){
            productConfigIds.add(a.LG_TelephonyProductConfiguration__c);
        }
        attributeList = [select id,name,cscfga__Display_Value__c,cscfga__Value__c,cscfga__Product_Configuration__c from cscfga__Attribute__c where
                            cscfga__Product_Configuration__c in :productConfigIds
                            and name = 'Reservation Number' and cscfga__Display_Value__c!=null
                            ];
        for(cscfga__Attribute__c att : attributeList)
            prodConfigAttributeMap.put(att.cscfga__Product_Configuration__c,att);

        for(Asset a :(list<asset>) scope){
            wwwDialogikaDeWsdlInfportSchemasIn.taIPhone rPhones = new wwwDialogikaDeWsdlInfportSchemasIn.taIPhone();
            rPhones.phone = new list<wwwDialogikaDeWsdlInfportSchemasIn.tIPhone>();
            wwwDialogikaDeWsdlInfportSchemasIn.tIPhone rPhone = new wwwDialogikaDeWsdlInfportSchemasIn.tIPhone();
            wwwDialogikaDeWsdlInfportSchemasSp.tIReservationInfo rInfo = new wwwDialogikaDeWsdlInfportSchemasSp.tIReservationInfo();
            rInfo.reservedUntil = Date.today()+30;
            rInfo.portDate = Date.today();
            rInfo.reservationKey = prodConfigAttributeMap.get(a.LG_TelephonyProductConfiguration__c).cscfga__Display_Value__c;
            String reservationKey = rInfo.reservationKey;

            rPhone.prefix=a.UM_AreaCode__c;
            rPhone.startNumber = a.UM_StartNumber__c;
            rPhone.endNumber = a.UM_EndNumber__c;
            rPhones.phone.add(rPhone);
            try{
                wwwDialogikaDeWsdlInfportSchemasIn.tVoid resp = pbWebservice.removeReservation(rPhones,rInfo,null,reservationKey,null,null,null,connection.Authentication_Token__c);
                a.status='Cancelled';
            }catch(Exception e){
                System.debug('**** Error - '+e.getMessage());
            }


        }

        update scope;

    }

    global void finish(Database.BatchableContext bc) {
        system.debug('Notify on Change of oppty Status');
    }

   /*

public void removeReservation(){
        InfoportServiceConnection__c connection = InfoportServiceConnection__c.getInstance();
        infportwsUnitymediaCom.InfportWSPort pbWebService = new infportwsUnitymediaCom.InfportWSPort();
        pbWebservice.endpoint_x = connection.Connection_URL__c; //'http://172.25.46.55:8001/infportWebservice12/ipWS';
        pbWebservice.inputHttpHeaders_x = new Map<String, String>();
        pbWebservice.inputHttpHeaders_x.put('Authorization', connection.Authentication_Token__c);
        if(connection.Session_Timeout__c!=null)
            pbWebservice.timeout_x = Integer.valueOf(connection.Session_Timeout__c);

        wwwDialogikaDeWsdlInfportSchemasSp.tIReservationInfo rInfo = new wwwDialogikaDeWsdlInfportSchemasSp.tIReservationInfo();
        rInfo.reservedUntil = Date.today()+30;
        rInfo.portDate = Date.today();
        rInfo.reservationKey = '0000029779';
        String reservationKey = '0000029779';
        wwwDialogikaDeWsdlInfportSchemasIn.taIPhone rPhones = new wwwDialogikaDeWsdlInfportSchemasIn.taIPhone();
        rPhones.phone = new list<wwwDialogikaDeWsdlInfportSchemasIn.tIPhone>();
        wwwDialogikaDeWsdlInfportSchemasIn.tIPhone rPhone = new wwwDialogikaDeWsdlInfportSchemasIn.tIPhone();
        //rPhone.ndc = '0049';
        //rPhone.prefix='201';
        //rPhone.startNumber = '45844817';
        rPhones.phone.add(rPhone);
        System.debug('*** rPhones='+rPhones);
        wwwDialogikaDeWsdlInfportSchemasIn.tVoid resp = pbWebservice.removeReservation(rPhones,rInfo,null,reservationKey,null,null,connection.Authentication_Token__c);
        System.debug('*** resp='+resp);
    }*/
}