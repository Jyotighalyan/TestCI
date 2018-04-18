@isTest
private class LG_InstallationInformationControllerTest {
	
	private static String vfBaseUrl = 'vforce.url';
	private static String sfdcBaseUrl = 'sfdc.url';
	private static Date wishDate = Date.newInstance(2016, 3, 20);
	private static Date plannedDate = Date.newInstance(2016, 3, 18);
	
	@testsetup
	private static void setupTestData()
	{
		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;
		
		LG_EnvironmentVariables__c envVariables = new LG_EnvironmentVariables__c();
		envVariables.LG_SalesforceBaseURL__c = sfdcBaseUrl;
		envVariables.LG_VisualForceBaseURL__c = vfBaseUrl;
		envVariables.LG_CloudSenceAnywhereIconID__c = 'csaID';
		envVariables.LG_ServiceAvailabilityIconID__c = 'saIconId';
		insert envVariables;
		
        csordtelcoa__Change_Types__c changeTypeDown = new csordtelcoa__Change_Types__c();
        changeTypeDown.csordtelcoa__Sort_Order__c = 0;
        changeTypeDown.Name                       = 'Migrate';
        changeTypeDown.LG_MigrateVariety__c       = true;
        insert changeTypeDown;
		Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);
				
		Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
		
		cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('BAsket58', account, null, opp, false);
		basket.csbb__Account__c = account.Id;
		insert basket;
		
		cscfga__Product_Definition__c prodDef = LG_GeneralTest.createProductDefinition('ProdDef58', true);
		
		List<cscrm__Address__c> addresses = new List<cscrm__Address__c>();
		cscrm__Address__c addressOne = new cscrm__Address__c(Name='AddressOne');
		cscrm__Address__c addressTwo = new cscrm__Address__c(Name='AddressTwo');
		addresses.add(addressOne);
		addresses.add(addressTwo);
		insert addresses;
				
		List<cscfga__Product_Configuration__c> prodConfs = new List<cscfga__Product_Configuration__c>();
		cscfga__Product_Configuration__c prodConf = LG_GeneralTest.createProductConfiguration('ProdConf58', 3, basket, prodDef, false);
		prodConf.LG_Address__c = addressOne.Id;
		prodConf.LG_InstallationWishDate__c = Date.today();
		prodConf.LG_InstallationClass__c = 'InstallClass';
		prodConf.LG_InstallationLeadTime__c = 8;
		prodConf.LG_InstallationNeeded__c = true;
		prodConf.cscfga__Product_Family__c = 'Company Fiber';
		
		cscfga__Product_Configuration__c prodConf1 = LG_GeneralTest.createProductConfiguration('ProdConf581', 3, basket, prodDef, false);
		prodConf1.LG_Address__c = addressOne.Id;
		prodConf1.LG_InstallationClass__c = 'InstallClass';
		prodConf1.LG_InstallationLeadTime__c = 3;
		prodConf1.LG_InstallationNeeded__c = true;
		prodConf1.cscfga__Product_Family__c = 'Company Internet';
		
		cscfga__Product_Configuration__c prodConf2 = LG_GeneralTest.createProductConfiguration('ProdConf582', 3, basket, prodDef, false);
		prodConf2.LG_Address__c = addressTwo.Id;
		prodConf2.LG_InstallationClass__c = 'InstallClass';
		prodConf2.LG_InstallationLeadTime__c = 8;
		prodConf2.LG_InstallationNeeded__c = true;
		prodConf2.cscfga__Product_Family__c = 'Office Internet';
		
		cscfga__Product_Configuration__c prodConf3 = LG_GeneralTest.createProductConfiguration('ProdConf5823', 3, basket, prodDef, false);
		prodConf3.LG_Address__c = addressTwo.Id;
		prodConf3.cscfga__Product_Family__c = 'Company Voice';
		
		prodConfs.add(prodConf);
		prodConfs.add(prodConf1);
		prodConfs.add(prodConf2);
		prodConfs.add(prodConf3);
		insert prodConfs;
		
		cscfga__Attribute_Definition__c attDef = LG_GeneralTest.createAttributeDefinition('AttDef', prodDef, 'User Input', 'String',
			null, null, null, true);
			
		LG_GeneralTest.createAttribute('Installation Planned Date', attDef, false, null, prodConf, false, null, true);
		LG_GeneralTest.createAttribute('Installation Wish Date', attDef, false, null, prodConf, false, null, true);
		
		noTriggers.Flag__c = false;
		upsert noTriggers;
	}
	
	private static testmethod void testRedirectToReturnId()
	{
		cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'BAsket58'];
		Account account = [SELECT Id FROM Account WHERE Name = 'Account'];
		
		PageReference pageRef = Page.LG_PortingNumbers;
		pageRef.getParameters().put('basketId', basket.Id);
		pageRef.getParameters().put('returnId', account.Id);
		Test.setCurrentPageReference(pageRef);
		
		Test.startTest();
		
			LG_InstallationInformationController controller = new LG_InstallationInformationController();
			pageRef = controller.redirectToReturnId();
			
		Test.stopTest();
		
		System.assertEquals( sfdcBaseUrl+ '/' + account.Id, pageRef.getUrl(),
							'Url should be ' + sfdcBaseUrl + '/' + account.Id);	
	}
	
	private static testmethod void testSave()
	{
		cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'BAsket58'];
		List<cscrm__Address__c> addresses = [SELECT Id, Name, LG_COAXConnectionLocation__c, LG_SharedOfficeBuilding__c
												FROM cscrm__Address__c  WHERE Name = 'AddressOne' OR Name = 'AddressTwo'];
		
		cscrm__Address__c addressOne;
		cscrm__Address__c addressTwo;
		
		for(cscrm__Address__c address : addresses)
		{
			if (address.Name.equals('AddressOne'))
			{
				addressOne = address;
			}
			else
			{
				addressTwo = address;
			}
			System.assertEquals(false, address.LG_SharedOfficeBuilding__c, 'Shared office Building flag should be false by default');
			System.assertEquals(true, String.isBlank(address.LG_COAXConnectionLocation__c), 'Coax location should be blank by default');
		}									
		
		PageReference pageRef = Page.LG_PortingNumbers;
		pageRef.getParameters().put('basketId', basket.Id);
		Test.setCurrentPageReference(pageRef);
		
		Test.startTest();
		
			LG_InstallationInformationController controller = new LG_InstallationInformationController();
			controller.siteIdToPlannedDates = addressOne.Id + '~18-03-2016';
			controller.siteIdToWishDates = addressOne.Id + '~20-03-2016';
			
			for(cscrm__Address__c address : controller.sites)
			{
				if (address.Id.equals(addressOne.Id))
				{
					address.LG_SharedOfficeBuilding__c = true;
					address.LG_COAXConnectionLocation__c = 'TestCoaxLocation';
				}
				else
				{
					address.LG_SharedOfficeBuilding__c = false;
					address.LG_COAXConnectionLocation__c = 'CoaxTwoLocation';
				}
			}
			pageRef = controller.save();
			
		Test.stopTest();
		
		addresses = [SELECT Id, Name, LG_COAXConnectionLocation__c, LG_SharedOfficeBuilding__c
						FROM cscrm__Address__c WHERE Name = 'AddressOne' OR Name = 'AddressOne'];
												
		for(cscrm__Address__c address : addresses)
		{
			if (address.Name.equals('AddressOne'))
			{
				System.assertEquals(true, address.LG_SharedOfficeBuilding__c, 'Shared office Building flag should be true for AddressOne');
				System.assertEquals('TestCoaxLocation', address.LG_COAXConnectionLocation__c, 'Coax location should be TestCoaxLocation for AddressOne');
			}
			else
			{
				System.assertEquals(false, address.LG_SharedOfficeBuilding__c, 'Shared office Building flag should be false for AddressTwo');
				System.assertEquals('CoaxTwoLocation', address.LG_COAXConnectionLocation__c, 'Coax location should be CoaxTwoLocation for AddressTwo');
			}
		}
		
		//check that wish and planned dates were setup
		List<cscfga__Product_Configuration__c> prodConfs = [SELECT Id, LG_InstallationWishDate__c, LG_InstallationPlannedDate__c,
																(SELECT Name, cscfga__Value__c, cscfga__Display_Value__c
																	FROM cscfga__Attributes__r
																	WHERE Name IN ('Installation Planned Date', 'Installation Wish Date')
																)
															FROM cscfga__Product_Configuration__c
															WHERE Name IN ('ProdConf58', 'ProdConf581')];

		for(cscfga__Product_Configuration__c prodConf : prodConfs)
		{
			System.assertEquals(wishDate, prodConf.LG_InstallationWishDate__c, 'Installation Wish Date should be 20/03/2016');
			System.assertEquals(plannedDate, prodConf.LG_InstallationPlannedDate__c, 'Installation Wish Date should be 20/03/2016');
			
			for(cscfga__Attribute__c att : prodConf.cscfga__Attributes__r)
			{
				if (att.Name.equals('Installation Wish Date'))
				{
					System.assertEquals('2016-3-20', att.cscfga__Value__c, 'Value should be 2016-3-20');
					System.assertEquals('20-3-2016', att.cscfga__Display_Value__c, 'Display Value should be 20-3-2016');
				}
				else if (att.Name.equals('Installation Planned Date'))
				{
					System.assertEquals('2016-3-18', att.cscfga__Value__c, 'Value should be 2016-3-18');
					System.assertEquals('18-3-2016', att.cscfga__Display_Value__c, 'Display Value should be 18-3-2016');
				}
			}
		}
	}
	
	private static testmethod void testSaveForMigrate()
	{
		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c = true;
		upsert noTriggers;
		
		cscfga__Product_Basket__c basket = [SELECT Id, csbb__Account__c FROM cscfga__Product_Basket__c WHERE Name = 'BAsket58'];
		basket.csordtelcoa__Change_Type__c = 'Migrate';
		update basket;
		
		List<cscrm__Address__c> addresses = [SELECT Id, Name, LG_COAXConnectionLocation__c, LG_SharedOfficeBuilding__c
												FROM cscrm__Address__c  WHERE Name = 'AddressOne' OR Name = 'AddressTwo'];
		
		cscrm__Address__c addressOne;
		cscrm__Address__c addressTwo;
		
		for(cscrm__Address__c address : addresses)
		{
			if (address.Name.equals('AddressOne'))
			{
				addressOne = address;
			}
			else
			{
				addressTwo = address;
			}
			System.assertEquals(false, address.LG_SharedOfficeBuilding__c, 'Shared office Building flag should be false by default');
			System.assertEquals(true, String.isBlank(address.LG_COAXConnectionLocation__c), 'Coax location should be blank by default');
		}	
		
		csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
		insert coreq;
		
		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = coreq.Id, Name = 'Product1',
																csord__Account__c = basket.csbb__Account__c, LG_Address__c = addressOne.Id, csordtelcoa__Closed_Replaced__c = false);
		csord__Subscription__c sub2 = new csord__Subscription__c(csord__Identification__c = 'TestIdent2', csord__Order_Request__c = coreq.Id, Name = 'Product2',
																csord__Account__c = basket.csbb__Account__c, LG_Address__c = addressOne.Id, csordtelcoa__Closed_Replaced__c = false);
		insert sub;
		insert sub2;
		
		List<csordtelcoa__Subscr_MACDProductBasket_Association__c> subBasketRelations 
																	= new List<csordtelcoa__Subscr_MACDProductBasket_Association__c>();
		subBasketRelations.add(new csordtelcoa__Subscr_MACDProductBasket_Association__c(csordtelcoa__Subscription__c = sub.Id,
																							csordtelcoa__Product_Basket__c = basket.Id));
		subBasketRelations.add(new csordtelcoa__Subscr_MACDProductBasket_Association__c(csordtelcoa__Subscription__c = sub2.Id,
																							csordtelcoa__Product_Basket__c = basket.Id));
		insert subBasketRelations;
		
		noTriggers.Flag__c = false;
		upsert noTriggers;			
		
		PageReference pageRef = Page.LG_PortingNumbers;
		pageRef.getParameters().put('basketId', basket.Id);
		Test.setCurrentPageReference(pageRef);
		
		Test.startTest();
		
			LG_InstallationInformationController controller = new LG_InstallationInformationController();
			controller.siteIdToPlannedDates = addressOne.Id + '~18-03-2016';
			controller.siteIdToWishDates = addressOne.Id + '~20-03-2016';
			
			for(cscrm__Address__c address : controller.sites)
			{
				if (address.Id.equals(addressOne.Id))
				{
					address.LG_SharedOfficeBuilding__c = true;
					address.LG_COAXConnectionLocation__c = 'TestCoaxLocation';
				}
				else
				{
					address.LG_SharedOfficeBuilding__c = false;
					address.LG_COAXConnectionLocation__c = 'CoaxTwoLocation';
				}
			}
			pageRef = controller.save();
			
		Test.stopTest();
		
		addresses = [SELECT Id, Name, LG_COAXConnectionLocation__c, LG_SharedOfficeBuilding__c
						FROM cscrm__Address__c WHERE Name = 'AddressOne' OR Name = 'AddressOne'];
												
		for(cscrm__Address__c address : addresses)
		{
			if (address.Name.equals('AddressOne'))
			{
				System.assertEquals(true, address.LG_SharedOfficeBuilding__c, 'Shared office Building flag should be true for AddressOne');
				System.assertEquals('TestCoaxLocation', address.LG_COAXConnectionLocation__c, 'Coax location should be TestCoaxLocation for AddressOne');
			}
			else
			{
				System.assertEquals(false, address.LG_SharedOfficeBuilding__c, 'Shared office Building flag should be false for AddressTwo');
				System.assertEquals('CoaxTwoLocation', address.LG_COAXConnectionLocation__c, 'Coax location should be CoaxTwoLocation for AddressTwo');
			}
		}
		
		//check that wish and planned dates were setup
		List<cscfga__Product_Configuration__c> prodConfs = [SELECT Id, LG_InstallationWishDate__c, LG_InstallationPlannedDate__c,
																(SELECT Name, cscfga__Value__c, cscfga__Display_Value__c
																	FROM cscfga__Attributes__r
																	WHERE Name IN ('Installation Planned Date', 'Installation Wish Date')
																)
															FROM cscfga__Product_Configuration__c
															WHERE Name IN ('ProdConf58', 'ProdConf581')];

		for(cscfga__Product_Configuration__c prodConf : prodConfs)
		{
			System.assertEquals(wishDate, prodConf.LG_InstallationWishDate__c, 'Installation Wish Date should be 20/03/2016');
			System.assertEquals(plannedDate, prodConf.LG_InstallationPlannedDate__c, 'Installation Wish Date should be 20/03/2016');
			
			for(cscfga__Attribute__c att : prodConf.cscfga__Attributes__r)
			{
				if (att.Name.equals('Installation Wish Date'))
				{
					System.assertEquals('2016-3-20', att.cscfga__Value__c, 'Value should be 2016-3-20');
					System.assertEquals('20-3-2016', att.cscfga__Display_Value__c, 'Display Value should be 20-3-2016');
				}
				else if (att.Name.equals('Installation Planned Date'))
				{
					System.assertEquals('2016-3-18', att.cscfga__Value__c, 'Value should be 2016-3-18');
					System.assertEquals('18-3-2016', att.cscfga__Display_Value__c, 'Display Value should be 18-3-2016');
				}
			}
		}
		
		List<csordtelcoa__Subscr_MACDProductBasket_Association__c> subBasketJuncs = [SELECT LG_DeactivationWishDate__c
																					FROM csordtelcoa__Subscr_MACDProductBasket_Association__c
																					WHERE csordtelcoa__Product_Basket__c = :basket.Id];
		for(csordtelcoa__Subscr_MACDProductBasket_Association__c subBasketJunc : subBasketJuncs)
		{
			//System.assertEquals(wishDate, subBasketJunc.LG_DeactivationWishDate__c, 'Deactivation wish date should be 20/3/2016');
		}
	}
	
	private static testmethod void testCreateNewContact()
	{
		cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'BAsket58'];
		Account account = [SELECT Id, Name FROM Account WHERE Name = 'Account'];
		PageReference pageRef = Page.LG_SeparateInvoices;
		pageRef.getParameters().put('basketId',basket.Id);
		Test.setCurrentPageReference(pageRef);
				
		Test.startTest();
		
			LG_InstallationInformationController controller = new LG_InstallationInformationController();
			pageRef = controller.createNewContact();
			
		Test.stopTest();
		
		System.assertEquals('/'+Contact.getSObjectType().getDescribe().getKeyPrefix() + '/e?'
								+ 'retURL=%2Fapex%2FLG_InstallationInformation%3FbasketId%3D' + basket.Id
								+ '&saveURL=%2Fapex%2FLG_InstallationInformation%3FbasketId%3D' + basket.Id 
								+ '&testId=' + account.Name + '&testId_lkid='+account.Id , pageRef.getUrl(),
							'Url should be ' + Contact.getSObjectType().getDescribe().getKeyPrefix() + '/e?'
												+ '&saveURL=/apex/LG_InstallationInformation?basketId=' + basket.Id 
													+'&testId=&' + account.Name + '&testId_lkid='+account.Id+
													+ '&retURL=/apex/LG_InstallationInformation?basketId=' + basket.Id);	
	}
}