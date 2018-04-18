/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
@isTest
private class KenanPaymentProfileTest {
	
	@isTest
	static void testProperties() {
		DateTime curTime = DateTime.now();
		Test.startTest();
		KenanPaymentProfile payProfile = new KenanPaymentProfile();
		payProfile.altBankAccNum = '1';
		payProfile.avsAddressId = 1;
		payProfile.avsResponseCode = '2';
		payProfile.bankAccountType = 1;
		payProfile.bankAgencyCode = '3';
		payProfile.bankAgencyName = '4';
		payProfile.bankCode = '5';
		payProfile.billCompanyTaxId = 1;
		payProfile.branchCode = '6';
		payProfile.branchName = '7';
		payProfile.cardAccount = '8';
		payProfile.cardCarrier = '9';
		payProfile.cardExpire = '10';
		payProfile.clearingHouseId = '11';
		payProfile.custBankAccNum = '12';
		payProfile.custBankAccOwner = '13';
		payProfile.custBankAcctType = '14';
		payProfile.custBankBic = '15';
		payProfile.custBankBicHist = '16';
		payProfile.custBankIban = '17';
		payProfile.custBankIbanHist = '18';
		payProfile.custBankSortCode = '19';
		payProfile.custBillAddress = '20';
		payProfile.custBillCity = '21';
		payProfile.custBillCountryCode = 1;
		payProfile.custBillState = '22';
		payProfile.custBillZip = '23';
		payProfile.custCompanyName = '24';
		payProfile.custEmail = '25';
		payProfile.custPhone = '26';
		payProfile.cyclicalBillUsed = false;
		payProfile.diffAcctOwnFlag = '27';
		payProfile.driverLicenseNum = '28';
		payProfile.driverLicenseState = '29';
		payProfile.epgSubscriptionId = '30';
		payProfile.isDefault = false;
		payProfile.isTemporary = false;
		payProfile.mandateId = '31';
		payProfile.mandateReset = '32';
		payProfile.mandateSignDate = curTime;
		payProfile.mandateStatus = '33';
		payProfile.newCustBankSortCode = '34';
		payProfile.nonRealtimeOnly = false;
		payProfile.ownrFname = '35';
		payProfile.ownrLname = '36';
		payProfile.paymentMerchantId = 1;
		payProfile.payMethod = '37';
		payProfile.profileCreationTime = curTime;
		payProfile.referenceNumber = '38';
		payProfile.sequenceType = '39';
		payProfile.status = 1;
		payProfile.transactionUuid = '40';
		payProfile.transFlag = '41';
		Test.stopTest();
		
		System.assertEquals(payProfile.altBankAccNum, '1');
		System.assertEquals(payProfile.avsAddressId, 1);
		System.assertEquals(payProfile.avsResponseCode, '2');
		System.assertEquals(payProfile.bankAccountType, 1);
		System.assertEquals(payProfile.bankAgencyCode, '3');
		System.assertEquals(payProfile.bankAgencyName, '4');
		System.assertEquals(payProfile.bankCode, '5');
		System.assertEquals(payProfile.billCompanyTaxId, 1);
		System.assertEquals(payProfile.branchCode, '6');
		System.assertEquals(payProfile.branchName, '7');
		System.assertEquals(payProfile.cardAccount, '8');
		System.assertEquals(payProfile.cardCarrier, '9');
		System.assertEquals(payProfile.cardExpire, '10');
		System.assertEquals(payProfile.clearingHouseId, '11');
		System.assertEquals(payProfile.custBankAccNum, '12');
		System.assertEquals(payProfile.custBankAccOwner, '13');
		System.assertEquals(payProfile.custBankAcctType, '14');
		System.assertEquals(payProfile.custBankBic, '15');
		System.assertEquals(payProfile.custBankBicHist, '16');
		System.assertEquals(payProfile.custBankIban, '17');
		System.assertEquals(payProfile.custBankIbanHist, '18');
		System.assertEquals(payProfile.custBankSortCode, '19');
		System.assertEquals(payProfile.custBillAddress, '20');
		System.assertEquals(payProfile.custBillCity, '21');
		System.assertEquals(payProfile.custBillCountryCode, 1);
		System.assertEquals(payProfile.custBillState, '22');
		System.assertEquals(payProfile.custBillZip, '23');
		System.assertEquals(payProfile.custCompanyName, '24');
		System.assertEquals(payProfile.custEmail, '25');
		System.assertEquals(payProfile.custPhone, '26');
		System.assertEquals(payProfile.cyclicalBillUsed, false);
		System.assertEquals(payProfile.diffAcctOwnFlag, '27');
		System.assertEquals(payProfile.driverLicenseNum, '28');
		System.assertEquals(payProfile.driverLicenseState, '29');
		System.assertEquals(payProfile.epgSubscriptionId, '30');
		System.assertEquals(payProfile.isDefault, false);
		System.assertEquals(payProfile.isTemporary, false);
		System.assertEquals(payProfile.mandateId, '31');
		System.assertEquals(payProfile.mandateReset, '32');
		System.assertEquals(payProfile.mandateSignDate, curTime);
		System.assertEquals(payProfile.mandateStatus, '33');
		System.assertEquals(payProfile.newCustBankSortCode, '34');
		System.assertEquals(payProfile.nonRealtimeOnly, false);
		System.assertEquals(payProfile.ownrFname, '35');
		System.assertEquals(payProfile.ownrLname, '36');
		System.assertEquals(payProfile.paymentMerchantId, 1);
		System.assertEquals(payProfile.payMethod, '37');
		System.assertEquals(payProfile.profileCreationTime, curTime);
		System.assertEquals(payProfile.referenceNumber, '38');
		System.assertEquals(payProfile.sequenceType, '39');
		System.assertEquals(payProfile.status, 1);
		System.assertEquals(payProfile.transactionUuid, '40');
		System.assertEquals(payProfile.transFlag, '41');


	}
	
}