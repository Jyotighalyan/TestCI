@isTest
private class KenanAccountItemServiceTest {
    
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
    static void testInsertRowAlternate() {
        KenanAccountItemCalloutMock accountItemMock = new KenanAccountItemCalloutMock();
        accountItemMock.numberOfRecords = 3;
        Test.setMock (HttpCalloutMock.class, accountItemMock);
        
        KenanAccountItem ksi = new KenanAccountItem();
        ksi.serviceExternalId = 'serviceExternalId';
        ksi.serviceExternalIdType = 2;
        ksi.itemId = 1302;
        ksi.itemType = 1;
        
        Test.startTest();
        KenanAccountItemService kserv = new KenanAccountItemService();
        List<KenanObject> returnedObjs = kserv.insertRowAlternate(ksi, 'POST', 'CREATE');
        Test.stopTest();
        
        List<KenanAccountItem> accountItems = (List<KenanAccountItem>) returnedObjs;
        
        for (KenanAccountItem accountItem: accountItems) {
            System.assertEquals('Test Annotation', accountItem.annotation);
            System.assertEquals('Test Annotation 2', accountItem.annotation2);
            System.assertEquals('EUR', accountItem.currencyCode);
            System.assertEquals(0.0, accountItem.rate);
            System.assertEquals('1', accountItem.salesforceId);
            System.assertEquals(1, accountItem.units);
        }
    }
    
    @isTest
    static void testDeleteRow() {
        KenanAccountItemCalloutMock accountItemMock = new KenanAccountItemCalloutMock();
        accountItemMock.numberOfRecords = 1;
        Test.setMock(HttpCalloutMock.class, accountItemMock);
        
        KenanAccountItem ksi = new KenanAccountItem();
        ksi.serviceExternalId = 'serviceExternalId';
        ksi.serviceExternalIdType = 2;
        ksi.itemId = 1302;
        ksi.itemType = 1;
        
        Test.startTest();
        KenanAccountItemService kserv = new KenanAccountItemService();
        Boolean success = kserv.deleteRow(ksi);
        Test.stopTest();
        
        System.assert(success, 'Delete row should not have been successful');
    }
    
    @isTest 
    static void testInsertRow() {
        KenanAccountItemCalloutMock accountItemMock = new KenanAccountItemCalloutMock();
        accountItemMock.numberOfRecords = 1;
        Test.setMock (HttpCalloutMock.class, accountItemMock);
        
        KenanAccountItem ksi = new KenanAccountItem();
        ksi.serviceExternalId = 'serviceExternalId';
        ksi.serviceExternalIdType = 2;
        ksi.itemId = 1302;
        ksi.itemType = 1;
        
        Test.startTest();
        KenanAccountItemService kserv = new KenanAccountItemService();
        KenanObject returnedObj = kserv.insertRow(ksi, 'POST', 'CREATE');
        Test.stopTest();
        
        System.assertEquals(null, returnedObj);
    }
    
    
    @isTest 
    static void testUpdateRow() {
        KenanAccountItemCalloutMock accountItemMock = new KenanAccountItemCalloutMock();
        accountItemMock.numberOfRecords = 1;
        Test.setMock (HttpCalloutMock.class, accountItemMock);
        
        KenanAccountItem ksi = new KenanAccountItem();
        ksi.serviceExternalId = 'serviceExternalId';
        ksi.serviceExternalIdType = 2;
        ksi.itemId = 1302;
        ksi.itemType = 1;
        
        Test.startTest();
        KenanAccountItemService kserv = new KenanAccountItemService();
        KenanObject returnedObj = kserv.updateRow(ksi, 'PUT', 'MODIFY');
        Test.stopTest();
        
        System.assertEquals(null, returnedObj);
    }
    
    @isTest
    static void testQuery_Exception() {
        KenanAccountItemService kserv = new KenanAccountItemService();
        
        Test.startTest();
        try {
            DataSource.TableResult result = kserv.query(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAccountItemService.query has not been implemented', ke.errorName);
            System.assertEquals('KenanAccountItemService.query has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }
    
    @isTest
    static void testSearch_Exception() {
        KenanAccountItemService kserv = new KenanAccountItemService();
        
        Test.startTest();
        try {
            DataSource.TableResult result = kserv.search(null, 'Test Search Phrase');
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAccountItemService.search has not been implemented', ke.errorName);
            System.assertEquals('KenanAccountItemService.search has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }
    
    @isTest
    static void testUpsertRows_Exception() {
        KenanAccountItemService kserv = new KenanAccountItemService();
        
        Test.startTest();
        try {
            List<DataSource.UpsertResult> results = kserv.upsertRows(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAccountItemService.upsertRows has not been implemented', ke.errorName);
            System.assertEquals('KenanAccountItemService.upsertRows has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }
    
    @isTest
    static void testDeleteRows_Exception() {
        KenanAccountItemService kserv = new KenanAccountItemService();
        
        Test.startTest();
        try {
            List<DataSource.DeleteResult> results = kserv.deleteRows(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAccountItemService.deleteRows has not been implemented', ke.errorName);
            System.assertEquals('KenanAccountItemService.deleteRows has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }
    
}