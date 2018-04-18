/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
@isTest
global class KenanPaymentProfileServiceMock implements HttpCalloutMock {
	
	private String jsonService = '{"accountExternalId":"string","accountExternalIdType":0,"accountInternalId":0,"altBankAccNum":"1234","avsAddressId":0,"avsResponseCode":"string","bankAccountType":0,"bankAgencyCode":"string","bankAgencyName":"string","bankCode":"string","billCompanyTaxId":0,"branchCode":"string","branchName":"Test Branch Name","cardAccount":"string","cardCarrier":"string","cardExpire":"string","clearingHouseId":"string","custBankAccNum":"string","custBankAccOwner":"string","custBankAcctType":"string","custBankBic":"string","custBankBicHist":"string","custBankIban":"string","custBankIbanHist":"string","custBankSortCode":"string","custBillAddress":"string","custBillCity":"string","custBillCountryCode":0,"custBillState":"string","custBillZip":"string","custCompanyName":"Test Company Name","custEmail":"test@test.org","custPhone":"string","cyclicalBillUsed":true,"diffAcctOwnFlag":"string","driverLicenseNum":"string","driverLicenseState":"string","isDefault":true,"isTemporary":true,"mandateId":"string","mandateReset":"string","mandateSignDate":"2016-07-28T11:36:44.364Z","mandateStatus":"Test Status","newCustBankSortCode":"string","nonRealtimeOnly":true,"ownrFname":"string","ownrLname":"string","payMethod":0,"profileId":0,"sequenceType":"string","status":0,"transFlag":"string"}';

	global Integer numberOfRecords { get; set; }
	
	global HttpResponse respond ( HTTPRequest req ) {
		List<String> jsonList = new List<String>();
		String jsonString = '';
		if (numberOfRecords == 1){
			jsonString = jsonService;
		} else {
			for (Integer i = 0; i < numberOfRecords; i++){
				jsonList.add('');
			}
			jsonString = JSON.serialize(jsonList);
		}
		
		HttpResponse res = new HttpResponse();
		res.setHeader ('Content-Type', 'application/json');
		res.setBody (jsonString);
		res.setStatusCode ( 200 );
		System.assertNotEquals ( null, res.getBody(), 'response body should not be null' );
		return res;
	}

}