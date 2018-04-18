@isTest
private class UM_KenanAdjustmentTriggerHandlerTest{
 
  @testsetup
  private static void setupTestData()
  {
   No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    noTriggers.Flag__c = true;
    noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
    upsert noTriggers;
    
    Account testAcc = LG_GeneralTest.CreateAccount(
        'Recaro', 'Customer', 'SoHo', 5, 'Qualified', '049-3220919', '55107192', 'UnityMedia', 'Flughafen Allee', '25', '', '28199', 'Bremen', 'Germany'
      );

      csconta__Billing_Account__c testBilingAcc = LG_GeneralTest.createBillingAccount('1234', testAcc.Id, true, true);

      csconta__Billing_Account__c testBillingAcc = [SELECT Id, LG_PaymentType__c, LG_BankAccountHolder__c, LG_BankAccountNumberIBAN__c, UM_BankAccountNumberBic__c FROM csconta__Billing_Account__c WHERE csconta__Financial_Account_Number__c='1234'];
      testBillingAcc.LG_PaymentType__c = 'Direct Debit';
      testBillingAcc.LG_BankAccountHolder__c = 'Mr. Bob Dobalina';
      testBillingAcc.LG_BankAccountNumberIBAN__c = 'DE85123100500123456102';
      testBillingAcc.UM_BankAccountNumberBic__c = '123';
      update testBillingAcc; 

      UM_InvoiceHeader__c testInvoiceHeader1 = LG_GeneralTest.createInvoiceHeader(testAcc.Id, Date.today().addDays(-10), '100-0', 100.00, 75.00, 100, 75, Date.today().addDays(5), testBillingAcc.Id, true);
      Kenan_Adjustment__c testAdj1 = LG_GeneralTest.createKenanAdjustment('100', '1', 'Incorrect or unapplied charges', 'miscellaneous adjustment', 'requested', 25.00, testInvoiceHeader1.Id, false);
      testAdj1.UM_Received_from_Billing_System__c=true;
      testAdj1.UM_Original_Invoice_Number__c=testInvoiceHeader1.UM_InvoiceNumber__c;
      testAdj1.Invoice_Header__c=null;
      insert testAdj1;
     }
     @isTest static void testOverview() {

        Account testAcc = [SELECT Id, LG_BankAccountNumberIBAN__c FROM Account WHERE Name='Recaro'];
        csconta__Billing_Account__c testBillingAcc = [SELECT Id FROM csconta__Billing_Account__c WHERE csconta__Financial_Account_Number__c='1234'];
        Kenan_Adjustment__c adj=[SELECT Id,Invoice_Header__c FROM Kenan_Adjustment__c WHERE trackingId__c='100'];
        UM_InvoiceHeader__c  invoice=[SELECT Id from UM_InvoiceHeader__c  WHERE UM_Customer_SF_ID__c = : testAcc .id];
        system.assertEquals(adj.Invoice_Header__c, invoice.id);
     
      }
 }