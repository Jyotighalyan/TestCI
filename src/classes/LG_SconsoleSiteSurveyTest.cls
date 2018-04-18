@isTest
public class LG_SconsoleSiteSurveyTest {
    @testSetup
  static void setup() {

    No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    noTriggers.Flag__c = true;
    noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
    upsert noTriggers;

    //Address
        cscrm__Address__c address = new cscrm__Address__c();
        address.Name = 'Address Name';
        address.LG_HouseNumberExtension__c = '2nd floor';
        address.LG_HouseNumber__c = '35';
        address.cscrm__Street__c = 'street';
        address.cscrm__City__c = 'city';
        address.cscrm__Country__c = 'country';
        address.cscrm__Zip_Postal_Code__c = 'T1234';
        insert address;
        
        Site_Survey__c siteSurvey = new Site_Survey__c(Name= 'Site',Date__c = Date.today().addDays(4),Access_Technology__c ='');
        siteSurvey.Address__c = address.Id;
        insert siteSurvey;
        
        Attachment attach = new Attachment(Name = 'Unit Test Attachment', Body = Blob.valueOf('Unit Test Attachment Body'));
        attach.parentId = siteSurvey.Id;
        insert attach;

  }
    
    public static testMethod void TestCodeCoverage() {
        List<Site_Survey__c> siteSurveyList = [SELECT Id,Name,Date__c,Access_Technology__c,Address__c FROM Site_Survey__c ORDER BY Date__c Desc];
        cscrm__Address__c address = [SELECT Id FROM cscrm__Address__c LIMIT 1];
        Test.startTest();
        PageReference pageRef = Page.LG_SconsoleSiteSurveyPage;
    Test.setCurrentPage(pageRef);
    pageRef.getParameters().put('siteId', siteSurveyList[0].Address__c);
        LG_SconsoleSiteSurveyController controller = new LG_SconsoleSiteSurveyController();
        
        controller.siteAttachmentCheck = false;
        controller.getmyfile();
        controller.getSiteSurvey();
        controller.uploadAttachment();
        controller.siteSurveyObject = siteSurveyList[0];
        Attachment attachment = new Attachment();
        attachment.name = 'test attach';
        attachment.body = Blob.valueOf('Unit Test Attachment Body');
        //controller.UpdateSurvey();
        //Test UpdateSurvey
        /*List<Apexpages.Message> successmsgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:successmsgs){
            if (msg.getDetail().contains('Site Survey Updated Successfully')) b = true;
        }
        System.assertEquals(true, b);
        
        //Test UpdateSurvey Negative Scenario
        Site_Survey__c site = new Site_Survey__c();
        controller.siteSurveyObject = site;
        controller.UpdateSurvey();
        List<Apexpages.Message> errormsgs = ApexPages.getMessages();
        b = false;
        for(Apexpages.Message msg:errormsgs){
            if (msg.getDetail().contains('Error updating new Site Survey')) b = true;
        }
        System.assertEquals(true, b);*/
        
        controller.getsiteAttachment();
        System.assertEquals(pageRef.getURL(), controller.PageRefresh().getURL());
        
        //Test deleteAttachment
        Attachment testAttachment = new Attachment();
        testAttachment.name = 'test attach';
        testAttachment.body = Blob.valueOf('Unit Test Attachment Body');
        testAttachment.parentId = siteSurveyList[0].Id;
        insert testAttachment;
        controller.attachment = testAttachment;
        System.assertEquals(true, LG_SconsoleSiteSurveyController.deleteAttachment(testAttachment.Id));
        
        
         boolean b = false;
        //To Test SaveSurvey
        Site_Survey__c siteSurvey_1 = new Site_Survey__c(Name= 'Site1',Date__c = Date.today().addDays(4),Access_Technology__c ='');
        siteSurvey_1.Address__c = address.Id;
        controller.siteSurveyObject = siteSurvey_1;
        controller.myfile = attachment;
        controller.saveSurvey();
        
        
        Site_Survey__c site1 = new Site_Survey__c();
        Attachment attachment1 = new Attachment();
        controller.siteSurveyObject = site1;
        controller.myfile = attachment1;
        controller.saveSurvey();
        List<Apexpages.Message> saveSurveyErrormsgs = ApexPages.getMessages();
        b = false;
        for(Apexpages.Message msg:saveSurveyErrormsgs){
            System.debug('msg.getDetail()'+msg.getDetail());
            if (msg.getDetail().contains('Error creating new Site Survey')) b = true;
        }
        System.assertEquals(true, b);
        PageReference closePage = Page.c__LG_SConsoleCloseTab;
        System.assertEquals(closePage.getURL(), controller.cancel().getURL());
        
        Test.stopTest();
    }

}