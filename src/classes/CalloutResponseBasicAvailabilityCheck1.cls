global class CalloutResponseBasicAvailabilityCheck1 extends csbb.CalloutResponseManagerExt {

    global CalloutResponseBasicAvailabilityCheck1 (Map<String, csbb.CalloutResponse> mapCR, csbb.ProductCategory productCategory, csbb.CalloutProduct.ProductResponse productResponse) {
        this.setData(mapCR, productCategory, productResponse);
    }
    
    global CalloutResponseBasicAvailabilityCheck1 () {
    }
    
    global void setData(Map<String, csbb.CalloutResponse> mapCR, csbb.ProductCategory productCategory, csbb.CalloutProduct.ProductResponse productResponse) {
        this.service = 'BasicAvailabilityCheck1';
        this.productCategoryId = productCategory.productCategoryId;
        this.mapCR = mapCR;
        this.productCategory = productCategory;
        this.productResponse = productResponse;
        this.setPrimaryCalloutResponse();
    }
    
    global Map<String, Object> processResponseRaw (Map<String, Object> inputMap) {
        return new Map<String, Object>();
    }
    
    global Map<String, Object> getDynamicRequestParameters (Map<String, Object> inputMap) {
        return new Map<String, Object>();
    }
    
    global void runBusinessRules (String categoryIndicator) {
        this.productResponse.available = 'true';
        String resultJson = csbb.CalloutDisplay.takeString(crPrimary,'Envelope.Body.doWorkResponse.result');
        Map<String, String> resultMap = (Map<String, String>)JSON.deserialize(resultJson, Map<String, String>.class);
        this.productResponse.displayMessage = ('Top speed for this site is ' + resultMap.get('topspeed'));
        this.productResponse.fields.put('topspeed', resultMap.get('topspeed'));
        
        system.debug('resultMap: ' + resultMap);
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
        
        String topSpeed;
        if (ignoreRFSCheck == 'Yes') {
            canOfferResult.status = 'OK';
        }
        else {
            topSpeed = responseFields.get('topspeed');
            system.debug('topSpeed is: ' + topSpeed);
            if (topSpeed == '0') {
                canOfferResult.status = Label.UM_NO_CONNECTION_ERROR;
            }
            else
            	canOfferResult.status = 'OK'; 
        }
        
        system.debug('canOfferResult: ' + canOfferResult);
        return canOfferResult;
    }
}