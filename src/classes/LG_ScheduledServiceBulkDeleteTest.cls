/**
* Test for LG_ScheduledServiceBulkDelete
* 
* @author Petar Miletic
* @ticket SFDT-581 - Remove services and Line Items for Soho and Mobile
* @since  30/03/2016
*/
@IsTest
public class LG_ScheduledServiceBulkDeleteTest {

    private static String CRON_EXP = '0 0 0 15 3 ? 2099';

    @testSetup 
    private static void setupTestData() {
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        Account acc = LG_GeneralTest.CreateAccount('AccountSFDT', '12345678', 'Ziggo', true);
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, true);

        csord__Order_Request__c orderReq = new csord__Order_Request__c();
        orderReq.Name = 'OR Via Console 1';
        orderReq.csord__Module_Name__c = 'CS Order Implementation Module Telco A';
        orderReq.csord__Module_Version__c = '1.0';
        insert orderReq;
        
        // This one will not be deleted because it is linked to Subscription that is in use
        csord__Order__c ord = new csord__Order__c();
        ord.csord__Account__c = acc.Id;
        ord.csord__Order_Request__c = orderReq.Id;
        ord.csord__Identification__c = 'orderId';
        ord.csordtelcoa__Opportunity__c = opp.Id;
        insert ord;
        
        csord__Subscription__c subs = new csord__Subscription__c();
        subs.Name = 'Mobile';
        subs.csord__Account__c = acc.Id;
        subs.csord__Order_Request__c = orderReq.Id;
        subs.csord__Identification__c = 'externalId';
        subs.csord__Order__c = ord.Id;
        insert subs;
        
        // This one will not be deleted because it is linked to Service that is in use
        csord__Order__c ord1 = new csord__Order__c();
        ord1.csord__Account__c = acc.Id;
        ord1.csord__Order_Request__c = orderReq.Id;
        ord1.csord__Identification__c = 'orderId';
        ord1.csordtelcoa__Opportunity__c = opp.Id;
        insert ord1;

        // This will be completely deleted
        csord__Order__c ord2 = new csord__Order__c();
        ord2.csord__Account__c = acc.Id;
        ord2.csord__Order_Request__c = orderReq.Id;
        ord2.csord__Identification__c = 'orderId';
        ord2.csordtelcoa__Opportunity__c = opp.Id;
        insert ord2;
        
        csord__Subscription__c subs2 = new csord__Subscription__c();
        subs2.Name = 'Mobile';
        subs2.csord__Account__c = acc.Id;
        subs2.csord__Order_Request__c = orderReq.Id;
        subs2.csord__Identification__c = 'ClearAll';
        subs2.csord__Order__c = ord2.Id;
        insert subs2;
        // This will be completely deleted, end
        
        // This one will not be deleted because it is linked to Services that only partialy match deletion criteria (1 of 5 records)
        csord__Order__c ord3 = new csord__Order__c();
        ord3.csord__Account__c = acc.Id;
        ord3.csord__Order_Request__c = orderReq.Id;
        ord3.csord__Identification__c = 'orderId';
        ord3.csordtelcoa__Opportunity__c = opp.Id;
        insert ord3;

        List<csord__Service__c> serviceList = new List<csord__Service__c>();
        
        for (integer i = 0; i < 10; i++) {
            
            csord__Service__c ser = new csord__Service__c();
            
            ser.csord__Subscription__c = subs.Id;
            ser.csord__Identification__c = 'orderId';
            ser.csord__Order_Request__c = orderReq.Id;

            if (i < 5 && math.mod(i, 2) == 0) { // 0, 2 and 4 will be deleted because they match the condition
                ser.Name = 'Mobile';
                ser.LG_MarketSegment__c = 'SoHox';
            }
            else if (i < 5 && math.mod(i, 2) != 0) {
                ser.LG_RootOrder__c = ord1.Id;
            }
            else if (i == 5) // This one will be deleted becouse it is Mobile, Not SoHo and Service In Delivery
            {
                ser.Name = 'Mobile';
                ser.csord__Status__c = 'Service In Delivery';
                ser.LG_RootOrder__c = ord3.Id;
            }
            else // This ones won't be deleted because they don't match the condition for deletion
            {
                ser.Name = 'Mobile ' + i;
                ser.LG_RootOrder__c = ord3.Id;
            }
            
            serviceList.add(ser);
        }
        
        insert serviceList;
        
        serviceList.clear();
        
        for (integer i = 0; i < 5; i++) {
            
            csord__Service__c ser = new csord__Service__c();
            
            ser.csord__Subscription__c = subs2.Id;
            ser.csord__Identification__c = 'orderId';
            ser.csord__Order_Request__c = orderReq.Id;
            ser.LG_RootOrder__c = ord2.Id;
            
            ser.Name = 'Mobile';
            ser.LG_MarketSegment__c = 'SoHo';

            serviceList.add(ser);
        }
        
        insert serviceList;
        
        // This will be marked as SoHo - To Be Deleted and completely deleted
        csord__Order__c ord4 = new csord__Order__c();
        ord4.csord__Account__c = acc.Id;
        ord4.csord__Order_Request__c = orderReq.Id;
        ord4.csord__Identification__c = 'orderId';
        ord4.csordtelcoa__Opportunity__c = opp.Id;
        insert ord4;

        csord__Subscription__c subs3 = new csord__Subscription__c();
        subs3.Name = 'Test';
        subs3.csord__Account__c = acc.Id;
        subs3.csord__Order_Request__c = orderReq.Id;
        subs3.csord__Identification__c = 'ClearAll';
        subs3.csord__Order__c = ord4.Id;
        insert subs3;
        
        serviceList.clear();
        
        for (integer i = 0; i < 5; i++) {
            
            csord__Service__c ser = new csord__Service__c();
            
            ser.csord__Subscription__c = subs3.Id;
            ser.csord__Identification__c = 'orderId';
            ser.csord__Order_Request__c = orderReq.Id;
            ser.LG_RootOrder__c = ord4.Id;

            ser.Name = 'Test';
            ser.LG_MarketSegment__c = 'SoHo';

            serviceList.add(ser);
        }
        
        insert serviceList;
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    
    @IsTest
    private static void LG_ScheduledBulkDeleteExecuteTest() {
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        LG_ScheduledServiceBulkDelete batch = new LG_ScheduledServiceBulkDelete();

        Test.StartTest();
        
        Database.executeBatch(batch);
        
        Test.StopTest();
        
        List<csord__Service__c> services = [SELECT Id, Name FROM csord__Service__c];
        List<csord__Service__c> nonSohoInDelivery = [SELECT Id, Name FROM csord__Service__c WHERE csord__Status__c = 'Service In Delivery' AND Name = 'Mobile' AND LG_MarketSegment__c != 'SoHo'];
        List<csord__Subscription__c> subscriptions = [SELECT Id, Name FROM csord__Subscription__c];
        List<csord__Order__c> orders = [SELECT Id, Name FROM csord__Order__c];

        //System.assertEquals(9, services.size(), 'Invalid batch deletion job');
        System.assertEquals(0, nonSohoInDelivery.size(), 'Invalid batch deletion job');
      //  System.assertEquals(1, subscriptions.size(), 'Invalid batch deletion job');
       // System.assertEquals(3, orders.size(), 'Invalid batch deletion job');
        
        /*System.assertEquals(0, services.size(), 'Invalid batch deletion job');
        System.assertEquals(0, nonSohoInDelivery.size(), 'Invalid batch deletion job');
        System.assertEquals(0, subscriptions.size(), 'Invalid batch deletion job');
        System.assertEquals(2, orders.size(), 'Invalid batch deletion job');*/
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    
  /*  @IsTest
    private static void LG_ScheduledBulkDeleteExecuteScheduledTest() {
        
        Test.StartTest();
        
        // Schedule the test job. Because this is a test, job executes immediately after Test.stopTest().
        String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new LG_ScheduledServiceBulkDelete());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2099-03-15 00:00:00', String.valueOf(ct.NextFireTime));
        
        // Verify the scheduled job hasn't run yet.
        List<csord__Service__c> servicesBefore = [SELECT Id FROM csord__Service__c];
        System.assertEquals(20, servicesBefore.size(), 'Invalid list size');

        Test.stopTest();
        
        // Now that the scheduled job has executed after Test.stopTest(), check for values
        // List<csord__Service__c> services = [SELECT Id, Name FROM csord__Service__c];
        
        // Schedule should fire after stopTest but it does not execute batch. This needs to be investigated
        // System.assertEquals(2, services.size(), 'Invalid data');
    }*/
}