public class LG_OrchProcessTemplateTriggerHandler {
	/**
	 * Checks that the selected value of the LG_DecompositionCriteria__c
	 * field is not already selected on some other Orch. Process Template record.
	 * If so, throws the error.
	 *
	 * @param  List<CSPOFA__Orchestration_Process_Template__c> templates
	 * @param  Map<Id, CSPOFA__Orchestration_Process_Template__c> oldMap
	 * @author Tomislav Blazek
	 * @ticket SFOM-202
	 * @since  15/12/2016
	 */
	public static void checkDecompositionCriteria(List<CSPOFA__Orchestration_Process_Template__c> templates,
												  Map<Id, CSPOFA__Orchestration_Process_Template__c> oldMap)
	{
		Set<CSPOFA__Orchestration_Process_Template__c> applicableTemplates = new Set<CSPOFA__Orchestration_Process_Template__c>();
		Set<String> decompositionCriteriasForQuery                         = new Set<String>();
		/*
		 * Decide which templates should be processed:
		 * - only new templates
		 *      or the ones having a change in the LG_DecompositionCriteria__c field
		 */
		for (CSPOFA__Orchestration_Process_Template__c newTemplate : templates) {
			if (String.isBlank(newTemplate.LG_DecompositionCriteria__c)) {
				continue;
			}
			CSPOFA__Orchestration_Process_Template__c oldTemplate = oldMap == null ? null : oldMap.get(newTemplate.Id);

			if (oldTemplate == null || (oldTemplate.LG_DecompositionCriteria__c != newTemplate.LG_DecompositionCriteria__c)) {
				applicableTemplates.add(newTemplate);
				decompositionCriteriasForQuery.addAll(LG_Util.semicolonSeparatedStringToSet(newTemplate.LG_DecompositionCriteria__c));
			}
		}

		if (!applicableTemplates.isEmpty()) {
			String decCriterias = String.join(new List<String>(decompositionCriteriasForQuery), '\',\'');

			List<CSPOFA__Orchestration_Process_Template__c> existingTemplates;
			String queryString = 'SELECT Id, Name, LG_DecompositionCriteria__c '
								 + 'FROM CSPOFA__Orchestration_Process_Template__c '
								 + 'WHERE LG_DecompositionCriteria__c INCLUDES(\'' + decCriterias +'\')';

			List<CSPOFA__Orchestration_Process_Template__c> orchProcessTemplates =
				(List<CSPOFA__Orchestration_Process_Template__c>)Database.query(queryString);

			//ugly, but had to iterate through all the multiselect picklist values
			for (CSPOFA__Orchestration_Process_Template__c newTemplate : applicableTemplates) {
				for (CSPOFA__Orchestration_Process_Template__c existingTemplate : orchProcessTemplates) {
					if (newTemplate.Id != existingTemplate.Id) {
						boolean errored = false;
						for (String decompCriteria : LG_Util.semicolonSeparatedStringToSet(newTemplate.LG_DecompositionCriteria__c)) {
							if (existingTemplate.LG_DecompositionCriteria__c.contains(decompCriteria)) {
								newTemplate.addError(Label.LG_OrchProcessDecCriteriaError.replace('{templateName}', existingTemplate.Name));
								errored = true;
								break;
							}
						}
						if (errored) {
							break;
						}
					}
				}
			}
		}
	}
}