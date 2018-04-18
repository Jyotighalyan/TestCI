/*******************************************************************************************************************************************
* File Name     :  UM_KenanAutoSyncAccountTest
* Description   :  Test Class for UM_KenanAutoSyncAccountTest

* @author       :  Shubham Mittal    
* Modification Log
===================================================================================================
* Ver.    Date          Author              Modification
---------------------------------------------------------------------------------------------------
  -        -               -                    -
********************************************************************************************************************************************/
@isTest
public class UM_KenanAutoSyncAccountTest{
    @testsetup
  private static void setupTestData()
  {
    No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    noTriggers.Flag__c = true;
    noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
    upsert noTriggers;
    DateTime currentDateTime = DateTime.now();
  DateTime LastSynced = currentDateTime.addMinutes(-30);

    Account testAcc = LG_GeneralTest.CreateAccount(
        'Recaro', 'Customer', 'SME', 5, 'Qualified', '049-3220919', '55107192', 'UnityMedia', 'Flughafen Allee', '25', '', '28199', 'Bremen', 'Germany');
      testAcc.UM_LastSyncedwithBilling__c=LastSynced;
      update testAcc;
      csconta__Billing_Account__c testBilingAcc = LG_GeneralTest.createBillingAccount('1234', testAcc.Id, true, true);
    
      csconta__Billing_Account__c testBillingAcc = [SELECT Id, LG_BankAccountNumberIBAN__c,UM_IsAccountSynced__c FROM csconta__Billing_Account__c WHERE csconta__Financial_Account_Number__c='1234'];      
      testBillingAcc.LG_BankAccountNumberIBAN__c = 'DE85123100500123456102';
      
      update testBillingAcc;
      
    csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'TestM', csord__Module_Version__c = '1.0');
    insert coreq;
    
    csord__Subscription__c sub = new csord__Subscription__c(csord__Account__c=testAcc.id,csord__Identification__c = 'TestIdentM',csord__Status__c='Active', csord__Order_Request__c = coreq.Id, csconta__Billing_Account__c=testBillingAcc.Id);
    insert sub;
    
    cscrm__Address__c add= new cscrm__Address__c(cscrm__Street__c = 'TestStreetM');
    insert add;
    csord__Service__c intService = new csord__Service__c(csord__Identification__c = 'TestIdentSubM', csord__Order_Request__c = coreq.Id,csord__Status__c='Active',
                              csord__Subscription__c = sub.Id, LG_Address__c = add.Id, LG_ProductFamily__c = 'Internet');
    insert intService;
    
    upsert noTriggers;
  }
  private static testMethod void testAccount()
  {
      Account acc=[select id,LG_VisitPostalCode__c from account Limit 1];
      List<Id> acntids=new List<ID>();
      acntids.add(acc.id);
      test.startTest();
      UM_KenanAutoSyncAccount.UM_KenanAutoSyncAccount(acntids);
      test.stopTest();
  }
    private static testMethod void testBillingAccount()
  {
      csconta__Billing_Account__c billAcc=[select id from csconta__Billing_Account__c Limit 1];
       DateTime currentDateTime = DateTime.now();
  DateTime LastSynced = currentDateTime.addMinutes(-30);
      billAcc.UM_LastSyncedwithBilling__c=LastSynced;
      update billAcc;
      List<Id> acntids=new List<ID>();
      acntids.add(billAcc.id);
      test.startTest();
      UM_KenanAutoSyncAccount.UM_KenanAutoSyncAccount(acntids);
      test.stopTest();
  }
}