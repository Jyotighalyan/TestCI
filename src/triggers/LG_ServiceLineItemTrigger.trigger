trigger LG_ServiceLineItemTrigger on csord__Service_Line_Item__c (after insert, after update)
{
    No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    
    if (notriggers == null || !notriggers.Flag__c)
    {        
        if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
        {
          //  LG_ServiceLineItemTriggerHandler.cloneSlaLineItem(Trigger.new, Trigger.oldMap);    
		  LG_ServiceLineItemTriggerHandler.updateBillingAccount(Trigger.newMap);    
        }
    }
}