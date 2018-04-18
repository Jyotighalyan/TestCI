/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Http Connection Helper manages building the HTTP Callout from Salesforce to the Kenan API
*/
public class KenanHTTPConnectionHelper {

	public KenanHTTPConnectionHelper(){

	}

	public HttpResponse sendRequest(String jsonString, String method, String endpoint, Integer startRecord, Integer blockSize){
		KenanLogUtils.logInfo('sendRequest', 'jsonString', jsonString);
		KenanLogUtils.logInfo('sendRequest', 'method', method);
		KenanLogUtils.logInfo('sendRequest', 'endpoint', endpoint);

		KenanServiceConnection__c connection = KenanServiceConnection__c.getInstance();

		//https://sfdcapi.kenanax.com/kenan-salesforce-api/rest
		//Basic YWRtaW46YWRtaW4=
		HttpRequest request = new HttpRequest();
		request.setMethod(method);
		request.setHeader('Content-Type', 'application/json');
		request.setHeader('Accept', 'application/json');
		request.setHeader('startRecord', String.valueOf(startRecord));
		request.setHeader('blockSize', String.valueOf(blockSize));
		request.setHeader('Authorization', connection.Authentication_Token__c);
		request.setTimeout(Integer.valueOf(connection.Session_Timeout__c));
		request.setEndpoint(connection.Connection_URL__c + connection.REST_Application_Base__c + endpoint);

		if (String.isNotEmpty(jsonString)){
			request.setBody(jsonString);	
		}
        else {
            request.setHeader('Content-Length', String.valueOf(0));
        }
		Http service = new Http();
		HttpResponse response = service.send(request);	
		if (response.getBody() != null) {
			KenanLogUtils.logInfo('sendRequest', 'response', response.getBody());
		}
		
		return response;
	}

}