/**
* Case trigger 
* 
* @author Petar Miletic
* @ticket SFOM-317
* @since 30/01/2017
*/
public class LG_CaseTriggerHandler {
    
    
    // CCB2BPE-378: Start : Method to map a new contact with an account for assisted care track
    public static void MapNewContacttoAccount(List<Case> casesNew) {
    
         Map<Id,String> rt_map = new Map<Id,String>();
            for(RecordType rt : [SELECT Id, DeveloperName FROM RecordType]){
                rt_map.put(rt.Id,rt.DeveloperName);
            }
             List<Contact> updatecon = new List<Contact>();
            //System.debug('##$rtmap : '+rt_map);
            for(Case c: casesNew){
                //system.debug('c.ContactId'+c.ContactId);
                //system.debug('##$rt dev name : '+rt_map.get(c.recordTypeID));
                if(rt_map.get(c.recordTypeID) == 'LG_B2B_Care_Admin_Change_Request_UM' || 
                rt_map.get(c.recordTypeID) == 'B2B_Care_Billing_Query_Request_UM' ||
                rt_map.get(c.recordTypeID) == 'LG_B2B_Care_Complaint_Request_UM' ||
                rt_map.get(c.recordTypeID) == 'LG_B2B_Care_General_Query_Request_UM' ||
                rt_map.get(c.recordTypeID) == 'LG_B2B_Care_Online_Billing_Request_UM' ||
                rt_map.get(c.recordTypeID) == 'LG_B2B_Care_SLA_Breach_Request_UM' ||
                rt_map.get(c.recordTypeID) == 'LG_B2B_Care_Service_Change_Request_UM' ||
                rt_map.get(c.recordTypeID) == 'LG_B2B_Care_Technical_Request_UM'){
                                            
                    for (Contact con: [Select Id, Salutation,AccountId from Contact where id= :c.ContactId]){    
                        
                    if( c.ContactId != null && con.AccountId == null ){
                        //System.debug('##$Contact is created');
                                                
                        con.AccountId = c.AccountId;
                        con.Salutation = 'Mr.';
                        updatecon.add(con);
                        
                        }
                        
                    }
                }
            }
            if(updatecon != null && !updatecon .isEmpty())       
                       Database.Update(updatecon);
    
    }
        // CCB2BPE-378: End
    
    
    /*
* Case trigger, Constrain selection of Case Reason based on Case Record Type
*
* On insert
*
* @author Petar Miletic
* @ticket SFOM-317
* @since 30/01/2017
*/
    public static void updateSolutionJeopardyReason(List<Case> casesNew) {
        
        Map<Id, String> solutionMap = new Map<Id, String>();
        
        Set<String> allowed = new Set<String> { 'Install', 'Provision', 'Number Port', 'Activate Service', 'Access Planning', 'Provision One Step'};
            
            // Detect Changes
            for (Case obj :casesNew) {
                
                // Skip if Record Type is not on allowed list
                if (!allowed.contains(obj.RecordType.Name)) {
                    continue;
                }
                
                if (obj.LG_Solution__c != null && obj.Reason != null) {
                    solutionMap.put(obj.LG_Solution__c, obj.Reason);
                }
            }
        
        resolveJeoperdyReason(solutionMap);
    }
    
    /*
* Case trigger, Constrain selection of Case Reason based on Case Record Type
* 
* On update
*
* @author Petar Miletic
* @ticket SFOM-317
* @since 30/01/2017
*/
    public static void updateSolutionJeopardyReason(List<Case> casesNew, Map<Id, Case> casesOld) {
        
        Map<Id, String> solutionMap = new Map<Id, String>();
        
        // Detect Changes
        for (Case obj :casesNew) {
            
            Case oldCase = casesOld.get(obj.Id);
            
            if (obj.LG_Solution__c != null && obj.Reason != null && obj.Reason != oldCase.Reason) {
                
                solutionMap.put(obj.LG_Solution__c, obj.Reason);
            }
        }
        
        resolveJeoperdyReason(solutionMap);
    }
    
    /*
* Case trigger, Constrain selection of Case Reason based on Case Record Type
* 
* Update Solution Jeopardy
*
* @author Petar Miletic
* @ticket SFOM-317
* @since 30/01/2017
*/
    private static void resolveJeoperdyReason(Map<Id, String> solutionMap) {
        
        // If changes exist query Solutin data and update
        if (!solutionMap.isEmpty()) {
            
            // Query only those Solution that require update
            List<csord__Solution__c> solutions = [SELECT Id, Jeopardy_Reason__c FROM csord__Solution__c WHERE Id IN :solutionMap.keySet()];
            
            for (csord__Solution__c obj :solutions) {
                
                obj.Jeopardy_Reason__c = solutionMap.get(obj.Id);
            }
            
            // Update Solutions
            update solutions;
        }
    }
    
    /*
* Case trigger, Constrain selection of Case Reason based on Case Record Type
* 
* Case close Validation
*
* @author Godson
* @ticket SFOM-356
* @since 17/02/2017
*/
    public static void validateCaseStatus(List<Case> casesNew) {
        //SFOM-1822 - Removing Activate Service Case service validation Temporarily (, 'Activate Service')
        Set<String> allowed = new Set<String> {'Install', 'Provision'};
        Set<String> caseReasonAllowed = new Set<String> { 'Install', 'Provision', 'Activate Service','Number Port','Access Planning'};
        Set<String> serviceDateValidate = new Set<String> { 'Provision One Step','Activate Service'};
        Set<String> manageLogisticsValidate = new Set<String> { 'Manage Logistics'};
        Set<String> manageTenantValidate = new Set<String> {'Manage Tenant'};
        Map<Id,List<csord__Service__c>> serviceListMap;
        Map<Id,List<csord__Solution__c>> solutionListMap;
        List<String> solutionIdList = new List<String>();
        //Get solution ids from the case
        for(Case caseDetail:casesNew){
            if(caseDetail.LG_Solution__c != null){
                solutionIdList.add(caseDetail.LG_Solution__c);
            }
        }
        //Get serviceRecords related to the 
        serviceListMap = getServiceRecords(casesNew, solutionIdList);
        solutionListMap = getSolutionRecords(casesNew, solutionIdList);
        for (Case caseRecord :casesNew) {
            Map<ID,Schema.RecordTypeInfo> recordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosById();
            String recordTypeName = recordTypeMap.get(caseRecord.RecordTypeId).getName();
            
            //SFOM-1822
            if (caseRecord.Status == 'Closed' && manageLogisticsValidate.contains(recordTypeName)) {
                validateLogisticsService(caseRecord, solutionListMap, serviceListMap);
            }
            
            //SFOM-2202/SFOM-1820
            if (caseRecord.Status == 'Closed' && manageTenantValidate.contains(recordTypeName)) {
                validateManageTenant(caseRecord, solutionListMap);
            }
            
            //SFOM-1748
            //Service Activation / Deactivation date validate
            if (caseRecord.Status == 'Closed' && serviceDateValidate.contains(recordTypeName)) {
                validateServiceDates(caseRecord, serviceListMap, recordTypeName);
            }
            
            // Skip if Record Type is not on allowed list
            if (!caseReasonAllowed.contains(recordTypeName)) {
                continue;
            }
            if(caseRecord.Status == 'Closed'){
                validateSolutionRecords(caseRecord, solutionListMap, recordTypeName);
            }
            
            // Skip if Record Type is not on allowed list
            if (!allowed.contains(recordTypeName)) {
                continue;
            }
            
            if(caseRecord.Status == 'Closed'){
                //Modified for the bug SFOM-578 - passing Solition list
                validateServiceRecords(caseRecord, solutionListMap, serviceListMap, recordTypeName);
            }
        }
    }
    
    /**
     * Method to fetch solution record
     * SFOM-505
     **/
    @TestVisible
    private static Map<Id,List<csord__Solution__c>> getSolutionRecords(List<Case> caseRecords, List<String> solutionIdList) {
        Map<Id,List<csord__Solution__c>> solutionListMap = new Map<Id,List<csord__Solution__c>>();
        List<csord__Solution__c> solutionListDetails;
        
        solutionListDetails = 
        [
            SELECT Id, Name, LG_Jeopardy__c, UM_DeliveryCompletionDate__c, csord__Account__r.LG_Huawei_Tenant_ID__c, 
            LG_Address__r.LG_TechnicalContact__r.LG_UserName__c, LG_Address__r.LG_TechnicalContact__r.LG_Password__c
            FROM csord__Solution__c 
            WHERE Id IN :solutionIdList
        ];
        
        for(Case caseListDetail:caseRecords){
            for(csord__Solution__c solutionDetails:solutionListDetails){
                if(caseListDetail.LG_Solution__c == solutionDetails.Id){
                    if(solutionListMap.containsKey(caseListDetail.Id)){
                        List<csord__Solution__c> solutionList = solutionListMap.get(caseListDetail.Id);
                        solutionList.add(solutionDetails);
                        solutionListMap.put(caseListDetail.Id, solutionList);
                    }else{
                        solutionListMap.put(caseListDetail.Id, new List<csord__Solution__c>{solutionDetails});
                    }
                }
            }
        }
        return solutionListMap;
    }
    
    @TestVisible
    private static Map<Id,List<csord__Service__c>> getServiceRecords(List<Case> caseRecords, List<String> solutionIdList) {
        Map<Id,List<csord__Service__c>> serviceListMap = new Map<Id,List<csord__Service__c>>();
        List<csord__Service__c> serviceListDetails;
        
        serviceListDetails = [SELECT Id, Name, 
                              csord__Status__c,
                              LG_Provision_Valid__c,
                              LG_Install_Valid__c,
                              LG_Activate_Valid__c, 
                              LG_Suborder__c,
                              csord__Activation_Date__c, //SFOM-1748
                              csord__Deactivation_Date__c,
                              LG_Action__c,
                              csord__Service__c,
                              UM_LogisticsReference__c, //SFOM-1822
                              UM_ESN__c,
                              UM_ProvisioningServiceExternalId__c,
                              LG_ProductFamily__c,
                              LG_DecompositionCriteria__c,
                              UM_DependsOnService__c,
                              LG_DependsOnSecondaryService__c,
							  UM_Cancellation__c							  
                              FROM csord__Service__c
                              WHERE LG_Suborder__c IN :solutionIdList];
       //Changes for DGT-381 Starts
        for(Case caseListDetail:caseRecords)
        {
           for(csord__Service__c serviceDetails:serviceListDetails)
           {
           system.debug('service is:'+serviceDetails);
           system.debug('case record type' + caseListDetail.Type);
                  //Changes For BHP-306 Starts
                    if (caseListDetail.LG_Solution__c == serviceDetails.LG_Suborder__c) 
                    {
                        if(serviceListMap.containsKey(caseListDetail.Id))
                        {
                            List<csord__Service__c> serviceList = serviceListMap.get(caseListDetail.Id);
                            serviceList.add(serviceDetails);
                            serviceListMap.put(caseListDetail.Id, serviceList);
                            
                        }
                        
                        else
                        {
                            serviceListMap.put(caseListDetail.Id, new List<csord__Service__c>{serviceDetails});
                        }
                    }
                         //Changes For BHP-306 Ends
                for(Integer j = 0; j < serviceListMap.values().size(); j++)
                {
                    if(caseListDetail.RecordType.Name=='Provision' && serviceDetails.UM_DependsOnService__c==null && serviceDetails.LG_DependsOnSecondaryService__c!=null){
                     serviceListMap.put(caseListDetail.Id, new List<csord__Service__c>{serviceListMap.get(caseListDetail.Id).remove(j)});
                    }
                }
            }
        }
        //Changes for DGT-381 Ends
        system.debug('Service List Map'+serviceListMap);
        return serviceListMap;
    }
    
    /**
     * To validate the solution is marked as Jeopardy
     * SFOM-505
     **/
    @TestVisible
    private static void validateSolutionRecords(Case caseRecord, Map<Id,List<csord__Solution__c>> solutionListMap, String recordName) {
        List<String> allowedList = new List<String> { 'Install', 'Provision', 'Activate Service','Number Port','Access Planning'};
        List<csord__Solution__c> solutionList;
        
        if (caseRecord.LG_Solution__c != null) {
            solutionList = solutionListMap.get(caseRecord.Id);
        } else {
            solutionList = new List<csord__Solution__c>();
        }
        
        //SFOM-505 Validate Case Reason, If solution is marked as Jeopardy
        for(String record:allowedList){
            if(record == recordName && (caseRecord.Reason == null || caseRecord.Reason == '' || caseRecord.Reason == 'N/A') && solutionList[0].LG_Jeopardy__c == true){
                caseRecord.Reason.addError('Case Reason is mandatory.');
                break;
            }
        }
        
    }
    
    @TestVisible
    private static void validateServiceRecords(Case caseRecord, Map<Id,List<csord__Solution__c>> solutionListMap, Map<Id,List<csord__Service__c>> serviceListMap, String recordName) {
        LG_ConsoleSectionUtil utils = new LG_ConsoleSectionUtil();
        List<String> allowedList = new List<String> { 'Install', 'Provision', 'Activate Service'};
            List<csord__Service__c> serviceList;
        List<csord__Solution__c> solutionList;
        
        
        if (caseRecord.LG_Solution__c != null) {
            serviceList = serviceListMap.get(caseRecord.Id);
            solutionList = solutionListMap.get(caseRecord.Id);
        } else {
            serviceList = new List<csord__Service__c>();
            solutionList = new List<csord__Solution__c>();
        }
        
        For(csord__Service__c serviceRecord: serviceList){
            System.debug('testttttt--->'+solutionList[0].LG_Jeopardy__c);
            //Case record type 'Install'
            if(recordName == allowedList.get(0)){
            if(caseRecord.Type != 'Cancel')  //sfom 537  when type is cancel close case should not have any validations.
            {
                //SFOM-578 - To check the service failure
                if(utils.checkServiceFailed(serviceRecord.csord__Status__c, recordName)){
                    //Throw error if it is not marked as jeopardy
                    if(!solutionList[0].LG_Jeopardy__c){
                        caseRecord.addError('One of the Service is in failed status. Please mark it as Jeopardy.');
                    }
                }else{
                    if(serviceRecord.LG_Install_Valid__c != 'Yes'){
                        caseRecord.addError('Please enter Screen Flow for all services with a red traffic light and populate additional enrichment details');
                        continue;
                    }
                }
                
             }   
                
            }
            
            //Case record type 'Provision'
            if(recordName == allowedList.get(1)){
               if(caseRecord.Type != 'Cancel') //sfom 537  when type is cancel close case should not have any validations.
                {
                    //Blocking as a part of DGT-214 (SFOM-1822)
                    //SFOM-578 - To check the service failure
                /*if(utils.checkServiceFailed(serviceRecord.csord__Status__c, recordName)){
                    //Throw error if it is not marked as jeopardy
                    if(!solutionList[0].LG_Jeopardy__c){
                        caseRecord.addError('One of the Service is in failed status. Please mark it as Jeopardy.');
                    }
                }else{
                    if(serviceRecord.LG_Provision_Valid__c != 'Yes'){
                        caseRecord.addError('Please enter Screen Flow for all services with a red traffic light and populate additional enrichment details');
                        continue;
                    }
                }*/
                if(serviceRecord.UM_ProvisioningServiceExternalId__c == null || serviceRecord.UM_ProvisioningServiceExternalId__c == ''){
                    caseRecord.addError('Case cannot be closed without a valid Provisioning Service External Id value.');
                    continue;
                }
            }
            }
            
            //Case record type 'Activate Service'
            if(recordName == allowedList.get(2)){
            if(caseRecord.Type != 'Cancel')  //sfom 537  when type is cancel close case should not have any validations.
            {
                //SFOM-578 - To check the service failure
                if(utils.checkServiceFailed(serviceRecord.csord__Status__c, recordName)){
                    //Throw error if it is not marked as jeopardy
                    if(!solutionList[0].LG_Jeopardy__c){
                        caseRecord.addError('One of the Service is in failed status. Please mark it as Jeopardy.');
                    }
                }else{
                    if(serviceRecord.LG_Activate_Valid__c != 'Yes'){
                        caseRecord.addError('Please enter Screen Flow for all services with a red traffic light and populate additional enrichment details');
                        continue;
                    }
                }
            }
            }
            
            //Validating service status
            //Blocked as a part of OMB-1574
            /*if(!utils.validateServiceStatus(serviceRecord.csord__Status__c, recordName)){
                caseRecord.addError('Please select a valid status for the Service.');
                continue;
                }*/
            }
                
                    
    }
    
    //SFOM-1748
    @TestVisible
    private static void validateServiceDates(Case caseRecord, Map<Id,List<csord__Service__c>> serviceListMap, String recordName) {
        List<csord__Service__c> serviceList;
        
        Boolean noDateOnChild= false;
        
        if (caseRecord.LG_Solution__c != null) {
            serviceList = serviceListMap.get(caseRecord.Id);
        } else {
            serviceList = new List<csord__Service__c>();
        }
		
		// added by RC for BHP-8 and 11
		
        if (caseRecord.Type == 'Hpbx-Provision Kundensetup' || caseRecord.Type == 'Hpbx-Provision Entry Services' || caseRecord.Type == 'Hpbx-Manage phone numbers' || caseRecord.Type == 'Hpbx- daily cancellable' || caseRecord.Type=='HPBX-Remove from Sipwise' || caseRecord.Type == 'Hpbx- Monthly cancellable') {
          
            serviceList = filterHpbxServices(serviceList,caseRecord.Type);
        }
        
        System.debug('TESTERR='+serviceList);
        if (caseRecord.Type == 'Primary' || caseRecord.Type == 'Secondary'|| caseRecord.Type == 'Logistics') {
            serviceList = filterBdsServices(serviceList,caseRecord.Type);
        }
        for(csord__Service__c serviceRecord: serviceList){
            //SFOM-1748
            if(serviceRecord.LG_Action__c == 'Delete' && serviceRecord.csord__Deactivation_Date__c == null){
                caseRecord.addError('Case cannot be closed until Activation/Deactivation dates are entered.');
                continue;
            }else if(serviceRecord.LG_Action__c != 'Delete' && serviceRecord.csord__Activation_Date__c == null){
                caseRecord.addError('Case cannot be closed until Activation/Deactivation dates are entered.');
                continue;
            }
            
            //added to fix oMB-2994 starts
            if(serviceRecord.LG_DecompositionCriteria__c == 'Set 7 - JIRA Fiber' && serviceRecord.csord__Activation_Date__c != null && serviceRecord.LG_Action__c == 'Delete'){
                
                 for(csord__Service__c childService: [select id,csord__Deactivation_Date__c from csord__Service__c where csord__Service__c =: serviceRecord.id] )
                     {
                     if(childService.csord__Deactivation_Date__c==null)
                     {
                     noDateOnChild= true;
                     }
                     }
                     if(noDateOnChild){
                      caseRecord.addError('Parent Case Cannot be closed before child Service Case.');
                      continue;
                     }
            }
            
         }
        
        //added to fix oMB-2994 ends

    }
    //added by RC to filter the HPBX services on case closure based on case type
    private static List<csord__Service__c> filterHpbxServices(List<csord__Service__c> services, String caseType) {
        List<csord__Service__c> filteredServices = new List<csord__Service__c>();
        for (csord__Service__c service: services) {
            if (caseType == 'Hpbx-Provision Kundensetup' && service.LG_DecompositionCriteria__c == 'Set 10 - SIPWISE') {
                filteredServices.add(service);
            } else if (caseType == 'Hpbx-Provision Entry Services' && service.LG_DecompositionCriteria__c == 'Set 10 - SIPWISE Entry Services') {
                filteredServices.add(service);
            }else if (caseType == 'Hpbx-Manage phone numbers' && service.LG_DecompositionCriteria__c == 'Set 10 - INFPORT') {
                filteredServices.add(service);
            }
            //sfom-2567 BHP-11
             else if (caseType == 'Hpbx- daily cancellable' && service.UM_Cancellation__c == 'Daily') {
                filteredServices.add(service);
            }else if (caseType == 'Hpbx- Monthly cancellable' && service.UM_Cancellation__c == 'Monthly') {
                filteredServices.add(service);
            } else if (caseType == 'HPBX-Remove from Sipwise' && service.UM_Cancellation__c == null) {
                filteredServices.add(service);
            }
        }
        return filteredServices;
    }
    
    //added by RC to filter the BDS services on case closure based on case type    
    private static List<csord__Service__c> filterBdsServices(List<csord__Service__c> services, String caseType) {
        List<csord__Service__c> filteredServices = new List<csord__Service__c>();
        for (csord__Service__c service: services) {
            if (caseType == 'Primary' &&  (service.UM_DependsOnService__c!=null  || (service.LG_DependsOnSecondaryService__c==null && service.UM_DependsOnService__c==null))) {
                filteredServices.add(service);
            } else if (caseType == 'Secondary' && (service.UM_DependsOnService__c==null  &&  service.LG_DependsOnSecondaryService__c!=null)) {
                filteredServices.add(service);
            } else if (caseType == 'Logistics' && service.csord__service__c ==null) {
                filteredServices.add(service);
            }
        }
        return filteredServices;
    }
    
    /**
    *@author -  Anthony Arockiam
    *@ticket - SFOM-2202
    *@date - 20/11/2017
    */
    @TestVisible
    private static void validateManageTenant(Case caseRecord, Map<Id,List<csord__Solution__c>> solutionListMap){
        System.debug('>>>>CaseRecord000'+caseRecord.LG_Order__c);
        Account tenantAccount = new Account();
        Contact tenantContact = new Contact();
        csord__Order__c orderRecord = retriveOrderRecord(caseRecord.LG_Order__c);
        csord__Solution__c caseSolution = new csord__Solution__c();
        if(orderRecord != null){
            if(orderRecord.csord__Account__c != null){
                tenantAccount = 
                [
                    SELECT Id, LG_Huawei_Tenant_ID__c
                    FROM Account 
                    WHERE Id =: orderRecord.csord__Account__c
                ];
            }
            if(orderRecord.csordtelcoa__Opportunity__r.LG_PrimaryContact__c != null){
                tenantContact = 
                [
                    SELECT Id, LG_UserName__c, LG_Password__c, Name
                    FROM Contact 
                    WHERE Id =: orderRecord.csordtelcoa__Opportunity__r.LG_PrimaryContact__c
                ];
            }
            if(tenantAccount.LG_Huawei_Tenant_ID__c == null 
            || tenantContact.LG_UserName__c == null
            || tenantContact.LG_Password__c == null){
                caseRecord.addError('Please fill Tenant Id, Username and Password to close the Manage Tenant case');
            }
        }
        
    }
    
    private static csord__Order__c retriveOrderRecord(String ordId){
        csord__Order__c order = new csord__Order__c();
        if(ordId != null){
            order = 
            [
                SELECT Id, Name, Ownerid, csord__Status__c, csord__Account__c, csord__Account__r.Name, csordtelcoa__Opportunity__r.LG_PrimaryContact__c
                FROM csord__Order__c 
                WHERE Id = :ordId
            ];
        }
        return order;
    }
    /**
    *@author -  Godson
    *@ticket - SFOM-1822
    *@date - 08/11/2017
    */
    @TestVisible
    private static void validateLogisticsService(Case caseRecord, Map<Id,List<csord__Solution__c>> solutionListMap, Map<Id,List<csord__Service__c>> serviceListMap) {
        List<csord__Service__c> serviceList;
        List<csord__Solution__c> solutionList;
        
        
        if (caseRecord.LG_Solution__c != null) {
            serviceList = serviceListMap.get(caseRecord.Id);
            solutionList = solutionListMap.get(caseRecord.Id);
        } else {
            serviceList = new List<csord__Service__c>();
            solutionList = new List<csord__Solution__c>();
        }
        
         // DGT -520 fix
         if (!serviceList.isEmpty()) {
         	serviceList = filterBdsServices(serviceList,caseRecord.Type);
         }
        
        if(solutionList[0].UM_DeliveryCompletionDate__c == null){
            caseRecord.addError('Case cannot be closed until Delivery Completion Date is entered.');
        }
        //Changes For sfom-2597 Starts- To save details on asset 
        List<Asset> assetValues = [SELECT Id,csord__Service__c,LG_Logistics_Reference_Number__c,LG_Logistics_Supplier_Name__c,LG_MACAddress__c  FROM Asset WHERE csord__Service__c IN :serviceList LIMIT 1];
        if(!assetValues.isEmpty()){
        for(Asset a:assetValues){
            if(a.LG_Logistics_Reference_Number__c==null || a.LG_Logistics_Supplier_Name__c==null ||a.LG_MACAddress__c==null){
                caseRecord.addError('Please enter Screen Flow for all services and populate additional enrichment details(Logistics Ref.,LG_Logistics Name.,ESN).');
                continue; 
            }
        }
        }
        //Changes For sfom-2597 Ends
       /** for(csord__Service__c serviceRecord: serviceList){
            //SFOM-1748
            if(serviceRecord.UM_LogisticsReference__c == null || serviceRecord.UM_ESN__c == null){
                caseRecord.addError('Please enter Screen Flow for all services and populate additional enrichment details(Logistics Ref., ESN).');
                continue;
            }
            
        }*/
        
    }
    
   
    public static void validateAppointment(List<Case> casesNew) {
        
        Map<id, case> caseMap = new Map<id, case>();
        map<Id, Schema.RecordTypeInfo>  newSchema = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById();
        //add schedule appointment case records to a map
        for (Case obj :casesNew) {    
            
            if (newSchema.get(obj.recordTypeID).getName()!= 'Schedule Appointment') {
                continue;
            }
            
            if (newSchema.get(obj.recordTypeID).getName() == 'Schedule Appointment'  && obj.LG_Solution__C!= Null && obj.status == 'Closed') {
                caseMap.put(obj.id, obj);                
            } 
        }
        
        if(caseMap.size()>0)
            checkappointment(caseMap);        
    }
    
    Public Static Void checkAppointment(Map<id, case> caseMap){
        
        Map<id, LG_ScheduleAppointment__c> caseAppMap = new Map<id, LG_ScheduleAppointment__c>();
        List<LG_ScheduleAppointment__c> appointmentList= new List <LG_ScheduleAppointment__c>();
        List<case> caseList = new List<case>();
        List<CSPOFA__Orchestration_Process__c> processIds = new List <CSPOFA__Orchestration_Process__c>();
        List<CSPOFA__Orchestration_Step__c> processSteps = new List<CSPOFA__Orchestration_Step__c>();
        List<csord__Solution__c> solnlist = new List<csord__Solution__c>(); 
        List<csord__Solution__c> solnListToUpdate = new List<csord__Solution__c>(); 
        
        //get the list of appointments for the cases in the map and cases for Modify type and not in Jeopardy
        appointmentList = [SELECT id,LG_Status__c,LG_Case__c from LG_ScheduleAppointment__c WHERE LG_Case__c in :caseMap.keyset() and  LG_Status__c = 'Scheduled'];
        caseList = [SELECT id, LG_Solution__C from case WHERE  id in :caseMap.keyset() and type = 'Modify' ];
        
        //Get the list of solution id mapped to the cases
        set<Id> solnId = new set <Id>();
        
        for (case c : caseList){
            solnId.add(c.LG_Solution__c);
        }
        
        //Get the list of orchestration process ids and process ids for the solution
        solnList = [SELECT id, LG_TargetDate__c, LG_EarliestInstallDate__c, LG_EarliestPortingWishDate__c,LG_LatestPortingWishDate__c, LG_AnyNumbersToPort__c, LG_InflightChange__c, LG_RetryInstall__c, LG_RetryNumberPort__c from csord__Solution__c WHERE  id in :solnId];
        processIds = [SELECT id, Name, LG_Solution__c, CSPOFA__Orchestration_Process_Template__c, CSPOFA__Process_On_Hold__c FROM CSPOFA__Orchestration_Process__c where LG_Solution__c IN :solnId];
        processSteps = [select id, Name, CSPOFA__Status__c, CSPOFA__Step_Order__c,CSPOFA__Orchestration_Process__c,CSPOFA__Orchestration_Process__r.LG_Solution__r.id  FROM CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__c in :processIds and CSPOFA__Step_Order__c <100];    
        
        //add appointment details to a map
        for (LG_ScheduleAppointment__c appointment :appointmentList) {
            
            caseAppMap.put(appointment.LG_Case__C, appointment);
        }
        
        //check if every case in the map contains a appointment
        for (String keyId : caseMap.keySet() ){
            
            if(!caseAppMap.keyset().contains(keyId)){
                
                caseMap.get(keyId).addError('Case cannot be closed without a valid appointment');
                break;
            }
        }
        
        //Checking the impact on Orchestration Process
        
        //Setting portingwindow to 7 days -- to be made dynamic in future phases
        Integer portingWindow = 7;
        Integer potentialGotoSeq;  
        for (csord__Solution__c soln :solnList ){
            
            if (soln.LG_AnyNumbersToPort__c == True){
                //Compute the potential step based on porting wish date
                potentialGotoSeq = 34;
                if (soln.LG_LatestPortingWishDate__c + portingWindow > soln.LG_TargetDate__c ){
                    potentialGotoSeq = 37;
                }
                
                //Get the inprogress step
                CSPOFA__Orchestration_Step__c inProgressProcessStep = inProgressProcessStep(processSteps, soln.id);
                
                //Condition to check if there is an impact on orchestration process due to change in dates  and set the appropriate flags to True
                if(inProgressProcessStep.CSPOFA__Step_Order__c >=potentialGotoSeq ){
                    if(potentialGotoSeq == 37){
                        soln.LG_RetryInstall__c = True;
                        solnListToUpdate.add(soln);
                    }
                    else if(potentialGotoSeq == 34){
                        soln.LG_RetryNumberPort__c = True;
                        solnListToUpdate.add(soln);
                        
                    }
                    if(soln.LG_Jeopardy__c == True){
                        Continue;
                    }else {
                        soln.LG_InflightChange__c = True;
                        continue;
                    }
                }
            }
            //For products with number porting flag unchecked
            if (soln.LG_AnyNumbersToPort__c == False){
                potentialGotoSeq = 37;
                CSPOFA__Orchestration_Step__c inProgressProcessStep = inProgressProcessStep(processSteps, soln.id);
                
                //Condition to check if there is an impact on orchestration process due to change in dates  and set the appropriate flags to True
                if(inProgressProcessStep.CSPOFA__Step_Order__c >=potentialGotoSeq ){
                    
                    soln.LG_RetryInstall__c = True;
                    solnListToUpdate.add(soln);
                    
                    if(soln.LG_Jeopardy__c == True){
                        Continue;
                    }else {
                        soln.LG_InflightChange__c = True;
                        continue;
                    }
                } 
            }
        }
        if(solnListToUpdate.size()>0){
                update solnListToUpdate; 
        }    
    }
    
    
    //Method to compute the inporgress orchestration process step
    Private static CSPOFA__Orchestration_Step__c inProgressProcessStep (List<CSPOFA__Orchestration_Step__c> inProgressProcessStep, Id solnId){
        
        CSPOFA__Orchestration_Step__c pro = new CSPOFA__Orchestration_Step__c ();
        for (CSPOFA__Orchestration_Step__c processStep : inProgressProcessStep){
            if(processstep.CSPOFA__Orchestration_Process__r.LG_Solution__c== solnId  && (processstep.CSPOFA__Status__c == 'In Progress'  || processstep.CSPOFA__Status__c == 'Waiting For Feedback')){
                pro = processStep;
                break;
            }
        }
        return pro; 
    }

    //SFOM-2164 Update Service Status as "Activation Completed" upon case closure.
    public static void updateServiceStatusOnCaseClosure(List<Case> casesNew,Map<Id, Case> casesOld){
        List<String> solutionIdList = new List<String>();
        Map<Id,List<csord__Service__c>> serviceListMap;
        list<csord__Service__c> changedServices = new list<csord__Service__c>();        
        
        //Get solution ids from the case
        for(Case caseDetail:casesNew){
            if(caseDetail.LG_Solution__c != null){
                solutionIdList.add(caseDetail.LG_Solution__c);
            }
        }
        
        //Get serviceRecords related to the 
        serviceListMap = getServiceRecords(casesNew, solutionIdList);
        
        for (Case caseRecord :casesNew) {
            Map<ID,Schema.RecordTypeInfo> recordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosById();
            String recordTypeName = recordTypeMap.get(caseRecord.RecordTypeId).getName();
            
            if (caseRecord.Status == 'Closed' && (casesOld.get(caseRecord.id).status!='Closed') &&
                (recordTypeName=='Provision One Step' || recordTypeName=='Activate Service')) {
                for(csord__Service__c serviceRecord: serviceListMap.get(caseRecord.id)){
                    if(serviceRecord.csord__Deactivation_Date__c!=null || serviceRecord.csord__activation_Date__c!=null){
                        if (serviceRecord.csord__status__c != 'Ready for Billing' && serviceRecord.csord__status__c != 'Active') {
                        	serviceRecord.csord__status__c='Activation Completed'; 
                        }   
                        changedServices.add(serviceRecord);
                    }
                }
            } 
        }
        system.debug('changedServices=='+changedServices);
        update changedServices;        
    }
    
    
    
}