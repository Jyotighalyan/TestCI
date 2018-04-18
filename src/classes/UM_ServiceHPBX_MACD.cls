public class UM_ServiceHPBX_MACD implements UM_KenanSyncBatch.IServiceConnect
{
    public void execute(list<sObject> servicesList)
    {
        list<csord__Service__c> allServices = (list<csord__Service__c>) servicesList;
        map<Id, csord__Service__c> serviceIdServiceToUpdateMap = new map<Id, csord__Service__c>();
        list<csord__Service_Line_Item__c> sliToBeUpdatedList = new list<csord__Service_Line_Item__c>();
        list<csord__Subscription__c> subscriptionToBeUpdatedList = new list<csord__Subscription__c>();      
        KenanConnectorService kenanConService = new KenanConnectorService();

        for(csord__Service__c s : allServices)
        {
            if(s.csord__Service__c != null){
                list<csord__Service_Line_Item__c> sliList = s.csord__Service_Line_Items__r; 
                // Add child service
                if(!sliList.isEmpty() && sliList.size() > 0 && ( s.csordtelcoa__Delta_Status__c == 'Add'|| ( s.csordtelcoa__Delta_Status__c ==null && (s.csord__Service__r.LG_DecompositionCriteria__c== 'Set 22 - Parent/Category Only' ||s.csord__Service__r.LG_DecompositionCriteria__c== 'Set 7 - JIRA Fiber' ||s.csord__Service__r.LG_DecompositionCriteria__c== 'Set 20 - BDS Site Process'))
                 || ((s.csordtelcoa__Delta_Status__c != null || s.csordtelcoa__Delta_Status__c == 'Added') && (s.csord__Service__r.LG_DecompositionCriteria__c== 'Set 7 - JIRA Fiber' || s.csord__Service__r.LG_DecompositionCriteria__c== 'Set 20 - BDS Site Process'))
                 )){
                    for(csord__Service_Line_Item__c sli : sliList){
                    	if(s.csord__Service__r.LG_DecompositionCriteria__c== 'Set 7 - JIRA Fiber' && sli.Do_Not_Sync_with_Billing__c == 'Yes')
                            continue;
                    	
                        if(sli.UM_KenanServiceLineId__c == null){
                            KenanServiceItem newKSI = UM_KenanSubscriptionSyncCtrl.createKenanServiceItem(sli);
                            newKSI.serviceExternalId = s.csord__Service__c;    //replacedLineItem.csord__Service__c;
                            newKSI.activeDate = s.csord__Activation_Date__c;
                            
                            newKSI.extData = new Map<String, Object>();
                            string itemDescription = sli.csord__Line_Description__c;
                            if(itemDescription != null && !String.isBlank(itemDescription) && itemDescription.length() > 50)
                                itemDescription = itemDescription.subString(0,50);
                            
                            if(newKSI.itemType == 0)
                                newKSI.extData.put('16', itemDescription);
                            else if(newKSI.itemType == 1)
                                newKSI.extData.put('15', itemDescription);
                            
                            if(newKSI.rate < 0)
                                newKSI.rate = newKSI.rate * -1;
                            
                            if(!Test.isRunningTest()){
                                list<KenanServiceItem> ksiBackList = kenanConService.serviceItemCreate(newKSI);
                                if(ksiBackList != null && !ksiBackList.isEmpty()){
                                    sli.UM_KenanServiceLineId__c = ksiBackList[0].instanceId;
                                    sliToBeUpdatedList.add(sli);
                                    
                                    if(!serviceIdServiceToUpdateMap.containsKey(s.Id)){
                                        s.csord__Status__c = 'Active';
                                        s.LG_ServiceStatus__c = 'Active';
                                        s.csordtelcoa__Delta_Status__c = null;
                                        serviceIdServiceToUpdateMap.put(s.Id, s);
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Terminate child service
                if(!sliList.isEmpty() && sliList.size() > 0 && ( s.csordtelcoa__Delta_Status__c == 'Terminate' ||s.csordtelcoa__Delta_Status__c == 'Deleted From Subscription' && s.csord__Status__c=='Ready For Billing')){
                    system.debug('in child service termination block');
                    for(csord__Service_Line_Item__c sli : sliList){
                        if(sli.UM_KenanServiceLineId__c != null && sli.csord__Is_Recurring__c){
                            KenanServiceItem newKSI = UM_KenanSubscriptionSyncCtrl.createKenanServiceItem(sli);
                            newKSI.instanceId = sli.UM_KenanServiceLineId__c;
                            Time myTime = Time.newInstance(0, 0, 0, 0);
                            newKSI.inactiveDate = DateTime.newInstance(s.csord__Deactivation_Date__c, myTime);
                            
                            if(newKSI.rate < 0)
                                newKSI.rate = newKSI.rate * -1;
                            
                            if(!Test.isRunningTest()){
                                if(kenanConService.serviceItemCease(newKSI)){
                                    if(!serviceIdServiceToUpdateMap.containsKey(s.Id)){
                                        s.csord__Status__c = 'Inactive';
                                        s.LG_ServiceStatus__c = 'Inactive';
                                        s.csordtelcoa__Delta_Status__c = null;
                                        serviceIdServiceToUpdateMap.put(s.Id, s);
                                    }
                                }
                            }
                        }
                    }
                }
            }else if(s.csord__Service__c == null){
                if(s.LG_ServiceExternalId__c != null && s.csordtelcoa__Delta_Status__c == 'Modify'){
                    KenanService service = new KenanService();
                    service.salesforceObjectId = s.Id;
                    service.extData = new Map<String, Object>();

                    if(s.UM_SubscriberName__c != null )
                        service.extData.put('25',string.valueof(s.UM_SubscriberName__c));
                    if(s.UM_PhoneExtension__c != null )
                        service.extData.put('26',string.valueof(s.UM_PhoneExtension__c));
                    
                    KenanService ksBack = null;
                    
                    if(!Test.isRunningTest())
                        ksBack = kenanConService.serviceModify(service);
                    
                    if(ksBack != null && ksBack.serviceInternalId != null){
                        //s.csord__Status__c = 'Active';
                        //s.LG_ServiceStatus__c = 'Active';
                        s.csordtelcoa__Delta_Status__c = null;
                        serviceIdServiceToUpdateMap.put(s.Id, s);
                    }
                }
                // Terminate parent service
                if(s.LG_ServiceExternalId__c != null && s.csordtelcoa__Delta_Status__c == 'Terminate' && !Test.isRunningTest())
                {
                    if(UM_KenanSubscriptionSyncCtrl.terminateServices(s.csord__Subscription__c, s.csord__Deactivation_Date__c, '')){
                        s.csord__Status__c = 'Inactive';
                        s.LG_ServiceStatus__c = 'Inactive';
                        s.csordtelcoa__Delta_Status__c = null;
                        serviceIdServiceToUpdateMap.put(s.Id, s);
                        
                        csord__Subscription__c sub = new csord__Subscription__c(id=s.csord__Subscription__c);
                        sub.Billing_Termination_Date__c = DateTime.now();
                        sub.Kenan_Response__c = null;
                        subscriptionToBeUpdatedList.add(sub);
                    }
                }
            }
        }
        if(!sliToBeUpdatedList.isEmpty())
            UPDATE sliToBeUpdatedList;
        if(!serviceIdServiceToUpdateMap.isEmpty())
            UPDATE serviceIdServiceToUpdateMap.values();
        if(!subscriptionToBeUpdatedList.isEmpty())
            UPDATE subscriptionToBeUpdatedList;
    }
}