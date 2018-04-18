/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Exception for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanException extends Exception {

	public KenanException(HttpResponse response){
		handleException(response);
	}
    
    public String friendlyErrorMessage { get; private set; }
    public String errorName { get; set; }
    public String errorTextId { get; set; }
    public String errorCategory { get; set; }
	public String errorClass { get; set; }
	public String errorCode { get; set; }
	public String errorFileName { get; set; }
	public String errorFunctionName { get; set; }
	public String errorObjectName { get; set; }
	public String errorObjectFieldName { get; set; }
	public String errorLineNumber { get; set; }
	public String errorMessage { get; set; }
	public String message { get; set; }
	public String errorDetails { get; set; }
	public String extraInformation { get; set; }

	private void handleException(HttpResponse response){
		system.debug('handleException:' + response.getBody());
		Integer statusCode = response.getStatusCode();

        if ( (statusCode == 500) && (String.isNotEmpty(response.getBody())) ) {
            Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            
            if (errorMap.get('errorName') != null) this.errorName = String.valueOf(errorMap.get('errorName'));
            if (errorMap.get('errorTextId') != null) this.errorTextId = String.valueOf(errorMap.get('errorTextId')); 
            if (errorMap.get('errorCategory') != null) this.errorCategory = String.valueOf(errorMap.get('errorCategory'));
            if (errorMap.get('errorClass') != null) this.errorClass = String.valueOf(errorMap.get('errorClass'));
            if (errorMap.get('errorCode') != null) this.errorCode = String.valueOf(errorMap.get('errorCode'));
            if (errorMap.get('errorFileName') != null) this.errorFileName = String.valueOf(errorMap.get('errorFileName'));
            if (errorMap.get('errorFunctionName') != null) this.errorFunctionName = String.valueOf(errorMap.get('errorFunctionName'));
            if (errorMap.get('errorObjectName') != null) this.errorObjectName = String.valueOf(errorMap.get('errorObjectName'));
            if (errorMap.get('errorObjectFieldName') != null) this.errorObjectFieldName = String.valueOf(errorMap.get('errorObjectFieldName'));
            if (errorMap.get('errorLineNumber') != null) this.errorLineNumber = String.valueOf(errorMap.get('errorLineNumber'));
            if (errorMap.get('errorMessage') != null) this.errorMessage = String.valueOf(errorMap.get('errorMessage'));
            if (errorMap.get('message') != null) this.message = String.valueOf(errorMap.get('message'));
            if (errorMap.get('errorDetails') != null) this.errorDetails = String.valueOf(errorMap.get('errorDetails'));
            if (errorMap.get('extraInformation') != null) this.extraInformation = String.valueOf(errorMap.get('extraInformation'));
                        
        } else {
            
            this.errorTextId = String.valueOf(response.getStatusCode());
            this.errorMessage = response.getStatus();
        }

		getFriendlyMessage();
		
	}

	private void getFriendlyMessage(){
		String errorId;
		if (!String.isEmpty(this.errorTextId)){
			errorId = 'KenanError_' + this.errorTextId.replace('-', '_');
		}
		this.friendlyErrorMessage = KenanExceptionMessage.getMessage(errorId);
	}
}