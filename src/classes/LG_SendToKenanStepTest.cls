@isTest
private class LG_SendToKenanStepTest {
    /*

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
		csord__Solution__c replacementSolution           = new csord__Solution__c(Name = 'replacementSolution', csord__Identification__c = 'replacementSolution');
		csord__Solution__c solutionInactiveService       = new csord__Solution__c(Name = 'solutionInactiveService', csord__Identification__c = 'solutionInactiveService');
		solutions.add(solutionActiveService);
		solutions.add(solutionActiveServiceReplaced);
		solutions.add(solutionInactiveService);
		solutions.add(replacementSolution);
		insert solutions;
		replacementSolution.LG_OldSuborder__c = solutionActiveServiceReplaced.Id;
		update replacementSolution;

		CSPOFA__Orchestration_Process_Template__c orcTemplate = new CSPOFA__Orchestration_Process_Template__c();
		insert orcTemplate;

		List<CSPOFA__Orchestration_Process__c> processes = new List<CSPOFA__Orchestration_Process__c>();
		CSPOFA__Orchestration_Process__c processAct = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
																						   LG_Solution__c = solutionActiveService.Id);
		CSPOFA__Orchestration_Process__c processActReplaced = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
																								   LG_Solution__c = solutionActiveServiceReplaced.Id);
		CSPOFA__Orchestration_Process__c processInactive = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
																								LG_Solution__c = solutionInactiveService.Id);
		processes.add(processAct);
		processes.add(processActReplaced);
		processes.add(processInactive);
		insert processes;

		List<CSPOFA__Orchestration_Step__c> steps = new List<CSPOFA__Orchestration_Step__c>();
		steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processAct.Id));
		steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processActReplaced.Id));
		steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processInactive.Id));
		insert steps;

		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'IdentSub');
		insert sub;

		List<csord__Service__c> services = new List<csord__Service__c>();
		csord__Service__c serviceActive = new csord__Service__c(csord__Status__c = 'Activation Completed', csord__Subscription__c = sub.Id,
																csord__Identification__c = 'serviceActive', LG_Suborder__c = solutionActiveService.Id);
		csord__Service__c serviceInactiveForNew = new csord__Service__c(csord__Status__c = 'Requested', csord__Subscription__c = sub.Id,
																		csord__Identification__c = 'serviceInactiveForNew', LG_Suborder__c = solutionActiveService.Id);
		csord__Service__c serviceActiveReplaced = new csord__Service__c(csord__Status__c = 'Activation Completed', csord__Subscription__c = sub.Id,
																		csord__Identification__c = 'serviceActiveReplaced', LG_Suborder__c = solutionActiveServiceReplaced.Id);
		csord__Service__c serviceInactive = new csord__Service__c(csord__Status__c = 'Requested', csord__Subscription__c = sub.Id,
																  csord__Identification__c = 'serviceInactive', LG_Suborder__c = solutionInactiveService.Id);
		services.add(serviceActive);
		services.add(serviceInactiveForNew);
		services.add(serviceActiveReplaced);
		services.add(serviceInactive);
		insert services;

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
		LG_AnyActiveServiceStep checkServices = new LG_AnyActiveServiceStep();
		steps = checkServices.process(steps);
		Test.stopTest();

		for (SObject obj : steps) {
			CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
			System.assertEquals('Complete', step.CSPOFA__Status__c, 'Status should be complete');
		}
	}

	private static testmethod void testCheckActiveServices()
	{
		List<CSPOFA__Orchestration_Process__c> processes = [SELECT Id, LG_Solution__c,
															LG_Solution__r.Name,
															LG_Solution__r.LG_AnyActiveService__c
															FROM CSPOFA__Orchestration_Process__c
															WHERE LG_Solution__c != null];

		Set<Id> processids = new Set<Id>();
		for (CSPOFA__Orchestration_Process__c process : processes) {
			processids.add(process.Id);
			System.assertEquals(false, process.LG_Solution__r.LG_AnyActiveService__c, 'Any Active Service flag should be set to false');
		}

		Test.startTest();
		LG_AnyActiveServiceStep checkServices = new LG_AnyActiveServiceStep();
		checkServices.checkActiveServices(processids);
		Test.stopTest();

		processes = [SELECT Id, LG_Solution__c,
					 LG_Solution__r.Name,
					 LG_Solution__r.LG_AnyActiveService__c
					 FROM CSPOFA__Orchestration_Process__c];

		for (CSPOFA__Orchestration_Process__c process : processes) {
			if (process.LG_Solution__r.Name == 'SolActiveService') {
				System.assertEquals(true, process.LG_Solution__r.LG_AnyActiveService__c, 'Any Active Service flag should be set to true');
			} else if (process.LG_Solution__r.Name == 'SolActiveServiceReplaced' || process.LG_Solution__r.Name == 'solutionInactiveService') {
				System.assertEquals(false, process.LG_Solution__r.LG_AnyActiveService__c, 'Any Active Service flag remain false');
			}
		}
	}*/
    
    public static testmethod void LG_Sendtest(){
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c      = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		Account acc = new Account(Name = 'TestAcc');
		insert acc;

		List<csord__Solution__c> solutions = new List<csord__Solution__c>();
		csord__Solution__c solutionActiveService         = new csord__Solution__c(Name = 'SolActiveService', csord__Identification__c = 'SolActiveService');
		csord__Solution__c solutionActiveServiceReplaced = new csord__Solution__c(Name = 'SolActiveServiceReplaced', csord__Identification__c = 'SolActiveServiceReplaced');
		csord__Solution__c replacementSolution           = new csord__Solution__c(Name = 'replacementSolution', csord__Identification__c = 'replacementSolution');
		csord__Solution__c solutionInactiveService       = new csord__Solution__c(Name = 'solutionInactiveService', csord__Identification__c = 'solutionInactiveService');
		solutions.add(solutionActiveService);
		solutions.add(solutionActiveServiceReplaced);
		solutions.add(solutionInactiveService);
		solutions.add(replacementSolution);
		insert solutions;
		replacementSolution.LG_OldSuborder__c = solutionActiveServiceReplaced.Id;
		update replacementSolution;

		CSPOFA__Orchestration_Process_Template__c orcTemplate = new CSPOFA__Orchestration_Process_Template__c();
		insert orcTemplate;
        
        List<CSPOFA__Orchestration_Process__c> processes = new List<CSPOFA__Orchestration_Process__c>();
		CSPOFA__Orchestration_Process__c processAct = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
																						   LG_Solution__c = solutionActiveService.Id);
	//	CSPOFA__Orchestration_Process__c processActReplaced = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
																								  // LG_Solution__c = solutionActiveServiceReplaced.Id);
		//CSPOFA__Orchestration_Process__c processInactive = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
																								//LG_Solution__c = solutionInactiveService.Id);
		processes.add(processAct);
	//	processes.add(processActReplaced);
		//processes.add(processInactive);
		insert processes;

	CSPOFA__Orchestration_Step__c steps1 = new CSPOFA__Orchestration_Step__c();
		steps1.CSPOFA__Orchestration_Process__c = processAct.Id;
	//	steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processActReplaced.Id));
		//steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processInactive.Id));
		insert steps1;
        list<CSPOFA__Orchestration_Step__c> l4=new List<CSPOFA__Orchestration_Step__c>();
        l4.add(steps1);
          List<id> processesIds=new LIST<ID>();
        for(CSPOFA__Orchestration_Step__c st: l4){
            
            processesIds.add(st.CSPOFA__Orchestration_Process__c);
            
        }
         system.debug(processesIds);
    /*    csord__Solution__c sol=[SELECT Id,
											(SELECT Id,csord__Status__c,csord__Activation_Date__c FROM Services__r
											)
											FROM csord__Solution__c WHERE Id IN (SELECT LG_Solution__c
														 FROM CSPOFA__Orchestration_Process__c
														 WHERE Id IN :processesIds)];
        
        system.debug(sol);*/
        
        test.startTest();
        LG_SendToKenanStep  step=new LG_SendToKenanStep();
        List<sobject> l1=new List<sobject>();
        //l1.add(steps1);
      
      //  l1.add(solutionActiveService);
     
        step.process(l1);
        
      
        test.stopTest();
        
        
    }
}