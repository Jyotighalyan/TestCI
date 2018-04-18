/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
@isTest
private class KenanConnectorServiceTest {

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
		ksc.Stored_Language_Code__c = '1';
		insert ksc; 
    }


	@isTest
	static void testaccountCreate() {
		Account a = new Account();
		a.Name = 'Sample Test Account';
		insert a;

		KenanAccount ka = KenanSampleCode.createSampleInsertKenanAccount(a.Id);
		ka.paymentProfile = KenanSampleCode.createSamplePaymentProfile();
		KenanAccountCalloutMock accountMock = new KenanAccountCalloutMock();
		accountMock.numberOfRecords = 1;
		Test.setMock (HttpCalloutMock.class, accountMock);
		Test.startTest();

		KenanConnectorService service = new KenanConnectorService();
		KenanAccount retKa = service.accountCreate(ka); 
		Test.stopTest();
		system.assertEquals(retKa.billFname, ka.billFname, 'Bill Company names did not match');
	}

	@isTest
	static void testaccountUpdate() {
		
		KenanAccount ka = KenanSampleCode.createSampleUpdateKenanAccount();
		KenanAccountCalloutMock accountMock = new KenanAccountCalloutMock();
		accountMock.numberOfRecords = 1;
		Test.setMock (HttpCalloutMock.class, accountMock);
		Test.startTest();

		KenanConnectorService service = new KenanConnectorService();
		KenanAccount retKa = service.accountUpdate(ka); 
		Test.stopTest();
		system.assertEquals(retKa.billFname, ka.billFname, 'Bill Company names did not match');
	}

	@isTest
	static void testaccountCease() {
		
		KenanAccount ka = KenanSampleCode.createSampleCeaseKenanAccount();
		KenanAccountCalloutMock accountMock = new KenanAccountCalloutMock();
		accountMock.numberOfRecords = 1;
		Test.setMock (HttpCalloutMock.class, accountMock);
		Test.startTest();

		KenanConnectorService service = new KenanConnectorService();
		Boolean retKa = service.accountCease(ka);
		Test.stopTest();
		system.assertEquals(true, retKa, 'KenanAccount was not deleted');
	}

	@isTest
	static void testServiceCreate() {
		Account a = new Account();
		a.Name = 'Sample Test Account';
		insert a;

		KenanService ks = KenanSampleCode.createSampleInsertKenanService(a.Id);
		ks.serviceItems.add(KenanSampleCode.createSampleKenanServiceItem(ks.externalAddressId, 2));

		KenanServiceCalloutMock serviceMock = new KenanServiceCalloutMock();
		serviceMock.numberOfRecords = 1;
		Test.setMock(HttpCalloutMock.class, serviceMock);
		Test.startTest();

		KenanConnectorService service = new KenanConnectorService();
		KenanService returnService = service.serviceCreate(ks); 
		Test.stopTest();

		System.assertNotEquals(null, returnService, 'Returned kenan service should not be null');
		System.assertEquals('123 Test St.', returnService.address1);
		System.assertEquals('Test Company', returnService.bserviceCompany);
		System.assertEquals('Test First Name', returnService.bserviceFname);
		System.assertEquals('Test Last Name', returnService.bserviceLname);
		System.assertEquals('555-1212', returnService.bservicePhone);
		System.assertEquals('Allentown', returnService.city);

		System.assertNotEquals(null, returnService.serviceItems, 'There should be service items in the service');
		System.assertEquals(2, returnService.serviceItems.size(), 'There should be 2 service items on the service');

		for (Integer i = 0; i < returnService.serviceItems.size(); i++) {
			String id = String.valueOf(i + 1);

			KenanServiceItem serviceItem = returnService.serviceItems.get(i);

			System.assertEquals('000' + id, serviceItem.instanceId);
			System.assertEquals(Integer.valueOf(id), serviceItem.itemId);
			System.assertEquals(Integer.valueOf(id), serviceItem.itemType);
			System.assertEquals(Decimal.valueOf(id) * 100, serviceItem.rate);
		}
	}
	
	/*@isTest
	static void testServiceItemCreate() {
		KenanServiceItem ksi = KenanSampleCode.createSampleKenanServiceItem('externalServiceId', 2);

		KenanServiceItemCalloutMock serviceItemMock = new KenanServiceItemCalloutMock();
		serviceItemMock.numberOfRecords = 3;
		Test.setMock(HttpCalloutMock.class, serviceItemMock);
		Test.startTest();
		KenanConnectorService service = new KenanConnectorService();
        
		List<KenanServiceItem> returnServiceItems = service.serviceItemCreate(ksi); 
		Test.stopTest();
	
		System.assertNotEquals(null, returnServiceItems);
		System.assert(!returnServiceItems.isEmpty());
		System.assertEquals(serviceItemMock.numberOfRecords, returnServiceItems.size());

		for (KenanServiceItem serviceItem: returnServiceItems) {
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
	static void testOrderCreate() {
		Account a = new Account();
		a.Name = 'Sample Test Account';
		insert a;

		Integer servicesNum = 3;

		List<KenanService> services = new List<KenanService>();

		for (Integer i = 0; i < servicesNum; i++) {
			KenanService ks = KenanSampleCode.createSampleInsertKenanService(a.Id);
			services.add(ks);
		}

		KenanServiceCalloutMock serviceMock = new KenanServiceCalloutMock();
		serviceMock.numberOfRecords = 3;
		Test.setMock(HttpCalloutMock.class, serviceMock);

		Test.startTest();
		KenanConnectorService service = new KenanConnectorService();
		List<KenanService> returnServices = service.orderCreate(services); 
		Test.stopTest();

		System.assertNotEquals(null, returnServices);
		System.assertEquals(servicesNum, returnServices.size());

		for (Integer i = 0; i < returnServices.size(); i++) {
			KenanService returnService = returnServices.get(i);

			System.assertEquals('123 Test St.', returnService.address1);
			System.assertEquals('Test Company', returnService.bserviceCompany);
			System.assertEquals('Test First Name', returnService.bserviceFname);
			System.assertEquals('Test Last Name', returnService.bserviceLname);
			System.assertEquals('555-1212', returnService.bservicePhone);
			System.assertEquals('Allentown', returnService.city);

			System.assertNotEquals(null, returnService.serviceItems, 'There should be service items in the service');
			System.assertEquals(2, returnService.serviceItems.size(), 'There should be 2 service items on the service');

			for (Integer j = 0; j < returnService.serviceItems.size(); j++) {
				String id = String.valueOf(j + 1);

				KenanServiceItem serviceItem = returnService.serviceItems.get(j);

				System.assertEquals('000' + id, serviceItem.instanceId);
				System.assertEquals(Integer.valueOf(id), serviceItem.itemId);
				System.assertEquals(Integer.valueOf(id), serviceItem.itemType);
				System.assertEquals(Decimal.valueOf(id) * 100, serviceItem.rate);
			}
		}
	}

	@isTest
	static void testServiceCease() {
		Account a = new Account();
		a.Name = 'Sample Test Account';
		insert a;

		KenanService ks = KenanSampleCode.createSampleCeaseKenanService(a.Id);
			
		KenanServiceCalloutMock serviceMock = new KenanServiceCalloutMock();
		serviceMock.numberOfRecords = 1;
		Test.setMock(HttpCalloutMock.class, serviceMock);

		Test.startTest();
		KenanConnectorService service = new KenanConnectorService();
		Boolean success = service.serviceCease(ks);
		Test.stopTest();

		system.assert(success, 'Delete should have been successful');
	}

	@isTest
	static void testServiceItemCease() {
		KenanServiceItem ksi = KenanSampleCode.createSampleKenanServiceItem('externalServiceId', 2);

		KenanServiceItemCalloutMock serviceItemMock = new KenanServiceItemCalloutMock();
		serviceItemMock.numberOfRecords = 1;
		Test.setMock(HttpCalloutMock.class, serviceItemMock);

		Test.startTest();
		KenanConnectorService service = new KenanConnectorService();
		Boolean serviceItem = service.serviceItemCease(ksi);
		Test.stopTest();

		system.assertEquals(true, serviceItem, 'Returned ceased service item should not be false');
	}

	@isTest
	static void testServiceIdCreate() {
		KenanServiceExternalId item = new KenanServiceExternalId();
		Datetime today = Datetime.now();
		item.salesforceObjectId = '6105551212';
		item.activeDate = today.date();
  		item.serviceExternalId = '6105551212';
  		item.serviceExternalIdType = 20;

		KenanServiceExternalIdServiceCalloutMock serviceMock = new KenanServiceExternalIdServiceCalloutMock();
		serviceMock.numberOfRecords = 1;
		Test.setMock(HttpCalloutMock.class, serviceMock);
		
		Test.startTest();
		KenanConnectorService service = new KenanConnectorService();
		KenanServiceExternalId returnedItem = service.serviceIdCreate(item);
		Test.stopTest();

		System.assertNotEquals(null, returnedItem);
		System.assertEquals(Datetime.newInstance(2016, 7, 7, 0, 0, 0), returnedItem.activeDate);
		System.assertEquals(Datetime.newInstance(2016, 7, 7, 0, 0, 0), returnedItem.createDt);
		System.assertEquals(Datetime.newInstance(2017, 7, 7, 0, 0, 0), returnedItem.inactiveDate);
		System.assertEquals(Datetime.newInstance(2016, 7, 7, 0, 0, 0), returnedItem.intendedViewEffectiveDt);
		System.assert(returnedItem.isCurrent);
		System.assert(returnedItem.isFromInventory);
		System.assertEquals(0, returnedItem.prevViewId);
		System.assertEquals('serviceExternalId', returnedItem.serviceExternalId);
		System.assertEquals(0, returnedItem.serviceExternalIdType);
		System.assertEquals(0, returnedItem.serviceInternalId);
		System.assertEquals(0, returnedItem.serviceInternalIdResets);
		System.assertEquals(0, returnedItem.viewId);
		System.assertEquals(0, returnedItem.viewStatus);
	}

	@isTest
	static void testServiceIdCease() {
		KenanServiceExternalId item = new KenanServiceExternalId();
		Datetime today = Datetime.now();
		item.salesforceObjectId = '6105551212';
		item.activeDate = today.date();
  		item.serviceExternalId = '6105551212';
  		item.serviceExternalIdType = 20;

		KenanServiceExternalIdServiceCalloutMock extIdMock = new KenanServiceExternalIdServiceCalloutMock();
		extIdMock.numberOfRecords = 1;
		Test.setMock(HttpCalloutMock.class, extIdMock);

		Test.startTest();
		KenanConnectorService service = new KenanConnectorService();
		Boolean success = service.serviceIdCease(item);
		Test.stopTest();

		System.assert(success, 'Service id cease should have been successful');
	}

	@isTest
	static void testServiceIdSwap() {
		KenanServiceExternalId item = new KenanServiceExternalId();
		Datetime today = Datetime.now();
		item.salesforceObjectId = '6105551212';
		item.activeDate = today.date();
  		item.serviceExternalId = '6105551212';
  		item.serviceExternalIdType = 20;
  		item.oldServiceExternalId = '6105551212';
  		item.oldServiceExternalIdType = 20;

		KenanServiceExternalIdServiceCalloutMock extIdMock = new KenanServiceExternalIdServiceCalloutMock();
		extIdMock.numberOfRecords = 1;
		Test.setMock(HttpCalloutMock.class, extIdMock);

		Test.startTest();
		KenanConnectorService service = new KenanConnectorService();
		KenanServiceExternalId returnedItem = service.serviceIdSwap(item);
		Test.stopTest();

		System.assertNotEquals(null, returnedItem);
		System.assertEquals(Datetime.newInstance(2016, 7, 7, 0, 0, 0), returnedItem.activeDate);
		System.assertEquals(Datetime.newInstance(2016, 7, 7, 0, 0, 0), returnedItem.createDt);
		System.assertEquals(Datetime.newInstance(2017, 7, 7, 0, 0, 0), returnedItem.inactiveDate);
		System.assertEquals(Datetime.newInstance(2016, 7, 7, 0, 0, 0), returnedItem.intendedViewEffectiveDt);
		System.assert(returnedItem.isCurrent);
		System.assert(returnedItem.isFromInventory);
		System.assertEquals(0, returnedItem.prevViewId);
		System.assertEquals('serviceExternalId', returnedItem.serviceExternalId);
		System.assertEquals(0, returnedItem.serviceExternalIdType);
		System.assertEquals(0, returnedItem.serviceInternalId);
		System.assertEquals(0, returnedItem.serviceInternalIdResets);
		System.assertEquals(0, returnedItem.viewId);
		System.assertEquals(0, returnedItem.viewStatus);
	}

	@isTest
	static void testAccountHierarchy() {
		Account a = new Account();
		a.Name = 'Sample Test Account';
		insert a;

		List<KenanAccount> accountList = new List<KenanAccount>();

		KenanAccount ka1 = KenanSampleCode.createSampleInsertKenanAccount(a.Id);
		ka1.paymentProfile = KenanSampleCode.createSamplePaymentProfile();
		accountList.add(ka1);

		KenanAccount ka2 = KenanSampleCode.createSampleInsertKenanAccount(a.Id);
		ka2.paymentProfile = KenanSampleCode.createSamplePaymentProfile();
		accountList.add(ka2);

		KenanAccountCalloutMock accountMock = new KenanAccountCalloutMock();
		accountMock.numberOfRecords = 3;
		Test.setMock (HttpCalloutMock.class, accountMock);

		Test.startTest();
		KenanConnectorService service = new KenanConnectorService();
		List<KenanAccount> returnedAccts = service.accountHierarchyCreate(accountList);
		Test.stopTest();

		for (KenanAccount acct: returnedAccts) {
			System.assertEquals('Jack', acct.billFname);
			System.assertEquals('123 Main St.', acct.billAddress1);
			System.assertEquals('Allentown', acct.billCity);
			System.assertEquals('PA', acct.billState);
			System.assertEquals('18101', acct.billZip);
		}
	}

	@isTest
	static void testServiceModify() {
		Account a = new Account();
		a.Name = 'Sample Test Account';
		insert a;

		KenanService ks = KenanSampleCode.createSampleInsertKenanService(a.Id);
		ks.serviceItems.add(KenanSampleCode.createSampleKenanServiceItem(ks.externalAddressId, 2));

		KenanServiceCalloutMock serviceMock = new KenanServiceCalloutMock();
		serviceMock.numberOfRecords = 1;
		Test.setMock(HttpCalloutMock.class, serviceMock);
		Test.startTest();

		KenanConnectorService service = new KenanConnectorService();
		KenanService returnService = service.serviceModify(ks); 
		Test.stopTest();

		System.assertNotEquals(null, returnService, 'Returned kenan service should not be null');
		System.assertEquals('123 Test St.', returnService.address1);
		System.assertEquals('Test Company', returnService.bserviceCompany);
		System.assertEquals('Test First Name', returnService.bserviceFname);
		System.assertEquals('Test Last Name', returnService.bserviceLname);
		System.assertEquals('555-1212', returnService.bservicePhone);
		System.assertEquals('Allentown', returnService.city);

		System.assertNotEquals(null, returnService.serviceItems, 'There should be service items in the service');
		System.assertEquals(2, returnService.serviceItems.size(), 'There should be 2 service items on the service');

		for (Integer i = 0; i < returnService.serviceItems.size(); i++) {
			String id = String.valueOf(i + 1);

			KenanServiceItem serviceItem = returnService.serviceItems.get(i);

			System.assertEquals('000' + id, serviceItem.instanceId);
			System.assertEquals(Integer.valueOf(id), serviceItem.itemId);
			System.assertEquals(Integer.valueOf(id), serviceItem.itemType);
			System.assertEquals(Decimal.valueOf(id) * 100, serviceItem.rate);
		}
	}

	@isTest
	static void testServiceAddressChange() {
		KenanAddress ka = KenanSampleCode.createSampleKenanAddress();
		
		KenanAddressServiceCalloutMock addressMock = new KenanAddressServiceCalloutMock();
		addressMock.numberOfRecords = 1;
		Test.setMock(HttpCalloutMock.class, addressMock);

		Test.startTest();

		KenanConnectorService service = new KenanConnectorService();
		KenanAddress returnAddress = service.changeServiceAddress(ka); 
		Test.stopTest();

		System.assertNotEquals(null, returnAddress, 'Returned kenan address should not be null');
		System.assertEquals('123 Test St.', returnAddress.cAddress1);
		System.assertEquals('Allentown', returnAddress.cCity);
		System.assertEquals('TX', returnAddress.cState);
		System.assertEquals('11111', returnAddress.cPostalCode);
		System.assert(returnAddress.cIsActive);
	}

	@isTest
	static void testPaymentProfileCreate() {
		KenanPaymentProfile profile = KenanSampleCode.createSamplePaymentProfile();

		KenanPaymentProfileServiceMock serviceMock = new KenanPaymentProfileServiceMock();
		serviceMock.numberOfRecords = 1;
		Test.setMock(HttpCalloutMock.class, serviceMock);
		
		Test.startTest();
		KenanConnectorService service = new KenanConnectorService();
		KenanPaymentProfile returnProf = service.paymentProfileCreate(profile); 
		Test.stopTest();

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
}