/************************************************************************************************************************************
*        Class: LG_OutageCase
*     Program : B2B SELF CARE PROGRAM
*  Description: It will compare the account related service ids with the service ids which affected 
*               by the outage cases. In short, it will find out the cases effecting 
*               a particular account.
*    Author(s): Namrata Mehta (Infosys Limited)
* Created Date: 12-JAN-2018
*   Test Class: LG_OutageTestCase
*************************************************************************************************************************************/

@RestResource(urlMapping='/outage/*')      //URL mapping
global class LG_OutageCase {
    @httpGet                    //get method call
    global static void getCaseOutage(){
        
        Map<id,  Set<csord__Service__c>> caseIdMapServices;
        List<case>outageCases=new List<case>();
        List<Service_Impacted__c> serviceImpactedRecord=new  List<Service_Impacted__c>();
        List<Service_Impacted__c> serviceImpactedWithservice=new  List<Service_Impacted__c>();
        List<csord__Service__c> serviceList=new List<csord__Service__c>();
        List<csord__Service__c> servList=new List<csord__Service__c>();
        List<String> accServiceIds = new List<String>();
        Set<String> accServiceIdsSet = new Set<String>();
    Set<String> accServiceMacAddresses = new Set<String>();
        List<case>csList=new List<case>();
        set<id> serviceId=new set<id>();
        List<Case> outage;
        List<caseWrapper> outageCaseList;
        list<Account> accounList;
        Account acc;
        List<csord__Service__c> servicesList;
        list<string> requestId;
        csord__Service__c servicesid;
        string error;
        Map<String, csord__Service__c> serviceIdMapObj = new Map<String, csord__Service__c>();
        Set<String> accServiceExtIds = new Set<String>();
      Set<String> accSerCustomerNumbers = new Set<String>();


        
        List<Case> plannedMCases_on_Account;
        Map<Id,Set<csord__Service__c >> finalServiceMap = new Map<Id,Set<csord__Service__c >>();
        
        
        String jsonResponse ;
        //Id addressRecordtypeId=[Select id from RecordType where sObjectType = 'Service_Impacted__c' and developerName //='LG_B2B_Care_Address_and_Service_Type'].id;  //query record type of service impacted object
        //Id addressRecordtypeId=[Select id from RecordType where sObjectType = 'Service_Impacted__c' and developerName ='LG_Care_Topology_Data_from_SBC'].id;  //query record type of service impacted object [NM]
        
        RestRequest request = RestContext.request;
        RestResponse res = RestContext.response;
        RestContext.response.addHeader('Content-Type', 'application/json');
        
        
        try{
           
      //system.debug('caseIds are=='+caseIds);
            Set<String> impactedServiceIds = new Set<String>();
          Set<String> impactedEquipIds = new Set<String>();
          Set<String> impactedcustomers = new Set<string>();

            Map<Id, Set<String>> caseMapSerExtIds = new Map<id, Set<String>>();
          Map<Id, Set<String>> caseMapEquipIds = new Map<id, Set<String>>();
          Map<Id, Set<String>> caseMapCusNumbers = new Map<id, Set<String>>();
          caseIdMapServices = new Map<Id, Set<csord__Service__c>>();

            Map<String,Set<String>> mapCasesServiceId = new Map<String,Set<String>> ();
            Map<Id, Set<String>> servicesImpactedMap = new Map<Id, Set<String>>();
            Map<Id, Set<String>> servicesImpactedMapTemp = new Map<Id, Set<String>>();
            outageCases=[SELECT id,LG_Case_Reason__c,status,description,subject,type,CaseNumber,recordType.DeveloperName,recordType.Name,LG_Estimated_Start_Time__c,LG_Estimated_resolution_time__c FROM Case WHERE  Status not in ('Closed','Resolved') AND (recordtype.DeveloperName = 'LG_B2B_Care_Planned_Maintenance_Request_UM' OR recordType.developerName='LG_B2B_Care_Mass_Outage_Request_UM')];

      List<id> caseIds = new List<id>();
            for(Case c : outageCases) {
                caseIds.add(c.Id);
            }
            //system.debug('caseIds is ---- 67'+caseIds);

            string requestIdTemp = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
            //system.debug('requestIdTemp--'+requestIdTemp);
            String service_Id = request.params.get('serviceId');
            //system.debug('service_Id+++'+service_Id);
            
            if(requestIdTemp!='null' && service_Id==null){      //service id is null
                acc=[select LG_AccountNumber__c from account where  LG_AccountNumber__c=: requestIdTemp limit 1];
                for(csord__Service__c service : [SELECT  id, Name, LG_ServiceStatus__c , LG_ServiceExternalId__c,csordtelcoa__Service_Number__c,LG_ProvisioningAccountNo__c,LG_Address__r.cscrm__Zip_Postal_Code__c,LG_Address__r.cscrm__City__c,LG_Address__r.cscrm__Street__c ,csord__Subscription__c FROM csord__Service__c WHERE csord__Subscription__c in (SELECT id FROM csord__Subscription__c WHERE csord__Account__r.LG_AccountNumber__c = :acc.LG_AccountNumber__c) ] ) {
                    
                    if(service.LG_ServiceExternalId__c!=null && service.LG_ServiceStatus__c=='Active' ){
                        serviceIdMapObj.put(service.LG_ServiceExternalId__c, service);
                        accServiceIds.add(service.Id); 
                        accServiceExtIds.add(service.LG_ServiceExternalId__c);
                  accSerCustomerNumbers.add(service.LG_ProvisioningAccountNo__c);
            //system.debug('service.LG_ProvisioningAccountNo__c is++'+service.LG_ProvisioningAccountNo__c);
                        //system.debug('+++accServiceIds'+accServiceIds);
                    }
                }
            }

            if(service_id!=null && requestIdTemp!=null){      //service id is not null
            acc=[select LG_AccountNumber__c from account where  LG_AccountNumber__c=: requestIdTemp];
                for(csord__Service__c service : [SELECT id, Name, LG_ServiceStatus__c, LG_ProvisioningAccountNo__c, LG_ServiceExternalId__c,csordtelcoa__Service_Number__c,LG_Address__r.cscrm__Zip_Postal_Code__c,LG_Address__r.cscrm__City__c,LG_Address__r.cscrm__Street__c ,csord__Subscription__c FROM csord__Service__c WHERE id=:service_Id and csord__Subscription__c in (SELECT id FROM csord__Subscription__c WHERE csord__Account__r.LG_AccountNumber__c = :acc.LG_AccountNumber__c) ] ) {
                    
                    //system.debug('service---'+service);
                    if(service.LG_ServiceExternalId__c!=null &&service.LG_ServiceStatus__c=='Active' ){
                        serviceIdMapObj.put(service.LG_ServiceExternalId__c, service);
                        accServiceIds.add(service.Id);  
                        accServiceExtIds.add(service.LG_ServiceExternalId__c);
                  accSerCustomerNumbers.add(service.LG_ProvisioningAccountNo__c);
            //system.debug('service.LG_ProvisioningAccountNo__c is++--'+service.LG_ProvisioningAccountNo__c);
                        //system.debug('----accServiceIds'+accServiceIds);
                    }
                }
      }
 
            if(accServiceIds.size() > 0) {
                for(Asset a :[SELECT id,csord__Service__c,LG_MACAddress__c FROM Asset WHERE csord__Service__c IN :accServiceIds]) {
                    //serviceIdMapMacAddress.put(a.LG_MACAddress__c,a.csord__Service__c);
                    accServiceMacAddresses.add(a.LG_MACAddress__c);
                }
      }
      system.debug('line no 120'+accServiceMacAddresses);
      Boolean flag = false;
            //system.debug('serviceIdMapObj+++ line 122'+serviceIdMapObj);
      //system.debug('set value for === 130'+accSerCustomerNumbers);
      for(Service_Impacted__c li: [SELECT id,LG_Care_Customer_Number__c,LG_Care_Service_Record_Id__c,LG_B2B_Care_Equipment_id__c,B2B_Postcode__c,B2B_Case_Number__c,B2B_City__c,B2B_Service_Category__c,B2B_Service_Id__c,B2B_Street__c 
                                     FROM Service_Impacted__c
                                     WHERE B2B_Case_Number__c IN :caseIds]) {
      //system.debug('SI ==='+li);
                                         
            if(li.LG_Care_Service_Record_Id__c != null) {
                if(serviceIdMapObj.containsKey(li.LG_Care_Service_Record_Id__c)) {
                   if(caseIdMapServices.get(li.B2B_Case_Number__c) == null) {
                       caseIdMapServices.put(li.B2B_Case_Number__c, new Set<csord__Service__c> {serviceIdMapObj.get(li.LG_Care_Service_Record_Id__c)});
                   }
                    else {
                        Set<csord__Service__c> temp = caseIdMapServices.get(li.B2B_Case_Number__c);
                        temp.add(serviceIdMapObj.get(li.LG_Care_Service_Record_Id__c));
                        caseIdMapServices.put(li.B2B_Case_Number__c, temp);
                    }
                   system.debug('caseIdMapServices ==='+caseIdMapServices); 
                }
            }
            system.debug('caseIdMapServices++++ 142'+caseIdMapServices);
            if(flag == false && li.B2B_Service_Id__c != null) {
                if(accServiceExtIds.contains(li.B2B_Service_Id__c)) {
                    flag = true;
                    impactedServiceIds.add(li.B2B_Service_Id__c);
                    if(caseMapSerExtIds.get(li.B2B_Case_Number__c) == null) {
                        caseMapSerExtIds.put(li.B2B_Case_Number__c, new Set<String> {li.B2B_Service_Id__c});
                    }
                    else {
                        Set<String> temp = caseMapSerExtIds.get(li.B2B_Case_Number__c);
                        temp.add(li.B2B_Service_Id__c);
                        caseMapSerExtIds.put(li.B2B_Case_Number__c, temp);
                    }
                    //system.debug('caseMapSerExtIds ==='+caseMapSerExtIds); 

                }
            }
            if(flag == false && li.LG_B2B_Care_Equipment_id__c != null) {
                if(accServiceMacAddresses.contains(li.LG_B2B_Care_Equipment_id__c)) {
                    flag = true;
                    impactedEquipIds.add(li.LG_B2B_Care_Equipment_id__c);
                    if(caseMapEquipIds.get(li.B2B_Case_Number__c) == null) {
                        caseMapEquipIds.put(li.B2B_Case_Number__c, new Set<String> {li.LG_B2B_Care_Equipment_id__c});
                    }
                    else {
                        Set<String> temp = caseMapEquipIds.get(li.B2B_Case_Number__c);
                        temp.add(li.LG_B2B_Care_Equipment_id__c);
                        caseMapEquipIds.put(li.B2B_Case_Number__c, temp);
                    }
                    //system.debug('caseMapEquipIds ==='+caseMapEquipIds); 

                }
            }
            system.debug('set values== 174'+accSerCustomerNumbers);  
               system.debug('175---'+li.LG_Care_Customer_Number__c);
                                         system.debug('flag==176'+flag);
            if(flag == false && li.LG_Care_Customer_Number__c != null) {
                if(accSerCustomerNumbers.contains(li.LG_Care_Customer_Number__c)) {
                    flag = true;
                    impactedcustomers.add(li.LG_Care_Customer_Number__c);
                    if(caseMapCusNumbers.get(li.B2B_Case_Number__c) == null) {
                        caseMapCusNumbers.put(li.B2B_Case_Number__c, new Set<String> {li.LG_Care_Customer_Number__c});
                    }
                    else {
                        Set<String> temp = caseMapCusNumbers.get(li.B2B_Case_Number__c);
                        temp.add(li.LG_Care_Customer_Number__c);
                        caseMapCusNumbers.put(li.B2B_Case_Number__c, temp);
                    }
                    //system.debug('caseMapCusNumbers ==='+caseMapCusNumbers); 
                }
            }
    }

      system.debug('caseIdMapServices++++ 195'+caseIdMapServices);
      for(String serId :serviceIdMapObj.keySet()) {
            for(Id caseId :caseMapSerExtIds.keySet()) {
                
                if(caseMapSerExtIds.get(caseId).contains(serviceIdMapObj.get(serId).LG_ServiceExternalId__c)) {
                    system.debug('if true==');
                    if(caseIdMapServices.get(caseId) == null) {
                        caseIdMapServices.put(caseId, new Set<csord__Service__c>{serviceIdMapObj.get(serId)});
                    }
                    else {
                        Set<csord__Service__c> temp = caseIdMapServices.get(caseId);
                        temp.add(serviceIdMapObj.get(serId));
                        caseIdMapServices.put(caseId, temp);
                    }
                    system.debug('caseIdMapServices---'+caseIdMapServices);
                }
            }
        }
        system.debug('caseIdMapServices++++ 213'+caseIdMapServices);
        for(String serId :serviceIdMapObj.keySet()) {
            system.debug('1 st for 215');
            for(Id caseId :caseMapCusNumbers.keySet()) {
                system.debug('2 nd for 217');
                //system.debug('LG_ProvisioningAccountNo__c value++'+serviceIdMapObj.get(serId).LG_ProvisioningAccountNo__c);
                if(caseMapCusNumbers.get(caseId).contains(serviceIdMapObj.get(serId).LG_ProvisioningAccountNo__c)) {
                    if(caseIdMapServices.get(caseId) == null) {
                        caseIdMapServices.put(caseId, new Set<csord__Service__c>{serviceIdMapObj.get(serId)});
                    }
                    else {
                        Set<csord__Service__c> temp = caseIdMapServices.get(caseId);
                        temp.add(serviceIdMapObj.get(serId));
                        caseIdMapServices.put(caseId, temp);
                    }
                    system.debug('caseIdMapServices++++'+caseIdMapServices);
                }
            }
        }
        system.debug('caseIdMapServices++++ 232'+caseIdMapServices);
        Map<id,  Set<Id>> caseIdMapSerId = new Map<Id, Set<Id>>();
        for(Asset ass :[SELECT Id, csord__Service__c, LG_MACAddress__c  FROM Asset WHERE LG_MACAddress__c IN :impactedEquipIds] )
        {
            for(Id caseId :caseMapEquipIds.keySet()) {
                if(caseMapEquipIds.get(caseId).contains(ass.LG_MACAddress__c)) {
                    if(caseIdMapSerId.get(caseId) == null) {
                        caseIdMapSerId.put(caseId, new Set<Id>{ass.csord__Service__c} );
                    }
                    else {
                        Set<Id> temp = caseIdMapSerId.get(caseId);
                        temp.add(ass.csord__Service__c);
                        caseIdMapSerId.put(caseId,temp);
                    }
                    //system.debug('caseIdMapSerId++++'+caseIdMapSerId);
                }
            }
        }
        
      /*  for(Id caseId :caseIdMapSerId.keySet()) {
            for(Id serId :caseIdMapSerId.get(caseId)) {
                if(caseIdMapServices.get(caseId) == null) {
                    caseIdMapServices.put(caseId, new Set<csord__Service__c> {serviceIdMapObj.get(serId)} );
                    system.debug('null value 255'+caseIdMapServices.get(caseId));
                }
                else {
                    Set<csord__Service__c> temp = caseIdMapServices.get(caseId);
                    system.debug('caseId value --259'+caseIdMapServices.get(caseId));
                    temp.add(serviceIdMapObj.get(serId));
                    caseIdMapServices.put(caseId, temp);
                    system.debug('null value 261'+caseIdMapServices.get(caseId));
                }
                system.debug('caseIdMapServices final'+caseIdMapServices);
            }
        }
        system.debug('caseIdMapServices 264'+caseIdMapServices);
        for(Id caseId :caseIdMapServices.keySet()) {
            for(csord__Service__c ser :caseIdMapServices.get(caseId)) {

            }
        }*/

            
            Set<String> plannedMaintenanceServiceIds = new Set<String>();

            
            plannedMCases_on_Account = new List<Case> ();
            outage = new List<Case>();
            outageCaseList = new List<caseWrapper>();
            //system.debug('outageCases are---'+outageCases);
            for (Case c : outageCases) {
                if(caseIdMapServices.containsKey(c.Id) && c.recordtype.DeveloperName == 'LG_B2B_Care_Planned_Maintenance_Request_UM') {
                plannedMCases_on_Account.add(c);
                //system.debug('plannedMCases_on_Account value---'+plannedMCases_on_Account);
              }
              else if(caseIdMapServices.containsKey(c.Id) && c.recordtype.DeveloperName == 'LG_B2B_Care_Mass_Outage_Request_UM') {
                caseWrapper caseWrapp = new caseWrapper();
                caseWrapp.caseObj = c;
                caseWrapp.servList = new List<csord__Service__c>();
                caseWrapp.servList.addAll(caseIdMapServices.get(c.Id));
                outageCaseList.add(caseWrapp);
                } 
            }
      system.debug('outageCaseList++ 288'+outageCaseList);
            if(outageCaseList.size()>0){
            jsonResponse = Json.serialize(outageCaseList);
            res.responseBody = blob.valueOf(jsonResponse);
            return;
            }
            else{
                 res.statusCode=400;
                 error='No Outage Found';
                jsonResponse = Json.serialize(error);
                res.responseBody = blob.valueOf(jsonResponse);
                return;
                
            }
                
        }catch(exception e){
            system.debug('exception is++'+e);
            system.debug('e.getmessage'+e+'e=='+e.getLineNumber());
            res.statusCode=400;
          
            e.setMessage('Invalid Customer Number or service Id');
            
            jsonResponse = Json.serialize(e.getMessage());
                res.responseBody = blob.valueOf(jsonResponse);
                return;
            
        }
    }
    
    public class addressRelatedCasesMapping {
        public List<csord__Service__c> addressRelatedServiceIds;
        public String caseId;
    } 
    public class caseWrapper{
        public case caseObj{get;set;}
        public List<csord__Service__c> servList {get;set;}
    }
    
}