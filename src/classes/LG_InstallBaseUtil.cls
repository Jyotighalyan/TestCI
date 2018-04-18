/**
 * Used as a utility class for Install Base updates.
 * Once the order is being completed / canceled, the install base
 * should be properly updated.
 * Statuses of services, subscriptions, related assets, and related/replaced
 * services, subscriptions should be updated.
 *
 * @author Tomislav Blazek
 * @ticket SFOM-499
 * @since  13/3/2017
 */
public class LG_InstallBaseUtil {

	private Set<Id> orderIds;
	private List<csord__Order__c> cancelOrders;
	private List<csord__Order__c> completeOrders;
	private Map<Id, csord__Subscription__c> subsToUpdate;
	private Map<Id, csord__Service__c> servicesToUpdate;
	private Map<Id, csord__Service_Line_Item__c> slisToDelete;
	private csordtelcoa__Orders_Subscriptions_Options__c osOptions;

	public LG_InstallBaseUtil(Set<Id> orderIds)
	{
		this.orderIds = orderIds;
		osOptions     = csordtelcoa__Orders_Subscriptions_Options__c.getOrgDefaults();
	}

	public void updateInstallBaseStatuses()
	{
		prepareData();

		if (!cancelOrders.isEmpty()) {
			processCancelOrders();
		}
		if (!completeOrders.isEmpty()) {
			processCompleteOrders();
		}

		if (!servicesToUpdate.isEmpty()){
			update servicesToUpdate.values();
		}
		if (!subsToUpdate.isEmpty()){
			update subsToUpdate.values();
		}

		if (!slisToDelete.isEmpty()) {
			delete slisToDelete.values();
		}

		if (!servicesToUpdate.isEmpty()) {
			updateAssets();
		}
	}

	private void prepareData()
	{
		cancelOrders   = new List<csord__Order__c>();
		completeOrders = new List<csord__Order__c>();

		for (csord__Order__c order : [SELECT Id, csord__Status2__c, csordtelcoa__Opportunity__c,
									  (SELECT Id, csord__Status__c, csord__Subscription__c, csord__Subscription__r.csordtelcoa__Replaced_Subscription__c,
									   csord__Subscription__r.csord__Status__c, csordtelcoa__Replaced_Service__c, csord__Subscription__r.csordtelcoa__Change_Type__c,
									   csordtelcoa__Replaced_Service__r.Id, csordtelcoa__Replaced_Service__r.csord__Status__c,
									   csordtelcoa__Replaced_Service__r.csord__Subscription__c,
									   csordtelcoa__Replaced_Service__r.csord__Subscription__r.csord__Status__c,
									   csordtelcoa__Replaced_Service__r.csord__Subscription__r.csordtelcoa__Replacement_Subscription__c
									   FROM csord__Services__r)
									  FROM csord__Order__c
									  WHERE Id IN :orderIds]) {
			if (order.csord__Status2__c == osOptions.LG_OrderCompleteStatus__c) {
				completeOrders.add(order);
			} else if (order.csord__Status2__c == osOptions.LG_OrderCanceledStatus__c) {
				cancelOrders.add(order);
			}
		}

		subsToUpdate     = new Map<Id, csord__Subscription__c>();
		servicesToUpdate = new Map<Id, csord__Service__c>();
		slisToDelete     = new Map<Id, csord__Service_Line_Item__c>();
	}

	private void processCompleteOrders()
	{
		Set<Id> replacedServiceIds          = new Set<Id>();
		Set<Id> replacedSubscriptionIds     = new Set<Id>();
		Set<Id> oppIds                      = new Set<Id>();
		List<csord__Service__c> newServices = new List<csord__Service__c>();

		for (csord__Order__c order : completeOrders) {
			oppIds.add(order.csordtelcoa__Opportunity__c);
			for (csord__Service__c service : order.csord__Services__r) {
				if (service.csord__Status__c == 'Active' || service.csord__Status__c == 'Inactive' || service.csord__Status__c == 'Closed Replaced'){
					continue;
				}
				newServices.add(service);
				//SFOM-1786 We do not treat move as closed replaced - but as New+Terminate
			//if (service.csord__Subscription__r.csordtelcoa__Change_Type__c != 'Move') {
					replacedSubscriptionIds.add(service.csord__Subscription__r.csordtelcoa__Replaced_Subscription__c);
				//}
			}
		}

		//requested for termination should be set to inactive
		updateRequestedForTermination(replacedSubscriptionIds, oppIds, true);

		//activate the new ones and close replace the old ones
		for (csord__Service__c newService : newServices) {
			if (newService.csordtelcoa__Replaced_Service__r != null) {
				//SFOM-1786 We do not treat move as closed replaced - but as New+Terminate - so setting the old one to Inactive
				/*if (newService.csord__Subscription__r.csordtelcoa__Change_Type__c == 'Move') {
					newService.csordtelcoa__Replaced_Service__r.csord__Status__c                        = osOptions.LG_ServiceDeactivatedStatus__c;
					newService.csordtelcoa__Replaced_Service__r.csord__Subscription__r.csord__Status__c = osOptions.LG_ServiceDeactivatedStatus__c;
				} else {
					newService.csordtelcoa__Replaced_Service__r.csord__Status__c                        = osOptions.csordtelcoa__Subscription_Closed_Replaced_State__c;
					newService.csordtelcoa__Replaced_Service__r.csord__Subscription__r.csord__Status__c = osOptions.csordtelcoa__Subscription_Closed_Replaced_State__c;
				}*/
				newService.csordtelcoa__Replaced_Service__r.csord__Status__c                        = osOptions.csordtelcoa__Subscription_Closed_Replaced_State__c;
				newService.csordtelcoa__Replaced_Service__r.csord__Subscription__r.csord__Status__c = osOptions.csordtelcoa__Subscription_Closed_Replaced_State__c;
    			servicesToUpdate.put(newService.csordtelcoa__Replaced_Service__r.Id, newService.csordtelcoa__Replaced_Service__r);
				subsToUpdate.put(newService.csordtelcoa__Replaced_Service__r.csord__Subscription__c, newService.csordtelcoa__Replaced_Service__r.csord__Subscription__r);
			}

			newService.csord__Status__c                        = 'Active';
			newService.csord__Subscription__r.csord__Status__c = 'Active';
			servicesToUpdate.put(newService.Id, newService);
			subsToUpdate.put(newService.csord__Subscription__c, newService.csord__Subscription__r);
		}
	}

	private void processCancelOrders()
	{
		Set<Id> replacedServiceIds          = new Set<Id>();
		Set<Id> replacedSubscriptionIds     = new Set<Id>();
		Set<Id> oppIds                      = new Set<Id>();
		List<csord__Service__c> newServices = new List<csord__Service__c>();

		for (csord__Order__c order : cancelOrders) {
			oppIds.add(order.csordtelcoa__Opportunity__c);
			for (csord__Service__c service : order.csord__Services__r) {
				if (service.csord__Status__c == 'Active' || service.csord__Status__c == 'Inactive' || service.csord__Status__c == 'Closed Replaced'){
					continue;
				}
				newServices.add(service);
				//SFOM-1786 We do not treat move as closed replaced - but as New+Terminate
				//if (service.csord__Subscription__r.csordtelcoa__Change_Type__c != 'Move') {
					replacedSubscriptionIds.add(service.csord__Subscription__r.csordtelcoa__Replaced_Subscription__c);
				//}
			}
		}

		//requested for termination should be reverted to active
		updateRequestedForTermination(replacedSubscriptionIds, oppIds, false);

		//cancel the new ones and revert the old ones
		for (csord__Service__c newService : newServices) {
			if (newService.csordtelcoa__Replaced_Service__r != null) {
				newService.csordtelcoa__Replaced_Service__r.csordtelcoa__Replacement_Service__c                             = null;
				newService.csordtelcoa__Replaced_Service__r.csordtelcoa__Replacement_Product_Configuration__c               = null;
				newService.csordtelcoa__Replaced_Service__r.csord__Status__c                                                = 'Active';
				newService.csordtelcoa__Replaced_Service__r.csord__Subscription__r.csord__Status__c                         = 'Active';
				newService.csordtelcoa__Replaced_Service__r.csord__Subscription__r.csordtelcoa__Replacement_Subscription__c = null;
				servicesToUpdate.put(newService.csordtelcoa__Replaced_Service__r.Id, newService.csordtelcoa__Replaced_Service__r);
				subsToUpdate.put(newService.csordtelcoa__Replaced_Service__r.csord__Subscription__c, newService.csordtelcoa__Replaced_Service__r.csord__Subscription__r);
			}

			newService.csord__Status__c                                             = osOptions.LG_OrderCanceledStatus__c;
			newService.csordtelcoa__Replaced_Service__c                             = null;
			newService.csord__Subscription__r.csord__Status__c                      = osOptions.LG_OrderCanceledStatus__c;
			newService.csord__Subscription__r.csordtelcoa__Replaced_Subscription__c = null;
			servicesToUpdate.put(newService.Id, newService);
			subsToUpdate.put(newService.csord__Subscription__c, newService.csord__Subscription__r);
		}
	}

	private void updateRequestedForTermination(Set<Id> replacedSubscriptionIds, Set<Id> oppIds, Boolean terminate)
	{
		Set<Id> subIdsFromJunction = new Set<Id>();

		//fetch the subscription ids from the junction object - to have a full set of all old subscription ids that were involved in the
		//MACD process
		for (csordtelcoa__Subscription_MACDOpportunity_Association__c junction : [SELECT csordtelcoa__Subscription__c
																				  FROM csordtelcoa__Subscription_MACDOpportunity_Association__c
																				  WHERE csordtelcoa__Opportunity__c IN :oppIds]) {
			subIdsFromJunction.add(junction.csordtelcoa__Subscription__c);
		}

		//populate a set of subscription ids that were deleted from the basket (old subscription ids will not be contained in the
		//replaced subscription ids set)
		Set<Id> subIdsForUpdate = new Set<Id>();
		for (Id subId : subIdsFromJunction) {
			if (!replacedSubscriptionIds.contains(subId)) {
				subIdsForUpdate.add(subId);
			}
		}

		if (!subIdsForUpdate.isEmpty()) {
			List<csord__Service__c> services = [SELECT Id, csord__Status__c, LG_Action__c,
												csord__Subscription__r.csordtelcoa__Replacement_Subscription__c,
												csord__Subscription__r.csord__Status__c,
												csordtelcoa__Replacement_Service__c, csord__Subscription__c,
												csordtelcoa__Replacement_Product_Configuration__c,
												(SELECT Id, LG_IsPenaltyFee__c FROM csord__Service_Line_Items__r WHERE LG_IsPenaltyFee__c = true)
												FROM csord__Service__c
												WHERE csord__Subscription__c IN :subIdsForUpdate
												AND csord__Status__c NOT IN ('Active', 'Inactive', 'Closed Replaced')];

			if (!services.isEmpty()) {
				for (csord__Service__c service : services) {
					service.csord__Subscription__r.csord__Status__c = terminate ? osOptions.LG_ServiceDeactivatedStatus__c : 'Active';
					if (!terminate) {
						service.csord__Subscription__r.csordtelcoa__Replacement_Subscription__c = null;
						service.csordtelcoa__Replacement_Service__c                             = null;
						service.csordtelcoa__Replacement_Product_Configuration__c               = null;
					}
					service.csord__Status__c = terminate ? osOptions.LG_ServiceDeactivatedStatus__c : 'Active';

					servicesToUpdate.put(service.Id, service);
					subsToUpdate.put(service.csord__Subscription__c, service.csord__Subscription__r);

					//In case termination order is cancelled, and there were some penalty fees reparented to the service being terminated,
					//we must remove these service line items.
					if (!terminate) {
						for (csord__Service_Line_Item__c sli : service.csord__Service_Line_Items__r) {
							slisToDelete.put(sli.Id, sli);
						}
					}
				}
			}
		}
	}

	//update the Assets status - Active if related service is active, inactive if related service is inactive.
	private void updateAssets(){
		List<Asset> assetsToUpdate = new List<Asset>();

		for (Asset asset : [SELECT Id, Status, csord__Service__c, csord__Service__r.csord__Status__c,
							LG_TelephonyService__c, LG_TelephonyService__r.csord__Status__c,
							LG_NumberRangeService__c, LG_NumberRangeService__r.csord__Status__c
							FROM Asset
							WHERE csord__Service__c IN :servicesToUpdate.keySet()
							OR LG_TelephonyService__c IN :servicesToUpdate.keySet()
							OR LG_NumberRangeService__c IN :servicesToUpdate.keySet()]) {
			if (servicesToUpdate.containsKey(asset.csord__Service__c)) {
				asset.Status = asset.csord__Service__r.csord__Status__c;
				assetsToUpdate.add(asset);
			} else if (servicesToUpdate.containsKey(asset.LG_NumberRangeService__c)) {
				asset.Status = asset.LG_NumberRangeService__r.csord__Status__c;
				assetsToUpdate.add(asset);
			} else if (servicesToUpdate.containsKey(asset.LG_TelephonyService__c)) {
				asset.Status = asset.LG_TelephonyService__r.csord__Status__c;
				assetsToUpdate.add(asset);
			}
		}

		if (!assetsToUpdate.isEmpty()) {
			update assetsToUpdate;
		}
	}
}