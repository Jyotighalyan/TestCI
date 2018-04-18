/**
 * Used as a custom orchestator step.
 * Scans the Process Request records related
 * to the Port-in Numbers related to the solution being processed.
 * Stamps the 'Process Requests to Cancel' flag on the solution,
 * so that further conditions in the process can use it.
 *
 * @author Tomislav Blazek
 * @ticket SFOM-359
 * @since  30/3/2017
 */
global class LG_AnyNumberPortReqsStep implements CSPOFA.ExecutionHandler {

	public List<sObject> process(List<SObject> data)
	{
		List<sObject> result = new List<sObject>();
		//collect the data for all steps passed in, if needed
		//process steps
		List<CSPOFA__Orchestration_Step__c> stepList =
			(List<CSPOFA__Orchestration_Step__c>)data;

		Set<Id> processesIds = new Set<Id>();
		for (CSPOFA__Orchestration_Step__c step : stepList) {
			processesIds.add(step.CSPOFA__Orchestration_Process__c);
		}

		checkNumberPortRequests(processesIds);

		for (CSPOFA__Orchestration_Step__c step : stepList) {
			//mark step Status, Completed Date
			step.CSPOFA__Status__c         = 'Complete';
			step.CSPOFA__Completed_Date__c = Date.today();
			result.add(step);
		}

		return result;
	}

	/**
	 * Scans the Process Request records related to the processes/solutions
	 * being executed/processed and checks whether there is any request in progress
	 * or successfull.
	 * If that's the case, flag 'Process Requests to Cancel' on the related solution
	 * will be set to true.
	 *
	 * @param  Set<Id> processesIds
	 * @author Tomislav Blazek
	 * @ticket SFOM-359
	 * @since  30/3/2017
	 */
	@TestVisible
	private void checkNumberPortRequests(Set<Id> processesIds)
	{
		Set<Id> solutionsIds = new Set<Id>();
		for (CSPOFA__Orchestration_Process__c process : [SELECT LG_Solution__c
														 FROM CSPOFA__Orchestration_Process__c
														 WHERE Id IN :processesIds
														 AND LG_Solution__c != null]) {
			solutionsIds.add(process.LG_Solution__c);
		}

		Map<Id, csord__Solution__c> solutionsToUpdate = new Map<Id, csord__Solution__c>();

		List<LG_AssetProcessAssociation__c> assetAsscs = [SELECT Id, LG_Process__c,
														  LG_Asset__r.LG_TelephonyService__r.LG_Suborder__c
														  FROM LG_AssetProcessAssociation__c
														  WHERE LG_Asset__r.LG_TelephonyService__r.LG_Suborder__c IN :solutionsIds
														  AND LG_Asset__r.RecordType.Name = 'Number Block'
																							AND LG_Asset__r.LG_NumberRangeType__c = 'Port-In'];

		if (!assetAsscs.isEmpty()) {
			Set<Id> processIds        = new Set<Id>();
			Set<Id> processesToCancel = new Set<Id>();
			for (LG_AssetProcessAssociation__c assetAssc : assetAsscs) {
				processIds.add(assetAssc.LG_Process__c);
			}

			for (LG_ProcessRequest__c procReq : [SELECT LG_Process__c FROM LG_ProcessRequest__c
												 WHERE LG_Response__c != 'Rejected'
												 AND LG_Process__c IN :processIds]) {
				processesToCancel.add(procReq.LG_Process__c);
			}

			if (!processesToCancel.isEmpty()) {
				for (LG_AssetProcessAssociation__c assetAssc : assetAsscs) {
					if (processesToCancel.contains(assetAssc.LG_Process__c)) {
						solutionsToUpdate.put(assetAssc.LG_Asset__r.LG_TelephonyService__r.LG_Suborder__c,
											  new csord__Solution__c(Id = assetAssc.LG_Asset__r.LG_TelephonyService__r.LG_Suborder__c,
																	 LG_ProcessRequestsToCancel__c = true));
					}
				}

				if (!solutionsToUpdate.isEmpty()) {
					update solutionsToUpdate.values();
				}
			}
		}
	}
}