/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
@isTest
global class KenanServiceCalloutMock implements HttpCalloutMock {
        
    global Integer numberOfRecords { get; set; }
    
    global HttpResponse respond ( HTTPRequest req ) {
        List<KenanService> jsonList = new List<KenanService>();
        String jsonString = '';
        
        if (numberOfRecords == 1) {
            jsonString = JSON.serialize(createService());
        } else {
            for (Integer i = 0; i < numberOfRecords; i++){
                jsonList.add(createService());
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

    private KenanService createService() {
        KenanService service = new KenanService();

        service.address1 = '123 Test St.';
        service.bserviceCompany = 'Test Company';
        service.bserviceFname = 'Test First Name';
        service.bserviceLname = 'Test Last Name';
        service.bservicePhone = '555-1212';
        service.city = 'Allentown';

        service.serviceItems.add(createServiceItem(1));
        service.serviceItems.add(createServiceItem(2));

        return service;
    }

    private KenanServiceItem createServiceItem(Integer num) {
        KenanServiceItem serviceItem = new KenanServiceItem();

        serviceItem.instanceId = '000' + num;
        serviceItem.itemId = num;
        serviceItem.itemType = num;
        serviceItem.rate = num;
        serviceItem.currencyCode = '1';

        return serviceItem;
    }
}