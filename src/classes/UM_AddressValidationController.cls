public class UM_AddressValidationController implements LG_AddressValidation {

    public PageReference cancel() {
        return new pagereference(returnURL);
    }

    public final Integer TIMEOUT_X = 2000;
    public final String ENDPOINT_X = 'callout:UM_SpiderWS/TopasWS/TopasWSService';
    
    String objectType;
    String recordID;
    public String recordCountry;
    public String returnURL {get; set;}
    public Map<String,String> searchField {get; set;}
    public List<String> searchFieldS {get; set;}
    public String selectedAddressID {get; set;}
    public mapAndDisplay mapAndDisplaySetting {get; set;}
    public sObject validationRecord {get; set;}
    public Boolean invalidSetting {get; set;}
    public Boolean outsideAddressValidationpage {get; set;}
    public UM_MACDConfigurationController macdConfController {get; set;}
    public UM_AddressResponse addressResponse {get; set;}
    settingInfo settingData = new settingInfo();
    public Boolean isQuickCreatePremise=false;
    public string accId;
    public string prodDefId;    
    public string lookupId;
    public boolean invalidCountry{get;set;}
 
    /*
        Constructor when this class is set as the primary controller of a Visualforce page
    */
    public UM_AddressValidationController() {
    	invalidCountry=false;
        recordID = ApexPages.currentPage().getParameters().get('id');
        recordCountry = ApexPages.currentPage().getParameters().get('country');
        prodDefId=ApexPages.currentPage().getParameters().get('productDefinitionId');
        accId = ApexPages.currentPage().getParameters().get('accId');
        lookupId=ApexPages.currentPage().getParameters().get('lookupId');
        string isQCP=ApexPages.currentPage().getParameters().get('isQuickCreatePremise');
        
        if(recordCountry==null || recordCountry!='Germany'){
        	invalidCountry=true;
        }
        
        if('true'==isQCP) isQuickCreatePremise=true;
        
        boolean isFromMacd = false;
        
        //if used as a component outside the AddressValidation page where id is an accountID    
        if (String.isBlank(recordId) )
        {
            isFromMacd = true;
            recordID = ApexPages.currentPage().getParameters().get('accountId');
            
            if (String.isNotBlank(recordId) && String.isBlank(recordCountry))
            {
                recordCountry = 'Germany';
                invalidCountry=false;
            }                        
        }
        
        if(isQuickCreatePremise){
        	isFromMacd=false;
        	recordID = ApexPages.currentPage().getParameters().get('Id');
        }
        
        returnURL = ApexPages.currentPage().getParameters().get('returnURL');
        try{

            objectType = LG_AddressValidationHelper.findObjectNameFromRecordIdPrefix(recordID);
            retrieveSearchSettings(objectType, recordCountry);

        } catch (Exception ex) {
            invalidSetting = true;

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, Label.UM_InvalidSFID));
            return;
        }     
        searchField = LG_AddressValidationHelper.readFieldSet(settingData.fieldSet, objectType);
        retrieveCurrentData(searchField.keySet() , objectType, recordID);
        sequenceSearch();		
        if (!isFromMacd) {
            findAddress();    
        }
    }
	   

    public void sequenceSearch(){
            searchFieldS = new List<String>();
            searchFieldS.addAll( searchField.keySet() );
    }
    
    /*

    */
    public void retrieveSearchSettings(String objectName, String country) {
        //loop not needed
        String strUrlUTF8; String displayMapJson;        
        LG_AddressValidationSetup__mdt tempVar = [Select LG_FieldSetName__c, LG_DisplayConfiguration__c from LG_AddressValidationSetup__mdt where LG_Country__c = :country AND LG_Object__c = :objectName limit 1];

        String StaticResourceName;
        if(tempVar != null) {
            settingData.validSettingFound = true;
            settingData.fieldSet = tempVar.LG_FieldSetName__c;
            StaticResourceName = tempVar.LG_DisplayConfiguration__c;
        }

        StaticResource displayMapBlob = [Select body, name from StaticResource where Name = :StaticResourceName]; 

        strUrlUTF8 = displayMapBlob.body.toString();
        displayMapJson = EncodingUtil.urlDecode(strUrlUTF8, 'UTF-8'); 

        mapAndDisplaySetting = (mapAndDisplay)JSON.deserialize(displayMapJson, mapAndDisplay.class);
        system.assert(settingData.validSettingFound && settingData.fieldSet!= '', 'No valid configuration found!');
    }

    void retrieveCurrentData(Set<String> searchField, String objectName, String recordID) {
        String query = 'Select ';
        Integer i = 1;
        for(String loopVar : searchField) {
            i++;
            query += loopVar;
            if(i <= searchField.size()) {
                query += ',';
            }
        }
        query += ' from ' + objectType + ' where ID=' +'\'' + recordID + '\'';
        validationRecord = (sObject)Database.query(query);
    }

    /* To be reused or Deleted*/
    public void findAddress () {

        ApexPages.getMessages().clear();

        if( LG_EnvironmentVariables__c.getOrgDefaults().LG_AddressSearchLocal__c == true ) {
            //findAddressLocal ();
        } else if(objectType!='cscrm__Address__c' && validationRecord.get('LG_VisitPostalCode__c') != null && validationRecord.get('LG_VisitHouseNumber__c') != null){
            findAddressTopas ();
        }
         else if(objectType=='cscrm__Address__c' && validationRecord.get('cscrm__Zip_Postal_Code__c') != null && validationRecord.get('LG_HouseNumber__c') != null){
            findAddressTopas ();
        }
    }

    /**
     * Description: Call spider webservice to validate address against Topas database
     */
    public void findAddressTopas() { 

        UM_AddressResponse.TopasWSPort ws = new UM_AddressResponse.TopasWsPort();
        ws.timeout_x = TIMEOUT_X;
        ws.endpoint_x = ENDPOINT_X;

        Map<String, String> searchParams = new Map<String, String>();
        for(fieldMap loopVar : mapAndDisplaySetting.fieldMap) {
            if(loopVar.searchFilter && validationRecord.get(loopVar.sfFieldName) != null) {
                
                searchParams.put(loopVar.webServiceParam, ((String)validationRecord.get(loopVar.sfFieldName)));
            }
        }

        String systemId = '';
        Integer maxRecords = 100;
        Integer startRecord = 0;

        UM_WebserviceCredentials__c loginCredentials = UM_WebserviceCredentials__c.getValues('UM_TopasWS');

        try {
            UM_AddressResponse.addressesExt res = ws.addressSearchExt(systemId, maxRecords, startRecord, searchParams, loginCredentials.login__c, loginCredentials.password__c);

            addressResponse = new UM_AddressResponse();
            addressResponse.addressExt = new List<UM_AddressResponse.addressExt>();
            addressResponse.addressExt = (List<UM_AddressResponse.addressExt>)res.address;

        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.UM_GenericError));      
        }
    }
   
    /**
     * TODO: Bypass webservice 
     */
    public void findAddressLocal () {
 
    }

    /**
     * Update address data
     * @return PageReference
     */
    public pagereference setAddress() {
        
        Boolean isUpsert=false;
        UM_AddressResponse.addressExt selectAddress = new UM_AddressResponse.addressExt();
        for(UM_addressResponse.addressExt loopVar:addressResponse.addressExt){            
            if(String.valueOf(loopVar.buildingId) == selectedAddressID)
                selectAddress = loopVar;
        }
		
		if(selectAddress!=null && selectedAddressID!=null && accId!=null && isQuickCreatePremise){
			list<cscrm__Address__c> addRecord=[Select Id, LG_AddressID__c, cscrm__Account__c from cscrm__Address__c where LG_AddressID__c=:selectedAddressID AND cscrm__Account__c=:accId limit 1];
			if(!addRecord.isEmpty()){
				validationRecord.put('Id',addRecord[0].Id);
				cscrm__Address__c deleteAddRecord=new cscrm__Address__c(id=recordID); 
				delete deleteAddRecord;
				recordId=addRecord[0].Id;
				isUpsert=true;
			}
		}
		
        if (outsideAddressValidationpage) {

            if (macdConfController.validateAddress) {
                update new cscrm__Address__c(Id = macdConfController.validateSiteId,
                                                LG_AddressID__c = selectAddress.buildingId);
            } else {
                macdConfController.moveSite = new UM_AddressResponse.OptionalsJson(selectAddress);
            }
            return null;            
        }    
         else {

            for(fieldMap loopVar : mapAndDisplaySetting.fieldMap) {
                if(selectAddress.get(loopVar.soapField) != null) {
                    //Added temporarily by Shashank. To be discussed with Robert to look for a better solution.
                    if(loopVar.sfFieldName=='UM_VisitGeolocation__latitude__s' || loopVar.sfFieldName=='UM_VisitGeolocation__longitude__s'){
                        validationRecord.put(loopVar.sfFieldName , decimal.valueOf(selectAddress.get(loopVar.soapField).replace(',', '.')));
                    }
                    else if(loopVar.sfFieldName=='cscrm__Geolocation__latitude__s' || loopVar.sfFieldName=='cscrm__Geolocation__longitude__s'){
                        validationRecord.put(loopVar.sfFieldName , decimal.valueOf(selectAddress.get(loopVar.soapField).replace(',', '.')));
                    }
                    else {
                        validationRecord.put(loopVar.sfFieldName , selectAddress.get(loopVar.soapField));    
                    }                    
                } else {
                    validationRecord.put(loopVar.sfFieldName , selectAddress.getServiceability(loopVar.soapField));
                }
            	if(isQuickCreatePremise){
            		if(accId!=null){
            			account acc=new Account(id=accId);
            			validationRecord.put('cscrm__Account__c',acc.Id);
            		}
            		string nm=string.valueOf(selectAddress.get('zip'))+string.valueOf(selectAddress.get('streetNo'));
            		if(selectAddress.get('streetNoSuffix')!=null)
            		nm+=string.valueOf(selectAddress.get('streetNoSuffix'));            		
            		validationRecord.put('Name',nm);   
            		validationRecord.put('cscrm__Country__c',recordCountry);         		
            	}
            }

            try {
            	if(isUpsert){
            		upsert validationRecord;
            	}
            	else {
            		update validationRecord;	
            	}
                
            } catch (exception ex){
                    String errorMessage = ex.getMessage();
                    Integer occurence;
                    if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                        occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
                        errorMessage = errorMessage.mid(occurence, errorMessage.length());
                        occurence = errorMessage.lastIndexOf(':');
                        errorMessage = errorMessage.mid(0, occurence);
                    }
                    else {
                        errorMessage = ex.getMessage();
                    }
                    system.debug('ERROR: '+ errorMessage);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            }
                                    
            
            if(isQuickCreatePremise){
				returnURL='/apex/cscfga__Lookup?lookupId='+lookupId+'&productDefinitionId='+prodDefId+'&attributeValues=Account Id='+accId+'&excludeIds=';
            	cscrm__Address__c updatedAddress=[select Id,cscrm__Street__c, LG_FullAddressDetails__c from cscrm__Address__c where id =:recordId];
            	if(updatedAddress!=null){
            		returnURL=returnURL+'&searchValue='+updatedAddress.cscrm__Street__c;
            	}            
            }            
            return (new pagereference(returnURL));
        }
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
     * Description : This class captures settings for mapping of Salesforce to JSON fields and also the the display setting on the address search layout.
     */
    class mapAndDisplay {
        public boolean isActive;
        public List<fieldMap> fieldMap{get;set;}
    }

    /**
     *
     */
    class fieldMap {
        public String sfFieldName{get;set;}
        public String jsonField{get;set;}
        public String soapField{get;set;}
        public Boolean resultVisible{get;set;}
        public String displayLabel{get;set;}
        public Boolean searchFilter{get;set;}
        public Boolean requiredParam{get;set;}
        public String webServiceParam{get;set;}
    }
}