/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
@isTest
global class KenanAccountItemCalloutMock implements HttpCalloutMock {
		
	global Integer numberOfRecords { get; set; }
	
	global HttpResponse respond ( HTTPRequest req ) {
		List<KenanAccountItem> jsonList = new List<KenanAccountItem>();
		String jsonString = '';
		if (numberOfRecords == 1){
			jsonString = JSON.serialize(createAccountItem(1));
		} else {
			for (Integer i = 0; i < numberOfRecords; i++){
				jsonList.add(createAccountItem(i));
			}
			jsonString = JSON.serialize(jsonList);
		}
		
		HttpResponse res = new HttpResponse();
		res.setHeader ('Content-Type', 'application/json');
		res.setBody (jsonString);
		res.setStatusCode ( 200 );
		System.assertNotEquals ( null, res.getBody(), 'response body should not be null' );
		return res;
	}

	private KenanAccountItem createAccountItem(Integer num) {
		KenanAccountItem accountItem = new KenanAccountItem();

		accountItem.instanceId = '0000:' + num;
		accountItem.itemId = num;
		accountItem.itemType = num;
		accountItem.currencyCode = '7';
		accountItem.annotation = 'Test Annotation';
		accountItem.annotation2 = 'Test Annotation 2';
		accountItem.salesforceId = '1';
		accountItem.units = 1;
		accountItem.rate = 0.0;
		accountItem.inactiveDate = Datetime.now().addDays(-30);

		return accountItem;
	}
}