/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanAddressService for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanAddressService implements KenanServiceInterface {
	
	private JSONGenerator jsonGen;
	private KenanAddressMapper addressMapper;
	private KenanServiceConnection__c kenanSettings;

	public KenanAddressService() {
		jsonGen = JSON.createGenerator(true);
		addressMapper = new KenanAddressMapper();
		kenanSettings = KenanServiceConnection__c.getInstance();
	}

	public KenanObject insertRow(KenanObject contextObject,  String method, String action){
		KenanAddress address = (KenanAddress) contextObject;
		Map<String, Object> itemMap = addressMapper.getEnumeratedValues(address);
		String jsonString = JSON.serialize(itemMap);	
		KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
		String endpoint = '/services/' + address.serviceExternalId + '.' + address.serviceExternalIdType + '/address';
		Integer startRecord = 0;
		Integer blockSize = 10;
		HttpResponse response = helper.sendRequest(jsonString, method, endpoint, startRecord, blockSize);
		if (response.getStatusCode() == 200){
			KenanAddress responseAddress;
			if (String.isEmpty(response.getBody())){
				
			} else {
				Map<String, Object> serviceMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
				responseAddress = addressMapper.getDisplayValues(serviceMap);
			}
			return responseAddress;	
		} else {
			KenanException ke = new KenanException(response);
			throw ke;
		}
	}

	public KenanObject updateRow(KenanObject contextObject,  String method, String action){
		KenanException ke = new KenanException();
    	ke.errorName = 'KenanAddressService.updateRow has not been implemented';
    	ke.errorMessage = 'KenanAddressService.updateRow has not been implemented';
    	throw ke;
	}

	public Boolean deleteRow(KenanObject contextObject){
 		KenanException ke = new KenanException();
    	ke.errorName = 'KenanAddressService.deleteRow has not been implemented';
    	ke.errorMessage = 'KenanAddressService.deleteRow has not been implemented';
    	throw ke;
    }

    public DataSource.TableResult query(DataSource.QueryContext context){
		KenanException ke = new KenanException();
    	ke.errorName = 'KenanAddressService.query has not been implemented';
    	ke.errorMessage = 'KenanAddressService.query has not been implemented';
    	throw ke;
	}

    public DataSource.TableResult search(DataSource.TableSelection context, String searchPhrase){
    	KenanException ke = new KenanException();
    	ke.errorName = 'KenanAddressService.search has not been implemented';
    	ke.errorMessage = 'KenanAddressService.search has not been implemented';
    	throw ke;

    }

    public List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext context){
    	KenanException ke = new KenanException();
    	ke.errorName = 'KenanAddressService.upsertRows has not been implemented';
    	ke.errorMessage = 'KenanAddressService.upsertRows has not been implemented';
    	throw ke;
    }
    
	public List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext context){
		KenanException ke = new KenanException();
    	ke.errorName = 'KenanAddressService.deleteRows has not been implemented';
    	ke.errorMessage = 'KenanAddressService.deleteRows has not been implemented';
    	throw ke;
	}

}