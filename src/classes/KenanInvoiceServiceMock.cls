/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Unit Test for use in Salesforce Kenan Connection Service
*/
@isTest
global class KenanInvoiceServiceMock implements HttpCalloutMock {

	global Integer numberOfRecords { get; set; }

	global static final String jsonString = '{"currencyCode":7,"accountStatus":-1,"collectionIndicator":0,"chgWho":"KENANFX                       ","chgDate":"2016-07-29T13:20:02.000+0000","billSequenceNum":1,"billDispMeth":6,"testFlag":false,"archFlag":false,"statementDate":"2016-06-01T00:00:00.000+0000","processNum":"1","payDueDate":"2016-07-01T00:00:00.000+0000","origPayDueDate":"2016-07-01T00:00:00.000+0000","newCharges":211513,"netNewCharges":211513,"totalDue":211513,"totalAdj":-464,"totalPaid":-211049,"balanceDue":0,"disputeAmt":-21897,"lateExemptCharges":0,"glAmount":211513,"balanceConverted":0,"newChargeCredits":0,"zip":"adf             ","fromDate":"2016-05-01T00:00:00.000+0000","toDate":"2016-06-01T00:00:00.000+0000","payMethod":3,"nextToDate":"2016-07-01T00:00:00.000+0000","prepDate":"2016-07-07T18:04:28.000+0000","taxDate":"2016-07-07T18:04:28.000+0000","paymentDueDate":"2016-07-01T00:00:00.000+0000","imageReq":false,"imageDone":false,"specialCode":-1,"prepTask":"bip01577e7d8a   ","prepStatus":1,"formatStatus":0,"dispatchCount":0,"pageCount":0,"backoutStatus":0,"jnlEarnedThruDt":"2016-07-01T00:00:00.000+0000","jnlStatus":-1,"accountInternalId":78,"accountExternalId":"78","accountExternalIdType":1,"billRefNo":1401,"billRefResets":0,"languageCode":4,"billPeriod":"M01","interimBillFlag":false,"includeNrc":false,"includeRc":false,"includeAdj":false,"includeUsage":false,"includePayment":false,"billConverted":0,"warmBillFlag":false,"prevBillRefno":0,"prevBillRefResets":0,"prevBalanceRefno":0,"prevBalanceRefResets":0}';
	
	global HttpResponse respond ( HTTPRequest req ) {		
		HttpResponse res = new HttpResponse();
		res.setHeader ('Content-Type', 'application/json');
		String jsonResult = '[';
		
		if (numberOfRecords == 1){
			res.setBody (jsonString);
		}
		else {
			
			for (Integer i = 0; i<= numberOfRecords; i++){
				jsonResult = jsonResult + jsonString + ',';
			}
			jsonResult = jsonResult.removeEnd(',') + ']';
			res.setBody (jsonResult);
		}
		
		res.setStatusCode ( 200 );
		System.assertNotEquals ( null, res.getBody(), 'response body should not be null' );
		return res;
	}
}