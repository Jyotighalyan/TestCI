@isTest
private class CustomBttnSetBillingAccOnLineItemsTest {
	
	private static String vfBaseUrl = 'vforce.url';
	private static String sfdcBaseUrl = 'sfdc.url';
	
	@testsetup
	private static void setupTestData()
	{
		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;
		
		LG_EnvironmentVariables__c envVariables = new LG_EnvironmentVariables__c();
		envVariables.LG_SalesforceBaseURL__c = sfdcBaseUrl;
		envVariables.LG_VisualForceBaseURL__c = vfBaseUrl;
		envVariables.LG_CloudSenceAnywhereIconID__c = 'csaID';
		envVariables.LG_ServiceAvailabilityIconID__c = 'saIconId';
		insert envVariables;
		
		Account account = LG_GeneralTest.CreateAccount('AccountSFDT', '12345678', 'Ziggo', true);
		
		Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
		
		cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Basket', account, null, opp, true);
		
		noTriggers.Flag__c = false;
		upsert noTriggers;
	}
	
	private static testmethod void testPerformActionSuccess()
	{
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;
        
        Account account = [SELECT Id FROM Account WHERE Name = 'AccountSFDT'];
		cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'Basket'];
        basket.csbb__Account__c = account.Id;
        update basket;
        
        noTriggers.Flag__c = false;
		upsert noTriggers;
		
		Test.startTest();
			CustomButtonSetBillingAccountOnLineItems cstBtn = new CustomButtonSetBillingAccountOnLineItems();
			String performActionResult = cstBtn.performAction(basket.Id);
		Test.stopTest();
		
		System.assertEquals('{"status":"ok","redirectURL":"' + sfdcBaseUrl 
							+ '/apex/LG_SeparateInvoices?basketId=' + basket.Id + '"}',
							performActionResult, 'result should match');
	}
    
    private static testmethod void testPerformActionError()
	{
		cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'Basket'];
		
		Test.startTest();
			CustomButtonSetBillingAccountOnLineItems cstBtn = new CustomButtonSetBillingAccountOnLineItems();
			String performActionResult = cstBtn.performAction(basket.Id);
		Test.stopTest();
		
		System.assertEquals(CustomButtonSetBillingAccountOnLineItems.errorMsg,
							performActionResult, 'result should match');
	}
}