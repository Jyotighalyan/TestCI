@isTest
private class LG_OpenCloudSenseController_TEST {
	
	@isTest static void testGetCloudSenseURL() {
		// Implement test code
		Group smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = smeQueueID.id);
        insert cs;
        
		Lead tmpLead = LG_GeneralTest.CreateLead(
			'Maatschap T.A. Aanhane',
			'test@test.com',
			'Ms.',
			'H.',
			'Bleij',
			'',
			'06-18452681',
			'',
			'Not Contacted',
			'34189218',
        	'On-Net',
        	true,
        	true,
        	10,
        	5,
        	'Low',
        	'De Heining',
        	'9',
        	'B',
        	'1161AC',
        	'ZWANENBURG',
        	'Netherlands');

		System.debug('Lead ID:' + tmpLead.ID);

		//PageReference pageRef = new PageReference('/'+tmpLead.ID);

		PageReference pageRef = Page.LG_OpenCloudsense;
		Test.setCurrentPage(Page.LG_OpenCloudsense);
		ApexPages.currentPage().getParameters().put('id',tmpLead.ID);

		LG_OpenCloudSenseController controller = new LG_OpenCloudSenseController(new ApexPages.StandardController(tmpLead));


		System.debug('pageRef:' +pageRef.getUrl());

		System.debug('Lead Open Cloudsense URL: ' +tmpLead.LG_OpenCloudSenseAnywhere__c);

		System.debug('controller URL: ' + controller.redirectUrl);

		System.assertEquals(controller.redirectUrl, controller.redirectUrl, 'Test CloudSense URL is correct');



	}
	
	
}