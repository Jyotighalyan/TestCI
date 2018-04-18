/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanInvoiceDetailService for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanInvoiceDetailService implements KenanServiceInterface {
		
	private KenanServiceConnection__c kenanSettings;
	//private JSONGenerator gen;
	private String columnName;
	private String columnValue;
	private String endpoint;
	private KenanInvoiceDetailMapper mapper;
	private External_Data_Service__mdt keyData;
	private String[] keyFields;
	private Map<String, Object> searchParams;
    private List<Object> keyValues;
    private Map<String, String> typeCodes;

	//private static Map<String, String> typeCodes = new Map<String, String>{
	//	'1' => 'payment',
	//	'2' => 'recurring charge',
	//	'3' => 'non-recurring charge',
	//	'4' => 'adjustment',
	//	'5' => 'summary',
	//	'6' => 'unit credit',
	//	'7' => 'usage charge'
	//};

	private static Map<String, String> subtypeCodes = new Map<String, String>{
		'-1' => 'previous bill total due summary',
		'-2' => 'new charges summary',
		'-3' => 'total due summary'
	};

	private static Map<String, String> endpointParamNames = new Map<String, String>{
		'typeCode' => 'typeCode',
		'subtypeCode' => 'subtypeCode',
		'billRefNo' => 'billRefNo',
		'serviceExternalId' => 'serviceExternalId',
        'serviceExternalIdType' => 'serviceExternalIdType',
		'accountExternalId' => 'acctExternalId',
		'accountExternalIdType' => 'acctExternalIdType',
		'minAmount' => 'minAmount',
		'maxAmount' => 'maxAmount',
		'fromDate' => 'dateFrom',
		'toDate' => 'dateTo'
	};

	public KenanInvoiceDetailService() {
		kenanSettings = KenanServiceConnection__c.getInstance();
		mapper = new KenanInvoiceDetailMapper();
		keyData = [SELECT KeyFields__c FROM External_Data_Service__mdt WHERE DeveloperName = 'InvoiceItem' LIMIT 1];
		keyFields = keyData.KeyFields__c.split(',');
        getTypeCodes();
	}

	public KenanObject insertRow(KenanObject contextObject,  String method, String action){
		return null;
	}
	
	public KenanObject updateRow(KenanObject contextObject,  String method, String action){
		return null;
	}

	public Boolean deleteRow(KenanObject contextObject){
 		// this is not going to be implemented
		return false;
    }		

    /*	these are methods to support Salesforce Connect */
	
	public DataSource.TableResult query(DataSource.QueryContext context){
		System.debug('QueryContext: ' + context);

		List<Map<String,Object>> mappedData = new List<Map<String,Object>>();
        Integer offset = context.offset;
        Integer maxResults = context.maxResults;

        DataSource.Filter filter = context.TableSelection.Filter;
        setEndpoint(filter);
        
        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();

        Integer size = 2;
        if (this.columnName == 'ExternalId' || this.columnName == 'Invoice'){
            size = 1;
        }
        
        HttpResponse response = helper.sendRequest(null, 'GET', this.endpoint, 0, 100);
        if (response.getStatusCode() == 200){
            if (keyValues.size() == 1 || keyValues.size() == 2) {
                List<Object> rows = (List<Object>) JSON.deserializeUntyped(response.getBody());
                for (Object row : rows){
                    Map<String, Object> curRow = (Map<String, Object>) row;
                    addExternalId(curRow);
                    mappedData.add(curRow);
                }
            } else if (keyValues.size() == 3){
                Map<String, Object> curRow = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                addExternalId(curRow);
                mappedData.add(curRow);
            }
            mapper.getDisplayValues(mappedData);
            DataSource.TableResult result;
            result = DataSource.TableResult.get(context, mappedData);
            return result;
        } else {
            KenanException ke = new KenanException(response);
            throw ke;
        } 
	}

	public DataSource.TableResult search(DataSource.TableSelection context, String searchPhrase){
		return null;
	}

	public List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext context){
    	List<DataSource.UpsertResult> result = new List<DataSource.UpsertResult>();


    	return result;
    }

    public List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext context){
    	return null;
    }

    /**
    * Retrieve the invoice header record with the given id
    * @param invoiceHeaderId the id of the invoice header record
    * @return UM_InvoiceHeader__c
    */
    public UM_InvoiceHeader__c getInvoiceHeader(Id invoiceHeaderId) {

        List<UM_InvoiceHeader__c> invoiceHeaders = [
            SELECT
                Name,
                UM_Customer_SF_ID__c,
                UM_Invoice_Amount_Gross_Currency__c,
                UM_Invoice_Amount_Gross__c,
                UM_Invoice_Amount_Net_Currency__c,
                UM_Invoice_Amount_Net__c,
                UM_Invoice_Date__c,
                UM_InvoiceNumber__c,
                UM_OpenPDF__c,
                UM_Payment_Due_Date__c,
                (
                    SELECT
                        Name,
                        Id,
                        accountExternalId__c,
                        accountExternalIdType__c,
                        Adjustment_Reason__c,
                        Adjustment_Type__c,
                        Approval_Status__c,
                        billRefNo__c,
                        billRefResets__c,
                        currencyCode__c,
                        Effective_Date__c,
                        fraudIndicator__c,
                        Invoice_Header__c,
                        Invoice_Item__c,
                        Open_Item__c,
                        primaryUnits__c,
                        primaryUnitsType__c,
                        revRcvCostCtr__c,
                        requestStatus__c,
                        Total_Amount__c,
                        trackingId__c,
                        trackingIdServ__c,
                        Unit_Type__c
                    FROM
                        Adjustments__r
                )
            FROM
                UM_InvoiceHeader__c
            WHERE
                Id = :invoiceHeaderId
        ];

        UM_InvoiceHeader__c invoiceHeader;

        if (!invoiceHeaders.isEmpty()) {
            invoiceHeader = invoiceHeaders.get(0);
        }

        return invoiceHeader;
    }


    /**
    * Retrieve the invoice header record with the given id
    * @param invoiceHeaderId the id of the invoice header record
    * @return UM_InvoiceHeader__c
    */
    public UM_InvoiceHeader__c getInvoiceHeader(Id invoiceHeaderId, String invoiceHeaderFieldSetName) {

        List<Schema.FieldSetMember> members = Schema.SObjectType.UM_InvoiceHeader__c.fieldSets.getMap().get(invoiceHeaderFieldSetName).getFields();
        Set<String> fieldSet = new Set<String>();
        
        fieldSet.add('Id');
        fieldSet.add('Name');
        fieldSet.add('UM_InvoiceNumber__c');
        
        if (Test.isRunningTest()){
            fieldSet.add('UM_Invoice_Date__c');
            fieldSet.add('UM_Invoice_Amount_Gross__c');
            fieldSet.add('UM_Invoice_Amount_Net__c');
            fieldSet.add('UM_Payment_Due_Date__c');
        }
        
        for (Schema.FieldSetMember member : members){
            fieldSet.add(member.getFieldPath());
        }

        List<String> fields = new List<String>(fieldSet);

        String soqlQuery = 'SELECT ' + String.join(fields, ',') + ', (SELECT Name, Id, accountExternalId__c, accountExternalIdType__c, Adjustment_Reason__c, Adjustment_Type__c, Approval_Status__c, billRefNo__c, billRefResets__c, currencyCode__c, Effective_Date__c, fraudIndicator__c, Invoice_Header__c, Invoice_Item__c, Open_Item__c, primaryUnits__c, primaryUnitsType__c, revRcvCostCtr__c, requestStatus__c, Total_Amount__c, UM_Received_from_Billing_System__c ,trackingId__c, trackingIdServ__c, Unit_Type__c FROM Adjustments__r) FROM UM_InvoiceHeader__c WHERE Id = :invoiceHeaderId';

        List<UM_InvoiceHeader__c> invoiceHeaders = Database.query(soqlQuery);            

        UM_InvoiceHeader__c invoiceHeader;

        if (!invoiceHeaders.isEmpty()) {
            invoiceHeader = invoiceHeaders.get(0);
        }

        return invoiceHeader;
    }

    /**
    * Query external source for invoice item records
    * @param fieldStr the string of fields to retrieve
    * @param keyValue the value to be used to filter the where clause
    * @return KenanInvoiceDetailResponse
    */
    public KenanInvoiceDetailResponse queryInvoiceItems(String fieldStr, String keyValue) {
        List<InvoiceItem__x> kenanInvoiceItems = new List<InvoiceItem__x>();

        String completeFieldStr = removeDuplicateFields(fieldStr);
        String query = 'SELECT ' +
                        String.escapeSingleQuotes(completeFieldStr) +
                        ' FROM InvoiceItem__x WHERE Invoice__r.UM_InvoiceNumber__c = \'' + 
                        String.escapeSingleQuotes(keyValue) + '\' ' +
                        ' ORDER BY serviceInternalId__c';
        KenanLogUtils.logInfo('queryInvoiceItems SOQL: ', query);        
        List<sObject> resultList = new List<sObject>();

        if (!Test.isRunningTest()) {
        	resultList = Database.query(query);
        } else {
        	resultList = (List<sObject>) KenanSampleCode.createSampleInvoiceItems();
        }

        if (!resultList.isEmpty()) {
            for (sObject resultItem: resultList) {
                InvoiceItem__x invoiceItem = (InvoiceItem__x) resultItem;
                kenanInvoiceItems.add(invoiceItem);
            }
        }

        KenanInvoiceDetailResponse response = buildKenanDetailResponse(kenanInvoiceItems);

        return response;
    }

    private void getTypeCodes(){
        typeCodes = new Map<String, String>();
        List<InvoiceTypeCode__mdt> items = [SELECT MasterLabel, TypeCodeId__c FROM InvoiceTypeCode__mdt];
        for (InvoiceTypeCode__mdt item : items){
            typeCodes.put(item.TypeCodeId__c, item.MasterLabel);
        }
    }

    private String removeDuplicateFields(String fieldStr) {
    	Set<String> necessaryFields = new Set<String>{
    		'Id',
    		'serviceExternalId__c',
    		'serviceInternalId__c',
    		'subtypeCode__c'
    	};

    	List<String> fields = fieldStr.split(', ');
    	List<String> completeFields = new List<String>();

    	for (String field: fields) {
    		if (necessaryFields.contains(field)) {
    			necessaryFields.remove(field);
    		}

    		completeFields.add(field);
    	}

    	for (String necessaryField: necessaryFields) {
    		completeFields.add(necessaryField);
    	}

    	String completeFieldStr = String.join(completeFields, ', ');

    	return completeFieldStr;
    }

    private KenanInvoiceDetailResponse buildKenanDetailResponse(List<InvoiceItem__x> invoiceItems) {
        system.debug('buildKenanDetailResponse entry:' + invoiceItems);
    	KenanInvoiceDetailResponse response = new KenanInvoiceDetailResponse();

    	Decimal accountLevelTotal = 0;
    	Decimal paymentTotal = 0;
    	Decimal serviceTotal = 0;
        Decimal invoiceTotal = 0;
        Decimal adjustmentTotal = 0;
        Decimal newChargesTotal = 0;

    	for (InvoiceItem__x invoiceItem: invoiceItems) {
            if (invoiceItem.typeCode__c == typeCodes.get('2') || invoiceItem.typeCode__c == typeCodes.get('3')) {
                // Recurring or Non-Recurring Charges
                if (invoiceItem.billingLevel__c == '0') {
                    // Account details (Section 1)
                    System.debug('Adding Account Level Item:' + invoiceItem);
    				response.accountLevelInvoiceItems.add(invoiceItem);
    				accountLevelTotal += invoiceItem.amount__c;
                } else if (invoiceItem.billingLevel__c == '1') {
                    // Service details (Section 4)
                    System.debug('Service Level Item:' + invoiceItem);
					if (!response.serviceToInvoiceItems.containsKey(invoiceItem.serviceExternalId__c)) {
						response.serviceToInvoiceItems.put(invoiceItem.serviceExternalId__c, new List<InvoiceItem__x>());
					}
					response.serviceToInvoiceItems.get(invoiceItem.serviceExternalId__c).add(invoiceItem);
                    serviceTotal += invoiceItem.amount__c;
                }
            } else if (invoiceItem.typeCode__c == typeCodes.get('5')) {
                // Invoice Totals (Section 2)
                // ignore invoice item if the subtype code is not in { -1, -2, -3 }
                if (subtypeCodes.containsKey(invoiceItem.subtypeCode__c) && invoiceItem.openItemId__c == '0') {
                    response.invoiceTotalItems.add(invoiceItem);
                    invoiceTotal += invoiceItem.amount__c;
                    if (!response.serviceToSummaryItem.containsKey(invoiceItem.serviceExternalId__c)) {
                        response.serviceToSummaryItem.put(invoiceItem.serviceExternalId__c, invoiceItem);
                    }
                }
                if (invoiceItem.subtypeCode__c == '-2') {
                    newChargesTotal += invoiceItem.amount__c;
                }

            } else if (invoiceItem.typeCode__c == typeCodes.get('1')) {
                // Payment Details (Section 3)
                response.paymentInvoiceItems.add(invoiceItem);
                paymentTotal += invoiceItem.amount__c;
            } else if (invoiceItem.typeCode__c == typeCodes.get('7')) {
                System.debug('Adding TypeCode 7 Item:' + invoiceItem);
                if (!response.serviceToInvoiceItems.containsKey(invoiceItem.serviceExternalId__c)) {
                    response.serviceToInvoiceItems.put(invoiceItem.serviceExternalId__c, new List<InvoiceItem__x>());
                }
                response.serviceToInvoiceItems.get(invoiceItem.serviceExternalId__c).add(invoiceItem);
                serviceTotal += invoiceItem.amount__c;
            } else if (invoiceItem.typeCode__c == typeCodes.get('4')) {
                // Adjustment details (Section 5)
                System.debug('Adding TypeCode 4 Adjustment Item:' + invoiceItem);
                response.adjustmentItems.add(invoiceItem);
                adjustmentTotal += invoiceItem.amount__c;
            }
		}

		response.accountLevelTotal = accountLevelTotal;
		response.paymentTotal = paymentTotal;
		response.serviceTotal = serviceTotal;
        response.invoiceTotal = invoiceTotal;
        response.adjustmentTotal = adjustmentTotal;
        response.newInvoiceTotal = newChargesTotal;
        system.debug('buildKenanDetailResponse exit:' + response);
    	return response;
    }

    /**
    * Query external source for a single invoice item record
    * @param fieldStr the string of fields to retrieve
    * @param keyValue the value to be used to filter the where clause
    * @return List<InvoiceItem__x>
    */
    public InvoiceItem__x queryInvoiceItem(String fieldStr, String keyValue) {
        system.debug('queryInvoiceItem :' + keyValue);
        InvoiceItem__x kenanInvoiceItem;

        String query = 'SELECT ' +
                        String.escapeSingleQuotes(fieldStr) +
                        ' FROM InvoiceItem__x WHERE ExternalId = \'' + 
                        String.escapeSingleQuotes(keyValue) + '\' ' +
                        ' ORDER BY serviceInternalId__c';
                
        List<sObject> resultList = new List<sObject>();

        if (!Test.isRunningTest()) {
            resultList = Database.query(query);
        }

        if (!resultList.isEmpty()) {
            kenanInvoiceItem = (InvoiceItem__x) resultList[0];
        }

        return kenanInvoiceItem;
    }

    @TestVisible
    private void setEndPoint (DataSource.Filter filter){
        system.debug('filter:' + filter);

        if (filter.columnName != null && filter.columnValue != null){
            System.debug('setEndpoint main filter:' + filter.columnValue);
            this.columnValue = String.valueOf(filter.columnValue);
            system.debug('columnValue:' + columnValue);
            keyValues = formatColumnValue(this.columnValue).split('\\.');
    		//columnName = filter.columnName;
            setEndPoint();
    	} else {
    		List<DataSource.Filter> subFilters = filter.subfilters;
    		this.columnValue = String.valueOf(subFilters[0].columnValue);
    		if (!subFilters.isEmpty() && subFilters.size() == 1){
    			//columnName = subFilters[0].columnName;
    
    			if (subFilters[0].columnName == 'Invoice') {	
	                keyValues = formatColumnValue(this.columnValue).split('\\.');
	                setEndPoint();
	            } else {
	            	parseMultipleFilters(subFilters);
	            }
    		} else if (subFilters.size() > 1) {
    			parseMultipleFilters(subFilters);
    		}
    	}
    }

    private void parseMultipleFilters(List<DataSource.Filter> subFilters) {
        system.debug('parseMultipleFilters' + subfilters);
    	//multiple filters doing Invoice Item search;
		searchParams = new Map<String, Object>();
		for (DataSource.Filter subFilter : subFilters){
			if (subFilter.subfilters != null && !subFilter.subfilters.isEmpty()) {
				for (DataSource.Filter sf : subFilter.subfilters) {
					formatParameterFields(sf);
				}
			} else {
				formatParameterFields(subFilter);
			}

		}
        //map venaumerated values and fix fields
        mapper.mapEnumeratedValues(searchParams);

		//TODO: Set Endpoint Value for search
		List<String> nameValuePairs = new List<String>();

		for (String name: searchParams.keySet()) {
			String value = String.valueOf(searchParams.get(name));
			nameValuePairs.add(String.format('{0}={1}', new List<String>{ name, value }));
		}

		keyValues = new List<String>{ String.join(nameValuePairs, '&') };
    	setEndpoint();
    }

    private void formatParameterFields(DataSource.Filter subFilter) {
    	if (DataSource.FilterType.GREATER_THAN_OR_EQUAL_TO.equals(subFilter.type) && 'amount'.equals(subFilter.columnName)) {
			searchParams.put(endpointParamNames.get('minAmount'), String.valueOf(subFilter.columnValue));
		} else if (DataSource.FilterType.LESS_THAN_OR_EQUAL_TO.equals(subFilter.type) && 'amount'.equals(subFilter.columnName)) {
			searchParams.put(endpointParamNames.get('maxAmount'), String.valueOf(subFilter.columnValue));
		} else if ('fromDate'.equals(subFilter.columnName) || 'toDate'.equals(subFilter.columnName)) {
			String theDate = ((Datetime)subFilter.columnValue).formatGmt('yyyy-MM-dd');
			searchParams.put(endpointParamNames.get(subFilter.columnName), theDate);
		} else {
			searchParams.put(endpointParamNames.get(subFilter.columnName), String.valueOf(subFilter.columnValue));
		}
    }

    private void setEndPoint(){
        system.debug('keyValues:' + keyValues);
        if (keyValues.size() == 1) {
        	// Search
        	this.endpoint = '/invoices/details?' + keyValues[0];
        }

        if (keyValues.size() == 2){
            // all details
            this.endpoint = '/invoices/' + keyValues[0] + '.' + keyValues[1] + '/details';

        } else if (keyValues.size() == 3){
            // Single record
            this.endpoint = '/invoices/' + keyValues[0] + '.' + keyValues[1] + '/details/' +  keyValues[2];            
        }
    }

    private void addExternalId(Map<String, Object> mappedRow){
		String externalId = '';
		keyValues = new List<Object>();
		for (String s : keyFields){
			keyValues.add(String.valueOf(mappedRow.get(s)));
		}

		externalId = String.join(keyValues, kenanSettings.BillRefNo_BillRefResets_delimiter__c);
		mappedRow.put('ExternalId', externalId);

		system.debug(LoggingLevel.INFO, 'keyValues:' + keyValues);
		system.debug(LoggingLevel.INFO, 'ExternalId:' + externalId);
	}


	private String formatColumnValue(Object columnValue){
        //replace - with . in case they separate the billRefNo and BillRefResets with a dash
		return String.valueOf(columnValue).replace(kenanSettings.BillRefNo_BillRefResets_delimiter__c, '.');
	}
}