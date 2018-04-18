@isTest
private class CustomButtonNumberManagementTest {

	private static String vfBaseUrl   = 'vforce.url';
	private static String sfdcBaseUrl = 'sfdc.url';

	@testsetup
	private static void setupTestData()
	{
		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c      = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		LG_NumberManagementSettings__c mngSettings = new LG_NumberManagementSettings__c();
		mngSettings.LG_BlockSizes__c                       = '1,10,100';
		mngSettings.LG_NumberRangeProdConfForNew__c        = true;
		mngSettings.LG_NumberRangeProdConfForPortIn__c     = true;
		mngSettings.LG_NumberRangeProductDefinitionName__c = 'Number Range';
		mngSettings.LG_TelephonyNumberRangeAttribute__c    = 'Number Ranges';
		mngSettings.LG_BlockTypeAttribute__c               = 'Block Type';
		mngSettings.LG_EndNumberAttribute__c               = 'End Number';
		mngSettings.LG_NumberRangeAttribute__c             = 'Number Range';
		mngSettings.LG_SizeAttribute__c                    = 'Size';
		mngSettings.LG_StartNumberAttribute__c             = 'Start Number';
		mngSettings.LG_PortInOperators__c                  = 'BT,KPN';
		mngSettings.LG_RequireDetailsForNew__c             = true;
		mngSettings.LG_RequireDetailsForPortIn__c          = true;
		if (!Schema.SObjectType.Asset.fieldSets.getMap().isEmpty()) {
			String fieldSetName = '';
			for (String key : Schema.SObjectType.Asset.fieldSets.getMap().keySet()) {
				fieldSetName = key;
				break;
			}
			mngSettings.LG_PortInDetailsFieldSet__c = fieldSetName;
			mngSettings.LG_NewDetailsFieldSet__c    = fieldSetName;
		}
		insert mngSettings;

		LG_EnvironmentVariables__c envVariables = new LG_EnvironmentVariables__c();
		envVariables.LG_SalesforceBaseURL__c         = sfdcBaseUrl;
		envVariables.LG_VisualForceBaseURL__c        = vfBaseUrl;
		envVariables.LG_CloudSenceAnywhereIconID__c  = 'csaID';
		envVariables.LG_ServiceAvailabilityIconID__c = 'saIconId';
		insert envVariables;

		Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);

		Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);

		csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test Service Req', csord__Module_Version__c = '1.0');
		insert coreq;

		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'IdentSub');
		insert sub;

		csord__Service__c service = new csord__Service__c(csord__Identification__c = 'Telephony Service', csord__Order_Request__c = coreq.Id, csord__Subscription__c = sub.Id);
		insert service;

		cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Basket', account, null, opp, false);
		basket.csbb__Account__c = account.Id;
		insert basket;

		cscfga__Product_Definition__c telephonyProdDef   = LG_GeneralTest.createProductDefinition('Telephony', true);
		cscfga__Product_Definition__c prodDefNumberRange = LG_GeneralTest.createProductDefinition('Number Range', true);


		cscfga__Product_Configuration__c telephonyProdConf   = LG_GeneralTest.createProductConfiguration('Telephony', 3, basket, telephonyProdDef, true);
		cscfga__Product_Configuration__c numberRangeProdConf = LG_GeneralTest.createProductConfiguration('Number Range', 3, basket, prodDefNumberRange, true);

		cscfga__Attribute_Definition__c attDef = LG_GeneralTest.createAttributeDefinition('Number Ranges', telephonyProdDef, 'Related Product', 'String',
																						  null, null, null, true);
		LG_GeneralTest.createAttributeDefinition('Block Type', prodDefNumberRange, 'User Input', 'String', null, null, null, true);
		LG_GeneralTest.createAttributeDefinition('End Number', prodDefNumberRange, 'User Input', 'String', null, null, null, true);
		LG_GeneralTest.createAttributeDefinition('Number Range', prodDefNumberRange, 'User Input', 'String', null, null, null, true);
		LG_GeneralTest.createAttributeDefinition('Size', prodDefNumberRange, 'User Input', 'String', null, null, null, true);
		LG_GeneralTest.createAttributeDefinition('Start Number', prodDefNumberRange, 'User Input', 'String', null, null, null, true);

		LG_GeneralTest.createAttribute('Number Ranges', attDef, false, null, telephonyProdConf, false, numberRangeProdConf.Id, true);

		Id numberBlockRTId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Number Block').getRecordTypeId();
		Id phoneNumberRTId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Phone Number').getRecordTypeId();

		Asset numberBlock = new Asset();
		numberBlock.Name                                  = '090123';
		numberBlock.AccountId                             = account.Id;
		numberBlock.RecordTypeId                          = numberBlockRTId;
		numberBlock.LG_EndNumber__c                       = '090123';
		numberBlock.LG_NumberRange__c                     = '090123';
		numberBlock.LG_NumberRangeSize__c                 = Decimal.valueOf('1');
		numberBlock.LG_NumberRangeType__c                 = 'New';
		numberBlock.LG_StartNumber__c                     = '090123';
		numberBlock.LG_TelephonyProductConfiguration__c   = telephonyProdConf.Id;
		numberBlock.LG_NumberRangeProductConfiguration__c = numberRangeProdConf.Id;
		numberBlock.LG_TelephonyService__c                = service.Id;
		insert numberBlock;

		Asset numberAsset = new Asset();
		numberAsset.Name                                  = '090123';
		numberAsset.AccountId                             = account.Id;
		numberAsset.LG_Asset__c                           = numberBlock.Id;
		numberAsset.RecordTypeId                          = phoneNumberRTId;
		numberAsset.LG_PhoneNumber__c                     = '090123';
		numberAsset.LG_NumberRangeType__c                 = 'New';
		numberAsset.LG_TelephonyProductConfiguration__c   = telephonyProdConf.Id;
		numberAsset.LG_NumberRangeProductConfiguration__c = numberRangeProdConf.Id;
		insert numberAsset;

		noTriggers.Flag__c = false;
		upsert noTriggers;
	}

	private static testmethod void testPerformActionSuccess()
	{
		cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c];

		Test.startTest();
		CustomButtonNumberManagement cstBtn = new CustomButtonNumberManagement();
		String performActionResult          = cstBtn.performAction(basket.Id);
		Test.stopTest();

		System.assertEquals('{"status":"ok","redirectURL":"' + sfdcBaseUrl
							+ '/apex/LG_NumberManagement?id=' + basket.Id + '"}',
							performActionResult, 'result should match');
	}

	private static testmethod void testError()
	{
		cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c];

		delete [SELECT Id FROM cscfga__Product_Configuration__c WHERE cscfga__Product_Basket__c = : basket.Id];

		Test.startTest();
		CustomButtonNumberManagement cstBtn = new CustomButtonNumberManagement();
		String performActionResult          = cstBtn.performAction(basket.Id);
		Test.stopTest();

		System.assertEquals(CustomButtonNumberManagement.errorMsg,
							performActionResult, 'result should match');
	}
}