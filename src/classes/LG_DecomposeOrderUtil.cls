/**
 * Used as a utility class for Order Decomposition.
 * Services are being grouped in suborders, and orchestrator
 * processes are being started for each order and each suborder.
 *
 * @author Tomislav Blazek
 * @ticket SFOM-25
 * @since  11/11/2016
 */
public class LG_DecomposeOrderUtil {

    private List<Id> orderIds;
    private List<Id> primaryOrderIds;
    private List<CSPOFA__Orchestration_Process_Template__c> orchProcessTemplates;
    private List<csord__Service__c> services;
    private List<csord__Service__c> penaltyFeeServices;
    private List<csord__Service__c> terminationServices;
    private Map<String, List<csord__Service__c>> groupedServices;
    private Map<String, csord__Solution__c> suborders;
    private Map<String, cscrm__Address__c> addressMap;
    private Map<String, Date> targetDatesMap;
    private Map<Id, Set<csord__Solution__c>> oldSubordersMap;
    private Map<String, String> groupedKeyToCriteria;
    private CSPOFA__Orchestration_Process_Template__c orchestrateOrderProcess;
    private Map<String, CSPOFA__Orchestration_Process_Template__c> groupedKeyToTemplate;
    private Set<String> siteAgnosticProdFamilies;
    private Map<Id, Id> servicesToTerminateOrder;
    private Set<Id> moveMigrateOrders;
    private Set<Id> terminatedServicesIds;
    private Map<Id, Set<csord__Service__c>> parentToChildren;
    private Map<Id, Set<Id>> parentToChildrenId;
    private string pAcctNo;
    private Set<String> decCriteriasSet;
//  private Map<Id, Id> serviceToDependsOn;
//  private Map<Id, csord__Service__c> dependentService;

    public LG_DecomposeOrderUtil(List<Id> orderIds)
    {
        this.orderIds = orderIds;
        primaryOrderIds = new List<Id>();
        System.debug('>>>>>OrderIds'+orderIds);
    }

    public void startOrderDecomposition()
    {
        System.debug('in decomposition' + Limits.getQueries());
        resolveRootOrders(orderIds);
        
        prepareData(orderIds);

        //groupServices();
        
        processGroupKey();

        createSolutionRecords();

        updatePenaltyFeeLineItems();

        deleteTerminationRecords();

        updateMoveMigrateOrders();
        //SFOM-529
        // VM_GenerateOrderReportUtil.generateOrderReport(suborders);

        startOrchestratorProcesses(primaryOrderIds);
        System.debug('after decomposition' + Limits.getQueries());
    }

    /**
     * For all the Services that are related to Number Range product
     * configurations, find all the Number Range
     * and Phone Number assets, and populate the respective
     * Service fields on the Assets
     *
     * @param  List<csord__Service__c> services
     * @author Tomislav Blazek
     * @ticket SFOM-236
     * @since  30/12/2016
     */
    public static void relateNumberAssets(List<Id> serviceIds) {
        String numberRangeDefinitionName = LG_NumberManagementSettings__c.getInstance(UserInfo.getUserId()).LG_NumberRangeProductDefinitionName__c;
        List<csord__Service__c> services = [SELECT Id,LG_ProvisioningAccountNo__c,csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c,csordtelcoa__Replaced_Service__c, csordtelcoa__Product_Configuration__c, LG_ProductDefinitionName__c, csord__Service__c, csord__Order__c, LG_RootOrder__c, LG_ProductFamily__c
                                            FROM csord__Service__c WHERE Id IN :serviceIds];

        Map<Id, csord__Service__c> numberRangeConfToService = new Map<Id, csord__Service__c>();
        for (csord__Service__c service : services) {
            if (service.LG_ProductDefinitionName__c == numberRangeDefinitionName) {
                numberRangeConfToService.put(service.csordtelcoa__Product_Configuration__c, service);
            }
        }


        if (!numberRangeConfToService.isEmpty()) {

            List<Asset> assetsToUpdate = [SELECT Id, LG_NumberRangeProductConfiguration__c, LG_NumberRangeService__c,
                                          LG_TelephonyProductConfiguration__c, LG_TelephonyService__c
                                          FROM Asset
                                          WHERE LG_NumberRangeProductConfiguration__c IN :numberRangeConfToService.keySet()];

            for (Asset asset : assetsToUpdate) {
                asset.LG_TelephonyService__c   = numberRangeConfToService.get(asset.LG_NumberRangeProductConfiguration__c).csord__Service__c;
                asset.LG_NumberRangeService__c = numberRangeConfToService.get(asset.LG_NumberRangeProductConfiguration__c).Id;
                asset.csord__Order__c          = numberRangeConfToService.get(asset.LG_NumberRangeProductConfiguration__c).LG_RootOrder__c;
            }

            if (!assetsToUpdate.isEmpty()) {
                update assetsToUpdate;
            }
        }
    }

    /**
     * LG_RootOrder__c lookup field should be populated before insert with the service.csord_Order_r.csord_Primary_Order_c field value. 
     * Also populate LG_SubRootOrder__c for the subscription related to the service. @Navneet_sanotra @ticket SFOM-2799
     * (This should be the first thing done before service insert)
     *
     * @author Anthony Arockiam
     * @ticket SFOM-2423
     * @since 26/01/2018
    */
	private void resolveRootOrders(List<Id> orderIds) {

	    if (!orderIds.isEmpty()) {
	        
	        Boolean changed = false;
	        
	        List<csord__Service__c> services = [SELECT Id, Name, csord__Order__c, LG_RootOrder__c,csord__Subscription__r.LG_SubRootOrder__c,csord__Subscription__c, csord__Order__r.csord__Primary_Order__c FROM csord__Service__c WHERE csord__Order__c IN :orderIds];

            for (csord__Service__c service :services) {
                
                if (String.isNotBlank(service.csord__Order__c)) {
                    
                    service.LG_RootOrder__c = service.csord__Order__r.csord__Primary_Order__c;
                    service.csord__Subscription__r.LG_SubRootOrder__c = service.csord__Order__r.csord__Primary_Order__c;
                    update service.csord__Subscription__r;
                    changed = true;
                }
            }
            
            if (changed) {
                update services;
            }
        }
    }
	
    /**
     * Fetches the data required for order decomposition
     *
     * @param  List<Id> orderIds
     * @author Tomislav Blazek
     * @ticket SFOM-25
     * @since  11/11/2016
     */
    private void prepareData(List<Id> orderIds)
    {
        
        
        //fetch the services being terminated by the termination products
        terminatedServicesIds = new Set<Id>();
		Map<Id, Id> terminateServiceIdToOriginalOrderId = new Map<Id, Id>();
		    

        CSPOFA__Orchestrator_Constants__c orhConstants = CSPOFA__Orchestrator_Constants__c.getOrgDefaults();
        if (orhConstants != null && String.isNotBlank(orhConstants.LG_OrchestrateOrder__c)) {
            orchestrateOrderProcess = [SELECT Id FROM CSPOFA__Orchestration_Process_Template__c
                                       WHERE Name = :orhConstants.LG_OrchestrateOrder__c];
        }

        Set<Id> migrateOpps    = new Set<Id>();
        Map<Id, Id> oppToOrder = new Map<Id, Id>();
		Boolean isOppChangeType = false; //to exclude ComplexChange
        for (csord__Order__c order : [SELECT Id, csordtelcoa__Opportunity__c, csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c
                                      FROM csord__Order__c WHERE Id IN :orderIds AND csord__Primary_Order__c = null]) {
            primaryOrderIds.add(order.Id);
            oppToOrder.put(order.csordtelcoa__Opportunity__c, order.Id);
            if (LG_Util.getMigrateVarietyChangeTypes().contains(order.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c)) {
                migrateOpps.add(order.csordtelcoa__Opportunity__c);
            }
            if(order.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c == 'Change'){
            	isOppChangeType = true;
            }
        }

        System.debug('>>>>>MigrateOpps'+migrateOpps);

        //for Migrate we must ignore services that were cloned (are basically treated as change, they are not getting terminated)
        Set<Id> clonedServices = new Set<Id>();
        if (!migrateOpps.isEmpty()) {
            for (cscfga__Product_Configuration__c prodConfs : [SELECT csordtelcoa__Replaced_Service__c
                                                               FROM cscfga__Product_Configuration__c
                                                               WHERE cscfga__Product_Basket__r.cscfga__Opportunity__c IN :migrateOpps
                                                               	AND cscfga__Product_Definition__r.LG_ProductSubtype__c != 'Termination']) {
                clonedServices.add(prodConfs.csordtelcoa__Replaced_Service__c);
            }
        }

        System.debug('>>>>>clonedServices'+clonedServices);
        
        //fetch the termination products related to the order
        Map<Id, Id> terminatedSubIdsToOrderId              = new Map<Id, Id>();
        Map<Id, Date> terminateWishDateToTerminatedService = new Map<Id, Date>();
//      serviceToDependsOn = new Map<Id, Id>();
//      dependentService = new Map<Id, csord__Service__c>();

        for (csordtelcoa__Subscr_MACDProductBasket_Association__c macdJunction : [SELECT csordtelcoa__Subscription__c, LG_DeactivationWishDate__c,
                                                                                  csordtelcoa__Product_Basket__r.cscfga__Opportunity__c
                                                                                  FROM csordtelcoa__Subscr_MACDProductBasket_Association__c
                                                                                  WHERE csordtelcoa__Product_Basket__r.cscfga__Opportunity__c IN :oppToOrder.keySet()
                                                                                  AND LG_DeactivationWishDate__c != null]) {
            terminatedSubIdsToOrderId.put(macdJunction.csordtelcoa__Subscription__c, oppToOrder.get(macdJunction.csordtelcoa__Product_Basket__r.cscfga__Opportunity__c));
            terminateWishDateToTerminatedService.put(macdJunction.csordtelcoa__Subscription__c, macdJunction.LG_DeactivationWishDate__c);
        }
        
        System.debug('>>>>>terminatedSubIds'+terminatedSubIdsToOrderId);
		/** OMB-1615 ***/
        //isOppChangeType = true;
		if(isOppChangeType){
            system.debug('<<<<<<<<<<in oppchange');
			Map<String,Date> oppIdAddressIdToWishDateMap = new Map<String,Date>();
			Map<String,String> subIdToOppIdAddressIdMap = new Map<String,String>();
			Map<String,String> subIdToOppId = new Map<String,String>();
			Set<Id> replaceSubIdsFromBasket = new Set<Id>();
			Set<Id> subIdsFromJunction = new Set<Id>();
			//fetch the replaced subscription Ids from the configurations that are in the basket
	        for(cscfga__Product_Configuration__c prodConf : [SELECT csordtelcoa__Replaced_Subscription__c, LG_InstallationWishDate__c, 
	                                                        LG_Address__c, cscfga__Product_Basket__r.cscfga__Opportunity__c
	                                                        FROM cscfga__Product_Configuration__c
	                                                        WHERE cscfga__Product_Basket__r.csordtelcoa__Synchronised_with_Opportunity__c = true
	                                                        AND cscfga__Product_Basket__r.csordtelcoa__Change_Type__c = 'Change'
	                                                        AND cscfga__Product_Basket__r.cscfga__Opportunity__c IN :oppToOrder.keySet() and cscfga__Product_Family__c!='Termination'])
	        {
	            replaceSubIdsFromBasket.add(prodConf.csordtelcoa__Replaced_Subscription__c);
	            String opAddrId = String.valueOf(prodConf.cscfga__Product_Basket__r.cscfga__Opportunity__c) + String.valueOf(prodConf.LG_Address__c);
	
	        }
			System.debug('>>>>>replaceSubIdsFromBasket'+replaceSubIdsFromBasket);
	        //fetch the subscription ids from the junction object - to have a full set of all old subscription ids that were involved in the
	        //MACD process
	        for(csordtelcoa__Subscription_MACDOpportunity_Association__c junction : [SELECT csordtelcoa__Subscription__c, csordtelcoa__Opportunity__c, csordtelcoa__Subscription__r.LG_Address__c
	                                                                                 FROM csordtelcoa__Subscription_MACDOpportunity_Association__c
	                                                                                 WHERE csordtelcoa__Opportunity__c IN :oppToOrder.keySet()
	                                                                                 	AND csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c = 'Change'])
	        {
                //AND csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c = 'Change'
	            subIdsFromJunction.add(junction.csordtelcoa__Subscription__c);
	            String opAddrId = String.valueOf(junction.csordtelcoa__Opportunity__c) + String.valueOf(junction.csordtelcoa__Subscription__r.LG_Address__c);
	            subIdToOppIdAddressIdMap.put(junction.csordtelcoa__Subscription__c, opAddrId);
	            subIdToOppId.put(junction.csordtelcoa__Subscription__c,junction.csordtelcoa__Opportunity__c);
	            
	        }
	
	        System.debug('>>>>>subIdToOppId'+subIdToOppId);
	
	        //populate a set of subscription ids that were deleted from the basket (old subscription ids will not be contained in the
	        //replaced subscription ids set)
	        for(Id subId : subIdsFromJunction)
	        {
	            if (!replaceSubIdsFromBasket.contains(subId))
	            {
	            	if(subIdToOppId.get(subId) != null)
	                terminatedSubIdsToOrderId.put(subId, oppToOrder.get(subIdToOppId.get(subId)));
	                
	                if(subIdToOppIdAddressIdMap.get(subId) != null && oppIdAddressIdToWishDateMap.get(subIdToOppIdAddressIdMap.get(subId)) != null)
	                terminateWishDateToTerminatedService.put(subId, oppIdAddressIdToWishDateMap.get(subIdToOppIdAddressIdMap.get(subId))); 
	            } 
	        }
            		//added as part of OMB-3542 starts
			system.debug('orderids in 3542=='+orderIds);        

            for (csord__Service__c service : [select id,csord__Service__r.csordtelcoa__Replacement_Service__r.LG_RootOrder__c from csord__Service__C where LG_Action__c ='Delete' AND LG_DecompositionCriteria__c!=null AND csord__Service__c!=null AND csord__Subscription__c IN (select csordtelcoa__Replaced_Subscription__c from csord__Subscription__c where csord__Order__c IN:orderIds AND csordtelcoa__Change_Type__c ='Change')]) {

			system.debug('service>>>>>'+service.csord__Service__c);
            terminatedServicesIds.add(service.Id);
			terminateServiceIdToOriginalOrderId.put(service.Id, service.csord__Service__r.csordtelcoa__Replacement_Service__r.LG_RootOrder__c);


			}
		system.debug('terminateServiceIdToOriginalOrderId=='+terminateServiceIdToOriginalOrderId);
	   //added as part of OMB-3542 ends
        }
		/***  END   ***/
		System.debug('>>>>>terminatedSubIdsToOrderId'+terminatedSubIdsToOrderId);

        for (csord__Service__c service : [SELECT Id,LG_ProvisioningAccountNo__c,LG_ProvisioningSystem__c FROM csord__Service__c
                                          WHERE csord__Subscription__c IN :terminatedSubIdsToOrderId.keySet()
                                          AND Id NOT IN :clonedServices]) {
            terminatedServicesIds.add(service.Id);

            //added for sfom-1130
            if (service.LG_ProvisioningSystem__c =='CAMA' && service.LG_ProvisioningAccountNo__c!=null) {
                pAcctNo = service.LG_ProvisioningAccountNo__c;

            }
        }
        System.debug('>>>>>TerminatedServiceIds'+terminatedServicesIds);

        //fetch all the services created but ignore the termination product services
        //SFOM-1191 - Opportunity Change_Type__c added in query
        List<csord__Service__c> servicesToFilter = new List<csord__Service__c>();

        servicesToFilter = [SELECT Id,
                            csord__Order__c,
                            LG_RootOrder__c,
                            LG_RootOrder__r.csord__Account__c,
                            csord__Service__c,
                            LG_DecompositionCriteria__c,
                            LG_Suborder__c,
                            LG_OldSuborder__c,
                            LG_Address__c,
                            LG_InstallationWishDate__c,
                            LG_Address__r.Name,
                            LG_Address__r.cscrm__Address_Details__c,//Added for SFOM-2800
                            LG_Address__r.Id,
                            LG_Address__r.cscrm__State_Province__c,
                            UM_State__c,
                            LG_Action__c,
                            LG_ProductFamily__c,
                            csordtelcoa__Delta_Status__c,
                            LG_Activationneeded__c,
                            LG_ProvisioningSystem__c,
                            LG_ProvisioningAccountNo__c,
                            csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c,
                            csordtelcoa__Replaced_Service__r.LG_ProvisioningSystem__c,
                            UM_DependsOnService__r.LG_ProvisioningAccountNo__c,
                            UM_DependsOnService__r.LG_DecompositionCriteria__c,
                            LG_DependsOnSecondaryService__r.LG_DecompositionCriteria__c,
                            LG_Suborder__r.LG_Termination__c,
                            LG_InstallationNeeded__c,
                            csord__Subscription__c,
                            csord__Subscription__r.csordtelcoa__Change_Type__c,
                            csordtelcoa__Replaced_Service__r.LG_Suborder__r.Id,
                            csordtelcoa__Replaced_Service__r.LG_Suborder__r.LG_InstallationWishDate__c,
                            csordtelcoa__Replaced_Service__r.LG_Suborder__r.LG_Address__c,
                            csordtelcoa__Replaced_Service__r.LG_Suborder__r.LG_DecompositionCriteria__c,
                            csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name,
                            csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_ProductSubtype__c,
                            csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_NeedsActivation__c,
                            csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_NeedsInstallation__c,
                            LG_RootOrder__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c,
                            LG_TerminatedService__c,
                            UM_DependsOnService__c,
                            Persistent_Id__c,
                            LG_From_Service__c,
                            LG_To_Service__c,
                            UM_WaitForAccess__c,
                            //added as part of sfom-2551
                            LG_Primary_Access_Network__c,LG_Primary_Access_Type__c,
                            UM_DownloadSpeed__c, name,LG_Hardware__c,LG_Secondary_Access_Network__c,LG_Secondary_Access_Type__c,
                            (SELECT Id, csord__Service__c, csord__Service__r.LG_TerminatedService__c,
                             csord__Service__r.csordtelcoa__Replaced_Service__c FROM csord__Service_line_Items__r)
                            FROM csord__Service__c
                            WHERE (LG_RootOrder__c IN :primaryOrderIds OR Id IN :terminatedServicesIds)
                            AND (csord__Service__c = null OR (csord__Service__c != null AND LG_DecompositionCriteria__c !=null))];
                            // Added OR condition to include child services which has decomp criteria


        services                 = new List<csord__Service__c>();
        penaltyFeeServices       = new List<csord__Service__c>();
        terminationServices      = new List<csord__Service__c>();
        oldSubordersMap          = new Map<Id, Set<csord__Solution__c>>();
        servicesToTerminateOrder = new Map<Id, Id>();
        moveMigrateOrders        = new Set<Id>();

        for (csord__Service__c service : servicesToFilter) {
            //SFOM-379 fetch order Ids that are move/migrate, but not related to services being terminated.
            if (!terminatedSubIdsToOrderId.containsKey(service.csord__Subscription__c)
              && (service.csord__Subscription__r.csordtelcoa__Change_Type__c == 'Move' || LG_Util.getMigrateVarietyChangeTypes().contains(service.csord__Subscription__r.csordtelcoa__Change_Type__c))
              && service.csord__Service__c == null) {
                moveMigrateOrders.add(service.LG_RootOrder__c);
            }
            if (service.csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_ProductSubtype__c != 'Penalty Fee'
                && service.csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_ProductSubtype__c != 'Termination') {
                //(old) terminated services must be reparent to the current order, and the termination wish date must be set,
                //so that the grouping into suborders is done correctly
                System.debug('>>>ServiceId1111'+service.Id);
                if (terminatedSubIdsToOrderId.containsKey(service.csord__Subscription__c)) {
                    servicesToTerminateOrder.put(service.Id, service.LG_RootOrder__c);
                    service.LG_RootOrder__c            = terminatedSubIdsToOrderId.get(service.csord__Subscription__c);
                    service.LG_InstallationWishDate__c = terminateWishDateToTerminatedService.get(service.csord__Subscription__c);
                }
				
				//added as part of OMB-3542 starts

				if (terminateServiceIdToOriginalOrderId.containsKey(service.id)) {
				    system.debug('in omb-3542 second method');
					servicesToTerminateOrder.put(service.Id, service.LG_RootOrder__c);
					service.LG_RootOrder__c = terminateServiceIdToOriginalOrderId.get(service.Id);
					service.csord__Status__c = LG_Util.getServiceRequestDeactivateStatus();

				}		
				//added as part of OMB-3542 ends

                //SFOM-1786
                if (service.csord__Subscription__r.csordtelcoa__Change_Type__c == 'Move' && service.csordtelcoa__Delta_Status__c == 'Continuing In Subscription'){
                    service.csordtelcoa__Delta_Status__c = null;
                }
                services.add(service);
            } else if (service.csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_ProductSubtype__c == 'Termination' && service.csord__Service__c == null) {
                terminationServices.add(service);
            } else if (service.csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_ProductSubtype__c == 'Penalty Fee' && service.csord__Service__c == null) {
                penaltyFeeServices.add(service);
            }

            if (service.csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_ProductSubtype__c == 'Termination' && service.csord__Service__c == null ) {
                continue;
            }

            //populate the old suborders map
            if (!oldSubordersMap.containsKey(service.LG_RootOrder__c) && service.csord__Service__c == null) {
                oldSubordersMap.put(service.LG_RootOrder__c, new Set<csord__Solution__c>());
            }
            if (service.csordtelcoa__Replaced_Service__r != null && service.csordtelcoa__Replaced_Service__r.LG_Suborder__r != null && service.csord__Service__c == null) {
                oldSubordersMap.get(service.LG_RootOrder__c).add(service.csordtelcoa__Replaced_Service__r.LG_Suborder__r);
            }
            //SFOM-1038
//            if (service.UM_DependsOnService__c != null) {
//                serviceToDependsOn.put(service.Id, service.UM_DependsOnService__c);
//                dependentService.put(service.Id, service);
//           }
        }

        decCriteriasSet = new Set<String>();

        for (csord__Service__c service : services) {
            resolveInstallationAndActivation(service);
            decCriteriasSet.add(service.LG_DecompositionCriteria__c);
        }

        String decCriterias = String.join(new List<String>(decCriteriasSet), '\',\'');

        String queryString = 'SELECT Id, Name, LG_DecompositionCriteria__c '
                             + 'FROM CSPOFA__Orchestration_Process_Template__c '
                             + 'WHERE LG_DecompositionCriteria__c INCLUDES(\'' + decCriterias +'\')';

        System.debug('queryString -> ' + queryString);

        orchProcessTemplates = (List<CSPOFA__Orchestration_Process_Template__c>)Database.query(queryString);
    }

    /**
     * Groups services based on a key:
     * Decomposition Criteria + Installation Wish Date + Site
     *
     * Map will be used to further group services under the same solution.
     *
     * @author Tomislav Blazek
     * @ticket SFOM-25
     * @since  11/11/2016
     */
    
    private void groupServices()
    {
        groupedServices      = new Map<String, List<csord__Service__c>>();
        addressMap           = new Map<String, cscrm__Address__c>();
        groupedKeyToCriteria = new Map<String, String>();
        targetDatesMap       = new Map<String, Date>();
        Integer nogroupCount              = 0;
        String legacyCriteria             = LG_OrderDecompositionSettings__c.getAll().get('VM').LG_LegacyDecompositionCriteria__c;
        //String groupDependentWithParent   = LG_OrderDecompositionSettings__c.getAll().get('UM').LG_GroupDependentWithParent__c;
        Set<String> groupDependentWithParent   = new Set<String>((LG_OrderDecompositionSettings__c.getAll().get('UM').LG_GroupDependentWithParent__c).split(','));
        String overridenoGroupingCriteria = LG_OrderDecompositionSettings__c.getAll().get('UM').LG_OverrideNogroupingCriteria__c;
        String CombineInternetGroupingCriteria = LG_OrderDecompositionSettings__c.getAll().get('UM').LG_CombineInternetDecompositionCriteria__c;
//      String perSiteCriteria            = LG_OrderDecompositionSettings__c.getAll().get('UM').LG_PerSiteDecompositionCriteria__c;
        String allTogetherCriteria = LG_OrderDecompositionSettings__c.getAll().get('UM').LG_AllTogetherDecompositionCriteria__c;
        Set<String> perSiteCriteriaSet    = new Set<String>((LG_OrderDecompositionSettings__c.getAll().get('UM').LG_PerSiteDecompositionCriteria__c).split(','));
        Set<String> noGroupingCriteriaSet = new Set<String>((LG_OrderDecompositionSettings__c.getAll().get('UM').LG_NoGroupingDecompositionCriteria__c).split(','));
        Set<String> internetGroupingCriteriaSet = new Set<String>((LG_OrderDecompositionSettings__c.getAll().get('UM').LG_CombineInternetDecompositionCriteria__c).split(','));
        String macdDecompositionCriteria = LG_OrderDecompositionSettings__c.getAll().get('UM').LG_MacdDecompositionCriteria__c;

        for (csord__Service__c service : services) {
            system.debug('service :>>>'+service);
            system.debug('service DC:>>>'+service.LG_DecompositionCriteria__c);
            String groupedKey;
            csord__Service__c parentService = null;
/***
            //SFOM-1038
            csord__Service__c dependentServ = null;
            if(!serviceToDependsOn.isEmpty()) {
                dependentServ = getDependentService(service);
            }
            system.debug('dependentServ :'+dependentServ);
            if (dependentServ != null) {//Group Dependent Service
                groupedKey = dependentServ.csord__Order__c + dependentServ.LG_DecompositionCriteria__c;

                //SFOM-1191 - alltogethercriteria set used  & condition added to group noGroupingCriteria (MACD Migrate) into persite
            } else if (service.LG_DecompositionCriteria__c == legacyCriteria || allTogetherCriteriaSet.contains(service.LG_DecompositionCriteria__c)) {
 ***/
//added alltogether for sfom-1575
            if (service.LG_DecompositionCriteria__c == legacyCriteria || service.LG_DecompositionCriteria__c == allTogetherCriteria) {
                groupedKey = service.LG_RootOrder__c + service.LG_DecompositionCriteria__c;

                //SFOM-1038 ,SFOM-1575
            } else if (internetGroupingCriteriaSet.contains(service.LG_DecompositionCriteria__c)  && LG_Util.getMigrateVarietyChangeTypes().contains(service.LG_RootOrder__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c)) {
                groupedKey = service.LG_RootOrder__c + macdDecompositionCriteria;
                groupedKey = groupedKey + service.LG_Address__c;
                addressMap.put(groupedKey, service.LG_Address__r);

            } else if (perSiteCriteriaSet.contains(service.LG_DecompositionCriteria__c) || (service.LG_DecompositionCriteria__c == overridenoGroupingCriteria && LG_Util.getMigrateVarietyChangeTypes().contains(service.LG_RootOrder__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c))) {
                //SFOM-1095
                //decompose services per site only, irrespective of Installation Date
                groupedKey = service.LG_RootOrder__c + service.LG_DecompositionCriteria__c;
                groupedKey = groupedKey + service.LG_Address__c;
                addressMap.put(groupedKey, service.LG_Address__r);

//            } else if (service.LG_DecompositionCriteria__c == noGroupingCriteria) {
//                //decompose each service in seaparate suborder even for same address
//                groupedKey = service.csord__Order__c + service.LG_DecompositionCriteria__c;
//                groupedKey = groupedKey + service.LG_Address__c + '_' + nogroupCount;
//                addressMap.put(groupedKey, service.LG_Address__r);
//                nogroupCount++;

            //} else if (service.UM_DependsOnService__c != null && service.LG_DecompositionCriteria__c == groupDependentWithParent) {
            } else if (service.UM_DependsOnService__c != null && groupDependentWithParent.contains(service.LG_DecompositionCriteria__c)) {
//              csord__Service__c parentService = null;
                parentService = getParentService(service.UM_DependsOnService__c);
                boolean addressAlreadyAdded = false;
                if (parentService != null) {
                    system.debug('parent decomposition criteria' + parentService.LG_DecompositionCriteria__c);
                    if (LG_Util.getMigrateVarietyChangeTypes().contains(service.LG_RootOrder__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c) && internetGroupingCriteriaSet.contains(parentService.LG_DecompositionCriteria__c)) {
                        groupedKey = service.LG_RootOrder__c + macdDecompositionCriteria;

                    } else {
                        groupedKey = service.LG_RootOrder__c + parentService.LG_DecompositionCriteria__c;

                    }
                    if (!LG_Util.getMigrateVarietyChangeTypes().contains(service.LG_RootOrder__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c) && noGroupingCriteriaSet.contains(parentService.LG_DecompositionCriteria__c)) {
                        groupedKey = groupedKey + parentService.LG_Address__c + '_' + parentService.Id;
                        addressAlreadyAdded = true;
                    }
                    if (perSiteCriteriaSet.contains(parentService.LG_DecompositionCriteria__c)){
                        if (!addressAlreadyAdded){
                            groupedKey = groupedKey + parentService.LG_Address__c;
                            addressAlreadyAdded = true;
                        }
                    }
                    if (LG_Util.getMigrateVarietyChangeTypes().contains(service.LG_RootOrder__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c) && internetGroupingCriteriaSet.contains(parentService.LG_DecompositionCriteria__c)) {
                        if (!addressAlreadyAdded){
                            groupedKey = groupedKey + parentService.LG_Address__c;
                            addressAlreadyAdded = true;
                        }
                    }
                   /* if (LG_Util.getMigrateVarietyChangeTypes().contains(service.LG_RootOrder__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c) && (noGroupingCriteriaSet.contains(parentService.LG_DecompositionCriteria__c) || perSiteCriteriaSet.contains(parentService.LG_DecompositionCriteria__c))) {
                        groupedKey = service.csord__Order__c + parentService.LG_DecompositionCriteria__c;
                        groupedKey = groupedKey + parentService.LG_Address__c;
                    }*/
                    addressMap.put(groupedKey, parentService.LG_Address__r);
                } else {
                    groupedKey = service.LG_RootOrder__c + service.LG_DecompositionCriteria__c;
                    groupedKey = groupedKey + service.LG_Address__c + '_' + service.Id;
                    addressMap.put(groupedKey, service.LG_Address__r);
                }

            } else if (noGroupingCriteriaSet.contains(service.LG_DecompositionCriteria__c)) {
                groupedKey = service.LG_RootOrder__c + service.LG_DecompositionCriteria__c;
                groupedKey = groupedKey + service.LG_Address__c + '_' + service.Id;
                addressMap.put(groupedKey, service.LG_Address__r);
            } else {
                groupedKey = service.LG_RootOrder__c + service.LG_DecompositionCriteria__c + service.LG_InstallationWishDate__c;
                if (!isSiteAgnostic(service.LG_ProductFamily__c)) {
                    groupedKey = groupedKey + service.LG_Address__c;
                    addressMap.put(groupedKey, service.LG_Address__r);
                }
            }
//            if (dependentServ != null) {
//                groupedKeyToCriteria.put(groupedKey, dependentServ.LG_DecompositionCriteria__c);
//                targetDatesMap.put(groupedKey, dependentServ.LG_InstallationWishDate__c);
            if (parentService != null) {
                groupedKeyToCriteria.put(groupedKey, parentService.LG_DecompositionCriteria__c);
                targetDatesMap.put(groupedKey, parentService.LG_InstallationWishDate__c);
            } else {
                groupedKeyToCriteria.put(groupedKey, service.LG_DecompositionCriteria__c);
                //SFOM-1361 - to prevent null data entry
                if(service.LG_InstallationWishDate__c != null){
                targetDatesMap.put(groupedKey, service.LG_InstallationWishDate__c);
            }

            }

            if (!groupedServices.containsKey(groupedKey)) {
                groupedServices.put(groupedKey, new List<csord__Service__c>());
            }

            groupedServices.get(groupedKey).add(service);
            
        }
        system.debug('groupedServices :'+groupedServices);

        // code to group Mobile service with running Cama Manual suborder
        
        Boolean CamaManualFlag = false;
        Boolean mobileServiceFlag = false;
        String camaManualKey = null;
        String mobileServiceKey = null;
        List<csord__Service__c> mobileService = new List<csord__Service__c>();

        for (String serviceIds: groupedServices.keySet()) {
             if (serviceIds.contains(macdDecompositionCriteria)) {
                 CamaManualFlag = true;
                 camaManualKey = serviceIds;
             } else if (serviceIds.contains(allTogetherCriteria)) {
                 mobileServiceFlag = true;
                 mobileService = groupedServices.get(serviceIds);
                 mobileServiceKey = serviceIds;
             }
        }

        if (CamaManualFlag && mobileServiceFlag) {
            groupedServices.get(camaManualKey).add(mobileService[0]);
            groupedServices.remove(mobileServiceKey);
            groupedKeyToCriteria.remove(mobileServiceKey);
        }

        groupedKeyToTemplate = new Map<String, CSPOFA__Orchestration_Process_Template__c>();

        for (String key : groupedKeyToCriteria.keySet()) {
            System.debug('>>>>>Criteria000>>>>'+key);
            System.debug('>>>>>Criteria>>>>'+groupedKeyToCriteria.get(key));
            for (CSPOFA__Orchestration_Process_Template__c template : orchProcessTemplates) {
                if (String.isNotBlank(template.LG_DecompositionCriteria__c)) {
                    Set<String> criterias = new Set<String>(template.LG_DecompositionCriteria__c.split(';'));

                    String criteria = groupedKeyToCriteria.get(key);
					System.debug('>>>>>Criteriasss>>>>'+criterias);
                    if (criterias.contains(criteria)) {
                    	System.debug('>>>CrieteriaPresent');
                        groupedKeyToTemplate.put(key, template);
                        break;
                    }
                }
            }
        }
    }
	/**
     * Groups services based on a key:
     * Decomposition Criteria + Installation Wish Date + Site
     *
     * Map will be used to further group services under the same solution.
     *
     * @author Anthony Arockiam 
     * @ticket SFOM-25
     * @since  19/10/2017
     */
     private void processGroupKey(){
     	groupedServices      = new Map<String, List<csord__Service__c>>();
        groupedKeyToCriteria = new Map<String, String>();
        addressMap           = new Map<String, cscrm__Address__c>();
        targetDatesMap       = new Map<String, Date>();
        Map<String,List<DecompositionSequence__mdt>> decomSequencMap = new Map<String,List<DecompositionSequence__mdt>>();
        decomSequencMap = getDecompostionRecords();
        Set<Id> orderIdsToUpdate = new Set<Id>();
         List<csord__Service__c> bdsServiceList = new  List<csord__Service__c>();
        for(csord__Service__c service : services) {     
            System.debug('>>>>ServiceId>>>'+service.Id);        
            System.debug('>>>>ServDecompCriteria>>>'+service.LG_DecompositionCriteria__c);      
            if(service.LG_DecompositionCriteria__c == 'Set 20 - BDS Site Process'){ //This will be changed to Network type
                orderIdsToUpdate.add(service.LG_RootOrder__c);
                bdsServiceList.add(service);
            }
            String overrideCriteria = null;
            Boolean isOverride = false;
     		csord__Service__c parentService = null;
     		String groupedKey;
     		String serviceKey = getServiceKey(service);
     		groupedKey = serviceKey;
     		List<String> dcFields = new List<String>(); 
            String oppChangeType = service.LG_RootOrder__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c;
     		if(decomSequencMap.get(service.LG_DecompositionCriteria__c) != null){
     			for(DecompositionSequence__mdt dc : decomSequencMap.get(service.LG_DecompositionCriteria__c)){// 2 records     				
     				if(dc.ChangeType__c == null || (oppChangeType != null && dc.ChangeType__c.contains(oppChangeType))){ // IF Change type
     					if(dc.GroupByCriteria__c == 'Override'){
                            System.debug('>>>Override Block');
                            isOverride = true;
     						groupedKey = groupedKey + dc.OverrideDecompostionCriteria__c;
     						overrideCriteria = dc.OverrideDecompostionCriteria__c;
     						if(dc.GroupKey__c != null){
     							dcFields = parseFields(dc.GroupKey__c);
     							groupedKey = formGroupKey(dcFields, service, groupedKey);
     						}
     						if(dc.GroupKey__c != null && dc.GroupKey__c.contains('LG_Address__c')){
     							addressMap.put(groupedKey, service.LG_Address__r);
     						}

     					} else if(dc.GroupByCriteria__c == 'Group with Depends On'){ // Assumed that parent service will not dependent on another service

     						parentService = getParentService(service.UM_DependsOnService__c);
							
     						if(parentService != null){
                                System.debug('>>>555666'+service.UM_DependsOnService__c);
	     						groupedKey = getGroupKeyForParent(parentService, decomSequencMap.get(parentService.LG_DecompositionCriteria__c), decomSequencMap);
     						} else { 
                    			groupedKey = service.LG_DecompositionCriteria__c + groupedKey + service.LG_Address__c + '_' + service.Id;
                    			if(dc.GroupKey__c != null && dc.GroupKey__c.contains('LG_Address__c')){
     								addressMap.put(groupedKey, service.LG_Address__r);
     							}
     						}
     						
     					} else if(dc.GroupByCriteria__c == 'groupwithFromLink'){
     						groupedKey = formGroupKey(dcFields, service, groupedKey);
     						if(service.LG_From_Service__c != null){ // Connection
     							groupedKey = groupedKey + service.LG_From_Service__c;
     							System.debug('>>>>BDSFR');
     							// Order + FRom_Service
     						} else if(service.Persistent_Id__c != null){ //VPN
     							groupedKey = groupedKey + service.Persistent_Id__c;
     							// Order + Persistent Id
     						}     						
     					} //OrderId + PersistentIdVPN **/
     					else {
                            System.debug('>>>thrid Block');
     						if(dc.GroupKey__c != null){
     							dcFields = parseFields(dc.GroupKey__c);
								groupedKey = formGroupKey(dcFields, service, groupedKey);
     						}
							if(dc.GroupKey__c != null && dc.GroupKey__c.contains('LG_Address__c')){
								addressMap.put(groupedKey, service.LG_Address__r);
     						}
     					}
     					break;
     				} // END IF Change type    				
	     		}
     		} 
     		if(groupedKey == serviceKey){
     			dcFields = parseFields(decomSequencMap.get('default')[0].GroupKey__c);
     			groupedKey = formGroupKey(dcFields, service, groupedKey);
     			if(decomSequencMap.get('default')[0].GroupKey__c.contains('LG_Address__c')){
 					addressMap.put(groupedKey, service.LG_Address__r);
 				}
     		}

     		if(!groupedServices.containsKey(groupedKey)) {
                groupedServices.put(groupedKey, new List<csord__Service__c>());
            }
            groupedServices.get(groupedKey).add(service);   

            if (parentService != null) {
                groupedKeyToCriteria.put(groupedKey, parentService.LG_DecompositionCriteria__c);
                targetDatesMap.put(groupedKey, parentService.LG_InstallationWishDate__c);
            } else {
                if (isOverride == true && overrideCriteria != null && decCriteriasSet.contains(overrideCriteria)) {
                    groupedKeyToCriteria.put(groupedKey, overrideCriteria);
                } else {
                   groupedKeyToCriteria.put(groupedKey, service.LG_DecompositionCriteria__c); 
                }
                if (service.LG_InstallationWishDate__c != null) {
                    targetDatesMap.put(groupedKey, service.LG_InstallationWishDate__c);
                }
            }
            System.debug('>>>>service>>>>'+service.Id+'>>>>>'+groupedKey);
        }
        
        //DGT-117
        if(!bdsServiceList.isEmpty()){
            updateDependOnService(bdsServiceList);
        }
        // code to regroup running services(Mobile service with running Cama Manual suborder)
        reGroupDecompositionCriterias(decomSequencMap);
        groupedKeyToTemplate = new Map<String, CSPOFA__Orchestration_Process_Template__c>();

        for (String key : groupedKeyToCriteria.keySet()) {
            for (CSPOFA__Orchestration_Process_Template__c template : orchProcessTemplates) {
                if (String.isNotBlank(template.LG_DecompositionCriteria__c)) {
                    Set<String> criterias = new Set<String>(template.LG_DecompositionCriteria__c.split(';'));
                    String criteria = groupedKeyToCriteria.get(key);
                    System.debug('>>>>>Criteria>>>>'+criteria);
                    System.debug('>>>>>Criterias>>>>'+criterias);
                    if (criterias.contains(criteria)) {
                        System.debug('>>>>>CriteriasPresent>>>>');
                        groupedKeyToTemplate.put(key, template);
                        break;
                    }
                }
            }
        }
        List<csord__Order__c> ordersToUpdate = new List<csord__Order__c>();
        if(!orderIdsToUpdate.isEmpty()){
        	for(Id orderId : orderIdsToUpdate){
        		csord__Order__c ord = new csord__Order__c();
        		ord.Id = orderId;
        		ord.LG_BDS__c = 'true';
        		ordersToUpdate.add(ord);
        	}
        	update ordersToUpdate;
        }
        
     }
      
     private String getGroupKeyForParent(csord__Service__c service, List<DecompositionSequence__mdt> dcList, Map<String,List<DecompositionSequence__mdt>> decomSequencMap){
     	String groupedKey;
     	String serviceKey = getServiceKey(service);
     	groupedKey = serviceKey;
     	List<String> dcFields = new List<String>(); 
        String oppChangeType = service.LG_RootOrder__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c;
     	if(!dcList.isEmpty()){
 			for(DecompositionSequence__mdt dc : dcList){
 				if(dc.ChangeType__c == null || (oppChangeType != null && dc.ChangeType__c.contains(oppChangeType))){
 					dcFields = parseFields(dc.GroupKey__c);
 					if(dc.GroupByCriteria__c == 'Override'){
 						groupedKey = groupedKey + dc.OverrideDecompostionCriteria__c;
 						if(dc.GroupKey__c != null){
 							groupedKey = formGroupKey(dcFields, service, groupedKey);
 						}
 						if(dc.GroupKey__c.contains('LG_Address__c')){
 							addressMap.put(groupedKey, service.LG_Address__r);
 						}
     					break;
 					} else {
 						groupedKey = formGroupKey(dcFields, service, groupedKey);
						if(dc.GroupKey__c.contains('LG_Address__c')){
							addressMap.put(groupedKey, service.LG_Address__r);
 						}
 						break;
     				}
 				}  				   				
     		}
 		}  
 		if(groupedKey == serviceKey){
 			dcFields = parseFields(decomSequencMap.get('default')[0].GroupKey__c);
 			groupedKey = formGroupKey(dcFields, service, groupedKey);
 		}
 		return groupedKey;
     }
     
     private List<String> parseFields(String fieldString){
     	fieldString = fieldString.replace(' ','');
     	List<String> tempFieldList = new List<String>();
     	tempFieldList = fieldString.split('\\+');
     	return tempFieldList;
     }
     
     private String formGroupKey(List<String> fieldList, csord__Service__c service, String grpKey){
     	for(String fieldName : fieldList){
     		if(fieldName == 'Id'){
     			grpKey = grpKey +'_'+ service.get(fieldName);
     		} else {
     			grpKey = grpKey + service.get(fieldName);
     		}
		}
     	return grpKey;
     }
     
     private void reGroupDecompositionCriterias(Map<String,List<DecompositionSequence__mdt>> decomSequencMap){
     	Map<String, DecompositionSequence__mdt> reGroupDecompCriteria = new Map<String, DecompositionSequence__mdt>();
     	for(String decompCriteria : decomSequencMap.keySet()){
     		for(DecompositionSequence__mdt dc : decomSequencMap.get(decompCriteria)){
     			if(dc.GroupByCriteria__c == 'ReGroup with Running Service'){
     				reGroupDecompCriteria.put(dc.ServiceDecompositionCriteria__c, dc);
     			}
     		}
     	}
     	
     	for(DecompositionSequence__mdt dc : reGroupDecompCriteria.values()){
     		if(dc.OverrideDecompostionCriteria__c != null){
     			String groupFrom = dc.ServiceDecompositionCriteria__c; //'Set 14 - CaMa Mobile';
		    	String groupTo = dc.OverrideDecompostionCriteria__c; //'Set 15 - CaMa Manual';
		        Boolean isGroupTo = false;
		        Boolean isGroupFrom = false;
		        String groupToKey = null;
		        String groupFromKey = null;
		        List<csord__Service__c> groupFromServices = new List<csord__Service__c>();
		        for (String serviceIds: groupedServices.keySet()) {
     				if (serviceIds.contains(groupTo)) {
            			isGroupTo = true;
            			groupToKey = serviceIds;
             		} else if (serviceIds.contains(groupFrom)) {
                 		isGroupFrom = true;
                 		groupFromServices = groupedServices.get(serviceIds);
                 		groupFromKey = serviceIds;
             		}
        		}
                System.debug('>>>>>GroupedServices>>>>'+groupedServices);
        		if (isGroupTo && isGroupFrom) {
                    System.debug('>>>>GroupTo'+groupTo);
                    System.debug('>>>>GroupFromServices'+groupFromServices[0]);
		            groupedServices.get(groupToKey).add(groupFromServices[0]);
		            groupedServices.remove(groupFromKey);
		            groupedKeyToCriteria.remove(groupFromKey);
		            break;
		        }
     		}
     	}
     }
     
     private Map<String,List<DecompositionSequence__mdt>> getDecompostionRecords(){
     	Map<String,List<DecompositionSequence__mdt>> decomSequencMap = new Map<String,List<DecompositionSequence__mdt>>();
     	List<DecompositionSequence__mdt> decompSequences = 
     	[ 
     		Select Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName, 
     			ChangeType__c, Comments__c, ExecutionSequence__c, 
 				GroupByCriteria__c, GroupKey__c, OverrideDecompostionCriteria__c, ServiceDecompositionCriteria__c 
     		FROM DecompositionSequence__mdt 
     		ORDER BY ExecutionSequence__c asc
     	];
     	
     	for(DecompositionSequence__mdt dc : decompSequences){
     		if(dc.ServiceDecompositionCriteria__c.contains(',')){
     			for(String sdc : dc.ServiceDecompositionCriteria__c.split(',')){
	     			List<DecompositionSequence__mdt> tempDC = new List<DecompositionSequence__mdt>();
	     			if(decomSequencMap.get(sdc) != null){
	     				tempDC = decomSequencMap.get(sdc);
	     			}
	     			tempDC.add(dc);
	     			decomSequencMap.put(sdc,tempDC); 
     			}
     		} else {
     			List<DecompositionSequence__mdt> tempDC = new List<DecompositionSequence__mdt>();
     			if(decomSequencMap.get(dc.ServiceDecompositionCriteria__c) != null){
     				tempDC = decomSequencMap.get(dc.ServiceDecompositionCriteria__c);
     			}
     			tempDC.add(dc);
     			decomSequencMap.put(dc.ServiceDecompositionCriteria__c,tempDC);
     		}
     		
     	}
     	return decomSequencMap; 
     }
     
    public String getServiceKey(csord__Service__c service) {
      //  return service.LG_RootOrder__c; /// Updated  for SFOM-1761
        return service.LG_RootOrder__c;
 //       return service.csord__Order__c + '-' + service.LG_RootOrder__c;
    }

    /**
     * Creates the solutions records that will be used as a master
     * to the grouped services.
     * Also updates the services with the relevant Solution references.
     *
     * @author Tomislav Blazek
     * @ticket SFOM-25
     * @since  11/11/2016
     */
    private void createSolutionRecords()
    {
        suborders = new Map<String, csord__Solution__c>();
        String provisioningAccountNumber = null;
        Id suborderRecType = Schema.SObjectType.csord__Solution__c.getRecordTypeInfosByName().get('Suborder').getRecordTypeId();
        List<cscrm__Address__c> addressToUpdate = new List<cscrm__Address__c>();
        Group Qid = [select Id from Group where Type = 'Queue' and name = 'Order Management' Limit 1];
        System.debug('>>>>GroupedServices'+groupedServices);
        for (String key : groupedServices.keySet()) {

            System.debug('groupedKeyToTemplate -> ' + groupedKeyToTemplate);
            System.debug('>>>>>>'+key);
            String solutionName= groupedKeyToTemplate.get(key).Name;
            String suborderName=groupedKeyToTemplate.get(key).Name;
             String allServices='';
            cscrm__Address__c address = addressMap.get(key);
            Id addressId;
            Id orderId   = groupedServices.get(key)[0].LG_RootOrder__c;
            Id accountId = groupedServices.get(key)[0].LG_RootOrder__r.csord__Account__c;
			Boolean waitForAccess = groupedServices.get(key)[0].UM_WaitForAccess__c;
            Boolean installationNeeded = false;
            Boolean activationNeeded   = false;

            // Check if at least one service requires installation or activation
            for (csord__Service__c service : groupedServices.get(key)) {

                // If true set value
                if (service.LG_Activationneeded__c) {
                    activationNeeded = true;
                }

                // If true set value
                if (service.LG_InstallationNeeded__c) {
                    installationNeeded = true;
                }

                // If both of them are true stop the loop. If not continue looping
                if (activationNeeded && installationNeeded) {
                    break;
                }
            }

            //update State/Province field on address  from UM_State__c field on a service if State/Province is empty
            //added by Usha Punia (SFOM - 981)

            for (csord__Service__c service : groupedServices.get(key)) {
               allServices += service.name +',';
                if(service.LG_address__c != null){
                    if(service.LG_Address__r.cscrm__State_Province__c == null || service.LG_Address__r.cscrm__State_Province__c == '' ){
                        system.debug('enter if');
                        // service.LG_Address__r.cscrm__State_Province__c = service.UM_State__c;

                        cscrm__Address__c a = new cscrm__Address__c();
                        a.id = service.LG_Address__c;
                        a.cscrm__State_Province__c = service.UM_State__c;
                        addressToUpdate.add(a);
                        system.debug('Check# ' + a.cscrm__State_Province__c + '-- '+ service.UM_State__c );
                    }
                }
            }
             allServices=allServices.removeEnd(',');
            // update addressToUpdate ;
            // SFOM-1929 changes

            for (csord__Service__c service : groupedServices.get(key)) {
                if (service.LG_ProvisioningAccountNo__c != null || service.UM_DependsOnService__r.LG_ProvisioningAccountNo__c != null) {
                    provisioningAccountNumber = service.LG_ProvisioningAccountNo__c!=null?service.LG_ProvisioningAccountNo__c:service.UM_DependsOnService__r.LG_ProvisioningAccountNo__c;
                    break;
                }
            }
            system.debug('Provisioning account number is ' + provisioningAccountNumber);
            // SFOM-1929 changes ends


            if (address != null) {
                solutionName += ' - ' + address.cscrm__Address_Details__c;
                addressId     = address.Id;
            }

            Id oldSuborderId = null;

            if (oldSubordersMap.containsKey(orderId) && !oldSubordersMap.get(orderId).isEmpty()) {
                //match the old suborder based on the key fields
                for (csord__Solution__c oldSuborder : oldSubordersMap.get(orderId)) {
                    if (oldSuborder.LG_Address__c == addressId
                        && oldSuborder.LG_InstallationWishDate__c == targetDatesMap.get(key)
                        && oldSuborder.LG_DecompositionCriteria__c == groupedKeyToCriteria.get(key)) {
                        oldSuborderId = oldSuborder.Id;
                        break;
                    }
                }
                //if there was no match found, try to match by address and decompose criteria, if there is any match,
                //take the one having the closest date
                if (oldSuborderId == null) {
                    csord__Solution__c closestByDate = null;

                    for (csord__Solution__c oldSuborder : oldSubordersMap.get(orderId)) {
                        if (oldSuborder.LG_Address__c == addressId
                            && oldSuborder.LG_DecompositionCriteria__c == groupedKeyToCriteria.get(key)) {
                            if (closestByDate == null) {
                                closestByDate = oldSuborder;
                            }

                            Date newInstallDate = targetDatesMap.get(key);

              if (newInstallDate == null || oldSuborder.LG_InstallationWishDate__c == null){
                continue;
              }

                            Integer daysBetweenOldNew     = Math.abs(newInstallDate.daysBetween(oldSuborder.LG_InstallationWishDate__c));
                            Integer daysBetweenClosestNew = Math.abs(newInstallDate.daysBetween(closestByDate.LG_InstallationWishDate__c));

                            if (daysBetweenOldNew < daysBetweenClosestNew) {
                                closestByDate = oldSuborder;
                            }
                        }
                    }

                    if (closestByDate != null) {
                        oldSuborderId = closestByDate.Id;
                    }
                }
            }

            suborders.put(key, new csord__Solution__c(Name=suborderName,
            										  LG_Solution_Name__c = solutionName,
            	                                      LG_Service__c=allServices,
                                                      RecordTypeId = suborderRecType,
                                                      csord__Order__c = orderId,
                                                      csord__Account__c = accountId,
                                                      LG_OldSuborder__c = oldSuborderId,
                                                      LG_Address__c = addressId,
                                                      LG_TargetDate__c = targetDatesMap.get(key),
                                                      LG_InstallationWishDate__c = targetDatesMap.get(key),
                                                      LG_DecompositionCriteria__c = groupedKeyToCriteria.get(key),
                                                      csord__Identification__c = solutionName,
                                                      LG_ActivationNeeded__c = activationNeeded,
                                                      LG_InstallationNeeded__c = installationNeeded,
                                                      LG_Termination__c = isTerminationSuborder(key, orderId),
                                                      Ownerid = Qid.id,
                                                      LG_ProvisioningAccountNo__c = provisioningAccountNumber,
                                                      //Ownerid = System.Label.order_management_queue_id,  // (00G6E000000QgYs) To change the owner from opportunity to order management queue
                                                      csord__Status__c = 'In Progress',
                                                      UM_WaitForAccess__c = waitForAccess,
                                                      csord__Type__c = 'Suborder'));
        system.debug('key :'+key);
        system.debug('groupedKeyToCriteria :'+groupedKeyToCriteria.get(key));
        }

        insert suborders.values();

        List<csord__Service__c> servicesToUpdate = new List<csord__Service__c>();
        system.debug('**pAcctNo'+pAcctNo);
    Set<Id> parentIds = new Set<Id>();
    Map<Id, csord__Service__c> parentService = new Map<Id, csord__Service__c>();
        string dependAcctNo;

        for (String key : groupedServices.keySet()) {
            for (csord__Service__c service : groupedServices.get(key)) {
                service.LG_OldSuborder__c = service.LG_Suborder__c;
                service.LG_Suborder__c    = suborders.get(key).Id;
                //if service is the one being terminated, reparent it back to the original order, so we do not
                //lose track of it
                if (terminatedServicesIds.contains(service.Id) && servicesToTerminateOrder.containsKey(service.Id)) {
                    service.LG_RootOrder__c = servicesToTerminateOrder.get(service.Id);
                }
                system.debug('**terminatedServicesIds'+terminatedServicesIds);

                //SFOM - 1929 changes
                if (service.LG_ProvisioningAccountNo__c == null) {
                    service.LG_ProvisioningAccountNo__c = provisioningAccountNumber;
                }


                //added for sfom-1130 to copy provisioning acct No


                if (service.LG_ProvisioningSystem__c=='CAMA') {
                    system.debug('**change type'+service.LG_RootOrder__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c);


                    if (service.LG_RootOrder__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c=='Move') {
                        system.debug('**its move');
                                    system.debug('**temi'+suborders.get(key).LG_Termination__c);
                        if (suborders.get(key).LG_Termination__c==true) {
                            if (service.csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c!=null) {
                                system.debug('**entered into move');
                                           service.LG_ProvisioningAccountNo__c=service.csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c;

                                         }

                                     }

                    } else if (service.LG_RootOrder__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c=='Change') {
                        if (service.csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c!=null && service.csordtelcoa__Replaced_Service__c!=null) {
                            system.debug('--service1'+service.Id);
                            service.LG_ProvisioningAccountNo__c = service.csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c;
                            dependAcctNo                        = service.LG_ProvisioningAccountNo__c;

                               }

                        /* else if(service.UM_DependsOnService__c!=null && service.csordtelcoa__Replaced_Service__c==null)
                           {    system.debug('--deoends'+service.UM_DependsOnService__c);
                           system.debug('--service2'+service.Id);
                           system.debug('--dependAcctNo'+dependAcctNo);
                           system.debug('--deoendsacctno'+service.UM_DependsOnService__r.LG_ProvisioningAccountNo__c);
                             if(service.UM_DependsOnService__r.LG_ProvisioningAccountNo__c!=null ){
                             service.LG_ProvisioningAccountNo__c=service.UM_DependsOnService__r.LG_ProvisioningAccountNo__c;
                                         }
                             else{
                              service.LG_ProvisioningAccountNo__c=dependAcctNo;
                               }
                           }*/
                    } else if (LG_Util.getMigrateVarietyChangeTypes().contains(service.LG_RootOrder__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c)) {

                        if (pAcctNo!=null) {
                            service.LG_ProvisioningAccountNo__c = pAcctNo;
                                        }
                                   }
                               }

                servicesToUpdate.add(service);
        parentIds.add(service.Id);
        parentService.put(service.Id, service);
            }
        }
    //OMB-773
    updateSolutionIdToChildren(parentIds, parentService, servicesToUpdate);

        update servicesToUpdate;
    }
     /**
     * linking BDS with Access
     * Updating VDSL AND CCC 
     *
     * @author Preetha N
     * @ticket DGT-117
     * @since  12/02/2018
 */

  PUBLIC void updateDependOnService(List<csord__Service__c> bdsServices){
      
        system.debug('updateDependOnService===preetha');
        List<csord__Service__c> servicesToUpdate=new List<csord__Service__c>();
        Map<Id,csord__Service__c> dependOnservicesMap=new Map<Id,csord__Service__c>();
        Map<Id,csord__Service__c> secondaryServicesMap=new Map<Id,csord__Service__c>();
        Set<Id> dependOnserviceIds=new Set<Id>();
        Set<Id> secondaryServiceIds=new Set<Id>();

        for(csord__Service__c bdsService:bdsServices){
		
            if(bdsService.UM_DependsOnService__c!=null){
                 dependOnserviceIds.add(bdsService.UM_DependsOnService__c);
                 dependOnservicesMap.put(bdsService.UM_DependsOnService__c,bdsService);
             }
             if(bdsService.LG_DependsOnSecondaryService__c!=null){
				secondaryServiceIds.add(bdsService.LG_DependsOnSecondaryService__c);
				secondaryServicesMap.put(bdsService.LG_DependsOnSecondaryService__c,bdsService);
             }
        }
        
                  system.debug('dependOnservicesMap=='+dependOnservicesMap); 

        List<csord__Service__c> serv=[select id,UM_DownloadSpeed__c,LG_Primary_Access_Network__c,LG_Primary_Access_Type__c, name,LG_Hardware__c,LG_Secondary_Access_Network__c,LG_Secondary_Access_Type__c from  csord__Service__c where id IN : dependOnserviceIds];
        List<csord__Service__c> secList=[select id,UM_DownloadSpeed__c,LG_Primary_Access_Network__c,LG_Primary_Access_Type__c, name,LG_Hardware__c,LG_Secondary_Access_Network__c,LG_Secondary_Access_Type__c from  csord__Service__c where id IN : secondaryServiceIds];
      
          system.debug('secList=='+secList.size()); 
          system.debug('serv=='+serv.size()); 

          for(csord__Service__c b:serv){
                system.debug('in primservary loop'); 
                system.debug('dependOnservicesMap.get(b.id)=='+dependOnservicesMap.get(b.id));
				b.LG_Primary_Access_Network__c=dependOnservicesMap.get(b.id).LG_Primary_Access_Network__c;
				b.LG_Primary_Access_Type__c=dependOnservicesMap.get(b.id).LG_Primary_Access_Type__c;
				b.UM_DownloadSpeed__c=dependOnservicesMap.get(b.id).UM_DownloadSpeed__c;
				b.LG_Hardware__c=dependOnservicesMap.get(b.id).LG_Hardware__c;
				b.LG_Primary_Check__c=true;
				servicesToUpdate.add(b);
            }
   
            for(csord__service__c sec:secList){
                system.debug('in secon loop'); 
				sec.LG_Secondary_Access_Network__c=secondaryServicesMap.get(sec.id).LG_Secondary_Access_Network__c;
				sec.LG_Secondary_Access_Type__c=secondaryServicesMap.get(sec.id).LG_Secondary_Access_Type__c;
				sec.UM_DownloadSpeed__c=secondaryServicesMap.get(sec.id).UM_DownloadSpeed__c;
				sec.LG_Hardware__c=secondaryServicesMap.get(sec.id).LG_Hardware__c;
				sec.LG_Secondary_Value__c=true;
				servicesToUpdate.add(sec);
			}
      
      
       
       
        try{
            if(!servicesToUpdate.isEmpty()){
                update servicesToUpdate;
         system.debug('servicesToUpdatedddd bds methos=='+servicesToUpdate);  
   
            }
        }catch(Exception e){
            system.debug(e);
        }
        
        }
        
    

    /**
     * Checks whether suborder is a termination suborder - all services on the suborder
     * are linked to an order that is not the parent of the suborder.
     *
     * @author Tomislav Blazek
     * @ticket SFOM-379
     * @since  29/5/2017
     */
    private Boolean isTerminationSuborder(String key, Id orderId)
    {
        Boolean isTermination = true;
        for (csord__Service__c service : groupedServices.get(key)) {
            String originalOrder = service.LG_RootOrder__c;

            /*if (servicesToTerminateOrder.containsKey(service.Id)) {
                originalOrder = servicesToTerminateOrder.get(service.Id);
            }*/
            if (servicesToTerminateOrder.containsKey(service.Id) && terminatedServicesIds.contains(service.Id)) {
                originalOrder = servicesToTerminateOrder.get(service.Id);
            }
            if (orderId == originalOrder) {
                isTermination = false;
                break;
            }
        }

        return isTermination;
    }

    /**
     * Reparents the penalty fee service line items
     * to the services being terminated.
     *
     * @author Tomislav Blazek
     * @ticket SFOM-367
     * @since  16/2/2017
     */
    private void updatePenaltyFeeLineItems()
    {
        List<csord__Service_Line_Item__c> slisToUpdate = new List<csord__Service_Line_Item__c>();
        for (csord__Service__c service : penaltyFeeServices) {
            for (csord__Service_Line_Item__c sli : service.csord__Service_line_Items__r) {
                sli.csord__Service__c = sli.csord__Service__r.LG_TerminatedService__c;
                sli.LG_IsPenaltyFee__c = true;
                sli.csordtelcoa__Delta_Status__c = 'Added';
                slisToUpdate.add(sli);
            }
        }
        for (csord__Service__c service : terminationServices) {
            for (csord__Service_Line_Item__c sli : service.csord__Service_line_Items__r) {
                sli.csord__Service__c            = sli.csord__Service__r.csordtelcoa__Replaced_Service__c;
                sli.LG_IsPenaltyFee__c           = true;
                sli.csordtelcoa__Delta_Status__c = 'Added';
                slisToUpdate.add(sli);
            }
        }

        if (!slisToUpdate.isEmpty()) {
            update slisToUpdate;
        }
    }

    /**
     * Deletes the subscriptions/services related to the Termination products
     * and to the Penalty Fee product. (No use of these records, so no need
     * to have them)
     *
     * @author Tomislav Blazek
     * @ticket SFOM-692
     * @since  1/5/2017
     */
    private void deleteTerminationRecords()
    {
        Set<Id> subscriptionsToDeleteIds = new Set<Id>();

        for (csord__Service__c service : [SELECT csord__Subscription__c
                                          FROM csord__Service__c
                                          WHERE LG_RootOrder__c IN :orderIds
                                          AND (csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_ProductSubtype__c = 'Termination'
                                                OR csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_ProductSubtype__c = 'Penalty Fee')]) {
            subscriptionsToDeleteIds.add(service.csord__Subscription__c);
        }

        if (!subscriptionsToDeleteIds.isEmpty()) {
            delete [SELECT Id FROM csord__Subscription__c WHERE Id IN:subscriptionsToDeleteIds];
        }
    }

    /**
     * Move and Migrate orders must have field Wait for New Provide set to true.
     *
     * @author Tomislav Blazek
     * @ticket SFOM-379
     * @since  29/5/2017
     */
    private void updateMoveMigrateOrders()
    {
        List<csord__Order__c> ordersToUpdate = new List<csord__Order__c>();

        for (Id orderId : moveMigrateOrders) {
            ordersToUpdate.add(new csord__Order__c(Id = orderId, LG_WaitForNewProvide__c = true));
        }

        if (!ordersToUpdate.isEmpty()) {
            update ordersToUpdate;
        }
    }

    /**
     * Starts the orchestrator process for each order,
     * and each Solution record.
     *
     * @param  List<Id> orderIds
     * @author Tomislav Blazek
     * @ticket SFOM-25
     * @since  11/11/2016
     */
    private void startOrchestratorProcesses(List<Id> orderIds)
    {
        List<CSPOFA__Orchestration_Process__c> processesToStart = new List<CSPOFA__Orchestration_Process__c>();

        if (orchestrateOrderProcess != null) {
            System.debug('>>>>insideOrchProcess000'+orderIds);
            for (Id orderId : orderIds) {
                System.debug('>>>>insideOrchProcess11'+OrderId);
                processesToStart.add(new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orchestrateOrderProcess.Id,
                                                                          LG_Order__c = orderId));
                                                                          System.debug('>>>>insideOrchProcess222');
            }
        }
System.debug('>>>>outsideOrchProcess'+suborders);
        for (String key : suborders.keySet()) {
            System.debug('>>>>outsideOrchProcess1111');
            processesToStart.add(new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = groupedKeyToTemplate.get(key).Id,
                                                                      LG_Solution__c = suborders.get(key).Id, LG_order__c = suborders.get(key).csord__Order__c));
                                                                      System.debug('>>>>outsideOrchProcess222');
            
            
        }

        insert processesToStart;
    }

    private Boolean isSiteAgnostic(String productFamily)
    {
        if (siteAgnosticProdFamilies == null) {
            siteAgnosticProdFamilies = LG_Util.commaSeparatedStringToSet(
                LG_OrderDecompositionSettings__c.getAll().get('VM').LG_SiteAgnosticProductFamilies__c);

        }

        return siteAgnosticProdFamilies.contains(productFamily);
    }

    /*
     * Resolves Service Statuses
     *
     * @param  csord__Service__c service
     * @author Petar Miletić
     * @ticket SFOM-131
     * @since  19/01/2017
     */
    private void resolveInstallationAndActivation(csord__Service__c service) {

        if (service == null || service.csordtelcoa__Product_Configuration__c == null) {

            return;
        }

        // If Delta Status is of Add type, use the first value from the CSV (e.g. Y from Y,N,Y). If N, set the Needs Activation on Service to "false", otherwise to "true"
        // If Delta Status is of Change type, use the second value from the CSV (e.g. N from Y,N,Y). If N, set the Needs Activation on Service to "false", otherwise to "true"
        // If Delta Status is of Change type, use the third value from the CSV (e.g. Y from Y,N,Y). If N, set the Needs Activation on Service to "false", otherwise to "true"
        // If value on product definition is blank for some reason, assume Y.

        String needsActivation   = service.csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_NeedsActivation__c;
        String needsInstallation = service.csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_NeedsInstallation__c;

        if (String.isBlank(needsInstallation)) {
            service.LG_InstallationNeeded__c = true;
        } else {
            service.LG_InstallationNeeded__c = needsInstallation.split(',')[getDeltaIndex(service)] == 'Y';
        }

        if (String.isBlank(needsActivation)) {
            service.LG_Activationneeded__c = true;
        } else {
            service.LG_Activationneeded__c = needsActivation.split(',')[getDeltaIndex(service)] == 'Y';
        }
    }

    /*
     * Get delta index. Data is formatted as X,X,X (Add, Change, Delete) which translates to indexes 0,1,2
     */
    private Integer getDeltaIndex(csord__Service__c service) {

        Integer index = 0;

        if (service.csordtelcoa__Delta_Status__c == 'Added To Subscription') {
            index = 0;
        } else if (service.csordtelcoa__Delta_Status__c == 'Continuing In Subscription') {
            index = 1;
        } else if (service.csordtelcoa__Delta_Status__c == 'Deleted From Subscription') {
            index = 2;
        }

        return index;
    }
    /**
     * update suborder fields from the services
     *
     * @param  Map<String, csord__Solution__c> suborders
     * @author Minhaj Alam
     * @ticket SFOM-403
     * @since  29/05/2017
     */
    public void sumUpServices(Map<String, csord__Solution__c> suborders){

        List<Id> suborderIds                                = new List<Id>();
        List<csord__Solution__c> suborderToUpdate           = new List<csord__Solution__c>();
        Map<Id, List<csord__Service__c>> suborderServiceMap = new Map<Id, List<csord__Service__c>>();
        Map<Id, csord__Solution__c> suborderIdMap           = new Map<Id, csord__Solution__c>();

        for (csord__Solution__c suborder : suborders.values()) {
            suborderIds.add(suborder.Id);
            suborderIdMap.put(suborder.Id, suborder);
        }


        List<csord__Service__c> services = [SELECT LG_Suborder__c,LG_ContractEndDate__c,LG_ContractStartDate__c, Name, csord__Total_One_Off_Charges__c, csord__Total_Recurring_Charges__c,LG_ProductFamily__c FROM csord__Service__c WHERE LG_Suborder__c IN : suborderIds];

        for (csord__Service__c service : services) {
            List<csord__Service__c> serviceList = new List<csord__Service__c>();

            if (suborderServiceMap.containsKey(service.LG_Suborder__c)) {
                serviceList = suborderServiceMap.get(service.LG_Suborder__c);
            }
            serviceList.add(service);

            suborderServiceMap.put(service.LG_Suborder__c, serviceList);
        }

        for (Id suborderId : suborderServiceMap.keySet()) {

            double totalRecurringCharges = 0.00;
            double totalOneOffCharges    = 0.00;
            double totalRentalPrice      = 0.00;
            Integer contractPeriod = 1;
            list<String>  serviceNames = new list<String>();
            integer serviceCount = 0;

            //calculate for all services under sub order
            for (csord__Service__c service : suborderServiceMap.get(suborderId)) {


                serviceNames.add(service.name);
                if (service.LG_ContractEndDate__c!=null && service.LG_ContractStartDate__c!=null) {
                    contractPeriod = service.LG_ContractStartDate__c.monthsBetween(service.LG_ContractEndDate__c);
                    system.debug('--contractPeriod'+contractPeriod);

                }

                if (service.csord__Total_One_Off_Charges__c != null) {
                    totalOneOffCharges += service.csord__Total_One_Off_Charges__c;
                }

                if (service.csord__Total_Recurring_Charges__c != null) {
                    totalRecurringCharges += service.csord__Total_Recurring_Charges__c;
                    totalRentalPrice      += service.csord__Total_Recurring_Charges__c * contractPeriod;
                    system.debug('--totalRentalPricePerService'+totalRentalPrice);

                }

                serviceCount++;
            }

            csord__Solution__c suborder = suborderIdMap.get(suborderId);
            if (LG_ValidateOpportunity__c.getInstance().Org_Name__c == 'VMB') {
                suborder.VM_MainComponent__c      = String.join(serviceNames,',');
                suborder.VM_Count_of_Services__c  = serviceCount;
                suborder.VM_Total_Rental_Price__c = totalRentalPrice;
            }
            suborder.LG_Total_One_off__c        = totalOneOffCharges;
            suborder.LG_Total_Recurring__c      = totalRecurringCharges;
            suborder.LG_Total_Suborder_Value__c = totalOneOffCharges + totalRentalPrice;


            suborderToUpdate.add(suborder);
        }

        update suborderToUpdate;

    }
    /**
     * get the dependent service for the depeds on service
     *
     * @param  csord__Service__c service
     * @author Minhaj Alam
     * @ticket SFOM-1038
     * @since  27/06/2017
     */
/*
    public csord__Service__c getDependentService(csord__Service__c service)
    {
        csord__Service__c dependentServ = null;
        for (Id serviceId : serviceToDependsOn.keySet()) {
            if (serviceToDependsOn.get(serviceId) == service.Id || serviceId == service.Id) {
                if(serviceId == service.Id) { //it is a dependent service
                    dependentServ = service;
                    break;
                } else if (serviceToDependsOn.get(serviceId) == service.Id) {//it is a dependsOn service
                    dependentServ = dependentService.get(serviceId);
                    break;
                }
            }
        }

        return dependentServ;
    }
*/
     public csord__Service__c getParentService(Id parentServiceId)
    {

        csord__Service__c parenttServ = null;
        for (csord__Service__c service : services) {
            if (service.id == parentServiceId)
                return service;

        }

     return parenttServ;
    }

    /**
     * update solution id in all child services
     *
     *
     * @author Minhaj Alam
     * @ticket OMB-773
     * @since  10/08/2017
     */
    public void updateSolutionIdToChildren(Set<Id> parentIds, Map<Id, csord__Service__c> parentService, List<csord__Service__c> servicesToUpdate)
  {
    Set<Id> childrenId = new Set<Id>();
    parentToChildren = new Map<Id, Set<csord__Service__c>>();
    parentToChildrenId = new Map<Id, Set<Id>>();
        List<csord__Service__c> childrenList = new List<csord__Service__c>();
    //get all the child services for the order

        childrenList = [SELECT Id, Name, csord__Service__c,csord__Order__c, LG_RootOrder__c, LG_ProvisioningSystem__c,csord__Service__r.csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c,LG_RootOrder__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c,LG_ProvisioningAccountNo__c ,csord__Service__r.csordtelcoa__Replaced_Service__c, csord__Subscription__r.csordtelcoa__Change_Type__c, csordtelcoa__Delta_Status__c,LG_ProductFamily__c  FROM csord__Service__c WHERE LG_RootOrder__c IN :orderIds AND csord__Service__c != null AND LG_DecompositionCriteria__c = null];
        //Added LG_DecompositionCriteria__c=null for decomposition criteria case

    childrenId = getChildren(parentIds, childrenList, true);
    while(!childrenId.isEmpty()) {
      childrenId = getChildren(childrenId, childrenList, false);
    }
    //update the solution id for all children with solutionid from root parent
    for (Id parentId :parentToChildren.keySet()) {
      for (csord__Service__c childService :parentToChildren.get(parentId)) {
        childService.LG_Suborder__c = parentService.get(parentId).LG_Suborder__c;
        childService.LG_OldSuborder__c = parentService.get(parentId).LG_OldSuborder__c;
        //SFOM-1786
        if (childService.csord__Subscription__r.csordtelcoa__Change_Type__c == 'Move' && childService.csordtelcoa__Delta_Status__c == 'Continuing In Subscription'){
            childService.csordtelcoa__Delta_Status__c = null;
        }

                if(childService.LG_ProvisioningSystem__c=='CAMA' && childService.LG_RootOrder__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c == 'Change')
                {
                    if(childService.csord__Service__c!=null && childService.csord__Service__r.csordtelcoa__Replaced_Service__c!=null
                                && childService.csord__Service__r.csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c!=null)
                    {
                       childService.LG_ProvisioningAccountNo__c = childService.csord__Service__r.csordtelcoa__Replaced_Service__r.LG_ProvisioningAccountNo__c;
                    }
                }
        servicesToUpdate.add(childService);
      }

    }
  }

  /**
     * get the children to be processed
     *
     * store the all children to the root parent in  parentToChildren map
     *
     * @author Minhaj Alam
     * @ticket OMB-773
     * @since  10/08/2017
     */
    public Set<Id> getChildren(Set<Id> parentIds, List<csord__Service__c> childrenList, Boolean firstLevel)
  {
        Set<Id> childrenId = new Set<Id>();
        if (!childrenList.isEmpty()) {
          List<csord__Service__c> children = new List<csord__Service__c>();
          //fetch children of parentids from list children
      for (Integer i = (childrenList.size()-1) ; i >= 0 ; i--) {
              if (parentIds.contains(childrenList[i].csord__Service__c)) {
                      children.add(childrenList[i]);
                      //remove the children from childrenList which are processed
                      childrenList.remove(i);
              }
        }
      if (!children.isEmpty()) {
        for (csord__Service__c  child :children) {
                  //create Map<Id, Set<csord__Service__c>> [parentId, children] for first level of children
                  //and use the same parent to store children for all level
                  if (firstLevel) {
                      Set<csord__Service__c> serviceList = new Set<csord__Service__c>();
                      Set<Id> serviceId = new Set<Id>();
                      if (parentToChildrenId.containsKey(child.csord__Service__c)) {
                          serviceList =  parentToChildren.get(child.csord__Service__c);
                          serviceId =  parentToChildrenId.get(child.csord__Service__c);
                      }
                      serviceList.add(child);
                      serviceId.add(child.Id);
                      parentToChildren.put(child.csord__Service__c, serviceList);
                      parentToChildrenId.put(child.csord__Service__c, serviceId);
                  } else {
                    //Add children to the same paren Id created in first level
                      for (Id  parentId :parentToChildren.keySet()) {
                          if (parentToChildrenId.get(parentId).contains(child.csord__Service__c)) {
                              Set<csord__Service__c> serv = parentToChildren.get(parentId);
                              serv.add(child);
                              Set<Id> servId = parentToChildrenId.get(parentId);
                              servId.add(child.Id);
                              parentToChildren.put(parentId, serv);
                              parentToChildrenId.put(parentId, servId);
                          }
                      }
          }
          childrenId.add(child.Id);
        }
        system.debug('childrenId :'+childrenId);
      }
      system.debug('parentToChildren :'+parentToChildren);
        }
    return childrenId;
  }
}