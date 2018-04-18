@isTest
public class LG_SConsoleBillingAccDetailsTest {
  @testSetup 
    static void setup() {
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
       //Billing Account
       csconta__Billing_Account__c b = new csconta__Billing_Account__c();
        b.LG_BillingAccountName__c = 'Test Billing';
        b.LG_BillingEmailAddress__c = 'test@testmail.com';
        b.LG_PaymentType__c = '';
       insert b;
        
        
    }
    public static testMethod void TestLG_ViewAttributeDefenitionController(){
        
        csconta__Billing_Account__c b = [select Id from csconta__Billing_Account__c LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(b);
        LG_SConsoleBillingAccDetailsExtension controller = new LG_SConsoleBillingAccDetailsExtension(sc);
        
        System.assertEquals(b.Id, controller.getbillingAccountDetail().Id);
        controller.edit();
        controller.save();
        controller.cancel();
        Test.stopTest();
    }
}