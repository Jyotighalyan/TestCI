/**
 * Test class for LG_CheckCancellationAndPortingWindow
 * 
 * @author Petar Miletic
 * @ticket SFOM-208
 * @since  22/12/2016
*/
@isTest
public class LG_CheckCancellationAndPortingWindowTest {

    @testsetup
    private static void setupTestData() {
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        // Create record types
        RecordType numberBlockRecordType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Asset' AND Name = 'Number Block'];

        Account acc = new Account(Name = 'TestAcc');
        insert acc;

        // Solution 
        csord__Solution__c sol = new csord__Solution__c(Name = 'Test Solution', LG_AnyNumbersToPort__c = false, csord__Identification__c = '6465467985', LG_OrderChanged__c = false, LG_OrderCancelled__c = false);
        insert sol;
        
        // Subscripton 
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '6465467986');
        insert sub; 
        
        // Service 
        csord__Service__c service = new csord__Service__c(csord__Subscription__c = sub.Id, LG_Suborder__c = sol.Id, csord__Identification__c = '6465467987', LG_InstallationPlannedDate__c = Date.today());
        insert service;

        List<Asset> assets = new List<Asset>();
        
        // Top level asset (number block)
        Asset topAsset = new Asset(Name = 'Asset_0', AccountId = acc.Id, csord__Service__c = service.Id, RecordTypeId = numberBlockRecordType.Id);
        insert topAsset;
        
        for (Integer i = 1; i < 6; i++) {
            
            Asset obj = new Asset(Name = 'Asset_' + i, AccountId = acc.Id, csord__Service__c = service.Id);

            obj.LG_Asset__c = topAsset.Id;
            obj.LG_NumberRangeType__c = 'New';
            
            // Set correct record type for every even record
            if (math.mod(i, 2) == 0) {
                obj.LG_PortInWishDate__c = Date.today().addDays(i);
            }
            else {
                obj.LG_PortInWishDate__c = Date.today().addDays(i * -1);
            }
            
            assets.add(obj);
        }

        insert assets;

        // Add Appointment
        LG_ScheduleAppointment__c appointment = new LG_ScheduleAppointment__c(LG_AgreedInstallDate__c = Date.today(), LG_Solution__c = sol.Id, LG_Slot__C = 'Morning Slot');
        insert appointment;

        // Orcestrator stuff
        CSPOFA__Orchestration_Process_Template__c orcTemplate = new CSPOFA__Orchestration_Process_Template__c();
        insert orcTemplate;
        
        CSPOFA__Orchestration_Process__c process = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id, csordtelcoa__Service__c = service.Id, LG_Solution__c = sol.Id);
        insert process;
        
        CSPOFA__Orchestration_Step__c step = new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = process.Id);
        insert step;

        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    
    @isTest
    private static void processTest() {

        List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c];
        
        for(SObject obj : steps) {
            
            CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
            System.assertNotEquals('Complete', step.CSPOFA__Status__c, 'Status should not be complete');
        }
        
        Test.startTest();
        
        LG_CheckCancellationAndPortingWindow testObj = new LG_CheckCancellationAndPortingWindow();
        steps = testObj.process(steps);
            
        Test.stopTest();
        
        for(SObject obj : steps) {
            
            CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
            System.assertEquals('Complete', step.CSPOFA__Status__c, 'Status should be complete');
        }        
    }
    
    @isTest
    private static void checkCancellationAndPortingWindowTest() {
        
        Map<Id, CSPOFA__Orchestration_Process__c> processMap = new Map<Id, CSPOFA__Orchestration_Process__c>([SELECT Id FROM CSPOFA__Orchestration_Process__c]);
        
        // Get solution object before
        csord__Solution__c solBefore = [SELECT ID, LG_OrderChanged__c, LG_OrderCancelled__c FROM csord__Solution__c WHERE Name = 'Test Solution' LIMIT 1];
                        
        Test.startTest();
        
        LG_CheckCancellationAndPortingWindow obj = new LG_CheckCancellationAndPortingWindow();
        obj.checkCancellationAndPortingWindow(processMap.keySet());

        Test.stopTest();
        
        // Get solution object after
        csord__Solution__c solAfter = [SELECT ID, LG_AnyNumbersToPort__c, LG_EarliestPortingWishDate__c, LG_LatestPortingWishDate__c FROM csord__Solution__c WHERE Name = 'Test Solution' LIMIT 1];

        // Asert before state
        System.assertEquals(false, solBefore.LG_OrderChanged__c, 'Invalid Solution data (LG_OrderChanged__c)');
        System.assertEquals(false, solBefore.LG_OrderCancelled__c, 'Invalid Solution data (LG_OrderCancelled__c)');
        
        // Asert after state
        // System.assertEquals(true, solAfter.LG_AnyNumbersToPort__c, 'Invalid Solution data ()');
    }
    
    @isTest
    private static void checkCancellationTest() {
        
        Map<Id, CSPOFA__Orchestration_Process__c> processMap = new Map<Id, CSPOFA__Orchestration_Process__c>([SELECT Id FROM CSPOFA__Orchestration_Process__c]);
        
        // Get solution object before
        csord__Solution__c solBefore = [SELECT ID, LG_OrderChanged__c, LG_OrderCancelled__c FROM csord__Solution__c WHERE Name = 'Test Solution' LIMIT 1];
        solBefore.LG_OrderCancelled__c = true;
        update solBefore;
        
        Test.startTest();
        
        LG_CheckCancellationAndPortingWindow obj = new LG_CheckCancellationAndPortingWindow();
        obj.checkCancellationAndPortingWindow(processMap.keySet());

        Test.stopTest();
        
        // Get solution object after
        csord__Solution__c solAfter = [SELECT ID, LG_AnyNumbersToPort__c, LG_EarliestPortingWishDate__c, LG_LatestPortingWishDate__c FROM csord__Solution__c WHERE Name = 'Test Solution' LIMIT 1];

        // Asert before state
        System.assertEquals(false, solBefore.LG_OrderChanged__c, 'Invalid Solution data (LG_OrderChanged__c)');
        System.assertEquals(true, solBefore.LG_OrderCancelled__c, 'Invalid Solution data (LG_OrderCancelled__c)');
        
        // Asert after state
        // System.assertEquals(true, solAfter.LG_AnyNumbersToPort__c, 'Invalid Solution data ()');
    }
    
    @isTest
    private static void checkPortingWindowTest() {
        
        Map<Id, CSPOFA__Orchestration_Process__c> processMap = new Map<Id, CSPOFA__Orchestration_Process__c>([SELECT Id FROM CSPOFA__Orchestration_Process__c]);
        
        // Get solution object before
        csord__Solution__c solBefore = [SELECT ID, LG_OrderChanged__c, LG_OrderCancelled__c FROM csord__Solution__c WHERE Name = 'Test Solution' LIMIT 1];
        
        // Load Appointment
        LG_ScheduleAppointment__c appointment = [SELECT Id, LG_AgreedInstallDate__c FROM LG_ScheduleAppointment__c WHERE LG_Solution__c = :solBefore.Id LIMIT 1];
        appointment.LG_AgreedInstallDate__c = Date.today().addDays(35);
        update appointment;
                        
        Test.startTest();
        
        LG_CheckCancellationAndPortingWindow obj = new LG_CheckCancellationAndPortingWindow();
        obj.checkCancellationAndPortingWindow(processMap.keySet());

        Test.stopTest();
        
        // Get solution object after
        csord__Solution__c solAfter = [SELECT ID, LG_AnyNumbersToPort__c, LG_EarliestPortingWishDate__c, LG_LatestPortingWishDate__c FROM csord__Solution__c WHERE Name = 'Test Solution' LIMIT 1];

        // Asert before state
        System.assertEquals(false, solBefore.LG_OrderChanged__c, 'Invalid Solution data (LG_OrderChanged__c)');
        System.assertEquals(false, solBefore.LG_OrderCancelled__c, 'Invalid Solution data (LG_OrderCancelled__c)');
        
        // Asert after state
        // System.assertEquals(true, solAfter.LG_AnyNumbersToPort__c, 'Invalid Solution data ()');
    }
}