public class LG_OpportunityTriggerHandler
{
    /**
    * Sets the Subscription and the Service status to Request Deactivation Status,
    * for the 'replaced' subscriptions/services while doing MACD move/Migrate
    * Also populates the termination/deactivation wish dates on the relevant services.
    *
    * @param  List<Opportunity> opps
    * @param  Map<Id, Opportunity> oldMap
    * @author Tomislav Blazek
    * @ticket SFDT-499
    * @since  16/3/2016
    */
    public static boolean isExecuting = false;
    public static void deactivateSubscriptionServices(List<Opportunity> opps,
                                                        Map<Id, Opportunity> oldMap)
    {
        //holds a set of Opp Ids for checking the baskets
        Set<Id> oppIds = new Set<Id>();

        /*
        * Decide which opportunities should be processed:
         * - opportunities that had been closed won
        * - opportunities of a Migrate or Move change type
        * - opportunities that have synced basket populated
        */
        csordtelcoa__Orders_Subscriptions_Options__c cs = csordtelcoa__Orders_Subscriptions_Options__c.getInstance();

        for (Opportunity opp : opps) {
            Opportunity oldOpp = oldMap == null ? null : oldMap.get(opp.Id);

            if (Opp.stageName==cs.csordtelcoa__Opportunity_Stages_creating_orders__c
                && (LG_Util.getMigrateVarietyChangeTypes().contains(opp.csordtelcoa__Change_Type__c) || opp.csordtelcoa__Change_Type__c == 'Move' || opp.csordtelcoa__Change_Type__c == 'Terminate')
                && (oldOpp == null || (oldOpp.StageName != opp.StageName))) {
                oppIds.add(opp.Id);
            }
        }

        if  (!oppIds.isEmpty()) {

            Set<Id> replacedServiceIds = new Set<Id>();
            Set<Id> basketIds = new Set<Id>();
            for(cscfga__Product_Configuration__c config : [SELECT Id, csordtelcoa__Replaced_Service__c,
                                                              cscfga__Product_Basket__c, LG_ChangeType__c,
                                                              cscfga__Product_Definition__r.LG_ProductSubtype__c
                                                              FROM cscfga__Product_Configuration__c
                                                              WHERE cscfga__Product_Basket__c IN (SELECT Id
                                                        FROM cscfga__Product_Basket__c
                                                        WHERE csordtelcoa__Synchronised_with_Opportunity__c = true
                                                        AND (csordtelcoa__Change_Type__c IN :LG_Util.getMigrateVarietyChangeTypes() OR
                                                                csordtelcoa__Change_Type__c = 'Move' OR
                                                                csordtelcoa__Change_Type__c = 'Terminate')
                                                                                                    AND cscfga__Opportunity__c IN :oppIds)]){
                basketIds.add(config.cscfga__Product_Basket__c);
                if (config.cscfga__Product_Definition__r.LG_ProductSubtype__c != 'Termination' && config.LG_ChangeType__c != 'Move') {
                replacedServiceIds.add(config.csordtelcoa__Replaced_Service__c);
            }
            }

            if (!basketIds.isEmpty()) {

                /**
                 * Query is expanded to encompass Services line item that will be updated to deleted
                 *
                 * @author Petar Miletic
                 * @ticket SFOM-648
                 * @since  20/04/2017
                 */
                List<csord__Service__c> services = [SELECT Id, csord__Status__c, LG_Address__c, csordtelcoa__Delta_Status__c,
                                                    csord__Subscription__r.csord__Status__c, csord__Subscription__c,
                                                    (SELECT Id, LG_IsPenaltyFee__c FROM csord__service_line_items__r)
                                                    FROM csord__Service__c
                                                    WHERE Id NOT IN :replacedServiceIds
                                                    AND csord__Subscription__c
                                                    IN (SELECT csordtelcoa__Subscription__c
                                                        FROM csordtelcoa__Subscr_MACDProductBasket_Association__c
                                                        WHERE csordtelcoa__Product_Basket__c IN :basketIds)];

                if (!services.isEmpty())
                {

                    Set<csord__Subscription__c> subsForUpdate = new Set<csord__Subscription__c>();
                    List<csord__Service_Line_Item__c> slisForUpdate = new List<csord__Service_Line_Item__c>();

                    for (csord__Service__c service : services) {
                        //update Subscriptions status
                        service.csord__Subscription__r.csord__Status__c = LG_Util.getSubscriptionRequestDeactivateStatus();
                        subsForUpdate.add(service.csord__Subscription__r);

                        //update Services status and Deactivation date
                        service.csord__Status__c = LG_Util.getServiceRequestDeactivateStatus();
                        //SFOM-1711
                        service.csordtelcoa__Delta_Status__c = 'Deleted From Subscription';
                        /**
                         * Set delta status to deleted
                         *
                         * @author Petar Miletic
                         * @ticket SFOM-648
                         * @since  20/04/2017
                         */
                        for (csord__Service_Line_Item__c sli :service.csord__service_line_items__r) {
                            if (!sli.LG_IsPenaltyFee__c) {
                                sli.csordtelcoa__Delta_Status__c = 'Deleted';
                            }
                            slisForUpdate.add(sli);
                        }
                    }
                    update services;
                    if (!slisForUpdate.isEmpty()) {
                        update slisForUpdate;
                    }
                    update new List<csord__Subscription__c>(subsForUpdate);
                }
            }
        }
    }

    /**
    * Sets the Subscription and the Service status to Request Deactivation Status,
    * for the product configurations that were deleted from the product basket while
    * doing a MACD Change scenario (basically for terminated products).
    *
    * @param  List<Opportunity> opps
    * @param  Map<Id, Opportunity> oldMap
    * @author Tomislav Blazek
    * @ticket SFDT-678
    * @since  07/04/2016
    */
    public static void deactivateSubscriptionServicesForTermination(List<Opportunity> opps,
                                                                    Map<Id, Opportunity> oldMap)
    {
        //holds a set of Opp Ids for checking the baskets
        Set<Id> oppIds = new Set<Id>();

        /*
        * Decide which opportunities should be processed:
        * - opportunities that had a Stage changed to Ready for Order (or were inserted as Ready for Order)
        * - opportunities of a Change change type
        * - opportunities that have synced basket populated
        */
        for (Opportunity opp : opps)
        {
            Opportunity oldOpp = oldMap == null ? null : oldMap.get(opp.Id);

            if (opp.StageName == 'Ready for Order'
                && opp.csordtelcoa__Change_Type__c == 'Change'
                && (oldOpp == null || (oldOpp.StageName != opp.StageName)))
            {
                oppIds.add(opp.Id);
            }
        }

        if  (!oppIds.isEmpty())
        {
            Set<Id> subIdsFromJunction = new Set<Id>();
            Set<Id> replaceSubIdsFromBasket = new Set<Id>();

            //fetch the replaced subscription Ids from the configurations that are in the basket
            for(cscfga__Product_Configuration__c prodConf : [SELECT csordtelcoa__Replaced_Subscription__c
                                                            FROM cscfga__Product_Configuration__c
                                                            WHERE cscfga__Product_Basket__r.csordtelcoa__Synchronised_with_Opportunity__c = true
                                                            AND cscfga__Product_Basket__r.csordtelcoa__Change_Type__c = 'Change'
                                                            AND cscfga__Product_Basket__r.cscfga__Opportunity__c IN :oppIds and cscfga__Product_Family__c!='Termination'])
            {
                replaceSubIdsFromBasket.add(prodConf.csordtelcoa__Replaced_Subscription__c);
            }

            //fetch the subscription ids from the junction object - to have a full set of all old subscription ids that were involved in the
            //MACD process
            for(csordtelcoa__Subscription_MACDOpportunity_Association__c junction : [SELECT csordtelcoa__Subscription__c
                                                                                     FROM csordtelcoa__Subscription_MACDOpportunity_Association__c
                                                                                     WHERE csordtelcoa__Opportunity__c IN :oppIds])
            {
                subIdsFromJunction.add(junction.csordtelcoa__Subscription__c);
            }

            //populate a set of subscription ids that were deleted from the basket (old subscription ids will not be contained in the
            //replaced subscription ids set)
            Set<Id> subIdsForUpdate = new Set<Id>();
            for(Id subId : subIdsFromJunction)
            {
                if (!replaceSubIdsFromBasket.contains(subId))
                {
                    subIdsForUpdate.add(subId);
                }
            }

            if (!subIdsForUpdate.isEmpty())
            {
                List<csord__Service__c> services = [SELECT Id, csord__Status__c, csordtelcoa__Delta_Status__c,
                                                    csord__Subscription__r.csord__Status__c,
                                                    (SELECT Id, LG_IsPenaltyFee__c FROM csord__service_line_items__r)
                                                    FROM csord__Service__c
                                                    WHERE csord__Subscription__c IN :subIdsForUpdate];

                if (!services.isEmpty())
                {
                    List<csord__Service_Line_Item__c> slisForUpdate = new List<csord__Service_Line_Item__c>();
                    Set<csord__Subscription__c> subsForUpdate = new Set<csord__Subscription__c>();
                    for (csord__Service__c service : services)
                    {
                        //update Subscriptions status
                        service.csord__Subscription__r.csord__Status__c = LG_Util.getSubscriptionRequestDeactivateStatus();
                        subsForUpdate.add(service.csord__Subscription__r);

                        //update Services status and Deactivation date
                        service.csord__Status__c = LG_Util.getServiceRequestDeactivateStatus();
                        //SFOM-1711
                        service.csordtelcoa__Delta_Status__c = 'Deleted From Subscription';
                        /**
                         * Set delta status to deleted
                         *
                         * @author Petar Miletic
                         * @ticket OMB-1615
                         * @since  01/11/2017
                         */
                        for (csord__Service_Line_Item__c sli :service.csord__service_line_items__r) {
                            if (!sli.LG_IsPenaltyFee__c) {
                                sli.csordtelcoa__Delta_Status__c = 'Deleted';
                            }
                            slisForUpdate.add(sli);
                        }
                    }

                    update services;
                    if (!slisForUpdate.isEmpty()) {
                        update slisForUpdate;
                    }
                    update new List<csord__Subscription__c>(subsForUpdate);
                }
            }
        }
    }
    /*Comenting following code for INC INC000001518457 */
   /* public static void findAddressNotValidated(list<Opportunity> lstOpp, map<Id, Opportunity> mapOldOpportunity){
        map<id,cscfga__Product_Basket__c> mapProdBasket= new map<id, cscfga__Product_Basket__c>();
        map<Id,list<cscfga__Product_Configuration__c>> mapOppProdConfig=new map<Id,list<cscfga__Product_Configuration__c>>();
        List<cscfga__Product_Configuration__c> lstProdConfig = new List<cscfga__Product_Configuration__c>();
        set<Id> setIds=new set<Id>();
          //identify the opportunities which are moved to "Ready for order".
          for( Opportunity opp:lstOpp){
            if(mapOldOpportunity.get(opp.Id).StageName!=opp.StageName && opp.Stagename =='Ready for Order'){
                setIds.add(opp.Id);
            }
          }
          if(!setIds.isEmpty()){
            //collect all the product baskets on such opportunities which are synchronised with the opportunity.
            mapProdBasket=new map<id,cscfga__Product_Basket__c>([select id, cscfga__Opportunity__c , csordtelcoa__Synchronised_with_Opportunity__c from cscfga__Product_Basket__c where csordtelcoa__Synchronised_with_Opportunity__c=true AND cscfga__Opportunity__c IN: setIds]);

            if(!mapProdBasket.isEmpty()){
                //identify the product config records which have premises where address is not validated yet.
                lstProdConfig =[select Id,cscfga__Product_Basket__c, LG_Address__c, LG_Address__r.UM_AddressValidated__c, LG_Address__r.LG_FullAddressDetails__c from cscfga__Product_Configuration__c where LG_Address__r.UM_AddressValidated__c=false and cscfga__Product_Basket__c IN: mapProdBasket.values()];
            }
            //Collect the product configs against the opportunities which have not validated address on premise
            if(!lstProdConfig.isEmpty()){
                for(cscfga__Product_Configuration__c prodConfig:lstProdConfig){
                    if(!mapProdBasket.isEmpty() && mapProdBasket.containsKey(prodConfig.cscfga__Product_Basket__c)){
                        if(mapOppProdConfig.containsKey(mapProdBasket.get(prodConfig.cscfga__Product_Basket__c).cscfga__Opportunity__c)){
                            mapOppProdConfig.get(mapProdBasket.get(prodConfig.cscfga__Product_Basket__c).cscfga__Opportunity__c).add(prodConfig);
                        }
                        else if(mapProdBasket.isEmpty() || !mapOppProdConfig.containsKey(mapProdBasket.get(prodConfig.cscfga__Product_Basket__c).cscfga__Opportunity__c)){
                            mapOppProdConfig.put(mapProdBasket.get(prodConfig.cscfga__Product_Basket__c).cscfga__Opportunity__c, new list<cscfga__Product_Configuration__c>{prodConfig});
                        }
                    }
                }
            }
          }

          //throw an error for the opportunities with not validated premise of the products on the product baskets.
          for(Opportunity opp:lstOpp){
            if(!mapOppProdConfig.isEmpty() && mapOppProdConfig.containsKey(opp.Id) && !test.isRunningTest()){
                opp.addError(Label.UM_OpprtunityValidationError);
            }
          }

    }*//*Comenting following code for INC INC000001518457 */

    //added this method to remove 2 workflow rules LG_Update_Oppty_SalesChannel_with_User_SalesChannel and LG_OpportunityStageUpdated to fix UMR 948

    public static void replaceWFFieldUpdates(list<Opportunity> lstOpp, map<Id,Opportunity> mapOldOpp){
        list<Opportunity> filteredLstOpp=new list<Opportunity>();
        set<Id> setOppOwner=new set<Id>();
        map<Id,User> mapOwner=new map<Id, User>();
        //opp.LG_NEWSalesChannel__c
        for(Opportunity opp:lstOpp){
            if(mapOldOpp==null ||(mapOldOpp!=null  && opp.stageName!=mapOldOpp.get(opp.id).stageName)){
                filteredLstOpp.add(opp);
                setOppOwner.add(opp.OwnerId);
            }
        }
        if(!setOppOwner.isEmpty())
        mapOwner=new map<Id, User>([select Id, LG_SalesChannel__c from User where Id IN:setOppOwner]);

        if(!filteredLstOpp.isEmpty()){
            for(Opportunity opp:filteredLstOpp){
                if(!mapOwner.isEmpty() && mapOwner.containsKey(opp.OwnerId)){
                    opp.LG_NEWSalesChannel__c=mapOwner.get(opp.OwnerId).LG_SalesChannel__c;
                }
                if(mapOldOpp!=null && !mapOldOpp.isEmpty() && mapOldOpp.containsKey(opp.Id)){
                    opp.LG_PreviousStage__c=mapOldOpp.get(opp.Id).stageName;
                    opp.LG_LastStageChangeDate__c=system.today();
                }
            }
        }
    }

    //added as part of UMR-174
      //Added by trupti
    //Modified by tonib
    public static void upload(List<Opportunity> lstOpp)
    {
        try
        {
            Set<Id> oppIds = new Set<Id>();
            for (Opportunity o : lstOpp) {
                oppIds.add(o.Id);
            }
            List<Opportunity> lstSoHoOpps = [SELECT Id FROM Opportunity WHERE Id =:oppIds AND Account.LG_Segment__c = 'SoHo'];
            List<Document> docList = [select id, Body, Name, DeveloperName from document where Name =:LABEL.LG_LegalDocName limit 1];

            if(!docList.isEmpty())
            {
                for(Opportunity opp : lstSoHoOpps)
                {
                    attachment attachmentObj = new attachment();
                    attachmentObj.Body = docList[0].Body;
                    attachmentObj.ContentType = '.pdf';
                    attachmentObj.ParentId = opp.Id;
                    attachmentObj.Name = LABEL.LG_LegalDocName;
                    insert attachmentObj;
                }
            }
        }
        Catch(Exception e)
        {
            system.debug('Exception--> ' + e);
        }
    }

    public static void cancelReservationNumber(List<Opportunity> opps, Map<Id, Opportunity> oldMap)
    {
        list<asset> phoneNumberAssets = new list<asset>();
        //holds a set of Opp Ids for checking the baskets
        system.debug('cancelReservationNumber--oppty handler==');
        Set<Id> oppIds = new Set<Id>();
        map<id,string> oppPICReasonMap = new map<id,string>();
        for (Opportunity opp : opps){
            if (opp.StageName == 'Pre-Installation-Cancellation' && (oldMap.get(opp.Id).StageName != opp.StageName))
                oppIds.add(opp.Id);
            oppPICReasonMap.put(opp.id,opp.UM_PICReasons__c);
        }
        if(!oppIds.isEmpty()){
            list<csord__Service__c> cancelServices = [select id,LG_RootOrder__r.csordtelcoa__Opportunity__c, LG_RootOrder__c,LG_ServiceStatus__c from csord__Service__c
                                                where LG_ServiceStatus__c='Requested' and LG_RootOrder__r.csordtelcoa__Opportunity__c in :oppIds];
            for(csord__Service__c s : cancelServices){
                s.LG_ServiceStatus__c='Cancelled';
                s.UM_PICReason__c=oppPICReasonMap.get(s.LG_RootOrder__r.csordtelcoa__Opportunity__c);
            }

            update cancelServices;

            phoneNumberAssets = [select id,status from asset where LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c in :oppIds];

            for(Asset ph : phoneNumberAssets){
                ph.status = 'Cancelled';
            }

            update phoneNumberAssets;

            Id batchJobId = Database.executeBatch(new UM_CancelReservationNotification(oppIds), 10);
        }
       }
       
    public static void completeCancellationProcess(List<Opportunity> opps, Map<Id, Opportunity> oldMap){
        Set<Id> picOppIds = new Set<Id>();
        for (Opportunity opp : opps){
            if (opp.StageName == 'Pre-Installation-Cancellation' && (oldMap.get(opp.Id).StageName != opp.StageName)){
                picOppIds.add(opp.Id);
            }
        }
        if(!picOppIds.isEmpty()){
            List<CSPOFA__Orchestration_Step__c> orchProcessStepsToUpdate = new List<CSPOFA__Orchestration_Step__c>();
            Map<Id, CSPOFA__Orchestration_Process__c> orchProcessToUpdate = new Map<Id, CSPOFA__Orchestration_Process__c>();
            Map<Id, csord__Order__c> ordersToUpdate = new Map<Id, csord__Order__c>();
            Map<Id, csord__Solution__c> subOrdersToUpdate = new Map<Id, csord__Solution__c>();

            List<CSPOFA__Orchestration_Step__c> orchProcessSteps = 
            [
                SELECT Id, Name, CSPOFA__Status__c, CSPOFA__Orchestration_Process__r.CSPOFA__Orchestration_Process_Template__r.Name, 
                    CSPOFA__Orchestration_Process__c, CSPOFA__Orchestration_Process__r.LG_Solution__c, CSPOFA__Orchestration_Process__r.LG_Order__c
                FROM CSPOFA__Orchestration_Step__c
                WHERE CSPOFA__Orchestration_Process__r.LG_Order__r.csordtelcoa__Opportunity__c IN: picOppIds                    
            ];
            
            for(CSPOFA__Orchestration_Step__c orchstep : orchProcessSteps){
                System.debug('>>>>0000');
                if(orchstep.Name == 'Cancelled'){
                    System.debug('>>>>1111');
                    orchstep.CSPOFA__Status__c = 'In Progress';
                    orchProcessStepsToUpdate.add(orchstep);
                    System.debug('>>>>2222');
                } else if(orchstep.CSPOFA__Orchestration_Process__r.CSPOFA__Orchestration_Process_Template__r.Name == 'Orchestrate Order'){
                    System.debug('>>>>3333');
                    orchstep.CSPOFA__Status__c = 'Blocked';
                    orchProcessStepsToUpdate.add(orchstep);
                    System.debug('>>>>4444');
                    if(orchProcessToUpdate.get(orchstep.CSPOFA__Orchestration_Process__c) == null){
                        CSPOFA__Orchestration_Process__c op = new CSPOFA__Orchestration_Process__c();
                        op.Id = orchstep.CSPOFA__Orchestration_Process__c;
                        op.CSPOFA__Status__c = 'Complete';
                        orchProcessToUpdate.put(op.Id, op);
                    }                   
                }
                
                if(orchStep.CSPOFA__Orchestration_Process__r.LG_Order__c != null){
                    if(ordersToUpdate.get(orchStep.CSPOFA__Orchestration_Process__r.LG_Order__c) == null){
                        csord__Order__c order = new csord__Order__c();
                        order.Id = orchStep.CSPOFA__Orchestration_Process__r.LG_Order__c;
                        order.csord__Status2__c = 'Cancelled';
                        order.csord__Status__c = 'Cancelled';
                        ordersToUpdate.put(order.Id, order);
                    }
                    
                }
                
                if(orchStep.CSPOFA__Orchestration_Process__r.LG_Solution__c != null){
                    if(subOrdersToUpdate.get(orchStep.CSPOFA__Orchestration_Process__r.LG_Solution__c) == null){
                        csord__Solution__c subOrder = new csord__Solution__c();
                        subOrder.Id = orchStep.CSPOFA__Orchestration_Process__r.LG_Solution__c;
                        subOrder.csord__Status__c = 'Cancelled';
                        subOrdersToUpdate.put(subOrder.Id, subOrder);
                    }
                    
                }
            }
            
            List<Case> casesToUpdate = new List<Case>();
            List<Case> allCases = 
            [
                SELECT Id, Status 
                FROM Case 
                WHERE status != 'Closed' AND (LG_Solution__c IN: subOrdersToUpdate.keySet() OR LG_Order__c IN: ordersToUpdate.keySet()) 
            ];
            
            for(Case caseRec : allCases){
                caseRec.status = 'Cancelled';
                casesToUpdate.add(caseRec);
            }
            System.debug('>>>>stepsCount'+orchProcessStepsToUpdate.size());
            System.debug('>>>>processTemplates'+orchProcessToUpdate.values());
            System.debug('>>>>casesToUpdate'+casesToUpdate.size());
            System.debug('>>>>subOrders'+subOrdersToUpdate.values());
            System.debug('>>>>Orders'+ordersToUpdate.values());
            update orchProcessStepsToUpdate;
            update orchProcessToUpdate.values();    
            update casesToUpdate;        
            update subOrdersToUpdate.values();
            update ordersToUpdate.values();
            
            
        } 
        
    }
     

    /*public static void checkPartnerSalesId(List<Opportunity> opps, Map<Id, Opportunity> oldMap)
    {
        Set<Id> oppid= new Set<Id>();
        list<cscfga__Product_Basket__c> pblist = new list<cscfga__Product_Basket__c>();
        list<cscfga__Product_Configuration__c> pclist = new list<cscfga__Product_Configuration__c>();
        boolean flag= false;



        for(Opportunity opp : opps)
        {
            //Opportunity oldOpp = Trigger.oldMap.get(opp.Id);

            if(opp.StageName == 'Ready for Order'  && (oldMap.get(opp.Id).StageName != opp.StageName))
            {

                oppid.add(opp.id);
                flag= true;
            }
        }

        system.debug('$$$oppid'+oppid);
        if(!oppid.isEmpty())
        {
            pblist = [select id from cscfga__Product_Basket__c  where csordtelcoa__Synchronised_with_Opportunity__c= true and cscfga__Opportunity__c in :oppid];
        }
         system.debug('$$$pblist '+pblist );
        if(!pblist.isEmpty())
        {
            pclist =  [select id,LG_Address__c  from cscfga__Product_Configuration__c where cscfga__Product_Basket__c in :pblist];
        }
        system.debug('$$$pclist '+pclist );
        Set<String> lgac=new Set<String>();

        if(!pclist.isEmpty()){
            for(cscfga__Product_Configuration__c lp:pclist){
                lgac.add(lp.LG_Address__c);
            }
        }
        system.debug('$$$lgac'+lgac);

        list<cscrm__Address__c> statelist =  new list<cscrm__Address__c> ();
        if(!lgac.isEmpty())
        {
            statelist =new list<cscrm__Address__c>([Select cscrm__State_Province__c from cscrm__Address__c where Id in :lgac]);
        }
        system.debug('$$$statelist'+statelist);

        boolean nrwFlag;
        boolean bwFlag;
        set<string> stateSet = new set<string>();
        if(!statelist.isEmpty())
        {
            for(cscrm__Address__c lp:statelist){
                stateSet.add(lp.cscrm__State_Province__c);
            }
        }
        system.debug('$$$stateSet'+stateSet);
        if(!stateSet.isEmpty())
        {
            if(stateSet.contains('NRW') || stateSet.contains('HSN'))
            {
                nrwFlag= true;
            }
            if(stateSet.contains('BW'))
            {
                bwFlag= true;
            }
        }
        system.debug('$$$stateSet'+stateSet);
        set<opportunity> setToUpdate = new set<opportunity>();
        list<opportunity> listToUpdate = new list<opportunity>();
        list<opportunity> accList = new list<opportunity>();

        if(!oppid.isEmpty())
            acclist = [SELECT UM_PartnerAccount__r.UM_P_Sales_ID_BW__c, UM_PartnerAccount__r.UM_P_Sales_ID_NRW_HSN__c FROM Opportunity WHERE id in : oppid];
       system.debug('$$$acclist '+acclist );
        //system.debug('#####acclist '+acclist[0].UM_PartnerAccount__r.UM_P_Sales_ID_BW__c );
        //system.debug('#####acclist '+acclist[0].UM_PartnerAccount__r.UM_P_Sales_ID_NRW_HSN__c );

        //if(!oppid.isEmpty())
            //List<Opportunity> olist = [SELECT Id,Sales_Partner_ID_NRW_HSN__c,Sales_Partner_ID_BW__c  FROM Opportunity WHERE Id IN: Trigger.newMap.keySet()];


        opportunity[] oppor = new opportunity[]{};
        for(Opportunity opp : opps)
        {
            Opportunity aux  = new Opportunity (Id = opp.Id);
            if(nrwFlag== true )
            {
                if(!acclist.isEmpty())
                {
                aux.Sales_Partner_ID_NRW_HSN__c = accList[0].UM_PartnerAccount__r.UM_P_Sales_ID_NRW_HSN__c;
                setToUpdate.add(aux);
                }
            }
            if(bwFlag== true)
            {
                if(!acclist.isEmpty())
                {
                aux.Sales_Partner_ID_BW__c= accList[0].UM_PartnerAccount__r.UM_P_Sales_ID_BW__c;
                setToUpdate.add(aux);
                }
            }
        }
        system.debug('$$$acclist '+acclist );
        if(!setToUpdate.isEmpty())
        {
            system.debug('###setToUpdate '+setToUpdate);
            listToUpdate.addall(setToUpdate);
            system.debug('###listToUpdate '+listToUpdate);
        }

        if(!listToUpdate.isEmpty())
        {
            system.debug('###listToUpdate '+listToUpdate);

            update listToUpdate[0];

        }
        else if(listToUpdate.isEmpty() && flag== true)
        {
            for(Opportunity opp : opps)
            {
            opp.addError('Partner Sales ID und Lieferadresse sollten im gleichen Bundesland sein');
            }
        }
    }*/

    /**
     * Set versioning data if data is empty
     *
     * @param  List<Opportunity> opps
     * @author Petar Miletic
     * @ticket SFOM-430
     * @since  07/03/2017
    */
    public static void setVersioningData(List<Opportunity> opps) {

        for (Opportunity opp :opps) {

            // If the version data is not set then set it to 1
            // Older and newer version must be null in order to set initial versioning info
            if (opp.LG_Version__c == null && opp.LG_OlderVersion__c == null && opp.LG_NewerVersion__c == null) {

                opp.LG_Version__c = 1;
                opp.LG_ActiveVersion__c = true;
            }
        }
    }
        //SFOM-1843 - Removing the method for Cancel order validation
  //added as a workaround for OM journey for PIC stageName
        /*public static void restrictCancelOMOrders( Map<Id, Opportunity> newMap, Map<Id, Opportunity> oldMap){
            
     
            Set<Id> oppIds = new Set<Id>();
            for (Opportunity opp : newMap.values()){
                if (opp.StageName == 'Pre-Installation-Cancellation' && (oldMap.get(opp.Id).StageName != opp.StageName))
                    oppIds.add(opp.Id);
                system.debug('oppIds=='+oppIds);
            }
            
            List<csord__Solution__c> sol=[select id, csord__Order__r.csordtelcoa__Opportunity__c from csord__Solution__c where csord__Order__r.csordtelcoa__Opportunity__c in :oppIds];
            
            if(!sol.isEmpty()){
            
            Set<Id> oId=new Set<Id>();
            
            for( csord__Solution__c s : sol ) {
                  oId.add(s.csord__Order__r.csordtelcoa__Opportunity__c);
              }
    
            system.debug('oId=='+oId);

            for(Opportunity o: newMap.values()){
                if(oId.contains(o.Id)){
                    o.addError(Label.LG_RestrictCancelOrder);
                         }
                }
            }
      }*/  
}