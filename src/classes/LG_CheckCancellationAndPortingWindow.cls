/**
 * Check if Order has been cancelled or changed or appointment is beyond 
 * the porting window
 * 
 * @author Petar Miletic
 * @ticket SFOM-208
 * @since  22/12/2016
*/
global class LG_CheckCancellationAndPortingWindow implements CSPOFA.ExecutionHandler {

	public List<sObject> process(List<SObject> data)
	{
		List<sObject> result = new List<sObject>();

 		List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;
				
		Set<Id> processesIds = new Set<Id>();
		for (CSPOFA__Orchestration_Step__c step : stepList)
		{
			processesIds.add(step.CSPOFA__Orchestration_Process__c);
		}
		
		// Invoke method with step logic
		checkCancellationAndPortingWindow(processesIds);
		
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
	 * Check if Order has been cancelled or changed or appointment is beyond the porting window
	*/
	@TestVisible
    private void checkCancellationAndPortingWindow(Set<Id> processesIds) {
        
        Map<Id, csord__Solution__c> solutions = new Map<Id, csord__Solution__c>();

		// Get all Service Ids associated with the process
		for(CSPOFA__Orchestration_Process__c process : [SELECT Id, 
		                                                    LG_Solution__c, 
    		                                                LG_Solution__r.LG_AnyNumbersToPort__c, 
    		                                                LG_Solution__r.LG_EarliestPortingWishDate__c, 
    		                                                LG_Solution__r.LG_LatestPortingWishDate__c,
    		                                                LG_Solution__r.LG_OrderChanged__c,
    		                                                LG_Solution__r.LG_OrderCancelled__c,
    		                                                csordtelcoa__Service__c,
    		                                                csordtelcoa__Service__r.LG_InstallationPlannedDate__c
		                                                FROM CSPOFA__Orchestration_Process__c 
		                                                WHERE Id IN :processesIds AND LG_Solution__c != null]) 
        {
			solutions.put(process.LG_Solution__c, process.LG_Solution__r);
		}

        // Get list of assets for given services
        List<Asset> assets = [SELECT Id, Name, 
                                    csord__Service__r.LG_Suborder__c, 
                                    csord__Service__r.LG_Suborder__r.Id, 
                                    csord__Service__r.LG_InstallationPlannedDate__c
                                FROM Asset 
                                WHERE csord__Service__r.LG_Suborder__c IN :solutions.keySet() 
                                    AND LG_Asset__r.RecordType.Name = 'Number Block' 
                                    AND LG_NumberRangeType__c = 'Port-In'];
                            
        if (assets.isEmpty()) {
            return;
        }
        
        // Filter out all solutions that allready have shceduled appointments
        List<LG_ScheduleAppointment__c> appointments = [SELECT Id, LG_Solution__c, LG_AgreedInstallDate__c, LG_Solution__r.csord__Status__c FROM LG_ScheduleAppointment__c WHERE LG_Solution__c IN :solutions.keySet()];
        
        Map<Id, csord__Solution__c> solutionsToUpdate = new Map<Id, csord__Solution__c>();
        
        for (csord__Solution__c sol :solutions.values()) {
            
            if (sol.LG_OrderChanged__c || sol.LG_OrderCancelled__c) {
                
                // Update solution and don't check porting dates
                solutionsToUpdate.put(sol.Id, sol);
                continue;
            }
            
            // Check if date is outside porting window
            if (!dateIsWithinPortingWindow(sol, appointments)) {
                
                // Update solution
                solutionsToUpdate.put(sol.Id, sol);
                continue;
            }
        }
        
        if (!solutionsToUpdate.isEmpty()) {
            System.debug('Start update...');
            // TO DD
            // Field to update is undefined at this moment
            // and the process will probably change
            // Add new field -> Porting Date Requires change

            //update solutionsToUpdate.values();
        }
    }
    
    /*
     * Check if installation date is inside porting window 
    */
    private Boolean dateIsWithinPortingWindow(csord__Solution__c sol, List<LG_ScheduleAppointment__c> appointments) {
        
        LG_ScheduleAppointment__c appointment = getAppointment(sol.Id, appointments);
        
        if (appointment == null) {
            return true;
        }
        
        return (appointment.LG_AgreedInstallDate__c >= sol.LG_EarliestPortingWishDate__c && appointment.LG_AgreedInstallDate__c <= sol.LG_LatestPortingWishDate__c);
    }
    
    /*
     * Get appointment by Solution Id
    */
    private LG_ScheduleAppointment__c getAppointment(Id solutionId, List<LG_ScheduleAppointment__c> appointments) {
        
        LG_ScheduleAppointment__c obj = null;
        
        for (LG_ScheduleAppointment__c app :appointments) {
            
            if (app.LG_Solution__c == solutionId) {
                obj = app;
                break;
            }
        }
        
        return obj;
    }
}