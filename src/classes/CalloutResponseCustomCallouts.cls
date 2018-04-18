global class CalloutResponseCustomCallouts extends csbb.CalloutResponseManagerExt {
    /*
     * Creating user presentable address out of individual address fields returned from the Address Checker
     */
    global Map<String, Object> processResponseRaw (Map<String, Object> inputMap) {
        
        Map<String, Object> returnMap = new Map<String, Object>();
        Map<String, Object> contextData = (Map<String, Object>)inputMap.get('context');
        
        if (contextData != null && contextData.get('calloutServiceMethodType') == 'address') {
            system.debug('inputMap: ' + inputMap);
            List<Object> results = new List<Object>();
            LG_CommonAddressFormat c = new LG_CommonAddressFormat(inputMap);
            system.debug('inputMap /over');
            // Define parametar mapping! Parametar order: street, house number, house number extension, postcode, city, ID field
            results = c.ToCommonAddressFormat('Address_Line_1__c', 'House_Number__c', 'House_Number_Extension__c', 'Postcode__c', 'Town__c', 'Region__c', null , null ,'Site_Id__c');

            // TSC is smart enough to add addressResponseProcessed result into a proper place in the JSON response
            returnMap.put('addressResponseProcessed', JSON.serialize(results));
        }

        return returnMap;
    }
    
    global Map<String, Object> getDynamicRequestParameters (Map<String, Object> inputMap) {
        return new Map<String, Object>();
    }
}