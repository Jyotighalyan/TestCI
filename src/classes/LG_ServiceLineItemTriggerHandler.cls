public class LG_ServiceLineItemTriggerHandler
{
	/**
	* If SLA service line item on Internet product is created/updated,
	* and there are related products
	* (Zakelijk Hosted Bellen, Multi Wifi, PIN Zeker) on the same Site,
	* method clones the Internet SLA service line item on these services
	*
	* @param  List<csord__Service_Line_Item__c> lineItems
	* @param  Map<Id, csord__Service_Line_Item__c> oldMap
	* @author Tomislav Blazek
	* @ticket SFDT-525
	* @since  18/3/2016
	*/
	
	//Commenting out as per UMR-1051
	/*
	public static void cloneSlaLineItem(List<csord__Service_Line_Item__c> lineItems, Map<Id, csord__Service_Line_Item__c> oldMap)
	{
		List<csord__Service_Line_Item__c> slaLineItems = new List<csord__Service_Line_Item__c>();
		Set<Id> servicesForChecking = new Set<Id>();

		for (csord__Service_Line_Item__c lineItem : lineItems)
		{
			csord__Service_Line_Item__c oldLineItem = oldMap == null ? null : oldMap.get(lineItem.Id);

			if (lineItem.LG_AddOnType__c == 'SLA'
		        && (oldLineItem == null || (oldLineItem.LG_ExternalDescription__c != lineItem.LG_ExternalDescription__c)))
		    {
				servicesForChecking.add(lineItem.csord__Service__c);
				slaLineItems.add(lineItem);
			}
		}

		if (!servicesForChecking.isEmpty())
		{
			Map<Id, csord__Service__c> internetServices = new Map<Id, csord__Service__c>();
			Set<Id> addresses = new Set<Id>();

			for (csord__Service__c internetService : [SELECT Id, LG_Address__c FROM csord__Service__c
			        WHERE LG_ProductFamily__c in ('Company Fiber', 'Office Internet', 'Company Internet', 'Wholesale Fiber') 
													 AND Id IN :servicesForChecking])
			{
				internetServices.put(internetService.Id, internetService);
				addresses.add(internetService.LG_Address__c);
			}

			Map<csord__Service_Line_Item__c, csord__Service__c> eligibleLineItems = new Map<csord__Service_Line_Item__c, csord__Service__c>();
			for(csord__Service_Line_Item__c lineItem : slaLineItems)
			{
				if (internetServices.containsKey(lineItem.csord__Service__c))
				{
					eligibleLineItems.put(lineItem, internetServices.get(lineItem.csord__Service__c));
				}
			}

			if (!eligibleLineItems.isEmpty())
			{
				List<csord__Service__c> relatedServices = [SELECT Id, LG_Address__c,
                                                            (SELECT Id, Name, csord__Identification__c, csord__Is_Adhoc__c,
                                                            csord__Is_Recurring__c, csord__Line_Description__c,
                                                            csord__Order_Request__c, LG_BillingAccount__c,
                                                            LG_ServiceLineItemExternalId__c, LG_Quantity__c, LG_ExternalServiceName__c,
                                                            LG_ExternalPriceName__c, LG_ExternalDescription__c, LG_Type__c,
                                                            LG_AddOnType__c, LG_ToBeSent__c, Do_Not_Sync_with_Billing__c 
                                                            FROM csord__Service_line_Items__r
                                                            WHERE LG_AddOnType__c = 'SLA')
                                                            FROM csord__Service__c
                                                            WHERE LG_Address__c IN :addresses
                                                            AND csord__Status__c NOT IN (:LG_Util.getServiceDeactivatedStatus(), :LG_Util.getServiceRequestDeactivateStatus())
                                                            AND LG_ProductFamily__c IN ('Business Voice','WLAN','Office Phone')];

				List<csord__Service_Line_Item__c> slaLinesToUpsert = new List<csord__Service_Line_Item__c>();
				for(csord__Service_Line_Item__c intSlaLineItem : eligibleLineItems.keySet())
				{
					csord__Service__c internetService = eligibleLineItems.get(intSlaLineItem);

					for(csord__Service__c relatedService : relatedServices)
					{
						if (relatedService.LG_Address__c == internetService.LG_Address__c)
						{
							Id relatedSlaItemId = null;
							if (!relatedService.csord__Service_line_Items__r.isEmpty())
							{
								relatedSlaItemId = relatedService.csord__Service_line_Items__r[0].Id;
							}

							slaLinesToUpsert.add(new csord__Service_Line_Item__c(Id = relatedSlaItemId, Name = intSlaLineItem.Name,
							                     csord__Identification__c = intSlaLineItem.csord__Identification__c,
							                     csord__Is_Adhoc__c = intSlaLineItem.csord__Is_Adhoc__c,
							                     csord__Is_Recurring__c = intSlaLineItem.csord__Is_Recurring__c,
							                     csord__Line_Description__c = intSlaLineItem.csord__Line_Description__c,
							                     csord__Service__c = relatedService.Id,
                                                 Do_Not_Sync_with_Billing__c = intSlaLineItem.Do_Not_Sync_with_Billing__c,                                
							                     csord__Order_Request__c = intSlaLineItem.csord__Order_Request__c,
							                     LG_BillingAccount__c = intSlaLineItem.LG_BillingAccount__c,
							                     LG_ServiceLineItemExternalId__c = intSlaLineItem.LG_ServiceLineItemExternalId__c,
							                     LG_Quantity__c = intSlaLineItem.LG_Quantity__c,
							                     LG_ExternalServiceName__c = intSlaLineItem.LG_ExternalServiceName__c,
							                     LG_ExternalPriceName__c = intSlaLineItem.LG_ExternalPriceName__c,
							                     LG_ExternalDescription__c = intSlaLineItem.LG_ExternalDescription__c,
							                     LG_Type__c = intSlaLineItem.LG_Type__c, LG_AddOnType__c = intSlaLineItem.LG_AddOnType__c,
																					LG_ToBeSent__c = intSlaLineItem.LG_ToBeSent__c));
						}
					}
				}

				if (!slaLinesToUpsert.isEmpty())
				{
					upsert slaLinesToUpsert;
				}
			}
		}
	}*/
	public static void updateBillingAccount(Map<Id, csord__Service_Line_Item__c> lineItemsMap)
	{
		Set<Id> lineItemIds = new Set<Id>();
		for(csord__Service_Line_Item__c slItem : lineItemsMap.values()){
			if(slItem.LG_BillingAccount__c == null){
				lineItemIds.add(slItem.Id);
			}
		}
		if(!lineItemIds.isEmpty()){
			List<csord__Service_Line_Item__c> lineItems = 
			[
				SELECT Id, LG_BillingAccount__c, csord__Service__r.csord__Subscription__r.csconta__Billing_Account__r.Id
				FROM csord__Service_Line_Item__c
				WHERE Id IN: lineItemIds
			];
			for(csord__Service_Line_Item__c sli : lineItems){
				sli.LG_BillingAccount__c = sli.csord__Service__r.csord__Subscription__r.csconta__Billing_Account__r.Id;
			}
			update lineItems;
		}
		
	}
}