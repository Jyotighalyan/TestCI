@isTest
public class UM_KenanSyncHelperTest {
    public static testmethod void kenansync(){
        test.startTest();
           Account acc = LG_GeneralTest.CreateAccount('AccountSFDT', '12345678', 'Ziggo', true);
        csconta__Billing_Account__c billaact=lg_generaltest.createBillingAccount('finnumber',acc.id,true,true);
         csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert coreq;
        
         csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'Test Subscription', csord__Order_Request__c = coreq.Id);
        sub.csordtelcoa__Change_Type__c = 'Change';
        insert sub;

        
        UM_KenanSyncHelper.syncKenanAccount(billaact.id,true);
        UM_KenanSyncHelper.syncKenanService(billaact.id,sub.id);
        test.stopTest();
        
        
    }

}