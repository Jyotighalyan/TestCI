/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
@isTest
global class KenanServiceItemCalloutMock implements HttpCalloutMock {
    
    
    private String jsonService = '{"activeDate": "2016-07-06T00:00:00.000Z","annotation": "Test Annotation","annotation2": "Test Annotation 2","currencyCode": 10,"inactiveDate": "2017-07-06T00:00:00.000Z","instanceId": "1","itemId": 0,"itemType": 0,"rate": 0,"salesforceId": "1"}';
        
    global Integer numberOfRecords { get; set; }
    
    global HttpResponse respond ( HTTPRequest req ) {
        List<String> jsonList = new List<String>();
        String jsonString = '';
        if (numberOfRecords == 1){
            jsonString = jsonService;
        } else {
            for (Integer i = 0; i < numberOfRecords; i++){
                jsonList.add('{"activeDate": "2016-07-06T00:00:00.000Z","annotation": "Test Annotation","annotation2": "Test Annotation 2","currencyCode": 10,"inactiveDate": "2017-07-06T00:00:00.000Z","instanceId": "1","itemId": 0,"itemType": 0,"rate": 0,"salesforceId": "1"}');
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