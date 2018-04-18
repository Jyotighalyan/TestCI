@isTest
public class LG_ValidateBillingAccountTest {
 	@isTest
	public static void handleTest() {
        Account acc = LG_GeneralTest.CreateAccount('Test Account', '12345678', 'Ziggo', false);
        
        acc.LG_PostalStreet__c = 'First Street';
        acc.LG_PostalHouseNumber__c = '253';
        acc.LG_PostalHouseNumberExtension__c = 'A';
        acc.LG_PostalPostalCode__c = '25000';
        acc.LG_PostalCity__c = 'Agram';
        acc.LG_PostalCountry__c = 'Netherlands';

        acc.UM_PostalGeolocation__Latitude__s = 65.946472;
        acc.UM_PostalGeolocation__Longitude__s = -47.427979;
        
        insert acc;
        
        csconta__Billing_Account__c billingAccount1 = LG_GeneralTest.createBillingAccount('32165465', acc.Id, true, true);
        billingAccount1.LG_BankAccountNumberIBAN__c = 'IN2156296';
        update billingAccount1;
       
        csconta__Billing_Account__c billingAccount2 = LG_GeneralTest.createBillingAccount('12345678', acc.Id, true, true);
        
        list<csconta__Billing_Account__c> newData = new list<csconta__Billing_Account__c>();
        list<csconta__Billing_Account__c> oldData = new list<csconta__Billing_Account__c>();
        
        newData.add(billingAccount1);
        oldData.add(billingAccount2);
        
        test.startTest();
        LG_ValidateBillingAccount.handle(newData,oldData);
        test.stopTest();
        
    }
}