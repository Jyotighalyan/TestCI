/**
  * Class that is used to fake the response for HTTP callouts for test purposes
  *
  * @Author: Ferdinand Bondt
  * @Version: 1.0
  */
@isTest
global class UM_DocumentumResponseMock implements HttpCalloutMock{

    /**
      * Method that fakes the Documentum interface
      *
      * @param req  The HTTP request used
      */
    
    public String type;
	Public UM_DocumentumResponseMock(){
        //this.type = input;
    } 
    Public UM_DocumentumResponseMock(String input){
        this.type = input;
    }  
    global HTTPResponse respond(HTTPRequest req) {

        // Create a fake response
        HttpResponse res = new HttpResponse();
        if(type=='DocumentList')
        {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('<documents><document id="0901c4138de67958" content_type="pdf"><invoice><number>8849607</number><date>2010-02-05T00:00:00.000+01:00</date><total>0.0</total></invoice></document></documents>');
            res.setStatusCode(200);
            
        }
        if(type=='InvoiceSuccess')
        {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('test pdf');
            res.setStatusCode(200);
            
        } 
        if(type=='InvoiceFailure')
        {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('Error- unavailable');
            res.setStatusCode(404);
            
        } 
        if(type=='InvoiceAuthorization')
        {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('Error- unauthorized');
            res.setStatusCode(401);
            
        }     
        return res;
    }
}