@isTest
private class LG_ScanBillingAccountsStepTest {
	
    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
		
		Account acc = new Account(Name = 'TestAcc');
		insert acc;
		
		csconta__Billing_Account__c billAcc = LG_GeneralTest.createBillingAccount('testNmbr', acc.Id, false, false);
		//billAcc.LG_ExternalSystem__c = 'ICOMS';
		csconta__Billing_Account__c billICOMSNotSet = LG_GeneralTest.createBillingAccount('testNmbr', acc.Id, false, false);
		billICOMSNotSet.LG_ExternalSystem__c = 'ICOMS';
		csconta__Billing_Account__c billICOMSSet = LG_GeneralTest.createBillingAccount('testNmbr', acc.Id, false, false);
		billICOMSSet.LG_ExternalSystem__c = 'ICOMS';
		//billICOMSSet.LG_ExternalId__c = '13-123456789';
		List<csconta__Billing_Account__c> billAccs = new List<csconta__Billing_Account__c>();
		billAccs.add(billAcc);
		billAccs.add(billICOMSSet);
		billAccs.add(billICOMSNotSet);
		insert billAccs;
		system.debug('111111111111'+billICOMSSet);
		system.debug('11111111222221111'+billICOMSNotSet);
		csord__Solution__c solution = new csord__Solution__c(Name = 'NewBilling', csord__Identification__c = 'IdentSol',LG_NewBilling__c=false);
		insert solution;
		
		csord__Solution__c solutionSec = new csord__Solution__c(csord__Identification__c = 'IdentSol');
		insert solutionSec;
		
		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'IdentSub',csconta__Billing_Account__c=billAcc.Id);
		insert sub; 
		
		csord__Service__c service = new csord__Service__c(csord__Subscription__c = sub.Id,
															LG_Suborder__c = solution.Id, csord__Identification__c = 'IdentSol');
		insert service;
		
		csord__Service__c serviceNewBill = new csord__Service__c(LG_Suborder__c = solution.Id, csord__Identification__c = 'IdentSol',
																	csord__Subscription__c = sub.Id);
		insert serviceNewBill;
		
		csord__Service_Line_Item__c sliFirst = new csord__Service_Line_Item__c(csord__Service__c = service.Id, csord__Identification__c = 'IdentSol',
																				LG_BillingAccount__c = billAcc.Id);
		csord__Service_Line_Item__c sliSec = new csord__Service_Line_Item__c(csord__Service__c = serviceNewBill.Id, csord__Identification__c = 'IdentSol',
																				LG_BillingAccount__c = billICOMSSet.Id);
		csord__Service_Line_Item__c sliThird = new csord__Service_Line_Item__c(csord__Service__c = serviceNewBill.Id, csord__Identification__c = 'IdentSol',
																				LG_BillingAccount__c = billICOMSNotSet.Id);
		List<csord__Service_Line_Item__c> slis = new List<csord__Service_Line_Item__c>();
		slis.add(sliFirst);
		slis.add(sliSec);
		slis.add(sliThird);
		insert slis;															
		
		CSPOFA__Orchestration_Process_Template__c orcTemplate = new CSPOFA__Orchestration_Process_Template__c();
		insert orcTemplate;
        
		CSPOFA__Orchestration_Process__c process = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id, 
																						LG_Solution__c = solution.Id);
		insert process;
		
		CSPOFA__Orchestration_Process__c processSecond = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
																								LG_Solution__c = solutionSec.Id);
		insert processSecond;
		
		CSPOFA__Orchestration_Step__c step = new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = process.Id);
		CSPOFA__Orchestration_Step__c stepSecond = new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processSecond.Id);
		insert step;
		insert stepSecond;
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
	
	private static testmethod void testProcess()
	{
		List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c];
		
		for(SObject obj : steps)
		{
			CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
			System.assertNotEquals('Complete', step.CSPOFA__Status__c, 'Status should not be complete');
		}
		
		
		Test.startTest();
			LG_ScanBillingAccountsStep scanBillAccs = new LG_ScanBillingAccountsStep();
			steps = scanBillAccs.process(steps);
		Test.stopTest();
		
		for(SObject obj : steps)
		{
			CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
			System.assertEquals('Complete', step.CSPOFA__Status__c, 'Status should be complete');
		}
	}
	

}