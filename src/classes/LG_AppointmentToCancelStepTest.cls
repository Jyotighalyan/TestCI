@isTest
private class LG_AppointmentToCancelStepTest {

    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        Account acc = new Account(Name = 'TestAcc');
        insert acc;

        List<csord__Solution__c> solutions = new List<csord__Solution__c>();
        csord__Solution__c solutionPastApp   = new csord__Solution__c(Name = 'SolPastApp', csord__Identification__c = 'SolPastApp');
        csord__Solution__c solutionTodayApp  = new csord__Solution__c(Name = 'SolTodayApp', csord__Identification__c = 'SolTodayApp');
        csord__Solution__c solutionFutureApp = new csord__Solution__c(Name = 'SolFutureApp', csord__Identification__c = 'SolFutureApp');
        solutions.add(solutionPastApp);
        solutions.add(solutionTodayApp);
        solutions.add(solutionFutureApp);
        insert solutions;

        CSPOFA__Orchestration_Process_Template__c orcTemplate = new CSPOFA__Orchestration_Process_Template__c();
        insert orcTemplate;

        List<CSPOFA__Orchestration_Process__c> processes = new List<CSPOFA__Orchestration_Process__c>();
        CSPOFA__Orchestration_Process__c processPast = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
                                                                                            LG_Solution__c = solutionPastApp.Id);
        CSPOFA__Orchestration_Process__c processToday = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
                                                                                             LG_Solution__c = solutionTodayApp.Id);
        CSPOFA__Orchestration_Process__c processFuture = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
                                                                                              LG_Solution__c = solutionFutureApp.Id);
        processes.add(processPast);
        processes.add(processToday);
        processes.add(processFuture);
        insert processes;

        List<CSPOFA__Orchestration_Step__c> steps = new List<CSPOFA__Orchestration_Step__c>();
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processPast.Id));
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processToday.Id));
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processFuture.Id));
        insert steps;

        Schema.DescribeFieldResult slotFieldResult = LG_ScheduleAppointment__c.LG_Slot__c.getDescribe();
        String slotValue                           = slotFieldResult.getPicklistValues()[0].getValue();


        List<LG_ScheduleAppointment__c> schApps = new List<LG_ScheduleAppointment__c>();
        schApps.add(new LG_ScheduleAppointment__c(LG_Slot__c = slotValue, LG_Solution__c = solutionPastApp.Id, LG_AgreedInstallDate__c = Date.today().addDays(-5)));
        schApps.add(new LG_ScheduleAppointment__c(LG_Slot__c = slotValue, LG_Solution__c = solutionTodayApp.Id, LG_AgreedInstallDate__c = Date.today()));
        schApps.add(new LG_ScheduleAppointment__c(LG_Slot__c = slotValue, LG_Solution__c = solutionFutureApp.Id, LG_AgreedInstallDate__c = Date.today().addDays(5)));
        insert schApps;

        noTriggers.Flag__c = false;
        upsert noTriggers;
    }

    private static testmethod void testProcess()
    {
        List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c];

        for (SObject obj : steps) {
            CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
            System.assertNotEquals('Complete', step.CSPOFA__Status__c, 'Status should not be complete');
        }


        Test.startTest();
        LG_AppointmentToCancelStep checkApps = new LG_AppointmentToCancelStep();
        steps = checkApps.process(steps);
        Test.stopTest();

        for (SObject obj : steps) {
            CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
            System.assertEquals('Complete', step.CSPOFA__Status__c, 'Status should be complete');
        }
    }

    private static testmethod void testCheckScheduleAppointment()
    {
        List<CSPOFA__Orchestration_Process__c> processes = [SELECT Id, LG_Solution__c,
                                                            LG_Solution__r.Name,
                                                            LG_Solution__r.LG_AppointmentToCancel__c
                                                            FROM CSPOFA__Orchestration_Process__c
                                                            WHERE LG_Solution__c != null];

        Set<Id> processids = new Set<Id>();
        for (CSPOFA__Orchestration_Process__c process : processes) {
            processids.add(process.Id);
            System.assertEquals(false, process.LG_Solution__r.LG_AppointmentToCancel__c, 'Appointment to Cancel flag should be set to false');
        }

        Test.startTest();
        LG_AppointmentToCancelStep checkApps = new LG_AppointmentToCancelStep();
        checkApps.checkScheduleAppointment(processids);
        Test.stopTest();

        processes = [SELECT Id, LG_Solution__c,
                     LG_Solution__r.Name,
                     LG_Solution__r.LG_AppointmentToCancel__c
                     FROM CSPOFA__Orchestration_Process__c];

        for (CSPOFA__Orchestration_Process__c process : processes) {
            if (process.LG_Solution__r.Name == 'SolPastApp') {
                System.assertEquals(false, process.LG_Solution__r.LG_AppointmentToCancel__c, 'Appointment to Cancel flag should be set to true');
            } else if (process.LG_Solution__r.Name == 'SolTodayApp' || process.LG_Solution__r.Name == 'SolFutureApp') {
                System.assertEquals(true, process.LG_Solution__r.LG_AppointmentToCancel__c, 'Appointment to Cancel flag should remain false');
            }
        }
    }
}