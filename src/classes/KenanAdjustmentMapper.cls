/**
* TODO: ApexDoc.
*/
public with sharing class KenanAdjustmentMapper implements KenanObjectMapper{

    private KenanServiceConnection__c kenanSettings;

	public KenanAdjustmentMapper() {
		kenanSettings = KenanServiceConnection__c.getInstance();
	}

    // for use with Internal SFDC API
	public Map<String,Object> getEnumeratedValues(KenanObject kObject){
        KenanAdjustment ka = (KenanAdjustment) kObject;
        Map<String,Object> objectMap = new Map<String,Object>();

        if (ka.accountExternalId != null) objectMap.put('accountExternalId', ka.accountExternalId);
        if (ka.accountExternalIdType != null) objectMap.put('accountExternalIdType', ka.accountExternalIdType);
        if (ka.accountInternalId != null) objectMap.put('accountInternalId', ka.accountInternalId);
        if (ka.adjReasonCode != null) objectMap.put('adjReasonCode', ka.adjReasonCode);
        if (ka.billRefNo != null) objectMap.put('billRefNo', ka.billRefNo);
        if (ka.billRefResets != null) objectMap.put('billRefResets', ka.billRefResets);
        if (ka.currencyCode != null) objectMap.put('currencyCode', ka.currencyCode);
        if (ka.effectiveDate != null) objectMap.put('effectiveDate', ka.effectiveDate);
        if (ka.fraudIndicator != null) objectMap.put('fraudIndicator', ka.fraudIndicator);
        if (ka.invoiceItem != null) objectMap.put('invoiceItem', ka.invoiceItem);
        if (ka.origType != null) objectMap.put('origType', ka.origType);
        if (ka.openItemId != null) objectMap.put('openItemId', ka.openItemId);
        if (ka.primaryUnits != null) objectMap.put('primaryUnits', ka.primaryUnits);
        if (ka.primaryUnitsType != null) objectMap.put('primaryUnitsType', ka.primaryUnitsType);
        if (ka.requestStatus != null) objectMap.put('requestStatus', ka.requestStatus);
        if (ka.revRcvCostCtr != null) objectMap.put('revRcvCostCtr', ka.revRcvCostCtr);
        if (ka.totalAmt != null) {
            ka.totalAmt.setScale(2);
            objectMap.put('totalAmt', ka.totalAmt);
        }
        if (ka.trackingId != null) objectMap.put('trackingId', ka.trackingId);
        if (ka.trackingIdServ != null) objectMap.put('trackingIdServ', ka.trackingIdServ);


        mapEnumeratedValues(objectMap);

        return objectMap;
    }

    // for use with Internal SFDC API
    public KenanObject getDisplayValues(Map<String, Object> objectMap){
        KenanAdjustment ka = new KenanAdjustment();
        mapDisplayValues(objectMap);

        if (objectMap.get('accountExternalId') != null) ka.accountExternalId = String.valueOf(objectMap.get('accountExternalId'));
        if (objectMap.get('accountExternalIdType') != null) ka.accountExternalIdType = Integer.valueOf(objectMap.get('accountExternalIdType'));
        if (objectMap.get('accountInternalId') != null) ka.accountInternalId = Integer.valueOf(objectMap.get('accountInternalId'));
        if (objectMap.get('adjReasonCode') != null) ka.adjReasonCode = String.valueOf(objectMap.get('adjReasonCode'));
        if (objectMap.get('billRefNo') != null) ka.billRefNo = Integer.valueOf(objectMap.get('billRefNo'));
        if (objectMap.get('billRefResets') != null) ka.billRefResets = Integer.valueOf(objectMap.get('billRefResets'));
        if (objectMap.get('currencyCode') != null) ka.currencyCode = String.valueOf(objectMap.get('currencyCode'));
        if (objectMap.get('effectiveDate') != null ) ka.effectiveDate = KenanUtils.fixDateTime(objectMap.get('effectiveDate')).date();
        if (objectMap.get('fraudIndicator') != null) ka.fraudIndicator = String.valueOf(objectMap.get('fraudIndicator'));
        if (objectMap.get('invoiceItem') != null) ka.invoiceItem = String.valueOf(objectMap.get('invoiceItem'));
        if (objectMap.get('origType') != null) ka.origType = String.valueOf(objectMap.get('origType'));
        if (objectMap.get('openItemId') != null) ka.openItemId = String.valueOf(objectMap.get('openItemId'));
        if (objectMap.get('primaryUnits') != null) ka.primaryUnits = String.valueOf(objectMap.get('primaryUnits'));
        if (objectMap.get('primaryUnitsType') != null) ka.primaryUnitsType = String.valueOf(objectMap.get('primaryUnitsType'));
        if (objectMap.get('requestStatus') != null) ka.requestStatus = String.valueOf(objectMap.get('requestStatus'));
        if (objectMap.get('revRcvCostCtr') != null) ka.revRcvCostCtr = String.valueOf(objectMap.get('revRcvCostCtr'));
        if (objectMap.get('totalAmt') != null) ka.totalAmt = (Decimal) objectMap.get('totalAmt');
        if (objectMap.get('trackingId') != null) ka.trackingId = String.valueOf(objectMap.get('trackingId'));
        if (objectMap.get('trackingIdServ') != null) ka.trackingIdServ = String.valueOf(objectMap.get('trackingIdServ'));

        return ka;
    }

    // for use with Salesforce Connect External Objects
    public void getEnumeratedValues(List<Map<String, Object>> objectMap){
        for (Map<String, Object> row : objectMap) {
            mapEnumeratedValues(row);
        }
    }

    // for use with Salesforce Connect External Objects
    public void getDisplayValues(List<Map<String, Object>> objectMap){
        for (Map<String, Object> row : objectMap) {
            mapDisplayValues(row);
        }
    }

    public void mapEnumeratedValues(Map<String, Object> record){
        if (record.get('adjReasonCode') != null) record.put('adjReasonCode', KenanEnumerationHelper.getEnumKeyValue('AdjustmentReasonBean__mdt', 'AdjReasonCode__c', record.get('adjReasonCode'), kenanSettings.Stored_Language_Code__c, 'DisplayValue__c'));
        if (record.get('origType') != null) record.put('origType', KenanEnumerationHelper.getEnumKeyValue('AdjustmentOrigType__mdt', 'OrigType__c', record.get('origType'), kenanSettings.Stored_Language_Code__c, 'MasterLabel'));
        if (record.get('openItemId') != null) record.put('openItemId', KenanEnumerationHelper.getEnumKeyValue('OpenItemBean__mdt', 'OpenItemId__c', record.get('openItemId'), kenanSettings.Stored_Language_Code__c, 'DisplayValue__c'));
        if (record.get('requestStatus') != null) record.put('requestStatus', KenanEnumerationHelper.getEnumKeyValue('AdjustmentStatus__mdt', 'requestStatus__c', record.get('requestStatus'), kenanSettings.Stored_Language_Code__c, 'MasterLabel'));
        if (record.get('currencyCode') != null) record.put('currencyCode', KenanEnumerationHelper.getEnumKeyValue('RateCurrencyBean__mdt', 'CurrencyCode__c', record.get('currencyCode'), kenanSettings.Stored_Language_Code__c, 'ShortDisplay__c'));
        if (record.get('currencyCode') != null && record.get('totalAmt') != null) record.put('totalAmt', KenanEnumerationHelper.getAPICurrencyValue(record.get('totalAmt'), record.get('currencyCode'), kenanSettings.Stored_Language_Code__c));
   }

    private void mapDisplayValues(Map<String, Object> record){
        if (record.get('currencyCode') != null && record.get('totalAmt') != null) record.put('totalAmt', KenanEnumerationHelper.getDisplayCurrencyValue(Decimal.valueOf(String.valueOf(record.get('totalAmt'))), String.valueOf(record.get('currencyCode')), kenanSettings.Stored_Language_Code__c));
        if (record.get('adjReasonCode') != null) record.put('adjReasonCode', KenanEnumerationHelper.getEnumDisplayValue('AdjustmentReasonBean__mdt', 'AdjReasonCode__c', record.get('adjReasonCode'), kenanSettings.Stored_Language_Code__c, 'DisplayValue__c'));
        if (record.get('origType') != null) record.put('origType', KenanEnumerationHelper.getEnumDisplayValue('AdjustmentOrigType__mdt', 'OrigType__c', record.get('origType'), kenanSettings.Stored_Language_Code__c, 'MasterLabel'));
        if (record.get('openItemId') != null) record.put('openItemId', KenanEnumerationHelper.getEnumDisplayValue('OpenItemBean__mdt', 'OpenItemId__c', record.get('openItemId'), kenanSettings.Stored_Language_Code__c, 'DisplayValue__c'));
        if (record.get('requestStatus') != null) record.put('requestStatus', KenanEnumerationHelper.getEnumDisplayValue('AdjustmentStatus__mdt', 'requestStatus__c', record.get('requestStatus'), kenanSettings.Stored_Language_Code__c, 'MasterLabel'));
        if (record.get('currencyCode') != null) record.put('currencyCode', KenanEnumerationHelper.getEnumDisplayValue('RateCurrencyBean__mdt', 'CurrencyCode__c', record.get('currencyCode'), kenanSettings.Stored_Language_Code__c, 'ShortDisplay__c'));
        
    }

}