@istest
public class UM_UpdateJiraNotificationsTest
{
    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        Account account = LG_GeneralTest.CreateAccount('Test Jira', '12345678', 'UM', true);
        
        csconta__Billing_Account__c billingAcc = LG_GeneralTest.createBillingAccount('SFDT-59 Bill1', account.Id, true, true);
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
        
        csord__Order_Request__c orderRequest = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert orderRequest;
        
        csord__Order__c order = LG_GeneralTest.createOrder('Company Fibre',account,'In Progress',orderRequest, opp, true);
        
        cscrm__Address__c address = LG_GeneralTest.crateAddress('TestAddress', 'street', 'city', '5', '73', '2014GC', 'Netherlands', account, true);
        
        csord__Solution__c suborder = new csord__Solution__c();
        suborder.Name               = 'UM JIRA Fiber - 123456';
        suborder.csord__Account__c  = account.id;
        suborder.csord__Order__c    = order.id;
        suborder.LG_Address__c      = address.id;
        suborder.csord__Status__c   = 'In Progress';
        suborder.csord__Identification__c = 'UM JIRA Fiber - 123456';
        suborder.csord__Order_Request__c  = orderRequest.id;
        suborder.LG_InstallationWishDate__c = System.today() + 10;
        suborder.LG_TargetDate__c = System.today();
        suborder.LG_ProvisioningWorkOrder__c = 'BBS-2111';
        suborder.LG_Integration_Description__c = 'Success';
        suborder.LG_Integration_Status__c = 'JIRA Work Order Created';
        insert suborder;
        
        csord__Subscription__c subscription = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = orderRequest.Id);
        subscription.LG_Address__c      = address.Id;
        subscription.csord__Account__c  = account.Id;
        subscription.csord__Order__c    = order.Id;
        subscription.csord__Solution__c = suborder.Id;
        subscription.csconta__Billing_Account__c = billingAcc.id;
        insert subscription;             
        
        csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestService', csord__Subscription__c = subscription.Id, csord__Order_Request__c = orderRequest.Id);
        service.LG_Address__c   = address.Id;
        service.LG_Suborder__c  = suborder.id;
        service.LG_ProductFamily__c   ='Company Fibre';
        service.UM_JiraIssueTypeId__c = '12101';
        service.LG_ServiceStatus__c = 'Provisioned';
        service.LG_DecompositionCriteria__c = 'Set 7 - JIRA Fiber';
        insert service;
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
        
    }
    
    @isTest static void  testMissingIssueId()
    {
        String JsonMsg='{'+
            '"issue_id": "",'+
            '"status": "",'+
            '"service_date": "2017-11-20",'+
            '"cancellation_reason": "test",'+
            '"cancellation_description": "test",'+
            '"additional_hour": "test",'+
            '"additional_work_note": "test",'+
            '"service_id": "1234"'+
            '}';
        
        getRestContext(JsonMsg);
       User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       System.runAs(thisUser)
       {
            Test.startTest();       
            UM_UpdateJiraNotifications.updateJiraNotifications();
            Test.stopTest();
        } 
    }
    
    @isTest static void  testNoServiceUpdate()
    {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser)
        { 
            String JsonMsg='{'+
                '"issue_id": "BBS-2111",'+
                '"status": "OFFEN",'+                   
                '"service_date": "2017-11-20",'+
                '"service_id": "123456"'+
                '}';
            
            getRestContext(JsonMsg);
            
            Test.startTest();       
            UM_UpdateJiraNotifications.updateJiraNotifications();
            Test.stopTest();
            
            csord__solution__c suborder = [SELECT id, LG_Jira_Status__c,LG_Integration_Status__c,LG_TargetDate__c 
                                           FROM csord__solution__c WHERE Name = 'UM JIRA Fiber - 123456'];
            
            System.assertEquals('OFFEN', suborder.LG_Jira_Status__c);
            System.assertEquals('JIRA Work Order Created', suborder.LG_Integration_Status__c);
        }
    }
    
    @isTest static void  testInProgressUpdate()
    {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser)
        { 
            String JsonMsg='{'+
                '"issue_id": "BBS-2111",'+
                '"status": "Prüfen - Termin",'+
                '"service_date": "2017-11-20",'+
                '"service_id": "123456"'+
                '}';
            
            getRestContext(JsonMsg);
            
            Test.startTest();       
            UM_UpdateJiraNotifications.updateJiraNotifications();
            
            csord__solution__c suborder = [SELECT id, LG_Jira_Status__c,LG_Integration_Status__c,LG_TargetDate__c 
                                           FROM csord__solution__c WHERE Name = 'UM JIRA Fiber - 123456'];
            
            System.assertEquals('PRÜFEN - TERMIN', suborder.LG_Jira_Status__c);
            System.assertEquals('Installation In-Progress', suborder.LG_Integration_Status__c);
            System.assertEquals(Date.valueOf('2017-11-20'), suborder.LG_TargetDate__c);
            
            List<LG_ScheduleAppointment__c> apptList = [SELECT id FROM LG_ScheduleAppointment__c WHERE LG_Solution__c = :suborder.Id];
            
            System.assertEquals(1, apptList.size());
            
            String JsonMsg1='{'+
                '"issue_id": "BBS-2111",'+
                '"status": "PRUFEN – TERMIN",'+        
                '"service_date": "2017-11-21",'+
                '"service_id": "123456"'+
                '}';
            
            getRestContext(JsonMsg1);
            
            UM_UpdateJiraNotifications.updateJiraNotifications();
            Test.stopTest();
            
            csord__solution__c suborder1 = [SELECT id, LG_Jira_Status__c,LG_Integration_Status__c,LG_TargetDate__c 
                                            FROM csord__solution__c WHERE Name = 'UM JIRA Fiber - 123456'];
            List<LG_ScheduleAppointment__c> apptList1 = [SELECT id,LG_AgreedInstallDate__c FROM LG_ScheduleAppointment__c WHERE LG_Solution__c = :suborder1.Id];
            
            System.assertEquals(1, apptList1.size());
            System.assertEquals(Date.valueOf('2017-11-21'), apptList1[0].LG_AgreedInstallDate__c);
        }
    }
    
    @isTest static void  testInstallationCompleteUpdate()
    {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser)
        { 
            String JsonMsg='{'+
                '"issue_id": "BBS-2111",'+
                '"status": "IN FERTIGMELDUNG",'+               
                '"service_date": "2017-11-20",'+
                '"additional_work_note": "test",'+
                '"additional_hour": "test",'+
                '"cancellation_description": "not cancelled",'+
                '"service_id": "123456"'+
                '}';
            
            getRestContext(JsonMsg);
            
            Test.startTest();       
            UM_UpdateJiraNotifications.updateJiraNotifications();
            Test.stopTest();
            
            csord__solution__c suborder = [SELECT id, LG_Jira_Status__c,LG_Integration_Status__c,LG_TargetDate__c 
                                           FROM csord__solution__c WHERE Name = 'UM JIRA Fiber - 123456'];
            
            System.assertEquals('IN FERTIGMELDUNG', suborder.LG_Jira_Status__c);
            System.assertEquals('Installation Complete', suborder.LG_Integration_Status__c);
            System.assertEquals(Date.valueOf('2017-11-20'), suborder.LG_TargetDate__c);
            
            csord__service__c service = [SELECT id, LG_ServiceStatus__c,csord__activation_date__c 
                                         FROM csord__service__c WHERE LG_Suborder__c = :suborder.Id];
            
            System.assertEquals(Date.valueOf('2017-11-20'), service.csord__activation_date__c);
            //System.assertEquals('Ready for Billing', service.LG_ServiceStatus__c);
        }
    }
    
    @isTest static void  testNoServiceDateUpdate()
    {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser)
        { 
            String JsonMsg='{'+
                '"issue_id": "BBS-2111",'+
                '"status": "IN FERTIGMELDUNG",'+                
                '"service_date": "",'+
                '"service_id": "123456"'+
                '}';
            
            getRestContext(JsonMsg);
            
            Test.startTest();       
            UM_UpdateJiraNotifications.updateJiraNotifications();
            Test.stopTest();
            
            csord__solution__c suborder = [SELECT id, LG_Jira_Status__c,LG_Integration_Status__c,LG_TargetDate__c 
                                           FROM csord__solution__c WHERE Name = 'UM JIRA Fiber - 123456'];
            
            System.assertEquals('IN FERTIGMELDUNG', suborder.LG_Jira_Status__c);
            System.assertEquals('Installation Complete', suborder.LG_Integration_Status__c);
            System.assertEquals(Date.Today(), suborder.LG_TargetDate__c);
            
            csord__service__c service = [SELECT id, LG_ServiceStatus__c,csord__activation_date__c FROM csord__service__c 
                                         WHERE LG_Suborder__c = :suborder.Id];
            
            System.assertEquals(Date.TODAY(), service.csord__activation_date__c);
            //System.assertEquals('Ready for Billing', service.LG_ServiceStatus__c);
        } 
    }
    
    @isTest static void  testException()
    {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser)
        { 
            String JsonMsg='{'+
                '"issue_id": "BBS-2111",'+
                '"status": "IN FERTIGMELDUNG",'+                
                '"service_date": "2017.11.20",'+
                '"service_id": "123456"'+
                '}';
            
            getRestContext(JsonMsg);
            
            Test.startTest();       
            UM_UpdateJiraNotifications.updateJiraNotifications();
            Test.stopTest();
            
            csord__solution__c suborder = [SELECT id, LG_Jira_Status__c,LG_Integration_Status__c,LG_TargetDate__c 
                                           FROM csord__solution__c WHERE Name = 'UM JIRA Fiber - 123456'];
            
            System.assertEquals('SFDC failure', suborder.LG_Integration_Status__c);
            System.assertEquals(Date.Today(), suborder.LG_TargetDate__c);
            
            csord__service__c service = [SELECT id, LG_ServiceStatus__c,csord__activation_date__c FROM csord__service__c 
                                         WHERE LG_Suborder__c = :suborder.Id];
            
            System.assertEquals(null, service.csord__activation_date__c);
            System.assertEquals('Provisioned', service.LG_ServiceStatus__c);
            
            List<Note> notes = [SELECT id from Note where parentId= :suborder.Id];
            
            System.assertEquals(1, notes.size());
        }
    }
    
    @isTest static void  testCancelJiraOrder()
    {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser)
        { 
            String JsonMsg='{'+
                '"issue_id": "BBS-2111",'+
                '"status": "GESCHLOSSEN",'+                
                '"service_date": "2017-11-20",'+
                '"cancellation_reason": "test",'+
                '"service_id": "123456"'+
                '}';
            
            getRestContext(JsonMsg);
            
            Test.startTest();       
            UM_UpdateJiraNotifications.updateJiraNotifications();
            Test.stopTest();
            
            csord__solution__c suborder = [SELECT id, LG_Jira_Status__c,LG_Integration_Status__c,LG_TargetDate__c 
                                           FROM csord__solution__c WHERE Name = 'UM JIRA Fiber - 123456'];
            
            System.assertEquals('GESCHLOSSEN', suborder.LG_Jira_Status__c);
            System.assertEquals('JIRA Initiated Cancellation', suborder.LG_Integration_Status__c);
        }
    }
    
    @isTest static void  testInterimEmails()
    {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser)
        { 
            String JsonMsg='{'+
                '"issue_id": "BBS-2111",'+
                '"status": "WARTEN - TIEFBAU",'+                
                '"service_date": "2017-11-20",'+
                '"assignee_email_address": "ankur_gupta55@infosys.com",'+
                '"service_id": "123456"'+
                '}';
            
            getRestContext(JsonMsg);
            
            Test.startTest();       
            UM_UpdateJiraNotifications.updateJiraNotifications();
            Test.stopTest();
            
            csord__solution__c suborder = [SELECT id, LG_Jira_Status__c,LG_Integration_Status__c,LG_TargetDate__c 
                                           FROM csord__solution__c WHERE Name = 'UM JIRA Fiber - 123456'];
            
            System.assertEquals('WARTEN - TIEFBAU', suborder.LG_Jira_Status__c);
        }
    }
    
    static void getRestContext(String jsonString){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/UM_UpdateJiraNotifications'; 
        req.requestBody = Blob.valueof(jsonString);
        
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
    }
}