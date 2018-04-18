@isTest
private class LG_PortingNmbrsSiteCmpntControllerTest {
	
	/* RS: This Class should be fixed - no assert methods */
	
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
		
		Account account = LG_GeneralTest.CreateAccount('AccountSFDT-58', '12345678', 'Ziggo', true);
				
		Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
		
		cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('BAsket58', account, null, opp, false);
		basket.csbb__Account__c = account.Id;
		insert basket;
		
		cscfga__Product_Definition__c prodDef = LG_GeneralTest.createProductDefinition('ProdDef58', true);
		
		cscfga__Product_Configuration__c prodConf = LG_GeneralTest.createProductConfiguration('ProdConf58', 3, basket, prodDef, false);
		prodConf.LG_PortIn__c = true;
		prodConf.LG_MaximumQuantity__c = 20;
		insert prodConf;
		
		LG_PortingNumber__c tmpPortingNumber = new LG_PortingNumber__c();
		tmpPortingNumber.LG_FirstPhoneNumber__c = '345';
		tmpPortingNumber.LG_LastPhoneNumber__c = '345';
		tmpPortingNumber.LG_Operator__c = 'KLN';
		tmpPortingNumber.LG_PhoneNumber__c = '345';
		tmpPortingNumber.LG_PortingDate__c = Date.today();
		tmpPortingNumber.LG_PrimaryNumber__c = '345';
		tmpPortingNumber.LG_Type__c = 'SB Telephony';
		tmpPortingNumber.LG_Opportunity__c = null;
		tmpPortingNumber.LG_ProductConfiguration__c = prodConf.Id;
		insert tmpPortingNumber;
		
		noTriggers.Flag__c = false;
		upsert noTriggers;
	}
	
	private static testmethod void testResetData()
	{
		cscfga__Product_Configuration__c prodConf = [SELECT Id FROM cscfga__Product_Configuration__c WHERE Name = 'ProdConf58'];
		
		Test.startTest();
		
			LG_PortingNumbersController controller = new LG_PortingNumbersController();
			
			LG_PortingNmbrsSiteComponentController compController = new LG_PortingNmbrsSiteComponentController();
			compController.pageController = controller;
			compController.prodConfigId = prodConf.Id;
			compController.lstImportFileRow.add(new LG_PortingNmbrsSiteComponentController.cImportFileRow());
			compController.fileName = 'something';
			compController.lstErrorMessage.add('Something');
			compController.fileIsValid = true;
			
			compController.resetData(true);
		Test.stopTest();
		
		// Need to be fixed
		// System.assertEquals(1, compController.lstPortedNumbers.size(), 'One ported number should already exist');
	}
	
	private static testmethod void testUploadValidateFile()
	{
		cscfga__Product_Configuration__c prodConf = [SELECT Id FROM cscfga__Product_Configuration__c WHERE Name = 'ProdConf58'];
		
		Test.startTest();
		
			LG_PortingNumbersController controller = new LG_PortingNumbersController();
			
			LG_PortingNmbrsSiteComponentController compController = new LG_PortingNmbrsSiteComponentController();
			compController.pageController = controller;
			compController.prodConfigId = prodConf.Id;
			
			compController.fileName='Tel test';
			
			String filecsv = 'Wensdatum portering,Hoofdnummer,Operator (telecomprovider),Enkelvoudige nummers,(of),Nummerblokken (reeks/blok van 10 /100 /1000 nummers):,,nummer\n';
			filecsv += '24-05-2015,12334454,KNL,,,34343430,t/m,34343439';
			filecsv += '25-05-2015,1233445,KNL,123434343,,,t/m,';
			filecsv += '25-05-2015,12334489,XYZ,,,678999990,t/m,678999999';
			filecsv += '27-05-2015,767676,ABC,7676767676,,,t/m,';
			
			compController.fileBody = Blob.valueof(filecsv);
			
			compController.uploadValidateFile();
			
		Test.stopTest();
	}
}