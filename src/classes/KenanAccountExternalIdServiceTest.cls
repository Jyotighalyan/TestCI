/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
@isTest
private class KenanAccountExternalIdServiceTest {
	
	@testSetup
	static void setup() {
		KenanServiceConnection__c ksc = new KenanServiceConnection__c();
		ksc.Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=';
		ksc.Session_Timeout__c = '120000';
		ksc.Connection_URL__c = 'https://dev-aws-oag-pe.upc.biz';
        ksc.REST_Application_Base__c = '/kenan-salesforce-api/rest';
        ksc.Stored_Language_Code__c = '1';
		insert ksc; 
	}
	
	@isTest
	static void testInsertRow() {
        KenanAccountExternalIdService accountExternalIdService = new KenanAccountExternalIdService();
        
        KenanAccountExternalId accountExternalId = new KenanAccountExternalId();
        Datetime today = Datetime.now();
        accountExternalId.salesforceObjectId = 'accountExternalId';
        accountExternalId.activeDate = today.date();
        accountExternalId.accountExternalId = 'externalId';
        accountExternalId.accountExternalIdType = 20;

        KenanAccountExternalIdServiceCalloutMock accountItemMock = new KenanAccountExternalIdServiceCalloutMock();
        accountItemMock.numberOfRecords = 1;
        Test.setMock(HttpCalloutMock.class, accountItemMock);

        Test.startTest();
        KenanObject returnedObj = accountExternalIdService.insertRow(accountExternalId, 'POST', 'CREATE');
        Test.stopTest();

        KenanAccountExternalId accountItem = (KenanAccountExternalId) returnedObj;

    	System.assertEquals(Datetime.newInstance(2016, 7, 7, 0, 0, 0), accountItem.activeDate);
        System.assertEquals(Datetime.newInstance(2017, 7, 7, 0, 0, 0), accountItem.inactiveDate);
        System.assert(accountItem.isCurrent);
        System.assertEquals('accountExternalId', accountItem.accountExternalId);
		System.assertEquals(0, accountItem.accountExternalIdType);
		System.assertEquals(0, accountItem.accountInternalId);
	}

	@isTest
	static void testUpdateRow() {
		KenanAccountExternalId accountExternalId = new KenanAccountExternalId();
        Datetime today = Datetime.now();
        accountExternalId.salesforceObjectId = 'accountExternalId';
        accountExternalId.activeDate = today.date();
        accountExternalId.accountExternalId = 'externalId';
        accountExternalId.accountExternalIdType = 20;
        accountExternalId.oldAccountExternalId = '10';

        KenanAccountExternalIdServiceCalloutMock accountItemMock = new KenanAccountExternalIdServiceCalloutMock();
        accountItemMock.numberOfRecords = 1;
        Test.setMock(HttpCalloutMock.class, accountItemMock);

        Test.startTest();
        KenanAccountExternalIdService accountExternalIdService = new KenanAccountExternalIdService();
        KenanObject returnedObj = accountExternalIdService.updateRow(accountExternalId, 'PUT', 'SWAP');
        Test.stopTest();

        KenanAccountExternalId accountItem = (KenanAccountExternalId) returnedObj;

    	System.assertEquals(Datetime.newInstance(2016, 7, 7, 0, 0, 0), accountItem.activeDate);
        System.assertEquals(Datetime.newInstance(2017, 7, 7, 0, 0, 0), accountItem.inactiveDate);
        System.assert(accountItem.isCurrent);
        System.assertEquals('accountExternalId', accountItem.accountExternalId);
		System.assertEquals(0, accountItem.accountExternalIdType);
		System.assertEquals(0, accountItem.accountInternalId);
	}

	@isTest
	static void testDeleteRow() {
		KenanAccountExternalId accountExternalId = new KenanAccountExternalId();
        Datetime today = Datetime.now();
        accountExternalId.salesforceObjectId = 'accountExternalId';
        accountExternalId.activeDate = today.date();
        accountExternalId.inactiveDate = today.date();
        accountExternalId.accountExternalId = 'externalId';
        accountExternalId.accountExternalIdType = 20;

        KenanAccountExternalIdServiceCalloutMock accountItemMock = new KenanAccountExternalIdServiceCalloutMock();
        accountItemMock.numberOfRecords = 1;
        Test.setMock(HttpCalloutMock.class, accountItemMock);

        Test.startTest();
        KenanAccountExternalIdService accountExternalIdService = new KenanAccountExternalIdService();
        Boolean success = accountExternalIdService.deleteRow(accountExternalId);
        Test.stopTest();

       	System.assert(success);
	}

    @isTest
    static void testDeleteRows() {
        KenanAccountExternalIdService service = new KenanAccountExternalIdService();

        Test.startTest();
        try {
            List<DataSource.DeleteResult> result = service.deleteRows(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAccountExternalIdService.deleteRows has not been implemented', ke.errorName);
            System.assertEquals('KenanAccountExternalIdService.deleteRows has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testUpsertRows() {
        KenanAccountExternalIdService service = new KenanAccountExternalIdService();

        Test.startTest();
        try {
            List<DataSource.UpsertResult> result = service.upsertRows(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAccountExternalIdService.upsertRows has not been implemented', ke.errorName);
            System.assertEquals('KenanAccountExternalIdService.upsertRows has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testSearch() {
        KenanAccountExternalIdService service = new KenanAccountExternalIdService();

        Test.startTest();
        try {
            DataSource.TableResult result = service.search(null, 'test search');
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAccountExternalIdService.search has not been implemented', ke.errorName);
            System.assertEquals('KenanAccountExternalIdService.search has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testQuery() {
        KenanAccountExternalIdService service = new KenanAccountExternalIdService();

        Test.startTest();
        try {
            DataSource.TableResult result = service.query(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAccountExternalIdService.query has not been implemented', ke.errorName);
            System.assertEquals('KenanAccountExternalIdService.query has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }
}