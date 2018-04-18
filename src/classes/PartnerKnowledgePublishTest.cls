@isTest
    public class PartnerKnowledgePublishTest{
    
    @testsetup
    private static void setupTestData()
    {
            FormsTemp__kav article =new FormsTemp__kav(Title='test',summary='xyz',urlname='xyz1');
            insert article;
            Offer__kav article2 =new Offer__kav(Title='test2',summary='xyz',urlname='xyz2');
            insert article2;
            Newsletter__kav article3 =new Newsletter__kav(Title='test3',summary='xyz',urlname='xyz3');
            insert article3;
            

 
    }
    
      @isTest static void testPartnerknowledge() {
      
           Test.startTest();
           PartnerKnowledgePublish knowledge = new PartnerKnowledgePublish();
           list<FormsTemp__kav> formsret = knowledge.getForms();
           list<Offer__kav> offerret = knowledge.getoffer();
           list<Newsletter__kav> Newsret = knowledge.getNewsletter();
           Test.stopTest();
      
      
      }

}