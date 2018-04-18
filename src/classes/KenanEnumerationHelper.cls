/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Enumeration Helper for use in managing Kenan Enumerated Values with Salesforce Kenan Connection Service
*/
public class KenanEnumerationHelper {

	public static final String QUALIFIED_API_NAME_ATTRIBUTE = 'QualifiedApiName';
    public static final String FULL_NAME_ATTRIBUTE = 'FullName';
    public static final String LABEL_ATTRIBUTE = 'Label';
    public static final String DEV_NAME_ATTRIBUTE = 'DeveloperName';
    public static final String DESC_ATTRIBUTE = 'Description';
    public static final String MDT_SUFFIX = '__mdt';
    public static final String KEY_ATTRIBUTE = 'Key';
    public static final String FIELD_SUFFIX = '__c';
    public static final String KEY_SEPARATOR = ':';
    private static RateCurrencyBean__mdt rate;

	static KenanMetadataService.MetadataPort port;
    
    //public for testing purposes only;
    public static KenanEnumerationHelper.MetaStatus mdApiStatus = MetaStatus.NOT_CHECKED;
    
    //public for testing purposes
    public enum MetaStatus {
        NOT_CHECKED,
        AVAILABLE,
        UNAVAILABLE
    }
    
    public static Boolean checkMetadataAPIConnection(String sessionId) {
        if (mdApiStatus == MetaStatus.NOT_CHECKED) {
            boolean success = true;
            KenanMetadataService.FileProperties[] allCmdProps;
            try {
                KenanMetadataService.MetadataPort service = getPort(sessionId);
                List<KenanMetadataService.ListMetadataQuery> queries = new List<KenanMetadataService.ListMetadataQuery>();
                KenanMetadataService.ListMetadataQuery customMetadata = new KenanMetadataService.ListMetadataQuery();
                customMetadata.type_x = 'CustomMetadata';
                queries.add(customMetadata);
                allCmdProps = service.listMetadata(queries, 34);
                mdApiStatus = MetaStatus.AVAILABLE;
            } catch (CalloutException e) {
                if (!e.getMessage().contains('Unauthorized endpoint, please check Setup')) {
                    throw e;
                }
                mdApiStatus = MetaStatus.UNAVAILABLE;
            }
        }
        return mdApiStatus == MetaStatus.AVAILABLE;
    }
    
    public static KenanMetadataService.MetadataPort getPort(String sessionId) {
        if (port == null) {
            port = new KenanMetadataService.MetadataPort();
            port.sessionHeader = new KenanMetadataService.SessionHeader_element();
            port.sessionHeader.sessionId = sessionId;
        }
        return port;
    }
    
    public static void transformToCustomMetadataAndCreate(KenanEnumeration enumeration, String sessionId) {
        String devName;
        String label;
        Integer rowCount = 0;
        List<Map<String, String>> fieldValues = enumeration.getValues();

        List<KenanMetadataService.Metadata> customMetadataRecords = new List<KenanMetadataService.Metadata>();
        
        Map<String, String> header = enumeration.getFieldNames();
        Map<String, String> keyFields = enumeration.getKeyFieldNames();
        for(Map<String, String> singleRowOfValues : fieldValues) {            
            String typeDevName = enumeration.enumName;
            Map<String, String> fieldsAndValues = new Map<String, String>();
            String keyValue = '';
            for (String fieldName : header.keySet()) {
            	fieldsAndValues.put(fieldName + FIELD_SUFFIX, singleRowOfValues.get(fieldName));
                if (keyFields.get(fieldName) != null) {
                	keyValue = keyValue + singleRowOfValues.get(fieldName) + KEY_SEPARATOR;
                }
            }
            String finalKeyValue = keyValue.removeEnd(KEY_SEPARATOR);
            fieldsAndValues.put(LABEL_ATTRIBUTE, typeDevName + '.' + finalKeyValue);
            fieldsAndValues.put(KEY_ATTRIBUTE + FIELD_SUFFIX, finalKeyValue);
            
            if (fieldsAndValues.get(FULL_NAME_ATTRIBUTE) == null) {
                String strippedLabel = fieldsAndValues.get(LABEL_ATTRIBUTE).replaceAll('\\W+', '_').replaceAll('__+', '_').replaceAll('\\A[^a-zA-Z]+', '').replaceAll('_$', '');
                //default fullName to type_dev_name.label
                fieldsAndValues.put(FULL_NAME_ATTRIBUTE, typeDevName + '.'+ strippedLabel);
            } else if(fieldsAndValues.get(LABEL_ATTRIBUTE) == null) {
                //default label to dev_name
                fieldsAndValues.put(LABEL_ATTRIBUTE, fieldsAndValues.get(DEV_NAME_ATTRIBUTE));
            }
            
            customMetadataRecords.add(transformToCustomMetadata(fieldsAndValues.keySet(), fieldsAndValues));
        }
        createMetadataAndValidate(customMetadataRecords, sessionId);
    }


    public static void deleteCustomMetadata(KenanEnumeration enumeration, String sessionId) {
        String enumName = enumeration.enumName;
        List<String> recordsToDelete = new List<String>();
        String soqlQuery = 'SELECT DeveloperName FROM ' + enumName + MDT_SUFFIX;
        List<SObject> records = Database.query(soqlQuery);

        for (SObject record : records){
            recordsToDelete.add( enumName + '.' + String.valueOf(record.get('DeveloperName')));
        }
        deleteMetadataAndValidate(recordsToDelete, sessionId);

    }
    
    /*
     * Transformation utility to turn the configuration values into custom metadata values
     * This method to modify Metadata is only approved for Custom Metadata Records. Note that the number of custom metadata 
     * values which can be passed in one update has been increased to 200 values (just for custom metadata)
     * We recommend to create new type if more fields are needed.
     * Using https://github.com/financialforcedev/apex-mdapi
     */
    private static KenanMetadataService.CustomMetadata transformToCustomMetadata(Set<String> standardFields, Map<String, String> fieldsAndValues){
        KenanMetadataService.CustomMetadata  customMetadata = new KenanMetadataService.CustomMetadata();
        customMetadata.label = fieldsAndValues.get(LABEL_ATTRIBUTE);
        customMetadata.fullName = fieldsAndValues.get(FULL_NAME_ATTRIBUTE);
        customMetadata.description = fieldsAndValues.get(DESC_ATTRIBUTE);
        
        //custom fields
        KenanMetadataService.CustomMetadataValue[] customMetadataValues = new List<KenanMetadataService.CustomMetadataValue>();
        if(fieldsAndValues != null){
            for (String fieldName : fieldsAndValues.keySet()) {
                if (fieldName != LABEL_ATTRIBUTE && fieldName != FULL_NAME_ATTRIBUTE) {
                    KenanMetadataService.CustomMetadataValue cmRecordValue = new KenanMetadataService.CustomMetadataValue();
                    cmRecordValue.field=fieldName;
                    cmRecordValue.value= fieldsAndValues.get(fieldName);
                    customMetadataValues.add(cmRecordValue);
                }
            }
        }
        customMetadata.values = customMetadataValues;
        return customMetadata;
    }
    
    private static void createMetadataAndValidate(KenanMetadataService.Metadata[] records, String sessionId) {
        if (records.size() == 0){
            system.debug('No Metadata Records to insert');
            return;
        }
        List<KenanMetadataService.UpsertResult> results = new List<KenanMetadataService.UpsertResult>();

        if (records.size() <= 150){
            results = getPort(sessionId).upsertMetadata(records);
            system.debug('createMetadataAndValidate results:' + results);
        }
        else {
            List<KenanMetadataService.Metadata> recordscopy = new List<KenanMetadataService.Metadata>();
            for (KenanMetadataService.Metadata record : records){
                recordscopy.add(record);
                if ( recordscopy.size() == 199){
                    if( !Test.isRunningTest()){
                        results.addAll(getPort(sessionId).upsertMetadata(recordscopy));
                    }
                    recordscopy.clear();
                }
            }
            if (!Test.isRunningTest()){
                results.addAll(getPort(sessionId).upsertMetadata(recordscopy));
            }
        }

         
        String message;
        if(results!=null){
            for(KenanMetadataService.UpsertResult saveResult : results){
                if(saveResult==null || saveResult.success){
                     continue;
                }
                
            	if(saveResult.errors!=null){
                	for(KenanMetadataService.Error error : saveResult.errors){
                		system.debug(LoggingLevel.ERROR, error);
                		KenanMetadataServiceException ee = new KenanMetadataServiceException();
                		ee.setMessage(error.message);
                		throw ee;
             	   }
                
		            if (!saveResult.success){
	                	return;
	    	        }
	    	    }
     		}
        }
    }

    private static void deleteMetadataAndValidate(List<String> typesToDelete, String sessionId) {
        if (typesToDelete.size() == 0){
            system.debug('No Metadata Records to delete');
            return;
        }
        List<KenanMetadataService.DeleteResult> results = new List<KenanMetadataService.DeleteResult>();
        
        if (typesToDelete.size() <= 150){
            results = getPort(sessionId).deleteMetadata('CustomMetadata', typesToDelete);
            system.debug('deleteMetadataAndValidate results:' + results);
        }
        else {
            List<String> recordscopy = new List<String>();
            for (String record : typesToDelete){
                recordscopy.add(record);
                if ( recordscopy.size() == 199){
                    results.addAll(getPort(sessionId).deleteMetadata('CustomMetadata', recordscopy));
                    recordscopy.clear();
                }
            }
            results.addAll(getPort(sessionId).deleteMetadata('CustomMetadata', recordscopy));
        }

         
        String message;
        if(results!=null){
            for(KenanMetadataService.DeleteResult result : results){
                if(result==null || result.success){
                     continue;
                }
                
                if(result.errors!=null){
                    for(KenanMetadataService.Error error : result.errors){
                        system.debug(LoggingLevel.ERROR, error);
                        KenanMetadataServiceException ee = new KenanMetadataServiceException();
                        ee.setMessage(error.message);
                        throw ee;
                   }
                
                    if (!result.success){
                        return;
                    }
                }
            }
        }
    }

	public static void createCustomSetting(String objectName, String sessionId){
		List<KenanMetadataService.CustomObject> metaToUpload = new List<KenanMetadataService.CustomObject>();
		KenanMetadataService.CustomObject customObject = new KenanMetadataService.CustomObject();
		customObject.fullName = objectName + MDT_SUFFIX;
		customObject.label = objectName;
		customObject.pluralLabel = objectName;
		metaToUpload.add(customObject);
		createMetadataAndValidate(metaToUpload, sessionId);
	}

	public static void addCustomFields(Map<String, String> enumFieldMap, String objectName, String sessionId){
		List<KenanMetadataService.CustomField> fields = new List<KenanMetadataService.CustomField>();

		fields.add(createCustomField('Key', objectName + MDT_SUFFIX));
		createMetadataAndValidate(fields, sessionId);
		fields.clear();
		
		for ( String key : enumFieldMap.keySet()){
			String settingFieldName = key;
			fields.add(createCustomField(settingFieldName, objectName + MDT_SUFFIX));
			createMetadataAndValidate(fields, sessionId);
			fields.clear();
			
		}
	}

	private static KenanMetadataService.CustomField createCustomField(String fieldName, String objectName){
		KenanMetadataService.CustomField customField = new KenanMetadataService.CustomField();
		customField.fullName = objectName + '.' + fieldName + FIELD_SUFFIX;
		customField.label = fieldName;
		customField.type_x = 'Text';
		customField.length = 255;
		customField.externalId = false;
		customField.trackTrending = false;
		customField.required = false;
		return customField;
	}

    public static String getEnumDisplayValue(String customMetaDataAPIName, String keyFieldName, Object keyObjectValue, String languageCode, String displayFieldName){
        system.debug(LoggingLevel.WARN, 'getEnumDisplayValue enter: ' + customMetaDataAPIName + '::' + keyObjectValue);
        String displayValue;
        String keyValue = String.valueOf(keyObjectValue);
        String queryString = 'SELECT ' + displayFieldName + ' FROM ' + customMetaDataAPIName + ' WHERE ' + keyFieldName + ' = :keyValue AND LanguageCode__c = :languageCode';

        List<SObject> enumerations = Database.query(queryString);
        if (!enumerations.isEmpty()){
            displayValue = (String) enumerations[0].get(displayFieldName); 
        } else {
            throw new KenanMetadataServiceException('Key value could not be located in ' + customMetaDataAPIName + ' for Key ' + keyValue );
        }
        return displayValue;
    }

    public static String getEnumDisplayValue(String customMetaDataAPIName, String keyFieldName, Object keyObjectValue, String displayFieldName){
        system.debug(LoggingLevel.WARN, 'getEnumDisplayValue enter: ' + customMetaDataAPIName + '::' + keyObjectValue);
        String displayValue;
        String keyValue = String.valueOf(keyObjectValue);
        String queryString = 'SELECT ' + displayFieldName + ' FROM ' + customMetaDataAPIName + ' WHERE ' + keyFieldName + ' = :keyValue';

        List<SObject> enumerations = Database.query(queryString);
        if (!enumerations.isEmpty()){
            displayValue = (String) enumerations[0].get(displayFieldName); 
        } else {
            throw new KenanMetadataServiceException('Key value could not be located in ' + customMetaDataAPIName + ' for Key ' + keyValue );
        }
        return displayValue;
    }

    public static String getEnumKeyValue(String customMetaDataAPIName, String keyFieldName, Object displayObjectValue, String languageCode, String displayFieldName){
        
        system.debug(LoggingLevel.WARN, 'getEnumKeyValue enter: ' + customMetaDataAPIName + '::' + displayObjectValue);
        String displayValue = String.valueOf(displayObjectValue);
        String enumValue;
        String queryString = 'SELECT ' + keyFieldName + ' FROM ' + customMetaDataAPIName + ' WHERE ' + displayFieldName + ' = :displayValue AND LanguageCode__c = :languageCode';

        List<SObject> enumerations = Database.query(queryString);
        if (!enumerations.isEmpty()){
            enumValue = (String) enumerations[0].get(keyFieldName); 
        } else {
           throw new KenanMetadataServiceException('Enumeration value could not be located in ' + customMetaDataAPIName + ' for Value ' + displayValue + ' and language code ' + languageCode); 
        }
        
        return enumValue;
    }

    public static String getEnumKeyValue(String customMetaDataAPIName, String keyFieldName, Object displayObjectValue, String displayFieldName){
        system.debug('getEnumKeyValue enter: ' + customMetaDataAPIName + '::' + displayObjectValue);
        String displayValue = String.valueOf(displayObjectValue);
        String enumValue;
        String queryString = 'SELECT ' + keyFieldName + ' FROM ' + customMetaDataAPIName + ' WHERE ' + displayFieldName + ' = :displayValue';

        List<SObject> enumerations = Database.query(queryString);
        if (!enumerations.isEmpty()){
            enumValue = (String) enumerations[0].get(keyFieldName); 
        } else {
           throw new KenanMetadataServiceException('Enumeration value could not be located in ' + customMetaDataAPIName + 'for Value ' + displayValue ); 
        }
        
        return enumValue;
    }

    public static Decimal getDisplayCurrencyValue(Decimal value, String currencyCode, String languageCode){
        getCurrencyCode(currencyCode,languageCode);
        Decimal convertedValue;
        if (rate.ImpliedDecimal__c == '0'){
            convertedValue = value;
        } 
        else if (rate.ImpliedDecimal__c == '1'){
            convertedValue = value / 10;
        }
        else if (rate.ImpliedDecimal__c == '2'){
            convertedValue = value / 100;
        }
        return convertedValue;
    }

    public static Integer getAPICurrencyValue(Object value, Object currencyCode, String languageCode){
        System.debug('getAPICurrencyValue:' + value + ':' + currencyCode + ':' + languageCode);
        getCurrencyCode(String.valueOf(currencyCode), languageCode);
        Integer convertedValue;
        if (rate.ImpliedDecimal__c == '0'){
            convertedValue = Integer.valueOf(value);
        } 
        else if (rate.ImpliedDecimal__c == '1'){

            convertedValue = Integer.valueOf(Double.valueOf(value) * 10);
        }
        else if (rate.ImpliedDecimal__c == '2'){
            convertedValue = Integer.valueOf(Double.valueOf(value) * 100);
        }
        System.debug('convertedValue:' + convertedValue);
        return convertedValue;
    }

    private static void getCurrencyCode(String currencyCode, String languageCode){
        if (rate == null){
            rate = [SELECT 
                IsSymbolFirst__c, 
                ConfigTagId__c, 
                CurrencyType__c,
                ImpliedDecimal__c,
                RoundingFactor__c,
                IsConversionDefault__c,
                LanguageCode__c,
                IsDefault__c,
                ShortDisplay__c,
                FormatCode__c,
                InactiveDate__c,
                ActiveDate__c,
                RoundingMethod__c,
                IsInternal__c,
                DisplayValue__c,
                CurrencyCode__c
            FROM RateCurrencyBean__mdt
            WHERE LanguageCode__c = : languageCode
            AND CurrencyCode__c = :currencyCode
            LIMIT 1];
        }
        System.debug('rate:' + rate);
    }

    public static String getDefaultEnumDisplayValue(String customMetaDataAPIName, String languageCode, String displayFieldName){
        system.debug(LoggingLevel.WARN, 'getDefaultEnumDisplayValue enter: ' + customMetaDataAPIName);
        String displayValue;
        String queryString = 'SELECT ' + displayFieldName + ' FROM ' + customMetaDataAPIName + ' WHERE IsDefault__c = \'true\' AND LanguageCode__c = :languageCode';

        List<SObject> enumerations = Database.query(queryString);
        if (!enumerations.isEmpty()){
            displayValue = (String) enumerations[0].get(displayFieldName); 
        } else {
            throw new KenanMetadataServiceException('default value could not be located in ' + customMetaDataAPIName);
        }
        return displayValue;
    }
}