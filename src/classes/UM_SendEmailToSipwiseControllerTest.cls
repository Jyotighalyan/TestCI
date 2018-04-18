@IsTest
public class UM_SendEmailToSipwiseControllerTest {

    @testsetup
    private static void setupTestData()
    {
        
        Group smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = smeQueueID.id);
        insert cs;

        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

		    cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('TestCategory', true);

        //generate Product Definition
        cscfga__Product_Definition__c tmpProductDefinition = LG_GeneralTest.createProductDefinition('ZZP Internet', false);
        tmpProductDefinition.cscfga__Product_Category__c = prodCategory.Id;
        insert tmpProductDefinition;

        Lead tmpLead = LG_GeneralTest.CreateLead('Maatschap T.A. Aanhane', 'test@test.com', 'Ms.', 'H.', 'Bleij', '', '06-18452681', '', 'Not Contacted', '34189218', 'On-Net', true, true, 10, 5, 'Low', 'De Heining', '9', 'B', '1161AC', 'ZWANENBURG', 'Netherlands');

    		cscfga__Product_Basket__c tmpProductBasket = LG_GeneralTest.createProductBasket('Test Basket Lead', null, tmpLead, null);
    		cscfga__Product_Configuration__c pcInternet = LG_GeneralTest.createProductConfiguration('ZZP Internet', 24, tmpProductBasket, tmpProductDefinition);

        cscfga__Attribute_Definition__c def1 = LG_GeneralTest.createAttributeDefinition('Voice Interface', tmpProductDefinition, '', 'String', '', '', '');
        cscfga__Attribute_Definition__c def2 = LG_GeneralTest.createAttributeDefinition('Number Of Interfaces', tmpProductDefinition, '', 'String', '', '', '');
        cscfga__Attribute_Definition__c def3 = LG_GeneralTest.createAttributeDefinition('IP PBX Type', tmpProductDefinition, '', 'String', '', '', '');
        cscfga__Attribute_Definition__c def4 = LG_GeneralTest.createAttributeDefinition('Subscriber to ISDN interface', tmpProductDefinition, '', 'String', '', '', '');
        cscfga__Attribute_Definition__c def5 = LG_GeneralTest.createAttributeDefinition('Call Barring Level', tmpProductDefinition, '', 'String', '', '', '');
        cscfga__Attribute_Definition__c def6 = LG_GeneralTest.createAttributeDefinition('Total Channel No', tmpProductDefinition, '', 'String', '', '', '');

    		cscfga__Attribute__c att1 = LG_GeneralTest.createAttribute('Voice Interface', def1, false, 0, pcInternet, false, 'BRI', true);
    		cscfga__Attribute__c att2 = LG_GeneralTest.createAttribute('Number Of Interfaces', def2, false, 0, pcInternet, false, '2', true);
    		cscfga__Attribute__c att3 = LG_GeneralTest.createAttribute('IP PBX Type', def3, false, 0, pcInternet, false, 'type', true);
    		cscfga__Attribute__c att4 = LG_GeneralTest.createAttribute('Subscriber to ISDN interface', def4, false, 0, pcInternet, false, '12121212', true);
    		cscfga__Attribute__c att5 = LG_GeneralTest.createAttribute('Call Barring Level', def5, false, 0, pcInternet, false, '7', true);
    		cscfga__Attribute__c att6 = LG_GeneralTest.createAttribute('Total Channel No', def6, false, 0, pcInternet, false, '4', true);

    		csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
    		insert coreq;

    		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = coreq.Id);
    		insert sub;

    		csord__Service__c service = new csord__Service__c(LG_ServiceStatus__c='Provisioned',csord__Identification__c = 'TestService', csord__Subscription__c = sub.Id, csord__Order_Request__c = coreq.Id, csordtelcoa__Product_Configuration__c = pcInternet.Id);
    		insert service;

            csordtelcoa__Orders_Subscriptions_Options__c osOptions = new csordtelcoa__Orders_Subscriptions_Options__c();
            osOptions.LG_ServiceRequestDeactivateStatus__c = 'Ready for Deactivation';
            osOptions.LG_SubscriptionRequestDeactivateStatus__c = 'Ready for Deactivation';
            osOptions.LG_ServiceDeactivatedStatus__c = 'Inactive';
            insert osOptions;
    }

    @isTest static void testSendEmailJS() {

      	UM_Email_Settings__c setting = new UM_Email_Settings__c();
      	setting.Name = 'Sipwise Provisioning';
      	setting.Email_Address__c = 'test@test.com';
      	insert setting;

    	csord__Service__c sid = [SELECT id FROM csord__Service__c WHERE  csord__Identification__c='TestService'];

    	Test.startTest();

    		System.assertEquals('Email sent', UM_SendEmailToSipwiseController.sendEmailJS(sid.Id), 'Something went wrong');

    	Test.stopTest();
    }

    @isTest static void testSendEmailApex() {

      	UM_Email_Settings__c setting = new UM_Email_Settings__c();
      	setting.Name = 'Sipwise Provisioning';
      	setting.Email_Address__c = 'test@test.com';
      	insert setting;

    	csord__Service__c sid = [SELECT id FROM csord__Service__c WHERE  csord__Identification__c='TestService'];

    	Test.startTest();

    		System.assertEquals('Email sent', UM_SendEmailToSipwiseController.sendEmailTrigger(sid.Id), 'Something went wrong');

    	Test.stopTest();
    }

    @isTest static void testSendNoEmail() {

      	UM_Email_Settings__c setting = new UM_Email_Settings__c();
      	setting.Name = 'Sipwise Provisioning';
      	setting.Email_Address__c = '';
      	insert setting;

    	csord__Service__c sid = [SELECT id FROM csord__Service__c WHERE  csord__Identification__c='TestService'];

    	Test.startTest();

    		UM_SendEmailToSipwiseController.sendEmailTrigger(sid.Id);

    	Test.stopTest();
    }
}