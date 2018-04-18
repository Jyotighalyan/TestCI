/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanServiceExternalIdService for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanServiceExternalIdService implements KenanServiceInterface {
		
	private KenanServiceConnection__c kenanSettings;
	private JSONGenerator jsonGen;
	private KenanServiceExternalIdMapper mapper;
	
	public KenanServiceExternalIdService() {
		jsonGen = JSON.createGenerator(true);
		kenanSettings = KenanServiceConnection__c.getInstance();	
		mapper = new KenanServiceExternalIdMapper();
	}

	public KenanObject insertRow(KenanObject contextObject,  String method, String action){
		KenanServiceExternalId item = (KenanServiceExternalId) contextObject;
		KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
		String jsonString = JSON.serialize(mapper.getEnumeratedValues(item));
		String endpoint = '/services/' + item.salesforceObjectId + '.' + kenanSettings.Default_Service_External_IdType__c + '/Id';
		Integer startRecord = 0;
		Integer blockSize = 10;
		HttpResponse response = helper.sendRequest(jsonString, method, endpoint, startRecord, blockSize);
		KenanServiceExternalId kenanResponse;
		if (String.isEmpty(response.getBody())){
				
		} else {
			Map<String, Object> itemMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			kenanResponse = mapper.getDisplayValues(itemMap);
		}
		return kenanResponse;
	}
	
	public KenanObject updateRow(KenanObject contextObject,  String method, String action){
		KenanServiceExternalId item = (KenanServiceExternalId) contextObject;
		KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
		String jsonString = JSON.serialize(mapper.getEnumeratedValues(item));
		String endpoint = '/services/' + item.salesforceObjectId + '.' + kenanSettings.Default_Service_External_IdType__c + '/Id/' + KenanGWTEncodingUtils.urlEncode(item.oldServiceExternalId) + '.' + item.oldServiceExternalIdType;
		Integer startRecord = 0;
		Integer blockSize = 10;
		HttpResponse response = helper.sendRequest(jsonString, method, endpoint, startRecord, blockSize);
		KenanServiceExternalId kenanResponse;
		if (String.isEmpty(response.getBody())){
				
		} else {
			Map<String, Object> itemMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			kenanResponse = mapper.getDisplayValues(itemMap);
		}
		return kenanResponse;
	}

	public Boolean deleteRow(KenanObject contextObject){
 		KenanServiceExternalId item = (KenanServiceExternalId) contextObject;
		KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
		String endpoint = '/services/' + item.salesforceObjectId + '.' + kenanSettings.Default_Service_External_IdType__c + '/Id/' + KenanGWTEncodingUtils.urlEncode(item.serviceExternalId) + '.' + item.serviceExternalIdType;

		if (item.inactiveDate != null) {
			String dateString = item.inactiveDate.format('yyyy-MM-dd\'T \'HH:mm:ss.SSSZ');
			String[] dateArray = dateString.split('T');
			endpoint = endpoint + '?InactiveDate=' + dateArray[0];	
		}
		
		Integer startRecord = 0;
		Integer blockSize = 10;
		HttpResponse response = helper.sendRequest(null, 'DELETE', endpoint, startRecord, blockSize);
		KenanServiceExternalId kenanResponse;
		if (response.getStatusCode() == 200){
			return true;
		} else {
			KenanException ke = KenanUtils.handleException(response);
			throw ke;
		}
				
		return false;
    }	

    public DataSource.TableResult query(DataSource.QueryContext context){
		KenanException ke = new KenanException();
    	ke.errorName = 'KenanServiceExternalIdService.query has not been implemented';
    	ke.errorMessage = 'KenanServiceExternalIdService.query has not been implemented';
    	throw ke;
	}

    public DataSource.TableResult search(DataSource.TableSelection context, String searchPhrase){
    	KenanException ke = new KenanException();
    	ke.errorName = 'KenanServiceExternalIdService.search has not been implemented';
    	ke.errorMessage = 'KenanServiceExternalIdService.search has not been implemented';
    	throw ke;

    }

    public List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext context){
    	KenanException ke = new KenanException();
    	ke.errorName = 'KenanServiceExternalIdService.upsertRows has not been implemented';
    	ke.errorMessage = 'KenanServiceExternalIdService.upsertRows has not been implemented';
    	throw ke;
    }
    
	public List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext context){
		KenanException ke = new KenanException();
    	ke.errorName = 'KenanServiceExternalIdService.deleteRows has not been implemented';
    	ke.errorMessage = 'KenanServiceExternalIdService.deleteRows has not been implemented';
    	throw ke;
	}	
}