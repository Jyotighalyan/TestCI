/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
@isTest
private class KenanServiceServiceTest {
    
    @testSetup
    static void setup() {
        KenanServiceConnection__c ksc = new KenanServiceConnection__c();
        ksc.Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=';
        ksc.Session_Timeout__c = '120000';
        ksc.Connection_URL__c = 'https://dev-aws-oag-pe.upc.biz';
        ksc.REST_Application_Base__c = '/kenan-salesforce-api/rest';
        insert ksc;
    }

    @isTest 
    static void testInsertRow() {
        KenanServiceService kserv = new KenanServiceService();

        KenanServiceCalloutMock serviceMock = new KenanServiceCalloutMock();
        serviceMock.numberOfRecords = 1;
        Test.setMock (HttpCalloutMock.class, serviceMock);

        Datetime today = Datetime.now();

        Test.startTest();
        KenanService ks = new KenanService();
        ks.sfdcAccountId = '1';
        ks.address1 ='123 Test St.';
        ks.bserviceCompany = 'Test Company';
        ks.bserviceFname = 'Test First Name';
        ks.bserviceLname = 'Test Last Name';
        ks.bservicePhone = '555-1212';
        ks.city = 'Allentown';

        ks.serviceItems = new List<KenanServiceItem>();
        
        KenanServiceItem kenanServiceItem = new KenanServiceItem();
        kenanServiceItem.instanceId = '0001';
        kenanServiceItem.itemId = 1;
        kenanServiceItem.itemType = 1;
        kenanServiceItem.rate = 1.0;
        ks.serviceItems.add(kenanServiceItem);

        KenanObject ko = kserv.insertRow(ks, 'POST', 'CREATE');
        Test.stopTest();

        KenanService ksUpserted = (KenanService)ko;

        System.assertEquals(ks.bserviceCompany, ksUpserted.bserviceCompany);
        System.assertEquals(ks.bserviceFname, ksUpserted.bserviceFname);
        System.assertEquals(ks.bserviceLname, ksUpserted.bserviceLname);
        System.assertEquals(ks.bservicePhone, ksUpserted.bservicePhone);
        System.assertEquals(ks.city, ksUpserted.city);

        List<KenanServiceItem> upsertedServiceItems = ksUpserted.serviceItems;

        for (Integer i = 0; i < upsertedServiceItems.size(); i++) {
            KenanServiceItem upsertedServiceItem = upsertedServiceItems.get(i);
            Integer id = i + 1;

            System.assertEquals('000' + id, upsertedServiceItem.instanceId);
            System.assertEquals(id, upsertedServiceItem.itemId);
            System.assertEquals(id, upsertedServiceItem.itemType);
            System.assertEquals(id * 100, upsertedServiceItem.rate);
        }
    }

    @isTest 
    static void testInsertRows() {
        KenanServiceService kserv = new KenanServiceService();

        KenanServiceCalloutMock serviceMock = new KenanServiceCalloutMock();
        serviceMock.numberOfRecords = 3;
        Test.setMock (HttpCalloutMock.class, serviceMock);

        Datetime today = Datetime.now();

        List<KenanService> ksList = new List<KenanService>();
        Integer numServices = 3;

        Test.startTest();
        for (Integer i = 0; i < numServices; i++) {
            String id = String.valueOf(i + 1);
            KenanService ks = new KenanService();
            ks.sfdcAccountId = id;
            ks.address1 ='123 Test St.';
            ks.bserviceCompany = 'Test Company';
            ks.bserviceFname = 'Test First Name';
            ks.bserviceLname = 'Test Last Name';
            ks.bservicePhone = '555-1212';
            ks.city = 'Allentown';

            ks.serviceItems = new List<KenanServiceItem>();
            
            KenanServiceItem kenanServiceItem = new KenanServiceItem();
            kenanServiceItem.instanceId = '000' + id;
            kenanServiceItem.itemId = 1;
            kenanServiceItem.itemType = 1;
            kenanServiceItem.rate = 1.0;
            ks.serviceItems.add(kenanServiceItem);

            ksList.add(ks);
        }

        List<KenanObject> koList = kserv.insertRows(ksList, 'POST', 'CREATE');
        Test.stopTest();

        List<KenanService> ksListUpserted = (List<KenanService>)koList;

        for (Integer i = 0; i < ksListUpserted.size(); i++) {
            String id = String.valueOf(i + 1);

            KenanService ksUpserted = ksListUpserted.get(i);

            System.assertEquals('Test Company', ksUpserted.bserviceCompany);
            System.assertEquals('Test First Name', ksUpserted.bserviceFname);
            System.assertEquals('Test Last Name', ksUpserted.bserviceLname);
            System.assertEquals('555-1212', ksUpserted.bservicePhone);
            System.assertEquals('Allentown', ksUpserted.city);

            List<KenanServiceItem> upsertedServiceItems = ksUpserted.serviceItems;

            for (Integer j = 0; j < upsertedServiceItems.size(); j++) {
                KenanServiceItem upsertedServiceItem = upsertedServiceItems.get(j);

                System.assertEquals('000' + (j + 1), upsertedServiceItem.instanceId);
                System.assertEquals((j + 1), upsertedServiceItem.itemId);
                System.assertEquals((j + 1), upsertedServiceItem.itemType);
                System.assertEquals((j + 1) * 100, upsertedServiceItem.rate);
            }
        }
        
    }

    @isTest 
    static void testUpdateRow() {
        KenanServiceService kserv = new KenanServiceService();

        KenanServiceCalloutMock serviceMock = new KenanServiceCalloutMock();
        serviceMock.numberOfRecords = 1;
        
        Test.setMock (HttpCalloutMock.class, serviceMock);
        
        Datetime today = Datetime.now();
        
        Test.startTest();
        KenanService ks = new KenanService();
        ks.sfdcAccountId = '1';
        ks.bserviceCompany = 'Test Company';
        ks.bserviceFname = 'Test First Name';
        ks.bserviceLname = 'Test Last Name';
        ks.bservicePhone = '555-1212';
        KenanObject ko = kserv.updateRow(ks, 'PUT', 'MODIFY');
        Test.stopTest();

        KenanService ksUpserted = (KenanService)ko;

        System.assertEquals(ks.bserviceCompany, ksUpserted.bserviceCompany);
        System.assertEquals(ks.bserviceFname, ksUpserted.bserviceFname);
        System.assertEquals(ks.bserviceLname, ksUpserted.bserviceLname);
        System.assertEquals(ks.bservicePhone, ksUpserted.bservicePhone);
        System.assertEquals(null, ks.address1, 'Service Update does not support address updates');
        System.assertEquals(null, ks.address2, 'Service Update does not support address updates');
        System.assertEquals(null, ks.address3, 'Service Update does not support address updates');
        System.assertEquals(null, ks.address4, 'Service Update does not support address updates');
        System.assertEquals(null, ks.addressLocation, 'Service Update does not support address updates');
        System.assertEquals(null, ks.city, 'Service Update does not support address updates');
        System.assertEquals(null, ks.addressTypeId, 'Service Update does not support address updates');
        System.assertEquals(null, ks.countryCode, 'Service Update does not support address updates');
        System.assertEquals(null, ks.county, 'Service Update does not support address updates');
        System.assertEquals(null, ks.postalCode, 'Service Update does not support address updates');
        System.assertEquals(null, ks.state, 'Service Update does not support address updates');
        System.assertEquals(2, ksUpserted.serviceItems.size(), 'Service Update does not support Service Item Updates');
            
    }

    @isTest 
    static void testDeleteRow() {
        KenanServiceService kserv = new KenanServiceService();

        KenanServiceCalloutMock serviceMock = new KenanServiceCalloutMock();
        serviceMock.numberOfRecords = 2;
        Test.setMock (HttpCalloutMock.class, serviceMock);

        Test.startTest();
        KenanService ks = new KenanService();
        ks.sfdcAccountId = '1';
        ks.bserviceCompany = 'Test Company';
        ks.bserviceFname = 'Test First Name';
        ks.bserviceLname = 'Test Last Name';
        ks.bservicePhone = '555-1212';
        ks.disconnectReason = 'Customer request';
        ks.disconnectDate = Date.today();
        Boolean success = kserv.deleteRow(ks);
        Test.stopTest();

        System.assert(success, 'Delete should have been successful');
    }
    
    @isTest
    static void testQuery_Exception() {
        KenanServiceService kserv = new KenanServiceService();

        Test.startTest();
        try {
            DataSource.TableResult result = kserv.query(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanServiceService.query has not been implemented', ke.errorName);
            System.assertEquals('KenanServiceService.query has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testSearch_Exception() {
        KenanServiceService kserv = new KenanServiceService();

        Test.startTest();
        try {
            DataSource.TableResult result = kserv.search(null, 'Test Search Phrase');
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanServiceService.search has not been implemented', ke.errorName);
            System.assertEquals('KenanServiceService.search has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testUpsertRows_Exception() {
        KenanServiceService kserv = new KenanServiceService();

        Test.startTest();
        try {
            List<DataSource.UpsertResult> results = kserv.upsertRows(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanServiceService.upsertRows has not been implemented', ke.errorName);
            System.assertEquals('KenanServiceService.upsertRows has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testDeleteRows_Exception() {
        KenanServiceService kserv = new KenanServiceService();

        Test.startTest();
        try {
            List<DataSource.DeleteResult> results = kserv.deleteRows(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanServiceService.deleteRows has not been implemented', ke.errorName);
            System.assertEquals('KenanServiceService.deleteRows has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }
}