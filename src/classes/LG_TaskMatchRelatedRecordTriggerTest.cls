@isTest
public class LG_TaskMatchRelatedRecordTriggerTest {

	public static testMethod void runTest() {
		/*
		Database.insert(prepareAccounts(), true);
		Database.insert(prepareLeads(), true);
		Test.startTest();
		Database.SaveResult[] results = Database.insert(prepareTasks(), false);
		System.debug('CPU time: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime());
		System.debug('SOQL: ' + Limits.getQueries() + '/' + Limits.getLimitQueries());
		System.debug('Query rows: ' + Limits.getQueryRows() + '/' + Limits.getLimitQueryRows());
		Test.stopTest();
		Integer failedCount = 0;
		for (Database.SaveResult result : results) {
			if (result.isSuccess() == false) {
				++failedCount;
			}
		}
		System.assertEquals(1, failedCount);
		Integer relatedToLeadCount = [select count() from Task t where t.WhoId != null];
		System.assertEquals(2000, relatedToLeadCount);
		Integer relatedToAccountCount = [select count() from Task t where t.WhatId != null];
		System.assertEquals(2000, relatedToAccountCount);
		*/
	}
	
	public static List<Account> prepareAccounts() {
		List<Account> accounts = new List<Account>();
		for (Integer i = 0; i < 2000; ++i) {
			String identifier = String.valueOf(i);
			accounts.add(new Account(Name = 'Test Account #' + identifier, LG_VisitCountry__c = 'Netherlands', LG_ChamberOfCommerceNumber__c = identifier.leftPad(8).replace(' ', '0'), LG_Footprint__c = 'UPC'));
		}
		return accounts;
	}
	
	public static List<Lead> prepareLeads() {
		List<Lead> leads = new List<Lead>();
		leads.add(new Lead(LastName = '1999', Status = 'Contacted', Company = 'Test Company #1999', LG_VisitCountry__c = 'Netherlands', LG_ChamberOfCommerceNumber__c = '00001999'));
		for (Integer i = 2000; i < 4000; ++i) {
			String identifier = String.valueOf(i);
			leads.add(new Lead(LastName = identifier, Status = 'Contacted', Company = 'Test Company #' + identifier, LG_VisitCountry__c = 'Netherlands', LG_ChamberOfCommerceNumber__c = identifier.leftPad(8).replace(' ', '0')));
		}
		return leads;
	}
	
	private static List<Task> prepareTasks() {
		List<Task> tasks = new List<Task>();
		for (Integer i = 0; i < 4000; ++i) {
 			tasks.add(new Task(Status = 'Completed', Priority = 'High', LG_RelatedExternalID__c = String.valueOf(i).leftPad(8).replace(' ', '0')));
		}
		tasks.add(new Task(Status = 'Completed', Priority = 'High'));
		tasks.add(new Task(Status = 'Completed', Priority = 'High', LG_RelatedExternalID__c = '9999999'));
		return tasks;
	}

}