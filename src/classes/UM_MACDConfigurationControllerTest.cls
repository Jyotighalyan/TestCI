@isTest
private class UM_MACDConfigurationControllerTest {

	private static String vfBaseUrl   = 'vforce.url';
	private static String sfdcBaseUrl = 'sfdc.url';

	@testsetup
	private static void setupTestData()
	{
		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c      = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		UM_WebserviceCredentials__c setting = new UM_WebserviceCredentials__c();
		setting.Name        = 'UM_TopasWS';
		setting.Login__c    = 'tLogin';
		setting.Password__c = 'tPassword';
		insert setting;

		LG_EnvironmentVariables__c envVariables = new LG_EnvironmentVariables__c();
		envVariables.LG_SalesforceBaseURL__c         = sfdcBaseUrl;
		envVariables.LG_VisualForceBaseURL__c        = vfBaseUrl;
		envVariables.LG_CloudSenceAnywhereIconID__c  = 'csaID';
		envVariables.LG_ServiceAvailabilityIconID__c = 'saIconId';
		insert envVariables;

		LG_MACDSpecificVariables__c macdSpecs = new LG_MACDSpecificVariables__c();
		macdSpecs.LG_SalesChannelsAllowedForTerminate__c = 'someChannel';
		insert macdSpecs;

		csbb__Callout_Service__c httpService = new csbb__Callout_Service__c();
		httpService.Name               = 'RfsCheckCallout';
		httpService.csbb__End_Point__c = 'testendpoint';
		insert httpService;

		List<cscrm__Address__c> addresses = new List<cscrm__Address__c>();
		cscrm__Address__c addressOne = new cscrm__Address__c(
			Name = 'AddressOne',
			cscrm__Street__c = 'Flughafen Allee',
			cscrm__Zip_Postal_Code__c = '28199',
			LG_HouseNumber__c = '25',
			LG_AddressID__c = '123654');
		cscrm__Address__c addressTwo = new cscrm__Address__c(Name = 'AddressTwo');
		addresses.add(addressOne);
		addresses.add(addressTwo);
		insert addresses;

		csordtelcoa__Change_Types__c changeType = new csordtelcoa__Change_Types__c();
		changeType.csordtelcoa__Sort_Order__c = 0;
		changeType.Name                       = 'Change';
		insert changeType;

		csordtelcoa__Change_Types__c changeTypeTerm = new csordtelcoa__Change_Types__c();
		changeTypeTerm.csordtelcoa__Sort_Order__c = 2;
		changeTypeTerm.Name                       = 'Terminate';
		insert changeTypeTerm;

		Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);

		csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
		insert coreq;

		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = coreq.Id, Name = 'Product1',
																csord__Account__c = account.Id, LG_Address__c = addressOne.Id, csordtelcoa__Closed_Replaced__c = false);
		csord__Subscription__c sub2 = new csord__Subscription__c(csord__Identification__c = 'TestIdent2', csord__Order_Request__c = coreq.Id, Name = 'Product2',
																 csord__Account__c = account.Id, LG_Address__c = addressOne.Id, csordtelcoa__Closed_Replaced__c = false);
		insert sub;
		insert sub2;

		Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);

		cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('BAsket58', account, null, opp, false);
		basket.csbb__Account__c = account.Id;
		insert basket;

		cscfga__Product_Definition__c telephonyProdDef = LG_GeneralTest.createProductDefinition('Telephony', true);

		cscfga__Product_Configuration__c telephonyProdConf = LG_GeneralTest.createProductConfiguration('Telephony', 3, basket, telephonyProdDef, true);

		csord__Service__c macdeable = new csord__Service__c(csord__Identification__c = 'macdeable', csord__Order_Request__c = coreq.Id,
															csord__Subscription__c = sub.Id, csordtelcoa__Product_Configuration__c = telephonyProdConf.Id);
		insert macdeable;

		csord__Service__c notMacdabale = new csord__Service__c(csord__Identification__c = 'notMacdabale', csord__Order_Request__c = coreq.Id,
															   csord__Subscription__c = sub2.Id);
		insert notMacdabale;

		cscfga__Product_Category__c prodCatTerm = LG_GeneralTest.createProductCategory('Termination', true);

		cscfga__Product_Definition__c prodDefTerm = LG_GeneralTest.createProductDefinition('Termination', false);
		prodDefTerm.cscfga__Product_Category__c = prodCatTerm.Id;
		insert prodDefTerm;

		noTriggers.Flag__c = false;
		upsert noTriggers;
	}

	private static testmethod void testGetPageController()
	{
		Account account            = [SELECT Id FROM Account WHERE Name = 'Account'];
		csord__Subscription__c sub = [SELECT Id, csord__Identification__c, LG_Address__c
									  FROM csord__Subscription__c WHERE csord__Identification__c = 'TestIdent'];

		PageReference pageRef = Page.UM_MACDConfiguration;
		pageRef.getParameters().put('accountId', account.Id);
		pageRef.getParameters().put('subscriptionId', sub.Id);
		Test.setCurrentPageReference(pageRef);

		Test.startTest();

		UM_MACDConfigurationController controller = new UM_MACDConfigurationController();

		Test.stopTest();

		System.assertEquals(controller, controller.getPageController(), 'Method should return the controller instance');
	}

	private static testmethod void testGetSiteCaption()
	{
		Account account            = [SELECT Id FROM Account WHERE Name = 'Account'];
		csord__Subscription__c sub = [SELECT Id, csord__Identification__c, LG_Address__c
									  FROM csord__Subscription__c WHERE csord__Identification__c = 'TestIdent'];

		String addressJson                              = '{"selectedAddressDisplay":"TestAddress","city":"Amstelveen","postCode":"1183NW","houseNumberExt":"AE","houseNumber":"26","street":"Bankrashof","addressId":"12360"}';
		UM_AddressResponse.OptionalsJson moveSiteObject = (UM_AddressResponse.OptionalsJson)JSON.deserialize(addressJson, UM_AddressResponse.OptionalsJson.class);

		PageReference pageRef = Page.UM_MACDConfiguration;
		pageRef.getParameters().put('accountId', account.Id);
		pageRef.getParameters().put('subscriptionId', sub.Id);
		Test.setCurrentPageReference(pageRef);

		Test.startTest();

		UM_MACDConfigurationController controller = new UM_MACDConfigurationController();
		controller.moveSite = moveSiteObject;

		Test.stopTest();

		System.assertEquals(JSON.serialize(controller.moveSite), controller.moveSiteJson, 'JSon should be the same');
		System.assertEquals(moveSiteObject.selectedAddressDisplay, controller.moveSiteCaption, 'Site Caption should be the same');
	}

	private static testmethod void testRedirectToReturnId()
	{
		Account account            = [SELECT Id FROM Account WHERE Name = 'Account'];
		csord__Subscription__c sub = [SELECT Id, csord__Identification__c, LG_Address__c
									  FROM csord__Subscription__c WHERE csord__Identification__c = 'TestIdent'];

		PageReference pageRef = Page.UM_MACDConfiguration;
		pageRef.getParameters().put('accountId', account.Id);
		pageRef.getParameters().put('subscriptionId', sub.Id);
		Test.setCurrentPageReference(pageRef);

		Test.startTest();

		UM_MACDConfigurationController controller = new UM_MACDConfigurationController();
		pageRef = controller.redirectToReturnId();

		System.assertEquals( sfdcBaseUrl+ '/' + sub.Id, pageRef.getUrl(),
							 'Url should be ' + sfdcBaseUrl + '/' + sub.Id);

		pageRef = Page.UM_MACDConfiguration;
		pageRef.getParameters().put('accountId', account.Id);
		Test.setCurrentPageReference(pageRef);

		controller = new UM_MACDConfigurationController();
		pageRef    = controller.redirectToReturnId();

		Test.stopTest();

		System.assertEquals( sfdcBaseUrl+ '/' + account.Id, pageRef.getUrl(),
							 'Url should be ' + sfdcBaseUrl + '/' + account.Id);
	}

	private static testmethod void testRfsCheck()
	{
		cscrm__Address__c address = [SELECT Id FROM cscrm__Address__c
									 WHERE Name = 'AddressOne'];

		Test.setMock(WebServiceMock.class, new UM_AddressResponseMock());
		UM_AddressResponseMock.resmth = 'searchext';

		Test.startTest();
		LG_MACDConfigurationController.HttpResponseRemoting responseObj = UM_MACDConfigurationController.rfsCheck(address.Id, false);

		Test.stopTest();

		System.assertNotEquals(null, responseObj, 'Response object should not be null');
		System.assertEquals(200, responseObj.statusCode, 'Status code should be 200');
	}

	private static testmethod void testRfsCheckMove()
	{
		String addressJson = '{"selectedAddressDisplay":null,"city":null,"postCode":"28199","houseNumberExt":null,"houseNumber":"25","street":"Flughafen Allee","buildingId":"123654"}';

		Test.setMock(WebServiceMock.class, new UM_AddressResponseMock());
		UM_AddressResponseMock.resmth = 'searchext';

		Test.startTest();
		LG_MACDConfigurationController.HttpResponseRemoting responseObj = UM_MACDConfigurationController.rfsCheck(addressJson, true);

		Test.stopTest();

		system.debug('--+ responseObj: '+responseObj);

		System.assertNotEquals(null, responseObj, 'Response object should not be null');
		System.assertEquals(200, responseObj.statusCode, 'Status code should be 200');
	}

	private static testmethod void testCreateMacdAndProductBasket()
	{
		cscrm__Address__c address = [SELECT Id FROM cscrm__Address__c
									 WHERE Name = 'AddressOne'];
		csord__Subscription__c subscription = [SELECT Id, csord__Identification__c, LG_Address__c
											   FROM csord__Subscription__c WHERE csord__Identification__c = 'TestIdent'];

		Account account = [SELECT Id FROM Account WHERE Name = 'Account'];

		LG_MACDConfigurationController.SitesObj siteObj = new LG_MACDConfigurationController.SitesObj();
		siteObj.sites = new LG_MACDConfigurationController.Site[] {};
		LG_MACDConfigurationController.Site site = new LG_MACDConfigurationController.Site();
		site.id          = address.Id;
		site.rfsResponse = UM_RfsCheckUtility.buildRfsResponse();
		LG_MACDConfigurationController.Sub sub = new LG_MACDConfigurationController.Sub();
		sub.id    = subscription.Id;
		site.subs = new LG_MACDConfigurationController.Sub[] {};
		site.subs.add(sub);
		siteObj.sites.add(site);
		List<LG_MACDConfigurationController.MigrateServices> migrateServices = new List<LG_MACDConfigurationController.MigrateServices>();
		List<LG_MACDConfigurationController.MoveInMoveOutDetails> moveDates  = new List<LG_MACDConfigurationController.MoveInMoveOutDetails>();
		Test.startTest();
		String macdOppId = UM_MACDConfigurationController.createMacdOppAndBasket(JSON.serialize(siteObj), 'Change', account.Id, JSON.serialize(migrateServices), JSON.serialize(moveDates), false);
		Test.stopTest();

		//Only checking for MACD Opportunity as Basket is not created in the test context
		List<Opportunity> opps = [SELECT Id, csordtelcoa__Change_Type__c FROM Opportunity where csordtelcoa__Change_Type__c = 'Change'];
		System.assertEquals(1, opps.size(), 'MACD Opportunity should be created');
		System.assertEquals(opps[0].Id, macdOppId, 'MACD Opportunity Id should be ' + macdOppId);
		System.assertEquals('Change', opps.get(0).csordtelcoa__Change_Type__c, 'MACD Opportunity should be of a Change Type');
	}

	private static testmethod void testCreateMacdAndProductBasketMoveFAiled()
	{
		cscrm__Address__c address = [SELECT Id FROM cscrm__Address__c
									 WHERE Name = 'AddressOne'];
		csord__Subscription__c subscription = [SELECT Id, csord__Identification__c, LG_Address__c
											   FROM csord__Subscription__c WHERE csord__Identification__c = 'TestIdent'];

		Account account = [SELECT Id FROM Account WHERE Name = 'Account'];

		LG_MACDConfigurationController.SitesObj siteObj = new LG_MACDConfigurationController.SitesObj();
		siteObj.sites = new LG_MACDConfigurationController.Site[] {};
		LG_MACDConfigurationController.Site site = new LG_MACDConfigurationController.Site();
		site.id          = address.Id;
		site.rfsResponse = UM_RfsCheckUtility.buildRfsResponse();
		LG_MACDConfigurationController.Sub sub = new LG_MACDConfigurationController.Sub();
		sub.id    = subscription.Id;
		site.subs = new LG_MACDConfigurationController.Sub[] {};
		site.subs.add(sub);
		siteObj.sites.add(site);
		List<LG_MACDConfigurationController.MigrateServices> migrateServices = new List<LG_MACDConfigurationController.MigrateServices>();
		List<LG_MACDConfigurationController.MoveInMoveOutDetails> moveDates  = new List<LG_MACDConfigurationController.MoveInMoveOutDetails>();
		Test.startTest();
		String retMsg = UM_MACDConfigurationController.createMacdOppAndBasket(JSON.serialize(siteObj), 'Move', account.Id, JSON.serialize(migrateServices), JSON.serialize(moveDates), false);
		Test.stopTest();

		System.assertEquals('Move failed', retMsg, 'Move should fail for not having Fiber subs.');
	}

	private static testmethod void testUpdateProductConfigurationAttributes()
	{
		cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'BAsket58'];
		cscrm__Address__c address        = [SELECT Id FROM cscrm__Address__c
											WHERE Name = 'AddressOne'];
		Account account = [SELECT Id FROM Account WHERE Name = 'Account'];

		cscfga__Product_Definition__c prodDef     = LG_GeneralTest.createProductDefinition('ProdDef', true);
		cscfga__Product_Configuration__c prodConf = LG_GeneralTest.createProductConfiguration('ProdConf', 3, basket, prodDef, true);
		cscfga__Attribute_Definition__c attDef    = LG_GeneralTest.createAttributeDefinition('AttDef', prodDef, 'User Input', 'String',
																							 null, null, null, true);

		LG_GeneralTest.createAttribute('Premise Id', attDef, false, null, prodConf, false, address.Id, true);
		LG_GeneralTest.createAttribute('Product Family', attDef, false, null, prodConf, false, 'Internet', true);
		LG_GeneralTest.createAttribute('QoS', attDef, false, null, prodConf, false, '', true);
		LG_GeneralTest.createAttribute('Upload', attDef, false, null, prodConf, false, '', true);
		LG_GeneralTest.createAttribute('Download', attDef, false, null, prodConf, false, '', true);
		LG_GeneralTest.createAttribute('Installation Wish Date', attDef, false, null, prodConf, false, '', true);

		Map<String, String> siteToRfsCommonResponse = new Map<String, String>();
		siteToRfsCommonResponse.put(address.Id, '{"zipCode":"2596AP","street":"JOZEF ISRAELSLAAN","houseNumberExt":"","houseNumber":"4","city":"S-GRAVENHAGE","availability":[{"technology":"HFC","supportingData":[],"limits":[{"up":"30","qos":"Standard","down":"199"}],"capability":"Data"},{"technology":"HFC","supportingData":[],"limits":[{"up":"40","qos":"Standard","down":"200"}],"capability":"Data"},{"technology":"Digital","supportingData":[],"limits":[{"up":"","qos":"Standard","down":""}],"capability":"TV"},{"technology":"Analogue","supportingData":[],"limits":[{"up":"","qos":"Standard","down":""}],"capability":"TV"},{"technology":"Digital","supportingData":[],"limits":[],"capability":"Voice"}]}');

		Set<Id> migratedServices                  = new Set<Id>();
		List<Map<Id, Date>> moveInMoveOutDateList = new List<Map<Id, Date>>();
		Test.startTest();
		UM_MACDConfigurationController.updateProductConfigurationAttributes(basket.Id, siteToRfsCommonResponse, 'Change', account.Id, migratedServices, moveInMoveOutDateList);
		Test.stopTest();

		List<cscfga__Attribute__c> attributes = [SELECT Name, cscfga__Value__c, cscfga__Product_Configuration__c
												 FROM cscfga__Attribute__c
												 WHERE Name IN ('Upload', 'Download', 'Product Family', 'Premise Id', 'QoS')
												 AND cscfga__Product_Configuration__c = :prodConf.Id];

		System.assertEquals(5, attributes.size(), 'Five attributes expected');
		for (cscfga__Attribute__c att : attributes) {
			if (att.Name.equals('Upload')) {
				System.assertEquals('40', att.cscfga__Value__c, '40 should be max upload speed');
			}
			if (att.Name.equals('Download')) {
				System.assertEquals('200', att.cscfga__Value__c, '200 should be max download speed');
			}
			if (att.Name.equals('QoS')) {
				System.assertEquals('Standard', att.cscfga__Value__c, 'QoS should be Standard');
			}
			if (att.Name.equals('Installation Wish Date')) {
				System.assertEquals(null, att.cscfga__Value__c, 'Installation Wish Date should be null');
			}
		}
	}

	private static testmethod void testUpdateProductConfigurationAttributesMove()
	{
		Account account = [SELECT Id FROM Account WHERE Name = 'Account'];

		String addressJson = '{"selectedAddressDisplay":null,"city":"Amstelveen","postCode":"1183NW","houseNumberExt":"AE","houseNumber":"26","street":"Bankrashof","addressId":"12360"}';

		UM_AddressResponse.OptionalsJson moveAddress = (UM_AddressResponse.OptionalsJson)
													   JSON.deserialize(addressJson, UM_AddressResponse.OptionalsJson.class);

		Map<String, Object> addressIdMap = (Map<String, Object>)JSON.deserializeUntyped(
			AddressCheck.setAddress(moveAddress.street, moveAddress.streetNo, moveAddress.streetNoSuffix,
									moveAddress.zip, moveAddress.city, account.Id,
									moveAddress.buildingId, 'Germany',moveAddress.stateOrProvince));

		Id addressId = (Id) addressIdMap.get('SalesforceAddressId');

		cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'BAsket58'];
		cscrm__Address__c address        = [SELECT Id FROM cscrm__Address__c
											WHERE Name = 'AddressOne'];

		cscfga__Product_Definition__c prodDef     = LG_GeneralTest.createProductDefinition('ProdDef', true);
		cscfga__Product_Configuration__c prodConf = LG_GeneralTest.createProductConfiguration('ProdConf', 3, basket, prodDef, true);
		cscfga__Attribute_Definition__c attDef    = LG_GeneralTest.createAttributeDefinition('AttDef', prodDef, 'User Input', 'String',
																							 null, null, null, true);

		LG_GeneralTest.createAttribute('Premise Id', attDef, false, null, prodConf, false, address.Id, true);
		LG_GeneralTest.createAttribute('Product Family', attDef, false, null, prodConf, false, 'Internet', true);
		LG_GeneralTest.createAttribute('QoS', attDef, false, null, prodConf, false, '', true);
		LG_GeneralTest.createAttribute('Upload', attDef, false, null, prodConf, false, '', true);
		LG_GeneralTest.createAttribute('Download', attDef, false, null, prodConf, false, '', true);

		Map<String, String> siteToRfsCommonResponse = new Map<String, String>();
		siteToRfsCommonResponse.put(addressJson, '{"zipCode":"2596AP","street":"JOZEF ISRAELSLAAN","houseNumberExt":"","houseNumber":"4","city":"S-GRAVENHAGE","availability":[{"technology":"HFC","supportingData":[],"limits":[{"up":"30","qos":"Standard","down":"199"}],"capability":"Data"},{"technology":"HFC","supportingData":[],"limits":[{"up":"40","qos":"Standard","down":"200"}],"capability":"Data"},{"technology":"Digital","supportingData":[],"limits":[{"up":"","qos":"Standard","down":""}],"capability":"TV"},{"technology":"Analogue","supportingData":[],"limits":[{"up":"","qos":"Standard","down":""}],"capability":"TV"},{"technology":"Digital","supportingData":[],"limits":[],"capability":"Voice"}]}');

		Set<Id> migratedServices                  = new Set<Id>();
		List<Map<Id, Date>> moveInMoveOutDateList = new List<Map<Id, Date>>();
		Test.startTest();
		UM_MACDConfigurationController.updateProductConfigurationAttributes(basket.Id, siteToRfsCommonResponse, 'Move', account.Id, migratedServices, moveInMoveOutDateList);
		Test.stopTest();

		List<cscfga__Attribute__c> attributes = [SELECT Name, cscfga__Value__c, cscfga__Product_Configuration__c
												 FROM cscfga__Attribute__c
												 WHERE Name IN ('Upload', 'Download', 'Product Family', 'Premise Id', 'QoS')
												 AND cscfga__Product_Configuration__c = :prodConf.Id];

		System.assertEquals(5, attributes.size(), 'Five attributes expected');
		for (cscfga__Attribute__c att : attributes) {
			if (att.Name.equals('Upload')) {
				System.assertEquals('40', att.cscfga__Value__c, '40 should be max upload speed');
			}
			if (att.Name.equals('Download')) {
				System.assertEquals('200', att.cscfga__Value__c, '200 should be max download speed');
			}
			if (att.Name.equals('QoS')) {
				System.assertEquals('Standard', att.cscfga__Value__c, 'QoS should be Standard');
			}
		}
	}

	private static testmethod void testCreateMigrateMacdBasket()
	{
		cscrm__Address__c address = [SELECT Id, LG_FullAddressDetails__c FROM cscrm__Address__c
									 WHERE Name = 'AddressOne'];
		List<csord__Subscription__c> subs = [SELECT Id, csord__Account__c, Name,
											 LG_Address__r.Id, LG_Address__r.LG_FullAddressDetails__c
											 FROM csord__Subscription__c
											 WHERE csord__Identification__c = 'TestIdent' OR csord__Identification__c = 'TestIdent2'
																														ORDER BY LG_Address__r.LG_FullAddressDetails__c];

		Account account = [SELECT Id FROM Account WHERE Name = 'Account'];

		Opportunity opp = [SELECT Id FROM Opportunity WHERE AccountId = :account.Id];

		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c      = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('TestBasket', account, null, opp, false);
		basket.csordtelcoa__Change_Type__c = 'Migrate';
		insert basket;

		noTriggers.Flag__c = false;
		upsert noTriggers;

		Test.startTest();
		LG_MACDConfigurationController.updateMigrateMacdBasket(basket.Id, false, subs);
		Test.stopTest();

		basket = [SELECT Id, csordtelcoa__Change_Type__c, csbb__Account__c,
				  LG_SelectedProducts__c, cscfga__Opportunity__c
				  FROM cscfga__Product_Basket__c WHERE Id = :basket.Id];

		System.assertEquals(opp.Id, basket.cscfga__Opportunity__c, 'Opportunity should be set on the MACD basket');
		System.assertEquals('Migrate', basket.csordtelcoa__Change_Type__c, 'Change Type should be Migrate');
	}

	private static testmethod void testCreateMacdAndProductBasketTerminate()
	{
		cscrm__Address__c address = [SELECT Id FROM cscrm__Address__c
									 WHERE Name = 'AddressOne'];
		csord__Subscription__c subscription = [SELECT Id, csord__Identification__c, LG_Address__c
											   FROM csord__Subscription__c WHERE csord__Identification__c = 'TestIdent'];

		Account account = [SELECT Id FROM Account WHERE Name = 'Account'];

		LG_MACDConfigurationController.SitesObj siteObj = new LG_MACDConfigurationController.SitesObj();
		siteObj.sites = new LG_MACDConfigurationController.Site[] {};
		LG_MACDConfigurationController.Site site = new LG_MACDConfigurationController.Site();
		site.id          = address.Id;
		site.rfsResponse = UM_RfsCheckUtility.buildRfsResponse();
		LG_MACDConfigurationController.Sub sub = new LG_MACDConfigurationController.Sub();
		sub.id    = subscription.Id;
		site.subs = new LG_MACDConfigurationController.Sub[] {};
		site.subs.add(sub);
		siteObj.sites.add(site);

		List<LG_MACDConfigurationController.MigrateServices> migrateServices = new List<LG_MACDConfigurationController.MigrateServices>();
		List<LG_MACDConfigurationController.MoveInMoveOutDetails> moveDates  = new List<LG_MACDConfigurationController.MoveInMoveOutDetails>();

		Test.startTest();
		String macdOppId = UM_MACDConfigurationController.createMacdOppAndBasket(JSON.serialize(siteObj), 'Terminate', account.Id, JSON.serialize(migrateServices), JSON.serialize(moveDates), false);
		Test.stopTest();

		List<Opportunity> opps = [SELECT Id, csordtelcoa__Change_Type__c FROM Opportunity where csordtelcoa__Change_Type__c = 'Terminate'];
		System.assertEquals(1, opps.size(), 'MACD Opportunity should be created');
		System.assertEquals(opps[0].Id, macdOppId, 'MACD Opportunity Id should be ' + macdOppId);
		System.assertEquals('Terminate', opps.get(0).csordtelcoa__Change_Type__c, 'MACD Opportunity should be of a Terminate Type');
	}

	private static testmethod void testNotEligibleForTerminate()
	{
		Account account            = [SELECT Id FROM Account WHERE Name = 'Account'];
		csord__Subscription__c sub = [SELECT Id, csord__Identification__c, LG_Address__c
									  FROM csord__Subscription__c WHERE csord__Identification__c = 'TestIdent'];

		PageReference pageRef = Page.UM_MACDConfiguration;
		pageRef.getParameters().put('accountId', account.Id);
		pageRef.getParameters().put('subscriptionId', sub.Id);
		Test.setCurrentPageReference(pageRef);

		Test.startTest();

		UM_MACDConfigurationController controller = new UM_MACDConfigurationController();

		Test.stopTest();

		for (String ct : controller.changeTypes) {
			System.assertEquals(false, ct.equals('Terminate'), 'No Change type should be terminate');
		}
	}

	private static testmethod void testMoveInMoveOutDate()
	{
		cscrm__Address__c address                                       = [SELECT Id FROM cscrm__Address__c LIMIT 1];
		LG_MACDConfigurationController.MoveInMoveOutDetails moveDetails = new LG_MACDConfigurationController.MoveInMoveOutDetails();
		moveDetails.Id                                                        = address.Id;
		moveDetails.moveInDate                                                = '20-07-2017';
		moveDetails.moveOutDate                                               = '21-07-2017';
		List<LG_MACDConfigurationController.MoveInMoveOutDetails> dateDetails = new List<LG_MACDConfigurationController.MoveInMoveOutDetails>();
		dateDetails.add(moveDetails);
		List<Map<Id, Date>> dateMap = LG_MACDConfigurationController.getMoveInMoveOutDate(dateDetails);
	}

	private static testmethod void testDeleteMigratedConfigs()
	{
		cscfga__Product_Basket__c basket          = [SELECT Id FROM cscfga__Product_Basket__c];
		cscfga__Product_Configuration__c prodConf = [SELECT Id FROM cscfga__Product_Configuration__c WHERE Name = 'Telephony' AND cscfga__Product_Basket__c = :basket.Id];
		System.assertEquals(true, prodConf != null, 'Prod Conf exists');

		Set<Id> prodConfIds = new Set<Id>();
		prodConfIds.add(prodConf.Id);

		LG_MACDConfigurationController.deleteMigratedConfigsCloneAssets(prodConfIds, basket.Id);
		List<cscfga__Product_Configuration__c> prodConfs = [SELECT Id FROM cscfga__Product_Configuration__c WHERE Name = 'Telephony' AND cscfga__Product_Basket__c = :basket.Id];
	}
}