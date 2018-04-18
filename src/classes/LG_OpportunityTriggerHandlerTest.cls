@isTest
private class LG_OpportunityTriggerHandlerTest {

	private static Date someDate = Date.newInstance(1960, 2, 17);

	@testsetup
	private static void setupTestData()
	{
		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

        csordtelcoa__Change_Types__c changeTypeDown = new csordtelcoa__Change_Types__c();
        changeTypeDown.csordtelcoa__Sort_Order__c = 0;
        changeTypeDown.Name                       = 'Migrate';
        changeTypeDown.LG_MigrateVariety__c       = true;
        insert changeTypeDown;

		Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'New Accoun 1', true);

		Opportunity opp = LG_GeneralTest.CreateOpportunity(account, false);
		insert opp;

		cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Basket', account, null, opp, false);
		basket.csordtelcoa__Synchronised_with_Opportunity__c = true;
		basket.csordtelcoa__Change_Type__c = 'Migrate';
		insert basket;

		cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('Test Category', true);

		cscfga__Product_Definition__c prodDef = LG_GeneralTest.createProductDefinition('Phone Numbers', false);

		prodDef.cscfga__Product_Category__c = prodCategory.Id;
		insert prodDef;

		cscrm__Address__c address = new cscrm__Address__c(cscrm__Street__c = 'TestStreet');
		insert address;

		csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
		insert coreq;

		csconta__Billing_Account__c bAcc= new csconta__Billing_Account__c(csconta__Account__c= account.ID, csconta__Status__c='New', LG_ContractualOrganization__c='Hessen (HSN)', csconta__Billing_Channel__c='Paper', UM_BillFormatOptions__c='Summary');
    	insert bAcc;
        
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = coreq.Id,csconta__Billing_Account__c= bAcc.id);
		insert sub;

        csord__Subscription__c sub2 = new csord__Subscription__c(csord__Identification__c = 'TestIdent2', csord__Order_Request__c = coreq.Id,csconta__Billing_Account__c= bAcc.id);
		insert sub2;

		csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestService', csord__Subscription__c = sub.Id, csord__Order_Request__c = coreq.Id,LG_ProductFamily__c='SOHO');
		service.LG_Address__c = address.Id;
		insert service;

        csord__Service_Line_Item__c serviceLineItem = new csord__Service_Line_Item__c(Name = 'Service Line Item', csord__Service__c = service.Id, csord__Identification__c = '123456789321');
        insert serviceLineItem;

		csord__Service__c service2 = new csord__Service__c(csord__Identification__c = 'TestService2', csord__Subscription__c = sub2.Id, csord__Order_Request__c = coreq.Id);
		service2.LG_Address__c = address.Id;
		service2.LG_ProductFamily__c = 'SOHO';
		insert service2;

		insert new csordtelcoa__Subscr_MACDProductBasket_Association__c(csordtelcoa__Subscription__c = sub.Id,
																						csordtelcoa__Product_Basket__c = basket.Id, LG_DeactivationWishDate__c = someDate);

		insert new csordtelcoa__Subscription_MACDOpportunity_Association__c(csordtelcoa__Subscription__c = sub.Id, csordtelcoa__Opportunity__c = opp.Id);
		insert new csordtelcoa__Subscription_MACDOpportunity_Association__c(csordtelcoa__Subscription__c = sub2.Id, csordtelcoa__Opportunity__c = opp.Id);

		cscfga__Product_Configuration__c pc = LG_GeneralTest.createProductConfiguration('TestConf', 12, basket, prodDef, false);
		pc.csordtelcoa__Replaced_Subscription__c = sub.Id;
		insert pc;

        csordtelcoa__Orders_Subscriptions_Options__c osOptions = new csordtelcoa__Orders_Subscriptions_Options__c();
        osOptions.LG_ServiceRequestDeactivateStatus__c = 'Service Termination Requested';
		osOptions.LG_SubscriptionRequestDeactivateStatus__c = 'Subscription Termination Requested';
		insert osOptions;

		noTriggers.Flag__c = false;
		upsert noTriggers;
	}

	private static testmethod void testDeactivateSubscriptionServices()
	{
		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		Account account = [SELECT Id FROM Account WHERE Name = 'Account'];
		Opportunity opp = [SELECT Id, csordtelcoa__Change_Type__c FROM Opportunity WHERE AccountId = :account.Id];
		cscfga__Product_Basket__c basket = [SELECT Id, csordtelcoa__Change_Type__c FROM cscfga__Product_Basket__c WHERE Name = 'Basket'];
		opp.csordtelcoa__Change_Type__c = 'Migrate';
		update opp;

		noTriggers.Flag__c = false;
		upsert noTriggers;
		csordtelcoa__Orders_Subscriptions_Options__c cs = csordtelcoa__Orders_Subscriptions_Options__c.getInstance();
		Opp.stageName = cs.csordtelcoa__Opportunity_Stages_creating_orders__c;

		List<Opportunity> opps = new List<Opportunity>();
		opps.add(opp);

		Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>();
		oldMap.put(opp.Id, new Opportunity(StageName = ''));

		Test.startTest();
			LG_OpportunityTriggerHandler.deactivateSubscriptionServices(opps, oldMap);
		Test.stopTest();

		csord__Subscription__c sub = [SELECT csord__Status__c FROM csord__Subscription__c WHERE csord__Identification__c = 'TestIdent'];
		System.assertEquals(LG_Util.getSubscriptionRequestDeactivateStatus(), sub.csord__Status__c, 'Status should be ' + LG_Util.getSubscriptionRequestDeactivateStatus());

		csord__Service__c service = [SELECT csord__Status__c FROM csord__Service__c WHERE csord__Identification__c = 'TestService'];
		System.assertEquals(LG_Util.getServiceRequestDeactivateStatus(), service.csord__Status__c, 'Status should be ' + LG_Util.getServiceRequestDeactivateStatus());

		/**
		 * Set delta status to deleted
		 *
		 * @author Petar Miletic
		 * @ticket SFOM-648
		 * @since  20/04/2017
		 */
		csord__Service_Line_Item__c sli = [SELECT Id, csordtelcoa__Delta_Status__c FROM csord__Service_Line_Item__c WHERE csord__Identification__c = '123456789321'];
		System.assertEquals('Deleted', sli.csordtelcoa__Delta_Status__c, 'Invalid data');
	}

	private static testmethod void testDeactivateSubscriptionServicesForTermination()
	{
		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		Account account = [SELECT Id FROM Account WHERE Name = 'Account'];
		Opportunity opp = [SELECT Id, csordtelcoa__Change_Type__c FROM Opportunity WHERE AccountId = :account.Id];
		cscfga__Product_Basket__c basket = [SELECT Id, csordtelcoa__Change_Type__c FROM cscfga__Product_Basket__c WHERE Name = 'Basket'];
		basket.csordtelcoa__Change_Type__c = 'Change';
		update basket;
		opp.csordtelcoa__Change_Type__c = 'Change';
		update opp;

		noTriggers.Flag__c = false;
		upsert noTriggers;

		opp.StageName = 'Ready for Order';
		List<Opportunity> opps = new List<Opportunity>();
		opps.add(opp);

		Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>();
		oldMap.put(opp.Id, new Opportunity(StageName = ''));

		Test.startTest();
			LG_OpportunityTriggerHandler.deactivateSubscriptionServicesForTermination(opps, oldMap);
		Test.stopTest();

		csord__Subscription__c sub = [SELECT csord__Status__c FROM csord__Subscription__c WHERE csord__Identification__c = 'TestIdent2'];
		System.assertEquals(LG_Util.getSubscriptionRequestDeactivateStatus(), sub.csord__Status__c, 'Status should be ' + LG_Util.getSubscriptionRequestDeactivateStatus());

		csord__Service__c service = [SELECT csord__Status__c FROM csord__Service__c WHERE csord__Identification__c = 'TestService2'];
		System.assertEquals(LG_Util.getServiceRequestDeactivateStatus(), service.csord__Status__c, 'Status should be ' + LG_Util.getServiceRequestDeactivateStatus());
	}

	private static testmethod void testDeactivateSubscriptionServicesNoOld()
	{
		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		Account account = [SELECT Id FROM Account WHERE Name = 'Account'];
		Opportunity opp = [SELECT Id, csordtelcoa__Change_Type__c FROM Opportunity WHERE AccountId = :account.Id];
		cscfga__Product_Basket__c basket = [SELECT Id, csordtelcoa__Change_Type__c FROM cscfga__Product_Basket__c WHERE Name = 'Basket'];
		basket.csordtelcoa__Change_Type__c = 'Migrate';
		update basket;

		opp.csordtelcoa__Change_Type__c = 'Migrate';
		update opp;

		noTriggers.Flag__c = false;
		upsert noTriggers;

		opp.StageName = 'Ready for Order';
		List<Opportunity> opps = new List<Opportunity>();
		opps.add(opp);

		Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>();
		//oldMap.put(opp.Id, new Opportunity(StageName = ''));

		Test.startTest();
			LG_OpportunityTriggerHandler.deactivateSubscriptionServices(opps, null);
		Test.stopTest();

		csord__Subscription__c sub = [SELECT csord__Status__c FROM csord__Subscription__c WHERE csord__Identification__c = 'TestIdent'];
		//System.assertEquals(LG_Util.getSubscriptionRequestDeactivateStatus(), sub.csord__Status__c, 'Status should be ' + LG_Util.getSubscriptionRequestDeactivateStatus());

		csord__Service__c service = [SELECT csord__Status__c FROM csord__Service__c WHERE csord__Identification__c = 'TestService'];
		//System.assertEquals(LG_Util.getServiceRequestDeactivateStatus(), service.csord__Status__c, 'Status should be ' + LG_Util.getServiceRequestDeactivateStatus());
	}
     private static testmethod void testUpload()
    {
        Account account1 = LG_GeneralTest.CreateAccount('Account1', '1234567', 'New Accoun 2', true);
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account1, false);

        Document d=new Document();
        //d.DeveloperName=LABEL.LG_LegalDocName;
        d.Body = Blob.valueOf('Some Text');
		d.ContentType = 'application/pdf';
		d.IsPublic = true;
		d.Name = LABEL.LG_LegalDocName;
		d.FolderId = [select id from folder where name = 'Shared Documents'][0].id;
        insert d;
        test.startTest();
		insert opp;
        test.stopTest();

    }
}