global class LG_Care_USMS_MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
       
        System.assertEquals('POST', req.getMethod());
        // Create a fake response
       
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String xml = '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">'+
                '<Body>'+
                    '<createTroubleTicket xmlns="http://ticketws.unitymedia.com/">'+
                        '<IncidentNumber xmlns="">12345</IncidentNumber>'+
                        '<success xmlns="">true</success>'+
                        '<faultcode xmlns="">testFaultCode</faultcode>'+
                        '<faultstring xmlns="">testFaultString</faultstring>'+
                        '</createTroubleTicket>'+
                '</Body>'+
            '</Envelope>';
        res.setBody(xml);
        res.setStatusCode(200);
        return res;
    }
}