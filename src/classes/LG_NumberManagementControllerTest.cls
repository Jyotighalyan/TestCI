@isTest
private class LG_NumberManagementControllerTest {

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
		mngSettings.LG_MinNumberLength__c                  = 10;
		mngSettings.LG_MaxNumberLength__c                  = 10;
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

		Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);

		Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);

		csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test Service Req', csord__Module_Version__c = '1.0');
		insert coreq;

		csord__Order__c order = LG_GeneralTest.createOrder('TestOrder', account, 'First Status', coreq, opp, true);

		csord__Solution__c solution = new csord__Solution__c(csord__Order__c = order.Id, csord__Identification__c = 'identSol1');
		insert solution;

		Id installCaseRtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Install').getRecordTypeId();

		Case testCase = new Case(LG_Solution__c = solution.Id, RecordTypeId = installCaseRtId);
		insert testCase;

		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'IdentSub');
		insert sub;

		csord__Service__c service = new csord__Service__c(csord__Identification__c = 'Telephony Service', csord__Order_Request__c = coreq.Id, csord__Subscription__c = sub.Id, LG_RootOrder__c = order.Id);
		insert service;
		
		CSPOFA__Orchestration_Process_Template__c orcTemplate = new CSPOFA__Orchestration_Process_Template__c();
		insert orcTemplate;
		
		CSPOFA__Orchestration_Process__c process = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id, csordtelcoa__Service__c = service.Id, LG_Solution__c = solution.Id);
		insert process;
		
		CSPOFA__Orchestration_Step__c step = new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = process.Id, CSPOFA__Step_Order__c = 35, CSPOFA__Status__c = 'In Progress');
		insert step;

        LG_InflightChangeStep__c inflightSetting = new LG_InflightChangeStep__c(Name= 'Test', LG_OrchestrationProcess__c = orcTemplate.id, LG_InstallLoop__c=55, LG_NumberPortLoop__c=38,LG_PortingWindow__c=7, LG_ProvisionLoop__c=27,LG_RetryInstall__c=37,LG_RetryNumberPort__c=34,LG_RetryProvision__c=20);
		insert inflightSetting;
        
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
		numberBlock.LG_PortInName__c                     = 'Test1';	
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
		numberAsset.LG_PortInName__c                	  = 'Test1';
		numberAsset.LG_TelephonyProductConfiguration__c   = telephonyProdConf.Id;
		numberAsset.LG_NumberRangeProductConfiguration__c = numberRangeProdConf.Id;
		insert numberAsset;

		noTriggers.Flag__c = false;
		upsert noTriggers;
	}

	private static testmethod void testGetPortInOperators()
	{
		cscfga__Product_Configuration__c prodConf = [SELECT Id FROM cscfga__Product_Configuration__c WHERE Name = 'Telephony'];

		PageReference pageRef = Page.LG_NumberManagement;
		pageRef.getParameters().put('id', prodConf.Id);
		Test.setCurrentPageReference(pageRef);

		Test.startTest();

		LG_NumberManagementController controller = new LG_NumberManagementController();
		List<SelectOption> operators = controller.getPortInOperators();

		Test.stopTest();

		System.assertEquals(3, operators.size(), 'SelectOption list should have 2 elements');
	}

	private static testmethod void testSave()
	{
		cscfga__Product_Configuration__c prodConf = [SELECT Id, cscfga__Product_Basket__c FROM cscfga__Product_Configuration__c WHERE Name = 'Telephony'];

		PageReference pageRef = Page.LG_NumberManagement;
		pageRef.getParameters().put('id', prodConf.cscfga__Product_Basket__c);
		Test.setCurrentPageReference(pageRef);

		Test.startTest();
		LG_NumberManagementController controller = new LG_NumberManagementController();
		controller.numberRangeList[0].numberBlockAsset.LG_EndNumber__c = '1234567890';
		controller.save();
		Test.stopTest();

		Asset asset = [SELECT Id, LG_EndNumber__c FROM Asset Where RecordType.Name = 'Number Block' AND Name = '090123'];
		System.assertEquals('1234567890', asset.LG_EndNumber__c, 'End number should be 1234567890');
	}

	private static testmethod void testSaveStartNumberChanged()
	{
		cscfga__Product_Configuration__c prodConf = [SELECT Id, cscfga__Product_Basket__c FROM cscfga__Product_Configuration__c WHERE Name = 'Telephony'];
		No_Triggers__c noTriggers                 = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c      = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		Asset phoneNumber = [SELECT Id, LG_PhoneNumber__c FROM Asset Where RecordType.Name = 'Phone Number'];

		PageReference pageRef = Page.LG_NumberManagement;
		pageRef.getParameters().put('id', prodConf.cscfga__Product_Basket__c);
		Test.setCurrentPageReference(pageRef);

		Test.startTest();
		LG_NumberManagementController controller = new LG_NumberManagementController();
		controller.numberRangeList[0].numberBlockAsset.LG_StartNumber__c = '1234567890';
		List<String> numbers                                             = new List<String>();
		numbers.add('1234567890');
		controller.numberRangeList[0].numbers = JSON.serialize(numbers);
		controller.save();
		Test.stopTest();

		phoneNumber = [SELECT Id, LG_PhoneNumber__c FROM Asset Where RecordType.Name = 'Phone Number'];
		System.assertEquals('1234567890', phoneNumber.LG_PhoneNumber__c, 'Phone number should be 1234567890');
	}

	private static testmethod void testPageReadOnly()
	{
		Case testCase = [SELECT Id FROM Case];

		PageReference pageRef = Page.LG_NumberManagement;
		pageRef.getParameters().put('id', testCase.Id);
		Test.setCurrentPageReference(pageRef);

		Test.startTest();
		LG_NumberManagementController controller = new LG_NumberManagementController();
		Test.stopTest();

		System.assertEquals(true, controller.pageReadOnly, 'Page should be in a read only mode');
	}
	
	private static testmethod void testUpdateFromNumberManagementOtherChanges()
	{
		No_Triggers__c noTriggers                 = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c      = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;
		
		Id manageNumbersCaseRtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Manage Numbers').getRecordTypeId();
		Case testCase = [SELECT Id, LG_Solution__c, RecordTypeId  FROM Case];		
		testCase.RecordTypeId = manageNumbersCaseRtId;
		update testCase;
		
		Asset testAssets = [SELECT Id, LG_StartNumber__c, LG_EndNumber__c, LG_PortInWishDate__c, LG_PortInOperator__c FROM Asset limit 1];	

		PageReference pageRef = Page.LG_NumberManagement;
		pageRef.getParameters().put('id', testCase.Id);
		Test.setCurrentPageReference(pageRef);

		Test.startTest();
		LG_NumberManagementController controller = new LG_NumberManagementController();
		controller.numberRangeList[0].numberBlockAsset.LG_EndNumber__c = '1234567890';
		controller.numberRangeList[0].numberBlockAsset.Id = testAssets.Id;
		controller.save();
		Test.stopTest();

		csord__Solution__c Solution = [SELECT Id, LG_RetryProvision__c, LG_RetryNumberPort__c, LG_InflightChange__c, LG_Jeopardy__c FROM csord__Solution__c];
		System.assertEquals(true, Solution.LG_RetryProvision__c, 'Retry provision should be true');
		System.assertEquals(true, Solution.LG_InflightChange__c, ' Inflight Change should be true');
	}
	
	private static testmethod void testUpdateFromNumberManagementDonorOnlyChanges()
	{
		No_Triggers__c noTriggers                 = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c      = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;
		
		Id manageNumbersCaseRtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Manage Numbers').getRecordTypeId();
		Case testCase = [SELECT Id, LG_Solution__c, RecordTypeId  FROM Case];		
		testCase.RecordTypeId = manageNumbersCaseRtId;
		update testCase;
		
		Asset testAssets = [SELECT Id, LG_StartNumber__c, LG_EndNumber__c, LG_PortInWishDate__c, LG_PortInOperator__c FROM Asset limit 1];	

		PageReference pageRef = Page.LG_NumberManagement;
		pageRef.getParameters().put('id', testCase.Id);
		Test.setCurrentPageReference(pageRef);

		Test.startTest();
		LG_NumberManagementController controller = new LG_NumberManagementController();
		controller.numberRangeList[0].numberBlockAsset.LG_PortInName__c = 'ABC';
		controller.numberRangeList[0].numberBlockAsset.Id = testAssets.Id;
		controller.save();
		Test.stopTest();

		csord__Solution__c Solution = [SELECT Id, LG_RetryProvision__c, LG_RetryNumberPort__c, LG_InflightChange__c, LG_Jeopardy__c FROM csord__Solution__c];
		System.assertEquals(true, Solution.LG_RetryNumberPort__c, 'Retry NumberPort should be true');
		System.assertEquals(true, Solution.LG_InflightChange__c, ' Inflight Change should be true');
	}
    //SFOM-737
	private static testmethod void testDonorOnlyChangesforjeopardy()
	{
		No_Triggers__c noTriggers                 = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c      = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;
		
		Id manageNumbersCaseRtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Manage Numbers').getRecordTypeId();
		Case testCase = [SELECT Id, LG_Solution__c, RecordTypeId  FROM Case];		
		testCase.RecordTypeId = manageNumbersCaseRtId;
		update testCase;
		
		csord__Solution__c Sol = [SELECT Id, LG_RetryProvision__c, LG_RetryNumberPort__c, LG_InflightChange__c, LG_Jeopardy__c FROM csord__Solution__c where id = :testCase.LG_Solution__c limit 1];
		sol.LG_Jeopardy__c = TRUE;
        update sol;
        
        CSPOFA__Orchestration_Process__c pro = [select id from CSPOFA__Orchestration_Process__c where LG_Solution__c = :sol.Id limit 1];
        CSPOFA__Orchestration_Step__c OrchStep = [select id, Name, CSPOFA__Status__c, CSPOFA__Step_Order__c from CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__c = :pro.id limit 1];
        OrchStep.CSPOFA__Step_Order__c = 38; 
        update OrchStep;

        Asset testAssets = [SELECT Id, LG_StartNumber__c, LG_EndNumber__c, LG_PortInWishDate__c, LG_PortInOperator__c FROM Asset limit 1];	

		PageReference pageRef = Page.LG_NumberManagement;
		pageRef.getParameters().put('id', testCase.Id);
		Test.setCurrentPageReference(pageRef);

		Test.startTest();
		LG_NumberManagementController controller = new LG_NumberManagementController();
		controller.numberRangeList[0].numberBlockAsset.LG_PortInName__c = 'ABC';
		controller.numberRangeList[0].numberBlockAsset.Id = testAssets.Id;
		controller.save();
		Test.stopTest();

		csord__Solution__c Solution = [SELECT Id, LG_RetryProvision__c, LG_RetryNumberPort__c, LG_InflightChange__c, LG_Jeopardy__c FROM csord__Solution__c];
		System.assertEquals(true, Solution.LG_RetryNumberPort__c, 'Retry NumberPort should be true');
	}
    //SFOM-737
	private static testmethod void testOtherChangeswithJeopardy()
	{
		No_Triggers__c noTriggers                 = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c      = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;
		
		Id manageNumbersCaseRtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Manage Numbers').getRecordTypeId();
		Case testCase = [SELECT Id, LG_Solution__c, RecordTypeId  FROM Case];		
		testCase.RecordTypeId = manageNumbersCaseRtId;
		update testCase;
		
		csord__Solution__c Sol = [SELECT Id, LG_RetryProvision__c, LG_RetryNumberPort__c, LG_InflightChange__c, LG_Jeopardy__c FROM csord__Solution__c where id = :testCase.LG_Solution__c  limit 1];
		sol.LG_Jeopardy__c = TRUE;
        update sol;
        
        CSPOFA__Orchestration_Process__c pro = [select id from CSPOFA__Orchestration_Process__c where LG_Solution__c = :sol.Id limit 1];
        CSPOFA__Orchestration_Step__c OrchStep = [select id, Name, CSPOFA__Status__c, CSPOFA__Step_Order__c from CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__c = :pro.id limit 1];
        OrchStep.CSPOFA__Step_Order__c = 27; 
        update OrchStep;

        Asset testAssets = [SELECT Id, LG_StartNumber__c, LG_EndNumber__c, LG_PortInWishDate__c, LG_PortInOperator__c FROM Asset limit 1];	

		PageReference pageRef = Page.LG_NumberManagement;
		pageRef.getParameters().put('id', testCase.Id);
		Test.setCurrentPageReference(pageRef);

		Test.startTest();
		LG_NumberManagementController controller = new LG_NumberManagementController();
		controller.numberRangeList[0].numberBlockAsset.LG_EndNumber__c = '1234567890';
		controller.numberRangeList[0].numberBlockAsset.Id = testAssets.Id;
		controller.save();
		Test.stopTest();

		csord__Solution__c Solution = [SELECT Id, LG_RetryProvision__c, LG_RetryNumberPort__c, LG_InflightChange__c, LG_Jeopardy__c FROM csord__Solution__c];
		System.assertEquals(true, Solution.LG_RetryProvision__c, 'Retry provision should be true');
	}
}