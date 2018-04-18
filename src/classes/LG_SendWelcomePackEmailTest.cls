@isTest
public class LG_SendWelcomePackEmailTest {
    @testSetup 
    static void setup() {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        //Account
        Account account = new Account(Name = 'Send mail test Account');
        insert account;
        
        //Order
        csord__Order__c order = new csord__Order__c(Name='Test Order',csord__Identification__c = '6465467986',csord__Account__c = account.Id);
        insert order;
        
        //Solution
        csord__Solution__c solution = new csord__Solution__c(Name = 'test solution',csord__Identification__c = '6465467986',csord__Order__c=order.Id);
        insert solution;
        
        CSPOFA__Orchestration_Process_Template__c processTemplate = new CSPOFA__Orchestration_Process_Template__c();
        processTemplate.Name = 'Process template';
        insert processTemplate;
        
        CSPOFA__Orchestration_Process__c orchProcess = new CSPOFA__Orchestration_Process__c();
        orchProcess.Name = 'Orch Process';
        orchProcess.CSPOFA__Process_On_Hold__c = false;
        orchProcess.CSPOFA__Orchestration_Process_Template__c = processTemplate.Id;
        orchProcess.LG_Solution__c = solution.Id;
        insert orchProcess;
        
        List<CSPOFA__Orchestration_Step__c> steps = new List<CSPOFA__Orchestration_Step__c>();
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = orchProcess.Id));
        insert steps;
        
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'IdentSub');
        insert sub;
        
    }
    public static testMethod void TestSendEmail(){
        csord__Solution__c s = [select Id from csord__Solution__c where name = 'test solution' limit 1];
        Test.startTest();
        LG_SendWelcomePackEmail.SendEmail(s.Id);
        Test.stopTest();
    }
    
    public static testMethod void testProcess(){
        List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__r.name='Orch Process'];
        System.debug('Steps' + steps);
        
        csord__Solution__c sol=[select id,name,csord__Account__c,csord__Account__r.NumberOfEmployees, csord__Account__r.LG_ChamberOfCommerceNumber__c,LG_Address__r.cscrm__State_Province__c,LG_Address__c,LG_Address__r.LG_AddressID__c,csord__Status__c,csord__Order__c from csord__Solution__c where name = 'test solution'];
        
        for (SObject obj : steps) {
            CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
            System.assertNotEquals('Complete', step.CSPOFA__Status__c, 'Status should not be complete');
        }
        
        LG_SendWelcomePackEmail sendEmail = new LG_SendWelcomePackEmail();
        
        Test.startTest();
        steps = sendEmail.process(steps);
        Test.stopTest();
      
        for (SObject obj : steps) {
            CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
            System.assertEquals('Complete', step.CSPOFA__Status__c, 'Complete');
        }
    }
}