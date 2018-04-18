/**
 * Once the suborder is complete, the process needs to notify the parent order process.
 *
 * Find other suborders processes. Check their statuses. If all statuses = Complete, set Order process status to Complete.
 *
 * @param  Set<Id> processesIds
 * @author Petar Miletic
 * @ticket SFOM-233
 * @since  06/02/2017
 */
global class LG_NotifyOrderProcess implements CSPOFA.ExecutionHandler {

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
	 * Once the suborder is complete, the process needs to notify the parent order process.
	 *
	 * Find other suborders processes. Check their statuses. If all statuses = Complete, set Order process status to Complete.
	 *
	 * @param  Set<Id> processesIds
	 * @author Petar Miletic
	 * @ticket SFOM-233
	 * @since  06/02/2017
	 */
	@TestVisible
	private void notifyOrderProcess(Set<Id> processesIds) {

		csordtelcoa__Orders_Subscriptions_Options__c osOptions = csordtelcoa__Orders_Subscriptions_Options__c.getOrgDefaults();

		Map<Id, Set<Boolean>> orderStatus = new Map<Id, Set<Boolean>>();
		Map<Id, csord__Order__c> orders   = new Map<Id, csord__Order__c>();
		Map<Id, csord__Solution__c> currentSolutions = new Map<Id, csord__Solution__c>();

		// Get all data
		for (CSPOFA__Orchestration_Process__c process : [SELECT Id,
														 LG_Solution__c,
														 LG_Solution__r.csord__Status__c,
														 LG_Solution__r.csord__Order__c,
														 LG_Solution__r.csord__Order__r.csord__Status2__c
														 FROM CSPOFA__Orchestration_Process__c
														 WHERE Id IN :processesIds AND LG_Solution__c != null]) {
			// Populate orders
			if (process.LG_Solution__r.csord__Order__c != null){
				orders.put(process.LG_Solution__r.csord__Order__c, process.LG_Solution__r.csord__Order__r);
			}
			currentSolutions.put(process.LG_Solution__c, process.LG_Solution__r);
		}

    	/**
    	 * Follow on order status is not change to Follow up automatically
    	 *
    	 * Solution: Solution that is currently in process needs to be updated to status Complete
    	 *
    	 * @author Petar Miletic
    	 * @ticket SFOM-563
    	 * @since  27/03/2017
    	 */
        if (!currentSolutions.isEmpty()) {

            for (csord__Solution__c sol :currentSolutions.values()) {
                sol.csord__Status__c = 'Complete';
            }

            update currentSolutions.values();
        }

		// If not empty, continue
		if (!orders.isEmpty()) {

			List<csord__Solution__c> solutions = [SELECT Id,
												  csord__Order__c,
												  csord__Status__c
												  FROM csord__Solution__c
												  WHERE csord__Order__c IN :orders.keySet()
												  AND csord__Order__c != null];
			// All or partial
			for (csord__Solution__c sol :solutions) {

				if (sol.csord__Order__c == null) {
					continue;
				}

				// Create testable map like: {a1c6E0000004Mj9QAE={false, true}, a1c6E0000004MjAQAU={true}}
				if (orderStatus.containsKey(sol.csord__Order__c)) {

					Set<Boolean> tmp = orderStatus.get(sol.csord__Order__c);
					tmp.add(sol.csord__Status__c == 'Complete');

					orderStatus.put(sol.csord__Order__c, tmp);
				} else {
					orderStatus.put(sol.csord__Order__c, new Set<Boolean> { sol.csord__Status__c  == 'Complete' });
				}
			}

			List<csord__Order__c> ordersUpdate = new List<csord__Order__c>();

			// Validate that all linked Solutions are Complete and that Order can be closed as well
			for (csord__Order__c obj :orders.values()) {

				if (orderStatus.isEmpty() || !orderStatus.containsKey(obj.Id)) {
					continue;
				}

				// If there is only one status and it's true
				if (orderStatus.get(obj.Id).size() == 1 && orderStatus.get(obj.Id).contains(true)) {
					obj.csord__Status2__c = osOptions.LG_OrderCompleteStatus__c;
				} else if (orderStatus.get(obj.Id).size() == 2 && orderStatus.get(obj.Id).contains(true)) {
					obj.csord__Status2__c = osOptions.LG_OrderPartiallyCompletedStatus__c;
				}

				ordersUpdate.add(obj);
			}

			// If there is something to update, then update
			if (!ordersUpdate.isEmpty()) {

				update ordersUpdate;
			}
		}
	}
	/**
	 * Populate Service End Date/Start Date on Services (MACD)
	 *
	 * @author Petar Miletic
	 * @ticket SFOM-1035
	 * @since  04/07/2017
	*/
	private List<csord__Service__c> handleMACDDelete(List<csord__Service__c> services, Map<Id, csord__Solution__c> currentSolutions) {

        List<csord__Service__c> subset = new List<csord__Service__c>();
        Map<Id, csord__Solution__c> solutions = new Map<Id, csord__Solution__c>();

        Boolean change = false;

	    for (csord__Service__c obj :services) {

	        change = false;

	        // If MACD Action on a given Service is Delete, copy the Effective Date to End Date.
	        if (obj.csord__Subscription__r.csordtelcoa__Product_Configuration__r.cscfga__Product_Basket__r.cscfga__Opportunity__r.csordtelcoa__Change_Type__c == 'Delete' && obj.LG_EffectiveDate__c != obj.csord__Deactivation_Date__c) {

                obj.csord__Deactivation_Date__c = obj.LG_EffectiveDate__c;
                change = true;
		}

            // For any other MACD Action, copy the Effective Date to Start Date.
	        if (obj.csord__Subscription__r.csordtelcoa__Product_Configuration__r.cscfga__Product_Basket__r.cscfga__Opportunity__r.csordtelcoa__Change_Type__c != 'Delete' && obj.LG_EffectiveDate__c != obj.csord__Activation_Date__c) {

                obj.csord__Activation_Date__c = obj.LG_EffectiveDate__c;
                change = true;
	        }

	        if (change) {
	            subset.add(obj);
		}

	        // Step 700 should automatically populate the Effective Date to the Target date, if for any reason the date was not populated by previous step.
	        if (currentSolutions.containsKey(obj.csord__Solution__c)) {

	             csord__Solution__c sol = currentSolutions.get(obj.csord__Solution__c);

	             if (obj.LG_EffectiveDate__c != sol.LG_TargetDate__c && obj.LG_EffectiveDate__c != null) {

	                 sol.LG_TargetDate__c = obj.LG_EffectiveDate__c;

	                 solutions.put(sol.Id, sol);
	             }
	        }
	    }

	    if (!solutions.values().isEmpty()) {

	        update solutions.values();
	    }

	    return subset;
	}
}