@isTest
global class UM_JiraCreateIssueMock implements HttpCalloutMock {
    
    String type = null;
    String errorBody = 'Cannot forward issue to JIRA: ORA-20012: ORA-20002: 500 <?xml version="1.0" encoding="UTF-8"'+
        'standalone="yes"?><status><status-code>500</status-code><stack-trace>java.lang.NullPointerException'+
        'at de.catworkx.jira.plugins.sol.utils.SolRestDataUtil.createIssueFromJSON(SolRestDataUtil.java:56'+
        'ORA-06512: at "APP_SPIDER.SPDINTJIR", line 25 ORA-06512: at line 1';
    
    global UM_JiraCreateIssueMock (String type)
    {
        this.type  = type;    
    }
    
    global HttpResponse respond (HttpRequest request) 
    {
        HttpResponse response = new HttpResponse();
        
        //Error when there is issue sending request to Jira
        if(type == '404') 
        {
            response.setHeader('Content-Type', 'application/json');
            response.setStatusCode(404);
            response.setBody(errorBody);
            response.setStatus('Not Found');
        }
        //webservice timeout error 
        else if(type == '408') 
        {
            response.setHeader('Content-Type', 'application/json');
            response.setStatusCode(408);
            response.setStatus('Time out');
        }
        //Successful Work Order Creation in Jira with key
        else if(type == '200') 
        {
            response.setHeader('Content-Type', 'application/json');
            response.setStatusCode(200);
            response.setBody('{"key" : "BBS-2300", "error" : null}');
            response.setStatus('Success');
        }
        //Successful Work Order Creation in Jira without key and error
        else if(type == 'ok') 
        {
            response.setHeader('Content-Type', 'application/json');
            response.setStatusCode(200);
            response.setBody('{"key" : null, "error" : null}');
            response.setStatus('Success');
        }
        //Webservice callout exception
        else if(type == 'calloutException')
        {
            CalloutException e = (CalloutException)CalloutException.class.newInstance();
            e.setMessage('Callout Error');
            throw e;
        }
        //General Exception -for e.g. StringException
        else
        {
            StringException ex = (StringException)StringException.class.newInstance();
            ex.setMessage(errorBody);
            throw ex;
        }
        
        return response;
    }
}