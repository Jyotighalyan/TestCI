@isTest
private class LG_ManageNumberStepTest {

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

		csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test Service Req', csord__Module_Version__c = '1.0');
		insert coreq;

		csord__Solution__c solution = new csord__Solution__c(Name = 'NumbersIncomplete', csord__Identification__c = 'IdentSol');
		insert solution;

		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'IdentSub');
		insert sub;

		csord__Service__c service = new csord__Service__c(LG_Suborder__c = solution.Id, csord__Identification__c = 'Telephony Service', csord__Order_Request__c = coreq.Id, csord__Subscription__c = sub.Id);
		insert service;

		CSPOFA__Orchestration_Process_Template__c orcTemplate = new CSPOFA__Orchestration_Process_Template__c();
		insert orcTemplate;

		CSPOFA__Orchestration_Process__c process = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
																						LG_Solution__c = solution.Id);
		insert process;

		CSPOFA__Orchestration_Step__c step = new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = process.Id);
		insert step;

		Id numberBlockRTId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Number Block').getRecordTypeId();
		Id phoneNumberRTId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Phone Number').getRecordTypeId();
		Account account    = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);

		Asset numberBlock = new Asset();
		numberBlock.Name                   = '090123';
		numberBlock.AccountId              = account.Id;
		numberBlock.RecordTypeId           = numberBlockRTId;
		numberBlock.LG_EndNumber__c        = '090123';
		numberBlock.LG_NumberRange__c      = '090123';
		numberBlock.LG_NumberRangeSize__c  = Decimal.valueOf('1');
		numberBlock.LG_NumberRangeType__c  = 'New';
		numberBlock.LG_StartNumber__c      = '090123';
		numberBlock.LG_TelephonyService__c = service.Id;
		insert numberBlock;

		Asset numberBlockWoStartNumber = new Asset();
		numberBlockWoStartNumber.Name                   = 'Placeholder for 5 number block';
		numberBlockWoStartNumber.RecordTypeId           = numberBlockRTId;
		numberBlockWoStartNumber.AccountId              = account.Id;
		numberBlockWoStartNumber.LG_NumberRangeSize__c  = Decimal.valueOf('5');
		numberBlockWoStartNumber.LG_NumberRangeType__c  = 'New';
		numberBlockWoStartNumber.LG_TelephonyService__c = service.Id;
		insert numberBlockWoStartNumber;

		noTriggers.Flag__c = false;
		upsert noTriggers;
	}

	private static testmethod void testProcess()
	{
		List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c];

		for (SObject obj : steps) {
			CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
			System.assertNotEquals('Complete', step.CSPOFA__Status__c, 'Status should not be complete');
		}


		Test.startTest();
		LG_ManageNumbersStep manageNumbers = new LG_ManageNumbersStep();
		steps = manageNumbers.process(steps);
		Test.stopTest();

		for (SObject obj : steps) {
			CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
			System.assertEquals('Complete', step.CSPOFA__Status__c, 'Status should be complete');
		}
	}

	private static testmethod void testCheckNumberBlockAssets()
	{
		CSPOFA__Orchestration_Process__c process = [SELECT Id, LG_Solution__c,
													LG_Solution__r.Name,
													LG_Solution__r.LG_NumbersIncomplete__c
													FROM CSPOFA__Orchestration_Process__c
													WHERE LG_Solution__c != null];

		Set<Id> processids = new Set<Id>();
		processids.add(process.Id);
		System.assertEquals(false, process.LG_Solution__r.LG_NumbersIncomplete__c, 'Numbers Incomplete flag should be set to false');

		Test.startTest();
		LG_ManageNumbersStep manageNumbers = new LG_ManageNumbersStep();
		manageNumbers.checkNumberBlockAssets(processids);
		Test.stopTest();

		process = [SELECT Id, LG_Solution__c,
				   LG_Solution__r.Name,
				   LG_Solution__r.LG_NumbersIncomplete__c
				   FROM CSPOFA__Orchestration_Process__c
				   WHERE LG_Solution__c != null];

		System.assertEquals(true, process.LG_Solution__r.LG_NumbersIncomplete__c, 'Numbers Incomplete flag should be set to true');
	}
}