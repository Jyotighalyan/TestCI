global class CalloutResponseTopasRFSCheck extends csbb.CalloutResponseManagerExt {
    
    private String availabilityResponse {get; set;}
    private String rfsCheckFailureMessage {get; set;}
    
    global CalloutResponseTopasRFSCheck (Map<String, csbb.CalloutResponse> mapCR, csbb.ProductCategory productCategory, csbb.CalloutProduct.ProductResponse productResponse) {
        this.setData(mapCR, productCategory, productResponse);
    }
    
    global CalloutResponseTopasRFSCheck () {
    }
    
    global void setData(Map<String, csbb.CalloutResponse> mapCR, csbb.ProductCategory productCategory, csbb.CalloutProduct.ProductResponse productResponse) {
        this.service = 'TopasRFSCheck';
        this.productCategoryId = productCategory.productCategoryId;
        this.mapCR = mapCR;
        this.productCategory = productCategory;
        this.productResponse = productResponse;
        this.setPrimaryCalloutResponse();
    }
    
    global Map<String, Object> processResponseRaw (Map<String, Object> inputMap) {
        system.debug('+++processResponseRaw inputMap: ' + inputMap);
        String httpStatusCode = (String) inputMap.get('httpStatusCode');
        
        if (httpStatusCode != '200')
        {
            String respMessage = Label.UM_RFS_CHECK_ERROR;
            if (httpStatusCode != null)
            {
                respMessage = Label.UM_RFS_CHECK_FAILURE + ' ' + httpStatusCode + '.';
                if (httpStatusCode == '400')
                {
                    respMessage = respMessage 
                                    + ' '+ Label.UM_RFS_CHECK_MANDATORY_FIELDS_ERROR;
                }
                else if (httpStatusCode == '500')
                {
                    respMessage = respMessage
                                    + ' '+ Label.UM_INTERNAL_SERVER_ERROR;
                }
                else if (httpStatusCode == '404')
                {
                    respMessage = respMessage
                                    + ' '+ Label.UM_RFS_CHECK_NO_ADDRESS_FOUND_ERROR;
                }
            }
            rfsCheckFailureMessage = respMessage;
        }
        else
        {    
            String response = (String) inputMap.get('availabilityResponseRaw'); 
            System.Debug('++S->response: '+response);            
            if(response.contains('uepId'))
            	availabilityResponse = response.substring(114,response.length()-21).normalizeSpace();
            else
            	rfsCheckFailureMessage =  Label.UM_RFS_CHECK_ERROR + ' '+ Label.UM_RFS_CHECK_NO_ADDRESS_FOUND_ERROR;
            System.Debug('++S->availabilityResponse: '+availabilityResponse);
        }
        return new Map<String, Object>();
    }
    
    global Map<String, Object> getDynamicRequestParameters (Map<String, Object> inputMap) {
        return new Map<String, Object>();
    }
    
    global void runBusinessRules (String categoryIndicator) {        
        Boolean internetAvailable = false;
        String upspeed;
        String downspeed = '0';
        
        if (rfsCheckFailureMessage != null)
        {
            this.productResponse.available = 'false';
            this.productResponse.fields.put('rfsCheckFailureMessage', rfsCheckFailureMessage);
            this.productResponse.displayMessage = rfsCheckFailureMessage;
        }
        else
        {
            this.productResponse.available = 'true';
            String rfsCommonJson = UM_RfsCheckUtility.getCommonRfsJsonFormat(availabilityResponse);
            System.debug('rfsCommonJson: ' + rfsCommonJson);
            UM_RfsCheckUtility.RfsCommon rfsCommon = (UM_RfsCheckUtility.RfsCommon) JSON.deserialize(rfsCommonJson, UM_RfsCheckUtility.RfsCommon.class);

            //FootPrint
            //String footprint = rfsCommon.footprint;
            for (UM_RfsCheckUtility.common_Availability avail : rfsCommon.availability)
            {
                if (avail.capability.equals('Data') && avail.technology.equals('Coax'))
                {
                    internetAvailable = true;
                    
                    for (UM_RfsCheckUtility.Limits lim : avail.limits)
                    {
                        upspeed = lim.up;
                        downspeed = lim.down;
                    }
                }
                else if (avail.capability.equals('Voice') && avail.technology.equals('Mobile'))
                {
                    //mobile
                }
                else if (avail.capability.equals('TV') && avail.technology.equals('Digital'))
                {
                    //dtv
                }
                else if (avail.capability.equals('TV') && avail.technology.equals('Analogue'))
                {
                    //catv
                }
                else if (avail.capability.equals('Voice') && avail.technology.equals('Digital'))
                {
                    //telephony
                }
            }
            this.productResponse.displayMessage = ('Top speed for this site is ' + downspeed);
            this.productResponse.fields.put('topspeed', downspeed);
            this.crPrimary.mapDynamicFields.put('topspeed', downspeed);
            this.crPrimary.mapDynamicFields.put('state', rfsCommon.stateOrProvince);
        }
        
        //Map<String, String> resultMap = (Map<String, String>)JSON.deserialize(resultJson, Map<String, String>.class);
        
        //system.debug('resultMap: ' + resultMap);no need for this as you're not using resultMap anymore
        system.debug('this.crPrimary.mapDynamicFields is ' +  this.crPrimary.mapDynamicFields);
        system.debug('this.productResponse.fields is ' + this.productResponse.fields);
        
    }
    
    global csbb.Result canOffer (Map<String, String> attMap, Map<String, String> responseFields, csbb.CalloutProduct.ProductResponse productResponse) {
        csbb.Result canOfferResult = new csbb.Result();
        
        system.debug('responseFields: ' + responseFields);
        system.debug('productResponse: ' + productResponse);
        system.debug('attMap: ' + attMap);
        
        String ignoreRFSCheck;
        if (attMap.containsKey('Ignore RFS Check')) {
          ignoreRFSCheck = attMap.get('Ignore RFS Check');
        }
        else {
          ignoreRFSCheck = 'No';
        }
        
        if (responseFields.containsKey('rfsCheckFailureMessage'))
        {
            if (ignoreRFSCheck == 'Yes')
            {
                canOfferResult.status = 'OK';
            }
            else
            {
                canOfferResult.status = responseFields.get('rfsCheckFailureMessage');    
            }
        }
        else
        {
            /*
             * If topspeed is higher than 0 i.e. there is connection, make non-AOP offers available and AOP ones unavailable.
             * Opposite applies.
             */
            String topSpeed;
            if (responseFields.containsKey('topspeed')) {
                topSpeed = responseFields.get('topspeed');
            }
            else {
                topSpeed = '0';
            }
            
            if ((topSpeed == '0') || (topSpeed == null)) {
                if (ignoreRFSCheck == 'Yes') {
                    canOfferResult.status = 'OK';
                }
                else {
                    canOfferResult.status = Label.UM_NO_CONNECTION_ERROR;
                }
            }
            else {
                if (ignoreRFSCheck == 'Yes') {
                    canOfferResult.status = Label.UM_NO_PRODUCT_AVAILABLE_ERROR;
                }
                else {
                    canOfferResult.status = 'OK';
                }
            }
        }
        
        return canOfferResult;
    }
}