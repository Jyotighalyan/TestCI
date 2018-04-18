/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
@isTest
private class KenanServiceItemServiceTest {

    @testSetup static void setup() {
        // Create common test accounts
        Account samAct = new Account();
        samAct.Name = 'Sample Account';
        insert samAct; 

        KenanServiceConnection__c ksc = new KenanServiceConnection__c();
        ksc.Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=';
        ksc.Session_Timeout__c = '120000';
        ksc.Connection_URL__c = 'https://kenan-dev-pubelb-amdocs-1924041402.eu-central-1.elb.amazonaws.com';
        ksc.REST_Application_Base__c = '/kenan-salesforce-api/rest';
        insert ksc; 
    }

    @isTest
    static void testInsertRow() {
        KenanServiceItem ksi = KenanSampleCode.createSampleKenanServiceItem('serviceExternalId', 2);

        KenanServiceItemCalloutMock serviceItemMock = new KenanServiceItemCalloutMock();
        serviceItemMock.numberOfRecords = 1;
        Test.setMock (HttpCalloutMock.class, serviceItemMock);

        Datetime today = Datetime.now();

        Test.startTest();
        KenanServiceItemService kserv = new KenanServiceItemService();
        KenanObject returnedObj = kserv.insertRow(ksi, 'DELETE', 'CEASE');
        Test.stopTest();

        KenanServiceItem serviceItem = (KenanServiceItem) returnedObj;

        System.assertEquals(Datetime.newInstance(2016, 7, 6, 0, 0, 0), serviceItem.activeDate);
        System.assertEquals('Test Annotation', serviceItem.annotation);
        System.assertEquals('Test Annotation 2', serviceItem.annotation2);
        System.assertEquals('KRW', serviceItem.currencyCode);
        System.assertEquals(Datetime.newInstance(2017, 7, 6, 0, 0, 0), serviceItem.inactiveDate);
        System.assertEquals('1', serviceItem.instanceId);
        System.assertEquals(0, serviceItem.itemId);
        System.assertEquals(0, serviceItem.itemType);
        System.assertEquals(0.0, serviceItem.rate);
        System.assertEquals('1', serviceItem.salesforceId);
    }

   /* @isTest
    static void testInsertRowAlternate() {
        KenanServiceItem ksi = KenanSampleCode.createSampleKenanServiceItem('serviceExternalId', 2);

        KenanServiceItemCalloutMock serviceItemMock = new KenanServiceItemCalloutMock();
        serviceItemMock.numberOfRecords = 3;
        Test.setMock (HttpCalloutMock.class, serviceItemMock);

        Datetime today = Datetime.now();

        Test.startTest();
        KenanServiceItemService kserv = new KenanServiceItemService();
        List<KenanObject> returnedObjs = kserv.insertRowAlternate(ksi, 'POST', 'CREATE');
        Test.stopTest();

        List<KenanServiceItem> serviceItems = (List<KenanServiceItem>) returnedObjs;

        for (KenanServiceItem serviceItem: serviceItems) {
            System.assertEquals(Datetime.newInstance(2016, 7, 6, 0, 0, 0), serviceItem.activeDate);
            System.assertEquals('Test Annotation', serviceItem.annotation);
            System.assertEquals('Test Annotation 2', serviceItem.annotation2);
            System.assertEquals('KRW', serviceItem.currencyCode);
            System.assertEquals(Datetime.newInstance(2017, 7, 6, 0, 0, 0), serviceItem.inactiveDate);
            System.assertEquals('1', serviceItem.instanceId);
            System.assertEquals(0, serviceItem.itemId);
            System.assertEquals(0, serviceItem.itemType);
            System.assertEquals(0.0, serviceItem.rate);
            System.assertEquals('1', serviceItem.salesforceId);
        }
    }
*/
    @isTest
    static void testUpdateRow() {
        KenanServiceItem ksi = KenanSampleCode.createSampleKenanServiceItem('serviceExternalId', 2);

        KenanServiceItemCalloutMock serviceItemMock = new KenanServiceItemCalloutMock();
        serviceItemMock.numberOfRecords = 1;
        Test.setMock (HttpCalloutMock.class, serviceItemMock);

        Datetime today = Datetime.now();

        Test.startTest();
        KenanServiceItemService kserv = new KenanServiceItemService();
        KenanObject returnedObj = kserv.updateRow(ksi, 'PUT', 'MODIFY');
        Test.stopTest();

        KenanServiceItem serviceItem = (KenanServiceItem) returnedObj;

        System.assertEquals(Datetime.newInstance(2016, 7, 6, 0, 0, 0), serviceItem.activeDate);
        System.assertEquals('Test Annotation', serviceItem.annotation);
        System.assertEquals('Test Annotation 2', serviceItem.annotation2);
        System.assertEquals('KRW', serviceItem.currencyCode);
        System.assertEquals(Datetime.newInstance(2017, 7, 6, 0, 0, 0), serviceItem.inactiveDate);
        System.assertEquals('1', serviceItem.instanceId);
        System.assertEquals(0, serviceItem.itemId);
        System.assertEquals(0, serviceItem.itemType);
        System.assertEquals(0.0, serviceItem.rate);
        System.assertEquals('1', serviceItem.salesforceId);
    }

    @isTest
    static void testDeleteRow() {
        KenanServiceItem ksi = KenanSampleCode.createSampleKenanServiceItem('serviceExternalId', 2);

        KenanServiceItemCalloutMock serviceItemMock = new KenanServiceItemCalloutMock();
        serviceItemMock.numberOfRecords = 1;
        Test.setMock (HttpCalloutMock.class, serviceItemMock);

        Datetime today = Datetime.now();

        Test.startTest();
        KenanServiceItemService kserv = new KenanServiceItemService();
        Boolean success = kserv.deleteRow(ksi);
        Test.stopTest();

        System.assert(success, 'Delete row should not have been successful');
    }

    @isTest
    static void testQuery_Exception() {
        KenanServiceItemService kserv = new KenanServiceItemService();

        Test.startTest();
        try {
            DataSource.TableResult result = kserv.query(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanServiceItemService.query has not been implemented', ke.errorName);
            System.assertEquals('KenanServiceItemService.query has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testSearch_Exception() {
        KenanServiceItemService kserv = new KenanServiceItemService();

        Test.startTest();
        try {
            DataSource.TableResult result = kserv.search(null, 'Test Search Phrase');
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanServiceItemService.search has not been implemented', ke.errorName);
            System.assertEquals('KenanServiceItemService.search has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testUpsertRows_Exception() {
        KenanServiceItemService kserv = new KenanServiceItemService();

        Test.startTest();
        try {
            List<DataSource.UpsertResult> results = kserv.upsertRows(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanServiceItemService.upsertRows has not been implemented', ke.errorName);
            System.assertEquals('KenanServiceItemService.upsertRows has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testDeleteRows_Exception() {
        KenanServiceItemService kserv = new KenanServiceItemService();

        Test.startTest();
        try {
            List<DataSource.DeleteResult> results = kserv.deleteRows(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanServiceItemService.deleteRows has not been implemented', ke.errorName);
            System.assertEquals('KenanServiceItemService.deleteRows has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }
}