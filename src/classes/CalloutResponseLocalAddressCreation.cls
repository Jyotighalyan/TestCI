global class CalloutResponseLocalAddressCreation extends csbb.CalloutResponseManagerExt {

    global CalloutResponseLocalAddressCreation (Map<String, csbb.CalloutResponse> mapCR, csbb.ProductCategory productCategory, csbb.CalloutProduct.ProductResponse productResponse) {
        this.setData(mapCR, productCategory, productResponse);
    }
    
    global CalloutResponseLocalAddressCreation () {
    }
    
    global void setData(Map<String, csbb.CalloutResponse> mapCR, csbb.ProductCategory productCategory, csbb.CalloutProduct.ProductResponse productResponse) {
        this.service = 'LocalAddressCreation';
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
        system.debug('++++++entered runBusinessRules for LocalAddressCreation');
        this.productResponse.displayMessage = Label.LG_AddressCreationSucces;
        this.productResponse.available = 'true';
        String resultJson = csbb.CalloutDisplay.takeString(crPrimary,'Envelope.Body.setAddressResponse.result');
        Map<String, String> resultMap = (Map<String, String>)JSON.deserialize(resultJson, Map<String, String>.class);
        this.crPrimary.mapDynamicFields.put('SalesforceAddressId',resultMap.get('SalesforceAddressId'));
        system.debug('++++resultMap: ' + resultMap);
        
        system.debug('categoryIndicator: ' + categoryIndicator);
    }
    
    global csbb.Result canOffer (Map<String, String> attMap, Map<String, String> responseFields, csbb.CalloutProduct.ProductResponse productResponse) {
        csbb.Result canOfferResult = new csbb.Result();
        canOfferResult.status = 'OK';
        
        system.debug('responseFields: ' + responseFields);
        system.debug('productResponse: ' + productResponse);
        system.debug('canOfferResult: ' + canOfferResult);
        
        return canOfferResult;
    }
}