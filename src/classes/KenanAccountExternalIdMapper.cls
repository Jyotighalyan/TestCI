/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanAccountExternalIdMapper for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanAccountExternalIdMapper implements KenanObjectMapper {
	public KenanAccountExternalIdMapper() {
		
	}

	public Map<String,Object> getEnumeratedValues(KenanObject kObject){
        Map<String,Object> objectMap = new Map<String,Object>();
        KenanAccountExternalId item = (KenanAccountExternalId) kobject;
        
		if (item.activeDate != null) objectMap.put('activeDate', item.activeDate);
		if (item.inactiveDate != null) objectMap.put('inactiveDate', item.inactiveDate);
	  	if (item.isCurrent != null) objectMap.put('isCurrent', item.isCurrent);
	  	if (item.accountExternalId != null) objectMap.put('accountExternalId', item.accountExternalId);
	  	if (item.accountExternalIdType != null) objectMap.put('accountExternalIdType', item.accountExternalIdType);
	  	if (item.accountInternalId != null) objectMap.put('accountInternalId', item.accountInternalId);
		
        return objectMap;
    }

    public KenanAccountExternalId getDisplayValues(Map<String, Object> objectMap){
    	KenanAccountExternalId item = new KenanAccountExternalId();
        
		if (objectMap.get('activeDate') != null) item.activeDate = KenanUtils.fixDateTime(objectMap.get('activeDate'));
		if (objectMap.get('inactiveDate') != null) item.inactiveDate = KenanUtils.fixDateTime(objectMap.get('inactiveDate'));
	  	if (objectMap.get('isCurrent') != null) item.isCurrent = Boolean.valueOf(objectMap.get('isCurrent'));
	  	if (objectMap.get('accountExternalId') != null) item.accountExternalId = String.valueOf(objectMap.get('accountExternalId'));
	  	if (objectMap.get('accountExternalIdType') != null) item.accountExternalIdType = Integer.valueOf(objectMap.get('accountExternalIdType'));
	  	if (objectMap.get('accountInternalId') != null) item.accountInternalId = Integer.valueOf(objectMap.get('accountInternalId'));
		
        return item;
    }
}