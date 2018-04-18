@isTest
public class LG_AppointmentReminderEmailHandlerTest {
	 static testMethod void TestinBoundEmail()
   {
       csord__Solution__c sol = new csord__Solution__c();
       sol.name='test Sol';
       sol.csord__Identification__c='123';
       insert sol; 
       List<RecordType> caseRecordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND Name IN ('Install', 'Provision', 'Number Port', 'Activate Service', 'Access Planning')];

       Case cse = new Case(LG_solution__c=sol.Id);
       cse.Status = 'New';
        cse.RecordTypeId = caseRecordTypes[0].Id;
       cse.Type = '';
       insert cse;
       // create a new email and envelope object
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
       Case c1 = [Select id,casenumber FROM Case WHERE id=:cse.id];
       // setup the data for the email
       email.subject = 'Create reminder';
       email.fromAddress = 'someaddress@email.com';
       email.plainTextBody = 'email body\n2225256325\nTitle Case#:'+c1.casenumber;
      
      
      // call the email service class and test it with the data in the testMethod
      LG_AppointmentReminderEmailHandler  handler=new LG_AppointmentReminderEmailHandler ();
      handler.handleInboundEmail(email, env);
      system.assertEquals(1, Limits.getEmailInvocations());
    
   }
}