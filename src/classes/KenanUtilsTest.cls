/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
@isTest
private class KenanUtilsTest {
	
	private static final String JSON_STRING = '{ "errorName": "test error name", "errorTextId": "test text id", "errorCategory": "error category test", "errorClass": "error class test", "errorCode": "error code test", "errorFileName": "error filename test", "errorFunctionName": "test error function name", "errorObjectName": "test error object name", "errorObjectFieldName": "test object field name", "errorLineNumber": "Error line number", "errorMessage": "test error message", "message": "test message", "errorDetails": "test error details", "extraInformation": "extra info test"}';
	
	@testSetup
	static void setup() {

	}

	@isTest
	static void testConvertFromUnix() {
		Long timestamp = DateTime.newInstance(2016, 7, 11, 0, 0, 0).getTime();

		Test.startTest();
		DateTime dteTme = KenanUtils.convertFromUnix(timestamp);
		Test.stopTest();

		System.assertNotEquals(null, dteTme);
		System.assertEquals(2016, dteTme.year());
		System.assertEquals(7, dteTme.month());
		System.assertEquals(11, dteTme.day());
		System.assertEquals(0, dteTme.hour());
		System.assertEquals(0, dteTme.minute());
		System.assertEquals(0, dteTme.second());
	}

	@isTest
	static void testConvertToUnix() {
		DateTime dte = DateTime.newInstance(2016, 7, 11, 0, 0, 0);
		Long timestamp = dte.getTime();

		Test.startTest();
		Long convertedTimestamp = KenanUtils.convertToUnix(dte);
		Test.stopTest();

		System.assertEquals(timestamp, convertedTimestamp);
	}

	@isTest
	static void testGetExternalDataMap() {
		Map<String, Object> objectMap = new Map<String, Object>{
			'Key1' => 'Value1',
			'Key2' => 'Value2'
		};

		Test.startTest();
		Map<String, String> dataMap = KenanUtils.getExternalDataMap(objectMap);
		Test.stopTest();

		for (String key: dataMap.keySet()) {
			String val = dataMap.get(key);
			String objVal = (String) objectMap.get(key);

			System.assertEquals(objVal, val);
		}
	}

	@isTest
	static void testHandleException_500() {
		HttpResponse response = new HttpResponse();
		response.setStatusCode(500);
		response.setBody(JSON_STRING);

		Test.startTest();
		KenanException kex = KenanUtils.handleException(response);
		Test.stopTest();

		System.assertEquals('test error name', kex.errorName);
		System.assertEquals('test text id', kex.errorTextId);
		System.assertEquals('error category test', kex.errorCategory);
		System.assertEquals('error class test', kex.errorClass);
		System.assertEquals('error code test', kex.errorCode);
		System.assertEquals('error filename test', kex.errorFileName);
		System.assertEquals('test error function name', kex.errorFunctionName);
		System.assertEquals('test error object name', kex.errorObjectName);
		System.assertEquals('test object field name', kex.errorObjectFieldName);
		System.assertEquals('Error line number', kex.errorLineNumber);
		System.assertEquals('test error message', kex.errorMessage);
		System.assertEquals('test message', kex.message);
		System.assertEquals('test error details', kex.errorDetails);
		System.assertEquals('extra info test', kex.extraInformation);
	}

	@isTest
	static void testHandleException_404() {
		HttpResponse response = new HttpResponse();
		response.setStatusCode(404);
		response.setStatus('Not found');
		response.setBody(JSON_STRING);

		Test.startTest();
		KenanException kex = KenanUtils.handleException(response);
		Test.stopTest();

		System.assertEquals('404', kex.errorTextId);
		System.assertEquals('Not found', kex.errorMessage);
	}

	@isTest
	static void testFixDateTime_String() {

		Test.startTest();
		DateTime dteTme = KenanUtils.fixDateTime('2016-07-11T00:00:00.000Z');
		Test.stopTest();

		System.assertNotEquals(null, dteTme);
		System.assertEquals(2016, dteTme.year());
		System.assertEquals(7, dteTme.month());
		System.assertEquals(11, dteTme.day());
		System.assertEquals(0, dteTme.hour());
		System.assertEquals(0, dteTme.minute());
		System.assertEquals(0, dteTme.second());
	}

	@isTest
	static void testFixDateTime_DateTime() {
		DateTime dte = DateTime.newInstance(2016, 7, 11, 0, 0, 0);

		Test.startTest();
		DateTime dteTme = KenanUtils.fixDateTime(dte);
		Test.stopTest();

		System.assertNotEquals(null, dteTme);
		System.assertEquals(2016, dteTme.year());
		System.assertEquals(7, dteTme.month());
		System.assertEquals(11, dteTme.day());
		System.assertEquals(0, dteTme.hour());
		System.assertEquals(0, dteTme.minute());
		System.assertEquals(0, dteTme.second());
	}

	@isTest
	static void testGetGMTFormattedDateString_Success() {
		Datetime theDate = Datetime.newInstance(2017, 1, 31, 0, 0, 0);

		String expectedDateString = '2017-01-31T00%3A00%3A00.000Z';

		Test.startTest();
		String gmtDateString = KenanUtils.getGMTFormattedDateString(theDate);
		Test.stopTest();

		System.assertEquals(expectedDateString, gmtDateString);
	}

	@isTest
	static void testGetGMTFormattedDateString_Failure() {
		Datetime theDate = Datetime.newInstance(2017, 1, 31, 0, 0, 0);

		String expectedDateString = '2017-02-26T00%3A00%3A00.000Z';

		Test.startTest();
		String gmtDateString = KenanUtils.getGMTFormattedDateString(theDate);
		Test.stopTest();

		System.assertNotEquals(expectedDateString, gmtDateString);
	}
}