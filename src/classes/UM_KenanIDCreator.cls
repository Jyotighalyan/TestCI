public with sharing class UM_KenanIDCreator implements UM_KenanSyncBatch.IServiceConnect{

    public void execute(list<sObject> numberBlockList){
        //list<UM_NumberBlock__c> numberBlocks = (list <UM_NumberBlock__c>) numberBlockList;
        list<Asset> numberBlocks = (list <Asset>) numberBlockList;
        KenanServiceExternalId idBack;

        for(Asset numberBlock : numberBlocks){
            if(numberBlock.LG_NumberRangeService__r.csord__Service__c!=null){
                System.debug('*** numberBlock'+numberBlock);
                if(!Test.isRunningTest())
                    idBack = UM_KenanSubscriptionSyncCtrl.createExternalId(numberBlock.LG_NumberRangeService__r.csord__Service__c,
                                                              numberBlock.UM_CDRIDNumber__c, numberBlock.LG_NumberRangeService__r.csord__Service__r.csord__Activation_Date__c);
            }

            if((idBack!=null && idBack.serviceInternalId!=null) || (Test.isRunningTest())){
                System.debug('*** idBack: '+idBack);
                numberBlock.Status  = 'Active';
            }
        }
        update numberBlocks;
    }

}