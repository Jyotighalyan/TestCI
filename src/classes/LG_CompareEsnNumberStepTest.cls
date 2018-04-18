/**
 * Test class for LG_CompareEsnNumberStep 
 *
 * @author Alisha
 * @ticket OMB-1746
 * @since  18/12/2017
 */
@isTest
public class LG_CompareEsnNumberStepTest {

  
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
        csord__Solution__c solutionActiveService         = new csord__Solution__c(Name = 'SolActiveService', csord__Identification__c = 'SolActiveService');
        csord__Solution__c solutionActiveServiceReplaced = new csord__Solution__c(Name = 'SolActiveServiceReplaced', csord__Identification__c = 'SolActiveServiceReplaced');
        solutions.add(solutionActiveService);
        solutions.add(solutionActiveServiceReplaced);
        insert solutions;

        CSPOFA__Orchestration_Process_Template__c orcTemplate = new CSPOFA__Orchestration_Process_Template__c();
        insert orcTemplate;

        List<CSPOFA__Orchestration_Process__c> processes = new List<CSPOFA__Orchestration_Process__c>();
        CSPOFA__Orchestration_Process__c processAct = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
                                                                                           LG_Solution__c = solutionActiveService.Id);
        CSPOFA__Orchestration_Process__c processActReplaced = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
                                                                                                   LG_Solution__c = solutionActiveServiceReplaced.Id);
        processes.add(processAct);
        processes.add(processActReplaced);
        insert processes;

        List<CSPOFA__Orchestration_Step__c> steps = new List<CSPOFA__Orchestration_Step__c>();
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processAct.Id));
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processActReplaced.Id));
        insert steps;

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'IdentSub');
        insert sub;

        List<csord__Service__c> services = new List<csord__Service__c>();
        csord__Service__c serviceActive = new csord__Service__c(UM_ESN__c='123',csord__Status__c = 'Activation Completed', csord__Subscription__c = sub.Id,
                                                                csord__Identification__c = 'serviceActive', LG_Suborder__c = solutionActiveService.Id);
        csord__Service__c serviceActiveReplaced = new csord__Service__c(UM_ESN__c='1234',csord__Status__c = 'Activation Completed', csord__Subscription__c = sub.Id,
                                                                        csord__Identification__c = 'serviceActiveReplaced', LG_Suborder__c = solutionActiveServiceReplaced.Id);
        services.add(serviceActive);
        services.add(serviceActiveReplaced);
        insert services;
        csord__Service__c s=[select id from csord__Service__c where id=:serviceActive.id];
        s.csordtelcoa__Replaced_Service__c=serviceActiveReplaced.id;
        update s;

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
        LG_CompareEsnNumberStep a= new LG_CompareEsnNumberStep ();
        steps = a.process(steps);
        Test.stopTest();

        for (SObject obj : steps) {
            CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
            System.assertEquals('Complete', step.CSPOFA__Status__c, 'Status should not be complete');
        }
    }

    private static testmethod void testCompareEsn()
    {
        List<CSPOFA__Orchestration_Process__c> processes = [SELECT Id, LG_Solution__c,
                                                            LG_Solution__r.Name,
                                                            LG_Solution__r.LG_AnyActiveService__c
                                                            FROM CSPOFA__Orchestration_Process__c
                                                            WHERE LG_Solution__c != null];

        Set<Id> processids = new Set<Id>();
        for (CSPOFA__Orchestration_Process__c process : processes) {
            processids.add(process.Id);
            System.assertEquals(false, process.LG_Solution__r.LG_AnyActiveService__c, Label.LG_ErrorServiceFlagFalse);
        }

        Test.startTest();
        LG_CompareEsnNumberStep compareEsn= new LG_CompareEsnNumberStep();
        compareEsn.compareEsnNumber(processids);
        Test.stopTest();
}
}