/**
  * Class that is used to fake the response for HTTP callouts for test purposes
  *
  * @Author: Ferdinand Bondt
  * @Version: 1.0
  */
@isTest
global class UM_MPIResponseMock implements HttpCalloutMock{
	
	/**
	  * Method that fakes the MPI interface
	  *
	  * @param req	The HTTP request used
	  */
	global HTTPResponse respond(HTTPRequest req) {

		// Create a fake response
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody('It is delivered');
		res.setStatusCode(200);
		return res;
	}
}