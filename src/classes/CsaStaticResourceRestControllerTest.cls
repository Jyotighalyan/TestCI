@isTest
private class CsaStaticResourceRestControllerTest {

    private class StaticResourceQueryTest extends CsaStaticResourceRestController.StaticResourceQuery{
        private List<StaticResource> prepareStaticResourceList() {
            List<StaticResource> staticResourceList = new List<StaticResource>();
            
            StaticResource sr = new StaticResource();
            sr.Id = '081240000009Avl';
            sr.Name = 'testStaticResource';
            sr.ContentType = 'text/plain';
            sr.Body = Blob.valueof('testBody');
            
            staticResourceList.add(sr);
            return staticResourceList;
        }
        
        public override List<StaticResource> queryDatabase(String query) {
            return prepareStaticResourceList();
        }
        
        public override List<StaticResource> getStaticResourceById(String id) {
          return prepareStaticResourceList();
      }
      
      public override List<StaticResource> getStaticResourceByName(String name) {
          return prepareStaticResourceList();
      }       
    }

  private static testMethod void testGetStaticResourcesByName() {
        List<CsaStaticResourceRestController.StaticResourceWrapper> wrapperList = getStaticResource('name', 'testStaticResource');
        assertPropertyEquality(wrapperList);
  }

    private static testMethod void testGetStaticResourcesById() {
        List<CsaStaticResourceRestController.StaticResourceWrapper> wrapperList = getStaticResource('id', '081240000009Avl');
        assertPropertyEquality(wrapperList);
  }
  
  private static testMethod void testGetStaticResourcesByQuery() {
        List<CsaStaticResourceRestController.StaticResourceWrapper> wrapperList = getStaticResource('query', 'SELECT Id FROM StaticResource WHERE Id IN (\'081240000009AvlAAE\')');
        assertPropertyEquality(wrapperList);
  }
  
  private static List<CsaStaticResourceRestController.StaticResourceWrapper> getStaticResource(String key, String value) {
      RestRequest req = new RestRequest(); 
        req.requestURI = '/CsaRest/StaticResource';  
        req.httpMethod = 'GET';
        req.addParameter(key, value);
        RestContext.request = req;

        StaticResourceQueryTest qt = new StaticResourceQueryTest();
        CsaStaticResourceRestController.q = qt;
        List<CsaStaticResourceRestController.StaticResourceWrapper> wrapperList =  CsaStaticResourceRestController.getStaticResources();
        
        return wrapperList;
  }
  
  private static void assertPropertyEquality(List<CsaStaticResourceRestController.StaticResourceWrapper> wrapperList) {
      System.assertEquals(1, wrapperList.size());
        System.assertEquals('testStaticResource', wrapperList[0].Name);
        System.assertEquals('text/plain', wrapperList[0].ContentType);
        System.assertEquals('testBody', wrapperList[0].Data);
  }

}