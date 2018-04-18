// This class is based on the basket builder user guide for LGI
global class CalloutResponseAA_LoopbackTest extends csbb.CalloutResponseManagerExt {
  global CalloutResponseAA_LoopbackTest (Map<String, csbb.CalloutResponse> mapCR, csbb.ProductCategory productCategory, csbb.CalloutProduct.ProductResponse productResponse) {
    this.setData(mapCR, productCategory, productResponse);
  }
  global CalloutResponseAA_LoopbackTest () {
  }
  global void setData(Map<String, csbb.CalloutResponse> mapCR, csbb.ProductCategory productCategory, csbb.CalloutProduct.ProductResponse productResponse) {
    this.service = 'AA_LoopbackTest';
    this.productCategoryId = productCategory.productCategoryId;
    this.mapCR = mapCR;
    this.productCategory = productCategory;
    this.productResponse = productResponse;
    setPrimaryCalloutResponse();
    return;
  }
  global Map<String, Object> processResponseRaw (Map<String, Object> inputMap) {
    return new Map<String, Object>();
  }
  global Map<String, Object> getDynamicRequestParameters (Map<String, Object> inputMap) {
    return new Map<String, Object>();
  }
  global void runBusinessRules (String categoryIndicator) {
    system.debug('Entered runBusinessRules');
    String resultJson = csbb.CalloutDisplay.takeString(crPrimary, 'Envelope.Body.doWorkResponse.result');
    Map<String, String> resultMap = (Map<String, String>)JSON.deserialize(resultJson, Map<String, String>.class);
    
    this.crPrimary.mapDynamicFields.put('topAvailableSpeed', resultMap.get('topspeed'));
    
    productResponse.displayMessage = 'Sample message';
    productResponse.available = 'true';
    this.productResponse.fields.put('topSpeed', resultMap.get('topspeed'));

    return;
  }
  global csbb.Result canOffer (Map<String, String> attMap, Map<String, String> responseFields, csbb.CalloutProduct.ProductResponse productResponse) {
    system.debug('Entered canOffer');
    Integer reportedAvailableTopSpeed = Integer.valueOf(responseFields.get('topSpeed'));
    //Integer offeredTopSpeed = Integer.valueOf(attMap.get('CompareWith Attribute'));
    Integer offeredTopSpeed = 100;
    
    String offerStatus;
    if (reportedAvailableTopSpeed >= offeredTopSpeed) {
      offerStatus = 'OK';
    }
    else {
      offerStatus = '';
    }
    
    csbb.Result canOfferResult = new csbb.Result();
    canOfferResult.status = offerStatus;
    return canOfferResult;
  }
}