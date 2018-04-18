@isTest
private class LG_OrchProcessTemplateTriggerHandlerTest {

	@testsetup
	private static void setupTestData()
	{
		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c      = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		Schema.DescribeFieldResult fieldResult = csord__Service__c.LG_DecompositionCriteria__c.getDescribe();

		List<CSPOFA__Orchestration_Process_Template__c> orcTemplates = new List<CSPOFA__Orchestration_Process_Template__c>();

		for (Schema.PicklistEntry ple : fieldResult.getPicklistValues()) {
			orcTemplates.add(new CSPOFA__Orchestration_Process_Template__c(LG_DecompositionCriteria__c = ple.getValue()));
		}

		insert orcTemplates;

		noTriggers.Flag__c = false;
		upsert noTriggers;
	}

	private static testmethod void testCheckDecompositionCriteria()
	{
		Schema.DescribeFieldResult fieldResult =
			csord__Service__c.LG_DecompositionCriteria__c.getDescribe();

		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		String decCrit1 = ple[0].getValue();

		List<CSPOFA__Orchestration_Process_Template__c> orcTemplates = new List<CSPOFA__Orchestration_Process_Template__c>();
		orcTemplates.add(new CSPOFA__Orchestration_Process_Template__c(LG_DecompositionCriteria__c = decCrit1));
		orcTemplates.add(new CSPOFA__Orchestration_Process_Template__c());

		Test.startTest();
		try {
			insert new CSPOFA__Orchestration_Process_Template__c(LG_DecompositionCriteria__c = decCrit1);
		}
		catch (Exception e) {
			System.assertEquals(true, e.getMessage().contains(Label.LG_OrchProcessDecCriteriaError.split('}')[1]),
								'Field validation exception should have been thrown');
		}

		insert new CSPOFA__Orchestration_Process_Template__c(Name = 'Inserted');
		Test.stopTest();

		CSPOFA__Orchestration_Process_Template__c template = [SELECT Id, Name FROM CSPOFA__Orchestration_Process_Template__c
															  WHERE LG_DecompositionCriteria__c = null];
		System.assertEquals('Inserted', template.Name, 'One template should have been inserted');
	}
}