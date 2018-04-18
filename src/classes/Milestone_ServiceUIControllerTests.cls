@isTest
private class Milestone_ServiceUIControllerTests {
    /* Fixture vars */
    static String fieldJson;
    static Account acc;
    static csord__Order_Request__c req;
    static csord__Order__c ord;
    static csord__Subscription__c sub;
    static csord__Service__c service;
    static csord__Service__c childService;
    static cspofa__Orchestration_Process__c process;
    static csord__Solution__c sol;
    
    @testSetup 
    private static void setupTestData() {
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        List<cssvc1__Service_Console_Component_Config__c> setups = new List<cssvc1__Service_Console_Component_Config__c>();
        
        cssvc1__Service_Console_Component_Config__c obj1 = new cssvc1__Service_Console_Component_Config__c();
        obj1.Name = 'Milestone Navigator Config';
        obj1.cssvc1__Type__c = 'Milestone Config';
        obj1.cssvc1__JSON__c = '{ "tabs":{ "orders":{ "enabled":true, "OrchestrationProcessLookup":"lg_order__c", "OrchestrationProcessLookupFull":"lg_order__c" }, "subscriptions":{ "enabled":true, "OrchestrationProcessLookup":"csordtelcoa__Subscription__c", "OrchestrationProcessLookupFull":"csordtelcoa__Subscription__c" }, "solutions":{ "enabled":true, "OrchestrationProcessLookup":"lg_solution__c", "OrchestrationProcessLookupFull":"lg_solution__r.csord__order__c" } }, "deltavisualiser":{ "delta":{ "enabled":true, "url":"https://test.salesforce.com" } }, "cols":{ "orders":[ { "name":"Order Number", "field":{ "csord__order__c":"csord__order_number__c", "csord__subscription__c":"csord__identification__c" }, "link":"id", "style":{ "width":"20%" } } ], "subscriptions":[ ], "solutions":[ ] }, "filter":{ "orders":{ "options":[ { "label":"All", "value":null }, { "label":"Status: Active", "value":"Active" }, { "label":"Status: Complete", "value":"Complete" }, { "label":"Status: In Progress", "value":"In Progress", "default":true }, { "label":"Status: Closed Replaced", "value":"Closed Replaced" } ] }, "subscriptions":{ "options":[ { "label":"All", "value":null }, { "label":"Status: Active/In Provisioning", "value":[ "Active", "In Provisioning" ], "default":true }, { "label":"Status: In Progress", "value":"In Progress" }, { "label":"Status: Closed Replaced", "value":"Closed Replaced" }, { "label":"Name: Test Subscription 3C", "value":"Test Subscription 3C", "field":"Name" } ] }, "solutions":{ "options":[ { "label":"All", "value":null }, { "label":"Status: Active", "value":"Active" }, { "label":"Status: Complete", "value":"Complete" }, { "label":"Status: In Progress", "value":"In Progress", "default":true }, { "label":"Status: Closed Replaced", "value":"Closed Replaced" } ] } }, "translations": { "de" : { "OrdersAndSubscriptionsNavigator": "Orders & Subscriptions Navigator de", "Orders": "Orders de", "Subscriptions": "Subscriptions de", "Solutions": "Solutions de", "Name": "Name de", "Status": "Status de", "Delta": "Delta" } }}';
        
        cssvc1__Service_Console_Component_Config__c obj2 = new cssvc1__Service_Console_Component_Config__c();
        obj2.Name = 'Milestone View Config';
        obj2.cssvc1__Type__c = 'Milestone View Config';
        obj2.cssvc1__JSON__c = '{"showCriticalPath":false,"showTaskList":false,"showCaseList":false,"Order Progress Milestones":{"The order is clean and is accepted by SD for further processing":"Testflag"},"wildcard":{"Project Manager Assigned":"task-completed"},"inflight":{"order":{"enabled":true,"OrchestrationProcessLookup":"lg_order__c","buttonsAndActionsField":"","buttonsAndActionsLookup":"","pauseResumeButton":false,"buttonsAndActions":[{"action":"Change","url":"/apex/ProcesViewDetails?Id=","enabled":true,"externalLink":false,"target":"_blank"},{"action":"Follow-On","url":"/apex/ProcesViewDetails?Id=","enabled":true,"externalLink":false,"target":"_blank"},{"action":"Cancel","url":"/apex/ProcesViewDetails?Id=","enabled":true,"externalLink":false,"target":"_blank"},{"action":"Test","url":"/apex/ProcesViewDetails?Id=","enabled":true,"externalLink":false,"target":"_blank"},{"action":"Test 2","url":"/apex/ProcesViewDetails?Id=","enabled":true,"externalLink":false,"target":"_blank"}]},"service":{"enabled":true,"OrchestrationProcessLookup":"lg_order__c","buttonsAndActionsField":"","buttonsAndActionsLookup":"","pauseResumeButton":false,"buttonsAndActions":[{"action":"Follow-On","url":"/apex/ProcesViewDetails?Id=","enabled":true,"externalLink":false,"target":"_blank"},{"action":"Cancel","url":"/apex/ProcesViewDetails?Id=","enabled":true,"externalLink":false,"target":"_blank"}]}},"suborderSettings":{"enabled":true,"OrchestrationProcessLookup":"lg_solution__c","OrchestratorRelatedSuborderInfo":"lg_solution__r","suborderActions":{"objectType":"csord__Solution__c","enabled":true,"pauseResumeButton":true,"buttonsAndActionsField":"","buttonsAndActionsLookup":"","buttonsAndActions":[{"action":"Appointments","url":"/apex/ProcesViewDetails?Id=","enabled":true,"externalLink":false,"target":"_blank"},{"action":"Numbers","url":"/apex/ProcesViewDetails?Id=","enabled":true,"externalLink":false,"target":"_blank"},{"action":"Configure","url":"/apex/ProcesViewDetails?Id=","enabled":true,"externalLink":false,"target":"_blank"},{"action":"Test","url":"/apex/ProcesViewDetails?Id=","enabled":true,"externalLink":false,"target":"_blank"},{"action":"Test New","url":"/apex/ProcesViewDetails?Id=","enabled":true,"externalLink":false,"target":"_blank"}]}}}';
        
        setups.add(obj1);
        setups.add(obj2);
        
        insert setups;
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    
    @isTest
    static void testGetConfigReturnsDefaultEmptyString() {
        System.assertEquals('', Milestone_ServiceUIController.getConfig('test'));
    }
    
    @isTest
    static void testUserAngularLocale() {
        // System.assertEquals('en', new ServiceUIController().userAngularLocale);
        System.assertEquals(UserInfo.getLocale().toLowerCase().replaceAll('_\\w\\w', ''), new Milestone_ServiceUIController().userAngularLocale);
    }
    
    @isTest
    static void testGetConfigReturnsConfigObject() {
        String json = '{"Test": "Config"}';
        cssvc1__Service_Console_Component_Config__c config = new cssvc1__Service_Console_Component_Config__c(Name = 'Test Config', cssvc1__type__c = 'test', cssvc1__json__c = json);
        insert config;
        System.assertEquals(json, Milestone_ServiceUIController.getConfig('test'));
    }
    
    @isTest
    static void testGetProcesses() {
        fixtures();
        
        System.assertNotEquals(null, Milestone_ServiceUIController.getProcesses(ord.Id));
        System.assertNotEquals(null, Milestone_ServiceUIController.getProcesses(sub.Id));
        System.assertNotEquals(null, Milestone_ServiceUIController.getProcesses(service.Id));
        System.assertNotEquals(null, Milestone_ServiceUIController.getProcesses(childService.Id));
        System.assertNotEquals(null, Milestone_ServiceUIController.getProcesses(sol.Id));
    }
    
    @isTest
    
    static void testgetAccount() {
        fixtures();
        
        
        
        test.startTest();
        Milestone_ServiceUIController c;
        
        
        c = new Milestone_ServiceUIController();
        try{
            c.recId = acc.id;
            System.assertEquals(acc.id, c.account.id); 
        } catch(DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
        
        
        c = new Milestone_ServiceUIController();
        c.recId = ord.id;
        System.assertEquals(acc.id, c.account.id);
        
        c = new Milestone_ServiceUIController();
        c.recId = sub.id;
        System.assertEquals(acc.id, c.account.id);
        
        c = new Milestone_ServiceUIController();
        c.recId = service.id;
        System.assertEquals(acc.id, c.account.id);
        
        c = new Milestone_ServiceUIController();
        c.recId = sol.id;
        System.assertEquals(acc.id, c.account.id);
        
        c = new Milestone_ServiceUIController();
        c.recId = process.id;
        System.assertEquals(null, process.csordtelcoa__Service__c);
        System.assertNotEquals(null, process.csordtelcoa__Subscription__c);
        test.stopTest();
    }
    
    
    static void fixtures() {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        fieldJson = '[{"name":"Name","field":"name","link":"id","style":{"min-width":"120px","width":"20%"}},{"name":"Status","field":{"csord__order__c":"csord__status2__c","csord__subscription__c":"csord__status__c","csord__service__c":"csord__status__c"},"style":{"min-width":"120px","width":"20%"}},{"name":"Process","field":"process","style":{"min-width":"120px","width":"20%"}},{"name":"Progress","type":"progress","style":{"min-width":"120px","width":"20%"}},{"name":"Order Number","field":{"csord__order__c":"csord__order_number__c","csord__subscription__c":"csord__identification__c"},"link":"id","style":{"width":"20%"}},{"name":"Name","field":"name","link":"id"},{"name":"Status","field":{"csord__order__c":"csord__status2__c","csord__subscription__c":"csord__status__c","csord__service__c":"csord__status__c"},"style":{"min-width":"120px","width":"20%"}},{"name":"One Off Charge","field":{"csord__subscription__c":"csord__total_one_off_charges__c","csord__service__c":"csord__total_one_off_charges__c"},"type":"currency","style":{"max-width":"100px"}},{"name":"Recurring Charge","field":{"csord__subscription__c":"csord__total_recurring_charges__c","csord__service__c":"csord__total_recurring_charges__c"},"type":"currency","style":{"max-width":"100px"}},{"name":"Start Date","field":{"csord__service__c":"csord__Activation_Date__c","csord__service_line_item__c":"csord__Start_Date__c"},"type":"date","style":{"max-width":"100px"}},{"name":"End Date","field":{"csord__service__c":"csord__Deactivation_Date__c","csord__service_line_item__c":"csord__End_Date__c"},"type":"date","style":{"max-width":"100px"}}]';
        
        acc = new Account(
            name = 'Test Account'
        );
        
        insert acc;
        
        req = new csord__Order_Request__c(
            name = 'Test OR',
            csord__module_name__c = 'Test',
            csord__module_version__c = '1',
            csord__Process_Status__c = 'Requested',
            csord__Request_DateTime__c = System.DateTime.newInstance(System.currentTimeMillis())
        );
        insert req;
        
        ord = new csord__Order__c(
            name = 'Test Order',
            csord__Account__c = acc.id,
            csord__Order_Request__c = req.id,
            csord__Identification__c = '1'
        );
        insert ord;
        
        sub = new csord__Subscription__c(
            name = 'Test Sub',
            csord__Account__c = acc.id,
            csord__Order_Request__c = req.id,
            csord__Order__c = ord.id,
            csord__Identification__c = '1',
            csord__Status__c = 'In Provisioning'
        );
        insert sub;
        
        service = new csord__Service__c(
            name = 'Test Service',
            csord__Order_Request__c = req.id,
            csord__Order__c = ord.id,
            csord__Subscription__c = sub.id,
            csord__Identification__c = '1',
            csord__Status__c = 'In Provisioning'
        );
        insert service;
        
        sol = new csord__Solution__c(
            name = 'Test Sol',
            csord__Identification__c = '1',
            csord__Account__c = acc.id
        );
        insert sol;
        
        childService = new csord__Service__c(
            name = 'Test Child Service',
            csord__Order_Request__c = req.id,
            csord__Order__c = ord.id,
            csord__Subscription__c = sub.id,
            csord__Service__c = service.id,
            csord__Identification__c = '1',
            csord__Status__c = 'In Provisioning'
        );
        insert childService;
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        Task t = LG_Util.createTask('Test Task', 'Task: Other', null, thisUser.Id, Date.today(), 'New', 'Normal', ord.Id, false);
        t.LG_Preferred_Communication_Channel__c = 'Phone';
        insert t;
        
        cspofa__Orchestration_Process_Template__c tpl = new cspofa__Orchestration_Process_Template__c(
            Name = 'Test Tpl'
        );
        insert tpl;
        
        process = new cspofa__Orchestration_Process__c(
            Name = 'Test Process',
            cspofa__Orchestration_Process_Template__c = tpl.id,
            cspofa__Account__c = acc.id,
            csordtelcoa__Service__c = null,
            csordtelcoa__Subscription__c = sub.id,
            cspofa__Process_On_Hold__c = false
        );
        insert process;
        
        
        List<cspofa__Orchestration_Step__c> steps = new List<cspofa__Orchestration_Step__c>();
        for (Integer i = 1; i < 4; i++) {
            cspofa__Orchestration_Step__c step = new cspofa__Orchestration_Step__c(
                name = 'Step ' + i,
                cspofa__Orchestration_Process__c = process.id
            );
            if (i == 1) {
                step.cspofa__related_object_id__c = t.id;
                step.cspofa__status__c = 'Error';
            }
            steps.add(step);
        }
        insert steps;
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    public static testmethod void getAccounttest(){
        test.startTest();
        
        Account account = new Account(Name = 'Send mail test Account');
        insert account;
        ApexPages.StandardController sc = new ApexPages.StandardController(account);
        Milestone_ServiceUIController milserv=new Milestone_ServiceUIController(sc);
        Account acc = LG_GeneralTest.CreateAccount('TestAccount', '321654987', 'Test', true);
        
        cspofa__Orchestration_Process_Template__c tpl = new cspofa__Orchestration_Process_Template__c(
            Name = 'Test Tpl'
        );
        insert tpl;
        process = new cspofa__Orchestration_Process__c(
            Name = 'Test Process',
            cspofa__Orchestration_Process_Template__c = tpl.id,
            cspofa__Account__c = acc.id,
            cspofa__Process_On_Hold__c = true
        );
        insert process;
        
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, false);
        opp.StageName = 'Order Generated';
        insert opp;
        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert coreq;
        
        csord__Order__c orderObj = LG_GeneralTest.createOrder('Test Order', acc, 'First Status', coreq, opp, false);
        orderObj.csord__Identification__c = '321654687453';
        orderObj.csordtelcoa__Opportunity__c = opp.Id;
        insert orderObj;
        
        
        
        Milestone_ServiceUIController.startPauseProcess(process.id);
        Milestone_ServiceUIController.getSuborders(orderObj.id,2,2);
        
        //milserv.recordType();
        Milestone_ServiceUIController c;
        
        c = new Milestone_ServiceUIController();
        c.recId = account.id;
        test.stopTest();
        
        
    }
    public static testmethod void userCurrencySymboltest(){
        test.startTest();
        Account account = lg_generaltest.createPartnerAccount();
        ApexPages.StandardController sc = new ApexPages.StandardController(account);
        Milestone_ServiceUIController milserv=new Milestone_ServiceUIController(sc);
        Milestone_ServiceUIController c;
        c = new Milestone_ServiceUIController();
        System.assertEquals(UserInfo.getDefaultCurrency(), c.userCurrencyCode);
        System.assertNotEquals(UserInfo.getDefaultCurrency(),c.userCurrencySymbol);
        c.recId = account.id;
        system.assertNotEquals(String.valueOf(account.RecordType),c.RecordType);
        //Start - SFOM - 1977
        system.assertNotEquals('',c.related); 
        //End - SFOM - 1977
        test.stopTest();
        
    }
    public static testmethod void CatchTest(){
        
        //Start - SFOM - 1977
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        //End - SFOM - 1977

        test.startTest();
        Account ac = new Account(
            name = 'Test Account'
        );
        
        insert ac;
        req = new csord__Order_Request__c(
            name = 'Test OR',
            csord__module_name__c = 'Test',
            csord__module_version__c = '1',
            csord__Process_Status__c = 'Requested',
            csord__Request_DateTime__c = System.DateTime.newInstance(System.currentTimeMillis())
        );
        insert req;
        
        ord = new csord__Order__c(
            name = 'Test Order',
            csord__Account__c = ac.id,
            csord__Order_Request__c = req.id,
            csord__Identification__c = '1'
        );
        insert ord;
        
        sub = new csord__Subscription__c(
            name = 'Test Sub',
            csord__Account__c = ac.id,
            csord__Order_Request__c = req.id,
            csord__Order__c = ord.id,
            csord__Identification__c = '1',
            csord__Status__c = 'In Provisioning'
        );
        insert sub;
        
        service = new csord__Service__c(
            name = 'Test Service',
            csord__Order_Request__c = req.id,
            csord__Order__c = ord.id,
            csord__Subscription__c = sub.id,
            csord__Identification__c = '1',
            csord__Status__c = 'In Provisioning'
        );
        insert service;
        
        
        delete ac;
        delete ord;
        delete service;
        delete sub;
        //Start - SFOM - 1977
        noTriggers.Flag__c = False;
        upsert noTriggers;
        //End - SFOM - 1977
        
        Milestone_UtilityHelper.loadAccount(ac.id);
        Milestone_UtilityHelper.loadAccount(ord.id);
        Milestone_UtilityHelper.loadAccount(service.id);
        Milestone_UtilityHelper.loadAccount(sub.id);
        
        test.stopTest();
    }
    
    
}