@isTest
private class LG_AnyNumberPortReqsStepTest {

    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);

        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);

        csord__Solution__c solutionWithNumberPort = new csord__Solution__c(Name = 'testSolNmbrPort',
                                                                           csord__Identification__c = 'testsol');
        insert solutionWithNumberPort;

        csord__Solution__c solutionWoNumberPort = new csord__Solution__c(Name = 'testSolWoNmbrPort',
                                                                         csord__Identification__c = 'testsol');
        insert solutionWoNumberPort;

        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Basket', account, null, opp, false);
        basket.csbb__Account__c = account.Id;
        insert basket;

        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert coreq;

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = coreq.Id);
        insert sub;

        csord__Service__c telephonyService = new csord__Service__c(csord__Identification__c = 'TestTelServ', csord__Order_Request__c = coreq.Id, LG_Suborder__c = solutionWithNumberPort.Id,
                                                                   csord__Subscription__c = sub.Id);
        insert telephonyService;

        csord__Service__c telephonyServiceWoNumberPort = new csord__Service__c(csord__Identification__c = 'TestTelServWoNmbr', csord__Order_Request__c = coreq.Id, LG_Suborder__c = solutionWoNumberPort.Id,
                                                                               csord__Subscription__c = sub.Id);
        insert telephonyServiceWoNumberPort;

        Id numberBlockRTId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Number Block').getRecordTypeId();

        Asset numberBlock = new Asset();
        numberBlock.Name                   = '090123';
        numberBlock.AccountId              = account.Id;
        numberBlock.RecordTypeId           = numberBlockRTId;
        numberBlock.LG_EndNumber__c        = '090123';
        numberBlock.LG_NumberRange__c      = '090123';
        numberBlock.LG_NumberRangeSize__c  = Decimal.valueOf('1');
        numberBlock.LG_NumberRangeType__c  = 'Port-In';
        numberBlock.LG_StartNumber__c      = '090123';
        numberBlock.LG_PortInWishDate__c   = Date.newInstance(2017, 2, 17);
        numberBlock.LG_TelephonyService__c = telephonyService.Id;
        insert numberBlock;

        Asset numberBlockWoNmbrPort = new Asset();
        numberBlockWoNmbrPort.Name                   = '090123';
        numberBlockWoNmbrPort.AccountId              = account.Id;
        numberBlockWoNmbrPort.RecordTypeId           = numberBlockRTId;
        numberBlockWoNmbrPort.LG_EndNumber__c        = '090123';
        numberBlockWoNmbrPort.LG_NumberRange__c      = '090123';
        numberBlockWoNmbrPort.LG_NumberRangeSize__c  = Decimal.valueOf('1');
        numberBlockWoNmbrPort.LG_NumberRangeType__c  = 'Port-In';
        numberBlockWoNmbrPort.LG_StartNumber__c      = '090123';
        numberBlockWoNmbrPort.LG_PortInWishDate__c   = Date.newInstance(2017, 2, 17);
        numberBlockWoNmbrPort.LG_TelephonyService__c = telephonyServiceWoNumberPort.Id;
        insert numberBlockWoNmbrPort;

        CSPOFA__Orchestration_Process_Template__c orcTemplate = new CSPOFA__Orchestration_Process_Template__c();
        insert orcTemplate;

        List<CSPOFA__Orchestration_Process__c> processes = new List<CSPOFA__Orchestration_Process__c>();
        CSPOFA__Orchestration_Process__c processNmbrPort = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
                                                                                                LG_Solution__c = solutionWithNumberPort.Id);
        CSPOFA__Orchestration_Process__c processWoNmbrPort = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
                                                                                                  LG_Solution__c = solutionWoNumberPort.Id);
        processes.add(processNmbrPort);
        processes.add(processWoNmbrPort);
        insert processes;

        List<CSPOFA__Orchestration_Step__c> steps = new List<CSPOFA__Orchestration_Step__c>();
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processNmbrPort.Id));
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processWoNmbrPort.Id));
        insert steps;

        LG_PortingProcess__c portProcess = new LG_PortingProcess__c();
        insert portProcess;

        LG_ProcessRequest__c portProcessReq = new LG_ProcessRequest__c(LG_Process__c = portProcess.Id);
        insert portProcessReq;

        LG_AssetProcessAssociation__c assWithPort = new LG_AssetProcessAssociation__c(LG_Process__c = portProcess.Id, LG_Asset__c = numberBlock.Id);
        insert assWithPort;

        LG_PortingProcess__c portProcessWoNumberPort = new LG_PortingProcess__c();
        insert portProcessWoNumberPort;

        LG_ProcessRequest__c portProcessReqWoNumberPort = new LG_ProcessRequest__c(LG_Process__c = portProcessWoNumberPort.Id, LG_Response__c = 'Rejected');
        insert portProcessReqWoNumberPort;

        LG_AssetProcessAssociation__c assWithoutPort = new LG_AssetProcessAssociation__c(LG_Process__c = portProcessWoNumberPort.Id, LG_Asset__c = numberBlockWoNmbrPort.Id);
        insert assWithoutPort;

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
        LG_AnyNumberPortReqsStep checkNmbr = new LG_AnyNumberPortReqsStep();
        steps = checkNmbr.process(steps);
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
                                                            LG_Solution__r.LG_ProcessRequestsToCancel__c
                                                            FROM CSPOFA__Orchestration_Process__c
                                                            WHERE LG_Solution__c != null];

        Set<Id> processids = new Set<Id>();
        for (CSPOFA__Orchestration_Process__c process : processes) {
            processids.add(process.Id);
            System.assertEquals(false, process.LG_Solution__r.LG_ProcessRequestsToCancel__c, 'Process Requests to Cancel flag should be set to false');
        }

        Test.startTest();
        LG_AnyNumberPortReqsStep checkNmbr = new LG_AnyNumberPortReqsStep();
        checkNmbr.checkNumberPortRequests(processids);
        Test.stopTest();

        processes = [SELECT Id, LG_Solution__c,
                     LG_Solution__r.Name,
                     LG_Solution__r.LG_ProcessRequestsToCancel__c
                     FROM CSPOFA__Orchestration_Process__c];

        for (CSPOFA__Orchestration_Process__c process : processes) {
            if (process.LG_Solution__r.Name == 'testSolNmbrPort') {
                System.assertEquals(true, process.LG_Solution__r.LG_ProcessRequestsToCancel__c, 'Process Requests to Cancel flag should be set to true');
            } else if (process.LG_Solution__r.Name == 'testSolWoNmbrPort') {
                System.assertEquals(false, process.LG_Solution__r.LG_ProcessRequestsToCancel__c, 'Process Requests to Cancel flag should remain false');
            }
        }
    }
}