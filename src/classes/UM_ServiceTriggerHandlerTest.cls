 /**
 * @author (s)      : David van 't Hooft
 * @requirement id  : UMR-499
 * @description     : Test the Numberblock inserts on providing a valid json
 * 					: Test the Opportunity set to ''Close Lost' if the last active product/services is also cancelled attached to this Opportunity
 *
 * @log:            : 10AUG2016 v1.0
 */
@isTest
private class UM_ServiceTriggerHandlerTest {

	/**
     * Test auto creation of the UM_NumberRangeService__c records on creating a Service with LG_ProductFamily__c = 'Number Range'
     */
    // static testMethod void inserNumberblockTest() {
	// 	// creating test account
	// 	Account a = new Account(name = 'Test1', LG_VisitCountry__c = 'Netherlands', LG_ChamberOfCommerceNumber__c = '03438493', LG_Footprint__c = 'UPC');
	// 	insert a;
    //
	// 	csord__Order_Request__c req = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
	// 	insert req;
    //
	// 	csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = req.Id, csord__Account__c = a.Id);
	// 	insert sub;
    //
	// 	cscrm__Address__c address = new cscrm__Address__c(cscrm__Street__c = 'TestStreet');
	// 	insert address;
    //
	// 	Test.startTest();
	// 	//Test insert
    // 	String numman = '{"UM_NumberBlockList": [{"UM_StartNumber__c":"222444400","UM_EndNumber__c":"222444409","UM_CDRIDNumber__c":"22244440","UM_AreaCode__c":"222","UM_BlockSize__c":"10"},{"UM_StartNumber__c":"222444410","UM_EndNumber__c":"222444419","UM_CDRIDNumber__c":"22244441","UM_AreaCode__c":"222","UM_BlockSize__c":"10"}]}';
	// 	csord__Service__c serv = new csord__Service__c(csord__Identification__c = 'TestIdentSub', csord__Order_Request__c = req.Id,
	// 														csord__Subscription__c = sub.Id, LG_Address__c = address.Id, LG_ProductFamily__c = 'Number Range', UM_NumberManagement__c = numman);
	// 	insert serv;
    //
	// 	// Test number and content of created number blocks
    // 	List<UM_NumberBlock__c> nbList = [select Id, UM_StartNumber__c, UM_EndNumber__c, UM_CDRIDNumber__c, UM_AreaCode__c, UM_BlockSize__c, UM_Account__c, UM_ProductConfiguration__c, UM_NumberRangeService__c, UM_VoiceService__c from UM_NumberBlock__c where UM_NumberRangeService__c = :serv.Id];
	// 	System.assertEquals(2, nbList.size(), '2 UM_NumberBlock__c records should have bean created!');
	// 	System.assertEquals('22244440', nbList[0].UM_CDRIDNumber__c, 'UM_CDRIDNumber__c should contain the json data!');
	// 	System.assertEquals(serv.Id, nbList[0].UM_NumberRangeService__c, 'Service Id should be filled in!');
	// 	System.assertEquals('22244441', nbList[1].UM_CDRIDNumber__c, 'UM_CDRIDNumber__c should contain the json data!');
	// 	System.assertEquals(serv.Id, nbList[1].UM_NumberRangeService__c, 'Service Id should be filled in!');
    //
	// 	//Test update
	// 	numman = '{"UM_NumberBlockList": [{"UM_StartNumber__c":"222444410","UM_EndNumber__c":"222444419","UM_CDRIDNumber__c":"22244441","UM_AreaCode__c":"222","UM_BlockSize__c":"10"}]}';
	// 	serv.UM_NumberManagement__c = numman;
	// 	update serv;
	// 	Test.stopTest();
    //
	// 	// Test number and content of created number blocks
    // 	nbList = [select Id, UM_StartNumber__c, UM_EndNumber__c, UM_CDRIDNumber__c, UM_AreaCode__c, UM_BlockSize__c, UM_Account__c, UM_ProductConfiguration__c, UM_NumberRangeService__c, UM_VoiceService__c from UM_NumberBlock__c where UM_NumberRangeService__c = :serv.Id];
	// 	System.assertEquals(1, nbList.size(), '1 UM_NumberBlock__c records should have bean created!');
	// 	System.assertEquals('22244441', nbList[0].UM_CDRIDNumber__c, 'UM_CDRIDNumber__c should contain the json data!');
    // }

	/**
	 * If a service status changes to 'Service Cancelled' then get the Opportunity reference via the order and check all
	 * services for that order if they also have the service status 'Service Cancelled'. If so set the stage to 'Closed Lost' and
	 * probability to 0% and Loss_Reason__c to 'Pre-installation cancellation (PIC)'
	 * check if Opportunity gets updated correctly
     */
    static testMethod void checkCancelOpportunityTest() {
		// creating test account
		Account a = new Account(name = 'Test1', LG_VisitCountry__c = 'Netherlands', LG_ChamberOfCommerceNumber__c = '03438493', LG_Footprint__c = 'UPC');
		insert a;

        Opportunity tmpOpportunity = new Opportunity(Name = 'Test', AccountId=a.Id, StageName = 'Awareness of interest', CloseDate=Date.today()+5);
        insert tmpOpportunity;

		csord__Order_Request__c req = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
		insert req;

        csord__Order__c o = new csord__Order__c();
        o.Name = 'Test Order';
        o.csord__Account__c = a.Id;
        o.csord__Status2__c = 'Order Submitted';
        o.csord__Order_Request__c = req.Id;
        o.csord__Identification__c = 'DWHTestBatchOn_' + system.now();
        o.csordtelcoa__Opportunity__c=tmpOpportunity.Id;
        insert o;

		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = req.Id, csord__Account__c = a.Id);
		insert sub;

		cscrm__Address__c address = new cscrm__Address__c(cscrm__Street__c = 'TestStreet');
		insert address;

		Test.startTest();
		//Test insert
		list<csord__Service__c> serviceList = new List<csord__Service__c>();
    	String numman = '{"UM_NumberBlockList": [{"UM_StartNumber__c":"222444400","UM_EndNumber__c":"222444409","UM_CDRIDNumber__c":"22244440","UM_AreaCode__c":"222","UM_BlockSize__c":"10"},{"UM_StartNumber__c":"222444410","UM_EndNumber__c":"222444419","UM_CDRIDNumber__c":"22244441","UM_AreaCode__c":"222","UM_BlockSize__c":"10"}]}';
		serviceList.add(new csord__Service__c(csord__Identification__c = 'TestIdentSub1', csord__Order_Request__c = req.Id, LG_ServiceStatus__c = 'Requested', LG_RootOrder__c = o.Id,
															csord__Subscription__c = sub.Id, LG_Address__c = address.Id, LG_ProductFamily__c = 'Number Range', UM_NumberManagement__c = numman));
		numman = '{"UM_NumberBlockList": [{"UM_StartNumber__c":"222444410","UM_EndNumber__c":"222444419","UM_CDRIDNumber__c":"22244441","UM_AreaCode__c":"222","UM_BlockSize__c":"10"}]}';
		serviceList.add(new csord__Service__c(csord__Identification__c = 'TestIdentSub2', csord__Order_Request__c = req.Id, LG_ServiceStatus__c = 'Requested', LG_RootOrder__c = o.Id,
															csord__Subscription__c = sub.Id, LG_Address__c = address.Id, LG_ProductFamily__c = 'Number Range', UM_NumberManagement__c = numman));
		insert serviceList;

		serviceList[0].LG_ServiceStatus__c = 'Cancelled';
		serviceList[0].UM_PICReason__c = 'Customer cannot pay';
		update serviceList;
		tmpOpportunity = [select StageName, Probability, Loss_Reason__c from Opportunity where Id = :tmpOpportunity.Id];
		System.assertNotEquals('Closed Lost', tmpOpportunity.StageName, 'Stage name should not be changed!');

		serviceList[1].LG_ServiceStatus__c = 'Cancelled';
		serviceList[1].UM_PICReason__c = 'Customer cannot pay';
		update serviceList;
		tmpOpportunity = [select StageName, Probability, Loss_Reason__c from Opportunity where Id = :tmpOpportunity.Id];
		System.assertEquals('Closed Lost', tmpOpportunity.StageName, 'Stage name should be changed!');
		System.assertEquals(0, tmpOpportunity.Probability, 'probability should be set to 0!');
		System.assertEquals('Pre-installation cancellation (PIC)', tmpOpportunity.Loss_Reason__c, 'Loss reason incorrect!');

		// test send email
		serviceList[1].LG_ProductFamily__c = 'Company Fiber';
		serviceList[1].LG_ServiceStatus__c = 'Ready for Billing';
		serviceList[1].UM_PICReason__c = '';
		serviceList[1].csord__Activation_Date__c = Date.Today();
		update serviceList;

		Test.stopTest();
    }

	/**
     * Test replacement of the product configuration from the new service
     */
    static testMethod void checkReplacementServiceOnCreateTest() {
    	/**
		// creating test account
		Account a = new Account(name = 'Test1', LG_VisitCountry__c = 'Netherlands', LG_ChamberOfCommerceNumber__c = '03438493', LG_Footprint__c = 'UPC');
		insert a;

		csord__Order_Request__c req = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
		insert req;

		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = req.Id, csord__Account__c = a.Id);
		insert sub;

		cscrm__Address__c address = new cscrm__Address__c(cscrm__Street__c = 'TestStreet');
		insert address;

		Test.startTest();
		//Test insert
    	String numman = '{"UM_NumberBlockList": [{"UM_StartNumber__c":"222444400","UM_EndNumber__c":"222444409","UM_CDRIDNumber__c":"22244440","UM_AreaCode__c":"222","UM_BlockSize__c":"10"},{"UM_StartNumber__c":"222444410","UM_EndNumber__c":"222444419","UM_CDRIDNumber__c":"22244441","UM_AreaCode__c":"222","UM_BlockSize__c":"10"}]}';
		csord__Service__c serv = new csord__Service__c(csord__Identification__c = 'TestIdentSub', csord__Order_Request__c = req.Id,
															csord__Subscription__c = sub.Id, LG_Address__c = address.Id, LG_ProductFamily__c = 'Number Range', UM_NumberManagement__c = numman);
		insert serv;

		// Test number and content of created number blocks
    	List<UM_NumberBlock__c> nbList = [select Id, UM_StartNumber__c, UM_EndNumber__c, UM_CDRIDNumber__c, UM_AreaCode__c, UM_BlockSize__c, UM_Account__c, UM_ProductConfiguration__c, UM_NumberRangeService__c, UM_VoiceService__c from UM_NumberBlock__c where UM_NumberRangeService__c = :serv.Id];
		System.assertEquals(2, nbList.size(), '2 UM_NumberBlock__c records should have bean created!');
		System.assertEquals('22244440', nbList[0].UM_CDRIDNumber__c, 'UM_CDRIDNumber__c should contain the json data!');
		System.assertEquals(serv.Id, nbList[0].UM_NumberRangeService__c, 'Service Id should be filled in!');
		System.assertEquals('22244441', nbList[1].UM_CDRIDNumber__c, 'UM_CDRIDNumber__c should contain the json data!');
		System.assertEquals(serv.Id, nbList[1].UM_NumberRangeService__c, 'Service Id should be filled in!');

		//Test update
		numman = '{"UM_NumberBlockList": [{"UM_StartNumber__c":"222444410","UM_EndNumber__c":"222444419","UM_CDRIDNumber__c":"22244441","UM_AreaCode__c":"222","UM_BlockSize__c":"10"}]}';
		serv.UM_NumberManagement__c = numman;
		update serv;
		Test.stopTest();

		// Test number and content of created number blocks
    	nbList = [select Id, UM_StartNumber__c, UM_EndNumber__c, UM_CDRIDNumber__c, UM_AreaCode__c, UM_BlockSize__c, UM_Account__c, UM_ProductConfiguration__c, UM_NumberRangeService__c, UM_VoiceService__c from UM_NumberBlock__c where UM_NumberRangeService__c = :serv.Id];
		System.assertEquals(1, nbList.size(), '1 UM_NumberBlock__c records should have bean created!');
		System.assertEquals('22244441', nbList[0].UM_CDRIDNumber__c, 'UM_CDRIDNumber__c should contain the json data!');
		**/
    }
}