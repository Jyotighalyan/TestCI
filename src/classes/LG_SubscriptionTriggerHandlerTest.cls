@isTest
public class LG_SubscriptionTriggerHandlerTest {

	@testsetup
	private static void setupTestData()
	{
        csordtelcoa__Orders_Subscriptions_Options__c osOptions = new csordtelcoa__Orders_Subscriptions_Options__c();
		osOptions.csordtelcoa__Subscription_Number_Prefix__c = 'SN-';
		osOptions.csordtelcoa__Service_Number_Prefix__c = 'SVC-';
		insert osOptions;
	}

	@IsTest
	private static void updateSubscriptionNumberTest() {
	    
		csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test Subscription Req', csord__Module_Version__c = '1.0');
		insert coreq;
		
		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'Test Subscription', csord__Order_Request__c = coreq.Id);

	    Test.startTest();
	    
	    sub.csordtelcoa__Change_Type__c = 'Move';
	    insert sub;

	    List<csord__Subscription__c> subs = new List<csord__Subscription__c>();
	    subs.add(sub);
	    
	    LG_SubscriptionTriggerHandler.updateSubscriptionNumber( subs );
	    
	    Test.stopTest();
	    
	    csord__Subscription__c s = [SELECT Id, Name, csordtelcoa__Change_Type__c, csordtelcoa__Subscription_Number__c, csordtelcoa__Subscription_Number_Sequence__c FROM csord__Subscription__c WHERE Id = :sub.Id LIMIT 1];

	    String expected = 'SN-' +  s.csordtelcoa__Subscription_Number_Sequence__c;
	    
	    System.assertNotEquals(null, s.csordtelcoa__Subscription_Number_Sequence__c, 'Invalid data');
	    System.assertEquals(expected, s.csordtelcoa__Subscription_Number__c, 'Invalid data');
	}
}