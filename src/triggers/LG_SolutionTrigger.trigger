trigger LG_SolutionTrigger on csord__Solution__c (after update) {
	No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());

	if (notriggers == null || !notriggers.Flag__c) {
		if (Trigger.isUpdate && Trigger.IsAfter) {
			LG_SolutionTriggerHandler.notifyMonitorField(Trigger.new, Trigger.oldMap);
            //LG_SolutionTriggerHandler.checkVPNAndConnectionStatus(Trigger.new, Trigger.oldMap);
		}
	}
}