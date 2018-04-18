public class UM_ServiceCreator implements UM_KenanSyncBatch.IServiceConnect{

    public void execute(list<sObject> servicesList){
        list<csord__Service__c> services = (list<csord__Service__c>) servicesList;
        list<csord__Service__c> terminatedServices = new list<csord__Service__c>();
        list<sObject> accountsToUpdate = new list<sObject>();
        list<UM_BillingAccountItem__c> accountItemsToUpdate = new list<UM_BillingAccountItem__c>();
        list<KenanService> ksList = new list<KenanService>();
        list<task> taskList = new list<task>();
        map<id,sObject> idObjectMap = new map<id,sObject>();
        list<csord__Subscription__c> terminatedSubsList = new list<csord__Subscription__c>();
        map<id,csord__Service__c> idServiceMap = new map<id,csord__Service__c>();
        list<csord__Service__c> successServices = new list<csord__Service__c> ();
        set<id> subIds = new set<id>();
        set<id> replacedSubIds = new set<id>();
        map<string,csord__Service_Line_Item__c> idLineItemMap = new map<string,csord__Service_Line_Item__c>();
        map<id,csord__Service_Line_Item__c> serviceItemsToUpdate = new map<id,csord__Service_Line_Item__c>();

        list<csord__Service_Line_Item__c> terminatedLineItems = new list<csord__Service_Line_Item__c>();
        list<csord__Service_Line_Item__c> createdLineItems = new list<csord__Service_Line_Item__c>();
        KenanConnectorService kenanService = new KenanConnectorService();

        csordtelcoa__Orders_Subscriptions_Options__c osp = csordtelcoa__Orders_Subscriptions_Options__c.getOrgDefaults();
        String inactiveStatus = osp.LG_ServiceDeactivatedStatus__c;
        if(inactiveStatus==null)
            inactiveStatus = 'Inactive';

        for(csord__Service__c s : services){
            subIds.add(s.csord__Subscription__c);
            if(s.csord__Subscription__r.csordtelcoa__Replaced_Subscription__c!=null)
                replacedSubIds.add(s.csord__Subscription__r.csordtelcoa__Replaced_Subscription__c);

        }

        map<id,list<csord__Service_Line_Item__c >> serviceItemsMap = UM_KenanSubscriptionSyncCtrl.getServiceItems(subIds);
        map<id,list<csord__Service_Line_Item__c >> replacedServiceItemsMap = UM_KenanSubscriptionSyncCtrl.getServiceItems(replacedSubIds);



        //System.debug('*** serviceItemsMap: '+serviceItemsMap);
        //System.debug('*** serviceItemsMap: '+replacedServiceItemsMap);

        for(csord__Service__c s : services){
            idServiceMap.put(s.id,s);
            UM_KenanAccountSyncCtrl kenanController = new UM_KenanAccountSyncCtrl(s.csord__Subscription__r.csconta__Billing_Account__c ,true);
            list<sObject> accounts = kenanController.syncKenanAccount();
            if(accounts!=null){
                for(sObject obj : accounts){
                    idObjectMap.put(obj.id,obj);
                }
            }


            if(!idObjectMap.isEmpty()){
                accountsToUpdate.addAll(idObjectMap.values());
                accountItemsToUpdate.addAll(kenanController.accountItemList);
            }

            //If MCAD then terminate the replaced service first before synchronisation the changed/news service with Kenan.
            if(s.csordtelcoa__Replaced_Service__c!=null){

                if(s.csord__Subscription__r.csordtelcoa__Change_Type__c=='Change' && !replacedServiceItemsMap.isEmpty()){
                    //Create place holder for Kenan Id Population
                    KenanService ksBack = new KenanService();
                    ksBack.salesforceObjectId=s.id;
                    if(s.csordtelcoa__Replaced_Service__r.LG_ServiceExternalId__c!=null)
                        ksBack.serviceInternalId=Integer.valueOf(s.csordtelcoa__Replaced_Service__r.LG_ServiceExternalId__c);

                    csord__Service__c terminatedService = new csord__Service__c(id=s.csordtelcoa__Replaced_Service__c);
                    csord__Subscription__c sub = new csord__Subscription__c(id=s.csordtelcoa__Replaced_Service__r.csord__Subscription__c);
                    sub.Billing_Termination_Date__c = DateTime.now();
                    sub.Kenan_Response__c=null;
                    terminatedService.csord__Deactivation_Date__c = s.csord__Activation_Date__c;
                    terminatedSubsList.add(sub);
                    terminatedServices.add(terminatedService);

                    //s.LG_ServiceExternalId__c = s.csordtelcoa__Replaced_Service__r.LG_ServiceExternalId__c;

                    //Get Original Service Line Items and map it by Line Item Reference
                    for(csord__Service_Line_Item__c si : replacedServiceItemsMap.get(s.csordtelcoa__Replaced_Service__c)){
                        //System.debug('*** replacedItem='+si);
                        //modified for OMB-2615
                        // OMB-2900 fix
                        if(si.csord__Service__r.csord__Service__c != null && si.csord__Service__r.csord__Service__r.Name.contains('Company Fiber')) {
                            idLineItemMap.put(si.csordtelcoa__Line_Item_Reference_Id__c+si.UM_BillingProductId__c,si);
                        } else {
                            idLineItemMap.put(si.csordtelcoa__Line_Item_Reference_Id__c,si);
                        }
                        // condition modified to fix OMB-1896
                        if(si.csordtelcoa__Delta_Status__c == 'Deleted' && si.UM_ServiceItemType__c!='1'){
                            //System.debug('*** csordtelcoa__Delta_Status__c= Deleted');
                            KenanServiceItem ksi = UM_KenanSubscriptionSyncCtrl.createKenanServiceItem(si);
                            string kenanItemId = si.UM_KenanServiceLineId__c;
                            
                            //FIX FOR OMB-1898 - Start - Check if There are any additional/associated MRC Line Items
                            if(kenanItemId.contains(';')){
                                list<string> kenanIdList = kenanItemId.split(';');
                                if(kenanIdList!=null){
                                    ksi.instanceId = kenanIdList[0];    
                                    KenanServiceItem ksiMRC = UM_KenanSubscriptionSyncCtrl.createKenanServiceItem(si);
                                    ksiMRC.instanceId = kenanIdList[1]; 
                                    ksiMRC.inactiveDate = getDateTimeFormat(s.csord__Activation_Date__c);
                                    ksiMRC.serviceExternalId = s.csordtelcoa__Replaced_Service__c;
                                    kenanService.serviceItemCease(ksiMRC);
                                }
                            }
                            else
                                ksi.instanceId = si.UM_KenanServiceLineId__c;
                            //FIX FOR OMB-1898 - End
                            //Fix for CATGOV-499 - Assign Inactive Date in User's Local Time Zone to avoid adding one hour to the midnight.
                            ksi.inactiveDate = getDateTimeFormat(s.csord__Activation_Date__c);
                            //If contract id is not null then set the item type as 2 i.e. Contract Type
                            if(ksi.itemType==0 && si.UM_ContractId__c!=null) {
                                ksi.itemType = 2;
                            }
                            ksi.serviceExternalId = s.csordtelcoa__Replaced_Service__c;
                            //System.debug('*** replacedKSI='+ksi);
                            if(kenanService.serviceItemCease(ksi))
                                terminatedLineItems.add(si);
                        }
                    }


                    csord__Service_Line_Item__c replacedLineItem;
                    //Get list of new Line Items
                    list<csord__Service_Line_Item__c > serviceItems = serviceItemsMap.get(s.id);
                    //System.debug('*** serviceItems= '+serviceItems);

                    if(serviceItems!=null){

                        for( csord__Service_Line_Item__c si : serviceItems){
                            //System.debug('*** si= '+si);
                            //OMB-2900 fix
                         	if(si.csord__Service__r.csord__Service__c != null && si.csord__Service__r.csord__Service__r.Name.contains('Company Fiber')) {
                                replacedLineItem = idLineItemMap.get(si.csordtelcoa__Line_Item_Reference_Id__c+si.UM_BillingProductId__c);
                        	} else {
                                replacedLineItem = idLineItemMap.get(si.csordtelcoa__Line_Item_Reference_Id__c);
                            }


                            if((si.csordtelcoa__Delta_Status__c == 'Price Change')
                                    || (si.csordtelcoa__Delta_Status__c == 'Price And Name Change')
                                    || (si.csordtelcoa__Delta_Status__c == 'Name Change')  ){

                                if(replacedLineItem!=null){
                                    KenanServiceItem ksi = UM_KenanSubscriptionSyncCtrl.createKenanServiceItem(replacedLineItem);
                                    ksi.instanceId = replacedLineItem.UM_KenanServiceLineId__c;
                                    //Fix for CATGOV-499 - Assign Inactive Date in User's Local Time Zone to avoid adding one hour to the midnight.
                                    ksi.inactiveDate = getDateTimeFormat(s.csord__Activation_Date__c);
                                    //System.debug('*** replaced ksi= '+ksi);
                                    if(ksi.itemType==0 && si.UM_ContractId__c!=null) {
                                        ksi.itemType = 2;
                                    }
                                    //Check if the Line Item is One Time Charge then don't terminate, just create.
                           // Start code fix for omb-1797
                                    if(ksi.itemType!=1){
                                        if(kenanService.serviceItemCease(ksi)){
                                            terminatedLineItems.add(replacedLineItem);
                                            KenanServiceItem newKSI = UM_KenanSubscriptionSyncCtrl.createKenanServiceItem(si);
                                            newKSI.serviceExternalId = replacedLineItem.csord__Service__c;
                                            newKSI.activeDate = s.csord__Activation_Date__c;
                                            // added for omb-2615 fix
                                            if(replacedLineItem.csord__Service__r.csord__Service__c != null && replacedLineItem.csord__Service__r.csord__Service__r.Name.contains('Company Fiber'))
                                            {
                                                System.debug('Inside if####');
                                                newKSI.serviceExternalId = replacedLineItem.csord__Service__r.csord__Service__c;
                                            }
                                            //added by AG: OMB-1710 on 9-Nov-2017 ( line no. 132-140)
                                            newKSI.extData = new Map<String, Object>();
                                            string itemDescription = si.csord__Line_Description__c;
                                            if(itemDescription != null && !String.isBlank(itemDescription) && itemDescription.length() > 50)
                                                itemDescription = itemDescription.subString(0,50);

                                            if(newKSI.itemType == 0)
                                                newKSI.extData.put('16', itemDescription);
                                            else if(newKSI.itemType == 1)
                                                newKSI.extData.put('15', itemDescription);
                                            list<KenanServiceItem> ksiBack = kenanService.serviceItemCreate(newKSI);
                                            if(ksiBack!=null && !ksiBack.isEmpty()){
                                                si.UM_KenanServiceLineId__c=ksiBack[0].instanceId;
                                                createdLineItems.add(si);
                                            }
                                        }
                                    }else{
                         // End code fix for omb-1797
                                        KenanServiceItem newKSI = UM_KenanSubscriptionSyncCtrl.createKenanServiceItem(si);
                                        newKSI.serviceExternalId = replacedLineItem.csord__Service__c;
                                         if(replacedLineItem.csord__Service__r.csord__Service__c != null && replacedLineItem.csord__Service__r.csord__Service__r.Name.contains('Company Fiber'))
                                        {
                                            System.debug('Inside if####');
                                            newKSI.serviceExternalId = replacedLineItem.csord__Service__r.csord__Service__c;
                                        }
                                  // Start code fix for OMB-1797
                                        newKSI.activeDate = s.csord__Activation_Date__c;
                                           //added by AG: OMB-1710 on 9-Nov-2017 ( line no. 157-165)
                                        newKSI.extData = new Map<String, Object>();
                                        string itemDescription = si.csord__Line_Description__c;
                                        if(itemDescription != null && !String.isBlank(itemDescription) && itemDescription.length() > 50)
                                            itemDescription = itemDescription.subString(0,50);
                                         system.debug('newKSI.itemType =='+newKSI.itemType );
                                        if(newKSI.itemType == 0)
                                            newKSI.extData.put('16', itemDescription);
                                        else if(newKSI.itemType == 1)
                                            newKSI.extData.put('15', itemDescription);
                       // End code fix for OMB-1797
                                        list<KenanServiceItem> ksiBack = kenanService.serviceItemCreate(newKSI);
                                        if(ksiBack!=null && !ksiBack.isEmpty()){
                                            si.UM_KenanServiceLineId__c=ksiBack[0].instanceId;
                                            createdLineItems.add(si);
                                        }    
                                    }
                                }
                            } else if(si.csordtelcoa__Delta_Status__c == 'Added'){
                                KenanServiceItem newKSI = UM_KenanSubscriptionSyncCtrl.createKenanServiceItem(si);
                                newKSI.serviceExternalId = s.csordtelcoa__Replaced_Service__c; //replacedLineItem.csord__Service__c;
                          // Start code fix for OMB-1797
                                newKSI.activeDate = s.csord__Activation_Date__c;
                                //added by AG: OMB-1710 on 9-Nov-2017 ( line no. 181-190)
                                newKSI.extData = new Map<String, Object>();
                                string itemDescription = si.csord__Line_Description__c;
                                if(itemDescription != null && !String.isBlank(itemDescription) && itemDescription.length() > 50)
                                    itemDescription = itemDescription.subString(0,50);

                                if(newKSI.itemType == 0)
                                    newKSI.extData.put('16', itemDescription);
                                else if(newKSI.itemType == 1)
                                    newKSI.extData.put('15', itemDescription);
                     // End code fix for OMB-1797
                                //FIX for OMB-1898 - Start - Create additional Contract Line Item when Contract Id is populated.
                                if(newKSI.itemType==0 && si.UM_ContractId__c!=null) {
                                    KenanServiceItem contractItem =  UM_KenanSubscriptionSyncCtrl.createKenanServiceItem(si);
                                    contractItem.serviceExternalId = s.csordtelcoa__Replaced_Service__c; //replacedLineItem.csord__Service__c;
                                    contractItem.activeDate = s.csord__Activation_Date__c;

                                    contractItem.extData = new Map<String, Object>();
                                    contractItem.itemType = 2;
                                    contractItem.extData.put('17',itemDescription);
            
                                    contractItem.itemId =  Integer.valueOf(si.UM_ContractId__c);
                                    if(!String.isBlank(si.UM_NumberOfUnits__c))
                                       contractItem.unitCreditUnitsFree = Decimal.valueOf(si.UM_NumberOfUnits__c);
        
                                    list<KenanServiceItem> contractKSIBack = kenanService.serviceItemCreate(contractItem);
                                    System.debug('*** contractKSIBack='+contractKSIBack);
                                    if(contractKSIBack!=null && !contractKSIBack.isEmpty()){
                                        si.UM_KenanServiceLineId__c=contractKSIBack[0].instanceId;
                                    }
                                 }
                                list<KenanServiceItem> ksiBack = kenanService.serviceItemCreate(newKSI);
                                if(ksiBack!=null && !ksiBack.isEmpty()){
                                    if(si.UM_KenanServiceLineId__c!=null)
                                        si.UM_KenanServiceLineId__c=si.UM_KenanServiceLineId__c + ';' + ksiBack[0].instanceId;
                                    else
                                    si.UM_KenanServiceLineId__c=ksiBack[0].instanceId;
                                    createdLineItems.add(si);
                                }
                                 //FIX for OMB-1898 - End
                            }else if (si.csordtelcoa__Delta_Status__c == 'Unchanged'){
                                si.UM_KenanServiceLineId__c = replacedLineItem.UM_KenanServiceLineId__c ;
                                createdLineItems.add(si);
                            }


                        }
                        
                        // refreshing code branch with changes already present in UAT/Prod
                        
                        // Modify the service should go first before the swap id.
                        UM_KenanSubscriptionSyncCtrl.modifyKenanService(s.csordtelcoa__Replaced_Service__c, s.csord__Subscription__c, s.Id);
                        
                        //Swap Service ID of the Original Service with the MACD Service in Kenan after successful MACD change
                        swapServiceId(s.csordtelcoa__Replaced_Service__c,s.id,s.csord__Activation_Date__c);
                    }

                    if(ksBack!=null){
                        ksList.add(ksBack);
                        //successServices.add(s);
                    }
                }else{
                    //OMB-1970 - start
                    boolean terminatedFlag = false;
                    if(s.csord__Subscription__r.csordtelcoa__Change_Type__c=='Move' && s.csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_BillingTerminateOnMove__c){
                        System.debug('*** MACD Move and TerminateOnMove=true');
                    if(!UM_KenanSubscriptionSyncCtrl.terminateServices(s.csordtelcoa__Replaced_Service__r.csord__Subscription__c,s.csord__Activation_Date__c ,null)){
                        Task errTask = createErrorTask(s.csordtelcoa__Replaced_Service__r);
                        taskList.add(errTask);
                        }
                        else
                            terminatedFlag=true;
                    }else if(s.csord__Subscription__r.csordtelcoa__Change_Type__c!='Move'){
                        System.debug('*** MACD != Move');
                        if(!UM_KenanSubscriptionSyncCtrl.terminateServices(s.csordtelcoa__Replaced_Service__r.csord__Subscription__c,s.csord__Activation_Date__c ,null)){
                            Task errTask = createErrorTask(s.csordtelcoa__Replaced_Service__r);
                            taskList.add(errTask);
                        }
                        else
                            terminatedFlag=true;
                    }
                    
                    
                    
                    System.debug('*** TerminatedFlag='+terminatedFlag);
                    if(terminatedFlag){
                        csord__Service__c terminatedService = new csord__Service__c(id=s.csordtelcoa__Replaced_Service__c);
                        //terminatedService.csord__Status__c = inactiveStatus;
                        //terminatedService.LG_ServiceStatus__c = inactiveStatus;
                        terminatedService.csord__Deactivation_Date__c = s.csord__Activation_Date__c;
                        csord__Subscription__c sub = new csord__Subscription__c(id=s.csordtelcoa__Replaced_Service__r.csord__Subscription__c);
                        sub.Billing_Termination_Date__c = DateTime.now();
                        sub.Kenan_Response__c=null;
                        terminatedSubsList.add(sub);
                        terminatedServices.add(terminatedService);
                    }
                    
                    System.debug('*** Move before create service');
                    KenanService ksBack = UM_KenanSubscriptionSyncCtrl.createService(s.csord__Subscription__c);
                    System.debug('*** Move after create service='+ksBack);

                    if(ksBack!=null)
                        ksList.add(ksBack);

                    System.debug('*** ksList: ' + ksList );
                    //OMB-1970 - End
                }
            } else{
                KenanService ksBack = UM_KenanSubscriptionSyncCtrl.createService(s.csord__Subscription__c);
                if(ksBack!=null){
                    ksList.add(ksBack);
                    successServices.add(s);
                    //System.debug('*** Adding to successServices='+successServices + ' service= '+s);
                }
                //System.debug('*** ksBack: ' + ksBack );
            }
        }



        //System.debug('*** Final terminatedSubsList: ' + terminatedSubsList);


        //System.debug('*** successServices='+successServices);

        // Changes for UMR-174 & 506
        //If Company Voice Service Activated in Billing then Activate Phone Numbers in Infoport/Dialogika
        /*list<asset> numberBlockAssets = new list<asset>();
        if(!successServices.isEmpty()){
            numberBlockAssets = [select id,name,status, LG_TelephonyProductConfiguration__c,LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__c
                ,account.Name,UM_StartNumber__c,UM_EndNumber__c,UM_AreaCode__c,csord__Service__r.LG_Address__r.cscrm__State_Province__c,csord__Service__r.csord__Service__r.csordtelcoa__Service_Number__c from Asset
                 where LG_TelephonyProductConfiguration__r.cscfga__Product_Family__c='Number Range' and RecordType.Name='Number Block' and csord__Service__r.csord__Service__c in :successServices];
        }
        System.debug('*** numberBlockAssets='+numberBlockAssets);

        if(numberBlockAssets!=null && !numberBlockAssets.isEmpty()){

            list<cscfga__Attribute__c> attributeList = new list<cscfga__Attribute__c>();
            map<id,cscfga__Attribute__c> prodConfigAttributeMap = new map<id,cscfga__Attribute__c>();
            set<id> productConfigIds = new set<id>();

            for(Asset a : numberBlockAssets){
                productConfigIds.add(a.LG_TelephonyProductConfiguration__c);
            }
            System.debug('*** productConfigIds='+productConfigIds);
            attributeList = [select id,name,cscfga__Display_Value__c,cscfga__Value__c,cscfga__Product_Configuration__c from cscfga__Attribute__c where
                                cscfga__Product_Configuration__c in :productConfigIds
                                and name = 'Reservation Number' and cscfga__Display_Value__c!=null
                                ];

            System.debug('*** attributeList='+attributeList);

            for(cscfga__Attribute__c att : attributeList)
                prodConfigAttributeMap.put(att.cscfga__Product_Configuration__c,att);

            System.debug('*** prodConfigAttributeMap='+prodConfigAttributeMap);

            for(Asset nb : numberBlockAssets){
                if(prodConfigAttributeMap.get(nb.LG_TelephonyProductConfiguration__c)!=null){
                    String reservationKey = prodConfigAttributeMap.get(nb.LG_TelephonyProductConfiguration__c).cscfga__Display_Value__c;
                    System.debug('*** reservationKey='+reservationKey);
                    LG_NumberReservationUtil.activatePhoneRequest(nb.UM_AreaCode__c,nb.UM_StartNumber__c,nb.UM_EndNumber__c,reservationKey,nb.csord__Service__r.csord__Service__r.csordtelcoa__Service_Number__c,nb.csord__Service__r.LG_Address__r.cscrm__State_Province__c);
                }
            }
        }
        */



        if(!successServices.isEmpty()){
            updateContractDuration(successServices);
        }

        update terminatedLineItems;
        update createdLineItems;

		//update terminated services & subscription status
        //System.debug('*** terminatedServices='+terminatedServices);
        if(!terminatedSubsList.isEmpty()){
            update terminatedServices;
            update terminatedSubsList;
        }

        if(accountsToUpdate!=null && !accountsToUpdate.isEmpty())
            update accountsToUpdate;

        if(accountItemsToUpdate!=null && !accountItemsToUpdate.isEmpty())
            update accountItemsToUpdate;

        //Create task for error resolution
        if(!taskList.isEmpty())
			insert taskList;



        //update internal Kenan ids after successful synchronisation
        if(!ksList.isEmpty()){
            UM_KenanSubscriptionSyncCtrl.updateKenanIds(ksList);
            for(KenanService ksBack : ksList ){
                for(KenanServiceItem ki : ksBack.serviceItems){
                    if(serviceItemsToUpdate.get(ki.salesforceId)==null)
                    	serviceItemsToUpdate.put(ki.salesforceId,new csord__Service_Line_Item__c(id=ki.salesforceId,UM_KenanServiceLineId__c=ki.instanceId));
                    else
                        serviceItemsToUpdate.get(ki.salesforceId).UM_KenanServiceLineId__c = serviceItemsToUpdate.get(ki.salesforceId).UM_KenanServiceLineId__c+ ';' + ki.instanceId;
                }
            }
            update serviceItemsToUpdate.values();
        }

    }

    private Task createErrorTask(csord__Service__c service){
        Task t = new Task(Subject='Error while terminating a service: '+service.csordtelcoa__Service_Number_Sequence__c);
        t.OwnerId = service.LastModifiedById;
        t.Description = service.csord__Subscription__r.Kenan_Response__c;
        t.ActivityDate = Date.today();
        return t;
    }

    /**
    * Update contract of old added product if depends on set and contract end date
    * on previous service is lower then contract end date of new service
    *
    * @author Robert Stankiewicz
    * @ticket UMR-1107
    * @since  30/11/2016
    */
    public void updateContractDuration(List<csord__Service__c>  services) {
        csord__Service__c dependentService;
        //system.debug('*** updateContractDuration() services='+services);
        Set<Id> idsToCheck = new Set<Id>();
        List<csord__Service__c> servicesToCheck = new List<csord__Service__c>();
        list<id> replacedServiceIds = new list<id>();
        csconta__Contract__c con;

        map<id,csord__Service__c> replacedServicesMap = new map<id,csord__Service__c>();

        for(csord__Service__c service : services){
                idsToCheck.add(service.Id);
                if(service.UM_DependsOnService__r.csordtelcoa__Replaced_Service__c!=null)
                    replacedServiceIds.add(service.UM_DependsOnService__r.csordtelcoa__Replaced_Service__c);
        }
        system.debug('*** updateContractDuration() replacedServiceIds='+replacedServiceIds);

        if(!replacedServiceIds.isEmpty()){
            for(csord__Service__c s : [select id,csord__Subscription__c,csord__Subscription__r.LG_Contract__r.csconta__Valid_From__c,
                        csord__Subscription__r.LG_Contract__r.csconta__Valid_To__c from csord__Service__c where id in :replacedServiceIds ]){
                replacedServicesMap.put(s.id,s);
            }

        }
        system.debug('*** updateContractDuration() replacedServicesMap='+replacedServicesMap);

        //system.debug('--+ idsToCheck: '+idsToCheck);

        if(!idsToCheck.isEmpty()) {

            for(csord__Service__c service : services) {

                if(idsToCheck.contains(service.Id))
                    servicesToCheck.add(service);
            }
        }
        system.debug('*** updateContractDuration() servicesToCheck='+servicesToCheck);

        List<csord__Service__c> servicesToUpdate = new List<csord__Service__c>();
        List<csconta__Contract__c> contractsToUpdate = new List<csconta__Contract__c>();

        for(csord__Service__c serv : servicesToCheck) {

            if(serv.LG_ContractTerm__c != NULL) {

                Date serviceValidTo = serv.csord__Activation_Date__c.addMonths(Integer.ValueOf(serv.LG_ContractTerm__c));

                if(serv.UM_DependsOnService__c != NULL &&
                    serv.UM_DependsOnService__r.LG_ContractEndDate__c < serviceValidTo ) {

                    system.debug('*** updateContractDuration() UM_DependsOnService__c!=null && UM_DependsOnService__r.LG_ContractEndDate__c < serviceValidTo: '+serv);
                    // Start - code added to fix OMB-1692 -RC
                    String rStatus;
                    String replacedId = serv.UM_DependsOnService__r.csordtelcoa__Replaced_Service__c;
                    List<csord__service__c> replacedServices = new List<csord__service__c>([Select LG_ServiceStatus__c from csord__Service__c where Id =:replacedId limit 1]);
                    for (csord__Service__c rser: replacedServices) {
                         rStatus = rser.LG_ServiceStatus__c ;
                    }
                    if(serv.UM_DependsOnService__r.csordtelcoa__Replaced_Service__c!=null && (rStatus != 'Inactive')) 
                    // End - code added to fix OMB-1692 -RC
                        dependentService = new csord__Service__c(id=serv.UM_DependsOnService__r.csordtelcoa__Replaced_Service__c);
                    else
                        dependentService = new csord__Service__c(id=serv.UM_DependsOnService__c);

                    //added by Shashank
                    dependentService.LG_ContractTerm__c = serv.LG_ContractTerm__c;
                    servicesToUpdate.add(dependentService);

                    serv.UM_DependsOnService__r.LG_ContractTerm__c=serv.LG_ContractTerm__c;
                    // set new contract start date
                    //serv.UM_DependsOnService__r.csord__Subscription__r.LG_Contract__r.csconta__Valid_From__c = serv.LG_ContractStartDate__c;
                    // set new contract end date
                    // Start - code added to fix OMB-1692 -RC
                    if(serv.UM_DependsOnService__r.csordtelcoa__Replaced_Service__c!=null && (rStatus != 'Inactive')){
                    // End - code added to fix OMB-1692 -RC
                        csord__Service__c replacedService = replacedServicesMap.get(serv.UM_DependsOnService__r.csordtelcoa__Replaced_Service__c);
                        replacedService.csord__Subscription__r.LG_Contract__r.csconta__Valid_To__c = serviceValidTo;
                        replacedService.csord__Subscription__r.LG_Contract__r.LG_TerminationDate__c = serv.UM_Latest_Cancellation_Letter_Arrival__c;
                        con = replacedService.csord__Subscription__r.LG_Contract__r;
                        con.csconta__Subscription__c = replacedService.csord__Subscription__c;
                    }
                    else{
                        serv.UM_DependsOnService__r.csord__Subscription__r.LG_Contract__r.csconta__Valid_To__c = serviceValidTo;
                        serv.csord__Subscription__r.LG_Contract__r.LG_TerminationDate__c  = serv.UM_Latest_Cancellation_Letter_Arrival__c;
                        con = serv.UM_DependsOnService__r.csord__Subscription__r.LG_Contract__r;
                        con.csconta__Subscription__c = serv.UM_DependsOnService__r.csord__Subscription__c;
                    }
                    contractsToUpdate.add(con);
                }
            }
        }
        system.debug('*** updateContractDuration() servicesToUpdate='+servicesToUpdate);

        system.debug('*** updateContractDuration() contractsToUpdate='+contractsToUpdate);

        //system.debug('--+ servicesToUpdate is:'+servicesToUpdate);
        if(contractsToUpdate.size()>0){
            updateContractsInKenan(contractsToUpdate);
        }
    }

    public void updateContractsInKenan(list<sObject> contractList){
            list<csconta__Contract__c> contracts = (list <csconta__Contract__c>) contractList;
            set<id> subIds = new set<id>();
            map<id,csord__Service__c> subServiceMap = new map<id,csord__Service__c>();
            System.debug('*** contractList='+contractList);
            Date cancellationLetterDate=Date.Today();

            KenanService ksBack;
            for(csconta__Contract__c con : contracts){
                subIds.add(con.csconta__Subscription__c);
            }
            System.debug('*** updateContractsInKenan - subIds='+subIds);
            
            //Fix for OMB-2077 - Added new fieldin SOQL ActivationDate
            for(csord__Service__c service : [select id,csord__Subscription__c,csord__Activation_Date__c,UM_Latest_Cancellation_Letter_Arrival__c,csordtelcoa__Replacement_Service__r.UM_Latest_Cancellation_Letter_Arrival__c from csord__Service__c where csord__Service__c=null and csord__Subscription__c in :subIds ]){
                subServiceMap.put(service.csord__Subscription__c,service);
            }
            System.debug('*** updateContractsInKenan - subServiceMap='+subServiceMap);

            for(csconta__Contract__c contract : contracts){
                Date dTime =  contract.csconta__Valid_To__c;
                DateTime conractDueDate = DateTime.newInstanceGMT(dTime.year(),dTime.month(),dTime.day());
                System.debug('*** before conractDueDate='+conractDueDate);
                if(contract.csconta__Subscription__c!=null){
                    csord__Service__c service = subServiceMap.get(contract.csconta__Subscription__c);
                    System.debug('*** contract='+contract+ ' and Service='+service);

                    cancellationLetterDate = contract.LG_TerminationDate__c;
                    //Fix for OMB-2077 - Added new parameter ActivationDate
                    ksBack = UM_KenanSubscriptionSyncCtrl.updateContract(service.id,conractDueDate,cancellationLetterDate,service.csord__Activation_Date__c);
                }

                if((ksBack!=null && ksBack.serviceInternalId!=null) || (Test.isRunningTest())){
                    System.debug('*** ksBack: '+ksBack);
                }
            }
    }
                     // Pushing changes already present in UAT branch to JIT branch
    private void swapServiceId(string oldId,string newId,date newActivationDate){
        KenanServiceExternalId ksei = new KenanServiceExternalId();
        ksei.salesforceObjectId = oldId;
        ksei.activeDate = newActivationDate;
        ksei.serviceExternalId = newId; // new External Id
        ksei.serviceExternalIdType = 2;       // new External Id Type
        ksei.oldServiceExternalId = oldId; // old External Id
        ksei.oldServiceExternalIdType = 2;    // old External Id Type
        KenanConnectorService connector = new KenanConnectorService();
        system.debug('*** swapIdRequest - ksei='+ksei);
        KenanServiceExternalId returnItem = connector.serviceIdSwap(ksei);   
        system.debug('*** swapIdResult='+returnItem);
    }
    //Fix for CATGOV-499 
    private DateTime getDateTimeFormat(Date pDate){
        Time myTime = Time.newInstance(0, 0, 0, 0);
        DateTime newDateTime;
        try{
            if(pDate!=null){
              newDateTime = DateTime.newInstance(pDate,myTime);
              return newDateTime;
            }
            else
                return null;
        }catch(exception e){
            return null;
        }
    }

}