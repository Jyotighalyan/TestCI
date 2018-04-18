/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
@isTest
global class KenanAccountErrorCalloutMock implements HttpCalloutMock {
	
	global HttpResponse respond ( HTTPRequest req ) {
		HttpResponse res = new HttpResponse();
		res.setHeader ('Content-Type', 'application/json');
		res.setBody('{"errorName":"Invalid Format","message":"The request was in an invalid format"}');
		res.setStatusCode ( 400 );
		res.setStatus('The request was in an invalid format');
		System.assertNotEquals ( null, res.getBody(), 'response body should not be null' );
		return res;
	}

}