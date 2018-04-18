@isTest
public class UM_RestApiAddressCheckTest {
    public static testmethod void addrcheck(){
        test.startTest();
        
          RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = 'callout:UM_SpiderWS/TopasWS/TopasWSService';  
        req.addParameter('zip', '0');
        req.addParameter('streetNo', '1390296387');
        req.addParameter('streetNoSuffix', '1wer2547');
         req.addParameter('street', '1wer2547');

        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
       UM_RestApiAddressCheck.um_addresscheck(); 
        UM_AddressResponse addr=new UM_AddressResponse();
      
     //  UM_RestApiAddressCheck.Address add=new UM_RestApiAddressCheck.Address();
      // add.buildingId='b';
     // UM_RestApiAddressCheck check=new UM_RestApiAddressCheck(add);
     // check.Address();
        test.stopTest();
         }
    
 

}