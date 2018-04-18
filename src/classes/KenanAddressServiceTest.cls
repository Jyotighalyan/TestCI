@isTest
private class KenanAddressServiceTest {
	
	@testSetup
	static void setup() {
		KenanServiceConnection__c ksc = new KenanServiceConnection__c();
		ksc.Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=';
		ksc.Session_Timeout__c = '120000';
		ksc.Connection_URL__c = 'https://kenan-dev-pubelb-amdocs-1924041402.eu-central-1.elb.amazonaws.com';
		ksc.REST_Application_Base__c = '/kenan-salesforce-api/rest';
		insert ksc; 
	}

	@isTest
	static void testInsertRow() {
		KenanAddress ka = KenanSampleCode.createSampleKenanAddress();
		
		KenanAddressServiceCalloutMock addressMock = new KenanAddressServiceCalloutMock();
		addressMock.numberOfRecords = 1;
		Test.setMock(HttpCalloutMock.class, addressMock);

        Test.startTest();
        KenanAddressService kserv = new KenanAddressService();
        KenanObject returnedObj = kserv.insertRow(ka, 'POST', 'CREATE');
        Test.stopTest();

        KenanAddress returnAddress = (KenanAddress) returnedObj;

    	System.assertNotEquals(null, returnAddress, 'Returned kenan address should not be null');
		System.assertEquals('123 Test St.', returnAddress.cAddress1);
		System.assertEquals('Allentown', returnAddress.cCity);
		System.assertEquals('TX', returnAddress.cState);
		System.assertEquals('11111', returnAddress.cPostalCode);
		System.assert(returnAddress.cIsActive);
	}

	@isTest
	static void testUpdateRow() {
		KenanAddressService kserv = new KenanAddressService();

		Test.startTest();
		try {	
        	KenanObject returnedObj = kserv.updateRow(null, 'PUT', 'UPDATE');
        	System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAddressService.updateRow has not been implemented', ke.errorName);
            System.assertEquals('KenanAddressService.updateRow has not been implemented', ke.errorMessage);
        }

        Test.stopTest();
	}

	@isTest
	static void testDeleteRow() {
		KenanAddressService kserv = new KenanAddressService();

        Test.startTest();
		try {	
        	Boolean success = kserv.deleteRow(null);
        	System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAddressService.deleteRow has not been implemented', ke.errorName);
            System.assertEquals('KenanAddressService.deleteRow has not been implemented', ke.errorMessage);
        }

        Test.stopTest();
	}

	@isTest
    static void testQuery_Exception() {
       	KenanAddressService kserv = new KenanAddressService();
        
        Test.startTest();
        try {
            DataSource.TableResult result = kserv.query(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAddressService.query has not been implemented', ke.errorName);
            System.assertEquals('KenanAddressService.query has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testSearch_Exception() {
        KenanAddressService kserv = new KenanAddressService();

        Test.startTest();
        try {
            DataSource.TableResult result = kserv.search(null, 'Test Search Phrase');
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAddressService.search has not been implemented', ke.errorName);
            System.assertEquals('KenanAddressService.search has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testUpsertRows_Exception() {
        KenanAddressService kserv = new KenanAddressService();

        Test.startTest();
        try {
            List<DataSource.UpsertResult> results = kserv.upsertRows(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAddressService.upsertRows has not been implemented', ke.errorName);
            System.assertEquals('KenanAddressService.upsertRows has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testDeleteRows_Exception() {
        KenanAddressService kserv = new KenanAddressService();

        Test.startTest();
        try {
            List<DataSource.DeleteResult> results = kserv.deleteRows(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAddressService.deleteRows has not been implemented', ke.errorName);
            System.assertEquals('KenanAddressService.deleteRows has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }
}