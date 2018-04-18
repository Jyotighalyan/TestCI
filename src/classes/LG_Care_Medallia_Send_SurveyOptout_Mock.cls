@isTest(seeAllData=false)
global class LG_Care_Medallia_Send_SurveyOptout_Mock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        String JsonText='{"response": {"Status": "notOK", "Statuscode": "200"}}';
        res.setBody(JsonText);
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        return res;
    }
    
}