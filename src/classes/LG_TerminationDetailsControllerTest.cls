@isTest
private class LG_TerminationDetailsControllerTest {

	private static String vfBaseUrl   = 'vforce.url';
	private static String sfdcBaseUrl = 'sfdc.url';
	private static Date wishDate      = Date.newInstance(2016, 3, 20);
	private static Date plannedDate   = Date.newInstance(2016, 3, 18);

	@testsetup
	private static void setupTestData()
	{
		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c      = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		LG_EnvironmentVariables__c envVariables = new LG_EnvironmentVariables__c();
		envVariables.LG_SalesforceBaseURL__c         = sfdcBaseUrl;
		envVariables.LG_VisualForceBaseURL__c        = vfBaseUrl;
		envVariables.LG_CloudSenceAnywhereIconID__c  = 'csaID';
		envVariables.LG_ServiceAvailabilityIconID__c = 'saIconId';
		insert envVariables;

		LG_TerminationSpecificVariables__c termSpecifics = new LG_TerminationSpecificVariables__c();
		termSpecifics.LG_NumberOfToleratedDays__c = 30;
		insert termSpecifics;

		List<cscrm__Address__c> addresses = new List<cscrm__Address__c>();
		cscrm__Address__c addressOne = new cscrm__Address__c(Name = 'AddressOne');
		cscrm__Address__c addressTwo = new cscrm__Address__c(Name = 'AddressTwo');
		addresses.add(addressOne);
		addresses.add(addressTwo);
		insert addresses;

		Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);

		Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);

		cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('BAsket58', account, null, opp, false);
		basket.csbb__Account__c            = account.Id;
		basket.csordtelcoa__Change_Type__c = 'Terminate';
		insert basket;

		csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
		insert coreq;

		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = coreq.Id, Name = 'Product1',
																csord__Account__c = basket.csbb__Account__c, LG_Address__c = addressOne.Id, csordtelcoa__Closed_Replaced__c = false);
		csord__Subscription__c sub2 = new csord__Subscription__c(csord__Identification__c = 'TestIdent2', csord__Order_Request__c = coreq.Id, Name = 'Product2',
																 csord__Account__c = basket.csbb__Account__c, LG_Address__c = addressOne.Id, csordtelcoa__Closed_Replaced__c = false);
		insert sub;
		insert sub2;

		List<csordtelcoa__Subscr_MACDProductBasket_Association__c> subBasketRelations
			= new List<csordtelcoa__Subscr_MACDProductBasket_Association__c>();
		subBasketRelations.add(new csordtelcoa__Subscr_MACDProductBasket_Association__c(csordtelcoa__Subscription__c = sub.Id,
																						csordtelcoa__Product_Basket__c = basket.Id));
		subBasketRelations.add(new csordtelcoa__Subscr_MACDProductBasket_Association__c(csordtelcoa__Subscription__c = sub2.Id,
																						csordtelcoa__Product_Basket__c = basket.Id));
		insert subBasketRelations;

		cscfga__Product_Definition__c prodDef = LG_GeneralTest.createProductDefinition('Termination', false);
		prodDef.LG_ProductSubtype__c = 'Termination';
		insert prodDef;

		List<cscfga__Product_Configuration__c> prodConfs = new List<cscfga__Product_Configuration__c>();
		cscfga__Product_Configuration__c prodConf = LG_GeneralTest.createProductConfiguration('ProdConf58', 3, basket, prodDef, false);
		prodConf.LG_Address__c                         = addressOne.Id;
		prodConf.LG_InstallationWishDate__c            = Date.today();
		prodConf.csordtelcoa__Replaced_Subscription__c = sub.Id;

		cscfga__Product_Configuration__c prodConf1 = LG_GeneralTest.createProductConfiguration('ProdConf581', 3, basket, prodDef, false);
		prodConf1.LG_Address__c                         = addressOne.Id;
		prodConf1.LG_InstallationNeeded__c              = true;
		prodConf1.csordtelcoa__Replaced_Subscription__c = sub2.Id;

		cscfga__Product_Configuration__c prodConf2 = LG_GeneralTest.createProductConfiguration('ProdConf582', 3, basket, prodDef, false);
		prodConf2.LG_Address__c = addressTwo.Id;

		cscfga__Product_Configuration__c prodConf3 = LG_GeneralTest.createProductConfiguration('ProdConf5823', 3, basket, prodDef, false);
		prodConf3.LG_Address__c = addressTwo.Id;

		prodConfs.add(prodConf);
		prodConfs.add(prodConf1);
		prodConfs.add(prodConf2);
		prodConfs.add(prodConf3);
		insert prodConfs;

		csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestTelServ', csord__Order_Request__c = coreq.Id,
														  csord__Subscription__c = sub.Id, csordtelcoa__Product_Configuration__c = prodConf.Id);
		insert service;

		cscfga__Attribute_Definition__c attDef = LG_GeneralTest.createAttributeDefinition('AttDef', prodDef, 'User Input', 'String',
																						  null, null, null, true);
		LG_GeneralTest.createAttribute('Installation Wish Date', attDef, false, null, prodConf, false, null, true);

		noTriggers.Flag__c = false;
		upsert noTriggers;
	}

	private static testmethod void testRedirectToReturnId()
	{
		cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'BAsket58'];
		Account account                  = [SELECT Id FROM Account WHERE Name = 'Account'];

		PageReference pageRef = Page.LG_TerminationDetails;
		pageRef.getParameters().put('basketId', basket.Id);
		pageRef.getParameters().put('returnId', account.Id);
		Test.setCurrentPageReference(pageRef);

		Test.startTest();

		LG_TerminationDetailsController controller = new LG_TerminationDetailsController();
		pageRef = controller.redirectToReturnId();

		Test.stopTest();

		System.assertEquals( sfdcBaseUrl+ '/' + account.Id, pageRef.getUrl(),
							 'Url should be ' + sfdcBaseUrl + '/' + account.Id);
	}

	private static testmethod void testSave()
	{
		cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'BAsket58'];
		cscrm__Address__c addressOne     = [SELECT Id FROM cscrm__Address__c WHERE Name = 'AddressOne'];
		Set<Id> subIds = new Set<Id>();
		for (csord__Subscription__c sub : [SELECT Id FROM csord__Subscription__c]) {
			subIds.add(sub.Id);
		}

		PageReference pageRef = Page.LG_TerminationDetails;
		pageRef.getParameters().put('basketId', basket.Id);
		Test.setCurrentPageReference(pageRef);

		Test.startTest();

		LG_TerminationDetailsController controller = new LG_TerminationDetailsController();
		controller.premiseIdToWishDates = addressOne.Id + '~20-03-2016';
		controller.terminatedSubs       = subIds;

		pageRef = controller.save();

		Test.stopTest();

		List<csordtelcoa__Subscr_MACDProductBasket_Association__c> subBasketJuncs = [SELECT LG_DeactivationWishDate__c
																					 FROM csordtelcoa__Subscr_MACDProductBasket_Association__c
																					 WHERE csordtelcoa__Product_Basket__c = :basket.Id];
		for (csordtelcoa__Subscr_MACDProductBasket_Association__c subBasketJunc : subBasketJuncs) {
			System.assertEquals(wishDate, subBasketJunc.LG_DeactivationWishDate__c, 'Deactivation wish date should be 20/3/2016');
		}
	}
}