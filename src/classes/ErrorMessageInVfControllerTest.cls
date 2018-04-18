@isTest
public class ErrorMessageInVfControllerTest{

 @isTest static void ErrorMessageInVfControllerTest(){

         No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert coreq;

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = coreq.Id);
        insert sub;

        insert new cscrm__Address__c(cscrm__Street__c = 'TestStreet');

        csordtelcoa__Orders_Subscriptions_Options__c osOptions = new csordtelcoa__Orders_Subscriptions_Options__c();
        osOptions.csordtelcoa__Subscription_Number_Prefix__c = 'SN-';
        osOptions.csordtelcoa__Service_Number_Prefix__c = 'SVC-';
        insert osOptions;


        noTriggers.Flag__c = false;
        upsert noTriggers;

 }

 private static testmethod void testUpdateService()
    {
        //cscrm__Address__c address = [SELECT Id FROM cscrm__Address__c WHERE cscrm__Street__c = 'TestStreet'];
        Account testAcc = LG_GeneralTest.CreateAccount('Recaro', 'Customer', 'SoHo', 5, 'Qualified', '049-3220919', '55107192', 'UnityMedia', 'Flughafen Allee', '25', '', '28199', 'Bremen', 'Germany');
        //insert testAcc;
        cscrm__Address__c address = LG_GeneralTest.crateAddress('New address', 'Flughafen Allee', 'Bremen', '25', '', '28199', 'Germany', testAcc, true);
        //insert address;
        //csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'Test Subscription', Name='Company Internet', csord__Order_Request__c = coreq.Id);
         csord__Order_Request__c req = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert req;

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'Test Subscription', Name='Company Internet', csord__Order_Request__c = req.Id);
      insert sub;
        //csord__Subscription__c sub = [SELECT Id, csord__Identification__c, LG_Address__c FROM csord__Subscription__c WHERE csord__Identification__c = 'TestIdent'];





        Test.startTest();
              csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestIdentSub', LG_ServiceStatus__c = 'Active',csord__Order_Request__c = req.Id, csord__Subscription__c = sub.Id, LG_Address__c = address.Id);
            //csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestIdentSub', LG_ServiceStatus__c = 'Active',csord__Subscription__c = sub.Id, LG_Address__c = address.Id);
            insert service;
            ApexPages.StandardController sc = new ApexPages.StandardController(service);
            ErrorMessageInVfController ec = new ErrorMessageInVfController(sc);
            System.assertEquals('Active', service.LG_ServiceStatus__c, 'Services cannot be edited when they are active');
        Test.stopTest();


    }


}