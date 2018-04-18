global class LG_Care_SBC_MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
       
        //System.assertEquals('GET', req.getMethod()); 
        // Create a fake response
        String JsonText='{"response": {"Status": "True","message":"None", "Status-code": ""}}';
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        res.setBody(JsonText);
        res.setStatusCode(200);
        return res;
    }
}