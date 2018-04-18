/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Adjustment Data structure for use in Salesforce Kenan Connection Service
*/
@isTest
global class KenanAdjustmentCalloutMock implements HttpCalloutMock {

    global Integer numberOfRecords { get; set; }

    public HTTPResponse respond(HTTPRequest req) {
        List<KenanAdjustment> jsonList = new List<KenanAdjustment>();
        String jsonString = '';
        if (numberOfRecords == 1){
            jsonString = JSON.serialize(createKenanAdjustment());
        } else {
            for (Integer i = 0; i < numberOfRecords; i++){
                jsonList.add(createKenanAdjustment());
            }
            jsonString = JSON.serialize(jsonList);
        }
        
        HttpResponse res = new HttpResponse();
        res.setHeader ('Content-Type', 'application/json');
        res.setBody(jsonString);
        res.setStatusCode ( 200 );
        System.assertNotEquals ( null, res.getBody(), 'response body should not be null' );
        return res;
    }

    private KenanAdjustment createKenanAdjustment() {
        KenanAdjustment adjustment = new KenanAdjustment();
        DateTime curDate = DateTime.now();
        Decimal amt = 300;
               
        adjustment.accountExternalId = 'extId';
        adjustment.accountExternalIdType = 1;
        adjustment.accountInternalId = 2;
        adjustment.adjReasonCode = '11';
        adjustment.billRefNo = 3.0;
        adjustment.billRefResets = 4.0;
        adjustment.currencyCode = '10';
        adjustment.effectiveDate = curDate;
        adjustment.fraudIndicator = 'fraudIndicator';
        //adjustment.invoice = 'invoice';
        adjustment.invoiceItem = 'invoiceItem';
        adjustment.origType = '4';
        adjustment.openItemId = '101';
        adjustment.primaryUnits = 'primaryUnits';
        adjustment.primaryUnitsType = 'primaryUnitsType';
        adjustment.requestStatus = '1';
        adjustment.revRcvCostCtr = 'revRcvCostCtr';
        adjustment.totalAmt = amt;
        adjustment.trackingId = 'trackingId';
        adjustment.trackingIdServ = 'trackingIdServ';
        adjustment.approvedBy = 'Me';
        adjustment.approvalStatus = 'approved';
        return adjustment;
    }

}