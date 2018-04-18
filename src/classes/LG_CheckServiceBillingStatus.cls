/**
 * Check billing status for services
 * 
 * @author Petar Miletic
 * @ticket SFOM-189
 * @since  22/12/2016
*/
global class LG_CheckServiceBillingStatus implements CSPOFA.ExecutionHandler {

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
		checkServiceBillingStatus(processesIds);
		
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
	 * Check if there is at least one service with active billing
	*/
	@TestVisible
    private void checkServiceBillingStatus(Set<Id> processesIds) {
        
        Map<Id, csord__Service__c> services = new Map<Id, csord__Service__c>();
        Map<Id, csord__Solution__c> solutions = new Map<Id, csord__Solution__c>();
        
		// Get all Service Ids associated with the process
		for(CSPOFA__Orchestration_Process__c process : [SELECT Id, 
		                                                    LG_Solution__c, 
		                                                    LG_Solution__r.Name,
    		                                                csordtelcoa__Service__c,
    		                                                csordtelcoa__Service__r.csord__Status__c,
    		                                                csordtelcoa__Service__r.LG_Suborder__c
		                                                FROM CSPOFA__Orchestration_Process__c 
		                                                WHERE Id IN :processesIds AND LG_Solution__c != null]) 
        {
            services.put(process.csordtelcoa__Service__c, process.csordtelcoa__Service__r);
			solutions.put(process.LG_Solution__c, process.LG_Solution__r);
		}
		
        /* Maybe SLI need to be checked. This is unclear for now
        List<csord__Service_Line_Item__c> slis = [SELECT Id, Name, csord__Is_Active__c, 
                                                        csord__Service__c, 
                                                        csord__Service__r.csord__Status__c, 
                                                        csord__Service__r.csord__Activation_Date__c 
                                                        csord__Service__r.csord__Solution__c 
                                                    FROM csord__Service_Line_Item__c 
                                                    WHERE csord__Service__c IN :services.keySet() 
                                                    AND csord__Is_Active__c = true
                                                    AND csord__Service__r.csord__Status__c = 'Active'];
        */
        
        Map<Id, csord__Solution__c> solutionsMap = new Map<Id, csord__Solution__c>();
        
        // Check if service is active. 
        // If even one service is active then start billing
        for (csord__Service__c service : services.values()) {
            
            // Just one service with start date set to today or before today
            // Start billing
            if (service.csord__Status__c == 'Active') {
                
                csord__Solution__c sol = solutions.get(service.LG_Suborder__c);
                
                if (sol != null) {
                    
                    // TO DO
                    // Add field that will be used as flag (maype partial billing)
                    // Update solution and add it to the list
                    solutionsMap.put(sol.Id, sol);
                }
                
            }
        }
        
        // Update solution
        if (!solutionsMap.values().isEmpty()) {
            update solutionsMap.values();
        }
    }
}