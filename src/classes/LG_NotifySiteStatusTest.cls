@isTest
private class LG_NotifySiteStatusTest {

    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        Account acc = new Account(Name = 'TestAcc');
        insert acc;
        
         //Order
        csord__Order__c order = new csord__Order__c(Name='Test Order',csord__Identification__c = '6465467986');
        insert order;

        List<csord__Solution__c> solutions = new List<csord__Solution__c>();
        csord__Solution__c solVPNService         = new csord__Solution__c(Name = 'solVPNService', csord__Identification__c = 'solVPNService', csord__Order__c= order.Id,LG_Activated_New_Site__c = 'false');
        csord__Solution__c solCCCOffnetService   = new csord__Solution__c(Name = 'solCCCOffnetService', csord__Identification__c = 'solCCCOffnetService', csord__Order__c= order.Id,LG_Activated_New_Site__c = 'false');
        csord__Solution__c solBDSService       = new csord__Solution__c(Name = 'solBDSService', csord__Identification__c = 'solBDSService', csord__Order__c= order.Id,LG_Activated_New_Site__c = 'false');
        csord__Solution__c solConnectionService       = new csord__Solution__c(Name = 'solConnectionService', csord__Identification__c = 'solConnectionService', csord__Order__c= order.Id,LG_Activated_New_Site__c = 'false');
        solutions.add(solVPNService);
        solutions.add(solCCCOffnetService);
        solutions.add(solBDSService);
        solutions.add(solConnectionService);
        insert solutions;
        
        CSPOFA__Orchestration_Process_Template__c orcTemplate = new CSPOFA__Orchestration_Process_Template__c();
        insert orcTemplate;

        List<CSPOFA__Orchestration_Process__c> processes = new List<CSPOFA__Orchestration_Process__c>();
        CSPOFA__Orchestration_Process__c processVPN = new CSPOFA__Orchestration_Process__c(Name = 'VPNProcess', CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
                                                                                           LG_Solution__c = solVPNService.Id);
        CSPOFA__Orchestration_Process__c processCCCOffnet = new CSPOFA__Orchestration_Process__c(Name = 'CCCOffnetProcess',CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
                                                                                                LG_Solution__c = solCCCOffnetService.Id);                                                                                   
        CSPOFA__Orchestration_Process__c processBDS = new CSPOFA__Orchestration_Process__c(Name = 'BDSProcess', CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
                                                                                                LG_Solution__c = solBDSService.Id);
        CSPOFA__Orchestration_Process__c processConnection = new CSPOFA__Orchestration_Process__c(Name = 'VPNConnectionProcess', CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
                                                                                                LG_Solution__c = solConnectionService.Id);    
        processes.add(processVPN);
        processes.add(processCCCOffnet);
        processes.add(processBDS);
        processes.add(processConnection);
        insert processes;

        List<CSPOFA__Orchestration_Step__c> steps = new List<CSPOFA__Orchestration_Step__c>();
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processVPN.Id));
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processCCCOffnet.Id));
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processBDS.Id));
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processConnection.Id));
        insert steps;

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'IdentSub');
        insert sub;

        List<csord__Service__c> services = new List<csord__Service__c>();
        csord__Service__c VPNService = new csord__Service__c(csord__Status__c = 'Provisioned', csord__Subscription__c = sub.Id,
                                                                csord__Identification__c = 'solVPNService', LG_Suborder__c = solVPNService.Id,LG_From_Service__c='',Persistent_Id__c='VPNPERS123',LG_RootOrder__c=order.Id);
		csord__Service__c CCCOffnetService = new csord__Service__c(csord__Status__c = 'Provisioned', LG_ServiceStatus__c ='Requested', csord__Subscription__c = sub.Id, LG_DecompositionCriteria__c ='Set 23 - CCC Offnet Process',
                                                                  csord__Identification__c = 'solCCCOffnetService', LG_Suborder__c = solCCCOffnetService.Id,Persistent_Id__c='CCCPERS123',LG_RootOrder__c=order.Id);
        csord__Service__c BDSService = new csord__Service__c(csord__Status__c = 'Provisioned', csord__Subscription__c = sub.Id,UM_DependsOnService__c = CCCOffnetService.Id, 
                                                                  csord__Identification__c = 'solBDSService', LG_Suborder__c = solBDSService.Id,Persistent_Id__c='BDSPERS123',LG_RootOrder__c=order.Id);
        csord__Service__c ConnectionService = new csord__Service__c(csord__Status__c = 'Provisioned', csord__Subscription__c = sub.Id,
                                                                  csord__Identification__c = 'solConnectionService', LG_Suborder__c = solConnectionService.Id,LG_From_Service__c='VPNPERS123',LG_To_Service__c='BDSPERS123',LG_RootOrder__c=order.Id);                
        services.add(VPNService);
        services.add(CCCOffnetService);
        services.add(BDSService);
        services.add(ConnectionService);
        insert services;
        
       	BDSService.UM_DependsOnService__c = CCCOffnetService.Id;
        update BDSService;
       
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
        LG_NotifySiteStatus checkServices = new LG_NotifySiteStatus();
        steps = checkServices.process(steps);
        Test.stopTest();

        for (SObject obj : steps) {
            CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
            System.assertEquals('Complete', step.CSPOFA__Status__c, 'Status should not be complete');
        }
    }

    private static testmethod void testCheckServiceStatustoNotify()
    {
        /*No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;*/
        
        List<CSPOFA__Orchestration_Process__c> processes = [SELECT Id, LG_Solution__c,
                                                            LG_Solution__r.Name
                                                            FROM CSPOFA__Orchestration_Process__c
                                                            WHERE LG_Solution__c != null];
        csord__Service__c BDSService = [SELECT Id,csord__Status__c,LG_Suborder__c,LG_RootOrder__c FROM csord__Service__c WHERE csord__Identification__c = 'solBDSService' LIMIT 1];

        
        Set<Id> processids = new Set<Id>();
        for (CSPOFA__Orchestration_Process__c process : processes) {
            processids.add(process.Id);
        }

        Test.startTest();
        LG_NotifySiteStatus checkServices = new LG_NotifySiteStatus();
        checkServices.checkServiceStatustoNotify(processids);
        
        BDSService.csord__Status__c = 'Activation Completed';
        update BDSService;
        checkServices.checkServiceStatustoNotify(processids);
        Test.stopTest();
        
        /*noTriggers.Flag__c = false;
        upsert noTriggers;*/

        
    }
    
    private static testmethod void testCheckDependentOnServiceStatustoNotify()
    {
        /*No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;*/
        
        CSPOFA__Orchestration_Process__c process = [SELECT Id, LG_Solution__c,
                                                            LG_Solution__r.Name
                                                            FROM CSPOFA__Orchestration_Process__c
                                                            WHERE Name = 'BDSProcess'];
                
        Set<Id> processid = new Set<Id>();
     
        processid.add(process.Id);
     
        Test.startTest();
        LG_NotifySiteStatus checkServices = new LG_NotifySiteStatus();
        checkServices.checkServiceStatustoNotify(processid);
       
       csord__Service__c cccService = [SELECT Id,csord__Status__c,LG_Suborder__c,LG_RootOrder__c, LG_ServiceStatus__c FROM csord__Service__c WHERE csord__Identification__c = 'solCCCOffnetService' LIMIT 1];
        
       system.assertEquals('Activation Completed', cccService.LG_ServiceStatus__c, 'Dependent Service Status should be set to Activation Completed!');
        
       Test.stopTest();
        
        /*noTriggers.Flag__c = false;
        upsert noTriggers;*/

        
    }
}