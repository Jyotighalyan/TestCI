@isTest
public class infportwsUnitymediaComTes {

    @isTest static void infportwsUnitymediaComTest1() {

        
        InfoportServiceConnection__c setting = new InfoportServiceConnection__c();
        setting.Authentication_Token__c  = 'Basic aW5mcG9ydC1lY28ud3M6MW5mcDByNyMyMDAw';
        setting.Connection_URL__c = 'https://appst.unitymedia.de/InfportWS/InfportWSService?wsdl';
        setting.Session_Timeout__c = decimal.valueOf('120.000');
        insert setting;
        Test.setMock(WebServiceMock.class, new infportwsUnitymediaComTest());

        Test.startTest();
        infportwsUnitymediaCom.InfportWSPort pbWebService = new infportwsUnitymediaCom.InfportWSPort();
        wwwDialogikaDeWsdlInfportSchemasSp.taExtensionPhone phones = new wwwDialogikaDeWsdlInfportSchemasSp.taExtensionPhone();
        wwwDialogikaDeWsdlInfportSchemasSp.tIReservationInfo info = new wwwDialogikaDeWsdlInfportSchemasSp.tIReservationInfo ();
        wwwDialogikaDeWsdlInfportSchemasSp.tTemplateInfo templateInfo = new wwwDialogikaDeWsdlInfportSchemasSp.tTemplateInfo ();
        wwwDialogikaDeWsdlInfportSchemasSp.tChannelDescriptor cd = new wwwDialogikaDeWsdlInfportSchemasSp.tChannelDescriptor ();
        wwwDialogikaDeWsdlInfportSchemasSp.tIExistingNumberInfo existingNrs = new wwwDialogikaDeWsdlInfportSchemasSp.tIExistingNumberInfo ();
        String region;
        String username;
        String password;
        String authorization;
        pbWebService.reserveNumbers(phones,info,templateInfo,cd,existingNrs, region, username, password, authorization);               
        Test.stopTest();
    }

   @isTest static void infportwsUnitymediaComTest2() {

        
        InfoportServiceConnection__c setting = new InfoportServiceConnection__c();
        setting.Authentication_Token__c  = 'Basic aW5mcG9ydC1lY28ud3M6MW5mcDByNyMyMDAw';
        setting.Connection_URL__c = 'https://appst.unitymedia.de/InfportWS/InfportWSService?wsdl';
        setting.Session_Timeout__c = decimal.valueOf('120.000');
        insert setting;
        Test.setMock(WebServiceMock.class, new infportwsUnitymediaComTest());

        Test.startTest();
        infportwsUnitymediaCom.InfportWSPort pbWebService = new infportwsUnitymediaCom.InfportWSPort();
        
        String region;
        String username;
        String password;
        String authorization;
        wwwDialogikaDeWsdlInfportSchemasSf.GetAllCarriersResponse_element resp = pbWebService.getAllCarriers(region, username, password, authorization);               
        Test.stopTest();
    }
    
     @isTest static void infportwsUnitymediaComTest3() {

        
        InfoportServiceConnection__c setting = new InfoportServiceConnection__c();
        setting.Authentication_Token__c  = 'Basic aW5mcG9ydC1lY28ud3M6MW5mcDByNyMyMDAw';
        setting.Connection_URL__c = 'https://appst.unitymedia.de/InfportWS/InfportWSService?wsdl';
        setting.Session_Timeout__c = decimal.valueOf('120.000');
        insert setting;
        Test.setMock(WebServiceMock.class, new infportwsUnitymediaComTest());

        Test.startTest();
        infportwsUnitymediaCom.InfportWSPort pbWebService = new infportwsUnitymediaCom.InfportWSPort();
        
        String region;
        String username;
        String password;
        String authorization;
         wwwDialogikaDeWsdlInfportSchemasIn.taIPhone phones = new wwwDialogikaDeWsdlInfportSchemasIn.taIPhone();
         wwwDialogikaDeWsdlInfportSchemasSp.tIReservationInfo info = new wwwDialogikaDeWsdlInfportSchemasSp.tIReservationInfo();
         wwwDialogikaDeWsdlInfportSchemasSp.tTemplateInfo templateInfo = new wwwDialogikaDeWsdlInfportSchemasSp.tTemplateInfo ();
         String reservationKey;
    pbWebService.removeReservation(phones,info,templateInfo,reservationKey,region, username, password, authorization);               
        Test.stopTest();
    }

}