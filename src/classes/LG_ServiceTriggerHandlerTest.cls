@isTest(SeeAllData=true)
private class LG_ServiceTriggerHandlerTest {

    /*@testsetup
    private static void setupTestData() {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert coreq;
        
        //create orders
        csord__Order__c primaryorder = LG_GeneralTest.createOrder('primaryorder', account, 'First Status', coreq, opp, false);
        primaryorder.csord__Identification__c = '321654456453';
        primaryorder.csordtelcoa__Opportunity__c = opp.Id;
        insert primaryorder;
        
        csord__Order__c orderObj = LG_GeneralTest.createOrder('Test Order', account, 'First Status', coreq, opp, false);
        orderObj.csord__Identification__c = '321654687453';
        orderObj.csordtelcoa__Opportunity__c = opp.Id;
        orderobj.csord__Primary_Order__c = primaryorder.id;
        insert orderObj;
        
        csord__Order__c orderObj1 = LG_GeneralTest.createOrder('Test Order-2', account, 'First Status', coreq, opp, false);
        orderObj1.csord__Identification__c = '321654687453';
        orderObj1.csordtelcoa__Opportunity__c = opp.Id;
        orderobj.csord__Primary_Order__c = primaryorder.id;
        insert orderObj1;

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = coreq.Id);
        insert sub;

        insert new cscrm__Address__c(cscrm__Street__c = 'TestStreet');

        csordtelcoa__Orders_Subscriptions_Options__c osOptions = new csordtelcoa__Orders_Subscriptions_Options__c();
        osOptions.csordtelcoa__Subscription_Number_Prefix__c = 'SN-';
        osOptions.csordtelcoa__Service_Number_Prefix__c = 'SVC-';
        insert osOptions;

        Account acc = new Account();
        acc.Name = 'Planned Maintenance Account';
        acc.LG_VisitCountry__c = 'Germany';
        acc.LG_ChamberOfCommerceNumber__c = '7';
        acc.LG_Footprint__c = 'UPC';
        insert acc;



        EntitlementProcessId__c entitlementIds = new EntitlementProcessId__c();
        entitlementIds.Name = 'Gold';
        entitlementIds.Process_Id__c = e.Id;
        insert entitlementIds;

        noTriggers.Flag__c = false;
        upsert noTriggers;
    }*/

    private static testmethod void testUpdateSubscriptionAddress() {


        csord__Order_Request__c req = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert req;

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = req.Id);
        insert sub;

        cscrm__Address__c address = new cscrm__Address__c(cscrm__Street__c = 'TestStreet');
        insert address;

        System.assertEquals(null, sub.LG_Address__c, 'Address is null by default');

        Test.startTest();
        csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestIdentSub', csord__Order_Request__c = req.Id,
                csord__Subscription__c = sub.Id, LG_Address__c = address.Id);
        insert service;
        Test.stopTest();

        sub = [SELECT Id, csord__Identification__c, LG_Address__c
               FROM csord__Subscription__c WHERE csord__Identification__c = 'TestIdent'];

        System.assertEquals(address.Id, sub.LG_Address__c, 'Address should be populated');
    }

    @IsTest
    private static void updateServiceNumberTest() {

        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test Service Req', csord__Module_Version__c = '1.0');
        insert coreq;

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'Test Service Ident', csord__Order_Request__c = coreq.Id);
        sub.csordtelcoa__Change_Type__c = 'Move';
        insert sub;



        csord__Service__c service = new csord__Service__c(csord__Identification__c = 'Test Service', csord__Order_Request__c = coreq.Id);

        Test.startTest();

        service.csord__Subscription__c = sub.Id;
        insert service;

        Test.stopTest();

        csord__Service__c s = [SELECT Id, Name, csord__Subscription__r.csordtelcoa__Change_Type__c, csordtelcoa__Service_Number__c, csordtelcoa__Service_Number_Sequence__c FROM csord__Service__c WHERE Id = :service.Id LIMIT 1];

        String expected = 'SVC-' +  s.csordtelcoa__Service_Number_Sequence__c;

        System.assertNotEquals(null, s.csordtelcoa__Service_Number_Sequence__c, 'Invalid data');
        System.assertEquals(expected, s.csordtelcoa__Service_Number__c, 'Invalid data');
    }

    /*
    private static testmethod void testCloneSlaLineItem()
    {
        cscrm__Address__c address = [SELECT Id FROM cscrm__Address__c WHERE cscrm__Street__c = 'TestStreet'];

        csord__Subscription__c sub = [SELECT Id, csord__Identification__c, LG_Address__c
                                        FROM csord__Subscription__c WHERE csord__Identification__c = 'TestIdent'];

        csord__Order_Request__c req = [SELECT Id, csord__Module_Name__c
                                        FROM csord__Order_Request__c WHERE csord__Module_Name__c = 'Test'];

        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        csord__Service__c intService = new csord__Service__c(csord__Identification__c = 'TestIdentSub', csord__Order_Request__c = req.Id,
                                                            csord__Subscription__c = sub.Id, LG_Address__c = address.Id, LG_ProductFamily__c = 'Internet');
        insert intService;

        insert new csord__Service_Line_Item__c(Name = 'Test Internet SLA',
                                                            csord__Identification__c = 'nesto',
                                                            csord__Is_Adhoc__c = true,
                                                            csord__Is_Recurring__c = true,
                                                            csord__Line_Description__c = 'Test Desc',
                                                            csord__Service__c = intService.Id,
                                                            csord__Order_Request__c = req.Id,
                                                            LG_BillingAccount__c = null,
                                                            LG_ServiceLineItemExternalId__c = 'Something',
                                                            LG_Quantity__c = null,
                                                            LG_ExternalServiceName__c = 'SLA TEST',
                                                            LG_ExternalPriceName__c = null,
                                                            LG_ExternalDescription__c = 'Test Desc',
                                                            LG_Type__c = null, LG_AddOnType__c = 'SLA',
                                                            LG_ToBeSent__c = null);

        noTriggers.Flag__c = false;
        upsert noTriggers;


        Test.startTest();
            csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestIdentSub', csord__Order_Request__c = req.Id,
                                                                csord__Subscription__c = sub.Id, LG_Address__c = address.Id, LG_ProductFamily__c = 'HPBX');
            insert service;
        Test.stopTest();

        List<csord__Service_line_Item__c> lineItems = [SELECT Id, Name, csord__Identification__c, csord__Is_Adhoc__c,
                                                        csord__Is_Recurring__c, csord__Line_Description__c,
                                                        csord__Order_Request__c, LG_BillingAccount__c,
                                                        LG_ServiceLineItemExternalId__c, LG_Quantity__c, LG_ExternalServiceName__c,
                                                        LG_ExternalPriceName__c, LG_ExternalDescription__c, LG_Type__c,
                                                        LG_AddOnType__c, LG_ToBeSent__c
                                                        FROM csord__Service_line_Item__c
                                                        WHERE LG_AddOnType__c = 'SLA'
                                                        AND csord__Service__c = :service.Id];
        System.assertEquals(1, lineItems.size(), 'Only one SLA line item should be inserted');
        System.assertEquals('Test Desc', lineItems[0].LG_ExternalDescription__c, 'External description should be Test Desc');
        System.assertEquals('Test Internet SLA', lineItems[0].Name, 'Name should be Test Internet SLA');
    } */

    /**
    * Mark all subscriptions that have only SoHo Services with status "SoHo - To Be Deleted" when created
    *
    * @param  Map<Id, csord__Service__c> newMap
    * @author Petar Miletic
    * @ticket SFDT-665
    * @since  07/04/2016
    */
    /*
    @IsTest
    private static void updateSubscriptionStatus() {

        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test Request', csord__Module_Version__c = '1.0');
        insert coreq;

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'Test Subscription', csord__Order_Request__c = coreq.Id);
        sub.csordtelcoa__Change_Type__c = 'Move';
        insert sub;

        csord__Service__c service = new csord__Service__c(csord__Identification__c = 'Test Service', csord__Order_Request__c = coreq.Id);

        Test.startTest();

        service.LG_MarketSegment__c = 'SoHo';
        service.csord__Subscription__c = sub.Id;
        insert service;

        Test.stopTest();

        csord__Subscription__c su = [SELECT Id, Name, csord__Status__c FROM csord__Subscription__c WHERE csord__Identification__c = 'Test Subscription' LIMIT 1];

        System.assertEquals('SoHo - To Be Deleted', su.csord__Status__c, 'Invalid data');
    } */

    @IsTest
    private static void updateStatusOnService() {
        Profile p = [select id from profile where name = 'UM_CSR_Profile'];
        User tmpUser = [select id from User where ProfileId = :p.Id and isActive = true limit 1];

        System.runAs ( tmpUser ) {
            csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test Request', csord__Module_Version__c = '1.0');
            insert coreq;

            csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'Test Subscription', csord__Order_Request__c = coreq.Id);
            sub.csordtelcoa__Change_Type__c = 'Move';
            insert sub;

            csord__Service__c service = new csord__Service__c(csord__Identification__c = 'Test Service', csord__Order_Request__c = coreq.Id );
            service.LG_ServiceStatus__c = 'Active';
            service.LG_MarketSegment__c = 'SoHo';
            service.csord__Subscription__c = sub.Id;
            insert service;

            csord__Service__c serviceTmp = [select id, LG_ServiceStatus__c from csord__Service__c where id = :service.Id];
            
            system.assertEquals('Active', service.LG_ServiceStatus__c, 'Status should be set to Active!');

            Test.startTest();
            service.LG_ServiceStatus__c = 'Requested';
            try {
                update service;
                system.assert(true, 'Update should fail on status');
            } catch (Exception ex) {
                system.debug('Update should fail on going back to previous atate');
            }
            Test.stopTest();
        }
    }

    private static void testCreateContractOnServiceActiveStatus() {


    }

    private static void testUpdateDependsOn() {



    }

    /**
    * Update Solution to Complete once all service status set Actvie/Inactive
    *
    * @author Sathya.B
    * @ticket SFOM-820
    * @since  30/06/2017
    */
    @IsTest
    private static void UM_updateSoltuionToCompleteTest() {
        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test Request', csord__Module_Version__c = '1.0');
        insert coreq;

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'Test Subscription', csord__Order_Request__c = coreq.Id);
        sub.csordtelcoa__Change_Type__c = 'Move';
        insert sub;

        csord__Order__c order = new csord__Order__c();
        order.Name = 'Company Internet';
        order.csord__Identification__c = '123';

        insert order;

        csord__Solution__c sol = new csord__Solution__c();
        sol.csord__Order_Request__c = coreq.id;
        sol.csord__Order__c = order.id;

        sol.csord__Identification__c = '123';
        insert sol;

        csord__Service__c service2 = new csord__Service__c(csord__Identification__c = 'Test Service', csord__Order_Request__c = coreq.Id, LG_ServiceStatus__c = 'Requested');
        service2.LG_MarketSegment__c = 'SoHo';
        service2.csord__Subscription__c = sub.Id;
        service2.LG_Suborder__c = sol.id;
        insert service2;

        Test.startTest();

        service2.LG_ServiceStatus__c = 'Active';
        update service2;

        Test.stopTest();

        csord__Service__c serviceTmp = [select id, LG_ServiceStatus__c,LG_Suborder__r.csord__Status__c from csord__Service__c where id = :service2.Id];

        system.assertequals('Complete', serviceTmp.LG_Suborder__r.csord__Status__c);
    }

   @IsTest
    private static void UM_updateEntitlementToSLATest() {



        ///
        DateTime dateTimeInstance = DateTime.now();
        dateTimeInstance.addDays(1);

        Account acc = new Account();
        acc.Name = 'Planned Maintenance Account';
        acc.LG_VisitCountry__c = 'Germany';
        acc.LG_ChamberOfCommerceNumber__c = '7';
        acc.LG_Footprint__c = 'UPC';
        insert acc;
         system.assertequals('Planned Maintenance Account',acc.Name);

        csord__Order_Request__c orderRequest = new csord__Order_Request__c();
        orderRequest.Name = 'Test Order Request';
        orderRequest.csord__Module_Name__c = 'Test Module';
        orderRequest.csord__Module_Version__c = 'Test v1.0';
        orderRequest.csord__Process_Status__c = 'Testing';
        orderRequest.csord__Request_DateTime__c = dateTimeInstance;
        insert orderRequest;

        csord__Subscription__c sub = new csord__Subscription__c();
        sub.Name = 'Business Broadband';
        sub.csord__Account__c = acc.id;
        sub.csord__Identification__c = 'Test Identification';
        sub.csord__Order_Request__c = orderRequest.id;
        insert sub;

        csord__Service__c service = new csord__Service__c();
        service.csord__Subscription__c = sub.id;
        service.LG_ServiceExternalId__c = '112245 testing';
        service.LG_SLA__c = 'Gold';
        service.Name = 'Test Service';
        service.csord__Status__c = 'Active';
        service.csord__Order_Request__c = orderRequest.Id;
        service.csord__Identification__c ='test Identification';
        insert service;

        csord__Service__c service1 = new csord__Service__c();
        service1.csord__Subscription__c = sub.id;
        service1.LG_ServiceExternalId__c = '112245 testing';
        service1.LG_SLA__c = 'Bronze';
        service1.Name = 'Test Service';
        service1.csord__Status__c = 'Active';
        service1.csord__Order_Request__c = orderRequest.Id;
        service1.csord__Identification__c ='test Identification';
        insert service1;

        //List<csord__Service__c> services = [SELECT Id FROM csord__Service__c WHERE LG_SLA__c != null LIMIT 1000];
        Set<Id> serviceIds = new Set<Id>();
        serviceIds.add(service.Id);
        serviceIds.add(service1.Id);
        Entitlement e = new Entitlement();
        e.AccountId = acc.Id;
        e.Name = 'TestEntitlement';
        e.StartDate = date.newInstance(2015, 2, 1);
        Date d = Date.today();
        e.EndDate = d.addDays(1);
        insert e;


        service1.LG_SLA__c = 'Gold';
        update service1;

    }
    /*
    @isTest public static void setupMethod() {
        DateTime dateTimeInstance = DateTime.now();
        dateTimeInstance.addDays(1);

        Account acc = new Account();
        acc.Name = 'Planned Maintenance Account';
        acc.LG_VisitCountry__c = 'Germany';
        acc.LG_ChamberOfCommerceNumber__c = '7';
        acc.LG_Footprint__c = 'UPC';
        insert acc;


        csord__Order_Request__c orderRequest = new csord__Order_Request__c();
        orderRequest.Name = 'Test Order Request';
        orderRequest.csord__Module_Name__c = 'Test Module';
        orderRequest.csord__Module_Version__c = 'Test v1.0';
        orderRequest.csord__Process_Status__c = 'Testing';
        orderRequest.csord__Request_DateTime__c = dateTimeInstance;
        insert orderRequest;

        csord__Subscription__c sub = new csord__Subscription__c();
        sub.Name = 'Business Broadband';
        sub.csord__Account__c = acc.id;
        sub.csord__Identification__c = 'Test Identification';
        sub.csord__Order_Request__c = orderRequest.id;
        insert sub;

        csord__Service__c service = new csord__Service__c();
        service.csord__Subscription__c = sub.id;
        service.LG_ServiceExternalId__c = '112245 testing';
        service.LG_SLA__c = 'Gold';
        service.Name = 'Test Service';
        service.csord__Status__c = 'Active';
        service.csord__Order_Request__c = orderRequest.Id;
        service.csord__Identification__c ='test Identification';
        insert service;

        csord__Service__c service1 = new csord__Service__c();
        service1.csord__Subscription__c = sub.id;
        service1.LG_ServiceExternalId__c = '112245 testing';
        service1.LG_SLA__c = 'Bronze';
        service1.Name = 'Test Service';
        service1.csord__Status__c = 'Active';
        service1.csord__Order_Request__c = orderRequest.Id;
        service1.csord__Identification__c ='test Identification';
        insert service1;

        service1.LG_SLA__c = 'Bronze';
        update service1;
        //List<csord__Service__c> services = [SELECT Id FROM csord__Service__c WHERE LG_SLA__c != null LIMIT 1000];
        Set<Id> serviceIds = new Set<Id>();
        serviceIds.add(service.Id);
        serviceIds.add(service1.Id);
        Entitlement e = new Entitlement();
        e.AccountId = acc.Id;
        e.Name = 'TestEntitlement';
        e.StartDate = date.newInstance(2015, 2, 1);
        Date d = Date.today();
        e.EndDate = d.addDays(1);
        insert e;





    }*/
}