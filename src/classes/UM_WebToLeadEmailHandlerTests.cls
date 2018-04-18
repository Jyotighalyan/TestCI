@IsTest
private class UM_WebToLeadEmailHandlerTests {

    static testMethod void myTestMethod() {
        
        Group smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = smeQueueID.id);
        insert cs;
        
        Lead tmpLead = LG_GeneralTest.CreateLead('Maatschap T.A. Aanhane', 'some@test.com', 'Ms.', 'George', 'Savaropulos', '', '06-18452681', '', 'Not Contacted', '34189218', 'On-Net', true, true, 10, 5, 'Low', 'De Heining', '9', 'B', '1161AC', 'ZWANENBURG', 'Netherlands');
        // Create a new email and envelope object
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        String lemail = 'some@test.com';
            
        // Create the email body
        email.plainTextBody = 'Product: Company Internet\nCompany: Bushwalz\nPLZ: 00-AA123\nOrt: Germany\nStreet: Drilling Street\nStreetNo: 143\nSalutation: Mr.\nFirstName: George\nLastName: Savaropulos\nPhoneNo: +3106778776\nEmail: '+lemail+'\nMessage: This is my important message to you so please keep it in mind that we need this information.';

        email.fromAddress ='mark@test.com';
        String contactEmail = 'alan@test.com';
        email.ccAddresses = new String[] {'Alan Doe <' + contactEmail + '>'};
        email.subject = 'Dummy Account Name 123';
        
        UM_WebToLeadEmailHandler wte = new UM_WebToLeadEmailHandler();
        
        Test.startTest();
        Messaging.InboundEmailResult result = wte.handleInboundEmail(email, env);
        Test.stopTest();

        Lead newLead = [SELECT FirstName, LastName FROM Lead WHERE email=:lemail LIMIT 1];
        System.assertEquals ('George', newLead.FirstName);
        System.assertEquals ('Savaropulos', newLead.LastName);
    }
}