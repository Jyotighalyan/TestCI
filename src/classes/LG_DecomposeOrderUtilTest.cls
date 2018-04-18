@isTest
private class LG_DecomposeOrderUtilTest {

    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        LG_NumberManagementSettings__c mngSettings = new LG_NumberManagementSettings__c();
        mngSettings.LG_BlockSizes__c                       = '1,10,100';
        mngSettings.LG_NumberRangeProdConfForNew__c        = true;
        mngSettings.LG_NumberRangeProdConfForPortIn__c     = true;
        mngSettings.LG_NumberRangeProductDefinitionName__c = 'Number Range';
        mngSettings.LG_TelephonyNumberRangeAttribute__c    = 'Number Ranges';
        mngSettings.LG_BlockTypeAttribute__c               = 'Block Type';
        mngSettings.LG_EndNumberAttribute__c               = 'End Number';
        mngSettings.LG_NumberRangeAttribute__c             = 'Number Range';
        mngSettings.LG_SizeAttribute__c                    = 'Size';
        mngSettings.LG_StartNumberAttribute__c             = 'Start Number';
        insert mngSettings;

        csordtelcoa__Change_Types__c changeTypeDown = new csordtelcoa__Change_Types__c();
        changeTypeDown.csordtelcoa__Sort_Order__c = 0;
        changeTypeDown.Name                       = 'Migrate';
        changeTypeDown.LG_MigrateVariety__c       = true;
        insert changeTypeDown;

        Account acc = LG_GeneralTest.CreateAccount('TestAccount', '321654987', 'Test', true);

        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, true);

        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('TestBasket', acc, null, opp, true);

        // Generate Product Definition
        cscfga__Product_Definition__c prodDef = LG_GeneralTest.createProductDefinition('ProdDef58', false);
        prodDef.LG_NeedsActivation__c   = 'Y,Y,Y';
        prodDef.LG_NeedsInstallation__c = 'N,N,N';
        insert prodDef;

        // Generate Product Definition
        cscfga__Product_Definition__c prodDefEmpty = LG_GeneralTest.createProductDefinition('ProdDef58', false);
        prodDefEmpty.LG_NeedsActivation__c = '';
        insert prodDefEmpty;

        // Generate Product Configuration
        cscfga__Product_Configuration__c prodConfig = LG_GeneralTest.createProductConfiguration('ProdConf58', 3, basket, prodDef, true);

        // Generate Product Configuration
        cscfga__Product_Configuration__c prodConfigEmpty = LG_GeneralTest.createProductConfiguration('ProdConfEmpty', 3, basket, prodDefEmpty, true);

        CSPOFA__Orchestrator_Constants__c orchConstants = new CSPOFA__Orchestrator_Constants__c();
        orchConstants.LG_OrchestrateOrder__c = 'Orch Order';
        insert orchConstants;

        LG_OrderDecompositionSettings__c decompSettings = new LG_OrderDecompositionSettings__c();
        decompSettings.Name                              = 'VM';
        decompSettings.LG_SiteAgnosticProductFamilies__c = 'Mobile,Cloud';
        //insert decompSettings;

        String decCrit1;
        String decCrit2;
        String decCrit5;
        String decCrit7;
        String decCrit8;

        Schema.DescribeFieldResult fieldResult = csord__Service__c.LG_DecompositionCriteria__c.getDescribe();
        List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
        decCrit5                       = plist[4].getValue();
        decCrit7                       = plist[6].getValue();
        decCrit8                       = plist[7].getValue();

        LG_OrderDecompositionSettings__c decompSettings1 = new LG_OrderDecompositionSettings__c(Name = 'UM');
        decompSettings1.LG_NoGroupingDecompositionCriteria__c = decCrit5;
        decompSettings1.LG_AllTogetherDecompositionCriteria__c = decCrit7;
        decompSettings1.LG_PerSiteDecompositionCriteria__c = decCrit8;
        decompSettings1.LG_CombineInternetDecompositionCriteria__c = 'Combine Internet';
        decompSettings1.LG_MacdDecompositionCriteria__c = 'macd criteria';
        decompSettings1.LG_GroupDependentWithParent__c = 'Set 6 - CaMa Dependent';
        //insert decompSettings1;
		
        List<CSPOFA__Orchestration_Process_Template__c> orcTemplates = new List<CSPOFA__Orchestration_Process_Template__c>();
        CSPOFA__Orchestration_Process_Template__c orcTemplateOrder = new CSPOFA__Orchestration_Process_Template__c(Name = 'Orch Order');
        orcTemplates.add(orcTemplateOrder);

        for (Schema.PicklistEntry ple : fieldResult.getPicklistValues()) {
            orcTemplates.add(new CSPOFA__Orchestration_Process_Template__c(LG_DecompositionCriteria__c = ple.getValue()));
        }

        insert orcTemplates;

        List<cscrm__Address__c> addresses = new List<cscrm__Address__c>();
        cscrm__Address__c addressOne = new cscrm__Address__c(Name = 'AddressOne');
        cscrm__Address__c addressTwo = new cscrm__Address__c(Name = 'AddressTwo');
        addresses.add(addressOne);
        addresses.add(addressTwo);
        insert addresses;

        csord__Order__c order = new csord__Order__c(csord__Identification__c = 'IdentOrd1');
        insert order;

        csord__Order__c order2 = new csord__Order__c(csord__Identification__c = 'IdentOrd2');
        insert order2;

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'IdentSub');
        insert sub;

        /*
         * Delta status added as part of SFOM-131
         */
        List<csord__Service__c> services = new List<csord__Service__c>();
        csord__Service__c serviceDC1One = new csord__Service__c(Name='servicename',csord__Subscription__c = sub.Id,
                                                                csord__Identification__c = 'serviceDC1One', csordtelcoa__Delta_Status__c = 'Added To Subscription',
                                                                csordtelcoa__Product_Configuration__c = prodConfig.Id,
                                                                //LG_DecompositionCriteria__c = 'DC1',
                                                                LG_RootOrder__c = order.Id);
        csord__Service__c serviceDC1Two = new csord__Service__c(csord__Subscription__c = sub.Id,
                                                                csord__Identification__c = 'serviceDC1Two', csordtelcoa__Delta_Status__c = 'Continuing In Subscription',
                                                                csordtelcoa__Product_Configuration__c = prodConfig.Id,
                                                                //LG_DecompositionCriteria__c = 'DC1',
                                                                LG_RootOrder__c = order.Id);
        csord__Service__c serviceDC2One = new csord__Service__c(csord__Subscription__c = sub.Id,
                                                                csord__Identification__c = 'serviceDC2One', csordtelcoa__Delta_Status__c = 'Deleted From Subscription',
                                                                csordtelcoa__Product_Configuration__c = prodConfig.Id,
                                                                //LG_DecompositionCriteria__c = 'DC2',
                                                                LG_RootOrder__c = order.Id);
        csord__Service__c serviceDC1Ord2One = new csord__Service__c(csord__Subscription__c = sub.Id,
                                                                    csord__Identification__c = 'serviceDC1Ord2One', csordtelcoa__Delta_Status__c = 'Added To Subscription',
                                                                    csordtelcoa__Product_Configuration__c = prodConfigEmpty.Id,
                                                                    //LG_DecompositionCriteria__c = 'DC1',
                                                                    LG_RootOrder__c = order2.Id);
        csord__Service__c serviceDC2Ord2One = new csord__Service__c(csord__Subscription__c = sub.Id,
                                                                    csord__Identification__c = 'serviceDC2Ord2One', csordtelcoa__Delta_Status__c = 'Added To Subscription',
                                                                    csordtelcoa__Product_Configuration__c = prodConfig.Id,
                                                                    //LG_DecompositionCriteria__c = 'DC2',
                                                                    LG_Address__c = addressOne.Id,
                                                                    LG_RootOrder__c = order2.Id);
        csord__Service__c serviceDC2Ord2Two = new csord__Service__c(Name='servicecheck',csord__Subscription__c = sub.Id,
                                                                    csord__Identification__c = 'serviceDC2Ord2Two', csordtelcoa__Delta_Status__c = 'Added To Subscription',
                                                                    csordtelcoa__Product_Configuration__c = prodConfig.Id,
                                                                    //LG_DecompositionCriteria__c = 'DC2',
                                                                    LG_Address__c = addressTwo.Id,
                                                                    LG_RootOrder__c = order2.Id);
        services.add(serviceDC1One);
        services.add(serviceDC1Two);
        services.add(serviceDC2One);
        services.add(serviceDC1Ord2One);
        services.add(serviceDC2Ord2One);
        services.add(serviceDC2Ord2Two);
        insert services;

        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert coreq;

        cscfga__Product_Definition__c telephonyProdDef   = LG_GeneralTest.createProductDefinition('Telephony', true);
        cscfga__Product_Definition__c prodDefNumberRange = LG_GeneralTest.createProductDefinition('Number Range', true);

        cscfga__Product_Configuration__c telephonyProdConf   = LG_GeneralTest.createProductConfiguration('Telephony', 3, basket, telephonyProdDef, true);
        cscfga__Product_Configuration__c numberRangeProdConf = LG_GeneralTest.createProductConfiguration('Number Range', 3, basket, prodDefNumberRange, true);

        List<Asset> assets = new List<Asset>();
        for (Integer i = 0; i<105; i++) {
            assets.add(new Asset(AccountId = acc.Id, Name = 'Nmbr'+i, LG_TelephonyProductConfiguration__c = telephonyProdConf.Id, LG_NumberRangeProductConfiguration__c = numberRangeProdConf.Id));
        }
        insert assets;

        csord__Service__c telephonyService = new csord__Service__c(csord__Identification__c = 'TestTelServ', csord__Order_Request__c = coreq.Id,
                                                                   csord__Subscription__c = sub.Id, csordtelcoa__Product_Configuration__c = telephonyProdConf.Id);
        insert telephonyService;

        csord__Service__c numberRangeService = new csord__Service__c(csord__Identification__c = 'TestNmbrServ', csord__Order_Request__c = coreq.Id, csord__Service__c = telephonyService.Id,
                                                                     csord__Subscription__c = sub.Id, csordtelcoa__Product_Configuration__c = numberRangeProdConf.Id);
        insert numberRangeService;

        noTriggers.Flag__c = false;
        upsert noTriggers;
    }

    private static testmethod void startOrderDecomposition()
    {
        cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c];

        Map<Id, csord__Order__c> orders = new Map<Id, csord__Order__c>([SELECT Id FROM csord__Order__c
                                                                        WHERE csord__Identification__c IN ('IdentOrd1', 'IdentOrd2')]);

        String decCrit1;
        String decCrit2;
        String decCrit3;

        Schema.DescribeFieldResult fieldResult =
            csord__Service__c.LG_DecompositionCriteria__c.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        decCrit1                       = ple[0].getValue();
        decCrit2                       = ple[1].getValue();
        decCrit3                       = ple[2].getValue();

        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        cscfga__Product_Definition__c prodDefLegacy = LG_GeneralTest.createProductDefinition('Legacy', true);

        cscfga__Product_Configuration__c prodConfLegacy = LG_GeneralTest.createProductConfiguration('Legacy', 3, basket, prodDefLegacy, true);

        Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);

        csconta__Billing_Account__c bAcc= new csconta__Billing_Account__c(csconta__Account__c= account.ID, csconta__Status__c='New', LG_ContractualOrganization__c='Hessen (HSN)', csconta__Billing_Channel__c='Paper', UM_BillFormatOptions__c='Summary');
    	insert bAcc;

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'IdentSub',csconta__Billing_Account__c=bAcc.id);
        insert sub;
        

        //LG_OrderDecompositionSettings__c decompSettings = LG_OrderDecompositionSettings__c.getAll().get('VM');
        //decompSettings.LG_LegacyDecompositionCriteria__c = decCrit3;
        //update decompSettings;

        csord__Service__c legacyOne = new csord__Service__c(csord__Subscription__c = sub.Id,
                                                            csord__Identification__c = 'legacyone',
                                                            csordtelcoa__Product_Configuration__c = prodConfLegacy.Id,
                                                            LG_DecompositionCriteria__c = decCrit3,
                                                            LG_RootOrder__c = orders.values()[0].Id);
        insert legacyOne;
        csord__Service__c legacyTwo = new csord__Service__c(csord__Subscription__c = sub.Id,
                                                            csord__Identification__c = 'legacytwo',
                                                            csordtelcoa__Product_Configuration__c = prodConfLegacy.Id,
                                                            LG_DecompositionCriteria__c = decCrit3,
                                                            LG_RootOrder__c = orders.values()[0].Id);
        insert legacyTwo;
        csord__Service__c Child1 = new csord__Service__c(csord__Subscription__c = sub.Id,
                                                    csord__Identification__c = 'Child1',
                                                    csord__Service__c = legacyTwo.Id,
                                                    LG_RootOrder__c = orders.values()[0].Id);
        insert Child1;

        csord__Service__c Child2 = new csord__Service__c(csord__Subscription__c = sub.Id,
                                                    csord__Identification__c = 'Child2',
                                                    csord__Service__c = legacyTwo.Id,
                                                    LG_RootOrder__c = orders.values()[0].Id);
        insert Child2;

        csord__Service__c subChild2 = new csord__Service__c(csord__Subscription__c = sub.Id,
                                                    csord__Identification__c = 'subChild2',
                                                    csord__Service__c = Child1.Id,
                                                    LG_RootOrder__c = orders.values()[0].Id);
        insert subChild2;
        //SFOM-403 insert service line items with price
        list<csord__Service_Line_Item__c> serviceLinse = new list<csord__Service_Line_Item__c>();
        csord__Service_Line_Item__c sliOne = new csord__Service_Line_Item__c (Name = 'SliOne', csord__Service__c = legacyOne.Id, csord__Identification__c = 'SliOne', csord__Total_Price__c = 10.00, csord__Is_Recurring__c = true);
        serviceLinse.add(sliOne);

        csord__Service_Line_Item__c SliTwo = new csord__Service_Line_Item__c (Name = 'SliTwo', csord__Service__c = legacyTwo.Id, csord__Identification__c = 'SliTwo', csord__Total_Price__c = 20.00, csord__Is_Recurring__c = false);
        serviceLinse.add(SliTwo);
        insert serviceLinse;

        List<csord__Service__c> services = [SELECT Id, LG_DecompositionCriteria__c, csord__Identification__c
                                            FROM csord__Service__c WHERE csord__Identification__c
                                            IN ('serviceDC1One', 'serviceDC1Two', 'serviceDC2One',
                                                'serviceDC1Ord2One', 'serviceDC2Ord2One', 'serviceDC2Ord2Two')];

        for (csord__Service__c service : services) {
            if (service.csord__Identification__c == 'serviceDC1One'
                || service.csord__Identification__c == 'serviceDC1Two'
                || service.csord__Identification__c == 'serviceDC1Ord2One') {
                service.LG_DecompositionCriteria__c = decCrit1;
            } else
            {
                service.LG_DecompositionCriteria__c = decCrit2;
            }
        }

        update services;

        noTriggers.Flag__c = false;
        upsert noTriggers;

        Test.startTest();

        LG_DecomposeOrderUtil decomposeUtil = new LG_DecomposeOrderUtil(new List<Id>(orders.keySet()));
        decomposeUtil.startOrderDecomposition();

        Test.stopTest();
        //SFOM-403
        List<csord__Solution__c> solutionsUpdated = [SELECT Id, LG_DecompositionCriteria__c, LG_Total_One_off__c, LG_Total_Recurring__c,LG_Total_Suborder_Value__c FROM csord__Solution__c WHERE csord__Order__r.csord__Identification__c = 'IdentOrd1' AND LG_DecompositionCriteria__c = :decCrit3];
        system.debug('solutionsUpdated :'+solutionsUpdated);


        //Five solutions should have been created
        //and 7 processes  - 1 for each order and 1 for each solution
        List<csord__Solution__c> solutions = [SELECT Id, csord__Status__c FROM csord__Solution__c];
        System.assertEquals(6, solutions.size(), 'Six solutions should have been created');

        /*
         * Enforce Solutions state model - In Progress, Complete, Cancelled
         *
         * @author Petar Miletić
         * @ticket SFOM-571
         * @since  03/04/2017
         */
         
        
        for (csord__Solution__c obj: solutions) {
            System.assertEquals('In Progress', obj.csord__Status__c, 'Invalid data');
        }


        List<CSPOFA__Orchestration_Process__c> processes = [SELECT Id, LG_Order__c, LG_Solution__c FROM CSPOFA__Orchestration_Process__c];
        System.assertEquals(8, processes.size(), 'Eight processes should have been created');

        Integer order    = 0;
        Integer solution = 0;
        for (CSPOFA__Orchestration_Process__c process : processes) {
            if (process.LG_Solution__c != null) {
                solution++;
            }
            if (process.LG_Order__c != null && process.LG_Solution__c == null) {
                order++;
            }
        }
        System.assertEquals(2, order, 'Two processes related to orders should have been created');
        System.assertEquals(6, solution, 'Five processes related to solutions should have been created');

        /*
         * Resolves Service Statuses
         *
         * @param  csord__Service__c service
         * @author Petar Miletić
         * @ticket SFOM-131
         * @since  19/01/2017
         */
         
        
        csord__Service__c serviceDC1One     = [SELECT LG_Activationneeded__c, LG_InstallationNeeded__c FROM csord__Service__c WHERE csord__Identification__c = 'serviceDC1One' LIMIT 1];
        csord__Service__c serviceDC1Two     = [SELECT LG_Activationneeded__c, LG_InstallationNeeded__c FROM csord__Service__c WHERE csord__Identification__c = 'serviceDC1Two' LIMIT 1];
        csord__Service__c serviceDC2One     = [SELECT LG_Activationneeded__c, LG_InstallationNeeded__c FROM csord__Service__c WHERE csord__Identification__c = 'serviceDC2One' LIMIT 1];
        csord__Service__c serviceDC1Ord2One = [SELECT LG_Activationneeded__c, LG_InstallationNeeded__c FROM csord__Service__c WHERE csord__Identification__c = 'serviceDC1Ord2One' LIMIT 1];

        // Delta: Added To Subscription
        System.assertEquals(true, serviceDC1One.LG_Activationneeded__c, 'Invalid data');
        System.assertEquals(false, serviceDC1One.LG_InstallationNeeded__c, 'Invalid data');

        // Delta: Continuing In Subscription
        System.assertEquals(true, serviceDC1Two.LG_Activationneeded__c, 'Invalid data');
        System.assertEquals(false, serviceDC1Two.LG_InstallationNeeded__c, 'Invalid data');

        // Delta: Deleted From Subscription
        System.assertEquals(true, serviceDC2One.LG_Activationneeded__c, 'Invalid data');
        System.assertEquals(false, serviceDC2One.LG_InstallationNeeded__c, 'Invalid data');

        // Delta: Added To Subscription, but it defaults to Y,Y,Y becouse Product Definition data is null or empty
        System.assertEquals(true, serviceDC1Ord2One.LG_Activationneeded__c, 'Invalid data');
        System.assertEquals(true, serviceDC1Ord2One.LG_InstallationNeeded__c, 'Invalid data');


        // ProdConf58 - linked to Product definition that is Y,Y,Y and N,N,N
        // ProdConfEmpty - linked to Product definition that is empty so it defaults to Y,Y,Y in both cases
        List<csord__Service__c> serviceList = [SELECT Id, Name,
                                               LG_Suborder__c,
                                               LG_Suborder__r.Name,
                                               LG_Activationneeded__c,
                                               LG_InstallationNeeded__c,
                                               LG_Suborder__r.LG_ActivationNeeded__c,
                                               LG_Suborder__r.LG_InstallationNeeded__c,
                                               csordtelcoa__Product_Configuration__r.Name
                                               FROM csord__Service__c
                                               WHERE csord__Identification__c != 'TestTelServ'
                                               AND csord__Identification__c != 'TestNmbrServ'];

        // Test if solution is updated correctly
        for (csord__Service__c obj : serviceList) {

            if (obj.csordtelcoa__Product_Configuration__r.Name == 'ProdConf58') {

                // ProdConf58 - linked to Product definition that is Y,Y,Y and N,N,N
                System.assertEquals(true, obj.LG_Suborder__r.LG_Activationneeded__c, 'Invalid data');
                System.assertEquals(false, obj.LG_Suborder__r.LG_InstallationNeeded__c, 'Invalid data');

            } else {

                // ProdConfEmpty - linked to Product definition that is empty so it defaults to Y,Y,Y in both cases
                System.assertEquals(true, obj.LG_Suborder__r.LG_Activationneeded__c, 'Invalid data');
                System.assertEquals(true, obj.LG_Suborder__r.LG_InstallationNeeded__c, 'Invalid data');
            }
        }
    }


    private static testmethod void testRelateNumberAssets()
    {
        csord__Service__c telService = [SELECT Id, LG_ProductDefinitionName__c, csordtelcoa__Product_Configuration__c
                                        FROM csord__Service__c WHERE LG_ProductDefinitionName__c = 'Telephony'];
        csord__Service__c numberRangeService = [SELECT Id, LG_ProductDefinitionName__c, csordtelcoa__Product_Configuration__c
                                                FROM csord__Service__c WHERE LG_ProductDefinitionName__c = 'Number Range'];

        List<Id> services = new List<Id>();
        services.add(numberRangeService.Id);

        List<Asset> assets = [SELECT Id, LG_NumberRangeService__c, LG_TelephonyService__c FROM Asset];

        for (Asset asset : assets) {
            System.assertEquals(null, asset.LG_NumberRangeService__c, 'Asset service lookup should be blank');
            System.assertEquals(null, asset.LG_TelephonyService__c, 'Asset service lookup should be blank');
        }

        Test.startTest();
        LG_DecomposeOrderUtil.relateNumberAssets(services);
        Test.stopTest();

        assets = [SELECT Id, LG_NumberRangeService__c, LG_TelephonyService__c FROM Asset];

        for (Asset asset : assets) {
            System.assertEquals(telService.Id, asset.LG_TelephonyService__c, 'Telephony Service lookup should be populated');
            System.assertEquals(numberRangeService.Id, asset.LG_NumberRangeService__c, 'Number Range Service lookup should be populated');
        }
    }


    private static testmethod void testRelateOldSolution()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        csord__Order__c order  = new csord__Order__c(csord__Identification__c = 'order1');
        csord__Order__c order2 = new csord__Order__c(csord__Identification__c = 'order2');
        csord__Order__c order3 = new csord__Order__c(csord__Identification__c = 'order3');
        csord__Order__c order4 = new csord__Order__c(csord__Identification__c = 'order4');
        List<csord__Order__c> orders = new List<csord__Order__c>();
        orders.add(order);
        orders.add(order2);
        orders.add(order3);
        orders.add(order4);
        insert orders;

        cscrm__Address__c address1 = new cscrm__Address__c(cscrm__Street__c = 'TestStreet');
        insert address1;
        cscrm__Address__c address2 = new cscrm__Address__c(cscrm__Street__c = 'TestStreet2');
        insert address2;

        Date newDate        = Date.today();
        Date newDatePlusTwo = newDate.addDays(2);

        String decCrit1;
        String decCrit2;

        Schema.DescribeFieldResult fieldResult =
            csord__Service__c.LG_DecompositionCriteria__c.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        decCrit1                       = ple[0].getValue();
        decCrit2                       = ple[1].getValue();

        csord__Solution__c solution = new csord__Solution__c(csord__Order__c = order.Id, csord__Identification__c = 'identSol1',
                                                             LG_DecompositionCriteria__c = decCrit1, LG_InstallationWishDate__c = newDate, LG_Address__c = address1.Id);

        csord__Solution__c solutionDifferentDate = new csord__Solution__c(csord__Order__c = order3.Id, csord__Identification__c = 'identSol2',
                                                                          LG_DecompositionCriteria__c = decCrit2, LG_InstallationWishDate__c = newDatePlusTwo, LG_Address__c = address2.Id);


        List<csord__Solution__c> solutions = new List<csord__Solution__c>();
        solutions.add(solution);
        solutions.add(solutionDifferentDate);
        insert solutions;

        csord__Subscription__c subOld         = new csord__Subscription__c(csord__Identification__c = 'IdentOldSub');
        csord__Subscription__c sub            = new csord__Subscription__c(csord__Identification__c = 'IdentSub');
        csord__Subscription__c subOldDiffDate = new csord__Subscription__c(csord__Identification__c = 'IdentOldSubDiffDate');
        csord__Subscription__c subDiffDate    = new csord__Subscription__c(csord__Identification__c = 'IdentDiffDate');
        List<csord__Subscription__c> subs = new List<csord__Subscription__c>();
        subs.add(subOld);
        subs.add(sub);
        subs.add(subOldDiffDate);
        subs.add(subDiffDate);
        insert subs;

        csord__Service__c serviceOld1 = new csord__Service__c(LG_RootOrder__c = order.Id, csord__Subscription__c = subOld.Id, LG_Suborder__c = solution.Id, csord__Identification__c = 'TestServOld1',
                                                              LG_DecompositionCriteria__c = decCrit1, LG_InstallationWishDate__c = newDate, LG_Address__c = address1.Id);
        csord__Service__c service1 = new csord__Service__c(LG_RootOrder__c = order2.Id, csord__Subscription__c = sub.Id, csord__Identification__c = 'TestServ1', LG_DecompositionCriteria__c = decCrit1,
                                                           LG_InstallationWishDate__c = newDate, LG_Address__c = address1.Id);

        csord__Service__c serviceOldDiffDate = new csord__Service__c(LG_RootOrder__c = order3.Id, csord__Subscription__c = subOldDiffDate.Id, LG_Suborder__c = solutionDifferentDate.Id,
                                                                     csord__Identification__c = 'TestServOldDiff1', LG_DecompositionCriteria__c = decCrit2, LG_InstallationWishDate__c = newDatePlusTwo, LG_Address__c = address2.Id);
        csord__Service__c serviceDiffDate = new csord__Service__c(LG_RootOrder__c = order4.Id, csord__Subscription__c = subDiffDate.Id, csord__Identification__c = 'TestServ1DiffDate', LG_DecompositionCriteria__c = decCrit2,
                                                                  LG_InstallationWishDate__c = newDate, LG_Address__c = address2.Id);

        List<csord__Service__c> services = new List<csord__Service__c>();
        services.add(service1);
        services.add(serviceOld1);
        services.add(serviceOldDiffDate);
        services.add(serviceDiffDate);
        insert services;

        service1.csordtelcoa__Replaced_Service__c              = serviceOld1.Id;
        serviceOld1.csordtelcoa__Replacement_Service__c        = service1.Id;
        serviceDiffDate.csordtelcoa__Replaced_Service__c       = serviceOldDiffDate.Id;
        serviceOldDiffDate.csordtelcoa__Replacement_Service__c = serviceDiffDate.Id;
        update services;

        noTriggers.Flag__c = false;
        upsert noTriggers;

        List<Id> orderIds = new List<Id>();
        orderIds.add(order2.Id);
        orderIds.add(order4.Id);

        Test.startTest();
        LG_DecomposeOrderUtil util = new LG_DecomposeOrderUtil(orderIds);
        util.startOrderDecomposition();
        Test.stopTest();

        services = [SELECT Id, csord__Identification__c, LG_Suborder__r.LG_OldSuborder__c FROM csord__Service__c
                    WHERE csord__Identification__c = 'TestServ1' OR csord__Identification__c = 'TestServ1DiffDate'];

        for (csord__Service__c service : services) {
            if (service.csord__Identification__c == 'TestServ1') {
                System.assertEquals(solution.Id, service.LG_Suborder__r.LG_OldSuborder__c, 'Old suborder should be set');
            }   else if (service.csord__Identification__c == 'TestServ1DiffDate') {
                System.assertEquals(solutionDifferentDate.Id, service.LG_Suborder__r.LG_OldSuborder__c, 'Old suborder should be set');
            }
        }
    }

    private static testmethod void startOrderDecompositionTermination()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        Opportunity opp = [SELECT Id FROM Opportunity];

        csord__Order__c oldOrder = new csord__Order__c(csord__Identification__c = 'IdentOldOrde');
        insert oldOrder;

        csord__Order__c newOrder = new csord__Order__c(csord__Identification__c = 'IdentNewOrder');
        insert newOrder;

        cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'TestBasket'];
        basket.cscfga__Opportunity__c = opp.Id;
        update basket;

        String decCrit1;
        String decCrit2;

        Schema.DescribeFieldResult fieldResult =
            csord__Service__c.LG_DecompositionCriteria__c.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        decCrit1                       = ple[0].getValue();
        decCrit2                       = ple[1].getValue();


        cscfga__Product_Definition__c prodDefTerm       = LG_GeneralTest.createProductDefinition('Termination', false);
        prodDefTerm.LG_ProductSubtype__c = 'Termination';
        insert prodDefTerm;
        cscfga__Product_Definition__c prodDefPenaltyFee = LG_GeneralTest.createProductDefinition('Penalty Fee', false);
        prodDefPenaltyFee.LG_ProductSubtype__c = 'Penalty Fee';
        insert prodDefPenaltyFee;
        cscfga__Product_Definition__c prodDefOld        = LG_GeneralTest.createProductDefinition('ProdDefOld', true);

        cscfga__Product_Configuration__c prodConfigOld  = LG_GeneralTest.createProductConfiguration('Old Service', 3, basket, prodDefOld, true);
        cscfga__Product_Configuration__c prodConfigTerm = LG_GeneralTest.createProductConfiguration('Termination For Old', 3, basket, prodDefTerm, true);
        cscfga__Product_Configuration__c prodConfigPFee = LG_GeneralTest.createProductConfiguration('Penalty Fee', 3, basket, prodDefPenaltyFee, true);

         Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);

        csconta__Billing_Account__c bAcc= new csconta__Billing_Account__c(csconta__Account__c= account.ID, csconta__Status__c='New', LG_ContractualOrganization__c='Hessen (HSN)', csconta__Billing_Channel__c='Paper', UM_BillFormatOptions__c='Summary');
    	insert bAcc;

        csord__Subscription__c oldSub = new csord__Subscription__c(csord__Identification__c = 'OldSub',csconta__Billing_Account__c=bAcc.id);
        insert oldSub;

        csord__Subscription__c newSub = new csord__Subscription__c(csord__Identification__c = 'newSub',csconta__Billing_Account__c=bAcc.id);
        insert newSub;

        csord__Subscription__c pFeeSub = new csord__Subscription__c(csord__Identification__c = 'pFeeSub',csconta__Billing_Account__c=bAcc.id);
        insert pFeeSub;

        List<csordtelcoa__Subscr_MACDProductBasket_Association__c> subBasketRelations
            = new List<csordtelcoa__Subscr_MACDProductBasket_Association__c>();
        subBasketRelations.add(new csordtelcoa__Subscr_MACDProductBasket_Association__c(csordtelcoa__Subscription__c = oldSub.Id, LG_DeactivationWishDate__c = Date.today(),
                                                                                        csordtelcoa__Product_Basket__c = basket.Id));
        insert subBasketRelations;

        cscrm__Address__c address = [SELECT Id FROM cscrm__Address__c LIMIT 1];

        List<csord__Service__c> services = new List<csord__Service__c>();
        csord__Service__c oldService = new csord__Service__c(csord__Subscription__c = oldSub.Id,
                                                             csord__Identification__c = 'oldService',
                                                             csordtelcoa__Product_Configuration__c = prodConfigOld.Id, LG_Address__c = address.Id,
                                                             LG_RootOrder__c = oldOrder.Id, LG_DecompositionCriteria__c = decCrit1);
        csord__Service__c newService = new csord__Service__c(csord__Subscription__c = newSub.Id, LG_TerminatedSubscription__c = oldSub.Id,
                                                             csord__Identification__c = 'newService', LG_InstallationWishDate__c = Date.today(),
                                                             csordtelcoa__Product_Configuration__c = prodConfigTerm.Id, LG_Address__c = address.Id,
                                                             LG_RootOrder__c = newOrder.Id, LG_DecompositionCriteria__c = decCrit1);
        csord__Service__c pFeeService = new csord__Service__c(csord__Subscription__c = pFeeSub.Id,
                                                              csord__Identification__c = 'pFeeService',
                                                              csordtelcoa__Product_Configuration__c = prodConfigPFee.Id,
                                                              LG_RootOrder__c = newOrder.Id, LG_DecompositionCriteria__c = decCrit1);
        services.add(oldService);
        services.add(newService);
        services.add(pFeeService);
        insert services;

        csord__Service_Line_Item__c sli = new csord__Service_Line_Item__c (Name = 'feeSli', csord__Service__c = pFeeService.Id, csord__Identification__c = 'feeSli');
        insert sli;

        pFeeService.LG_TerminatedService__c = oldService.Id;
        update pFeeService;

        noTriggers.Flag__c = false;
        upsert noTriggers;

        Test.startTest();

        List<Id> orderIds = new List<Id>();
        orderIds.add(newOrder.Id);

        LG_DecomposeOrderUtil decomposeUtil = new LG_DecomposeOrderUtil(orderIds);
        decomposeUtil.startOrderDecomposition();

        Test.stopTest();

        List<csord__Solution__c> solutions = [SELECT Id, csord__Status__c, Name FROM csord__Solution__c];

        //System.assertEquals(1, solutions.size(), 'One solution should be created'+ solutions);

        List<CSPOFA__Orchestration_Process__c> processes = [SELECT Id, LG_Order__c, LG_Solution__c FROM CSPOFA__Orchestration_Process__c];
        //System.assertEquals(2, processes.size(), 'Two processes should have been created');

        Integer order    = 0;
        Integer solution = 0;
        for (CSPOFA__Orchestration_Process__c process : processes) {
            if (process.LG_Solution__c != null) {
                solution++;
            }
            if (process.LG_Order__c != null && process.LG_Solution__c == null) {
                order++;
            }
        }
        /**
        System.assertEquals(1, order, 'One process related to order should have been created');
        System.assertEquals(1, solution, 'One process related to solution should have been created');

        oldService = [SELECT Id, LG_Suborder__c FROM csord__Service__c WHERE csord__Identification__c = 'oldService'];
        System.assertEquals(solutions[0].Id, oldService.LG_Suborder__c, 'Old Service should be reparented to new solution');

        sli = [SELECT Id, csord__Service__c FROM csord__Service_Line_Item__c WHERE Name = 'feeSli'];
        System.assertEquals(oldService.Id, sli.csord__Service__c, 'Penalty Fee SLI should have been reparented to old Service');

        List<csord__Subscription__c> subsDeleted = [SELECT Id FROM csord__Subscription__c WHERE csord__Identification__c = 'newSub' OR csord__Identification__c = 'pFeeSub'];
        System.assertEquals(true, subsDeleted.isEmpty(), 'Termination product and penalty fee product subscriptions should be deleted');

        List<csord__Service__c> servicesDeleted = [SELECT Id FROM csord__Service__c WHERE csord__Identification__c = 'newService' OR csord__Identification__c = 'pFeeService'];
        System.assertEquals(true, servicesDeleted.isEmpty(), 'Termination product and penalty fee product services should be deleted');
        **/
    }

    private static testmethod void testDecompositionMigrateOrder()
    {
        cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c];

        Map<Id, csord__Order__c> orders = new Map<Id, csord__Order__c>([SELECT Id FROM csord__Order__c
                                                                        WHERE csord__Identification__c IN ('IdentOrd1', 'IdentOrd2')]);

        String decCrit1;
        String decCrit2;
        String decCrit3;

        Schema.DescribeFieldResult fieldResult =
            csord__Service__c.LG_DecompositionCriteria__c.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        decCrit1                       = ple[0].getValue();
        decCrit2                       = ple[1].getValue();
        decCrit3                       = ple[2].getValue();

        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        cscfga__Product_Definition__c prodDefLegacy = LG_GeneralTest.createProductDefinition('Legacy', true);

        cscfga__Product_Configuration__c prodConfLegacy = LG_GeneralTest.createProductConfiguration('Legacy', 3, basket, prodDefLegacy, true);

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'IdentSub', csordtelcoa__Change_Type__c = 'Migrate');
        insert sub;

        //LG_OrderDecompositionSettings__c decompSettings = LG_OrderDecompositionSettings__c.getAll().get('VM');
        //decompSettings.LG_LegacyDecompositionCriteria__c = decCrit3;
        //update decompSettings;

        csord__Service__c legacyOne = new csord__Service__c(csord__Subscription__c = sub.Id,
                                                            csord__Identification__c = 'legacyone',
                                                            csordtelcoa__Product_Configuration__c = prodConfLegacy.Id,
                                                            LG_DecompositionCriteria__c = decCrit3,
                                                            LG_RootOrder__c = orders.values()[0].Id);
        insert legacyOne;
        csord__Service__c legacyTwo = new csord__Service__c(csord__Subscription__c = sub.Id,
                                                            csord__Identification__c = 'legacytwo',
                                                            csordtelcoa__Product_Configuration__c = prodConfLegacy.Id,
                                                            LG_DecompositionCriteria__c = decCrit3,
                                                            LG_RootOrder__c = orders.values()[0].Id);
        insert legacyTwo;
        List<csord__Service__c> services = [SELECT Id, LG_DecompositionCriteria__c, csord__Identification__c
                                            FROM csord__Service__c WHERE csord__Identification__c
                                            IN ('serviceDC1One', 'serviceDC1Two', 'serviceDC2One',
                                                'serviceDC1Ord2One', 'serviceDC2Ord2One', 'serviceDC2Ord2Two')];

        for (csord__Service__c service : services) {
            if (service.csord__Identification__c == 'serviceDC1One'
                || service.csord__Identification__c == 'serviceDC1Two'
                || service.csord__Identification__c == 'serviceDC1Ord2One') {
                service.LG_DecompositionCriteria__c = decCrit1;
            } else
            {
                service.LG_DecompositionCriteria__c = decCrit2;
            }
        }

        update services;

        noTriggers.Flag__c = false;
        upsert noTriggers;

        Test.startTest();

        LG_DecomposeOrderUtil decomposeUtil = new LG_DecomposeOrderUtil(new List<Id>(orders.keySet()));
        decomposeUtil.startOrderDecomposition();

        Test.stopTest();

        csord__Order__c order = [SELECT Id, LG_WaitForNewProvide__c FROM csord__Order__c WHERE Id = :orders.values()[0].Id];
        System.assertEquals(true, order.LG_WaitForNewProvide__c, 'Wait for New Provide flag should be set to true.');
    }

    private static testmethod void startOrderDecompositionMigrate()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        Opportunity opp = [SELECT Id FROM Opportunity];
        opp.csordtelcoa__Change_Type__c = 'Migrate';
        update opp;

        csord__Order__c oldOrder = new csord__Order__c(csord__Identification__c = 'IdentOldOrde');
        insert oldOrder;

        csord__Order__c newOrder = new csord__Order__c(csord__Identification__c = 'IdentNewOrder', csordtelcoa__Opportunity__c = opp.Id);
        insert newOrder;

        cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'TestBasket'];
        basket.cscfga__Opportunity__c = opp.Id;
        update basket;

        String decCrit1;
        String decCrit2;

        Schema.DescribeFieldResult fieldResult =
            csord__Service__c.LG_DecompositionCriteria__c.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        decCrit1                       = ple[0].getValue();
        decCrit2                       = ple[1].getValue();


        cscfga__Product_Definition__c prodDefOldMigrate = LG_GeneralTest.createProductDefinition('ProdDefOldMigrate', true);
        cscfga__Product_Definition__c prodDefChange     = LG_GeneralTest.createProductDefinition('ProdDefOldChange', true);

        cscfga__Product_Configuration__c prodConfigMigrate   = LG_GeneralTest.createProductConfiguration('Old Service for Migrate', 3, basket, prodDefOldMigrate, true);
        cscfga__Product_Configuration__c prodConfigChange    = LG_GeneralTest.createProductConfiguration('Old Service for Change', 3, basket, prodDefChange, true);
        cscfga__Product_Configuration__c prodConfigNewChange = LG_GeneralTest.createProductConfiguration('New for Change', 3, basket, prodDefChange, true);

        csord__Subscription__c oldSub = new csord__Subscription__c(csord__Identification__c = 'OldSub');
        insert oldSub;

        csord__Subscription__c newSub = new csord__Subscription__c(csord__Identification__c = 'newSub');
        insert newSub;

        List<csordtelcoa__Subscr_MACDProductBasket_Association__c> subBasketRelations
            = new List<csordtelcoa__Subscr_MACDProductBasket_Association__c>();
        subBasketRelations.add(new csordtelcoa__Subscr_MACDProductBasket_Association__c(csordtelcoa__Subscription__c = oldSub.Id, LG_DeactivationWishDate__c = Date.today(),
                                                                                        csordtelcoa__Product_Basket__c = basket.Id));
        insert subBasketRelations;

        cscrm__Address__c address = [SELECT Id FROM cscrm__Address__c LIMIT 1];

        List<csord__Service__c> services = new List<csord__Service__c>();
        csord__Service__c oldServiceMigrate = new csord__Service__c(csord__Subscription__c = oldSub.Id,
                                                                    csord__Identification__c = 'oldServiceMigrate',
                                                                    csordtelcoa__Product_Configuration__c = prodConfigMigrate.Id, LG_Address__c = address.Id,
                                                                    LG_RootOrder__c = oldOrder.Id, LG_DecompositionCriteria__c = decCrit1);
        csord__Service__c oldServiceChange = new csord__Service__c(csord__Subscription__c = oldSub.Id,
                                                                   csord__Identification__c = 'oldServiceChange',
                                                                   csordtelcoa__Product_Configuration__c = prodConfigChange.Id, LG_Address__c = address.Id,
                                                                   LG_RootOrder__c = oldOrder.Id, LG_DecompositionCriteria__c = decCrit1);
        csord__Service__c newService = new csord__Service__c(csord__Subscription__c = newSub.Id, LG_TerminatedSubscription__c = oldSub.Id,
                                                             csord__Identification__c = 'newServiceChange', LG_InstallationWishDate__c = Date.today(),
                                                             csordtelcoa__Product_Configuration__c = prodConfigChange.Id, LG_Address__c = address.Id,
                                                             LG_RootOrder__c = newOrder.Id, LG_DecompositionCriteria__c = decCrit1);
        services.add(oldServiceMigrate);
        services.add(newService);
        services.add(oldServiceChange);
        insert services;

        newService.csordtelcoa__Replaced_Service__c = oldServiceChange.Id;
        update newService;

        noTriggers.Flag__c = false;
        upsert noTriggers;

        Test.startTest();

        List<Id> orderIds = new List<Id>();
        orderIds.add(newOrder.Id);

        LG_DecomposeOrderUtil decomposeUtil = new LG_DecomposeOrderUtil(orderIds);
        decomposeUtil.startOrderDecomposition();

        Test.stopTest();

        List<csord__Solution__c> solutions = [SELECT Id, csord__Status__c, Name FROM csord__Solution__c];

        System.assertEquals(1, solutions.size(), 'One solution should be created'+ solutions);

        List<CSPOFA__Orchestration_Process__c> processes = [SELECT Id, LG_Order__c, LG_Solution__c FROM CSPOFA__Orchestration_Process__c];
        System.assertEquals(2, processes.size(), 'Two processes should have been created');

        Integer order    = 0;
        Integer solution = 0;
        for (CSPOFA__Orchestration_Process__c process : processes) {
            if (process.LG_Solution__c != null) {
                solution++;
            }
            if (process.LG_Order__c != null && process.LG_Solution__c == null) {
                order++;
            }
        }
        System.assertEquals(1, order, 'One process related to order should have been created');
        System.assertEquals(1, solution, 'One process related to solution should have been created');

        oldServiceMigrate = [SELECT Id, LG_Suborder__c FROM csord__Service__c WHERE csord__Identification__c = 'oldServiceMigrate'];
        System.assertEquals(solutions[0].Id, oldServiceMigrate.LG_Suborder__c, 'Old Service should be reparented to new solution');
    }

    private static testmethod void startOrderDecompositionUM()
    {

        csord__Order__c order = [SELECT Id FROM csord__Order__c  WHERE csord__Identification__c = 'IdentOrd1'];
        Set<Id> orderSet = new Set<Id>();
        orderSet.add(order.Id);
        List<cscrm__Address__c> addresses = [SELECT Id FROM cscrm__Address__c WHERE Name IN ('AddressOne','AddressTwo')];

        String decCrit5;
        String decCrit6;
        String decCrit7;
        String decCrit8;

        Schema.DescribeFieldResult fieldResult =
        csord__Service__c.LG_DecompositionCriteria__c.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        decCrit5                       = ple[4].getValue(); //No Grouping
        decCrit6                       = ple[5].getValue(); //Dependent Service
        decCrit7                       = ple[6].getValue(); //All Together
        decCrit8                       = ple[7].getValue(); //Per Site

        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c];
        cscfga__Product_Definition__c ProdDefTest        = LG_GeneralTest.createProductDefinition('ProdDefTest', true);
        cscfga__Product_Configuration__c prodConfig  = LG_GeneralTest.createProductConfiguration('Test Service', 3, basket, ProdDefTest, true);

        cscfga__Product_Definition__c ProdDefTest2        = LG_GeneralTest.createProductDefinition('ProdDefTest', true);
        cscfga__Product_Configuration__c prodConfig2  = LG_GeneralTest.createProductConfiguration('Test Service', 3, basket, ProdDefTest2, true);
        cscfga__Product_Definition__c ProdDefTest3        = LG_GeneralTest.createProductDefinition('ProdDefTest', true);
        cscfga__Product_Configuration__c prodConfig3  = LG_GeneralTest.createProductConfiguration('Test Service', 3, basket, ProdDefTest3, true);
     	cscfga__Product_Definition__c ProdDefTest4        = LG_GeneralTest.createProductDefinition('ProdDefTest4', true);
        cscfga__Product_Configuration__c prodConfig4  = LG_GeneralTest.createProductConfiguration('Test Service', 3, basket, ProdDefTest4, true);

        List<csord__Service__c> services = [SELECT Id, LG_DecompositionCriteria__c, csord__Identification__c
                                            FROM csord__Service__c WHERE LG_RootOrder__c = :order.Id];

        List<csord__Service__c> serviceList = new List<csord__Service__c>();
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'IdentSubDepends');
        insert sub;
        csord__Service__c accessService = new csord__Service__c(csord__Subscription__c = sub.Id,
                                                            csord__Identification__c = 'accessService',
                                                            csordtelcoa__Product_Configuration__c = prodConfig.Id ,
                                                            LG_DecompositionCriteria__c = decCrit5,
                                                            LG_RootOrder__c = order.Id);
        insert accessService;

        csord__Service__c service2 = new csord__Service__c(csord__Subscription__c = sub.Id,
                                                            csord__Identification__c = 'Identservice2',
                                                            csordtelcoa__Product_Configuration__c = prodConfig2.Id ,
                                                            LG_DecompositionCriteria__c = decCrit5,
                                                            LG_RootOrder__c = order.Id);
        csord__Service__c service3 = new csord__Service__c(csord__Subscription__c = sub.Id,
                                                            csord__Identification__c = 'Identservice3',
                                                            csordtelcoa__Product_Configuration__c = prodConfig3.Id ,
                                                            LG_DecompositionCriteria__c = decCrit5,
                                                            LG_RootOrder__c = order.Id);
         csord__Service__c service4 = new csord__Service__c(csord__Subscription__c = sub.Id,
                                                            csord__Identification__c = 'Identservice4',
                                                            csordtelcoa__Product_Configuration__c = prodConfig4.Id ,
                                                            LG_DecompositionCriteria__c = decCrit8,
                                                            LG_Address__c = addresses.get(0).Id,
                                                            LG_RootOrder__c = order.Id);
         csord__Service__c service5 = new csord__Service__c(csord__Subscription__c = sub.Id,
                                                            csord__Identification__c = 'Identservice4',
                                                            csordtelcoa__Product_Configuration__c = prodConfig4.Id ,
                                                            LG_DecompositionCriteria__c = decCrit8,
                                                            LG_Address__c = addresses.get(1).Id,
                                                            LG_RootOrder__c = order.Id);

        serviceList.add(service2);
        serviceList.add(service3);
        serviceList.add(service4);
        serviceList.add(service5);
        insert serviceList;
        for (csord__Service__c service : services) {
            if (service.csord__Identification__c == 'serviceDC1One' || service.csord__Identification__c == 'serviceDC1Two') {
                service.LG_DecompositionCriteria__c = decCrit7;
            }

            if (service.csord__Identification__c == 'serviceDC2One' ) {
                service.UM_DependsOnService__c = accessService.Id;
                service.LG_DecompositionCriteria__c = decCrit6;
            }


        }

        update services;

        noTriggers.Flag__c = false;
        upsert noTriggers;

        Test.startTest();

        LG_DecomposeOrderUtil decomposeUtil = new LG_DecomposeOrderUtil(new List<Id>(orderSet));
        decomposeUtil.startOrderDecomposition();

        Test.stopTest();

        List<csord__Solution__c> solutionsNoGrouping = [SELECT Id, csord__Status__c FROM csord__Solution__c WHERE LG_DecompositionCriteria__c = :decCrit5];
        System.assertEquals(3, solutionsNoGrouping.size(), '3 solutions should have been created for NoGrouping');
        
        //List<csord__Solution__c> solutionsDepedent = [SELECT Id, csord__Status__c FROM csord__Solution__c WHERE LG_DecompositionCriteria__c = :decCrit6];
        //System.debug('>>>>sdsize1111>>>>'+solutionsDepedent.size());
        //System.assertEquals(1, solutionsDepedent.size(), '1 solutions should have been created for Depedent');
        
        List<csord__Solution__c> solutionsAllTogether = [SELECT Id, csord__Status__c FROM csord__Solution__c WHERE LG_DecompositionCriteria__c = :decCrit7];
        System.debug('>>>>sATGSize1111>>>>'+solutionsAllTogether.size());
        System.assertEquals(1, solutionsAllTogether.size(), '2 solutions should have been created for AllTogether');
        
        List<csord__Solution__c> solutionsPerSiteOnly = [SELECT Id, csord__Status__c FROM csord__Solution__c WHERE LG_DecompositionCriteria__c = :decCrit8];
        System.assertEquals(2, solutionsPerSiteOnly.size(), '2 solutions should have been created for HPBX');
    }


    private static testmethod void testUpdateProvisioningChange()
    {

        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        Opportunity opp = [SELECT Id FROM Opportunity];
        opp.csordtelcoa__Change_Type__c = 'Change';
        update opp;

        csord__Order__c oldOrder = new csord__Order__c(csord__Identification__c = 'IdentOldOrde');
        insert oldOrder;

        csord__Order__c newOrder = new csord__Order__c(csord__Identification__c = 'IdentNewOrder', csordtelcoa__Opportunity__c = opp.Id);
        insert newOrder;

        cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'TestBasket'];
        basket.cscfga__Opportunity__c = opp.Id;
        update basket;

        String decCrit1;
        String decCrit2;

        Schema.DescribeFieldResult fieldResult =
            csord__Service__c.LG_DecompositionCriteria__c.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        decCrit1                       = ple[0].getValue();
        decCrit2                       = ple[1].getValue();


        cscfga__Product_Definition__c prodDefOldMigrate = LG_GeneralTest.createProductDefinition('ProdDefOldMigrate', true);
        cscfga__Product_Definition__c prodDefChange     = LG_GeneralTest.createProductDefinition('ProdDefOldChange', true);

        cscfga__Product_Configuration__c prodConfigMigrate   = LG_GeneralTest.createProductConfiguration('Old Service for Migrate', 3, basket, prodDefOldMigrate, true);
        cscfga__Product_Configuration__c prodConfigChange    = LG_GeneralTest.createProductConfiguration('Old Service for Change', 3, basket, prodDefChange, true);
        cscfga__Product_Configuration__c prodConfigNewChange = LG_GeneralTest.createProductConfiguration('New for Change', 3, basket, prodDefChange, true);

        csord__Subscription__c oldSub = new csord__Subscription__c(csord__Identification__c = 'OldSub');
        insert oldSub;

        csord__Subscription__c newSub = new csord__Subscription__c(csord__Identification__c = 'newSub');
        insert newSub;

        List<csordtelcoa__Subscr_MACDProductBasket_Association__c> subBasketRelations
            = new List<csordtelcoa__Subscr_MACDProductBasket_Association__c>();
        subBasketRelations.add(new csordtelcoa__Subscr_MACDProductBasket_Association__c(csordtelcoa__Subscription__c = oldSub.Id, LG_DeactivationWishDate__c = Date.today(),
                                                                                        csordtelcoa__Product_Basket__c = basket.Id));
        insert subBasketRelations;

        cscrm__Address__c address = [SELECT Id FROM cscrm__Address__c LIMIT 1];

        List<csord__Service__c> services = new List<csord__Service__c>();
        csord__Service__c oldServiceMigrate = new csord__Service__c(csord__Subscription__c = oldSub.Id,
                                                                    csord__Identification__c = 'oldServiceMigrate',LG_ProvisioningSystem__c='CAMA',
                                                                    csordtelcoa__Product_Configuration__c = prodConfigMigrate.Id, LG_Address__c = address.Id,
                                                                    LG_RootOrder__c = oldOrder.Id, LG_DecompositionCriteria__c = decCrit1);
        csord__Service__c oldServiceChange = new csord__Service__c(csord__Subscription__c = oldSub.Id,
                                                                   csord__Identification__c = 'oldServiceChange',LG_ProvisioningAccountNo__c='123',LG_ProvisioningSystem__c='CAMA',
                                                                   csordtelcoa__Product_Configuration__c = prodConfigChange.Id, LG_Address__c = address.Id,
                                                                   LG_RootOrder__c = oldOrder.Id, LG_DecompositionCriteria__c = decCrit1);
        csord__Service__c newService = new csord__Service__c(csord__Subscription__c = newSub.Id, LG_TerminatedSubscription__c = oldSub.Id,LG_ProvisioningSystem__c='CAMA',
                                                             csord__Identification__c = 'newServiceChangetete', LG_InstallationWishDate__c = Date.today(),
                                                             csordtelcoa__Product_Configuration__c = prodConfigChange.Id, LG_Address__c = address.Id,
                                                             LG_RootOrder__c = newOrder.Id, LG_DecompositionCriteria__c = decCrit1);
        services.add(oldServiceMigrate);
        services.add(newService);
        services.add(oldServiceChange);
        insert services;

        newService.csordtelcoa__Replaced_Service__c = oldServiceChange.Id;
        update newService;

        noTriggers.Flag__c = false;
        upsert noTriggers;

        Test.startTest();

        List<Id> orderIds = new List<Id>();
        orderIds.add(newOrder.Id);

        LG_DecomposeOrderUtil decomposeUtil = new LG_DecomposeOrderUtil(orderIds);
        decomposeUtil.startOrderDecomposition();

        Test.stopTest();
        csord__Service__c ser=[select LG_ProvisioningAccountNo__c from csord__Service__c where csord__Identification__c = 'newServiceChangetete' ];

         System.assertEquals('123', ser.LG_ProvisioningAccountNo__c);

     }


     private static testmethod void testUpdateProvisioningMove()
    {

        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        Opportunity opp = [SELECT Id FROM Opportunity];
        opp.csordtelcoa__Change_Type__c = 'Move';
        update opp;

        csord__Order__c oldOrder = new csord__Order__c(csord__Identification__c = 'IdentOldOrde');
        insert oldOrder;

        csord__Order__c newOrder = new csord__Order__c(csord__Identification__c = 'IdentNewOrder', csordtelcoa__Opportunity__c = opp.Id);
        insert newOrder;

        cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'TestBasket'];
        basket.cscfga__Opportunity__c = opp.Id;
        update basket;

        String decCrit1;
        String decCrit2;

        Schema.DescribeFieldResult fieldResult =
            csord__Service__c.LG_DecompositionCriteria__c.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        decCrit1                       = ple[0].getValue();
        decCrit2                       = ple[1].getValue();


        cscfga__Product_Definition__c prodDefOldMigrate = LG_GeneralTest.createProductDefinition('ProdDefOldMigrate', true);
        cscfga__Product_Definition__c prodDefChange     = LG_GeneralTest.createProductDefinition('ProdDefOldChange', true);

        cscfga__Product_Configuration__c prodConfigMigrate   = LG_GeneralTest.createProductConfiguration('Old Service for Migrate', 3, basket, prodDefOldMigrate, true);
        cscfga__Product_Configuration__c prodConfigChange    = LG_GeneralTest.createProductConfiguration('Old Service for Change', 3, basket, prodDefChange, true);
        cscfga__Product_Configuration__c prodConfigNewChange = LG_GeneralTest.createProductConfiguration('New for Change', 3, basket, prodDefChange, true);

        csord__Subscription__c oldSub = new csord__Subscription__c(csord__Identification__c = 'OldSub');
        insert oldSub;

        csord__Subscription__c newSub = new csord__Subscription__c(csord__Identification__c = 'newSub');
        insert newSub;

        List<csordtelcoa__Subscr_MACDProductBasket_Association__c> subBasketRelations
            = new List<csordtelcoa__Subscr_MACDProductBasket_Association__c>();
        subBasketRelations.add(new csordtelcoa__Subscr_MACDProductBasket_Association__c(csordtelcoa__Subscription__c = oldSub.Id, LG_DeactivationWishDate__c = Date.today(),
                                                                                        csordtelcoa__Product_Basket__c = basket.Id));
        insert subBasketRelations;

        cscrm__Address__c address = [SELECT Id FROM cscrm__Address__c LIMIT 1];

        List<csord__Service__c> services = new List<csord__Service__c>();
        csord__Service__c oldServiceMigrate = new csord__Service__c(csord__Subscription__c = oldSub.Id,
                                                                    csord__Identification__c = 'oldServiceMigrate',LG_ProvisioningSystem__c='CAMA',
                                                                    csordtelcoa__Product_Configuration__c = prodConfigMigrate.Id, LG_Address__c = address.Id,
                                                                    LG_RootOrder__c = oldOrder.Id, LG_DecompositionCriteria__c = decCrit1);
        csord__Service__c oldServiceChange = new csord__Service__c(csord__Subscription__c = oldSub.Id,
                                                                   csord__Identification__c = 'oldServiceChange',LG_ProvisioningAccountNo__c='123',LG_ProvisioningSystem__c='CAMA',
                                                                   csordtelcoa__Product_Configuration__c = prodConfigChange.Id, LG_Address__c = address.Id,
                                                                   LG_RootOrder__c = oldOrder.Id, LG_DecompositionCriteria__c = decCrit1);
        csord__Service__c newService = new csord__Service__c(csord__Subscription__c = newSub.Id, LG_TerminatedSubscription__c = oldSub.Id,LG_ProvisioningSystem__c='CAMA',
                                                             csord__Identification__c = 'newServiceChangetest', LG_InstallationWishDate__c = Date.today(),
                                                             csordtelcoa__Product_Configuration__c = prodConfigChange.Id, LG_Address__c = address.Id,
                                                             LG_RootOrder__c = newOrder.Id, LG_DecompositionCriteria__c = decCrit1);
        services.add(oldServiceMigrate);
        services.add(newService);
        services.add(oldServiceChange);
        insert services;

        newService.csordtelcoa__Replaced_Service__c = oldServiceChange.Id;
        update newService;

        noTriggers.Flag__c = false;
        upsert noTriggers;

        Test.startTest();

        List<Id> orderIds = new List<Id>();
        orderIds.add(newOrder.Id);

        LG_DecomposeOrderUtil decomposeUtil = new LG_DecomposeOrderUtil(orderIds);
        decomposeUtil.startOrderDecomposition();

        Test.stopTest();
        csord__Service__c ser=[select LG_ProvisioningAccountNo__c from csord__Service__c where csord__Identification__c = 'newServiceChangetest'  ];

         System.assertEquals('123', ser.LG_ProvisioningAccountNo__c);





     }
}