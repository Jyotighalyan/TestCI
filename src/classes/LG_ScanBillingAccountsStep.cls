/**
* Used as a custom orchestator step.
* Scans all the Billing Account records related
* to the solution being processed.
* Stamps the 'New Billing' flag on the solution,
* so that further conditions in the process can use it.
* 
* @author Tomislav Blazek
* @ticket SFOM-43
* @since  15/11/2016
*/
global class LG_ScanBillingAccountsStep implements CSPOFA.ExecutionHandler {
	
	public List<sObject> process(List<SObject> data)
	{
		List<sObject> result = new List<sObject>();
		//collect the data for all steps passed in, if needed
		//process steps
 		List<CSPOFA__Orchestration_Step__c> stepList =
			(List<CSPOFA__Orchestration_Step__c>)data;
				
		Set<Id> processesIds = new Set<Id>();
		for (CSPOFA__Orchestration_Step__c step : stepList)
		{
			processesIds.add(step.CSPOFA__Orchestration_Process__c);
		}
		
		checkBillingAccounts(processesIds);
		
		for (CSPOFA__Orchestration_Step__c step : stepList)
		{
			//mark step Status, Completed Date
			step.CSPOFA__Status__c = 'Complete';
			step.CSPOFA__Completed_Date__c = Date.today();
			result.add(step);
		}

		return result;
	}

	/**
	 * Scans the Billing Accounts related to the processes/solutions being
	 * executed/processed and checks whether Billing Accounts of the ICOMS
	 * external system don't have external Id set.
	 * If that's the case, flag 'New Billing' on the related solution will 
	 * be set to true.
	 * 
	 * @param  Set<Id> processesIds
	 * @author Tomislav Blazek
	 * @ticket SFOM-43
	 * @since  15/11/2016
	 */
	@TestVisible
	private void checkBillingAccounts(Set<Id> processesIds)
	{
		Set<Id> solutionsIds = new Set<Id>();
		for(CSPOFA__Orchestration_Process__c process : [SELECT LG_Solution__c
														FROM CSPOFA__Orchestration_Process__c
														WHERE Id IN :processesIds
														AND LG_Solution__c != null])
		{
			solutionsIds.add(process.LG_Solution__c);
		}
		 
		Map<Id, csord__Solution__c> solutionsToUpdate = new Map<Id, csord__Solution__c>();
		 
		for(csord__Service_Line_Item__c sli : [SELECT LG_BillingAccount__r.LG_ExternalSystem__c,
														LG_BillingAccount__r.LG_ExternalId__c,
														LG_BillingAccount__c,
														csord__Service__r.LG_Suborder__c
												FROM csord__Service_Line_Item__c
												WHERE csord__Service__r.LG_Suborder__c IN :solutionsIds])
		{
		    system.debug('-----abc'+ sli);
	 		if (sli.LG_BillingAccount__c != null && sli.LG_BillingAccount__r.LG_ExternalSystem__c == 'ICOMS'
				&& String.isBlank(sli.LG_BillingAccount__r.LG_ExternalId__c)
				&& !solutionsToUpdate.containsKey(sli.csord__Service__r.LG_Suborder__c))
			{
			    
				solutionsToUpdate.put(sli.csord__Service__r.LG_Suborder__c,
										new csord__Solution__c(Id = sli.csord__Service__r.LG_Suborder__c,
																LG_NewBilling__c = true));
			}
		}
		
		if (!solutionsToUpdate.isEmpty())
		{
			update solutionsToUpdate.values();
		}
	}
}