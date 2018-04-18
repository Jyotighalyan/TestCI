/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Unit Test for use in Salesforce Kenan Connection Service
*/
@isTest
private class KenanServiceItemMapperTest {
    
    @testSetup
    static void setup() {
        KenanServiceConnection__c settings = new KenanServiceConnection__c(
            Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=',
            Session_Timeout__c = '120000',
            Connection_URL__c = 'https://kenan-dev-pubelb-amdocs-1924041402.eu-central-1.elb.amazonaws.com',
            REST_Application_Base__c = '/kenan-salesforce-api/rest',
            Stored_Language_Code__c = '1'
        );

        insert settings;
    }
    
    @isTest
    static void getEnumeratedValuesTest(){
        
        KenanServiceItem serviceItem = new KenanServiceItem();
        Datetime curDate = Datetime.now();

        serviceItem.activeDate = Datetime.newInstance(2016, 7, 6, 0, 0, 0);
        serviceItem.annotation = 'Test Annotation';
        serviceItem.annotation2 = 'Test Annotation 2';
        serviceItem.currencyCode = 'KRW';
        serviceItem.inactiveDate = Datetime.newInstance(2017, 7, 6, 0, 0, 0);
        serviceItem.instanceId = '1';
        serviceItem.itemId = 0;
        serviceItem.itemType = 0;
        serviceItem.rate = 0.0;
        serviceItem.salesforceId = '1';
        serviceItem.units = 2;
        serviceItem.unitsType = 'Money';
        serviceItem.discountAmount = 5;
        serviceItem.discountPercent = 0.5;
        serviceItem.unitCreditUnitsFree = 10;
        serviceItem.unitCreditAmountFree = 15;
        
        Test.startTest();
        KenanServiceItemMapper mapper = new KenanServiceItemMapper();
        Map<String,Object> objectMap = mapper.getEnumeratedValues(serviceItem);
        Test.stopTest();
        
        System.assertEquals(serviceItem.activeDate, objectMap.get('activeDate'));
        System.assertEquals(serviceItem.annotation, objectMap.get('annotation'));
        System.assertEquals(serviceItem.annotation2, objectMap.get('annotation2'));
        System.assertEquals(serviceItem.currencyCode, 'KRW');
        System.assertEquals(serviceItem.inactiveDate, objectMap.get('inactiveDate'));
        System.assertEquals(serviceItem.instanceId, objectMap.get('instanceId'));
        System.assertEquals(serviceItem.itemId, objectMap.get('itemId'));
        System.assertEquals(serviceItem.itemType, objectMap.get('itemType'));
        System.assertEquals(serviceItem.rate, objectMap.get('rate'));
        System.assertEquals(serviceItem.salesforceId, objectMap.get('salesforceId'));
        System.assertEquals(serviceItem.units, objectMap.get('units'));
        System.assertEquals(serviceItem.discountAmount, objectMap.get('discountAmount'));
        System.assertEquals(serviceItem.discountPercent * 100, objectMap.get('discountPercent'));
        System.assertEquals(serviceItem.unitCreditUnitsFree, objectMap.get('unitCreditUnitsFree'));
        System.assertEquals(serviceItem.unitCreditAmountFree, objectMap.get('unitCreditAmountFree'));
        System.assertEquals('1', objectMap.get('unitsType'));
    }
    
    
    @isTest
    static void getDisplayValuesTest(){
        
        Map<String,Object> objectMap = new Map<String,Object>();
        Datetime curDate = Datetime.now();
        
        objectMap.put('activeDate', '2016-07-06T00:00:00.000Z');
        objectMap.put('annotation', 'Test Annotation');
        objectMap.put('annotation2', 'Test Annotation 2');
        objectMap.put('currencyCode', '10');
        objectMap.put('inactiveDate', '2017-07-06T00:00:00.000Z');
        objectMap.put('instanceId', '1');
        objectMap.put('itemId', 0);
        objectMap.put('itemType', 0);
        objectMap.put('rate', 0.0);
        objectMap.put('salesforceId', '1');
        objectMap.put('units', 2);
        objectMap.put('unitsType', 1);
        objectMap.put('unitCreditUnitsFree', 5);

        Test.startTest();
        KenanServiceItemMapper mapper = new KenanServiceItemMapper();
        KenanServiceItem serviceItem = mapper.getDisplayValues(objectMap);
        Test.stopTest();

        System.assertEquals(Datetime.newInstance(2016, 7, 6, 0, 0, 0), serviceItem.activeDate);
        System.assertEquals(objectMap.get('annotation'), serviceItem.annotation);
        System.assertEquals(objectMap.get('annotation2'), serviceItem.annotation2);
        System.assertEquals('KRW', serviceItem.currencyCode);
        System.assertEquals(Datetime.newInstance(2017, 7, 6, 0, 0, 0), serviceItem.inactiveDate);
        System.assertEquals(objectMap.get('instanceId'), serviceItem.instanceId);
        System.assertEquals(objectMap.get('itemId'), serviceItem.itemId);
        System.assertEquals(objectMap.get('itemType'), serviceItem.itemType);
        System.assertEquals(objectMap.get('rate'), serviceItem.rate);
        System.assertEquals(objectMap.get('salesforceId'), serviceItem.salesforceId);
        System.assertEquals(objectMap.get('units'), serviceItem.units);
        System.assertEquals(objectMap.get('unitCreditUnitsFree'), serviceItem.unitCreditUnitsFree);
        System.assertEquals('Money', serviceItem.unitsType);
    }

    @isTest
    static void getDisplayValuesAlternateTest(){
        
        Map<String,Object> objectMap = new Map<String,Object>();
        
        KenanServiceItem item = new KenanServiceItem();
        item.activeDate = Datetime.newInstance(2016, 7, 6, 0, 0, 0);
        item.annotation = 'Test Annotation';
        item.annotation2 = 'Test Annotation 2';
        item.currencyCode = '10';
        item.inactiveDate = Datetime.newInstance(2017, 7, 6, 0, 0, 0);
        item.instanceId = '1';
        item.itemId = 0;
        item.itemType = 0;
        item.rate = 0.0;
        item.salesforceId = '1';

        Test.startTest();
        KenanServiceItemMapper mapper = new KenanServiceItemMapper();
        mapper.getDisplayValues(item);
        Test.stopTest();

        //System.assertEquals(Datetime.newInstance(2016, 7, 6, 0, 0, 0), serviceItem.activeDate);
  //      System.assertEquals(item.annotation, serviceItem.annotation);
  //      System.assertEquals(item.annotation2, serviceItem.annotation2);
  //      System.assertEquals(item.currencyCode, serviceItem.currencyCode);
  //      System.assertEquals(Datetime.newInstance(2017, 7, 6, 0, 0, 0), serviceItem.inactiveDate);
  //      System.assertEquals(item.instanceId, serviceItem.instanceId);
  //      System.assertEquals(item.itemId, serviceItem.itemId);
  //      System.assertEquals(item.itemType, serviceItem.itemType);
  //      System.assertEquals(item.rate, serviceItem.rate);
  //      System.assertEquals(item.salesforceId, serviceItem.salesforceId);
    }
}