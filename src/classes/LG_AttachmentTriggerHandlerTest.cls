@isTest
private class LG_AttachmentTriggerHandlerTest
{
    @isTest
    private static  void testAttachmentTrigger()
    {
        CSCAP__Click_Approve_Setting__c clickApproveSettingObj = New CSCAP__Click_Approve_Setting__c();
        clickApproveSettingObj.Name = 'Site Approve - Opportunity';
        clickApproveSettingObj.CSCAP__Approve_Email_Message__c='test';
        clickApproveSettingObj.CSCAP__Reject_Email_Message__c='test';
        clickApproveSettingObj.CSCAP__Reject_Email_New__c='test';
        clickApproveSettingObj.CSCAP__Status__c='Active';
      clickApproveSettingObj.CSCAP__Send_PIN_Using__c= 'Email';
        clickApproveSettingObj.CSCAP__Send_PIN_Email_Template__c='Customer Approval Site CA PIN New';
        clickApproveSettingObj.CSCAP__Sites_Approval_Title__c='Virgin Media Business Order';
        clickApproveSettingObj.CSCAP__Sites_Approval_Header__c='Virgin Media Business Order';
        insert clickApproveSettingObj;
        Account testAccount = new Account(Name='testAccount');
        insert testAccount;
        system.assertEquals('testAccount', testAccount.Name);
        
        Contact testContact = new Contact(FirstName = 'TestName', LastName = 'TestName', Salutation ='Mr.', email = 'test@test.com',AccountId=testAccount.id);
        insert testContact;
        system.assertEquals('TestName', testContact.FirstName);
        
        
        Opportunity testOpportunity = new Opportunity(amount=500,CloseDate = system.today().addMonths(4),Name = 'TestOpp', StageName = 'Awareness of interest', AccountId =testAccount.id,LG_AutomatedQuoteDelivery__c='Quote Requested');
        insert testOpportunity;
        system.assertEquals('TestOpp', testOpportunity.Name);
        List<OpportunityContactRole> newContactRoleList = new List<OpportunityContactRole>();
        newContactRoleList.add(new OpportunityContactRole(ContactId=testContact.id,OpportunityId=testOpportunity.Id,Role='Administrative Contact',IsPrimary=true));
        //newContactRoleList.add(new OpportunityContactRole(ContactId=testContact.id,OpportunityId=testOpportunity.Id,Role='Administrative Contact',IsPrimary=False));
        //newContactRoleList.add(new OpportunityContactRole(ContactId=testContact.id,OpportunityId=testOpportunity.Id,Role='Other',IsPrimary=False));

        insert newContactRoleList;
        Blob b = Blob.valueOf('Test Data');
            
        Attachment attachment = new Attachment();
        attachment.ParentId = testOpportunity.id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        Test.startTest();
        insert(attachment);
        Test.stopTest();
        
    
    }
    @isTest
    private static  void testAttachmentTriggerAdminContactWithNoName()
    {
        CSCAP__Click_Approve_Setting__c clickApproveSettingObj = New CSCAP__Click_Approve_Setting__c();
        clickApproveSettingObj.Name = 'Site Approve - Opportunity';
        clickApproveSettingObj.CSCAP__Approve_Email_Message__c='test';
        clickApproveSettingObj.CSCAP__Reject_Email_Message__c='test';
        clickApproveSettingObj.CSCAP__Reject_Email_New__c='test';
        clickApproveSettingObj.CSCAP__Status__c='Active';
    	clickApproveSettingObj.CSCAP__Send_PIN_Using__c= 'Email';
        clickApproveSettingObj.CSCAP__Send_PIN_Email_Template__c='Customer Approval Site CA PIN New';
        clickApproveSettingObj.CSCAP__Sites_Approval_Title__c='Virgin Media Business Order';
        clickApproveSettingObj.CSCAP__Sites_Approval_Header__c='Virgin Media Business Order';
        insert clickApproveSettingObj;
        Account testAccount = new Account(Name='testAccount');
        insert testAccount;
        system.assertEquals('testAccount', testAccount.Name);
        
        Contact testContact = new Contact(FirstName = 'TestName', LastName = 'TestName', Salutation ='Mr.', email = 'test@test.com',AccountId=testAccount.id);
        insert testContact;
        system.assertEquals('TestName', testContact.FirstName);
        
        
        Opportunity testOpportunity = new Opportunity(amount=500,CloseDate = system.today().addMonths(4),Name = 'TestOpp', StageName = 'Awareness of interest', AccountId =testAccount.id,LG_AutomatedQuoteDelivery__c='Quote Requested');
        insert testOpportunity;
        system.assertEquals('TestOpp', testOpportunity.Name);
        //List<OpportunityContactRole> newContactRoleList = new List<OpportunityContactRole>();
        //newContactRoleList.add(new OpportunityContactRole(ContactId=testContact.id,OpportunityId=testOpportunity.Id,Role='Administrative Contact',IsPrimary=true));
        //newContactRoleList.add(new OpportunityContactRole(ContactId=testContact.id,OpportunityId=testOpportunity.Id,Role='Administrative Contact',IsPrimary=False));
        //newContactRoleList.add(new OpportunityContactRole(ContactId=testContact.id,OpportunityId=testOpportunity.Id,Role='Other',IsPrimary=False));

        //insert newContactRoleList;
        Blob b = Blob.valueOf('Test Data');
            
        Attachment attachment = new Attachment();
        attachment.ParentId = testOpportunity.id;
        attachment.Name = Label.LG_LegalDocName;
        attachment.Body = b;
        Test.startTest();
        insert(attachment);
        Test.stopTest();
        
    }
}