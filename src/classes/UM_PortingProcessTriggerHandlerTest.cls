@isTest
public with sharing class UM_PortingProcessTriggerHandlerTest {
    
    @testsetup
	private static void setupTestData()
	{
		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
		insert coreq;
		
		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = coreq.Id);
		insert sub;
		
		cscrm__Address__c add=new cscrm__Address__c(cscrm__Street__c = 'TestStreet');
		insert add;
		
        csordtelcoa__Orders_Subscriptions_Options__c osOptions = new csordtelcoa__Orders_Subscriptions_Options__c();
		osOptions.csordtelcoa__Subscription_Number_Prefix__c = 'SN-';
		osOptions.csordtelcoa__Service_Number_Prefix__c = 'SVC-';
		insert osOptions;
	
		csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestIdentSub', csord__Order_Request__c = coreq.Id,
																csord__Subscription__c = sub.Id, LG_Address__c = add.Id);
		insert service;
		
		noTriggers.Flag__c = false;
		upsert noTriggers;
	}
	
	private static testmethod void testUpdatePortingProcessCountOnService(){
		csord__Service__c service=[select Id from csord__Service__c limit 1];
		test.startTest();
		UM_PortingProcess__c portProcess= LG_GeneralTest.createPortingProcess(service,'Test PP', 'open', true);
		csord__Service__c queriedService=[Select Id, UM_NumberOfOpenPortingProcesses__c from csord__Service__c where Id=:service.Id];
		system.assertEquals(1,queriedService.UM_NumberOfOpenPortingProcesses__c);
		delete portProcess;
		csord__Service__c reQueriedService=[Select Id, UM_NumberOfOpenPortingProcesses__c from csord__Service__c where Id=:service.Id];
		system.assertEquals(0,reQueriedService.UM_NumberOfOpenPortingProcesses__c);
		
		test.stopTest();
		
	}
	
	private static testMethod void testCreateKenanIDs(){
		csord__Service__c service=[select Id from csord__Service__c limit 1];
		UM_PortingProcess__c portProcess= LG_GeneralTest.createPortingProcess(service,'Test PP', 'open', true);
		test.startTest();
		portProcess.UM_Status__c='Closed';
		portProcess.UM_Stage__c='Closed';
		portProcess.UM_SubStage__c='Confirmed';		
		update portProcess;
		test.stopTest();
		
	}
}