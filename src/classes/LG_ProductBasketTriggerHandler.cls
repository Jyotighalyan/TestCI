public class LG_ProductBasketTriggerHandler {
    public static void BeforeInsertHandle(List<cscfga__Product_Basket__c> lstNewPB) {
        //SimulateInsertFromTablet(lstNewPB);

        //not needed - agreed that we will dinamically look, when Product Basket related to Opportunity we will look at Installation Address on Opportunity
        //when Product Basket related to Account or to Lead - we will look at Installation address on Product Basket
        //SetVisitAddressToProductBasketFromWebBeforeInsert(lstNewPB);

        populateTheCustomerAccountField(lstNewPB);
        setDefaultBillingAccount(lstNewPB);
        updateProductBasketName(lstNewPB);        
    }

    /*public static void BeforeUpdateHandle(List<cscfga__Product_Basket__c> lstNewPB, List<cscfga__Product_Basket__c> lstOldPB) {
        //SetLeadReferenceToNullBeforeUpdateOnSync(lstNewPB,lstOldPB);      
    }*/

    public static void AfterInsertHandle(List<cscfga__Product_Basket__c> lstNewPB) {
        //System.debug('***before function - lstNewPB=' + lstNewPB);
        UnSyncProductBasketsAfterInsertUpdate(lstNewPB, null);
    }

    public static void AfterUpdateHandle(List<cscfga__Product_Basket__c> lstNewPB, List<cscfga__Product_Basket__c> lstOldPB) {
        ModifyBasketNamesForUpdate(lstNewPB, lstOldPB);
        UnSyncProductBasketsAfterInsertUpdate(lstNewPB, lstOldPB);

        DeleteOLIsProductDetailsAfterUpdate(lstNewPB, lstOldPB);

        InsertOLIsProductDetailsAfterUpdate(lstNewPB, lstOldPB);

        SetContractTermToOpportunity(lstNewPB, lstOldPB);

        // Product Definitions not used in UM (marked as SOHO Telephony or Mobile Telephony) (TBanic 2017-01-31, to resolve too many soqls during the D2D basket upload)
        //DeletePortingStructureAfterBasketUnsync(lstNewPB, lstOldPB);
        //InsertPortingStructureAfterBasketSync(lstNewPB, lstOldPB);
        //UpdatePortingStructureAfterBasketSyncAndUnsync(lstNewPB, lstOldPB);
        
        UpdateOpportunity(lstNewPB, lstOldPB);
        updatePhoneNumberStatusToReserved(lstNewPB,lstOldPB);

    }
    
   private static void UpdateOpportunity(List<cscfga__Product_Basket__c> lstNewPB, List<cscfga__Product_Basket__c> lstOldPB) {
        
        System.debug('**********New Procedure**********');
        System.debug('********** lstNewPB=' + lstNewPB);
        System.debug('********** lstOldPB=' + lstOldPB);
        
               
        //Map<string, string> BasketIdOppId = new Map<string, string>();
        for (integer i = 0; i < lstNewPB.size(); ++i) 
        //for (cscfga__Product_Configuration__c Lists: lstNewPB)
        {
            //System.debug('********** loop Baskets=' + lstNewPB[i].csordtelcoa__Synchronised_with_Opportunity__c;
            if ((lstNewPB[i].csordtelcoa__Synchronised_with_Opportunity__c)) {
            
                Decimal TotalAmt = 0.0;
                Decimal Discount = 0.0;
                String disctemp;
                String temp;
                
                List<cscfga__Product_Configuration__c> prodconfigs = [SELECT id,Remaining_Contract_Child__c,cscfga__One_Off_Charge__c,Recurring_Total_Amount__c,UM_RemainingContractTerm__c,cscfga__Recurring_Charge__c from cscfga__Product_Configuration__c where cscfga__Product_Basket__r.Id =:lstNewPB[i].Id];
            
                for (cscfga__Product_Configuration__c tmpAttribute : prodconfigs) {
                
                            System.debug('********** tmpAttribute=' + tmpAttribute);
                            
                            
                          

                            TotalAmt +=  tmpAttribute.cscfga__One_Off_Charge__c;
                            TotalAmt +=  tmpAttribute.Recurring_Total_Amount__c;
                                                      
                            
                            
                            //System.debug('********** tmpAttribute ends amount=' + TotalAmt);
                }
                
                List<cscfga__Attribute_Field__c> Attconfigs = [SELECT cscfga__Attribute__r.cscfga__Product_Configuration__r.id,name,cscfga__Value__c from cscfga__Attribute_Field__c where cscfga__Attribute__r.cscfga__Product_Configuration__r.cscfga__Product_Basket__r.id =:lstNewPB[i].Id and cscfga__Attribute_Field__c.name = 'Total Discount Value'];
                            
                            for (cscfga__Attribute_Field__c tmpAttribute2 : Attconfigs) {
                            
                                    System.debug('********** Attconfigs=' + Attconfigs);
                                    disctemp = tmpAttribute2.cscfga__Value__c;
                                    System.debug('********** disctemp=' + disctemp);
                                    if(String.isNotBlank(disctemp)){
                                        if(disctemp.length() > 0)
                                        {
                                            temp = tmpAttribute2.cscfga__Value__c;
                                            Discount +=  Decimal.valueOf(temp);                                
                                        }
                                    }
                            }
                                  TotalAmt = TotalAmt - Discount; 
                                
                
                System.debug('********** Productbasket ends amount=' + TotalAmt);
                if(lstNewPB[i].cscfga__Opportunity__c != null)
                {
                    Opportunity opp = [Select id,UM_TotalContractValue__c from opportunity where id =:lstNewPB[i].cscfga__Opportunity__c];
                    opp.UM_TotalContractValue__c = TotalAmt;
                    update opp;
                }
                //BasketIdOppId.put(lstNewPB[i].Id, lstNewPB[i].cscfga__Opportunity__c);
            }
        }
        
        //System.debug('**********New Procedure**********' + BasketIdOppId);
        
        
    }    
        
    //Updates the Product Basket Name with User's Local Time Zone Date/Time Format.
    private static void updateProductBasketName(List<cscfga__Product_Basket__c> lstNewPB){
        for(cscfga__Product_Basket__c basket : lstNewPB){
            if(basket.Name!=null && !basket.Name.contains('Mac basket'))
                basket.Name = 'New Basket ' + DateTime.Now().format('yyyy-MM-dd HH:mm:ss', ''+userinfo.getTimeZone());
        }
    }

    /*private static void InsertPortingStructureAfterBasketSync(List<cscfga__Product_Basket__c> lstNewPB, List<cscfga__Product_Basket__c> lstOldPB) {
        //this is for SOHO Telephony and for Mobile Telephony
        //SB Telephony is specific as it can be uploaded
        //System.debug('********** lstNewPB=' + lstNewPB);
        //System.debug('********** lstOldPB=' + lstOldPB);
        Map<string, string> mapSyncedProductBasketIdOppId = new Map<string, string>();

        List<LG_PortingNumber__c> lstPortingNumberInsert = new List<LG_PortingNumber__c>(); 

        for (integer i = 0; i < lstNewPB.size(); ++i) {
            //System.debug('********** loop Baskets=' + lstNewPB[i].csordtelcoa__Synchronised_with_Opportunity__c + '------' + !lstOldPB[i].csordtelcoa__Synchronised_with_Opportunity__c);
            if ((lstNewPB[i].csordtelcoa__Synchronised_with_Opportunity__c) && (!lstOldPB[i].csordtelcoa__Synchronised_with_Opportunity__c)) {
                mapSyncedProductBasketIdOppId.put(lstNewPB[i].Id, lstNewPB[i].cscfga__Opportunity__c);
            }
        }

        //System.debug('********** mapSyncedProductBasketIdOppId=' + mapSyncedProductBasketIdOppId);

        if (mapSyncedProductBasketIdOppId.size() > 0) {


            List<cscfga__Attribute__c> lstAttribute = [SELECT cscfga__Attribute_Definition__c, cscfga__Attribute_Definition__r.LG_ProductDetailType__c,
                                       cscfga__Product_Configuration__c, cscfga__Product_Configuration__r.cscfga__Product_Basket__c, cscfga__Value__c, Id, Name
                                       FROM cscfga__Attribute__c c
                                       WHERE cscfga__Attribute_Definition__r.LG_ProductDetailType__c in ('JSON Porting SOHO Telephony', 'JSON Porting Mobile Telephony')
                                       AND cscfga__Product_Configuration__r.cscfga__Product_Basket__c in : mapSyncedProductBasketIdOppId.keyset()];

            for (cscfga__Attribute__c tmpAttribute : lstAttribute) {
                string tmpPortingStructureType;

                if (tmpAttribute.cscfga__Attribute_Definition__r.LG_ProductDetailType__c == 'JSON Porting SOHO Telephony') {
                    tmpPortingStructureType = 'SOHO Telephony';
                } else {
                    tmpPortingStructureType = 'Mobile Telephony';
                }

                string OppId = mapSyncedProductBasketIdOppId.get(tmpAttribute.cscfga__Product_Configuration__r.cscfga__Product_Basket__c);

                List<LG_PortingNumber__c> lsttmpPortingNumber = LG_TelephoneUtility.CreatePortingStructure(tmpPortingStructureType, tmpAttribute.cscfga__Value__c, tmpAttribute.cscfga__Product_Configuration__c, OppId);

                if (lsttmpPortingNumber.size() > 0) {
                    lstPortingNumberInsert.addall(lsttmpPortingNumber);
                }
            }

            //System.debug('********** lstPortingNumberInsert=' + lstPortingNumberInsert);

            if (lstPortingNumberInsert.size() > 0) insert lstPortingNumberInsert;
        }
    }
*/
/*  private static void DeletePortingStructureAfterBasketUnsync(List<cscfga__Product_Basket__c> lstNewPB, List<cscfga__Product_Basket__c> lstOldPB) {
        //this is for SOHO Telephony and for Mobile Telephony
        //SB Telephony is specific as it can be uploaded
        Map<string, string> mapUnSyncedProductBasketIdOppId = new Map<string, string>();

        for (integer i = 0; i < lstNewPB.size(); ++i) {
            if ((!lstNewPB[i].csordtelcoa__Synchronised_with_Opportunity__c) && (lstOldPB[i].csordtelcoa__Synchronised_with_Opportunity__c)) {
                mapUnSyncedProductBasketIdOppId.put(lstNewPB[i].Id, lstNewPB[i].cscfga__Opportunity__c);
            }
        }

        if (mapUnSyncedProductBasketIdOppId.size() > 0) {
            List<LG_PortingNumber__c> lstPortingNumberDelete = [SELECT Id FROM LG_PortingNumber__c WHERE LG_Type__c in ('Mobile Telephony', 'SOHO Telephony') and  LG_Opportunity__c in : mapUnSyncedProductBasketIdOppId.values()];

            if (lstPortingNumberDelete.size() > 0) {
                delete lstPortingNumberDelete;
            }
        }
    }
*/
    /*private static void UpdatePortingStructureAfterBasketSyncAndUnsync(List<cscfga__Product_Basket__c> lstNewPB, List<cscfga__Product_Basket__c> lstOldPB) {
        //this is specific for SB Internet as here we are only updating Opportunity field on porting structure
        //to connect or unconnect porting structure for easy select to OPT

        Map<string, string> mapUnSyncedProductBasketIdOppId = new Map<string, string>();
        Map<string, string> mapSyncedProductBasketIdOppId = new Map<string, string>();

        for (integer i = 0; i < lstNewPB.size(); ++i) {
            if ((!lstNewPB[i].csordtelcoa__Synchronised_with_Opportunity__c) && (lstOldPB[i].csordtelcoa__Synchronised_with_Opportunity__c)) {
                mapUnSyncedProductBasketIdOppId.put(lstNewPB[i].Id, lstNewPB[i].cscfga__Opportunity__c);
            } else if ((lstNewPB[i].csordtelcoa__Synchronised_with_Opportunity__c) && (!lstOldPB[i].csordtelcoa__Synchronised_with_Opportunity__c)) {
                mapSyncedProductBasketIdOppId.put(lstNewPB[i].Id, lstNewPB[i].cscfga__Opportunity__c);
            }
        }

        if (mapUnSyncedProductBasketIdOppId.size() > 0) {
            List<LG_PortingNumber__c> lstPortingNumberDisconnectFromOpp = [SELECT Id, LG_Opportunity__c, LG_ProductConfiguration__c,
                                      LG_ProductConfiguration__r.cscfga__Product_Basket__c, LG_Type__c
                                      FROM LG_PortingNumber__c
                                      WHERE LG_Type__c = 'SB Telephony' AND  LG_ProductConfiguration__r.cscfga__Product_Basket__c in : mapUnSyncedProductBasketIdOppId.keyset()];

            if (lstPortingNumberDisconnectFromOpp.size() > 0) {
                for (LG_PortingNumber__c tmpLGPortingNumber : lstPortingNumberDisconnectFromOpp) {
                    tmpLGPortingNumber.LG_Opportunity__c = null;
                }

                update lstPortingNumberDisconnectFromOpp;
            }
        }

        if (mapSyncedProductBasketIdOppId.size() > 0) {
            List<LG_PortingNumber__c> lstPortingNumberConnectToOpp = [SELECT Id, LG_Opportunity__c, LG_ProductConfiguration__c,
                                      LG_ProductConfiguration__r.cscfga__Product_Basket__c, LG_Type__c
                                      FROM LG_PortingNumber__c
                                      WHERE LG_Type__c = 'SB Telephony' AND LG_ProductConfiguration__r.cscfga__Product_Basket__c in : mapSyncedProductBasketIdOppId.keyset()];

            if (lstPortingNumberConnectToOpp.size() > 0) {
                for (LG_PortingNumber__c tmpLGPortingNumber : lstPortingNumberConnectToOpp) {
                    string OppId = mapSyncedProductBasketIdOppId.get(tmpLGPortingNumber.LG_ProductConfiguration__r.cscfga__Product_Basket__c);
                    tmpLGPortingNumber.LG_Opportunity__c = OppId;
                }

                update lstPortingNumberConnectToOpp;
            }
        }
    }
*/
    private static void SetContractTermToOpportunity(List<cscfga__Product_Basket__c> lstNewPB, List<cscfga__Product_Basket__c> lstOldPB) {
        Map<string, string> mapSyncedProductBasketIdOppId = new Map<string, string>();

        for (integer i = 0; i < lstNewPB.size(); ++i) {
            if ((lstNewPB[i].csordtelcoa__Synchronised_with_Opportunity__c) && (!lstOldPB[i].csordtelcoa__Synchronised_with_Opportunity__c)) {
                mapSyncedProductBasketIdOppId.put(lstNewPB[i].Id, lstNewPB[i].cscfga__Opportunity__c);
            }
        }
        System.debug('mapSyncedProductBasketIdOppId'+mapSyncedProductBasketIdOppId);
        //System.debug('***mapSyncedProductBasketIdOppId=' + mapSyncedProductBasketIdOppId);

        if (mapSyncedProductBasketIdOppId.size() > 0) {
            Map<Id, cscfga__Product_Configuration__c> mapPC = new Map<Id, cscfga__Product_Configuration__c>([SELECT cscfga__Product_Basket__c, Id
                    FROM cscfga__Product_Configuration__c
                    WHERE cscfga__Product_Basket__c in : mapSyncedProductBasketIdOppId.keyset()]);

            //System.debug('***mapPC=' + mapPC);

            Set<string> setPCId = new Set<string>();

            for (cscfga__Product_Configuration__c tmpPC : mapPC.values()) {
                setPCId.add(tmpPC.Id);
            }

            //System.debug('***setPCId=' + setPCId);

            List<cscfga__Attribute__c> lstAttrib = [SELECT cscfga__Product_Configuration__c, cscfga__Value__c, Id,
                                                    cscfga__Attribute_Definition__r.LG_ProductDetailType__c
                                                    FROM cscfga__Attribute__c c
                                                    WHERE cscfga__Attribute_Definition__r.LG_ProductDetailType__c = 'Contract Term' AND cscfga__Product_Configuration__c in : setPCId];

            //System.debug('***lstAttrib=' + lstAttrib);

            Map<string, string> mapOppIdContractTerm = new Map<string, string>();

            for (cscfga__Attribute__c tmpAttrib : lstAttrib) {
                string tmpPCId = tmpAttrib.cscfga__Product_Configuration__c;
                string tmpPBId = mapPC.get(tmpPCId).cscfga__Product_Basket__c;
                string tmpOppId = mapSyncedProductBasketIdOppId.get(tmpPBId);
                string tmpContractTerm = tmpAttrib.cscfga__Value__c;

                mapOppIdContractTerm.put(tmpOppId, tmpContractTerm);
            }

            //System.debug('***mapOppIdContractTerm=' + mapOppIdContractTerm);

            if (mapOppIdContractTerm.size() > 0) {
                Map<Id, Opportunity> mapOpportunity = new Map<Id, Opportunity>([SELECT Id, LG_ContractTermMonths__c FROM Opportunity WHERE Id in : mapOppIdContractTerm.keyset()]);
                System.debug('mapOpportunity-->'+mapOpportunity);
                //System.debug('***mapOpportunity=' + mapOpportunity);

                for (Opportunity tmpOpportunity : mapOpportunity.values()) {
                    tmpOpportunity.LG_ContractTermMonths__c = integer.valueof(mapOppIdContractTerm.get(tmpOpportunity.Id));
                    //System.debug('***tmpOpportunity=' + tmpOpportunity);
                }

                //System.debug('***mapOpportunity before=' + mapOpportunity);
                update mapOpportunity.values();
            }
        }
    }

    private static void DeleteOLIsProductDetailsAfterUpdate(List<cscfga__Product_Basket__c> lstNewPB, List<cscfga__Product_Basket__c> lstOldPB) {
        Set<string> setUnSyncedProductBasketId = new Set<string>();

        for (integer i = 0; i < lstNewPB.size(); ++i) {
            if ((!lstNewPB[i].csordtelcoa__Synchronised_with_Opportunity__c) && (lstOldPB[i].csordtelcoa__Synchronised_with_Opportunity__c)) {
                setUnSyncedProductBasketId.add(lstNewPB[i].Id);
            }
        }

        if (setUnSyncedProductBasketId.size() > 0) {
            
            LG_ProductUtility.DeleteHardOLIs(setUnSyncedProductBasketId, lstNewPB);
            //LG_ProductDetailsUtility.DeleteProductDetails(setUnSyncedProductBasketId, lstNewPB);
            LG_ProductUtility.DeleteOpportunityReports(setUnSyncedProductBasketId, lstNewPB);
        }
    }

    private static void InsertOLIsProductDetailsAfterUpdate(List<cscfga__Product_Basket__c> lstNewPB, List<cscfga__Product_Basket__c> lstOldPB) {
        Set<string> setSyncedProductBasketId = new Set<string>();
        Set<string> setSyncedOppId = new Set<string>();

        for (integer i = 0; i < lstNewPB.size(); ++i) {
            if ((lstNewPB[i].csordtelcoa__Synchronised_with_Opportunity__c) && (!lstOldPB[i].csordtelcoa__Synchronised_with_Opportunity__c)) {
                setSyncedProductBasketId.add(lstNewPB[i].Id);
                setSyncedOppId.add(lstNewPB[i].cscfga__Opportunity__c);
            }
        }

        if (setSyncedProductBasketId.size() > 0) {
            //before insert - delete the ones we know for sure will not be needed

            List<cscfga__Product_Basket__c> lstAllProductBasket = [SELECT Id, cscfga__Opportunity__c FROM cscfga__Product_Basket__c WHERE cscfga__Opportunity__c in : setSyncedOppId];

            Set<string> setUnsyncedProductBasketId = new Set<string>();

            for (cscfga__Product_Basket__c tmpProductBasket : lstAllProductBasket) {
                if (!setSyncedProductBasketId.contains(tmpProductBasket.Id)) {
                    setUnsyncedProductBasketId.add(tmpProductBasket.Id);
                }
            }


            if (setUnSyncedProductBasketId.size() > 0) {
                //LG_ProductUtility.DeleteOLIs(setUnSyncedProductBasketId);
                LG_ProductUtility.DeleteHardOLIs(setUnSyncedProductBasketId, lstNewPB);
                //LG_ProductDetailsUtility.DeleteProductDetails(setUnSyncedProductBasketId, lstNewPB);
                LG_ProductUtility.DeleteOpportunityReports(setUnSyncedProductBasketId, lstNewPB);
            }

            if (setSyncedProductBasketId.size() > 0) {
                LG_ProductUtility.CreateOLIs(setSyncedProductBasketId);
                LG_ProductUtility.MapProductConfigurationsToQuotesObject(setSyncedProductBasketId, true);
                //LG_ProductDetailsUtility.CreateProductDetails(setSyncedProductBasketId);
            }
        }
    }

    private static Map<Id, Opportunity> GetmapOpportunityForUpdate(List<cscfga__Product_Basket__c> lstNewPB, List<cscfga__Product_Basket__c> lstOldPB) {
        Set<string> setOppId = new Set<string>();
        Map<Id, Opportunity> mapOpportunity = new Map<Id, Opportunity>();

        for (integer i = 0; i < lstNewPB.size(); ++i) {
            if ((lstNewPB[i].cscfga__Opportunity__c != lstOldPB[i].cscfga__Opportunity__c) || (lstNewPB[i].Name == 'New Basket')) {

                if (lstNewPB[i].cscfga__Opportunity__c != null) {
                    setOppId.add(lstNewPB[i].cscfga__Opportunity__c);
                }
            }
        }

        if (setOppId.size() > 0) {
            mapOpportunity = new Map<Id, Opportunity>([SELECT Id, Name FROM Opportunity WHERE Id in : setOppId]);
        }

        return mapOpportunity;
    }

    private static void ModifyBasketNames(List<cscfga__Product_Basket__c> lstPB, Map<Id, Opportunity> mapOpportunity) {
        Set<string> setPBId = new Set<string>();
        Set<string> setOppId = new Set<string>();

        for (cscfga__Product_Basket__c tmpPB : lstPB) {

            if (ValidateBasketName(tmpPB, mapOpportunity)) {
                setPBId.add(tmpPB.Id);
            }
        }

        if (setPBId.size() > 0) {
            Map<Id, cscfga__Product_Basket__c> mapProductBasketUpdate = new Map<Id, cscfga__Product_Basket__c>([SELECT Id, Name FROM cscfga__Product_Basket__c WHERE Id in : setPBId]);

            List<cscfga__Product_Basket__c> lstProductBasketUpdate = new List<cscfga__Product_Basket__c>();

            for (cscfga__Product_Basket__c tmpPB : lstPB) {
                if (tmpPB.cscfga__Opportunity__c != null) {
                    if  (mapOpportunity.containsKey(tmpPB.cscfga__Opportunity__c)) {
                        Opportunity tmpOpportunity = mapOpportunity.get(tmpPB.cscfga__Opportunity__c);
                        cscfga__Product_Basket__c tmpPBUpdate = mapProductBasketUpdate.get(tmpPB.Id);

                        tmpPBUpdate.Name = 'Basket for ' + tmpOpportunity.Name;

                        lstProductBasketUpdate.add(tmpPBUpdate);

                        //System.debug('***tmpPBUpdate.Name=' + tmpPBUpdate.Name);
                    }
                }
            }

            //System.debug('***lstProductBasketUpdate=' + lstProductBasketUpdate);
            if (lstProductBasketUpdate.size() > 0) {
                update lstProductBasketUpdate;
            }
        }
    }
    
    /*
     * Validates basket name in order to determine is it valid for Name change
    */ 
    private static Boolean ValidateBasketName(cscfga__Product_Basket__c basket, Map<Id, Opportunity> mapOpportunity) {
        
        boolean retval = false;
        
        // Check if basket Name is incorrect or it needs to be changed
        if (mapOpportunity.containsKey(basket.cscfga__Opportunity__c)) {
            retval = (String.isBlank(basket.Name) || basket.Name != 'Basket for ' + mapOpportunity.get(basket.cscfga__Opportunity__c).Name);
        }

        return retval;
    }

    private static void UnSyncProductBasketsAfterInsertUpdate(List<cscfga__Product_Basket__c> lstNewPB, List<cscfga__Product_Basket__c> lstOldPB) {
        //to be called after insert or after update,
        //if newly updated Product Baskets were synced then un-sync all others which have same Opportunity
        //if newly inserted Product Baskets are synced then un-sync all others which have same Opportunity

        Set<string> setOpportunityId = new Set<string>();
        Set<string> setSyncedProductBasketId = new Set<string>();
        Boolean Pass;

        for (integer i = 0; i < lstNewPB.size(); ++i) {
            Pass = false;

            if (lstOldPB == null && lstNewPB[i].csordtelcoa__Synchronised_with_Opportunity__c) {
                Pass = true;
            } else if ((lstNewPB[i].csordtelcoa__Synchronised_with_Opportunity__c) && (!lstOldPB[i].csordtelcoa__Synchronised_with_Opportunity__c)) {
                Pass = true;
            }

            if ((Pass) && (lstNewPB[i].cscfga__Opportunity__c != null)) {
                setOpportunityId.add(lstNewPB[i].cscfga__Opportunity__c);
                setSyncedProductBasketId.add(lstNewPB[i].Id);
            }
        }

        if (setOpportunityId.size() > 0) {
            List<cscfga__Product_Basket__c> lstAllProductBasket = [SELECT Id, csordtelcoa__Synchronised_with_Opportunity__c, cscfga__Opportunity__c
                    FROM cscfga__Product_Basket__c WHERE cscfga__Opportunity__c in : setOpportunityId];

            List<cscfga__Product_Basket__c> lstProductBasketUpdate = new List<cscfga__Product_Basket__c>();

            for (cscfga__Product_Basket__c tmpPB : lstAllProductBasket) {
                if (!setSyncedProductBasketId.contains(tmpPB.Id)) {
                    if (tmpPB.csordtelcoa__Synchronised_with_Opportunity__c) {
                        tmpPB.csordtelcoa__Synchronised_with_Opportunity__c = false;
                        lstProductBasketUpdate.add(tmpPB);
                    }
                }
            }

            if (lstProductBasketUpdate.size() > 0) {
                System.debug('+++#SM list of lstProductBasketUpdate' + lstProductBasketUpdate);
                update lstProductBasketUpdate;
            }
        }
    }

    private static void ModifyBasketNamesForUpdate(List<cscfga__Product_Basket__c> lstNewPB, List<cscfga__Product_Basket__c> lstOldPB) {
        Map<Id, Opportunity> mapOpportunity = GetmapOpportunityForUpdate(lstNewPB, lstOldPB);
        System.debug('before update mapOpportunity=' + mapOpportunity);
        ModifyBasketNames(lstNewPB, mapOpportunity);
    }

    /**
     * Populates the Account field (csbb__Account__c) on the Product Basket level.
     * It uses the Account of the Product Basket related Opportunity.
     * If Product Basket does not have any Opportunity related, Account field will
     * be left unchanged/null.
     *
     * @param  List<cscfga__Product_Basket__c> lstNewPB - trigger.new list
     * @author Tomislav Blazek
     * @ticket SFDT-88
     * @since  15/01/2016
     */
    private static void populateTheCustomerAccountField(List<cscfga__Product_Basket__c> prodBaskets) {
        //holds a set of Product Baskets applicable for processing
        Set<cscfga__Product_Basket__c> applicableProdBaskets = new Set<cscfga__Product_Basket__c>();

        /*
        * Decide which product baskets should be processed:
        * - only the baskets that are having a change on the opportunity field (and opportunity is not null)
        */
        for (cscfga__Product_Basket__c newProdBasket : prodBaskets) {
            if (newProdBasket.cscfga__Opportunity__c != null) {
                applicableProdBaskets.add(newProdBasket);
            }
        }

        if (!applicableProdBaskets.isEmpty()) {
            Set<Id> oppIds = new Set<Id>();

            for (cscfga__Product_Basket__c basket : applicableProdBaskets) {
                oppIds.add(basket.cscfga__Opportunity__c);
            }

            Map<Id, Id> oppToAccountIdMap = new Map<Id, Id>();

            for (Opportunity opp : [SELECT Id, AccountId FROM Opportunity WHERE Id IN :oppIds]) {
                oppToAccountIdMap.put(opp.Id, opp.AccountId);
            }

            for (cscfga__Product_Basket__c prodBasket : applicableProdBaskets) {
                prodBasket.csbb__Account__c = oppToAccountIdMap.get(prodBasket.cscfga__Opportunity__c);
            }
        }
    }

    /**
     * Populates the Billing Account on the Product Basket level. It uses the default Billing Account
     * of the Account assigned to the Product Basket csbb__Account__c field. If Account doesn't have a Default
     * Billing Account, then the cscfga__Product_Basket__c.LG_BillingAccount__c field will be blank.
     *
     * @param  List<cscfga__Product_Basket__c> lstNewPB - trigger.new list
     * @author Tomislav Blazek
     * @ticket SFDT-59
     * @since  13/01/2016
     */
    private static void setDefaultBillingAccount(List<cscfga__Product_Basket__c> lstNewPB) {
        Map<Id, Id> basketToAccountIdMap = new Map<Id, Id>();

        for (cscfga__Product_Basket__c basket : lstNewPB) {
            basketToAccountIdMap.put(basket.Id, basket.csbb__Account__c);
        }

        Map<Id, Id> accountToDefBillingAccIdMap = new Map<Id, Id>();

        for (csconta__Billing_Account__c billAcc : [SELECT Id, csconta__Account__r.Id FROM csconta__Billing_Account__c WHERE csconta__Account__c IN :basketToAccountIdMap.values() AND LG_Default__c = true]) {
            accountToDefBillingAccIdMap.put(billAcc.csconta__Account__r.Id, billAcc.Id);
        }

        for (cscfga__Product_Basket__c basket : lstNewPB) {
            if (accountToDefBillingAccIdMap.containsKey(basketToAccountIdMap.get(basket.Id))) {
                basket.LG_BillingAccount__c = accountToDefBillingAccIdMap.get(basketToAccountIdMap.get(basket.Id));
            }
        }
    }
    
    private static void updatePhoneNumberStatusToReserved(List<cscfga__Product_Basket__c> lstNewPB, List<cscfga__Product_Basket__c> lstOldPB){
        list<Asset> numberBlockAssets = new list<Asset>();
        set<id> synchronisedBaskets = new set<id>();

        for (integer i = 0; i < lstNewPB.size(); ++i) {
            if ((lstNewPB[i].csordtelcoa__Synchronised_with_Opportunity__c) && (!lstOldPB[i].csordtelcoa__Synchronised_with_Opportunity__c)) {
                synchronisedBaskets.add(lstNewPB[i].id);
            }
        }
		if(!synchronisedBaskets.isEmpty())
        	numberBlockAssets = [select id,csord__service__c,UM_Business_Voice_Service__c,UM_Product_Configuration__c
                                from asset where
                                LG_TelephonyProductConfiguration__r.cscfga__Product_Basket__c in :synchronisedBaskets ];

        for(Asset nbAsset : numberBlockAssets){
            nbAsset.Status = 'Reserved';
        }


        update numberBlockAssets;

    }
    
    /**
 * Populate the Penalty Total and Overridden Penalty Total fields on the Opportunity
 *
 * Executes after insert/update
 *
 * @param  List<cscfga__Product_Basket__c> lstNewPB - trigger.new list
 * @author Petar Miletic
 * @ticket SFDT-1188, SFDT-1310
 * @since  13/07/2016
 */
    @TestVisible
    public static void updateOppPenaltyTotals(List<cscfga__Product_Basket__c> lstNewPB, Map<Id, cscfga__Product_Basket__c> lstOldPB) {

        Set<Id> oppIds                             = new Set<Id>();
        Map<Id, cscfga__Product_Basket__c> baskets = new Map<Id, cscfga__Product_Basket__c>();

        for (cscfga__Product_Basket__c basket :lstNewPB) {
            // If Terminate and it was Synchronised
            if ((lstOldPB != null && basket.csordtelcoa__Change_Type__c == 'Terminate' &&
                 basket.csordtelcoa__Synchronised_with_Opportunity__c == true &&
                 basket.csordtelcoa__Synchronised_with_Opportunity__c != lstOldPB.get(basket.Id).csordtelcoa__Synchronised_with_Opportunity__c)
                ||
                (lstOldPB == null && basket.csordtelcoa__Change_Type__c == 'Terminate' &&
                 basket.csordtelcoa__Synchronised_with_Opportunity__c == true)) {

                baskets.put(basket.Id, basket);
                oppIds.add(basket.cscfga__Opportunity__c);
            }
        }

        if (!baskets.isEmpty()) {

            // Get Prodcut Configurations
            List<cscfga__Product_Configuration__c> pcs = [SELECT Id, Name, cscfga__Product_Basket__c, cscfga__Total_Price__c,
                                                          (SELECT Name, cscfga__Price__c
                                                           FROM cscfga__Attributes__r
                                                           WHERE Name IN ('Calculated Price', 'Overridden Price'))
                                                          FROM cscfga__Product_Configuration__c
                                                          WHERE cscfga__Product_Basket__c IN :baskets.keySet() AND cscfga__Product_Definition__r.Name = 'Penalty Fee'];

            // Get Opportunities
            Map<Id, Opportunity> opportunites = new Map<Id, Opportunity>([SELECT Id, Name, LG_CalculatedPenaltyFee__c FROM Opportunity WHERE Id IN:oppIds]);

            // Calculate Basket total and update Opportunities
            for (cscfga__Product_Basket__c b :baskets.values()) {
                Opportunity o = opportunites.get(b.cscfga__Opportunity__c);
                calculateOppTotalFromConfigs(o, b.Id, pcs);
            }

            update opportunites.values();
        }
    }
/*
 * Calculate Basket total
 */
    private static void calculateOppTotalFromConfigs(Opportunity opp, Id basketId, List<cscfga__Product_Configuration__c> pcs) {

        Decimal calcTotal      = 0;
        Decimal overridenTotal = 0;

        for (cscfga__Product_Configuration__c pc :pcs) {

            if (pc.cscfga__Product_Basket__c == basketId) {

                for (cscfga__Attribute__c att : pc.cscfga__Attributes__r) {
                    if (att.Name == 'Calculated Price') {
                        calcTotal += att.cscfga__Price__c;
                    } else if (att.Name == 'Overridden Price') {
                        overridenTotal += att.cscfga__Price__c;
                    }
                }
            }
        }

        opp.LG_CalculatedPenaltyFee__c = calcTotal;
        opp.LG_FinalPenalty__c         = overridenTotal;
    }
}