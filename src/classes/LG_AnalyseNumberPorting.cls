/**
 * Check if there are any number to port
 * 
 * Scans all numbers under this Solution. If there are any numbers that
 * still require porting, set the Any Numbers to Port to True and also update the
 * Earliest and Latest porting dates if needed.
 *
 * @param  Set<Id> processesIds
 * @author Petar Miletic
 * @ticket SFOM-193, replaces (SFOM-190, SFOM-194)
 * @since  03/02/2017
*/
global class LG_AnalyseNumberPorting implements CSPOFA.ExecutionHandler {

	public List<sObject> process(List<SObject> data)
	{
		List<sObject> result = new List<sObject>();

 		List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;
				
		Set<Id> processesIds = new Set<Id>();
		for (CSPOFA__Orchestration_Step__c step : stepList)
		{
			processesIds.add(step.CSPOFA__Orchestration_Process__c);
		}
		
		// Check number porting
		LG_NumberPorting porting = new LG_NumberPorting();
		porting.checkNumberPorting(processesIds);
		
		for (CSPOFA__Orchestration_Step__c step : stepList)
		{
			//mark step Status, Completed Date
			step.CSPOFA__Status__c = 'Complete';
			step.CSPOFA__Completed_Date__c = Date.today();
			result.add(step);
		}

		return result;
	}
}