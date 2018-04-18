@isTest
private class LG_SolutionTriggerHandlerTest {

	@testsetup
	private static void setupTestData()
	{
		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c      = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);

		Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);

		csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
		insert coreq;

		csord__Order__c order = LG_GeneralTest.createOrder('MonitorOrderName', account, 'First Status', coreq, opp, true);

		csord__Solution__c solution = new csord__Solution__c(Name = 'Test Solution', csord__Identification__c = '6465467986', csord__Order__c = order.Id);
		insert solution;
		
		//For BDS
		Account acc = new Account(Name = 'TestAcc');
        insert acc;
        
         //Order
        //csord__Order__c order = new csord__Order__c(Name='Test Order',csord__Identification__c = '6465467986');
        //insert order;

        List<csord__Solution__c> solutions = new List<csord__Solution__c>();
        csord__Solution__c solVPNService         = new csord__Solution__c(Name = 'solVPNService', csord__Identification__c = 'solVPNService', csord__Order__c= order.Id,LG_DecompositionCriteria__c = 'Set 21 - VPN Process');
        csord__Solution__c solBDSService       = new csord__Solution__c(Name = 'solBDSService', csord__Identification__c = 'solBDSService', csord__Order__c= order.Id,LG_DecompositionCriteria__c = 'Set 21 - VPN Process');
        csord__Solution__c solConnectionService       = new csord__Solution__c(Name = 'solConnectionService', csord__Identification__c = 'solConnectionService', csord__Order__c= order.Id,LG_DecompositionCriteria__c = 'Set 21 - VPN Process');
        solutions.add(solVPNService);
        solutions.add(solBDSService);
        solutions.add(solConnectionService);
        insert solutions;
        
        CSPOFA__Orchestration_Process_Template__c orcTemplate = new CSPOFA__Orchestration_Process_Template__c();
        insert orcTemplate;

        List<CSPOFA__Orchestration_Process__c> processes = new List<CSPOFA__Orchestration_Process__c>();
        CSPOFA__Orchestration_Process__c processVPN = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
                                                                                           LG_Solution__c = solVPNService.Id);
        CSPOFA__Orchestration_Process__c processBDS = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
                                                                                                LG_Solution__c = solBDSService.Id);
        CSPOFA__Orchestration_Process__c processConnection = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
                                                                                                LG_Solution__c = solConnectionService.Id);    
        processes.add(processVPN);
        processes.add(processBDS);
        processes.add(processConnection);
        insert processes;

        List<CSPOFA__Orchestration_Step__c> steps = new List<CSPOFA__Orchestration_Step__c>();
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processVPN.Id));
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processBDS.Id));
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processConnection.Id));
        insert steps;

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'IdentSub');
        insert sub;

        List<csord__Service__c> services = new List<csord__Service__c>();
        csord__Service__c VPNService = new csord__Service__c(csord__Status__c = 'Provisioned', csord__Subscription__c = sub.Id, 
                                                                csord__Identification__c = 'solVPNService', LG_Suborder__c = solVPNService.Id,LG_From_Service__c='',Persistent_Id__c='0036E00000HaVPN',LG_RootOrder__c=order.Id);
        csord__Service__c BDSService = new csord__Service__c(csord__Status__c = 'Ready for Billing', csord__Subscription__c = sub.Id, 
                                                                  csord__Identification__c = 'solBDSService', LG_Suborder__c = solBDSService.Id,Persistent_Id__c='0036E00000HaBDSQA3',LG_RootOrder__c=order.Id);
        BDSService.csord__Deactivation_Date__c = System.Today();
        csord__Service__c BDSService1 = new csord__Service__c(csord__Status__c = 'Provisioned', csord__Subscription__c = sub.Id, 
                                                                  csord__Identification__c = 'solBDSService', LG_Suborder__c = solBDSService.Id,Persistent_Id__c='0036E00000HaBDSQA3',LG_RootOrder__c=order.Id);

        csord__Service__c ConnectionService = new csord__Service__c(csord__Status__c = 'Provisioned', csord__Subscription__c = sub.Id, 
                                                                  csord__Identification__c = 'solConnectionService', LG_Suborder__c = solConnectionService.Id,LG_From_Service__c='0036E00000HaVPN',LG_To_Service__c='0036E00000HaBDSQA3',LG_RootOrder__c=order.Id);                
        services.add(VPNService);
        services.add(BDSService);
        services.add(BDSService1);
        services.add(ConnectionService);
        insert services;

		noTriggers.Flag__c = false;
		upsert noTriggers;
	}

	private static testmethod void testNotifyMonitorFieldJeopardy()
	{
		csord__Solution__c solution = [SELECT Id, LG_Jeopardy__c FROM csord__Solution__c WHERE Name = 'Test Solution'];

		Test.startTest();
		solution.LG_Jeopardy__c = true;
		update solution;
		Test.stopTest();
	}

	private static testmethod void testNotifyMonitorFieldInflight()
	{
		csord__Solution__c solution = [SELECT Id, LG_InflightChange__c FROM csord__Solution__c WHERE Name = 'Test Solution'];

		Test.startTest();
		solution.LG_InflightChange__c = true;
		update solution;
		Test.stopTest();
	}

	private static testmethod void testNotifyMonitorFieldOrderChanged()
	{
		csord__Solution__c solution = [SELECT Id, LG_OrderChanged__c FROM csord__Solution__c WHERE Name = 'Test Solution'];

		Test.startTest();
		solution.LG_OrderChanged__c = true;
		update solution;
		Test.stopTest();
	}
	
	private static testmethod void testCheckBDSVPNSite()
	{
		List<CSPOFA__Orchestration_Process__c> processes = [SELECT Id, LG_Solution__c,
                                                            LG_Solution__r.Name
                                                            FROM CSPOFA__Orchestration_Process__c
                                                            WHERE LG_Solution__c != null];
                                                            
        List<csord__Solution__c> solutions = new List<csord__Solution__c>();
        for(csord__Solution__c sol : [SELECT Id, LG_OrderChanged__c FROM csord__Solution__c]){
        	sol.LG_DecompositionCriteria__c = 'Set 21 - VPN Process';
        	sol.LG_Activated_New_Site__c = 'Check Services';
        	solutions.add(sol);
        }
        update solutions;
        csord__Service__c BDSService = [SELECT Id,csord__Status__c,LG_Suborder__c,LG_RootOrder__c FROM csord__Service__c WHERE csord__Identification__c = 'solBDSService' LIMIT 1];

        
        Set<Id> processids = new Set<Id>();
        for (CSPOFA__Orchestration_Process__c process : processes) {
            processids.add(process.Id);
        }

        Test.startTest();
        LG_CheckVPNAndConnectionStatus checkServices = new LG_CheckVPNAndConnectionStatus();
        //checkServices.checkVPNAndConnectionStatus(processids);
        
        BDSService.csord__Status__c = 'Activation Completed';
        update BDSService;
        
        System.debug('>>>>STatus1111>>>'+BDSService.Id);
        checkServices.checkVPNAndConnectionStatus(processids);
        Test.stopTest();
	}
}