/**
  * Class that is used to make the connection with MPI Webservice via Spider
  *
  * @Author: Ferdinand Bondt
  * @Version: 1.0
  */
public class UM_MPIResponse {
	
	/**
	  * Method that makes the connection with Documentum and returns the http response
	  *
	  * @param url	string with the additional info for the callout
	  */
	public static HTTPResponse sendData(String boundary, Blob bodyBlob){
		HttpRequest req = new HttpRequest();
		req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
		req.setMethod('POST');
		req.setEndpoint('callout:UM_MPIWS');
		//req.setEndpoint('http://posttestserver.com/post.php?dir=test123');
		req.setBodyAsBlob(bodyBlob);
		req.setTimeout(60000);
		req.setHeader('Content-Length', String.valueof(req.getBodyAsBlob().size()));
		system.debug('Request is: '+req);
		Http http = new Http();
		HTTPResponse res = http.send(req);
		return res;
	}
}