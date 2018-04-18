@isTest
public class LG_SConsoleOrderCancelTest {
    
    @testSetup
    static void setup() {
    
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        /*Contact con = new Contact();
        con.FirstName = 'First Name';
        con.LastName = 'Last Name';
        con.Email = 'test@organization.com';
        insert con;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Opportunity';
        opp.OwnerId = con;
        insert opp;*/
        
        Profile prof = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User usr = new User();
         usr.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
         usr.LastName = 'last';
         usr.Email = 'test@libertyglobal.com';
         usr.Username = 'buytest@libertyglobal.com' + System.currentTimeMillis();
         usr.CompanyName = 'TEST';
         usr.Title = 'title';
         usr.Alias = 'alias';
         usr.TimeZoneSidKey = 'America/Los_Angeles';
         usr.EmailEncodingKey = 'UTF-8';
         usr.LanguageLocaleKey = 'en_US';
         usr.LocaleSidKey = 'en_US';
        insert usr;
        
        csord__Order_Request__c orderObj = new csord__Order_Request__c();
        orderObj.name = 'Test';
        orderObj.csord__Module_Name__c ='Test';
        orderObj.csord__Module_Version__c = 'Test';
        orderObj.csord__Process_Status__c = 'Requested';
        orderObj.csord__Request_DateTime__c = system.today();
        insert orderObj;
         
        csord__Order__c oOr = new csord__Order__c();
        oOr.Name = 'Test';
        oOr.csord__Status2__c = 'New';
        oOr.csord__Identification__c = 'Test';
        oOr.csord__Order_Request__c =orderObj.id;
        //oOr.csordtelcoa__Opportunity__c = opp.Id;
        insert oOr;
         
         CSPOFA__Orchestration_Process_Template__c processTemplate = new CSPOFA__Orchestration_Process_Template__c();
         processTemplate.Name = 'Process template';
         insert processTemplate;
         
                  
         csord__Solution__c solutionObject = new csord__Solution__c ();
         solutionObject.Name = 'test';
         solutionObject.csord__Order__c =oOr.id;
         solutionObject.csord__Identification__c = 'Test';
         solutionObject.csord__Order_Request__c= orderObj.id;
         insert solutionObject;
        
        CSPOFA__Orchestration_Process__c orchProcess = new CSPOFA__Orchestration_Process__c();
        orchProcess.Name = 'Orch Process';
        orchProcess.CSPOFA__Orchestration_Process_Template__c = processTemplate.Id;
        orchProcess.CSPOFA__Process_On_Hold__c = false;
        orchProcess.LG_Solution__c = solutionObject.Id;
        insert orchProcess;
         
         
         List<RecordType> caseRecordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND Name IN ('Install', 'Provision', 'Number Port', 'Activate Service', 'Access Planning')];

         case c= new case();
         c.LG_Order__c =oOr.id;
         c.LG_Solution__c= solutionObject.id;
         c.Status = 'New';
         c.OwnerId = usr.Id; 
         c.RecordTypeId = caseRecordTypes[0].Id;
         insert c;
     }
     
     
     static testMethod void testController() 
    {
        Case c = [SELECT id,LG_Order__c,LG_Solution__c,ContactId, RecordType.Name,Status FROM Case LIMIT 1];
        csord__Order__c order = [SELECT id,csord__Status2__c FROM csord__Order__c LIMIT 1];
        csord__Solution__c solutionObject = [SELECT id,Name FROM csord__Solution__c LIMIT 1];
        CSPOFA__Orchestration_Process__c orchProcess = [SELECT Id, Name, Owner.Email, CSPOFA__Process_On_Hold__c FROM CSPOFA__Orchestration_Process__c LIMIT 1];
        LG_SConsoleOrderCancelExtension controller = new LG_SConsoleOrderCancelExtension(new ApexPages.StandardController(c));
        Test.StartTest();
        controller.getOrder();
        controller.getSolution();
        controller.getOrderCancelDetail();
        controller.getRecordType();
        controller.cancelConfirmed();
        controller.cancelCancelled();
        //controller.sendEmail();
        system.assertEquals(order.Id, controller.getOrder().Id);
        system.assertEquals(solutionObject.Id, controller.getSolution()[0].Id);
        
        
        controller.rowVal = 0;
        controller.changeOrchStatus();
        system.assertEquals(true, controller.orderCancelDetail[0].orchestrator.CSPOFA__Process_On_Hold__c);
        
        
        Test.stopTest();
        
    }
    
}