/**
 *Test Class for LG_EndpointResolver
 * 
 * @author Preetha N
 * @since  24/10/2017
*/
@isTest
public class LG_EndpointResolverTest {
    public static testmethod void resoltest(){
      test.startTest();
      LG_ServiceRequestUrl__c req=new LG_ServiceRequestUrl__c();
     req.LG_LocalizationClass__c='LG_EndpointResolver';
     insert req;
     LG_EndpointResolver.getInstance();
    test.stopTest();
        
    }
}