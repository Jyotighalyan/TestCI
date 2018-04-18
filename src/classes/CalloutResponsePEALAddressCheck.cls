global class CalloutResponsePEALAddressCheck extends csbb.CalloutResponseManagerExt {
    /*
     * Creating user presentable address out of individual address fields returned from the Address Checker
     */
    global Map<String, Object> processResponseRaw (Map<String, Object> inputMap) {
		system.debug('+++raw address response: ' + inputMap);
        Map<String, Object> returnMap = new Map<String, Object>();
        Map<String, Object> contextData = (Map<String, Object>)inputMap.get('context');
        String httpStatusCode = (String) inputMap.get('httpStatusCode');
        
        if (contextData != null && contextData.get('calloutServiceMethodType') == 'address') {
            
            if (httpStatusCode != '200')
            {
                String respMessage = Label.LG_AddressCheckFail;
                if (httpStatusCode != null)
                {
                    respMessage = Label.LG_AddressFailedCode + ' ' + httpStatusCode + '.';
                    if (httpStatusCode == '400')
                    {
                        respMessage = respMessage 
                                        + ' ' + Label.LG_MissingAddressParam;
                    }
                    else if (httpStatusCode == '500')
                    {
                        respMessage = respMessage
                                        + ' ' + Label.UM_INTERNAL_SERVER_ERROR;
                    }
                }
                returnMap.put('addressResponseMessage', respMessage);
                returnMap.put('addressResponseStatus', 'error');
                returnMap.put('addressResponseProcessed', '[]');
            }
            else
            {
                List<Object> results = new List<Object>();
                LG_CommonAddressFormat c = new LG_CommonAddressFormat(inputMap);

                // Define parametar mapping! Parametar order: street, house number, house number extension, postcode, city, ID field
                results = c.ToCommonAddressFormat('streetName', 'streetNrFirst', 'streetNrFirstSuffix', 'postcode', 'city', 'region',null,null, 'addressId');

                // TSC is smart enough to add addressResponseProcessed result into a proper place in the JSON response
                returnMap.put('addressResponseProcessed', JSON.serialize(results));
            }
        }
        system.debug('+++processed address response: ' + returnMap);
        return returnMap;
    }
    
    global Map<String, Object> getDynamicRequestParameters (Map<String, Object> inputMap) {
        return new Map<String, Object>();
    }
}