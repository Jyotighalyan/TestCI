/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanServiceExternalIdMapper for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanServiceExternalIdMapper implements KenanObjectMapper{
	public KenanServiceExternalIdMapper() {
		
	}

	public Map<String,Object> getEnumeratedValues(KenanObject kObject){
        Map<String,Object> objectMap = new Map<String,Object>();
        KenanServiceExternalId item = (KenanServiceExternalId) kobject;
        
		if (item.activeDate != null) objectMap.put('activeDate', item.activeDate);
		if (item.createDt != null) objectMap.put('createDt', item.createDt);
		if (item.inactiveDate != null) objectMap.put('inactiveDate', item.inactiveDate);
	  	if (item.intendedViewEffectiveDt != null) objectMap.put('intendedViewEffectiveDt', item.intendedViewEffectiveDt);
	  	if (item.isCurrent != null) objectMap.put('isCurrent', item.isCurrent);
	  	if (item.isFromInventory != null) objectMap.put('isFromInventory', item.isFromInventory);
	  	if (item.prevViewId != null) objectMap.put('prevViewId', item.prevViewId);
	  	if (item.serviceExternalId != null) objectMap.put('serviceExternalId', item.serviceExternalId);
	  	if (item.serviceExternalIdType != null) objectMap.put('serviceExternalIdType', item.serviceExternalIdType);
	  	if (item.serviceInternalId != null) objectMap.put('serviceInternalId', item.serviceInternalId);
	  	if (item.serviceInternalIdResets != null) objectMap.put('serviceInternalIdResets', item.serviceInternalIdResets);
	  	//if (item.viewCreatedDt != null) objectMap.put('viewCreatedDt', item.viewCreatedDt);
	  	//if (item.viewEffectiveDt != null) objectMap.put('viewEffectiveDt', item.viewEffectiveDt);
	  	if (item.viewId != null) objectMap.put('viewId', item.viewId);
	  	if (item.viewStatus != null) objectMap.put('viewStatus', item.viewStatus);
		
        return objectMap;
    }

    public KenanServiceExternalId getDisplayValues(Map<String, Object> objectMap){
    	KenanServiceExternalId item = new KenanServiceExternalId();
        
		if (objectMap.get('activeDate') != null) item.activeDate = KenanUtils.fixDateTime(objectMap.get('activeDate'));
		if (objectMap.get('createDt') != null) item.createDt = KenanUtils.fixDateTime(objectMap.get('createDt'));
		if (objectMap.get('inactiveDate') != null) item.inactiveDate = KenanUtils.fixDateTime(objectMap.get('inactiveDate'));
	  	if (objectMap.get('intendedViewEffectiveDt') != null) item.intendedViewEffectiveDt = KenanUtils.fixDateTime(objectMap.get('intendedViewEffectiveDt'));
	  	if (objectMap.get('isCurrent') != null) item.isCurrent = Boolean.valueOf(objectMap.get('isCurrent'));
	  	if (objectMap.get('isFromInventory') != null) item.isFromInventory = Boolean.valueOf(objectMap.get('isFromInventory'));
	  	if (objectMap.get('prevViewId') != null) item.prevViewId = Integer.valueOf(objectMap.get('prevViewId'));
	  	if (objectMap.get('serviceExternalId') != null) item.serviceExternalId = String.valueOf(objectMap.get('serviceExternalId'));
	  	if (objectMap.get('serviceExternalIdType') != null) item.serviceExternalIdType = Integer.valueOf(objectMap.get('serviceExternalIdType'));
	  	if (objectMap.get('serviceInternalId') != null) item.serviceInternalId = Integer.valueOf(objectMap.get('serviceInternalId'));
	  	if (objectMap.get('serviceInternalIdResets') != null) item.serviceInternalIdResets = Integer.valueOf(objectMap.get('serviceInternalIdResets'));
	  	//if (objectMap.get('viewCreatedDt') != null) item.viewCreatedDt = KenanUtils.fixDateTime(objectMap.get('viewCreatedDt'));
	  	//if (objectMap.get('viewEffectiveDt') != null) item.viewEffectiveDt = KenanUtils.fixDateTime(objectMap.get('viewEffectiveDt'));
	  	if (objectMap.get('viewId') != null) item.viewId = Integer.valueOf(objectMap.get('viewId'));
	  	if (objectMap.get('viewStatus') != null) item.viewStatus = Integer.valueOf(objectMap.get('viewStatus'));
		
        return item;
    }
}