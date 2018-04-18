@isTest
public class UM_ValidateIbanTest {

    @isTest static void testValidateIbanLead() {
        
         Group smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = smeQueueID.id);
        insert cs;

        Lead tmpLead = LG_GeneralTest.CreateLead('Recaro', 'test@test.com', 'Ms.', 'H.', 'Borg', '', '06-18452681', '', 'Not Contacted', '34189218', 'On-Net', true, true, 10, 5, 'Low', 'Flughafen Allee', '25', '', '28199', 'Bremen', 'Germany');
        tmpLead.LG_BankAccountNumberIBAN__c = 'DE853701005001234566503';
        update tmpLead;

        UM_WebserviceCredentials__c setting = new UM_WebserviceCredentials__c();
        setting.Name = 'UM_TolerantWS';
        setting.Login__c = 'tLogin';
        setting.Password__c = 'tPassword';
        insert setting;

        Test.startTest();

        Test.setMock(WebServiceMock.class, new UM_IbanResponseMock());
        
        //System.assertEquals('IBAN number verified', UM_ValidateIban.checkIbanWebservice( tmpLead.Id ));
        
        Test.stopTest();
    }

   @isTest static void testValidateWrongIbanLead() {
       
       Group smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = smeQueueID.id);
        insert cs;

        Lead tmpLead = LG_GeneralTest.CreateLead('Recaro', 'test@test.com', 'Ms.', 'H.', 'Borg', '', '06-18452681', '', 'Not Contacted', '34189218', 'On-Net', true, true, 10, 5, 'Low', 'Flughafen Allee', '25', '', '28199', 'Bremen', 'Germany');
        tmpLead.LG_BankAccountNumberIBAN__c = 'DE3343701005001234566112';
        update tmpLead;

        UM_WebserviceCredentials__c setting = new UM_WebserviceCredentials__c();
        setting.Name = 'UM_TolerantWS';
        setting.Login__c = 'tLogin';
        setting.Password__c = 'tPassword';
        insert setting;

        Test.startTest();

        // Mock different response
        Test.setMock(WebServiceMock.class, new UM_IbanResponseMock());
        //System.assertEquals('IBAN Number could not be verified', UM_ValidateIban.checkIbanWebservice( tmpLead.Id ));
        
        Test.stopTest();
    }

   @isTest static void testValidateIbanNoWebserviceLead() {
		
       Group smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = smeQueueID.id);
        insert cs;
       
        Lead tmpLead = LG_GeneralTest.CreateLead('Recaro', 'test@test.com', 'Ms.', 'H.', 'Borg', '', '06-18452681', '', 'Not Contacted', '34189218', 'On-Net', true, true, 10, 5, 'Low', 'Flughafen Allee', '25', '', '28199', 'Bremen', 'Germany');
        tmpLead.LG_BankAccountNumberIBAN__c = 'DE853701005001234566503';
        update tmpLead;

        UM_WebserviceCredentials__c setting = new UM_WebserviceCredentials__c();
        setting.Name = 'UM_TolerantWS';
        setting.Login__c = 'tLogin';
        setting.Password__c = '';
        insert setting;

        Test.startTest();

        Test.setMock(WebServiceMock.class, new UM_IbanResponseMock());
        UM_ValidateIban.checkIbanWebservice( tmpLead.Id ); 

        //System.assertEquals('123654', c.addressResponse.address.get(0).buildingId);
        
        Test.stopTest();
    }

    @isTest static void testValidateNoIbanLead() {
        
        Group smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = smeQueueID.id);
        insert cs;

        Lead tmpLead = LG_GeneralTest.CreateLead('Recaro', 'test@test.com', 'Ms.', 'H.', 'Borg', '', '06-18452681', '', 'Not Contacted', '34189218', 'On-Net', true, true, 10, 5, 'Low', 'Flughafen Allee', '25', '', '28199', 'Bremen', 'Germany');

        UM_WebserviceCredentials__c setting = new UM_WebserviceCredentials__c();
        setting.Name = 'UM_TolerantWS';
        setting.Login__c = 'tLogin';
        setting.Password__c = 'tPassword';
        insert setting;

        Test.startTest();

        UM_ValidateIban.checkIbanWebservice( tmpLead.Id ); 

        Test.stopTest();
    }

}