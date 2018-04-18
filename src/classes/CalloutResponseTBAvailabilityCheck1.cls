global class CalloutResponseTBAvailabilityCheck1 extends csbb.CalloutResponseManagerExt {

    global CalloutResponseTBAvailabilityCheck1 (Map<String, csbb.CalloutResponse> mapCR, csbb.ProductCategory productCategory, csbb.CalloutProduct.ProductResponse productResponse) {
        this.setData(mapCR, productCategory, productResponse);
    }
    
    global CalloutResponseTBAvailabilityCheck1 () {
    }
    
    global void setData(Map<String, csbb.CalloutResponse> mapCR, csbb.ProductCategory productCategory, csbb.CalloutProduct.ProductResponse productResponse) {
        this.service = 'TBAvailabilityCheck1';
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
        this.productResponse.displayMessage = 'Sample message from RFS Check';
        this.productResponse.available = 'true';
        String resultJson = csbb.CalloutDisplay.takeString(crPrimary,'Envelope.Body.doWorkResponse.result');
        Map<String, String> resultMap = (Map<String, String>)JSON.deserialize(resultJson, Map<String, String>.class);
        this.crPrimary.mapDynamicFields.put('topspeed', resultMap.get('topspeed'));
        
        system.debug('categoryIndicator: ' + categoryIndicator);
        system.debug('resultMap: ' + resultMap);
    }
    
    global csbb.Result canOffer (Map<String, String> attMap, Map<String, String> responseFields, csbb.CalloutProduct.ProductResponse productResponse) {
        csbb.Result canOfferResult = new csbb.Result();
        canOfferResult.status = 'OK';
        
        system.debug('responseFields: ' + responseFields);
        system.debug('productResponse: ' + productResponse);
        system.debug('attMap: ' + attMap);
        system.debug('canOfferResult: ' + canOfferResult);
        
        return canOfferResult;
    }
}