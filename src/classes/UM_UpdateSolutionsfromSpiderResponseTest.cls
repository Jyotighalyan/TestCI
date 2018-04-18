/*
*`Test Class for UM_UpdateSolutionsfromSpiderResponse
*
* @author Ankur Gupta
* @ticket SFOM-2297
* @since  13/12/2017
*/

@istest
public class UM_UpdateSolutionsfromSpiderResponseTest
{    
    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c        = true;
        noTriggers.SetupOwnerId   = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        Account acc = LG_GeneralTest.CreateAccount('AccountSFDT', '12345678', 'Ziggo', true);
        
        csconta__Billing_Account__c billingAcc = LG_GeneralTest.createBillingAccount('SFDT-59 Bill1', acc.Id, true, true);

        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, true);
        
        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert coreq;
        
        csord__Order__c  order = LG_GeneralTest.createOrder('Company Internet', acc, 'In Progress', coreq, opp, true);
        
        csord__Solution__c sol = new csord__Solution__c();
        sol.Name = 'UM Company Internet - 6912173';
        sol.csord__Account__c = acc.id;
        sol.csord__Order__c   = order.id;
        sol.csord__Status__c  = 'In Progress';
        sol.LG_Integration_Status__c = 'Request Acknowledged';
        sol.LG_Integration_Description__c = 'Success';
        sol.csord__Identification__c = 'UM Company Internet - 6912173';
        sol.csord__Order_Request__c  = coreq.id;
        sol.LG_TargetDate__c           = System.today();
        sol.LG_InstallationWishDate__c = System.today()+10;
        sol.LG_Provisioning_External_Id__c= '123';
        insert sol;
        
        cscrm__Address__c address = LG_GeneralTest.crateAddress('TestAddress', 'street', 'city', '5', '73', '2014GC', 'Netherlands', acc, true);
        
        csord__Subscription__c subscription = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = coreq.Id);
        subscription.LG_Address__c      = address.Id;
        subscription.csord__Account__c  = acc.Id;
        subscription.csord__Order__c    = order.Id;
        subscription.csord__Solution__c = sol.Id;
        subscription.csconta__Billing_Account__c = billingAcc.id;
        insert subscription;
        
        csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestService', csord__Subscription__c = subscription.Id, csord__Order_Request__c = coreq.Id);
        service.LG_Address__c  = address.Id;
        service.LG_Suborder__c = sol.id;
        service.csord__status__c = 'Requested';
        insert service;

      	Integration_Errors_Translation__c translations = new Integration_Errors_Translation__c();
        translations.Name='Cannot auto-approve a name change';
        translations.Error__c = 'Cannot auto-approve a name change';
        translations.errorInGerman__c= 'Kann eine Namensänderung nicht automatisch genehmigen';
        insert translations;
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    
    @isTest static void testWorkOrderCreated()
    {
        getRestContext();
        
        Test.startTest(); 
        UM_UpdateSolutionsfromSpiderResponse.updateCamaWODetails('123', 'Success', '2245678', '2131646', '','');   
        Test.stopTest();
        
        csord__solution__c solution = [SELECT Id, Name, csord__Status__c, LG_Jeopardy__c, LG_Integration_Status__c, LG_Integration_Description__c,
                                       LG_ProvisioningWorkOrder__c, LG_ProvisioningAccountNo__c FROM csord__solution__c WHERE Name = 'UM Company Internet - 6912173'];
        
        System.assertEquals('In Provisioning', solution.csord__Status__c);
        System.assertEquals('Work Order Created', solution.LG_Integration_Status__c);
        System.assertEquals('Success', solution.LG_Integration_Description__c);
        System.assertEquals('2245678', solution.LG_ProvisioningAccountNo__c);
        System.assertEquals('2131646', solution.LG_ProvisioningWorkOrder__c);
        System.assertEquals(false, solution.LG_Jeopardy__c);
        
        csord__service__c service = [SELECT id, LG_ServiceStatus__c,LG_ProvisioningAccountNo__c FROM csord__service__c 
                                     WHERE LG_Suborder__c = :solution.Id];
        
        System.assertEquals('Provisioned', service.LG_ServiceStatus__c);
        System.assertEquals('2245678', service.LG_ProvisioningAccountNo__c);
        
        List<Note> notes = [SELECT id from Note where parentId= :solution.Id];
        
        System.assertEquals(0, notes.size());
    }
    
    @isTest static void testPendingWorkOrder1()
    {
        getRestContext();
        
        String errors = 'PENDING_ORDER_REASON(Cannot Auto Approve name change)';
        Test.startTest(); 
        UM_UpdateSolutionsfromSpiderResponse.updateCamaWODetails('123', 'Success', '0', '0', '4235678', errors);   
        Test.stopTest();
        
        csord__solution__c solution = [SELECT Id, Name, csord__Status__c, LG_Jeopardy__c, LG_Integration_Status__c, LG_Integration_Description__c,
                                       LG_ProvisioningWorkOrder__c, LG_ProvisioningAccountNo__c FROM csord__solution__c WHERE Name = 'UM Company Internet - 6912173'];
        
        System.assertEquals('In Provisioning', solution.csord__Status__c);
        System.assertEquals('Pending Work Order Created', solution.LG_Integration_Status__c);
        System.assertEquals('Pending Order: PENDING_ORDER_REASON(Cannot Auto Approve name change)', solution.LG_Integration_Description__c);
        System.assertEquals(null, solution.LG_ProvisioningAccountNo__c);
        System.assertEquals('4235678', solution.LG_ProvisioningWorkOrder__c);
        System.assertEquals(false, solution.LG_Jeopardy__c);
        
        csord__service__c service = [SELECT id, LG_ServiceStatus__c,LG_ProvisioningAccountNo__c FROM csord__service__c 
                                     WHERE LG_Suborder__c = :solution.Id];
        
        System.assertEquals('Requested', service.LG_ServiceStatus__c);
        System.assertEquals(null, service.LG_ProvisioningAccountNo__c);
        
        List<Note> notes = [SELECT id from Note where parentId= :solution.Id];
        
        System.assertEquals(0, notes.size());
    }
    
    @isTest static void testPendingWorkOrder2()
    {
        getRestContext();
        
        String errors = 'PENDING_ORDER_REASON(Cannot Auto Approve name change),1000000(Unknown error code: [CM-APIPKG987] ERROR: API error - house master record not found),1000000(Unknown error code: [CM-APIPKG987] ERROR: API error - house master record not found),1000000(Unknown error code: [CM-APIPKG987] ERROR: API error - house master record not found),1000000(Unknown error code: [CM-APIPKG987] ERROR: API error - house master record not found),1000000(Unknown error code: [CM-APIPKG987] ERROR: API error - house master record not found),1000000(Unknown error code: [CM-APIPKG987] ERROR: API error - house master record not found)' +
            ',1000000(Unknown error code: [CM-APIPKG987] ERROR: API error - house master record not found)';
        
        Test.startTest(); 
        UM_UpdateSolutionsfromSpiderResponse.updateCamaWODetails('123', 'Success', '0', '0', '0', errors);   
        Test.stopTest();
        
        csord__solution__c solution = [SELECT Id, Name, csord__Status__c, LG_Jeopardy__c, LG_Integration_Status__c, LG_Integration_Description__c,
                                       LG_ProvisioningWorkOrder__c, LG_ProvisioningAccountNo__c FROM csord__solution__c WHERE Name = 'UM Company Internet - 6912173'];
        
        System.assertEquals('In Provisioning', solution.csord__Status__c);
        System.assertEquals('Pending Work Order Created', solution.LG_Integration_Status__c);
        System.assertEquals(Label.LG_JiraJeopardyError, solution.LG_Integration_Description__c);
        System.assertEquals(null, solution.LG_ProvisioningAccountNo__c);
        System.assertEquals(null, solution.LG_ProvisioningWorkOrder__c);
        System.assertEquals(false, solution.LG_Jeopardy__c);
        
        csord__service__c service = [SELECT id, LG_ServiceStatus__c,LG_ProvisioningAccountNo__c FROM csord__service__c 
                                     WHERE LG_Suborder__c = :solution.Id];
        
        System.assertEquals('Requested', service.LG_ServiceStatus__c);
        System.assertEquals(null, service.LG_ProvisioningAccountNo__c);
        
        List<Note> notes = [SELECT id from Note where parentId= :solution.Id];
        
        System.assertEquals(1, notes.size());
    }
    
    @isTest static void testOrderCreationFailed()
    {
        getRestContext();
        
        String errors = 'PENDING_ORDER_REASON(Cannot Auto Approve name change),1000000(Unknown error code: [CM-APIPKG987] ERROR: API error - house master record not found),1000000(Unknown error code: [CM-APIPKG987] ERROR: API error - house master record not found),1000000(Unknown error code: [CM-APIPKG987] ERROR: API error - house master record not found),1000000(Unknown error code: [CM-APIPKG987] ERROR: API error - house master record not found),1000000(Unknown error code: [CM-APIPKG987] ERROR: API error - house master record not found),1000000(Unknown error code: [CM-APIPKG987] ERROR: API error - house master record not found)' +
            ',1000000(Unknown error code: [CM-APIPKG987] ERROR: API error - house master record not found)';
        
        Test.startTest(); 
        UM_UpdateSolutionsfromSpiderResponse.updateCamaWODetails('123', 'Failure', '0', '0', '0', errors);   
        Test.stopTest();
        
        csord__solution__c solution = [SELECT Id, Name, csord__Status__c, LG_Jeopardy__c, LG_Integration_Status__c, LG_Integration_Description__c,
                                       LG_ProvisioningWorkOrder__c, LG_ProvisioningAccountNo__c FROM csord__solution__c WHERE Name = 'UM Company Internet - 6912173'];
        
        System.assertEquals('In Progress', solution.csord__Status__c);
        System.assertEquals('Order Creation Failed', solution.LG_Integration_Status__c);
        System.assertEquals(Label.LG_JiraJeopardyError, solution.LG_Integration_Description__c);
        System.assertEquals(null, solution.LG_ProvisioningAccountNo__c);
        System.assertEquals(null, solution.LG_ProvisioningWorkOrder__c);
        System.assertEquals(true, solution.LG_Jeopardy__c);
        
        csord__service__c service = [SELECT id, LG_ServiceStatus__c,LG_ProvisioningAccountNo__c FROM csord__service__c 
                                     WHERE LG_Suborder__c = :solution.Id];
        
        System.assertEquals('Requested', service.LG_ServiceStatus__c);
        System.assertEquals(null, service.LG_ProvisioningAccountNo__c);
        
        List<Note> notes = [SELECT id from Note where parentId= :solution.Id];
        
        System.assertEquals(1, notes.size());
    }
    
    @isTest static void testMissingTransctionId()
    {
        getRestContext();
        
        Test.startTest(); 
        UM_UpdateSolutionsfromSpiderResponse.updateCamaWODetails('', 'Failure', '0', '0', '0', '');   
        Test.stopTest();
        
        csord__solution__c solution = [SELECT Id, Name, csord__Status__c, LG_Jeopardy__c, LG_Integration_Status__c, LG_Integration_Description__c,
                                       LG_ProvisioningWorkOrder__c, LG_ProvisioningAccountNo__c FROM csord__solution__c WHERE Name = 'UM Company Internet - 6912173'];
        
        System.assertEquals('In Progress', solution.csord__Status__c);
        System.assertEquals('Request Acknowledged', solution.LG_Integration_Status__c);
        System.assertEquals('Success', solution.LG_Integration_Description__c);
        System.assertEquals(null, solution.LG_ProvisioningAccountNo__c);
        System.assertEquals(null, solution.LG_ProvisioningWorkOrder__c);
        System.assertEquals(false, solution.LG_Jeopardy__c);
        
        csord__service__c service = [SELECT id, LG_ServiceStatus__c,LG_ProvisioningAccountNo__c FROM csord__service__c 
                                     WHERE LG_Suborder__c = :solution.Id];
        
        System.assertEquals('Requested', service.LG_ServiceStatus__c);
        System.assertEquals(null, service.LG_ProvisioningAccountNo__c);
        
        List<Note> notes = [SELECT id from Note where parentId= :solution.Id];
        
        System.assertEquals(0, notes.size());
    }
    
    
    @isTest static void testErrorTranslation()
    {
        getRestContext();
        
        csord__solution__c sol = [SELECT id, LastModifiedbyId FROM csord__solution__c WHERE Name = 'UM Company Internet - 6912173'];
        User u = [SELECT Id,LanguageLocaleKey FROM User WHERE Id = :sol.LastModifiedbyId];
        u.LanguageLocaleKey = 'de';
        update u;
        
        String errors = 'PENDING_ORDER_REASON(Cannot auto-approve a name change)';
        Test.startTest(); 
        UM_UpdateSolutionsfromSpiderResponse.updateCamaWODetails('123', 'Success', '0', '0', '4235678', errors);   
        Test.stopTest();
        
        csord__solution__c solution = [SELECT Id, Name, csord__Status__c, LG_Jeopardy__c, LG_Integration_Status__c, LG_Integration_Description__c,
                                       LG_ProvisioningWorkOrder__c, LG_ProvisioningAccountNo__c FROM csord__solution__c WHERE Name = 'UM Company Internet - 6912173'];
        
        System.assertEquals('In Provisioning', solution.csord__Status__c);
        System.assertEquals('Pending Work Order Created', solution.LG_Integration_Status__c);
        System.assertEquals('Pending Order: PENDING_ORDER_REASON(Kann eine Namensänderung nicht automatisch genehmigen)', solution.LG_Integration_Description__c);
        System.assertEquals(null, solution.LG_ProvisioningAccountNo__c);
        System.assertEquals('4235678', solution.LG_ProvisioningWorkOrder__c);
        System.assertEquals(false, solution.LG_Jeopardy__c);
        
        csord__service__c service = [SELECT id, LG_ServiceStatus__c,LG_ProvisioningAccountNo__c FROM csord__service__c 
                                     WHERE LG_Suborder__c = :solution.Id];
        
        System.assertEquals('Requested', service.LG_ServiceStatus__c);
        System.assertEquals(null, service.LG_ProvisioningAccountNo__c);
        
        List<Note> notes = [SELECT id from Note where parentId= :solution.Id];
        
        System.assertEquals(0, notes.size());
    }
    
    private static void getRestContext()
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/UM_UpdateSolutions/'; 
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
    }
}