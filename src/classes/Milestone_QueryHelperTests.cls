@isTest
private class Milestone_QueryHelperTests {

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
    
    //added newly
    @istest
    static void isLocalOrderRelPresenttest(){
        CSPOFA__Orchestration_Process__c cs_orch=new CSPOFA__Orchestration_Process__c();
        cs_orch.CSPOFA__Progress__c='0%';
       Milestone_QueryHelper.validateRel(cs_orch.CSPOFA__Progress__c);
        
    }
    
      @istest
    static void filterValidFieldstest(){
      
        Map<String, Set<String>> supplied=new  Map<String, Set<String>>();
        Set<String> s1=new Set<String>();
        s1.add('CSPOFA__Opportunity__c');
        s1.add('CSPOFA__Orchestration_Process_Template__c');
        s1.add('CSPOFA__Processing_Mode__c');
       supplied.put('CSPOFA__Orchestration_Process__c', s1);
       Milestone_QueryHelper.filterValidFields(supplied);
        
    }
    
      @istest
    static void buildFieldStringtest(){
        set<string> emptyset=new set<String>();
       Milestone_QueryHelper.buildFieldString(emptyset);
        
    }
    
      @istest
    static void addFieldtest(){
        Map<String, Set<String>> fieldSetMap=new Map<String, Set<String>>();
 		Milestone_QueryHelper.addField(fieldSetMap,'','');
       }
    
      @istest
    static void getFieldSetMaptest(){
    	String filterJson = '{"$or": {"cspofa__Status__c": ["Error", "Warning"], "$and": {"cspofa__Status__c": "In Progress", "cspofa__Orchestration_Process__r.cspofa__jeopardy_created_flag__c": true}}}';
		Milestone_QueryHelper.getFieldSetMap(filterJson);
       }
    
    @istest
    static void isLocalOrderPresenttest(){
        Milestone_NavigatorConfig.Orders o=new Milestone_NavigatorConfig.Orders();
        o.OrchestrationProcessLookup='abc';
        Milestone_NavigatorConfig.Tabs s=new  Milestone_NavigatorConfig.Tabs();
       s.orders=o;
        Milestone_NavigatorConfig mileston=new Milestone_NavigatorConfig();
        mileston.Tabs=s;
      
		Milestone_QueryHelper.isLocalOrderRelPresent(mileston);
       }
    
     @istest
    static void isLocalSolutionRelPresenttest(){
        Milestone_NavigatorConfig.Solutions sol=new  Milestone_NavigatorConfig.Solutions();
        sol.OrchestrationProcessLookup='abcxyz';
        Milestone_NavigatorConfig.Orders o=new Milestone_NavigatorConfig.Orders();
        o.OrchestrationProcessLookup='abc';
        Milestone_NavigatorConfig.Tabs s=new  Milestone_NavigatorConfig.Tabs();
       s.orders=o;
        s.solutions=sol;
        Milestone_NavigatorConfig mileston=new Milestone_NavigatorConfig();
        mileston.Tabs=s;
      
		Milestone_QueryHelper.isLocalSolutionRelPresent(mileston);
       }
    
    
    @isTest
    static void testDeserializeFilter() {
        String filterJson = '{"$or": {"cspofa__Status__c": ["Error", "Warning"], "$and": {"cspofa__Status__c": "In Progress", "cspofa__Orchestration_Process__r.cspofa__jeopardy_created_flag__c": true}}}';
        String query = Milestone_QueryHelper.deserializeFilter(filterJson).toQueryFragment();
        String expected = '((cspofa__Status__c = \'Error\' OR cspofa__Status__c = \'Warning\' OR (cspofa__Status__c = \'In Progress\' AND cspofa__Orchestration_Process__r.cspofa__jeopardy_created_flag__c = true)))';
        System.assertEquals(expected, query);
    }

    @isTest
    static void testGetProcessesQuery() {
        
        String navJson = Milestone_ServiceUIController.getConfig('Milestone Config');
        Milestone_NavigatorConfig setup = (Milestone_NavigatorConfig)JSON.deserialize(navJson, Milestone_NavigatorConfig.class);
        
        System.assertNotEquals(null, Milestone_QueryHelper.getProcessesQuery('1 = 1', null, setup));
    }

    @isTest
    static void testBuildControlPanelItemsQuery() {
        String filterJson = '{"$or": {"cspofa__Status__c": ["Error", "Warning"], "$and": {"cspofa__Status__c": "In Progress", "cspofa__Orchestration_Process__r.cspofa__jeopardy_created_flag__c": true}}}';
        System.assertNotEquals(null, Milestone_QueryHelper.buildControlPanelItemsQuery(null, filterJson, 'CSPOFA__Step_Order__c ASC', 50));
    }

   /* @isTest
    static void testDeserializeFilterSpecialValues() {
        String filterJson = '{"OwnerId": "$User.Id"}';
        String query = Milestone_QueryHelper.deserializeFilter(filterJson).toQueryFragment();
        String expected = '(OwnerId = \'' + UserInfo.getUserId() + '\')';
        System.assertEquals(expected, query);

        filterJson = '{"Owner.userName": "$User.username"}';
        query = Milestone_QueryHelper.deserializeFilter(filterJson).toQueryFragment();
        expected = '(Owner.userName = \'' + UserInfo.getUserName() + '\')';
        System.assertEquals(expected, query);

        filterJson = '{"Owner.profileId": "$User.profileId"}';
        query = Milestone_QueryHelper.deserializeFilter(filterJson).toQueryFragment();
        expected = '(Owner.profileId = \'' + UserInfo.getProfileId() + '\')';
        System.assertEquals(expected, query);

        filterJson = '{"Owner.roleId": "$User.roleId"}';
        query = Milestone_QueryHelper.deserializeFilter(filterJson).toQueryFragment();
        String v = UserInfo.getUserRoleId();
        if (v == null) v = '';
        expected = '(Owner.roleId = \'' + v + '\')';
        System.assertEquals(expected, query);

        filterJson = '{"Owner.name": "$User.name"}';
        query = Milestone_QueryHelper.deserializeFilter(filterJson).toQueryFragment();
        expected = '(Owner.name = \'' + UserInfo.getName() + '\')';
        System.assertEquals(expected, query);
    }*/
    
    @isTest
    static void testDeserializeFilterLikeOperators() {
    	String filterJson = '{"test": {"$lk": "value%"}}';
        String query = Milestone_QueryHelper.deserializeFilter(filterJson).toQueryFragment();
        String expected = '(test LIKE \'value%\')';
        System.assertEquals(expected, query);    	

    	filterJson = '{"test": {"$nlk": "value%"}}';
        query = Milestone_QueryHelper.deserializeFilter(filterJson).toQueryFragment();
        expected = '(test NOT LIKE \'value%\')';
        System.assertEquals(expected, query);    	
    }
}