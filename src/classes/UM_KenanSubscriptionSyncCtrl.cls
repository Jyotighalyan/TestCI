public with sharing class UM_KenanSubscriptionSyncCtrl {

    public UM_KenanSubscriptionSyncCtrl(){
        //constructor
    }

    public static list<csord__Service__c> getServices(Id subId){
        return [SELECT id,UM_DeactivationReason__c, UM_ProductDescription__c,csord__Status__c, LG_ProductFamily__c, LG_ProductName__c, LG_Quantity__c,
                LG_CurrencyCode__c ,csord__Activation_Date__c,LG_Address__r.cscrm__Street__c,
                LG_Address__r.LG_HouseNumber__c,LG_Address__r.cscrm__Country__c,LG_Address__r.LG_AddressID__c,
                LG_Address__r.cscrm__Zip_Postal_Code__c,LG_Address__r.cscrm__State_Province__c,
                csordtelcoa__Service_Number__c,LG_Address__r.cscrm__City__c,LG_ContractTerm__c,
                csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c,UM_PartnerAccount__c,
                LG_Address__r.LG_HouseNumberExtension__c,UM_CustomersInvoiceGroupingReference__c,
                LG_ContractStartDate__c,LG_ContractEndDate__c,UM_PartnerSalesId__c,
                UM_PartnerAccount__r.UM_P_Sales_ID_NRW_HSN__c,UM_PartnerAccount__r.UM_P_Sales_ID_BW__c,UM_SubscriberName__c, UM_PhoneExtension__c,
                UM_Cancellation_Period__c, UM_Latest_Cancellation_Letter_Arrival__c, UM_HPBXExternalId__c, UM_SubscriberID__c,
                csordtelcoa__Replacement_Service__r.UM_DeactivationReason__c,UM_SendVoiceworksExternalID__c,LG_Charge_Group_Name__c  // changes for DGT-322
                FROM csord__Service__c
                WHERE csord__Subscription__c = :subId and csord__Service__c = null];
    }

    public static map<id,list<csord__Service_Line_Item__c >> getServiceItems(set<Id> subscriptionIds){
        map<id,list<csord__Service_Line_Item__c >> serviceItemMap = new map<id,list<csord__Service_Line_Item__c >>();
        list<csord__Service_Line_Item__c > services = new list<csord__Service_Line_Item__c >();
        map<id,id> parentServiceMap = new map<id,id>();
        Id serviceId;

        list<csord__Service_Line_Item__c> serviceItems = [SELECT id,csordtelcoa__Line_Item_Reference_Id__c,csordtelcoa__Delta_Status__c,csord__Service__r.csord__Subscription__c,UM_Price_Override__c ,csord__Service__c,
                                                            UM_ServiceItemType__c,UM_KenanServiceLineId__c,csord__Service__r.csord__Service__c,csord__Line_Description__c,
                                                            csord__Service__r.csordtelcoa__Service_Number__c,UM_BillingProductId__c,LG_BillingProductId__c,
                                                            csord__Total_Price__c, UM_NumberOfUnits__c, UM_UnitType__c,csord__Is_Recurring__c,
                                                           csord__Discount_Value__c,csord__Discount_Type__c,UM_DiscountEndDate__c,csord__Discounted_Amount__c,
                                                          UM_ContractId__c,UM_RecurringPriceDiscount__c,csord__Service__r.LG_DecompositionCriteria__c, UM_OneOffPriceDiscount__c,
                                                          csord__Service__r.csord__Service__r.Name
                                                          FROM csord__Service_Line_Item__c
                                                          WHERE Do_Not_Sync_with_Billing__c!='Yes' AND
                                                                csord__Service__r.csord__Subscription__c in :subscriptionIds 
                                                        //added as part of sfom-2285
                                                         AND (csord__Service__r.csord__Service__r.LG_DecompositionCriteria__c != 'Set 22 - Parent/Category Only'
                                                         OR (csord__Service__r.csord__Status__c ='Ready for Billing' AND csord__Service__r.csord__Service__r.LG_DecompositionCriteria__c = 'Set 22 - Parent/Category Only'))        
                                                        //OMB-1847 -start
                                                         AND ((csord__Service__r.LG_DecompositionCriteria__c != 'Set 7 - JIRA Service')
                                                         OR (csord__Service__r.csord__Status__c ='Ready for Billing' AND csord__Service__r.LG_DecompositionCriteria__c = 'Set 7 - JIRA Service' and UM_KenanServiceLineId__c = null))
                                                        //OMB-1847 - End
                                                        //DGT-381 - start
                                                        AND ((csord__Service__r.csord__Service__r.LG_DecompositionCriteria__c != 'Set 20 - BDS Site Process')
                                                         OR (csord__Service__r.csord__Status__c ='Ready for Billing' AND csord__Service__r.csord__Service__r.LG_DecompositionCriteria__c = 'Set 20 - BDS Site Process' and UM_KenanServiceLineId__c = null))
                                                         //DGT-381 - End
														 
														 //DGT-506 starts
														 AND ((csord__Service__r.LG_DecompositionCriteria__c != 'Set 7 - JIRA CCF Service')
														 OR (csord__Service__r.csord__Status__c ='Ready for Billing' AND csord__Service__r.LG_DecompositionCriteria__c = 'Set 7 - JIRA  CCF Service' and UM_KenanServiceLineId__c = null))
														 //DGT-506 ends
                                                          ORDER BY csord__Service__c ];

        //System.debug('*** serviceItems: '+ serviceItems);

        if(serviceItems!=null && !serviceItems.isEmpty())
            serviceId = serviceItems[0].csord__Service__c;

        for(csord__Service_Line_Item__c serviceItem : serviceItems){
           // serviceItemKenanIdMap.put(serviceItem.id,serviceItem.csordtelcoa__Line_Item_Reference_Id__c); Changed by BAU (Abhimanyu) on 2nd Aug, 2017
            if(serviceItem.csord__Service__r.csord__Service__c==null){
                if(serviceItemMap.get(serviceItem.csord__Service__c)!=null){
                    services = serviceItemMap.get(serviceItem.csord__Service__c);
                    services.add(serviceItem);
                    serviceItemMap.remove(serviceItem.csord__Service__c);
                    serviceItemMap.put(serviceItem.csord__Service__c,services);
                }else{
                    services.add(serviceItem);
                    serviceItemMap.put(serviceItem.csord__Service__c,services);
                }

                //services.add(serviceItem);
            }else{
                if(serviceItemMap.get(serviceItem.csord__Service__r.csord__Service__c)!=null){
                    services = serviceItemMap.get(serviceItem.csord__Service__r.csord__Service__c);
                    services.add(serviceItem);
                    serviceItemMap.remove(serviceItem.csord__Service__r.csord__Service__c);
                    serviceItemMap.put(serviceItem.csord__Service__r.csord__Service__c, services);
                }else{
                    services.add(serviceItem);
                    serviceItemMap.put(serviceItem.csord__Service__r.csord__Service__c,services);
                }
            }
        }
        //if(serviceItemMap.isEmpty() && !services.isEmpty())
        //if(!services.isEmpty())
          //  serviceItemMap.put(serviceId,services);
        return serviceItemMap;
    }

    public pageReference updateKenanService(){
        try{
        string doTerminate = ApexPages.currentPage().getParameters().get('terminate');
        if(doTerminate=='y'){
            terminateKenanServices();
        }
        else{
            createKenanServices();
        }
        }catch (exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        return null;
    }

    public PageReference createKenanServices(){

        String subId = ApexPages.currentPage().getParameters().get('id');

        KenanService ks = UM_KenanSubscriptionSyncCtrl.createService(subId);
        if(ks!=null){
            updateKenanIds(new list<KenanService>{ks});
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Kenan Services successfully created. Kenan Service Id: '+ ks.serviceInternalId);
            ApexPages.addMessage(myMsg);
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error occured while synchronising with billing.');
            ApexPages.addMessage(myMsg);
        }

        return null;
    }

    public PageReference terminateKenanServices(){
        String subId = ApexPages.currentPage().getParameters().get('id');

        if(UM_KenanSubscriptionSyncCtrl.terminateServices(subId,DateTime.Now(),null)){
            csord__Subscription__c sub = new csord__Subscription__c(id=subId);
            sub.Billing_Termination_Date__c = DateTime.now();
            sub.Kenan_Response__c=null;
            update sub;

            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'All services have been succesfully ceased.');
            ApexPages.addMessage(myMsg);
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Termination request failed.');
            ApexPages.addMessage(myMsg);
        }


        return null;

    }

    public static KenanService createService(String subId){

        KenanConnectorService connector = new KenanConnectorService();
        KenanService service,ksBack;
        map<id,list<String>> phoneNumbersMap = new map<id,list<String>>();
        map<id,list<csord__Service_Line_Item__c >> serviceItemsMap = new map<id,list<csord__Service_Line_Item__c >>();
        try{
            csord__Subscription__c subscription = [select id,csord__Account__c,csconta__Billing_Account__c ,LG_Address__r.cscrm__Street__c,
                                                   LG_Address__r.LG_HouseNumber__c,LG_Address__r.cscrm__State_Province__c,
                                                   LG_Address__r.cscrm__City__c,LG_Address__r.cscrm__Country__c,
                                                   LG_Address__r.cscrm__Zip_Postal_Code__c,
                                                   LG_Address__r.LG_HouseNumberExtension__c
                                                   FROM csord__Subscription__c
                                                   WHERE id=:subId limit 1];

            list<csord__Service__c> servicesList = UM_KenanSubscriptionSyncCtrl.getServices(subscription.id);
            serviceItemsMap = UM_KenanSubscriptionSyncCtrl.getServiceItems(new set<id>{subscription.id});
            phoneNumbersMap = getListOfPortingNumbers(new set<id>{subscription.id});

            for(csord__Service__c s : servicesList){

                service = createKenanService(s,subscription,serviceItemsMap,phoneNumbersMap);
            }

            //System.debug('*** service: '+ service);
            System.debug('service json--->'+ json.serialize(service));
            ksBack = connector.serviceCreate(service);
            ksBack.salesforceObjectId = service.salesforceObjectId;
            //System.debug('*** ksBack.serviceItems: '+ksBack.serviceItems);

            /*for(KenanServiceItem ki : ksBack.serviceItems){
                System.debug('*** kenanServiceItemId = '+ serviceItemKenanIdMap.get(ki.salesforceId));
                serviceItemsToUpdate.add(new csord__Service_Line_Item__c(id=ki.salesforceId,UM_KenanServiceLineId__c=ki.instanceId,csordtelcoa__Line_Item_Reference_Id__c=serviceItemKenanIdMap.get(ki.salesforceId)));
            }*/

            //System.debug('*** ksBack: '+ksBack);

            //updateKenanIds(ksBack);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Kenan Services successfully created. Kenan Service Id: '+ ksBack.serviceInternalId);
            //ApexPages.addMessage(myMsg);
        }catch (Kenanexception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.errorMessage);
            //ApexPages.addMessage(myMsg);
            updateKenanResponse(subId,e.message);
            return null;
        }
        catch (exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            //ApexPages.addMessage(myMsg);
            //System.debug('*** exception: '+e + ' ' + e.getStackTraceString());
            updateKenanResponse(subId,e.getMessage());
            return null;
        }
        return ksBack;
    }

    public Static boolean terminateServices(String subId,DateTime discoDate,String discoReason){
        KenanService ks;
        boolean bSuccess=false;
        try{
            list<csord__Service__c> servicesList = UM_KenanSubscriptionSyncCtrl.getServices(subId);
            if(discoDate==null)
                discoDate = Date.today();

            for(csord__Service__c s : servicesList){
                KenanConnectorService service = new KenanConnectorService();
                ks = UM_KenanSubscriptionSyncCtrl.createCeaseKenanService(s.id,discoDate,discoReason);
                //System.debug('*** ks: '+ks);
                if(service.serviceCease(ks)){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'All services have been succesfully ceased.');
                    //System.debug('*** Cease Success: '+ks);
                    bSuccess=true;
                    //ApexPages.addMessage(myMsg);
                }
                else{
                    bSuccess=false;
                    break;
                }
            }
            return bSuccess;
        }catch (Kenanexception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.message);
            //ApexPages.addMessage(myMsg);
            System.debug('*** exception: '+ e + ' ' + e.getStackTraceString());
            updateKenanResponse(subId,e.message);
            return false;

        }
        catch (exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            //ApexPages.addMessage(myMsg);
            System.debug('*** exception: '+ e + ' ' + e.getStackTraceString());
            updateKenanResponse(subId,e.getMessage());
            return false;
        }
    }

    public static KenanService createCeaseKenanService(Id serviceId,DateTime discoDate,String discoReason){
        KenanService ks = new KenanService();
        DateTime timeStamp = discoDate;//reverting back changes for CATGOV-449

        ks.salesforceOrgId = UserInfo.getOrganizationId();
        ks.salesforceObjectId = serviceId;
        if(String.isBlank(discoReason))
            ks.disconnectReason = 'Customer request';
        else
            ks.disconnectReason = discoReason;
        ks.disconnectDate = discoDate; //timeStamp;
        return ks;
    }

    public static void updateKenanResponse(String subId,String errorMessage){
        if(!String.isBlank(subId)){
            csord__Subscription__c sub = [select id,Kenan_Response__c from csord__Subscription__c where id=:subId];
            sub.Kenan_Response__c = errorMessage;
            update sub;
        }
    }

    public static void updateKenanIds(list<KenanService> ksList){
        map<id,csord__Service__c> serviceIdServiceMap = new map<id,csord__Service__c>();
        list<csord__Subscription__c> subscriptionsToUpdateList = new list<csord__Subscription__c>();
        set<Id> serviceIdSet = new set<Id>();
        map<id,string> serviceIdKenanIdMap = new map<id,string>();
        map<Id,string> subscriptionIdKenanIdMap = new map<Id,string>();

        for(KenanService ks : ksList ){
            serviceIdSet.add(ks.salesforceObjectId);
            serviceIdKenanIdMap.put(ks.salesforceObjectId,String.valueOf(ks.serviceInternalId));
        }

        for(csord__Service__c service : [SELECT Id,csord__Subscription__c,LG_ServiceExternalId__c,LG_ServiceStatus__c,csord__Status__c, LG_ProductFamily__c
                                         FROM csord__Service__c
                                         WHERE Id IN: serviceIdSet])
        {
            service.LG_ServiceStatus__c = 'Active';
            service.csord__Status__c = 'Active';
            service.LG_ServiceExternalId__c = serviceIdKenanIdMap.get(service.Id);
            serviceIdServiceMap.put(service.Id,service);
            subscriptionIdKenanIdMap.put(service.csord__Subscription__c,serviceIdKenanIdMap.get(service.Id));
        }

        if(!serviceIdServiceMap.isEmpty())
            UPDATE serviceIdServiceMap.values();

        for(csord__Subscription__c sub : [SELECT Id, Kenan_Response__c, Billing_Termination_Date__c, LG_SubscriptionExternalId__c
                                          FROM csord__Subscription__c
                                          WHERE Id IN:subscriptionIdKenanIdMap.keySet()])
        {
            sub.Kenan_Response__c = null;
            sub.LG_SubscriptionExternalId__c = subscriptionIdKenanIdMap.get(sub.id);
            subscriptionsToUpdateList.add(sub);
        }
        if(!subscriptionsToUpdateList.isEmpty())
            UPDATE subscriptionsToUpdateList;
    }

    /*private static map<id,list<string>> getListOfPortingNumbers(set<id> subIds){
        map<id,list<string>> portingNumbers = new map<id,list<string>>();
        list<string> numbers = new list<string>();

        list<UM_NumberBlock__c> listOfNumberBlocks = [select id,UM_CDRIDNumber__c,UM_NumberRangeService__r.csord__Subscription__c from UM_NumberBlock__c
                                                      where
                                                        UM_NumberRangeService__r.csord__Subscription__c in :subIds and
                                                        UM_NumberRangeService__r.LG_TypeOfPhoneRange__c ='New' and
                                                        UM_NumberRangeService__r.LG_ProductFamily__c = 'Number Range'
                                                     ];

        for(UM_NumberBlock__c nb : listOfNumberBlocks){
            if(nb.UM_CDRIDNumber__c!=null){
                if(portingNumbers.get(nb.UM_NumberRangeService__r.csord__Subscription__c)!=null){
                    numbers = portingNumbers.get(nb.UM_NumberRangeService__r.csord__Subscription__c);
                    numbers.add(nb.UM_CDRIDNumber__c);
                    portingNumbers.remove(nb.UM_NumberRangeService__r.csord__Subscription__c);
                    portingNumbers.put(nb.UM_NumberRangeService__r.csord__Subscription__c,numbers);
                }else{
                    numbers.add(nb.UM_CDRIDNumber__c);
                    portingNumbers.put(nb.UM_NumberRangeService__r.csord__Subscription__c,numbers);
                }
            }
        }
        return portingNumbers;
    }*/
    //Updated method to look for Asset records with Number Block record type.
    //Fix for OMB-994
    
    private static map<id,list<string>> getListOfPortingNumbers(set<id> subIds){
        map<id,list<string>> phoneNumbers = new map<id,list<string>>();
        list<string> numbers = new list<string>();

        list<Asset> listOfNumberBlocks = [select id,UM_CDRIDNumber__c,LG_NumberRangeService__r.csord__Subscription__c from Asset
                                                      where
                                                        LG_NumberRangeService__r.csord__Subscription__c in :subIds and
                                                        LG_NumberRangeService__r.LG_TypeOfPhoneRange__c ='New' and
                                                        LG_NumberRangeService__r.LG_ProductFamily__c = 'Number Range' and
                                                        RecordType.name='Number Block'
                                                     ];

        for(Asset nb : listOfNumberBlocks){
            if(nb.UM_CDRIDNumber__c!=null){
                if(phoneNumbers.get(nb.LG_NumberRangeService__r.csord__Subscription__c)!=null){
                    numbers = phoneNumbers.get(nb.LG_NumberRangeService__r.csord__Subscription__c);
                    numbers.add(nb.UM_CDRIDNumber__c);
                    phoneNumbers.remove(nb.LG_NumberRangeService__r.csord__Subscription__c);
                    phoneNumbers.put(nb.LG_NumberRangeService__r.csord__Subscription__c,numbers);
                }else{
                    numbers.add(nb.UM_CDRIDNumber__c);
                    phoneNumbers.put(nb.LG_NumberRangeService__r.csord__Subscription__c,numbers);
                }
            }
        }
        return phoneNumbers;

    }

    /*
*

*/

    public static KenanServiceExternalId createExternalId(string serviceId, string phoneNumber, DateTime activeDate) {
        KenanServiceExternalId ksei = new KenanServiceExternalId();
        KenanConnectorService service = new KenanConnectorService();

        Datetime today = Datetime.now();
        ksei.activeDate = activeDate; //DateTime.valueOf('2016-07-19 17:36:23');
        ksei.serviceExternalId = phoneNumber;//'0123123339';
        ksei.serviceExternalIdType = 20;
        ksei.salesforceObjectId = serviceId;//'a164E0000000cCkQAI';//'a164E0000000eFaQAI';
        KenanServiceExternalId kseiBack = service.serviceIdCreate(ksei);
        //System.debug('*** kseiBack: '+kseiBack);
        return kseiBack;
    }

    public static KenanServiceExternalId swapExternalId(String serviceId, String oldPhoneNumber, String newPhoneNumber, DateTime inactiveDate) {
        KenanServiceExternalId ksei = new KenanServiceExternalId();
        KenanConnectorService service = new KenanConnectorService();

        Datetime today = Datetime.now();
        //ksei.activeDate = today+1;
        ksei.inactiveDate = inactiveDate; //today.date()+1;
        ksei.serviceExternalId = newPhoneNumber; //'0123123698';
        ksei.serviceExternalIdType = 20;
        ksei.oldServiceExternalId = oldPhoneNumber; //'0123123699'; // old External Id
        ksei.oldServiceExternalIdType = 20; // old External Id Type
        ksei.salesforceObjectId = serviceId; //'a164E0000000eFGQAY';
        KenanServiceExternalId kseiBack = service.serviceIdSwap(ksei);
        //System.debug('*** kseiBack: '+kseiBack);
        return kseiBack;
    }

    public static boolean ceaseExternalId(String serviceId, String phoneNumber, DateTime inactiveDate) {
        KenanServiceExternalId ksei = new KenanServiceExternalId();
        KenanConnectorService service = new KenanConnectorService();

        Datetime today = Datetime.now();
        ksei.inactiveDate =  inactiveDate.date(); //today.date();
        ksei.serviceExternalId = phoneNumber; //'0123123339';
        ksei.serviceExternalIdType = 20;
        ksei.salesforceObjectId = serviceId; //'a164E0000000cCkQAI';

        Boolean kseiBack = service.serviceIdCease(ksei);
        //System.debug('*** kseiBack: '+kseiBack);
        return kseiBack;
    }

    public static boolean createOrder(string orderId){
        KenanConnectorService connector = new KenanConnectorService();

        list<KenanService> serviceList = new list<kenanService>();
        map<id,csord__Subscription__c> subscriptions = new map<id,csord__Subscription__c>();
        map<id,list<string>> phoneNumbersMap = new map<id,list<string>>();
        for(csord__Subscription__c  sub : [select id,csconta__Billing_Account__c from csord__Subscription__c where csord__Order__c =:orderId]){
            subscriptions.put(sub.id,sub);
        }

        map<id,list<csord__Service_Line_Item__c >> serviceItems = getServiceItems(subscriptions.keySet());
        phoneNumbersMap = getListOfPortingNumbers(subscriptions.keySet());
        for(csord__Service__c s : [SELECT id,UM_ProductDescription__c , csord__Status__c,csord__Subscription__c, LG_ProductFamily__c, LG_ProductName__c, LG_Quantity__c,
                                   LG_CurrencyCode__c ,csord__Activation_Date__c,LG_Address__r.cscrm__Street__c,
                                   LG_Address__r.LG_HouseNumber__c,LG_Address__r.cscrm__Country__c,LG_Address__r.LG_AddressID__c,
                                   LG_Address__r.cscrm__Zip_Postal_Code__c,LG_Address__r.cscrm__State_Province__c,
                                   csordtelcoa__Service_Number__c,LG_Address__r.cscrm__City__c,LG_ContractTerm__c,
                                   csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c,
                                   LG_Address__r.LG_HouseNumberExtension__c,UM_CustomersInvoiceGroupingReference__c,
                                   LG_ContractStartDate__c,LG_ContractEndDate__c,UM_PartnerAccount__c,UM_PartnerSalesId__c,
                                   UM_PartnerAccount__r.UM_P_Sales_ID_NRW_HSN__c,UM_PartnerAccount__r.UM_P_Sales_ID_BW__c,UM_SubscriberName__c,
                                   UM_HPBXExternalId__c, UM_SubscriberID__c, UM_PhoneExtension__c,
                                   UM_Cancellation_Period__c, UM_Latest_Cancellation_Letter_Arrival__c,UM_SendVoiceworksExternalID__c,LG_Charge_Group_Name__c  // changes for DGT-322
                                   FROM csord__Service__c
                                   WHERE csord__Subscription__c in :subscriptions.keySet() and csord__Service__c = null]){

                                       serviceList.add(createKenanService(s,subscriptions.get(s.csord__Subscription__c),serviceItems,phoneNumbersMap));

                                   }
        List<KenanService> newServices = connector.orderCreate(serviceList);
        //system.debug('*** newServices: '+newServices);
        return true;
    }

    private static KenanService createKenanService(csord__service__c s, csord__Subscription__c subscription,map<id,
                                                   list<csord__Service_Line_Item__c >> serviceItemsMap,map<id,list<string>> phoneNumbersMap)
    {
        KenanService service = new KenanService();
        List<KenanServiceItem> items = new List<KenanServiceItem>();
        map<string,csord__Service_Line_Item__c> rcNrcUnitTypeMap =  new map<string,csord__Service_Line_Item__c> ();

        DateTime timeStamp = DateTime.now();
        service.sfdcAccountId = subscription.csconta__Billing_Account__c ;
        if(s.csord__Activation_Date__c!=null){
            service.activeDt = s.csord__Activation_Date__c;
            service.serviceActiveDt = s.csord__Activation_Date__c;
        }
        else{
            service.activeDt = timeStamp;
            service.serviceActiveDt = timeStamp;
        }
        //Address Fields
        service.addressTypeId = 'Not Free-form';
        service.addressLocation = 1;        //1 = master address // 2 = local address
        service.address1 = s.LG_Address__r.cscrm__Street__c ;
        service.streetName = s.LG_Address__r.cscrm__Street__c ;
        service.externalAddressId  = s.LG_Address__r.LG_AddressID__c;
        service.houseNumber = s.LG_Address__r.LG_HouseNumber__c ;
        service.houseNumberSuffix = s.LG_Address__r.LG_HouseNumberExtension__c;
        service.city = s.LG_Address__r.cscrm__City__c;
        service.countryCode = s.LG_Address__r.cscrm__Country__c ;
        service.postalCode = s.LG_Address__r.cscrm__Zip_Postal_Code__c ;
        service.state = s.LG_Address__r.cscrm__State_Province__c;

        // UMR-1854. emfConfig Id = 2 for HPBX related Services - Omkar
        if(s.LG_ProductFamily__c != NULL && s.LG_ProductFamily__c.equalsIgnoreCase('Virtual Voice'))
            service.emfConfigId = 2;
        else if(s.LG_ProductFamily__c != NULL && s.LG_ProductFamily__c.equalsIgnoreCase('Virtual Phone'))
            service.emfConfigId = 3;
        else
            service.emfConfigId = 1;

        service.privacyLevel = 'No mask';
        service.revRcvCostCtr = 1;
        service.salesforceObjectId = s.id; //s.csordtelcoa__Service_Number__c;
        service.currencyCode = UserInfo.getDefaultCurrency() ;
        service.extIdList = new List<Map<String, String>>();
        Map<String, String> extMap = new Map<String, String>();
        extMap.put('value', s.id);
        extMap.put('type', '2');               // TODO may be change it to type 10 once confirmed by Kenan
        service.extIdList.add(extMap);

        // SFOM-970 / UMR-1854 - Changes by Omkar
        if(s.UM_SubscriberID__c != null){
            Map<String, String> extMap1 = new Map<String, String>();
            extMap1.put('value', string.valueof(s.UM_SubscriberID__c));
            extMap1.put('type', '30');
            service.extIdList.add(extMap1);
        }
        else if(s.UM_SendVoiceworksExternalID__c != null && s.UM_SendVoiceworksExternalID__c.equalsIgnoreCase('Yes'))  // SFOM-1317 / UMR-1854 - Changes by Omkar
        {
            Map<String, String> extMap1 = new Map<String, String>();
            extMap1.put('value', string.valueof(s.UM_HPBXExternalId__c));
            extMap1.put('type', '40');
            service.extIdList.add(extMap1);
        }

        //Add Phone Numbers
        //System.debug('*** phoneNumbersMap: '+ phoneNumbersMap);
        if(phoneNumbersMap!=null && !phoneNumbersMap.isEmpty()){
            list<string> phoneNumbers = phoneNumbersMap.get(subscription.id);
            //System.debug('*** phoneNumbers: '+phoneNumbers);
            for(String phoneNumber : phoneNumbers){
                Map<String, String> extIdMap = new Map<String, String>();
                extIdMap.put('value',phoneNumber);
                extIdMap.put('type','20');
                service.extIdList.add(extIdMap);
            }
        }

        //Add optional grouping data
       /* extMap.put('value',
            UM_KenanSubscriptionSyncCtrl.concGroupingReference(s.UM_CustomersInvoiceGroupingReference__c, service.externalAddressId));
        extMap.put('type','13');
        */


        //System.debug('*** serviceItemsMap: '+serviceItemsMap + ' and serviceId: '+s.id);
        //Create Service Items
        if (serviceItemsMap.get(s.id)!=null) {

            for(csord__Service_Line_Item__c si : serviceItemsMap.get(s.id)){
                if(!si.csord__Is_Recurring__c){
                    if(si.UM_UnitType__c!=null)
                        rcNrcUnitTypeMap.put(si.UM_UnitType__c,si);
                }

            }

            for(csord__Service_Line_Item__c serviceItem : serviceItemsMap.get(s.id)){
                //If Service Item is of Non-Recurring type then do not add to the list
                if((!serviceItem.csord__Is_Recurring__c) && (serviceItem.UM_UnitType__c!=null))
                    continue;

                KenanServiceItem item = new KenanServiceItem();
                item = createKenanServiceItem(serviceItem);
                if(serviceItem.UM_UnitType__c!=null){
                    csord__Service_Line_Item__c nrcLineItem = rcNrcUnitTypeMap.get(serviceItem.UM_UnitType__c);
                    if(nrcLineItem!=null){
                        item.rcAssociatedNrc = createKenanServiceItem(nrcLineItem);
                        
                        //Fix for OMB-1797 (Passing Line Item Description for NRC)
                        item.rcAssociatedNrc.extData = new Map<String, Object>();
                        string nrcItemDescription = nrcLineItem.csord__Line_Description__c;
                        if(!String.isBlank(nrcItemDescription)){
                            integer size = nrcItemDescription.length();
                        
                            if(size>50)
                                nrcItemDescription = nrcItemDescription.subString(0,50);
                            
                            item.rcAssociatedNrc.extData.put('15',nrcItemDescription);

                        }
                        //End of Fix for OMB-1797
                    }
                }
                item.extData = new Map<String, Object>();
                string itemDescription = serviceItem.csord__Line_Description__c;
                if(!String.isBlank(itemDescription)){
                  integer size = itemDescription.length();

                  if(size>50)
                    itemDescription = itemDescription.subString(0,50);
                }
                if(item.itemType==0){
                    //RC    charge_description  PRODUCT_EXT_DATA param_id=16
                    item.extData.put('16', itemDescription);
                    if(serviceItem.UM_ContractId__c!=null){
                        KenanServiceItem contractItem =  createKenanServiceItem(serviceItem);
                                                                                                contractItem.extData = new Map<String, Object>();
                        contractItem.itemType = 2;
                        contractItem.extData.put('17',itemDescription);

                        contractItem.itemId =  Integer.valueOf(serviceItem.UM_ContractId__c);
                        if(!String.isBlank(serviceItem.UM_NumberOfUnits__c))
                           contractItem.unitCreditUnitsFree = Decimal.valueOf(serviceItem.UM_NumberOfUnits__c);
                        items.add(contractItem);
                    }
                }else if(item.itemType==1){
                    //NRC   charge_description  NRC_EXT_DATA param_id=15
                    item.extData.put('15',itemDescription);
                }else if(item.itemType==2){
                    //Contract  charge_description  CUSTOMER_CONTRACT_EXT_DATA param_id=17
                    item.extData.put('17',itemDescription);
                }
                items.add(item);

            }
        }
        service.extData = new Map<String, Object>();
        //Add optional grouping data
        service.extData.put('13', UM_KenanSubscriptionSyncCtrl.concGroupingReference(s.UM_CustomersInvoiceGroupingReference__c, service.externalAddressId));
        // end of grouping data
        Time myTime = Time.newInstance(0, 0, 0, 0);
        DateTime contractStart,contractEnd;

        if(s.LG_ContractStartDate__c!=null)
          contractStart = DateTime.newInstance(s.LG_ContractStartDate__c,myTime);

        if(s.LG_ContractEndDate__c!=null)
          contractEnd = DateTime.newInstance(s.LG_ContractEndDate__c,myTime);

        service.extData.put('4', '73');
        service.extData.put('5', String.valueOf(DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS')));
        if(s.LG_ContractStartDate__c!=null)
          service.extData.put('7', String.valueOf(contractStart.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS')));
        else
          service.extData.put('7', String.valueOf(DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS')));

if(s.LG_ProductFamily__c != 'Virtual Voice' || 
            (s.LG_ProductFamily__c == 'Virtual Voice' && s.LG_ContractTerm__c != null && s.LG_ContractTerm__c > 0))
        {
        if(s.LG_ContractEndDate__c!=null)
          service.extData.put('8', String.valueOf(contractEnd.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS')));
        else
          service.extData.put('8', String.valueOf(DateTime.now().addYears(2).format('yyyy-MM-dd\'T\'HH:mm:ss.SSS')));
        

        // Changes made for BU-31
        if(s.UM_Cancellation_Period__c != null)
            service.extData.put('23',String.valueOf(s.UM_Cancellation_Period__c));
        if(s.UM_Latest_Cancellation_Letter_Arrival__c != null){
            DateTime letterArrivalDate = DateTime.newInstance(s.UM_Latest_Cancellation_Letter_Arrival__c,myTime);
            service.extData.put('24', String.valueOf(letterArrivalDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS')));
        }
        else if(s.LG_ContractEndDate__c!=null){
            DateTime letterArrivalDate = DateTime.newInstance(s.LG_ContractEndDate__c.addMonths(integer.valueof(-s.UM_Cancellation_Period__c)),myTime);
            service.extData.put('24', String.valueOf(letterArrivalDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS')));
        }
        else{
            DateTime letterArrivalDate = DateTime.now().addYears(2).addMonths(integer.valueof(-s.UM_Cancellation_Period__c));
            service.extData.put('24', String.valueOf(letterArrivalDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS')));
        }
}
        // SFOM-970 / UMR-1854 - Changes by Omkar
        if(s.UM_SubscriberName__c != null )
            service.extData.put('25',string.valueof(s.UM_SubscriberName__c));

        if(s.UM_PhoneExtension__c != null )
            service.extData.put('26',string.valueof(s.UM_PhoneExtension__c));
            
        //Changes for BU-191 -- Start
        if(s.UM_CustomersInvoiceGroupingReference__c != null)
            service.extData.put('28',string.valueof(s.UM_CustomersInvoiceGroupingReference__c));
            
        // changes for DGT-322
        if(s.LG_Charge_Group_Name__c != null)
            service.extData.put('29',string.valueof(s.LG_Charge_Group_Name__c));
        //UM_PartnerAccount__r.UM_P_Sales_ID_BW__c
        //system.debug('service.extData--->'+service.extData);
        if(s.UM_PartnerSalesId__c!=null)
          service.extData.put('21', s.UM_PartnerSalesId__c);
          
        service.extData.put('10', '1');

        service.serviceItems = items;

        return service;
    }

    public static KenanServiceItem createKenanServiceItem (csord__Service_Line_Item__c serviceItem){
        KenanServiceItem item = new KenanServiceItem();
        //item.serviceExternalId = serviceItem.csord__Service__r.csordtelcoa__Service_Number__c;
        item.serviceExternalId = serviceItem.csord__Service__c;
        //if(serviceItem.UM_ServiceItemType__c!=null)
            item.serviceExternalIdType = 2;// Integer.valueOf(serviceItem.UM_ServiceItemType__c);

        item.salesforceId = serviceItem.id;


        if(serviceItem.UM_ServiceItemType__c!=null)
            item.itemType = Integer.valueOf(serviceItem.UM_ServiceItemType__c);

        if(serviceItem.UM_BillingProductId__c!=null && item.itemType!=2)
            item.itemId = Integer.valueOf(serviceItem.UM_BillingProductId__c) ;
        else if (item.ItemType==2 && serviceItem.UM_ContractId__c!=null)
            item.itemId = Integer.valueOf(serviceItem.UM_ContractId__c);

        if(serviceItem.UM_Price_Override__c!='No')
            item.rate = serviceItem.csord__Total_Price__c*100;
        if(serviceItem.UM_NumberOfUnits__c!=null)
            item.units = Integer.valueOf(serviceItem.UM_NumberOfUnits__c);

        item.unitsType = serviceItem.UM_UnitType__c;
        item.currencyCode = UserInfo.getDefaultCurrency() ;
        if(item.itemType ==2 && serviceItem.UM_RecurringPriceDiscount__c !=null && decimal.valueOf(serviceItem.UM_RecurringPriceDiscount__c)>0){
            item.discountPercent = decimal.valueOf(serviceItem.UM_RecurringPriceDiscount__c) ;
        }
        else if (item.itemType == 2 && serviceItem.UM_OneOffPriceDiscount__c !=null && decimal.valueOf(serviceItem.UM_OneOffPriceDiscount__c)>0){
            item.discountPercent = decimal.valueOf(serviceItem.UM_OneOffPriceDiscount__c) ;
        }

        if(item.discountPercent!=null && item.discountPercent>0)
            item.inactiveDate = serviceItem.UM_DiscountEndDate__c;

        return item;
    }

    private static String concGroupingReference(String iGroupingRef, String extId) {

        String result = '';
        Integer pad = 15;

        if(iGroupingRef!=null) {

            if(iGroupingRef.length() > pad) iGroupingRef = iGroupingRef.substring(0, pad);
            result = iGroupingRef.rightPad(pad);
        } else {

            result = result.rightPad(pad);
        }

        return result + extId;
    }

    //Fix for OMB-2077 - Added new parameter ActivationDate
    public static KenanService updateContract(String serviceId, DateTime contractDueDate, Date cancellationLetterArrivalDate,Date activationDate){
            KenanConnectorService connector = new KenanConnectorService();
            KenanService service = new KenanService();
            service.salesforceObjectId = serviceId;
            
            //Fix for OMB-2077 - Added new parameter ActivationDate
            if(activationDate!=null)
                service.activeDt = activationDate;//DateTime.newInstance(activationDate,Time.newInstance(0, 0, 0, 0));
            //End of fix OMB-2077
            
            service.extData = new Map<String, Object>();
            //System.debug('*** serviceId= '+serviceId+ ' contractDueDate'+contractDueDate+ ' cancellationLetterArrivalDate='+cancellationLetterArrivalDate);
            service.extData.put('8', String.valueOf(contractDueDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS')));
            if(cancellationLetterArrivalDate!=null){
                Time myTime = Time.newInstance(0, 0, 0, 0);
                DateTime letterArrivalDate = DateTime.newInstance(cancellationLetterArrivalDate,myTime);
                service.extData.put('24', String.valueOf(letterArrivalDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS')));
            }
            KenanService ksBack = connector.serviceModify(service);
            //System.debug('**** updateContract Service Modify:'+ksBack);
            return ksBack;
    }

    public static KenanService updateDeactivationReason(String serviceId, String deactivationReason){
            KenanConnectorService connector = new KenanConnectorService();
            KenanService service = new KenanService();
            service.salesforceObjectId = serviceId;
            service.extData = new Map<String, Object>();
            service.extData.put('9', deactivationReason);

            KenanService ksBack = connector.serviceModify(service);
            return ksBack;
    }
    public static void modifyKenanService(Id oldServiceId, Id newSubId, Id newServiceId){
        KenanConnectorService kenanConService = new KenanConnectorService();
        KenanService kService;
        map<id,list<String>> phoneNumbersMap = new map<id,list<String>>();
        map<id,list<csord__Service_Line_Item__c >> serviceItemsMap = new map<id,list<csord__Service_Line_Item__c >>();
        try{
            csord__Subscription__c subscription = [select id,csord__Account__c,csconta__Billing_Account__c ,LG_Address__r.cscrm__Street__c,
                                                   LG_Address__r.LG_HouseNumber__c,LG_Address__r.cscrm__State_Province__c,
                                                   LG_Address__r.cscrm__City__c,LG_Address__r.cscrm__Country__c,
                                                   LG_Address__r.cscrm__Zip_Postal_Code__c,
                                                   LG_Address__r.LG_HouseNumberExtension__c
                                                   FROM csord__Subscription__c
                                                   WHERE id=: newSubId limit 1];

            list<csord__Service__c> servicesList = UM_KenanSubscriptionSyncCtrl.getServices(subscription.id);
            //serviceItemsMap = UM_KenanSubscriptionSyncCtrl.getServiceItems(new set<id>{subscription.id});
            phoneNumbersMap = getListOfPortingNumbers(new set<id>{subscription.id});

            for(csord__Service__c s : servicesList){
                if(s.Id == newServiceId)
                    kService = createKenanService(s, subscription, serviceItemsMap, phoneNumbersMap);
            }
            
            System.debug('kService json--->'+ json.serialize(kService));
            // update only the extended params
            KenanService kServiceToUpdate = new KenanService();
            kServiceToUpdate.extData = new Map<String, Object>();
            kServiceToUpdate.extData = kService.extData;
            kServiceToUpdate.salesforceObjectId = oldServiceId;
            
            System.debug('kServiceToUpdate json--->'+ json.serialize(kServiceToUpdate));
            
            KenanService kenanServiceBack = null;
            
            if(!Test.isRunningTest())
                kenanServiceBack = kenanConService.serviceModify(kServiceToUpdate);
        }
        catch(Exception e)
        {
            System.debug('*** exception: '+e + ' ' + e.getStackTraceString());
        }
    }
}
