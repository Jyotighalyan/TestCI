public class LG_OrderTriggerHandler {
	/**
	 * If there is a change in the Order staus field - the orchestrator
	 * Evented Monitor field should be notified.
	 *
	 * @param  List<csord__Order__c> orders
	 * @param  Map<Id, csord__Order__c> oldMap
	 * @author Tomislav Blazek
	 * @ticket SFOM-359
	 * @since  28/2/2017
	 */
	public static void notifyMonitorField(List<csord__Order__c> orders, Map<Id, csord__Order__c> oldMap) {
		Set<Id> eligibleOrderIds = new Set<Id>();

		/*
		 * Decide which orders should be processed:
		 * - only orders that had a change in the csord__Status2__c field
		 */
		for (csord__Order__c newOrder : orders) {
			csord__Order__c oldOrder = oldMap == null ? null : oldMap.get(newOrder.Id);

			if (oldOrder != null && oldOrder.csord__Status2__c != newOrder.csord__Status2__c) {
				eligibleOrderIds.add(newOrder.Id);
			}
		}

		if (!eligibleOrderIds.isEmpty()) {
			CSPOFA.Events.emit('update', eligibleOrderIds);
		}
	}

	/**
	 * If the order was canceled of completed, fire the housekeeping utility
	 * (install base related records will be properly updated).
	 *
	 * @param  List<csord__Order__c> orders
	 * @param  Map<Id, csord__Order__c> oldMap
	 * @author Tomislav Blazek
	 * @ticket SFOM-357
	 * @since  23/3/2017
	 */
	public static void updateInstallBase(List<csord__Order__c> orders, Map<Id, csord__Order__c> oldMap) {
		Set<Id> eligibleOrderIds = new Set<Id>();
		csordtelcoa__Orders_Subscriptions_Options__c osOptions = csordtelcoa__Orders_Subscriptions_Options__c.getOrgDefaults();

		/*
		 * Decide which orders should be processed:
		 * - orders that had a change in the status to be complete/canceled
		 */
		for (csord__Order__c newOrder : orders) {
			csord__Order__c oldOrder = oldMap == null ? null : oldMap.get(newOrder.Id);

			if (oldOrder != null && oldOrder.csord__Status2__c != newOrder.csord__Status2__c
				&& (newOrder.csord__Status2__c == osOptions.LG_OrderCompleteStatus__c || newOrder.csord__Status2__c == osOptions.LG_OrderCanceledStatus__c)) {
				eligibleOrderIds.add(newOrder.Id);
			}
		}

		if (!eligibleOrderIds.isEmpty()) {
			if (!System.isBatch() && !System.isFuture()) {
				updateInstallBaseStatusesFuture(eligibleOrderIds);
			} else
			{
				updateInstallBaseStatuses(eligibleOrderIds);
			}
		}
	}

	private static void updateInstallBaseStatuses(Set<Id> orderIds)
	{
		LG_InstallBaseUtil util = new LG_InstallBaseUtil(orderIds);
		util.updateInstallBaseStatuses();
	}

	@future
	private static void updateInstallBaseStatusesFuture(Set<Id> orderIds)
	{
		updateInstallBaseStatuses(orderIds);
	}
}