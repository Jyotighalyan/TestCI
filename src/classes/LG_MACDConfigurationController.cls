/**
 * Used as a controller for LG_MACDConfigurationController VF page.
 *
 * @author Tomislav Blazek
 * @ticket SFDT-204
 * @since  22/02/2016
 */
public abstract with sharing class LG_MACDConfigurationController {

	public Account account {get; set;}
	public csord__Subscription__c subscription {get; set;}
	public List<csord__Subscription__c> subscriptions {get; set;}
	public List<cscrm__Address__c> sites {get; set;}
	public Map<Id, List<csord__Subscription__c>> siteToSubsMap {get; set;}
	public List<String> changeTypes {get; set;}
	public Boolean validateAddress {get; set;}
	public String validateSiteId {get; set;}
	public Date moveInDate {get; set;}
	public Date moveOutDate {get; set;}
	public Id accountId {get; set;}

	private Id returnId;

	public void prepareValidateVariables(){
	}

	public LG_MACDConfigurationController() {
		accountId = ApexPages.currentPage().getParameters().get('accountId');
		Id subscriptionId = ApexPages.currentPage().getParameters().get('subscriptionId');

		returnId = accountId;

		if (String.isNotBlank(subscriptionId)) {
			subscription = [SELECT Id, Name FROM csord__Subscription__c
							WHERE Id = :subscriptionId];

			returnId = subscriptionId;
		}

		account = [SELECT Id, Name, LG_VisitPostalCode__c, LG_VisitStreet__c, LG_VisitCity__c,
				   LG_VisitHouseNumber__c, LG_VisitHouseNumberExtension__c
				   FROM Account WHERE Id = :accountId];

		prepareSubscriptions();

		Set<Id> siteIds = new Set<Id>();
		siteToSubsMap   = new Map<Id, List<csord__Subscription__c>>();

		for (csord__Subscription__c sub : subscriptions) {
			siteIds.add(sub.LG_Address__c);
			if (!siteToSubsMap.containsKey(sub.LG_Address__r.Id)) {
				siteToSubsMap.put(sub.LG_Address__r.Id, new List<csord__Subscription__c>());
			}
			siteToSubsMap.get(sub.LG_Address__r.Id).add(sub);
		}

		sites = [SELECT Id, LG_AddressID__c, LG_FullAddressDetails__c, cscrm__Street__c,
				 cscrm__Zip_Postal_Code__c, LG_HouseNumber__c, cscrm__City__c
				 FROM cscrm__Address__c
				 WHERE Id IN :siteIds
				 ORDER BY LG_FullAddressDetails__c];

		//fetch the Change Types from Custom Settings
		changeTypes = new List<String>();

		List<ChangeTypesWrapper> changeTypesW = new List<ChangeTypesWrapper>();

		for (csordtelcoa__Change_Types__c changeType : csordtelcoa__Change_Types__c.getAll().values()) {
			if (!changeType.LG_AvailableOnMACDPage__c) {
				continue;
			}

			//User not eligible for initiating the Terminate process should not see the Terminate
			//change type in the dropdown
			if (changeType.Name == 'Terminate' && !isUserEligibleForTerminate()) {
				continue;
			}

			changeTypesW.add(new ChangeTypesWrapper(changeType));
		}
		//sort by order Type
		changeTypesW.sort();

		for (ChangeTypesWrapper ct : changeTypesW) {
			changeTypes.add(ct.changeType.Name);
		}
	}

	private abstract void prepareSubscriptions();

	/**
	 * Method checks the user Sales Channel and if the channel is eligible for
	 * initiating the Terminate process.
	 * @return {Boolean}  true if user is allowed to initiate Terminate process
	 * @author Tomislav Blazek
	 * @ticket SFDT-1198
	 * @since  2016-07-07
	 */
	@TestVisible
	private boolean isUserEligibleForTerminate()
	{
		boolean eligibleForTermination = false;

		if (LG_Util.getSalesChannelsForTerminate().size() == 0) {
			eligibleForTermination = true;
		} else {
			String userSalesChannel = LG_Util.getCurrentUserSalesChannel();

			for (String eligibleSalesChannel : LG_Util.getSalesChannelsForTerminate()) {
				if (eligibleSalesChannel.equals(userSalesChannel)) {
					eligibleForTermination = true;
					break;
				}
			}
		}
		return eligibleForTermination;
	}

	//back to return Id
	public PageReference redirectToReturnId() {
		PageReference newocp = new PageReference(LG_Util.getSalesforceBaseUrl() + '/' + returnId);

		return newocp;
	}

	public static Set<String> getMigrateVarieties(){
		return LG_Util.getMigrateVarietyChangeTypes();
	}

	/**
	 * filter Move-in, Move-out dates
	 * @author Minhaj Alam
	 * @ticket SFOM-377
	 * @since  08/06/2017
	 */
	public static List<Map<Id, Date>> getMoveInMoveOutDate(List<MoveInMoveOutDetails> moveInMoveOutDetails)
	{
		Map<Id, Date> moveInDetails               = new Map<Id, Date>();
		Map<Id, Date> moveOutDetails              = new Map<Id, Date>();
		List<Map<Id, Date>> moveInMoveOutDateList = new List<Map<Id, Date>>();

		for (MoveInMoveOutDetails dates : moveInMoveOutDetails) {
			Id siteId             = dates.id;
			Date moveInWishDate   = null;
			Date moveOutWishDate  = null;
			String moveInDateStr  = dates.moveInDate;
			String moveOutDateStr = dates.moveOutDate;
			//date is in dd-mm-yyyy format so we should create a new instance properly formatted
			moveInWishDate = Date.newInstance(Integer.valueOf(moveInDateStr.split('-')[2]),
											  Integer.valueOf(moveInDateStr.split('-')[1]),
											  Integer.valueOf(moveInDateStr.split('-')[0]));

			moveOutWishDate = Date.newInstance(Integer.valueOf(moveOutDateStr.split('-')[2]),
											   Integer.valueOf(moveOutDateStr.split('-')[1]),
											   Integer.valueOf(moveOutDateStr.split('-')[0]));


			moveInDetails.put(siteId, moveInWishDate);
			moveOutDetails.put(siteId, moveOutWishDate);
		}
		moveInMoveOutDateList.add(moveInDetails);
		moveInMoveOutDateList.add(moveOutDetails);
		system.debug('moveInMoveOutDateList :'+moveInMoveOutDateList);
		return moveInMoveOutDateList;
	}

	//@future
	public static void deleteMigratedConfigsCloneAssets(Set<Id> deleteConfIds, Id macdBasketId)
	{
		LG_CloneAssetsUtil.cloneUsingProductBasketId(macdBasketId);
		delete [SELECT Id FROM cscfga__Product_Configuration__c WHERE Id IN:deleteConfIds];
		//delete [SELECT Id FROM csbb__Product_Configuration_Request__c WHERE csbb__Product_Basket__c = : macdBasketId
		//																							  AND (csbb__Product_Configuration__c IN: deleteConfIds
		//
		delete [SELECT Id FROM csbb__Product_Configuration_Request__c WHERE csbb__Product_Basket__c = : macdBasketId
																									  AND (csbb__Product_Configuration__c IN: deleteConfIds
																										   OR csbb__Product_Configuration__c = null)];
	}

	/**
	 * Creates the related terminate products.
	 * It also creates the records of the csordtelcoa__Subscr_MACDProductBasket_Association__c object
	 * that holds the relation between old subscriptions and the new Terminate MACD basket.
	 * Terminate Product configs have to be created by using future method, as it calls the API and it
	 * uses a lot of SOQLs... 101 error appears when having multiple subscriptions.
	 *
	 * @param  Id basketId - Id of MACD Terminate Basket
	 * @author Tomislav Blazek
	 * @ticket SFDT-85
	 * @since  8/6/2016
	 */
	public static void createTerminateProductConfigs(Id basketId, List<csord__Subscription__c> subscriptions)
	{
		for (csord__Subscription__c sub : subscriptions) {
			createTerminateProductConfigsFuture(basketId, sub.Id);
		}
	}

	@future
	private static void createTerminateProductConfigsFuture(Id basketId, Id subscriptionId)
	{
		cscfga__Product_Definition__c prodDef = [SELECT Id, cscfga__Product_Category__c FROM cscfga__Product_Definition__c WHERE Name = 'Termination'];
		cscfga__Product_Basket__c basket      = [SELECT Id, LG_BasketNumber__c FROM cscfga__Product_Basket__c WHERE Id = :basketId];
		csord__Subscription__c sub            = [SELECT Id, Name, LG_Address__c, LG_Site__c, csconta__Billing_Account__c FROM csord__Subscription__c WHERE Id = :subscriptionId];

		cscfga.API_1.ApiSession api            = new cscfga.API_1.ApiSession(prodDef);
		cscfga.ProductConfiguration rootConfig = api.getRootConfiguration();
		cscfga.Attribute attribute             = rootConfig.getAttribute('Product Name');
		if (attribute != null) {
			attribute.setValue('Terminate ' + sub.Name);
		}

		attribute = rootConfig.getAttribute('Premise Id');
		if (attribute != null) {
			attribute.setValue(sub.LG_Address__c);
		}

		attribute = rootConfig.getAttribute('Site Id');
		if (attribute != null) {
			attribute.setValue(sub.LG_Site__c);
		}

		attribute = rootConfig.getAttribute('Basket Number');
		if (attribute != null) {
			attribute.setValue(basket.LG_BasketNumber__c);
		}

		attribute = rootConfig.getAttribute('Terminated Subscription Id');
		if (attribute != null) {
			attribute.setValue(sub.Id);
		}

		attribute = rootConfig.getAttribute('Terminated Product');
		if (attribute != null) {
			attribute.setValue(sub.Id);
			attribute.setDisplayValue(sub.Name);
		}

		api.updateConfig();
		api.persistConfiguration();

		List<cscfga__Product_Configuration__c> prodConfs = [SELECT Id, cscfga__Product_Basket__c, cscfga__Product_Basket__r.Id,
															LG_InstallationClass__c, LG_InstallationLeadTime__c, LG_InstallationNeeded__c,
															LG_Address__c, LG_Address__r.Id, LG_Address__r.cscrm__City__c,
															LG_Address__r.cscrm__Zip_Postal_Code__c, LG_Address__r.LG_HouseNumberExtension__c,
															LG_Address__r.LG_HouseNumber__c, LG_Address__r.cscrm__Street__c,
															LG_Address__r.LG_AddressID__c, LG_Address__r.cscrm__State_Province__c,
															LG_Address__r.cscrm__Geolocation__Latitude__s, LG_Address__r.cscrm__Geolocation__Longitude__s,
															csordtelcoa__Replaced_Subscription__c,
															(SELECT Name, cscfga__Value__c,
															 cscfga__Product_Configuration__c
															 FROM cscfga__Attributes__r
															 WHERE Name IN ('Installation Lead Time', 'Installation Class',
																			'Installation Needed'))
															FROM cscfga__Product_Configuration__c
															WHERE Id = :rootConfig.getId()];

		Set<cscfga__Product_Basket__c> basketsToDelete                = new Set<cscfga__Product_Basket__c>();
		List<csbb__Product_Configuration_Request__c> prodReqsToInsert = new List<csbb__Product_Configuration_Request__c>();
		for (cscfga__Product_Configuration__c prodConf : prodConfs) {
			basketsToDelete.add(prodConf.cscfga__Product_Basket__r);
			prodConf.cscfga__Product_Basket__c             = basketId;
			prodConf.LG_ChangeType__c                      = 'Terminate';
			prodConf.Name                                  = 'Terminate ' + sub.Name;
			prodConf.csordtelcoa__Replaced_Subscription__c = sub.Id;

			for (cscfga__Attribute__c att : prodConf.cscfga__Attributes__r) {
				if (att.Name == 'Installation Lead Time') {
					Decimal leadtime = att.cscfga__Value__c != null ? Decimal.valueOf(att.cscfga__Value__c) : 0;
					prodConf.LG_InstallationLeadTime__c = leadTime;
				} else if (att.Name == 'Installation Class') {
					prodConf.LG_InstallationClass__c = att.cscfga__Value__c;
				} else if (att.Name == 'Installation Needed') {
					prodConf.LG_InstallationNeeded__c = Boolean.valueOf(att.cscfga__Value__c);
				}
			}

			csbb__Product_Configuration_Request__c pcr = new csbb__Product_Configuration_Request__c(csbb__Product_Basket__c = basketId,
																									csbb__Product_Configuration__c = prodConf.Id,
																									csbb__Product_Category__c = prodDef.cscfga__Product_Category__c);
			if (prodConf.LG_Address__r != null) {
				pcr.csbb__Optionals__c = JSON.serialize(new LG_AddressResponse.OptionalsJson(prodConf.LG_Address__r));
			}
			prodReqsToInsert.add(pcr);
		}

		if (!basketsToDelete.isEmpty()) {
			delete new List<cscfga__Product_Basket__c>(basketsToDelete);
		}

		for (cscfga__Product_Configuration__c prodConf : prodConfs) {
			prodConf.LG_Billing_Account__c = sub.csconta__Billing_Account__c;
		}

		update prodConfs;
		insert prodReqsToInsert;
	}

	/**
	 * Creates a Terminate MACD Basket.
	 *
	 * @param  Id macdOpportunity - Id of MACD Opportunity
	 * @author Tomislav Blazek
	 * @ticket SFDT-85
	 * @since  7/6/2016
	 */
	public static Id createTerminateMacdBasket(Id macdOpportunity)
	{
		Opportunity opp = [SELECT Id, AccountId
						   FROM Opportunity
						   WHERE Id = :macdOpportunity];

		cscfga__Product_Basket__c macdBasket = new cscfga__Product_Basket__c();
		macdBasket.csbb__Account__c            = opp.AccountId;
		macdBasket.cscfga__Opportunity__c      = opp.Id;
		macdBasket.csordtelcoa__Change_Type__c = 'Terminate';
		macdBasket.Name                        = 'Mac basket: ' + DateTime.now();
		insert macdBasket;

		return macdBasket.Id;
	}

	/**
	 * Populates the LG_SelectedProducts__c field on the Product Basket that holds the
	 * migrated product/subscription names.
	 * Populates the LG_MigratedServicesIds__c field on the Basket so that the observer could
	 * delete configurations that are migrated.
	 *
	 * @param  Id basketId - Id of MACD Basket
	 * @param  List<csord__Subscription__c> subscriptions - subscriptions that are being migrated
	 * @param  List<MigrateServices> migrationServices - services that were set as migrate/change on MACD
	 *                                                 config screen
	 * @author Tomislav Blazek
	 * @ticket SFOM-401
	 * @since  24/5/2017
	 */
	public static void updateMigrateMacdBasket(Id basketId, Boolean isDowngrade, List<csord__Subscription__c> subscriptions)
	{
		String currentProducts = '';

		Map<cscrm__Address__c, List<csord__Subscription__c>> siteToSubsMap = new Map<cscrm__Address__c, List<csord__Subscription__c>>();
		for (csord__Subscription__c sub : subscriptions) {
			if (!siteToSubsMap.containsKey(sub.LG_Address__r)) {
				siteToSubsMap.put(sub.LG_Address__r, new List<csord__Subscription__c>());
			}
			siteToSubsMap.get(sub.LG_Address__r).add(sub);
		}

		for (cscrm__Address__c site : siteToSubsMap.keySet()) {
			currentProducts += site.LG_FullAddressDetails__c;
			currentProducts += '\r\n';

			for (csord__Subscription__c sub : siteToSubsMap.get(site)) {
				currentProducts += '   - ' + sub.Name + '\r\n';
			}
		}
         // added code for OMB-1976 to not populate product name in basket in opportunity
		update new cscfga__Product_Basket__c(Id = basketId, LG_SelectedProducts__c = currentProducts, LG_Downgrade__c = isDowngrade, cscfga__Products_In_Basket__c = null);
	}

	public static void insertSubBasketRelations(Id macdBasket, List<csord__Subscription__c> subscriptions, List<Map<Id, Date>> moveInMoveOutDateList)
	{
		List<csordtelcoa__Subscr_MACDProductBasket_Association__c> subBasketRelations
			= new List<csordtelcoa__Subscr_MACDProductBasket_Association__c>();
		for (csord__Subscription__c sub : subscriptions) {
			//SFOM-377 save move-out date to junction object
			csordtelcoa__Subscr_MACDProductBasket_Association__c junction = new csordtelcoa__Subscr_MACDProductBasket_Association__c();
			if (!moveInMoveOutDateList.isEmpty()) {
				junction.LG_DeactivationWishDate__c = moveInMoveOutDateList.get(1).get(sub.LG_Address__c);
			}
			junction.csordtelcoa__Subscription__c   = sub.Id;
			junction.csordtelcoa__Product_Basket__c = macdBasket;

			subBasketRelations.add(junction);
		}
		insert subBasketRelations;
	}

	public static void insertSubOppRelations(Id macdOpp, List<csord__Subscription__c> subscriptions)
	{
		List<csordtelcoa__Subscription_MACDOpportunity_Association__c> subOppRelations
			= new List<csordtelcoa__Subscription_MACDOpportunity_Association__c>();
		for (csord__Subscription__c sub : subscriptions) {
			subOppRelations.add(new csordtelcoa__Subscription_MACDOpportunity_Association__c(csordtelcoa__Subscription__c = sub.Id,
																							 csordtelcoa__Opportunity__c = macdOpp));
		}
		insert subOppRelations;
	}

	public class SitesObj {
		public Site[] sites;
	}

	public class Sub {
		public String id;
	}


	public class Site {
		public String id;
		public Sub[] subs;
		public String rfsResponse;
	}

	public class HttpResponseRemoting {
		public Integer statusCode;
		public String respBody;
	}

	public class ChangeTypesWrapper implements Comparable {
		public csordtelcoa__Change_Types__c changeType;

		// Constructor
		public ChangeTypesWrapper(csordtelcoa__Change_Types__c ct) {
			changeType = ct;
		}

		// Compare changeTypes based on the sort order value.
		public Integer compareTo(Object compareTo) {
			// Cast argument to ChangeTypesWrapper
			ChangeTypesWrapper compareToCt = (ChangeTypesWrapper)compareTo;

			// The return value of 0 indicates that both elements are equal.
			Integer returnValue = 0;
			if (changeType.csordtelcoa__Sort_Order__c > compareToCt.changeType.csordtelcoa__Sort_Order__c) {
				// Set return value to a positive value.
				returnValue = 1;
			} else if (changeType.csordtelcoa__Sort_Order__c < compareToCt.changeType.csordtelcoa__Sort_Order__c) {
				// Set return value to a negative value.
				returnValue = -1;
			}

			return returnValue;
		}
	}

	/**
	 * Checks if subscription has inactive product
	 *
	 * @param  String selectedSites
	 * @return boolean
	 * @author Minhaj Alam
	 * @ticket - SFOM-532
	 * @since  21/3/2017
	 */
	@RemoteAction
	public static boolean subscriptionContainsInactiveProduct(String selectedSites)
	{
		Set<Id> subsIds = new Set<Id>();
		SitesObj sitesObj = (SitesObj) JSON.deserialize(selectedSites, LG_MACDConfigurationController.SitesObj.class);
		for (Site site : sitesObj.sites) {
			for (Sub sub : site.subs) {
				subsIds.add(sub.id);
			}
		}

		List<csord__Subscription__c> subscriptions = [SELECT Id,
													  (SELECT Id,
													   csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.cscfga__Active__c
													   FROM csord__Services__r)
													  FROM csord__Subscription__c
													  WHERE Id IN :subsIds];

		for (csord__Subscription__c sub : subscriptions) {
			for (csord__Service__c service : sub.csord__Services__r) {
				if (!service.csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.cscfga__Active__c) {
					return true;
				}
			}
		}

		return false;
	}


	/**
	 * MACD Migrate
	 *
	 * @author Petar Miletic
	 * @story SFOM-785
	 * @since  22/05/2017
	 */
	public class MigrateServices
	{
		public String Id { get; set; }
		public Boolean Change { get; set; }
		public Boolean Discontinued { get; set; }
	}

	/**
	 * MACD Move
	 *
	 * @author Minhaj Alam
	 * @story SFOM-377
	 * @since  09/06/2017
	 */
	public class MoveInMoveOutDetails
	{
		public String Id { get; set; }
		public String moveInDate { get; set; }
		public String moveOutDate { get; set; }
	}
}