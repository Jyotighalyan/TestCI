trigger UM_BillingAccountItemTrigger on UM_BillingAccountItem__c (before insert, before update, after insert, after update) {
    No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    //calling below method outside No triggeres check because it has to be called when records come from external system using System user
    if(Trigger.isBefore && Trigger.isInsert){
            UM_BillingAccountItemTriggerHandler.updateItemRecordType(Trigger.New);
    }
    //added below method to update Amount- BHP-23
    if(Trigger.isBefore && Trigger.isUpdate){
            UM_BillingAccountItemTriggerHandler.beforeUpdateEventHandler(Trigger.New, Trigger.OldMap);
    }
    if (notriggers == null || !notriggers.Flag__c){
        if(Trigger.isBefore && Trigger.isInsert){
            UM_BillingAccountItemTriggerHandler.beforeInsertEventHandler(Trigger.New);
        }

        if(Trigger.isAfter && Trigger.isInsert){
            UM_BillingAccountItemTriggerHandler.afterInsertEventHandler(Trigger.New);
        }

        if(Trigger.isAfter && Trigger.isUpdate){
            UM_BillingAccountItemTriggerHandler.afterUpdateEventHandler(Trigger.New,Trigger.oldMap);
        }
    }
}