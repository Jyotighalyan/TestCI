public class UM_VWStagingDataAccess{
    
    public Map<String,csord__Service__c> getKundenSetupWithChildsServices(set<string> vwsHPBXImplExtIdSet, set<string> nonSubscriberVWObjIdSet)
    {
        map<string,csord__Service__c> externalIdServiceMap = new map<string,csord__Service__c>();
        for(csord__Service__c ser : [SELECT Id, csord__Subscription__c, UM_HPBXExternalId__c, LG_Address__c,LG_ServiceStatus__c, csord__Status__c,
                                        csord__Subscription__r.LG_Contract__c, UM_SubscriberName__c, UM_PhoneExtension__c, csord__Subscription__r.csconta__Billing_Account__c,
                                        csord__Subscription__r.Sales_Partner_Id__c,
                                            (SELECT Id,csord__Subscription__c,csord__Identification__c,UM_VoiceWorksObjectId__c,LG_Address__c,
                                                UM_SubscriberName__c, UM_PhoneExtension__c, UM_StoreOrderNumber__c, LG_ServiceStatus__c, csord__Status__c
                                              FROM  csord__Services__r 
                                              WHERE UM_VoiceWorksObjectId__c IN: nonSubscriberVWObjIdSet
                                                AND UM_StoreOrderNumber__c = null)
                                       FROM csord__Service__c 
                                       WHERE UM_HPBXExternalId__c IN: vwsHPBXImplExtIdSet
                                        AND Name = 'Virtual Voice Kundensetup'
                                        AND csord__Service__c = NULL
                                        AND (LG_ServiceStatus__c = 'Active' OR csord__Status__c = 'Active')])
        {
            externalIdServiceMap.put(ser.UM_HPBXExternalId__c, ser);
        }                                                                                             
        return externalIdServiceMap;
    }
    
    public map<string, csord__Service__c> getSubscriberWithChildServices(set<string> subscriberIdSet)
    {
        map<string, csord__Service__c> subIdServiceMap = new map<string, csord__Service__c>();
        
        for(csord__Service__c ser : [SELECT Id, csord__Subscription__c, UM_HPBXExternalId__c, UM_SubscriberID__c,
                                        UM_VoiceWorksObjectId__c, csordtelcoa__Delta_Status__c, LG_ServiceStatus__c, csord__Status__c, 
                                        UM_SubscriberName__c, UM_PhoneExtension__c,LG_Address__c,
                                            (SELECT Id, csord__Subscription__c, UM_HPBXExternalId__c, UM_SubscriberID__c,
                                                UM_VoiceWorksObjectId__c, csordtelcoa__Delta_Status__c, LG_ServiceStatus__c, csord__Status__c, csord__Service__c, 
                                                UM_SubscriberName__c, UM_PhoneExtension__c
                                            FROM csord__Services__r)
                                    FROM csord__Service__c 
                                    WHERE UM_SubscriberID__c IN: subscriberIdSet
                                        AND csord__Service__c = null])
        {
            subIdServiceMap.put(ser.UM_SubscriberID__c, ser);
        }
        
        return subIdServiceMap;
    }
    
    public map<string,csconta__Billing_Account__c> getBillingAccounts(set<string> billingAccountIdSet)
    {
        map<string,csconta__Billing_Account__c> baNumberBillingAccountMap = new map<string,csconta__Billing_Account__c>();
        
        for(csconta__Billing_Account__c ba : [SELECT Id, LG_BillingAccountNumber__c, csconta__Account__c 
                                              FROM csconta__Billing_Account__c 
                                              WHERE LG_BillingAccountNumber__c IN: billingAccountIdSet])
        {
            baNumberBillingAccountMap.put(ba.LG_BillingAccountNumber__c, ba);
        }
        return baNumberBillingAccountMap;
    }
    
    public map<string,cscrm__Address__c> getAddressData(set<string> premiseNumberSet)
    {
        map<string,cscrm__Address__c> premiseNumberPremiseMap = new map<string,cscrm__Address__c>();
        
        for(cscrm__Address__c premise : [SELECT Id, LG_PremiseNumber__c, cscrm__Country__c 
                                        FROM cscrm__Address__c 
                                        WHERE LG_PremiseNumber__c IN: premiseNumberSet])
        {
            premiseNumberPremiseMap.put(premise.LG_PremiseNumber__c, premise);
        }
        return premiseNumberPremiseMap;
    }
    
    public Map<String,List<csord__Service__c>> getExistingServicesWithAssets(set<string> storeOrderNumberSet)
    {
        Map<String,List<csord__Service__c>> storeOrderServicesMap = new Map<String,List<csord__Service__c>>();
        
        for(csord__Service__c ser : [SELECT Id,UM_StoreOrderNumber__c,csord__Subscription__r.csord__Account__c,
                                                    (Select Id from csord__Salesforce_Assets__r) 
                                             FROM csord__Service__c 
                                             WHERE UM_StoreOrderNumber__c IN: storeOrderNumberSet
                                             AND csord__Service__c != null
                                             AND (LG_ServiceStatus__c = 'Active' OR csord__Status__c = 'Active')
                                             ORDER BY Name ASC]){
            if(storeOrderServicesMap.containsKey(ser.UM_StoreOrderNumber__c)){
                List<csord__Service__c> sList = storeOrderServicesMap.get(ser.UM_StoreOrderNumber__c);
                sList.add(ser);
                storeOrderServicesMap.put(ser.UM_StoreOrderNumber__c, sList);
            }else{
                List<csord__Service__c> sList=new List<csord__Service__c>();
                sList.add(ser);
                storeOrderServicesMap.put(ser.UM_StoreOrderNumber__c, sList);
            }
        }
        return storeOrderServicesMap;
    }
    //modified below query for BHP-83, added 2 new fields in query
    public map<string,cspmb__Price_Item__c> getPriceItemsForProductCodes(set<String> productCodeSet)
    {
        map<string,cspmb__Price_Item__c> productCodePriceItemMap = new map<string,cspmb__Price_Item__c>();
        
        for(cspmb__Price_Item__c priceItem : [SELECT Id, Name, cspmb__Price_Item_Description__c,cspmb__One_Off_Charge__c,cspmb__Recurring_Charge__c,
                                                UM_VoiceworksOneOffChargeID__c, UM_VoiceworksRecurringChargeID__c, UM_Create_Additional_Line_Item__c,
                                                   cspmb__One_Off_Charge_External_Id__c, cspmb__Recurring_Charge_External_Id__c,
                                                   UM_VoiceworksMoreServices__c, UM_NumberOfUnitsRequired__c, UM_UnitType__c
                                               FROM cspmb__Price_Item__c 
                                               WHERE cspmb__Is_Active__c = true 
                                                   AND (UM_VoiceworksOneOffChargeID__c IN: productCodeSet
                                                    OR UM_VoiceworksRecurringChargeID__c IN: productCodeSet)])
        {
            if(priceItem.UM_VoiceworksOneOffChargeID__c != null)
                productCodePriceItemMap.put(priceItem.UM_VoiceworksOneOffChargeID__c, priceItem);
            if(priceItem.UM_VoiceworksRecurringChargeID__c != null)
                productCodePriceItemMap.put(priceItem.UM_VoiceworksRecurringChargeID__c, priceItem);
        }
        return productCodePriceItemMap;
    }
    public map<string,cspmb__Add_On_Price_Item__c> getAddOnPriceItemsForProductCodes(set<String> productCodeSet)
    {
        map<string,cspmb__Add_On_Price_Item__c> productCodePriceItemMap = new map<string,cspmb__Add_On_Price_Item__c>();
        
        for(cspmb__Add_On_Price_Item__c addOnpriceItem : [SELECT Id, Name, cspmb__Add_On_Price_Item_Description__c,cspmb__One_Off_Charge__c,cspmb__Recurring_Charge__c,
                                                UM_VoiceworksOneOffChargeID__c,UM_VoiceworksRecurringChargeID__c, UM_Create_Additional_Line_Item__c,
                                                   cspmb__One_Off_Charge_External_Id__c, cspmb__Recurring_Charge_External_Id__c,
                                                   UM_VoiceworksMoreServices__c, UM_CancellationCode__c
                                               FROM cspmb__Add_On_Price_Item__c 
                                               WHERE cspmb__Is_Active__c = true 
                                                   AND (UM_VoiceworksOneOffChargeID__c IN: productCodeSet
                                                    OR UM_VoiceworksRecurringChargeID__c IN: productCodeSet)])
        {
            if(addOnpriceItem.UM_VoiceworksOneOffChargeID__c != null)
                productCodePriceItemMap.put(addOnpriceItem.UM_VoiceworksOneOffChargeID__c, addOnpriceItem);
            if(addOnpriceItem.UM_VoiceworksRecurringChargeID__c != null)
                productCodePriceItemMap.put(addOnpriceItem.UM_VoiceworksRecurringChargeID__c, addOnpriceItem);
        }
        return productCodePriceItemMap;
    }
}