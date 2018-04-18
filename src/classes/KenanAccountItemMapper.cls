/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanAccountItemMapper for use in Salesforce Kenan Connection Service
*/
public class KenanAccountItemMapper {
	private KenanServiceConnection__c kenanSettings;

	public KenanAccountItemMapper() {
		kenanSettings = KenanServiceConnection__c.getInstance();
	}
	
	public Map<String,Object> getEnumeratedValues(KenanObject kObject){
		KenanAccountItem item = (KenanAccountItem) kObject;
		Map<String, Object> itemMap = new Map<String, Object>();
		if (item.activeDate != null) itemMap.put('activeDate', item.activeDate);
  		if (item.annotation != null) itemMap.put('annotation', item.annotation);
		if (item.annotation2 != null) itemMap.put('annotation2', item.annotation2);
		if (item.currencyCode != null) itemMap.put('currencyCode', KenanEnumerationHelper.getEnumKeyValue('RateCurrencyBean__mdt', 'CurrencyCode__c', item.currencyCode, kenanSettings.Stored_Language_Code__c, 'ShortDisplay__c'));
		if (item.inactiveDate != null) itemMap.put('inactiveDate', item.inactiveDate);
		if (item.instanceId != null) itemMap.put('instanceId', item.instanceId);
		if (item.itemId != null) itemMap.put('itemId', item.itemId);
		if (item.itemType != null) itemMap.put('itemType', item.itemType);
		if (item.rate != null) itemMap.put('rate', item.rate);
		if (item.salesforceId != null) itemMap.put('salesforceId', item.salesforceId);
		if (item.units != null) itemMap.put('units', item.units);
		if (item.unitsType != null) itemMap.put('unitsType', KenanEnumerationHelper.getEnumKeyValue('UnitsTypeBean__mdt', 'UnitsType__c', item.unitsType, kenanSettings.Stored_Language_Code__c, 'DisplayValue__c'));
		if (item.rcAssociatedNrc != null) itemMap.put('rcAssociatedNrc', getEnumeratedValues(item.rcAssociatedNrc));
		if (item.discountAmount != null) itemMap.put('discountAmount', item.discountAmount);
  		if (item.discountPercent != null) itemMap.put('discountPercent', KenanEnumerationHelper.getAPICurrencyValue(item.discountPercent, itemMap.get('currencyCode'), kenanSettings.Stored_Language_Code__c));
  		if (item.unitCreditUnitsFree != null) itemMap.put('unitCreditUnitsFree', item.unitCreditUnitsFree);
  		if (item.unitCreditAmountFree != null) itemMap.put('unitCreditAmountFree', item.unitCreditAmountFree);
  		if (item.contractLevel != null) itemMap.put('contractLevel', item.contractLevel);
  		if (item.nrcParentRcInstanceId != null) itemMap.put('nrcParentRcInstanceId', item.nrcParentRcInstanceId);
  		if (item.extData != null) itemMap.put('extData', item.extData);		
		return itemMap;
	}
	
	public KenanAccountItem getDisplayValues(Map<String, Object> objectMap){
		KenanAccountItem item = new KenanAccountItem();

		if (objectMap.get('activeDate') != null) item.activeDate = KenanUtils.fixDateTime(objectMap.get('activeDate'));
  		if (objectMap.get('annotation') != null) item.annotation = String.valueOf(objectMap.get('annotation'));
		if (objectMap.get('annotation2') != null) item.annotation2 = String.valueOf(objectMap.get('annotation2'));
		if (objectMap.get('currencyCode') != null) item.currencyCode = KenanEnumerationHelper.getEnumDisplayValue('RateCurrencyBean__mdt', 'CurrencyCode__c', objectMap.get('currencyCode'), kenanSettings.Stored_Language_Code__c, 'ShortDisplay__c');
		if (objectMap.get('inactiveDate') != null) item.inactiveDate = KenanUtils.fixDateTime(objectMap.get('inactiveDate'));
		if (objectMap.get('instanceId') != null) item.instanceId = String.valueOf(objectMap.get('instanceId'));
		if (objectMap.get('itemId') != null) item.itemId = Integer.valueOf(objectMap.get('itemId'));
		if (objectMap.get('itemType') != null) item.itemType = Integer.valueOf(objectMap.get('itemType'));
		if (objectMap.get('rate') != null) item.rate = KenanEnumerationHelper.getAPICurrencyValue(objectMap.get('rate'), objectMap.get('currencyCode'), kenanSettings.Stored_Language_Code__c);
		if (objectMap.get('salesforceId') != null) item.salesforceId = String.valueOf(objectMap.get('salesforceId'));
		if (objectMap.get('units') != null) item.units = Integer.valueOf(objectMap.get('units'));
		if (objectMap.get('unitsType') != null) item.unitsType = KenanEnumerationHelper.getEnumDisplayValue('UnitsTypeBean__mdt', 'UnitsType__c', objectMap.get('unitsType'), kenanSettings.Stored_Language_Code__c, 'DisplayValue__c');

		KenanServiceItemMapper serviceItemMapper = new KenanServiceItemMapper();

		if (objectMap.get('rcAssociatedNrc') != null) item.rcAssociatedNrc = serviceItemMapper.getDisplayValues((Map<String, Object>) objectMap.get('rcAssociatedNrc'));		
		if (objectMap.get('discountAmount') != null) item.discountAmount = KenanEnumerationHelper.getAPICurrencyValue(objectMap.get('discountAmount'), objectMap.get('currencyCode'), kenanSettings.Stored_Language_Code__c);
		if (objectMap.get('discountPercent') != null) item.discountPercent = KenanEnumerationHelper.getAPICurrencyValue(objectMap.get('discountPercent'), objectMap.get('currencyCode'), kenanSettings.Stored_Language_Code__c);
		if (objectMap.get('unitCreditUnitsFree') != null) item.unitCreditUnitsFree = Decimal.valueOf(String.valueOf(objectMap.get('unitCreditUnitsFree')));
		if (objectMap.get('unitCreditAmountFree') != null) item.unitCreditAmountFree = KenanEnumerationHelper.getAPICurrencyValue(objectMap.get('unitCreditAmountFree'), objectMap.get('currencyCode'), kenanSettings.Stored_Language_Code__c);

		return item;
	}

	public void getDisplayValues(KenanAccountItem accountItem){
		
		String currencyCode = accountItem.currencyCode;

		if (accountItem.activeDate != null) accountItem.activeDate = KenanUtils.fixDateTime(accountItem.activeDate);
  		if (accountItem.annotation != null) accountItem.annotation = String.valueOf(accountItem.annotation);
		if (accountItem.annotation2 != null) accountItem.annotation2 = String.valueOf(accountItem.annotation2);
		if (accountItem.currencyCode != null) accountItem.currencyCode = KenanEnumerationHelper.getEnumDisplayValue('RateCurrencyBean__mdt', 'CurrencyCode__c', accountItem.currencyCode, kenanSettings.Stored_Language_Code__c, 'ShortDisplay__c');
		if (accountItem.inactiveDate != null) accountItem.inactiveDate = KenanUtils.fixDateTime(accountItem.inactiveDate);
		if (accountItem.instanceId != null) accountItem.instanceId = String.valueOf(accountItem.instanceId);
		if (accountItem.itemId != null) accountItem.itemId = Integer.valueOf(accountItem.itemId);
		if (accountItem.itemType != null) accountItem.itemType = Integer.valueOf(accountItem.itemType);
		if (accountItem.rate != null) accountItem.rate = KenanEnumerationHelper.getDisplayCurrencyValue(accountItem.rate, currencyCode, kenanSettings.Stored_Language_Code__c);
		if (accountItem.salesforceId != null) accountItem.salesforceId = String.valueOf(accountItem.salesforceId);
		if (accountItem.units != null) accountItem.units = Integer.valueOf(accountItem.units);
		if (accountItem.unitsType != null) accountItem.unitsType = KenanEnumerationHelper.getEnumDisplayValue('UnitsTypeBean__mdt', 'UnitsType__c', accountItem.unitsType, kenanSettings.Stored_Language_Code__c, 'DisplayValue__c');		
		if (accountItem.discountAmount != null) accountItem.discountAmount = KenanEnumerationHelper.getDisplayCurrencyValue(accountItem.discountAmount, currencyCode, kenanSettings.Stored_Language_Code__c);
		if (accountItem.discountPercent != null) accountItem.discountPercent = KenanEnumerationHelper.getDisplayCurrencyValue(accountItem.discountPercent, currencyCode, kenanSettings.Stored_Language_Code__c);
		//if (accountItem.unitCreditUnitsFree != null) accountItem.unitCreditUnitsFree = Decimal.valueOf(String.valueOf(objectMap.get('unitCreditUnitsFree')));
		if (accountItem.unitCreditAmountFree != null) accountItem.unitCreditAmountFree = KenanEnumerationHelper.getDisplayCurrencyValue(accountItem.unitCreditAmountFree, currencyCode, kenanSettings.Stored_Language_Code__c);

	}

}