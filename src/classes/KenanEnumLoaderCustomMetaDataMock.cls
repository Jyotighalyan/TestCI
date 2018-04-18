/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Unit Test for use in Salesforce Kenan Connection Service
*/
@isTest
global class KenanEnumLoaderCustomMetaDataMock implements WebServiceMock {
	public void doInvoke(
		Object stub, Object request, Map<String, Object> response,
		String endpoint, String soapAction, String requestName,
		String responseNS, String responseName, String responseType) {
		if(request instanceof KenanMetaDataService.retrieve_element)
			response.put('response_x', new KenanMetaDataService.retrieveResponse_element());
		else if(request instanceof KenanMetaDataService.checkDeployStatus_element)
			response.put('response_x', new KenanMetaDataService.checkDeployStatusResponse_element());
		else if(request instanceof KenanMetaDataService.listMetadata_element)
			response.put('response_x', new KenanMetaDataService.listMetadataResponse_element());
		else if(request instanceof KenanMetaDataService.checkRetrieveStatus_element)
			response.put('response_x', new KenanMetaDataService.checkRetrieveStatusResponse_element());
		else if(request instanceof KenanMetaDataService.describeMetadata_element)
			response.put('response_x', new KenanMetaDataService.describeMetadataResponse_element());
		else if(request instanceof KenanMetaDataService.deploy_element)
			response.put('response_x', new KenanMetaDataService.deployResponse_element());
        else if(request instanceof KenanMetaDataService.updateMetadata_element)
            response.put('response_x', new KenanMetaDataService.updateMetadataResponse_element());
        else if(request instanceof KenanMetaDataService.renameMetadata_element)
            response.put('response_x', new KenanMetaDataService.renameMetadataResponse_element());
        else if(request instanceof  KenanMetaDataService.cancelDeploy_element)
            response.put('response_x', new KenanMetaDataService.cancelDeployResponse_element());
        else if(request instanceof  KenanMetaDataService.deleteMetadata_element)
            response.put('response_x', new KenanMetaDataService.deleteMetadataResponse_element());
        else if(request instanceof  KenanMetaDataService.upsertMetadata_element)
            response.put('response_x', new KenanMetaDataService.upsertMetadataResponse_element());
        else if(request instanceof  KenanMetaDataService.createMetadata_element)
            response.put('response_x', new KenanMetaDataService.createMetadataResponse_element());
        else if(request instanceof  KenanMetaDataService.deployRecentValidation_element)
            response.put('response_x', new KenanMetaDataService.deployRecentValidationResponse_element());
        else if(request instanceof KenanMetaDataService.describeValueType_element)
            response.put('response_x', new KenanMetaDataService.describeValueTypeResponse_element());
        else if(request instanceof KenanMetaDataService.checkRetrieveStatus_element)
            response.put('response_x', new KenanMetaDataService.checkRetrieveStatusResponse_element());
		return;
	}
}