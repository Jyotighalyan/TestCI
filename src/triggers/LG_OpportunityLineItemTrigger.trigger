trigger LG_OpportunityLineItemTrigger on OpportunityLineItem (after delete, after insert, after update, 
before delete, before insert, before update) 
{

    No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    
    if (notriggers == null || !notriggers.Flag__c)
    {
        if ((trigger.isInsert) && (trigger.IsAfter))
        {
            LG_OpportunityLineItemTriggerHandler.AfterInsertHandle(trigger.new);
        }
        
    }

}