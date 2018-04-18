///
/// Product Configuration trigger
///
trigger LG_ProdConfRequestTrigger on csbb__Product_Configuration_Request__c (before insert,
after delete, after insert, after update, after undelete) {

	No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    
    if (notriggers == null || !notriggers.Flag__c)
    {
		if (Trigger.isAfter)
		{
			LG_ProdConfRequestTriggerHandler.updateRollUpFieldsOnProductBasket(Trigger.new, Trigger.oldMap);
			
			if (Trigger.isInsert || Trigger.isUpdate)
			{
				LG_ProdConfRequestTriggerHandler.upsertThePremisesRecords(Trigger.new, Trigger.oldMap);
			}
		}
		
		if (Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert))
		{
			LG_ProdConfRequestTriggerHandler.setTheOptionalsField(Trigger.new, Trigger.oldMap);
		}
    }
}