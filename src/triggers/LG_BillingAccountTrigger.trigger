trigger LG_BillingAccountTrigger on csconta__Billing_Account__c (before insert, before update, after insert) {
    
    if((trigger.isUpdate || trigger.isInsert) && trigger.isBefore) {
        // LG_ValidateBillingAccount.handle(Trigger.new, Trigger.old);
    }
    
    No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    
    if (notriggers == null || !notriggers.Flag__c)
    {
        if (trigger.isBefore && trigger.isInsert)
        {
            LG_BillingAccountTriggerHandler.beforeInsertHandler(trigger.new);
            LG_BillingAccountTriggerHandler.removeWhiteSpaceFromIBAN(trigger.new);
        }
        
        if (trigger.isBefore && trigger.isUpdate)
        {
            LG_BillingAccountTriggerHandler.beforeUpdateHandler(trigger.new, trigger.oldMap);
            LG_BillingAccountTriggerHandler.setIsSyncOnBillAccountToFalse(trigger.new, trigger.oldMap);
            LG_BillingAccountTriggerHandler.removeWhiteSpaceFromIBAN(trigger.new);
        }

        if (trigger.isAfter && trigger.isInsert)
        {
            LG_BillingAccountTriggerHandler.afterInsertHandler(trigger.new);
        }        
    }
}