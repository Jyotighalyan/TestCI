public with sharing class UM_BillingAccountItemTriggerHandler {
    static Id discountRecordTypeId = Schema.SObjectType.UM_BillingAccountItem__c.getRecordTypeInfosByName().get('Discount').getRecordTypeId();
    static Id adjustmentRecordTypeId = Schema.SObjectType.UM_BillingAccountItem__c.getRecordTypeInfosByName().get('Adjustment').getRecordTypeId(); 
    private static final String APPROVALSTATUS_APPROVED= 'Approved';    
    public static void beforeInsertEventHandler(list<UM_BillingAccountItem__c> newItems){
        //below changes made for BHP-21, added conditions for recordtypes
        List<UM_BillingAccountItem__c> discountItemsList = new List<UM_BillingAccountItem__c>();
        List<UM_BillingAccountItem__c> adjustmentItemsList = new List<UM_BillingAccountItem__c>();
        
        updateFutureDatedFlag(newItems);
        
        for(UM_BillingAccountItem__c item:newItems)
        {
              if(item.recordtypeId==adjustmentRecordTypeId && !item.UM_Received_from_Billing_System__c)
                   adjustmentItemsList.add(item);
              else if (item.recordtypeId==discountRecordTypeId )
                   discountItemsList.add(item);
        }
        if(!discountItemsList.isEmpty())
        {
            validateBillingAccountItem(discountItemsList);
            updateBillingCodesForDiscountItems(discountItemsList);
        }
        if(!adjustmentItemsList.isEmpty())
        {
            system.debug('inside adjsut list#');
            updateBillingCodesForAdjustItems(adjustmentItemsList);
            updateAmountForAdjustItems(adjustmentItemsList);
        }
    }

    public static void afterInsertEventHandler(list<UM_BillingAccountItem__c> newItems){
        //below changes made for BHP-21, added conditions for recordtypes
        List<UM_BillingAccountItem__c> discountItemsList = new List<UM_BillingAccountItem__c>();
        for(UM_BillingAccountItem__c item:newItems)
        {
            if(item.recordtypeId==discountRecordTypeId )
                discountItemsList.add(item);
        }
        if(!discountItemsList.isEmpty())
        {
            validateBillingAccountItem(discountItemsList);
            setOutOfSyncFlag(discountItemsList);
            syncBillingAccountItems(discountItemsList,null);
        }
    }

    public static void afterUpdateEventHandler(list<UM_BillingAccountItem__c> newItems,map<id,UM_BillingAccountItem__c> oldItemMap){
        //below changes made for BHP-21, added conditions for recordtypes and called relevant methods
        List<UM_BillingAccountItem__c> discountItemsList = new List<UM_BillingAccountItem__c>();
        List<UM_BillingAccountItem__c> adjustmentItemsList = new List<UM_BillingAccountItem__c>();
        for(UM_BillingAccountItem__c item:newItems)
        {
            if(item.recordtypeId==discountRecordTypeId )
                discountItemsList.add(item);
            else
                adjustmentItemsList.add(item); 
        }
        if(!discountItemsList.isEmpty())
        {
            validateBillingAccountItem(discountItemsList);
            resetFutureDatedFlag(discountItemsList,oldItemMap);
            syncBillingAccountItems(discountItemsList,oldItemMap);
        }
        if(!adjustmentItemsList.isEmpty())
        {
            syncParentBillingAccounts(adjustmentItemsList,oldItemMap);
        }
        
    }

    private static void setOutOfSyncFlag(list<UM_BillingAccountItem__c> newItems){
        set<id> updateBillingAccIds = new set<id>();
        for(UM_BillingAccountItem__c item : newItems){
            if(item.UM_StartDate__c<=Date.Today())
                updateBillingAccIds.add(item.UM_BillingAccount__c);
        }

        list<csconta__Billing_Account__c> billingAccounts = [select id,UM_IsAccountSynced__c from csconta__Billing_Account__c where id in :updateBillingAccIds];
        for(csconta__Billing_Account__c ba : billingAccounts)
            ba.UM_IsAccountSynced__c=true;

        update billingAccounts;
    }

    private static void resetFutureDatedFlag(list<UM_BillingAccountItem__c> newItems, map<id,UM_BillingAccountItem__c> oldItemMap){
        set<id> updateBillingAccIds = new set<id>();
        for(UM_BillingAccountItem__c item : newItems){
            if(item.UM_Is_Future_Dated__c==false && oldItemMap.get(item.id).UM_Is_Future_Dated__c==true){
                updateBillingAccIds.add(item.UM_BillingAccount__c);
            }
        }

        if(!updateBillingAccIds.isEmpty()){
            list<csconta__Billing_Account__c> billingAccounts = [select id,UM_IsAccountSynced__c from csconta__Billing_Account__c where id in :updateBillingAccIds];
            for(csconta__Billing_Account__c ba : billingAccounts)
                ba.UM_IsAccountSynced__c=true;

            update billingAccounts;
        }
    }

    private static void syncBillingAccountItems(list<UM_BillingAccountItem__c> newItems, map<id,UM_BillingAccountItem__c> oldItemMap){
        list<UM_BillingAccountItem__c> records = new list<UM_BillingAccountItem__c>();
        string query = 'select id,Name,UM_BillingAccount__c,UM_BillingCode__c,UM_Percentage__c,'+
                            ' UM_StartDate__c,UM_EndDate__c,UM_NumberofMonths__c,RecordTypeId,UM_Approval_Status__c,UM_Total_Amount__c,UM_Description__c,UM_NRC_Reason__c'+
                            ' from UM_BillingAccountItem__c where id in :records and UM_External_Id__c=null';

        list<UM_BillingAccountItem__c> accItems = [SELECT id,Name,UM_BillingAccount__c,UM_BillingAccount__r.LG_ExternalId__c,
                                                    UM_BillingCode__c,UM_Is_Future_Dated__c,UM_Percentage__c,UM_StartDate__c,UM_EndDate__c,
                                                    UM_NumberofMonths__c,RecordTypeId,UM_Approval_Status__c,UM_Total_Amount__c,UM_Description__c,UM_NRC_Reason__c 
                                                    FROM UM_BillingAccountItem__c 
                                                    WHERE id in :newItems and UM_External_Id__c=null];
        //added below Record type condition for BHP-21
        for(UM_BillingAccountItem__c item : accItems){
            if(oldItemMap!=null){
                if(item.recordtypeid ==discountRecordTypeId && item.UM_Is_Future_Dated__c==false && oldItemMap.get(item.id).UM_Is_Future_Dated__c==true)
                    records.add(item);
            }else{
                if(item.UM_Is_Future_Dated__c==false && item.UM_BillingAccount__r.LG_ExternalId__c!=null){
                    records.add(item);
                }
            }
        }
        if(!records.isEmpty())
            Id batchJobId = Database.executeBatch(new UM_KenanSyncBatch(records,query,'UM_BillingAccountItemsSync'), 5);
    }

    private static void updateBillingCodesForDiscountItems(list<UM_BillingAccountItem__c> newItems){
        set<id> discountCodes = new set<id>();
        for(UM_BillingAccountItem__c item : newItems){
            if(item.UM_Discount__c!=null)
                discountCodes.add(item.UM_Discount__c);

            /*if((item.UM_EndDate__c==null && item.UM_NumberofMonths__c!=null && item.UM_NumberofMonths__c>0) && item.UM_StartDate__c!=null){
                date startDate = item.UM_StartDate__c;
                integer noOfMonths = Integer.valueOf(item.UM_NumberofMonths__c);
                date endDate = startDate.addMonths(noOfMonths);
                item.UM_EndDate__c = endDate;
            }*/
        }

        map<id,LG_Discount__c > discountMap = new map<id,LG_Discount__c>([select id,UM_ExternalId__c from LG_Discount__c
                                                              where id in :discountCodes]);
        for(UM_BillingAccountItem__c item : newItems){
            if(item.UM_Discount__c!=null)
            	item.UM_BillingCode__c  = discountMap.get(item.UM_Discount__c).UM_ExternalId__c ;
        }
    }

    private static void validateBillingAccountItem(list<UM_BillingAccountItem__c> newItems){
        for(UM_BillingAccountItem__c item : newItems){
            if(item.UM_EndDate__c!=null && item.UM_NumberofMonths__c!=null){
                item.addError('You have selected an end date and duration, and you should choose one of these options. Please select one and delete the other.');
                continue;
            }
        }
    }
    //below method added for BHP-21, sets Kenan code against Kenan NRC reason 
    private static void updateBillingCodesForAdjustItems(list<UM_BillingAccountItem__c> newItems)
    {
         system.debug('inside updatebillingcode method#');
         Map<String,UM_Kenan_NRCReason_Mapping__c> NRCReasonMappingObjMap = getNRCReasonMappingObjMap();
         if(!NRCReasonMappingObjMap.isEmpty())
         {
             for(UM_BillingAccountItem__c bItem: newItems)
             {
                 system.debug('bItem.UM_NRC_Reason__c#'+bItem.UM_NRC_Reason__c);
                 if(NRCReasonMappingObjMap.containsKey(bItem.UM_NRC_Reason__c))
                     bItem.UM_BillingCode__c = NRCReasonMappingObjMap.get(bItem.UM_NRC_Reason__c).UM_Kenan_Code__c;
             }
             
         }
    }
    //below method added for BHP-21, sets amount as positive/negative beased on NRC reason 
    private static void updateAmountForAdjustItems(list<UM_BillingAccountItem__c> newItems)
    {
         system.debug('inside updatebillingcode method#');
         Map<String,UM_Kenan_NRCReason_Mapping__c> NRCReasonMappingObjMap = getNRCReasonMappingObjMap();
         if(!NRCReasonMappingObjMap.isEmpty())
         {
             for(UM_BillingAccountItem__c bItem: newItems)
             {
                 Double finalAmount = bItem.UM_Total_Amount__c;
                 system.debug('bItem.UM_NRC_Reason__c#'+bItem.UM_NRC_Reason__c);
                 if(NRCReasonMappingObjMap.containsKey(bItem.UM_NRC_Reason__c))
                 {
                     if(NRCReasonMappingObjMap.get(bItem.UM_NRC_Reason__c).UM_Is_Negative_Amount__c )
                     {
                         if(finalAmount > 0)
                             finalAmount = finalAmount * (-1);
                     }
                     else
                     {
                         if(finalAmount < 0)
                             finalAmount = finalAmount * -1;
                     }
                 }
                 bItem.UM_Total_Amount__c = finalAmount ;
             }
             
         }
    }
    //below method added for BHP-21, returns the Map of Kenan NRC reason and Custom setting record 
    private static Map<String,UM_Kenan_NRCReason_Mapping__c> getNRCReasonMappingObjMap()
    {
         Map<String,UM_Kenan_NRCReason_Mapping__c> NRCReasonMappingObjMap = new Map<String,UM_Kenan_NRCReason_Mapping__c>();
         List<UM_Kenan_NRCReason_Mapping__c> kenanNRCReasonList = UM_Kenan_NRCReason_Mapping__c.getall().values();
         if(!kenanNRCReasonList.isEmpty())
         {
             for(UM_Kenan_NRCReason_Mapping__c nr: kenanNRCReasonList )
             {
                 if(nr.Um_Is_Active__c)
                     NRCReasonMappingObjMap.put(nr.UM_Kenan_NRC_Reason__c,nr);
             }   
         }
         return NRCReasonMappingObjMap;
    }
    //added below method for BHP-21 to trigger Billing Account sync for Adjustment type Billing Account Items when record gets approved
    private static void syncParentBillingAccounts(list<UM_BillingAccountItem__c> newItems,map<id,UM_BillingAccountItem__c> oldItemMap)
    {
        system.debug('insode syncParent#');
        set<id> updateBillingAccIds = new set<id>();
        for(UM_BillingAccountItem__c item : newItems){
            if(item.UM_Received_from_Billing_System__c==false &&((item.UM_Is_Future_Dated__c==false && item.UM_Approval_Status__c==APPROVALSTATUS_APPROVED && oldItemMap.get(item.id).UM_Approval_Status__c!=item.UM_Approval_Status__c) || (item.UM_Approval_Status__c==APPROVALSTATUS_APPROVED && item.UM_Is_Future_Dated__c==false && oldItemMap.get(item.id).UM_Is_Future_Dated__c ==true)))
            {
                system.debug('condition met#');
                updateBillingAccIds.add(item.UM_BillingAccount__c);
            }
        }

        list<csconta__Billing_Account__c> billingAccounts = [select id,UM_IsAccountSynced__c from csconta__Billing_Account__c where id in :updateBillingAccIds];
        for(csconta__Billing_Account__c ba : billingAccounts)
            ba.UM_IsAccountSynced__c=true;

        update billingAccounts;
    }
    //added below method for setting Future Dated flag to true
    private static void updateFutureDatedFlag(List<UM_BillingAccountItem__c> newItems)
    {
        for(UM_BillingAccountItem__c item:newItems)
         {
             if(item.UM_StartDate__c>Date.Today())
                item.UM_Is_Future_Dated__c=true;
         }
    }
    //added below method for setting RT and Amount if records is coming from Billing system- BHP 23
    public static void updateItemRecordType(List<UM_BillingAccountItem__c> newItems)
    {
        for(UM_BillingAccountItem__c item:newItems)
        {
              if(item.UM_ItemType__c.equalsIgnoreCase('One-time Charge') && item.UM_Received_from_Billing_System__c)
              {    
                     system.debug('inside update RT#');
                     item.recordtypeId=adjustmentRecordTypeId;
                     if(item.UM_Total_Amount__c!=null && item.UM_Total_Amount__c!=0)
                          item.UM_Total_Amount__c=item.UM_Total_Amount__c/100;
               }
        }           
    }
    //added below method for updating Amount coming from Kenan- BHP23- 15/1/18
    public static void beforeUpdateEventHandler(List<UM_BillingAccountItem__c> newItems , Map<Id,UM_BillingAccountItem__c> oldItemsMap)
    {
        for(UM_BillingAccountItem__c item:newItems)
        {
              if(item.UM_Received_from_Billing_System__c && item.UM_Total_Amount__c!=null && item.UM_Total_Amount__c!=0 && item.UM_Total_Amount__c!=null && item.UM_Total_Amount__c != oldItemsMap.get(item.id).UM_Total_Amount__c)
                  item.UM_Total_Amount__c=item.UM_Total_Amount__c/100;
        } 
    }
}