/**
* Test class for LG_ServiceProvisioningStep
*
* @author ALisha
* @ticket SFOM-672
* @since  20/06/2017
*
*`New Version:
* @author Ankur Gupta
* @ticket SFOM-2296
* @since  13/12/2017
*/
@isTest
public class LG_ServiceProvisioningBackgroundStepTest {
    
    @testSetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        Account acc = LG_GeneralTest.CreateAccount('OMTestAccount', '321654987', 'Test', true);
        acc.LG_ChamberOfCommerceNumber__c='123';
        update acc;
        
        csconta__Billing_Account__c billingAcc = LG_GeneralTest.createBillingAccount('SFDT-59 Bill1', acc.Id, true, true);
        
        Contact c = new contact();
        c.Salutation = 'Mr.';
        c.LastName   = 'test';
        c.AccountId  = acc.id;
        c.Email = 'test@gtr.com';
        c.Phone = '9850027690';
        insert c;
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, true);
        
        cscrm__Address__c address = LG_GeneralTest.crateAddress('TestAddress', 'street', 'city', '5', '73', '2014GC', 'Netherlands', acc, true);
        address.LG_AddressID__c = '123456';
        address.LG_TechnicalContact__c = c.id;
        upsert address ;
        
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('TestBasket', acc, null, opp, true);
        
        // Generate Product Definition
        cscfga__Product_Definition__c prodDef = LG_GeneralTest.createProductDefinition('ProdDef58', false);
        prodDef.LG_NeedsActivation__c   = 'Y,Y,Y';
        prodDef.LG_NeedsInstallation__c = 'N,N,N';
        insert prodDef;
        
        // Generate Product Definition
        cscfga__Product_Definition__c prodDefEmpty = LG_GeneralTest.createProductDefinition('ProdDef58', false);
        prodDefEmpty.LG_NeedsActivation__c = '';
        insert prodDefEmpty;
        
        // Generate Product Configuration
        cscfga__Product_Configuration__c prodConfig = LG_GeneralTest.createProductConfiguration('ProdConf58', 3, basket, prodDef, true);
        prodConfig.LG_Address__c = address.id;
        update prodConfig;
        
        // Generate Product Configuration
        cscfga__Product_Configuration__c prodConfigEmpty = LG_GeneralTest.createProductConfiguration('ProdConfEmpty', 3, basket, prodDefEmpty, true);
        basket.csordtelcoa__Synchronised_with_Opportunity__c=true;
        update basket;
        
        csord__Order_Request__c orderRequest = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert orderRequest;
        
        csord__Order__c order = LG_GeneralTest.createOrder('Company Internet', acc, 'In Progress', orderRequest, opp, true);
        
        csord__Solution__c suborder = new csord__Solution__c ();
        suborder.Name = 'test';
        suborder.csord__Order__c = order.Id;
        suborder.csord__Identification__c = 'Test';
        suborder.csord__Account__c = acc.id;
        suborder.LG_Address__c = address.id;
        suborder.UM_No_of_Tries__c = 1;
        suborder.csord__Order_Request__c  = orderRequest.id;
        suborder.LG_InstallationWishDate__c = System.today() + 10;
        suborder.LG_TargetDate__c = System.today();
        suborder.csord__Status__c   = 'In Progress';
        insert suborder;
        
        csord__Subscription__c subscription = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = orderRequest.Id);
        subscription.LG_Address__c     = address.Id;
        subscription.csord__Account__c   = acc.Id;
        subscription.csord__Order__c   = order.Id;
        subscription.csord__Solution__c = suborder.Id;
        subscription.csconta__Billing_Account__c = billingAcc.id;
        insert subscription;             
        
        csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestService', csord__Subscription__c = subscription.Id, csord__Order_Request__c = orderRequest.Id);
        service.LG_Address__c   = address.Id;
        service.LG_Suborder__c  = suborder.id;
        service.LG_ProductFamily__c  = 'Company Internet';
        service.LG_ServiceStatus__c = 'Activation Completed';
        service.LG_ProvisioningCode__c = '1PLAY150B';
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
    
    @isTest static void testCallOutSuccess()
    {
        List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__r.name='Orch Process'];
        
        CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c )steps[0];
        System.assertNotEquals('Complete' ,step.CSPOFA__Status__c, 'Status should not be complete before callout');   
        
        Test.setMock(WebServiceMock.class, new UM_PlaceOrderBackgroundMock());
        
        Test.startTest();
        LG_ServiceProvisioningBackgroundStep testCaMaCallout = new LG_ServiceProvisioningBackgroundStep();
        testCaMaCallout.performCallouts(steps);
        testCaMaCallout.process(steps);    
        Test.stopTest(); 
        
        csord__solution__c solution = [SELECT Id, LG_Integration_Status__c, LG_Provisioning_External_Id__c,LG_Integration_Description__c, LG_Jeopardy__c, LG_JeopardyExplanation__c,
                                       Jeopardy_Reason__c,UM_No_of_Tries__c  FROM csord__Solution__c WHERE name = 'test'];
        
        List<Note> notes = [SELECT Id, body FROM Note WHERE ParentId = :solution.id];
        
        System.assertEquals(0, notes.size());
        System.assertEquals('Request Acknowledged', solution.LG_Integration_Status__c);
        System.assertEquals('Success', solution.LG_Integration_Description__c);
        System.assertEquals(false, solution.LG_Jeopardy__c);
        System.assertEquals(null, solution.Jeopardy_Reason__c);
        System.assertEquals(null, solution.LG_JeopardyExplanation__c);
        System.assertEquals('1234567', solution.LG_Provisioning_External_Id__c);
        System.assertEquals(1, solution.UM_No_of_Tries__c);
    }
    
    @isTest static void testCallOutFailure()
    {
        List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__r.name='Orch Process'];
        
        CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c )steps[0];
        System.assertNotEquals('Complete' ,step.CSPOFA__Status__c, 'Status should not be complete before callout');   
        
        cscrm__Address__c address = [SELECT Id,LG_AddressID__c FROM  cscrm__Address__c WHERE Name = 'TestAddress'];
        address.LG_AddressID__c = '223456';
        update address;
        
        Test.setMock(WebServiceMock.class, new UM_PlaceOrderBackgroundMock());
        
        Test.startTest();
        LG_ServiceProvisioningBackgroundStep testCaMaCallout = new LG_ServiceProvisioningBackgroundStep();
        testCaMaCallout.performCallouts(steps);
        testCaMaCallout.process(steps);    
        Test.stopTest(); 
        
        csord__solution__c solution = [SELECT Id, LG_Integration_Status__c, LG_Provisioning_External_Id__c,LG_Integration_Description__c, LG_Jeopardy__c, LG_JeopardyExplanation__c,
                                       Jeopardy_Reason__c,UM_No_of_Tries__c  FROM csord__Solution__c WHERE name = 'test'];
        List<Note> notes = [SELECT Id, body FROM Note WHERE ParentId = :solution.id];
        
        System.assertEquals(0, notes.size());
        System.assertEquals('Timeout', solution.LG_Integration_Status__c);
        System.assertEquals('Middleware Timeout', solution.LG_Integration_Description__c);
        System.assertEquals(true, solution.LG_Jeopardy__c);
        System.assertEquals('MiddleWare Timeout', solution.Jeopardy_Reason__c);
        System.assertEquals(Label.LG_Orch_Retries_Error, solution.LG_JeopardyExplanation__c);
        System.assertEquals(null, solution.LG_Provisioning_External_Id__c);
        System.assertEquals(3, solution.UM_No_of_Tries__c);
    }
    
    @isTest static void testCallOutException()
    {
        List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__r.name='Orch Process'];
        
        CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c )steps[0];
        System.assertNotEquals('Complete' ,step.CSPOFA__Status__c, 'Status should not be complete before callout');   
        
        cscrm__Address__c address = [SELECT Id,LG_AddressID__c FROM  cscrm__Address__c WHERE Name = 'TestAddress'];
        address.LG_AddressID__c = '323456';
        update address;
        
        Test.setMock(WebServiceMock.class, new UM_PlaceOrderBackgroundMock());
        
        Test.startTest();
        LG_ServiceProvisioningBackgroundStep testCaMaCallout = new LG_ServiceProvisioningBackgroundStep();
        testCaMaCallout.performCallouts(steps);
        testCaMaCallout.process(steps);    
        Test.stopTest(); 
        
        csord__solution__c solution = [SELECT Id, LG_Integration_Status__c, LG_Provisioning_External_Id__c,LG_Integration_Description__c, LG_Jeopardy__c, LG_JeopardyExplanation__c,
                                       Jeopardy_Reason__c,UM_No_of_Tries__c  FROM csord__Solution__c WHERE name = 'test'];
        
        List<Note> notes = [SELECT Id, body FROM Note WHERE ParentId = :solution.id];
        
        System.assertEquals(1, notes.size());
        System.assertEquals('SFDC failure', solution.LG_Integration_Status__c);
        System.assertEquals(Label.LG_JiraJeopardyError , solution.LG_Integration_Description__c);
        System.assertEquals(true, solution.LG_Jeopardy__c);
        System.assertEquals('SFDC failure', solution.Jeopardy_Reason__c);
        System.assertEquals(Label.LG_JiraJeopardyError, solution.LG_JeopardyExplanation__c);
        System.assertEquals(null, solution.LG_Provisioning_External_Id__c);
    }
}