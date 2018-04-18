/**
* Used for unit testing of the UM_MACDConfigurationController as a HTTP Mockup
* 
* @author Robert Stankiewicz
* @since  22/08/2016
*/
@isTest
public class UM_MACDConfRfsCheckMock implements HttpCalloutMock {

    protected Integer code;
    protected String status;
    protected String body;
    protected Map<String, String> responseHeaders;

    public UM_MACDConfRfsCheckMock(Integer code, String status, String body) {
        this.code = code;
        this.status = status;
        this.body = body;
    }

    public HTTPResponse respond(HTTPRequest req) {

        HttpResponse res = new HttpResponse();
        res.setBody(this.body);
        res.setStatusCode(this.code);
        res.setStatus(this.status);
        return res;
    }

}