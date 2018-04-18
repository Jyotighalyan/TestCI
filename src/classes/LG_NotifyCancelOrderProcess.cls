/**
 * Once the all suborder are canceled Order is canceled as well
 *
 * Find other suborders processes. Check their statuses. If all statuses = Cancel, set Order process status to Cancel.
 *
 * @param  Set<Id> processesIds
 * @author Petar Miletic
 * @ticket SFOM-556
 * @since  23/03/2017
 */
global class LG_NotifyCancelOrderProcess implements CSPOFA.ExecutionHandler {

	public List<sObject> process(List<SObject> data)
	{
		List<sObject> result = new List<sObject>();

		List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;

		Set<Id> processesIds = new Set<Id>();
		for (CSPOFA__Orchestration_Step__c step : stepList) {
			processesIds.add(step.CSPOFA__Orchestration_Process__c);
		}

		// Call method
		notifyOrderProcess(processesIds);

		for (CSPOFA__Orchestration_Step__c step : stepList) {
			//mark step Status, Completed Date
			step.CSPOFA__Status__c         = 'Complete';
			step.CSPOFA__Completed_Date__c = Date.today();
			result.add(step);
		}

		return result;
	}

	/**
	 * Once the all suborders are canceled, the process needs to notify the parent order process.
	 *
	 * Find other suborders processes. Check their statuses. If all statuses = Canceled, set Order process status to Canceled.
	 *
	 * @param  Set<Id> processesIds
	 * @author Petar Miletic
	 * @ticket SFOM-556
	 * @since  23/03/2017
	 */
	@TestVisible
	private void notifyOrderProcess(Set<Id> processesIds) {

		csordtelcoa__Orders_Subscriptions_Options__c osOptions = csordtelcoa__Orders_Subscriptions_Options__c.getOrgDefaults();

		Map<Id, Set<Boolean>> orderStatus = new Map<Id, Set<Boolean>>();
		Map<Id, csord__Order__c> orders   = new Map<Id, csord__Order__c>();
		List<csord__Solution__c> currentSolutions = new List<csord__Solution__c>();

		// Get all data
		for (CSPOFA__Orchestration_Process__c process : [SELECT Id,
														 LG_Solution__c,
														 LG_Solution__r.csord__Order__c,
														 LG_Solution__r.csord__Order__r.csord__Status2__c
														 FROM CSPOFA__Orchestration_Process__c
														 WHERE Id IN :processesIds AND LG_Solution__c != null]) {
			// Populate orders
			orders.put(process.LG_Solution__r.csord__Order__c, process.LG_Solution__r.csord__Order__r);
			currentSolutions.add(process.LG_Solution__r);
		}
		
		/*
		 * Enforce Solutions state model - In Progress, Complete, Cancelled
		 *
		 * @author Petar Miletić
		 * @ticket SFOM-571
		 * @since  03/04/2017
		*/
        if (!currentSolutions.isEmpty()) {
            
            for (csord__Solution__c sol :currentSolutions) {
                sol.csord__Status__c = 'Cancelled';
            }
            
            update currentSolutions;
        }

		// If not empty, continue
		if (!orders.isEmpty()) {

			List<csord__Solution__c> solutions = [SELECT Id,
												  csord__Order__c,
												  csord__Status__c
												  FROM csord__Solution__c
												  WHERE csord__Order__c IN :orders.keySet()];
			// All or partial
			for (csord__Solution__c sol :solutions) {

				if (sol.csord__Order__c == null) {
					continue;
				}

				// Create testable map like: {a1c6E0000004Mj9QAE={false, true}, a1c6E0000004MjAQAU={true}}
				if (orderStatus.containsKey(sol.csord__Order__c)) {

					Set<Boolean> tmp = orderStatus.get(sol.csord__Order__c);
					tmp.add(sol.csord__Status__c == 'Cancelled');

					orderStatus.put(sol.csord__Order__c, tmp);
				} else {
					orderStatus.put(sol.csord__Order__c, new Set<Boolean> { sol.csord__Status__c  == 'Cancelled' });
				}
			}

			List<csord__Order__c> ordersUpdate = new List<csord__Order__c>();

			// Validate that all linked Solutions are Complete and that Order can be closed as well
			for (csord__Order__c obj :orders.values()) {

				if (orderStatus.isEmpty() || !orderStatus.containsKey(obj.Id)) {
					continue;
				}

				// If all statuses are true. Size == 1 becouse it contains only true
				if (orderStatus.get(obj.Id).size() == 1 && orderStatus.get(obj.Id).contains(true)) {
					obj.csord__Status2__c = osOptions.LG_OrderCanceledStatus__c;
				} 

				ordersUpdate.add(obj);
			}

			// If there is something to update, then update
			if (!ordersUpdate.isEmpty()) {

				update ordersUpdate;
			}
		}
	}
}