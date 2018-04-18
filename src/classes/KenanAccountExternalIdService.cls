/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanAccountExternalIdService for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanAccountExternalIdService implements KenanServiceInterface {
	
	private KenanServiceConnection__c kenanSettings;
	private JSONGenerator jsonGen;
	private KenanAccountExternalIdMapper mapper;

	public KenanAccountExternalIdService() {
		jsonGen = JSON.createGenerator(true);
		kenanSettings = KenanServiceConnection__c.getInstance();	
		mapper = new KenanAccountExternalIdMapper();
	}

	public KenanObject insertRow(KenanObject contextObject,  String method, String action){
		KenanAccountExternalId item = (KenanAccountExternalId) contextObject;
		KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
		String jsonString = JSON.serialize(mapper.getEnumeratedValues(item));
		String endpoint = '/accounts/' + item.salesforceObjectId + '.' + kenanSettings.Default_Account_External_IdType__c + '/Id';
		Integer startRecord = 0;
		Integer blockSize = 10;
		HttpResponse response = helper.sendRequest(jsonString, method, endpoint, startRecord, blockSize);
		KenanAccountExternalId kenanResponse;
		if (String.isEmpty(response.getBody())){
			System.debug('No response received from insertRow!');
		} else {
			Map<String, Object> itemMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			kenanResponse = mapper.getDisplayValues(itemMap);
		}
		return kenanResponse;
	}
	
	public KenanObject updateRow(KenanObject contextObject,  String method, String action){
		KenanAccountExternalId item = (KenanAccountExternalId) contextObject;
		KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
		String jsonString = JSON.serialize(mapper.getEnumeratedValues(item));
		String endpoint = '/accounts/' + item.salesforceObjectId + '.' + kenanSettings.Default_Account_External_IdType__c + '/Id/' + KenanGWTEncodingUtils.urlEncode(item.oldAccountExternalId) + '.' + item.oldAccountExternalIdType;
		Integer startRecord = 0;
		Integer blockSize = 10;
		HttpResponse response = helper.sendRequest(jsonString, method, endpoint, startRecord, blockSize);
		KenanAccountExternalId kenanResponse;
		if (String.isEmpty(response.getBody())){
			System.debug('No response received from updateRow!');
		} else {
			Map<String, Object> itemMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			kenanResponse = mapper.getDisplayValues(itemMap);
		}
		return kenanResponse;
	}

	public Boolean deleteRow(KenanObject contextObject){
 		KenanAccountExternalId item = (KenanAccountExternalId) contextObject;
		KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
		String endpoint = '/accounts/' + item.salesforceObjectId + '.' + kenanSettings.Default_Account_External_IdType__c + '/Id/' + KenanGWTEncodingUtils.urlEncode(item.oldAccountExternalId) + '.' + item.oldAccountExternalIdType;

		if (item.inactiveDate != null) {
			String dateString = item.inactiveDate.format('yyyy-MM-dd\'T \'HH:mm:ss.SSSZ');
			String[] dateArray = dateString.split('T');
			endpoint = endpoint + '?InactiveDate=' + dateArray[0];	
		}
		
		Integer startRecord = 0;
		Integer blockSize = 10;
		HttpResponse response = helper.sendRequest(null, 'DELETE', endpoint, startRecord, blockSize);
		KenanAccountExternalId kenanResponse;
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
    	ke.errorName = 'KenanAccountExternalIdService.query has not been implemented';
    	ke.errorMessage = 'KenanAccountExternalIdService.query has not been implemented';
    	throw ke;
	}

    public DataSource.TableResult search(DataSource.TableSelection context, String searchPhrase){
    	KenanException ke = new KenanException();
    	ke.errorName = 'KenanAccountExternalIdService.search has not been implemented';
    	ke.errorMessage = 'KenanAccountExternalIdService.search has not been implemented';
    	throw ke;
    }

    public List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext context){
    	KenanException ke = new KenanException();
    	ke.errorName = 'KenanAccountExternalIdService.upsertRows has not been implemented';
    	ke.errorMessage = 'KenanAccountExternalIdService.upsertRows has not been implemented';
    	throw ke;
    }
    
	public List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext context){
		KenanException ke = new KenanException();
    	ke.errorName = 'KenanAccountExternalIdService.deleteRows has not been implemented';
    	ke.errorMessage = 'KenanAccountExternalIdService.deleteRows has not been implemented';
    	throw ke;
	}
}