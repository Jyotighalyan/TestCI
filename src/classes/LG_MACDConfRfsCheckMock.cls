/**
* Used for unit testing of the LG_MACDConfigurationController as a HTTP Mockup
* 
* @author Tomislav Blazek
* @ticket SFDT-240
* @since  25/2/2016
*/
@isTest
public class LG_MACDConfRfsCheckMock implements HttpCalloutMock {

    protected Integer code;
    protected String status;
    protected String body;
    protected Map<String, String> responseHeaders;

    public LG_MACDConfRfsCheckMock(Integer code, String status, String body) {
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