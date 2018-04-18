/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Unit Test for use in Salesforce Kenan Connection Service
*/
@isTest
private class KenanEnumLoaderCustomMetaDataTest {
	
	@isTest static void ConstructorTest(){
		Test.startTest();
		KenanEnumLoaderCustomMetaData km = new KenanEnumLoaderCustomMetaData();
		Test.stopTest();
		System.assertNotEquals(null, km);	
	}
	
	@isTest static void ConstructorWithSessionTest(){
		Test.startTest();
		String sessionId = UserInfo.getSessionId(); 
		KenanEnumLoaderCustomMetaData km = new KenanEnumLoaderCustomMetaData(sessionId);
		Test.stopTest();
		System.assertNotEquals(null, km);	
	}
	
	@isTest static void executeLoadTrueTest(){
		KenanEnumeration ke = (KenanEnumeration) JSON.deserialize(sampleTextEnumExist, KenanEnumeration.class);
		
		Test.setMock(WebServiceMock.class, new KenanEnumLoaderCustomMetaDataMock());

		Test.startTest();
		String sessionId = UserInfo.getSessionId(); 
		KenanEnumLoaderCustomMetaData km = new KenanEnumLoaderCustomMetaData(sessionId);
		
		km.executeLoad(sessionId, ke, true);
		Test.stopTest();	
		System.assertNotEquals(null, km);
	}
	
	@isTest static void executeLoadFalseTest(){
		KenanEnumeration ke = (KenanEnumeration) JSON.deserialize(sampleText, KenanEnumeration.class);
		
		Test.setMock(WebServiceMock.class, new KenanEnumLoaderCustomMetaDataMock());

		Test.startTest();
		String sessionId = UserInfo.getSessionId(); 
		KenanEnumLoaderCustomMetaData km = new KenanEnumLoaderCustomMetaData(sessionId);
		km.executeLoad(sessionId, ke, false);
		Test.stopTest();	
		System.assertNotEquals(null, km);
		
	}
	
	@isTest static void executeLoadFalseTest_EnumExist(){
		KenanEnumeration ke = (KenanEnumeration) JSON.deserialize(sampleTextEnumExist, KenanEnumeration.class);
		
		Test.setMock(WebServiceMock.class, new KenanEnumLoaderCustomMetaDataMock());

		Test.startTest();
		String sessionId = UserInfo.getSessionId(); 
		KenanEnumLoaderCustomMetaData km = new KenanEnumLoaderCustomMetaData(sessionId);
		km.executeLoad(sessionId, ke, false);
		Test.stopTest();	
		System.assertNotEquals(null, km);
		
	}

	private static String sampleText = '{"fieldList":["ConfigTagId:String","LanguageCode:Integer","IsDefault:Boolean","ShortDisplay:String","AccessRegion:String","IsInternal:Boolean","DisplayValue:String"],"keyList":["LanguageCode:Integer","AccessRegion:String"],"enumName":"AccessRegionBean","dataList":[["Kenan FX 3.0","1","false","LATA1","LATA1","false","LATA1"],["Kenan FX 3.0","1","false","LATA2","LATA2","false","LATA2"],["Kenan FX 3.0","1","false","LATA3","LATA3","false","LATA3"]]}';
	private static String sampleTextEnumExist = '{"fieldList":["ConfigTagId:String","LanguageCode:Integer","IsDefault:Boolean","ShortDisplay:String","AccessRegion:String","IsInternal:Boolean","DisplayValue:String"],"keyList":["LanguageCode:Integer","AccessRegion:String"],"enumName":"AccountCategoryBean","dataList":[["Kenan FX 3.0","1","false","LATA1","LATA1","false","LATA1"],["Kenan FX 3.0","1","false","LATA2","LATA2","false","LATA2"],["Kenan FX 3.0","1","false","LATA3","LATA3","false","LATA3"]]}';
}