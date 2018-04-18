/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
@isTest
private class KenanServiceExternalIdServiceTest {
	
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
        KenanServiceExternalIdService kserv = new KenanServiceExternalIdService();
        
        KenanServiceExternalId ksei = new KenanServiceExternalId();
        Datetime today = Datetime.now();
        ksei.salesforceObjectId = 'serviceExternalId';
        ksei.activeDate = today.date();
        ksei.serviceExternalId = 'externalId';
        ksei.serviceExternalIdType = 20;

        KenanServiceExternalIdServiceCalloutMock serviceItemMock = new KenanServiceExternalIdServiceCalloutMock();
        serviceItemMock.numberOfRecords = 1;
        Test.setMock (HttpCalloutMock.class, serviceItemMock);

        Test.startTest();
        KenanObject returnedObj = kserv.insertRow(ksei, 'POST', 'CREATE');
        Test.stopTest();

        KenanServiceExternalId serviceItem = (KenanServiceExternalId) returnedObj;

    	System.assertEquals(Datetime.newInstance(2016, 7, 7, 0, 0, 0), serviceItem.activeDate);
        System.assertEquals(Datetime.newInstance(2016, 7, 7, 0, 0, 0), serviceItem.createDt);
        System.assertEquals(Datetime.newInstance(2017, 7, 7, 0, 0, 0), serviceItem.inactiveDate);
        System.assertEquals(Datetime.newInstance(2016, 7, 7, 0, 0, 0), serviceItem.intendedViewEffectiveDt);
        System.assert(serviceItem.isCurrent);
        System.assert(serviceItem.isFromInventory);
        System.assertEquals(0, serviceItem.prevViewId);
        System.assertEquals('serviceExternalId', serviceItem.serviceExternalId);
		System.assertEquals(0, serviceItem.serviceExternalIdType);
		System.assertEquals(0, serviceItem.serviceInternalId);
        System.assertEquals(0, serviceItem.serviceInternalIdResets);
		System.assertEquals(0, serviceItem.viewId);
		System.assertEquals(0, serviceItem.viewStatus);
	}

	@isTest
	static void testUpdateRow() {
		KenanServiceExternalId ksei = new KenanServiceExternalId();
        Datetime today = Datetime.now();
        ksei.salesforceObjectId = 'serviceExternalId';
        ksei.activeDate = today.date();
        ksei.serviceExternalId = 'externalId';
        ksei.serviceExternalIdType = 20;
        ksei.oldServiceExternalId = '10';

        KenanServiceExternalIdServiceCalloutMock serviceItemMock = new KenanServiceExternalIdServiceCalloutMock();
        serviceItemMock.numberOfRecords = 1;
        Test.setMock (HttpCalloutMock.class, serviceItemMock);

        Test.startTest();
        KenanServiceExternalIdService kserv = new KenanServiceExternalIdService();
        KenanObject returnedObj = kserv.updateRow(ksei, 'PUT', 'SWAP');
        Test.stopTest();

        KenanServiceExternalId serviceItem = (KenanServiceExternalId) returnedObj;

    	System.assertEquals(Datetime.newInstance(2016, 7, 7, 0, 0, 0), serviceItem.activeDate);
        System.assertEquals(Datetime.newInstance(2016, 7, 7, 0, 0, 0), serviceItem.createDt);
        System.assertEquals(Datetime.newInstance(2017, 7, 7, 0, 0, 0), serviceItem.inactiveDate);
        System.assertEquals(Datetime.newInstance(2016, 7, 7, 0, 0, 0), serviceItem.intendedViewEffectiveDt);
        System.assert(serviceItem.isCurrent);
        System.assert(serviceItem.isFromInventory);
        System.assertEquals(0, serviceItem.prevViewId);
        System.assertEquals('serviceExternalId', serviceItem.serviceExternalId);
		System.assertEquals(0, serviceItem.serviceExternalIdType);
		System.assertEquals(0, serviceItem.serviceInternalId);
        System.assertEquals(0, serviceItem.serviceInternalIdResets);
		System.assertEquals(0, serviceItem.viewId);
		System.assertEquals(0, serviceItem.viewStatus);
	}

	@isTest
	static void testDeleteRow() {
		KenanServiceExternalId ksei = new KenanServiceExternalId();
        Datetime today = Datetime.now();
        ksei.salesforceObjectId = 'serviceExternalId';
        ksei.activeDate = today.date();
        ksei.inactiveDate = today.date();
        ksei.serviceExternalId = 'externalId';
        ksei.serviceExternalIdType = 20;

        KenanServiceExternalIdServiceCalloutMock serviceItemMock = new KenanServiceExternalIdServiceCalloutMock();
        serviceItemMock.numberOfRecords = 1;
        Test.setMock (HttpCalloutMock.class, serviceItemMock);

        Test.startTest();
        KenanServiceExternalIdService kserv = new KenanServiceExternalIdService();
        Boolean success = kserv.deleteRow(ksei);
        Test.stopTest();

       	System.assert(success);
	}

    @isTest
    static void testDeleteRows() {
        KenanServiceExternalIdService service = new KenanServiceExternalIdService();

        Test.startTest();
        try {
            List<DataSource.DeleteResult> result = service.deleteRows(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanServiceExternalIdService.deleteRows has not been implemented', ke.errorName);
            System.assertEquals('KenanServiceExternalIdService.deleteRows has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testUpsertRows() {
        KenanServiceExternalIdService service = new KenanServiceExternalIdService();

        Test.startTest();
        try {
            List<DataSource.UpsertResult> result = service.upsertRows(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanServiceExternalIdService.upsertRows has not been implemented', ke.errorName);
            System.assertEquals('KenanServiceExternalIdService.upsertRows has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testSearch() {
        KenanServiceExternalIdService service = new KenanServiceExternalIdService();

        Test.startTest();
        try {
            DataSource.TableResult result = service.search(null, 'test search');
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanServiceExternalIdService.search has not been implemented', ke.errorName);
            System.assertEquals('KenanServiceExternalIdService.search has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testQuery() {
        KenanServiceExternalIdService service = new KenanServiceExternalIdService();

        Test.startTest();
        try {
            DataSource.TableResult result = service.query(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanServiceExternalIdService.query has not been implemented', ke.errorName);
            System.assertEquals('KenanServiceExternalIdService.query has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }
}