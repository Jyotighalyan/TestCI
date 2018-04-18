@isTest
public class UM_ValidateJiraFormTest {
    
    @testSetup
    public static void testData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        Account account = LG_GeneralTest.CreateAccount('Test Jira', '12345678', 'UM', true);
        account.LG_PostalHouseNumber__c = '5';
        account.LG_PostalStreet__c = 'street';
        account.LG_PostalCity__c = 'city';
        account.LG_PostalPostalCode__c = '12354';
        update account;
        
        csconta__Billing_Account__c billingAcc = LG_GeneralTest.createBillingAccount('SFDT-59 Bill1', account.Id, true, true);
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
        
        csord__Order_Request__c orderRequest = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert orderRequest;
        
        csord__Order__c order = LG_GeneralTest.createOrder('Company Fibre',account,'In Progress',orderRequest, opp, true);
        
        cscrm__Address__c address = LG_GeneralTest.crateAddress('TestAddress', 'street', 'city', '5', '73', '2014GC', 'Netherlands', account, true);
        address.GNV__c = 'Nicht erforderlich';
        address.Consulting_Id__c = '123456';
        update address;
        
        csord__Solution__c suborder = new csord__Solution__c();
        suborder.Name               = 'UM JIRA Fiber - 123456';
        suborder.csord__Account__c  = account.id;
        suborder.csord__Order__c    = order.id;
        suborder.LG_Address__c      = address.id;
        suborder.csord__Status__c   = 'In Progress';
        suborder.csord__Identification__c = 'UM JIRA Fiber - 123456';
        suborder.csord__Order_Request__c  = orderRequest.id;
        suborder.LG_InstallationWishDate__c = System.today() + 10;
        suborder.LG_TargetDate__c = System.today();
        insert suborder;
        
        csord__Subscription__c subscription = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = orderRequest.Id);
        subscription.LG_Address__c      = address.Id;
        subscription.csord__Account__c  = account.Id;
        subscription.csord__Order__c    = order.Id;
        subscription.csord__Solution__c = suborder.Id;
        subscription.csconta__Billing_Account__c = billingAcc.id;
        insert subscription;                
        
        csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestService', csord__Subscription__c = subscription.Id, csord__Order_Request__c = orderRequest.Id);
        service.LG_Address__c   = address.Id;
        service.LG_Suborder__c  = suborder.id;
        service.LG_RootOrder__c = order.id;
        service.LG_ProductFamily__c   ='Company Fibre';
        service.UM_JiraIssueTypeId__c = '12101';
        insert service;
        
        CSPOFA__Orchestration_Process_Template__c processTemplate = new CSPOFA__Orchestration_Process_Template__c();
        processTemplate.Name = 'Process template';
        insert processTemplate;
        
        CSPOFA__Orchestration_Process__c orchProcess = new CSPOFA__Orchestration_Process__c();
        orchProcess.Name = 'Orch Process';
        orchProcess.CSPOFA__Process_On_Hold__c = false;
        orchProcess.CSPOFA__Orchestration_Process_Template__c = processTemplate.Id;
        orchProcess.LG_Solution__c = suborder.Id;
        insert orchProcess;
        
        List<CSPOFA__Orchestration_Step__c> steps = new List<CSPOFA__Orchestration_Step__c>();
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = orchProcess.Id));
        insert steps;
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    
    @isTest static void testValidForm()
    {
        List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__r.name='Orch Process'];
        
        CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c )steps[0];
        System.assertNotEquals('Complete' ,step.CSPOFA__Status__c, 'Status should not be complete before callout');
        
        cscrm__address__c address = [SELECT Id,cscrm__state_province__c FROM cscrm__address__c WHERE Name = 'TestAddress' ];
        address.cscrm__state_province__c = 'NRW';
        update address;
        
        Test.startTest();
        UM_ValidateJiraForm testJira = new UM_ValidateJiraForm();
        testJira.process(steps);    
        Test.stopTest(); 
        
        csord__solution__c solution = [SELECT Id, LG_Integration_Status__c, LG_Integration_Description__c, LG_Jeopardy__c, LG_JeopardyExplanation__c,
                                       Jeopardy_Reason__c,UM_No_of_Tries__c  FROM csord__Solution__c WHERE name = 'UM JIRA Fiber - 123456'];
        
        List<Note> notes = [SELECT Id, body FROM Note WHERE ParentId = :solution.id];
        
        System.assertEquals('Complete' , step.CSPOFA__Status__c);
        System.assertEquals(0, notes.size());     
        System.assertEquals(false , solution.LG_Jeopardy__c);
        System.assertEquals(null , solution.LG_JeopardyExplanation__c);
        System.assertEquals(null , solution.LG_Integration_Description__c);
    }
    
    @isTest static void testInvalidForm()
    {
        List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__r.name='Orch Process'];
        
        CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c )steps[0];
        System.assertNotEquals('Complete' ,step.CSPOFA__Status__c, 'Status should not be complete before callout');
        
        Test.startTest();
        UM_ValidateJiraForm testJira = new UM_ValidateJiraForm();
        testJira.process(steps);    
        Test.stopTest(); 
        
        csord__solution__c solution = [SELECT Id, LG_Integration_Status__c, LG_Integration_Description__c, LG_Jeopardy__c, LG_JeopardyExplanation__c,
                                       Jeopardy_Reason__c,UM_No_of_Tries__c  FROM csord__Solution__c WHERE name = 'UM JIRA Fiber - 123456'];
        
        List<Note> notes = [SELECT Id, body FROM Note WHERE ParentId = :solution.id];
        
        System.assertEquals('Complete' , step.CSPOFA__Status__c); 
        System.assertEquals(0 , notes.size());
        System.assertEquals(1,solution.UM_No_of_Tries__c );
        System.assertEquals(true , solution.LG_Jeopardy__c);     
        System.assertEquals('JIRA Order Creation Failed' , solution.Jeopardy_Reason__c);
        System.assertEquals('JIRA Order Creation Failed', solution.LG_Integration_Status__c);
        System.assertEquals('These field values cannot be left blank: {cscrm__Address__c={cscrm__state_province__c}}' , solution.LG_JeopardyExplanation__c);
        System.assertEquals('These field values cannot be left blank: {cscrm__Address__c={cscrm__state_province__c}}' , solution.LG_Integration_Description__c);
    }
    
    @isTest static void testGeneralException()
    {
        List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__r.name='Orch Process'];
        
        CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c )steps[0];
        System.assertNotEquals('Complete' ,step.CSPOFA__Status__c, 'Status should not be complete before callout');
        
        //This will create exception during call of createJiraOrder method call from UM_ValidateJiraForm class
        csord__service__c service = [SELECT Id,UM_JiraIssueTypeId__c FROM csord__service__c WHERE UM_JiraIssueTypeId__c = '12101'];
        service.UM_JiraIssueTypeId__c = null;
        update service;
        
        Test.startTest();
        UM_ValidateJiraForm testJira = new UM_ValidateJiraForm();
        testJira.process(steps);    
        Test.stopTest(); 
        
        csord__solution__c solution = [SELECT Id, LG_Integration_Status__c, LG_Integration_Description__c, LG_Jeopardy__c, LG_JeopardyExplanation__c,
                                       Jeopardy_Reason__c,UM_No_of_Tries__c  FROM csord__Solution__c WHERE name = 'UM JIRA Fiber - 123456'];
        
        List<Note> notes = [SELECT Id, body FROM Note WHERE ParentId = :solution.id];
        
        System.assertEquals('Complete' , step.CSPOFA__Status__c);
        System.assertEquals(1, notes.size()); 
        System.assertEquals(true , solution.LG_Jeopardy__c);
        System.assertEquals('SFDC failure' , solution.Jeopardy_Reason__c);
        System.assertEquals('SFDC failure', solution.LG_Integration_Status__c);
    }
}