/**
 * Service availibility controller
 */
public without sharing class UM_ServiceAvailabilityController {
    
    // Service availability information, contains service name and boolean flag
    public class ServiceAvailability {
            
        public final String serviceName {get; private set;}
        public final Boolean available {get; private set;}
            
        public ServiceAvailability(String serviceName, Boolean available) {
            this.serviceName = serviceName;
            this.available = available;
        }    
    }

    public final Integer TIMEOUT_X = 2000;
    public final String ENDPOINT_X = 'callout:UM_SpiderWS/TopasWS/TopasWSService';

    public Boolean addrValidated {get;set;}

    // Extension code set by attribute
    public String buildingIdAttribute {get; set;}
    public String buildingId {
        get {
            if(buildingId == null) {
                buildingId = ((buildingIdAttribute != null) ? buildingIdAttribute : '');
            }
            return buildingId;
        }
        private set;
    }

    public Id recordIdAttribute {
        get;
        set {
            recordIdAttribute = value;
            setServiceAvailibility();
        }
    }
    
    public String errorMessage {get; private set;}
    
    public List<ServiceAvailability> serviceAvailabilityInformation {
        get {
            if (serviceAvailabilityInformation == null) {
                serviceAvailabilityInformation = new List<ServiceAvailability>();
            }
            return serviceAvailabilityInformation;
        }
        private set;
    }
    public mapAndDisplay mapAndDisplaySetting {get; set;}
    settingInfo settingData = new settingInfo();
    public sObject currentlyAvailable {get;set;}

    public UM_ServiceAvailabilityController() {
        // Do nothing...

    }

    /**
     * Retrieve display settings for serviceability - query custom
     * metadata and get static resource json with settings
     * @param objectName - name of the object 
     */
    public void retrieveDisplaySettings(String objectName) {

        String strUrlUTF8; String displayMapJson;
        UM_ServiceabilitySetup__mdt tempVar = [Select UM_FieldSetName__c, UM_DisplayConfiguration__c from UM_ServiceabilitySetup__mdt where UM_Object__c = :objectName limit 1];

        String StaticResourceName;
        if(tempVar != null) {
            settingData.validSettingFound = true;
            settingData.fieldSet = tempVar.UM_FieldSetName__c;
            StaticResourceName = tempVar.UM_DisplayConfiguration__c;
        }

        StaticResource displayMapBlob = [Select body, name from StaticResource where Name = :StaticResourceName]; 

        strUrlUTF8 = displayMapBlob.body.toString();
        displayMapJson = EncodingUtil.urlDecode(strUrlUTF8, 'UTF-8'); 
        mapAndDisplaySetting = (mapAndDisplay)JSON.deserialize(displayMapJson, mapAndDisplay.class);
    }

    /**
     * Set service availibility information based on saved data
     */
    public void setServiceAvailibility() {

        if(recordIdAttribute != null) {

            String sObjName = recordIdAttribute.getSObjectType().getDescribe().getName();
            retrieveDisplaySettings( sObjName );
            if(mapAndDisplaySetting.fieldMap.size() > 0){

                getServiceAvailibility(mapAndDisplaySetting.fieldMap, sObjName, recordIdAttribute);
                if(currentlyAvailable != null) {
                    
                    addrValidated = (currentlyAvailable.get('LG_AddressValidated__c') == true) ? true : false;

                    for(fieldMap loopVar : mapAndDisplaySetting.fieldMap) {
                        serviceAvailabilityInformation.add(new ServiceAvailability(loopVar.displayLabel, Boolean.valueOf( currentlyAvailable.get(loopVar.sfFieldName) ) ) );
                    }
                }
            }

        }
    }

    /**
     * Prepare query to get service availibility information from the object
     * @param listOfFields List of fields to query
     * @param sObjName     Name of the object to query
     * @param recordId     RecordId
     */
    private void getServiceAvailibility(List<fieldMap> listOfFields, String sObjName, String recordId) {

            currentlyAvailable = null;
            String query = 'Select LG_AddressValidated__c, ';
            Integer i = 1;
            for(fieldMap loopVar : listOfFields) {
                i++;
                query += loopVar.sfFieldName;
                if(i <= listOfFields.size()) {
                    query += ',';
                }
            }
            query += ' from ' + sObjName + ' where Id=' +'\'' + recordId + '\'';
            currentlyAvailable = (sObject)Database.query( query );
    }

    /**
     * Invoke external web service and update availability information
     */
    public void updateServiceAvailability() {

        serviceAvailabilityInformation = null;
        errorMessage = null;
        String normalizedBuildingId = buildingId.trim();
        if (normalizedBuildingId.length() > 0) {

            String sObjName = recordIdAttribute.getSObjectType().getDescribe().getName();
            retrieveDisplaySettings( sObjName );
            getServiceAvailibility(mapAndDisplaySetting.fieldMap, sObjName, recordIdAttribute);

            UM_AddressResponse.TopasWSPort ws = new UM_AddressResponse.TopasWsPort();
            ws.timeout_x = TIMEOUT_X;
            ws.endpoint_x = ENDPOINT_X;
 
            Map<String, String> searchParams = new Map<String, String>();
            searchParams.put('buildingId', EncodingUtil.urlEncode(normalizedBuildingId, 'UTF-8'));

            String systemId = '';
            Integer maxRecords = 100;
            Integer startRecord = 0;

            UM_WebserviceCredentials__c loginCredentials = UM_WebserviceCredentials__c.getValues('UM_TopasWS');
            try {
                UM_AddressResponse.addressesExt res = ws.addressSearchExt(systemId, maxRecords, startRecord, searchParams, loginCredentials.login__c, loginCredentials.password__c);

                UM_AddressResponse addressResponse = new UM_AddressResponse();
                addressResponse.addressExt = new List<UM_AddressResponse.addressExt>();
                addressResponse.addressExt = (List<UM_AddressResponse.addressExt>)res.address;
  
                sObject toUpdate = parseServiceAvailabilityResponse( addressResponse.addressExt.get(0) );               
                update toUpdate;

            }  catch (Exception e) {
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.UM_GenericError));
            }

        } else {

            errorMessage = Label.LG_FillOutRequired;
        }

        //return null;
    }
    
    /**
     * Parse JSON response containing service availability data
     * @param  res Object containing WS response data 
     * @return sObject
     */
    private sObject parseServiceAvailabilityResponse(UM_AddressResponse.addressExt res) {

        for(fieldMap loopVar : mapAndDisplaySetting.fieldMap) {

            currentlyAvailable.put(loopVar.sfFieldName, res.getServiceability(loopVar.soapField));
        }

        return currentlyAvailable;
    }

    /**
     * Description : This sclass captures from settings from custom metadata type valid for current object and country.
     */
    class settingInfo {
        public boolean validSettingFound;
        public String fieldSet;
        public settingInfo () {
            validSettingFound = false;
            fieldSet = '';
        }
    }

    /**
     * Description : This class captures settings for mapping of Salesforce to SOAP fields and also the the display setting on the address search layout.
     */
    class mapAndDisplay {
        public boolean isActive;
        public List<fieldMap> fieldMap{get;set;}
    }

    /**
     * Description : List of fields
     */
    class fieldMap {
        public String sfFieldName{get;set;}
        public String displayLabel{get;set;}
        public String soapField{get;set;}
    }    
}