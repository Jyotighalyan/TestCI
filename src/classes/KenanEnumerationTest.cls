@isTest
private class KenanEnumerationTest {

    @isTest static void constructorTest() {
        Test.startTest();
        KenanEnumeration ke = new KenanEnumeration();
        List<Map<String, String>> valueList = ke.getValues();
        Map<String, String> fieldList = ke.getFieldNames();
        Map<String, String> keyList = ke.getKeyFieldNames();
        Test.stopTest();
        
        System.assertEquals(ke.dataList.size(), 0,'Constructor did not initialize dataList to an empty list');
        System.assertEquals(ke.fieldList.size(), 0,'Constructor did not initialize fieldList to an empty list');
        System.assertEquals(ke.keyList.size(), 0,'Constructor did not initialize keyList to an empty list');
        System.assertEquals(valueList.size(),0,'Constructor did not initialize valueList to an empty list');
        System.assertEquals(fieldList.size(),0,'Constructor did not initialize fieldList to an empty list');
        System.assertEquals(keyList.size(),0,'Constructor did not initialize keyList to an empty list');
    }
    
    @isTest static void enumNameTest() {
        Test.startTest();
        KenanEnumeration ke = (KenanEnumeration) JSON.deserialize(sampleText, KenanEnumeration.class);
        List<Map<String, String>> valueList = ke.getValues();
        Map<String, String> fieldList = ke.getFieldNames();
        Map<String, String> keyList = ke.getKeyFieldNames();
        Test.stopTest();
        
        System.assertEquals(ke.dataList.size(), 3,'Constructor did not initialize dataList to an empty list');
        System.assertEquals(ke.fieldList.size(), 7,'Constructor did not initialize fieldList to an empty list');
        System.assertEquals(ke.keyList.size(), 2,'Constructor did not initialize keyList to an empty list');
        System.assertEquals(valueList.size(),3,'Constructor did not initialize valueList to an empty list');
        System.assertEquals(fieldList.size(),7,'Constructor did not initialize fieldList to an empty list');
        System.assertEquals(keyList.size(),2,'Constructor did not initialize keyList to an empty list');
    }
    
    private static String sampleText = '{"fieldList":["ConfigTagId:String","LanguageCode:Integer","IsDefault:Boolean","ShortDisplay:String","AccessRegion:String","IsInternal:Boolean","DisplayValue:String"],"keyList":["LanguageCode:Integer","AccessRegion:String"],"enumName":"AccessRegionBean","dataList":[["Kenan FX 3.0","1","false","LATA1","LATA1","false","LATA1"],["Kenan FX 3.0","1","false","LATA2","LATA2","false","LATA2"],["Kenan FX 3.0","1","false","LATA3","LATA3","false","LATA3"]]}';
    
}