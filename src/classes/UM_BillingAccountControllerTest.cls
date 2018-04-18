@IsTest
public class UM_BillingAccountControllerTest {

    @testsetup
    private static void setupTestData()
    {
      Account testAcc = LG_GeneralTest.CreateAccount(
        'Recaro', 'Customer', 'SoHo', 5, 'Qualified', '049-3220919', '55107192', 'UnityMedia', 'Flughafen Allee', '25', '', '28199', 'Bremen', 'Germany'
      );

      csconta__Billing_Account__c testBilingAcc = LG_GeneralTest.createBillingAccount('1234', testAcc.Id, true, true);

      csconta__Billing_Account__c testBillingAcc = [SELECT Id, LG_BankAccountNumberIBAN__c FROM csconta__Billing_Account__c WHERE csconta__Financial_Account_Number__c='1234'];      
      testBillingAcc.LG_BankAccountNumberIBAN__c = 'DE85123100500123456102';
      update testBillingAcc;

      UM_WebserviceCredentials__c setting = new UM_WebserviceCredentials__c();
      setting.Name = 'UM_TolerantWS';
      setting.Login__c = 'tLogin';
      setting.Password__c = 'tPassword';
      insert setting;
 
    }

    @isTest static void testExistingBillingAccount() {
		
      Account testAcc = [SELECT Id, LG_BankAccountNumberIBAN__c FROM Account WHERE Name='Recaro'];
      csconta__Billing_Account__c testBillingAcc = [SELECT Id FROM csconta__Billing_Account__c WHERE csconta__Financial_Account_Number__c='1234'];

   		PageReference pageRef = Page.UM_BillingAccount;
      pageRef.getParameters().put('aId', testAcc.Id);
      pageRef.getParameters().put('id', testBillingAcc.Id);      
      pageRef.getParameters().put('retUrl', '/'+testAcc.Id);

    	Test.setCurrentPageReference(pageRef);

  		Test.startTest();
      
        Test.setMock(WebServiceMock.class, new UM_IbanResponseMock());   
        UM_BillingAccountController controller = new UM_BillingAccountController();

        System.assertNotEquals(null, controller.save());
    		
        controller.cancel();
  		
      Test.stopTest();	
 	  } 

    @isTest static void testNewBillingAccount() {

      Account testAcc = [SELECT Id FROM Account WHERE Name='Recaro'];

      PageReference pageRef = Page.UM_BillingAccount;
      pageRef.getParameters().put('aId', testAcc.Id);
      pageRef.getParameters().put('retUrl', '/'+testAcc.Id);

      Test.setCurrentPageReference(pageRef);

      Test.startTest();
      
        Test.setMock(WebServiceMock.class, new UM_IbanResponseMock());
        UM_BillingAccountController controller = new UM_BillingAccountController();
      
        // set billing account 
        controller.billingAccount.LG_BankAccountNumberIBAN__c = 'DE85123100500123456102';        

        System.assertNotEquals(null, controller.save());

        controller.goToPreviousPage('/'+testAcc.Id);

      Test.stopTest();  
    } 


    @isTest static void testExistingBillingNoValidation() {

      Account testAcc = [SELECT Id FROM Account WHERE Name='Recaro'];
      csconta__Billing_Account__c testBillingAcc = [SELECT Id FROM csconta__Billing_Account__c WHERE csconta__Financial_Account_Number__c='1234'];

      PageReference pageRef = Page.UM_BillingAccount;
      pageRef.getParameters().put('aId', testAcc.Id);
      pageRef.getParameters().put('id', testBillingAcc.Id);      
      pageRef.getParameters().put('retUrl', '/'+testAcc.Id);

      Test.setCurrentPageReference(pageRef);

      Test.startTest();

        UM_BillingAccountController controller = new UM_BillingAccountController();
        controller.validateIbanNumber = false;

        System.assertNotEquals(null, controller.save());
      
        controller.cancel();
      
      Test.stopTest();  
    }     

    @isTest static void testNewBillingAccountNoValidation() {

      Account testAcc = [SELECT Id FROM Account WHERE Name='Recaro'];

      PageReference pageRef = Page.UM_BillingAccount;
      pageRef.getParameters().put('aId', testAcc.Id);
      pageRef.getParameters().put('retUrl', '/'+testAcc.Id);

      Test.setCurrentPageReference(pageRef);

      Test.startTest();

        UM_BillingAccountController controller = new UM_BillingAccountController();
      
        // set billing account 
        controller.billingAccount.LG_BankAccountNumberIBAN__c = 'DE85123100500123456102';
        
        controller.validateIbanNumber = false;   

        System.assertNotEquals(null, controller.save());

        controller.goToPreviousPage('/'+testAcc.Id);

      Test.stopTest();  
    } 
}