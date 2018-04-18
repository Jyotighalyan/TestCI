/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Unit Test for use in Salesforce Kenan Connection Service
*/
@isTest
private class KenanEnumerationHelperTest {
	
	private static String sampleText = '{"fieldList":["ConfigTagId:String","LanguageCode:Integer","IsDefault:Boolean","ShortDisplay:String","AccessRegion:String","IsInternal:Boolean","DisplayValue:String"],"keyList":["LanguageCode:Integer","AccessRegion:String"],"enumName":"AccountCategoryBean","dataList":[["Kenan FX 3.0","1","false","LATA1","LATA1","false","LATA1"],["Kenan FX 3.0","1","false","LATA2","LATA2","false","LATA2"],["Kenan FX 3.0","1","false","LATA3","LATA3","false","LATA3"]]}';
	private static String sampleBaseText = '{"fieldList":["ConfigTagId:String","LanguageCode:Integer","IsDefault:Boolean","ShortDisplay:String","AccessRegion:String","IsInternal:Boolean","DisplayValue:String"],"keyList":["LanguageCode:Integer","AccessRegion:String"],"enumName":"AccountCategoryBean","dataList":[';
	private static String sampleDataText = '["Kenan FX 3.0","1","false","LATA1","LATA1","false","LATA1"],';
	private static String sampleSuffixText = ']}';
	@testSetup
	static void setup() {

	}

	@isTest
	static void testCheckMetadataAPIConnection() {
		KenanEnumerationHelper.mdApiStatus = KenanEnumerationHelper.MetaStatus.NOT_CHECKED;
		String sessionId = UserInfo.getSessionId(); 

		Test.setMock(WebServiceMock.class, new KenanEnumLoaderCustomMetaDataMock());

		Test.startTest();
		Boolean status = KenanEnumerationHelper.checkMetadataAPIConnection(sessionId);
		Test.stopTest();

		System.assert(status);
	}

	@isTest
	static void testTransformToCustomMetadataAndCreate() {
		KenanEnumeration enumeration = (KenanEnumeration) JSON.deserialize(sampleText, KenanEnumeration.class);
        List<Map<String, String>> valueList = enumeration.getValues();
        Map<String, String> fieldList = enumeration.getFieldNames();
        Map<String, String> keyList = enumeration.getKeyFieldNames();

		String sessionId = UserInfo.getSessionId(); 

		Test.setMock(WebServiceMock.class, new KenanEnumLoaderCustomMetaDataMock());

		Test.startTest();
		KenanEnumerationHelper.transformToCustomMetadataAndCreate(enumeration, sessionId);
		Test.stopTest();
	}

	@isTest
	static void testTransformToCustomMetadataAndCreate200() {
		String jsonString = sampleBaseText;
		for (Integer i = 0; i<201; i++){
			jsonString = jsonString + sampleDataText;
		}
		jsonString = jsonString.removeEnd(',');
		jsonString = jsonString + sampleSuffixText;
		system.debug('jsonString:' + jsonString);

		KenanEnumeration enumeration = (KenanEnumeration) JSON.deserialize(jsonString, KenanEnumeration.class);
        //List<Map<String, String>> valueList = enumeration.getValues();
        //Map<String, String> fieldList = enumeration.getFieldNames();
        //Map<String, String> keyList = enumeration.getKeyFieldNames();

		String sessionId = UserInfo.getSessionId(); 

		Test.setMock(WebServiceMock.class, new KenanEnumLoaderCustomMetaDataMock());

		Test.startTest();
		KenanEnumerationHelper.transformToCustomMetadataAndCreate(enumeration, sessionId);
		Test.stopTest();
	}

	@isTest
	static void testDeleteCustomMetadata() {

		String sessionId = UserInfo.getSessionId();
		KenanEnumeration enumeration = (KenanEnumeration) JSON.deserialize(sampleText, KenanEnumeration.class);
		Test.setMock(WebServiceMock.class, new KenanEnumLoaderCustomMetaDataMock());
		Test.startTest();
		KenanEnumerationHelper.deleteCustomMetadata(enumeration, sessionId);
		Test.stopTest();

		//System.assertEquals(val, enumValue);
	}

	@isTest
	static void testCreateCustomSetting() {
		String sessionId = UserInfo.getSessionId(); 

		Test.setMock(WebServiceMock.class, new KenanEnumLoaderCustomMetaDataMock());

		Test.startTest();
		KenanEnumerationHelper.createCustomSetting('AccountCategoryBean', sessionId);
		Test.stopTest();

	}

	@isTest 
	static void testAddCustomField() {
		String sessionId = UserInfo.getSessionId();
		Map<String, String> enumFieldMap = new Map<String, String>{
			'Key' => 'AccountCategory'
		};

		Test.setMock(WebServiceMock.class, new KenanEnumLoaderCustomMetaDataMock());

		Test.startTest();
		KenanEnumerationHelper.addCustomFields(enumFieldMap, 'AccountCategoryBean', sessionId);
		Test.stopTest();
	}

	@isTest
	static void testGetEnumDisplayValue() {
		String val = 'SME';

		Test.startTest();
		String displayValue = KenanEnumerationHelper.getEnumDisplayValue('AccountCategoryBean__mdt', 'AccountCategory__c', '1', '1', 'DisplayValue__c');
		Test.stopTest();

		System.assertEquals(val, displayValue);
	}

	@isTest
	static void testGetEnumDisplayValueAlternate() {
		String val = 'SME';

		Test.startTest();
		String displayValue = KenanEnumerationHelper.getEnumDisplayValue('AccountCategoryBean__mdt', 'AccountCategory__c', '1', 'DisplayValue__c');
		Test.stopTest();

		System.assertEquals(val, displayValue);
	}

	@isTest
	static void testGetEnumKeyVal() {
		String val = '1';

		Test.startTest();
		String enumValue = KenanEnumerationHelper.getEnumKeyValue('AccountCategoryBean__mdt', 'AccountCategory__c', 'SME', '1', 'DisplayValue__c');
		Test.stopTest();

		System.assertEquals(val, enumValue);
	}

	@isTest
	static void testGetEnumKeyValAlternate() {
		String val = '1';

		Test.startTest();
		String enumValue = KenanEnumerationHelper.getEnumKeyValue('AccountCategoryBean__mdt', 'AccountCategory__c', 'SME', 'DisplayValue__c');
		Test.stopTest();

		System.assertEquals(val, enumValue);
	}

	@isTest
	static void testgetDisplayCurrencyValue() {
		String val = '1';

		Test.startTest();
		Decimal value = KenanEnumerationHelper.getDisplayCurrencyValue(2000, '7', '1');
		Test.stopTest();

		System.assertEquals(20.00, value);
	}

	@isTest
	static void testgetAPICurrencyValue() {
		String val = '1';

		Test.startTest();
		Integer enumValue = KenanEnumerationHelper.getAPICurrencyValue(20.00, '7', '1');
		Test.stopTest();

		System.assertEquals(2000, enumValue);
	}

}