@isTest
private class KenanPaymentProfileServiceTest {
	
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
		KenanPaymentProfile prof = KenanSampleCode.createSamplePaymentProfile();
		
		KenanPaymentProfileServiceMock profMock = new KenanPaymentProfileServiceMock();
		profMock.numberOfRecords = 1;
		Test.setMock(HttpCalloutMock.class, profMock);

        Test.startTest();
        KenanPaymentProfileService kserv = new KenanPaymentProfileService();
        KenanObject returnedObj = kserv.insertRow(prof, 'POST', 'CREATE');
        Test.stopTest();

        KenanPaymentProfile returnProf = (KenanPaymentProfile) returnedObj;

    	System.assertNotEquals(null, returnProf, 'Returned kenan profile should not be null');
		System.assertEquals('1234', returnProf.altBankAccNum); 
        System.assertEquals('Test Branch Name', returnProf.branchName); 
        System.assertEquals('Test Company Name', returnProf.custCompanyName);
        System.assertEquals('test@test.org', returnProf.custEmail);
        System.assert(returnProf.cyclicalBillUsed);
        System.assert(returnProf.isDefault);
        System.assert(returnProf.isTemporary);
        System.assertEquals('Test Status', returnProf.mandateStatus);
        System.assertEquals('0', returnProf.payMethod);
	}

	@isTest
	static void testUpdateRow() {
		KenanPaymentProfileService kserv = new KenanPaymentProfileService();
        
        Test.startTest();
        try {
            KenanObject returnedObj = kserv.updateRow(null, 'PUT', 'MODIFY');
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanPaymentProfileService.updateRow has not been implemented', ke.errorName);
            System.assertEquals('KenanPaymentProfileService.updateRow has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
	}

	@isTest
	static void testDeleteRow() {
		KenanPaymentProfileService kserv = new KenanPaymentProfileService();

        Test.startTest();
		try {	
        	Boolean success = kserv.deleteRow(null);
        	System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanPaymentProfileService.deleteRow has not been implemented', ke.errorName);
            System.assertEquals('KenanPaymentProfileService.deleteRow has not been implemented', ke.errorMessage);
        }

        Test.stopTest();
	}

	@isTest
    static void testQuery_Exception() {
       	KenanPaymentProfileService kserv = new KenanPaymentProfileService();
        
        Test.startTest();
        try {
            DataSource.TableResult result = kserv.query(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanPaymentProfileService.query has not been implemented', ke.errorName);
            System.assertEquals('KenanPaymentProfileService.query has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testSearch_Exception() {
        KenanPaymentProfileService kserv = new KenanPaymentProfileService();

        Test.startTest();
        try {
            DataSource.TableResult result = kserv.search(null, 'Test Search Phrase');
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanPaymentProfileService.search has not been implemented', ke.errorName);
            System.assertEquals('KenanPaymentProfileService.search has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testUpsertRows_Exception() {
        KenanPaymentProfileService kserv = new KenanPaymentProfileService();

        Test.startTest();
        try {
            List<DataSource.UpsertResult> results = kserv.upsertRows(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanPaymentProfileService.upsertRows has not been implemented', ke.errorName);
            System.assertEquals('KenanPaymentProfileService.upsertRows has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testDeleteRows_Exception() {
        KenanPaymentProfileService kserv = new KenanPaymentProfileService();

        Test.startTest();
        try {
            List<DataSource.DeleteResult> results = kserv.deleteRows(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanPaymentProfileService.deleteRows has not been implemented', ke.errorName);
            System.assertEquals('KenanPaymentProfileService.deleteRows has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }
}