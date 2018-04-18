/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Service for use in Salesforce Kenan Connection Service
*/
public class KenanAccountService implements KenanServiceInterface {

    private KenanServiceConnection__c kenanSettings;
    private JSONGenerator jsonGen;
    private KenanAccountMapper accountMapper;
    private KenanAccountItemMapper accountItemMapper;
    private KenanPaymentProfileMapper paymentMapper;
    private String endpoint;
    private String columnName;
    private String columnValue;
    private List<Object> keyValues;
    private String[] keyFields;
    private External_Data_Service__mdt keyData;

    public KenanAccountService(){
        accountMapper = new KenanAccountMapper();
        accountItemMapper = new KenanAccountItemMapper();
        paymentMapper = new KenanPaymentProfileMapper();
        jsonGen = JSON.createGenerator(true);
        kenanSettings = KenanServiceConnection__c.getInstance();    
        keyData = [SELECT KeyFields__c FROM External_Data_Service__mdt WHERE DeveloperName = 'InvoiceItem' LIMIT 1];
        keyFields = keyData.KeyFields__c.split(',');
    }

    public KenanObject insertRow(KenanObject contextAccount,  String method, String action){
        KenanAccount kAccount = (KenanAccount) contextAccount;
        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
        String jsonString = generateCreate(kAccount);
        String endpoint = '/accounts/account';
        Integer startRecord = 0;
        Integer blockSize = 10;
        
        HttpResponse response = helper.sendRequest(jsonString, method, endpoint, startRecord, blockSize);
        if (response.getStatusCode() == 200){
            KenanAccount kaResponse;
            if (String.isEmpty(response.getBody())){
            
            } else {
                Map<String, Object> actMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                kaResponse = deserializeAccount(actMap);
            }
            return kaResponse;  
        } else {
            KenanException ke = new KenanException(response);
            throw ke;
        }
        
    }

    public KenanObject updateRow(KenanObject contextAccount,  String method, String action){
        KenanAccount kAccount = (KenanAccount) contextAccount;
        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
        String endpoint = '';
        String jsonString = '';
        
        endpoint = '/accounts/' + kAccount.salesforceObjectId + '.' + kenanSettings.Default_Account_External_IdType__c;
        jsonString = generateModify(kAccount, action);
                
        KenanLogUtils.log(LoggingLevel.DEBUG, 'updateRow', 'jsonString', jsonString);
        Integer startRecord = 0;
        Integer blockSize = 10;
        HttpResponse response = helper.sendRequest(jsonString, method, endpoint, startRecord, blockSize);
        System.debug(LoggingLevel.ERROR, 'response.getBody():' + response.getBody());

        if (response.getStatusCode() == 200){
            Map<String, Object> actMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            KenanAccount kaResponse = deserializeAccount(actMap);
            return kaResponse;  
        } else {
            KenanException ke = new KenanException(response);
            throw ke;
        }
    }

    public Boolean deleteRow(KenanObject contextAccount){
        KenanAccount kAccount = (KenanAccount) contextAccount;
        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
        String endpoint = '';
        endpoint = '/accounts/' + kAccount.salesforceObjectId + '.' + kenanSettings.Default_Account_External_IdType__c;
        if (kAccount.dateInactive != null) {
            endpoint += '?inactiveDate=' + kAccount.dateInactive.formatGmt('yyyy-MM-dd');
        }

        endpoint += '&disconnectReason=1';

        Integer startRecord = 0;
        Integer blockSize = 10;
        HttpResponse response = helper.sendRequest(null, 'DELETE', endpoint, startRecord, blockSize);

        if (response.getStatusCode() == 200){
            return true;    
        } else {
            KenanException ke = new KenanException(response);
            throw ke;
        }
    }

    public List<KenanAccount> insertHierarchy(List<KenanAccount> accountList){
        List<KenanAccount> kaccounts = (List<KenanAccount>) accountList;
        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
        String jsonString = generateHierarchy(accountList);
        String endpoint = '/accounts/hierarchy';
        String method = 'POST';
        Integer startRecord = 1;
        Integer blockSize = 10;
        
        HttpResponse response = helper.sendRequest(jsonString, method, endpoint, startRecord, blockSize);
        system.debug('response.getBody():' + response.getBody());

        if (response.getStatusCode() == 200){
            List<Object> responseMap = (List<Object>) JSON.deserializeUntyped(response.getBody());
            List<KenanAccount> resAccounts = new List<KenanAccount>();
            for (Object o : responseMap){
                Map<String, Object> actMap = (Map<String, Object>) o;
                resAccounts.add(deserializeAccount(actMap));
            }
            
            KenanLogUtils.logInfo('insertHierarchy exit', resAccounts);
            return resAccounts; 
        } else {
            KenanException ke = new KenanException(response);
            throw ke;
        }
    }

    public DataSource.TableResult query(DataSource.QueryContext context){
        List<Map<String,Object>> mappedData = new List<Map<String,Object>>();
        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
        DataSource.Filter filter = context.TableSelection.Filter;
        setEndPoint(filter);

        HttpResponse response = helper.sendRequest(null, 'GET', this.endpoint, 0, 100);
        Map<String, Object> curRow = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        addExternalId(curRow);
        mappedData.add(curRow);

        DataSource.TableResult result;
        result = DataSource.TableResult.get(context, mappedData);
        return result;
    }

    public DataSource.TableResult search(DataSource.TableSelection context, String searchPhrase){
        KenanException ke = new KenanException();
        ke.errorName = 'KenanAccountService.search has not been implemented';
        ke.errorMessage = 'KenanAccountService.search has not been implemented';
        throw ke;

    }

    public List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext context){
        KenanException ke = new KenanException();
        ke.errorName = 'KenanAccountService.upsertRows has not been implemented';
        ke.errorMessage = 'KenanAccountService.upsertRows has not been implemented';
        throw ke;
    }
    
    public List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext context){
        KenanException ke = new KenanException();
        ke.errorName = 'KenanAccountService.deleteRows has not been implemented';
        ke.errorMessage = 'KenanAccountService.deleteRows has not been implemented';
        throw ke;
    }


    private String generateCreate(KenanAccount ka){
        jsonGen.writeStartObject();
        addSFOrgId();
        addAccount(ka);
        addPaymentProfile(ka.paymentProfile);
        jsonGen.writeEndObject(); 
        String jsonString = jsonGen.getAsString();
        return jsonString;
    }

    private String generateModify(KenanAccount ka, String action){
        jsonGen.writeStartObject();
        addAccount(ka);
        addAction(action);
        jsonGen.writeEndObject();
        String jsonString = jsonGen.getAsString();
        return jsonString;
    }

    private String generateHierarchy(List<KenanAccount> accountList){
        jsonGen.writeStartObject();
        addSFOrgId();
        addHierarchyWrapper();
        jsonGen.writeStartArray();
        for(KenanAccount ka : accountList){
            jsonGen.writeStartObject();
            addAccount(ka);
            addPaymentProfile(ka.paymentProfile);
            jsonGen.writeEndObject();
        }
        jsonGen.writeEndArray();
        
        String jsonString = jsonGen.getAsString();
        return jsonString;
    }

    private void addSFOrgId(){
        jsonGen.writeStringField('salesforceOrgId', UserInfo.getOrganizationId());  
    }

    private void addHierarchyWrapper(){
        jsonGen.writeFieldName('accountPPWrappers');
    }

    private void addAccount(KenanAccount ka){
        jsonGen.writeFieldName('accountLocateObjectDataInputWrapper');
        Map<String, Object> accountMap = accountMapper.getEnumeratedValues(ka);
        jsonGen.writeObject(accountMap);
    }

    private void addPaymentProfile(KenanPaymentProfile paymentProfile){
        if (paymentProfile != null) {
            jsonGen.writeFieldName('profile');
            Map<String, Object> paymentProfileMap = paymentMapper.getEnumeratedValues(paymentProfile);
            jsonGen.writeObject(paymentProfileMap);
        }
    }

    private void addAction(String action){
        jsonGen.writeStringField('action', action); 
    }


    private KenanAccount deserializeAccount(Map<String, Object> accountMap){
        KenanAccount act = accountMapper.getDisplayValues(accountMap);

        KenanLogUtils.logInfo('deserializeAccount exit', act);
        return act;
    }

    private void setEndPoint (DataSource.Filter filter){
        system.debug('filter:' + filter);

        if (filter.columnName != null && filter.columnValue != null){
            System.debug('setEndpoint main filter:' + filter.columnValue);
            this.columnValue = String.valueOf(filter.columnValue);
            system.debug('columnValue:' + columnValue);
            keyValues = this.columnValue.split('\\.');
            setEndPoint();
        } else {
            //List<DataSource.Filter> subFilters = filter.subfilters;
            //this.columnValue = String.valueOf(subFilters[0].columnValue);
            //if (!subFilters.isEmpty() && subFilters.size() == 1){
            //  //columnName = subFilters[0].columnName;
    
            //  if (subFilters[0].columnName == 'Invoice') {    
         //           keyValues = formatColumnValue(this.columnValue).split('\\.');
         //           setEndPoint();
         //       } else {
         //         parseMultipleFilters(subFilters);
         //       }
            //} else if (subFilters.size() > 1) {
            //  parseMultipleFilters(subFilters);
            //}
        }
    }

    private void setEndPoint(){
        system.debug('keyValues:' + keyValues);
        if (keyValues.size() == 1) {
            // Search
            this.endpoint = '/accounts/' + keyValues[0];
        }

        if (keyValues.size() > 1){
            // all details
            this.endpoint = '/accounts/' + keyValues[0] + '.' + keyValues[1];

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

    private void generateAccountLines(List<KenanAccountItem> items){
        if (!items.isEmpty()){
            jsonGen.writeFieldName('accountItems');
            List<Map<String, Object>> accountItems = new List<Map<String, Object>>();
            for (KenanAccountItem item : items){
                accountItems.add(accountItemMapper.getEnumeratedValues(item));
            }
            jsonGen.writeObject(accountItems);
        }
        
    }
}