/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanServiceItemService for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanServiceItemService implements KenanServiceInterface {
        
    private KenanServiceConnection__c kenanSettings;
    private JSONGenerator jsonGen;
    private KenanServiceItemMapper serviceItemMapper;
    
    public KenanServiceItemService() {
        kenanSettings = KenanServiceConnection__c.getInstance();
        jsonGen = JSON.createGenerator(true);
        serviceItemMapper = new KenanServiceItemMapper();
    }

    public KenanObject insertRow(KenanObject contextObject, String method, String action) {
        KenanServiceItem item = (KenanServiceItem) contextObject;
        Map<String, Object> itemMap = serviceItemMapper.getEnumeratedValues(item);
        String jsonString = JSON.serialize(itemMap);
        String endpoint = '/services/item/' + item.instanceId + '.' + item.itemType;
        Integer startRecord = 0;
        Integer blockSize = 10;
        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
        HttpResponse response = helper.sendRequest(jsonString, method, endpoint, startRecord, blockSize);
        KenanServiceItem responseItem;
        
        if (String.isEmpty(response.getBody())){
            
        } else {
            Map<String, Object> serviceMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            responseItem = serviceItemMapper.getDisplayValues(serviceMap);
        }
        
        return responseItem;
    }

    public List<KenanObject> insertRowAlternate(KenanObject contextObject,  String method, String action){
        KenanServiceItem item = (KenanServiceItem) contextObject;
		Map<String, Object> itemMap = serviceItemMapper.getEnumeratedValues(item);
		String jsonString = JSON.serialize(itemMap);
		String endpoint = '/services/' + item.serviceExternalId + '.' + item.serviceExternalIdType + '/item';
		Integer startRecord = 0;
		Integer blockSize = 10;
		KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
		
		HttpResponse response = helper.sendRequest(jsonString, method, endpoint, startRecord, blockSize);
        if (response.getStatusCode() != 200){
            KenanException ke = KenanUtils.handleException(response);
            throw ke;
        }
		List<Object> responseMap = (List<Object>) JSON.deserializeUntyped(response.getBody());
		List<KenanServiceItem> resServiceItems = new List<KenanServiceItem>();

		for (Object o : responseMap){
			//Map<String, Object> serviceItemMap = (Map<String, Object>) JSON.deserializeUntyped((String)o);
			resServiceItems.add(serviceItemMapper.getDisplayValues((Map<String, Object>) o));
		}
		
		return resServiceItems;
        /*KenanServiceItem item = (KenanServiceItem) contextObject;
        Map<String, Object> itemMap = serviceItemMapper.getEnumeratedValues(item);
        //String jsonString = JSON.serialize(itemMap);
        String jsonString = generateCreate(item);
        String endpoint = '/services/' + item.serviceExternalId + '.' + item.serviceExternalIdType + '/item';
        Integer startRecord = 0;
        Integer blockSize = 10;
        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
        jsonString = jsonString.replace('\r\n', ' ');
        jsonString = jsonString.replace('\n', ' ');
        jsonString = jsonString.replace('\r', ' ');
        System.debug('SERVICE ITEM CREATE REQ --> ' + jsonString);
        HttpResponse response = helper.sendRequest(jsonString, method, endpoint, startRecord, blockSize);
        
        List<Object> responseMap = (List<Object>) JSON.deserializeUntyped(response.getBody());
        List<KenanServiceItem> resServiceItems = new List<KenanServiceItem>();

        for (Object o : responseMap){
            Map<String, Object> serviceItemMap = (Map<String, Object>) JSON.deserializeUntyped((String)o);
            resServiceItems.add(serviceItemMapper.getDisplayValues(serviceItemMap));
        }
        
        return resServiceItems;*/
        /*KenanServiceItem item = (KenanServiceItem) contextObject;
        //Map<String, Object> itemMap = serviceItemMapper.getEnumeratedValues(item);
        //String jsonString = JSON.serialize(itemMap);
        String jsonString = generateCreate(item);
        String endpoint = '/services/' + item.serviceExternalId + '.' + item.serviceExternalIdType + '/item';
        Integer startRecord = 0;
        Integer blockSize = 10;
        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
        jsonString = jsonString.replace('\r\n', ' ');
        jsonString = jsonString.replace('\n', ' ');
        jsonString = jsonString.replace('\r', ' ');
        System.debug('SERVICE ITEM CREATE REQ --> ' + jsonString);
        HttpResponse response = helper.sendRequest(jsonString, method, endpoint, startRecord, blockSize);
        
        List<Object> responseMap = (List<Object>) JSON.deserializeUntyped(response.getBody());
        List<KenanServiceItem> resServiceItems = new List<KenanServiceItem>();

        for (Object o : responseMap){
            Map<String, Object> serviceItemMap = (Map<String, Object>) JSON.deserializeUntyped((String)o);
            resServiceItems.add(serviceItemMapper.getDisplayValues(serviceItemMap));
        }
        
        return resServiceItems;*/
    }
    
    public KenanObject updateRow(KenanObject contextObject,  String method, String action){
        KenanServiceItem item = (KenanServiceItem) contextObject;
        Map<String, Object> itemMap = serviceItemMapper.getEnumeratedValues(item);
        String jsonString = JSON.serialize(itemMap);
        String endpoint = '/services/' + item.serviceExternalId + '.' + item.serviceExternalIdType + '/item';
        Integer startRecord = 0;
        Integer blockSize = 10;
        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
        HttpResponse response = helper.sendRequest(jsonString, method, endpoint, startRecord, blockSize);
        KenanServiceItem responseItem;
        
        if (String.isEmpty(response.getBody())){
            
        } else {
            Map<String, Object> serviceMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            responseItem = serviceItemMapper.getDisplayValues(serviceMap);
        }
        
        return responseItem;
    }

    public Boolean deleteRow(KenanObject contextObject){
        
        KenanServiceItem item = (KenanServiceItem) contextObject;
        String jsonString = generateCreate(item);
        String endpoint = '/services/item/' + item.instanceId + '.' + item.itemType;
        endpoint = addInactiveDateIfPresent(endpoint, item);
        Integer startRecord = 0;
        Integer blockSize = 10;
        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
        HttpResponse response = helper.sendRequest(jsonString, 'DELETE', endpoint, startRecord, blockSize);
        
        if (response.getStatusCode() == 200){
            return true;
        } 
        else {
            KenanException ke = KenanUtils.handleException(response);
            throw ke;
        }

        return false;
    }   

    public DataSource.TableResult query(DataSource.QueryContext context){
        KenanException ke = new KenanException();
        ke.errorName = 'KenanServiceItemService.query has not been implemented';
        ke.errorMessage = 'KenanServiceItemService.query has not been implemented';
        throw ke;
    }

    public DataSource.TableResult search(DataSource.TableSelection context, String searchPhrase){
        KenanException ke = new KenanException();
        ke.errorName = 'KenanServiceItemService.search has not been implemented';
        ke.errorMessage = 'KenanServiceItemService.search has not been implemented';
        throw ke;

    }

    public List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext context){
        KenanException ke = new KenanException();
        ke.errorName = 'KenanServiceItemService.upsertRows has not been implemented';
        ke.errorMessage = 'KenanServiceItemService.upsertRows has not been implemented';
        throw ke;
    }
    
    public List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext context){
        KenanException ke = new KenanException();
        ke.errorName = 'KenanServiceItemService.deleteRows has not been implemented';
        ke.errorMessage = 'KenanServiceItemService.deleteRows has not been implemented';
        throw ke;
    }   
    
    private String generateCreate(KenanServiceItem item){
        return JSON.serialize(item, true);
    }

    private String addInactiveDateIfPresent(String endpoint, KenanServiceItem kenanServiceItem) {
        if (kenanServiceItem.inactiveDate != null) {
            endpoint = endpoint + '?inactiveDate=' + KenanUtils.getGMTFormattedDateString(kenanServiceItem.inactiveDate);
        }

        return endpoint;
    }
}