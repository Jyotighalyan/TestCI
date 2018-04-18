/**
* Test class for UM_JiraEmailTemplateDetailsExtn
*
* @author Ankur Gupta
* @ticket SFOM-2588
* @since  14/03/2018
*/
@isTest
public class UM_JiraEmailTemplateDetailsExtnTest 
{
    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        insert new JiraAssigneeData__c(Name='Assignee User', AssigneeEmail__c='assigneeemail@um.de', AssigneeMobile__c='123456', AssigneePhone__c='654321');
        
        Account account = LG_GeneralTest.CreateAccount('Test Jira', '12345678', 'UM', true);
        
        csconta__Billing_Account__c billingAcc = LG_GeneralTest.createBillingAccount('SFDT-59 Bill1', account.Id, true, true);
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
        
        csord__Order_Request__c orderRequest = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert orderRequest;
        
        csord__Order__c order = LG_GeneralTest.createOrder('Company Fibre',account,'In Progress',orderRequest, opp, true);
        
        cscrm__Address__c address = LG_GeneralTest.crateAddress('TestAddress', 'street', 'city', '5', '73', '2014GC', 'Netherlands', account, true);
        address.cscrm__State_Province__c= 'BW';
        update address;
        
        csord__Solution__c suborder = new csord__Solution__c();
        suborder.Name               = 'UM JIRA Fiber - 123456';
        suborder.csord__Account__c  = account.id;
        suborder.csord__Order__c    = order.id;
        suborder.LG_Address__c      = address.id;
        suborder.csord__Status__c   = 'In Progress';
        suborder.csord__Identification__c = 'UM JIRA Fiber - 123456';
        suborder.csord__Order_Request__c  = orderRequest.id;
        suborder.UM_JiraAssigneeName__c = 'Assignee User';
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
		service.UM_DownloadSpeed__c = 100;
        insert service;
        
        Document document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'my_document';
        document.IsPublic = true;
        document.Name = 'Jira_UMLogo';
        document.FolderId = [SELECT id FROM Folder WHERE name = 'Unitymedia Resources'].id;
        insert document;
            
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    
    @isTest static void testAssigneeDetails()
    {
        User thisUser = [SELECT ID FROM User WHERE ID = :UserInfo.getUserId()];
        System.runAs(thisUser)
        {
            csord__Solution__c suborder = [SELECT id,name FROM csord__Solution__c WHERE name='UM JIRA Fiber - 123456'];
            
            UM_JiraEmailTemplateDetailsExtn assigneeDetails = new UM_JiraEmailTemplateDetailsExtn();
            assigneeDetails.suborderId = suborder.id;
            assigneeDetails.attrName = 'Name';
            
            Test.startTest();
            JiraAssigneeData__c assignee  = assigneeDetails.getAssigneeDetails();
            csord__service__c srvc = assigneeDetails.getServiceDetails();
            assigneeDetails.getLogoUrl();
            
            System.assertEquals('Assignee User', assignee.Name);
            System.assertEquals('assigneeemail@um.de', assignee.AssigneeEmail__c);
            System.assertEquals('123456', assignee.AssigneeMobile__c);
            System.assertEquals('654321', assignee.AssigneePhone__c); 
            System.assertEquals(100, srvc.UM_DownloadSpeed__c);
            
            suborder.UM_JiraAssigneeName__c = '';
            update suborder;
            System.assertEquals(null, assigneeDetails.getAssigneeDetails());
            
            Test.stopTest();
        }
    }
    
    @isTest static void testAddressDetails()
    {
        User thisUser = [SELECT ID FROM User WHERE ID = :UserInfo.getUserId()];
        System.runAs(thisUser)
        {
            csord__Solution__c suborder = [SELECT id,name,LG_Address__c FROM csord__Solution__c WHERE name='UM JIRA Fiber - 123456'];
            
            cscrm__address__c address = [SELECT id, cscrm__State_Province__c FROM cscrm__address__c WHERE id = : suborder.LG_Address__c];
            
            UM_JiraEmailTemplateDetailsExtn assigneeDetails = new UM_JiraEmailTemplateDetailsExtn();
            assigneeDetails.suborderId = suborder.id;
            
            Test.startTest();
            
            String addr  = assigneeDetails.getAddressDetails();
            System.assertEquals(Label.UM_AddressForBW, addr);
            
            address.cscrm__State_Province__c = 'HSN';
            update address;
            addr  = assigneeDetails.getAddressDetails();
           	System.assertEquals(Label.UM_AddressForHSN, addr);
            
            address.cscrm__State_Province__c = 'NRW';
            update address;
            addr  = assigneeDetails.getAddressDetails();
           	System.assertEquals(Label.UM_AddressForNRW, addr);
            
            address.cscrm__State_Province__c = 'BE';
            update address;
            System.assertEquals(null, assigneeDetails.getAddressDetails());
            
            Test.stopTest();
        }
    }
}