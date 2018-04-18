/**
 * Used as a custom orchestator step.
 * Check if Product requires installation/activtion and the appointment has not already been arranged
 * In that case Schedule Engineer Visit must be created (appointment object with appropriate appointment status)
 * 
 * @author Petar Miletic
 * @ticket SFOM-207
 * @since  21/12/2016
*/
global class LG_RequiresInstallationOrActivation implements CSPOFA.ExecutionHandler {

	public List<sObject> process(List<SObject> data)
	{
		List<sObject> result = new List<sObject>();

 		List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;
				
		Set<Id> processesIds = new Set<Id>();
		for (CSPOFA__Orchestration_Step__c step : stepList)
		{
			processesIds.add(step.CSPOFA__Orchestration_Process__c);
		}
		
		// Check installation
		checkInstallationAndActivation(processesIds);
		
		for (CSPOFA__Orchestration_Step__c step : stepList)
		{
			//mark step Status, Completed Date
			step.CSPOFA__Status__c = 'Complete';
			step.CSPOFA__Completed_Date__c = Date.today();
			result.add(step);
		}

		return result;
	}
	
	/*
	 * Check if Product requires installation/activtion and the appointment has not already been arranged
	 * In that case Schedule Engineer Visit must be created (appointment object with appropriate appointment status)
	*/
	@TestVisible
    private void checkInstallationAndActivation(Set<Id> processesIds) {
        
        Set<Id> serviceIds = new Set<Id>();

		// Get all Service Ids associated with the processes
		for(CSPOFA__Orchestration_Process__c process : [SELECT Id, csordtelcoa__Service__c, LG_Solution__c
		                                                FROM CSPOFA__Orchestration_Process__c 
		                                                WHERE Id IN :processesIds AND LG_Solution__c != null]) 
        {
			serviceIds.add(process.csordtelcoa__Service__c);
		}

        // Get only relevant services
        List<csord__Service__c> services = [SELECT Id, Name, LG_Suborder__c, LG_Suborder__r.Name, 
                                                csordtelcoa__Product_Configuration__r.LG_InstallationNeeded__c
                                                FROM csord__Service__c 
                                                WHERE Id IN :serviceIds 
                                                AND LG_Suborder__r.LG_ActivationNeeded__c = true 
                                                AND csordtelcoa__Product_Configuration__r.LG_InstallationNeeded__c = true];
                                                // TO DD
                                                // LG_ActivationNeeded__c is located on the definition
                                                // service -> Activation Needed, Installation needed
		
        if (services.isEmpty()) {
            return;
        }
        
        Map<Id, csord__Solution__c> solutions = new Map<Id, csord__Solution__c>();
        
        // Get all solutions and set status in advance
        for (csord__Service__c service :services) {
            
            csord__Solution__c sol = service.LG_Suborder__r;
            sol.csord__Status__c = 'Schedule Appointment required!';
            // TO DD
            // Add new field schedule appointment
            
            solutions.put(sol.Id, sol);
        }

		// TO DD
		// Statuses are still undefined (we need to check if it is in correct Status)
        // Filter out all solutions that allready have shceduled appointments
        List<LG_ScheduleAppointment__c> appointments = [SELECT Id, LG_Solution__c, LG_Solution__r.csord__Status__c FROM LG_ScheduleAppointment__c WHERE LG_Solution__c IN :solutions.keySet()];
        
        List<csord__Solution__c> solutionsUpdate = new List<csord__Solution__c>();
        
        // Check Solutions that allready have appoint assigned and remove them from update list
        for (LG_ScheduleAppointment__c app :appointments) {
            
            if (solutions.containsKey(app.LG_Solution__c)) {
                
                solutions.remove(app.LG_Solution__c);
            }
        }
        
        // If all solutions have appointments then this list is empty, If not update
        if (!solutions.values().isEmpty()) {
             update solutions.values()  ;
        }
    }
}