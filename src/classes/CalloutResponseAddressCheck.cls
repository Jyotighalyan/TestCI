global class CalloutResponseAddressCheck extends csbb.CalloutResponseManagerExt{
    /*
     * Creating user presentable address out of individual address fields returned from the Address Checker
     */
    global Map<String, Object> processResponseRaw (Map<String, Object> inputMap) {
		system.debug('+++raw address response: ' + inputMap);
        Map<String, Object> returnMap = new Map<String, Object>();
        Map<String, Object> contextData = (Map<String, Object>)inputMap.get('context');
        
        if (contextData != null && contextData.get('calloutServiceMethodType') == 'address') {

            List<Object> results = new List<Object>();
            LG_CommonAddressFormat c = new LG_CommonAddressFormat(inputMap);

            // Define parametar mapping! Parametar order: street, house number, house number extension, postcode, city, region, latitude, longitude, ID field
            results = c.ToCommonAddressFormat('cscrm__Street__c', 'LG_HouseNumber__c', 'LG_HouseNumberExtension__c', 'cscrm__Zip_Postal_Code__c', 'cscrm__City__c', 'cscrm__State_Province__c', 'cscrm__Geolocation__Latitude__s', 'cscrm__Geolocation__Longitude__s', 'LG_AddressID__c');
			system.debug('+++results in common address format: ' + JSON.serialize(results));
            // TSC is smart enough to add addressResponseProcessed result into a proper place in the JSON response
            returnMap.put('addressResponseProcessed', JSON.serialize(results));
        }
        
        return returnMap;
    }
    
    global Map<String, Object> getDynamicRequestParameters (Map<String, Object> inputMap) {
        return new Map<String, Object>();
    }
}