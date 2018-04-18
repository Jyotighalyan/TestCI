trigger UM_AssetTrigger on Asset (before insert, before update, after insert, after update) {
    No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    if (notriggers == null || !notriggers.Flag__c){

        if (Trigger.isAfter && Trigger.isUpdate){

        }

        if (Trigger.isAfter && Trigger.isInsert){

        }

        if(Trigger.isBefore && Trigger.isUpdate){
        }

        if(Trigger.isAfter && Trigger.isUpdate){

            UM_AssetTriggerHandler.cloneAssetsForProduct(Trigger.newMap,Trigger.oldMap);

            //UMR-307
            //Creates Child Assets for product

            UM_AssetTriggerHandler.createChildAssets(Trigger.newMap, Trigger.oldMap);
            UM_AssetTriggerHandler.updateChildAssets(Trigger.newMap, Trigger.oldMap);
        }

    }

}