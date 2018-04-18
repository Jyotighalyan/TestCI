@isTest
public class LG_ServiceCancellableTypeStepTest
{

  @testSetup
    private static void setupTestData() {
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        Account account = LG_GeneralTest.CreateAccount('Test ServiceCancellable', '12345678', 'UM', true);
        
        csconta__Billing_Account__c billingAcc = LG_GeneralTest.createBillingAccount('SFDT-59 Bill1', account.Id, true, true);
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
        
        csord__Order_Request__c orderRequest = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert orderRequest;
        
        csord__Order__c order = LG_GeneralTest.createOrder('Company Fibre',account,'In Progress',orderRequest, opp, true);
        
        cscrm__Address__c address = LG_GeneralTest.crateAddress('TestAddress', 'street', 'city', '5', '73', '2014GC', 'Netherlands', account, true);
        
        csord__Solution__c suborder = new csord__Solution__c();
        suborder.Name               = 'UM Company Fiber - 123456';
        suborder.csord__Account__c  = account.id;
        suborder.csord__Order__c    = order.id;
        suborder.LG_Address__c     = address.id;
        suborder.csord__Status__c   = 'In Progress';
        suborder.csord__Identification__c = 'UM Company Fiber - 123456';
        suborder.csord__Order_Request__c  = orderRequest.id;
        suborder.LG_InstallationWishDate__c = System.today() + 10;
        suborder.LG_TargetDate__c = System.today();
        insert suborder;
        
        csord__Subscription__c subscription = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = orderRequest.Id);
        subscription.LG_Address__c     = address.Id;
        subscription.csord__Account__c   = account.Id;
        subscription.csord__Order__c   = order.Id;
        subscription.csord__Solution__c = suborder.Id;
        subscription.csconta__Billing_Account__c = billingAcc.id;
        insert subscription;             
        
        csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestService', csord__Subscription__c = subscription.Id, csord__Order_Request__c = orderRequest.Id);
        service.LG_Address__c   = address.Id;
        service.LG_Suborder__c  = suborder.id;
        service.LG_ProductFamily__c    ='Company Fibre';
        service.UM_JiraIssueTypeId__c = '11201';
        service.LG_DecompositionCriteria__c='Set 17 - Charges';
        service.UM_Cancellation__c='Daily';
        insert service;
        
        csord__Service__c addOnService1 = new csord__Service__c(Name = 'Company Cloud Fibre', csord__Identification__c = 'TestService', csord__Subscription__c = subscription.Id, csord__Order_Request__c = orderRequest.Id);
        addOnService1.LG_Address__c   = address.Id;
        addOnService1.LG_Suborder__c  = suborder.id;
        addOnService1.csord__Order__c = order.id;
        addOnService1.csord__Service__c = service.Id;
        addOnService1.LG_DecompositionCriteria__c='Set 17 - Charges';
        addOnService1.UM_Cancellation__c='Monthly';
        insert addOnService1;

        csord__Solution__c suborder1 = new csord__Solution__c();
        suborder1.Name               = 'UM Company Service - 123456';
        suborder1.csord__Account__c  = account.id;
        suborder1.csord__Order__c    = order.id;
        suborder1.LG_Address__c     = address.id;
        suborder1.csord__Status__c   = 'In Progress';
        suborder1.csord__Identification__c = 'UM Company Fiber - 123456';
        suborder1.csord__Order_Request__c  = orderRequest.id;
        suborder1.LG_InstallationWishDate__c = System.today() + 10;
        suborder1.LG_TargetDate__c = System.today();
        insert suborder1;
        
        csord__Service__c service1 = new csord__Service__c(Name = 'Access 50 Gold', csord__Identification__c = 'TestService', csord__Subscription__c = subscription.Id, csord__Order_Request__c = orderRequest.Id);
        service1.LG_Address__c   = address.Id;
        service1.LG_Suborder__c  = suborder1.id;
        service1.csord__Order__c = order.id;
        service1.csord__Service__c = service.Id;
        insert service1;
        
        CSPOFA__Orchestration_Process_Template__c processTemplate = new CSPOFA__Orchestration_Process_Template__c();
        processTemplate.Name = 'Process template';
        insert processTemplate;
        
        CSPOFA__Orchestration_Process__c orchProcess = new CSPOFA__Orchestration_Process__c();
        orchProcess.Name = 'Orch Process';
        orchProcess.CSPOFA__Process_On_Hold__c = false;
        orchProcess.CSPOFA__Orchestration_Process_Template__c = processTemplate.Id;
        orchProcess.LG_Solution__c = suborder.Id;
        insert orchProcess;
        
        CSPOFA__Orchestration_Process_Template__c processTemplate1 = new CSPOFA__Orchestration_Process_Template__c();
        processTemplate1.Name = 'Process template1';
        insert processTemplate1;
        
        CSPOFA__Orchestration_Process__c orchProcess1 = new CSPOFA__Orchestration_Process__c();
        orchProcess1.Name = 'Orch Process1';
        orchProcess1.CSPOFA__Process_On_Hold__c = false;
        orchProcess1.CSPOFA__Orchestration_Process_Template__c = processTemplate1.Id;
        orchProcess1.LG_Solution__c = suborder1.Id;
        insert orchProcess1;
        
        List<CSPOFA__Orchestration_Step__c> steps = new List<CSPOFA__Orchestration_Step__c>();
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = orchProcess.Id));
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = orchProcess1.Id));
        insert steps;
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }

 @isTest
    private static void processTest() {
        
        List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c];
        
        CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c )steps[0];
        System.assertNotEquals('Complete' ,step.CSPOFA__Status__c, 'Status should not be complete before callout');
        
        Test.startTest();
        
        LG_ServiceCancellableTypeStep updateServiceCancellable = new LG_ServiceCancellableTypeStep();
        steps = updateServiceCancellable.process(steps);
        System.assertEquals('Complete', step.CSPOFA__Status__c, 'Status should be complete');
        Test.stopTest();
        
    }



}