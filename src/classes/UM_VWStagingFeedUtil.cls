/*
* File Name     :  UM_VWStagingFeedUtil
* Author: Omkar Jante (HPBX Team)
* Description : This class is responsible for every staging record processing.
* Last Modified by: OM Team-- Replaced Service Status with Activation completed.
* 
*/
public class UM_VWStagingFeedUtil{
    //created new FINAL static variables for constant values - BHP-83
    private static final string SUBSCRIBER_ENTRY_SERVICE= 'Virtual Voice Dienste';
    private static final string PRODUCT_FAMILY = 'Virtual Voice';
    private static final string SERVICE_STATUS = 'Activation Completed';
    private static final string SLA = 'Bronze';
    private static final string PROVISIONING_SYSTEM = 'VoiceWorks';
    private static final string FEED_PROCESSED_STATUS = 'Processed';
    private static final string FEED_FAILED_STATUS = 'Failed';
    
    private UM_VWStagingDataAccess dao;
    Savepoint sp;
    
    map<string, list<UM_VW_Staging_Feed__c>> vwExtIdNonSubscriberDataMap = new map<string, list<UM_VW_Staging_Feed__c>>();
    map<string, list<UM_VW_Staging_Feed__c>> vwExtIdSubscriberDataMap = new map<string, list<UM_VW_Staging_Feed__c>>();
    map<id,UM_VW_Staging_Feed__c> vwIdFeedToUpdateMap = new map<id,UM_VW_Staging_Feed__c>();
    map<string,string> vwExtIdSFVwExtIdMap = null;
    set<string> nonSubscriberVWObjIdSet = new set<string>();

    set<string> productCodeSet = null;
    set<string> subscriberIdSet = null;
    map<string,cspmb__Price_Item__c> productCodePriceItemMap = null;
    map<string,cspmb__Add_On_Price_Item__c> productCodeAddOnPriceItemMap = null;
    
    set<string> baNumberSet = new set<string>();
    set<string> premiseNumberSet = new set<string>();
    map<string,csconta__Billing_Account__c> baNumberBillingAccountMap = new map<string,csconta__Billing_Account__c>();
    map<string,cscrm__Address__c> premiseNumberPremiseMap = new map<string,cscrm__Address__c>();
    
    map<string,csord__Service__c> externalIdKundensetupServiceMap = new map<string,csord__Service__c>();
    map<string,map<string,csord__Service__c>> nonSubVWExtIdObjIdServiceMap = new map<string,map<string,csord__Service__c>>();
    
    map<string,csord__Service__c> subscriberIdSubscriberServiceMap = new map<string,csord__Service__c>();
    map<string,map<string,csord__Service__c>> subsIdVWObjIdServiceMap = new map<string,map<string,csord__Service__c>>();
    map<string,Id> subscriberIdSubscriptionIdsMap = new map<string,Id>();
    
    public UM_VWStagingFeedUtil(){
        dao = new UM_VWStagingDataAccess();
        vwExtIdSFVwExtIdMap = new map<string,string>();
        productCodeSet = new set<string>();
        subscriberIdSet = new set<string>();
    }
    //added new property for BHP-83
    public class Description{
        public String Extension{get;set;}
        public String Name{get;set;}
        public String StoreOrderNumber{get;set;}
        public String Username{get;set;} 
    }
    
    private Description getParsedDescription(String descriptionjson)
    {
        Description d = new Description();
        if(descriptionjson != null && descriptionjson.length() > 0)
            d = (Description)JSON.deserialize(descriptionjson, Description.class);
        
        //added below condition for BHP-83
        if(d.Username != null && d.Username.length()>0)
            d.Name = d.Username;
            
        return d;
    }
    
    public void collectRequiredData()
    {
        productCodePriceItemMap = dao.getPriceItemsForProductCodes(productCodeSet);
        productCodeAddOnPriceItemMap = dao.getAddOnPriceItemsForProductCodes(productCodeSet);
        
        set<string> allSFvwExtIdSet = new set<string>();
        allSFvwExtIdSet.addAll(vwExtIdSFVwExtIdMap.values());
        // get Kundensetup Subscription, Service and child services data for the VW External Id
        externalIdKundensetupServiceMap = dao.getKundenSetupWithChildsServices(allSFvwExtIdSet, nonSubscriberVWObjIdSet);
        for(string vwExtId : externalIdKundensetupServiceMap.keySet())
        {
            map<string,csord__Service__c> vwObjectIdServiceMap = null;
            
            if(externalIdKundensetupServiceMap.containsKey(vwExtId) 
                && externalIdKundensetupServiceMap.get(vwExtId).csord__Services__r != null){
                vwObjectIdServiceMap = new map<string,csord__Service__c>();
                for(csord__Service__c ser : externalIdKundensetupServiceMap.get(vwExtId).csord__Services__r){
                    vwObjectIdServiceMap.put(ser.UM_VoiceWorksObjectId__c, ser);
                }
            }
            
            if(vwObjectIdServiceMap != null && vwObjectIdServiceMap.size() > 0)
                nonSubVWExtIdObjIdServiceMap.put(vwExtId, vwObjectIdServiceMap);
        }
        // get all existing subscriber services along with Subscriber Id and VW object Id
        //subscriberIdSubscriberServiceMap = dao.getSubscriberWithChildServices(subscriberIdSet, subscriberVWObjIdSet);
        subscriberIdSubscriberServiceMap = dao.getSubscriberWithChildServices(subscriberIdSet);
        
        for(string subscriberId : subscriberIdSubscriberServiceMap.keySet())
        {
            map<string,csord__Service__c> vwObjectIdServiceMap = null;
            
            if(subscriberIdSubscriberServiceMap.containsKey(subscriberId) 
                && subscriberIdSubscriberServiceMap.get(subscriberId).csord__Services__r != null){
                vwObjectIdServiceMap = new map<string,csord__Service__c>();
                for(csord__Service__c ser : subscriberIdSubscriberServiceMap.get(subscriberId).csord__Services__r){
                    vwObjectIdServiceMap.put(ser.UM_VoiceWorksObjectId__c, ser);
                }
            }
            
            if(vwObjectIdServiceMap != null && vwObjectIdServiceMap.size() > 0)
                subsIdVWObjIdServiceMap.put(subscriberId, vwObjectIdServiceMap);
            
            // collect Subscription Id against subscriber id
            subscriberIdSubscriptionIdsMap.put(subscriberId, subscriberIdSubscriberServiceMap.get(subscriberId).csord__Subscription__c);
        }
    }
    
    public void segregateStagingData(List<UM_VW_Staging_Feed__c> vwsList)
    {
        try
        {
            List<UM_VW_Staging_Feed__c> vwsProcessLaterList = new List<UM_VW_Staging_Feed__c>();
            map<string, list<UM_VW_Staging_Feed__c>> subscriberFeedsMap = new map<string, list<UM_VW_Staging_Feed__c>>();
            map<string, list<UM_VW_Staging_Feed__c>> nonSubscriberFeedsMap = new map<string, list<UM_VW_Staging_Feed__c>>();
            List<UM_VW_Staging_Feed__c> vwsHardwareDataList = new List<UM_VW_Staging_Feed__c>();
            
            for(UM_VW_Staging_Feed__c vws : vwsList)
            {
                if(vws.UM_ExportType__c.equalsIgnoreCase('Billing') && vws.UM_AccountNumber__c != NULL)
                {
                    list<string> keysList = vws.UM_AccountNumber__c.split('\\|');
                    string sfActualVWExtId = '';
                    if(keysList != null && keysList.size() >= 3){
                        sfActualVWExtId = keysList.get(0) + '|' + keysList.get(1) + '|' + keysList.get(2);
                        vwExtIdSFVwExtIdMap.put(vws.UM_AccountNumber__c,sfActualVWExtId);
                        baNumberSet.add(keysList.get(0));
                        premiseNumberSet.add(keysList.get(1));
                    }else{
                        // invalid Account Number
                        vws.UM_Status__c = FEED_FAILED_STATUS;
                        vws.UM_ErrorMessage__c = 'Invalid Account Number.';
                        vwIdFeedToUpdateMap.put(vws.Id, vws);
                        continue;
                    }
                    
                    try{
                        Description d = getParsedDescription(vws.UM_Description__c);
                    }catch(exception ex){
                        vws.UM_Status__c = FEED_FAILED_STATUS;
                        vws.UM_ErrorMessage__c = ex.getMessage();
                        vwIdFeedToUpdateMap.put(vws.Id, vws);
                        continue;
                    }

                    if(vws.UM_ArticleNumber__c != null)
                        productCodeSet.add(vws.UM_ArticleNumber__c);
                    
                    if(vws.UM_SubscriberID__c != null)
                        subscriberIdSet.add(vws.UM_SubscriberID__c);
                    
                    if((vws.UM_Enddate__c != null || vws.UM_DescriptionChanged__c == '1') && !vws.UM_ProcessLater__c){
                        /* Skip these records during this processing and process them in next batch. 
                        These are skipped because, Activation and deactivation cannot be performed in same transaction. */
                        vws.UM_ProcessLater__c = true;
                        vws.UM_Status__c = 'New';
                        vwsProcessLaterList.add(vws);
                    }else if((vws.UM_Enddate__c != NULL && vws.UM_ProcessLater__c) || (vws.UM_DescriptionChanged__c == '1' && vws.UM_ProcessLater__c)){
                        // Terminate these records or change the Description data on Service
                        if(vws.UM_SubscriberID__c != null && !vws.UM_SubscriberID__c.equals('')){
                            if(subscriberFeedsMap.containsKey(vws.UM_SubscriberID__c)){
                                list<UM_VW_Staging_Feed__c> feedList = subscriberFeedsMap.get(vws.UM_SubscriberID__c);
                                feedList.add(vws);
                                subscriberFeedsMap.put(vws.UM_SubscriberID__c,feedList);
                            }else{
                                List<UM_VW_Staging_Feed__c> feedList=new List<UM_VW_Staging_Feed__c>();
                                feedList.add(vws);
                                subscriberFeedsMap.put(vws.UM_SubscriberID__c,feedList);
                            }
                            //subscriberVWObjIdSet.add(vws.UM_VoiceWorksObjectId__c);
                        }else{
                            if(nonSubscriberFeedsMap.containsKey(sfActualVWExtId)){
                                list<UM_VW_Staging_Feed__c> feedList = nonSubscriberFeedsMap.get(sfActualVWExtId);
                                feedList.add(vws);
                                nonSubscriberFeedsMap.put(sfActualVWExtId,feedList);
                            }else{
                                List<UM_VW_Staging_Feed__c> feedList = new List<UM_VW_Staging_Feed__c>();
                                feedList.add(vws);
                                nonSubscriberFeedsMap.put(sfActualVWExtId,feedList);
                            }
                            nonSubscriberVWObjIdSet.add(vws.UM_VoiceWorksObjectId__c);
                        }
                    }
                    else if(vws.UM_SubscriberID__c == null || vws.UM_SubscriberID__c == ''){
                        if(vwExtIdNonSubscriberDataMap.containsKey(sfActualVWExtId)){
                            list<UM_VW_Staging_Feed__c> feedList = vwExtIdNonSubscriberDataMap.get(sfActualVWExtId);
                            feedList.add(vws);
                            vwExtIdNonSubscriberDataMap.put(sfActualVWExtId,feedList);
                        }else{
                            List<UM_VW_Staging_Feed__c> feedList=new List<UM_VW_Staging_Feed__c>();
                            feedList.add(vws);
                            vwExtIdNonSubscriberDataMap.put(sfActualVWExtId,feedList);
                        }
                        nonSubscriberVWObjIdSet.add(vws.UM_VoiceWorksObjectId__c);
                    }
                    else if(vws.UM_SubscriberID__c !=null && !vws.UM_SubscriberID__c.equals('')){
                        if(vwExtIdSubscriberDataMap.containsKey(sfActualVWExtId)){
                            list<UM_VW_Staging_Feed__c> feedList = vwExtIdSubscriberDataMap.get(sfActualVWExtId);
                            feedList.add(vws);
                            vwExtIdSubscriberDataMap.put(sfActualVWExtId,feedList);
                        }else{
                            List<UM_VW_Staging_Feed__c> feedList=new List<UM_VW_Staging_Feed__c>();
                            feedList.add(vws);
                            vwExtIdSubscriberDataMap.put(sfActualVWExtId,feedList);
                        }
                        //subscriberVWObjIdSet.add(vws.UM_VoiceWorksObjectId__c);
                    }
                }else if(vws.UM_ExportType__c.equalsIgnoreCase('Hardware')){
                    vwsHardwareDataList.add(vws);
                }else{
                    // invalid Account Number
                    vws.UM_Status__c = FEED_FAILED_STATUS;
                    vws.UM_ErrorMessage__c = 'Invalid Data.';
                    vwIdFeedToUpdateMap.put(vws.Id, vws);
                    continue;
                }
            }
            // Collect all required data before start processing
            collectRequiredData();
            
            sp = Database.setSavepoint();
            
            // This data will be picked up by scheduler after 10 min of original data processing.
            if(vwsProcessLaterList.size() > 0)
                UPDATE vwsProcessLaterList;
            // Process non-subscriber services
            if(vwExtIdNonSubscriberDataMap.size()>0)
                processNonSubscriberData(vwExtIdNonSubscriberDataMap.keySet());
            // Process subscriber services
            if(vwExtIdSubscriberDataMap.size()>0)
                 processSubscriberData(vwExtIdSubscriberDataMap.keySet());
            // Process hardware
            if(vwsHardwareDataList.size()>0)
                processHardwareData(vwsHardwareDataList);
            // Process Termination - of existing services - any type
            if(subscriberFeedsMap.size()>0 || nonSubscriberFeedsMap.size() > 0)
                processChangeOrTerminateData(subscriberFeedsMap, nonSubscriberFeedsMap);
            // Update error / success after all processing
            if(!vwIdFeedToUpdateMap.isEmpty())
                UPDATE vwIdFeedToUpdateMap.values();
        }catch(Exception ex){
            system.debug('ex----------->' + ex+ ex.getStackTraceString());
            // if there any exception during the transaction, all will be rolled back.
            Database.rollback(sp);
            
            // In case of exception mark all failed with same exception message
            for(UM_VW_Staging_Feed__c vws : vwsList){
                vws.UM_Status__c = FEED_FAILED_STATUS;
                vws.UM_ErrorMessage__c = ex.getMessage();
            }
            UPDATE vwsList;
        }
    }
    
    // Process Termination records and Put Deactivation date on existing services
    // Process Description changed records and update Name and Ext Number
    public void processChangeOrTerminateData(map<string, list<UM_VW_Staging_Feed__c>> subscriberFeedsMap, map<string, list<UM_VW_Staging_Feed__c>> accIdNonSubscriberFeedsMap)
    {
        map<Id, csord__Service__c> servicesToUpdateMap = new map<Id, csord__Service__c>();
        
        for(string subscriberId : subscriberFeedsMap.keySet())
        {
            for(UM_VW_Staging_Feed__c vws : subscriberFeedsMap.get(subscriberId))
            {
                if(vws.UM_Enddate__c != null)
                {
                    if(subscriberIdSubscriberServiceMap.containsKey(subscriberId) 
                        && subscriberIdSubscriberServiceMap.get(subscriberId) != null)
                    {
                        csord__Service__c parentService = subscriberIdSubscriberServiceMap.get(subscriberId);
                        if(vws.UM_VoiceWorksObjectId__c == parentService.UM_VoiceWorksObjectId__c){
                            if(parentService.LG_ServiceStatus__c == 'Active' || parentService.csord__Status__c == 'Active'){
                                parentService.csordtelcoa__Delta_Status__c = 'Terminate';
                                parentService.csord__Deactivation_Date__c = vws.UM_Enddate__c;
                                parentService.LG_ServiceStatus__c = 'Ready for Billing';
                                parentService.csord__Status__c = 'Ready for Billing';
                                
                                servicesToUpdateMap.put(parentService.Id, parentService);
                                
                                // add all child services to terminate
                                if(parentService != null && parentService.csord__Services__r != null && parentService.csord__Services__r.size() > 0){
                                    for(csord__Service__c childSer : parentService.csord__Services__r){
                                        if(childSer.LG_ServiceStatus__c == 'Active' || childSer.csord__Status__c == 'Active'){
                                            childSer.csordtelcoa__Delta_Status__c = '';
                                            childSer.csord__Deactivation_Date__c = vws.UM_Enddate__c;
                                            servicesToUpdateMap.put(childSer.Id, childSer);
                                        }
                                    }
                                }
                                
                                vws.UM_Status__c = FEED_PROCESSED_STATUS;
                                vws.UM_ErrorMessage__c = '';
                                vwIdFeedToUpdateMap.put(vws.Id, vws);
                            }else{
                                // no extended service found 
                                vws.UM_Status__c = FEED_FAILED_STATUS;
                                vws.UM_ErrorMessage__c = 'Entry Service with this Subscriber ID and VoiceWorks Object Id is not Active, so cannot be terminated.';
                                vwIdFeedToUpdateMap.put(vws.Id, vws);
                            }
                        }
                        else if(subsIdVWObjIdServiceMap.containsKey(subscriberId))
                        {
                            map<string, csord__Service__c> objIdServiceMap = subsIdVWObjIdServiceMap.get(subscriberId);
                            
                            if(objIdServiceMap != null && objIdServiceMap.containsKey(vws.UM_VoiceWorksObjectId__c))
                            {
                                csord__Service__c childSer = objIdServiceMap.get(vws.UM_VoiceWorksObjectId__c);
                                map<Id, csord__Service__c> parentServicesMap = new map<Id, csord__Service__c>();
                                
                                if(!servicesToUpdateMap.isEmpty() && servicesToUpdateMap.containsKey(childSer.csord__Service__c)){
                                    vws.UM_Status__c = FEED_PROCESSED_STATUS;
                                    vws.UM_ErrorMessage__c = 'Parent Service is selected for Termination. Extended Service will be terminated along with Parent.';
                                    vwIdFeedToUpdateMap.put(vws.Id, vws);
                                }else if(childSer.LG_ServiceStatus__c == 'Active' || childSer.csord__Status__c == 'Active'){
                                    childSer.csordtelcoa__Delta_Status__c = 'Terminate';
                                    childSer.csord__Deactivation_Date__c = vws.UM_Enddate__c;
                                    childSer.LG_ServiceStatus__c = 'Ready for Billing';
                                    childSer.csord__Status__c = 'Ready for Billing';
                                    servicesToUpdateMap.put(childSer.Id, childSer);
                                
                                    vws.UM_Status__c = FEED_PROCESSED_STATUS;
                                    vws.UM_ErrorMessage__c = '';
                                    vwIdFeedToUpdateMap.put(vws.Id, vws);
                                }else{
                                    // no extended service found 
                                    vws.UM_Status__c = FEED_FAILED_STATUS;
                                    vws.UM_ErrorMessage__c = 'Extended Service with this Subscriber ID and VoiceWorks Object Id is not Active, so cannot be terminated.';
                                    vwIdFeedToUpdateMap.put(vws.Id, vws);
                                }
                            }else{
                                // no extended service found 
                                vws.UM_Status__c = FEED_FAILED_STATUS;
                                vws.UM_ErrorMessage__c = 'Could not find Active Extended Service with this Subscriber ID and VoiceWorks Object Id.';
                                vwIdFeedToUpdateMap.put(vws.Id, vws);
                            }
                        }else{
                            // no extended service found 
                            vws.UM_Status__c = FEED_FAILED_STATUS;
                            vws.UM_ErrorMessage__c = 'Could not find Active Entry or Extended Service with this Subscriber ID and VoiceWorks Object Id.';
                            vwIdFeedToUpdateMap.put(vws.Id, vws);
                        }
                    }else{
                        // no extended service found 
                        vws.UM_Status__c = FEED_FAILED_STATUS;
                        vws.UM_ErrorMessage__c = 'Could not find Active Entry Service with this Subscriber ID and VoiceWorks Object Id.';
                        vwIdFeedToUpdateMap.put(vws.Id, vws);
                    }
                }
            }
            
            for(UM_VW_Staging_Feed__c vws : subscriberFeedsMap.get(subscriberId))
            {
                if(vws.UM_DescriptionChanged__c == '1')
                {
                    if(subscriberIdSubscriberServiceMap.containsKey(subscriberId) 
                        && subscriberIdSubscriberServiceMap.get(subscriberId) != null)
                    {
                        csord__Service__c parentSer = subscriberIdSubscriberServiceMap.get(subscriberId);
                        Description descData = getParsedDescription(vws.UM_Description__c);
                        
                        if(servicesToUpdateMap.containsKey(parentSer.Id)){
                            vws.UM_Status__c = FEED_FAILED_STATUS;
                            vws.UM_ErrorMessage__c = 'This service is selected for Termination so Description cannot be changed.';
                            vwIdFeedToUpdateMap.put(vws.Id, vws);
                        }
                        else if(vws.UM_VoiceWorksObjectId__c != parentSer.UM_VoiceWorksObjectId__c){
                            vws.UM_Status__c = FEED_FAILED_STATUS;
                            vws.UM_ErrorMessage__c = 'This is not a Subscriber Service so Description cannot be changed.';
                            vwIdFeedToUpdateMap.put(vws.Id, vws);
                        }
                        else if(descData != null && (parentSer.UM_SubscriberName__c != descData.Name || parentSer.UM_PhoneExtension__c != descData.Extension)){
                            parentSer.UM_SubscriberName__c = descData.Name;
                            parentSer.UM_PhoneExtension__c = descData.Extension;
                            parentSer.csordtelcoa__Delta_Status__c = 'Modify';
                            servicesToUpdateMap.put(parentSer.Id, parentSer);
                            
                            vws.UM_Status__c = FEED_PROCESSED_STATUS;
                            vws.UM_ErrorMessage__c = '';
                            vwIdFeedToUpdateMap.put(vws.Id, vws);
                        }else{
                            vws.UM_Status__c = FEED_FAILED_STATUS;
                            vws.UM_ErrorMessage__c = 'There is no change in Subscriber Name or Phone Exception of Description Data.';
                            vwIdFeedToUpdateMap.put(vws.Id, vws);
                        }
                    }else{
                        // no extended service found 
                        vws.UM_Status__c = FEED_FAILED_STATUS;
                        vws.UM_ErrorMessage__c = 'Could not find Active Entry Service with this Subscriber ID and VoiceWorks Object Id.';
                        vwIdFeedToUpdateMap.put(vws.Id, vws);
                    }
                }
            }
        }
        
        for(string accountId : accIdNonSubscriberFeedsMap.keySet())
        {
            for(UM_VW_Staging_Feed__c vws : accIdNonSubscriberFeedsMap.get(accountId))
            {
                if(vws.UM_Enddate__c != null)
                {
                    if(!externalIdKundensetupServiceMap.isEmpty() && externalIdKundensetupServiceMap.containsKey(accountId))
                    {
                        if(!nonSubVWExtIdObjIdServiceMap.isEmpty() && nonSubVWExtIdObjIdServiceMap.size() > 0 
                            && nonSubVWExtIdObjIdServiceMap.containsKey(accountId)){
                            map<string,csord__Service__c> vwObjectIdServiceMap = nonSubVWExtIdObjIdServiceMap.get(accountId);
                            if(vwObjectIdServiceMap != null && vwObjectIdServiceMap.containsKey(vws.UM_VoiceWorksObjectId__c)){
                                csord__Service__c childSer = vwObjectIdServiceMap.get(vws.UM_VoiceWorksObjectId__c);
                                if(childSer.LG_ServiceStatus__c == 'Active' || childSer.csord__Status__c == 'Active'){
                                    childSer.csordtelcoa__Delta_Status__c = 'Terminate';
                                    childSer.csord__Deactivation_Date__c = vws.UM_Enddate__c;
                                    childSer.LG_ServiceStatus__c = 'Ready for Billing';
                                    childSer.csord__Status__c = 'Ready for Billing';
                                    servicesToUpdateMap.put(childSer.Id, childSer);
                                
                                    vws.UM_Status__c = FEED_PROCESSED_STATUS;
                                    vws.UM_ErrorMessage__c = '';
                                    vwIdFeedToUpdateMap.put(vws.Id, vws);
                                }else{
                                    vws.UM_Status__c = FEED_FAILED_STATUS;
                                    vws.UM_ErrorMessage__c = 'Could not find Active Service for this Account Number and VoiceWorks Object Id.';
                                    vwIdFeedToUpdateMap.put(vws.Id, vws);
                                }
                            }else{
                                vws.UM_Status__c = FEED_FAILED_STATUS;
                                vws.UM_ErrorMessage__c = 'Could not find Active Service for this Account Number and VoiceWorks Object Id.';
                                vwIdFeedToUpdateMap.put(vws.Id, vws);
                            }
                        }else{
                            vws.UM_Status__c = FEED_FAILED_STATUS;
                            vws.UM_ErrorMessage__c = 'Could not find Active Service for this Account Number and VoiceWorks Object Id.';
                            vwIdFeedToUpdateMap.put(vws.Id, vws);
                        }
                    }else{
                        vws.UM_Status__c = FEED_FAILED_STATUS;
                        vws.UM_ErrorMessage__c = 'Could not find Active Kundensetup Service for this Account Number.';
                        vwIdFeedToUpdateMap.put(vws.Id, vws);
                    }
                }else if(vws.UM_DescriptionChanged__c == '1'){
                    vws.UM_Status__c = FEED_FAILED_STATUS;
                    vws.UM_ErrorMessage__c = 'Description cannot be changed for Non-Subscriber Services.';
                    vwIdFeedToUpdateMap.put(vws.Id, vws);
                }
            }
        }
        
        if(!servicesToUpdateMap.isEmpty())
            UPDATE servicesToUpdateMap.values();
    }
    
    // Process non-subscriber services data
    public void processNonSubscriberData(set<string> vwsNonSubscriberExtIdSet)
    {
        list<csord__Service_Line_Item__c> finalSliToInsertList = new list<csord__Service_Line_Item__c>();
        
        map<string,list<csord__Service_Line_Item__c>> accountNoObjIdSLItemsMap = new map<string,list<csord__Service_Line_Item__c>>();
        map<string,csord__Service__c> accountNoObjIdServiceMap = new map<string,csord__Service__c>();
        
        for(string accountNumber : vwsNonSubscriberExtIdSet)
        {
            map<string, list<UM_VW_Staging_Feed__c>> vwObjectIdVwsFeedsMap = new map<string, list<UM_VW_Staging_Feed__c>>();
            map<string,map<string,UM_VW_Staging_Feed__c>> vwObjectIdArtNoVwsFeedsMap = new map<string,map<string,UM_VW_Staging_Feed__c>>();
            list<UM_VW_Staging_Feed__c> hardwareBillingFeedList = new list<UM_VW_Staging_Feed__c>();
            
            for(UM_VW_Staging_Feed__c vws : vwExtIdNonSubscriberDataMap.get(accountNumber))
            {
                if(!externalIdKundensetupServiceMap.containsKey(accountNumber)){
                    // No kundensetup service found
                    vws.UM_Status__c = FEED_FAILED_STATUS;
                    vws.UM_ErrorMessage__c = 'Could not find Active Kundensetup Service with this Account Number.';
                    vwIdFeedToUpdateMap.put(vws.Id, vws);
                    continue;
                }
                if(!productCodePriceItemMap.containsKey(vws.UM_ArticleNumber__c) && 
                    !productCodeAddOnPriceItemMap.containsKey(vws.UM_ArticleNumber__c)){
                    // invalid article number
                    vws.UM_Status__c = FEED_FAILED_STATUS;
                    vws.UM_ErrorMessage__c = 'Could not find this Article Number in Salesforce for Non-Subscriber billing item.';
                    vwIdFeedToUpdateMap.put(vws.Id, vws);
                    continue;
                }
                
                if(!nonSubVWExtIdObjIdServiceMap.isEmpty() && nonSubVWExtIdObjIdServiceMap.containsKey(accountNumber)){
                    map<string,csord__Service__c> vwObjIdServiceMap = nonSubVWExtIdObjIdServiceMap.get(accountNumber);
                    if(vwObjIdServiceMap != null && vwObjIdServiceMap.size() > 0 && vwObjIdServiceMap.containsKey(vws.UM_VoiceWorksObjectId__c)){
                        vws.UM_Status__c = FEED_FAILED_STATUS;
                        vws.UM_ErrorMessage__c = 'Non-Subscriber Service with this VoiceWorks Object Id is already present.';
                        vwIdFeedToUpdateMap.put(vws.Id, vws);
                        continue;
                    }
                }
                
                Description descData = getParsedDescription(vws.UM_Description__c);
                // Duplicate check is not required for Hardware billing items so processing differently
                if(descData != null && descData.StoreOrderNumber != null){
                    hardwareBillingFeedList.add(vws);
                }else{
                    // filter data with finding out Feeds against each VW object Id
                    if(vwObjectIdVwsFeedsMap.containsKey(vws.UM_VoiceWorksObjectId__c)){
                        list<UM_VW_Staging_Feed__c> feedList = vwObjectIdVwsFeedsMap.get(vws.UM_VoiceWorksObjectId__c);
                        feedList.add(vws);
                        vwObjectIdVwsFeedsMap.put(vws.UM_VoiceWorksObjectId__c,feedList);
                    }else{
                        List<UM_VW_Staging_Feed__c> feedList = new List<UM_VW_Staging_Feed__c>();
                        feedList.add(vws);
                        vwObjectIdVwsFeedsMap.put(vws.UM_VoiceWorksObjectId__c,feedList);
                    }
                }
            }
            
            for(string vwObjectId : vwObjectIdVwsFeedsMap.keySet())
            {
                map<string, UM_VW_Staging_Feed__c> vwArtNoVwsFeedMap = new map<string, UM_VW_Staging_Feed__c>();
                for(UM_VW_Staging_Feed__c vws : vwObjectIdVwsFeedsMap.get(vwObjectId))
                {
                    if(vwArtNoVwsFeedMap.containsKey(vws.UM_ArticleNumber__c)){
                        // duplicate entry agaist same VW object id
                        vws.UM_Status__c = FEED_FAILED_STATUS;
                        vws.UM_ErrorMessage__c = 'Duplicate Product entry found against this VW object Id.';
                        vwIdFeedToUpdateMap.put(vws.Id, vws);
                    }else{
                        vwArtNoVwsFeedMap.put(vws.UM_ArticleNumber__c,vws);
                    }
                }
                vwObjectIdArtNoVwsFeedsMap.put(vwObjectId,vwArtNoVwsFeedMap);
            }
            
            // process all other services as well as International Numbers. As all are going under the kundensetup not required extra conditions
            if(!vwObjectIdArtNoVwsFeedsMap.isEmpty())
            {
                for(string vwObjId : vwObjectIdArtNoVwsFeedsMap.keySet()){
                    map<string,UM_VW_Staging_Feed__c> artNoVwsFeedMap = vwObjectIdArtNoVwsFeedsMap.get(vwObjId);
                    list<UM_VW_Staging_Feed__c> sliVWSfeedList = artNoVwsFeedMap.values();

                    string serviceSLIKey = accountNumber + '-' + vwObjId;
                    
                    if(!sliVWSfeedList.isEmpty()){
                        // Create Service - child Service to kundensetup Service.
                        list<csord__Service__c> newServicesList = createNonSubscriberService(sliVWSfeedList,externalIdKundensetupServiceMap.get(accountNumber));
                        
                        integer serviceIndex = 0;
                        for(csord__Service__c serv : newServicesList){
                            serviceSLIKey = serviceSLIKey + serviceIndex;
                            // create Service Line items 
                            list<csord__Service_Line_Item__c> sliList = createNonSubscriberLineItems(sliVWSfeedList);
                            accountNoObjIdSLItemsMap.put(serviceSLIKey,sliList);
                            
                            accountNoObjIdServiceMap.put(serviceSLIKey,serv);
                            serviceIndex++;
                        }
                    }
                }
            }
            
            // Process Hardware services only. All are going under the kundensetup.
            if(!hardwareBillingFeedList.isEmpty())
            {
                integer uniqueIndex = 1;
                for(UM_VW_Staging_Feed__c vwsFeed : hardwareBillingFeedList){
                    list<UM_VW_Staging_Feed__c> sliVWSfeedList = new list<UM_VW_Staging_Feed__c>{vwsFeed};

                    string serviceSLIKey = 'hw-' + accountNumber + '-' + vwsFeed.UM_VoiceWorksObjectId__c;
                    
                    if(!sliVWSfeedList.isEmpty()){
                        // Create Service - child Service to kundensetup Service.
                        list<csord__Service__c> newServicesList = createNonSubscriberService(sliVWSfeedList, externalIdKundensetupServiceMap.get(accountNumber));
                        
                        integer serviceIndex = 0;
                        for(csord__Service__c serv : newServicesList){
                            serviceSLIKey = serviceSLIKey + serviceIndex;
                            
                            if(accountNoObjIdSLItemsMap.containsKey(serviceSLIKey)){
                                serviceSLIKey = serviceSLIKey + uniqueIndex;
                                uniqueIndex++;
                            }
                            // create Service Line items 
                            list<csord__Service_Line_Item__c> sliList = createNonSubscriberLineItems(sliVWSfeedList);
                            accountNoObjIdSLItemsMap.put(serviceSLIKey,sliList);
                            
                            accountNoObjIdServiceMap.put(serviceSLIKey,serv);
                            serviceIndex++;
                        }
                    }
                }
            }
        }
        
        if(!accountNoObjIdServiceMap.isEmpty())
            INSERT accountNoObjIdServiceMap.values();
        
        for(string accNoVWObjId : accountNoObjIdSLItemsMap.keySet()){
            for(csord__Service_Line_Item__c lineItem : accountNoObjIdSLItemsMap.get(accNoVWObjId)){
                lineItem.csord__Service__c = accountNoObjIdServiceMap.get(accNoVWObjId).Id;
                finalSliToInsertList.add(lineItem);
            }
        }
        
        if(!finalSliToInsertList.isEmpty())
            INSERT finalSliToInsertList;
    }
    
    // create non-subscriber Services
    private list<csord__Service__c> createNonSubscriberService(list<UM_VW_Staging_Feed__c> vwsFeedList, csord__Service__c kundensetupService)
    {
        //kundensetupService = externalIdKundensetupServiceMap.get(accountNumber);
        map<integer,csord__Service__c> numberServiceMap = new map<integer,csord__Service__c>();
        integer index = 0;
        
        for(UM_VW_Staging_Feed__c vwsFeed : vwsFeedList)
        {
            if(!numberServiceMap.containsKey(index)){
                list<string> keysList = vwsFeed.UM_AccountNumber__c.split('\\|');
                string stateName = 'NRW';
                if(keysList != null && keysList.size() >= 3)
                    stateName = keysList.get(2);
                    
                boolean isEntryService = false;
                cspmb__Price_Item__c pi = null;
                cspmb__Add_On_Price_Item__c addOnPi = null;
                string serviceName;
                Description descData = getParsedDescription(vwsFeed.UM_Description__c);
                
                if(productCodePriceItemMap.containsKey(vwsFeed.UM_ArticleNumber__c)){
                    isEntryService = true;
                    pi = productCodePriceItemMap.get(vwsFeed.UM_ArticleNumber__c);
                    serviceName = pi.Name;
                }else if(productCodeAddOnPriceItemMap.containsKey(vwsFeed.UM_ArticleNumber__c)){
                    isEntryService = false;
                    addOnPi = productCodeAddOnPriceItemMap.get(vwsFeed.UM_ArticleNumber__c);
                    serviceName = addOnPi.Name;
                }
                
                if(serviceName != null && serviceName.length() > 80)
                    serviceName = serviceName.substring(0, 80);
            
                csord__Service__c objService = new csord__Service__c(csord__Subscription__c = kundensetupService.csord__Subscription__c,
                                                                csord__Service__c = kundensetupService.Id,
                                                                LG_Address__c = kundensetupService.LG_Address__c,
                                                                csord__Activation_Date__c = vwsFeed.UM_Startdate__c,
                                                                csord__Identification__c = kundensetupService.csord__Subscription__c + '_'+vwsFeed.UM_VoiceWorksObjectId__c+'_0',
                                                                //UM_SubscriberName__c = descData.Name,
                                                                //UM_PhoneExtension__c = descData.Extension,
                                                                UM_StoreOrderNumber__c = descData.StoreOrderNumber,
                                                                LG_ServiceStatus__c = SERVICE_STATUS ,
                                                                csord__Status__c = SERVICE_STATUS ,
                                                                Name = serviceName,
                                                                LG_SLA__c = SLA,
                                                                UM_State__c = stateName,
                                                                LG_ProductFamily__c = PRODUCT_FAMILY,
                                                                csordtelcoa__Delta_Status__c = 'Add',
                                                                LG_ContractTerm__c = 0,
                                                                UM_Cancellation_Period__c = 0,
                                                                UM_VoiceWorksObjectId__c = vwsFeed.UM_VoiceWorksObjectId__c,
                                                                LG_ProvisioningAccountNo__c = vwsFeed.UM_VoiceworksAccountID__c,
                                                                LG_ProvisioningSystem__c = PROVISIONING_SYSTEM);
                
                if(vwsFeed.UM_Quantity__c > 1){
                    if(isEntryService){
                        if(pi.UM_VoiceworksMoreServices__c){
                            for(integer i=0;i<vwsFeed.UM_Quantity__c;i++){
                                csord__Service__c objService1 = new csord__Service__c(csord__Subscription__c = kundensetupService.csord__Subscription__c,
                                                                csord__Service__c = kundensetupService.Id,
                                                                LG_Address__c = kundensetupService.LG_Address__c,
                                                                csord__Activation_Date__c = vwsFeed.UM_Startdate__c,
                                                                csord__Identification__c = kundensetupService.csord__Subscription__c + '_'+vwsFeed.UM_VoiceWorksObjectId__c+'_'+i,
                                                                //UM_SubscriberName__c = descData.Name,
                                                                //UM_PhoneExtension__c = descData.Extension,
                                                                UM_StoreOrderNumber__c = descData.StoreOrderNumber,
                                                                LG_ServiceStatus__c = SERVICE_STATUS ,
                                                                csord__Status__c = SERVICE_STATUS ,
                                                                Name = serviceName,
                                                                LG_SLA__c = SLA,
                                                                UM_State__c = stateName,
                                                                LG_ProductFamily__c = PRODUCT_FAMILY,
                                                                csordtelcoa__Delta_Status__c = 'Add',
                                                                LG_ContractTerm__c = 0,
                                                                UM_Cancellation_Period__c = 0,
                                                                UM_VoiceWorksObjectId__c = vwsFeed.UM_VoiceWorksObjectId__c,
                                                                LG_ProvisioningAccountNo__c = vwsFeed.UM_VoiceworksAccountID__c,
                                                                LG_ProvisioningSystem__c = PROVISIONING_SYSTEM);
                                                                
                                numberServiceMap.put(i,objService1);
                            }
                        }
                        else
                            numberServiceMap.put(index,objService);
                    }
                    else{
                        if(addOnPi.UM_VoiceworksMoreServices__c){
                            for(integer i=0;i<vwsFeed.UM_Quantity__c;i++){
                                csord__Service__c objService2 = new csord__Service__c(csord__Subscription__c = kundensetupService.csord__Subscription__c,
                                                                csord__Service__c = kundensetupService.Id,
                                                                LG_Address__c = kundensetupService.LG_Address__c,
                                                                csord__Activation_Date__c = vwsFeed.UM_Startdate__c,
                                                                csord__Identification__c = kundensetupService.csord__Subscription__c + '_'+vwsFeed.UM_VoiceWorksObjectId__c+'_'+i,
                                                                //UM_SubscriberName__c = descData.Name,
                                                                //UM_PhoneExtension__c = descData.Extension,
                                                                UM_StoreOrderNumber__c = descData.StoreOrderNumber,
                                                                LG_ServiceStatus__c = SERVICE_STATUS ,
                                                                csord__Status__c = SERVICE_STATUS ,
                                                                Name = serviceName,
                                                                LG_SLA__c = SLA,
                                                                UM_State__c = stateName,
                                                                LG_ProductFamily__c = PRODUCT_FAMILY,
                                                                csordtelcoa__Delta_Status__c = 'Add',
                                                                LG_ContractTerm__c = 0,
                                                                UM_Cancellation_Period__c = 0,
                                                                UM_VoiceWorksObjectId__c = vwsFeed.UM_VoiceWorksObjectId__c,
                                                                LG_ProvisioningAccountNo__c = vwsFeed.UM_VoiceworksAccountID__c,
                                                                LG_ProvisioningSystem__c = PROVISIONING_SYSTEM);
                                numberServiceMap.put(i,objService2);
                            }
                        }else
                            numberServiceMap.put(index,objService);
                    }
                }else
                    numberServiceMap.put(index,objService);
            }
            
            vwsFeed.UM_Status__c = FEED_PROCESSED_STATUS;
            vwsFeed.UM_ErrorMessage__c = '';
            vwIdFeedToUpdateMap.put(vwsFeed.Id, vwsFeed);
        }
        
        return numberServiceMap.values();
    }
    
    // create non-subscriber Service line items
    private list<csord__Service_Line_Item__c> createNonSubscriberLineItems(list<UM_VW_Staging_Feed__c> vwsFeedList)
    {
        list<csord__Service_Line_Item__c> sliList = new list<csord__Service_Line_Item__c>();
        
        for(UM_VW_Staging_Feed__c vwsFeed : vwsFeedList)
        {
            boolean isEntryService = false;
            cspmb__Price_Item__c pi = null;
            cspmb__Add_On_Price_Item__c addOnPi = null;
            
            double cost = 0.0;
            string quantity;
            string billingId = null;

            if(productCodePriceItemMap.containsKey(vwsFeed.UM_ArticleNumber__c)){
                isEntryService = true;
                pi = productCodePriceItemMap.get(vwsFeed.UM_ArticleNumber__c);
                quantity = pi.UM_VoiceworksMoreServices__c? '1' : string.valueOf(integer.valueOf(vwsFeed.UM_Quantity__c));
            }else if(productCodeAddOnPriceItemMap.containsKey(vwsFeed.UM_ArticleNumber__c)){
                isEntryService = false;
                addOnPi = productCodeAddOnPriceItemMap.get(vwsFeed.UM_ArticleNumber__c);
                quantity = addOnPi.UM_VoiceworksMoreServices__c? '1' : string.valueOf(integer.valueOf(vwsFeed.UM_Quantity__c));
            }
            
            boolean isRecurring = false;
            if(vwsFeed.UM_Interval__c != null && vwsFeed.UM_Interval__c == '1' )
                isRecurring = true;
            
            if(isRecurring){
                // commented as Recurring charges come from VW
                //cost=pi.cspmb__Recurring_Charge__c;
                cost = vwsFeed.UM_UnitPrice__c;
                billingId = isEntryService ? pi.cspmb__Recurring_Charge_External_Id__c : addOnPi.cspmb__Recurring_Charge_External_Id__c;
            }else{
                cost = isEntryService ? pi.cspmb__One_Off_Charge__c : addOnPi.cspmb__One_Off_Charge__c;
                billingId = isEntryService ? pi.cspmb__One_Off_Charge_External_Id__c : addOnPi.cspmb__One_Off_Charge_External_Id__c;
            }
            
            string lineItemDescription;
            string SLIName;
            if(isEntryService){
                lineItemDescription = isRecurring ? pi.cspmb__Price_Item_Description__c : pi.cspmb__Price_Item_Description__c /* + ' Bereitstellungsentgelte' */;
                SLIName = lineItemDescription;
            }else{
                lineItemDescription = isRecurring ? addOnPi.cspmb__Add_On_Price_Item_Description__c : addOnPi.cspmb__Add_On_Price_Item_Description__c /*+ ' Bereitstellungsentgelte'*/;
                SLIName = lineItemDescription;
            }
            
            if(SLIName != null && SLIName.length() > 80)
                SLIName = SLIName.substring(0, 80);
            
            if(vwsFeed.UM_Quantity__c > 1 && isRecurring){
                if(isEntryService && pi != null && !pi.UM_VoiceworksMoreServices__c)
                    cost = cost * vwsFeed.UM_Quantity__c;
                else if(addOnPi != null && !addOnPi.UM_VoiceworksMoreServices__c)
                        cost = cost * vwsFeed.UM_Quantity__c;
            }
            
            if(vwsFeed.UM_UnitPrice__c < 0){
                cost = -cost; //negative cost from voiceworks
                lineItemDescription = 'Retoure ' + lineItemDescription;
                billingId = addOnPi.UM_CancellationCode__c;
            }

            csord__Service_Line_Item__c sli = new csord__Service_Line_Item__c(Name = SLIName,
                                                                            csord__Line_Description__c = lineItemDescription,
                                                                            LG_BillingProductId__c = billingId,
                                                                            UM_BillingProductId__c = billingId,
                                                                            csord__Is_Active__c = true,
                                                                            csord__Is_Recurring__c = isRecurring,
                                                                            csord__Total_Price__c = cost,
                                                                            LG_Quantity__c = quantity,
                                                                            UM_ServiceItemType__c = isRecurring ? '0' : '1',
                                                                            //csord__Service__c = sc.Id,
                                                                            csord__Identification__c = vwsFeed.UM_VoiceworksAccountID__c+'_'+billingId);
            sliList.add(sli);
        }
        
        return sliList;
    }
    
    // Process Subscriber data
    public void processSubscriberData(set<string> vwsSubscriberExtIdSet)
    {
        baNumberBillingAccountMap = dao.getBillingAccounts(baNumberSet);
        premiseNumberPremiseMap = dao.getAddressData(premiseNumberSet);
        
        map<string,csord__Subscription__c> accountNoSubscriptionMap = new map<string,csord__Subscription__c>();
        map<string,csord__Service__c> accountNoServiceMap = new map<string,csord__Service__c>();
        map<string,list<csord__Service_Line_Item__c>> accountNoSLItemsMap = new map<string,list<csord__Service_Line_Item__c>>();
        
        map<string,csord__Service__c> accountNoExtServiceMap = new map<string,csord__Service__c>();
        map<string,list<csord__Service_Line_Item__c>> accountNoExtSLItemsMap = new map<string,list<csord__Service_Line_Item__c>>();
        list<csord__Service_Line_Item__c> finalSliToInsertList = new list<csord__Service_Line_Item__c>();
        // collect the VoiceWorks Object Id for Extended Services only. This will help to identify the duplicates within same transaction.
        map<string, set<string>> subscriberIdVWObjIdSetMap = new map<string, set<string>>();
        
        for(string accountNumber : vwsSubscriberExtIdSet)
        {
            map<string, UM_VW_Staging_Feed__c> entrySubscriberVWFeedMap = new map<string, UM_VW_Staging_Feed__c>();
            map<string, list<UM_VW_Staging_Feed__c>> extendedSubscriberVWFeedMap = new map<string, list<UM_VW_Staging_Feed__c>>();
            //added below for BHP-83
            map<String,UM_VW_Staging_Feed__c> articleNoVWFeedMap = new Map<String,UM_VW_Staging_Feed__c>();
            map<String,map<String,UM_VW_Staging_Feed__c>> subscriberIdArticleNoVWFeedMap = new map<String,map<String,UM_VW_Staging_Feed__c>>();
            map<String,String> subscriberIdProductIdMap = new map<String,String>();
            for(UM_VW_Staging_Feed__c vws : vwExtIdSubscriberDataMap.get(accountNumber))
            {
                if(!externalIdKundensetupServiceMap.containsKey(accountNumber)){
                    // No kundensetup service found
                    vws.UM_Status__c = FEED_FAILED_STATUS;
                    vws.UM_ErrorMessage__c = 'Could not find Active Kundensetup Service with this Account Number.';
                    vwIdFeedToUpdateMap.put(vws.Id, vws);
                    continue;
                }
                if(!productCodePriceItemMap.containsKey(vws.UM_ArticleNumber__c)
                    && !productCodeAddOnPriceItemMap.containsKey(vws.UM_ArticleNumber__c)){
                    // invalid article number
                    vws.UM_Status__c = FEED_FAILED_STATUS;
                    vws.UM_ErrorMessage__c = 'Could not find this Article Number in Salesforce for Subscriber billing item.';
                    vwIdFeedToUpdateMap.put(vws.Id, vws);
                    continue;
                }
                
                if(productCodePriceItemMap.containsKey(vws.UM_ArticleNumber__c)){
                    if(subscriberIdSubscriberServiceMap.containsKey(vws.UM_SubscriberID__c)){
                        // Subscriber already present
                        vws.UM_Status__c = FEED_FAILED_STATUS;
                        vws.UM_ErrorMessage__c = 'Subscriber with this Subscriber Id is already present.';
                        vwIdFeedToUpdateMap.put(vws.Id, vws);
                        continue;
                    }
                    //added below for BHP-83
                    else if(!subscriberIdProductIdMap.isEmpty() && subscriberIdProductIdMap.get(vws.UM_SubscriberID__c) != productCodePriceItemMap.get(vws.UM_ArticleNumber__c).id)
                    {
                        vws.UM_Status__c = FEED_FAILED_STATUS;
                        vws.UM_ErrorMessage__c = 'Duplicate Entry service for same Subscriber Id. Another Entry service for same Subscriber is already selected for processing.';
                        vwIdFeedToUpdateMap.put(vws.Id, vws);
                        continue;
                    }
                    else if(!subscriberIdProductIdMap.isEmpty() && subscriberIdProductIdMap.get(vws.UM_SubscriberID__c) == productCodePriceItemMap.get(vws.UM_ArticleNumber__c).id && 
                            subscriberIdArticleNoVWFeedMap.containsKey(vws.UM_SubscriberID__c) && subscriberIdArticleNoVWFeedMap.get(vws.UM_SubscriberID__c).containsKey(vws.UM_ArticleNumber__c))
                    {
                        vws.UM_Status__c = FEED_FAILED_STATUS;
                        vws.UM_ErrorMessage__c = 'Duplicate Product entry found against this Subscriber Entry service';
                        vwIdFeedToUpdateMap.put(vws.Id, vws);
                    }
                    else
                    {
                       if(!entrySubscriberVWFeedMap.containsKey(vws.UM_SubscriberID__c))
                           entrySubscriberVWFeedMap.put(vws.UM_SubscriberID__c,vws); 
                       
                       articleNoVWFeedMap.put(vws.UM_ArticleNumber__c,vws); 
                       
                       if(!subscriberIdArticleNoVWFeedMap.containsKey(vws.UM_SubscriberID__c))
                           subscriberIdArticleNoVWFeedMap.put(vws.UM_SubscriberID__c,articleNoVWFeedMap);
                       else
                           subscriberIdArticleNoVWFeedMap.get(vws.UM_SubscriberID__c).put(vws.UM_ArticleNumber__c,vws);
                           
                       subscriberIdProductIdMap.put(vws.UM_SubscriberID__c,productCodePriceItemMap.get(vws.UM_ArticleNumber__c).id); 
                    
                    }
                    //BHP-83 changes end
                    //commented below for BHP-83
                    /*else if(!entrySubscriberVWFeedMap.containsKey(vws.UM_SubscriberID__c)){
                        entrySubscriberVWFeedMap.put(vws.UM_SubscriberID__c,vws);
                        system.debug('#entrySubscriberVWFeedMap'+entrySubscriberVWFeedMap);
                    }else{
                        // Subscriber already present
                        vws.UM_Status__c = FEED_FAILED_STATUS;
                        vws.UM_ErrorMessage__c = 'Duplicate Subscriber Id found. Same Subscriber is already selected for processing.';
                        vwIdFeedToUpdateMap.put(vws.Id, vws);
                        system.debug('#inside duplicate');
                    }*/
                }
                else if(productCodeAddOnPriceItemMap.containsKey(vws.UM_ArticleNumber__c)){
                    // filter data with finding out Feeds against each Subscriber Id
                    if(!subsIdVWObjIdServiceMap.isEmpty() && subsIdVWObjIdServiceMap.containsKey(vws.UM_SubscriberID__c)){
                        map<string, csord__Service__c> vwObjIdServiceMap = subsIdVWObjIdServiceMap.get(vws.UM_SubscriberID__c);
                        if(vwObjIdServiceMap != null && vwObjIdServiceMap.size() > 0 && vwObjIdServiceMap.containsKey(vws.UM_VoiceWorksObjectId__c)){
                            vws.UM_Status__c = FEED_FAILED_STATUS;
                            vws.UM_ErrorMessage__c = 'Subscriber Extended Service with this VoiceWorks Object Id is already present.';
                            vwIdFeedToUpdateMap.put(vws.Id, vws);
                            continue;
                        }
                    }
                    if(subscriberIdSubscriberServiceMap.containsKey(vws.UM_SubscriberID__c) 
                        && (subscriberIdSubscriberServiceMap.get(vws.UM_SubscriberID__c).LG_ServiceStatus__c != 'Active' 
                            || subscriberIdSubscriberServiceMap.get(vws.UM_SubscriberID__c).csord__Status__c != 'Active')){
                        vws.UM_Status__c = FEED_FAILED_STATUS;
                        vws.UM_ErrorMessage__c = 'Cound not process Extended Service, because Subscriber of this Extended Service is not Active.';
                        vwIdFeedToUpdateMap.put(vws.Id, vws);
                    }
                    else{
                        if(subscriberIdVWObjIdSetMap.containsKey(vws.UM_SubscriberID__c)){
                            set<string> extendedSerVWObjIdSet = subscriberIdVWObjIdSetMap.get(vws.UM_SubscriberID__c);
                            if(extendedSerVWObjIdSet.contains(vws.UM_VoiceWorksObjectId__c)){
                                vws.UM_Status__c = FEED_FAILED_STATUS;
                                vws.UM_ErrorMessage__c = 'Duplicate Subscriber Extended Service found. Same Subscriber Extended Service is already selected for processing.';
                                vwIdFeedToUpdateMap.put(vws.Id, vws);
                                continue;
                            }
                        }
                        
                        if(extendedSubscriberVWFeedMap.containsKey(vws.UM_SubscriberID__c)){
                            list<UM_VW_Staging_Feed__c> feedList = extendedSubscriberVWFeedMap.get(vws.UM_SubscriberID__c);
                            feedList.add(vws);
                            extendedSubscriberVWFeedMap.put(vws.UM_SubscriberID__c,feedList);
                        }else{
                            List<UM_VW_Staging_Feed__c> feedList = new List<UM_VW_Staging_Feed__c>();
                            feedList.add(vws);
                            extendedSubscriberVWFeedMap.put(vws.UM_SubscriberID__c,feedList);
                        }
                        
                        if(subscriberIdVWObjIdSetMap.containsKey(vws.UM_SubscriberID__c)){
                            set<string> extSerVWObjIdSet = subscriberIdVWObjIdSetMap.get(vws.UM_SubscriberID__c);
                            extSerVWObjIdSet.add(vws.UM_VoiceWorksObjectId__c);
                            subscriberIdVWObjIdSetMap.put(vws.UM_SubscriberID__c, extSerVWObjIdSet);
                        }else{
                            set<string> extSerVWObjIdSet = new set<string>();
                            extSerVWObjIdSet.add(vws.UM_VoiceWorksObjectId__c);
                            subscriberIdVWObjIdSetMap.put(vws.UM_SubscriberID__c, extSerVWObjIdSet);
                        }
                    }
                }
            }
            
            // process all Entry level Subscriber Services
            if(!entrySubscriberVWFeedMap.isEmpty())
            {
                for(string subscriberId : entrySubscriberVWFeedMap.keySet())
                {
                    if(!subscriberIdSubscriberServiceMap.containsKey(subscriberId))
                    {
                        // get billing account & Site
                        UM_VW_Staging_Feed__c vws = entrySubscriberVWFeedMap.get(subscriberId);
                        list<string> keysList = vws.UM_AccountNumber__c.split('\\|');
                        Id addressId = premiseNumberPremiseMap.get(keysList[1]).Id;
                        string serviceSLIKey = accountNumber + '-' + subscriberId;
                        // Create Subscription 
                        csord__Subscription__c subscriberSub = createSubscriberSubscription(vws, baNumberBillingAccountMap.get(keysList[0]),addressId);
                        accountNoSubscriptionMap.put(serviceSLIKey, subscriberSub);
                        // Create parent Service
                        csord__Service__c entryService = createSubscriberEntryService(vws, addressId);
                        accountNoServiceMap.put(serviceSLIKey, entryService);
                        // Create Service Line Items
                        //added below changes for BHP-83
                        List<UM_VW_Staging_Feed__c> vwFeedList= subscriberIdArticleNoVWFeedMap.get(subscriberId).values();
                        list<csord__Service_Line_Item__c> finalSLIList = new list<csord__Service_Line_Item__c>();
                        for(UM_VW_Staging_Feed__c vwsLI: vwFeedList)
                        {
                            list<string> keyList = vwsLI.UM_AccountNumber__c.split('\\|');
                            string errorMessage = '';
                            if(!baNumberBillingAccountMap.containsKey(keyList[0]))
                                errorMessage = 'Invalid Billing Account Number.';
                            if(!premiseNumberPremiseMap.containsKey(keyList[1]))
                                errorMessage += ' Invalid Billing Premise Number.';
                                
                            if(errorMessage == ''){   
                                list<csord__Service_Line_Item__c> sliList = createSubscriberLineItems(vwsLI);
                                if(!sliList.isEmpty())
                                    finalSLIList.addAll(sliList);
                            }
                            else
                            {
                                vwsLI.UM_Status__c = FEED_FAILED_STATUS;
                                vwsLI.UM_ErrorMessage__c = errorMessage ;
                                vwIdFeedToUpdateMap.put(vwsLI.Id, vwsLI);
                            }
                        }
                        if(!finalSLIList.isEmpty())
                            accountNoSLItemsMap.put(serviceSLIKey, finalSLIList);
                        //BHP-83 changes end
                    }
                }
            }
            
            if(!extendedSubscriberVWFeedMap.isEmpty())
            {
                for(string subscriberId : extendedSubscriberVWFeedMap.keySet())
                {
                    string serviceSLIKey = accountNumber + '-' + subscriberId;
                    list<csord__Service__c> serviceList = new list<csord__Service__c>();
                    list<csord__Service_Line_Item__c> sliList;// = new list<csord__Service_Line_Item__c>();
                    integer index = 0;
                                        
                    for(UM_VW_Staging_Feed__c vwsFeed : extendedSubscriberVWFeedMap.get(subscriberId))
                    {
                        if(subscriberIdSubscriberServiceMap.containsKey(vwsFeed.UM_SubscriberID__c) || 
                            entrySubscriberVWFeedMap.containsKey(vwsFeed.UM_SubscriberID__c))
                        {
                            list<string> keysList = vwsFeed.UM_AccountNumber__c.split('\\|');
                            string errorMsg = '';
                            if(!baNumberBillingAccountMap.containsKey(keysList[0]))
                                errorMsg = 'Invalid Billing Account Number.';
                            if(!premiseNumberPremiseMap.containsKey(keysList[1]))
                                errorMsg += ' Invalid Billing Premise Number.';

                            if(errorMsg == ''){
                                string newKey = serviceSLIKey + '-' + index;
                                // create service
                                csord__Service__c extendedService = createSubscriberExtendedService(vwsFeed);
                                accountNoExtServiceMap.put(newKey, extendedService);
                                // Create Service Line Items
                                sliList = createSubscriberLineItems(vwsFeed);
                                accountNoExtSLItemsMap.put(newKey, sliList);
                                index++;
                            }else{
                                vwsFeed.UM_Status__c = FEED_FAILED_STATUS;
                                vwsFeed.UM_ErrorMessage__c = errorMsg;
                                vwIdFeedToUpdateMap.put(vwsFeed.Id, vwsFeed);
                            }
                        }else{
                            vwsFeed.UM_Status__c = FEED_FAILED_STATUS;
                            vwsFeed.UM_ErrorMessage__c = 'Could not find Subscriber Entry Service with this Subscriber Id.';
                            vwIdFeedToUpdateMap.put(vwsFeed.Id, vwsFeed);
                        }
                    }
                }
            }
        }
        
        // Insert Subscriptions and put back to final subscription map
        if(!accountNoSubscriptionMap.isEmpty()){
            INSERT accountNoSubscriptionMap.values();
            // changed for BHP-18
            /*for(csord__Subscription__c sub : accountNoSubscriptionMap.values()){
                subscriberIdSubscriptionIdsMap.put(sub.UM_SubscriberID__c, sub.Id);
            }*/
            
            for(string key : accountNoSubscriptionMap.keySet()){
                csord__Subscription__c sub = accountNoSubscriptionMap.get(key);
                list<string> keysList = key.split('-');
                string subscriberId = keysList[1];
                subscriberIdSubscriptionIdsMap.put(subscriberId, sub.Id);
            }
        }
        system.debug('subscriberIdSubscriptionIdsMap------>' + subscriberIdSubscriptionIdsMap);
        
        // insert entry level services and set Service Id on service line item
        if(!accountNoServiceMap.isEmpty()){
            for(string key : accountNoServiceMap.keySet()){
                list<string> keysList = key.split('-');
                string subscriberId = keysList[1];
                accountNoServiceMap.get(key).csord__Subscription__c = subscriberIdSubscriptionIdsMap.get(subscriberId);
            }
            INSERT accountNoServiceMap.values();

            // Entry service - Service line items
            for(string key : accountNoSLItemsMap.keySet()){
                for(csord__Service_Line_Item__c sli : accountNoSLItemsMap.get(key)){
                    sli.csord__Service__c = accountNoServiceMap.get(key).Id;
                    finalSliToInsertList.add(sli);
                }
            }
        }
        
        if(!accountNoExtServiceMap.isEmpty())
        {
            for(string key : accountNoExtServiceMap.keySet()){
                list<string> keysList = key.split('-');
                string finalKey = keysList[0] + '-' + keysList[1];
                string subscriberId = keysList[1];
                
                if(accountNoServiceMap.containsKey(finalKey) && accountNoServiceMap.get(finalKey) != null){
                    accountNoExtServiceMap.get(key).csord__Service__c = accountNoServiceMap.get(finalKey).Id;
                    accountNoExtServiceMap.get(key).csord__Subscription__c = accountNoServiceMap.get(finalKey).csord__Subscription__c;
                    accountNoExtServiceMap.get(key).LG_Address__c = accountNoServiceMap.get(finalKey).LG_Address__c;
                }else if(subscriberIdSubscriberServiceMap.containsKey(subscriberId) && subscriberIdSubscriberServiceMap.get(subscriberId) != null){
                    accountNoExtServiceMap.get(key).csord__Service__c = subscriberIdSubscriberServiceMap.get(subscriberId).Id;
                    accountNoExtServiceMap.get(key).csordtelcoa__Delta_Status__c = 'Add';
                    accountNoExtServiceMap.get(key).csord__Subscription__c = subscriberIdSubscriptionIdsMap.get(subscriberId);
                    accountNoExtServiceMap.get(key).LG_Address__c = subscriberIdSubscriberServiceMap.get(subscriberId).LG_Address__c;
                }
            }
            
            INSERT accountNoExtServiceMap.values();
            
            // Extended service - Service line items
            for(string key : accountNoExtSLItemsMap.keySet()){
                for(csord__Service_Line_Item__c sli : accountNoExtSLItemsMap.get(key)){
                    sli.csord__Service__c = accountNoExtServiceMap.get(key).Id;
                    finalSliToInsertList.add(sli);
                }
            }
        }
        
        if(!finalSliToInsertList.isEmpty())
            INSERT finalSliToInsertList;
    }
    
    // Creation of Subscriber Subscription
    public csord__Subscription__c createSubscriberSubscription(UM_VW_Staging_Feed__c vws, csconta__Billing_Account__c billingAccount, Id addressId)
    {
        Id contractId = externalIdKundensetupServiceMap.get(vwExtIdSFVwExtIdMap.get(vws.UM_AccountNumber__c)).csord__Subscription__r.LG_Contract__c;
        string salesPartnerId = externalIdKundensetupServiceMap.get(vwExtIdSFVwExtIdMap.get(vws.UM_AccountNumber__c)).csord__Subscription__r.Sales_Partner_Id__c;
        
        csord__Subscription__c subscriberSub = new csord__Subscription__c(csconta__Billing_Account__c = billingAccount.Id,
                                                                       LG_Address__c = addressId,
                                                                       LG_Contract__c = contractId,
                                                                       UM_HPBXSalesPartnerId__c = salesPartnerId,
                                                                       csord__Identification__c = vws.UM_VoiceworksAccountID__c+'_'+vws.UM_SubscriberID__c,
                                                                       //UM_SubscriberId__c = vws.UM_SubscriberID__c,
                                                                       Name = SUBSCRIBER_ENTRY_SERVICE,
                                                                       //UM_VoiceworksAccountID__c = vws.UM_VoiceworksAccountID__c,
                                                                       csord__Account__c = billingAccount.csconta__Account__c);
        return subscriberSub;
    }
    
    // create subscriber Entry Service
    private csord__Service__c createSubscriberEntryService(UM_VW_Staging_Feed__c vwsFeed, Id addressId)
    {
        csord__Service__c entryService = new csord__Service__c();
        cspmb__Price_Item__c pi = null;
        Description descData = getParsedDescription(vwsFeed.UM_Description__c);
        
        if(productCodePriceItemMap.containsKey(vwsFeed.UM_ArticleNumber__c))
            pi = productCodePriceItemMap.get(vwsFeed.UM_ArticleNumber__c);
        
        list<string> keysList = vwsFeed.UM_AccountNumber__c.split('\\|');
        string stateName = 'NRW';
        if(keysList != null && keysList.size() >= 3)
            stateName = keysList.get(2);
        
        entryService = new csord__Service__c(LG_Address__c = addressId,
                                            csord__Activation_Date__c = vwsFeed.UM_Startdate__c,
                                            csord__Identification__c = vwsFeed.UM_ArticleNumber__c + '_'+vwsFeed.UM_VoiceWorksObjectId__c+'_0',
                                            UM_SubscriberId__c = vwsFeed.UM_SubscriberID__c,
                                            UM_SubscriberName__c = descData.Name,
                                            UM_PhoneExtension__c = descData.Extension,
                                            LG_ServiceStatus__c = SERVICE_STATUS ,
                                            csord__Status__c = SERVICE_STATUS ,
                                            Name= SUBSCRIBER_ENTRY_SERVICE,
                                            LG_SLA__c = SLA,
                                            UM_State__c = stateName,
                                            LG_ProductFamily__c = PRODUCT_FAMILY,
                                            LG_ContractTerm__c = 0,
                                            UM_Cancellation_Period__c = 0,
                                            UM_VoiceWorksObjectId__c = vwsFeed.UM_VoiceWorksObjectId__c,
                                            LG_ProvisioningAccountNo__c = vwsFeed.UM_VoiceworksAccountID__c,
                                            LG_ProvisioningSystem__c = PROVISIONING_SYSTEM);
        
        vwsFeed.UM_Status__c = FEED_PROCESSED_STATUS;
        vwsFeed.UM_ErrorMessage__c = '';
        vwIdFeedToUpdateMap.put(vwsFeed.Id, vwsFeed);
        
        return entryService;
    }
    
    // create subscriber Extended Service
    private csord__Service__c createSubscriberExtendedService(UM_VW_Staging_Feed__c vwsFeed)
    {
        csord__Service__c extendedService = new csord__Service__c();
        cspmb__Add_On_Price_Item__c addOnPi = null;
        string serviceName;
        list<string> keysList = vwsFeed.UM_AccountNumber__c.split('\\|');
        string stateName = 'NRW';
        if(keysList != null && keysList.size() >= 3)
            stateName = keysList.get(2);
            
        //Description descData = getParsedDescription(vwsFeed.UM_Description__c);
        
        if(productCodeAddOnPriceItemMap.containsKey(vwsFeed.UM_ArticleNumber__c)){
            addOnPi = productCodeAddOnPriceItemMap.get(vwsFeed.UM_ArticleNumber__c);
            serviceName = addOnPi.Name;
        }
        
        if(serviceName != null && serviceName.length() > 80)
            serviceName = serviceName.substring(0, 80);

        extendedService = new csord__Service__c(csord__Activation_Date__c = vwsFeed.UM_Startdate__c,
                                                csord__Identification__c = vwsFeed.UM_ArticleNumber__c + '_'+vwsFeed.UM_VoiceWorksObjectId__c+'_0',
                                                //UM_SubscriberName__c = descData.Name,
                                                //UM_PhoneExtension__c = descData.Extension,
                                                LG_ServiceStatus__c = SERVICE_STATUS ,
                                                csord__Status__c = SERVICE_STATUS ,
                                                Name = serviceName,
                                                LG_SLA__c = SLA,
                                                UM_State__c = stateName,
                                                LG_ProductFamily__c = PRODUCT_FAMILY,
                                                LG_ContractTerm__c = 0,
                                                UM_Cancellation_Period__c = 0,
                                                UM_VoiceWorksObjectId__c = vwsFeed.UM_VoiceWorksObjectId__c,
                                                LG_ProvisioningAccountNo__c = vwsFeed.UM_VoiceworksAccountID__c,
                                                LG_ProvisioningSystem__c = PROVISIONING_SYSTEM);
        
        vwsFeed.UM_Status__c = FEED_PROCESSED_STATUS;
        vwsFeed.UM_ErrorMessage__c = '';
        vwIdFeedToUpdateMap.put(vwsFeed.Id, vwsFeed);
        
        return extendedService;
    }
    
    // create subscriber Service line items
    private list<csord__Service_Line_Item__c> createSubscriberLineItems(UM_VW_Staging_Feed__c vwsFeed)
    {
        list<csord__Service_Line_Item__c> sliList = new list<csord__Service_Line_Item__c>();
        
        boolean isEntryService = false;
        boolean additionalLineItem = false;
        cspmb__Price_Item__c pi = null;
        cspmb__Add_On_Price_Item__c addOnPi = null;
        double cost = 0.0;
        string billingId = null;
        string quantity = string.valueOf(integer.valueOf(vwsFeed.UM_Quantity__c));
        //added below for BHP-83
        string numberOfUnits = null;
        string unitType = null;
        if(productCodePriceItemMap.containsKey(vwsFeed.UM_ArticleNumber__c)){
            isEntryService = true;
            pi = productCodePriceItemMap.get(vwsFeed.UM_ArticleNumber__c);
            additionalLineItem = pi.UM_Create_Additional_Line_Item__c;
        }
        else if(productCodeAddOnPriceItemMap.containsKey(vwsFeed.UM_ArticleNumber__c)){
            isEntryService = false;
            addOnPi = productCodeAddOnPriceItemMap.get(vwsFeed.UM_ArticleNumber__c);
            additionalLineItem = addOnPi.UM_Create_Additional_Line_Item__c;
        }
        
        boolean isRecurring = false;
        if(vwsFeed.UM_Interval__c != null && vwsFeed.UM_Interval__c == '1' )
            isRecurring = true;
        
        if(isRecurring){
            // commented as Recurring charges come from VW
            //cost=pi.cspmb__Recurring_Charge__c;
            cost = vwsFeed.UM_UnitPrice__c;
            billingId = isEntryService ? pi.cspmb__Recurring_Charge_External_Id__c : addOnPi.cspmb__Recurring_Charge_External_Id__c;
        }else{
            cost = isEntryService ? pi.cspmb__One_Off_Charge__c : addOnPi.cspmb__One_Off_Charge__c;
            billingId = isEntryService ? pi.cspmb__One_Off_Charge_External_Id__c : addOnPi.cspmb__One_Off_Charge_External_Id__c;
        }
        
        string lineItemDescription;
        string SLIName;
        
        if(isEntryService){
            lineItemDescription = isRecurring ? pi.cspmb__Price_Item_Description__c : pi.cspmb__Price_Item_Description__c /* + ' Bereitstellungsentgelte'*/;
            SLIName = lineItemDescription;
        }else{
            lineItemDescription = isRecurring ? addOnPi.cspmb__Add_On_Price_Item_Description__c : addOnPi.cspmb__Add_On_Price_Item_Description__c /* + ' Bereitstellungsentgelte'*/;
            SLIName = lineItemDescription;
        }
        
        if(SLIName != null && SLIName.length() > 80)
            SLIName = SLIName.substring(0, 80);
        
        // Commented as per OMB-1508
        /*
        Description descData = getParsedDescription(vwsFeed.UM_Description__c);
        
        if(descData != null && descData.Name != null){
            lineItemDescription = lineItemDescription + ' ' + descData.Name +' (Ext.' + descData.Extension + ')';
        }*/
        if(vwsFeed.UM_Quantity__c > 1 && isRecurring){
            if(isEntryService && pi != null && !pi.UM_VoiceworksMoreServices__c)
                cost = cost * vwsFeed.UM_Quantity__c;
            else if(addOnPi != null && !addOnPi.UM_VoiceworksMoreServices__c)
                cost = cost * vwsFeed.UM_Quantity__c;
        }
        
        //added below for BHP-83 
        if(isEntryService && pi != null && pi.UM_NumberOfUnitsRequired__c && isRecurring)
        {
            system.debug('#inside BP83 changes');
            quantity = '1';
            numberOfUnits = string.valueOf(integer.valueOf(vwsFeed.UM_Quantity__c));
            unitType = pi.UM_UnitType__c;
        }
        //BHP-83 changes end
        csord__Service_Line_Item__c sli = new csord__Service_Line_Item__c(Name = SLIName,
                                                                        csord__Line_Description__c = lineItemDescription,
                                                                        LG_BillingProductId__c = billingId,
                                                                        UM_BillingProductId__c = billingId,
                                                                        csord__Is_Active__c = true,
                                                                        csord__Is_Recurring__c = isRecurring,
                                                                        csord__Total_Price__c = cost,
                                                                        LG_Quantity__c = quantity,
                                                                        UM_ServiceItemType__c = isRecurring ? '0' : '1',
                                                                        //below field for BHP-83 
                                                                        UM_NumberOfUnits__c = numberOfUnits ,
                                                                        UM_UnitType__c = unitType ,
                                                                        //csord__Service__c = sc.Id,
                                                                        csord__Identification__c = vwsFeed.UM_SubscriberID__c+'_'+billingId);
        sliList.add(sli);
        // create additional line item
        if(additionalLineItem)
        {
            billingId = null;
            isRecurring = isRecurring ? false : true;
            cost = 0.0;
            //added below for BHP-83
            numberOfUnits = null;
            unitType =  null;
            
            if(productCodePriceItemMap.containsKey(vwsFeed.UM_ArticleNumber__c)){
                isEntryService = true;
                pi = productCodePriceItemMap.get(vwsFeed.UM_ArticleNumber__c);
            }
            else if(productCodeAddOnPriceItemMap.containsKey(vwsFeed.UM_ArticleNumber__c)){
                isEntryService = false;
                addOnPi = productCodeAddOnPriceItemMap.get(vwsFeed.UM_ArticleNumber__c);
            }
            
            if(isRecurring){
                // commented as Recurring charges come from VW
                cost = isEntryService ? pi.cspmb__Recurring_Charge__c : addOnPi.cspmb__Recurring_Charge__c;
                //cost = vwsFeed.UM_UnitPrice__c;
                billingId = isEntryService ? pi.cspmb__Recurring_Charge_External_Id__c : addOnPi.cspmb__Recurring_Charge_External_Id__c;
            }else{
                cost = isEntryService ? pi.cspmb__One_Off_Charge__c : addOnPi.cspmb__One_Off_Charge__c;
                billingId = isEntryService ? pi.cspmb__One_Off_Charge_External_Id__c : addOnPi.cspmb__One_Off_Charge_External_Id__c;
            }

            lineItemDescription = '';
            SLIName = '';
            
            if(isEntryService){
                lineItemDescription = isRecurring ? pi.cspmb__Price_Item_Description__c : pi.cspmb__Price_Item_Description__c /* + ' Bereitstellungsentgelte'*/;
                SLIName = lineItemDescription;
            }
            else{
                lineItemDescription = isRecurring ? addOnPi.cspmb__Add_On_Price_Item_Description__c : addOnPi.cspmb__Add_On_Price_Item_Description__c /* + ' Bereitstellungsentgelte'*/;
                SLIName = lineItemDescription;
            }
        
            if(SLIName != null && SLIName.length() > 80)
                SLIName = SLIName.substring(0, 80);
            
            if(vwsFeed.UM_Quantity__c > 1 && isRecurring){
                if(isEntryService && pi != null && !pi.UM_VoiceworksMoreServices__c)
                    cost = cost * vwsFeed.UM_Quantity__c;
                else if(addOnPi != null && !addOnPi.UM_VoiceworksMoreServices__c)
                    cost = cost * vwsFeed.UM_Quantity__c;
            }
            //added below for BHP-83 
            if(isEntryService && pi != null && pi.UM_NumberOfUnitsRequired__c && isRecurring)
            {
                quantity = '1';
                numberOfUnits = string.valueOf(integer.valueOf(vwsFeed.UM_Quantity__c));
                unitType = pi.UM_UnitType__c;
            }
            //BHP-83 changes end
            csord__Service_Line_Item__c sli1 = new csord__Service_Line_Item__c(Name = SLIName,
                                                                            csord__Line_Description__c = lineItemDescription,
                                                                            LG_BillingProductId__c = billingId,
                                                                            UM_BillingProductId__c = billingId,
                                                                            csord__Is_Active__c = true,
                                                                            csord__Is_Recurring__c = isRecurring,
                                                                            csord__Total_Price__c = cost,
                                                                            LG_Quantity__c = quantity,
                                                                            UM_ServiceItemType__c = isRecurring ? '0' : '1',
                                                                            //csord__Service__c = sc.Id,
                                                                            //below field for BHP-83 
                                                                            UM_NumberOfUnits__c = numberOfUnits ,
                                                                            UM_UnitType__c = unitType ,
                                                                            csord__Identification__c = vwsFeed.UM_SubscriberID__c+'_'+billingId);
            sliList.add(sli1);
        }
        //added below for BHP-83
        vwsFeed.UM_Status__c = FEED_PROCESSED_STATUS;
        vwsFeed.UM_ErrorMessage__c = '';
        vwIdFeedToUpdateMap.put(vwsFeed.Id, vwsFeed);
        //BHP-83 ends
        return sliList;
    }

    public void processHardwareData(list<UM_VW_Staging_Feed__c> vwFeedList)
    {
        map<string,list<UM_VW_Staging_Feed__c>> storeOrderFeedsMap = new map<string,list<UM_VW_Staging_Feed__c>>();
        list<Asset> assetsToBeCreatedList = new list<Asset>();
        
        for(UM_VW_Staging_Feed__c vws : vwFeedList)
        {
            if(storeOrderFeedsMap.containsKey(vws.UM_StoreOrderNumber__c)){
                list<UM_VW_Staging_Feed__c> feedList = storeOrderFeedsMap.get(vws.UM_StoreOrderNumber__c);
                feedList.add(vws);
                storeOrderFeedsMap.put(vws.UM_StoreOrderNumber__c,feedList);
            }else{
                List<UM_VW_Staging_Feed__c> feedList=new List<UM_VW_Staging_Feed__c>();
                feedList.add(vws);
                storeOrderFeedsMap.put(vws.UM_StoreOrderNumber__c,feedList);
            }
        }
        
        // find the Services with Hardware information
        map<string,list<csord__Service__c>> storeOrderServicesMap = dao.getExistingServicesWithAssets(storeOrderFeedsMap.keySet());
        
        // Process data against each store order number.
        for(string storeOrderNo : storeOrderFeedsMap.keySet())
        {
            list<UM_VW_Staging_Feed__c> vwsFeedToProcessList = storeOrderFeedsMap.get(storeOrderNo);

            if(storeOrderServicesMap != NULL && storeOrderServicesMap.containsKey(storeOrderNo)){
                list<csord__Service__c> thisOrderServicesList = storeOrderServicesMap.get(storeOrderNo);
                integer feedIndex = -1;
                
                for(csord__Service__c ser : thisOrderServicesList){
                    if(ser.csord__Salesforce_Assets__r == NULL || ser.csord__Salesforce_Assets__r.size() == 0){
                        ++feedIndex;
                        if(vwsFeedToProcessList.size() > feedIndex){
                            UM_VW_Staging_Feed__c vwsFeed = vwsFeedToProcessList.get(feedIndex);
                            
                            Asset a = new Asset(csord__Service__c = ser.Id,
                                                  AccountId = ser.csord__Subscription__r.csord__Account__c,
                                                  SerialNumber = vwsFeed.UM_Serial__c,
                                                  LG_MACAddress__c = vwsFeed.UM_MAC__c,
                                                  UM_Model__c = vwsFeed.UM_Model__c,
                                                  UM_Brand__c = vwsFeed.UM_Brand__c,
                                                  UM_ShippingDate__c = vwsFeed.UM_ShippingDate__c,
                                                  Status = 'Active',
                                                  Name = 'Hardware');
                            assetsToBeCreatedList.add(a);
                            // Mark this as Processed
                            vwsFeed.UM_Status__c = FEED_PROCESSED_STATUS;
                            vwsFeed.UM_ErrorMessage__c = '';
                            vwIdFeedToUpdateMap.put(vwsFeed.Id, vwsFeed);
                        }
                    }
                }
                ++feedIndex;
                // Mark failed as services are less than the number of Hardwares
                if(vwsFeedToProcessList.size() > feedIndex){
                    for(integer i=feedIndex;i<vwsFeedToProcessList.size();i++){
                        UM_VW_Staging_Feed__c vwsFeed = vwsFeedToProcessList.get(i);

                        vwsFeed.UM_Status__c = FEED_FAILED_STATUS;
                        vwsFeed.UM_ErrorMessage__c = 'Services are less than the number of Hardwares received.';
                        vwIdFeedToUpdateMap.put(vwsFeed.Id, vwsFeed);
                    }
                }
            }else{   // Mark failed as no services found
                for(UM_VW_Staging_Feed__c vwsFeed : vwsFeedToProcessList){
                    vwsFeed.UM_Status__c = FEED_FAILED_STATUS;
                    vwsFeed.UM_ErrorMessage__c = 'No Active Service found with this Store Order Number.';
                    vwIdFeedToUpdateMap.put(vwsFeed.Id, vwsFeed);
                }
            }
        }
        
        if(!assetsToBeCreatedList.isEmpty())
            INSERT assetsToBeCreatedList;
    }
    
    @InvocableMethod(label='InvokeBatchProcessStagingData')
    public static void InvokeBatchProcessStagingData(list<string> transactionIdList)
    {
        String nonSubscriberQuery = UM_VWStagingFeedUtil.getQuery('UM_VW_Staging_Feed__c') + 
                                                                ' WHERE UM_Status__c=\'New\' AND UM_Type__c = \'Feed\'' +
                                                                ' AND UM_SubscriberID__c = null' + 
                                                                ' AND UM_AccountNumber__c <> null';
        
        UM_VWStagingFeedProcessBatch vwNonSubscriberBatch = new UM_VWStagingFeedProcessBatch();
        
        if(transactionIdList != null && !transactionIdList.isEmpty()){
            nonSubscriberQuery += ' AND UM_TransactionId__c IN: transactionIdList';
            vwNonSubscriberBatch.transactionIdList = transactionIdList; 
        }
        vwNonSubscriberBatch.query = nonSubscriberQuery;
        vwNonSubscriberBatch.processType = 'nonSubscriber';
        Database.executeBatch(vwNonSubscriberBatch, 1);
        
        String subscriberQuery = UM_VWStagingFeedUtil.getQuery('UM_VW_Staging_Feed__c') + 
                                                                ' WHERE UM_Status__c=\'New\' AND UM_Type__c = \'Feed\'' +
                                                                ' AND UM_SubscriberID__c <> null' + 
                                                                ' AND UM_AccountNumber__c <> null';

        UM_VWStagingFeedProcessBatch vwSubscriberBatch = new UM_VWStagingFeedProcessBatch();                                                                
        if(transactionIdList != null && !transactionIdList.isEmpty()){
            subscriberQuery += ' AND UM_TransactionId__c IN: transactionIdList';
            vwSubscriberBatch.transactionIdList = transactionIdList;
        }
        vwSubscriberBatch.query = subscriberQuery;
        vwSubscriberBatch.processType = 'Subscriber';
        
        if(!Test.isRunningTest())
            Database.executeBatch(vwSubscriberBatch, 1);
        
        String hardwareQuery = UM_VWStagingFeedUtil.getQuery('UM_VW_Staging_Feed__c') + 
                                                            ' WHERE UM_Status__c=\'New\' AND UM_Type__c = \'Feed\'' +
                                                            ' AND UM_SubscriberID__c = null' + 
                                                            ' AND UM_AccountNumber__c = null' +
                                                            ' AND UM_StoreOrderNumber__c <> null';
        
        UM_VWStagingFeedProcessBatch vwHardwareBatch = new UM_VWStagingFeedProcessBatch();
        if(transactionIdList != null && !transactionIdList.isEmpty()){
            hardwareQuery += ' AND UM_TransactionId__c IN: transactionIdList';
            vwHardwareBatch.transactionIdList = transactionIdList;
        }
        vwHardwareBatch.query = hardwareQuery + ' ORDER BY UM_Brand__c ASC';
        vwHardwareBatch.processType = 'Hardware';

        if(!Test.isRunningTest())
            Database.executeBatch(vwHardwareBatch, 1);
    }
    
    public static String getQuery(String objectType){
        String query='Select Id';
        SObjectType objtype = Schema.getGlobalDescribe().get(objectType);
        Map<String,Schema.SObjectField> mfields = objtype.getDescribe().fields.getMap();
        Set<String> fieldkeys=mfields.keySet();
        for(String key:fieldkeys){
            
           if(key.equalsIgnoreCase('Id'))continue;
           
           Schema.SObjectField sf=mfields.get(key);
           Schema.DescribeFieldResult sdr=sf.getDescribe();
           String name=sdr.getName();
           query+=','+name;
        }
        query+=' from '+objectType;
        return query;
    }
    
    public map<string, list<UM_VW_Staging_Feed__c>> collectSubscriberData(list<UM_VW_Staging_Feed__c> vwsDataList)
    {
        map<string, list<UM_VW_Staging_Feed__c>> subsIdVWSDataMap = new map<string, list<UM_VW_Staging_Feed__c>>();
        
        for(UM_VW_Staging_Feed__c vws : vwsDataList)
        {
            if(vws.UM_SubscriberID__c != null && !vws.UM_SubscriberID__c.equals('')){
                if(subsIdVWSDataMap.containsKey(vws.UM_SubscriberID__c)){
                    list<UM_VW_Staging_Feed__c> feedList = subsIdVWSDataMap.get(vws.UM_SubscriberID__c);
                    feedList.add(vws);
                    subsIdVWSDataMap.put(vws.UM_SubscriberID__c,feedList);
                }else{
                    List<UM_VW_Staging_Feed__c> feedList=new List<UM_VW_Staging_Feed__c>();
                    feedList.add(vws);
                    subsIdVWSDataMap.put(vws.UM_SubscriberID__c,feedList);
                }
            }
        }
        return subsIdVWSDataMap;
    }
    
    public map<string, list<UM_VW_Staging_Feed__c>> collectNonSubscriberData(list<UM_VW_Staging_Feed__c> vwsDataList)
    {
        map<string, list<UM_VW_Staging_Feed__c>> vwExtIdVWSDataMap = new map<string, list<UM_VW_Staging_Feed__c>>();
        
        for(UM_VW_Staging_Feed__c vws : vwsDataList)
        {
            if(vws.UM_AccountNumber__c != null && !vws.UM_AccountNumber__c.equals('')){
                if(vwExtIdVWSDataMap.containsKey(vws.UM_AccountNumber__c)){
                    list<UM_VW_Staging_Feed__c> feedList = vwExtIdVWSDataMap.get(vws.UM_AccountNumber__c);
                    feedList.add(vws);
                    vwExtIdVWSDataMap.put(vws.UM_AccountNumber__c,feedList);
                }else{
                    List<UM_VW_Staging_Feed__c> feedList=new List<UM_VW_Staging_Feed__c>();
                    feedList.add(vws);
                    vwExtIdVWSDataMap.put(vws.UM_AccountNumber__c,feedList);
                }
            }
        }
        return vwExtIdVWSDataMap;
    }
    
    public map<string, list<UM_VW_Staging_Feed__c>> collectHardwareData(list<UM_VW_Staging_Feed__c> vwsDataList)
    {
        map<string, list<UM_VW_Staging_Feed__c>> storeIdVWSDataMap = new map<string, list<UM_VW_Staging_Feed__c>>();
        
        for(UM_VW_Staging_Feed__c vws : vwsDataList)
        {
            if(vws.UM_StoreOrderNumber__c != null && !vws.UM_StoreOrderNumber__c.equals('')){
                if(storeIdVWSDataMap.containsKey(vws.UM_StoreOrderNumber__c)){
                    list<UM_VW_Staging_Feed__c> feedList = storeIdVWSDataMap.get(vws.UM_StoreOrderNumber__c);
                    feedList.add(vws);
                    storeIdVWSDataMap.put(vws.UM_StoreOrderNumber__c,feedList);
                }else{
                    List<UM_VW_Staging_Feed__c> feedList=new List<UM_VW_Staging_Feed__c>();
                    feedList.add(vws);
                    storeIdVWSDataMap.put(vws.UM_StoreOrderNumber__c,feedList);
                }
            }
        }
        return storeIdVWSDataMap;
    }
}
