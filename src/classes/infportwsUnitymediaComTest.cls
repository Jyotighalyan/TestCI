@isTest
global class infportwsUnitymediaComTest implements WebServiceMock {
    
    
    public string startNumber {get;set;}
    public string endNumber {get;set;}
    public string prefix {get;set;}
    public string reservationKey {get;set;}
    //Public String response_x;
    
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
        String responseType
    ) {
        System.debug('requestName='+requestName);
        InfoportServiceConnection__c setting = new InfoportServiceConnection__c();
        //infportwsUnitymediaCom.InfportWSPort pbWebService = new infportwsUnitymediaCom.InfportWSPort();
        
        //wwwDialogikaDeWsdlInfportSchemasSp.ReserveNumbersResponse_element resp = new wwwDialogikaDeWsdlInfportSchemasSp.ReserveNumbersResponse_element();
        //resp.reservationKey = '1234';
        if(requestName=='reserveNumbers'){
            infportwsUnitymediaCom.reserveNumbersResponse response_x = new infportwsUnitymediaCom.reserveNumbersResponse();
            response_x.return_x = new wwwDialogikaDeWsdlInfportSchemasSp.ReserveNumbersResponse_element();
            response_x.return_x.reservationKey = '1234';
            response.put('response_x', response_x);

        }else if(requestName=='getAllCarriers'){
            infportwsUnitymediaCom.getAllCarriersResponse response_x = new infportwsUnitymediaCom.getAllCarriersResponse();
            response_x.return_x = new wwwDialogikaDeWsdlInfportSchemasSf.GetAllCarriersResponse_element();
            response_x.return_x.fnCarriers = new wwwDialogikaDeWsdlInfportSchemasSf.taFnCarrier();
            response.put('response_x', response_x);

        }else if(requestName=='removeReservation'){
            infportwsUnitymediaCom.removeReservationResponse response_x = new infportwsUnitymediaCom.removeReservationResponse();
            response_x.return_x = new wwwDialogikaDeWsdlInfportSchemasIn.tVoid();            
            response.put('response_x', response_x);

        }         
    }
    
    
    
}