/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanAdjustmentService for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanAdjustmentService implements KenanServiceInterface {
        
    private KenanServiceConnection__c kenanSettings;
    //private JSONGenerator gen;
    private String columnName;
    private String columnValue;
    private String endpoint;
    private KenanAdjustmentMapper mapper;
    private External_Data_Service__mdt keyData;
    private String[] keyFields;
    private Map<String, String> searchParams;
    private String invoiceId;
    private String invoiceItemId;

    public KenanAdjustmentService() {
        kenanSettings = KenanServiceConnection__c.getInstance();
        mapper = new KenanAdjustmentMapper();
        keyData = [SELECT KeyFields__c FROM External_Data_Service__mdt WHERE DeveloperName = 'Adjustment' LIMIT 1];
        keyFields = keyData.KeyFields__c.split(',');
    }

    public DataSource.TableResult query(DataSource.QueryContext context){
        KenanException ke = new KenanException();
        ke.errorMessage = 'KenanAdjustmentService.query has not been implemented';
        ke.errorName = 'KenanAdjustmentService.query has not been implemented';
        throw ke;
    }
    
    public DataSource.TableResult search(DataSource.TableSelection context, String searchPhrase){
        KenanException ke = new KenanException();
        ke.errorMessage = 'KenanAdjustmentService.search has not been implemented';
        ke.errorName = 'KenanAdjustmentService.search has not been implemented';
        throw ke;
    }
    
    public List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext context){
        system.debug(LoggingLevel.DEBUG, 'KenanAdjustmentService.upsertRows entry:' + context);
        List<DataSource.UpsertResult> results = new List<DataSource.UpsertResult>();
        List<Map<String, Object>> rows = context.rows;
        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
        
        for (Map<String, Object> row : rows){
            setEndPoint(row);

            Map<String, Object> copyRow = new Map<String, Object>();
            //copy the row because it's read only
            for (String key : row.keySet()){
                copyRow.put(key, row.get(key));
            }
            mapper.mapEnumeratedValues(copyRow);
            removeUnwantedFields(copyRow);

            String jsonString = JSON.serialize(copyRow);
            HttpResponse response = helper.sendRequest(jsonString, 'POST', endpoint, 0, 100);
            
            if (response.getStatusCode() == 200){
                String jsonContent = response.getBody();
                system.debug('jsonContent:' + jsonContent);
                Map<String, Object> curRow = (Map<String, Object>) JSON.deserializeUntyped(jsonContent);
                String externalId = curRow.get('trackingId') + '.' + curRow.get('trackingIdServ');
                curRow.put('ExternalId', externalId);
                
                results.add(DataSource.UpsertResult.success(externalId));
            
            }
            else {
                if (invoiceItemId == null){
                    results.add(DataSource.UpsertResult.failure(invoiceId, response.getBody()));
                } else {
                    results.add(DataSource.UpsertResult.failure(invoiceId + '.' + invoiceItemId, response.getBody()));
                }
                
            }
        }
        
        return results;
    }
    
    public List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext context){
        KenanException ke = new KenanException();
        ke.errorMessage = 'KenanAdjustmentService.deleteRows has not been implemented';
        ke.errorName = 'KenanAdjustmentService.deleteRows has not been implemented';
        throw ke;
    }

    public KenanObject insertRow(KenanObject contextObject,  String method, String action){
        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
        KenanAdjustment adjustment = (KenanAdjustment) contextObject;
        setEndPoint(adjustment);

        Map<String,Object> objectMap = mapper.getEnumeratedValues(adjustment);
        removeUnwantedFields(objectMap);

        String jsonString = JSON.serialize(objectMap);
        HttpResponse response = helper.sendRequest(jsonString, 'POST', endpoint, 0, 5);
        if (response.getStatusCode() == 200){
            String jsonContent = response.getBody();
            system.debug('jsonContent:' + jsonContent);
            Map<String, Object> curRow = (Map<String, Object>) JSON.deserializeUntyped(jsonContent);
            String externalId = curRow.get('trackingId') + '.' + curRow.get('trackingIdServ');
            curRow.put('ExternalId', externalId);       
            return mapper.getDisplayValues(curRow);
        }
        else {
            KenanException ex = new KenanException(response);
            throw ex;
        }
    }
    
    public KenanObject updateRow(KenanObject contextObject,  String method, String action){
        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
        KenanAdjustment adjustment = (KenanAdjustment) contextObject;
        endpoint = '/invoices/adjustment/' + adjustment.trackingId + '.' + adjustment.trackingIdServ + '?requestStatusAction=' + adjustment.approvalStatus + '&supervisorName=' + EncodingUtil.urlEncode(adjustment.approvedBy, 'UTF-8') ;
        HttpResponse response = helper.sendRequest(null, method, endpoint, 0, 5);
        if (response.getStatusCode() == 200){
            return adjustment;
        }
        else {
            KenanException ex = new KenanException(response);
            throw ex;
        }
    }

    public Boolean deleteRow(KenanObject contextObject){
        KenanException ke = new KenanException();
        ke.errorMessage = 'KenanAdjustmentService.deleteRow has not been implemented';
        ke.errorName = 'KenanAdjustmentService.deleteRow has not been implemented';
        throw ke;
    }

    private void setEndPoint(Map<String, Object> objectMap){
        
        if (objectMap.get('invoiceItem') == '000000000000000'){
            System.debug('Setting endPoint to Invoice Adjustment');
            endPoint = '/invoices/' +invoiceId +  '/adjustment';    
            invoiceId = String.valueOf(objectMap.get('billRefNo')) + '.' + String.valueOf(objectMap.get('billRefResets'));
            invoiceItemId = null;
        } else {
            System.debug('Setting endPoint to Invoice Detail Adjustment');
            String invoiceItem = String.valueOf(objectMap.get('invoiceItem')).replaceAll('-', '.');
            String[] items = invoiceItem.split('\\.');
            invoiceId = items[0] + '.' + items[1];
            invoiceItemId = items[2];
            endPoint = '/invoices/' + invoiceId +  '/details/' + invoiceItemId + '/adjustment';
        }
    }

    private void setEndPoint(KenanAdjustment adjustment){
        System.debug('setEndPoint: adjustment' + adjustment);
        if (adjustment.invoiceItem == '000000000000000' || adjustment.invoiceItem == null){
            invoiceId = adjustment.billRefNo + '.' + adjustment.billRefResets;
            endPoint = '/invoices/' +invoiceId +  '/adjustment';
        } else {
            adjustment.invoiceItem = adjustment.invoiceItem.replaceAll('-', '.');
            String[] items = adjustment.invoiceItem.split('\\.');
            invoiceId = items[0] + '.' + items[1];
            invoiceItemId = items[2];
            endPoint = '/invoices/' + invoiceId +  '/details/' + invoiceItemId + '/adjustment';
        }
    }

    private void removeUnwantedFields(Map<String, Object> row){
        system.debug('removeUnwantedFields:' + row);
        if (row.get('invoiceItem') == null){
            system.debug('removeUnwantedFields:invoiceitem == null');
            row.remove('invoiceItem');
            row.remove('requestStatus');
            row.remove('fraudIndicator');
            row.remove('billRefNo');
            row.remove('billRefResets');
            row.remove('currencyCode');
            row.remove('primaryUnits');
        } 
        else if (row.get('invoiceItem') != null){
            system.debug('removeUnwantedFields:invoiceitem != null');
            row.remove('revRcvCostCtr');
            row.remove('accountExternalId');
            row.remove('accountExternalIdType');
            row.remove('openItemId');
            row.remove('origType');
            row.remove('invoiceItem');

        }

    }
}