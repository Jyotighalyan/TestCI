@isTest
private class KenanExceptionTest {
	
	@isTest
	static void testStandardConstructor() {
		Test.startTest();
		KenanException ex = new KenanException();
		Test.stopTest();

		System.assertNotEquals(null, ex, 'Standard Constructor failed');
		System.assertEquals(null, ex.friendlyErrorMessage, 'Standard Constructor Failed');
	    System.assertEquals(null, ex.errorName, 'Standard Constructor Failed');
	    System.assertEquals(null, ex.errorTextId, 'Standard Constructor Failed');
	    System.assertEquals(null, ex.errorCategory, 'Standard Constructor Failed');
		System.assertEquals(null, ex.errorClass, 'Standard Constructor Failed');
		System.assertEquals(null, ex.errorCode, 'Standard Constructor Failed');
		System.assertEquals(null, ex.errorFileName, 'Standard Constructor Failed');
		System.assertEquals(null, ex.errorFunctionName,' Standard Constructor Failed');
		System.assertEquals(null, ex.errorObjectName, 'Standard Constructor Failed');
		System.assertEquals(null, ex.errorObjectFieldName, 'Standard Constructor Failed');
		System.assertEquals(null, ex.errorLineNumber, 'Standard Constructor Failed');
		System.assertEquals(null, ex.errorMessage, 'Standard Constructor Failed');
		System.assertEquals(null, ex.message, 'Standard Constructor Failed');
		System.assertEquals(null, ex.errorDetails, 'Standard Constructor Failed');
		System.assertEquals(null, ex.extraInformation, 'Standard Constructor Failed');
	}

	@isTest
	static void testResponse500Constructor() {

		HttpResponse response = new HttpResponse();
		response.setBody(errorText);
		response.setStatusCode(500);
		Test.startTest();
		KenanException ex = new KenanException(response);
		Test.stopTest();

		System.assertNotEquals(null, ex, 'HTTP Response Constructor failed');
		System.assertNOtEquals(null, ex.friendlyErrorMessage, 'HTTP Response Constructor Failed');
	    System.assertNotEquals(null, ex.errorName, 'HTTP Response Constructor Failed');
	    System.assertEquals(null, ex.errorTextId, 'HTTP Response Constructor Failed');
	    System.assertNotEquals(null, ex.errorCategory, 'HTTP Response Constructor Failed');
		System.assertEquals(null, ex.errorClass, 'HTTP Response Constructor Failed');
		System.assertEquals(null, ex.errorCode, 'HTTP Response Constructor Failed');
		System.assertNotEquals(null, ex.errorFileName, 'HTTP Response Constructor Failed');
		System.assertNotEquals(null, ex.errorFunctionName,' HTTP Response Constructor Failed');
		System.assertEquals(null, ex.errorObjectName, 'HTTP Response Constructor Failed');
		System.assertEquals(null, ex.errorObjectFieldName, 'HTTP Response Constructor Failed');
		System.assertNotEquals(null, ex.errorLineNumber, 'HTTP Response Constructor Failed');
		System.assertNotEquals(null, ex.errorMessage, 'HTTP Response Constructor Failed');
		System.assertNotEquals(null, ex.message, 'HTTP Response Constructor Failed');
		System.assertEquals(null, ex.errorDetails, 'HTTP Response Constructor Failed');
		System.assertNotEquals(null, ex.extraInformation, 'HTTP Response Constructor Failed');
	}

	@isTest
	static void testResponse400Constructor() {

		HttpResponse response = new HttpResponse();
		response.setBody(errorText);
		response.setStatusCode(400);
		Test.startTest();
		KenanException ex = new KenanException(response);
		Test.stopTest();

		System.assertNotEquals(null, ex, 'HTTP Response Constructor failed');
		System.assertNotEquals(null, ex.friendlyErrorMessage, 'HTTP Response Constructor Failed');
	    System.assertEquals(null, ex.errorName, 'HTTP Response Constructor Failed');
	    System.assertEquals('400', ex.errorTextId, 'HTTP Response Constructor Failed');
	    System.assertEquals(null, ex.errorCategory, 'HTTP Response Constructor Failed');
		System.assertEquals(null, ex.errorClass, 'HTTP Response Constructor Failed');
		System.assertEquals(null, ex.errorCode, 'HTTP Response Constructor Failed');
		System.assertEquals(null, ex.errorFileName, 'HTTP Response Constructor Failed');
		System.assertEquals(null, ex.errorFunctionName,' HTTP Response Constructor Failed');
		System.assertEquals(null, ex.errorObjectName, 'HTTP Response Constructor Failed');
		System.assertEquals(null, ex.errorObjectFieldName, 'HTTP Response Constructor Failed');
		System.assertEquals(null, ex.errorLineNumber, 'HTTP Response Constructor Failed');
		System.assertEquals(null, ex.errorMessage, 'HTTP Response Constructor Failed');
		System.assertEquals(null, ex.message, 'HTTP Response Constructor Failed');
		System.assertEquals(null, ex.errorDetails, 'HTTP Response Constructor Failed');
		System.assertEquals(null, ex.extraInformation, 'HTTP Response Constructor Failed');
	}
	
	private static String errorText = '{"errorName":"ck_ORACLE_ERROR","errorTextId":null,"errorCategory":"BackEnd","errorClass":null,"errorCode":null,"errorFileName":"ora_SqlcaToExceptionDB.c","errorFunctionName":"__ck_Raise_OracleDB","errorObjectName":null,"errorObjectFieldName":null,"errorLineNumber":105,"errorMessage":"An Oracle Error has occured","message":"ck_ORACLE_ERROR : {BSD_ERRORTEXT=ORA-20001: 158004, TRIG: INSERT/UPDATE Failed: Overlapping active/inactive dates for an external_id_type that ismarked as unique in EXTERNAL_ID_TYPE_REF. ORA-06512: at KENANFX.CUSTOMER_ID_ACCT_MAP_ATRIG, line 160 ORA-04088: error during execution of trigger KENANFX.CUSTOMER_ID_ACCT_MAP_ATRIG ORA-06512: at KENANFX.CIAM_INSERT, line 27 ORA-06512: at line 1, BSD_FORMAT=Oracle error has occurred. Error=(ORA-20001: 158004, TRIG: INSERT/UPDATE Failed: Overlapping active/inactive dates for an external_id_type that ismarked as unique in EXTERNAL_ID_TYPE_REF. ORA-06512: at KENANFX.CUSTOMER_ID_ACCT_MAP_ATRIG, line 160 ORA-04088: error during execution of tri) Line=(2180) File=(gen/bp_AccountIdORA.pc) Function=(executeciam_insertDB) Trigger=(NULL), BSD_EN=Oracle error has occurred. Error=({0}) Line=({1}) File=({2}) Function=({3}) Trigger=({4}), BSD_APPNAME=KenanSystem, BSD_LINE=2180, BSD_FUNCTION=executeciam_insertDB, ReplacementList=[Ljava.lang.Object;@22327184, BSD_FILE=gen/bp_AccountIdORA.pc, BSD_TEXTID=8}","errorDetails":null,"extraInformation":{}}';
}