/**
 * 
 * Facade class for Orchestration Process retrieval
 * 
 * @author Petar Miletic
 * @ticket SFOM-1396
 * @since  07/08/2017
*/
public class Milestone_OrchestrationProcessFacade {

	/*
	 * Resolve record type and get data based on that type
	*/
    public static List<CSPOFA__Orchestration_Process__c> getData(Id recordId, String fieldJson){

		// Get Tab Configuration in order to figure out what data to load and how
		String navJson = Milestone_ServiceUIController.getConfig('Milestone Config');
		Milestone_NavigatorConfig setup = Milestone_UtilityHelper.getConfiguration(navJson, true);

		setup.isValid();

		Map<String, Set<String>> fieldSetMap = Milestone_QueryHelper.getFieldSetMap(fieldJson);

		if (Milestone_UtilityHelper.isAccountId(recordId)) 
		{
			return getProcessesForAccount(recordId, fieldSetMap, setup);
		} 
		else if (Milestone_UtilityHelper.isOrderId(recordId)) 
		{
			return getProcessesForOrder(recordId, fieldSetMap, setup);
		} 
		else if (Milestone_UtilityHelper.isSubscriptionId(recordId)) 
		{
			return getProcessesForSubscription(recordId, fieldSetMap, setup);
		} 
		else if (Milestone_UtilityHelper.isServiceId(recordId)) 
		{
			return getProcessesForService(recordId, fieldSetMap, setup);
		} 
		else if (Milestone_UtilityHelper.isSolutionId(recordId) && setup.isSolutionTabEnabled()) 
		{
			return getProcessesForSolution(recordId, fieldSetMap, setup);
		}

		throw new Milestone_OrderNavigatorException('Could not recognise ID type: ' + recordId);
    }

	public static List<CSPOFA__Orchestration_Process__c> getSuborderData(Id recordId, Integer pageOffset, Integer pageLimit, String fieldJson){

		// Get Tab Configuration in order to figure out what data to load and how
		String navJson = Milestone_ServiceUIController.getConfig('Milestone Config');
		Milestone_NavigatorConfig setup = Milestone_UtilityHelper.getConfiguration(navJson, true);

		Map<String, Set<String>> fieldSetMap = Milestone_QueryHelper.getFieldSetMap(fieldJson);

		System.debug('Suborder data -> ' + fieldSetMap);

		if (Milestone_UtilityHelper.isOrderId(recordId)) 
		{
			return getProcessesForSuborders(recordId, fieldSetMap, setup, pageOffset, pageLimit);
		}

		throw new Milestone_OrderNavigatorException('Could not recognise ID type: ' + recordId);
    }
    
    /*
     * Retrieve Process info by Account Id
    */
   	private static List<CSPOFA__Orchestration_Process__c> getProcessesForAccount(Id recordId, Map<String, Set<String>> fieldSetMap, Milestone_NavigatorConfig setup) {
		String query = Milestone_QueryHelper.getProcessesQuery('cspofa__account__c = :recordId', fieldSetMap, setup);
		List<CSPOFA__Orchestration_Process__c> processes = Database.query(query);
		return processes;
	}

    /*
     * Retrieve Process info by Order Id
    */
	private static List<CSPOFA__Orchestration_Process__c> getProcessesForOrder(Id recordId, Map<String, Set<String>> fieldSetMap, Milestone_NavigatorConfig setup) {
		String orderFilter = Milestone_QueryHelper.isLocalOrderRelPresent ? setup.getOrderLookupField() + ' = :recordId AND ' : '';
		String query = Milestone_QueryHelper.getProcessesQuery(orderFilter + 'csordtelcoa__Subscription__c = null AND csordtelcoa__Service__c = null AND LG_Solution__c = null AND LG_Order__c = :recordId  ', fieldSetMap, setup);

		System.debug('getProcessesForOrder: query: ' + query);
		List<CSPOFA__Orchestration_Process__c> processes = Database.query(query);

		return processes;
	}

    /*
     * Retrieve Suborders (Solutions__c) info by Order Id
    */
	private static List<CSPOFA__Orchestration_Process__c> getProcessesForSuborders(Id recordId, Map<String, Set<String>> fieldSetMap, Milestone_NavigatorConfig setup, Integer pageOffset, Integer pageLimit) {

		String orderFilter = Milestone_QueryHelper.isLocalOrderRelPresent(setup) ? setup.getSolutionLookupField() + ' = :recordId ' : '';
		String query = Milestone_QueryHelper.getProcessesQuery(orderFilter, fieldSetMap, setup);

		if (pageOffset != null && pageLimit != null) {
			query += ' LIMIT ' + pageLimit + ' OFFSET ' + pageOffset;
		}

		System.debug('getProcessesForSuborders: query: ' + query);
		List<CSPOFA__Orchestration_Process__c> processes = Database.query(query);
		return processes;
	}

    /*
     * Retrieve Process info by Subscription Id
    */
	private static List<CSPOFA__Orchestration_Process__c> getProcessesForSubscription(Id recordId, Map<String, Set<String>> fieldSetMap, Milestone_NavigatorConfig setup) {
		String query = Milestone_QueryHelper.getProcessesQuery('csordtelcoa__Subscription__c = :recordId AND csordtelcoa__Service__c = null', fieldSetMap, setup);

		System.debug('getProcessesForSubscription: query: ' + query);
		List<CSPOFA__Orchestration_Process__c> processes = Database.query(query);
		return processes;
	}

    /*
     * Retrieve Process info by Service Id
    */
	private static List<CSPOFA__Orchestration_Process__c> getProcessesForService(Id recordId, Map<String, Set<String>> fieldSetMap, Milestone_NavigatorConfig setup) {
		String query = Milestone_QueryHelper.getProcessesQuery('csordtelcoa__Service__c = :recordId', fieldSetMap, setup);

		System.debug('getProcessesForService: query: ' + query);
		List<CSPOFA__Orchestration_Process__c> processes = Database.query(query);
		return processes;
	} 

    /*
     * Retrieve Process info by Solution Id
    */
	private static List<CSPOFA__Orchestration_Process__c> getProcessesForSolution(Id recordId, Map<String, Set<String>> fieldSetMap, Milestone_NavigatorConfig setup) {
		// There is no direct connection between solutions and processes. That's why solution lookup needs to be defined in the setup JSON
		String query = Milestone_QueryHelper.getProcessesQuery(setup.getSolutionLookupField() + ' = :recordId', fieldSetMap, setup);

		System.debug('getProcessesForSolution: query: ' + query);
		List<CSPOFA__Orchestration_Process__c> processes = Database.query(query);
		return processes;
	}
}