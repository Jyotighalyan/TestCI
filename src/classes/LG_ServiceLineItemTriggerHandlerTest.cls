@isTest
private class LG_ServiceLineItemTriggerHandlerTest {
	
	@testsetup
	private static void setupTestData()
	{
		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		Account acc = new Account(Name = 'TestAcc');
        insert acc;
        
        List<csconta__Billing_Account__c> billAccounts = new List<csconta__Billing_Account__c>();
		billAccounts.add(LG_GeneralTest.createBillingAccount('SFDT-59 Bill3', acc.Id, false, false));
		insert billAccounts;

		csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
		insert coreq;
		
		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = coreq.Id, csconta__Billing_Account__c = billAccounts[0].Id);
		insert sub;
		
		
		insert new cscrm__Address__c(cscrm__Street__c = 'TestStreet');
		
		noTriggers.Flag__c = false;
		upsert noTriggers;
	}
	
	private static testmethod void testSlaLineItem()
	{
		cscrm__Address__c address = [SELECT Id FROM cscrm__Address__c WHERE cscrm__Street__c = 'TestStreet'];
		
		csord__Subscription__c sub = [SELECT Id, csord__Identification__c, LG_Address__c 
										FROM csord__Subscription__c WHERE csord__Identification__c = 'TestIdent'];

		csord__Order_Request__c req = [SELECT Id, csord__Module_Name__c
										FROM csord__Order_Request__c WHERE csord__Module_Name__c = 'Test'];
		
		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;
		
		csord__Service__c intService = new csord__Service__c(csord__Identification__c = 'TestIdentSub', csord__Order_Request__c = req.Id,
															csord__Subscription__c = sub.Id, LG_Address__c = address.Id, LG_ProductFamily__c = 'Internet');
		insert intService;
		
		csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestIdentSub', csord__Order_Request__c = req.Id,
															csord__Subscription__c = sub.Id, LG_Address__c = address.Id, LG_ProductFamily__c = 'HPBX',
															csord__Status__c = 'something');
		insert service;
		
		noTriggers.Flag__c = false;
		upsert noTriggers;
			
		Test.startTest();
			insert new csord__Service_Line_Item__c(Name = 'Test Internet SLA',
																csord__Identification__c = 'nesto',
																csord__Is_Adhoc__c = true,
																csord__Is_Recurring__c = true,
																csord__Line_Description__c = 'Test Desc',
																csord__Service__c = intService.Id,
																csord__Order_Request__c = req.Id,
																LG_BillingAccount__c = null,
																LG_ServiceLineItemExternalId__c = 'Something',
																LG_Quantity__c = null,
																LG_ExternalServiceName__c = 'SLA TEST',
																LG_ExternalPriceName__c = null,
																LG_ExternalDescription__c = 'Test Desc',
																LG_Type__c = null, LG_AddOnType__c = 'SLA',
																LG_ToBeSent__c = null);
		Test.stopTest();
		
		List<csord__Service_line_Item__c> lineItems = [SELECT Id, Name, csord__Identification__c, csord__Is_Adhoc__c,
														csord__Is_Recurring__c, csord__Line_Description__c,
														csord__Order_Request__c, LG_BillingAccount__c,
														LG_ServiceLineItemExternalId__c, LG_Quantity__c, LG_ExternalServiceName__c,
														LG_ExternalPriceName__c, LG_ExternalDescription__c, LG_Type__c,
														LG_AddOnType__c, LG_ToBeSent__c
														FROM csord__Service_line_Item__c
														WHERE LG_AddOnType__c = 'SLA'
														AND csord__Service__c = :service.Id];
		//System.assertEquals(1, lineItems.size(), 'Only one SLA line item should be inserted');
		//System.assertEquals('Test Desc', lineItems[0].LG_ExternalDescription__c, 'External description should be Test Desc');
		//System.assertEquals('Test Internet SLA', lineItems[0].Name, 'Name should be Test Internet SLA');
	}
}