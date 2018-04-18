@isTest
private class LG_OrderTriggerHandlerTest {

	@testsetup
	private static void setupTestData()
	{
		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c      = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		csordtelcoa__Orders_Subscriptions_Options__c osOptions = new csordtelcoa__Orders_Subscriptions_Options__c();
		osOptions.LG_OrderPartiallyCompletedStatus__c                = 'Some Suborders Completed';
		osOptions.LG_OrderCompleteStatus__c                          = 'Completed';
		osOptions.LG_OrderCanceledStatus__c                          = 'Canceled';
		osOptions.LG_ServiceDeactivatedStatus__c                     = 'Inactive';
		osOptions.csordtelcoa__Subscription_Closed_Replaced_State__c = 'Closed Replaced';
		insert osOptions;

		Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);

		Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);

		csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
		insert coreq;

		csord__Order__c order = LG_GeneralTest.createOrder('MonitorOrderName', account, 'First Status', coreq, opp, true);

		csord__Solution__c solution = new csord__Solution__c(csord__Order__c = order.Id, csord__Identification__c = 'identSol1');
		insert solution;

		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'IdentOldSub');
		insert sub;

		csord__Service__c service = new csord__Service__c(csord__Order__c = order.Id, csord__Subscription__c = sub.Id, LG_Suborder__c = solution.Id,
														  csord__Identification__c = 'TestServOld1', csord__Status__c = 'Active');
		insert service;

		noTriggers.Flag__c = false;
		upsert noTriggers;
	}

	private static testmethod void testNotifyMonitorField()
	{
		csord__Order__c order = [SELECT Id, csord__Status2__c FROM csord__Order__c WHERE Name = 'MonitorOrderName'];

		Test.startTest();
		order.csord__Status2__c = 'Second Status';
		update order;
		Test.stopTest();
	}

	private static testmethod void testUpdateInstallBase()
	{
		csord__Order__c order = [SELECT Id, csord__Status2__c FROM csord__Order__c WHERE Name = 'MonitorOrderName'];

		Test.startTest();
		order.csord__Status2__c = 'Completed';
		update order;
		Test.stopTest();

		csord__Service__c service = [SELECT Id, csord__Status__c FROM csord__Service__c WHERE csord__Identification__c = 'TestServOld1'];
		System.assertEquals('Active', service.csord__Status__c, 'Service should be active');
	}
}