public with sharing class UM_ContractTriggerHandler {

     public static void updateServiceOnContractUpdate(map<id,csconta__Contract__c> newContracts, map<id,csconta__Contract__c>oldContracts){
        List<csord__Service__c > serviceToBeUpdate = new List<csord__Service__c >();
        set<id> subscriptionIdSet = new set<id>();
        Set<id> contractIdSet=new Set<id>();
        for(csconta__Contract__c contract : newContracts.values()){
            if((contract.csconta__Valid_To__c != oldContracts.get(contract.id).csconta__Valid_To__c))
                contractIdSet.add(contract.id);           
        }
        for(csord__Service__c ser : [SELECT Id, Name, UM_Latest_Cancellation_Letter_Arrival__c, UM_Cancellation_Period__c,LG_ContractEndDate__c
                                        FROM csord__Service__c 
                                        WHERE csord__Subscription__r.LG_Contract__c  IN: contractIdSet])
        {
            serviceToBeUpdate.add(ser);
        }
        System.debug('***Service Records'+serviceToBeUpdate);
        if(!serviceToBeUpdate.isEmpty())
            UPDATE serviceToBeUpdate;
     }
     
     public static void updateContractOnRenewal(set<Id> contractIdSet)
     {
        
        List<csord__Service__c > serviceList=[select id,csord__Activation_Date__c,UM_Latest_Cancellation_Letter_Arrival__c,UM_Cancellation_Period__c ,csord__Subscription__c,csord__Subscription__r.id,csord__Subscription__r.LG_Contract__c, csord__Subscription__r.LG_Contract__r.Id, csord__Subscription__r.LG_Contract__r.csconta__Valid_To__c 
                            from csord__Service__c 
                            where csord__Service__c=null and csord__Subscription__r.LG_Contract__r.Id in :contractIdSet];

        KenanService ksBack;
        
        for(csord__Service__c service: serviceList){
            Time t = Time.newInstance(0, 0, 0, 0);           
            DateTime conractDueDate = DateTime.newInstance(service.csord__Subscription__r.LG_Contract__r.csconta__Valid_To__c,t);
            Date letterArrivalDate = service.csord__Subscription__r.LG_Contract__r.csconta__Valid_To__c.addMonths(integer.valueof(-service.UM_Cancellation_Period__c));
            if(!Test.isRunningTest()){             
                 ksBack = UM_KenanSubscriptionSyncCtrl.updateContract(service.Id,conractDueDate,letterArrivalDate,service.csord__Activation_Date__c);
            }

            if((ksBack!=null && ksBack.serviceInternalId!=null) || (Test.isRunningTest())){
                System.debug('*** ksBack: '+ksBack);
            }
        }
    }
}