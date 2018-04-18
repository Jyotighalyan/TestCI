/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Unit Test for use in Salesforce Kenan Connection Service
*/
@isTest
private class KenanPaymentProfileMapperTest {
	
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
		
		KenanPaymentProfile profile = new KenanPaymentProfile();

		profile.altBankAccNum = '1234';
		profile.avsAddressId = 123;
		profile.avsResponseCode = '';
		profile.bankAccountType = 1;
		profile.bankAgencyCode = 'XYZ';
		profile.bankAgencyName = 'Test Agency';
		profile.bankCode = 'Test Bank Code';
		profile.billCompanyTaxId = 123456;
		profile.branchCode = 'Test Branch Code';
		profile.branchName = 'Test Branch Name';
		profile.cardAccount = '4111-1111';
		profile.cardCarrier = 'Test Card Carrier';
		profile.cardExpire = '01/01/2020';
		profile.clearingHouseId = 'Test Id';
		profile.custBankAccNum = '';
		profile.custBankAccOwner = 'Test Owner';
		profile.custBankAcctType = 'Test Type';
		profile.custBankBic = '';
		profile.custBankBicHist = '';
		profile.custBankIban = '';
		profile.custBankIbanHist = '';
		profile.custBankSortCode = '';
		profile.custBillAddress = '123 Test St.';
		profile.custBillCity = 'Allentown';
		profile.custBillCountryCode = 1;
		profile.custBillState = 'PA';
		profile.custBillZip = '18101';
		profile.custCompanyName = 'Test Company Name';
		profile.custEmail = 'Test Email';
		profile.custPhone = 'Test Phone';
		profile.cyclicalBillUsed = true;
		profile.diffAcctOwnFlag = '';
		profile.driverLicenseNum = '9876';
		profile.driverLicenseState = 'PA';
		profile.epgSubscriptionId = '';
		profile.isDefault = true;
		profile.isTemporary = true;
		profile.mandateId = '';
		profile.mandateReset = '';
		profile.mandateSignDate = Date.today();
		profile.mandateStatus = '';
		profile.newCustBankSortCode = '';
		profile.nonRealtimeOnly = false;
		profile.ownrFname = '';
		profile.ownrLname = '';
		profile.paymentMerchantId = 0;
		profile.payMethod = '';
		profile.profileCreationTime = Date.today();
		profile.referenceNumber = '5555';
		profile.sequenceType = '';
		profile.status = 0;
		profile.transactionUuid = '';
		profile.transFlag = '';

		Test.startTest();
		KenanPaymentProfileMapper mapper = new KenanPaymentProfileMapper();
		Map<String,Object> objectMap = mapper.getEnumeratedValues(profile);
		Test.stopTest();
				
		System.assertEquals(objectMap.get('altBankAccNum'), profile.altBankAccNum);
        System.assertEquals(objectMap.get('avsAddressId'), profile.avsAddressId); 
        System.assertEquals(objectMap.get('avsResponseCode'), profile.avsResponseCode); 
        System.assertEquals(objectMap.get('bankAccountType'), profile.bankAccountType); 
        System.assertEquals(objectMap.get('bankAgencyCode'), profile.bankAgencyCode); 
        System.assertEquals(objectMap.get('bankAgencyName'), profile.bankAgencyName); 
        System.assertEquals(objectMap.get('bankCode'), profile.bankCode); 
        System.assertEquals(objectMap.get('billCompanyTaxId'), profile.billCompanyTaxId); 
        System.assertEquals(objectMap.get('branchCode'), profile.branchCode); 
        System.assertEquals(objectMap.get('branchName'), profile.branchName); 
        System.assertEquals(objectMap.get('cardAccount'), profile.cardAccount); 
        System.assertEquals(objectMap.get('cardCarrier'), profile.cardCarrier); 
        System.assertEquals(objectMap.get('cardExpire'), profile.cardExpire); 
        System.assertEquals(objectMap.get('clearingHouseId'), profile.clearingHouseId); 
        System.assertEquals(objectMap.get('custBankAccNum'), profile.custBankAccNum); 
        System.assertEquals(objectMap.get('custBankAccOwner'), profile.custBankAccOwner); 
        System.assertEquals(objectMap.get('custBankAcctType'), profile.custBankAcctType);
        System.assertEquals(objectMap.get('custBankBic'), profile.custBankBic);
        System.assertEquals(objectMap.get('custBankBicHist'), profile.custBankBicHist);
        System.assertEquals(objectMap.get('custBankIban'), profile.custBankIban);
        System.assertEquals(objectMap.get('custBankIbanHist'), profile.custBankIbanHist);
        System.assertEquals(objectMap.get('custBankSortCode'), profile.custBankSortCode);
        System.assertEquals(objectMap.get('custBillAddress'), profile.custBillAddress);
        System.assertEquals(objectMap.get('custBillCity'), profile.custBillCity);
        System.assertEquals(objectMap.get('custBillCountryCode'), profile.custBillCountryCode);
        System.assertEquals(objectMap.get('custBillState'), profile.custBillState);
        System.assertEquals(objectMap.get('custBillZip'), profile.custBillZip);
        System.assertEquals(objectMap.get('custCompanyName'), profile.custCompanyName);
        System.assertEquals(objectMap.get('custEmail'), profile.custEmail);
        System.assertEquals(objectMap.get('custPhone'), profile.custPhone);
        System.assertEquals(objectMap.get('cyclicalBillUsed'), profile.cyclicalBillUsed);
        System.assertEquals(objectMap.get('diffAcctOwnFlag'), profile.diffAcctOwnFlag);
        System.assertEquals(objectMap.get('driverLicenseNum'), profile.driverLicenseNum);
        System.assertEquals(objectMap.get('driverLicenseState'), profile.driverLicenseState);
        System.assertEquals(objectMap.get('epgSubscriptionId'), profile.epgSubscriptionId);
        System.assertEquals(objectMap.get('isDefault'), profile.isDefault);
        System.assertEquals(objectMap.get('isTemporary'), profile.isTemporary);
        System.assertEquals(objectMap.get('mandateId'), profile.mandateId);
        System.assertEquals(objectMap.get('mandateReset'), profile.mandateReset);
        System.assertEquals(objectMap.get('mandateSignDate'), profile.mandateSignDate);
        System.assertEquals(objectMap.get('mandateStatus'), profile.mandateStatus);
        System.assertEquals(objectMap.get('newCustBankSortCode'), profile.newCustBankSortCode);
        System.assertEquals(objectMap.get('nonRealtimeOnly'), profile.nonRealtimeOnly);
        System.assertEquals(objectMap.get('ownrFname'), profile.ownrFname);
        System.assertEquals(objectMap.get('ownrLname'), profile.ownrLname);
        System.assertEquals(objectMap.get('paymentMerchantId'), profile.paymentMerchantId);
        System.assertEquals(objectMap.get('payMethod'), profile.payMethod);
        System.assertEquals(objectMap.get('profileCreationTime'), profile.profileCreationTime);
        System.assertEquals(objectMap.get('referenceNumber'), profile.referenceNumber);
        System.assertEquals(objectMap.get('sequenceType'), profile.sequenceType);
        System.assertEquals(objectMap.get('status'), profile.status);
        System.assertEquals(objectMap.get('transactionUuid'), profile.transactionUuid);
        System.assertEquals(objectMap.get('transFlag'), profile.transFlag);
	}

	@isTest
	static void getDisplayValuesTest() {
		Map<String, Object> objMap = new Map<String, Object>();
		
		objMap.put('altBankAccNum', 'altBankAccNum');
		objMap.put('avsAddressId', 1);
		objMap.put('avsResponseCode', 'avsResponseCode');
		objMap.put('bankAccountType', 1);
		objMap.put('bankAgencyCode', 'bankAgencyCode');
		objMap.put('bankAgencyName', 'bankAgencyName');
		objMap.put('bankCode', 'bankCode');
		objMap.put('billCompanyTaxId', 12345);
		objMap.put('branchCode', 'branchCode');
		objMap.put('branchName', 'branchName');
		objMap.put('cardAccount', 'cardAccount');
		objMap.put('cardCarrier', 'cardCarrier');
		objMap.put('cardExpire', 'cardExpire');
		objMap.put('clearingHouseId', 'clearingHouseId');
		objMap.put('custBankAccNum', 'custBankAccNum');
		objMap.put('custBankAccOwner', 'custBankAccOwner');
		objMap.put('custBankAcctType', 'custBankAcctType');
		objMap.put('custBankBic', 'custBankBic');
		objMap.put('custBankBicHist', 'custBankBicHist');
		objMap.put('custBankIban', 'custBankIban');
		objMap.put('custBankIbanHist', 'custBankIbanHist');
		objMap.put('custBankSortCode', 'custBankSortCode');
		objMap.put('custBillAddress', 'custBillAddress');
		objMap.put('custBillCity', 'custBillCity');
		objMap.put('custBillCountryCode', 1);
		objMap.put('custBillState', 'custBillState');
		objMap.put('custBillZip', 'custBillZip');
		objMap.put('custCompanyName', 'custCompanyName');
		objMap.put('custEmail', 'custEmail');
		objMap.put('custPhone', 'custPhone');
		objMap.put('cyclicalBillUsed', true);
		objMap.put('diffAcctOwnFlag', 'diffAcctOwnFlag');
		objMap.put('driverLicenseNum', 'driverLicenseNum');
		objMap.put('driverLicenseState', 'driverLicenseState');
		objMap.put('epgSubscriptionId', 'epgSubscriptionId');
		objMap.put('isDefault', true);
		objMap.put('isTemporary', true);
		objMap.put('mandateId', 'mandateId');
		objMap.put('mandateReset', 'mandateReset');
		objMap.put('mandateSignDate', Datetime.newInstance(2016, 7, 6, 0, 0, 0));
		objMap.put('mandateStatus', 'mandateStatus');
		objMap.put('newCustBankSortCode', 'newCustBankSortCode');
		objMap.put('nonRealtimeOnly', false);
		objMap.put('ownrFname', 'ownrFname');
		objMap.put('ownrLname', 'ownrLname');
		objMap.put('paymentMerchantId', 0);
		objMap.put('payMethod', 'payMethod');
		objMap.put('profileCreationTime', Datetime.newInstance(2016, 7, 6, 0, 0, 0));
		objMap.put('referenceNumber', 'referenceNumber');
		objMap.put('sequenceType', 'sequenceType');
		objMap.put('status', 0);
		objMap.put('transactionUuid', 'transactionUuid');
		objMap.put('transFlag', 'transFlag');

		Test.startTest();
		KenanPaymentProfileMapper mapper = new KenanPaymentProfileMapper();
		KenanObject prof = mapper.getDisplayValues(objMap);
		Test.stopTest();

		KenanPaymentProfile profile = (KenanPaymentProfile) prof;

		System.assertEquals(objMap.get('altBankAccNum'), profile.altBankAccNum);
        System.assertEquals(objMap.get('avsAddressId'), profile.avsAddressId);
        System.assertEquals(objMap.get('avsResponseCode'), profile.avsResponseCode);
        System.assertEquals(objMap.get('bankAccountType'), profile.bankAccountType);
        System.assertEquals(objMap.get('bankAgencyCode'), profile.bankAgencyCode);
        System.assertEquals(objMap.get('bankAgencyName'), profile.bankAgencyName);
        System.assertEquals(objMap.get('bankCode'), profile.bankCode);
        System.assertEquals(objMap.get('billCompanyTaxId'), profile.billCompanyTaxId);
        System.assertEquals(objMap.get('branchCode'), profile.branchCode);
        System.assertEquals(objMap.get('branchName'), profile.branchName);
        System.assertEquals(objMap.get('cardAccount'), profile.cardAccount);
        System.assertEquals(objMap.get('cardCarrier'), profile.cardCarrier);
        System.assertEquals(objMap.get('cardExpire'), profile.cardExpire);
        System.assertEquals(objMap.get('clearingHouseId'), profile.clearingHouseId);
        System.assertEquals(objMap.get('custBankAccNum'), profile.custBankAccNum);
        System.assertEquals(objMap.get('custBankAccOwner'), profile.custBankAccOwner);
        System.assertEquals(objMap.get('custBankAcctType'), profile.custBankAcctType);
        System.assertEquals(objMap.get('custBankBic'), profile.custBankBic);
        System.assertEquals(objMap.get('custBankBicHist'), profile.custBankBicHist);
        System.assertEquals(objMap.get('custBankIban'), profile.custBankIban);
        System.assertEquals(objMap.get('custBankIbanHist'), profile.custBankIbanHist);
        System.assertEquals(objMap.get('custBankSortCode'), profile.custBankSortCode);
        System.assertEquals(objMap.get('custBillAddress'), profile.custBillAddress);
        System.assertEquals(objMap.get('custBillCity'), profile.custBillCity);
        System.assertEquals(objMap.get('custBillCountryCode'), profile.custBillCountryCode);
        System.assertEquals(objMap.get('custBillState'), profile.custBillState);
        System.assertEquals(objMap.get('custBillZip'), profile.custBillZip);
        System.assertEquals(objMap.get('custCompanyName'), profile.custCompanyName);
        System.assertEquals(objMap.get('custEmail'), profile.custEmail);
        System.assertEquals(objMap.get('custPhone'), profile.custPhone);
        System.assertEquals(objMap.get('cyclicalBillUsed'), profile.cyclicalBillUsed);
        System.assertEquals(objMap.get('diffAcctOwnFlag'), profile.diffAcctOwnFlag);
        System.assertEquals(objMap.get('driverLicenseNum'), profile.driverLicenseNum);
        System.assertEquals(objMap.get('driverLicenseState'), profile.driverLicenseState);
        System.assertEquals(objMap.get('epgSubscriptionId'), profile.epgSubscriptionId);
        System.assertEquals(objMap.get('isDefault'), profile.isDefault);
        System.assertEquals(objMap.get('isTemporary'), profile.isTemporary);
        System.assertEquals(objMap.get('mandateId'), profile.mandateId);
        System.assertEquals(objMap.get('mandateReset'), profile.mandateReset);
        System.assertEquals(objMap.get('mandateSignDate'), profile.mandateSignDate);
        System.assertEquals(objMap.get('mandateStatus'), profile.mandateStatus);
        System.assertEquals(objMap.get('newCustBankSortCode'), profile.newCustBankSortCode);
        System.assertEquals(objMap.get('nonRealtimeOnly'), profile.nonRealtimeOnly);
        System.assertEquals(objMap.get('ownrFname'), profile.ownrFname);
        System.assertEquals(objMap.get('ownrLname'), profile.ownrLname);
        System.assertEquals(objMap.get('paymentMerchantId'), profile.paymentMerchantId);
        System.assertEquals(objMap.get('payMethod'), profile.payMethod);
        System.assertEquals(objMap.get('profileCreationTime'), profile.profileCreationTime);
        System.assertEquals(objMap.get('referenceNumber'), profile.referenceNumber);
        System.assertEquals(objMap.get('sequenceType'), profile.sequenceType);
        System.assertEquals(objMap.get('status'), profile.status);
        System.assertEquals(objMap.get('transactionUuid'), profile.transactionUuid);
        System.assertEquals(objMap.get('transFlag'), profile.transFlag);
	}

}