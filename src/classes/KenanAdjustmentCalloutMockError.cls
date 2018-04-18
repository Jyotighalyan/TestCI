/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Adjustment Data structure for use in Salesforce Kenan Connection Service
*/
@isTest
global class KenanAdjustmentCalloutMockError implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader ('Content-Type', 'application/json');
        res.setStatusCode ( 500 );
        res.setBody('{\"errorTextId\":\"Conn-023\",\"errorMessage\":\"This invoice record is not adjustable.\",\"message\":\"This invoice record is not adjustable.\"}');
        return res;
    }
}