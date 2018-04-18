/**
 * Used as a custom orchestator step.
 * Scans the Services records related
 * to the solution being processed.
 * Stamps the 'Any Active Service' flag on the solution,
 * so that further conditions in the process can use it.
 *
 * @author Tomislav Blazek
 * @ticket SFOM-359
 * @since  30/3/2017
 */
global class LG_AnyActiveServiceStep implements CSPOFA.ExecutionHandler {

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

		checkActiveServices(processesIds);

		for (CSPOFA__Orchestration_Step__c step : stepList) {
			//mark step Status, Completed Date
			step.CSPOFA__Status__c         = 'Complete';
			step.CSPOFA__Completed_Date__c = Date.today();
			result.add(step);
		}

		return result;
	}

	/**
	 * Scans the Service records related to the processes/solutions
	 * being executed/processed and checks whether any of the Service records
	 * have the status Active or higher. Relevant only for the solutions that
	 * were not superseeded by the newer version.
	 * If that's the case, flag 'Any Active Service' on the related solution
	 * will be set to true.
	 *
	 * @param  Set<Id> processesIds
	 * @author Tomislav Blazek
	 * @ticket SFOM-359
	 * @since  30/3/2017
	 */
	@TestVisible
	private void checkActiveServices(Set<Id> processesIds)
	{
		List<csord__Solution__c> solutionsToUpdate = new List<csord__Solution__c>();

		for (csord__Solution__c solution : [SELECT Id, (SELECT Id FROM Solutions__r),
											(SELECT Id FROM Services__r
											 WHERE csord__Status__c = 'Active'
																	  OR csord__Status__c = 'Activation Completed'
																							OR csord__Status__c = 'Ready for Billing'
																												  OR csord__Status__c = 'Installation Failed')
											FROM csord__Solution__c
											WHERE Id IN (SELECT LG_Solution__c
														 FROM CSPOFA__Orchestration_Process__c
														 WHERE Id IN :processesIds)]) {
			if (solution.Solutions__r.isEmpty() && !solution.Services__r.isEmpty()) {
				solutionsToUpdate.add(new csord__Solution__c(Id = solution.Id, LG_AnyActiveService__c = true));
			}
		}

		if (!solutionsToUpdate.isEmpty()) {
			update solutionsToUpdate;
		}
	}
}