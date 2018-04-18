public class LG_ServiceTriggerHandler {
    private static LG_ServiceTriggerHandler ins = null;
    private static Boolean stopTrigger = false;
    private static Boolean updateFlag = false;

    public List<csord__Service__c> services {
        get {
            if (services == NULL) {

                services = new List<csord__Service__c>();
            }

            return services;
        }
        private set;
    }

    public Set<Id> servicesIds {
        get {
            if (servicesIds == NULL) {

                servicesIds  = new Set<Id>();
            }

            return servicesIds;
        }
        private set;
    }

    public List<csord__Service__c> servicesList {
        get {
            if (servicesList == NULL) {

                servicesList = new List<csord__Service__c>();
            }

            return servicesList;
        }
        private set;
    }

    public Map<Id, csord__Service__c> oldServicesMap {
        get{
            if (oldServicesMap == NULL) {

                oldServicesMap = new Map<Id, csord__Service__c>();
            }

            return oldServicesMap;
        }
        private set;
    }

    public Map<Id, csord__Service__c> newServicesMap {
        get{
            if (newServicesMap == NULL) {

                newServicesMap = new Map<Id, csord__Service__c>();
            }

            return newServicesMap;
        }
        private set;
    }

    public String userProfileName {
        get {
            if (userProfileName == NULL) {
                Id cupId = UserInfo.getProfileId();
                userProfileName = [SELECT Name FROM Profile WHERE Id = : cupId limit 1].Name;
            }

            return userProfileName;
        }
        private set;
    }

    public Map<Id, String> replacementSubChangeType {
        get{
            if (replacementSubChangeType == NULL) {

                replacementSubChangeType = new Map<Id, String>();
            }

            return replacementSubChangeType;
        }
        private set;
    }

    // Class constructor
    private LG_ServiceTriggerHandler(List<csord__Service__c> newList, Map<Id, csord__Service__c> oldMap) {

        system.debug('--+ CONSTRUCTOR');
        services = newList;
        system.debug('--+ services: ' + services);
        oldServicesMap = oldMap;
        system.debug('--+ oldServicesMap: ' + oldServicesMap);
        for (csord__Service__c service : services) {

            if (service.Id != NULL) servicesIds.add( service.Id );
        }

        system.debug('--+ servicesIds: ' + servicesIds);

        if (!servicesIds.isEmpty()) {
            //** Added by sabeena as part of code merging 8/21/2017**
              servicesList = [SELECT Id, Name, LG_Address__c,LG_ServiceExternalid__c, LG_ServiceStatus__c, csord__Subscription__c, csord__Subscription__r.csord__Account__c, csord__Subscription__r.csconta__Billing_Account__c, csord__Subscription__r.LG_Address__c, csord__Subscription__r.csordtelcoa__Replaced_Subscription__r.LG_Contract__c,
                            csord__Subscription__r.csordtelcoa__Replaced_Subscription__c, csord__Subscription__r.csordtelcoa__Change_Type__c, csordtelcoa__Product_Configuration__c, csord__Status__c, csord__Subscription__r.LG_Contract__c, csord__Subscription__r.LG_Contract__r.csconta__Valid_To__c,
                            csordtelcoa__Product_Configuration__r.LG_Billing_Account__c, csord__Service__c, csordtelcoa__Replaced_Service__c, csordtelcoa__Service_Number__c, csordtelcoa__Service_Number_Sequence__c, csord__Activation_Date__c,LG_Action__c,
                            UM_GetCurrentContractTerm__c, LG_ContractStartDate__c, LG_ContractEndDate__c, LG_ContractTerm__c, UM_DependsOnService__c, UM_DependsOnProductConfiguration__c, UM_DependsOnService__r.LG_ContractEndDate__c, UM_DependsOnService__r.LG_ContractTerm__c,
                            UM_DependsOnService__r.csord__Subscription__r.LG_Contract__r.csconta__Valid_From__c, UM_DependsOnService__r.csord__Subscription__r.LG_Contract__r.csconta__Valid_To__c,csord__Subscription__r.csordtelcoa__Replacement_Subscription__r.csordtelcoa__Change_Type__c,
                            csord__Order__c,LG_RootOrder__c,csord__Service__r.UM_DependsOnService__r.csordtelcoa__Replaced_Service__c, csordtelcoa__Delta_Status__c,
                            LG_RootOrder__r.csordtelcoa__Opportunity__c, LG_RootOrder__r.csordtelcoa__Opportunity__r.um_partnerAccount__c, UM_PartnerAccount__c, csord__Subscription__r.csord__Order__c, csord__Subscription__r.csord__Order__r.csordtelcoa__Opportunity__c, csord__Subscription__r.csord__Order__r.csordtelcoa__Opportunity__r.UM_PartnerAccount__c,
                            LG_Suborder__r.csord__Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c,csordtelcoa__Replaced_Service__r.LG_ProvisioningSystem__c,csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c, csord__Service__r.LG_ServiceExternalId__c,LG_MarketSegment__c, LG_ProductFamily__c,
                            csord__Service__r.LG_DecompositionCriteria__c,LG_DecompositionCriteria__c,csordtelcoa__Product_Configuration__r.Name, LG_From_Service__c, LG_To_Service__c,csord__Service__r.LG_ProductFamily__c,csord__Service__r.csord__Activation_Date__c,csord__Service__r.csord__Status__c,
                            csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_BillingTerminateOnMove__c,LG_ProductDefinitionName__c,       //Added for OMB-1970
                            //added for SFOM-2551
                            LG_SecondaryProductConfiguration__c,LG_DependsOnSecondaryService__c,csord__Service__r.LG_SecondaryProductConfiguration__c, 
                              //added for oMB-3542
                            csord__service__r.LG_Replacement_Service_Change_Type__c
                            
							FROM csord__Service__c
                            WHERE Id IN :servicesIds];

            for(csord__Service__c service : servicesList){
                newServicesMap.put(service.Id, service);
                replacementSubChangeType.put(service.Id, service.csord__Subscription__r.csordtelcoa__Replacement_Subscription__r.csordtelcoa__Change_Type__c);
            }
        }

        system.debug('--+ servicesList: ' + servicesList);
    }

    /**
     * Pseudo-Singleton implementation, it was impossible to work on the same
     * set of data, because of complexity. The object is being recreated (as per logic in the trigger)
     * after every insert and before update
     *
     * @param  List<csord__Service__c> services
     * @return LG_ServiceTriggerHandler
     * @author Robert Stankiewicz
     * @since  09/11/2016
     */
    public Static LG_ServiceTriggerHandler getInstance(List<csord__Service__c> newServices, Map<Id, csord__Service__c> oldServices, Boolean newInstance) {

        // after insert all need to be refreshed
        updateFlag = newInstance;

        system.debug('--+ getInstance() +--');
        system.debug('--+ ins before: ' + ins);
        system.debug('--+ updateFlag: ' + updateFlag);

        if (ins == NULL || updateFlag == true) {

            //system.debug('--+ new instance of the object');
            //system.debug('--+ newServices: '+newServices);
            //system.debug('--+ newServices.size(): '+newServices.size());
            //system.debug('--+ oldServices: '+oldServices);
            //system.debug('--+ oldServices.size(): '+oldServices.size());
            ins = new LG_ServiceTriggerHandler( newServices, oldServices );

        }

        system.debug('--+ ins after: ' + ins);

        return ins;
    }

    /**
     * If MACD Move scenario, Subscription,Service and Service
     * Line Item will have new number instead old one
     *
     * @param  List<csord__Service__c> services
     * @author Petar Miletic
     * @ticket SFDT-447
     * @since  15/03/2016
    */
    public void updateSubscriptionNumber() {

        //system.debug('--+ updateSubscriptionNumber() ');

        List<csord__Service__c> servicesToUpdate = new List<csord__Service__c>();

        // Applicable for following change types
        Set<string> changeTypes = new Set<string> { 'Move' };
        changeTypes.addAll(LG_Util.getMigrateVarietyChangeTypes());

        csordtelcoa__Orders_Subscriptions_Options__c osOptions = csordtelcoa__Orders_Subscriptions_Options__c.getOrgDefaults();

        //RS: Singleton
        //List<csord__Service__c> subs = [SELECT Id, Name, csord__Subscription__r.csordtelcoa__Change_Type__c, csordtelcoa__Service_Number__c, csordtelcoa__Service_Number_Sequence__c FROM csord__Service__c WHERE Id IN :servicesIds];
        //system.debug('--+ should not be empty - servicesList: '+servicesList);
        for (csord__Service__c service : servicesList) {

            if (service.csord__Subscription__c != null && changeTypes.contains(service.csord__Subscription__r.csordtelcoa__Change_Type__c) && service.csordtelcoa__Service_Number_Sequence__c != null) {
                service.csordtelcoa__Service_Number__c = osOptions.csordtelcoa__Service_Number_Prefix__c + service.csordtelcoa__Service_Number_Sequence__c;

                servicesToUpdate.add( service );
            }
        }

        //system.debug('--+ servicesToUpdate.size(): '+servicesToUpdate.size());
        //system.debug('--+ servicesToUpdate: '+servicesToUpdate);
        if (servicesToUpdate.size() > 0)
            update servicesToUpdate;
    }

    /**
     * For all the new/updated Services that have a LG_Address__c field populated,
     * and are related to a Subscription that has a blank LG_Address__c field -
     * this method should populated the Address field on the Subscription
     *
     * @param  List<csord__Service__c> services
     * @author Tomislav Blazek
     * @ticket SFDT-296
     * @since  22/02/2016
     */
    public void updateSubscriptionAddress() {
        //system.debug('--+ updateSubscriptionAddress() ');
        Set<Id> idsToCheck = new Set<Id>();
        List<csord__Service__c> servicesToCheck = new List<csord__Service__c>();

        for (csord__Service__c service : services) {
            if (service.LG_Address__c != NULL)
                idsToCheck.add(service.Id);
        }
        //system.debug('--+ idsToCheck: '+idsToCheck);
        if (!idsToCheck.isEmpty()) {

            for (csord__Service__c service : servicesList) {

                if (idsToCheck.contains(service.Id))
                    servicesToCheck.add(service);
            }
            //RS: Singleton
            //servicesToCheck = [SELECT Id, LG_Address__c, csord__Subscription__c, csord__Subscription__r.LG_Address__c
            //                    FROM csord__Service__c
            //                        WHERE Id IN :idsToCheck];
        }

        //subscription to Address map
        Map<csord__Subscription__c, Id> subscriptionToAddress = new Map<csord__Subscription__c, Id>();
        for (csord__Service__c service : servicesToCheck) {
            if (service.csord__Subscription__r.LG_Address__c == null) {
                subscriptionToAddress.put(service.csord__Subscription__r, service.LG_Address__c);
            }
        }

        List<csord__Subscription__c> subsToUpdate = new List<csord__Subscription__c>();
        if (!subscriptionToAddress.isEmpty()) {
            for (csord__Subscription__c subscription : subscriptionToAddress.keySet()) {
                Id address = subscriptionToAddress.get(subscription);
                if (subscription.LG_Address__c != address) {
                    subscription.LG_Address__c = address;
                    subsToUpdate.add(subscription);
                }
            }

            //system.debug('--+ subsToUpdate: '+subsToUpdate);
            if (!subsToUpdate.isEmpty()) {
                update subsToUpdate;
            }
        }
    }

    /**
    * If services that is being inserted is (Zakelijk Hosted Bellen, Multi Wifi, PIN Zeker),
    * and if on the same address there is Internet service, the SLA line item of that Internet
    * service should be cloned to the new Service Line Items
    *
    * @param  List<csord__Service__c> services
    * @author Tomislav Blazek
    * @ticket SFDT-525
    * @since  18/3/2016
    */
    public void cloneSlaLineItem() {

        //system.debug('--+ cloneSlaLineItem()');
        Map<csord__Service__c, Id> eligibleServicesAddresses = new Map<csord__Service__c, Id>();

        for (csord__Service__c service : services) {
            if (service.csord__Status__c != LG_Util.getServiceDeactivatedStatus()
                    && service.csord__Status__c != LG_Util.getServiceDeactivatedStatus()
                    && (service.LG_ProductFamily__c == 'PIN'
                        || service.LG_ProductFamily__c == 'HPBX'
                        || service.LG_ProductFamily__c == 'Multi WiFi')) {
                eligibleServicesAddresses.put(service, service.LG_Address__c);
            }
        }

        if (!eligibleServicesAddresses.isEmpty()) {
            List<csord__Service_Line_Item__c> slaLinesToInsert = new List<csord__Service_Line_Item__c>();
            for (csord__Service__c internetService : [SELECT Id, LG_Address__c,
                    (SELECT Id, Name, csord__Identification__c, csord__Is_Adhoc__c,
                     csord__Is_Recurring__c, csord__Line_Description__c,
                     csord__Order_Request__c, LG_BillingAccount__c,
                     LG_ServiceLineItemExternalId__c, LG_Quantity__c, LG_ExternalServiceName__c,
                     LG_ExternalPriceName__c, LG_ExternalDescription__c, LG_Type__c,
                     LG_AddOnType__c, LG_ToBeSent__c
                     FROM csord__Service_line_Items__r
                     WHERE LG_AddOnType__c = 'SLA')
                    FROM csord__Service__c
                    WHERE LG_ProductFamily__c = 'Internet'
                                                AND LG_Address__c IN :eligibleServicesAddresses.values()]) {
                for (csord__Service__c eligibleService : eligibleServicesAddresses.keySet()) {
                    if (eligibleService.LG_Address__c == internetService.LG_Address__c) {
                        csord__Service_Line_Item__c intSlaLineItem = null;
                        if (!internetService.csord__Service_line_Items__r.isEmpty()) {
                            intSlaLineItem = internetService.csord__Service_line_Items__r[0];

                            slaLinesToInsert.add(new csord__Service_Line_Item__c(Name = intSlaLineItem.Name,
                                                 csord__Identification__c = intSlaLineItem.csord__Identification__c,
                                                 csord__Is_Adhoc__c = intSlaLineItem.csord__Is_Adhoc__c,
                                                 csord__Is_Recurring__c = intSlaLineItem.csord__Is_Recurring__c,
                                                 csord__Line_Description__c = intSlaLineItem.csord__Line_Description__c,
                                                 csord__Service__c = eligibleService.Id,
                                                 csord__Order_Request__c = intSlaLineItem.csord__Order_Request__c,
                                                 LG_BillingAccount__c = intSlaLineItem.LG_BillingAccount__c,
                                                 LG_ServiceLineItemExternalId__c = intSlaLineItem.LG_ServiceLineItemExternalId__c,
                                                 LG_Quantity__c = intSlaLineItem.LG_Quantity__c,
                                                 LG_ExternalServiceName__c = intSlaLineItem.LG_ExternalServiceName__c,
                                                 LG_ExternalPriceName__c = intSlaLineItem.LG_ExternalPriceName__c,
                                                 LG_ExternalDescription__c = intSlaLineItem.LG_ExternalDescription__c,
                                                 LG_Type__c = intSlaLineItem.LG_Type__c, LG_AddOnType__c = intSlaLineItem.LG_AddOnType__c,
                                                 LG_ToBeSent__c = intSlaLineItem.LG_ToBeSent__c));
                        }
                    }
                }
            }

            if (!slaLinesToInsert.isEmpty())
                insert slaLinesToInsert;
        }
    }

    /**********************************************************************************************************************
     * author: Madhu  // Debug by: DvtH10Aug2016
     * Date: July 2016
     * Param:List<csord__Service__c> services
     * Return:  void
     * Description: This method will update the BillingAccount on subscriptions
     * Summary of Changes : UMR-284
     **********************************************************************************************************************/
    public void updateSubscriptionBillingAccount() {

        system.debug('--+ updateSubscriptionBillingAccount()');
        Set<Id> subscriptionIds = new Set<Id>();
        List<csord__Service__c> servicesToCheck = new List<csord__Service__c>();
        Id accId;

        // subscriptionIds
        for (csord__Service__c service : services) {

            if (service.csord__Subscription__c != NULL)
                subscriptionIds.add(service.csord__Subscription__c);
        }
        system.debug('--+ subscriptionIds: ' + subscriptionIds);
        system.debug('--+ servicesList.isEmpty()? ' + servicesList.isEmpty() );
        if (!servicesList.isEmpty()) {

            for (csord__Service__c service : servicesList) {
                if (service.csord__Service__c == NULL) {

                    servicesToCheck.add( service );
                }
            }
        }
        system.debug('--+ servicesToCheck: ' + servicesToCheck);
        system.debug('--+ servicesToCheck.size(): ' + servicesToCheck.size());

        //subscription to update billing account
        Map<csord__Subscription__c, Id> subscriptionToBillingAccount = new Map<csord__Subscription__c, Id>();
        if (servicesToCheck != null && servicesToCheck.size() > 0) {

            for (csord__Service__c service : servicesToCheck) {

                //system.debug('--+ service FOR: '+service);
                //system.debug('--+ service: '+service.Name);
                //system.debug('--+ service.csordtelcoa__Product_Configuration__c: '+service.csordtelcoa__Product_Configuration__c);
                //system.debug('--+ service.csordtelcoa__Product_Configuration__r.LG_Billing_Account__c: '+service.csordtelcoa__Product_Configuration__r.LG_Billing_Account__c);

                if (!subscriptionToBillingAccount.containsKey(service.csord__Subscription__r))
                    subscriptionToBillingAccount.put(service.csord__Subscription__r, service.csordtelcoa__Product_Configuration__r.LG_Billing_Account__c);
            }

            //system.debug('--+ subscriptionToBillingAccount: '+subscriptionToBillingAccount);

            List<csord__Subscription__c> subsToUpdate = new List<csord__Subscription__c>();
            if (!subscriptionToBillingAccount.isEmpty()) {

                for (csord__Subscription__c subscription : subscriptionToBillingAccount.keySet()) {

                    accId = subscriptionToBillingAccount.get(subscription);
                    //system.debug('--+ accId: '+accId);
                    //system.debug('--+ subscription.csconta__Billing_Account__c: '+subscription.csconta__Billing_Account__c);

                    //DvtH11aug2016 prevent unneeded updates
                    //SFOM-1031 hpbx subscription does not have product configuration,hence checking for accId as null
                    if (accId != null && subscription.csconta__Billing_Account__c != accId) {
                        subscription.csconta__Billing_Account__c = accId;
                        subsToUpdate.add(subscription);
                    }
                }

                //system.debug('--+ subsToUpdate: '+subsToUpdate);
                if (!subsToUpdate.isEmpty()) {
                    update subsToUpdate;
                }
            }
        }
    }

    /**
    * Update contract of old added product if depends on set and contract end date
    * on previous service is lower then contract end date of new service
    *
    * @author Robert Stankiewicz
    * @ticket UMR-1107
    * @since  30/11/2016
    */
    public void updateContractDuration() {

        //system.debug('--+ updateContractDuration() ');
        Set<Id> idsToCheck = new Set<Id>();
        List<csord__Service__c> servicesToCheck = new List<csord__Service__c>();

        for (csord__Service__c service : services) {

            if (service.csord__Status__c == 'Active')
                idsToCheck.add(service.Id);
        }
        //system.debug('--+ idsToCheck: '+idsToCheck);

        if (!idsToCheck.isEmpty()) {

            for (csord__Service__c service : servicesList) {

                if (idsToCheck.contains(service.Id))
                    servicesToCheck.add(service);
            }
        }
        //system.debug('--+ servicesToCheck: '+servicesToCheck);

        List<csord__Service__c> servicesToUpdate = new List<csord__Service__c>();
        List<csconta__Contract__c> contractsToUpdate = new List<csconta__Contract__c>();

        for (csord__Service__c serv : servicesToCheck) {

            //system.debug('--+ serv is:'+serv);
            //system.debug('--+ serv.UM_DependsOnService__c: '+serv.UM_DependsOnService__c);
            //system.debug('--+ serv.UM_DependsOnService__r.LG_ContractEndDate__c: '+serv.UM_DependsOnService__r.LG_ContractEndDate__c);
            //system.debug('--+ serv.LG_ContractEndDate__c: '+serv.LG_ContractEndDate__c);
            //system.debug('--+ serv.LG_ContractTerm__c: '+serv.LG_ContractTerm__c);

            if (serv.LG_ContractTerm__c != NULL && serv.LG_ContractTerm__c > 0) {

                Date serviceValidTo = serv.csord__Activation_Date__c.addMonths(Integer.ValueOf(serv.LG_ContractTerm__c));

                if (serv.UM_DependsOnService__c != NULL &&
                        serv.UM_DependsOnService__r.LG_ContractEndDate__c < serviceValidTo ) {

                    csord__Service__c service = new csord__Service__c(id = serv.UM_DependsOnService__c);

                    //added by Shashank
                    service.LG_ContractTerm__c = serv.LG_ContractTerm__c;
                    servicesToUpdate.add(service);

                    serv.UM_DependsOnService__r.LG_ContractTerm__c = serv.LG_ContractTerm__c;
                    // set new contract start date
                    //serv.UM_DependsOnService__r.csord__Subscription__r.LG_Contract__r.csconta__Valid_From__c = serv.LG_ContractStartDate__c;
                    // set new contract end date
                    serv.UM_DependsOnService__r.csord__Subscription__r.LG_Contract__r.csconta__Valid_To__c = serviceValidTo;
                    contractsToUpdate.add( serv.UM_DependsOnService__r.csord__Subscription__r.LG_Contract__r );
                }
            }
        }

        //system.debug('--+ servicesToUpdate is:'+servicesToUpdate);
        if (servicesToUpdate.size() > 0)
            update servicesToUpdate;

        //system.debug('--+ servicesToUpdate is:'+servicesToUpdate);
        if (contractsToUpdate.size() > 0)
            update contractsToUpdate;

    }

    /*
     * Callout for Account & Service Synchronisation with Billing

    */
    public void synchroniseWithKenan () {

        //System.debug('--+ synchroniseWithKenan()');

        list<csord__Service__c> records = new list<csord__Service__c>();

        string query = 'select id, csord__Subscription__c,csordtelcoa__Replaced_Service__c, csordtelcoa__Replaced_Service__r.csord__Subscription__c,' +
                       'csord__Subscription__r.csconta__Billing_Account__c,csord__Activation_Date__c,UM_Latest_Cancellation_Letter_Arrival__c, ' +
                       ' csordtelcoa__Replaced_Service__r.csordtelcoa__Service_Number_Sequence__c,csord__Subscription__r.LG_Contract__r.LG_TerminationDate__c, ' +
                       ' csordtelcoa__Replaced_Service__r.LastModifiedById, UM_DependsOnService__r.csord__Subscription__c,' +
                       ' csordtelcoa__Replaced_Service__r.csord__Subscription__r.Kenan_Response__c, ' +
                       ' csord__Subscription__r.csordtelcoa__Replaced_Subscription__c,csord__Subscription__r.csordtelcoa__Change_Type__c, ' +
                       ' csordtelcoa__Replaced_Service__r.LG_ServiceExternalId__c,UM_DependsOnService__r.csordtelcoa__Replaced_Service__c,' +
                       ' UM_GetCurrentContractTerm__c, LG_ContractStartDate__c, LG_ContractEndDate__c, LG_ContractTerm__c, UM_DependsOnService__c, UM_DependsOnProductConfiguration__c, ' +
                       ' UM_DependsOnService__r.LG_ContractEndDate__c, UM_DependsOnService__r.LG_ContractTerm__c,' +
                       ' UM_DependsOnService__r.csord__Subscription__r.LG_Contract__r.csconta__Valid_From__c, UM_DependsOnService__r.csord__Subscription__r.LG_Contract__r.csconta__Valid_To__c,' +
                                            ' csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_BillingTerminateOnMove__c, '+        //Added for OMB-1970
                       ' LG_SecondaryProductConfiguration__c,LG_DependsOnSecondaryService__c,csord__Service__r.LG_SecondaryProductConfiguration__c '+
                       ' from csord__Service__c ' +
                       ' where csord__Status__c=\'Ready for Billing\' and LG_ServiceExternalId__c = null ' +
                       ' and csord__Service__c=null and id in :records';

        // check for 'soho' is added to avoid the kenen sync - by Trupti Rajput
        for (csord__Service__c service : services) {
            System.debug('+++ service='+service);
            if (service.csord__Service__c==null && service.csord__Status__c == 'Ready for Billing' && service.LG_MarketSegment__c != 'SoHo'
            && service.LG_ServiceExternalId__c==null
            // && service.LG_DecompositionCriteria__c != 'Set 22 - Parent/Category Only'
            && oldServicesMap.containsKey(service.id)
            && oldServicesMap.containsKey(service.id)
            && oldServicesMap.get(service.id).csord__Status__c != 'Ready for Billing') {
                records.add(service);
            }
        }
        //System.debug('*** Service Creation records:'+records);

        if (!records.isEmpty()) {
            //System.debug('*** before executeBatch');
            Id batchJobId = Database.executeBatch(new UM_KenanSyncBatch(records, query, 'UM_ServiceCreator'), 1);
            //System.debug('*** after executeBatch: '+batchJobId);
        }
        
        // Below is called to sync HPBX child services
        hpbxSyncWithKenan();
    }

    /*
     * Call out Termintion in Billing for the replaced Services in MACD

    */
    public void serviceMACDTermination(){
        map<id,id> subsServiceMap = new map<id,id>();
        // list<csord__Service_Line_Item__c> lineItems = new list<csord__Service_Line_Item__c>();

        //system.debug('--+ serviceMACDTermination()');

        list<csord__Service__c> records = new list<csord__Service__c>();

        string serviceStatus = 'Ready for Billing';
        string serviceAction = 'Delete';
        string status = String.Format('\'\'{0}\'\'', new String[]{serviceStatus});
        string action = String.Format('\'\'{0}\'\'', new String[]{serviceAction});

        string query = 'select id, csord__Deactivation_Date__c ,csordtelcoa__Replacement_Service__r.csord__Activation_Date__c,csord__Subscription__c, '+
            'csord__Subscription__r.csconta__Billing_Account__c,LastModifiedById,UM_DeactivationReason__c,'+
            ' csord__Subscription__r.csordtelcoa__Replacement_Subscription__c, csordtelcoa__Service_Number_Sequence__c,csord__Subscription__r.Kenan_Response__c,'+
            ' csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_BillingTerminateOnMove__c '+   //Added for OMB-1970
            ' from csord__Service__c '+
            '  where '+
            ' csord__Status__c in (' + status +') and LG_ServiceExternalId__c != null '+
           ' and csord__Service__c=null and id in :records and LG_Action__c IN ('+ action +')';
            //+ ' and csord__Subscription__r.csordtelcoa__Replacement_Subscription__r.csordtelcoa__Change_Type__c!=\'Move\'';

        for (csord__Service__c service : services) {
            //system.debug('--+ serviceMACDTermination.service: '+ service + ' and status: '+status);
            //system.debug('--+ oldServicesMap.containsKey(service.id)? '+oldServicesMap.containsKey(service.id));
            if (oldServicesMap.containsKey(service.id) &&
                    service.csord__Status__c == serviceStatus && service.LG_Action__c == serviceAction &&
                    !service.csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_BillingTerminateOnMove__c &&    //Added for OMB-1970
                    //replacementSubChangeType.get(service.Id)!='Move' &&       //Commented for OMB-1970
                    (oldServicesMap.get(service.id).csord__Status__c != serviceStatus || oldServicesMap.get(service.id).LG_Action__c != serviceAction)) {
                records.add(service);
                //System.debug('--+ service.csord__Status__c: '+ service.csord__Status__c + ' Old Status: '+oldServicesMap.get(service.id).csord__Status__c);
            }
        }

        //System.debug('*** MACDTermination records:'+records);
        if (!records.isEmpty()) {
            //System.debug('*** before executeBatch');
            //Commented out as part of SFOM-1555 START
            // for(csord__Service__c ser : records){
            //     subsServiceMap.put(ser.csord__Subscription__c,ser.id);
            // }

            //UMR-885 Assign Original Service Id to Termination Charge Service Line Item
            // lineItems = [select id,name,csord__service__r.csord__subscription__r.csordtelcoa__Replaced_Subscription__c from csord__Service_Line_Item__c where csord__service__r.csord__Subscription__r.csordtelcoa__Replaced_Subscription__c in :subsServiceMap.keySet()];
            // for(csord__Service_Line_Item__c item : lineItems){
            //     item.csord__Service__c = subsServiceMap.get(item.csord__service__r.csord__subscription__r.csordtelcoa__Replaced_Subscription__c);
            // }
            // update lineItems;
            // END of UMR-885
            // Commented out as part of SFOM-1555 END
            Id batchJobId = Database.executeBatch(new UM_KenanSyncBatch(records,query,'UM_ServiceTerminator'), 5);
            //System.debug('*** after executeBatch: '+batchJobId);
        }
    }

    public void ceaseNumberBlockIDs() {

        //system.debug('--+ ceaseNumberBlockIDs()');

        list<csord__Service__c> records = new list<csord__Service__c>();
        string query = 'select id, UM_NumberRangeService__c , UM_NumberRangeService__r.csord__Service__c,' +
                       ' UM_CDRIDNumber__c, UM_NumberRangeService__r.csord__Service__r.csordtelcoa__Replacement_Service__r.csord__Activation_Date__c' +
                       ' from UM_NumberBlock__c where UM_NumberRangeService__c in :records and ' +
                       ' UM_NumberRangeService__r.csordtelcoa__Delta_Status__c = \'Deleted From Subscription\'';

        for (csord__Service__c service : services) {

            if ((service.LG_ProductFamily__c == 'Number Range' && service.csord__Service__c != null) &&
                    (service.csordtelcoa__Delta_Status__c == 'Deleted From Subscription' &&
                     oldServicesMap.get(service.id).csordtelcoa__Delta_Status__c != 'Deleted From Subscription')
               ) {
                records.add(service);
            }
        }

        if (!records.isEmpty()) {
            //System.debug('*** before executeBatch');
            Id batchJobId = Database.executeBatch(new UM_KenanSyncBatch(records, query, 'UM_KenanIDTerminator'), 5);
            //System.debug('*** after executeBatch: '+batchJobId);
        }

    }


    public void updateReplacedServiceContract() {

        //system.debug('--+ updateReplacedServiceContract() ');

        Map<id, id> subContractMap = new Map<id, id>();
        list<csord__Subscription__c> newSubs = new list<csord__Subscription__c>();
        List<csord__Service__c> servicesToCheck = new List<csord__Service__c>();
        map<id, id> prodConfigSubsMap = new map<id, id>();

        for (csord__Service__c service : servicesList) {

            if (service.UM_GetCurrentContractTerm__c == TRUE && oldServicesMap.containskey(service.id) && oldServicesMap.get(service.id).UM_GetCurrentContractTerm__c == FALSE) {
                servicesToCheck.add( service );
            }
        }

        //system.debug('--+ servicesTocCheck: '+servicesToCheck);

        if (!servicesToCheck.isEmpty()) {

            List<Id> pConfigs = new List<Id>();
            for (csord__Service__c service : servicesToCheck) {
                pConfigs.add(service.csordtelcoa__Product_Configuration__c);
                prodConfigSubsMap.put(service.csordtelcoa__Product_Configuration__c, service.csord__Subscription__c);
            }

            Set<Id> setSerIds = new Set<Id>();
            if (!pConfigs.isEmpty()) {
                List<cscfga__Attribute__c> attributes = [SELECT Name, cscfga__Value__c, cscfga__Product_Configuration__c FROM cscfga__Attribute__c
                                                        WHERE Name = 'Service Replaced by Migration'
                                                                AND cscfga__Product_Configuration__c IN :pConfigs];
                for (cscfga__Attribute__c atr : attributes) {
                    if (atr.cscfga__Value__c != null) {
                        setSerIds.add(atr.cscfga__Value__c);
                    }
                }
                //system.debug('--+ setSerIds: '+setSerIds);
                Map<Id, csord__Service__c> map_IdService = new Map<Id, csord__Service__c>();
                if (!setSerIds.isEmpty())
                    map_IdService = new map<Id, csord__Service__c>([select id, csord__Subscription__c, csord__Subscription__r.LG_Contract__c from csord__Service__c where id IN:setSerIds ]);

                for (csord__Service__c service : servicesToCheck) {

                if(service.csordtelcoa__Replaced_Service__c == NULL) {

                        for (cscfga__Attribute__c attr : attributes) {
							if(prodConfigSubsMap.get(attr.cscfga__Product_Configuration__c) != null && map_IdService.get(attr.cscfga__Value__c) != null){
								subContractMap.put(prodConfigSubsMap.get(attr.cscfga__Product_Configuration__c) , map_IdService.get(attr.cscfga__Value__c).csord__Subscription__r.LG_Contract__c);
							}
                        }

                    } else {
                        system.debug('subscriptions' + service.csord__Subscription__c);
                        system.debug('service' + service);
                        if (service.csord__Subscription__r.LG_Contract__c != service.csord__Subscription__r.csordtelcoa__Replaced_Subscription__r.LG_Contract__c) {
                            subContractMap.put(service.csord__Subscription__c, service.csord__Subscription__r.csordtelcoa__Replaced_Subscription__r.LG_Contract__c);
                        }
                    }
                }
            }
        }

        //system.debug('--+ subContractMap: '+subContractMap);

        //if(!subContractMap.isEmpty())
        //    newSubs = [SELECT id,LG_Contract__c FROM csord__Subscription__c WHERE id IN :subContractMap.keySet()];
        for (id subId : subContractMap.keySet()) {

            csord__Subscription__c newSub = new csord__Subscription__c(id = subId);
            newSub.LG_Contract__c = subContractMap.get(subId);
            newSubs.add(newSub);
        }

        //system.debug('--+ newSubs: '+newSubs);

        //for(csord__Subscription__c sub : newSubs)
        //    sub.LG_Contract__c = subContractMap.get(sub.id);

        if (!newSubs.isEmpty())
            update newSubs;
    }

    /**********************************************************************************************************************
    * author: Madhu  // Debug by: DvtH10Aug2016
    * Date: July 2016
    * Param:List<csord__Service__c> services ,List<csord__Service__c> oldservices
    * Return:  void
    * Description: When the status and activation date on the service are set,
    *              the child services and the parent subscription should get the same values
    * Summary of Changes : UMR-683
    **********************************************************************************************************************/
    public void updateChildServicesAndSubscriptions() {

        //system.debug('--+ updateChildServicesAndSubscriptions()');
        //system.debug('--+ services: ' +services);
        //system.debug('--+ services.size(): ' +services.size());
        //system.debug('--+ oldServicesMap: '+oldServicesMap);
        //system.debug('--+ oldServicesMap.size(): '+oldServicesMap.size());

        Set<Id> idsToCheck = new Set<Id>();
        Map<Id, csord__Subscription__c> subsToUpdate = new Map<Id, csord__Subscription__c>();

        Set<Id> subscriptionIds = new Set<Id>();
        List<csord__Subscription__c> subsCheckList = new List<csord__Subscription__c>();
        csord__Subscription__c tmpSubs;

        //get all involved subscription ids
        for (csord__Service__c service : services) {

            //system.debug('--+ FOR service.Id: '+service.Id);
            //system.debug('--+ oldServicesMap.containsKey(service.id)? '+oldServicesMap.containsKey(service.id));
            if (oldServicesMap.containsKey(service.id)) {
                csord__Service__c oldService = oldServicesMap.get(service.id);

                if (oldService.csord__Status__c != service.csord__Status__c ||
                        oldService.csord__Activation_Date__c != service.csord__Activation_Date__c ||
                        oldService.csord__Deactivation_Date__c != service.csord__Deactivation_Date__c) { // Fix for OMB-1870

                    idsToCheck.add(service.Id);
                    if (service.csord__Service__c == null) {
                        subscriptionIds.add(service.csord__Subscription__c);
                    }
                }
            }
        }
        //system.debug('--+ subscriptionIds: '+subscriptionIds);

        // get subscriptions to check if subscribtions needed to be updated
        Map<Id, csord__Subscription__c> subscriptionMap = new Map<Id, csord__Subscription__c>();
        if (!subscriptionIds.isEmpty()) {
            subscriptionMap = new Map<Id, csord__Subscription__c>([SELECT Id, csord__Status__c FROM csord__Subscription__c WHERE Id IN :subscriptionIds]);
        }
        //system.debug('--+ subscriptionMap: '+subscriptionMap);

        for (csord__Service__c service : services) {

            //system.debug('--+ FOR service.Id: '+service.Id);
            //system.debug('--+ oldServicesMap.containsKey(service.id)? '+oldServicesMap.containsKey(service.id));
            if (oldServicesMap.containsKey(service.id)) {

                csord__Service__c oldService = oldServicesMap.get(service.id);

                if (oldService.csord__Status__c != service.csord__Status__c || oldService.csord__Activation_Date__c != service.csord__Activation_Date__c 
                    || oldService.csord__Deactivation_Date__c!=service.csord__Deactivation_Date__c) {       // Fix for OMB-1870
                    idsToCheck.add(service.Id);
                    //system.debug('--+ idsToCheck: '+idsToCheck);
                    if (service.csord__Service__c == null) {
                        //check if subscribtions needed to be updated, only if exist and have a different status
                        tmpSubs = subscriptionMap.get(service.csord__Subscription__c);
                        if (tmpSubs != null && tmpSubs.csord__Status__c != service.csord__Status__c) {

                            subsToUpdate.put(service.csord__Subscription__c, new csord__Subscription__c(id = service.csord__Subscription__c, csord__Status__c = service.csord__Status__c));
                        }
                    }
                }
            }
        }

        //system.debug('--+ subsToUpdate: '+subsToUpdate);
        if(!subsToUpdate.isEmpty())
            update subsToUpdate.values();

        //system.debug('--+ idsToCheck: '+idsToCheck);
        //system.debug('--+ idsToCheck.size(): '+idsToCheck.size());
        if (idsToCheck.size() > 0) {
            //Update Status and activation date on child services
            // Fix for OMB-1870
            List<csord__Service__c> childServicesList = [SELECT Id,LG_ServiceExternalId__c, csord__Service__r.LG_ServiceExternalId__c , LG_Address__c,  csord__Service__r.LG_DecompositionCriteria__c,csord__Status__c,csord__Service__r.LG_ProductFamily__c, csord__Activation_Date__c,csord__Deactivation_Date__c, csord__Service__r.csord__Status__c, csord__Service__r.csord__Activation_Date__c, csord__Service__r.csord__Deactivation_Date__c,UM_DependsOnService__c,LG_DependsOnSecondaryService__c
                    FROM csord__Service__c
                    WHERE csord__Service__c IN :idsToCheck];

            //Child services to update
            Map<Id, csord__Service__c> childServiceToUpdate = new Map<Id, csord__Service__c>();
		if (childServicesList != null && childServicesList.size() > 0) {
                for (csord__Service__c chService : childServicesList) {
                    //added as part of SFOM-2285
                 if (chService.csord__Status__c != chService.csord__Service__r.csord__Status__c
                      && chService.csord__Service__r.LG_DecompositionCriteria__c != 'Set 7 - JIRA Fiber' //OMB-1847
                      && (chService.csord__Service__r.LG_DecompositionCriteria__c != 'Set 20 - BDS Site Process' || (chService.csord__Service__r.LG_DecompositionCriteria__c == 'Set 20 - BDS Site Process' && (chService.UM_DependsOnService__c == null && chService.LG_DependsOnSecondaryService__c == null))) //DGT-381 finding internet serv
                       && (chService.csord__Service__r.LG_DecompositionCriteria__c != 'Set 22 - Parent/Category Only'  
                           ||((chService.csord__Service__r.LG_DecompositionCriteria__c == 'Set 22 - Parent/Category Only'|| chService.csord__Service__r.LG_DecompositionCriteria__c != 'Set 7 - JIRA Fiber') //OMB-1847)

                               && chService.csord__Activation_Date__c == chService.csord__Service__r.csord__Activation_Date__c
                               && chService.csord__Service__r.csord__Status__c=='Active'
                               ))){
                            //  && (chService.csord__Service__r.LG_ProductFamily__c!=null &&!(chService.csord__Service__r.LG_ProductFamily__c.equalsIgnoreCase('Virtual Voice'))) ) {

                        chService.csord__Status__c = chService.csord__Service__r.csord__Status__c;
                        chService.csord__Activation_Date__c = chService.csord__Service__r.csord__Activation_Date__c;
                        // below line is addedto fix OMB-1870
                        chService.csord__Deactivation_Date__c = chService.csord__Service__r.csord__Deactivation_Date__c;
                        childServiceToUpdate.put(chService.Id, chService);
                    }
                }
            }

            //system.debug('--+ childServiceToUpdate: '+childServiceToUpdate);

            if (!childServiceToUpdate.isEmpty()) {
                update childServiceToUpdate.values();
            }
        }
    }

    /**********************************************************************************************************************
      * author: Shashank Shekhar
      * Date: 2nd Aug 2016
      * Param:List<csord__Service__c> services ,map<Id,csord__Service__c> oldservicesMap
      * Return:  void
      * Description: When the Service Status on the service is changed ,the status field on service gets the same value
      * Summary of Changes : UMR-698
      **********************************************************************************************************************/
    public void updateStatusOnService() {

        //system.debug('--+ updateStatusOnService()');

        //DvtH23AUG2016 addition for the UM_CSR profile-->
        //Boolean isUM_CSR_Profile = 'UM_CSR_Profile'.equals(userProfileName);


        //  Boolean isUM_CSR_Profile = 'UM_CSR_Profile'.equals([SELECT Name FROM Profile WHERE Id = : cupId].Name);
        Schema.DescribeFieldResult fieldResult = csord__Service__c.LG_ServiceStatus__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Map<String, Integer> plOrderMap = new Map<String, Integer>();
        Integer cnt = 0;
        Integer oldIndex;
        Integer newIndex;
        for ( Schema.PicklistEntry f : ple) {
            plOrderMap.put(f.getValue(), cnt);
            cnt++;
        }
        //<--
        for (csord__Service__c service : services) {


            //system.debug('--+ service: '+service.Id);
            //system.debug('--+ oldServicesMap.containsKey(service.id): '+oldServicesMap.containsKey(service.id));
            if ( oldServicesMap.containsKey(service.id) &&
                    oldServicesMap.get(service.id).LG_ServiceStatus__c != service.LG_ServiceStatus__c ) {
                //DvtH23AUG2016 addition for the UM_CSR profile-->
                oldIndex = plOrderMap.get(oldServicesMap.get(service.id).LG_ServiceStatus__c);
                newIndex = plOrderMap.get(service.LG_ServiceStatus__c);
                if (oldIndex!=null && newIndex!=null && (oldIndex > newIndex)
                    //it should be possible to return from the Termination requested to other statuses.
                    && oldServicesMap.get(service.id).LG_ServiceStatus__c != LG_Util.getServiceRequestDeactivateStatus()) {
					if('UM_CSR_Profile'.equals(userProfileName))                    
                    service.addError(System.Label.Incorrect_status);
                } else {
                    //<--
                    if (service.LG_ServiceStatus__c != service.csord__Status__c)
                        service.csord__Status__c = service.LG_ServiceStatus__c;

                    //system.debug('--+ set csord__Status__c: '+service.csord__Status__c);
                    //DvtH23AUG2016 addition for the UM_CSR profile-->
                }

                //<--
            }
        }
    }
	
	 //SFOM-2164 - START
    public void onBeforeInsert(list<csord__Service__c> newServices){
        for(csord__service__c service : newServices){
            service.LG_ServiceStatus__c = service.csord__Status__c;
        }
    }
    //SFOM-2164 - END

    public void updateServiceStatusAfterSync() {

        //system.debug('--+ upidateServicesStatusAfterSync()');

        for (csord__Service__c service : services) {

            //system.debug('--+ FOR');
            //system.debug('--+ service.Id: '+service.Id);
            //system.debug('--+ oldServicesMap.get(service.id).csord__Status__c: '+oldServicesMap.get(service.id).csord__Status__c);
            //system.debug('--+ service.csord__Status__c: '+service.csord__Status__c);
            //system.debug('--+ oldServicesMap.containsKey(service.Id)? '+oldServicesMap.containsKey(service.Id));

            if ( ((oldServicesMap.get(service.id) != NULL && oldServicesMap.get(service.id).csord__Status__c != service.csord__Status__c)
                    || (oldServicesMap.get(service.id) == NULL))
                    && service.csord__Status__c != service.LG_ServiceStatus__c) {

                service.LG_ServiceStatus__c = service.csord__Status__c;

                //system.debug('--+ set serice.LG_ServiceStatus__c: '+service.LG_ServiceStatus__c);
            }
        }
    }

    /**********************************************************************************************************************
    * author: Shashank Shekhar
    * Date: 3rd Aug 2016
    * Param:List<csord__Service__c> services ,map<Id,csord__Service__c> oldservicesMap
    * Return:  void
    * Description: When the Service Status on the service is set to Service Active , a new contract is creatd and linked to the related subscription
    *              with Valid to and Valid from values coming from Service.
    * Summary of Changes : UMR-698
    **********************************************************************************************************************/
    public void createContractOnServiceActiveStatus() {

        //system.debug('--+ createContractOnServiceActiveStatus() ');

        list<csconta__Contract__c> lstContract = new list<csconta__Contract__c>();
        map<Id, csord__Subscription__c> map_IdSubscription = new map<Id, csord__Subscription__c>();
        set<id> set_SubsriptionIds = new set<Id>();

        for (csord__Service__c service : services) {

            //system.debug('--+ FOR service: '+service);
            if (!service.UM_GetCurrentContractTerm__c && service.csord__Subscription__c != null) {

                if (oldServicesMap.containsKey(service.id) &&
                        oldServicesMap.get(service.id).LG_ServiceStatus__c != service.LG_ServiceStatus__c &&
                        service.LG_ServiceStatus__c=='Ready for Billing' && service.csord__Service__c==NULL && service.LG_ContractTerm__c > 0){
                    set_SubsriptionIds.add(service.csord__Subscription__c);
                    csconta__Contract__c objContract = new csconta__Contract__c();
                    objContract.csconta__Valid_From__c = service.csord__Activation_Date__c;

                    if (service.LG_ContractTerm__c != null && service.csord__Activation_Date__c != null) {
                        objContract.csconta__Valid_To__c = service.csord__Activation_Date__c.addMonths(Integer.ValueOf(service.LG_ContractTerm__c));
                    }

                    objContract.csconta__Subscription__c = service.csord__Subscription__c;
                    lstContract.add(objContract);
                }
            }
        }

        //system.debug('--+ lstContract: '+lstContract);

        if (!lstContract.isEmpty()) {
            if (!set_SubsriptionIds.isEmpty()) {
                map_IdSubscription = new map<Id, csord__Subscription__c>([SELECT id, csord__Account__c, LG_Contract__c FROM csord__Subscription__c WHERE Id IN: set_SubsriptionIds]);
            }
            list<csord__Subscription__c> lstSub = new list<csord__Subscription__c>();

            for (csconta__Contract__c con : lstContract) {
                if (map_IdSubscription.containsKey(con.csconta__Subscription__c)) {
                    con.csconta__Account__c = map_IdSubscription.get(con.csconta__Subscription__c).csord__Account__c;
                }
            }
            insert lstContract;
            //system.debug('--+ insert lstContract: '+lstContract);

            if (!lstContract.isEmpty()) {
                for (csconta__Contract__c con : lstContract) 
                {
                    if(map_IdSubscription.containsKey(con.csconta__Subscription__c) && map_IdSubscription.get(con.csconta__Subscription__c).LG_Contract__c == null){
                        csord__Subscription__c sub = new csord__Subscription__c(id = con.csconta__Subscription__c);
                        sub.LG_Contract__c = con.Id;
                        lstSub.add(sub);
                    }
                }
            }

            //system.debug('--+ lstSub: '+lstSub);
            if (!lstSub.isEmpty())
                update lstSub;
        }
    }

    public void updateDependsOn(List<csord__Service__c> allServices) {
      	List<Id> servDependsOn = new List<Id>();
		for(csord__Service__c serv : allServices){
			if((serv.LG_SecondaryProductConfiguration__c != NULL && serv.LG_DependsOnSecondaryService__c == NULL) ||
            	(serv.UM_DependsOnProductConfiguration__c != NULL && serv.UM_DependsOnService__c == NULL)){
            		servDependsOn.add(serv.Id);
            }
		}
        system.debug('--+ updateDependsOn()'+servicesList);
		if(servDependsOn.isEmpty()){
			return;
		}
         servicesList = [SELECT Id, Name, LG_Address__c,LG_ServiceExternalid__c, LG_ServiceStatus__c, csord__Subscription__c, csord__Subscription__r.csord__Account__c, csord__Subscription__r.csconta__Billing_Account__c, csord__Subscription__r.LG_Address__c, csord__Subscription__r.csordtelcoa__Replaced_Subscription__r.LG_Contract__c,
                            csord__Subscription__r.csordtelcoa__Replaced_Subscription__c, csord__Subscription__r.csordtelcoa__Change_Type__c, csordtelcoa__Product_Configuration__c, csord__Status__c, csord__Subscription__r.LG_Contract__c, csord__Subscription__r.LG_Contract__r.csconta__Valid_To__c,
                            csordtelcoa__Product_Configuration__r.LG_Billing_Account__c, csord__Service__c, csordtelcoa__Replaced_Service__c, csordtelcoa__Service_Number__c, csordtelcoa__Service_Number_Sequence__c, csord__Activation_Date__c,LG_Action__c,
                            UM_GetCurrentContractTerm__c, LG_ContractStartDate__c, LG_ContractEndDate__c, LG_ContractTerm__c, UM_DependsOnService__c, UM_DependsOnProductConfiguration__c, UM_DependsOnService__r.LG_ContractEndDate__c, UM_DependsOnService__r.LG_ContractTerm__c,
                            UM_DependsOnService__r.csord__Subscription__r.LG_Contract__r.csconta__Valid_From__c, UM_DependsOnService__r.csord__Subscription__r.LG_Contract__r.csconta__Valid_To__c,csord__Subscription__r.csordtelcoa__Replacement_Subscription__r.csordtelcoa__Change_Type__c,
                            csord__Order__c,LG_RootOrder__c,csord__Service__r.UM_DependsOnService__r.csordtelcoa__Replaced_Service__c, csordtelcoa__Delta_Status__c,
                            LG_RootOrder__r.csordtelcoa__Opportunity__c, LG_RootOrder__r.csordtelcoa__Opportunity__r.um_partnerAccount__c, UM_PartnerAccount__c, csord__Subscription__r.csord__Order__c, csord__Subscription__r.csord__Order__r.csordtelcoa__Opportunity__c, csord__Subscription__r.csord__Order__r.csordtelcoa__Opportunity__r.UM_PartnerAccount__c,
                            LG_Suborder__r.csord__Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c,csordtelcoa__Replaced_Service__r.LG_ProvisioningSystem__c,csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c, csord__Service__r.LG_ServiceExternalId__c,LG_MarketSegment__c, LG_ProductFamily__c,
                            csord__Service__r.LG_DecompositionCriteria__c,LG_DecompositionCriteria__c,csordtelcoa__Product_Configuration__r.Name, LG_From_Service__c, LG_To_Service__c,csord__Service__r.LG_ProductFamily__c,csord__Service__r.csord__Activation_Date__c,csord__Service__r.csord__Status__c,
                            csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_BillingTerminateOnMove__c,LG_ProductDefinitionName__c,       //Added for OMB-1970
                            //added for SFOM-2551
                            LG_SecondaryProductConfiguration__c,LG_DependsOnSecondaryService__c,csord__Service__r.LG_SecondaryProductConfiguration__c 
                            FROM csord__Service__c
                            WHERE Id IN :servicesIds AND ((LG_SecondaryProductConfiguration__c != NULL AND LG_DependsOnSecondaryService__c = NULL) OR
                             (UM_DependsOnProductConfiguration__c != NULL AND UM_DependsOnService__c = NULL))
                            ];
        //set<Id> set_subscriptionIds = new set<Id>();
        set<Id> set_AccountIds = new set<Id>();
        list<csord__Service__c> servicesToBeUpdated = new list<csord__Service__c>();
        set<csord__Service__c> set_ServicesToBeUpdated = new set<csord__Service__c>();
        //list<csord__Subscription__c> lst_Subscription = new list<csord__Subscription__c>();
        list<csord__Service__c> lst_Service = new list<csord__Service__c>();
        System.debug('>>>TEST111'+stopTrigger);
        if (stopTrigger) return;
        System.debug('>>>TEST222');
        for (csord__Service__c s : servicesList) {
            set_AccountIds.add(s.csord__Subscription__r.csord__Account__c);
            //System.debug('>>>>>>>000000'+s.LG_SecondaryProductConfiguration__c);
        }
        // if (!set_subscriptionIds.isEmpty()) {
        //     //list<csord__Subscription__c> lst_Subscription = new list<csord__Subscription__c>([Select Id, csord__Account__c from csord__Subscription__c where Id IN: set_subscriptionIds]);
        //     lst_Subscription = [Select Id, csord__Account__c from csord__Subscription__c where Id IN: set_subscriptionIds];
        // }
        // if (!lst_Subscription.isEmpty()) {
        //
        //     for (csord__Subscription__c sub : lst_Subscription) {
        //         set_AccountIds.add(sub.csord__Account__c);
        //     }
        // }
        if (!set_AccountIds.isEmpty()) {
            //list<csord__Service__c> lst_Service = new list<csord__Service__c>([select id, csord__Subscription__c, csord__Subscription__r.csord__Account__c, UM_DependsOnProductConfiguration__c, csordtelcoa__Product_Configuration__c from csord__Service__c where  csord__Subscription__r.csord__Account__c IN: set_AccountIds]);
            lst_Service = [select id, UM_DependsOnService__c,csord__Subscription__c, LG_DependsOnSecondaryService__c,csord__Subscription__r.csord__Account__c, UM_DependsOnProductConfiguration__c, LG_SecondaryProductConfiguration__c ,csord__Service__r.LG_SecondaryProductConfiguration__c ,csordtelcoa__Product_Configuration__c from csord__Service__c where  csord__Subscription__r.csord__Account__c IN: set_AccountIds];
        }
        system.debug('lst_Service[='+lst_Service);
        if (!lst_Service.isEmpty()) {
         for (csord__Service__c newService : servicesList) {
             csord__Service__c updateMe = new csord__Service__c(id = newService.Id);
             
                for (csord__Service__c queriedService : lst_Service) 
                {
                    
                     if (newService.UM_DependsOnProductConfiguration__c == queriedService.csordtelcoa__Product_Configuration__c || newService.LG_SecondaryProductConfiguration__c == queriedService.csordtelcoa__Product_Configuration__c) 
                     {
                        if (newService.Id != queriedService.Id) 
                        {
                          // csord__Service__c updateMe = new csord__Service__c(id = newService.Id);
                        
                            if(newService.UM_DependsOnProductConfiguration__c!=null && newService.UM_DependsOnProductConfiguration__c==queriedService.csordtelcoa__Product_Configuration__c)
                            {
                                system.debug(' primary serv present');
                                updateMe.UM_DependsOnService__c = queriedService.Id;
                            }
                           if(newService.LG_SecondaryProductConfiguration__c!=null && newService.LG_SecondaryProductConfiguration__c==queriedService.csordtelcoa__Product_Configuration__c)
                           {
                                system.debug(' sec serv present');
                                updateMe.LG_DependsOnSecondaryService__c = queriedService.Id;
                            }
                            system.debug('set_ServicesToBeUpdated=='+set_ServicesToBeUpdated);
                           }
                        }
                    }
                     if (!set_ServicesToBeUpdated.contains(updateMe))
                        set_ServicesToBeUpdated.add(updateMe); 
            }
            Integer setsize = set_ServicesToBeUpdated.size();
            servicesToBeUpdated.AddAll(set_ServicesToBeUpdated);
            if (servicesToBeUpdated.size() > 0) 
            {
                stopTrigger = true;
                update servicesToBeUpdated;
            }
        }
    }
    

    public void setCloneWhenMigration()
    {
        set<Id> set_ParentService = new set<Id>();
        list<csord__Subscription__c> lstSubToBeUpdated = new list<csord__Subscription__c>();
        map<Id, csord__Service__c> mapQueriedService = new map<Id, csord__Service__c>();
    
        for (csord__Service__c ser : servicesList){
            if (ser.csord__Service__c == NULL)
                set_ParentService.add(ser.Id);
        }
        
        if (!set_ParentService.isEmpty()) {
            mapQueriedService = new map<Id, csord__Service__c>([select id, csordtelcoa__Product_Configuration__c, csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.UM_CloneWhenMigrating__c from csord__Service__c where Id IN:set_ParentService]);
            if (!mapQueriedService.isEmpty()){
                for (csord__Service__c s : servicesList){
                    if (mapQueriedService.containsKey(s.Id) && mapQueriedService.get(s.Id).csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.UM_CloneWhenMigrating__c){
                        // commented to avoid SOQL in for loop - Omkar
                        //csord__Subscription__c sub = [select Id, UM_CloneWhenMigrating__c from csord__Subscription__c where id = :s.csord__Subscription__c]; //new csord__Subscription__c(Id=s.csord__Subscription__c);
                        csord__Subscription__c sub = new csord__Subscription__c(Id = s.csord__Subscription__c,
                                                                                UM_CloneWhenMigrating__c = true);
                        //sub.UM_CloneWhenMigrating__c = true;
                        lstSubToBeUpdated.add(sub);
                    }
                }
                if (!lstSubToBeUpdated.isEmpty())
                    update lstSubToBeUpdated;
            }
        }
    }

    public void activateNumberBlocks() {
        list<csord__Service__c> activeNbrServices = new list<csord__Service__c>();

        for (csord__Service__c service : services) {
            if ((service.LG_ProductFamily__c == 'Number Range' && service.csord__Service__c != null) &&
                    ((service.csord__Status__c == 'Active' && oldServicesMap.get(service.id).csord__Status__c != 'Active')) ||
                    (service.csord__Status__c == 'Inactive' && oldServicesMap.get(service.id).csord__Status__c != 'Inactive') ||
                    (service.csord__Status__c == 'Cancelled' && oldServicesMap.get(service.id).csord__Status__c != 'Cancelled')
               ) {
                activeNbrServices.add(service);
            }
        }

        if (!activeNbrServices.isEmpty()) {
            list<UM_NumberBlock__c> nbrBlockList = [select id, UM_BillingStatus__c, UM_NumberRangeService__c, UM_NumberRangeService__r.csord__Status__c from UM_NumberBlock__c where UM_NumberRangeService__c in :activeNbrServices];
            for (UM_NumberBlock__c nb : nbrBlockList) {
                if (nb.UM_NumberRangeService__r.csord__Status__c == 'Active')
                    nb.UM_BillingStatus__c = 'Active in Billing';
                else if (nb.UM_NumberRangeService__r.csord__Status__c == 'Inactive')
                    nb.UM_BillingStatus__c = 'Not Active in Billing';
                else if (nb.UM_NumberRangeService__r.csord__Status__c == 'Cancelled')
                    nb.UM_Status__c = 'Cancelled';
            }
            update nbrBlockList;
        }
    }


    // RS: LG code not used in UM
    /**
    * Mark all subscriptions that have only SoHo Services with status "SoHo - To Be Deleted" when created
    *
    * @param  Map<Id, csord__Service__c> newMap
    * @author Petar Miletic
    * @ticket SFDT-665
    * @since  07/04/2016
    */
    /*
    public void updateSubscriptionStatus(Map<Id, csord__Service__c> newMap) {

        Set<Id> subscriptionIds = new Set<Id>();

        for (csord__Service__c s : newMap.values()) {

            // Take only top level Services
            // if (s.csord__Service__c == null && s.LG_MarketSegment__c == 'SoHo' && s.csord__Service__r.csord__Status__c != status) {
            if (s.csord__Service__c == null && s.LG_MarketSegment__c == 'SoHo') {
                subscriptionIds.add(s.csord__Subscription__c);
            }
        }

        if (!System.isFuture() && !System.isBatch()) {
            UpdateSubscriptions(subscriptionIds);
        }
    }
    */

    /**
    * Update must execute in future method because package trigger executes after this one
    *
    * @param  Set<Id> subscriptionIds
    * @author Petar Miletic
    * @ticket SFDT-749
    * @since  19/04/2016
    */
    /*
    @future
    public Static void UpdateSubscriptions(Set<Id> subscriptionIds) {

        if (subscriptionIds.size() > 0) {

            string status = 'SoHo - To Be Deleted';

            List<csord__Subscription__c> upSubscriptions = new List<csord__Subscription__c>();
            List<csord__Subscription__c> subscriptions = [SELECT Id, Name, csord__Status__c FROM csord__Subscription__c WHERE Id In :subscriptionIds];

            // Check to see if there are some services that are not SoHo
            List<csord__Service__c> childServices = [SELECT Id, csord__Subscription__c, LG_MarketSegment__c FROM csord__Service__c WHERE csord__Subscription__c In :subscriptionIds];
            for (csord__Subscription__c su : subscriptions) {

                //if (su.csord__Status__c != status && CheckChildServices(su.Id, childServices)) {
                if (CheckChildServices(su.Id, childServices)) {

                    su.csord__Status__c = status;
                    upSubscriptions.add(su);
                }
            }

            if (upSubscriptions.size() > 0) {
                update upSubscriptions;
            }
        }
    }
    */
    /*
    public Static Boolean CheckChildServices(Id subscriptionId, List<csord__Service__c> childServices) {

        Boolean retval = true;

        for (csord__Service__c s : childServices) {

            if (s.csord__Subscription__c != subscriptionId) {
                continue;
            }

            if (String.isNotBlank(s.LG_MarketSegment__c) && !s.LG_MarketSegment__c.equalsIgnoreCase('SoHo')) {
                retval = false;
            }
        }

        return retval;
    }
    */

    // RS: LG code not used in UM
    /**
    * Update provisioning Acct NO to new Services
    *
    * @author Sathya.B
    * @ticket SFOM-1130
    * @since  21/07/2017
    */
    public void updateProvisioningAcctNO()
    {
      //list<csord__Service__c> servicesLists = new list<csord__Service__c>();
      list<csord__Service__c> serviceListToUpdate = new list<csord__Service__c>();
      set<id> serviceIds=new set<id>();

        system.debug('--serv'+servicesIds );
       //servicesLists = [SELECT Id, LG_ServiceStatus__c, csord__Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c,LG_Suborder__r.id, LG_Suborder__r.LG_Termination__c,LG_ProvisioningSystem__c,LG_ProvisioningAccountNo__c,LG_Suborder__r.csord__Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c,csordtelcoa__Replaced_Service__r.LG_ProvisioningSystem__c,csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c,csordtelcoa__Replaced_Service__c from csord__Service__c where id in :servicesIds ];

       if(servicesList.size()>0)
       {
       system.debug('**entered act');
                  for(csord__Service__c serv: servicesList)
                  {
                           if(serv.LG_ProvisioningSystem__c=='CAMA')
                           {system.debug('**change type'+serv.LG_Suborder__r.csord__Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c);

                               if(LG_Util.getMigrateVarietyChangeTypes().contains(serv.csord__Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c))
                               {
                                   if(serv.csordtelcoa__Replaced_Service__r!=null && serv.csordtelcoa__Replaced_Service__r.LG_ProvisioningSystem__c=='CAMA' && serv.LG_ProvisioningSystem__c=='CAMA')
                                   {
                                    if(serv.csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c!=null){
                                       serv.LG_ProvisioningAccountNo__c=serv.csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c;

                                        }
                                   }

                               }
                               else if(serv.csord__Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c=='Move')
                               {    system.debug('**its move');
                                     if(serv.LG_Suborder__r.LG_Termination__c==true)
                                     {
                                         if(serv.csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c!=null)
                                         {system.debug('**entered into move');
                                           serv.LG_ProvisioningAccountNo__c=serv.csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c;
                                           system.debug('**update'+serv.LG_ProvisioningAccountNo__c);
                                         }

                                     }

                               }
                               else if(serv.csord__Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c=='Change')
                               {
                                    if(serv.csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c!=null)
                                         {
                                           serv.LG_ProvisioningAccountNo__c=serv.csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c;
                                         }
                               }

                               serviceListToUpdate.add(serv);
               }

              }

       }

       if(serviceListToUpdate.size()>0)
       {
        Update serviceListToUpdate ;
       }






    }







    /**
    * Update Solution to Complete once all service status set Actvie/Inactive
    *
    * @author Sathya.B
    * @ticket SFOM-820
    * @since  30/06/2017
    */
    public Void UM_updateSoltuionToComplete() {

        list<csord__Solution__c> solutionList = new list<csord__Solution__c>();
        list<csord__Solution__c> solutionListToUpdate = new list<csord__Solution__c>();
        set<id> solutionIds = new set<id>();
        boolean allServiceStatusSet;
        boolean notallSeriveStatusSet = false;

        for (csord__Service__c ser : services) {

            if (ser.LG_ServiceStatus__c != null && (ser.LG_ServiceStatus__c == 'Active' || ser.LG_ServiceStatus__c == 'Inactive')  && oldServicesMap.containsKey(ser.id) && (oldServicesMap.get(ser.id).LG_ServiceStatus__c != ser.LG_ServiceStatus__c)  ) {
                solutionIds.add(ser.LG_Suborder__c);
            }

        }
        if (!solutionIds.isEmpty()) {
            solutionList = [SELECT Id, csord__Status__c,
                            (SELECT id, LG_ServiceStatus__c from Services__r )
                            FROM csord__Solution__c
                            where id in :solutionIds ];
        }

        if (solutionList.size() > 0) {

            for (csord__Solution__c sol : solutionList ) {

                if (sol.Services__r.size() > 0) {

                    for (csord__Service__c servi : sol.Services__r) {

                        if (servi.LG_ServiceStatus__c == 'Active' || servi.LG_ServiceStatus__c == 'Inactive') {
                            allServiceStatusSet = true;
                        } else {
                            notallSeriveStatusSet = true;
                        }

                    }

                }
                if (allServiceStatusSet == true && notallSeriveStatusSet == false) {
                    sol.csord__Status__c = 'Complete';
                    solutionListToUpdate.add(sol);
                }
            }
        }

        if (solutionListToUpdate.size() > 0) {
            Update solutionListToUpdate;

        }
    }
    /**
    * Entitlement Records - to  linked to the service when SLA is updated on the service
    *
    * @author Apurva_Srivastava
    * @ticket SFOM-1099
    * @since  01/08/2017
    */
    public Void UM_updateEntitlementToSLA() {
        System.debug('----------------');
        Set<Id> changedSLAServie = new Set<Id> ();
        for (csord__Service__c newService : services) {
        System.debug('---------Condition-------'+ !oldServicesMap.containsKey(newService.id));
             if ((oldServicesMap.containsKey(newService.id)
                 && oldServicesMap.get(newService.id).LG_SLA__c != newService.LG_SLA__c)
                 || !oldServicesMap.containsKey(newService.id)
             ) {
                changedSLAServie.add(newService.Id);
             }
        }System.debug('---------changedSLAServie-------'+ changedSLAServie);
        if (!changedSLAServie.isEmpty()) {
            System.debug('----------------'+ changedSLAServie);
            LG_Care_CreateEntitlementRecord entitlementRecordObject = new LG_Care_CreateEntitlementRecord();
            entitlementRecordObject.linkServiceTypeToEntitlement(changedSLAServie);
        }
    }

    /**
     * Build UI + process test (OMB-125 Complex change)
     *
     * For code coverage run: LG_ComplexChangeUtilTest
     *
     * @author Petar Miletic
     * @ticket SFOM-431, SFOM-540
     * @since  03/03/2017
    */
    public static void setVersionData(Map<Id, csord__Service__c> services, Map<Id, csord__Service__c> oldServices) {

        Set<Id> serviceIds = new Set<Id>();

        // Compare to check if versioning is needed
        for (csord__Service__c newService : services.values()) {

            csord__Service__c old = oldServices.get(newService.Id);

            if (newService.LG_RootOrder__c != old.LG_RootOrder__c) {
                serviceIds.add(newService.Id);
            }
        }
        System.debug('Service Ids are' + serviceIds);
        // Just return if empty
        if (serviceIds.isEmpty()) {
            return;
        }

        // Set of replaced PC Ids
        Set<Id> replacedProductConfigurations = new Set<Id>();

        // Check only those that have replaced info
        List<csord__Service__c> objs = [SELECT Id, 
                                            Name,
                                            csord__Order__c,
                                            LG_SoftDeleted__c,
                                            csord__Order__r.LG_SoftDeleted__c,
                                            csord__Order__r.LG_NewOrderVersion__c,
                                            csord__Order__r.LG_PreviousOrderVersion__c,
                                            csord__Order__r.csord__Primary_Order__r.id,
                                            csord__Order__r.csord__Primary_Order__r.LG_SoftDeleted__c,
                                            csord__Order__r.csord__Primary_Order__r.LG_NewOrderVersion__c,
                                            csord__Order__r.csord__Primary_Order__r.LG_PreviousOrderVersion__c,  
											csord__Order__r.csordtelcoa__Opportunity__c,											
                                            LG_RootOrder__r.Id,
                                            LG_RootOrder__r.LG_SoftDeleted__c,
                                            LG_RootOrder__r.LG_NewOrderVersion__c,
                                            LG_RootOrder__r.LG_PreviousOrderVersion__c,
                                            LG_RootOrder__r.csord__Primary_Order__r.id,
                                            LG_RootOrder__r.csord__Primary_Order__r.LG_SoftDeleted__c,
                                            LG_RootOrder__r.csord__Primary_Order__r.LG_NewOrderVersion__c,
                                            LG_RootOrder__r.csord__Primary_Order__r.LG_PreviousOrderVersion__c,  
											LG_RootOrder__r.csordtelcoa__Opportunity__c,
                                            csordtelcoa__Product_Configuration__c,
                                            csordtelcoa__Product_Configuration__r.csordtelcoa__Replaced_Product_Configuration__c,
                                            csord__Subscription__c,
                                            csord__Subscription__r.csordtelcoa__Replaced_Subscription__c, 
                                            csord__Subscription__r.csordtelcoa__Replacement_Subscription__c
                                            FROM csord__Service__c 
                                            WHERE Id IN :services.keySet() AND csordtelcoa__Product_Configuration__r.csordtelcoa__Replaced_Product_Configuration__c != null];

        if (!objs.isEmpty()) {

            Set<Id> matchedProductConfigurationIds = new Set<Id>();

            // Get old Product Configuration Ids
            for (csord__Service__c obj : objs) {
                replacedProductConfigurations.add(obj.csordtelcoa__Product_Configuration__r.csordtelcoa__Replaced_Product_Configuration__c);
            }

            // Get Old data
            List<csord__Service__c> oldObjs = [SELECT Id, 
                                                    Name,
                                                    csord__Order__c,
                                                    csord__Order__r.LG_SoftDeleted__c,
                                                    csord__Order__r.LG_NewOrderVersion__c,
                                                    csord__Order__r.LG_PreviousOrderVersion__c,
                                                    csord__Order__r.csordtelcoa__Opportunity__c,
                                                    csord__Order__r.csord__Primary_Order__r.id,
                                                    csord__Order__r.csord__Primary_Order__r.LG_SoftDeleted__c,
                                                    csord__Order__r.csord__Primary_Order__r.LG_NewOrderVersion__c,
                                                    csord__Order__r.csord__Primary_Order__r.LG_PreviousOrderVersion__c,
                                                    LG_RootOrder__r.Id,
													LG_RootOrder__r.LG_SoftDeleted__c,
                                                    LG_RootOrder__r.LG_NewOrderVersion__c,
                                                    LG_RootOrder__r.LG_PreviousOrderVersion__c,
                                                    LG_RootOrder__r.csordtelcoa__Opportunity__c,
                                                    LG_RootOrder__r.csord__Primary_Order__r.id,
                                                    LG_RootOrder__r.csord__Primary_Order__r.LG_SoftDeleted__c,
                                                    LG_RootOrder__r.csord__Primary_Order__r.LG_NewOrderVersion__c,
                                                    LG_RootOrder__r.csord__Primary_Order__r.LG_PreviousOrderVersion__c,
                                                    csordtelcoa__Product_Configuration__c,
                                                    csordtelcoa__Replacement_Service__c,
                                                    csord__Subscription__c,
                                                    csord__Subscription__r.csordtelcoa__Replaced_Subscription__c, 
                                                    csord__Subscription__r.csordtelcoa__Replacement_Subscription__c 
                                                    FROM csord__Service__c 
                                                    WHERE csordtelcoa__Product_Configuration__c IN :replacedProductConfigurations AND csord__Order__c != null];

            // Map for storing Orders that require update
            Map<Id, csord__Order__c> orders = new Map<Id, csord__Order__c>();

            // For every service check older ones
            for (csord__Service__c obj : objs) {

                for (csord__Service__c oldObj : oldObjs) {

                    // Avoid unnecessary loops
                    if (obj.LG_RootOrder__r.LG_PreviousOrderVersion__c != null && oldObj.LG_RootOrder__r.LG_NewOrderVersion__c != null) {
                        continue;
                    }

                    /**
		           * Circular dependency fix
		           *
		           * @author Petar Miletic
		           * @ticket OMB-1086
		           * @since  25/09/2017
		          */
              //OMB-1711
                    if (obj.LG_RootOrder__r.LG_PreviousOrderVersion__c == oldObj.LG_RootOrder__r.LG_NewOrderVersion__c && 
                        obj.LG_RootOrder__r.LG_SoftDeleted__c == oldObj.LG_RootOrder__r.LG_SoftDeleted__c && 
                        oldObj.LG_RootOrder__r.LG_SoftDeleted__c == true && 
                        obj.LG_RootOrder__r.LG_SoftDeleted__c == false) 
                        {
		            continue;
		          }

                    csord__Order__c ord = obj.LG_RootOrder__r;
                    csord__Order__c rootOrd = obj.csord__Order__r.csord__Primary_Order__r;
                    ord.LG_SoftDeleted__c = false;

                    csord__Order__c oldOrd = oldObj.csord__Order__r;
                    csord__Order__c oldOrdRoot = oldObj.LG_RootOrder__r;
                    oldOrd.LG_SoftDeleted__c = true;
                    oldOrdRoot.LG_SoftDeleted__c = true; 

                    // If configurations are the same then Orders must be connected as well
                    if (obj.csordtelcoa__Product_Configuration__r.csordtelcoa__Replaced_Product_Configuration__c == oldObj.csordtelcoa__Product_Configuration__c) {

                        // Used on old and new. It will be the bassis for cleanup
                        matchedProductConfigurationIds.add(oldObj.csordtelcoa__Product_Configuration__c);

                        ord.LG_PreviousOrderVersion__c = oldOrd.Id;
                        oldOrd.LG_NewOrderVersion__c = ord.Id;
                        
                        rootOrd.LG_PreviousOrderVersion__c = oldOrdRoot.Id;
                        oldOrdRoot.LG_NewOrderVersion__c = rootOrd.Id;

                        /**
                         * Status of the previous order should
                         * change to Change Confirmed when Complex change is performed
                         *
                         * @author Petar Miletic
                         * @ticket SFOM-624
                         * @since  20/04/2017
                        */
                        oldOrd.csord__Status2__c = 'Change Confirmed';
                        oldOrdRoot.csord__Status2__c = 'Change Confirmed';

                        orders.put(ord.Id, ord);
                        orders.put(oldOrd.Id, oldOrd);
                        orders.put(oldOrdRoot.Id, oldOrdRoot);
                        orders.put(rootOrd.Id, rootOrd);
                    }
                }
            }

            if (!orders.isEmpty()) {

                update orders.values();
            }

            /**
             * Add "Consolidate Numbers" logic to Submit/Decompose
             *
             * @author Petar Miletic
             * @ticket SFOM-500
             * @since  27/03/2017
            */
            cleanupAssetsAndProcesses(matchedProductConfigurationIds);
        }
    }



    /**
     * Add "Consolidate Numbers" logic to Submit/Decompose
     *
     * @author Petar Miletic
     * @ticket SFOM-500
     * @since  27/03/2017
    */
    private static void cleanupAssetsAndProcesses(Set<Id> matchedProductConfigurationIds) {

        List<Asset> assets = [SELECT Id, Name,
                              LG_SoftDeleted__c
                              FROM Asset
                              WHERE LG_TelephonyProductConfiguration__c IN :matchedProductConfigurationIds];

        if (assets.isEmpty()) {
            return;
        }

        for (Asset obj : assets) {
            obj.LG_SoftDeleted__c = true;
        }

        update assets;
    }

    // This method helps to send individual child service items to Kenan and get the Kenan Id back. Also terminate either child or parent with child services.
    public static boolean isParentProcessed = false;
    public static boolean isChildProcessed = false;

    public void hpbxSyncWithKenan()
    {
        list<csord__Service__c> childServicesList = new list<csord__Service__c>();
        list<csord__Service__c> parentServicesList = new list<csord__Service__c>();
        for(csord__Service__c s : services)
        {
            system.debug('s.csord__Status__c----->'+s.csord__Status__c);
            system.debug('service data----->'+s);
            //system.debug('oldServicesMap----->'+oldServicesMap);
            
            if(s.csord__Service__c != null && s.LG_MarketSegment__c != 'SoHo' 
                && s.LG_ProductFamily__c != null && (s.LG_ProductFamily__c.equalsIgnoreCase('Virtual Voice') || s.LG_ProductFamily__c.equalsIgnoreCase('Virtual Phone') || s.LG_ProductFamily__c.equalsIgnoreCase('BDS'))
                && s.csord__Status__c == 'Ready for Billing' && oldServicesMap.containsKey(s.id)
                && oldServicesMap.get(s.id).csord__Status__c != 'Ready for Billing' && (s.csordtelcoa__Delta_Status__c == null || s.csordtelcoa__Delta_Status__c == 'Add' || s.csordtelcoa__Delta_Status__c == 'Terminate' || s.csordtelcoa__Delta_Status__c == 'Added To Subscription') 
                    )
                    {
                childServicesList.add(s);
            }
            
            if(s.csord__Service__c == null && s.LG_MarketSegment__c != 'SoHo' 
                && s.LG_ProductFamily__c != null && (s.LG_ProductFamily__c.equalsIgnoreCase('Virtual Voice')|| s.LG_ProductFamily__c.equalsIgnoreCase('Virtual Phone')|| s.LG_ProductFamily__c.equalsIgnoreCase('BDS'))
                && (s.csordtelcoa__Delta_Status__c == 'Terminate' || s.csordtelcoa__Delta_Status__c == 'Modify'))
				{
                parentServicesList.add(s);
            }

            //SFOM-2285
            if(s.csord__Service__c != null && s.csord__Status__c == 'Ready for Billing'
                && oldServicesMap.containsKey(s.id)
                && oldServicesMap.get(s.id).csord__Status__c != 'Ready for Billing'
                && newServicesMap.containsKey(s.Id)
                && newServicesMap.get(s.Id).csord__Service__r.LG_ProductFamily__c != null
                //added as part of oMB-1847
                && (newServicesMap.get(s.Id).csord__Service__r.LG_ProductFamily__c.equalsIgnoreCase('Company Fiber') || newServicesMap.get(s.Id).csord__Service__r.LG_ProductFamily__c.equalsIgnoreCase('Virtual Voice') || newServicesMap.get(s.Id).csord__Service__r.LG_ProductFamily__c.equalsIgnoreCase('Virtual Phone') ||newServicesMap.get(s.Id).csord__Service__r.LG_ProductFamily__c.equalsIgnoreCase('BDS'))
                && (newServicesMap.get(s.Id).csord__Service__r.LG_DecompositionCriteria__c == 'Set 22 - Parent/Category Only' ||  newServicesMap.get(s.Id).csord__Service__r.LG_DecompositionCriteria__c == 'Set 7 - JIRA Fiber')
                && newServicesMap.get(s.Id).csord__Service__r.LG_ServiceExternalId__c != null){
                childServicesList.add(s);
            }
        }
        
        if(!childServicesList.isEmpty())
        {
            string queryForBatch = 'SELECT Id, csord__Activation_Date__c,csord__Deactivation_Date__c,csord__Service__r.LG_DecompositionCriteria__c,LG_DecompositionCriteria__c, csord__Service__r.csord__Service__c,csord__Service__r.csord__Activation_Date__c,csord__Status__c, LG_ServiceStatus__c, csordtelcoa__Delta_Status__c,'+
                                            '(SELECT Id,csordtelcoa__Line_Item_Reference_Id__c,csordtelcoa__Delta_Status__c,csord__Service__r.csord__Subscription__c,'+
                                            'UM_Price_Override__c ,csord__Service__c, UM_ServiceItemType__c,'+
                                            'UM_KenanServiceLineId__c,csord__Service__r.csord__Service__c,csord__Line_Description__c,'+
                                            'csord__Service__r.csordtelcoa__Service_Number__c,LG_BillingProductId__c,UM_BillingProductId__c,'+
                                            'csord__Total_Price__c, UM_NumberOfUnits__c, UM_UnitType__c,csord__Is_Recurring__c,'+
                                            'csord__Discount_Value__c,csord__Discount_Type__c,UM_DiscountEndDate__c,'+
                                            'csord__Discounted_Amount__c, UM_ContractId__c,UM_RecurringPriceDiscount__c, '+
                                            'UM_OneOffPriceDiscount__c,Do_Not_Sync_with_Billing__c'+
                                        ' FROM csord__Service_Line_Items__r ORDER BY csord__Service__c)'+
                                    ' FROM csord__Service__c '+
                                    ' WHERE csord__Service__r.LG_ServiceExternalId__c <> null AND Id IN: records';

            if(!LG_ServiceTriggerHandler.isChildProcessed){
                Id batchJobId = Database.executeBatch(new UM_KenanSyncBatch(childServicesList, queryForBatch, 'UM_ServiceHPBX_MACD'), 1);
                LG_ServiceTriggerHandler.isChildProcessed = true;
            }
            system.debug('LG_ServiceTriggerHandler.isChildProcessed----->'+LG_ServiceTriggerHandler.isChildProcessed);
        }

        if(!parentServicesList.isEmpty())
        {
            string queryForBatch = 'SELECT Id, LG_ServiceExternalId__c, csord__Service__c, csord__Subscription__c, csordtelcoa__Delta_Status__c,'+
                                    'csord__Status__c, LG_ServiceStatus__c, csord__Deactivation_Date__c, UM_SubscriberName__c, UM_PhoneExtension__c' +
                                    ' FROM csord__Service__c '+
                                    ' WHERE LG_ServiceExternalId__c <> null AND Id IN: records';

            if(!LG_ServiceTriggerHandler.isParentProcessed){
                Id batchJobId = Database.executeBatch(new UM_KenanSyncBatch(parentServicesList, queryForBatch, 'UM_ServiceHPBX_MACD'), 1);
                LG_ServiceTriggerHandler.isParentProcessed = true;
            }
            system.debug('LG_ServiceTriggerHandler.isParentProcessed----->'+LG_ServiceTriggerHandler.isParentProcessed);
        }
        
        
        //added as part of SFOM-2285 starts

        list<csord__Service__c> childSerList = new list<csord__Service__c>();
        list<csord__Service__c> parentSerList = new list<csord__Service__c>();
        list<csord__Service__c> childWithParentList = new list<csord__Service__c>();
        list<csord__Service__c> childServiceWithRFB = new list<csord__Service__c>();
        Map<id,csord__Service__c> unbilledParentService=new Map<id,csord__Service__c> ();
             system.debug('in partial sync');
		if (!servicesIds.isEmpty()) {
                servicesList = [SELECT Id, Name, LG_Address__c,LG_ServiceExternalid__c, LG_ServiceStatus__c, csord__Subscription__c, csord__Subscription__r.csord__Account__c, csord__Subscription__r.csconta__Billing_Account__c, csord__Subscription__r.LG_Address__c, csord__Subscription__r.csordtelcoa__Replaced_Subscription__r.LG_Contract__c,
                            csord__Subscription__r.csordtelcoa__Replaced_Subscription__c, csord__Subscription__r.csordtelcoa__Change_Type__c, csordtelcoa__Product_Configuration__c, csord__Status__c, csord__Subscription__r.LG_Contract__c, csord__Subscription__r.LG_Contract__r.csconta__Valid_To__c,
                            csordtelcoa__Product_Configuration__r.LG_Billing_Account__c, csord__Service__c, csordtelcoa__Replaced_Service__c, csordtelcoa__Service_Number__c, csordtelcoa__Service_Number_Sequence__c, csord__Activation_Date__c,LG_Action__c,
                            UM_GetCurrentContractTerm__c, LG_ContractStartDate__c, LG_ContractEndDate__c, LG_ContractTerm__c, UM_DependsOnService__c, UM_DependsOnProductConfiguration__c, UM_DependsOnService__r.LG_ContractEndDate__c, UM_DependsOnService__r.LG_ContractTerm__c,
                            csord__Service__r.UM_DependsOnService__c,UM_DependsOnService__r.csord__Subscription__r.LG_Contract__r.csconta__Valid_From__c, UM_DependsOnService__r.csord__Subscription__r.LG_Contract__r.csconta__Valid_To__c,csord__Subscription__r.csordtelcoa__Replacement_Subscription__r.csordtelcoa__Change_Type__c,
                            csord__Order__c, LG_RootOrder__c, LG_RootOrder__r.csordtelcoa__Opportunity__c, LG_RootOrder__r.csordtelcoa__Opportunity__r.um_partnerAccount__c, UM_PartnerAccount__c, csord__Subscription__r.csord__Order__c, csord__Subscription__r.csord__Order__r.csordtelcoa__Opportunity__c, csord__Subscription__r.csord__Order__r.csordtelcoa__Opportunity__r.UM_PartnerAccount__c,
                            LG_Suborder__r.csord__Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c,csordtelcoa__Replaced_Service__r.LG_ProvisioningSystem__c,csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c, csord__Service__r.LG_ServiceExternalId__c,LG_MarketSegment__c, LG_ProductFamily__c,
                            csord__Service__r.LG_DecompositionCriteria__c ,csordtelcoa__Product_Configuration__r.Name,csord__Service__r.UM_DependsOnService__r.csordtelcoa__Replaced_Service__c, LG_From_Service__c, LG_To_Service__c,csord__Service__r.LG_ProductFamily__c,csord__Service__r.csord__Activation_Date__c,csord__Service__r.csord__Status__c
                            FROM csord__Service__c
                            WHERE Id IN :servicesIds];


		}
		System.debug('>>>>ServicesList>>>'+servicesIds.size());
        for(csord__Service__c s : servicesList)
        {
          
            system.debug('s.csord__Status__c----->'+s.csord__Status__c);
            system.debug('service data----->'+s.id+'==' +s.csord__Service__c+'=='+ s.LG_MarketSegment__c+'=='+s.csord__Service__r.LG_ProductFamily__c+'=='+s.csord__Status__c);
            system.debug('child pf----->'+s.LG_ProductFamily__c+'==parent pf==' +s.csord__Service__r.LG_ProductFamily__c);
        
            if(s.csord__Service__c != null && s.LG_MarketSegment__c != 'SoHo'
                && s.csord__Service__r.LG_ProductFamily__c!=null && (s.csord__Service__r.LG_ProductFamily__c.equalsIgnoreCase('Virtual Voice')|| s.csord__Service__r.LG_ProductFamily__c.equalsIgnoreCase('Virtual Phone')|| s.csord__Service__r.LG_ProductFamily__c.equalsIgnoreCase('BDS')||s.csord__Service__r.LG_ProductFamily__c.equalsIgnoreCase('Company Fiber'))
                && s.csord__Status__c == 'Activation Completed'
                && oldServicesMap.containsKey(s.id) && oldservicesMap.get(s.id).csord__Status__c != 'Activation Completed'
                     ){
                childSerList.add(s);
            }

            if(s.csord__Service__c == null && s.LG_MarketSegment__c != 'SoHo'
                && s.LG_ProductFamily__c != null && (s.LG_ProductFamily__c.equalsIgnoreCase('Virtual Voice') || s.LG_ProductFamily__c.equalsIgnoreCase('Virtual Phone') ||s.LG_ProductFamily__c.equalsIgnoreCase('BDS')||s.LG_ProductFamily__c.equalsIgnoreCase('Company Fiber'))&& s.LG_ServiceExternalId__c==null
                ){
                parentSerList.add(s);
            }
        }
            system.debug('childServicesList.size=='+childServicesList.size());
            system.debug('parentServicesList.size=='+parentServicesList.size());

        
        if(!childSerList.isEmpty())
        {
        set<Id> unbilledParentServiceIds = new set<Id>();
    
        for(csord__Service__c s : childSerList)
        {
            system.debug('service data childServicesList---->'+s);
            //check if the parent is sent for billing or not. If not then add both child and parent to the list.
            if(s.csord__Service__r.LG_ServiceExternalId__c==null){
                unbilledParentServiceIds.add(s.csord__Service__c);	
                unbilledParentService.put(s.csord__Service__c,s);//parent id and the child service
                }
        }  
        
        List<csord__Service__c> parentServiceToUpdate=new  List<csord__Service__c>();              
        system.debug('unbilledParentServi=='+unbilledParentService);
        List<csord__Service__c> parentService=[select id, csord__Activation_Date__c,LG_DecompositionCriteria__c ,csord__Status__c from csord__Service__c where Id IN:unbilledParentServiceIds];

        if (!parentService.isEmpty()) {

        for (csord__Service__c parentSer : parentService) {
                        csord__Service__c ser= unbilledParentService.get(parentSer.id);
                        parentSer.csord__Activation_Date__c = ser.csord__Activation_Date__c;
                        // fix for bhp-177
                        if (parentSer.csord__Status__c != 'Ready for Billing') {
                          parentSer.csord__Status__c = 'Activation Completed';
                        }
                        parentServiceToUpdate.add(parentSer);               
        }
        }  
        if (!parentServiceToUpdate.isEmpty()) {
        update  parentServiceToUpdate;
        }
        }

               //added as part of SFOM-2285 ends

    }
    
    // This method update the service and subscription status to Inactive from Closed Replaced
    public void updateSubscStatusToInactive()
    {
    	Set<Id> subScriptionIds = new Set<Id>();
    	List<csord__Subscription__c> subsToUpdate = new List<csord__Subscription__c>();
    	for(csord__Service__c serv : services){
    		if(serv.LG_ServiceStatus__c == 'Inactive'){
    			subScriptionIds.add(serv.csord__Subscription__c);
    		}
    	}
    	if(!subScriptionIds.isEmpty()){
    		for(csord__Subscription__c sub : 
    		[
    			SELECT Id, csord__Status__c,
    				(SELECT Id, LG_ServiceStatus__c FROM csord__Services__r) 
    			FROM csord__Subscription__c 
    			WHERE Id IN:subScriptionIds
    		]){
    			Boolean isActiveServiceExist = false;
    			if(sub.csord__Status__c != 'Inactive'){
    				for(csord__Service__c serv : sub.csord__Services__r){
    					if(serv.LG_ServiceStatus__c != 'Inactive'){
    						isActiveServiceExist = true;
    						break;
    					}
    				}
    				if(!isActiveServiceExist){
    					sub.csord__Status__c = 'Inactive';
    					subsToUpdate.add(sub);
    				}
    			}
    		}
    		if(!subsToUpdate.isEmpty()){
    			update subsToUpdate;
    		}
    	}
    }
    	
    //OMB-1970 - Start
    public void onBeforeUpdate(list<csord__service__c> newServices, map<id,csord__Service__c> oldServices){
        revertStatusIfMove(newServices,oldServices);
    }

    private void revertStatusIfMove(list<csord__service__c> newServices, map<id,csord__Service__c> oldServices){
        map<id,csord__Service__c> serviceMap = new map<id,csord__Service__c>([select id,csordtelcoa__Replacement_Service__r.csord__Subscription__r.csordtelcoa__Change_Type__c from csord__Service__c where id in :newServices]);
        for(csord__Service__c service : newServices){
            if(service.csord__Status__c=='Closed Replaced' &&
                service.csord__Deactivation_Date__c==null &&
                oldServices.get(service.id).csord__Status__c!='Closed Replaced' &&
                serviceMap.get(service.id).csordtelcoa__Replacement_Service__r!=null &&
                serviceMap.get(service.id).csordtelcoa__Replacement_Service__r.csord__Subscription__c!=null &&
                serviceMap.get(service.id).csordtelcoa__Replacement_Service__r.csord__Subscription__r.csordtelcoa__Change_Type__c=='Move'){

                    service.csord__status__c=oldServices.get(service.id).csord__Status__c;
            }

        }
    }
    // OMB-1970 - End
	/**
     * LG_RootOrder__c lookup field should be populated before insert with the service.csord_Order_r.csord_Primary_Order_c field value. 
     * (This should be the first thing done before service insert)
     *
     * @author Anthony Arockiam
     * @ticket SFOM-2378
     * @since 24/01/2018
    */
    public static void setRootOrder(List<csord__Service__c> objs) {
        
        Set<Id> orderIds = new Set<Id>();
        
        for (csord__Service__c obj :objs) {
            
            if (obj.LG_RootOrder__c == null && obj.csord__Order__c != null) {
                orderIds.add(obj.csord__Order__c);
            }
        }
        
        if (!orderIds.isEmpty()) {
            
            Map<Id, csord__Order__c> orders = new Map<Id, csord__Order__c>([SELECT Id, Name, 
                                                                                csord__Primary_Order__c 
                                                                            FROM csord__Order__c
                                                                            WHERE Id IN :orderIds AND csord__Primary_Order__c != null]);
                                                                            
            for (csord__Service__c obj :objs) {
                
                if (orders.containsKey(obj.csord__Order__c)) {
                    
                    csord__Order__c o = orders.get(obj.csord__Order__c);
                    
                    obj.LG_RootOrder__c = o.csord__Primary_Order__c;
                }
            }
        }
    }
    
    
    
    /**
     * 
     * Subscription should become active only if all the related services are active
     * @author Alisha
     * @ticket  OMB-1847 
     * @since 19/02/2018
    */
     public Void UM_updateSubscriptionToActive() {
        list<csord__Subscription__c> subsList = new list<csord__Subscription__c>();
        list<csord__Subscription__c> subsListToUpdate = new list<csord__Subscription__c>();
        set<id> subsIds = new set<id>();
        boolean allServiceStatusSet;
        boolean notallServiceStatusSet = false;
        for (csord__Service__c ser : services) {
            if (ser.LG_ServiceStatus__c != null && (ser.LG_ServiceStatus__c == 'Active' )  && oldServicesMap.containsKey(ser.id) && (oldServicesMap.get(ser.id).LG_ServiceStatus__c != ser.LG_ServiceStatus__c)  ) {
                subsIds.add(ser.csord__Subscription__c);
            }
        }
       if (!subsIds.isEmpty()) {
            subsList = [SELECT Id, csord__Status__c,
                        (SELECT id, LG_ServiceStatus__c from  csord__Services__r )
                        FROM csord__Subscription__c
                        where id in :subsIds ];
       }
        if(subsList.size()>0)
        {
          for (csord__Subscription__c sb : subsList )
          {
            if (sb.csord__Services__r.size() > 0)
            {
                for (csord__Service__c servi : sb.csord__Services__r)
                {
                    if (servi.LG_ServiceStatus__c == 'Active') {
                        allServiceStatusSet = true;
                    } else {
                        notallServiceStatusSet = true;
                    }
                }
            }
            if (allServiceStatusSet == true && notallServiceStatusSet == false)
            {
                sb.csord__Status__c = 'Active';
                subsListToUpdate.add(sb);
            }
        }
    }
        if (subsListToUpdate.size() > 0) {
            Update subsListToUpdate;
        }
    }
    
}
