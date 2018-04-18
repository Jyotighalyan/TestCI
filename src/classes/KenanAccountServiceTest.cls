/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanAccountService Unit Tests
*/
@isTest
private class KenanAccountServiceTest {
	
	static KenanAccountItem getKenanAccountItem(String serviceExternalId, Integer serviceExternalIdType) {
		KenanAccountItem kenanAccountItem = new KenanAccountItem();

		Date today = Date.today();
		String annotation = 'annotation';
		String annotation2 = 'annotation2';
		String currencyCode = 'EUR';
		Date yearFromToday = Date.today().addYears(1);
		String instanceId = 'instanceId';
		String salesforceId = 'salesforceId';
		Integer itemId = 1;
		Integer itemType = 2;
		Integer rate = 10;
		Integer units = 1;
		String unitsType = 'Money';
		String nrcParentRcInstanceId = 'nrcParentRcInstanceId';
		Decimal discountAmount = 10;
		Decimal discountPercent = 10;
		Decimal unitCreditUnitsFree = 10;
		Decimal unitCreditAmountFree = 10;
		Integer contractLevel = 1;
		Integer serviceItemExternalIdType = 2;

		kenanAccountItem.serviceExternalIdType = serviceExternalIdType;
		kenanAccountItem.serviceExternalId = serviceExternalId;
		kenanAccountItem.activeDate = today; 
		kenanAccountItem.annotation = annotation;
		kenanAccountItem.annotation2 = annotation2;
		kenanAccountItem.currencyCode = currencyCode; 
		kenanAccountItem.inactiveDate = yearFromToday; 
		kenanAccountItem.instanceId = instanceId;
		kenanAccountItem.itemId = itemId;
		kenanAccountItem.itemType = itemType;
		kenanAccountItem.rate = rate;
		kenanAccountItem.salesforceId = salesforceId;
		kenanAccountItem.units = units;
		kenanAccountItem.unitsType = unitsType;
		kenanAccountItem.nrcParentRcInstanceId = nrcParentRcInstanceId;
		kenanAccountItem.discountAmount = discountAmount; 
		kenanAccountItem.discountPercent = discountPercent; 
		kenanAccountItem.unitCreditUnitsFree = unitCreditUnitsFree;
		kenanAccountItem.unitCreditAmountFree = unitCreditAmountFree;
		kenanAccountItem.contractLevel = contractLevel;

		return kenanAccountItem;
	}

	@testSetup
	static void setup(){
		KenanServiceConnection__c ksc = new KenanServiceConnection__c();
		ksc.Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=';
		ksc.Session_Timeout__c = '120000';
		ksc.Connection_URL__c = 'https://dev-aws-oag-pe.upc.biz';
		ksc.REST_Application_Base__c = '/kenan-salesforce-api/rest';
		insert ksc;
	}

	@isTest 
	static void testInsertRow() {
		KenanAccountService aserv = new KenanAccountService();

		KenanAccountCalloutMock accountMock = new KenanAccountCalloutMock();
		accountMock.numberOfRecords = 1;
		Test.setMock (HttpCalloutMock.class, accountMock);

		Test.startTest();
		KenanAccount ka = new KenanAccount();
		ka.billFname = 'Jack';
		ka.billAddress1 = '123 Main St.';
		ka.billCity = 'Allentown';
		ka.billState = 'PA';
		ka.billZip = '18101';
		ka.paymentProfile = new KenanPaymentProfile();
		ka.paymentProfile.payMethod = '1';

		ka.accountItems = new List<KenanAccountItem>();
		
		for (Integer i = 0; i < 3; i++) {
			ka.accountItems.add(getKenanAccountItem(String.valueOf(i), 2));
		}

		KenanObject ko = aserv.insertRow(ka, 'POST', 'CREATE');
		Test.stopTest();

		KenanAccount kaUpserted = (KenanAccount)ko;
		System.assertEquals('Jack', kaUpserted.billFname);
		System.assertEquals('123 Main St.', kaUpserted.billAddress1);
		System.assertEquals('Allentown', kaUpserted.billCity);
		System.assertEquals('PA', kaUpserted.billState);
		System.assertEquals('18101', kaUpserted.billZip);

		List<KenanAccountItem> upsertedAccountItems = kaUpserted.accountItems;

		for (Integer i = 0; i < upsertedAccountItems.size(); i++) {
			KenanAccountItem upsertedAccountItem = upsertedAccountItems.get(i);
			Integer id = i + 1;

			System.assertEquals('000' + id, upsertedAccountItem.instanceId);
			System.assertEquals(id, upsertedAccountItem.itemId);
			System.assertEquals(id, upsertedAccountItem.itemType);
			System.assertEquals(id * 100, upsertedAccountItem.rate);
		}
	}

	@isTest 
	static void testUpdateRow() {
		KenanAccountService aserv = new KenanAccountService();

		KenanAccountCalloutMock accountMock = new KenanAccountCalloutMock();
		accountMock.numberOfRecords = 1;
		Test.setMock (HttpCalloutMock.class, accountMock);

		Test.startTest();
		KenanAccount ka = new KenanAccount();
		ka.billFname = 'Jack';
		ka.billAddress1 = '123 Main St.';
		ka.billCity = 'Allentown';
		ka.billState = 'PA';
		ka.billZip = '18101';

		KenanObject ko = aserv.upDateRow(ka, 'PUT', 'MODIFY');
		Test.stopTest();

		KenanAccount kaUpserted = (KenanAccount)ko;
		System.assertEquals('Jack', kaUpserted.billFname);
		System.assertEquals('123 Main St.', kaUpserted.billAddress1);
		System.assertEquals('Allentown', kaUpserted.billCity);
		System.assertEquals('PA', kaUpserted.billState);
		System.assertEquals('18101', kaUpserted.billZip);
	}

	@isTest 
	static void testDeleteRow() {
		KenanAccountService aserv = new KenanAccountService();

		KenanAccountCalloutMock accountMock = new KenanAccountCalloutMock();
		accountMock.numberOfRecords = 0;
		Test.setMock ( HttpCalloutMock.class, accountMock);

		Test.startTest();
		KenanAccount ka = new KenanAccount();
		ka.billFname = 'Jack';
		ka.billAddress1 = '123 Main St.';
		ka.billCity = 'Allentown';
		ka.billState = 'PA';
		ka.billZip = '18101';

		Boolean kaDeleted = aserv.deleteRow(ka);
		Test.stopTest();

		System.assertEquals(true, kaDeleted);
	}
	
	@isTest
	static void insertHierarchyTest(){
		KenanAccountService aserv = new KenanAccountService();

		KenanAccountCalloutMock accountMock = new KenanAccountCalloutMock();
		accountMock.numberOfRecords = 3;
		Test.setMock (HttpCalloutMock.class, accountMock);

		Test.startTest();
		KenanAccount ka = new KenanAccount();
		ka.billFname = 'Jack';
		ka.billAddress1 = '123 Main St.';
		ka.billCity = 'Allentown';
		ka.billState = 'PA';
		ka.billZip = '18101';
		ka.paymentProfile = new KenanPaymentProfile();
		ka.paymentProfile.payMethod = '1';

		ka.accountItems = new List<KenanAccountItem>();
		
		KenanAccountItem kenanAccountItem = new KenanAccountItem();
		kenanAccountItem.instanceId = '0001';
		kenanAccountItem.itemId = 1;
		kenanAccountItem.itemType = 1;
		kenanAccountItem.rate = 1.0;
		ka.accountItems.add(kenanAccountItem);

		List<KenanAccount> kacts = new List<KenanAccount>();
		kacts.add(ka);

		List<KenanObject> kos = aserv.insertHierarchy(kacts);
		Test.stopTest();

		List<KenanAccount> kasUpserted = (List<KenanAccount>)kos;

		for (KenanAccount kaUpserted: kasUpserted) {
			System.assertEquals('Jack', kaUpserted.billFname);
			System.assertEquals('123 Main St.', kaUpserted.billAddress1);
			System.assertEquals('Allentown', kaUpserted.billCity);
			System.assertEquals('PA', kaUpserted.billState);
			System.assertEquals('18101', kaUpserted.billZip);

			List<KenanAccountItem> upsertedAccountItems = kaUpserted.accountItems;

			for (Integer i = 0; i < upsertedAccountItems.size(); i++) {
				KenanAccountItem upsertedAccountItem = upsertedAccountItems.get(i);
				Integer id = i + 1;

				System.assertEquals('000' + id, upsertedAccountItem.instanceId);
				System.assertEquals(id, upsertedAccountItem.itemId);
				System.assertEquals(id, upsertedAccountItem.itemType);
				System.assertEquals(id * 100, upsertedAccountItem.rate);
			}
		}
	}

	@isTest
    static void testQuery() {
        KenanAccountService aserv = new KenanAccountService();

		KenanAccountCalloutMock accountMock = new KenanAccountCalloutMock();
		accountMock.numberOfRecords = 1;
		Test.setMock (HttpCalloutMock.class, accountMock);

        Test.startTest();
        DataSource.QueryContext context = new DataSource.QueryContext();
        context.TableSelection = new DataSource.TableSelection();
        context.TableSelection.Filter = new DataSource.Filter();
        context.TableSelection.Filter.columnName='TestAccountColumn';
        context.TableSelection.Filter.columnValue='123';

        DataSource.TableResult result = aserv.query(context);
        
        Test.stopTest();
    }

    @isTest
    static void testSearch_Exception() {
        KenanAccountService aserv = new KenanAccountService();

        Test.startTest();
        try {
            DataSource.TableResult result = aserv.search(null, 'Test Search Phrase');
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAccountService.search has not been implemented', ke.errorName);
            System.assertEquals('KenanAccountService.search has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testUpsertRows_Exception() {
        KenanAccountService kserv = new KenanAccountService();

        Test.startTest();
        try {
            List<DataSource.UpsertResult> results = kserv.upsertRows(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAccountService.upsertRows has not been implemented', ke.errorName);
            System.assertEquals('KenanAccountService.upsertRows has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testDeleteRows_Exception() {
        KenanAccountService kserv = new KenanAccountService();

        Test.startTest();
        try {
            List<DataSource.DeleteResult> results = kserv.deleteRows(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAccountService.deleteRows has not been implemented', ke.errorName);
            System.assertEquals('KenanAccountService.deleteRows has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }
	
}