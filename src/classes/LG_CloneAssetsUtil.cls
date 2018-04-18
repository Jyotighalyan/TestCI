/**
* MACD Migrate helper class
* 
* @author Petar Miletic
* @story SFDT-401
* @since  24/05/2017
*/
public class LG_CloneAssetsUtil {

    public static void cloneUsingOportunityIds(Id newOpportuntiyId, Id oldOpportuntiyId) {
        
        String[] types = new String[]{ 'Asset', 'LG_AssetProcessAssociation__c', 'LG_PortingProcess__c', 'LG_ProcessRequest__c' };
        
        Map<String, Set<String>> fieldMap = LG_ReflectionUtil.getObjectFieldsMap(types);

        String columnsAA = LG_ReflectionUtil.getColumns(fieldMap.get('LG_AssetProcessAssociation__c'), '');
        String columnsAs = LG_ReflectionUtil.getColumns(fieldMap.get('Asset'), 'LG_Asset__r');
        String columnsPP = LG_ReflectionUtil.getColumns(fieldMap.get('LG_PortingProcess__c'), 'LG_Process__r');
        
        // Get new Product Configurations
        List<cscfga__Product_Configuration__c> productConfigurations = [SELECT Id, 
                                                                            Name,
                                                                            csordtelcoa__Replaced_Product_Configuration__c,
                                                                            cscfga__Product_Basket__r.cscfga__Opportunity__c
                                                                        FROM cscfga__Product_Configuration__c 
                                                                        WHERE cscfga__Product_Basket__r.cscfga__Opportunity__c = :newOpportuntiyId];

        List<Asset> assets = Database.query('SELECT ' + LG_ReflectionUtil.getColumns(fieldMap.get('Asset'), '') + ' FROM Asset WHERE LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c = :oldOpportuntiyId OR LG_NumberRangeProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c = :oldOpportuntiyId');

        /**
         * Query is expanded to use LG_NumberRangeProductConfiguration__c as well
         *
         * @author Petar Miletic
         * @ticket SFOM-689
         * @since  28/04/2017
        */ 
        String columns = columnsAA + ', ' + columnsAs + ', ' + columnsPP;
        List<LG_AssetProcessAssociation__c> assetAssociations = Database.query('SELECT ' + columns + ' FROM LG_AssetProcessAssociation__c WHERE LG_Asset__r.LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c = :oldOpportuntiyId OR LG_Asset__r.LG_NumberRangeProductConfiguration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c = :oldOpportuntiyId');
        
        LG_CloneAssetsUtil.cloneNumbersAndRelatedRecords(productConfigurations, assets, assetAssociations);
    }
    
    public static void cloneUsingProductBasketId(Id newProductBasketId) {

        String[] types = new String[]{ 'Asset', 'LG_AssetProcessAssociation__c', 'LG_PortingProcess__c', 'LG_ProcessRequest__c' };
        
        Map<String, Set<String>> fieldMap = LG_ReflectionUtil.getObjectFieldsMap(types);

        String columnsAA = LG_ReflectionUtil.getColumns(fieldMap.get('LG_AssetProcessAssociation__c'), '');
        String columnsAs = LG_ReflectionUtil.getColumns(fieldMap.get('Asset'), 'LG_Asset__r');
        String columnsPP = LG_ReflectionUtil.getColumns(fieldMap.get('LG_PortingProcess__c'), 'LG_Process__r');
        
        // Get new Product Configurations
        List<cscfga__Product_Configuration__c> productConfigurations = [SELECT Id, 
                                                                            Name,
                                                                            csordtelcoa__Replaced_Product_Configuration__c,
                                                                            cscfga__Product_Basket__r.cscfga__Opportunity__c
                                                                        FROM cscfga__Product_Configuration__c 
                                                                        WHERE cscfga__Product_Basket__c = :newProductBasketId];
                                                                        
            
        Set<Id> pcIds = new Set<Id>();
        
        for (cscfga__Product_Configuration__c pc :productConfigurations) {
            
            if (String.isNotBlank(pc.csordtelcoa__Replaced_Product_Configuration__c)) {
                
                pcIds.add(pc.csordtelcoa__Replaced_Product_Configuration__c);
            }
        }
        
        if (!pcIds.isEmpty()) {

            List<Asset> assets = Database.query('SELECT ' + LG_ReflectionUtil.getColumns(fieldMap.get('Asset'), '') + ' FROM Asset WHERE LG_TelephonyProductConfiguration__c IN :pcIds OR LG_NumberRangeProductConfiguration__c IN :pcIds');
            
            /**
             * Query is expanded to use LG_NumberRangeProductConfiguration__c as well
             *
             * @author Petar Miletic
             * @ticket SFOM-689
             * @since  28/04/2017
            */ 
            String columns = columnsAA + ', ' + columnsAs + ', ' + columnsPP;
            List<LG_AssetProcessAssociation__c> assetAssociations = Database.query('SELECT ' + columns + ' FROM LG_AssetProcessAssociation__c WHERE LG_Asset__r.LG_TelephonyProductConfiguration__c IN :pcIds OR LG_Asset__r.LG_NumberRangeProductConfiguration__c IN :pcIds');
            
            LG_CloneAssetsUtil.cloneNumbersAndRelatedRecords(productConfigurations, assets, assetAssociations);
        }
    }
    
    /**
     * Remap numbers to active version  
     *
     * @author Petar Miletic
     * @ticket SFOM-498
     * @since  20/03/2017
    */  
    @TestVisible
    public static void cloneNumbersAndRelatedRecords(List<cscfga__Product_Configuration__c> productConfigurations, List<Asset> assets, List<LG_AssetProcessAssociation__c> assetAssociations) {

        String[] types = new String[]{ 'LG_PortingProcess__c', 'LG_ProcessRequest__c' };
        
        Map<String, Set<String>> fieldMap = LG_ReflectionUtil.getObjectFieldsMap(types);

        Map<Id, Asset> newAssets = new Map<Id, Asset>();

        // Prepare Asset Process Associations
        for (Asset obj :assets) {
            
            if (!newAssets.containsKey(obj.Id)) {
                Asset clone = obj.clone(false, true, false, false);
                
                 for (cscfga__Product_Configuration__c pc :productConfigurations) {
    
                    // If old PC is equal to replaced PC then update
                    if (obj.LG_TelephonyProductConfiguration__c == pc.csordtelcoa__Replaced_Product_Configuration__c) {
                        clone.LG_TelephonyProductConfiguration__c = pc.Id;
                    }
                    
                    if (obj.LG_NumberRangeProductConfiguration__c == pc.csordtelcoa__Replaced_Product_Configuration__c) {
                        clone.LG_NumberRangeProductConfiguration__c = pc.Id;
                    }
                }
                
                newAssets.put(obj.Id, clone);
            }
        }

        if (!newAssets.isEmpty()) {
            insert newAssets.values();
        }
        
        if (!assetAssociations.isEmpty()) {
        
            // Prepare data for cloning
            Map<Id, LG_PortingProcess__c> newPortingProcesses = new Map<Id, LG_PortingProcess__c>();

            // Prepare Asset Process Associations
            for (LG_AssetProcessAssociation__c obj :assetAssociations) {

                if (!newPortingProcesses.containsKey(obj.LG_Process__c)) {
                    newPortingProcesses.put(obj.LG_Process__c, obj.LG_Process__r.clone(false, true, false, false));
                }
            }
            
            Set<Id> Ids = newPortingProcesses.keySet();
            
            // Get Process Requests
            String processRequestColumns = LG_ReflectionUtil.getColumns(fieldMap.get('LG_ProcessRequest__c'), '');
            List<LG_ProcessRequest__c> processRequests = Database.query('SELECT ' + processRequestColumns + ' FROM LG_ProcessRequest__c WHERE LG_Process__c IN :Ids');

            insert newPortingProcesses.values();

            // Clone junction
            List<LG_AssetProcessAssociation__c> newAssetAssociations = assetAssociations.deepClone(false, false, false);

            // Remap old Assets to new Asset Ids
            for (Id key :newAssets.keySet()) {
    
                Asset tmp = newAssets.get(key);
    
                // Remap associations
                for (LG_AssetProcessAssociation__c newAssociation :newAssetAssociations) {
                    
                    if (newAssociation.LG_Asset__c == key) {
                        newAssociation.LG_Asset__c = tmp.Id;
                    } 
                }
            }
            
            // Prepare list for new requests
            List<LG_ProcessRequest__c> newProcessRequests = new List<LG_ProcessRequest__c>();
            
            // Remap old Processes to new Process Ids
            for (Id key :newPortingProcesses.keySet()) {
    
                LG_PortingProcess__c tmp = newPortingProcesses.get(key);
    
                // Remap associations
                for (LG_AssetProcessAssociation__c newAssociation :newAssetAssociations) {
                    
                    if (newAssociation.LG_Process__c == key) {
                        newAssociation.LG_Process__c = tmp.Id;
                    } 
                }
                
                for (LG_ProcessRequest__c pr :processRequests) {
                    
                    LG_ProcessRequest__c newPR = pr.clone(false, true, false, false);
                    
                    if (newPR.LG_Process__c == key) {
                        newPR.LG_Process__c = tmp.Id;
                        
                        newProcessRequests.add(newPR);
                    }
                }
            }
            
            // Insert new junction object
            insert newAssetAssociations;

            // Insert requests
            insert newProcessRequests;
        }
    }
}