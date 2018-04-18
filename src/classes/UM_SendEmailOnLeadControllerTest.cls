@isTest
public with sharing class UM_SendEmailOnLeadControllerTest {
    private static testMethod void testSendEmail(){
        
        Group smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = smeQueueID.id);
        insert cs;
        
        Lead objLead= LG_GeneralTest.createLead('Maatschap T.A. Aanhane', 'test@test.com', 'Ms.', 'H.', 'Bleij', '', '06-18452681', '', 'Not Contacted', '34189218', 'On-Net', true, true, 10, 5, 'Low', 'De Heining', '9', 'B', '1161AC', 'ZWANENBURG', 'Netherlands', true);
        UM_ProductInterest__c objPI1=LG_GeneralTest.createProductInterest(objLead, 'Office Internet', 10, 5, 2, 50, 12,20, true);
        UM_ProductInterest__c objPI2=LG_GeneralTest.createProductInterest(objLead, 'Company Fiber', 10, 5, 2, 50, 12,20, true);
        UM_ProductInterest__c objPI3=LG_GeneralTest.createProductInterest(objLead, 'Office Internet & Phone',null ,null ,null ,null ,null ,null , true);
        UM_ProductInterest__c objPI4=LG_GeneralTest.createProductInterest(objLead, 'Company Fiber', null,null ,null ,null ,null ,null, true);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(objLead);
        UM_SendEmailOnLeadController extCon = new UM_SendEmailOnLeadController(stdCon);
        Pagereference pRef=Page.UM_SendEmailOnLead;
        pRef.getParameters().put('id', objLead.Id);
        Test.setCurrentPageReference(pRef);
        
        Blob b = Blob.valueOf('Test Data');  
        list<Attachment> lstAttachment=new list<Attachment>();
        Attachment attachment1 = new Attachment();  
        attachment1.ParentId = objPI1.Id;  
        attachment1.Name = 'Test Attachment for Parent';  
        attachment1.Body = b;  
        lstAttachment.add(attachment1);
        Attachment attachment2 = new Attachment();  
        attachment2.ParentId = objPI2.Id;  
        attachment2.Name = 'Test Attachment for Parent';  
        attachment2.Body = b;       
        lstAttachment.add(attachment2);  
        insert lstAttachment; 
        
        LG_EnvironmentVariables__c envVariables = new LG_EnvironmentVariables__c();     
        envVariables.LG_CloudSenceAnywhereIconID__c = 'csaID';
        envVariables.LG_ServiceAvailabilityIconID__c = 'saIconId';
        envVariables.UM_ProductInterestCOAXEmail__c = UserInfo.getUserEmail();
        envVariables.UM_ProductInterestFiberEmail__c = UserInfo.getUserEmail();
        insert envVariables;
        
        test.startTest();
        extCon.sendEmail();
        test.stopTest();
    }
}