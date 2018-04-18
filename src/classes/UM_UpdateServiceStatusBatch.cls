global class UM_UpdateServiceStatusBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
       String query = 'SELECT Id,LG_Action__c, LG_MarketSegment__c, LG_ServiceStatus__c, csord__Activation_Date__c, csord__Deactivation_Date__c FROM csord__Service__c WHERE (csord__Activation_Date__c <= Today OR csord__Deactivation_Date__c <=Today) and (LG_ServiceStatus__c= \'Ready for Billing\') and (LG_MarketSegment__c = \'SOHO\')';              
                return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<csord__Service__c> scope) {
        List<csord__Service__c> lstServiceToBeUpdated= new List<csord__Service__c>();
         for (csord__Service__c lstService:scope)
         {
             if(lstService.LG_Action__c=='Delete')
             {
                 lstService.LG_ServiceStatus__c='Inactive';
             }
             else
             {
                 lstService.LG_ServiceStatus__c='Active';
             }
            lstServiceToBeUpdated.add(lstService);        
         }
         
         if(!lstServiceToBeUpdated.isEmpty()){
         update lstServiceToBeUpdated;
         }
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}