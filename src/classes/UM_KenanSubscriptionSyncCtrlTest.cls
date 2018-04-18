/* -----------------------------------------------------------------------------------------------------------------------
   Name: UM_KenanSubscriptionSyncCtrlTest.cls 
   Description: This is test class for UM_KenanSubscriptionSyncCtrl.cls

   Date            Version         Author          Summary of Changes 
-----------  ------- --------------  ----------------------------------------------------------------------------------
   July 2016       1.0             Madhu Sudhan        
------------------------------------------------------------------------------------------------------------------------ */

@isTest
public class UM_KenanSubscriptionSyncCtrlTest {
  @testsetup
  private static void setupTestData()
  {
    No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    noTriggers.Flag__c = true;
    noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
    upsert noTriggers;
    Account testAcc = LG_GeneralTest.CreateAccount(
        'Recaro', 'Customer', 'SoHo', 5, 'Qualified', '049-3220919', '55107192', 'UnityMedia', 'Flughafen Allee', '25', '', '28199', 'Bremen', 'Germany');
    csconta__Billing_Account__c testBilingAcc = LG_GeneralTest.createBillingAccount('1234', testAcc.Id, true, true);

      csconta__Billing_Account__c testBillingAcc = [SELECT Id, LG_BankAccountNumberIBAN__c FROM csconta__Billing_Account__c WHERE csconta__Financial_Account_Number__c='1234'];      
      testBillingAcc.LG_BankAccountNumberIBAN__c = 'DE85123100500123456102';
      update testBillingAcc;
      
    csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'TestM', csord__Module_Version__c = '1.0');
    insert coreq;
    
    csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdentM', csord__Order_Request__c = coreq.Id, csconta__Billing_Account__c=testBillingAcc.Id);
    insert sub;
    
    cscrm__Address__c add= new cscrm__Address__c(cscrm__Street__c = 'TestStreetM');
    insert add;
    csord__Service__c intService = new csord__Service__c(csord__Identification__c = 'TestIdentSubM', csord__Order_Request__c = coreq.Id,
                              csord__Subscription__c = sub.Id, LG_Address__c = add.Id, LG_ProductFamily__c = 'Internet');
    insert intService;
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
  
  private static testmethod void getServicesAndgetServicesLineitemsTest()
  {
    No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    noTriggers.Flag__c = true;
    noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
    upsert noTriggers;
    
    cscrm__Address__c address = [SELECT Id FROM cscrm__Address__c WHERE cscrm__Street__c = 'TestStreetM'];

    csord__Subscription__c sub = [SELECT Id, csord__Identification__c, LG_Address__c,UM_VoiceworksAccountID__c
                    FROM csord__Subscription__c WHERE csord__Identification__c = 'TestIdentM'];
    sub.UM_VoiceworksAccountID__c='23525325242345';
    update sub;
    csord__Order_Request__c req = [SELECT Id, csord__Module_Name__c
                    FROM csord__Order_Request__c WHERE csord__Module_Name__c = 'TestM'];
    
    
    csord__Service__c intService = new csord__Service__c(csord__Identification__c = 'TestIdentSub', csord__Order_Request__c = req.Id,
                              csord__Subscription__c = sub.Id, LG_Address__c = address.Id, LG_ProductFamily__c = 'Internet');
    insert intService;
    
    csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestIdentSub', csord__Order_Request__c = req.Id,
                              csord__Subscription__c = sub.Id, LG_Address__c = address.Id, LG_ProductFamily__c = 'HPBX',
                              csord__Status__c = 'something');
    insert service;
    
    noTriggers.Flag__c = false;
    upsert noTriggers;
      
    
      insert new csord__Service_Line_Item__c(Name = 'Test Internet SLA',
                                csord__Identification__c = 'nesto',
                                csord__Is_Adhoc__c = true,
                                csord__Is_Recurring__c = true,
                                csord__Line_Description__c = 'Test Desc',
                                csord__Service__c = intService.Id,
                                csord__Order_Request__c = req.Id,
                                LG_BillingAccount__c = null,
                                LG_ServiceLineItemExternalId__c = 'Something',
                                LG_Quantity__c = null,
                                LG_ExternalServiceName__c = 'SLA TEST',
                                LG_ExternalPriceName__c = null,
                                LG_ExternalDescription__c = 'Test Desc',
                                LG_Type__c = null, LG_AddOnType__c = 'SLA',
                                LG_ToBeSent__c = null);
    Test.startTest();
    set<Id> set_SubscriptionIds=new set<Id>();
      set_SubscriptionIds.add(sub.Id);
    UM_KenanSubscriptionSyncCtrl.getServices(sub.id);
    UM_KenanSubscriptionSyncCtrl.getServiceItems(set_SubscriptionIds);
    
    Test.setCurrentPageReference(new PageReference('Page.UM_KenanSubscriptionSync')); 
    System.currentPageReference().getParameters().put('id', sub.id);
    System.currentPageReference().getParameters().put('terminate', 'y');
    UM_KenanSubscriptionSyncCtrl obj=new UM_KenanSubscriptionSyncCtrl();
    obj.updateKenanService();
    System.currentPageReference().getParameters().put('terminate', 'n');
    obj.updateKenanService();
    //UM_KenanSubscriptionSyncCtrl.createOrder('sfasfasdfaasd');
    //UM_KenanSubscriptionSyncCtrl.updateContract(service.Id,Date.today().addYears(2),Date.today().addYears(2).addMonths(-3));
    Test.stopTest();
   
  }
  
  private static testmethod void getServicesAndgetServicesLineitemsTest1()
  {
    No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    noTriggers.Flag__c = true;
    noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
    upsert noTriggers;
    
    cscrm__Address__c address = [SELECT Id FROM cscrm__Address__c WHERE cscrm__Street__c = 'TestStreetM'];

    csord__Subscription__c sub = [SELECT Id, csord__Identification__c, LG_Address__c,UM_SubscriberID__c
                    FROM csord__Subscription__c WHERE csord__Identification__c = 'TestIdentM'];
    sub.UM_SubscriberID__c = '23456789088';
    update sub;
    csord__Order_Request__c req = [SELECT Id, csord__Module_Name__c
                    FROM csord__Order_Request__c WHERE csord__Module_Name__c = 'TestM'];
    
    csord__Service__c intService = new csord__Service__c(csord__Identification__c = 'TestIdentSub', csord__Order_Request__c = req.Id,
                              csord__Subscription__c = sub.Id, LG_Address__c = address.Id, LG_ProductFamily__c = 'Internet');
    insert intService;
    
    csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestIdentSub', csord__Order_Request__c = req.Id,
                              csord__Subscription__c = sub.Id, LG_Address__c = address.Id, LG_ProductFamily__c = 'HPBX',
                              csord__Status__c = 'something');
    insert service;
    
    noTriggers.Flag__c = false;
    upsert noTriggers;
      
    
      insert new csord__Service_Line_Item__c(Name = 'Test Internet SLA',
                                csord__Identification__c = 'nesto',
                                csord__Is_Adhoc__c = true,
                                csord__Is_Recurring__c = true,
                                csord__Line_Description__c = 'Test Desc',
                                csord__Service__c = intService.Id,
                                csord__Order_Request__c = req.Id,
                                LG_BillingAccount__c = null,
                                LG_ServiceLineItemExternalId__c = 'Something',
                                LG_Quantity__c = null,
                                LG_ExternalServiceName__c = 'SLA TEST',
                                LG_ExternalPriceName__c = null,
                                LG_ExternalDescription__c = 'Test Desc',
                                LG_Type__c = null, LG_AddOnType__c = 'SLA',
                                LG_ToBeSent__c = null);
    Test.startTest();
    set<Id> set_SubscriptionIds=new set<Id>();
      set_SubscriptionIds.add(sub.Id);
    UM_KenanSubscriptionSyncCtrl.getServices(sub.id);
    UM_KenanSubscriptionSyncCtrl.getServiceItems(set_SubscriptionIds);
    
    Test.setCurrentPageReference(new PageReference('Page.UM_KenanSubscriptionSync')); 
    System.currentPageReference().getParameters().put('id', sub.id);
    System.currentPageReference().getParameters().put('terminate', 'y');
    UM_KenanSubscriptionSyncCtrl obj=new UM_KenanSubscriptionSyncCtrl();
    obj.updateKenanService();
    System.currentPageReference().getParameters().put('terminate', 'n');
    obj.updateKenanService();
    //UM_KenanSubscriptionSyncCtrl.createOrder('sfasfasdfaasd');
    //UM_KenanSubscriptionSyncCtrl.updateDeactivationReason(service.Id,'No more required.');
    Test.stopTest();
   
  }
   
  private static testmethod void createSwapCeaseTest()
  {
    csord__Service__c service =[select id from csord__Service__c where csord__Identification__c = 'TestIdentSubM'];
    KenanHTTPConnectionHelper kch = new KenanHTTPConnectionHelper();
    KenanAccountCalloutMock accountMock = new KenanAccountCalloutMock();
    accountMock.numberOfRecords = 1;
    Test.setMock (HttpCalloutMock.class, accountMock);
    Test.startTest();
    UM_KenanSubscriptionSyncCtrl.createExternalId(service.id,'0123123339',Datetime.now());
    UM_KenanSubscriptionSyncCtrl.swapExternalId(service.id,'0123123339','0123123337',Datetime.now());
    UM_KenanSubscriptionSyncCtrl.ceaseExternalId(service.id,'0123123339',Datetime.now());
    account a=[select id from account where name='Sample Test AccountM'];
    KenanService ks = KenanSampleCode.createSampleInsertKenanService(a.Id);
    ks.salesforceObjectId=service.id;
      UM_KenanSubscriptionSyncCtrl.updateKenanIds(new list<KenanService> {ks});
    Test.stopTest();
  }
   
   

}