@isTest
public class UM_KenanIDTerminatorTest {
    
    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'TestM', csord__Module_Version__c = '1.0');
        insert coreq;
        
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdentM', csord__Order_Request__c = coreq.Id);
        insert sub;
        
        cscrm__Address__c add= new cscrm__Address__c(cscrm__Street__c = 'TestStreetM');
        insert add;
        csord__Service__c intService = new csord__Service__c(csord__Identification__c = 'TestIdentSubM', csord__Order_Request__c = coreq.Id,
                                                             csord__Subscription__c = sub.Id, LG_Address__c = add.Id, LG_ProductFamily__c = 'Internet');
        insert intService;
        
        csord__Service__c numRangeService = new csord__Service__c(csord__Identification__c = 'TestIdentSubM', csord__Order_Request__c = coreq.Id,
                                                                  csord__Subscription__c = sub.Id, LG_Address__c = add.Id,csord__Service__c=intService.id, LG_ProductFamily__c = 'Number Range');
        insert numRangeService;
        
        UM_NumberBlock__c numberBlock = new UM_NumberBlock__c(UM_NumberRangeService__c = numRangeService.id);
        numberBlock.UM_CDRIDNumber__c = '20(0123) 123 1231';
        insert numberBlock;
        
        Id portInRecordType = Schema.SObjectType.UM_PortingProcess__c.getRecordTypeInfosByName().get('Port-In').getRecordTypeId();
        UM_PortingProcess__c portingProcess = new UM_PortingProcess__c( UM_NumberRangeService__c = numRangeService.id,RecordTypeId=portInRecordType );
		portingProcess.UM_Status__c = 'Closed';
        portingProcess.UM_Stage__c = 'Closed';
        portingProcess.UM_SubStage__c = 'Confirmed';
        insert portingProcess;
        
        noTriggers.Flag__c = false;
        
        KenanServiceConnection__c ksc = new KenanServiceConnection__c();
        ksc.Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=';
        ksc.Session_Timeout__c = '120000';
        ksc.Connection_URL__c = 'https://kenan-dev-pubelb-amdocs-1924041402.eu-central-1.elb.amazonaws.com';
        ksc.REST_Application_Base__c = '/kenan-salesforce-api/rest';
        insert ksc;
        
        Account a = new Account();
        a.Name = 'Sample Test AccountM';
        insert a;
        
        upsert noTriggers;
    }
    
    public static testMethod void testExecute(){
    	csord__Service__c numService = [select id,csordtelcoa__Delta_Status__c from csord__Service__c where LG_ProductFamily__c = 'Number Range' limit 1 ];
        numService.csordtelcoa__Delta_Status__c = 'Deleted From Subscription';
            
        Test.startTest();
        
        update numService;
        
        Test.stopTest();
        
        System.assertEquals('Not Active in Billing', [select id, UM_BillingStatus__c from UM_NumberBlock__c limit 1].UM_BillingStatus__c);
        
    }

}