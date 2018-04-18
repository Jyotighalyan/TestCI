global class UM_BatchAutoRenewContract implements Database.Batchable < sObject >, Database.Stateful, Database.AllowsCallouts
{
    Date todayDate = date.today();
    String subscription_Status_Active='Active';
    public set<Id> contractIdSet;
    
    public UM_BatchAutoRenewContract(){contractIdSet = new set<Id>();}
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        string dataQuery = 'SELECT ID,csconta__Account__c, csconta__Subscription__c,csconta__Valid_To__c FROM csconta__Contract__c WHERE csconta__Valid_To__c  =: todayDate AND csconta__Subscription__r.csord__Status__c=:subscription_Status_Active';
        return Database.getQueryLocator(dataQuery);
    }

    global void execute(Database.BatchableContext BC, List < csconta__Contract__c > scope)
    {
        try 
        {
            List<csconta__Contract__c> contractList = new List<csconta__Contract__c>();      
            if (!scope.isEmpty())
            {
                for (csconta__Contract__c contract_obj: scope)
                {
                    contract_obj.csconta__Valid_To__c = contract_obj.csconta__Valid_To__c.addYears(1);
                    contractList.add(contract_obj);
                    contractIdSet.add(contract_obj.Id);
                }
                if(!contractList.isEmpty()){
                    UPDATE contractList;
                    System.debug('contractList.size()---->'+contractList.size());
                }
            }
         }
         catch (exception e)
         {
           System.debug('*** Error: ' + e.getMessage() + ' stack trace: ' + e.getStackTraceString());
         }
    }
    
    global void finish(Database.BatchableContext BC)
    {
        System.debug('contractIdSet.size()---->'+contractIdSet.size());
        if(!contractIdSet.isEmpty())
            UM_ContractTriggerHandler.updateContractOnRenewal(contractIdSet);
    }

}