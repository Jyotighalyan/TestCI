public with sharing class LG_AddressValidationController {

    public PageReference cancel() {
        return new pagereference(returnURL);
    }

    
    String objectType;
    String recordID;
    public String recordCountry;
    public String returnURL{get;set;}
    public Map<String,String> searchField{get;set;}
    public Map<Integer,String> searchFieldSeq{get;set;}
    public List<String> searchFieldS{get;set;}
    settingInfo settingData = new settingInfo();
    public LG_AddressResponse addressResponse{get;set;}
    public String selectedAddressID{get;set;}
    public mapAndDisplay mapAndDisplaySetting{get;set;}
    String[] tableDisplayFields;
    Integer loopCount;
    public List<Add_ToBeDel__c> addressSuggestion{get;set;}
    public ID selectedAddress{get;set;}
    public sObject validationRecord{get;set;}
    public Boolean invalidSetting {get;set;}
    public Boolean outsideAddressValidationpage {get; set;}
    public LG_MACDConfigurationController macdConfController {get; set;}

    /*
        Constructor when this class is set as the extension of a Visualforce page
    */
    public LG_AddressValidationController(ApexPages.StandardController controller) {
        recordID = ApexPages.currentPage().getParameters().get('id');
        recordCountry = ApexPages.currentPage().getParameters().get('country');

        try{
            objectType = findObjectNameFromRecordIdPrefix(recordID);
            retrieveSearchSettings(objectType, recordCountry);
        } catch (Exception ex) {
            invalidSetting = true;

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, Label.UM_InvalidSFID));
            return;
        }
        searchField = readFieldSet(settingData.fieldSet, objectType);
        retrieveCurrentData(searchField.keySet() , objectType, recordID);
        sequenceSearch();
        findAddress();
    }

    /*
        Constructor when this class is set as the primary controller of a Visualforce page
    */
    public LG_AddressValidationController() {
        recordID = ApexPages.currentPage().getParameters().get('id');
        recordCountry = ApexPages.currentPage().getParameters().get('country');
        boolean isFromMacd = false;

        //if used as a component outside the AddressValidation page where id is an accountID    
        if (String.isBlank(recordId))
        {
            isFromMacd = true;
            recordID = ApexPages.currentPage().getParameters().get('accountId');
            if (String.isNotBlank(recordId) && String.isBlank(recordCountry))
            {
                Account acc = [SELECT Id, LG_VisitCountry__c FROM Account WHERE Id = :recordId];
                recordCountry = acc.LG_VisitCountry__c;
                if (String.isBlank(recordCountry))
                {
                    LG_EnvironmentVariables__c enviornmentSettings = LG_EnvironmentVariables__c.getInstance();
                    recordCountry = enviornmentSettings.IdField_BillingCountry__c;
                    //recordCountry = 'Netherlands';
                }
            }
        }
 
        returnURL = ApexPages.currentPage().getParameters().get('returnURL');
        try{
            objectType = findObjectNameFromRecordIdPrefix(recordID);
            retrieveSearchSettings(objectType, recordCountry);
        } catch (Exception ex) {
            invalidSetting = true;

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, Label.UM_InvalidSFID));
            return;
        }     
        searchField = readFieldSet(settingData.fieldSet, objectType);
        retrieveCurrentData(searchField.keySet() , objectType, recordID);
        sequenceSearch();
        if (!isFromMacd)
        {
            findAddress();    
        }
    }

    public void sequenceSearch(){
            searchFieldS = new List<String>();
            searchFieldS = searchFieldSeq.values();
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

        strUrlUTF8 = displayMapBlob.body.toString(); System.debug('String strUrlUTF8: [' + strUrlUTF8 + ']'); 
        displayMapJson = EncodingUtil.urlDecode(strUrlUTF8, 'UTF-8'); 
        system.debug('JSON Start' + displayMapJson + 'JSON Stop');

        mapAndDisplaySetting = (mapAndDisplay)JSON.deserialize(displayMapJson, mapAndDisplay.class);

        system.assert(settingData.validSettingFound && settingData.fieldSet!= '', 'No valid configuration found!');
    }

    void retrieveCurrentData(Set<String> searchField, String objectName, String recordID) {
        String query = 'Select ';
        loopCount = 1;
        for(String loopVar : searchField) {
            loopCount++;
            query += loopVar;
            if(loopCount <= searchField.size()) {
                query += ',';
            }
        }
        query += ' from ' + objectType + ' where ID=' +'\'' + recordID + '\'';
        validationRecord = (sObject)Database.query(query);
        system.debug(' The Query' + validationRecord + ' The Query');
    }


    /* To be reused or Deleted*/
    public void findAddress () {
        ApexPages.getMessages().clear();
        if( LG_EnvironmentVariables__c.getOrgDefaults().LG_AddressSearchLocal__c == true || Test.isRunningTest() ) {
            findAddressLocal ();
        } else if(validationRecord.get('LG_VisitCountry__c') != null && validationRecord.get('LG_VisitPostalCode__c') != null && validationRecord.get('LG_VisitHouseNumber__c') != null){
            findAddressPeal ();
        }
    }

    public void findAddressPeal() {
        String requestURL = 'callout:LG_OracleAccessGateway/peal/api/b2b/addresses?cty=NL&chl=B2B_CATALYST_NL&';//&houseFlatNumber=20&postcode=3572RE';//'callout:LG_OracleAccessGateway/peal/api/b2b/addresses?';//LG_EnvironmentVariables__c.getOrgDefaults().LG_PealAddressServiceURL__c;
        Integer loopCount = 0;
        Boolean paramAdded = false;

        for(fieldMap loopVar : mapAndDisplaySetting.fieldMap) {
            //paramAdded =false;
            if(loopVar.searchFilter && validationRecord.get(loopVar.sfFieldName) != null) {
                requestURL += loopVar.webServiceParam;
                requestURL += ('=' + ((String)validationRecord.get(loopVar.sfFieldName)).replaceAll( '\\s+', ''));
                paramAdded = true;
            }
            loopCount++;
            if(mapAndDisplaySetting.fieldMap.size() > loopCount && paramAdded){
                requestURL += '&';
                paramAdded =false;
            }
        }
        system.debug('URL FORMED' + requestURL);
        system.debug('URL FORMED 1' + mapAndDisplaySetting.fieldMap);

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http httpObj = new Http();

        req.setMethod('GET');
        req.setEndpoint(requestURL);
        req.setTimeout(30000);

        try {
            res = httpObj.send(req);
        } catch(System.CalloutException e) {
            system.debug('Call Out Exception :' + e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LG_AddressValNA));       
        } catch(Exception e) {
            system.debug('Exception :' + e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LG_AddressValNA));     
        }
       
        system.debug('Response is \'' + res.getbody()+ '\'');
        if(res.getStatusCode() == 200 && res.getStatus() == 'OK') {
            addressResponse = new LG_AddressResponse();
            addressResponse.addView = new List<LG_AddressResponse.addView>();

            try{
                addressResponse.addView = (List<LG_AddressResponse.addView>)JSON.deserialize(res.getBody(), List<LG_AddressResponse.addView>.class);
            } catch(System.JSONException ex) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, Label.UM_GenericError));      
            }
        } else if(res.getStatusCode() == 100){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.UM_RFS_CHECK_NO_ADDRESS_FOUND_ERROR));      
        } else if(res.getStatus() != null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,res.getStatus()));
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.UM_GenericError));      
        }

    }

    public void findAddressLocal () {
        String addressQuery = 'Select Name,Address_ID__c,House_Number__C, Extension__c, City__c, Country__C, Post_Code__c, Street__c from Add_ToBeDel__c ';      
        if(validationRecord.get('LG_VisitCountry__c') != null && validationRecord.get('LG_VisitPostalCode__c') != null) {
                    addressQuery = addressQuery + 'where Country__c = \'' + validationRecord.get('LG_VisitCountry__c') +'\' and Post_Code__c like  \'' + validationRecord.get('LG_VisitPostalCode__c') + '\'';
        if(validationRecord.get('LG_VisitHouseNumber__c') != null) {
            addressQuery = addressQuery  + ' and House_Number__C like \'' + validationRecord.get('LG_VisitHouseNumber__c') + '\'';
        }
        if(validationRecord.get('LG_VisitHouseNumberExtension__c') != null) {
            addressQuery = addressQuery  + ' and Extension__c like \'' + validationRecord.get('LG_VisitHouseNumberExtension__c') + '\'';
        }
            addressSuggestion = (List<Add_ToBeDel__c>)Database.Query(addressQuery );
        }else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, Label.LG_FillCountryZip);
        }
        addressResponse = new LG_AddressResponse();            
        addressResponse.moreAddressesAvailable = false;
        loopCount = 0;
        system.debug(addressQuery  + 'queryishere');
        //system.debug(addressSuggestion[0].Address_ID__c + 'queryishere');
        addressResponse.addView = new List<LG_addressResponse.addView>();
        if(addressSuggestion != null) {
            for(Add_ToBeDel__c loopVar : addressSuggestion) {
                addressResponse.addView.add(new LG_addressResponse.addView());
                addressResponse.addView[loopCount].addressID = loopVar.Address_ID__c;
                addressResponse.addView[loopCount].city = loopVar.City__c;
                addressResponse.addView[loopCount].streetNrFirstSuffix = loopVar.Extension__c;
                addressResponse.addView[loopCount].CountryName = loopVar.Country__c;
                addressResponse.addView[loopCount].streetNrFirst = loopVar.House_Number__c;
                addressResponse.addView[loopCount].postcode = loopVar.Post_Code__c ;
                addressResponse.addView[loopCount].streetName = loopVar.Street__c;
                loopCount++;
            }
            
        }
    }

    /* To be reused or Deleted*/
    public pagereference setAddress() {
        
        LG_addressResponse.addView selectAddress = new LG_addressResponse.addView();
        for(LG_addressResponse.addView loopVar:addressResponse.addView){
            if(loopVar.addressID == selectedAddressID)
                selectAddress = loopVar;
        }
        system.debug(selectedAddressID + 'SelectedID');
            
        if (outsideAddressValidationpage)
        {
            if (macdConfController.validateAddress)
            {
                update new cscrm__Address__c(Id = macdConfController.validateSiteId,
                                                LG_AddressID__c = selectAddress.addressId);
            }
            else
            {
                //macdConfController.moveSite = new LG_AddressResponse.OptionalsJson(selectAddress);    
            }
            return null;
        }
        else
        {
            for(fieldMap loopVar : mapAndDisplaySetting.fieldMap) {
                validationRecord.put(loopVar.sfFieldName , selectAddress.get(loopVar.jsonField));
            }
            try {
                update validationRecord;
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
                    system.debug('errorMessage'+ errorMessage);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            }
            return (new pagereference(returnURL));
        }        
    }
    
    /* To be reused or Deleted
    public void updateAcc() {
        update validationRecord;
    }*/


    /*
    Description : This method processes Record ID and fetched the object Name from the Schema object
    Param : Record ID
    Return : API name of the object
    */
    public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
        String objectName = '';
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
             
            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
             
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){
                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                System.debug('Prefix is ' + prefix);
                 
                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();
                    System.debug('Object Name! ' + objectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
    }

    /*
    Descripion : This method process fieldset data and returns a map of Field Label and Field API name
    Param : FieldSet API Name & Object Name
    Return : Map of Field Label & Field API name
    */
    public Map<String,String> readFieldSet(String fieldSetName, String ObjectName)
    {
        system.assert(ObjectName != '', 'This page can be used with refernce to Salesforce Objects');
        system.assert(fieldSetName != '', 'No Search layout defined for this object');
        searchField = new Map<String,String>();
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        searchFieldSeq = new Map<Integer,String>();

        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        loopCount = 0;
        for(Schema.FieldSetMember loopVar : fieldSetObj.getFields()) {
            searchFieldSeq.put(loopCount,loopVar.getFieldPath());
            searchField.put(loopVar.getFieldPath(), loopVar.getLabel());
            loopCount++;
        }

        return searchField; 
    } 


    /*
        Description : This sclass captures from settings from custom metadata type valid for current object and country.
    */
    class settingInfo {
        public boolean validSettingFound;
        public String fieldSet;
        public settingInfo () {
            validSettingFound = false;
            fieldSet = '';
        }
    }

    
    /*
        Description : This class captures settings for mapping of Salesforce to JSON fields and also the the display setting on the address search layout.
    */
    class mapAndDisplay {
        public boolean isActive;
        public List<fieldMap> fieldMap{get;set;}
    }
    class fieldMap {
        public String sfFieldName{get;set;}
        public String jsonField{get;set;}
        public Boolean resultVisible{get;set;}
        public String displayLabel{get;set;}
        public Boolean searchFilter{get;set;}
        public Boolean requiredParam{get;set;}
        public String webServiceParam{get;set;}
    }
}