@isTest
private class CsaRestControllerTest {

  private static testMethod void testIsRestApiAvailable() {
        Boolean availability = CsaRestController.isRestApiAvailable();
        
        system.assertEquals(true, availability);
  }

}