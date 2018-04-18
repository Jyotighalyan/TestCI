@isTest
global class UM_AddressResponseMock implements WebServiceMock {

    public static String resmth;

    global void doInvoke(    
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {

        // start - specify the response you want to send
        if(resmth == 'search') {
            /*UM_AddressResponse.addressSearchResponse response_x = new UM_AddressResponse.addressSearchResponse();
            response_x.return_x = new UM_AddressResponse.addresses();

            UM_AddressResponse.address addr = new UM_AddressResponse.address();
            addr.buildingId = '123654';
            addr.street = 'Flughafen Allee';
            addr.zip = '28199';
            addr.streetNo = '25';

            response_x.return_x.address = new List<UM_AddressResponse.address>();
            response_x.return_x.address.add( addr );
            // end
            response.put('response_x', response_x);*/

        } else if (resmth == 'searchext') {
            UM_AddressResponse.addressSearchExtResponse response_x = new UM_AddressResponse.addressSearchExtResponse();
            response_x.return_x = new UM_AddressResponse.addressesExt();

            UM_AddressResponse.addressExt addr = new UM_AddressResponse.addressExt();
            addr.buildingId = '123654';
            addr.street = 'Flughafen Allee';
            addr.zip = '28199';
            addr.streetNo = '25';
            addr.mktAnalog = 'Y';
            addr.mktDigital = 'N';
            addr.mktInternet = 'Y';
            addr.mktMobile = 'Y';
            addr.mktPhone = 'N';

            response_x.return_x.address = new List<UM_AddressResponse.addressExt>();
            response_x.return_x.address.add( addr );
            // end
            response.put('response_x', response_x);

        }
    }
}