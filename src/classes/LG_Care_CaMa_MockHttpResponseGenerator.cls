@isTest(seeAllData=false)
global class LG_Care_CaMa_MockHttpResponseGenerator implements HttpCalloutMock {
   
    global HTTPResponse respond(HTTPRequest req) {
        
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String xml = '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">'+
                '<Body>'+
                    '<createTroubleTicket xmlns="http://ticketws.unitymedia.com/">'+
                        '<success xmlns="">true</success>'+
                        '<errorCode xmlns="">test error code</errorCode>'+
                        '<errorMessage xmlns="">test error message</errorMessage>'+
                        '</createTroubleTicket>'+
                '</Body>'+
            '</Envelope>';
        res.setBody(xml);
        res.setStatusCode(200);
        return res;
    }
}