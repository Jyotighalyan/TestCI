@isTest
private class LG_NumberPortingTest {

	@testsetup
	private static void setupTestData() {

		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c      = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);

		Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);

		csord__Solution__c solution = new csord__Solution__c(Name = 'testSol',
															 csord__Identification__c = 'testsol');
		insert solution;

		cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Basket', account, null, opp, false);
		basket.csbb__Account__c = account.Id;
		insert basket;

		csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
		insert coreq;

		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = coreq.Id);
		insert sub;

		cscfga__Product_Definition__c telephonyProdDef   = LG_GeneralTest.createProductDefinition('Telephony', true);
		cscfga__Product_Definition__c prodDefNumberRange = LG_GeneralTest.createProductDefinition('Number Range', true);

		cscfga__Product_Configuration__c telephonyProdConf   = LG_GeneralTest.createProductConfiguration('Telephony', 3, basket, telephonyProdDef, true);
		cscfga__Product_Configuration__c numberRangeProdConf = LG_GeneralTest.createProductConfiguration('Number Range', 3, basket, prodDefNumberRange, true);


		csord__Service__c telephonyService = new csord__Service__c(csord__Identification__c = 'TestTelServ', csord__Order_Request__c = coreq.Id, LG_Suborder__c = solution.Id,
																   csord__Subscription__c = sub.Id, csordtelcoa__Product_Configuration__c = telephonyProdConf.Id);
		insert telephonyService;

		csord__Service__c numberRangeService = new csord__Service__c(csord__Identification__c = 'TestNmbrServ', csord__Order_Request__c = coreq.Id,
																	 csord__Subscription__c = sub.Id, csordtelcoa__Product_Configuration__c = numberRangeProdConf.Id);
		insert numberRangeService;

		Id numberBlockRTId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Number Block').getRecordTypeId();
		Id phoneNumberRTId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Phone Number').getRecordTypeId();

		Asset numberBlock = new Asset();
		numberBlock.Name                                  = '090123';
		numberBlock.AccountId                             = account.Id;
		numberBlock.RecordTypeId                          = numberBlockRTId;
		numberBlock.LG_EndNumber__c                       = '090123';
		numberBlock.LG_NumberRange__c                     = '090123';
		numberBlock.LG_NumberRangeSize__c                 = Decimal.valueOf('1');
		numberBlock.LG_NumberRangeType__c                 = 'Portin';
		numberBlock.LG_StartNumber__c                     = '090123';
		numberBlock.LG_PortInWishDate__c                  = Date.newInstance(2017, 2, 17);
		numberBlock.LG_TelephonyProductConfiguration__c   = telephonyProdConf.Id;
		numberBlock.LG_NumberRangeProductConfiguration__c = numberRangeProdConf.Id;
		numberBlock.LG_TelephonyService__c                = telephonyService.Id;
		insert numberBlock;

		Asset numberAsset = new Asset();
		numberAsset.Name                                  = '090123';
		numberAsset.AccountId                             = account.Id;
		numberAsset.LG_Asset__c                           = numberBlock.Id;
		numberAsset.RecordTypeId                          = phoneNumberRTId;
		numberAsset.LG_PhoneNumber__c                     = '090123';
		numberAsset.LG_NumberRangeType__c                 = 'Portin';
		numberAsset.LG_TelephonyProductConfiguration__c   = telephonyProdConf.Id;
		numberAsset.LG_NumberRangeProductConfiguration__c = numberRangeProdConf.Id;
		numberAsset.LG_TelephonyService__c                = telephonyService.Id;
		insert numberAsset;

		Asset numberBlock2 = new Asset();
		numberBlock2.Name                                  = '090124';
		numberBlock2.AccountId                             = account.Id;
		numberBlock2.RecordTypeId                          = numberBlockRTId;
		numberBlock2.LG_EndNumber__c                       = '090124';
		numberBlock2.LG_NumberRange__c                     = '090124';
		numberBlock2.LG_NumberRangeSize__c                 = Decimal.valueOf('1');
		numberBlock2.LG_NumberRangeType__c                 = 'Portin';
		numberBlock2.LG_StartNumber__c                     = '090124';
		numberBlock2.LG_PortInWishDate__c                  = Date.newInstance(2017, 2, 17);
		numberBlock2.LG_TelephonyProductConfiguration__c   = telephonyProdConf.Id;
		numberBlock2.LG_NumberRangeProductConfiguration__c = numberRangeProdConf.Id;
		numberBlock2.LG_TelephonyService__c                = telephonyService.Id;
		insert numberBlock2;

		Asset numberAsset2 = new Asset();
		numberAsset2.Name                                  = '090124';
		numberAsset2.AccountId                             = account.Id;
		numberAsset2.LG_Asset__c                           = numberBlock2.Id;
		numberAsset2.RecordTypeId                          = phoneNumberRTId;
		numberAsset2.LG_PhoneNumber__c                     = '090124';
		numberAsset2.LG_NumberRangeType__c                 = 'Portin';
		numberAsset2.LG_TelephonyProductConfiguration__c   = telephonyProdConf.Id;
		numberAsset2.LG_NumberRangeProductConfiguration__c = numberRangeProdConf.Id;
		numberAsset2.LG_TelephonyService__c                = telephonyService.Id;
		insert numberAsset2;

		Asset numberBlock3 = new Asset();
		numberBlock3.Name                                  = '090150';
		numberBlock3.AccountId                             = account.Id;
		numberBlock3.RecordTypeId                          = numberBlockRTId;
		numberBlock3.LG_EndNumber__c                       = '090159';
		numberBlock3.LG_NumberRange__c                     = '090150-090159';
		numberBlock3.LG_PortInWishDate__c                  = Date.newInstance(2017, 2, 17);
		numberBlock3.LG_NumberRangeSize__c                 = Decimal.valueOf('10');
		numberBlock3.LG_NumberRangeType__c                 = 'Portin';
		numberBlock3.LG_StartNumber__c                     = '090150';
		numberBlock3.LG_TelephonyProductConfiguration__c   = telephonyProdConf.Id;
		numberBlock3.LG_NumberRangeProductConfiguration__c = numberRangeProdConf.Id;
		numberBlock3.LG_TelephonyService__c                = telephonyService.Id;
		insert numberBlock3;

		Asset numberAsset3 = new Asset();
		numberAsset3.Name                                  = '090150';
		numberAsset3.AccountId                             = account.Id;
		numberAsset3.LG_Asset__c                           = numberBlock3.Id;
		numberAsset3.RecordTypeId                          = phoneNumberRTId;
		numberAsset3.LG_PhoneNumber__c                     = '090150';
		numberAsset3.LG_NumberRangeType__c                 = 'Portin';
		numberAsset3.LG_TelephonyProductConfiguration__c   = telephonyProdConf.Id;
		numberAsset3.LG_NumberRangeProductConfiguration__c = numberRangeProdConf.Id;
		numberAsset3.LG_TelephonyService__c                = telephonyService.Id;
		
		insert numberAsset3;
		

		Asset numberBlock4 = new Asset();
		numberBlock4.Name                                  = '090160';
		numberBlock4.AccountId                             = account.Id;
		numberBlock4.RecordTypeId                          = numberBlockRTId;
		numberBlock4.LG_EndNumber__c                       = '090160';
		numberBlock4.LG_NumberRange__c                     = '090160';
		numberBlock4.LG_NumberRangeSize__c                 = Decimal.valueOf('1');
		numberBlock4.LG_NumberRangeType__c                 = 'Portin';
		numberBlock4.LG_StartNumber__c                     = '090160';
		numberBlock4.LG_PortInWishDate__c                  = Date.newInstance(2017, 2, 18);
		numberBlock4.LG_TelephonyProductConfiguration__c   = telephonyProdConf.Id;
		numberBlock4.LG_NumberRangeProductConfiguration__c = numberRangeProdConf.Id;
		numberBlock4.LG_TelephonyService__c                = telephonyService.Id;
		insert numberBlock4;

		Asset numberAsset4 = new Asset();
		numberAsset4.Name                                  = '090160';
		numberAsset4.AccountId                             = account.Id;
		numberAsset4.LG_Asset__c                           = numberBlock4.Id;
		numberAsset4.RecordTypeId                          = phoneNumberRTId;
		numberAsset4.LG_PhoneNumber__c                     = '090160';
		numberAsset4.LG_NumberRangeType__c                 = 'Portin';
		numberAsset4.LG_TelephonyProductConfiguration__c   = telephonyProdConf.Id;
		numberAsset4.LG_NumberRangeProductConfiguration__c = numberRangeProdConf.Id;
		numberAsset4.LG_TelephonyService__c                = telephonyService.Id;
		insert numberAsset4;

		noTriggers.Flag__c = false;
		upsert noTriggers;
	}

	@isTest
	private static void testCreatePortInProcessRecords() {
		List<csord__Service__c> services = [SELECT Id FROM csord__Service__c];
		List<Id> serviceIds  = new List<Id>();
		if(services.size()>0){
		for (csord__Service__c service : services) {
			serviceIds.add(service.Id);
		}
		}
		if(serviceIds.size()>0){
		Test.startTest();
		
		LG_NumberPorting.createPortInProcessRecords(serviceIds);
		Test.stopTest();
		}
		List<LG_PortingProcess__c> portProcess = [SELECT Id FROM LG_PortingProcess__c];
		System.assertEquals(3, portProcess.size(), 'Three processes should have been created');

		List<LG_AssetProcessAssociation__c> associations = [SELECT Id, LG_Asset__c, LG_Asset__r.Name, LG_Process__c FROM LG_AssetProcessAssociation__c];
		Id processId = null;
		for (LG_AssetProcessAssociation__c assc : associations) {
			if (assc.LG_Asset__r.Name == '090123' || assc.LG_Asset__r.Name == '090124') {
				if (processId != null) {
					System.assertEquals(processId, assc.LG_Process__c, 'Assets with name 090123 and 090124 should have the same process Id');
				} else {
					processId = assc.LG_Process__c;
				}
			}
		}
	}
}