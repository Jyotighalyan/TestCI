/**
 * Used as a controller for UM_MACDConfigurationController VF page.
 *
 * @author Tomislav Blazek
 * @ticket SFDT-204
 * @since  22/02/2016
 */
public with sharing class UM_MACDConfigurationController extends LG_MACDConfigurationController implements LG_MACDConfigurationInterface {

    public UM_AddressResponse.OptionalsJson moveSite {get; set;}
    public static String oppPartnerAccount;
    //SFOM-1097 - Map modified from String to csord__Service__c
    public Map<Id, csord__Service__c> subsToServiceMap {get; set;}
    public String moveSiteJson  {
        get {
            return JSON.serialize(moveSite);
        }
        set;
    }
    public String moveSiteCaption {
        get {
            return moveSite != null ? moveSite.selectedAddressDisplay : '';
        }
        set;
    }

    public UM_MACDConfigurationController getPageController()
    {
        return this;
    }

    public UM_MACDConfigurationController() {
    }

    private void prepareSubscriptions(){
        subscriptions = new List<csord__Subscription__c>();

        List<csord__Subscription__c> tempSubs = [SELECT Id, Name,csord__Order__c,csord__Order__r.csordtelcoa__Opportunity__c,
                                                 csord__Order__r.csordtelcoa__Opportunity__r.UM_PartnerAccount__c, LG_Address__c, LG_Address__r.Id,
                                                 (SELECT Id,
                                                                         Name, csord__Service__c, csord__Service__r.LG_ProvisioningSystem__c,csordtelcoa__Service_Number__c,csord__Subscription__c,
                                                                         LG_MarketSegment__c,LG_ProvisioningSystem__c,
                                                  csordtelcoa__Product_Configuration__c,
                                                  csordtelcoa__Product_Configuration__r.LG_InstallationWishDate__c,
                                                  csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__c,
                                                  csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_Discontinued__c
                                                  FROM csord__Services__r)
                                                 FROM csord__Subscription__c
                                                 WHERE csord__Account__c = :accountId
                                                                           AND csord__Status__c NOT IN :LG_Util.getOSStatusesNotAllowingChange()
                                                                           AND csordtelcoa__Closed_Replaced__c = false
                                                                                                                 AND LG_Address__c != null
                                                                                                                 //BHP-16
                                                                                                                 AND Name NOT IN ('Virtual Phone Dienste','Virtual Phone Dienstleistungen')
                                                                                                                 ORDER BY CreatedDate DESC];
        boolean isMacdable;
                subsToServiceMap = new Map<Id, csord__Service__c>();
        for (csord__Subscription__c sub : tempSubs) {
            isMacdable = true;

            if (sub.csord__Services__r.isEmpty()) {
                isMacdable = false;
            }

            for (csord__Service__c service : sub.csord__Services__r) {
                //Soho is not MACDable
                if (service.LG_MarketSegment__c == 'Soho') {
                    isMacdable = false;
                } else {
                    //Services with no Prodconfs or with ProdConfs that don't have Prod Defs, are not macdable
                    if (service.csordtelcoa__Product_Configuration__c == null
                        || service.csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__c == null) {
                        isMacdable = false;
                    }
                }

                //As part of BU-78
                // code fix for OMB-1856 starts and ends in next line-RC added condition
                if(sub.id == service.csord__Subscription__c && service.csord__Service__c == null) {
                  subsToServiceMap.put(sub.id, service);
                }
                System.debug('subsToServiceMap' + subsToServiceMap);
                //no need for further iteration
                if (!isMacdable) {
                    break;
                }
            }

            if (isMacdable) {
                subscriptions.add(sub);
            }
        }
    }

    /**
     * Fires the RFS Check for the Address/Site and returns the status code and the body of the response
     *
     * @param  String siteId - site Id (addressId)
     * @param  Boolean isMove - if changeType is Move, the selected move site has to be RFS checked
     * @return HttpResponseRemoting - custom class as with a http status code and a response body
     * @author Tomislav Blazek
     * @ticket
     * @since  23/2/2016
     */
    @RemoteAction
    public static HttpResponseRemoting rfsCheck(String siteId, Boolean isMove)
    {
        String addressId = '';

        if (isMove) {
            //movesiteId is serialized JSON of UM_AddressResponse.OptionalsJson class
            //so we have to deserialize it first
            UM_AddressResponse.OptionalsJson moveAddress = (UM_AddressResponse.OptionalsJson)
                                                           JSON.deserialize(siteId, UM_AddressResponse.OptionalsJson.class);
            addressId = moveAddress.buildingId;
        } else
        {
            cscrm__Address__c address = [SELECT Id, LG_AddressID__c
                                         FROM cscrm__Address__c
                                         WHERE Id = :siteId];

            addressId = address.LG_AddressID__c;
        }

        HttpResponseRemoting remoteResponse = new HttpResponseRemoting();

        // TO FIX Local query for DEV
        //if (LG_Util.getSandboxInstanceName().equals('dev'))
        //{
        //    remoteResponse.statusCode = 200;
        //    remoteResponse.respBody = LG_RfsCheckUtility.buildRfsResponse();
        //}
        //else
        //{

        UM_AddressResponse.TopasWSPort ws = new UM_AddressResponse.TopasWsPort();
        ws.timeout_x  = 2000;
        ws.endpoint_x = 'callout:UM_SpiderWS/TopasWS/TopasWSService';

        Map<String, String> searchParams = new Map<String, String>();

        if (addressId!=null) {
            searchParams.put('buildingId', EncodingUtil.urlEncode(addressId, 'UTF-8'));
        }

        String systemId     = '';
        Integer maxRecords  = 100;
        Integer startRecord = 0;

        try {

            //if(isMove) {
            //    remoteResponse.respBody = siteId;
            //  } else {
            UM_WebserviceCredentials__c loginCredentials = UM_WebserviceCredentials__c.getValues('UM_TopasWS');
            UM_AddressResponse addressResponse           = new UM_AddressResponse();
            addressResponse.addressExt = new List<UM_AddressResponse.addressExt>();

            UM_AddressResponse.addressesExt res = ws.addressSearchExt(systemId, maxRecords, startRecord, searchParams, loginCredentials.login__c, loginCredentials.password__c);
            addressResponse.addressExt = (List<UM_AddressResponse.addressExt>)res.address;
            //UM_AddressResponse.OptionalsJson rr = addressResponse.OptionalsJson(addressResponse.addressExt.get(0));
            //system.debug('--+ Json: '+rr);
            remoteResponse.respBody = JSON.serialize(addressResponse.addressExt.get(0));
            //}

            remoteResponse.statusCode = 200;

        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.UM_GenericError));
        }

        //}

        return remoteResponse;
    }

    /**
     * Fires the RFS Check for the Address/Site and returns the status code and the body of the response
     *
     * @param  String sitesJson - a list of selected sites and the related subscriptions from the VF Page
     *                              list is provided from the VF page as a json object
     * @param  String changeTypeName - MACD change type i.e. Change, Move - provided from the VF Page
     * @param  String accountId - id of the Account
     * @return String - returns the MACD Opportunity Id to redirect the user to
     * @author Tomislav Blazek
     * @ticket
     * @since  23/2/2016
     */
    @RemoteAction
    public static String createMacdOppAndBasket(String sitesJson, String changeTypeName, String accountId, String services, String moveInMoveOutDates, Boolean isDowngrade)
    {
        Set<Id> subsIds                           = new Set<Id>();
        List<Map<Id, Date>> moveInMoveOutDateList = new List<Map<Id, Date>>();

        SitesObj sitesObj = (SitesObj)JSON.deserialize(sitesJson, LG_MACDConfigurationController.SitesObj.class);
        Decimal TotalAmt = 0.0;//OMB-1611
        /**
         * MACD Migrate
         *
         * @author Petar Miletic
         * @story SFOM-785
         * @since  22/05/2017
         */
        List<LG_MACDConfigurationController.MigrateServices> migrationServices = (List<LG_MACDConfigurationController.MigrateServices>)JSON.deserialize(services, List<LG_MACDConfigurationController.MigrateServices>.class);

        //SFOM-377 MACD Move
        List<LG_MACDConfigurationController.MoveInMoveOutDetails> moveInMoveOutDetails = (List<LG_MACDConfigurationController.MoveInMoveOutDetails>)JSON.deserialize(moveInMoveOutDates, List<LG_MACDConfigurationController.MoveInMoveOutDetails>.class);
        moveInMoveOutDateList                                                          = LG_MACDConfigurationController.getMoveInMoveOutDate(moveInMoveOutDetails);


        Map<String, String> siteToRfsCommonResponse = new Map<String, String>();

        //Populate the site to RFS Common Response map, to be used when updating the attributes of Product Configurations
        for (Site site : sitesObj.sites) {
            String commonResponse = changeTypeName.equals('Terminate') ? '' : UM_RfsCheckUtility.getCommonRfsJsonFormat(site.rfsResponse);

            siteToRfsCommonResponse.put(site.Id, commonResponse);

            for (Sub sub : site.subs) {
                subsIds.add(sub.id);
            }

        }
        //BHP-16-starts    
           
        Set<Id> relatedVPKundenSetupIdSet=new Set<id>();
   
        for(csord__Subscription__c subscri : [Select id,name from csord__Subscription__c Where id in : subsIds and name ='Virtual Phone Kundensetup'])
            relatedVPKundenSetupIdSet.add(subscri.id);
        Map<Id,List<csord__Subscription__c>> accountIdVPServicesMap=LG_Util.getRelatedEntryServicesForVPKundensetupAccount(relatedVPKundenSetupIdSet);
        if(accountIdVPServicesMap.keyset().contains(accountId))
        {
            List<csord__Subscription__c> VPServicesTermination=accountIdVPServicesMap.get(accountId);
            system.debug('shubhamm'+VPServicesTermination);
            if(!VPServicesTermination.isEmpty() && VPServicesTermination!=null){
                for(csord__Subscription__c subsc: accountIdVPServicesMap.get(accountId))
                   { subsIds.add(subsc.id); }
                   }
         }
        //BHP-16-Ends
        csordtelcoa__Change_Types__c changeType = csordtelcoa__Change_Types__c.getAll().get(changeTypeName);

        List<csord__Subscription__c> subscriptions = [SELECT Id, Remaining_Contract_Amount__c, csord__Order__c, csord__Order__r.csordtelcoa__Opportunity__c,
                                                      csord__Order__r.csordtelcoa__Opportunity__r.UM_PartnerAccount__c,
                                                      UM_CloneWhenMigrating__c, csord__Account__c, Name, LG_Address__c,
                                                      LG_Address__r.Id, LG_Address__r.LG_FullAddressDetails__c, csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c,
                                                      (SELECT Id
                                                       FROM csord__Services__r
                                                       WHERE csord__Service__c = null)
                                                      FROM csord__Subscription__c
                                                      WHERE Id IN :subsIds
                                                      ORDER BY LG_Address__r.LG_FullAddressDetails__c];
 		//OMB-1611
        for(csord__Subscription__c sub : subscriptions)
        {
          TotalAmt += sub.Remaining_Contract_Amount__c;
        }
        if (changeTypeName == 'Move') {
            String moveResponse;
            //We only have one site for the Move scenario, so just fetch the response from the map
            for (String resp : siteToRfsCommonResponse.values()) {
                moveResponse = resp;
                break;
            }

            boolean internetAvailable              = false;
            UM_RfsCheckUtility.RfsCommon rfsCommon = (UM_RfsCheckUtility.RfsCommon)JSON.deserialize(moveResponse, UM_RfsCheckUtility.RfsCommon.class);

            for (UM_RfsCheckUtility.common_Availability avail : rfsCommon.availability) {
                if (avail.capability.equals('Data') && avail.technology.equals('Coax')) {
                    internetAvailable = true;
                    break;
                }
            }

            Set <String> BDSProductsWithoutRFS = new Set<String>{Label.CCC_Offnet,Label.BDS_Site, Label.VPN_services, Label.CCC_VDSL,Label.Company_VPN_Connection };
            if (!internetAvailable) {
                for (csord__Subscription__c sub : subscriptions) {
                    if ((!sub.Name.contains('Fiber')) && (!BDSProductsWithoutRFS.contains(sub.csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c) )) {
                        return 'Move failed';
                    }
                }
            }
        }

        Id recordTypeId = null;
        if (changeTypeName.equals('Terminate')) {
            RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Terminate' AND SobjectType = 'Opportunity' LIMIT 1];
            recordTypeId = rt.Id;
        }

        //fire a call to the O&S API for creating the MACD Opportunity
        Id macdOppId = csordtelcoa.API_V1.createMacOpportunityFromSubscriptions(subscriptions, changeType, recordTypeId, null, null);

        Id basketId = null;
        Set<Id> clonedWhileMigrateIds = new Set<Id>();

        for (csord__Subscription__c sub : subscriptions) {
            if (sub.csord__Order__r.csordtelcoa__Opportunity__r.UM_PartnerAccount__c != null && oppPartnerAccount == null) {
                oppPartnerAccount = sub.csord__Order__r.csordtelcoa__Opportunity__r.UM_PartnerAccount__c;
            }
            //OMB-1242
            if (sub.UM_CloneWhenMigrating__c) {
            	for (csord__Service__c service : sub.csord__Services__r) {
                    clonedWhileMigrateIds.add(service.Id);
            	}
            }
        }

        if (changeTypeName.equals('Terminate')) {
            basketId = LG_MACDConfigurationController.createTerminateMacdBasket(macdOppId);
            LG_MACDConfigurationController.insertSubOppRelations(macdOppId, subscriptions);
            LG_MACDConfigurationController.insertSubBasketRelations(basketId, subscriptions, moveInMoveOutDateList);
            LG_MACDConfigurationController.createTerminateProductConfigs(basketId, subscriptions);
        } else {
            List<cscfga__Product_Basket__c> baskets = [SELECT Id FROM cscfga__Product_Basket__c
                                                       WHERE cscfga__Opportunity__c = :macdOppId];

            if (!baskets.isEmpty()) {
                basketId = baskets[0].Id;
                /**
                 * MACD Migrate
                 * We must filter the services that are being migrated, so that we could delete
                 * the new (cloned) configurations.
                 * @author Tomislav Blazek
                 * @story SFOM-401
                 * @since  25/5/2017
                 */
                Set<Id> migratedServices = new Set<Id>();
                for (MigrateServices service : migrationServices) {
                    if (!service.change && !clonedWhileMigrateIds.contains(service.Id)) {
                    	migratedServices.add(service.Id);
                    }
                }
                updateProductConfigurationAttributes(basketId, siteToRfsCommonResponse, changeTypeName, accountId, migratedServices, moveInMoveOutDateList);
            }
        }

        if (basketId != null && LG_Util.getMigrateVarietyChangeTypes().contains(changeTypeName)) {
            LG_MACDConfigurationController.updateMigrateMacdBasket(basketId, isDowngrade, subscriptions);
        }

        if (basketId != null
            && (LG_Util.getMigrateVarietyChangeTypes().contains(changeTypeName) || changeTypeName.equals('Move'))) {
            LG_MACDConfigurationController.insertSubBasketRelations(basketId, subscriptions, moveInMoveOutDateList);
        }

        //SFOM-377
        Set<Id> terminatedServicesIds = new Set<Id>();
        if (changeTypeName.equals('Move')) {
            for (csord__Subscription__c sub :subscriptions) {
                for (csord__Service__c service :sub.csord__Services__r) {
                    terminatedServicesIds.add(service.Id);
                }
            }

            LG_PenaltyFeeCalculation calculator = LG_PenaltyFeeCalculation.getCalcInstance();
            if (calculator != null) {
                calculator.calculateCreatePenaltyFee(basketId, terminatedServicesIds);
            }
        }

        system.debug('oppPartnerAccount is:'+oppPartnerAccount);
        opportunity op = new opportunity(id = macdOppId);
        op.UM_PartnerAccount__c = oppPartnerAccount;
        op.Remaining_Contract_Value__C = TotalAmt;//OMB-1611
        system.debug('op is:'+op);
        update op;

        return macdOppId;
    }

    /**
     * Updates the Product Configurations attributes with the appropriate values of the RFS Check
     * Currently only Product Configurations of the Internet Family Type are updated.
     * It also updates:
     * - Product Configurations change type
     * - if 'Move'  - upserts the selected address and saves the Id of that address to the premise attribute
     *                of the product configuration(s)
     *
     * @param  Id basketId - Id of the basket for which the Attributes of the related Product Configurations
     *                          should be updated
     * @param  Map<String, String> siteToRfsCommonResponse - siteToRfsCommon response map
     *                                                      for getting the RFS Check results per Site
     * @param  String changeTypeName - MACD change type i.e. Change, Move - provided from the VF Page
     * @param Id accountId
     * @param Set<Id> migratedServices - SFOM-401 set of replaced services Ids so that we know cloned configs to
     * delete in case of migrate
     * @author Tomislav Blazek
     * @ticket
     * @since  25/2/2016
     */
    public static void updateProductConfigurationAttributes(Id basketId, Map<String, String> siteToRfsCommonResponse,
                                                            String changeTypeName, Id accountId, Set<Id> migratedServices, List<Map<Id, Date>> moveInMoveOutDateList)
    {
        List<cscfga__Product_Configuration__c> prodConfs = [SELECT Id, LG_ChangeType__c,
                                                            LG_Address__c,
                                                            LG_Site__c, csordtelcoa__Replaced_Service__c,
                                                            csordtelcoa__Replaced_Service__r.csord__Service__c,
                                                            LG_InstallationWishDate__c, LG_InstallationPlannedDate__c, cscfga__Key__c,
                                                            csordtelcoa__Replaced_Subscription__r.LG_Address__c,
                                                            (SELECT Name, cscfga__Value__c, cscfga__Display_Value__c, cscfga__Price__c,
                                                             cscfga__Recurring__c, cscfga__Is_Line_Item__c, cscfga__Product_Configuration__c
                                                             FROM cscfga__Attributes__r
                                                             WHERE Name IN ('Upload', 'Download',
                                                                            'Product Family', 'Premise Id', 'QoS',
                                                                            'Installation Planned Date',
                                                                            'Installation Wish Date',
                                                                            'Site Id',
                                                                            'Installation Lead Date',
                                                                            'Config Change Type',
                                                                            'Get Current Contract Term',
                                                                            'State')
                                                            OR (cscfga__Recurring__c = false AND cscfga__Is_Line_Item__c = true))
                                                            FROM cscfga__Product_Configuration__c
                                                            WHERE cscfga__Product_Basket__c = :basketId];

        boolean isInternet = false;
        String premiseId   = '';

        List<cscfga__Attribute__c> attributesToUpdate = new List<cscfga__Attribute__c>();

        Set<Id> prodConfsToDelete                                = new Set<Id>();
        List<cscfga__Product_Configuration__c> prodConfsToUpdate = new List<cscfga__Product_Configuration__c>();
        Date installationWishDate = null;
		List<csbb__Product_Configuration_Request__c> pcrList = new List<csbb__Product_Configuration_Request__c>();
        
        for (cscfga__Product_Configuration__c prodConf : prodConfs) {
            //SFOM-401 for migrated services we need to delete newly created product configurations.
            if (LG_Util.getMigrateVarietyChangeTypes().contains(changeTypeName)
                && (migratedServices.contains(prodConf.csordtelcoa__Replaced_Service__c)
                    || migratedServices.contains(prodConf.csordtelcoa__Replaced_Service__r.csord__Service__c))) {
                prodConfsToDelete.add(prodConf.Id);
                continue;
            }
            prodConfsToUpdate.add(prodConf);
        }
        for (cscfga__Product_Configuration__c prodConf : prodConfsToUpdate) {
            /**
             * MACD - ​Getting Error "Insert Failed" on clicking Finish button in Edit
             * Product Configuration page once after adding extra
             * telephone number for existing customer with Telefonie Plus...
             *
             * @author Petar Miletic
             * @story SFDT-1279
             * @since 18/07/2016
             */
            if (String.isBlank(prodConf.cscfga__Key__c)) {
                prodConf.cscfga__Key__c = LG_util.generateGUID();
            }

            //update the ChangeType field
            prodConf.LG_ChangeType__c = changeTypeName;
            //SFDT-647 Installation wish and planned dates should be blanked on cloned configurations
            prodConf.LG_InstallationWishDate__c = null;
            //SFOM-377 populate move-in date in PC
            if (changeTypeName.equals('Move') && !moveInMoveOutDateList.isEmpty()) {
                installationWishDate                = moveInMoveOutDateList.get(0).get(prodConf.csordtelcoa__Replaced_Subscription__r.LG_Address__c);
                prodConf.LG_InstallationWishDate__c = installationWishDate;
            }
            prodConf.LG_InstallationPlannedDate__c = null;

            //prod issue: one-time charges should be set to null
            for (cscfga__Attribute__c att : prodConf.cscfga__Attributes__r) {
                if (!att.cscfga__Recurring__c && att.cscfga__Is_Line_Item__c) {
                    att.cscfga__Value__c = null;
                    att.cscfga__Display_Value__c = null;
                    att.cscfga__Price__c = null;
                    attributesToUpdate.add(att);
                }
            }

            //SFDT-1576 Store the configuration change type
            for (cscfga__Attribute__c att : prodConf.cscfga__Attributes__r) {
                if (att.Name.equals('Config Change Type')) {
                    att.cscfga__Value__c = prodConf.LG_ChangeType__c;
                    attributesToUpdate.add(att);
                    break;
                }
            }

            //SFDT-647 Installation wish and planned dates should be blanked on cloned configurations
            for (cscfga__Attribute__c att : prodConf.cscfga__Attributes__r) {
                if (att.Name.equals('Installation Planned Date')
                    || att.Name.equals('Installation Wish Date')
                    || att.Name.equals('Installation Lead Date')) {

                    att.cscfga__Value__c         = null;
                    att.cscfga__Display_Value__c = null;
                    //SFOM-377 populate move-in date in attribute
                    if (changeTypeName.equals('Move') && att.Name.equals('Installation Wish Date')) {
                        att.cscfga__Value__c         = String.valueOf(installationWishDate);
                        att.cscfga__Display_Value__c = String.valueOf(installationWishDate);
                    }

                    attributesToUpdate.add(att);
                }

                //Use existing contract term for all cloned configurations as default
                if (att.Name.equals('Get Current Contract Term')) {
                    att.cscfga__Value__c         = 'Yes';
                    att.cscfga__Display_Value__c = 'Yes';
                    attributesToUpdate.add(att);
                }
            }

            //SFDT-85 Terminate MACD process doesn't update the attribute values
            if (!changeTypeName.equals('Terminate')) {
                isInternet = false;
                premiseId  = '';

                cscfga__Attribute__c attUpload   = null;
                cscfga__Attribute__c attDownload = null;
                cscfga__Attribute__c attQos      = null;
                cscfga__Attribute__c attState    = null;

                //Populate the attribute objects
                for (cscfga__Attribute__c att : prodConf.cscfga__Attributes__r) {
                    if (att.Name.equals('Product Family') && 'Internet'.equals(att.cscfga__Value__c)) {
                        isInternet = true;
                    }

                    if (att.Name.equals('Premise Id')) {
                        premiseId = String.isBlank(att.cscfga__Value__c) ? null : att.cscfga__Value__c;
                    }

                    if (att.Name.equals('QoS')) {
                        attQos = att;
                    }

                    if (att.Name.equals('Upload')) {
                        attUpload = att;
                    }

                    if (att.Name.equals('Download')) {
                        attDownload = att;
                    }

                    if (att.Name.equals('State')) {
                        attState = att;
                    }
                }

                //If Product Configuration is Internet, and it has a valid address, get the Common Response from the Map, and get
                //the Limits
                if (isInternet && //is internet
                    (changeTypeName.equals('Move') //if is a Move then we'll only have one site that has been RFS checked
                     || (String.isNotBlank(premiseId) && siteToRfsCommonResponse.containsKey(premiseId)    //otherwise choose
                         && String.isNotBlank(siteToRfsCommonResponse.get(premiseId))))) {                   //based on the premise Id
                    String rfsResponse = changeTypeName.equals('Move') ? siteToRfsCommonResponse.values().get(0)
                                         : siteToRfsCommonResponse.get(premiseId);
                    Map<String, String> limitsValuesMap = UM_RfsCheckUtility.getProductFamilyLimits(
                        rfsResponse, 'Internet');
                    if (attUpload != null) {
                        attUpload.cscfga__Value__c = limitsValuesMap.get('up');
                        attributesToUpdate.add(attUpload);
                    }
                    if (attDownload != null) {
                        attDownload.cscfga__Value__c = limitsValuesMap.get('down');
                        attributesToUpdate.add(attDownload);
                    }
                    if (attQos != null) {
                        attQos.cscfga__Value__c = limitsValuesMap.get('qos');
                        attributesToUpdate.add(attQos);
                    }
                }

                //Set the State attribute
                if ((changeTypeName.equals('Move') //if is a Move then we'll only have one site that has been RFS checked
                     || (String.isNotBlank(premiseId) && siteToRfsCommonResponse.containsKey(premiseId)    //otherwise choose
                         && String.isNotBlank(siteToRfsCommonResponse.get(premiseId))))) {                  //based on the premise Id
                    String rfsResponse = changeTypeName.equals('Move') ? siteToRfsCommonResponse.values().get(0)
                                         : siteToRfsCommonResponse.get(premiseId);

                    UM_RfsCheckUtility.RfsCommon rfsCommon = (UM_RfsCheckUtility.RfsCommon)JSON.deserialize(rfsResponse, UM_RfsCheckUtility.RfsCommon.class);

                    if (attState != null) {
                        attState.cscfga__Value__c = rfsCommon.stateOrProvince;
                        attributesToUpdate.add(attState);
                    }
                }
            }
        }

        //SFDT-366
        if (changeTypeName.equals('Move')) {
            //we only have one site while 'Move', so get the id of that site (it is also the serialized OptionalsJson)
            String optionalsJson = null;
            for (String site : siteToRfsCommonResponse.keySet()) {
                optionalsJson = site;
                break;
            }

            UM_AddressResponse.OptionalsJson moveAddress = (UM_AddressResponse.OptionalsJson)
                                                           JSON.deserialize(optionalsJson, UM_AddressResponse.OptionalsJson.class);

            Map<String, Object> addressIdMap = (Map<String, Object>)JSON.deserializeUntyped(
                AddressCheck.setAddress(moveAddress.street, moveAddress.streetNo, moveAddress.streetNoSuffix,
                                        moveAddress.zip, moveAddress.city, accountId,
                                        moveAddress.buildingId, 'Germany', moveAddress.region));

            Id addressId = (Id) addressIdMap.get('SalesforceAddressId');

            for (cscfga__Product_Configuration__c prodConf : prodConfsToUpdate) {
                prodConf.LG_Address__c = addressId;

                /**
                 * Move MACD fails on DEV2 (P2 Ticket)
                 *
                 * @author Petar Miletic
                 * @story SFDT-1496
                 * @since  18/08/2016
                 */
                prodConf.LG_Site__c = null;

                //Populate the premise attribute
                for (cscfga__Attribute__c att : prodConf.cscfga__Attributes__r) {
                    if (att.Name.equals('Premise Id')) {
                        att.cscfga__Value__c = addressId;
                        attributesToUpdate.add(att);
                    }

                    // @story SFDT-1496
                    if (att.Name.equals('Site Id')) {
                        att.cscfga__Value__c         = null;
                        att.cscfga__Display_Value__c = null;
                        attributesToUpdate.add(att);
                    }
                }
            }
            /*dgt-389*/
            cscrm__Address__c address = [select id,name,cscrm__City__c,cscrm__State_Province__c,cscrm__Zip_Postal_Code__c,LG_HouseNumberExtension__c,LG_HouseNumber__c,cscrm__Geolocation__latitude__s,cscrm__Geolocation__longitude__s,cscrm__Street__c,LG_AddressID__c from cscrm__Address__c where id =:addressId];
            string res = JSON.serialize(new LG_AddressResponse.OptionalsJson(address));
            system.debug('string ::' + res);
            pcrList = [select id,name,csbb__Optionals__c from csbb__Product_Configuration_Request__c where csbb__Product_Configuration__c IN :prodConfsToUpdate];
            if(!pcrList.isEmpty()){
                for(csbb__Product_Configuration_Request__c pcr : pcrList){
                    pcr.csbb__Optionals__c = res;
                }
            }
        }

        if (!prodConfsToUpdate.isEmpty()) {
            update prodConfsToUpdate;
        }

        if (!attributesToUpdate.isEmpty()) {
            update attributesToUpdate;
        }
        /*dgt-389 fix*/
        
        if(!pcrList.isEmpty()){
            update pcrList;
            system.debug('pcList::::' + pcrList);
        }
        if (!prodConfsToDelete.isEmpty()) {
            //delete [SELECT Id FROM csbb__Product_Configuration_Request__c WHERE csbb__Product_Basket__c = : basketId
						  //AND (csbb__Product_Configuration__c IN: prodConfsToDelete
							   //OR csbb__Product_Configuration__c = null)];
			
			LG_MACDConfigurationController.deleteMigratedConfigsCloneAssets(prodConfsToDelete, basketId);
        }
    }
}
