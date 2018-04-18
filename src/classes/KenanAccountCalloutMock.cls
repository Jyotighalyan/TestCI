/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan HTTP Mock for testing use in Salesforce Kenan Connection Service
*/
@isTest
global class KenanAccountCalloutMock implements HttpCalloutMock {
	
	global Integer numberOfRecords { get; set; }
	
	global HttpResponse respond ( HTTPRequest req ) {
		List<KenanAccount> jsonList = new List<KenanAccount>();
		String jsonString = '';
		
		if (numberOfRecords == 1){
			jsonString = JSON.serialize(createKenanAccount());
		} else {
			for (Integer i = 0; i < numberOfRecords; i++){
				jsonList.add(createKenanAccount());
			}
			jsonString = JSON.serialize(jsonList);
		}
		
		HttpResponse res = new HttpResponse();
		res.setHeader ('Content-Type', 'application/json');
		res.setBody(jsonString);
		res.setStatusCode ( 200 );
		System.assertNotEquals ( null, res.getBody(), 'response body should not be null' );
		return res;
	}
	
	private KenanAccount createKenanAccount(){
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

	private KenanAccountItem createAccountItem(Integer num) {
		KenanAccountItem accountItem = new KenanAccountItem();

		accountItem.instanceId = '000' + num;
		accountItem.itemId = num;
		accountItem.itemType = num;
		accountItem.rate = num;
		accountItem.currencyCode = '1';

		return accountItem;
	}
}