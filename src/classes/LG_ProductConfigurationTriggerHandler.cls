public with sharing class LG_ProductConfigurationTriggerHandler {
    public static void BeforeInsertHandle(List<cscfga__Product_Configuration__c> lstNewPC) {
        
    }

    public static void BeforeUpdateHandle(List<cscfga__Product_Configuration__c> lstNewPC, List<cscfga__Product_Configuration__c> lstOldPC) {

    }

    public static void AfterInsertHandle(List<cscfga__Product_Configuration__c> lstNewPC) {
        // SB Telephony product definition not used on UM (TBanic 2017-01-31, to resolve too many soqls during the D2D basket upload)
        //SetHasSBTelephonyOnProductBasket(lstNewPC);

        createProductConfigurationRequests(lstNewPC);
        // 2017-03-31, removed to ProductBasketUploadedEventHandler
        //setAddressAndInstallationWishDate(lstNewPC, null);
    }

    public static void AfterDeleteHandle(List<cscfga__Product_Configuration__c> lstOldPC) {
        Set<Id> productBasketIds = new Set<Id>();
			
        for (cscfga__Product_Configuration__c p : lstOldPC) {
            productBasketIds.add(p.cscfga__Product_Basket__c);
        }
		
        List<cscfga__Product_Basket__c> productBaskets = [SELECT Id, csordtelcoa__Synchronised_with_Opportunity__c FROM cscfga__Product_Basket__c WHERE Id IN :productBasketIds];

        if (productBaskets.size() > 0) {

            for (cscfga__Product_Basket__c p : productBaskets) {
                p.csordtelcoa__Synchronised_with_Opportunity__c = false;
            }

            update productBaskets;
        }
    }
 
  /** Start BDS Sprint 3 PI 6 **/
    /**
     * If VPN /site fields changed update same on respective connection product attributes
     *
     * @param  Map<Id,cscfga__Product_Configuration__c> lstNewPC
     * @param  Map<Id, cscfga__Product_Configuration__c> lstOldPC
     *
     **/
   public static void afterUpdateVpnProds(Map<Id,cscfga__Product_Configuration__c> lstNewPC, Map<Id, cscfga__Product_Configuration__c> lstOldPC) {
        
  Map<String, String> vpnNameMap = new map<String, String>();
  Map<String, String> vpnIdMap = new map<String, String>();
  Map<String, String> siteNameMap = new map<String, String>();
  Map<String, String> persistentIdToNameMap =  new Map<String, String>();
  Map<String, String> persistentIdToPcIdMap =  new Map<String, String>();
  
  for (cscfga__Product_Configuration__c pc: lstNewPC.values()){

    if((pc.LG_ProductDefinitionName__c==Label.VPN_services) && (pc.LG_CustomProductName__c != lstOldPC.get(pc.Id).LG_CustomProductName__c)){                
      vpnNameMap.put(pc.LG_Persistent_Id__c, pc.cscfga__Product_Basket__c); 
      persistentIdToNameMap.put(pc.LG_Persistent_Id__c, pc.LG_CustomProductName__c);
      persistentIdToPcIdMap.put(pc.LG_Persistent_Id__c, pc.Id);
      
    }
    else if(pc.LG_ChangeType__c == 'Move') {
      if(pc.LG_ProductDefinitionName__c==Label.VPN_services && (pc.LG_From_Configuration__c!=lstOldPC.get(pc.id).LG_From_Configuration__c)) {
      
        vpnIdMap.put(pc.LG_Persistent_Id__c, pc.cscfga__Product_Basket__c); 
        persistentIdToPcIdMap.put(pc.LG_Persistent_Id__c, pc.Id);
      
      }
      else if (pc.LG_ProductDefinitionName__c==Label.BDS_Site && (pc.LG_CustomProductName__c != lstOldPC.get(pc.Id).LG_CustomProductName__c)) {
        siteNameMap.put(pc.LG_Persistent_Id__c, pc.cscfga__Product_Basket__c);
        persistentIdToNameMap.put(pc.LG_Persistent_Id__c, pc.LG_CustomProductName__c);
        persistentIdToPcIdMap.put(pc.LG_Persistent_Id__c, pc.Id);
      }
    }
    
  }   
    
  list<cscfga__Attribute__c> attributesToupdate = new List<cscfga__Attribute__c>();
  
  List<cscfga__Product_Configuration__c> connectionPCList = new List<cscfga__Product_Configuration__c>();

	if(!vpnNameMap.isEmpty() || !vpnIdMap.isEmpty() || !siteNameMap.isEmpty())
	{

		connectionPCList.addAll([select cscfga__Product_Basket__r.Id,LG_From_Configuration__c,LG_To_Configuration__c,Name,
      (select Name,cscfga__Value__c from cscfga__Attributes__r where Name In ('Multiple VPN Network','VPN Network','Product Group','Group Charge Name Shadow','Group Charge Name','Product Full Name','Multiple BDS Site','BDS Site'))
      from cscfga__Product_Configuration__c where (LG_From_Configuration__c In:vpnNameMap.keySet() OR LG_From_Configuration__c In:vpnIdMap.keySet() OR LG_To_Configuration__c in:siteNameMap.keySet()) AND
      (cscfga__Product_Basket__c In :vpnNameMap.values() OR cscfga__Product_Basket__c In :vpnIdMap.values() OR cscfga__Product_Basket__c In :siteNameMap.values()) ]);
      
   }
  
  for (cscfga__Product_Configuration__c pc:connectionPCList) {
    
    Boolean vpnNameUpdate = false;
    Boolean vpnIdUpdate = false;
    Boolean siteUpdate = false;
    
    if (vpnNameMap.get(pc.LG_From_Configuration__c) == pc.cscfga__Product_Basket__r.Id) {
    
      vpnNameUpdate = true;
        
    } else if (vpnIdMap.get(pc.LG_From_Configuration__c) == pc.cscfga__Product_Basket__r.Id) {
    
      vpnIdUpdate = true;
    }
    else if (siteNameMap.get(pc.LG_To_Configuration__c) == pc.cscfga__Product_Basket__r.Id) {
    
      siteUpdate = true;
    }
    
    for (cscfga__Attribute__c att : pc.cscfga__Attributes__r) {
    
      if(att.Name=='Multiple VPN Network' && (vpnNameUpdate || vpnIdUpdate))
      {
          if(vpnNameUpdate)
          {
            att.cscfga__Display_Value__c = persistentIdToNameMap.get(pc.LG_From_Configuration__c);
          }   
        att.cscfga__Value__c = persistentIdToPcIdMap.get(pc.LG_From_Configuration__c);
        attributesToupdate.add(att);
            } 
      else if(att.name=='VPN Network' && vpnNameUpdate) {
        att.cscfga__Display_Value__c = persistentIdToNameMap.get(pc.LG_From_Configuration__c);
        att.cscfga__Value__c = persistentIdToNameMap.get(pc.LG_From_Configuration__c);
        attributesToupdate.add(att);
      }
      else if(att.name=='Product Group' && vpnNameUpdate){
        att.cscfga__Display_Value__c = persistentIdToNameMap.get(pc.LG_From_Configuration__c);
        att.cscfga__Value__c = persistentIdToNameMap.get(pc.LG_From_Configuration__c); 
        attributesToupdate.add(att);
      }
      else if((vpnNameUpdate) && att.name=='Group Charge Name Shadow') {
        att.cscfga__Display_Value__c = persistentIdToNameMap.get(pc.LG_From_Configuration__c);
        att.cscfga__Value__c = persistentIdToNameMap.get(pc.LG_From_Configuration__c);
        attributesToupdate.add(att);
      }
      else if((vpnNameUpdate) && att.name=='Group Charge Name') {   
        att.cscfga__Display_Value__c = persistentIdToNameMap.get(pc.LG_From_Configuration__c);
        att.cscfga__Value__c = persistentIdToNameMap.get(pc.LG_From_Configuration__c);
        attributesToupdate.add(att);
      }
      else if ((vpnNameUpdate || siteUpdate) && att.name=='Product Full Name'){    
        att.cscfga__Display_Value__c = pc.Name;
        att.cscfga__Value__c = pc.Name;
        attributesToupdate.add(att); 
      } 
      else if (siteUpdate && att.name == 'Multiple BDS Site') {
        att.cscfga__Display_Value__c = persistentIdToNameMap.get(pc.LG_To_Configuration__c);
        att.cscfga__Value__c = persistentIdToPcIdMap.get(pc.LG_To_Configuration__c);
        attributesToupdate.add(att);
      }
      else if (siteUpdate && att.name == 'BDS Site') {
          att.cscfga__Display_Value__c = persistentIdToNameMap.get(pc.LG_To_Configuration__c);
        att.cscfga__Value__c = persistentIdToNameMap.get(pc.LG_To_Configuration__c);
        attributesToupdate.add(att);
      } 
    }
  }
  System.debug('attributesToupdate is:'+attributesToupdate);
  
    if(attributesToupdate.size()>0){
        
        update attributesToupdate;
        
    }     
 }


/** BDS PI6 Sprint 3 Changes END     **/
    public static void BeforeDeleteHandle(list<cscfga__Product_Configuration__c> lstProdConfig){
    	List<cscfga__Product_Configuration__c> lstDependentProdConfig=[Select Id, UM_DependsOnProductConfiguration__c , cscfga__Configuration_Status__c from cscfga__Product_Configuration__c  where UM_DependsOnProductConfiguration__c IN: lstProdConfig ];
		if(!lstDependentProdConfig.isEmpty()){
			for(cscfga__Product_Configuration__c prodConfig:lstDependentProdConfig){
				prodConfig.cscfga__Configuration_Status__c='Incomplete';
			}
			system.debug('lstDependentProdConfig is:'+lstDependentProdConfig);
			update lstDependentProdConfig;
		}
    }

    private static void SetHasSBTelephonyOnProductBasket(List<cscfga__Product_Configuration__c> lstNewPC) {
        Set<string> setPCId = new Set<string>();
        Set<string> setPBId = new Set<string>();

        for (cscfga__Product_Configuration__c tmpPC : lstNewPC) {
            setPBId.add(tmpPC.cscfga__Product_Basket__c);
        }

        if (setPBId.size() > 0) {
            List<cscfga__Product_Configuration__c> lstPC = [SELECT Id, cscfga__Product_Definition__r.Name, cscfga__Product_Basket__c FROM cscfga__Product_Configuration__c WHERE cscfga__Product_Basket__c in : setPBId];

            Map<string, string> mapPBIdSBTelephonyPCId = new Map<string, string>();

            for (cscfga__Product_Configuration__c tmpPC : lstPC) {
                if (!mapPBIdSBTelephonyPCId.containsKey(tmpPC.cscfga__Product_Basket__c)) {
                    mapPBIdSBTelephonyPCId.put(tmpPC.cscfga__Product_Basket__c, '');
                }

                if (tmpPC.cscfga__Product_Definition__r.Name == 'SB Telephony') {
                    mapPBIdSBTelephonyPCId.put(tmpPC.cscfga__Product_Basket__c, tmpPC.Id);
                }
            }


            List<cscfga__Product_Basket__c> lstProductBasket = [SELECT Id, LG_SBTelephonyId__c FROM cscfga__Product_Basket__c WHERE Id in : setPBId];

            for (cscfga__Product_Basket__c tmpProductBasket : lstProductBasket) {
                tmpProductBasket.LG_SBTelephonyId__c = mapPBIdSBTelephonyPCId.get(tmpProductBasket.Id);
            }

            update lstProductBasket;

        }

    }

    public static void AfterUpdateHandle(List<cscfga__Product_Configuration__c> lstNewPC, Map<Id, cscfga__Product_Configuration__c> lstOldPC) {
        createProductConfigurationRequests(lstNewPC);
        // 2017-03-31, removec to ProductBasketUploadedEventHandler
        //setAddressAndInstallationWishDate(lstNewPC, lstOldPC);
    }

    /**
     * Creates Product Configuration Requests for every cscfga__Product_Configuration__c if they do not exist
     *
     * @param  List<cscfga__Product_Basket__c> lstNew
     * @author Petar Miletic
     * @ticket SFDT-346, SFDT-766
     * @since  23/03/2016
     */
    public static void createProductConfigurationRequests(List<cscfga__Product_Configuration__c> lstNew) {
        Set<ID> baskedIDs = new Set<ID>();
        Set<ID> productConfigurationIDs = new Set<ID>();

        List<csbb__Product_Configuration_Request__c> newPCRs = new List<csbb__Product_Configuration_Request__c>();

        for (cscfga__Product_Configuration__c pc : lstNew) {

            baskedIDs.add(pc.cscfga__Product_Basket__c);
        }

        Map<Id, cscfga__Product_Configuration__c> pclMap = new Map<Id, cscfga__Product_Configuration__c>([SELECT Id, Name, cscfga__Product_Basket__c, cscfga__Product_Basket__r.LG_CreatedFrom__c, cscfga__Product_Definition__r.cscfga__Product_Category__c FROM cscfga__Product_Configuration__c WHERE cscfga__Product_Basket__c IN :baskedIDs AND cscfga__Parent_Configuration__c = NULL]);

        // Get PCR's including candidates for PCR
        Map<Id, csbb__Product_Configuration_Request__c> pcrMap = new Map<Id, csbb__Product_Configuration_Request__c>([SELECT Id, Name, csbb__Product_Basket__c, csbb__Product_Configuration__c, csbb__Product_Category__c FROM csbb__Product_Configuration_Request__c WHERE csbb__Product_Basket__c IN :baskedIDs]);

        // Create set of current Product Configurations that have PCR's
        for (csbb__Product_Configuration_Request__c pcr : pcrMap.values()) {
            productConfigurationIDs.add(pcr.csbb__Product_Configuration__c);
        }

        for (ID i : baskedIDs) {

            // Get subsets of data
            List<cscfga__Product_Configuration__c> pcByBasket = getProductConfigurationByBasketID(i, pclMap);

            for (cscfga__Product_Configuration__c productConfig : pcByBasket) {

                if (productConfig.cscfga__Product_Basket__r.LG_CreatedFrom__c != 'Tablet') {
                    continue;
                }

                if (checkCandidate(productConfig, pcrMap)) {

                    System.debug('There is a PCR candidate. Skip PCR creation');
                    continue;
                }

                if (!productConfigurationIDs.contains(productConfig.Id)) {

                    // Create list of Product Configurations that do not have Product Configuration Request
                    csbb__Product_Configuration_Request__c r = new csbb__Product_Configuration_Request__c();

                    r.csbb__Product_Basket__c = i;
                    r.csbb__Product_Configuration__c = productConfig.Id;
                    r.csbb__Product_Category__c = productConfig.cscfga__Product_Definition__r.cscfga__Product_Category__c;

                    // Method is not Global and currently there is no scheduled date to make it
                    // Global or move it in another package. Idea is to move it from CSTELCOBB to CSBB
                    // cstelcobb.BasketBuilderApi.calculatePCRCharges(r, pcByBasket);
                    calculatePCRCharges(r, pcByBasket);

                    newPCRs.add(r);
                }
            }
        }
        
        if (newPCRs.size() > 0) {
            upsert newPCRs;
        }
    }

    /*
     * Check if there is candidate for PCR -> PC connection
    */
    private static Boolean checkCandidate(cscfga__Product_Configuration__c pc, Map<Id, csbb__Product_Configuration_Request__c> pcrMap) {

        Boolean retval = false;

        for (csbb__Product_Configuration_Request__c pcr : pcrMap.values()) {

            // If product basket is not the same, skip
            if (pc.cscfga__Product_Basket__c != pcr.csbb__Product_Basket__c) {
                continue;
            }

            // Check if there is a PCR candidate for creating PC -> PCR connection
            if (pcr.csbb__Product_Configuration__c == null && pc.cscfga__Product_Definition__c != null &&  pc.cscfga__Product_Definition__r.cscfga__Product_Category__c == pcr.csbb__Product_Category__c) {

                retval = true;
                break;
            }
        }

        return retval;
    }

    /*
     * Return subset data for Product Configurations; filters out PC by Basket ID
    */
    private static List<cscfga__Product_Configuration__c> getProductConfigurationByBasketID(ID basketID, Map<Id, cscfga__Product_Configuration__c> productConfigurations) {

        List<cscfga__Product_Configuration__c> tmp = new List<cscfga__Product_Configuration__c>();

        for (cscfga__Product_Configuration__c pc : productConfigurations.values()) {

            if (pc.cscfga__Product_Basket__c == basketID) {
                tmp.add(pc);
            }
        }

        return tmp;
    }

    /*
     * Calculates charges for product configuration request based on underlying product configurations. Originates from cstelcobb.BasketBuilderApi.calculatePCRCharges
    */
    public static void calculatePCRCharges(csbb__Product_Configuration_Request__c prodConfReq, List<cscfga__Product_Configuration__c> prodConfigs) {

        for (cscfga__Product_Configuration__c prodConf : prodConfigs) {

            Decimal sovValue;
            Decimal sovOneOff = null;
            Decimal sovMonthlyRevenue = null;
            Decimal roundedVal;

            for (cscfga__Attribute__c att : prodConf.cscfga__Attributes__r) {
                if (att.cscfga__Recurring__c) {
                    if (prodConf.cscfga__billing_frequency__c == 12) {
                        prodConfReq.csbb__total_mrc__c = (prodConfReq.csbb__total_mrc__c == null) ? att.cscfga__billing_price__c : prodConfReq.csbb__total_mrc__c + att.cscfga__billing_price__c;
                    } else if (prodConf.cscfga__billing_frequency__c == 4) {
                        prodConfReq.csbb__total_mrc__c = (prodConfReq.csbb__total_mrc__c == null) ? att.cscfga__billing_price__c : prodConfReq.csbb__total_mrc__c + att.cscfga__billing_price__c;
                    } else if (prodConf.cscfga__billing_frequency__c == 1) {
                        prodConfReq.csbb__total_yrc__c = (prodConfReq.csbb__total_yrc__c == null) ? att.cscfga__billing_price__c : prodConfReq.csbb__total_yrc__c + att.cscfga__billing_price__c;
                    }
                } else {
                    prodConfReq.csbb__total_oc__c = (prodConfReq.csbb__total_oc__c == null) ? att.cscfga__billing_price__c : prodConfReq.csbb__total_oc__c + att.cscfga__billing_price__c;
                }

                // skip rate line items and line items that do not have price or price is 0
                if (!att.cscfga__attribute_definition__r.cscfga__is_rate_line_item__c && att.cscfga__billing_price__c != null && att.cscfga__billing_price__c != 0) {
                    if (att.cscfga__recurring__c) {
                        roundedVal = (att.cscfga__billing_price__c * prodConf.cscfga__billing_frequency__c / 12).setScale(2); // round to 2 decimal places
                        sovMonthlyRevenue = (sovMonthlyRevenue == null) ? roundedVal : sovMonthlyRevenue + roundedVal;
                    } else {
                        roundedVal = (att.cscfga__billing_price__c).setScale(2);
                        sovOneOff = (sovOneOff == null) ? roundedVal : sovOneOff + roundedVal;
                    }
                }
            }

            if (sovMonthlyRevenue != null || sovOneOff != null) {
                sovValue = (sovMonthlyRevenue == null ? 0 : sovMonthlyRevenue) + (sovOneOff == null ? 0 : sovOneOff);
            } else {
                sovValue = null;
            }

            prodConfReq.csbb__total_sov__c = (prodConfReq.csbb__total_sov__c == null) ? sovValue : prodConfReq.csbb__total_sov__c + (sovValue == null ? 0 : sovValue);
        }

        return;
    }
    
    
/* Set status for terminate virtual phone dienste as valid,update default reason and mark one-off as readonly'-BHP -16*/

public static void setStatusForPhoneDienste(List<cscfga__Product_Configuration__c> prodConfs) {

Set<Id> ConfigIds = New Set<Id>();
   List<cscfga__Product_Configuration__c> toUpdateConfigs = New List<cscfga__Product_Configuration__c>();
               List<cscfga__Attribute__c> updateAttrs = New List<cscfga__Attribute__c>();
    for (cscfga__Product_Configuration__c pc: prodConfs){
if(pc.Name=='Terminate Virtual Phone Dienste')
{
                  ConfigIds.add(pc.id);
                  pc.cscfga__Configuration_Status__c='Valid'; 
                  }
} 
if(ConfigIds.size()>0) 
{
List<cscfga__Product_Configuration__c> lstDiensteConfig=[Select Id,Name,LG_From_Configuration__c,cscfga__Configuration_Status__c,(Select Name, cscfga__Value__c,cscfga__Display_Value__c,cscfga__Is_Read_Only__c from cscfga__Attributes__r where name ='Contract Termination Reason')
                                                    From cscfga__Product_Configuration__c Where Id IN:ConfigIds];


            
for (cscfga__Product_Configuration__c prodConf : lstDiensteConfig) {



 for(cscfga__Attribute__c att: prodConf.cscfga__Attributes__r) {
             system.debug('Attributes Loop'+att);
                 if(att.Name=='Contract Termination Reason'){
                  att.cscfga__Display_Value__c='Sonstiger K&#252ndigungsgrund';
                  att.cscfga__Value__c='Sonstiger K&#252ndigungsgrund';
                  updateAttrs.add(att);
                  }
                                     
                  }
                  
             
                  
}






update updateAttrs; 
}
}

    /**
    * Whenever there is an insert or an update of the Product Configuration as a result
    * of the MACD Change - Configuration status must be set to Valid
    *
    * @param  List<cscfga__Product_Configuration__c> prodConfs - trigger.new list
    * @author Tomislav Blazek
    * @ticket SFDT-551
    * @since  25/03/2016
    */
    public static void setStatusToValidForChange(List<cscfga__Product_Configuration__c> prodConfs) {
        for (cscfga__Product_Configuration__c prodConf : prodConfs) {
            if (prodConf.LG_ChangeType__c == 'Change' ||
                    prodConf.LG_ChangeType__c == 'Porting-Out') {
                prodConf.cscfga__Configuration_Status__c = 'Valid';
            }
        }
    }
    
    /**
	* Whenever there is an insert or an update of the (Child/Related) Product Configuration as a result
	* of the MACD - (Child/Related) Configuration status must be set to Valid if change type has
	* Valid Related Product field set to true
	*
	* @param  List<cscfga__Product_Configuration__c> prodConfs - trigger.new list
	* @author Tomislav Blazek
	* @since  21/9/2016
	*/
	public static void setStatusForChildToValid(List<cscfga__Product_Configuration__c> prodConfs) {
		for (cscfga__Product_Configuration__c prodConf : prodConfs)
		{
			if (LG_Util.shouldValidRelProductsByChangeType(prodConf.LG_ChangeType__c)
			    && prodConf.cscfga__Parent_Configuration__c != null)
			{
				prodConf.cscfga__Configuration_Status__c = 'Valid';
			}
		}
	}

    /**
     * Updates the related Publicly Listed Numbers (LG_PortingNumber__c records)
     * Whenever a Product Configuration of the Product Definition 'Phone Numbers' is inserted
     * or updated - the method deletes any existing related LG_PortingNumber__c records, and
     * insert the new records according to the related attribute PublicListingJson value.
     * Attribute 'PublicListingJson' value is populated while the user is entering new numbers
     * in the Edit Product Configuration screen (in Basket Builder).
     *
     * @param  List<cscfga__Product_Configuration__c> lstNewPB - trigger.new list
     * @author Tomislav Blazek
     * @ticket
     * @since  08/02/2016
     */
    public static void updatePubliclyListedNumbers(List<cscfga__Product_Configuration__c> prodConfs) {
        List<cscfga__Product_Configuration__c> eligibleConfs = [SELECT Id, cscfga__Product_Definition__r.Name
                FROM cscfga__Product_Configuration__c WHERE cscfga__Product_Definition__r.Name = 'Phone Numbers' AND
                        Id IN :prodConfs];

        if (!eligibleConfs.isEmpty()) {
            List<LG_PortingNumber__c> oldPortingNumbers = [SELECT Id FROM LG_PortingNumber__c
                    WHERE LG_ProductConfiguration__c IN :eligibleConfs];
            delete oldPortingNumbers;

            Id newRecordTypeId = Schema.SObjectType.LG_PortingNumber__c.getRecordTypeInfosByName()
                                 .get('New').getRecordTypeId();

            List<cscfga__Attribute__c> prodConfsAttNew = [SELECT cscfga__Value__c, cscfga__Product_Configuration__c
                    FROM cscfga__Attribute__c
                    WHERE Name = 'PublicListingJson'
                                 AND cscfga__Product_Configuration__c IN :eligibleConfs];

            List<LG_PortingNumber__c> numbersToInsert = new List<LG_PortingNumber__c>();

            for (cscfga__Attribute__c publicListingJson : prodConfsAttNew) {
                if (String.isNotBlank(publicListingJson.cscfga__Value__c)) {
                    PubliclyListedNumbers publiclyListed = (PubliclyListedNumbers) JSON.deserialize(publicListingJson.cscfga__Value__c,
                                                           PubliclyListedNumbers.class);

                    for (PhoneNumbers numberRow : publiclyListed.phoneNumbers) {
                        LG_PortingNumber__c portingNumber = new LG_PortingNumber__c();
                        portingNumber.LG_PhoneNumber__c = numberRow.phoneNumber;
                        portingNumber.LG_InDirectory__c = numberRow.publiclyListed;
                        portingNumber.LG_DirectoryListingName__c = numberRow.listingName;
                        portingNumber.LG_Type__c = 'SB Telephony';
                        portingNumber.LG_ProductConfiguration__c = publicListingJson.cscfga__Product_Configuration__c;
                        portingNumber.RecordTypeId = newRecordTypeId;
                        numbersToInsert.add(portingNumber);
                    }
                }
            }

            if (!numbersToInsert.isEmpty()) {
                insert numbersToInsert;
            }
        }
    }
    
    /*
     * The wish date & Installation date selected in the D2D app is not visible in the "Installation Information per site" page in SF
     * Update LG_Address__c in future method because it is overriden from package in classic update
     *
     * @param  List<cscfga__Product_Configuration__c> lstNewPC
     * @author Petar Miletic
     * @ticket SFDT-709, SFDT-770, FDT-710
     * @since  22/04/2016
    */
    
    private static void setAddressAndInstallationWishDate(List<cscfga__Product_Configuration__c> lstNewPC, Map<Id, cscfga__Product_Configuration__c> lstOldPC) {

        Set<Id> basketIDs = new Set<Id>();
        Set<Id> productConfigurationIds = new Set<Id>();

        // Get Baskets
        for (cscfga__Product_Configuration__c p : lstNewPC) {

            productConfigurationIds.add(p.Id);

            // Filter out  fields that do not require update
            //if (p.cscfga__Product_Basket__c != null && (p.LG_InstallationWishDate__c == null || p.LG_Address__c == null)) {
            if (p.cscfga__Product_Basket__c != null && (p.LG_InstallationWishDate__c == null || p.LG_Address__c == null)) {
                basketIDs.add(p.cscfga__Product_Basket__c);
            }
        }

        /*
         * Get BasketIds but first resolve if the update is really necessary by filtering out baskets that are already updated
        */
        /*if (lstOldPC == null) {
            
            // Get Baskets
            for (cscfga__Product_Configuration__c p : lstNewPC) {
    
                productConfigurationIds.add(p.Id);
    
                // Filter out  fields that do not require update
                //if (p.cscfga__Product_Basket__c != null && (p.LG_InstallationWishDate__c == null || p.LG_Address__c == null)) {
                if (p.cscfga__Product_Basket__c != null && (p.LG_InstallationWishDate__c == null || p.LG_Address__c == null)) {
                    basketIDs.add(p.cscfga__Product_Basket__c);
                }
            }
        }
        else {
            
            // Get Baskets
            for (cscfga__Product_Configuration__c p : lstNewPC) {
                
                productConfigurationIds.add(p.Id);
    
                // Filter out  fields that do not require update
                if (p.cscfga__Product_Basket__c != null && (
                    (p.LG_InstallationWishDate__c == null || p.LG_InstallationWishDate__c != lstOldPC.get(p.Id).LG_InstallationWishDate__c) || 
                    (p.LG_Address__c == null || p.LG_Address__c != lstOldPC.get(p.Id).LG_Address__c)
                    )) {
                    basketIDs.add(p.cscfga__Product_Basket__c);
                }
            }
        }*/
        
        /*
         * Future method only receives primitive types
         * Execute only if not in future
        */
        if (!basketIDs.isEmpty() && (!System.isFuture() && !System.isBatch())) {
            setAddressAndInstallationWishDate(basketIDs, productConfigurationIds);
        }
    }
    
    /*
     * Future method for updating Address and Installation Wish date. Package overwrites this values so they need to be set in future method
    */
    @future
    private static void setAddressAndInstallationWishDate(Set<Id> basketIDs, Set<Id> productConfigurationIds) {

        // Product Configurations that require PCR Optionals recreation
        Set<Id> pcIDs = new Set<Id>();
        
        // Product Configurations that will be updated (Address and Installation Date)
        List<cscfga__Product_Configuration__c> pcUpdate = new List<cscfga__Product_Configuration__c>();

        Map<Id, cscfga__Product_Basket__c> pbMap = new Map<Id, cscfga__Product_Basket__c>([SELECT Id, LG_PreferredInstallationDate__c, LG_InstallationCity__c,
                                                                                            LG_InstallationCountry__c, LG_InstallationHouseNumber__c, LG_InstallationStreet__c,
                                                                                            LG_InstallationPostalCode__c, LG_InstallationHouseNumberExtension__c,
                                                                                            LG_SharedOfficeBuilding__c, LG_COAXConnectionLocation__c, csbb__Account__c
                                                                                            FROM cscfga__Product_Basket__c WHERE Id IN :basketIDs AND LG_CreatedFrom__c = 'Tablet']);

        // If map is empty end execution
        if (pbMap.isEmpty()) {
            return;
        }

        List<cscfga__Product_Configuration__c> productConfigurations = [SELECT Id, LG_Address__c, LG_InstallationWishDate__c, cscfga__Product_Basket__c 
                                                                        FROM cscfga__Product_Configuration__c WHERE Id IN :productConfigurationIds];

        List<cscrm__Address__c> addresses = new List<cscrm__Address__c>();
        
        for (cscfga__Product_Basket__c pb :pbMap.values()) {
            addresses.add(LG_Util.createNewPremise(pb));
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
    
    /*
     * Check if any of the address elements is set. If not return false
    */
    @TestVisible
    private static Boolean checkAddressFields(cscfga__Product_Configuration__c pc) {
        
        Boolean isValid = false;
        
        if (pc.LG_Address__r != null) {
            isValid = (
                        String.isNotBlank(pc.LG_Address__r.cscrm__Street__c) || 
                        String.isNotBlank(pc.LG_Address__r.LG_HouseNumber__c) || 
                        String.isNotBlank(pc.LG_Address__r.LG_HouseNumberExtension__c) ||
                        String.isNotBlank(pc.LG_Address__r.cscrm__Zip_Postal_Code__c) ||
                        String.isNotBlank(pc.LG_Address__r.cscrm__City__c)
                      );
        }
        
        return isValid;
    }

    //Inner class used for deserializing the Json from PublicListingJson Attribute
    //of the Phone Numbers Product Configuration
    public class PubliclyListedNumbers {
        public PhoneNumbers[] phoneNumbers;
    }

    //Inner class used in the PubliclyListedNumbers inner class
    public class PhoneNumbers {
        public String phoneNumber;
        public String publiclyListed;
        public String listingName;
    }
    
    
   /**********************************************************************************************************************
    * author: Madhu  
    * Date: July 2016
    * Param:List<cscfga__Product_Configuration__c> & Map<id,cscfga__Product_Configuration__c>
    * Return:  void
    * Description: when services and subscriptions are created this method populates the billing account on sucscription 
    * Summary of Changes : 
    **********************************************************************************************************************/
    public static void updateSubscriptionBillingAccount(List<cscfga__Product_Configuration__c> productConfigList,Map<id,cscfga__Product_Configuration__c> oldMap)
       {
        Set<Id> productConfigIds = new Set<Id>();
        for(cscfga__Product_Configuration__c pConfig : productConfigList)
        {      
               cscfga__Product_Configuration__c oldPCObject=oldMap.get(pConfig.id);
               if(pConfig.LG_Billing_Account__c!= oldPCObject.LG_Billing_Account__c){
                    productConfigIds.add(pConfig.Id);
               }
        }
        if(productConfigIds!=null && productConfigIds.size()>0){
            List<csord__Service__c> ServicesList=[SELECT Id, LG_Address__c,csord__Subscription__c,csord__Subscription__r.csconta__Billing_Account__c, csordtelcoa__Product_Configuration__c,csordtelcoa__Product_Configuration__r.LG_Billing_Account__c FROM csord__Service__c
                                WHERE csordtelcoa__Product_Configuration__c IN :productConfigIds and csord__Service__c =null];
            if(ServicesList!=null && ServicesList.size()>0){
                    //subscription to update billing account    
                    Map<csord__Subscription__c, Id> subscriptionToBillingAccount = new Map<csord__Subscription__c, Id>();
                    for(csord__Service__c service : ServicesList)
                    {
                            subscriptionToBillingAccount.put(service.csord__Subscription__r, service.csordtelcoa__Product_Configuration__r.LG_Billing_Account__c);
                    }
    
                    List<csord__Subscription__c> subsToUpdate = new List<csord__Subscription__c>();
                    if (!subscriptionToBillingAccount.isEmpty())
                    {
                        for(csord__Subscription__c subscription : subscriptionToBillingAccount.keySet())
                        {
                            subscription.csconta__Billing_Account__c = subscriptionToBillingAccount.get(subscription);
                            subsToUpdate.add(subscription);
                        }
                        if(!subsToUpdate.isEmpty()){
                            update subsToUpdate;
                        }
                    }
            }
        }
     }
    
    /**
	 * When Number Range prod configuration is deleted, related number assets
	 * should be deleted also.
	 *
	 * @param  List<cscfga__Product_Configuration__c> prodConfs
	 * @author Tomislav Blazek
	 * @ticket SFOM-1036
	 * @since  26/6/2017
	 **/
	public static void deleteNumberAssets(List<cscfga__Product_Configuration__c> prodConfs) {
		Set<Id> eligibleProdConfIds = new Set<Id>();
		LG_NumberManagementSettings__c nmbrMngSettings = LG_NumberManagementSettings__c.getInstance(UserInfo.getUserId());
		/*
		 * Decide which prod confs should be processed:
		   - only Number Range product Configurations that were deleted
		 **/
		for (cscfga__Product_Configuration__c prodConf : prodConfs) {
			if (prodConf.LG_ProductDefinitionName__c == nmbrMngSettings.LG_NumberRangeProductDefinitionName__c && Trigger.isDelete) {
				eligibleProdConfIds.add(prodConf.Id);
			}
		}

		if  (!eligibleProdConfIds.isEmpty()) {
			List<Asset> assetsToDelete = [SELECT Id FROM Asset
										  WHERE LG_NumberRangeProductConfiguration__c IN :eligibleProdConfIds
										  AND LG_TelephonyService__c = null];

			if (!assetsToDelete.isEmpty()) {
				delete assetsToDelete;
			}
		}
	}


}
