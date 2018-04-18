@IsTest
public with sharing class UM_AssetTriggerHandlerTest {
	
 
 	@testsetup
    private static void setupTestData() {
    	
    	Account tmpAccount = LG_GeneralTest.CreateAccount('Stichting Statenkliniek', 'Customer', 'SoHo', 5, 'Qualified', '070-3220919', '55107192', 'Ziggo', 'Frankenslag', '357', 'A', '2582 HP', 'MONNICKENDAM', 'Netherlands');
    	No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
		insert coreq;
		
		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = coreq.Id);
		insert sub;
		
		cscrm__Address__c add= new cscrm__Address__c(cscrm__Street__c = 'TestStreet');
		insert add;
		
        csordtelcoa__Orders_Subscriptions_Options__c osOptions = new csordtelcoa__Orders_Subscriptions_Options__c();
		osOptions.csordtelcoa__Subscription_Number_Prefix__c = 'SN-';
		osOptions.csordtelcoa__Service_Number_Prefix__c = 'SVC-';
		insert osOptions;
		
		csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestIdentSub', csord__Order_Request__c = coreq.Id,
																csord__Subscription__c = sub.Id, LG_Address__c = add.Id);
		insert service;
		
		noTriggers.Flag__c = false;
		upsert noTriggers;
    	
    }   
    
    
    public static testMethod void createChildAssetsTest(){
    	csord__Service__c serv=[select id from csord__Service__c];
    	Account acc=[select id from account];
    	
    	Asset asst=new Asset();
    	asst.Name='Test Asset';
    	asst.csord__Service__c=serv.Id;
    	asst.accountId=acc.id;
    	asst.Quantity=2;
    	test.startTest();    	    
    	insert asst;
    	
    	Asset updateAsset=new Asset(id=asst.Id);
    	updateAsset.name='Updated Asset';
    	update updateAsset;
    	
    }
    
    
}