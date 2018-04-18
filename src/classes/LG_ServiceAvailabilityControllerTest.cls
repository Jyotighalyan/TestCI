@isTest
public class LG_ServiceAvailabilityControllerTest{
    
    public static testMethod void test1(){
        LG_ServiceAvailabilityController controller = new LG_ServiceAvailabilityController();
        LG_ServiceAvailabilityController.ServiceAvailability sa = new LG_ServiceAvailabilityController.ServiceAvailability('name', true);
        system.assertEquals('name', sa.serviceName);
        system.assertEquals(true, sa.available);
        controller.houseNumberAttribute = '47';
        system.assertEquals('47', controller.houseNumber);
        controller.extensionAttribute = 'ext';
        system.assertEquals('ext', controller.extension);
        List<LG_ServiceAvailabilityController.ServiceAvailability> salist = controller.serviceAvailabilityInformation;
        // serviceAvailabilityInformation getter never return s null
        System.assertNotEquals(null, salist);
        System.assertNotEquals(null, controller.extensionSuggestions);
        System.assertEquals(0, controller.extensionSuggestionCount);
        LG_ServiceAvailabilityController.HouseNumberExtensionSuggestion suggestion = new LG_ServiceAvailabilityController.HouseNumberExtensionSuggestion('\'TEST\' suggestion');
        System.assertEquals('\\\'TEST\\\' suggestion', suggestion.getEscapedSuggestion());
    }
    
    public static testMethod void runTestWithValidAddress() {
        LG_ServiceAvailabilityController controller = new LG_ServiceAvailabilityController();
        controller.postalCode = '2585 JG';
        controller.houseNumber = '1';
        controller.extension = '123';
        Continuation cont = (Continuation) controller.updateServiceAvailability();
        Map<String, HttpRequest> requests = cont.getRequests();
        System.assertEquals(1, requests.size());
        System.assertNotEquals(null, controller.requestLabel);
        // Perform mock callout
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"street":"PARKWEG","houseNumber":"1","houseNumberExt":"","zipCode":"2585JG","city":"S-GRAVENHAGE","status":[],"availability":[{"name":"dtv-horizon","available":false},{"name":"fp500","available":false},{"name":"internet","available":false},{"name":"dtv","available":false},{"name":"catv","available":false},{"name":"telephony","available":false},{"name":"mobile_internet","available":false},{"name":"fp200","available":false},{"name":"catvfee","available":false},{"name":"packages","available":false},{"name":"mobile","available":false}]}');
        Test.setContinuationResponse(controller.requestLabel, response);
        Object result = Test.invokeContinuationMethod(controller, cont);
        // Check return value of the callback method
        System.assertEquals(null, result);
        // Check result
        List<LG_ServiceAvailabilityController.ServiceAvailability> serviceAvailability = controller.serviceAvailabilityInformation;
        System.assertNotEquals(null, serviceAvailability);
        System.assertEquals(null, controller.errorMessage);
        System.assertEquals(11, serviceAvailability.size());
    }

    public static testMethod void runTestWithUnsetAddress() {
        LG_ServiceAvailabilityController controller = new LG_ServiceAvailabilityController();
        Object result = controller.updateServiceAvailability();
        System.assertEquals(null, result);
        System.assertNotEquals(null, controller.errorMessage);
    }
    
    public static testMethod void runTestWithExtensionSuggestions() {
        LG_ServiceAvailabilityController controller = new LG_ServiceAvailabilityController();
        controller.postalCode = 'clearly invalid postal code';
        controller.houseNumber = 'not even a number';
        Continuation cont = (Continuation) controller.updateServiceAvailability();
        Map<String, HttpRequest> requests = cont.getRequests();
        System.assertEquals(1, requests.size());
        System.assertNotEquals(null, controller.requestLabel);
        // Perform mock callout
        HttpResponse response = new HttpResponse();
        response.setStatusCode(404);
        Test.setContinuationResponse(controller.requestLabel, response);
        Object result = Test.invokeContinuationMethod(controller, cont);
        // Check return value of the callback method
        System.assert(result instanceof Continuation);
        // Check result
        System.assertNotEquals(null, controller.errorMessage);
        // Check suggestions
        cont = (Continuation) result;
        response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody('{"suggestions":["I"]}');
        response.setHeader('Content-Type', 'application/json');
        Test.setContinuationResponse(controller.requestLabel, response);
        result = Test.invokeContinuationMethod(controller, cont);
        System.assertEquals(null, result);
        System.assertEquals(1, controller.extensionSuggestionCount);
    }
    
    public static testMethod void runTestWithUnknownError() {
        LG_ServiceAvailabilityController controller = new LG_ServiceAvailabilityController();
        controller.postalCode = 'clearly invalid postal code';
        controller.houseNumber = 'not even a number';
        Continuation cont = (Continuation) controller.updateServiceAvailability();
        Map<String, HttpRequest> requests = cont.getRequests();
        System.assertEquals(1, requests.size());
        System.assertNotEquals(null, controller.requestLabel);
        // Perform mock callout
        HttpResponse response = new HttpResponse();
        response.setStatusCode(2000);
        Test.setContinuationResponse(controller.requestLabel, response);
        Object result = Test.invokeContinuationMethod(controller, cont);
        // Check return value of the callback method
        System.assertEquals(null, result);
        // Check result
        System.assertNotEquals(null, controller.errorMessage);
    }
    
    public static testMethod void runTestWithTimeout() {
        LG_ServiceAvailabilityController controller = new LG_ServiceAvailabilityController();
        controller.postalCode = '2585 JG';
        controller.houseNumber = '1';
        Continuation cont = (Continuation) controller.updateServiceAvailability();
        Map<String, HttpRequest> requests = cont.getRequests();
        System.assertEquals(1, requests.size());
        System.assertNotEquals(null, controller.requestLabel);
        // Perform mock callout
        HttpResponse response = new HttpResponse();
        response.setStatusCode(3000);
        Test.setContinuationResponse(controller.requestLabel, response);
        Object result = Test.invokeContinuationMethod(controller, cont);
        // Check return value of the callback method
        System.assertEquals(null, result);
        // Check result
        System.assertNotEquals(null, controller.errorMessage);
    }
    
    // The same as 'runTestWithValidAddress', but with service name translation
    // from the REST API name to user-friendly name. (Custom setting inserted)
    public static testMethod void runTestWithServiceNameTranslation() {
        LG_ServiceInformation__c serviceInformation = new LG_ServiceInformation__c();
        serviceInformation.Name = 'dtv-horizon';
        serviceInformation.LG_ServiceName__c = 'TESTING SERVICE';
        insert serviceInformation;
        LG_ServiceAvailabilityController controller = new LG_ServiceAvailabilityController();
        controller.postalCode = '2585 JG';
        controller.houseNumber = '1';
        Continuation cont = (Continuation) controller.updateServiceAvailability();
        Map<String, HttpRequest> requests = cont.getRequests();
        System.assertEquals(1, requests.size());
        System.assertNotEquals(null, controller.requestLabel);
        // Perform mock callout
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"street":"PARKWEG","houseNumber":"1","houseNumberExt":"","zipCode":"2585JG","city":"S-GRAVENHAGE","status":[],"availability":[{"name":"dtv-horizon","available":false},{"name":"fp500","available":false},{"name":"internet","available":false},{"name":"dtv","available":false},{"name":"catv","available":false},{"name":"telephony","available":false},{"name":"mobile_internet","available":false},{"name":"fp200","available":false},{"name":"catvfee","available":false},{"name":"packages","available":false},{"name":"mobile","available":false}]}');
        Test.setContinuationResponse(controller.requestLabel, response);
        Object result = Test.invokeContinuationMethod(controller, cont);
        // Check return value of the callback method
        System.assertEquals(null, result);
        // Check result
        List<LG_ServiceAvailabilityController.ServiceAvailability> serviceAvailability = controller.serviceAvailabilityInformation;
        System.assertNotEquals(null, serviceAvailability);
        System.assertEquals(null, controller.errorMessage);
        System.assertEquals(11, serviceAvailability.size());
        System.assertEquals('TESTING SERVICE', serviceAvailability.get(0).serviceName);
    }
    
    // Test retrieving house number extension suggestions with successful callout.
    public static testMethod void runExtensionSuggestionTestWithSuccess() {
        LG_ServiceAvailabilityController controller = new LG_ServiceAvailabilityController();
        controller.postalCode = '2585 JG';
        controller.houseNumber = '1';
        controller.extension = '';
        Continuation cont = (Continuation) controller.updateExtensionSuggestions();
        Map<String, HttpRequest> requests = cont.getRequests();
        System.assertEquals(1, requests.size());
        System.assertNotEquals(null, controller.requestLabel);
        // Perform mock callout
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"suggestions":["I","II","III","IV","V","VI","VII","VIII","IX","X","XI"]}');
        Test.setContinuationResponse(controller.requestLabel, response);
        Object result = Test.invokeContinuationMethod(controller, cont);
        // Check return value of the callback method
        System.assertEquals(null, result);
        // Check result
        System.assertEquals(11, controller.extensionSuggestionCount);
    }
    
    public static testMethod void runExtensionSuggestionTestWith404Error() {
        LG_ServiceAvailabilityController controller = new LG_ServiceAvailabilityController();
        controller.postalCode = '2585 JG';
        controller.houseNumber = '1';
        controller.extension = '';
        Continuation cont = (Continuation) controller.updateExtensionSuggestions();
        Map<String, HttpRequest> requests = cont.getRequests();
        System.assertEquals(1, requests.size());
        System.assertNotEquals(null, controller.requestLabel);
        // Perform mock callout
        HttpResponse response = new HttpResponse();
        response.setStatusCode(404);
        Test.setContinuationResponse(controller.requestLabel, response);
        Object result = Test.invokeContinuationMethod(controller, cont);
        // Check return value of the callback method
        System.assertEquals(null, result);
        // Check result
        System.assertEquals(0, controller.extensionSuggestionCount);
    }
    
    public static testMethod void runExtensionSuggestionTestWithTimeoutError() {
        LG_ServiceAvailabilityController controller = new LG_ServiceAvailabilityController();
        controller.postalCode = '2585 JG';
        controller.houseNumber = '1';
        controller.extension = '';
        Continuation cont = (Continuation) controller.updateExtensionSuggestions();
        Map<String, HttpRequest> requests = cont.getRequests();
        System.assertEquals(1, requests.size());
        System.assertNotEquals(null, controller.requestLabel);
        // Perform mock callout
        HttpResponse response = new HttpResponse();
        response.setStatusCode(2000);
        Test.setContinuationResponse(controller.requestLabel, response);
        Object result = Test.invokeContinuationMethod(controller, cont);
        // Check return value of the callback method
        System.assertEquals(null, result);
        // Check result
        System.assertEquals(0, controller.extensionSuggestionCount);
        System.assertEquals(Label.LG_CalloutTimedOut, controller.errorMessage);
    }
    
    public static testMethod void runExtensionSuggestionTestWithUnknownError() {
        LG_ServiceAvailabilityController controller = new LG_ServiceAvailabilityController();
        controller.postalCode = '2585 JG';
        controller.houseNumber = '1';
        controller.extension = '';
        Continuation cont = (Continuation) controller.updateExtensionSuggestions();
        Map<String, HttpRequest> requests = cont.getRequests();
        System.assertEquals(1, requests.size());
        System.assertNotEquals(null, controller.requestLabel);
        // Perform mock callout
        HttpResponse response = new HttpResponse();
        response.setStatusCode(2001);
        Test.setContinuationResponse(controller.requestLabel, response);
        Object result = Test.invokeContinuationMethod(controller, cont);
        // Check return value of the callback method
        System.assertEquals(null, result);
        // Check result
        System.assertEquals(0, controller.extensionSuggestionCount);
        System.assertEquals(Label.LG_UnknownApexError, controller.errorMessage);
    }

}