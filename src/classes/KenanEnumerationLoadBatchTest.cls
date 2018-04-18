/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Unit Test for use in Salesforce Kenan Connection Service
*/
@isTest
private class KenanEnumerationLoadBatchTest {
	
	@testSetup
	static void setup() {
		// Create common test accounts
        Account samAct = new Account();
		samAct.Name = 'Sample Account';
		insert samAct; 

        KenanServiceConnection__c ksc = new KenanServiceConnection__c();
		ksc.Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=';
		ksc.Session_Timeout__c = '120000';
		ksc.Connection_URL__c = 'https://kenan-dev-pubelb-amdocs-1924041402.eu-central-1.elb.amazonaws.com';
		ksc.REST_Application_Base__c = '/kenan-salesforce-api/rest';
		insert ksc; 
	}

	@isTest
	static void testEnumerationLoadBatch_LoadData() {
		String enumName = 'UnitsTypeBean';

		KenanEnumerationServiceCalloutMock enumerationMock = new KenanEnumerationServiceCalloutMock();
        enumerationMock.enumName = enumName;
        Test.setMock(HttpCalloutMock.class, enumerationMock);
        Test.setMock(WebServiceMock.class, new KenanEnumLoaderCustomMetaDataMock());

		String sessionId = UserInfo.getSessionId(); 

		KenanEnumerationLoadBatch loadBatch = new KenanEnumerationLoadBatch(sessionId, true);

		Test.startTest();
		Database.executeBatch(loadBatch, 200);
		Test.stopTest();
	}

	@isTest
	static void testEnumerationLoadBatch_DoNotLoadData() {
		String enumName = 'UnitsTypeBean';

		KenanEnumerationServiceCalloutMock enumerationMock = new KenanEnumerationServiceCalloutMock();
        enumerationMock.enumName = enumName;
        Test.setMock(HttpCalloutMock.class, enumerationMock);
        Test.setMock(WebServiceMock.class, new KenanEnumLoaderCustomMetaDataMock());

		String sessionId = UserInfo.getSessionId(); 

		KenanEnumerationLoadBatch loadBatch = new KenanEnumerationLoadBatch(sessionId, false);

		Test.startTest();
		Database.executeBatch(loadBatch, 200);
		Test.stopTest();
	}
}