global class UM_ServiceStatusValidator {


    @InvocableMethod(label='Service Status Check')
    public static void ValidateServiceStatus(List<Id> ServiceId) {

        if(!ServiceId.isEmpty()){
             Map<Id, csord__Solution__c> solutionList = new Map<Id, csord__Solution__c>();
             List<Id> solutionIds = new List<Id>();
             Map<Id,Case> existingCaseMap = new Map<Id,Case>();
             Map<Id,csord__Service__c> serviceMap = getAllServiceRecords(ServiceId);
             System.debug('serviceMap'+serviceMap);
             //Map<Id,List<csord__Service__c>> serviceListMap = getAllRelatedServices(OpportunityId);
             for (Id serv:ServiceId) {
                 if(serviceMap.containsKey(serv)){
                     csord__Service__c service = serviceMap.get(serv);
                     if(service.LG_ServiceStatus__c == 'Ready for Billing' && service.csord__Activation_Date__c <= Date.today()){
                         if(service.LG_Suborder__c != null){
                             service.LG_Suborder__r.LG_Integration_Status__c = 'Billing Integration Timeout';
                             solutionList.put(service.LG_Suborder__c, service.LG_Suborder__r);
                             solutionIds.add(service.LG_Suborder__c);
                         }
                     }
                 }
             }//for loop - service Ids

             try{
                 if(!solutionList.isEmpty()){
                     update solutionList.values();
                     //existingCaseMap = getExistingCases(solutionIds);
                     //createJeopardyCase(solutionIds, existingCaseMap);
                 }
             }catch(Exception ex){
                 System.debug('Exception : '+ ex.getMessage());
             }





        }
    }


    private static Map<Id,csord__Service__c> getAllServiceRecords(List<Id> serviceIds){
        Map<Id,csord__Service__c> serviceMap = new Map<Id,csord__Service__c>();
        List<csord__Service__c> serviceList =[SELECT Id, LG_ServiceStatus__c, csord__Activation_Date__c, LG_Suborder__c, LG_Suborder__r.LG_Integration_Status__c
                                            FROM csord__Service__c WHERE Id IN :serviceIds];

        for(csord__Service__c service:serviceList){
            if(!serviceMap.containsKey(service.Id)){
                serviceMap.put(service.Id, service);
            }
        }

        return serviceMap;
    }

    /*private static Map<Id,Case> getExistingCases(List<Id> SolutionIds){
        Map<Id,Case> existngCase = new Map<Id,Case>();
        List<Case> caseList = [SELECT Id, CaseNumber, LG_Solution__c FROM Case WHERE RecordType.Name = 'Jeopardy' AND Status = 'New' AND LG_Solution__c  IN :SolutionIds];
        for(Case cas:caseList){
            if(!existngCase.containsKey(cas.LG_Solution__c)){
                existngCase.put(cas.LG_Solution__c, cas);
            }
        }
        return existngCase;
    }

    private static void createJeopardyCase(List<Id> SolutionIds, Map<Id,Case> caseMap){
        List<Case> newCase = new List<Case>();
        for(Id solId:SolutionIds){
            if(caseMap == null || !caseMap.containsKey(solId)){
                Case jeopardyCase = new Case();
                jeopardyCase.Subject = 'Jeopardy caused by Billing';
                jeopardyCase.Type = 'Billing';
                jeopardyCase.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Jeopardy'].Id;
                jeopardyCase.OwnerId = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Business Service - SME Care'].Id;
                jeopardyCase.LG_Solution__c = solId;
                newCase.add(jeopardyCase);
            }
        }

        try{
            insert newCase;
        }catch(Exception e){
            System.debug('Exception : '+e.getMessage());
        }

    }*/

}