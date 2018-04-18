/**
* @author Copyright(c) Amdocs Development Limited 2017. All rights reserved.
* @date 2017
* @description KenanAccountItemService for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanAccountItemService implements KenanServiceInterface {
		
	private KenanServiceConnection__c kenanSettings;
	private JSONGenerator jsonGen;
	private KenanAccountItemMapper accountItemMapper;

	public KenanAccountItemService() {
		kenanSettings = KenanServiceConnection__c.getInstance();
		accountItemMapper = new KenanAccountItemMapper();	
	}

	public List<KenanObject> insertRowAlternate(KenanObject contextObject,  String method, String action){
		KenanAccountItem item = (KenanAccountItem) contextObject;
		Map<String, Object> itemMap = accountItemMapper.getEnumeratedValues(item);
		String jsonString = JSON.serialize(itemMap);
		String endpoint = '/accounts/' + item.serviceExternalId + '.' + item.serviceExternalIdType + '/item';
		Integer startRecord = 0;
		Integer blockSize = 10;

        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
        HttpResponse response = helper.sendRequest(jsonString, method, endpoint, startRecord, blockSize);
        
        // OMB-2633 START
        if (response.getStatusCode() != 200){
                   KenanException ke = KenanUtils.handleException(response);
                   throw ke;
        }
        // OMB-2633 END
        
        List<Object> responseMap = (List<Object>) JSON.deserializeUntyped(response.getBody());
        List<KenanAccountItem> resAccountItems = new List<KenanAccountItem>();

		for (Object o : responseMap){
			//Map<String, Object> accountItemMap = (Map<String, Object>) JSON.deserializeUntyped((String)o);
			resAccountItems.add(accountItemMapper.getDisplayValues((Map<String, Object>) o));
		}
		
		return resAccountItems;
	}

	public Boolean deleteRow(KenanObject contextObject){
		KenanAccountItem item = (KenanAccountItem) contextObject;
		String endpoint = '/accounts/item/' + item.instanceId + '.' + item.itemType;
		endpoint = addInactiveDateIfPresent(endpoint, item);
		Integer startRecord = 0;
		Integer blockSize = 10;
		
		KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
		HttpResponse response = helper.sendRequest(null, 'DELETE', endpoint, startRecord, blockSize);
		
		if (response.getStatusCode() == 200){
			return true;
		} 
		else {
			KenanException ke = KenanUtils.handleException(response);
			throw ke;
		}

		return false;
    }	

    public KenanObject insertRow(KenanObject contextObject,  String method, String action){
		return null;
	}

    public KenanObject updateRow(KenanObject contextObject,  String method, String action){
		return null;
	}

    public DataSource.TableResult query(DataSource.QueryContext context){
		KenanException ke = new KenanException();
    	ke.errorName = 'KenanAccountItemService.query has not been implemented';
    	ke.errorMessage = 'KenanAccountItemService.query has not been implemented';
    	throw ke;
	}

    public DataSource.TableResult search(DataSource.TableSelection context, String searchPhrase){
    	KenanException ke = new KenanException();
    	ke.errorName = 'KenanAccountItemService.search has not been implemented';
    	ke.errorMessage = 'KenanAccountItemService.search has not been implemented';
    	throw ke;

    }

    public List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext context){
    	KenanException ke = new KenanException();
    	ke.errorName = 'KenanAccountItemService.upsertRows has not been implemented';
    	ke.errorMessage = 'KenanAccountItemService.upsertRows has not been implemented';
    	throw ke;
    }
    
	public List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext context){
		KenanException ke = new KenanException();
    	ke.errorName = 'KenanAccountItemService.deleteRows has not been implemented';
    	ke.errorMessage = 'KenanAccountItemService.deleteRows has not been implemented';
    	throw ke;
	}	
    
    private String generateCreate(KenanAccountItem item){
    	return JSON.serialize(item, true);
    }

	private String addInactiveDateIfPresent(String endpoint, KenanAccountItem kenanAccountItem) {
    	if (kenanAccountItem.inactiveDate != null) {
    		endpoint = endpoint + '?inactiveDate=' + KenanUtils.getGMTFormattedDateString(kenanAccountItem.inactiveDate);
    	}

    	return endpoint;
    }
}