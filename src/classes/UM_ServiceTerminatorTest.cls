/*
 * Test class for LG_ValidateMyBillDetails
 @ Modified by : Shruthi Gopal
 @ Date   	   : 25/10/2017
*/

@isTest
private class UM_ServiceTerminatorTest
{
    
    @testsetup
    private static void setupTestData(){
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'TestM', csord__Module_Version__c = '1.0');
        insert coreq;
        
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdentM', csord__Order_Request__c = coreq.Id);
        insert sub;
        
        csconta__Contract__c contract = new csconta__Contract__c();
        contract.csconta__Subscription__c = sub.id;
        contract.csconta__Valid_From__c = Date.today();
        contract.csconta__Valid_To__c = Date.Today().addYears(1);
        insert contract;
        
        sub.LG_Contract__c = contract.id;
        update sub;
        
        cscrm__Address__c add= new cscrm__Address__c(cscrm__Street__c = 'TestStreetM');
        insert add;
        csord__Service__c intService = new csord__Service__c(csord__Identification__c = 'TestIdentSubM', csord__Order_Request__c = coreq.Id,
                                                             csord__Subscription__c = sub.Id, LG_Address__c = add.Id, LG_ProductFamily__c = 'Internet',UM_Cancellation_Period__c=null,csord__Status__c='Requested',
                                                             csord__Activation_Date__c=date.today());
        insert intService;
        
      /*  insert new csord__Service_Line_Item__c(Name = 'Test Internet SLA',
                                               csord__Identification__c = 'nesto',
                                               csord__Is_Adhoc__c = true,
                                               csord__Is_Recurring__c = true,
                                               csord__Line_Description__c = 'Test Desc',
                                               csord__Service__c = intService.Id,
                                               LG_BillingAccount__c = null,
                                               LG_ServiceLineItemExternalId__c = 'Something',
                                               LG_Quantity__c = null,
                                               csord__Total_Price__c=1000,
                                               LG_ExternalServiceName__c = 'SLA TEST',
                                               LG_ExternalPriceName__c = null,
                                               LG_ExternalDescription__c = 'Test Desc',
                                               LG_Type__c = 'Termination', 
                                               LG_ToBeSent__c = null);
                
        
        noTriggers.Flag__c = false;
        update noTriggers;*/
        
        KenanServiceConnection__c ksc = new KenanServiceConnection__c();
        ksc.Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=';
        ksc.Session_Timeout__c = '120000';
        ksc.Connection_URL__c = 'https://kenan-dev-pubelb-amdocs-1924041402.eu-central-1.elb.amazonaws.com';
        ksc.REST_Application_Base__c = '/kenan-salesforce-api/rest';
        insert ksc;

    }
    
    private static testMethod void testServiceTermination(){
        csord__Service__c inactiveService = [select id,csord__Status__c from csord__service__c limit 1];
        inactiveService.LG_ServiceExternalId__c = '123433';
        inactiveService.csord__Status__c = 'inactiveStatus';
        inactiveService.csord__Deactivation_Date__c = Date.today();
        KenanServiceService kserv = new KenanServiceService();
        
        list<sObject> servicesList = [select id,csord__Deactivation_Date__c,csordtelcoa__Service_Number_Sequence__c,LastModifiedById,csord__Subscription__r.Kenan_Response__c from csord__service__c];
        
        
        KenanServiceCalloutMock serviceMock = new KenanServiceCalloutMock();
        serviceMock.numberOfRecords = 2;
        Test.setMock (HttpCalloutMock.class, serviceMock);
        
        Test.startTest();
        UM_ServiceTerminator tObj = new UM_ServiceTerminator();
        tObj.execute(servicesList);
        update inactiveService;
        Test.stopTest();
        System.assertEquals('inactiveStatus', [select id,csord__status__c from csord__service__c where id=:inactiveService.id].csord__status__c);
    }
    
    private static testMethod void testCreateErrorTask(){
        csord__Service__c inactiveService = [select id,csordtelcoa__Service_Number_Sequence__c,LastModifiedById,csord__Subscription__r.Kenan_Response__c from csord__service__c limit 1];
        UM_ServiceTerminator tObj = new UM_ServiceTerminator();
       
      
    }
}