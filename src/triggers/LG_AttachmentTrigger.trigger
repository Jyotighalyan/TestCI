trigger LG_AttachmentTrigger on Attachment (after delete, after insert, after update, 
before delete, before insert, before update) 
{

	No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    
    if (notriggers == null || !notriggers.Flag__c)
    {
    	if ((trigger.isInsert) && (trigger.IsAfter)) 
    	{
    		LG_AttachmentTriggerHandler.AfterInsertHandle(trigger.new);
    		
    		for (integer i=0;i<trigger.new.size();++i)
    		{
    			system.debug('*** after insert trigger.new[' + i + ']=' + trigger.new[i].Name);                
    		}

    	}
    	
    	if ((trigger.isUpdate) && (trigger.IsAfter))
    	{
    		LG_AttachmentTriggerHandler.AfterUpdateHandle(trigger.new, trigger.old);

    		for (integer i=0;i<trigger.new.size();++i)
    		{
    			system.debug('*** after update trigger.new[' + i + ']=' + trigger.new[i].Name);
    		}

    	}
    	
    }


}