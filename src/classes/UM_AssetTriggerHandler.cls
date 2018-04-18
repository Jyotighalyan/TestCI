public with sharing class UM_AssetTriggerHandler {

    /*
     * Description: Creates related assets for all assets linked with the supplied list of Services.
     *
	*/
    public static void createChildAssets(map<id,Asset> newAssets,map<id,Asset>oldAssets){
        list<asset> assetsList = new list<asset>();
        list<asset> childAssetList = new list<asset>();
        String query= 'SELECT ';

        set<id> newAssetIds = newAssets.keySet();

        for(Schema.FieldSetMember f : SObjectType.Asset.FieldSets.UM_CloneAssetFields.getFields()){
            query += f.getFieldPath() + ', ';
        }

        query += ' Id,csord__Service__r.LG_Quantity__c,csord__Service__r.csord__Order__r.csord__Account__c, AccountId,'+
            		'csordtelcoa__Replaced_Asset__c,csordtelcoa__Replacement_Asset__c from Asset where id in :newAssetIds and ParentId=null';
        assetsList = Database.query(query);

        for(asset a : assetsList){
            if(a.csord__Service__c!=null && oldAssets.get(a.id).csord__Service__c==null){
                for(integer iCount=0;iCount<a.csord__Service__r.LG_Quantity__c;iCount++){
                    System.debug('+++ createChildAssets: iCount='+iCount);

                    Asset childAsset = new Asset();
                    for(Schema.FieldSetMember f : SObjectType.Asset.FieldSets.UM_CloneAssetFields.getFields()){
                        childAsset.AccountId = a.AccountId;
                        childAsset.ParentId = a.id;
                        childAsset.put(f.getFieldPath(),a.get(f.getFieldPath()));
                    }

                    childAssetList.add(childAsset);
                }
            }
        }

		insert childAssetList;
    }

    /*
     * Description: Copies values from Original Assets to the new MACD Assets, including related assets.
	*/
    public static void cloneAssetsForProduct(map<id,Asset> newAssets, map<id,Asset> oldAssets){
        map<id,asset> oldNewAssetsMap = new map<id,Asset>();
        list<asset> MACDAssets = new list<asset>();
        list<asset> MACDAssetList = new list<asset>();
		set<id> MACDAssetIds = new set<id>();

        System.debug('*** cloneAssetsForProduct: newAssets='+newAssets);

        for(asset a : newAssets.values()){
            if(a.csordtelcoa__Replacement_Asset__c!=null && oldAssets.get(a.id).csordtelcoa__Replacement_Asset__c==null){
                if(a.csordtelcoa__Replacement_Asset__c!=null && a.ParentId==null)
                    MACDAssetIds.add(a.csordtelcoa__Replacement_Asset__c);
            }
        }
        System.debug('*** MACDAssetIds='+MACDAssetIds);

        String query = 'SELECT ';
        String whereClause = 'Id,csordtelcoa__Replaced_Asset__c,csordtelcoa__Replacement_Asset__c FROM Asset where id in :MACDAssetIds AND Status!=\'Inactive\' AND ParentId=null';

        for(Schema.FieldSetMember f : SObjectType.Asset.FieldSets.UM_CloneAssetFields.getFields()){
            query += f.getFieldPath() + ', ';
        }

        String qryMACDAssets = query + whereClause;
        if (!MACDAssetIds.isEmpty()) {
        MACDAssets = Database.query(qryMACDAssets);
        }

        for(Asset a : MACDAssets){
            oldNewAssetsMap.put(a.csordtelcoa__Replaced_Asset__c,a);
        }
        System.debug('*** oldNewAssetsMap='+oldNewAssetsMap);
        for(Asset a : newAssets.values()){
            Asset MACDAsset = oldNewAssetsMap.get(a.id);
            System.debug('*** cloneAssetsForProduct: replacedAsset='+MACDAsset);
            if(MACDAsset!=null){
                if(a.csord__Asset_Value__c==MACDAsset.csord__Asset_Value__c){
                    for(Schema.FieldSetMember f : SObjectType.Asset.FieldSets.UM_CloneAssetFields.getFields()){
                        MACDAsset.put(f.getFieldPath(),a.get(f.getFieldPath()));
                    }
                }else{
                    for(Schema.FieldSetMember f : SObjectType.Asset.FieldSets.UM_CopyChildAssets.getFields()){
                        MACDAsset.put(f.getFieldPath(),a.get(f.getFieldPath()));
                    }
                }
                MACDAssetList.add(MACDAsset);
            }

        }
        update MACDAssetList;
    }

    /*
     * Description: Copies field values for MACD related assets from the original related assets.
    */
    public static void updateChildAssets(map<id,asset> newAssets,map<id,asset> oldAssets){
        list<asset> oldChildAssetList = new list<asset>();
        list<asset> newChildAssetList = new list<asset>();
        list<asset> originalAssets = new list<asset>();
        set<id> oldAssetIds = new set<id>();
        set<id> newAssetIds = new set<id>();

        String query='SELECT ';
        String whereClause, oldQuery, newQuery;

        for(Schema.FieldSetMember f : SObjectType.Asset.FieldSets.UM_CloneAssetFields.getFields()){
            query += f.getFieldPath() + ', ';
        }

        for(asset a : newAssets.values()){
		    if(a.csord__Service__c!=null && oldAssets.get(a.id).csord__Service__c==null){
                if(a.csordtelcoa__Replaced_Asset__c!=null && a.ParentId==null)
            	   oldAssetIds.add(a.csordtelcoa__Replaced_Asset__c);
		    }
        }
        System.debug('+++ updateChildAssets: oldAssetIds='+oldAssetIds);

        whereClause = 'Id,csordtelcoa__Replacement_Asset__c,csordtelcoa__Replaced_Asset__c FROM Asset where id in :oldAssetIds AND Status!=\'Inactive\' AND ParentId=null';

        String qryOriginalAssets = query + whereClause;

        if(oldAssetIds!=null && !oldAssetIds.isEmpty()){
            originalAssets = Database.query(qryOriginalAssets);
        }
        System.debug('+++ updateChildAssets: originalAssets='+originalAssets);

        query += ' Id,csord__Service__r.LG_Quantity__c,Parent.csordtelcoa__Replacement_Asset__c,Parent.csordtelcoa__Replaced_Asset__c from Asset ';
        whereClause = ' WHERE ParentId in :originalAssets AND Status!=\'Inactive\'';
        oldQuery = query + whereClause;

        if(originalAssets!=null && !originalAssets.isEmpty()){
            oldChildAssetList = Database.query(oldQuery);
        }
        System.debug('+++ updateChildAssets: oldChildAssetList='+oldChildAssetList);

        newAssetIds = newAssets.keySet();
        whereClause = ' WHERE ParentId in :newAssetIds';
        newQuery = query + whereClause;

        if(oldChildAssetList!=null && !oldChildAssetList.isEmpty()){
            newChildAssetList = Database.query(newQuery);
        }
        System.debug('+++ updateChildAssets: newChildAssetList='+newChildAssetList);

        for(asset oldAsset : oldChildAssetList){
            for(Asset newChildAsset : newChildAssetList){
                if(oldAsset.Parent.csordtelcoa__Replacement_Asset__c==newChildAsset.Parent.csordtelcoa__Replaced_Asset__c){
                    if(oldAsset.csord__Asset_Value__c==newChildAsset.csord__Asset_Value__c){
                        for(Schema.FieldSetMember f : SObjectType.Asset.FieldSets.UM_CloneAssetFields.getFields()){
                            newChildAsset.put(f.getFieldPath(),oldAsset.get(f.getFieldPath()));
                        }
                    }else{
                        for(Schema.FieldSetMember f : SObjectType.Asset.FieldSets.UM_CopyChildAssets.getFields()){
                            newChildAsset.put(f.getFieldPath(),oldAsset.get(f.getFieldPath()));
                        }
                    }
                }
            }
        }
        System.debug('+++ updateChildAssets: After Update --- newChildAssetList='+newChildAssetList);
        if(newChildAssetList!=null && !newChildAssetList.isEmpty())
    		update newChildAssetList;
    }

}