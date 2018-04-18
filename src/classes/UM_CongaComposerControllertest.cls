@isTest
private class UM_CongaComposerControllertest{
  
    @testSetup
    static void setup() {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        Account acc= new Account(name='accName', LG_ChamberOfCommerceNumber__c ='12345678',LG_Footprint__c = 'Ziggo', LG_BillingEmailAddress__c ='abc@abc.com');  
        insert acc;
        Opportunity opp=LG_GeneralTest.CreateOpportunity(acc);
        
        }
     @isTest
    static void callCongaTest() {   
        Opportunity oppor=[Select id from Opportunity LIMIT 1];
        PageReference pageRef = Page.UM_CongaComposer;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(oppor);
        ApexPages.currentPage().getParameters().put('id',oppor.id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorConga());
        UM_CongaComposerController ac=new UM_CongaComposerController ();         
        Attachment a=[Select id from Attachment Limit 1];       
        Test.stopTest();
        System.assertEquals('Sucessfully Quote Created and attached to Opportunity with Attachment ID: '+a.id, ac.getMyMsg());
        System.assertEquals(true, ac.getFlagSuccess());
        System.assertEquals(false, ac.getFlagError());
        System.assertEquals(true, ac.getSuccessResponse());
    }
}