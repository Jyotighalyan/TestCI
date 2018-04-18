/**
 * Test class for LG_HpbxImplementationServiceStep
 *
 * @author Ravi Choudhary
 * @ticket SFOM-1237
 * @since  24/07/2017
 */
@isTest
public class LG_HpbxImplementationServiceStepTest{

    @testSetup
    private static void setupTestData() {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;      
       
        
        // Insert two Orders
        List<csord__Order__c> orders = new List<csord__Order__c>();

        orders.add(new csord__Order__c(Name = 'Test Order First', csord__Status2__c = 'In Provisioning', LG_WaitForNewProvide__c = true, csord__Identification__c = '123456789'));
        insert orders;
        
        

        List<csord__Solution__c> solutions = new List<csord__Solution__c>();
        solutions.add(new csord__Solution__c(Name = 'Test Solution First', csord__Order__c = orders[0].Id, csord__Status__c = 'New', csord__Identification__c = '3335558881'));
        insert solutions;
        
        
        List<csord__Subscription__c> subscriptions = new List<csord__Subscription__c>();
        subscriptions.add(new csord__Subscription__c(Name = 'Test Subscription First',  csord__Solution__c = solutions[0].Id, csord__Identification__c = '2335558881'));
        insert subscriptions;
        
        List<csord__Service__c> services = new List<csord__Service__c>();
        services.add(new csord__Service__c(Name = 'Test Service First',LG_ServiceStatus__c ='Active', LG_Suborder__c = solutions[0].Id, csord__Subscription__c = subscriptions[0].Id, csord__Status__c = 'Active', csord__Solution__c = solutions[0].Id, csord__Identification__c = '4445556659',LG_ProductFamily__c = 'SOHO'));
        insert services;
        
        
        // Orcestrator stuff
        CSPOFA__Orchestration_Process_Template__c orcTemplate = new CSPOFA__Orchestration_Process_Template__c();
        insert orcTemplate;

        // Process first Solution
        CSPOFA__Orchestration_Process__c process = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id, LG_Solution__c = solutions[0].Id);
        insert process;

        CSPOFA__Orchestration_Step__c step = new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = process.Id);
        insert step;

        noTriggers.Flag__c = false;
        upsert noTriggers;
    }

    @isTest
    private static void processTest() {

        List<CSPOFA__Orchestration_Process__c> process = [SELECT Id FROM CSPOFA__Orchestration_Process__c];
        
        List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c];

        for (SObject obj : steps) {

            CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
            System.assertNotEquals('Complete', step.CSPOFA__Status__c, 'Status should not be complete');
        }

        Test.startTest();

        LG_HpbxImplementationServiceStep coordinateTermination = new LG_HpbxImplementationServiceStep();
        steps = coordinateTermination.process(steps);

        Test.stopTest();

        for (SObject obj : steps) {
            CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
            System.assertEquals('Complete', step.CSPOFA__Status__c, 'Status should be complete');
        }
    }
    
    
    private static testmethod void testUpdateServices()
    {
        List<CSPOFA__Orchestration_Process__c> process = [SELECT Id FROM CSPOFA__Orchestration_Process__c];
        system.debug('iin test');
        Test.startTest();
        LG_HpbxImplementationServiceStep coordinateTermination = new LG_HpbxImplementationServiceStep();
        coordinateTermination.updateServices(new set<Id>{process[0].Id});
        Test.stopTest();
        csord__Service__c ser= [SELECT Id, LG_ServiceStatus__c FROM csord__Service__c WHERE csord__Identification__c = '4445556659'];      
        System.assertEquals('Provisioned', ser.LG_ServiceStatus__c, 'Status should be Provisioned');
    }
}