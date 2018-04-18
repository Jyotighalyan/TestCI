/**
 * 
 * Test for LG_SConsoleNumberPortabilityExtension
 * 
 * @author Petar Miletic
 * @ticket SFOM-252
 * @since  18/01/2017
*/
@IsTest
public class LG_NumberPortabilityExtensionTest {

    @testSetup 
    private static void setupTestData() {

        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        // Create record types
        RecordType numberBlockRecordType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Asset' AND Name = 'Number Block'];
        RecordType caseRecordType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND Name = 'Number Port'];

        Account acc = new Account(Name = 'TestAcc');
        insert acc;

        // Solution 
        csord__Solution__c sol = new csord__Solution__c(Name = 'Test Solution', LG_AnyNumbersToPort__c = false, csord__Identification__c = '6465467985', LG_OrderChanged__c = false, LG_OrderCancelled__c = false);
        insert sol;
        
        // Subscripton 
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '6465467986');
        insert sub; 
        
        // Service 
        csord__Service__c service = new csord__Service__c(csord__Subscription__c = sub.Id, LG_Suborder__c = sol.Id, csord__Identification__c = '6465467987', LG_InstallationPlannedDate__c = Date.today());
        insert service;

        // Insert process
        LG_PortingProcess__c process = new LG_PortingProcess__c();
        process.LG_Account__c = acc.Id;
        insert process;
        
        LG_ProcessRequest__c request = new LG_ProcessRequest__c();
        request.LG_Process__c = process.Id;
        request.LG_PortingAgreedDate__c = Date.today();
        request.LG_Response__c = 'Success';
        insert request;
        
        LG_PortingProcess__c process2 = new LG_PortingProcess__c();
        process2.LG_Account__c = acc.Id;
        process2.LG_Provider__c = 'Test';
        insert process2;
        
        LG_ProcessRequest__c request2_1 = new LG_ProcessRequest__c();
        request2_1.LG_Process__c = process2.Id;
        request2_1.LG_PortingAgreedDate__c = Date.today();
        request2_1.LG_Response__c = 'Success';
        insert request2_1;
        
        LG_ProcessRequest__c request2_2 = new LG_ProcessRequest__c();
        request2_2.LG_Process__c = process2.Id;
        request2_2.LG_PortingAgreedDate__c = Date.today().addDays(30);
        request2_2.LG_Response__c = 'Success';
        insert request2_2;

        List<Asset> assets = new List<Asset>();
        
        // Top level asset (number block)
        Asset topAsset = new Asset(Name = 'Asset_0', AccountId = acc.Id, csord__Service__c = service.Id, LG_TelephonyService__c = service.Id, RecordTypeId = numberBlockRecordType.Id, LG_NumberRangeType__c = 'Portin');
        insert topAsset;
        
        for (Integer i = 1; i < 6; i++) {
            
            Asset obj = new Asset(Name = 'Asset_' + i, AccountId = acc.Id, csord__Service__c = service.Id);

            obj.LG_Asset__c = topAsset.Id;
            obj.LG_NumberRangeType__c = 'Portin';
            obj.LG_TelephonyService__c = service.Id;
            obj.RecordTypeId = numberBlockRecordType.Id;
            
            assets.add(obj);
        }

        insert assets;
        
        List<LG_AssetProcessAssociation__c> assetAssociation = new List<LG_AssetProcessAssociation__c>();
        
        for (Asset obj :assets) {
            
            assetAssociation.add(new LG_AssetProcessAssociation__c(LG_Asset__c = obj.Id, LG_Process__c = process.Id));
        }
        
        assetAssociation.add(new LG_AssetProcessAssociation__c(LG_Asset__c = topAsset.Id, LG_Process__c = process2.Id));
        
        insert assetAssociation;
        
        Case testCase = new Case();
        testCase.RecordTypeId = caseRecordType.Id;
        testCase.Status = 'New';
        testCase.LG_Solution__c = sol.Id;
        
        insert testCase;
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    
    @IsTest
    public static void editTest() {
        
        Case obj = [SELECT Id, status, LG_Service__c, LG_Solution__c, LG_Order__c, RecordType.Name FROM Case LIMIT 1];
        
        test.startTest();
        
            ApexPages.StandardController stController = new ApexPages.StandardController(obj);
            LG_SConsoleNumberPortabilityExtension controllerInstance = new LG_SConsoleNumberPortabilityExtension(stController);
            
            PageReference pageRef = Page.LG_SConsoleNumberPortability;
            pageRef.getParameters().put('id', String.valueOf(obj.Id));
            Test.setCurrentPage(pageRef);
        
            PageReference reference = controllerInstance.edit();

        test.stopTest();
        
        System.assertEquals(LG_ServiceConsoleBase.DisplayMode.edit, controllerInstance.getMode(), 'Invalid data');
        
    }
    
    @IsTest
    public static void cancelTest() {
        
        Case obj = [SELECT Id, status, LG_Service__c, LG_Solution__c, LG_Order__c, RecordType.Name FROM Case LIMIT 1];

        test.startTest();
        
            ApexPages.StandardController stController = new ApexPages.StandardController(obj);
            LG_SConsoleNumberPortabilityExtension controllerInstance = new LG_SConsoleNumberPortabilityExtension(stController);

            PageReference pageRef = Page.LG_SConsoleNumberPortability;
            pageRef.getParameters().put('id', String.valueOf(obj.Id));
            Test.setCurrentPage(pageRef);

            PageReference reference = controllerInstance.cancel();

        test.stopTest();
        
        System.assertEquals(LG_ServiceConsoleBase.DisplayMode.detail, controllerInstance.getMode(), 'Invalid data');
    }

    @IsTest
    public static void getProcessRequestsTest() {
        
        Case obj = [SELECT Id, status, LG_Service__c, LG_Solution__c, LG_Order__c, RecordType.Name FROM Case LIMIT 1];
        Map<Id, LG_PortingProcess__c> processes = new Map<Id, LG_PortingProcess__c>([SELECT Id FROM LG_PortingProcess__c]);
        
        test.startTest();
        
            ApexPages.StandardController stController = new ApexPages.StandardController(obj);
            LG_SConsoleNumberPortabilityExtension controllerInstance = new LG_SConsoleNumberPortabilityExtension(stController);
            
            List<LG_ProcessRequest__c> processRequests = controllerInstance.getProcessRequests(processes.keySet());

        test.stopTest();
        
        System.assertEquals(3, processRequests.size(), 'Invalid data');
    }
    
    @IsTest
    public static void getAssetsAssociationsTest() {
        
        Case obj = [SELECT Id, status, LG_Service__c, LG_Solution__c, LG_Order__c, RecordType.Name FROM Case LIMIT 1];
        Map<Id, LG_PortingProcess__c> processes = new Map<Id, LG_PortingProcess__c>([SELECT Id FROM LG_PortingProcess__c]);
        
        test.startTest();
        
            ApexPages.StandardController stController = new ApexPages.StandardController(obj);
            LG_SConsoleNumberPortabilityExtension controllerInstance = new LG_SConsoleNumberPortabilityExtension(stController);
            
            List<LG_AssetProcessAssociation__c> assetsAssociations = controllerInstance.getAssetsAssociations();
        
        test.stopTest();
        
        System.assertEquals(6, assetsAssociations.size(), 'Invalid data');
    }
    
    @IsTest
    public static void toogleEditTest() {
        
        Case obj = [SELECT Id, Status, LG_Service__c, LG_Solution__c, LG_Order__c, RecordType.Name FROM Case LIMIT 1];

        test.startTest();
        
            ApexPages.StandardController stController = new ApexPages.StandardController(obj);
            LG_SConsoleNumberPortabilityExtension controllerInstance = new LG_SConsoleNumberPortabilityExtension(stController);
            
            controllerInstance.toogleEdit();

        test.stopTest();
        
        System.assertEquals(true, controllerInstance.editor, 'Invalid data');
    }
    
    @IsTest
    public static void retrieveViewSubsetTest() {
        
        Case obj = [SELECT Id, status, LG_Service__c, LG_Solution__c, LG_Order__c, RecordType.Name FROM Case LIMIT 1];
        LG_PortingProcess__c process = [SELECT Id FROM LG_PortingProcess__c WHERE LG_Provider__c = 'Test' LIMIT 1];

        test.startTest();
        
            ApexPages.StandardController stController = new ApexPages.StandardController(obj);
            LG_SConsoleNumberPortabilityExtension controllerInstance = new LG_SConsoleNumberPortabilityExtension(stController);

            List<LG_SConsoleNumberPortabilityExtension.NumberPortabillityViewModel> viewSubset = controllerInstance.retrieveViewSubset(process.Id);

        test.stopTest();
        
        List<LG_ProcessRequest__c> requests = [SELECT Id FROM LG_ProcessRequest__c WHERE LG_Process__c = :process.Id ORDER BY LG_Process__c, CreatedDate DESC];
        
        System.assertEquals(1, viewSubset.size(), 'Invalid data');
        System.assertEquals(requests[0].Id, viewSubset[0].request.Id, 'Invalid data');
        System.assertEquals(requests[1].Id, viewSubset[0].previousRequest.Id, 'Invalid data');
    }
    
    @IsTest
    public static void numberPortabillityViewModelTest() {
        
        Case caseObj = [SELECT Id, status, LG_Service__c, LG_Solution__c, LG_Order__c, RecordType.Name FROM Case LIMIT 1];
        LG_PortingProcess__c process = [SELECT Id FROM LG_PortingProcess__c WHERE LG_Provider__c = 'Test' LIMIT 1];
        
        Account acc = [SELECT Id FROM Account LIMIT 1];
        csord__Service__c service = [SELECT Id FROM csord__Service__c LIMIT 1];
        
        Id numberBlockRTId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Number Block').getRecordTypeId();
        
        Asset obj = new Asset();

        obj.name='090123';
        obj.AccountId = acc.Id;
        obj.csord__Service__c = service.Id;
        obj.LG_NumberRangeType__c = 'Portin';
        obj.LG_TelephonyService__c = service.Id;
        obj.RecordTypeId         = numberBlockRTId;
        obj.LG_PortInInitials__c = 'Mr.';
        obj.LG_PortInName__c = 'Test Person';
        obj.LG_PortInStreet__c = 'First street';
        obj.LG_PortInHouseNumber__c = '25';
        obj.LG_PortInHouseNumberExtension__c = 'A';
        obj.LG_PortInZipcode__c = '10000';
        obj.LG_PortInCity__c = 'Agram';
        
        insert obj;
        
        
        LG_AssetProcessAssociation__c association = new LG_AssetProcessAssociation__c(LG_Asset__c = obj.Id, LG_Process__c = process.Id);
        insert association;
        
        // Reload data
        LG_AssetProcessAssociation__c associationData = [SELECT Id, Name, LG_Asset__c,
                                                            LG_Asset__r.LG_PortInInitials__c,
                                                            LG_Asset__r.LG_PortInName__c,
                                                            LG_Asset__r.LG_PortInStreet__c,
                                                            LG_Asset__r.LG_PortInHouseNumber__c,
                                                            LG_Asset__r.LG_PortInHouseNumberExtension__c,
                                                            LG_Asset__r.LG_PortInZipcode__c,
                                                            LG_Asset__r.LG_PortInCity__c,
                                                            LG_Process__c,
                                                            LG_Process__r.LG_ChangeIndicator__c
                                                        FROM LG_AssetProcessAssociation__c 
                                                        WHERE ID = :association.Id];

        test.startTest();
        
            LG_SConsoleNumberPortabilityExtension.NumberPortabillityViewModel model = new LG_SConsoleNumberPortabilityExtension.NumberPortabillityViewModel(associationData);

        test.stopTest();
        
        String expected = String.Join(new List<String>
                                    (new Set<String> 
                                        {
                                            obj.LG_PortInInitials__c,
                                            obj.LG_PortInName__c,
                                            obj.LG_PortInStreet__c,
                                            obj.LG_PortInHouseNumber__c,
                                            obj.LG_PortInHouseNumberExtension__c,
                                            obj.LG_PortInZipcode__c,
                                            obj.LG_PortInCity__c
                                        }
                                    ), ', ');
                                    
        System.assertEquals(expected, model.donorAccount, 'Invalid data');
    }
    public static testmethod void savesoltest(){
        test.startTest();
        csord__Solution__c sol=[select id from csord__Solution__c limit 1];
        Case obj = [SELECT Id, status, LG_Service__c, LG_Solution__c, LG_Order__c, RecordType.Name FROM Case LIMIT 1];
        Map<Id, LG_PortingProcess__c> processes = new Map<Id, LG_PortingProcess__c>([SELECT Id FROM LG_PortingProcess__c]);
        
        
            ApexPages.StandardController stController = new ApexPages.StandardController(obj);
            LG_SConsoleNumberPortabilityExtension controllerInstance = new LG_SConsoleNumberPortabilityExtension(stController);
            //controllerInstance.savesolution();
        controllerInstance.editsolution();
        controllerInstance.cancelsolution();
        
        
        test.stopTest();
        
    }
}