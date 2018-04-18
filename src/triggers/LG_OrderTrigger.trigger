trigger LG_OrderTrigger on csord__Order__c (after update) {
	No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());

	if (notriggers == null || !notriggers.Flag__c) {
		if (Trigger.isUpdate && Trigger.IsAfter) {
			LG_OrderTriggerHandler.notifyMonitorField(Trigger.new, Trigger.oldMap);
			LG_OrderTriggerHandler.updateInstallBase(Trigger.new, Trigger.oldMap);			
		}		
	}	
}