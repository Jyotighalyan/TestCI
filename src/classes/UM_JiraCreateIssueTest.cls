@isTest
public class UM_JiraCreateIssueTest 
{    
    @testSetup
    public static void testData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        Account account = LG_GeneralTest.CreateAccount('Test Jira', '12345678', 'UM', true);
        account.LG_PostalHouseNumber__c = '5';
        account.LG_PostalStreet__c = 'street';
        account.LG_PostalCity__c = 'city';
        account.LG_PostalPostalCode__c = '12354';
        update account;
        
        csconta__Billing_Account__c billingAcc = LG_GeneralTest.createBillingAccount('SFDT-59 Bill1', account.Id, true, true);
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
        
        csord__Order_Request__c orderRequest = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert orderRequest;
        
        csord__Order__c order = LG_GeneralTest.createOrder('Company Fibre',account,'In Progress',orderRequest, opp, true);
        
        cscrm__Address__c address = LG_GeneralTest.crateAddress('TestAddress', 'street', 'city', '5', '73', '2014GC', 'Netherlands', account, true);
        address.cscrm__state_province__c = 'NRW';
        address.GNV__c = 'Nicht erforderlich';
        address.Consulting_Id__c = '123456';
        update address;
        
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
        insert suborder;
        
        csord__Subscription__c subscription = new csord__Subscription__c(Name = 'Test Sub', csord__Identification__c = 'TestIdent', csord__Order_Request__c = orderRequest.Id);
        subscription.LG_Address__c      = address.Id;
        subscription.csord__Account__c  = account.Id;
        subscription.csord__Order__c    = order.Id;
        subscription.csconta__Billing_Account__c = billingAcc.id;
        insert subscription;                
        
        csord__Service__c service = new csord__Service__c(Name = 'Company Fiber' , csord__Identification__c = 'TestService', csord__Subscription__c = subscription.Id, csord__Order_Request__c = orderRequest.Id);
        service.LG_Address__c   = address.Id;
        service.LG_Suborder__c  = suborder.id;
        service.LG_RootOrder__c = order.id;
        service.LG_ProductFamily__c   = 'Company Fiber';
        service.UM_JiraIssueTypeId__c = '12101';
        service.LG_AdditionalInformation__c = 'Additional Information for CF';
        insert service;
        
         //for BGP
        csord__Solution__c suborderBGP = new csord__Solution__c();
        suborderBGP.Name               = 'UM JIRA BGP Service - 123456';
        suborderBGP.csord__Account__c  = account.id;
        suborderBGP.csord__Order__c    = order.id;
        suborderBGP.LG_Address__c      = address.id;
        suborderBGP.csord__Status__c   = 'In Progress';
        suborderBGP.csord__Identification__c = 'BGP - 123456';
        suborderBGP.csord__Order_Request__c  = orderRequest.id;
        suborderBGP.LG_InstallationWishDate__c = System.today() + 10;
        suborderBGP.LG_TargetDate__c = System.today();
        insert suborderBGP;
        
        csord__Service__c serviceBGP = new csord__Service__c(Name = 'BGP 35 Platinum', csord__Identification__c = 'TestServiceBGP', csord__Subscription__c = subscription.Id, csord__Order_Request__c = orderRequest.Id);
        serviceBGP.LG_Address__c   = address.Id;
        serviceBGP.LG_Suborder__c  = suborderBGP.id;
        serviceBGP.LG_RootOrder__c = order.id;
        serviceBGP.LG_ProductFamily__c   = 'Company Fiber';
        serviceBGP.UM_JiraIssueTypeId__c = '12008';
        serviceBGP.csord__Service__c = service.Id;
        serviceBGP.UM_AS_Number__c = 1.234;
        serviceBGP.UM_Announced_prefix__c = 'test';
        serviceBGP.UM_BGP_Password__c = 'testPassword';
        serviceBGP.UM_IPv4__c = 'testIpv4';
        serviceBGP.UM_IPv6__c = 'testIpv6';
        serviceBGP.LG_SLA__c = 'Platinum';
        serviceBGP.UM_DownloadSpeed__c = 35;
        serviceBGP.LG_AdditionalInformation__c = 'Additional Information for BGP';
        insert serviceBGP;
        
        //for Access
        csord__Solution__c suborderAccess = new csord__Solution__c();
        suborderAccess.Name               = 'UM JIRA Access Service - 123456';
        suborderAccess.csord__Account__c  = account.id;
        suborderAccess.csord__Order__c    = order.id;
        suborderAccess.LG_Address__c      = address.id;
        suborderAccess.csord__Status__c   = 'In Progress';
        suborderAccess.csord__Identification__c = 'Access - 123456';
        suborderAccess.csord__Order_Request__c  = orderRequest.id;
        suborderAccess.LG_InstallationWishDate__c = System.today() + 10;
        suborderAccess.LG_TargetDate__c = System.today();
        insert suborderAccess;
        
        csord__Service__c serviceAccess = new csord__Service__c(Name = 'Access 35 Gold', csord__Identification__c = 'TestServiceAccess', csord__Subscription__c = subscription.Id, csord__Order_Request__c = orderRequest.Id);
        serviceAccess.LG_Address__c   = address.Id;
        serviceAccess.LG_Suborder__c  = suborderAccess.id;
        serviceAccess.LG_RootOrder__c = order.id;
        serviceAccess.LG_ProductFamily__c   = 'Company Fiber';
        serviceAccess.UM_JiraIssueTypeId__c = '12008';
        serviceAccess.csord__Service__c = service.Id;
        serviceAccess.UM_DownloadSpeed__c = 35;
        serviceAccess.LG_SLA__c = 'Gold';
        serviceAccess.UM_Access_Active_IPv4__c = '29 - 5 nutzbare IP-Adressen';
        serviceAccess.UM_Access_Active_IPv6__c = '56 - 256 nutzbare Subnetze';
        serviceAccess.UM_Access_Transfer_IPv4__c = 'Wird bereitgestellt von Unitymedia';
        serviceAccess.UM_Access_Transfer_IPv6__c = 'Wird bereitgestellt von Unitymedia';
        serviceAccess.LG_AdditionalInformation__c = 'Additional Information for Access';
        insert serviceAccess;
        
        //for Comapny Cloud Fiber -- SFOM-2665 -- Start
        csord__Solution__c suborderCCF = new csord__Solution__c();
        suborderCCF.Name               = 'UM JIRA CCF Service - 123456';
        suborderCCF.csord__Account__c  = account.id;
        suborderCCF.csord__Order__c    = order.id;
        suborderCCF.LG_Address__c      = address.id;
        suborderCCF.csord__Status__c   = 'In Progress';
        suborderCCF.csord__Identification__c = 'Access - 123456';
        suborderCCF.csord__Order_Request__c  = orderRequest.id;
        suborderCCF.LG_InstallationWishDate__c = System.today() + 10;
        suborderCCF.LG_TargetDate__c = System.today();
        insert suborderCCF;
        
        csord__Service__c serviceCCF = new csord__Service__c(Name = 'Company Cloud Fiber 25', csord__Identification__c = 'TestServiceAccess', csord__Subscription__c = subscription.Id, csord__Order_Request__c = orderRequest.Id);
        serviceCCF.LG_Address__c   = address.Id;
        serviceCCF.LG_Suborder__c  = suborderCCF.id;
        serviceCCF.LG_RootOrder__c = order.id;
        serviceCCF.LG_ProductFamily__c   = 'Company Fiber';
        serviceCCF.UM_JiraIssueTypeId__c = '12008';
        serviceCCF.csord__Service__c = service.Id;
        serviceCCF.UM_DownloadSpeed__c = 25;
        serviceCCF.LG_SLA__c = 'Gold';
        serviceCCF.LG_AdditionalInformation__c = 'Additional Information for CCF';
        insert serviceCCF;
        //SFOM-2665 -- End
            
        //for MWLAN
        csord__Solution__c suborder1 = new csord__Solution__c();
        suborder1.Name               = 'WLAN - 123456';
        suborder1.csord__Account__c  = account.id;
        suborder1.csord__Order__c    = order.id;
        suborder1.LG_Address__c      = address.id;
        suborder1.csord__Status__c   = 'In Progress';
        suborder1.csord__Identification__c = 'WLAN - 123456';
        suborder1.csord__Order_Request__c  = orderRequest.id;
        suborder1.LG_InstallationWishDate__c = System.today() + 10;
        suborder1.LG_TargetDate__c = System.today();
        insert suborder1;
        
        csord__Subscription__c subscription1 = new csord__Subscription__c(Name = 'Test Sub1', csord__Identification__c = 'TestIdent1', csord__Order_Request__c = orderRequest.Id);
        subscription1.LG_Address__c      = address.Id;
        subscription1.csord__Account__c  = account.Id;
        subscription1.csord__Order__c    = order.Id;
        subscription1.csord__Solution__c = suborder1.Id;
        subscription1.csconta__Billing_Account__c = billingAcc.id;
        insert subscription1;                
        
        csord__Service__c service1 = new csord__Service__c(csord__Identification__c = 'TestService1', csord__Subscription__c = subscription1.Id, csord__Order_Request__c = orderRequest.Id);
        service1.LG_Address__c   = address.Id;
        service1.LG_Suborder__c  = suborder1.id;
        service1.LG_RootOrder__c = order.id;
        service1.UM_DependsOnService__c = service.id;
        service1.LG_ProductFamily__c   = 'WLAN';
        service1.UM_JiraIssueTypeId__c = '11401';
        insert service1;
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    
    @isTest static void createJiraFormForCF()
    {
        csord__solution__c suborder = [SELECT Id  FROM csord__Solution__c WHERE name = 'UM JIRA Fiber - 123456'];
        
        Test.startTest();
        UM_JiraCreateIssue.createJiraOrder(suborder);    
        Test.stopTest(); 
        
        System.assertEquals(0, UM_JiraCreateIssue.missingFieldMap.size());
    }
    
    @isTest static void createJiraFormForAccess()
    {
        csord__solution__c suborder = [SELECT Id  FROM csord__Solution__c WHERE name = 'UM JIRA Access Service - 123456'];
        
        Test.startTest();
        UM_JiraCreateIssue.createJiraOrder(suborder);    
        Test.stopTest(); 
        
        System.assertEquals(0, UM_JiraCreateIssue.missingFieldMap.size());
    }
    
    @isTest static void createJiraFormForBGP()
    {
        csord__solution__c suborder = [SELECT Id, LG_Integration_Status__c, LG_Integration_Description__c, LG_Jeopardy__c, LG_JeopardyExplanation__c,
                                       Jeopardy_Reason__c,UM_No_of_Tries__c  FROM csord__Solution__c WHERE name = 'UM JIRA BGP Service - 123456'];
        
        Test.startTest();
        UM_JiraCreateIssue.createJiraOrder(suborder);    
        Test.stopTest(); 
        
        System.assertEquals(0, UM_JiraCreateIssue.missingFieldMap.size());
    }
    //SFOM-2665 -- Start
    @isTest static void createJiraFormForCCF()
    {
        csord__solution__c suborder = [SELECT Id, LG_Integration_Status__c, LG_Integration_Description__c, LG_Jeopardy__c, LG_JeopardyExplanation__c,
                                       Jeopardy_Reason__c,UM_No_of_Tries__c  FROM csord__Solution__c WHERE name = 'UM JIRA CCF Service - 123456'];
        
        
        Account account = [SELECT id FROM Account WHERE Name = 'Test Jira'];
        account.LG_PostalStreet__c = '';
        update account;
        
        Test.startTest();
        UM_JiraCreateIssue.createJiraOrder(suborder);    
        Test.stopTest(); 
        
        System.assertEquals(1, UM_JiraCreateIssue.missingFieldMap.size());
    }
    //SFOM-2665 -- End
    @isTest static void createJiraFormForCFMWLAN()
    {
        csord__solution__c suborder = [SELECT Id, LG_Integration_Status__c, LG_Integration_Description__c, LG_Jeopardy__c, LG_JeopardyExplanation__c,
                                       Jeopardy_Reason__c,UM_No_of_Tries__c  FROM csord__Solution__c WHERE name = 'UM JIRA Fiber - 123456'];
        suborder.LG_ProvisioningWorkOrder__c = 'BBS-123';
        update suborder;
        
        csord__solution__c suborder1 = [SELECT Id, LG_Integration_Status__c, LG_Integration_Description__c, LG_Jeopardy__c, LG_JeopardyExplanation__c,
                                       Jeopardy_Reason__c,UM_No_of_Tries__c  FROM csord__Solution__c WHERE name = 'WLAN - 123456'];
        
        Test.startTest();
        UM_JiraCreateIssue.createJiraOrder(suborder1);    
        Test.stopTest(); 
        
        System.assertEquals(0, UM_JiraCreateIssue.missingFieldMap.size());
    }
    
    @isTest static void createJiraFormForCIMWLAN()
    {
        csord__solution__c suborder = [SELECT Id, LG_Integration_Status__c, LG_Integration_Description__c, LG_Jeopardy__c, LG_JeopardyExplanation__c,
                                       Jeopardy_Reason__c,UM_No_of_Tries__c  FROM csord__Solution__c WHERE name = 'UM JIRA Fiber - 123456'];
        suborder.LG_ProvisioningAccountNo__c = '22451356';
        update suborder;
        
        csord__solution__c suborder1 = [SELECT Id, LG_Integration_Status__c, LG_Integration_Description__c, LG_Jeopardy__c, LG_JeopardyExplanation__c,
                                       Jeopardy_Reason__c,UM_No_of_Tries__c  FROM csord__Solution__c WHERE name = 'WLAN - 123456'];
        
        Test.startTest();
        UM_JiraCreateIssue.createJiraOrder(suborder1);    
        Test.stopTest(); 
        
        System.assertEquals(0, UM_JiraCreateIssue.missingFieldMap.size());
    }
}