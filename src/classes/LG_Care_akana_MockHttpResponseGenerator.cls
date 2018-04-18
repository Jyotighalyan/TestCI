global class LG_Care_akana_MockHttpResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String bodyJSON = '{"response": {"Status": "True", "access_token": "real_madrid_club_de_football", "expires_in": "1902"}}';
        res.setBody(bodyJSON);
        res.setStatusCode(200);
        return res;
    }
}