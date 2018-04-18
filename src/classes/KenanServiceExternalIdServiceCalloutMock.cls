/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
@isTest
global class KenanServiceExternalIdServiceCalloutMock implements HttpCalloutMock {
	
	private String jsonService = '{ "activeDate": "2016-07-07T00:00:00.000Z","createDt": "2016-07-07T00:00:00.000Z","inactiveDate": "2017-07-07T00:00:00.000Z","intendedViewEffectiveDt": "2016-07-07T00:00:00.000Z","isCurrent": true,"isFromInventory": true,"prevViewId": 0,"serviceExternalId": "serviceExternalId","serviceExternalIdType": 0,"serviceInternalId": 0,"serviceInternalIdResets": 0,"viewCreatedDt": "2016-07-07T00:00:00.000Z","viewEffectiveDt": "2016-07-07T00:00:00.000Z","viewId": 0,"viewStatus": 0}';
		
	global Integer numberOfRecords { get; set; }
	
	global HttpResponse respond ( HTTPRequest req ) {
		List<String> jsonList = new List<String>();
		String jsonString = '';
		if (numberOfRecords == 1){
			jsonString = jsonService;
		} else {
			for (Integer i = 0; i < numberOfRecords; i++){
				jsonList.add('{ "activeDate": "2016-07-07T00:00:00.000Z","createDt": "2016-07-07T00:00:00.000Z","inactiveDate": "2017-07-07T00:00:00.000Z","intendedViewEffectiveDt": "2016-07-07T00:00:00.000Z","isCurrent": true,"isFromInventory": true,"prevViewId": 0,"serviceExternalId": "serviceExternalId","serviceExternalIdType": 0,"serviceInternalId": 0,"serviceInternalIdResets": 0,"viewCreatedDt": "2016-07-07T00:00:00.000Z","viewEffectiveDt": "2016-07-07T00:00:00.000Z","viewId": 0,"viewStatus": 0}');
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
}