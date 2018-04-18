/**
  * Class that is used to make the connection with Documentum Webservice via Spider
  *
  * @Author: Ferdinand Bondt
  * @Version: 1.0
  */
public class UM_DocumentumResponse{

	/**
	  * Method that makes the connection with Documentum and returns the http response
	  *
	  * @param url	string with the additional info for the callout
	  */
	public static HTTPResponse getData(String url){
		HttpRequest req = new HttpRequest();
		req.setEndpoint('callout:UM_DocumentumWS/' + url);
		req.setMethod('GET');
		Http http = new Http();
		HTTPResponse res = http.send(req);
		return res;
	}
}