@isTest
global class UM_KenanAccountCalloutMock implements HttpCalloutMock {
  public String sfId;
  public String billingAccountId;
  global HttpResponse respond ( HTTPRequest req ) {
    system.debug(req.getMethod());
    String jsonString ='';
    
    if(req.getEndpoint().contains('accounts/hierarchy'))
    {
        Map<String,Object> mapObj = new Map<String,Object>();
        mapObj.put('accountInternalId','1234');
        mapObj.put('salesforceObjectId',sfId);
        List<Object> listObj = new List<Object>();
        listObj.add(mapObj );
        system.debug(mapObj);
        jsonString = JSON.serialize(listObj );
    }
    else if(req.getEndpoint().contains('/accounts/account'))
    {
        Map<String,Object> mapObj = new Map<String,Object>();
        mapObj.put('accountInternalId','4567');
        jsonString = JSON.serialize(mapObj);
    }
    else if(req.getEndpoint().contains('/accounts/' + billingAccountId) )
    {
        Map<String,Object> mapObj = new Map<String,Object>();
        mapObj.put('instanceId','6789');
        mapObj.put('salesforceObjectId',sfId);
        List<Object> listObj = new List<Object>();
        listObj.add(mapObj );
        system.debug(mapObj);
        jsonString = JSON.serialize(listObj );
    }
    HttpResponse res = new HttpResponse();
    res.setHeader ('Content-Type', 'application/json');
    res.setBody(jsonString);
    res.setStatusCode ( 200 );
    System.assertNotEquals ( null, res.getBody(), 'response body should not be null' );
    system.debug(res);
    return res;
  }
   

}