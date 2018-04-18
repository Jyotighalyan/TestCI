/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
public class KenanPaymentProfileMapper implements KenanObjectMapper {

	public KenanPaymentProfileMapper(){

	}

	public Map<String,Object> getEnumeratedValues(KenanObject kObject){
		KenanPaymentProfile paymentProfile = (KenanPaymentProfile) kObject;
		Map<String,Object> profileMap = new Map<String,Object>();

		if (paymentProfile.altBankAccNum != null) profileMap.put('altBankAccNum', paymentProfile.altBankAccNum);
		if (paymentProfile.avsAddressId != null) profileMap.put('avsAddressId', paymentProfile.avsAddressId);
		if (paymentProfile.avsResponseCode != null) profileMap.put('avsResponseCode', paymentProfile.avsResponseCode);
		if (paymentProfile.bankAccountType != null) profileMap.put('bankAccountType', paymentProfile.bankAccountType);
		if (paymentProfile.bankAgencyCode != null) profileMap.put('bankAgencyCode', paymentProfile.bankAgencyCode);
		if (paymentProfile.bankAgencyName != null) profileMap.put('bankAgencyName', paymentProfile.bankAgencyName);
		if (paymentProfile.bankCode != null) profileMap.put('bankCode', paymentProfile.bankCode);
		if (paymentProfile.billCompanyTaxId != null) profileMap.put('billCompanyTaxId', paymentProfile.billCompanyTaxId);
		if (paymentProfile.branchCode != null) profileMap.put('branchCode', paymentProfile.branchCode);
		if (paymentProfile.branchName != null) profileMap.put('branchName', paymentProfile.branchName);
		if (paymentProfile.cardAccount != null) profileMap.put('cardAccount', paymentProfile.cardAccount);
		if (paymentProfile.cardCarrier != null) profileMap.put('cardCarrier', paymentProfile.cardCarrier);
		if (paymentProfile.cardExpire != null) profileMap.put('cardExpire', paymentProfile.cardExpire);
		if (paymentProfile.clearingHouseId != null) profileMap.put('clearingHouseId', paymentProfile.clearingHouseId);
		if (paymentProfile.custBankAccNum != null) profileMap.put('custBankAccNum', paymentProfile.custBankAccNum);
		if (paymentProfile.custBankAccOwner != null) profileMap.put('custBankAccOwner', paymentProfile.custBankAccOwner);
		if (paymentProfile.custBankAcctType != null) profileMap.put('custBankAcctType', paymentProfile.custBankAcctType);
		if (paymentProfile.custBankBic != null) profileMap.put('custBankBic', paymentProfile.custBankBic);
		if (paymentProfile.custBankBicHist != null) profileMap.put('custBankBicHist', paymentProfile.custBankBicHist);
		if (paymentProfile.custBankIban != null) profileMap.put('custBankIban', paymentProfile.custBankIban);
		if (paymentProfile.custBankIbanHist != null) profileMap.put('custBankIbanHist', paymentProfile.custBankIbanHist);
		if (paymentProfile.custBankSortCode != null) profileMap.put('custBankSortCode', paymentProfile.custBankSortCode);
		if (paymentProfile.custBillAddress != null) profileMap.put('custBillAddress', paymentProfile.custBillAddress);
		if (paymentProfile.custBillCity != null) profileMap.put('custBillCity', paymentProfile.custBillCity);
		if (paymentProfile.custBillCountryCode != null) profileMap.put('custBillCountryCode', paymentProfile.custBillCountryCode);
		if (paymentProfile.custBillState != null) profileMap.put('custBillState', paymentProfile.custBillState);
		if (paymentProfile.custBillZip != null) profileMap.put('custBillZip', paymentProfile.custBillZip);
		if (paymentProfile.custCompanyName != null) profileMap.put('custCompanyName', paymentProfile.custCompanyName);
		if (paymentProfile.custEmail != null) profileMap.put('custEmail', paymentProfile.custEmail);
		if (paymentProfile.custPhone != null) profileMap.put('custPhone', paymentProfile.custPhone);
		if (paymentProfile.cyclicalBillUsed != null) profileMap.put('cyclicalBillUsed', paymentProfile.cyclicalBillUsed);
		if (paymentProfile.diffAcctOwnFlag != null) profileMap.put('diffAcctOwnFlag', paymentProfile.diffAcctOwnFlag);
		if (paymentProfile.driverLicenseNum != null) profileMap.put('driverLicenseNum', paymentProfile.driverLicenseNum);
		if (paymentProfile.driverLicenseState != null) profileMap.put('driverLicenseState', paymentProfile.driverLicenseState);
		if (paymentProfile.epgSubscriptionId != null) profileMap.put('epgSubscriptionId', paymentProfile.epgSubscriptionId);
		if (paymentProfile.isDefault != null) profileMap.put('isDefault', paymentProfile.isDefault);
		if (paymentProfile.isTemporary != null) profileMap.put('isTemporary', paymentProfile.isTemporary);
		if (paymentProfile.mandateId != null) profileMap.put('mandateId', paymentProfile.mandateId);
		if (paymentProfile.mandateReset != null) profileMap.put('mandateReset', paymentProfile.mandateReset);
		if (paymentProfile.mandateSignDate != null) profileMap.put('mandateSignDate', paymentProfile.mandateSignDate);
		if (paymentProfile.mandateStatus != null) profileMap.put('mandateStatus', paymentProfile.mandateStatus);
		if (paymentProfile.newCustBankSortCode != null) profileMap.put('newCustBankSortCode', paymentProfile.newCustBankSortCode);
		if (paymentProfile.nonRealtimeOnly != null) profileMap.put('nonRealtimeOnly', paymentProfile.nonRealtimeOnly);
		if (paymentProfile.ownrFname != null) profileMap.put('ownrFname', paymentProfile.ownrFname);
		if (paymentProfile.ownrLname != null) profileMap.put('ownrLname', paymentProfile.ownrLname);
		if (paymentProfile.paymentMerchantId != null) profileMap.put('paymentMerchantId', paymentProfile.paymentMerchantId);
		if (paymentProfile.payMethod != null) profileMap.put('payMethod', paymentProfile.payMethod);
		if (paymentProfile.profileCreationTime != null) profileMap.put('profileCreationTime', paymentProfile.profileCreationTime);
		if (paymentProfile.referenceNumber != null) profileMap.put('referenceNumber', paymentProfile.referenceNumber);
		if (paymentProfile.sequenceType != null) profileMap.put('sequenceType', paymentProfile.sequenceType);
		if (paymentProfile.status != null) profileMap.put('status', paymentProfile.status);
		if (paymentProfile.transactionUuid != null) profileMap.put('transactionUuid', paymentProfile.transactionUuid);
		if (paymentProfile.transFlag != null) profileMap.put('transFlag', paymentProfile.transFlag);

		return profileMap;
	}

	public KenanPaymentProfile getDisplayValues(Map<String,Object> objectMap) {
		KenanPaymentProfile profile = new KenanPaymentProfile();

		if (objectMap.get('altBankAccNum') != null) profile.altBankAccNum = String.valueOf(objectMap.get('altBankAccNum'));
  		if (objectMap.get('avsAddressId') != null) profile.avsAddressId = Integer.valueOf(objectMap.get('avsAddressId'));
		if (objectMap.get('avsResponseCode') != null) profile.avsResponseCode = String.valueOf(objectMap.get('avsResponseCode'));
		if (objectMap.get('bankAccountType') != null) profile.bankAccountType = Integer.valueOf(objectMap.get('bankAccountType'));
		if (objectMap.get('bankAgencyCode') != null) profile.bankAgencyCode = String.valueOf(objectMap.get('bankAgencyCode'));
		if (objectMap.get('bankAgencyName') != null) profile.bankAgencyName = String.valueOf(objectMap.get('bankAgencyName'));
		if (objectMap.get('bankCode') != null) profile.bankCode = String.valueOf(objectMap.get('bankCode'));
		if (objectMap.get('billCompanyTaxId') != null) profile.billCompanyTaxId = (Long) objectMap.get('billCompanyTaxId');
		if (objectMap.get('branchCode') != null) profile.branchCode = String.valueOf(objectMap.get('branchCode'));
		if (objectMap.get('branchName') != null) profile.branchName = String.valueOf(objectMap.get('branchName'));
		if (objectMap.get('cardAccount') != null) profile.cardAccount = String.valueOf(objectMap.get('cardAccount'));
		if (objectMap.get('cardCarrier') != null) profile.cardCarrier = String.valueOf(objectMap.get('cardCarrier'));
		if (objectMap.get('cardExpire') != null) profile.cardExpire = String.valueOf(objectMap.get('cardExpire'));
		if (objectMap.get('clearingHouseId') != null) profile.clearingHouseId = String.valueOf(objectMap.get('clearingHouseId'));
		if (objectMap.get('custBankAccNum') != null) profile.custBankAccNum = String.valueOf(objectMap.get('custBankAccNum'));
		if (objectMap.get('custBankAccOwner') != null) profile.custBankAccOwner = String.valueOf(objectMap.get('custBankAccOwner'));
		if (objectMap.get('custBankAcctType') != null) profile.custBankAcctType = String.valueOf(objectMap.get('custBankAcctType'));
		if (objectMap.get('custBankBic') != null) profile.custBankBic = String.valueOf(objectMap.get('custBankBic'));
		if (objectMap.get('custBankBicHist') != null) profile.custBankBicHist = String.valueOf(objectMap.get('custBankBicHist'));
		if (objectMap.get('custBankIban') != null) profile.custBankIban = String.valueOf(objectMap.get('custBankIban'));
		if (objectMap.get('custBankIbanHist') != null) profile.custBankIbanHist = String.valueOf(objectMap.get('custBankIbanHist'));
		if (objectMap.get('custBankSortCode') != null) profile.custBankSortCode = String.valueOf(objectMap.get('custBankSortCode'));
		if (objectMap.get('custBillAddress') != null) profile.custBillAddress = String.valueOf(objectMap.get('custBillAddress'));
		if (objectMap.get('custBillCity') != null) profile.custBillCity = String.valueOf(objectMap.get('custBillCity'));
		if (objectMap.get('custBillCountryCode') != null) profile.custBillCountryCode = Integer.valueOf(objectMap.get('custBillCountryCode'));
		if (objectMap.get('custBillState') != null) profile.custBillState = String.valueOf(objectMap.get('custBillState'));
		if (objectMap.get('custBillZip') != null) profile.custBillZip = String.valueOf(objectMap.get('custBillZip'));
		if (objectMap.get('custCompanyName') != null) profile.custCompanyName = String.valueOf(objectMap.get('custCompanyName'));
		if (objectMap.get('custEmail') != null) profile.custEmail = String.valueOf(objectMap.get('custEmail'));
		if (objectMap.get('custPhone') != null) profile.custPhone = String.valueOf(objectMap.get('custPhone'));
		if (objectMap.get('cyclicalBillUsed') != null) profile.cyclicalBillUsed = Boolean.valueOf(objectMap.get('cyclicalBillUsed'));
		if (objectMap.get('diffAcctOwnFlag') != null) profile.diffAcctOwnFlag = String.valueOf(objectMap.get('diffAcctOwnFlag'));
		if (objectMap.get('driverLicenseNum') != null) profile.driverLicenseNum = String.valueOf(objectMap.get('driverLicenseNum'));
		if (objectMap.get('driverLicenseState') != null) profile.driverLicenseState = String.valueOf(objectMap.get('driverLicenseState'));
		if (objectMap.get('epgSubscriptionId') != null) profile.epgSubscriptionId = String.valueOf(objectMap.get('epgSubscriptionId'));
		if (objectMap.get('isDefault') != null) profile.isDefault = Boolean.valueOf(objectMap.get('isDefault'));
		if (objectMap.get('isTemporary') != null) profile.isTemporary = Boolean.valueOf(objectMap.get('isTemporary'));
		if (objectMap.get('mandateId') != null) profile.mandateId = String.valueOf(objectMap.get('mandateId'));
		if (objectMap.get('mandateReset') != null) profile.mandateReset = String.valueOf(objectMap.get('mandateReset'));
		if (objectMap.get('mandateSignDate') != null) profile.mandateSignDate = KenanUtils.fixDateTime(objectMap.get('mandateSignDate'));
		if (objectMap.get('mandateStatus') != null) profile.mandateStatus = String.valueOf(objectMap.get('mandateStatus'));
		if (objectMap.get('newCustBankSortCode') != null) profile.newCustBankSortCode = String.valueOf(objectMap.get('newCustBankSortCode'));
		if (objectMap.get('nonRealtimeOnly') != null) profile.nonRealtimeOnly = Boolean.valueOf(objectMap.get('nonRealtimeOnly'));
		if (objectMap.get('ownrFname') != null) profile.ownrFname = String.valueOf(objectMap.get('ownrFname'));
		if (objectMap.get('ownrLname') != null) profile.ownrLname = String.valueOf(objectMap.get('ownrLname'));
		if (objectMap.get('paymentMerchantId') != null) profile.paymentMerchantId = Integer.valueOf(objectMap.get('paymentMerchantId'));
		if (objectMap.get('payMethod') != null) profile.payMethod = String.valueOf(objectMap.get('payMethod'));
		if (objectMap.get('profileCreationTime') != null) profile.profileCreationTime = KenanUtils.fixDateTime(objectMap.get('profileCreationTime'));
		if (objectMap.get('referenceNumber') != null) profile.referenceNumber = String.valueOf(objectMap.get('referenceNumber'));
		if (objectMap.get('sequenceType') != null) profile.sequenceType = String.valueOf(objectMap.get('sequenceType'));
		if (objectMap.get('status') != null) profile.status = Integer.valueOf(objectMap.get('status'));
		if (objectMap.get('transactionUuid') != null) profile.transactionUuid = String.valueOf(objectMap.get('transactionUuid'));
		if (objectMap.get('transFlag') != null) profile.transFlag = String.valueOf(objectMap.get('transFlag'));

		return profile;
	}
}