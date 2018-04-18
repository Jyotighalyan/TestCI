trigger UM_KenanAdjustmentTrigger on Kenan_Adjustment__c (before insert,before update) {
 No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    //BHP-22 : Shubham Mittal
       if(Trigger.isBefore && Trigger.isInsert){
            UM_KenanAdjustmentTriggerHandler.beforeInsertEventHandler(Trigger.New);
        }
       //added below to support Amount update from Kenan- BHP-22 -15/01/18
       if(Trigger.isBefore && Trigger.isUpdate){
            UM_KenanAdjustmentTriggerHandler.beforeUpdateEventHandler(Trigger.New, Trigger.OldMap);
       }
}