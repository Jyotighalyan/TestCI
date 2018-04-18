/**
* MACD Migrate helper class
* 
* @author Petar Miletic
* @story SFDT-401
* @since  25/05/2017
*/
@IsTest
public class LG_CloneAssetsUtilTest {

    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        Account acc = LG_GeneralTest.CreateAccount('TestAccount', '321654987', 'Test', true);

        List<Opportunity> oportunities = new List<Opportunity>();

        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, false);
        opp.StageName = 'Order Generated';

        Opportunity oppNew = LG_GeneralTest.CreateOpportunity(acc, false);
        oppNew.StageName = 'Order Generated New';
        
        oportunities.add(opp);
        oportunities.add(oppNew);
        
        insert oportunities;
        
        List<cscfga__Product_Basket__c> productBaskets = new List<cscfga__Product_Basket__c>();
        
        cscfga__Product_Basket__c pb = new cscfga__Product_Basket__c();
        pb.Name = 'Test';
        pb.cscfga__Opportunity__c = opp.Id;
        pb.csordtelcoa__Synchronised_with_Opportunity__c = true;
        pb.csbb__Synchronised_With_Opportunity__c = true;
        pb.csbb__Account__c = acc.Id;
        
        cscfga__Product_Basket__c pbNew = new cscfga__Product_Basket__c();
        pbNew.Name = 'Test New';
        pbNew.cscfga__Opportunity__c = oppNew.Id;
        pbNew.csordtelcoa__Synchronised_with_Opportunity__c = true;
        pbNew.csbb__Synchronised_With_Opportunity__c = true;
        pbNew.csbb__Account__c = acc.Id;
        
        productBaskets.add(pb);
        productBaskets.add(pbNew);
        
        insert productBaskets;

        List<cscfga__Product_Definition__c> productDefinitions = new List<cscfga__Product_Definition__c>();

        cscfga__Product_Definition__c pd = new cscfga__Product_Definition__c();
        pd.Name = 'Generic Product Definition';
        pd.cscfga__Description__c = 'Generic Product Definition';

        cscfga__Product_Definition__c pdNew = new cscfga__Product_Definition__c();
        pdNew.Name = 'Generic Product Definition New';
        pdNew.cscfga__Description__c = 'Generic Product Definition';

        productDefinitions.add(pd);
        productDefinitions.add(pdNew);
        
        insert productDefinitions;
        
        cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c();
        pc.Name = 'Test Product Configuration';
        pc.cscfga__Description__c = 'Test Product Configuration';
        pc.cscfga__Product_Family__c = 'Test Product Configuration';
        pc.cscfga__Product_Definition__c = pd.Id;
        pc.cscfga__Product_Basket__c = pb.Id;

        insert pc;

        cscfga__Product_Configuration__c pcNew = new cscfga__Product_Configuration__c();
        pcNew.Name = 'Test Product Configuration New';
        pcNew.cscfga__Description__c = 'Test Product Configuration';
        pcNew.cscfga__Product_Family__c = 'Test Product Configuration';
        pcNew.cscfga__Product_Definition__c = pdNew.Id;
        pcNew.cscfga__Product_Basket__c = pbNew.Id;
        pcNew.csordtelcoa__Replaced_Product_Configuration__c = pc.Id;
        
        insert pcNew;
        
        // Create record types
        RecordType numberBlockRecordType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Asset' AND Name = 'Number Block'];
        RecordType phoneNumberRecordType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Asset' AND Name = 'Phone Number'];
        
        List<Asset> assets = new List<Asset>();
        List<Asset> topAssets = new List<Asset>();
        
        // Top level asset (number block)
        Asset topAssetFirst = new Asset(Name = 'Asset_F', AccountId = acc.Id, LG_NumberRangeType__c = 'Port-In', RecordTypeId = numberBlockRecordType.Id,
                                        LG_StartNumber__c = '000', LG_EndNumber__c = '004', LG_PortInWishDate__c = Date.today().addDays(-5), LG_TelephonyProductConfiguration__c = pc.Id, LG_SoftDeleted__c = false);
        topAssets.add(topAssetFirst);
        
        Asset topAssetSecond = new Asset(Name = 'Asset_S', AccountId = acc.Id, LG_NumberRangeType__c = 'Port-In', RecordTypeId = numberBlockRecordType.Id,
                                        LG_StartNumber__c = '000', LG_EndNumber__c = '004', LG_PortInWishDate__c = Date.today().addDays(4), LG_TelephonyProductConfiguration__c = pc.Id, LG_SoftDeleted__c = false);
        topAssets.add(topAssetSecond);
        
        insert topAssets;
        
        for (Integer i = 1; i < 6; i++) {

            Asset obj = new Asset(Name = 'Asset_' + i, AccountId = acc.Id);

            obj.LG_NumberRangeType__c = 'Port-In';
            obj.RecordTypeId = phoneNumberRecordType.Id;
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
        
        insert assets;

        // Insert process
        LG_PortingProcess__c pProcess = new LG_PortingProcess__c();
        pProcess.LG_Account__c = acc.Id;
        insert pProcess;
        
        List<LG_ProcessRequest__c> processRequests = new List<LG_ProcessRequest__c>();
        
        LG_ProcessRequest__c request = new LG_ProcessRequest__c();
        request.LG_Process__c = pProcess.Id;
        request.LG_Response__c = 'Success';
        
        processRequests.add(request);
        
        LG_ProcessRequest__c request2 = new LG_ProcessRequest__c();
        request2.LG_Process__c = pProcess.Id;
        request2.LG_Response__c = 'Success';
        
        processRequests.add(request2);
        
        insert processRequests;

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
    
    @IsTest
    public static void cloneUsingOportunityIdsTest() {
        
        Opportunity first = [SELECT Id FROM Opportunity WHERE StageName = 'Order Generated' LIMIT 1];
        Opportunity second = [SELECT Id FROM Opportunity WHERE StageName = 'Order Generated New' LIMIT 1];
        
        Id newOppId = second.Id;
        
        cscfga__Product_Configuration__c pc = [SELECT Id, Name, csordtelcoa__Replaced_Product_Configuration__c FROM cscfga__Product_Configuration__c WHERE Name = 'Test Product Configuration' LIMIT 1];
        
        List<LG_AssetProcessAssociation__c> associationsBefore = [SELECT Id, Name, LG_Process__c FROM LG_AssetProcessAssociation__c WHERE LG_Asset__r.LG_TelephonyProductConfiguration__c = :pc.Id];

        Set<Id> portinProcesses = new Set<Id>();
        
        List<Asset> assets = [SELECT Id, 
                                    Name, 
                                    LG_SoftDeleted__c
                                FROM Asset 
                                WHERE LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c = :first.Id OR 
                                        LG_NumberRangeProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c = :first.Id];
                                        
        List<LG_AssetProcessAssociation__c> assetProcessAssociations = [SELECT Id, Name, LG_Process__c
                                                                            FROM LG_AssetProcessAssociation__c 
                                                                            WHERE LG_Asset__r.LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c = :first.Id OR 
                                                                                    LG_Asset__r.LG_NumberRangeProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c = :first.Id];
                                                                                    
        for (LG_AssetProcessAssociation__c ap :assetProcessAssociations) {
            portinProcesses.add(ap.LG_Process__c);
        }

        // Validate previous state
        System.assertEquals(7, assets.size(), 'Invalid asset data');
        System.assertEquals(1, portinProcesses.size(), 'Invalid porting process data');
        System.assertEquals(7, assetProcessAssociations.size(), 'Invalid asset to process association data');

        Test.startTest();

        LG_CloneAssetsUtil.cloneUsingOportunityIds(second.Id, first.Id);

        Test.stopTest();

        // Requery new data
        String[] types = new String[]{ 'Asset', 'LG_AssetProcessAssociation__c', 'LG_PortingProcess__c', 'LG_ProcessRequest__c' };
        
        Map<String, Set<String>> fieldMap = LG_ReflectionUtil.getObjectFieldsMap(types);

        String columnsAA = LG_ReflectionUtil.getColumns(fieldMap.get('LG_AssetProcessAssociation__c'), '');
        String columnsAs = LG_ReflectionUtil.getColumns(fieldMap.get('Asset'), 'LG_Asset__r');
        String columnsPP = LG_ReflectionUtil.getColumns(fieldMap.get('LG_PortingProcess__c'), 'LG_Process__r');
        
        String columns = columnsAA + ', ' + columnsAs + ', ' + columnsPP;

        // Retrieve Asset Process Associations with Asset and Process data
        List<LG_AssetProcessAssociation__c> assetAssociations = Database.query('SELECT ' + columns + ' FROM LG_AssetProcessAssociation__c WHERE LG_Asset__r.LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c = :newOppId');
        
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

        // Validate new state
        System.assertEquals(7, assetsNew.size(), 'Invalid data');
        System.assertEquals(1, processesNew.size(), 'Invalid data');
        System.assertEquals(7, assetAssociations.size(), 'Invalid data');
        System.assertEquals(2, requests.size(), 'Invalid data');
    }
    
    @IsTest
    public static void cloneUsingProductBasketIdTest() {

        cscfga__Product_Basket__c pb = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'Test' LIMIT 1];
        cscfga__Product_Basket__c pbNew = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'Test New' LIMIT 1];

        Id basketId = pbNew.Id;
        
        cscfga__Product_Configuration__c pc = [SELECT Id, Name, csordtelcoa__Replaced_Product_Configuration__c FROM cscfga__Product_Configuration__c WHERE Name = 'Test Product Configuration' LIMIT 1];
        
        List<LG_AssetProcessAssociation__c> associationsBefore = [SELECT Id, Name, LG_Process__c FROM LG_AssetProcessAssociation__c WHERE LG_Asset__r.LG_TelephonyProductConfiguration__c = :pc.Id];

        Set<Id> portinProcesses = new Set<Id>();
        
        List<Asset> assets = [SELECT Id, 
                                    Name, 
                                    LG_SoftDeleted__c
                                FROM Asset 
                                WHERE LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__c = :pb.Id OR 
                                        LG_NumberRangeProductConfiguration__r.cscfga__Product_Basket__c = :pb.Id];
                                        
        List<LG_AssetProcessAssociation__c> assetProcessAssociations = [SELECT Id, Name, LG_Process__c
                                                                            FROM LG_AssetProcessAssociation__c 
                                                                            WHERE LG_Asset__r.LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__c = :pb.Id OR 
                                                                                    LG_Asset__r.LG_NumberRangeProductConfiguration__r.cscfga__Product_Basket__c = :pb.Id];
                                                                                    
        for (LG_AssetProcessAssociation__c ap :assetProcessAssociations) {
            portinProcesses.add(ap.LG_Process__c);
        }

        // Validate previous state
        System.assertEquals(7, assets.size(), 'Invalid asset data');
        System.assertEquals(1, portinProcesses.size(), 'Invalid porting process data');
        System.assertEquals(7, assetProcessAssociations.size(), 'Invalid asset to process association data');

        Test.startTest();

        LG_CloneAssetsUtil.cloneUsingProductBasketId(pbNew.Id);

        Test.stopTest();

        // Requery new data
        String[] types = new String[]{ 'Asset', 'LG_AssetProcessAssociation__c', 'LG_PortingProcess__c', 'LG_ProcessRequest__c' };
        
        Map<String, Set<String>> fieldMap = LG_ReflectionUtil.getObjectFieldsMap(types);

        String columnsAA = LG_ReflectionUtil.getColumns(fieldMap.get('LG_AssetProcessAssociation__c'), '');
        String columnsAs = LG_ReflectionUtil.getColumns(fieldMap.get('Asset'), 'LG_Asset__r');
        String columnsPP = LG_ReflectionUtil.getColumns(fieldMap.get('LG_PortingProcess__c'), 'LG_Process__r');
        
        String columns = columnsAA + ', ' + columnsAs + ', ' + columnsPP;

        // Retrieve Asset Process Associations with Asset and Process data
        List<LG_AssetProcessAssociation__c> assetAssociations = Database.query('SELECT ' + columns + ' FROM LG_AssetProcessAssociation__c WHERE LG_Asset__r.LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__c = :basketId');
        
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

        // Validate new state
        System.assertEquals(7, assetsNew.size(), 'Invalid data');
        System.assertEquals(1, processesNew.size(), 'Invalid data');
        System.assertEquals(7, assetAssociations.size(), 'Invalid data');
        System.assertEquals(2, requests.size(), 'Invalid data');
        
    }
}