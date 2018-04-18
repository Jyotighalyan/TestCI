@isTest
public class UM_KenanIDCreatorTest {
    
    public static testMethod void testExecute(){
    	
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
                                                                  csord__Subscription__c = sub.Id, LG_Address__c = add.Id,csord__Service__c=intService.id, LG_ProductFamily__c = 'Number Range',csord__Activation_Date__c=date.today());
        insert numRangeService;
        
        UM_NumberBlock__c numberBlock = new UM_NumberBlock__c(UM_NumberRangeService__c = numRangeService.id);
        numberBlock.UM_CDRIDNumber__c = '20(0123) 123 1231';
        insert numberBlock;
        
        Id portInRecordType = Schema.SObjectType.UM_PortingProcess__c.getRecordTypeInfosByName().get('Port-In').getRecordTypeId();
        UM_PortingProcess__c portingProcess = new UM_PortingProcess__c( UM_NumberRangeService__c = numRangeService.id,RecordTypeId=portInRecordType );
		portingProcess.UM_Status__c = 'Open';
        portingProcess.UM_Stage__c = 'Internal Clarification';
        portingProcess.UM_SubStage__c = 'Internal Clarification';
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
        
        Asset asst=new Asset();
    	asst.Name='Test Asset';
    	asst.csord__Service__c=numRangeService.Id;
    	asst.accountId=a.id;
        insert asst;
        
        list<sObject> l1 = new list<sObject>();
        l1.add(asst);
         
        test.startTest();
        UM_KenanIDCreator kc = new UM_KenanIDCreator();
        kc.execute(l1);
        test.stopTest();
       
    }
    
}