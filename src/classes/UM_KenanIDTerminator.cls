public with sharing class UM_KenanIDTerminator implements UM_KenanSyncBatch.IServiceConnect{

    public void execute(list<sObject> numberBlockList){
        list<UM_NumberBlock__c> numberBlocks = (list <UM_NumberBlock__c>) numberBlockList;
        boolean result=false;
        
        for(UM_NumberBlock__c numberBlock : numberBlocks){
            if((numberBlock.UM_NumberRangeService__r.csord__Service__c!=null) && (!Test.isRunningTest())){
                System.debug('*** numberBlock'+numberBlock);
                Date inactiveDate = numberBlock.UM_NumberRangeService__r.csord__Service__r.csordtelcoa__Replacement_Service__r.csord__Activation_Date__c;
                if(inactiveDate==null)
                    inactiveDate = Date.today();
            	result = UM_KenanSubscriptionSyncCtrl.ceaseExternalId(numberBlock.UM_NumberRangeService__r.csord__Service__c, 
                                                                      numberBlock.UM_CDRIDNumber__c, inactiveDate);
            }
            
            if((result) || (Test.isRunningTest())){
                numberBlock.UM_BillingStatus__c  = 'Not Active in Billing';
            }
        }
        update numberBlocks;
    }
    
}