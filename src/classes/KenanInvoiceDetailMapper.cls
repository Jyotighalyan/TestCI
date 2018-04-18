/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanInvoiceDetailMapper used to transpose Invoice Detail Enumeration values
*/

public with sharing class KenanInvoiceDetailMapper implements KenanObjectMapper{
    Map<String, UM_InvoiceHeader__c> invoiceHeaders;
    private KenanServiceConnection__c kenanSettings;

    public KenanInvoiceDetailMapper() {
        kenanSettings = KenanServiceConnection__c.getInstance();
        invoiceHeaders = new Map<String, UM_InvoiceHeader__c>();
    }


    public Map<String,Object> getEnumeratedValues(KenanObject kObject){
        KenanException ke = new KenanException();
        ke.errorName = 'getEnumeratedValues Method has not been implemented';
        ke.errorMessage = 'getEnumeratedValues Method has not been implemented';
        throw ke;
        return null;
    }

    public KenanObject getDisplayValues(Map<String, Object> objectMap){
        KenanException ke = new KenanException();
        ke.errorName = 'getDisplayValues Method has not been implemented';
        ke.errorMessage = 'getDisplayValues Method has not been implemented';
        throw ke;
        return null;
    }


    public void getEnumeratedValues(List<Map<String, Object>> records){
        for (Map<String, Object> row : records) {
            mapEnumeratedValues(row);
        }
    }

    public void getDisplayValues(List<Map<String, Object>> records){
        setInvoiceHeaders(records);
        for (Map<String, Object> row : records) {
            mapDisplayValues(row);            
        }   
    }


    public void mapEnumeratedValues(Map<String, Object> record){
        if (record.get('minAmount') != null) record.put('minAmount', KenanEnumerationHelper.getAPICurrencyValue(record.get('minAmount'), kenanSettings.Default_Currency_Code__c, kenanSettings.Stored_Language_Code__c));
        if (record.get('maxAmount') != null) record.put('maxAmount', KenanEnumerationHelper.getAPICurrencyValue(record.get('maxAmount'), kenanSettings.Default_Currency_Code__c, kenanSettings.Stored_Language_Code__c));
        if (record.get('typeCode') != null) record.put('typeCode', KenanEnumerationHelper.getEnumKeyValue('InvoiceTypeCode__mdt', 'TypeCodeId__c', record.get('typeCode'), 'MasterLabel'));
        

        if( record.get('currencyCode') != null) record.put('currencyCode', KenanEnumerationHelper.getEnumKeyValue('RateCurrencyBean__mdt', 'CurrencyCode__c', record.get('currencyCode'), kenanSettings.Stored_Language_Code__c, 'ShortDisplay__c'));
        if (record.get('ratePeriod') != null) record.put('ratePeriod', KenanEnumerationHelper.getEnumKeyValue('RatePeriodBean__mdt', 'IRatePeriod__c', record.get('ratePeriod'), kenanSettings.Stored_Language_Code__c, 'DisplayValue__c'));
        if (record.get('amount') != null ) record.put('amount', KenanEnumerationHelper.getAPICurrencyValue(record.get('amount'), record.get('currencyCode'), kenanSettings.Stored_Language_Code__c));
        if (record.get('federalTax') != null ) record.put('federalTax', KenanEnumerationHelper.getAPICurrencyValue(record.get('federalTax'), record.get('currencyCode'), kenanSettings.Stored_Language_Code__c));
        if (record.get('countyTax') != null ) record.put('countyTax', KenanEnumerationHelper.getAPICurrencyValue(record.get('countyTax'), record.get('currencyCode'), kenanSettings.Stored_Language_Code__c));
        if (record.get('cityTax') != null ) record.put('cityTax', KenanEnumerationHelper.getAPICurrencyValue(record.get('cityTax'), record.get('currencyCode'), kenanSettings.Stored_Language_Code__c));
        if (record.get('otherTax') != null ) record.put('otherTax', KenanEnumerationHelper.getAPICurrencyValue(record.get('otherTax'), record.get('currencyCode'), kenanSettings.Stored_Language_Code__c));
        if (record.get('ratedAmount') != null ) record.put('ratedAmount', KenanEnumerationHelper.getAPICurrencyValue(record.get('ratedAmount'), record.get('currencyCode'), kenanSettings.Stored_Language_Code__c));
        if (record.get('tax') != null ) record.put('tax', KenanEnumerationHelper.getAPICurrencyValue(record.get('tax'), record.get('currencyCode'), kenanSettings.Stored_Language_Code__c));
        if (record.get('discount') != null ) record.put('discount', KenanEnumerationHelper.getAPICurrencyValue(record.get('discount'), record.get('currencyCode'), kenanSettings.Stored_Language_Code__c));
    }

    private void mapDisplayValues(Map<String, Object> record){
        String currencyCode = String.valueOf(record.get('currencyCode'));
        
        if (record.get('minAmount') != null ) record.put('minAmount', KenanEnumerationHelper.getDisplayCurrencyValue(Decimal.valueOf(String.valueOf(record.get('minAmount'))), currencyCode, kenanSettings.Stored_Language_Code__c));
        if (record.get('maxAmount') != null ) record.put('maxAmount', KenanEnumerationHelper.getDisplayCurrencyValue(Decimal.valueOf(String.valueOf(record.get('maxAmount'))), currencyCode, kenanSettings.Stored_Language_Code__c));
        if (record.get('typeCode') != null) record.put('typeCode', KenanEnumerationHelper.getEnumDisplayValue('InvoiceTypeCode__mdt', 'TypeCodeId__c', record.get('typeCode'), 'MasterLabel'));        

        if (record.get('currencyCode') != null) record.put('currencyCode', KenanEnumerationHelper.getEnumDisplayValue('RateCurrencyBean__mdt', 'CurrencyCode__c', record.get('currencyCode'), kenanSettings.Stored_Language_Code__c, 'ShortDisplay__c'));
        if (record.get('ratePeriod') != null && record.get('ratePeriod') != ' ') record.put('ratePeriod', KenanEnumerationHelper.getEnumDisplayValue('RatePeriodBean__mdt', 'IRatePeriod__c', record.get('ratePeriod'), kenanSettings.Stored_Language_Code__c, 'DisplayValue__c'));
        if (record.get('fromDate') != null) record.put('fromDate', KenanUtils.fixDateTime(record.get('fromDate')));
        if (record.get('pcmActiveDt') != null) record.put('pcmActiveDt', KenanUtils.fixDateTime(record.get('pcmActiveDt')));        
        if (record.get('statementDate') != null) record.put('statementDate', KenanUtils.fixDateTime(record.get('statementDate')));
        if (record.get('toDate') != null) record.put('toDate', KenanUtils.fixDateTime(record.get('toDate')));
        if (record.get('transDate') != null) record.put('transDate', KenanUtils.fixDateTime(record.get('transDate')));
        if (record.get('trackingDate') != null) record.put('trackingDate', KenanUtils.fixDateTime(record.get('trackingDate')));
        if (record.get('amount') != null ) record.put('amount', KenanEnumerationHelper.getDisplayCurrencyValue(Decimal.valueOf(String.valueOf(record.get('amount'))), currencyCode, kenanSettings.Stored_Language_Code__c));
        if (record.get('federalTax') != null ) record.put('federalTax', KenanEnumerationHelper.getDisplayCurrencyValue(Decimal.valueOf(String.valueOf(record.get('federalTax'))), currencyCode, kenanSettings.Stored_Language_Code__c));
        if (record.get('countyTax') != null ) record.put('countyTax', KenanEnumerationHelper.getDisplayCurrencyValue(Decimal.valueOf(String.valueOf(record.get('countyTax'))), currencyCode, kenanSettings.Stored_Language_Code__c));
        if (record.get('cityTax') != null ) record.put('cityTax', KenanEnumerationHelper.getDisplayCurrencyValue(Decimal.valueOf(String.valueOf(record.get('cityTax'))), currencyCode, kenanSettings.Stored_Language_Code__c));
        if (record.get('otherTax') != null ) record.put('otherTax', KenanEnumerationHelper.getDisplayCurrencyValue(Decimal.valueOf(String.valueOf(record.get('otherTax'))), currencyCode, kenanSettings.Stored_Language_Code__c));
        if (record.get('ratedAmount') != null ) record.put('ratedAmount', KenanEnumerationHelper.getDisplayCurrencyValue(Decimal.valueOf(String.valueOf(record.get('ratedAmount'))), currencyCode, kenanSettings.Stored_Language_Code__c));
        if (record.get('tax') != null ) record.put('tax', KenanEnumerationHelper.getDisplayCurrencyValue(Decimal.valueOf(String.valueOf(record.get('tax'))), currencyCode, kenanSettings.Stored_Language_Code__c));
        if (record.get('discount') != null ) record.put('discount', KenanEnumerationHelper.getDisplayCurrencyValue(Decimal.valueOf(String.valueOf(record.get('discount'))), currencyCode, kenanSettings.Stored_Language_Code__c));
        
        if (record.get('billRefNo') != null && record.get('billRefResets') != null){
            String invoiceNumber = String.valueOf(record.get('billRefNo')) + kenanSettings.BillRefNo_BillRefResets_delimiter__c + String.valueOf(record.get('billRefResets'));
            
            system.debug('invoiceNumber:' + invoiceNumber);
            
            record.put('invoiceNumber', invoiceNumber);
            UM_InvoiceHeader__c header = invoiceHeaders.get(invoiceNumber);
            if (header != null){
                system.debug('Adding Invoice Header:' + header.UM_InvoiceNumber__c);
                record.put('InvoiceHeader', header);
            }       
        }

        
    }    

    private KenanObject convertToKenanObject(Map<String, Object> record){
        return null;
    }

    private void setInvoiceHeader( Map<String, Object> record){
        Set<String> invoiceId = new Set<String>();
        invoiceId.add(String.valueOf(record.get('billRefNo')) + kenanSettings.BillRefNo_BillRefResets_delimiter__c + String.valueOf(record.get('billRefResets')));
        List<UM_InvoiceHeader__c> invoiceRecords = [SELECT Id FROM UM_InvoiceHeader__c WHERE UM_InvoiceNumber__c = :invoiceId];
        if (!invoiceRecords.isEmpty()) setInvoiceHeaderMap(invoiceRecords);
    }

    private void setInvoiceHeaders( List<Map<String, Object>> records){
        Set<String> invoiceIds = new Set<String>();
        List<UM_InvoiceHeader__c> invoiceRecords;
        for (Map<String, Object> record : records){
            invoiceIds.add(String.valueOf(record.get('billRefNo')) + kenanSettings.BillRefNo_BillRefResets_delimiter__c + String.valueOf(record.get('billRefResets')));
        }
        invoiceRecords = [SELECT Id, UM_InvoiceNumber__c, Name FROM UM_InvoiceHeader__c WHERE UM_InvoiceNumber__c = :invoiceIds];
        if (!invoiceRecords.isEmpty()) setInvoiceHeaderMap(invoiceRecords);
    }

    private void setInvoiceHeaderMap(List<UM_InvoiceHeader__c> records){
        System.debug('setInvoiceHeaderMap enter:' + records);
        for (UM_InvoiceHeader__c record : records){
            invoiceHeaders.put(record.UM_InvoiceNumber__c, record);
        }
    }
}