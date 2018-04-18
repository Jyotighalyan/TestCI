/**
  * Custom step to manage Follow-On Order
 *
 * @author Petar Miletic
 * @ticket SFOM-408
 * @since  08/02/2017
*/
global class LG_FollowOnOrder implements CSPOFA.ExecutionHandler {

	public List<sObject> process(List<SObject> data)
	{
		List<sObject> result = new List<sObject>();

 		List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;
				
		Set<Id> processesIds = new Set<Id>();
		for (CSPOFA__Orchestration_Step__c step : stepList)
		{
			processesIds.add(step.CSPOFA__Orchestration_Process__c);
		}
		
		// Call method
		updateFollowOnOrders(processesIds);
		
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
	 * Search for all cases where Case Record Type = "Follow-On Order" and Order Id = process.Order Id
	 * 
     * For any such case
     * Change Status from On Hold to Follow-Up
     * Assign Case Owner to process.Order Id.Owner
     * Trigger Notification, so the case owner gets an email
     *
     * @author Petar Miletic
     * @ticket SFOM-408
     * @since  08/02/2017
	*/
	@TestVisible
	private void updateFollowOnOrders(Set<id> processesIds) {
	    
        Set<Id> orderIds = new Set<Id>();

		// Get all data
		for (CSPOFA__Orchestration_Process__c process : [SELECT Id, 
                                                            LG_Order__c
														 FROM CSPOFA__Orchestration_Process__c
														 WHERE Id IN :processesIds AND LG_Order__c != null]) {
														     
            if (!String.isBlank(process.LG_Order__c)) {
	            // Populate orders
	            orderIds.add(process.LG_Order__c);
			}
		}
		
		// Get related cases
		List<Case> cases = [SELECT Id,
                               Status, 
                               OwnerId, 
                               LG_Order__r.OwnerId
                            FROM Case 
                            WHERE LG_Order__c IN :orderIds AND 
                                RecordType.Name = 'Follow-On Order' AND
                                Status = 'On Hold'];
        
        // If not empty update cases
        if (!cases.isEmpty()) {
            
            for (Case obj :cases) {
                
                obj.Status = 'Follow Up';
                obj.OwnerId = obj.LG_Order__r.OwnerId;
            }
            
            // Trigger Notification, so the case owner gets an email
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail = true;
            
            update cases;
        }
	}
}