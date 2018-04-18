
@isTest
public with sharing class UM_PaymentOverviewControllerTest {

	@testsetup
    private static void setupTestData()
    {
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
      UM_InvoiceHeader__c testInvoiceHeader2 = LG_GeneralTest.createInvoiceHeader(testAcc.Id, Date.today().addDays(-7), '101-0', 100.00, 75.00, 100, 75, Date.today().addDays(8), testBillingAcc.Id, true);

      UM_InvoiceHeader__c testInvoiceHeader3 = LG_GeneralTest.createInvoiceHeader(testAcc.Id, Date.today().addDays(-4), '101-1', 50.00, 35.00, 50, 35, Date.today().addDays(10), testBillingAcc.Id, false);    
      testInvoiceHeader3.UM_Backout_Status__c = '1002';  
      insert testInvoiceHeader3;

      Kenan_Adjustment__c testAdj1 = LG_GeneralTest.createKenanAdjustment('100', '1', 'Incorrect or unapplied charges', 'miscellaneous adjustment', 'requested', 25.00, testInvoiceHeader1.Id, true);
      Kenan_Adjustment__c testAdj2 = LG_GeneralTest.createKenanAdjustment('101', '1', 'Incorrect or unapplied charges', 'miscellaneous adjustment', 'requested', 50.00, testInvoiceHeader1.Id, true);
      Kenan_Adjustment__c testAdj3 = LG_GeneralTest.createKenanAdjustment('102', '1', 'Incorrect or unapplied charges', 'miscellaneous adjustment', 'requested', 42.00, testInvoiceHeader2.Id, true);
      Kenan_Adjustment__c testAdj4 = LG_GeneralTest.createAdjustmentReceivedFromKenan('103', '1', 'Incorrect or unapplied charges', 'miscellaneous adjustment', 'requested', -2000.00, testInvoiceHeader2.Id, true,true,true,Date.today().addDays(2));
      Kenan_Adjustment__c testAdj5 = LG_GeneralTest.createAdjustmentReceivedFromKenan('104', '1', 'Incorrect or unapplied charges', 'miscellaneous adjustment', 'requested', 1000.00, testInvoiceHeader2.Id, true,true,false,Date.today().addDays(3));
        
      UM_PaymentInformation__c testPI = new UM_PaymentInformation__c();
      testPI.UM_Transaction_Date__c = '20160804183629';
      testPI.UM_Transaction_Amount__c = 33.00;
      testPI.UM_Transaction_ID__c = '100-99';
      testPI.UM_Transaction_Status__c = '2';
      testPI.UM_Billing_Location__c = testBillingAcc.Id;
      insert testPI;

    }

	@isTest static void testOverview() {

 		Account testAcc = [SELECT Id, LG_BankAccountNumberIBAN__c FROM Account WHERE Name='Recaro'];
      	csconta__Billing_Account__c testBillingAcc = [SELECT Id FROM csconta__Billing_Account__c WHERE csconta__Financial_Account_Number__c='1234'];

   		PageReference pageRef = Page.UM_BillingAccount;
      pageRef.getParameters().put('aId', testAcc.Id);
      pageRef.getParameters().put('id', testBillingAcc.Id);      
      pageRef.getParameters().put('retUrl', '/'+testAcc.Id);

    	Test.setCurrentPageReference(pageRef);

        Test.startTest();
            UM_PaymentOverviewController ov = new  UM_PaymentOverviewController();
            ov.recordIdAttribute = testBillingAcc.Id;
        system.debug('list#'+ov.paymentsList);
        system.assertEquals(8, ov.paymentsList.size());
        system.assertEquals(-18.17, ov.paymentsList.get(0).balance);
        system.assertEquals(-18.17, ov.paymentsList.get(1).balance);
        system.assertEquals(1.83, ov.paymentsList.get(2).balance);
        system.assertEquals(0.33, ov.paymentsList.get( ov.paymentsList.size() - 1 ).balance);

    	Test.stopTest();
	}	
}