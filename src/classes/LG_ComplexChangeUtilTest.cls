/**
 * Build UI + process test (OMB-125 Complex change)
 *
 * @author Petar Miletic
 * @ticket SFOM-431
 * @since  02/03/2017
*/
@IsTest
public class LG_ComplexChangeUtilTest {

    @testsetup
    private static void setupTestData()
    {
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        csordtelcoa__Orders_Subscriptions_Options__c osOptions = new csordtelcoa__Orders_Subscriptions_Options__c();
        osOptions.csordtelcoa__Generate_Orders_From_Basket__c = true;
        osOptions.csordtelcoa__Enforce_Synchronisation__c = true;
        osOptions.csordtelcoa__Create_Mac_Opportunities__c = true;
        osOptions.csordtelcoa__Basket_Linked_To_Opportunity__c = true;
        insert osOptions;

        csordtelcoa__Change_Types__c changeTypechange = new csordtelcoa__Change_Types__c();
        changeTypechange.csordtelcoa__Allow_Multiple_Subscriptions__c = true;
        changeTypechange.csordtelcoa__Auto_Create_Bundle__c = true;
        changeTypechange.csordtelcoa__Sort_Order__c = 1;
        changeTypechange.Name = 'Clone';
        insert changeTypechange;

        Account acc = LG_GeneralTest.CreateAccount('TestAccount', '321654987', 'Test', true);

        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, false);
        opp.StageName = 'Order Generated';
        insert opp;
        
        cscfga__Product_Basket__c pb = new cscfga__Product_Basket__c();
        pb.Name = 'Test';
        pb.cscfga__Opportunity__c = opp.Id;
        pb.csordtelcoa__Synchronised_with_Opportunity__c = true;
        pb.csbb__Synchronised_With_Opportunity__c = true;
        pb.csbb__Account__c = acc.Id;
        insert pb;
        
        cscfga__Product_Definition__c pd = new cscfga__Product_Definition__c();
        pd.Name = 'Generic Product Definition';
        pd.cscfga__Description__c = 'Generic Product Definition';
        insert pd;
        
        cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c();
        pc.Name = 'Test Product Configuration';
        pc.cscfga__Description__c = 'Test Product Configuration';
        pc.cscfga__Product_Family__c = 'Test Product Configuration';
        pc.cscfga__Product_Definition__c = pd.Id;
        pc.cscfga__Product_Basket__c = pb.Id;
        insert pc;
        
        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert coreq;

        csord__Order__c orderObj = LG_GeneralTest.createOrder('Test Order', acc, 'First Status', coreq, opp, false);
        orderObj.csord__Identification__c = '321654687453';
        orderObj.csordtelcoa__Opportunity__c = opp.Id;
        insert orderObj;
        
        // Solution 
        csord__Solution__c sol = new csord__Solution__c(Name = 'Test Solution', csord__Identification__c = '123456789', csord__Order__c = orderObj.Id);
        insert sol;
        
        //Appointment
        LG_ScheduleAppointment__c app = new LG_ScheduleAppointment__c(Name = 'Test Appointment', LG_Status__C = 'Scheduled', LG_Solution__C = sol.id, LG_Slot__c = 'Morning Slot', LG_JobReference__c = 'Test', LG_AgreedInstallDate__c = Date.today());
        insert app;
        
        // Subscripton 
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '6465467986', csord__Order__c = orderObj.Id, csordtelcoa__Product_Configuration__c = pc.Id);
        insert sub; 

        csord__Subscription__c sub2 = new csord__Subscription__c(csord__Identification__c = '64654679898', csord__Order__c = orderObj.Id, csordtelcoa__Product_Configuration__c = pc.Id);
        insert sub2; 
        
        // Service 
        csord__Service__c service = new csord__Service__c(Name = 'TestService', csord__Identification__c = '6465467986', 
                                                            csord__Activation_Date__c = Date.today(), 
                                                            LG_Effectivedate__c = Date.today(), 
                                                            LG_ServiceStatus__C = 'Provisioned', 
                                                            LG_Suborder__c = sol.Id, 
                                                            csord__Subscription__c = sub.id,
                                                            csord__Order__c = orderObj.Id,
                                                            csordtelcoa__Product_Configuration__c = pc.Id);
        insert service;
        
        cscfga__Product_Definition__c prodDefNumberRange = LG_GeneralTest.createProductDefinition('Number Range', true);
        // cscfga__Product_Configuration__c numberRangeProdConf = LG_GeneralTest.createProductConfiguration('Number Range', 3, pb, prodDefNumberRange, true);
        
        cscfga__Product_Configuration__c numberRangeProdConf = new cscfga__Product_Configuration__c();
        numberRangeProdConf.Name = 'Number Range';
        numberRangeProdConf.cscfga__Description__c = 'Number Range';
        numberRangeProdConf.cscfga__Product_Family__c = 'Number Range';
        numberRangeProdConf.cscfga__Product_Definition__c = prodDefNumberRange.Id;
        numberRangeProdConf.cscfga__Product_Basket__c = pb.Id;
        insert numberRangeProdConf;
        
        csord__Service__c service2 = new csord__Service__c(Name = 'TestService2', csord__Identification__c = '6465467987', 
                                                            csord__Activation_Date__c = Date.today(), 
                                                            LG_Effectivedate__c = Date.today(), 
                                                            LG_ServiceStatus__C = 'Provisioned', 
                                                            LG_Suborder__c = sol.Id, 
                                                            csord__Subscription__c = sub2.id,
                                                            csord__Order__c = orderObj.Id,
                                                            csordtelcoa__Product_Configuration__c = numberRangeProdConf.Id);
        insert service2;
        
        RecordType rt = [SELECT Id, Name, IsActive FROM RecordType WHERE SobjectType = 'Case' AND Name = 'Jeopardy' LIMIT 1];
        RecordType rtCanel = [SELECT Id, Name, IsActive FROM RecordType WHERE Name = 'Order Cancel Request' LIMIT 1];

        List<Case> cases = new List<Case>();

        Case caseobj = new Case();
        
        caseobj.RecordTypeId = rt.Id;
        caseobj.Status = 'New';
        caseobj.LG_Solution__c = sol.Id;
        caseobj.Type = 'Modify';
        
        Case caseobjCancel = new Case();
        
        caseobjCancel.RecordTypeId = rtCanel.Id;
        caseobjCancel.Subject = 'Cancel Case';
        caseobjCancel.Status = 'New';
        caseobjCancel.LG_Opportunity__c = opp.Id;
        caseobjCancel.Type = 'Cancel';
        
        cases.add(caseobj);
        cases.add(caseobjCancel);
        
        insert cases;

        // Create record types
        RecordType numberBlockRecordType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Asset' AND Name = 'Number Block'];
        RecordType phoneNumberRecordType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Asset' AND Name = 'Phone Number'];
        
        List<Asset> assets = new List<Asset>();

        // Top level asset (number block)
        Asset topAssetFirst = new Asset(Name = 'Asset_F', AccountId = acc.Id, LG_NumberRangeType__c = 'Portin', RecordTypeId = numberBlockRecordType.Id, LG_TelephonyService__c = service.Id,
                                        LG_StartNumber__c = '000', LG_EndNumber__c = '004', LG_PortInWishDate__c = Date.today().addDays(-5), LG_TelephonyProductConfiguration__c = pc.Id, LG_SoftDeleted__c = false);
        insert topAssetFirst;
        
        Asset topAssetSecond = new Asset(Name = 'Asset_S', AccountId = acc.Id, LG_NumberRangeType__c = 'Portin', RecordTypeId = numberBlockRecordType.Id, LG_TelephonyService__c = service.Id,
                                        LG_StartNumber__c = '000', LG_EndNumber__c = '004', LG_PortInWishDate__c = Date.today().addDays(4), LG_TelephonyProductConfiguration__c = pc.Id, LG_SoftDeleted__c = false);
        insert topAssetSecond;
        
        for (Integer i = 1; i < 6; i++) {

            Asset obj = new Asset(Name = 'Asset_' + i, AccountId = acc.Id);

            obj.LG_NumberRangeType__c = 'Portin';
            obj.RecordTypeId = phoneNumberRecordType.Id;
            obj.LG_TelephonyService__c = service.Id;
            obj.LG_TelephonyProductConfiguration__c = pc.Id;
            obj.LG_SoftDeleted__c = false;

            if (math.mod(i, 2) == 0) {
                obj.LG_Asset__c = topAssetSecond.Id;
            }
            else {
                obj.LG_Asset__c = topAssetFirst.Id;
            }

            assets.add(obj);
        }

        Asset objnr = new Asset(Name = 'Asset_99', AccountId = acc.Id);

        objnr.LG_NumberRangeType__c = 'Portin';
        objnr.RecordTypeId = phoneNumberRecordType.Id;
        objnr.LG_TelephonyService__c = service2.Id;
        objnr.LG_TelephonyProductConfiguration__c = pc.Id;
        objnr.LG_NumberRangeProductConfiguration__c = numberRangeProdConf.Id;
        objnr.LG_SoftDeleted__c = false;

        objnr.LG_Asset__c = topAssetSecond.Id;
        
        assets.add(objnr);
        
        insert assets;

        // Insert process
        LG_PortingProcess__c pProcess = new LG_PortingProcess__c();
        pProcess.LG_Account__c = acc.Id;
        insert pProcess;
        
        LG_ProcessRequest__c request = new LG_ProcessRequest__c();
        request.LG_Process__c = pProcess.Id;
        request.LG_Response__c = 'Success';
        insert request;
        
        LG_ProcessRequest__c request2 = new LG_ProcessRequest__c();
        request2.LG_Process__c = pProcess.Id;
        request2.LG_Response__c = 'Success';
        insert request2;

        List<LG_AssetProcessAssociation__c> assetAssociations = new List<LG_AssetProcessAssociation__c>();

        for (Asset obj :assets) {

            assetAssociations.add(new LG_AssetProcessAssociation__c( LG_Asset__c = obj.Id, LG_Process__c = pProcess.Id));
        }

        assetAssociations.add(new LG_AssetProcessAssociation__c( LG_Asset__c = topAssetFirst.Id, LG_Process__c = pProcess.Id));
        assetAssociations.add(new LG_AssetProcessAssociation__c( LG_Asset__c = topAssetSecond.Id, LG_Process__c = pProcess.Id));

        insert assetAssociations;

        noTriggers.Flag__c = false;
        upsert noTriggers;
    }

/*    @isTest
    public static void ComplexChangeOpportunityCaseTest() {
        
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        
        Case obj = [SELECT Id FROM Case LIMIT 1];
        obj.LG_Opportunity__c = opp.Id;
        
        update obj;
        system.debug('-----obj'+obj);
        
        Opportunity oldOpportunity = [SELECT Id, LG_Version__c, LG_ActiveVersion__c, LG_OlderVersion__c, LG_NewerVersion__c, LG_SoftDeleted__c FROM Opportunity LIMIT 1];
        
        Test.startTest();
       
        Id recordId = LG_ComplexChangeUtil.ComplexChange(obj.Id);

        Test.stopTest();
        
        String objectName = String.valueOf(recordId.getSobjectType());
        
        // Start conditions
        System.assertEquals(false, oldOpportunity.LG_SoftDeleted__c, 'Invalid data');
        System.assertEquals(null, oldOpportunity.LG_Version__c, 'Invalid data');
        System.assertEquals(true, oldOpportunity.LG_ActiveVersion__c, 'Invalid data');
        System.assertEquals(null, oldOpportunity.LG_OlderVersion__c, 'Invalid data');
        System.assertEquals(null, oldOpportunity.LG_NewerVersion__c, 'Invalid data');
        
        oldOpportunity = [SELECT Id, LG_Version__c, LG_ActiveVersion__c, LG_OlderVersion__c, LG_NewerVersion__c, LG_SoftDeleted__c FROM Opportunity WHERE Id = :oldOpportunity.Id LIMIT 1];

        // Old version updated
        System.assertEquals(true, oldOpportunity.LG_SoftDeleted__c, 'Invalid data');
        System.assertEquals(1, oldOpportunity.LG_Version__c, 'Invalid data');
        System.assertEquals(false, oldOpportunity.LG_ActiveVersion__c, 'Invalid data');
        System.assertEquals(null, oldOpportunity.LG_OlderVersion__c, 'Invalid data');
        System.assertEquals(recordId, oldOpportunity.LG_NewerVersion__c, 'Invalid data');
        
        Opportunity newOpportunity = [SELECT Id, LG_Version__c, LG_ActiveVersion__c, LG_OlderVersion__c, LG_NewerVersion__c, LG_SoftDeleted__c FROM Opportunity WHERE Id = :recordId LIMIT 1];
        
        // New version updated
        System.assertEquals(false, newOpportunity.LG_SoftDeleted__c, 'Invalid data');
        System.assertEquals(2, newOpportunity.LG_Version__c, 'Invalid data');
        System.assertEquals(true, newOpportunity.LG_ActiveVersion__c, 'Invalid data');
        System.assertEquals(oldOpportunity.Id, newOpportunity.LG_OlderVersion__c, 'Invalid data');
        System.assertEquals(null, newOpportunity.LG_NewerVersion__c, 'Invalid data');
        
        Case cancelCase = [SELECT Id, Status FROM Case WHERE Subject = 'Cancel Case'];
        
        System.assertEquals('On Hold', cancelCase.Status, 'Invalid data');
    }
    
    @isTest
    public static void ComplexChangeOrderCaseTest() {
        
        csord__Order__c ord = [SELECT Id FROM csord__Order__c LIMIT 1];
        
        Case obj = [SELECT Id FROM Case LIMIT 1];
        obj.LG_Order__c = ord.Id;
        
        update obj;
        
        Opportunity oldOpportunity = [SELECT Id, LG_Version__c, LG_ActiveVersion__c, LG_OlderVersion__c, LG_NewerVersion__c, LG_SoftDeleted__c FROM Opportunity LIMIT 1];
        
        Test.startTest();
        
        Id recordId = LG_ComplexChangeUtil.ComplexChange(obj.Id);

        Test.stopTest();
        
        String objectName = String.valueOf(recordId.getSobjectType());
        
        // Start conditions
        System.assertEquals(false, oldOpportunity.LG_SoftDeleted__c, 'Invalid data');
        System.assertEquals(null, oldOpportunity.LG_Version__c, 'Invalid data');
        System.assertEquals(true, oldOpportunity.LG_ActiveVersion__c, 'Invalid data');
        System.assertEquals(null, oldOpportunity.LG_OlderVersion__c, 'Invalid data');
        System.assertEquals(null, oldOpportunity.LG_NewerVersion__c, 'Invalid data');
        
        oldOpportunity = [SELECT Id, LG_Version__c, LG_ActiveVersion__c, LG_OlderVersion__c, LG_NewerVersion__c, LG_SoftDeleted__c FROM Opportunity WHERE Id = :oldOpportunity.Id LIMIT 1];

        // Old version updated
        System.assertEquals(true, oldOpportunity.LG_SoftDeleted__c, 'Invalid data');
        System.assertEquals(1, oldOpportunity.LG_Version__c, 'Invalid data');
        System.assertEquals(false, oldOpportunity.LG_ActiveVersion__c, 'Invalid data');
        System.assertEquals(null, oldOpportunity.LG_OlderVersion__c, 'Invalid data');
        System.assertEquals(recordId, oldOpportunity.LG_NewerVersion__c, 'Invalid data');
        
        Opportunity newOpportunity = [SELECT Id, LG_Version__c, LG_ActiveVersion__c, LG_OlderVersion__c, LG_NewerVersion__c, LG_SoftDeleted__c FROM Opportunity WHERE Id = :recordId LIMIT 1];
        
        // New version updated
        System.assertEquals(false, newOpportunity.LG_SoftDeleted__c, 'Invalid data');
        System.assertEquals(2, newOpportunity.LG_Version__c, 'Invalid data');
        System.assertEquals(true, newOpportunity.LG_ActiveVersion__c, 'Invalid data');
        System.assertEquals(oldOpportunity.Id, newOpportunity.LG_OlderVersion__c, 'Invalid data');
        System.assertEquals(null, newOpportunity.LG_NewerVersion__c, 'Invalid data');
    }

    @isTest
    public static void ComplexChangeOrderTest() {
        
        csord__Order__c obj = [SELECT Id FROM csord__Order__c LIMIT 1];
        
        Opportunity oldOpportunity = [SELECT Id, LG_Version__c, LG_ActiveVersion__c, LG_OlderVersion__c, LG_NewerVersion__c, LG_SoftDeleted__c FROM Opportunity LIMIT 1];
        
        Test.startTest();
        
        Id recordId = LG_ComplexChangeUtil.ComplexChange(obj.Id);

        Test.stopTest();
        
        String objectName = String.valueOf(recordId.getSobjectType());
        
        // Start conditions
        System.assertEquals(false, oldOpportunity.LG_SoftDeleted__c, 'Invalid data');
        System.assertEquals(null, oldOpportunity.LG_Version__c, 'Invalid data');
        System.assertEquals(true, oldOpportunity.LG_ActiveVersion__c, 'Invalid data');
        System.assertEquals(null, oldOpportunity.LG_OlderVersion__c, 'Invalid data');
        System.assertEquals(null, oldOpportunity.LG_NewerVersion__c, 'Invalid data');
        
        oldOpportunity = [SELECT Id, LG_Version__c, LG_ActiveVersion__c, LG_OlderVersion__c, LG_NewerVersion__c, LG_SoftDeleted__c FROM Opportunity WHERE Id = :oldOpportunity.Id LIMIT 1];

        // Old version updated
        System.assertEquals(true, oldOpportunity.LG_SoftDeleted__c, 'Invalid data');
        System.assertEquals(1, oldOpportunity.LG_Version__c, 'Invalid data');
        System.assertEquals(false, oldOpportunity.LG_ActiveVersion__c, 'Invalid data');
        System.assertEquals(null, oldOpportunity.LG_OlderVersion__c, 'Invalid data');
        System.assertEquals(recordId, oldOpportunity.LG_NewerVersion__c, 'Invalid data');
        
        Opportunity newOpportunity = [SELECT Id, LG_Version__c, LG_ActiveVersion__c, LG_OlderVersion__c, LG_NewerVersion__c, LG_SoftDeleted__c FROM Opportunity WHERE Id = :recordId LIMIT 1];
        
        // New version updated
        System.assertEquals(false, newOpportunity.LG_SoftDeleted__c, 'Invalid data');
        System.assertEquals(2, newOpportunity.LG_Version__c, 'Invalid data');
        System.assertEquals(true, newOpportunity.LG_ActiveVersion__c, 'Invalid data');
        System.assertEquals(oldOpportunity.Id, newOpportunity.LG_OlderVersion__c, 'Invalid data');
        System.assertEquals(null, newOpportunity.LG_NewerVersion__c, 'Invalid data');
    }
    
    @isTest
    public static void setVersionDataTest() {
        
        csord__Order__c obj = [SELECT Id FROM csord__Order__c LIMIT 1];
        
        Opportunity oldOpportunity = [SELECT Id, LG_Version__c, LG_ActiveVersion__c, LG_OlderVersion__c, LG_NewerVersion__c, AccountId, Account.Name FROM Opportunity LIMIT 1];

        Test.startTest();
        
        Id recordId = LG_ComplexChangeUtil.ComplexChange(obj.Id);
        
        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert coreq;

        csord__Order__c orderObj = LG_GeneralTest.createOrder('Test Order', oldOpportunity.Account, 'First Status', coreq, oldOpportunity, false);
        orderObj.csord__Identification__c = '316454135132177';
        
        // Overwrite old Opp
        orderObj.csordtelcoa__Opportunity__c = recordId;
        insert orderObj;

        // Subscripton 
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '2462347282241211', csord__Order__c = orderObj.Id);
        insert sub; 

        // Connect old and new PC
        cscfga__Product_Configuration__c oldPc = [SELECT Id, Name 
                                                    FROM cscfga__Product_Configuration__c 
                                                    WHERE Name = 'Test Product Configuration' LIMIT 1];
                                                    
        cscfga__Product_Configuration__c newPc = [SELECT Id, Name, csordtelcoa__Replaced_Product_Configuration__c
                                                    FROM cscfga__Product_Configuration__c 
                                                    WHERE cscfga__Product_Basket__r.cscfga__Opportunity__c = :recordId LIMIT 1];
                                                    
        newPc.csordtelcoa__Replaced_Product_Configuration__c = oldPc.Id;
        update newPc;
        
        // Service 
        csord__Service__c service = new csord__Service__c(Name = 'TestService', csord__Identification__c = '322132333355974', 
                                                            csord__Activation_Date__c = Date.today(), 
                                                            LG_Effectivedate__c = Date.today(), 
                                                            LG_ServiceStatus__C = 'Provisioned', 
                                                            csord__Subscription__c = sub.id,
                                                            csordtelcoa__Product_Configuration__c = newPc.Id);
                                                            
        insert service;
        
        Map<Id, csord__Service__c> services = new Map<Id, csord__Service__c>();
        services.put(service.Id, service);
        
        csord__Service__c newService = service.clone(true, true, true, true);
        newService.csord__Order__c = orderObj.Id;
        
        update newService;
        
        Test.stopTest();
        
        // Load old Order
        csord__Order__c oldOrder = [SELECT Id, Name, LG_NewOrderVersion__c, LG_PreviousOrderVersion__c, LG_SoftDeleted__c, csord__Status2__c FROM csord__Order__c WHERE csord__Identification__c = '321654687453' LIMIT 1];
        
        // Reload new Order
        csord__Order__c newOrder = [SELECT Id, Name, LG_NewOrderVersion__c, LG_PreviousOrderVersion__c, LG_SoftDeleted__c FROM csord__Order__c WHERE Id = :orderObj.Id LIMIT 1];

        // Load Assets
        List<Asset> assetsOld = [SELECT Id, Name, LG_SoftDeleted__c FROM Asset WHERE csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__c = :oldOpportunity.Id];
        List<Asset> assetsNew = [SELECT Id, Name, LG_SoftDeleted__c FROM Asset WHERE csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__c = :recordId];

        System.assertEquals(true, oldOrder.LG_SoftDeleted__c, 'Invalid data');
        System.assertEquals(false, newOrder.LG_SoftDeleted__c, 'Invalid data');
        
        /**
         * Status of the previous order should 
         * change to Change Confirmed when Complex change is performed
         *
         * @author Petar Miletic
         * @ticket SFOM-624
         * @since  20/04/2017
        */
    /* System.assertEquals('Change Confirmed', oldOrder.csord__Status2__c, 'Invalid data');
        
        System.assertEquals(oldOrder.LG_NewOrderVersion__c, newOrder.Id, 'Invalid data');
        System.assertEquals(newOrder.LG_PreviousOrderVersion__c, oldOrder.Id, 'Invalid data');
        
        for (Asset objOld :assetsOld) {
            System.assertEquals(true, objOld.LG_SoftDeleted__c, 'Invalid data');
        }
        
        for (Asset objNew :assetsNew) {
            System.assertEquals(false, objNew.LG_SoftDeleted__c, 'Invalid data');
        }
        
        Case cancelCase = [SELECT Id, Status FROM Case WHERE Subject = 'Cancel Case'];
        
        System.assertEquals('Closed', cancelCase.Status, 'Invalid data');
    }

    /**
     * Complex Change Cancelled
     *
     * @author Petar Miletic
     * @ticket SFOM-433
     * @since  06/07/2017
    */
 /* @isTest
    public static void cancelComplexChangeTest() {
        
        csord__Order__c obj = [SELECT Id FROM csord__Order__c LIMIT 1];
        
        Opportunity oldOpportunity = [SELECT Id, LG_Version__c, LG_ActiveVersion__c, LG_OlderVersion__c, LG_NewerVersion__c, LG_SoftDeleted__c FROM Opportunity LIMIT 1];
        
        Case cancelCase = [SELECT Id, Subject, Status, RecordType.Name FROM Case WHERE Subject = 'Cancel Case'];
        
        Test.startTest();
        
        cancelCase.Status = 'Closed';
        update cancelCase;
        
        Id recordId = LG_ComplexChangeUtil.ComplexChange(obj.Id);

        // Cancel new Opportunity
        LG_ComplexChangeUtil.cancelComplexChange(recordId);

        Test.stopTest();
        
        String objectName = String.valueOf(recordId.getSobjectType());

        Opportunity newOpportunity = [SELECT Id, LG_Version__c, LG_ActiveVersion__c, LG_OlderVersion__c, LG_NewerVersion__c, LG_SoftDeleted__c FROM Opportunity WHERE Id = :recordId LIMIT 1];
        
        // New version updated
        System.assertEquals(true, newOpportunity.LG_SoftDeleted__c, 'Invalid data');
        System.assertEquals(2, newOpportunity.LG_Version__c, 'Invalid data');
        System.assertEquals(false, newOpportunity.LG_ActiveVersion__c, 'Invalid data');
        System.assertEquals(oldOpportunity.Id, newOpportunity.LG_OlderVersion__c, 'Invalid data');
        System.assertEquals(null, newOpportunity.LG_NewerVersion__c, 'Invalid data');
        
        // Reload old Opportunity
        oldOpportunity = [SELECT Id, LG_Version__c, LG_ActiveVersion__c, LG_OlderVersion__c, LG_NewerVersion__c, LG_SoftDeleted__c FROM Opportunity WHERE Id = :oldOpportunity.Id LIMIT 1];

        // Old version updated
        System.assertEquals(false, oldOpportunity.LG_SoftDeleted__c, 'Invalid data');
        System.assertEquals(1, oldOpportunity.LG_Version__c, 'Invalid data');
        System.assertEquals(true, oldOpportunity.LG_ActiveVersion__c, 'Invalid data');
        System.assertEquals(null, oldOpportunity.LG_OlderVersion__c, 'Invalid data');
        System.assertEquals(recordId, oldOpportunity.LG_NewerVersion__c, 'Invalid data');
        
        cancelCase = [SELECT Id, Status FROM Case WHERE Subject = 'Cancel Case' LIMIT 1];
        
        //System.assertEquals('New', cancelCase.Status, 'Invalid data');
    }

     /**
     * Complex Change Cancelled
     *
     * @author Petar Miletic
     * @ticket SFOM-498
     * @since  20/03/2017
    */
   /*isTest   
    public static void cloneNumbersAndRelatedRecordsTest() {

        csord__Order__c obj = [SELECT Id, csordtelcoa__Opportunity__c FROM csord__Order__c WHERE csord__Identification__c = '321654687453' LIMIT 1];
        cscfga__Product_Configuration__c pc = [SELECT Id, Name, csordtelcoa__Replaced_Product_Configuration__c FROM cscfga__Product_Configuration__c WHERE Name = 'Test Product Configuration' LIMIT 1];
        cscfga__Product_Configuration__c numberRangeProdConf = [SELECT Id, Name, csordtelcoa__Replaced_Product_Configuration__c FROM cscfga__Product_Configuration__c WHERE Name = 'Number Range' LIMIT 1];
        
        List<LG_AssetProcessAssociation__c> associationsBefore = [SELECT Id, Name, LG_Process__c FROM LG_AssetProcessAssociation__c WHERE LG_Asset__r.LG_TelephonyProductConfiguration__c = :pc.Id];
        
        Test.startTest();

        LG_ComplexChangeUtil.ComplexChangeData data = new LG_ComplexChangeUtil.ComplexChangeData(obj.Id);

        Id recordId = LG_ComplexChangeUtil.ComplexChange(obj.Id);

        Test.stopTest();

        Set<Id> portinProcesses = new Set<Id>();
        
        // List<Asset> assets = [SELECT Id, Name, LG_SoftDeleted__c FROM Asset WHERE LG_TelephonyProductConfiguration__c = :pc.Id];
        List<Asset> assets = [SELECT Id, 
                                    Name, 
                                    LG_SoftDeleted__c
                                FROM Asset 
                                WHERE LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c = :obj.csordtelcoa__Opportunity__c OR 
                                        LG_NumberRangeProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c = :obj.csordtelcoa__Opportunity__c];
                                        
        List<LG_AssetProcessAssociation__c> assetProcessAssociations = [SELECT Id, Name, LG_Process__c 
                                                                            FROM LG_AssetProcessAssociation__c 
                                                                            WHERE LG_Asset__r.LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c = :obj.csordtelcoa__Opportunity__c OR 
                                                                                    LG_Asset__r.LG_NumberRangeProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c = :obj.csordtelcoa__Opportunity__c];
        
        for (LG_AssetProcessAssociation__c ap :assetProcessAssociations) {
            portinProcesses.add(ap.LG_Process__c);
        }
        
        // Validate ComplexChangeData
        System.assertEquals(true, data.isValid(), 'Invalid data');
        
        // Validate previous state
        System.assertEquals(8, assets.size(), 'Invalid asset data');
        System.assertEquals(1, portinProcesses.size(), 'Invalid portin process data');
        System.assertEquals(8, assetProcessAssociations.size(), 'Invalid asset to process association data');
        
        return;
        
        // Requery new data
        String[] types = new String[]{ 'Asset', 'LG_AssetProcessAssociation__c', 'LG_PortingProcess__c', 'LG_ProcessRequest__c' };
        
        Map<String, Set<String>> fieldMap = LG_ReflectionUtil.getObjectFieldsMap(types);

        String columnsAA = LG_ReflectionUtil.getColumns(fieldMap.get('LG_AssetProcessAssociation__c'), '');
        String columnsAs = LG_ReflectionUtil.getColumns(fieldMap.get('Asset'), 'LG_Asset__r');
        String columnsPP = LG_ReflectionUtil.getColumns(fieldMap.get('LG_PortingProcess__c'), 'LG_Process__r');
        
        String columns = columnsAA + ', ' + columnsAs + ', ' + columnsPP;

        // Retrieve Asset Process Associations with Asset and Process data
        List<LG_AssetProcessAssociation__c> assetAssociations = Database.query('SELECT ' + columns + ' FROM LG_AssetProcessAssociation__c WHERE LG_Asset__r.LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c = :recordId');
        
        Set<Asset> assetsNew = new Set<Asset>();
        Set<LG_PortingProcess__c> processesNew = new Set<LG_PortingProcess__c>();
        
        Set<Id> processIds = new Set<Id>();
        
        // Prepare Asset Process Associations
        for (LG_AssetProcessAssociation__c apa :assetAssociations) {
            
            assetsNew.add(apa.LG_Asset__r);
            processesNew.add(apa.LG_Process__r);
            
            processIds.add(apa.LG_Process__c);
        }
        
        List<LG_ProcessRequest__c> requests = [SELECT Id FROM LG_ProcessRequest__c WHERE LG_Process__c IN :processIds];
        
        System.assertEquals(associationsBefore.size(), assetProcessAssociations.size(), 'Invalid data');

        // New ones
        for (Asset objNew :assetsNew) {
            System.assertEquals(false, objNew.LG_SoftDeleted__c, 'Invalid data');
        }
        
        // Validate new state
        System.assertEquals(8, assetsNew.size(), 'Invalid data');
        System.assertEquals(1, processesNew.size(), 'Invalid data');
        System.assertEquals(8, assetAssociations.size(), 'Invalid data');
        System.assertEquals(2, requests.size(), 'Invalid data');
    }
*/
    @isTest
    public static void ComplexChangeInvalidTest() {
        
        Opportunity obj = [SELECT Id FROM Opportunity LIMIT 1];
        
        Test.startTest();
        
        String errorMessage = '';
        
        try {
            LG_ComplexChangeUtil.ComplexChange(obj.Id);    
        }
        catch (Exception ex) {
            errorMessage = ex.getMessage();
        }

        Test.stopTest();
        
        System.assertEquals('Unsupported record Id', errorMessage, 'Invalid data');
    }
    Public static testmethod void complexchangetest(){
        
        Opportunity obj = [SELECT Id FROM Opportunity LIMIT 1];
       List<csord__Subscription__c> sub= [select csord__Identification__c,csord__Order__c,csordtelcoa__Product_Configuration__c from csord__Subscription__c ];
       List<csord__Service__c> serv=[select Name from csord__Service__c];
    
        List<cscfga__Product_Configuration__c> congig=[select Name,cscfga__Description__c,cscfga__Product_Family__c,cscfga__Product_Definition__c,cscfga__Product_Basket__c from cscfga__Product_Configuration__c];
        test.startTest();
        case cas=[select id from case limit 1];
          LG_ComplexChangeUtil.ComplexChange(cas.id);
      /*LG_ComplexChangeUtil dat=new LG_ComplexChangeUtil();
        dat.ComplexChangeData compdat=new dat.ComplexChangeData();
        ComplexChangeData testdat=new ComplexChangeData();
        testdat.opp=;
        testdat.csordtelcoa__Change_Types__c=;
        testdat.List<csord__Subscription__c>*/
    //LG_ComplexChangeUtil.setVersioningData(obj.id,);
        test.stopTest();
        
    }
    public static testmethod void computil(){
        test.startTest();
        
         csord__Order__c serv=[select id,Name from csord__Order__c limit 1];
          LG_ComplexChangeUtil.ComplexChange(serv.id);
       
        test.stopTest();
        
    }
    public static testmethod void cancelComplexChangetest(){
        opportunity opps=[SELECT Id, Name,
                        	    LG_Version__c,
                        	    LG_ActiveVersion__c,
                        	    LG_NewerVersion__c,
                        	    LG_SoftDeleted__c,
                        	    LG_OlderVersion__r.LG_Version__c,
                                LG_OlderVersion__r.LG_ActiveVersion__c,
                                LG_OlderVersion__r.OwnerId
                    	    FROM Opportunity limit 1];
       
        Account acc = LG_GeneralTest.CreateAccount('TestAcc', '321654988', 'Test', true);
			
        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, false);
        opp.StageName = 'Order Generated';
		opp.LG_Version__c=123;
        opp.LG_ActiveVersion__c=false;
        User usr = [Select id,Email,Name,LastName from User where Id = :UserInfo.getUserId()];
        insert opp;
         
        usr.IsActive=true;
        update usr;
        csord__Order__c serv=[select id,Name,csordtelcoa__Opportunity__c from csord__Order__c limit 1];
        serv.csordtelcoa__Opportunity__c=opp.id;
        User usrr = [Select id,Email,Name,LastName from User where Id = :UserInfo.getUserId()];
      	serv.OwnerId =usrr.id;
        update serv;
        system.debug(serv.Owner.Email);
        system.debug(serv.Owner.Name);
        system.debug(serv.Owner.LastName);
     
        opps.LG_SoftDeleted__c=true;
        opps.LG_OlderVersion__c=opp.id;
        opps.LG_ActiveVersion__c=false;
        opps.LG_SoftDeleted__c=true;
        opps.LG_Version__c=123;
        update opps;
        
        case c1=[select id,Status,RecordType.Name,LG_Opportunity__c,LG_Order__c from case where LG_Opportunity__c=:opps.id ];
        c1.LG_Order__c=serv.id;
        update c1;
       system.debug(c1);
 
     System.RunAs(usr)
     {
      
        EmailTemplate e = new EmailTemplate (developerName = 'test', FolderId = UserInfo.getUserId(), TemplateType= 'Text', Name = 'Complex Change Notification'); 
		insert e;
        
        test.startTest();
        LG_ComplexChangeUtil.cancelComplexChange(opps.id);
         LG_ComplexChangeUtil.handleConfirmedRequestCases(opps);
        test.stopTest();
     }
      
        
    }
    public static testmethod void complxchang(){
        test.startTest();
          opportunity opps=[SELECT Id, Name,
                        	    LG_Version__c,
                        	    LG_ActiveVersion__c,
                        	    LG_NewerVersion__c,
                        	    LG_SoftDeleted__c,
                        	    LG_OlderVersion__r.LG_Version__c,
                                LG_OlderVersion__r.LG_ActiveVersion__c,
                                LG_OlderVersion__r.OwnerId
                    	    FROM Opportunity limit 1];
      
          Opportunity obj = [SELECT Id FROM Opportunity LIMIT 1];
        list<opportunity> l1=[select id from opportunity];
         Set<id> s1=new set<id>();
        
         Account acc = LG_GeneralTest.CreateAccount('TestAcc', '321654988', 'Test', true);
			
        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, false);
        opp.StageName = 'Order Generated';
		opp.LG_Version__c=123;
        opp.LG_ActiveVersion__c=false;
        User usr = [Select id,Email,Name,LastName from User where Id = :UserInfo.getUserId()];
        insert opp;
         
        usr.IsActive=true;
        update usr;
        csord__Order__c serv=[select id,Name,csordtelcoa__Opportunity__c from csord__Order__c limit 1];
        serv.csordtelcoa__Opportunity__c=opp.id;
        User usrr = [Select id,Email,Name,LastName from User where Id = :UserInfo.getUserId()];
      	serv.OwnerId =usrr.id;
        update serv;
        system.debug(serv.Owner.Email);
        system.debug(serv.Owner.Name);
        system.debug(serv.Owner.LastName);
     
        opps.LG_SoftDeleted__c=true;
        opps.LG_OlderVersion__c=opp.id;
        opps.LG_ActiveVersion__c=false;
        opps.LG_SoftDeleted__c=true;
        opps.LG_Version__c=123;
        update opps;
        for(Opportunity obj1:l1){
            
             s1.add(obj1.id);
        }
       
       
         case cas=[select id,LG_Opportunity__c from case limit 1];
        cas.LG_Opportunity__c=obj.id;
        update cas;
          LG_ComplexChangeUtil.ComplexChange(cas.id);
       
        //LG_ComplexChangeUtil.cloneNumbersAndRelatedRecords();
        LG_ComplexChangeUtil.handleCloseRequestCases(s1);
        test.stopTest();
        
    }
    
}