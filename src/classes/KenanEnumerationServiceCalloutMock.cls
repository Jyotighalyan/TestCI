/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
@isTest 
global class KenanEnumerationServiceCalloutMock implements HttpCalloutMock {
	
	//global Integer numberOfRecords { get; set; }
	global String enumName { get; set; }
	
	global HttpResponse respond ( HTTPRequest req ) {

		KenanEnumeration enumeration = new KenanEnumeration();
		enumeration.enumName = enumName;
		enumeration.dataList.add(new List<String>{ 'Test Data List: ' + enumName});
		enumeration.fieldList.add('Test Field List: ' + enumName);
		enumeration.keyList.add('Test Key List: ' + enumName);

		String jsonString = JSON.serialize(enumeration);

		HttpResponse res = new HttpResponse();
		res.setHeader ('Content-Type', 'application/json');
		res.setBody (jsonString);
		res.setStatusCode ( 200 );
		System.assertNotEquals ( null, res.getBody(), 'response body should not be null' );
		return res;
	}
}