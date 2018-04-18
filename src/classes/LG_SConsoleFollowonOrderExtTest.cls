@isTest
public class LG_SConsoleFollowonOrderExtTest {
	@testSetup
     static void createTestData()
     {
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
         insert oOr;
         
         csord__Solution__c solutionObject = new csord__Solution__c ();
         solutionObject.Name = 'test';
         solutionObject.csord__Order__c =oOr.id;
         solutionObject.csord__Identification__c = 'Test';
         solutionObject.csord__Order_Request__c= orderObj.id;
         insert solutionObject;
         List<RecordType> caseRecordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND Name IN ('Install', 'Provision', 'Number Port', 'Activate Service', 'Access Planning')];

         case c= new case();
         c.LG_Order__c =oOr.id;
         c.LG_Solution__c= solutionObject.id;
         c.RecordTypeId = caseRecordTypes[0].Id;
         c.Status = 'New';
         insert c;
     }
    static testMethod void testController() 
    {
        Case c = [SELECT id,LG_Order__c,LG_Solution__c,ContactId, RecordType.Name FROM Case LIMIT 1];
    	LG_SConsoleFollowonOrderExtension controller = new LG_SConsoleFollowonOrderExtension(new ApexPages.StandardController(c));
    	controller.getOrder();
        controller.getSolution();
        controller.getRecordType();
    }
    static testMethod void testControllerNoRelatedRecords() 
    {
         List<RecordType> caseRecordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND Name IN ('Install', 'Provision', 'Number Port', 'Activate Service', 'Access Planning')];

         case cse= new case();
         cse.Status = 'New';
          cse.RecordTypeId = caseRecordTypes[0].Id;
         insert cse;
         LG_SConsoleFollowonOrderExtension controller = new LG_SConsoleFollowonOrderExtension(new ApexPages.StandardController(cse));
    	 controller.getOrder();
         controller.getSolution();
         
    }
}