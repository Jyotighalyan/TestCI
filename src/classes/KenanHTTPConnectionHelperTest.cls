/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanHTTPConnectionHelper Ubnit Tests
*/
@isTest
private class KenanHTTPConnectionHelperTest {
	
	@testSetup
	static void setup() {
		KenanServiceConnection__c ksc = new KenanServiceConnection__c();
		ksc.Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=';
		ksc.Session_Timeout__c = '120000';
		ksc.Connection_URL__c = 'https://kenan-dev-pubelb-amdocs-1924041402.eu-central-1.elb.amazonaws.com';
		ksc.REST_Application_Base__c = '/kenan-salesforce-api/rest';
		insert ksc;
	}

	@isTest static void testSendRequest() {
		KenanHTTPConnectionHelper kch = new KenanHTTPConnectionHelper();
		
		KenanAccountCalloutMock accountMock = new KenanAccountCalloutMock();
		accountMock.numberOfRecords = 1;
		Test.setMock (HttpCalloutMock.class, accountMock);

		KenanAccount acct = createKenanAccount();

		Test.startTest();
		String jsonBody = JSON.serialize(acct);
		String method = 'POST';
		String endpoint = '/accounts/account';
		String serverId = '-1';
		Integer startRecord = 0;
		Integer blockSize = 10;
		
		HttpResponse hr = kch.sendRequest(jsonBody, method, endpoint, startRecord, blockSize);
		Test.stopTest();

		System.assertEquals(jsonBody, hr.getBody());
	}	

	@isTest static void testSendRequest_Error() {
		KenanHTTPConnectionHelper kch = new KenanHTTPConnectionHelper();

		KenanAccountErrorCalloutMock accountMock = new KenanAccountErrorCalloutMock();
		Test.setMock (HttpCalloutMock.class, accountMock);

		KenanAccount acct = createKenanAccount();

		Test.startTest();
		String jsonBody = JSON.serialize(acct);
		String method = 'POST';
		String endpoint = '/accounts/account';
		String serverId = '-1';
		Integer startRecord = 0;
		Integer blockSize = 10;
		
		
		HttpResponse hr = kch.sendRequest(jsonBody, method, endpoint, startRecord, blockSize);
			
		System.assertEquals(400, hr.getStatusCode());
		System.assertEquals('The request was in an invalid format', hr.getStatus());
		
		Test.stopTest();
	}	

	private static KenanAccount createKenanAccount(){
		KenanAccount ka = new KenanAccount();
		ka.extIdList = new List<Map<String, String>>();
		ka.extData = new Map<String, Object>();
		ka.billFname = 'Jack'; 
		ka.billAddress1 = '123 Main St.';
		ka.billCity = 'Allentown';
		ka.billState = 'PA';
		ka.billZip = '18101';
        
        ka.accountItems.add(createAccountItem(1));
		ka.accountItems.add(createAccountItem(2));
        
		return ka;
	}
    
    private static KenanAccountItem createAccountItem(Integer num) {
		KenanAccountItem accountItem = new KenanAccountItem();

		accountItem.instanceId = '000' + num;
		accountItem.itemId = num;
		accountItem.itemType = num;
		accountItem.rate = num;
		accountItem.currencyCode = '1';

		return accountItem;
	}
}