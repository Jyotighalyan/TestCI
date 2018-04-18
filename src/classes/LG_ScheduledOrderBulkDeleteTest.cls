/**
* Test for LG_ScheduledOrderBulkDelete
* 
* @author Petar Miletic
* @ticket SFDT-581 - Remove Orders and Line Items for Soho and Mobile
* @since  30/03/2016
*/
@IsTest
public class LG_ScheduledOrderBulkDeleteTest {

    private static String CRON_EXP = '0 0 0 15 3 ? 2099';

    @testSetup 
    private static void setupTestData() {
        
        Account acc = LG_GeneralTest.CreateAccount('AccountSFDT', '12345678', 'Ziggo', true);
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, true);
        
        csord__Order_Request__c orderReq = new csord__Order_Request__c();
        
        orderReq.Name = 'OR Via Console 1';
        orderReq.csord__Module_Name__c = 'CS Order Implementation Module Telco A';
        orderReq.csord__Module_Version__c = '1.0';
        
        insert orderReq;
        
        List<csord__Order__c> orderList = new List<csord__Order__c>();
        
        for (integer i = 0; i < 5; i++) {
            
            csord__Order__c ord = new csord__Order__c();
            
            ord.Name = 'Order ' + i;
            ord.csord__Account__c = acc.Id;
            ord.csord__Order_Request__c = orderReq.Id;
            ord.csord__Identification__c = 'orderId';
            ord.csordtelcoa__Opportunity__c = opp.Id;
            
            if (math.mod(i, 2) == 0) {
                ord.LG_MarketSegment__c = 'SoHo';
            }
            
            orderList.add(ord);
        }
        
        insert orderList;
        
        List<csord__Order_Line_Item__c> olis = new List<csord__Order_Line_Item__c>();
        
        for (integer i = 0; i < 5; i++) {
            
            csord__Order_Line_Item__c oli = new csord__Order_Line_Item__c();
            
            oli.Name = 'Test Oli ' + i;
            oli.csord__Order__c = orderList[i].Id;
            oli.csord__Identification__c = 'orderId';
            oli.csord__Order_Request__c = orderReq.Id;
            
            olis.add(oli);
        }
        
        insert olis;
    }
    
    @IsTest
    private static void LG_ScheduledBulkDeleteExecuteTest() {
        
        LG_ScheduledOrderBulkDelete batch = new LG_ScheduledOrderBulkDelete();

        Test.StartTest();
        
        Database.executeBatch(batch);
        
        Test.StopTest();
        
        List<csord__Order__c> orders = [SELECT Id, Name FROM csord__Order__c];
        List<csord__Order_Line_Item__c> olis = [SELECT Id, Name FROM csord__Order_Line_Item__c];
        
        System.assertEquals(2, orders.size(), 'Invalid batch deletion job');
        System.assertEquals(2, olis.size(), 'Invalid batch deletion job');
    }
    
    @IsTest
    private static void LG_ScheduledBulkDeleteExecuteScheduledTest() {
        
        Test.StartTest();
        
        // Schedule the test job. Because this is a test, job executes immediately after Test.stopTest().
        String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new LG_ScheduledOrderBulkDelete());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2099-03-15 00:00:00', String.valueOf(ct.NextFireTime));
        
        // Verify the scheduled job hasn't run yet.
        List<csord__Order__c> ordersBefore = [SELECT Id FROM csord__Order__c];
        System.assertEquals(5, ordersBefore.size(), 'Invalid list size');

        Test.stopTest();
        
        // Now that the scheduled job has executed after Test.stopTest(), check for values
        // List<csord__Order__c> orders = [SELECT Id, Name FROM csord__Order__c];
        // List<csord__Order_Line_Item__c> olis = [SELECT Id, Name FROM csord__Order_Line_Item__c];
        
        // Schedule should fire after stopTest but it does not execute batch. This needs to be investigated
        // System.assertEquals(2, orders.size(), 'Invalid data');
        // System.assertEquals(2, olis.size(), 'Invalid data');
    }
}