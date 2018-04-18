global class ProductBasketUploadedEventHandler extends csac.RestApiEventHandler {
 
    public override csac.RestApiResponse handleEvent(Object payload) {
        system.debug('Uploaded a product basket!');
        system.debug(payload);
        
        if(payload == null) {
            return new csac.RestApiResponse('Failure!', 'Payload object is null.');
        }
        
        string basketId = '';
        if(payload instanceof map<string, string>) {
            map<string, string> m = (map<string, string>)payload;
            system.debug(m);
            basketId = m.get('Id');
        }
        
        if (basketId != '') {
            setAddressAndInstallationWishDate(basketId);
            
            return new csac.RestApiResponse('Success!', 'After-basket-upload job is done.');
        }
        else {
            return new csac.RestApiResponse('Failure!', 'Basket ID is empty, impossible..');
        }
    }

    /*
     * This was moved from LG_ProductConfigurationTriggerHandler:
     * The wish date & Installation date selected in the D2D app is not visible in the "Installation Information per site" page in SF
	 * Update LG_Address__c in because it is overriden from package in classic update
	 * Trigger the quoting process after a basket has been uploaded with all the configs
    */
    private static void setAddressAndInstallationWishDate(string basketID) {

    	// All product configurations of the just uploaded product basket
		// Basket IDs (this was the fucntion's argument before)
		Set<Id> productConfigurationIds = new Set<Id>();
		Set<Id> basketIDs = new Set<Id>();
		
        // bug fix: we're getting basketID from CSA with ? at the end (OMB-3481/3483)
        String basketIdremovedEnd = basketID.removeEnd('?');
        basketIDs.add(Id.valueOf(basketIdremovedEnd));

        // Product Configurations that require PCR Optionals recreation
        Set<Id> pcIDs = new Set<Id>();

        // Opportunity Id's in this context
        Set<Id> setOppId = new Set<Id>();
        
        // Product Configurations that will be updated (Address and Installation Date)
        List<cscfga__Product_Configuration__c> pcUpdate = new List<cscfga__Product_Configuration__c>();

        Map<Id, cscfga__Product_Basket__c> pbMap = new Map<Id, cscfga__Product_Basket__c>([SELECT Id, LG_PreferredInstallationDate__c, LG_InstallationCity__c,
                                                                                            LG_InstallationCountry__c, LG_InstallationHouseNumber__c, LG_InstallationStreet__c,
                                                                                            LG_InstallationPostalCode__c, LG_InstallationHouseNumberExtension__c,
                                                                                            LG_SharedOfficeBuilding__c, LG_COAXConnectionLocation__c, csbb__Account__c, cscfga__Opportunity__c
                                                                                            FROM cscfga__Product_Basket__c WHERE Id IN :basketIDs AND LG_CreatedFrom__c = 'Tablet']);

        // If map is empty end execution
        if (pbMap.isEmpty()) {
            return;
        }

        // fetch all pcs from the uploaded basket
		List<cscfga__Product_Configuration__c> basketProductConfigs = new List<cscfga__Product_Configuration__c>(
		    [SELECT Id FROM cscfga__Product_Configuration__c WHERE cscfga__Product_Basket__c IN :basketIDs]);
		
		for (cscfga__Product_Configuration__c p : basketProductConfigs) {
			productConfigurationIds.add(p.Id);
		}

        List<cscfga__Product_Configuration__c> productConfigurations = [SELECT Id, LG_Address__c, LG_InstallationWishDate__c, cscfga__Product_Basket__c 
                                                                        FROM cscfga__Product_Configuration__c WHERE Id IN :productConfigurationIds];

        List<cscrm__Address__c> addresses = new List<cscrm__Address__c>();
        
        for (cscfga__Product_Basket__c pb :pbMap.values()) {
            addresses.add(LG_Util.createNewPremise(pb));
            setOppId.add(pb.cscfga__Opportunity__c);
        }

        if (!addresses.isEmpty()) {
            LG_Util.resolveAndUpsertPremiseDuplicates(addresses);
        }

        for (cscfga__Product_Configuration__c pc : productConfigurations) {
            
            if (pbMap.containsKey(pc.cscfga__Product_Basket__c)) {
                
                if (!addresses.isEmpty() && pc.LG_Address__c == null) {
                    pc.LG_Address__c = addresses[0].Id;
                    
                    pcIDs.add(pc.Id);
                }

                if (pc.LG_InstallationWishDate__c == null) {
                    pc.LG_InstallationWishDate__c = pbMap.get(pc.cscfga__Product_Basket__c).LG_PreferredInstallationDate__c;
                }
                
                pcUpdate.add(pc);
            }
        }
        
        // Update Product Configurations
        if (!pcUpdate.isEmpty()) {
            update pcUpdate;
        }
        
        if (!pcIDs.isEmpty() && !addresses.isEmpty()) {
            UpdateAddressField(pcIDs);
        }

        // start Congra workflow
        if (setOppId.size() > 0) {
			List<Opportunity> lstOpportunity = [SELECT Id, LG_AutomatedQuoteDelivery__c, StageName FROM Opportunity WHERE Id in : setOppId];

			List<Opportunity> lstOpportunityUpdate = new List<Opportunity>();

			for (Opportunity tmpOpportunity : lstOpportunity) {
				if (tmpOpportunity.StageName == 'Awareness of interest') {
					tmpOpportunity.LG_AutomatedQuoteDelivery__c = 'Quote Requested';
					lstOpportunityUpdate.add(tmpOpportunity);
				}
			}

			if (lstOpportunityUpdate.size() > 0) update lstOpportunityUpdate;

		}
    }

    /*
     * Update csbb__Optionals__c for PCR's (if field is empty address is not visible in TSC console)
    */
    private static void UpdateAddressField(Set<Id> productConfigurationIDs) {
        
        // Resolve csbb__Optionals ond PCR
        Map<Id, cscfga__Product_Configuration__c> prodcutConfigurations = new Map<Id, cscfga__Product_Configuration__c>([SELECT Id, LG_Address__r.Id, LG_Address__r.cscrm__City__c,
                                                                                                                             LG_Address__r.cscrm__Zip_Postal_Code__c, LG_Address__r.LG_HouseNumberExtension__c,
                                                                                                                             LG_Address__r.LG_HouseNumber__c, LG_Address__r.cscrm__Street__c,LG_Address__r.cscrm__State_Province__c,
                                                                                                                             LG_Address__r.LG_AddressID__c,LG_Address__r.cscrm__Geolocation__Latitude__s,LG_Address__r.cscrm__Geolocation__Longitude__s,
                                                                                                                             cscfga__Product_Basket__c, cscfga__Product_Basket__r.csbb__Account__c
                                                                                                                             FROM cscfga__Product_Configuration__c
                                                                                                                             WHERE ID IN :productConfigurationIDs]);
        // Get related PCR's
        List<csbb__Product_Configuration_Request__c> pcReq =  [SELECT Id, csbb__Optionals__c, csbb__Product_Configuration__c FROM csbb__Product_Configuration_Request__c WHERE csbb__Product_Configuration__c IN :productConfigurationIDs];

        for (csbb__Product_Configuration_Request__c r :pcReq) {
            
            if (prodcutConfigurations.containsKey(r.csbb__Product_Configuration__c) && prodcutConfigurations.get(r.csbb__Product_Configuration__c).LG_Address__r != null) {
            //if (prodcutConfigurations.containsKey(r.csbb__Product_Configuration__c) && checkAddressFields(prodcutConfigurations.get(r.csbb__Product_Configuration__c))) {
                r.csbb__Optionals__c = JSON.serialize(new LG_AddressResponse.OptionalsJson(prodcutConfigurations.get(r.csbb__Product_Configuration__c).LG_Address__r));
            }
        }
        system.debug('--+ pcReq: '+pcReq);       
        update pcReq;
    }
 
}