/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanServiceService for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanServiceService implements KenanServiceInterface {
    
    private KenanServiceConnection__c kenanSettings;
    private JSONGenerator jsonGen;
    private KenanServiceMapper serviceMapper;
    private KenanServiceItemMapper serviceItemMapper;

    public KenanServiceService() {
        jsonGen = JSON.createGenerator(true);
        kenanSettings = KenanServiceConnection__c.getInstance();
        serviceMapper = new KenanServiceMapper();
        serviceItemMapper = new KenanServiceItemMapper();
    }

    public KenanObject insertRow(KenanObject contextObject,  String method, String action){
        KenanService service = (KenanService) contextObject;
        String jsonString = generateCreate(service);    
        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
        String endpoint = '/services/service';
        Integer startRecord = 0;
        Integer blockSize = 10;
        HttpResponse response = helper.sendRequest(jsonString, method, endpoint, startRecord, blockSize);
        if (response.getStatusCode() == 200){
            KenanService responseService;
            if (String.isEmpty(response.getBody())){
                
            } else {
                Map<String, Object> serviceMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                responseService = serviceMapper.getDisplayValues(serviceMap);
            }
            return responseService; 
        }
        else {
            KenanException ke = new KenanException(response);
            throw ke;
        }
    }
    
    public List<KenanObject> insertRows(List<KenanObject> contextObjects,  String method, String action){
        List<KenanService> services = (List<KenanService>) contextObjects;
        String jsonString = generateCreate(services);       
        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
        String endpoint = '/services/services';
        Integer startRecord = 0;
        Integer blockSize = 10;
        HttpResponse response = helper.sendRequest(jsonString, method, endpoint, startRecord, blockSize);
        system.debug('response.getBody():' + response.getBody());

        if (response.getStatusCode() == 200){
            List<Object> responseMap = (List<Object>) JSON.deserializeUntyped(response.getBody());
            List<KenanService> resServices = new List<KenanService>();
            for (Object o : responseMap){
                Map<String, Object> serviceMap = (Map<String, Object>) o;
                resServices.add(serviceMapper.getDisplayValues(serviceMap));
            }
        return resServices;
        } else {
            KenanException ke = new KenanException(response);
            throw ke;
        }
    }

    public KenanObject updateRow(KenanObject contextObject,  String method, String action){
        KenanService service = (KenanService) contextObject;
        String jsonString = generateModify(service);    
        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
        String endpoint = '/services/' + service.salesforceObjectId + '.' + kenanSettings.Default_Service_External_IdType__c;
        Integer startRecord = 0;
        Integer blockSize = 10;
        HttpResponse response = helper.sendRequest(jsonString, method, endpoint, startRecord, blockSize);
        if (response.getStatusCode() == 200){
            KenanService responseService;
            if (String.isEmpty(response.getBody())){
                
            } else {
                Map<String, Object> serviceMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                responseService = serviceMapper.getDisplayValues(serviceMap);
            }   
            return responseService;
        } else  {
            KenanException ke = new KenanException(response);
            throw ke;
        }
    }

    public Boolean deleteRow(KenanObject contextObject){
        //This will cease a service in the Kenan Billing System
        KenanService service = (KenanService) contextObject;
        KenanHTTPConnectionHelper helper = new KenanHTTPConnectionHelper();
        
        Map<String, Object> serviceMap = serviceMapper.getEnumeratedValues(service);
        
        String dateString = service.disconnectDate.format('yyyy-MM-dd\'T \'HH:mm:ss.SSSZ');
        
        String endpoint = '/services/' + service.salesforceObjectId + '.' + kenanSettings.Default_Service_External_IdType__c + '?discoReason=' + EncodingUtil.urlEncode(String.valueOf(serviceMap.get('disconnectReason')), 'UTF-8') + '&discoDate=' + EncodingUtil.urlEncode(String.valueOf(dateString), 'UTF-8');
        
        
        
        if (serviceMap.get('waiveInstallmentNrc') != null){
            endpoint = endpoint + '&waiveInstallmentNrc=' + serviceMap.get('waiveInstallmentNrc');
        }

        if (serviceMap.get('waiveUnbilledNrc') != null){
            endpoint = endpoint + '&waiveUnbilledNrc=' + serviceMap.get('waiveUnbilledNrc');
        }

        if (serviceMap.get('waiveTerminationObligation') != null){
            endpoint = endpoint + '&waiveTerminationObligation=' + serviceMap.get('waiveTerminationObligation');
        }

        if (serviceMap.get('waiveUnmetObligation') != null){
            endpoint = endpoint + '&waiveUnmetObligation=' + serviceMap.get('waiveUnmetObligation');
        }

        if (serviceMap.get('waiveRefinanceNrc') != null){
            endpoint = endpoint + '&waiveRefinanceNrc=' + serviceMap.get('waiveRefinanceNrc');
        }

        Integer startRecord = 0;
        Integer blockSize = 10;
        String method = 'DELETE';
        HttpResponse response = helper.sendRequest(null, method, endpoint, startRecord, blockSize);
        if (response.getStatusCode() == 200) {
            return true;
        } else {
            KenanException ke = new KenanException(response);
            throw ke;
        }
        
    }

    public DataSource.TableResult query(DataSource.QueryContext context){
        KenanException ke = new KenanException();
        ke.errorName = 'KenanServiceService.query has not been implemented';
        ke.errorMessage = 'KenanServiceService.query has not been implemented';
        throw ke;
    }

    public DataSource.TableResult search(DataSource.TableSelection context, String searchPhrase){
        KenanException ke = new KenanException();
        ke.errorName = 'KenanServiceService.search has not been implemented';
        ke.errorMessage = 'KenanServiceService.search has not been implemented';
        throw ke;

    }

    public List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext context){
        KenanException ke = new KenanException();
        ke.errorName = 'KenanServiceService.upsertRows has not been implemented';
        ke.errorMessage = 'KenanServiceService.upsertRows has not been implemented';
        throw ke;
    }
    
    public List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext context){
        KenanException ke = new KenanException();
        ke.errorName = 'KenanServiceService.deleteRows has not been implemented';
        ke.errorMessage = 'KenanServiceService.deleteRows has not been implemented';
        throw ke;
    }       

    private String generateCreate(KenanService service){
        jsonGen.writeStartObject();
        generateAccountId(service.sfdcAccountId);
        generateService(service);
        generateServiceLines(service.serviceItems);
        jsonGen.writeEndObject();
        String jsonString = jsonGen.getAsString();
        return jsonString;
    }   

    private String generateCreate(List<KenanService> services){
        jsonGen.writeStartArray();

        for (KenanService service: services) {
            jsonGen.writeStartObject();
            generateAccountId(service.sfdcAccountId);
            generateService(service);
            generateServiceLines(service.serviceItems);
            jsonGen.writeEndObject();
        }
        
        jsonGen.writeEndArray();

        String jsonString = jsonGen.getAsString();
        return jsonString;
    }
    
    private String generateModify(KenanService service){
        Map<String, Object> serviceMap = serviceMapper.getEnumeratedValues(service);
        removeUnwantedFields(serviceMap);
        jsonGen.writeObject(serviceMap);
        String jsonString = jsonGen.getAsString();
        return jsonString;
    }

    private void generateAccountId(String accountId){
        jsonGen.writeFieldName('accountExternalId');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('type', kenanSettings.Default_Account_External_IdType__c);
        jsonGen.writeStringField('value', accountId);
        jsonGen.writeEndObject();
    }

    private void generateService(KenanService service){
        Map<String, Object> serviceMap = serviceMapper.getEnumeratedValues(service);
        removeUnwantedFields(serviceMap);
        jsonGen.writeFieldName('service');
        jsonGen.writeObject(serviceMap);
    }
    
    private void generateServiceLines(List<KenanServiceItem> items){
        if (!items.isEmpty()){
            jsonGen.writeFieldName('serviceItems');
            List<Map<String, Object>> serviceItems = new List<Map<String, Object>>();
            for (KenanServiceItem item : items){
                serviceItems.add(serviceItemMapper.getEnumeratedValues(item));
            }
            jsonGen.writeObject(serviceItems);
        }
        
    }

    private void removeUnwantedFields(Map<String, Object> serviceMap){
        serviceMap.remove('waiveInstallmentNrc');
        serviceMap.remove('waiveUnbilledNrc');
        serviceMap.remove('waiveTerminationObligation');
        serviceMap.remove('waiveUnmetObligation');
        serviceMap.remove('waiveRefinanceNrc');
    }
}