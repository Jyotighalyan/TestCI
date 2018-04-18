@IsTest
public class UM_ServiceAvailabilityControllerTest {

    /** SeeAllData - because of mdt visibility */
    @isTest(SeeAllData=true) static void testServiceAvailability() {

        Account testAcc = LG_GeneralTest.CreateAccount(
            'Recaro', 'Customer', 'SoHo', 5, 'Qualified', '049-3220919', '55107192', 'UnityMedia', 'Flughafen Allee', '25', '', '28199', 'Bremen', 'Germany'
        );

        /*
        UM_WebserviceCredentials__c setting = new UM_WebserviceCredentials__c();
        setting.Name = 'UM_TopasWS';
        setting.Login__c = 'tLogin';
        setting.Password__c = 'tPassword';
        insert setting;
        */
       
        PageReference pageRef = Page.UM_ServiceAvailabilityAccount; 
        pageRef.getParameters().put('recordId', testAcc.Id);
        pageRef.getParameters().put('buildingId', '123654');              
        Test.setCurrentPageReference(pageRef);

        Test.startTest();

        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new UM_AddressResponseMock());
        UM_AddressResponseMock.resmth = 'searchext';

        UM_ServiceAvailabilityController c = new  UM_ServiceAvailabilityController();

        c.recordIdAttribute = testAcc.Id;
        c.setServiceAvailibility();

        c.buildingIdAttribute = '123654';
        c.updateServiceAvailability();

        Map<String, Boolean> expectedAvailability = new Map<String, Boolean>{
            'Analog' => true,
            'Digital' => false,
            'Internet' => true,
            'Mobile' => true,
            'Phone' => false
        };

        for(UM_ServiceAvailabilityController.ServiceAvailability service : c.serviceAvailabilityInformation) {

            System.assertEquals(expectedAvailability.get( service.serviceName ), service.available);
        }

        Test.stopTest();
    }

    @isTest static void testServiceAvailabilityNoData() {

        Account testAcc = LG_GeneralTest.CreateAccount(
            'Recaro', 'Customer', 'SoHo', 5, 'Qualified', '049-3220919', '55107192', 'UnityMedia', 'Flughafen Allee', '25', '', '28199', 'Bremen', 'Germany'
        );

        UM_WebserviceCredentials__c setting = new UM_WebserviceCredentials__c();
        setting.Name = 'UM_TopasWS';
        setting.Login__c = 'tLogin';
        setting.Password__c = 'tPassword';
        insert setting;
 
        PageReference pageRef = Page.UM_ServiceAvailabilityAccount;  
        pageRef.getParameters().put('recordIdAttribute', testAcc.Id);
        pageRef.getParameters().put('buildingId', '123654');              
        Test.setCurrentPageReference(pageRef);

        Test.startTest();

        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new UM_AddressResponseMock());
        UM_AddressResponseMock.resmth = 'searchext';

        UM_ServiceAvailabilityController c = new  UM_ServiceAvailabilityController();
        c.updateServiceAvailability();

        Test.stopTest();
    }    
}