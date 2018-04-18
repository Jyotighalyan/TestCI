global class CalloutResponseCreateAddrFromAddrCheck extends csbb.CalloutResponseManagerExt{
	global Map<String, Object> processResponseRaw (Map<String, Object> inputMap) {
        system.debug('+++inputMap: ' + inputMap);
        Map<String, Object> returnMap = new Map<String, Object>();
        Map<String, String> contextData = (Map<String, String>)inputMap.get('context');
        
        if (contextData != null && contextData.get('calloutServiceMethodType') == 'address') {
            List<Object> results = new List<Object>();
            LG_CommonAddressFormat c = new LG_CommonAddressFormat(inputMap);

            // Define parametar mapping! Parametar order: street, house number, house number extension, postcode, city, ID field
            results = c.ToCommonAddressFormat('cscrm__Street__c', 'LG_HouseNumber__c', 'LG_HouseNumberExtension__c', 'cscrm__Zip_Postal_Code__c', 'cscrm__City__c', 'cscrm__State_Province__c',null,null, 'LG_AddressID__c');

            // TSC is smart enough to add addressResponseProcessed result into a proper place in the JSON response
            returnMap.put('addressResponseProcessed', JSON.serialize(results));
        }
        
        return returnMap;
    }

    
    global Map<String, Object> getDynamicRequestParameters (Map<String, Object> inputMap) {
        return new Map<String, Object>();
    }
}