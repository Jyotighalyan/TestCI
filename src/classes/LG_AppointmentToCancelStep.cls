/**
 * Used as a custom orchestator step.
 * Scans the Schedule Appointment records related
 * to the solution being processed.
 * Stamps the 'Appointment To Cancel' flag on the solution,
 * so that further conditions in the process can use it.
 *
 * @author Tomislav Blazek
 * @ticket SFOM-359
 * @since  27/3/2017
 */
global class LG_AppointmentToCancelStep implements CSPOFA.ExecutionHandler {

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

		checkScheduleAppointment(processesIds);

		for (CSPOFA__Orchestration_Step__c step : stepList) {
			//mark step Status, Completed Date
			step.CSPOFA__Status__c         = 'Complete';
			step.CSPOFA__Completed_Date__c = Date.today();
			result.add(step);
		}

		return result;
	}

	/**
	 * Scans the Schedule Appointment records related to the processes/solutions
	 * being executed/processed and checks whether the Date of the Appointment
	 * is set to Today or later.
	 * If that's the case, flag 'Appointment to Cancel' on the related solution
	 * will be set to true.
	 *
	 * @param  Set<Id> processesIds
	 * @author Tomislav Blazek
	 * @ticket SFOM-359
	 * @since  27/3/2017
	 */
	@TestVisible
	private void checkScheduleAppointment(Set<Id> processesIds)
	{
		Set<Id> solutionsIds = new Set<Id>();
		for (CSPOFA__Orchestration_Process__c process : [SELECT LG_Solution__c
														 FROM CSPOFA__Orchestration_Process__c
														 WHERE Id IN :processesIds
														 AND LG_Solution__c != null]) {
			solutionsIds.add(process.LG_Solution__c);
		}

		Map<Id, csord__Solution__c> solutionsToUpdate = new Map<Id, csord__Solution__c>();

		for (LG_ScheduleAppointment__c schApp : [SELECT LG_AgreedInstallDate__c, LG_Solution__c
												 FROM LG_ScheduleAppointment__c
												 WHERE LG_Solution__c IN :solutionsIds]) {
			if (schApp.LG_AgreedInstallDate__c >= Date.today()
				&& !solutionsToUpdate.containsKey(schApp.LG_Solution__c)) {
				solutionsToUpdate.put(schApp.LG_Solution__c,
									  new csord__Solution__c(Id = schApp.LG_Solution__c,
															 LG_AppointmentToCancel__c = true));
			}
		}

		if (!solutionsToUpdate.isEmpty()) {
			update solutionsToUpdate.values();
		}
	}
}