/*
 * Test class for LG_NotifyCancelOrderProcess

 @ Author : Shruthi Gopal
 @ Date   : 24/10/2017

 */
@isTest
public class LG_NotifyCancelOrderProcessTest {

	@testSetup
	private static void setupTestData() {

		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c      = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		csordtelcoa__Orders_Subscriptions_Options__c osOptions = new csordtelcoa__Orders_Subscriptions_Options__c();
		osOptions.LG_OrderPartiallyCompletedStatus__c = 'Some Suborders Completed';
		osOptions.LG_OrderCompleteStatus__c           = 'Completed';
		osOptions.LG_OrderCanceledStatus__c           = 'Canceled';
		insert osOptions;

		List<csord__Order__c> orders = new List<csord__Order__c>();

		orders.add(new csord__Order__c(Name = 'Test Order First', csord__Status2__c = 'In Provisioning', csord__Identification__c = '123456789'));
		orders.add(new csord__Order__c(Name = 'Test Order Second', csord__Status2__c = 'In Provisioning', csord__Identification__c = '123456799'));

		insert orders;

		List<csord__Solution__c> solutions = new List<csord__Solution__c>();

		for (Integer i = 0; i < 10; i++) {

			if (math.mod(i, 2) == 0) {
				solutions.add(new csord__Solution__c(Name = 'Test Solution First', csord__Order__c = orders[0].Id, csord__Status__c = 'New', csord__Identification__c = '333555888' + String.valueOf(i)));
			} else {
				solutions.add(new csord__Solution__c(Name = 'Test Solution Second', csord__Order__c = orders[1].Id, csord__Status__c = 'Complete', csord__Identification__c = '333555888' + String.valueOf(i)));
			}
		}

		insert solutions;

		solutions[0].csord__Status__c = 'Complete';
		update solutions[0];
        
		CSPOFA__Orchestration_Process_Template__c orcTemplate = new CSPOFA__Orchestration_Process_Template__c();
		insert orcTemplate;

		CSPOFA__Orchestration_Process__c process = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id, LG_Solution__c = solutions[0].Id);
		insert process;

		CSPOFA__Orchestration_Step__c step = new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = process.Id);
		insert step;

		CSPOFA__Orchestration_Process__c process2 = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id, LG_Solution__c = solutions[1].Id);
		insert process2;

		CSPOFA__Orchestration_Step__c step2 = new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = process2.Id);
		insert step2;

		noTriggers.Flag__c = false;
		upsert noTriggers;
	}

	@isTest
	private static void processTest() {

		List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c];

		for (SObject obj : steps) {

			CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
			System.assertNotEquals('Complete', step.CSPOFA__Status__c, 'Status should not be complete');
		}

		Test.startTest();

		LG_NotifyCancelOrderProcess notify = new LG_NotifyCancelOrderProcess();
		steps = notify.process(steps);

		Test.stopTest();

		for (SObject obj : steps) {

			CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
			System.assertEquals('Complete', step.CSPOFA__Status__c, 'Status should be complete');
		}
	}

	@IsTest
	public static void notifyOrderProcessTest() {

		Map<Id, CSPOFA__Orchestration_Process__c> processMap = new Map<Id, CSPOFA__Orchestration_Process__c>([SELECT Id FROM CSPOFA__Orchestration_Process__c]);

		csord__Order__c firstOrder  = [SELECT Id, csord__Status2__c FROM csord__Order__c WHERE Name = 'Test Order First' LIMIT 1];
		csord__Order__c secondOrder = [SELECT Id, csord__Status2__c FROM csord__Order__c WHERE Name = 'Test Order Second' LIMIT 1];

		Test.startTest();

		LG_NotifyCancelOrderProcess notify = new LG_NotifyCancelOrderProcess();
		notify.notifyOrderProcess(processMap.keySet());

		Test.stopTest();

		
		System.assertEquals('In Provisioning', firstOrder.csord__Status2__c, 'Invalid data');
		System.assertEquals('In Provisioning', secondOrder.csord__Status2__c, 'Invalid data');


		firstOrder  = [SELECT Id, csord__Status2__c FROM csord__Order__c WHERE Name = 'Test Order First' LIMIT 1];
		secondOrder = [SELECT Id, csord__Status2__c FROM csord__Order__c WHERE Name = 'Test Order Second' LIMIT 1];

	}
}