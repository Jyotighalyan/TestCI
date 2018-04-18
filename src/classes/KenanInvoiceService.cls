/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanInvoiceService for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanInvoiceService implements KenanServiceInterface {
		
	private KenanServiceConnection__c kenanSettings;
	//private JSONGenerator gen;
	private String columnName;
	private String columnValue;
	private String endpoint;
	private KenanInvoiceDetailMapper mapper;
	private External_Data_Service__mdt keyData;
	private String[] keyFields;
	private Map<String, String> searchParams;
    private List<Object> keyValues;

	public KenanInvoiceService() {
		kenanSettings = KenanServiceConnection__c.getInstance();
		//mapper = new KenanInvoiceDetailMapper();
		keyData = [SELECT KeyFields__c FROM External_Data_Service__mdt WHERE DeveloperName = 'Invoice' LIMIT 1];
		keyFields = keyData.KeyFields__c.split(',');
	}


    public DataSource.TableResult query(DataSource.QueryContext context){
        System.debug('KenanInvoiceService.query:' + context);
    	List<Map<String,Object>> mappedData = new List<Map<String,Object>>();
    	DataSource.Filter filter = context.TableSelection.Filter;
        setEndpoint(filter);

        if (columnValue != null){
            KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();

            Integer size = 2;
            if (this.columnName == 'ExternalId' || this.columnName == 'Invoice'){
                size = 1;
            }
            
            HttpResponse response = helper.sendRequest(null, 'GET', this.endpoint, 0, 100);
            
            if (keyValues.size() == 1 || keyValues.size() == 2) {
                Map<String, Object> curRow  = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                addExternalId(curRow);
                mappedData.add(curRow);
            }
            
        } 
        
        //mapper.getDisplayValues(mappedData);
		DataSource.TableResult result;
		result = DataSource.TableResult.get(context, mappedData);
		
		return result;
    }

	
    public DataSource.TableResult search(DataSource.TableSelection context, String searchPhrase){
    	return null;
    }

	
    public List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext context){
    	return null;
    }
    
 	
	public List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext context){
		return null;
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
    		//List<DataSource.Filter> subFilters = filter.subfilters;
    		//this.columnValue = String.valueOf(subFilters[0].columnValue);
    		//if (!subFilters.isEmpty() && subFilters.size() == 1){
    		//	//columnName = subFilters[0].columnName;
    
    		//	if (subFilters[0].columnName == 'Invoice') {	
	     //           keyValues = formatColumnValue(this.columnValue).split('\\.');
	     //           setEndPoint();
	     //       } else {
	     //       	parseMultipleFilters(subFilters);
	     //       }
    		//} else if (subFilters.size() > 1) {
    		//	parseMultipleFilters(subFilters);
    		//}
    	}
    }

    private void addExternalId(Map<String, Object> mappedRow){
		String externalId = '';
		keyValues = new List<Object>();
		for (String s : keyFields){
			keyValues.add(String.valueOf(mappedRow.get(s)));
		}

		externalId = String.join(keyValues, '.');
		mappedRow.put('ExternalId', externalId);

		system.debug(LoggingLevel.INFO, 'keyValues:' + keyValues);
		system.debug(LoggingLevel.INFO, 'ExternalId:' + externalId);
	}

    private void setEndPoint(){
        system.debug('keyValues:' + keyValues);
        if (keyValues.size() == 1) {
        	
        	this.endpoint = '/invoices/details?' + keyValues[0];
        }
        else if (keyValues.size() > 1){
            
            this.endpoint = '/invoices/' + keyValues[0] + '.' + keyValues[1];

        }
    }

    private String formatColumnValue(Object columnValue){
        //replace - with . in case they separate the billRefNo and BillRefResets with a dash
		return String.valueOf(columnValue).replace(kenanSettings.BillRefNo_BillRefResets_delimiter__c, '.');
	}

}