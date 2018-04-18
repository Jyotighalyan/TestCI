public with sharing class UM_ServiceTerminator implements UM_KenanSyncBatch.IServiceConnect{

    public void execute(list<sObject> servicesList){
        list<csord__Service__c> services = (list<csord__Service__c>) servicesList;
        list<task> taskList = new list<task>();
        list<csord__Subscription__c> subsList = new list<csord__Subscription__c>();
        list<csord__Service_Line_Item__c> lineItems = new list<csord__Service_Line_Item__c>();
        list<csord__Service__c> servicesToBeDeleted = new list<csord__Service__c>();
        list<csord__Subscription__c> subsToBeDeleted = new list<csord__Subscription__c>();
        // list<csord__Service__c> terminationServices = new list<csord__Service__c>();
        // list<csord__Subscription__c> terminationSubs = new list<csord__Subscription__c>();
        map<id,string> serviceDeactivationReasonMap = new map<id,string>();

        csordtelcoa__Orders_Subscriptions_Options__c osp = csordtelcoa__Orders_Subscriptions_Options__c.getOrgDefaults();
        String inactiveStatus = osp.LG_ServiceDeactivatedStatus__c;

        if(inactiveStatus==null)
            inactiveStatus = 'Inactive';

        System.debug('*** services: '+services);
        //Commented as part of SFOM-1555 Start
        // for(csord__service__c s : services){
        //     if(s.csord__Subscription__r.csordtelcoa__Replacement_Subscription__c!=null){
        //         terminationSubs.add(new csord__Subscription__c(id=s.csord__Subscription__r.csordtelcoa__Replacement_Subscription__c));
        //         terminationSubServiceMap.put(s.csord__Subscription__r.csordtelcoa__Replacement_Subscription__c,s.id);
        //     }
        // }

        // if(!terminationSubs.isEmpty()){
        //     terminationServices = [select id,UM_DeactivationReason__c,csord__Subscription__c from csord__service__c where csord__Subscription__c in :terminationSubs];
        //     for(csord__service__c s : terminationServices){
        //         Id serviceId = terminationSubServiceMap.get(s.csord__Subscription__c);
        //         serviceDeactivationReasonMap.put(serviceId,s.UM_DeactivationReason__c);
        //     }
        // }
        //Commented as part of SFOM-1555 End

        //GetTermination Line Items
        lineItems = [select id,name,UM_DeactivationReason__c,UM_ServiceItemType__c,UM_BillingProductId__c,UM_Price_Override__c,csord__Total_Price__c,
                        csord__Line_Description__c,csord__service__r.csord__subscription__r.csordtelcoa__Replaced_Subscription__c,
                        csord__Service__c,csord__Service__r.csord__Subscription__c,csord__Service__r.csord__Deactivation_Date__c
                        from csord__Service_Line_Item__c
                        where LG_Type__c like 'Termination'
                            AND csord__service__c in :services];

        //Send Termination Line Items to Kenan
        KenanConnectorService service = new KenanConnectorService();

        for(csord__Service_Line_Item__c item : lineItems){

            KenanServiceItem kItem =  new KenanServiceItem();
            kItem.serviceExternalId = item.csord__Service__c;
            kItem.salesforceId = item.id;
            kItem.activeDate = item.csord__Service__r.csord__Deactivation_Date__c;

            if(item.UM_ServiceItemType__c!=null)
                kItem.itemType = Integer.valueOf(item.UM_ServiceItemType__c);

            kItem.currencyCode = UserInfo.getDefaultCurrency() ;
            if(item.UM_BillingProductId__c!=null)
                kItem.itemId = Integer.valueOf(item.UM_BillingProductId__c) ;

            if(item.UM_Price_Override__c!='No')
                kItem.rate = item.csord__Total_Price__c*100;

            kItem.extData = new Map<String, Object>();
            string itemDescription = item.csord__Line_Description__c;

            if(!String.isBlank(itemDescription)){
                integer size = itemDescription.length();

                if(size>50)
                    itemDescription = itemDescription.subString(0,50);

                kItem.extData.put('15',itemDescription);
            }

            //SFOM-1555 Deactivation reason is the same on all line items of the same service (and the service itself)
            serviceDeactivationReasonMap.put(item.csord__Service__c, item.UM_DeactivationReason__c);

            //if(item.UM_DeactivationReason__c!=null)
            //    kItem.extData.put('9',item.UM_DeactivationReason__c);

            try{
                list<KenanServiceItem> ksiBack = service.serviceItemCreate(kItem);
                system.debug('*** Added Termination Item ksiBack='+ksiBack);
            }catch(Exception e){
                System.debug('*** Error while creating Termination Item in Kenan '+e.getMessage());
            }
        }

        for(csord__Service__c s : services){
	        Date terminationDate = Date.today();

            if(s.csord__Deactivation_Date__c!=null)
                terminationDate = s.csord__Deactivation_Date__c;

            string deactivationReason = serviceDeactivationReasonMap.get(s.id);
            //Commented out for now as there is issue with Back Dated Termination when serviceModify is set with current date.
            //UM_KenanSubscriptionSyncCtrl.updateDeactivationReason(s.id,deactivationReason);
            // --TODO
            if(!UM_KenanSubscriptionSyncCtrl.terminateServices(s.csord__Subscription__c,terminationDate,null)){
                Task errTask = createErrorTask(s);
                taskList.add(errTask);
            }else{
                s.csord__Status__c = inactiveStatus;
                s.LG_ServiceStatus__c = inactiveStatus;
                csord__Subscription__c sub = new csord__Subscription__c(id=s.csord__Subscription__c);
                sub.Billing_Termination_Date__c = DateTime.now();
                sub.Kenan_Response__c=null;
                subsList.add(sub);
            }

        }
        update services;
        update subsList;

        //UMR-885 Delete Termination Sbuscription and Service created by MACD Terminate
        //Commented out as part of SFOM-1555
        // delete terminationServices;
        // delete terminationSubs;

        //Create task for error resolution
        if(!taskList.isEmpty())
			insert taskList;
    }

    private Task createErrorTask(csord__Service__c service){
        Task t = new Task(Subject='Error while terminating a service: '+service.csordtelcoa__Service_Number_Sequence__c);
        t.OwnerId = service.LastModifiedById;
        t.Description = service.csord__Subscription__r.Kenan_Response__c;
        t.ActivityDate = Date.today();
        return t;
    }

}