trigger LG_OrchestratorProcessTemplateTrigger on CSPOFA__Orchestration_Process_Template__c (before insert, before update) {

	No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());

	if (notriggers == null || !notriggers.Flag__c) {
		if (Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert)) {
			LG_OrchProcessTemplateTriggerHandler.checkDecompositionCriteria(Trigger.new, Trigger.oldMap);
		}
	}
}