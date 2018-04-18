/*******************************************************************************************************************************************
* File Name     :  LG_CreateDataFromDWHFeedController
* Description   :  This is the utility class for the class: LG_CreateDataFromDWHFeedBatch

* @author       :   Shreyas
* Modification Log
===================================================================================================
* Ver.    Date          Author              Modification
---------------------------------------------------------------------------------------------------
* 1.0     2nd-Feb-16    Shreyas             Created the class for release R1*

********************************************************************************************************************************************/
/*******************************************************************************************************************************************************************
					Class is commented as Class specific to Ziggo,not used in UM
******************************************************************************************************************************************************************/

Public class LG_CreateDataFromDWHFeedController{
    
    public static void dummy(){
        
        //Class is commented as Class specific to Ziggo,not used in UM
    }
    
    /*

    public map<string, List<map<string, List<LG_DWHFeedStagingTable__c>> > > feedMap;
    public boolean manualSync = false;
    public string uniqueIdForManualSync = '';
    public map<string, string> uniqueIdAccountIdMap;     
    public string soqlQueryForAccount = '';
    public string soqlQueryForContact = '';
    public string soqlQueryForSubscription = '';
    public string soqlQueryForService = '';
    public string soqlQueryForBillingAccount = '';
    public string soqlQueryForPremise = '';
    public string soqlQueryForAttribute = '';
    public string soqlQueryForContract = '';
    
    public string DWHTypeAccount = 'Account';
    public string DWHTypeContact = 'Contact';
    public string DWHTypeSubscription = 'Subscription';
    public string DWHTypeService = 'Service';
    public string DWHTypeBillingAccount = 'Billing Account';
    public string DWHTypePremise = 'Premise';
    public string DWHTypeAttribute = 'Attribute';
    public string DWHTypeContract = 'Contract';
    
    public map<string, string> productNameAndProductDefinitionIdMap;
    public map<string, Decimal> productNameAndHierarchyLevelMap;
    public map<string, string> prodConfigExternalIdAndIdMap;
    public map<string, string> productNameDisplayValueMap;
    public map<string, string> productNameAdditionalDisplayValueMap;
    public map<string, string> productDefinitionRelatedProductAttDefNameMap;
    public map<string, string> productDefinitionProductNameAttDefNameMap;
    public map<string, string> attributeDefinitionHardCodedValueMap;
    public map<string, string> mapForHardCodedValues;
    public map<string, string> mapForProductCategoryNames;
    public map<string, string> mapForProductDefintionNames;
    public list<string> listOfProductDefinitionNames;
    public map<string, string> discountIdMap;
    public map<string, string> priceItemIdMap;
    public map<string, string> addOnPriceItemIdMap;
    public map<string, string> addOnPriceItemNameMap;
    public Set<string> subscriptionNameForLegacyPhoneNumbersSet;
    public map<string, List<string>> productConfigHierarchyMap;
    public string priceItemIdForMKBTelephony = '';
    public set<string> subscriptionUniqueIdSet;
    public set<string> serviceUniqueIdSet;
    public map<string, string> subscriptionNumberSubscriptionIdMap;
    public map<string, string> subscriptionNumberOrderIdMap;
    public map<string, string> serviceNumberServiceIdMap;
    public map<string,List<cscfga__Attribute_Definition__c>> mapForAttributeDefinition;
    public map<string, cscrm__Address__c> existingPremiseMap;
    public Set<string> contactExternalIdList;
    
    public Set<string> listOfConnectMKBProducts;
    public Set<string> listOfPinProducts;
    public Set<string> listOfMultiWifiProducts;
    public Set<string> listOfMiltiWifiAccessPointProducts;
    public Set<string> listOfTelephonyProducts;
    public Set<string> listOfPhoneNumberProducts;
    public Set<string> listOfInternetPlusProducts;
    public Set<string> listOfTelephonyPlusProducts;
    public Set<string> listOfZiggoBreedbandProducts;
    public Set<string> listOfAllMACDEnabledProducts;
    
    public Set<string> listOfProductsWithoutService;
    public Set<string> listOfInternetSecurityProductsForInternetPlus;
    public Set<string> listOfSLAProducts;
    public map<string, string> sla_DisplayMap;
    public Set<string> listOfConnectMKBSubscriptionName;
    public Set<string> listOfMultiWifiSubscriptionName;
    public Set<string> listOfTelephonySubscriptionName;
    public Set<string> listOfInternetPlusSubscriptionName;
    
    
    public string newStatus = 'New';
    public string processedSuccessfullyStatus = 'Processed Successfully';
    public string failedStatus = 'Failed';  
    public map<string, string> exceptionMessageMap;  
    
    public string pc_Internet = '';
    public string pc_RelatedProduct = '';
    public string pc_Telephony = '';
    public string pc_LegacyProducts = '';
    public string pc_LegacyRelatedProducts = '';
    
    public string pd_ConnectMKBInternet = '';
    public string pd_Pin = '';
    public string pd_MultiWifi = '';
    public string pd_WiFiAccessPoint = '';
    public string pd_Telephony = '';
    public string pd_PhoneNumbers = '';
    public string pd_InternetPlus = '';
    public string pd_ZiggoBreedband = '';
    public string pd_TelephonyPlus = '';
    
    public map<string, string> accountIdBackendSourceMap;
    public string accountSource_Derby = '';
    public string accountSource_Dynamics = '';
    public string accountSource_EBS = '';
    public string accountSource_Taifun = '';
    
    public string billingCountry{
    	get{
    		string recordCountry;
    		LG_EnvironmentVariables__c enviornmentSettings = LG_EnvironmentVariables__c.getInstance();
            recordCountry = enviornmentSettings.IdField_BillingCountry__c;
    		return recordCountry;
    	}
    }
    
    
    /*
        Constructor
    */
    
    /*
    public LG_CreateDataFromDWHFeedController(){
        exceptionMessageMap = new map<string, string>();
        createMapOfDWHCustomSetting();
        Set<String> setOfProductDefinitionNames = new Set<String>(listOfProductDefinitionNames);
        createListOfAttributeNamesForProducts(setOfProductDefinitionNames);
        createMapOfDiscountIds();
        createMapOfPriceItemIds();
        createMapOfAddOnPriceItemIds();
    }     
        
    /*
        Name: proceedFeedRecords
        Purpose: to process the feed records to create records in SFDC objects  
        Argument: map<string, List<map<string, List<LG_DWHFeedStagingTable__c>> > >
        Return type: none
    */
/*
    public void processFeedRecords(string uniqueId){
        
        List<Account> accountInsertList = new List<Account>();
        List<Account> accountUpdateList = new List<Account>();
        List<Contact> contactUpsertList = new List<Contact>();
        List<cscrm__Address__c> premiseInsertList = new List<cscrm__Address__c>();
        List<cscrm__Address__c> premiseUpdateList = new List<cscrm__Address__c>();  
        List<csconta__Billing_Account__c> billingAccountUpsertList = new List<csconta__Billing_Account__c>();  
        List<csord__Subscription__c> subscriptionInsertList = new List<csord__Subscription__c>();   
        List<csord__Service__c> serviceInsertList = new List<csord__Service__c>(); 
        List<csord__Subscription__c> subscriptionUpdateList = new List<csord__Subscription__c>();   
        List<csord__Service__c> serviceUpdateList = new List<csord__Service__c>(); 
        set<csord__Order__c> orderUpdateSet = new set<csord__Order__c>();
        List<csord__Order__c> orderUpdateList = new List<csord__Order__c>();
        List<csord__Service_Line_Item__c> sliInsertList = new List<csord__Service_Line_Item__c>();  
        
        List<map<string, List<LG_DWHFeedStagingTable__c>> > tempMapList = new List<map<string, List<LG_DWHFeedStagingTable__c>> >();
        tempMapList = feedMap.get(uniqueId);
        
        map<string, List<LG_DWHFeedStagingTable__c>> accountDWHMap = new map<string, List<LG_DWHFeedStagingTable__c>>();
        map<string, List<LG_DWHFeedStagingTable__c>> contactDWHMap = new map<string, List<LG_DWHFeedStagingTable__c>>();
        map<string, List<LG_DWHFeedStagingTable__c>> subscriptionDWHMap = new map<string, List<LG_DWHFeedStagingTable__c>>();
        map<string, List<LG_DWHFeedStagingTable__c>> serviceDWHMap = new map<string, List<LG_DWHFeedStagingTable__c>>();
        map<string, List<LG_DWHFeedStagingTable__c>> premiseDWHMap = new map<string, List<LG_DWHFeedStagingTable__c>>();
        map<string, List<LG_DWHFeedStagingTable__c>> billingAccountDWHMap = new map<string, List<LG_DWHFeedStagingTable__c>>();
        map<string, List<LG_DWHFeedStagingTable__c>> attributeDWHMap = new map<string, List<LG_DWHFeedStagingTable__c>>();
        map<string, List<LG_DWHFeedStagingTable__c>> contractDWHMap = new map<string, List<LG_DWHFeedStagingTable__c>>();

        for(map<string, List<LG_DWHFeedStagingTable__c>> objMap: tempMapList){
            
            if(objMap.containsKey('Account')){
                accountDWHMap = objMap;
            }
            
            if(objMap.containsKey('Contact')){
                contactDWHMap = objMap;
            }
            
            if(objMap.containsKey('Subscription')){
                subscriptionDWHMap = objMap;
            }
            
            if(objMap.containsKey('Service')){
                serviceDWHMap = objMap;
            }
            
            if(objMap.containsKey('Premise')){
                premiseDWHMap = objMap;
            }
            
            if(objMap.containsKey('BillingAccount')){
                billingAccountDWHMap = objMap;
            }
            
            if(objMap.containsKey('Attribute')){
                attributeDWHMap = objMap;
            }
            
            if(objMap.containsKey('Contract')){
                contractDWHMap = objMap;
            }
            
        }
        
        string accountExternalId = '';
        string accountId = '';
        string s = '';
        boolean processAccountAndRelatedRecords = False;
        
        //********** create Data from for Account DWH records 
        s = 'Account';
        LG_DWHFeedStagingTable__c account_DWHRecord = new LG_DWHFeedStagingTable__c();
        if(accountDWHMap.get(s) != null){
            account_DWHRecord = accountDWHMap.get(s)[0];           
            accountExternalId = account_DWHRecord.LG_AccountExternalId__c;
            
            Account acc = new Account();
            acc.LG_ExternalID__c = accountExternalId;
            acc.LG_AddressSearchText__c = account_DWHRecord.LG_AccountAddressSearchText__c;
            acc.LG_ChamberOfCommerceNumber__c = account_DWHRecord.LG_AccountChamberOfCommerceNumber__c;
            acc.LG_CompetitorContractEndDate__c = account_DWHRecord.LG_AccountCompetitorContractEndDate__c;
            acc.LG_CompetitorName__c = account_DWHRecord.LG_AccountCompetitorName__c;
            acc.LG_CompetitorProduct__c = account_DWHRecord.LG_AccountCompetitorProduct__c;
            acc.LG_CreditRisk__c = account_DWHRecord.LG_AccountCreditRisk__c;
            acc.LG_DateOfEstablishment__c = account_DWHRecord.LG_AccountDateOfEstablishment__c;
            acc.LG_DetailedIndustry__c = account_DWHRecord.LG_AccountDetailedIndustry__c;
            acc.LG_Footprint__c = account_DWHRecord.LG_AccountFootprint__c;
            acc.LG_Industry__c = account_DWHRecord.LG_AccountIndustry__c;
            acc.LG_LegalForm__c = account_DWHRecord.LG_AccountLegalForm__c;
            acc.LG_MobileCompetitorContractEndDate__c = account_DWHRecord.LG_AccountMobileCompContEndDate__c;
            acc.LG_MobileCompetitorName__c = account_DWHRecord.LG_AccountMobileCompetitorName__c;
            acc.Name = account_DWHRecord.LG_AccountName__c;
            acc.LG_NumberOfDesktops__c = account_DWHRecord.LG_AccountNumberOfDesktops__c;
            acc.NumberOfEmployees = Integer.valueOf(account_DWHRecord.LG_AccountNumberOfEmployees__c);
            acc.LG_NumberOfLaptops__c = account_DWHRecord.LG_AccountNumberOfLaptops__c;
            if(account_DWHRecord.LG_AccountOwnerId__c != null){
                //acc.OwnerId = account_DWHRecord.LG_AccountOwnerId__c;
            }               
            acc.ParentId = account_DWHRecord.LG_AccountParentId__c;
            acc.Phone = account_DWHRecord.LG_AccountPhone__c;
            acc.LG_ReadyForService__c = account_DWHRecord.LG_AccountReadyForService__c;
            acc.LG_ReasonForRegistration__c = account_DWHRecord.LG_AccountReasonForRegistration__c;
            acc.LG_Segment__c = account_DWHRecord.LG_AccountSegment__c;
            acc.LG_AccountBackendSource__c = account_DWHRecord.LG_AccountSource__c;
            acc.Type = account_DWHRecord.LG_AccountType__c;
            acc.LG_VisitCity__c = account_DWHRecord.LG_AccountVisitCity__c;
                acc.LG_VisitCountry__c = billingCountry;
            acc.LG_VisitHouseNumber__c = account_DWHRecord.LG_AccountVisitHouseNumber__c;
            acc.LG_VisitHouseNumberExtension__c = account_DWHRecord.LG_AccountVisitHouseNumberExtension__c;
            acc.LG_VisitPostalCode__c = account_DWHRecord.LG_AccountVisitPostalCode__c;
            acc.LG_VisitStreet__c = account_DWHRecord.LG_AccountVisitStreet__c;
            acc.Website = account_DWHRecord.LG_AccountWebsite__c;
            acc.LG_CommerciallyActive__c = account_DWHRecord.LG_AccountCommerciallyActive__c;
            acc.LG_EconomicallyActive__c = account_DWHRecord.LG_AccountEconomicallyActive__c;
            acc.LG_InternetCustomer__c = account_DWHRecord.LG_AccountInternetCustomer__c;
            acc.LG_MobileCustomer__c = account_DWHRecord.LG_AccountMobileCustomer__c;
            acc.LG_PrimaryLocation__c = account_DWHRecord.LG_AccountPrimaryLocation__c;
            acc.LG_TelephonyCustomer__c = account_DWHRecord.LG_AccountTelephonyCustomer__c;
            acc.LG_TVCustomer__c = account_DWHRecord.LG_AccountTVCustomer__c;
            
            if(uniqueIdAccountIdMap.get(uniqueId) != null && uniqueIdAccountIdMap.get(uniqueId) != ''){
                accountId = uniqueIdAccountIdMap.get(uniqueId);
                string sfdcAccountSource = '';
                if(accountIdBackendSourceMap.get(accountId) != null){
                    sfdcAccountSource = accountIdBackendSourceMap.get(accountId).toLowerCase();
                }
                string feedAccountSource = '';
                if(account_DWHRecord.LG_AccountSource__c != null){
                    feedAccountSource = account_DWHRecord.LG_AccountSource__c.toLowerCase();
                }
                
                if( (sfdcAccountSource == feedAccountSource) || 
                    (sfdcAccountSource == '') || 
                    (sfdcAccountSource == null) ||
                    (sfdcAccountSource == accountSource_Derby && feedAccountSource == accountSource_Dynamics) || 
                    (sfdcAccountSource == accountSource_Derby && feedAccountSource == accountSource_Taifun) || 
                    (sfdcAccountSource == accountSource_EBS && feedAccountSource == accountSource_Dynamics) ||
                    (sfdcAccountSource == accountSource_EBS && feedAccountSource == accountSource_Taifun) ||
                    (sfdcAccountSource == accountSource_Taifun && feedAccountSource == accountSource_Dynamics)   
                  ){
                    acc.Id = accountId;
                    accountUpdateList.add(acc);
                    processAccountAndRelatedRecords = True;
                }
            }
            else{
                accountInsertList.add(acc);
                processAccountAndRelatedRecords = True;
            }
            
            if(accountUpdateList.size() > 0){
                update accountUpdateList;
            }
            else if(accountInsertList.size() > 0){
                insert accountInsertList;
                accountId = accountInsertList[0].Id; 
            }
        }
        
        //********** create Data from for Contact DWH records only when the source is Dynamics OR Taifun
        if(processAccountAndRelatedRecords == True){
            
            s = 'Contact';
            List<LG_DWHFeedStagingTable__c> contact_DWHRecords = new List<LG_DWHFeedStagingTable__c>();
            if(contactDWHMap.get(s) != null){
                    
                    contact_DWHRecords = contactDWHMap.get(s);
                    for(LG_DWHFeedStagingTable__c dwh: contact_DWHRecords){
                        
                        Contact con = new Contact();
                        con.AccountId = accountId;
                        con.MailingCity = dwh.LG_ContactCity__c;
                            con.MailingCountry = billingCountry;
                        //com.MailingCountryCode = dwh.LG_ContactCountryCode__c;
                        con.Email = dwh.LG_ContactEmail__c;
                        con.LG_ExternalID__c = dwh.LG_ContactExternalID__c;
                        con.Fax = dwh.LG_ContactFax__c;
                        con.Firstname = dwh.LG_ContactFirstName__c;
                        con.LG_LastInteractionDate__c = dwh.LG_ContactLastInteractionDate__c;
                        con.LG_LastInteractionTopic__c = dwh.LG_ContactLastInteractionTopic__c;
                        con.lastname = dwh.LG_ContactLastName__c;
                        con.MobilePhone = dwh.LG_ContactMobilePhone__c;
                        if(dwh.LG_ContactOwnerId__c != null){
                            con.OwnerId = dwh.LG_ContactOwnerId__c;
                        }
                        con.Phone = dwh.LG_ContactPhone__c;
                        con.MailingPostalCode = dwh.LG_ContactPostalCode__c;
                        con.LG_PreferredCommunication__c = dwh.LG_ContactPreferredCommunication__c;
                        con.LG_Role__c = dwh.LG_ContactRole__c;
                        con.Salutation = dwh.LG_ContactSalutation__c;
                        con.MailingState = dwh.LG_ContactState__c;
                        con.MailingStreet = dwh.LG_ContactStreet__c;
                        con.Title = dwh.LG_ContactTitle__c;
                        con.HasOptedOutOfEmail = dwh.LG_ContactEmailOptOut__c;
                        con.HasOptedOutOfFax = dwh.LG_ContactFaxOptOut__c;
                        con.LG_DecisionMaker__c = dwh.LG_ContactIsDecisionMaker__c;
                        con.LG_MobileOptOut__c = dwh.LG_ContactMobileOptOut__c;
                        con.LG_PhoneOptOut__c = dwh.LG_ContactPhoneOptOut__c;
                        con.LG_PostOptOut__c = dwh.LG_ContactPostOptOut__c;
                        if(dwh.LG_ContactReportsTo__c != null){
                            con.ReportsToId = dwh.LG_ContactReportsTo__c;
                        }
                        
                        contactUpsertList.add(con);
                    }
                    
                if(contactUpsertList.size() > 0){
                    upsert contactUpsertList LG_ExternalID__c;
                }
            }
        }
        
        Map<string, string> contactExternalIdContactIdMap = new Map<string, string>();
        List<Contact> contactListFetched = new List<Contact>(); 
        contactListFetched = [Select Id, LG_ExternalID__c, accountId from Contact where LG_ExternalID__c IN: contactExternalIdList 
                                     AND accountId =: accountId];
        if(contactListFetched != null){
            for(Contact cont: contactListFetched){
                contactExternalIdContactIdMap.put(cont.LG_ExternalId__c, cont.Id);
            }
        }                             
        
        //********** create Data from for Premise DWH records
        List<string> premiseExternalIdList = new List<string>();      
        s = 'Premise';
        List<LG_DWHFeedStagingTable__c> premise_DWHRecords = new List<LG_DWHFeedStagingTable__c>();
        if(premiseDWHMap.get(s) != null){
            
            premise_DWHRecords = premiseDWHMap.get(s);
            for(LG_DWHFeedStagingTable__c dwh: premise_DWHRecords){
            
                premiseExternalIdList.add(dwh.LG_PremiseExternalId__c); 
                string extensionInUpperCase = '';
                if(dwh.LG_PremiseHouseNumberExtension__c != null){
                    extensionInUpperCase = dwh.LG_PremiseHouseNumberExtension__c.toUpperCase();
                }
                string uniqueKeyForDWHPremise = dwh.LG_AccountExternalId__c + '_' + dwh.LG_PremiseHouseNumber__c + '_' + extensionInUpperCase + '_'  + dwh.LG_PremisePostalCode__c;
                if(existingPremiseMap.containsKey(uniqueKeyForDWHPremise)){
                    //existingPremiseMap.get(uniqueKeyForDWHPremise).cscrm__Account__c = accountId;
                    //existingPremiseMap.get(uniqueKeyForDWHPremise).Name = dwh.LG_PremiseName__c;
                    //existingPremiseMap.get(uniqueKeyForDWHPremise).cscrm__Street__c = dwh.LG_PremiseStreet__c;
                    //existingPremiseMap.get(uniqueKeyForDWHPremise).LG_HouseNumber__c = dwh.LG_PremiseHouseNumber__c;
                    //existingPremiseMap.get(uniqueKeyForDWHPremise).LG_HouseNumberExtension__c = dwh.LG_PremiseHouseNumberExtension__c;
                    //existingPremiseMap.get(uniqueKeyForDWHPremise).cscrm__City__c = dwh.LG_PremiseCity__c;
                    //existingPremiseMap.get(uniqueKeyForDWHPremise).cscrm__State_Province__c = dwh.LG_PremiseStateProvince__c;
                    //existingPremiseMap.get(uniqueKeyForDWHPremise).cscrm__Zip_Postal_Code__c = dwh.LG_PremisePostalCode__c;
                    //existingPremiseMap.get(uniqueKeyForDWHPremise).cscrm__Country__c = dwh.LG_PremiseCountry__c;
                    //existingPremiseMap.get(uniqueKeyForDWHPremise).LG_Footprint__c = dwh.LG_PremiseFootprint__c;
                    
                    existingPremiseMap.get(uniqueKeyForDWHPremise).LG_DWHExternalID__c = dwh.LG_PremiseExternalId__c;
                    if(contactExternalIdContactIdMap.get(dwh.LG_PremiseTechnicalContact__c) != null){
                        existingPremiseMap.get(uniqueKeyForDWHPremise).LG_TechnicalContact__c = contactExternalIdContactIdMap.get(dwh.LG_PremiseTechnicalContact__c);
                    }
                    premiseUpdateList.add(existingPremiseMap.get(uniqueKeyForDWHPremise));
                }
                else{
                    cscrm__Address__c premise = new cscrm__Address__c();
                    premise.Name = dwh.LG_PremiseName__c;
                    premise.cscrm__Account__c = accountId;
                    premise.cscrm__Street__c = dwh.LG_PremiseStreet__c;
                    premise.LG_HouseNumber__c = dwh.LG_PremiseHouseNumber__c;
                    premise.LG_HouseNumberExtension__c = dwh.LG_PremiseHouseNumberExtension__c;
                    premise.cscrm__City__c = dwh.LG_PremiseCity__c;
                    premise.cscrm__State_Province__c = dwh.LG_PremiseStateProvince__c;
                    premise.cscrm__Zip_Postal_Code__c = dwh.LG_PremisePostalCode__c;
                        premise.cscrm__Country__c = billingCountry;
                    premise.LG_DWHExternalID__c = dwh.LG_PremiseExternalId__c;
                    premise.LG_Footprint__c = dwh.LG_PremiseFootprint__c;
                    if(contactExternalIdContactIdMap.get(dwh.LG_PremiseTechnicalContact__c) != null){
                        premise.LG_TechnicalContact__c = contactExternalIdContactIdMap.get(dwh.LG_PremiseTechnicalContact__c);
                    }
                    premiseInsertList.add(premise);
                }
            }
            
            if(premiseInsertList.size() > 0){
                insert premiseInsertList;
            }
            
            if(premiseUpdateList.size() > 0){
                update premiseUpdateList;
            }
        }
        
        Map<string, string> premiseExternalIdPremiseIdMap = new Map<string, string>();
        List<cscrm__Address__c> premiseListFetched = new List<cscrm__Address__c>(); 
        premiseListFetched = [Select Id, LG_DWHExternalID__c from cscrm__Address__c where LG_DWHExternalID__c IN: premiseExternalIdList AND cscrm__Account__c =: accountId];
        if(premiseListFetched != null){
            for(cscrm__Address__c premise: premiseListFetched){
                premiseExternalIdPremiseIdMap.put(premise.LG_DWHExternalID__c, premise.Id);
            }
        }

        //********** create Data from for Billing Account DWH records only when the source is Dynamics OR Taifun
        s = 'BillingAccount';
        
        List<LG_DWHFeedStagingTable__c> billingAccount_DWHRecords = new List<LG_DWHFeedStagingTable__c>();
        List<string> billingAccountExternalIdList = new List<string>(); 
        
        if(billingAccountDWHMap.get(s) != null){
            billingAccount_DWHRecords = billingAccountDWHMap.get(s);
            for(LG_DWHFeedStagingTable__c dwh: billingAccount_DWHRecords){
                
                billingAccountExternalIdList.add(dwh.LG_BillingAccountExternalId__c);
                
                if(processAccountAndRelatedRecords == True){
                    csconta__Billing_Account__c billingAccount = new csconta__Billing_Account__c();
                    billingAccount.csconta__Account__c = accountId;
                    billingAccount.csconta__Billing_Channel__c = dwh.LG_BillingAccountBillingChannel__c;
                    billingAccount.csconta__Format_Type__c = dwh.LG_BillingAccountBillFormat__c;
                    billingAccount.csconta__Status__c = dwh.LG_BillingAccountStatus__c;
                    billingAccount.LG_PaymentType__c = dwh.LG_BillingAccountPaymentType__c;
                    billingAccount.csconta__Street__c = dwh.LG_BillingAccountBillingStreet__c;
                    billingAccount.csconta__City__c = dwh.LG_BillingAccountBillingCity__c;
                    billingAccount.LG_HouseNumber__c = dwh.LG_BillingAccountBillingHouseNumber__c;
                    billingAccount.LG_HouseNumberExtension__c= dwh.LG_BillingAccountBillingHouseNumberExt__c;
                    billingAccount.csconta__Postcode__c = dwh.LG_BillingAccountBillingPostcode__c;
                    billingAccount.csconta__Country__c = dwh.LG_BillingAccountBillingCountry__c;
                    billingAccount.LG_BillingEmailAddress__c = dwh.LG_BillingAccountBillingEmailAddress__c;
                    billingAccount.LG_BankAccountNumberIBAN__c = dwh.LG_BillingAccountIBAN__c;
                    billingAccount.LG_BankAccountHolder__c = dwh.LG_BillingAccountBankAccountHolder__c;
                    billingAccount.csconta__Billing_Language__c = dwh.LG_BillingAccountBillingLanguage__c;
                    billingAccount.LG_CustomerReference__c = dwh.LG_BillingAccountCustomerReference__c;
                    billingAccount.LG_Default__c = dwh.LG_BillingAccountDefault__c;
                    billingAccount.csconta__Payment_Terms__c = dwh.LG_BillingAccountPaymentTerms__c;
                    billingAccount.LG_DeliveryMethod__c = dwh.LG_BillingAccountDeliveryMethod__c;
                    billingAccount.LG_DirectDebitMandate__c = dwh.LG_BillingAccountDirectDebitMandate__c;
                    billingAccount.LG_MandateEndDate__c = dwh.LG_BillingAccountMandateEndDate__c;
                    billingAccount.LG_MandateStartDate__c = dwh.LG_BillingAccountMandateStartDate__c;
                    billingAccount.LG_ExternalId__c = dwh.LG_BillingAccountExternalId__c;
                    billingAccountUpsertList.add(billingAccount);
                }
            }
            
            if(billingAccountUpsertList.size() > 0){
                upsert billingAccountUpsertList LG_ExternalId__c; 
            }
        }
        
        Map<string, string> billingAccountExternalIdBillingAccountIdMap = new Map<string, string>();
        List<csconta__Billing_Account__c> billingAccountListFetched = new List<csconta__Billing_Account__c>(); 
        billingAccountListFetched = [Select Id, LG_ExternalId__c, csconta__Account__c from csconta__Billing_Account__c where LG_ExternalId__c IN: billingAccountExternalIdList 
                                     AND csconta__Account__c =: accountId];
        if(billingAccountListFetched != null){
            for(csconta__Billing_Account__c ba: billingAccountListFetched){
                billingAccountExternalIdBillingAccountIdMap.put(ba.LG_ExternalId__c, ba.Id);
            }
        }
        
        
        //********** create Data from Contract DWH records
        s = 'Contract';
        List<LG_DWHFeedStagingTable__c> contract_DWHRecords = new List<LG_DWHFeedStagingTable__c>();
        List<csconta__Contract__c> contractUpsertList = new List<csconta__Contract__c>();
        List<string> contractExternalIdList = new List<string>();
        
        if(contractDWHMap.get(s) != null){
            contract_DWHRecords = contractDWHMap.get(s);
            for(LG_DWHFeedStagingTable__c dwh: contract_DWHRecords){
                csconta__Contract__c contract = new csconta__Contract__c();
                contractExternalIdList.add(dwh.LG_ContractNumber__c);
                contract.LG_DWHExternalID__c = dwh.LG_ContractNumber__c;
                contract.csconta__Valid_From__c = dwh.LG_ContractStartDate__c;
                contract.csconta__Valid_To__c = dwh.LG_ContractExpirationDate__c;
                contract.LG_TerminationDate__c = dwh.LG_ContractEndDate__c;
                contract.csconta__Status__c = dwh.LG_ContractStatus__c;
                contract.csconta__Account__c = accountId;
                contractUpsertList.add(contract);
            }
            
            if(contractUpsertList.size() > 0){
                upsert contractUpsertList LG_DWHExternalID__c;
            }
        }
        
        List<csconta__Contract__c> contractListFetched = new List<csconta__Contract__c>();
        Map<string, string> contractMap = new Map<string, string>();
        contractListFetched = [Select Id, LG_DWHExternalID__c from csconta__Contract__c where LG_DWHExternalID__c IN: contractExternalIdList];
        for(csconta__Contract__c cont: contractListFetched){
            contractMap.put(cont.LG_DWHExternalID__c, cont.Id);             
        } 
        
        system.debug('### subscriptionUniqueIdSet in the main method: ' + subscriptionUniqueIdSet);
        
        //********** update the Tracy Id in existing Subscription and service record
        if(subscriptionUniqueIdSet.contains(uniqueId)){
            
            s = 'Subscription';
            List<LG_DWHFeedStagingTable__c> subscription_DWHRecords = new List<LG_DWHFeedStagingTable__c>();
            if(subscriptionDWHMap.get(s) != null){
                
                subscription_DWHRecords = subscriptionDWHMap.get(s);
                for(LG_DWHFeedStagingTable__c dwh: subscription_DWHRecords){
                    csord__Subscription__c subs = new csord__Subscription__c();
                    if(subscriptionNumberSubscriptionIdMap.get(dwh.LG_SubscriptionNumber__c) != null){
                        subs.Id = subscriptionNumberSubscriptionIdMap.get(dwh.LG_SubscriptionNumber__c);
                    }
                    subs.LG_SubscriptionExternalId__c = dwh.LG_SubscriptionExternalId__c;
                    subs.csord__Status__c = dwh.LG_SubscriptionStatus__c;
                    subscriptionUpdateList.add(subs);
                    
                    //update the respective Order record
                    csord__Order__c ord = new csord__Order__c();
                    ord.csord__Status2__c = dwh.LG_SubscriptionStatus__c;
                    if(subscriptionNumberOrderIdMap.get(dwh.LG_SubscriptionNumber__c) != null){
                        ord.Id = subscriptionNumberOrderIdMap.get(dwh.LG_SubscriptionNumber__c);
                    }
                    orderUpdateSet.add(ord);
                }
                
                if(subscriptionUpdateList.size() > 0){
                    update subscriptionUpdateList;
                }
                if(orderUpdateSet.size() > 0){
                    orderUpdateList = new List<csord__Order__c>(orderUpdateSet);
                    update orderUpdateList;
                }
            }
            
            s = 'Service';
            List<LG_DWHFeedStagingTable__c> service_DWHRecords = new List<LG_DWHFeedStagingTable__c>();
            if(serviceDWHMap.get(s) != null){
                
                service_DWHRecords = serviceDWHMap.get(s);
                for(LG_DWHFeedStagingTable__c dwh: service_DWHRecords){
                    string productName = dwh.LG_ServiceName__c.toLowerCase();
                    if(!listOfProductsWithoutService.contains(productName)){
                        csord__Service__c serv = new csord__Service__c();
                        if(serviceNumberServiceIdMap.get(dwh.LG_ServiceNumber__c) != null){
                            serv.Id = serviceNumberServiceIdMap.get(dwh.LG_ServiceNumber__c);
                        }
                        serv.LG_ServiceExternalId__c = dwh.LG_ServiceExternalId__c; 
                        serv.csord__Status__c = dwh.LG_ServiceStatus__c;                      
                        serviceUpdateList.add(serv);
                    }
                }
                
                if(serviceUpdateList.size() > 0){
                    update serviceUpdateList;
                }
            }
        }
        //********** create new subscriptions and services
        else{
            //********** create Data from for Subscription DWH records
            s = 'Subscription';
            List<csord__Order_Request__c> orderRequestInsertList = new List<csord__Order_Request__c>();
            string orderRequestId = '';
            List<cscfga__Product_Basket__c> productBasketInsertList = new List<cscfga__Product_Basket__c>();
            string productBasketId = '';
            List<csord__Order__c> orderInsertList = new List<csord__Order__c>();
            string orderId = '';
            List<LG_DWHFeedStagingTable__c> subscription_DWHRecords = new List<LG_DWHFeedStagingTable__c>();
            if(subscriptionDWHMap.get(s) != null){
                
                subscription_DWHRecords = subscriptionDWHMap.get(s);
                
                csord__Order_Request__c orderReq = new csord__Order_Request__c();
                orderReq.Name = 'Order Request For ' + accountId;
                orderReq.csord__Module_Name__c = 'CS Order Implementation Module Telco A';
                orderReq.csord__Module_Version__c = '1.0';
                orderRequestInsertList.add(orderReq);
                
                cscfga__Product_Basket__c pb = new cscfga__Product_Basket__c();
                pb.Name = 'Product Basket for ' + accountId;
                productBasketInsertList.add(pb);
                    
                    
                
                if(orderRequestInsertList.size() > 0){
                    insert orderRequestInsertList; 
                    orderRequestId = orderRequestInsertList[0].Id;                     
                } 
                
                
                if(productBasketInsertList.size() > 0){
                    insert productBasketInsertList;  
                    productBasketId = productBasketInsertList[0].Id;                     
                } 
                
                csord__Order__c o = new csord__Order__c();
                o.Name = 'Order For ' + accountId;
                o.csord__Account__c = accountId;
                o.csord__Status2__c = 'Order Submitted';
                o.csord__Order_Request__c = orderRequestId;
                o.csord__Identification__c = 'CreatedByDWHOn_' + system.now();
                orderInsertList.add(o);
                    
                if(orderInsertList.size() > 0){
                    insert orderInsertList;  
                    orderId = orderInsertList[0].Id;                     
                } 
                              
                
                for(LG_DWHFeedStagingTable__c dwh: subscription_DWHRecords){
                    
                    csord__Subscription__c subs = new csord__Subscription__c();
                    subs.csord__Account__c = accountId;
                    subs.Name = dwh.LG_SubscriptionName__c;
                    subs.csord__Order_Request__c = orderRequestId;
                    subs.LG_SubscriptionExternalId__c = dwh.LG_SubscriptionExternalId__c;
                    subs.csord__Identification__c = orderRequestId;
                    subs.LG_Contract__c = contractMap.get(dwh.LG_SubscriptionContractNumber__c);
                    subs.csord__Status__c = dwh.LG_SubscriptionStatus__c;
                    subs.csord__Order__c = orderId;
                    subscriptionInsertList.add(subs);
                }
                
                if(subscriptionInsertList.size() > 0){
                    insert subscriptionInsertList;
                } 
            }
            
            List<csord__Subscription__c> subscriptionListFetched = new List<csord__Subscription__c>();
            Map<string, string> subscriptionIdMap = new Map<string, string>();
            Map<string, string> subscriptionNameMap = new Map<string, string>();
            
            subscriptionListFetched = [Select Id, Name, LG_SubscriptionExternalId__c from csord__Subscription__c where csord__Account__c =: accountId];
            for(csord__Subscription__c subs: subscriptionListFetched){
                subscriptionIdMap.put(subs.LG_SubscriptionExternalId__c, subs.Id); 
                subscriptionNameMap.put(subs.LG_SubscriptionExternalId__c, subs.Name);            
            }      
            
            
            //********** create Data (Product Configuration and Service) from for Service DWH records
            ///*
            List<cscfga__Product_Configuration__c> productConfigInsertList = new List<cscfga__Product_Configuration__c>(); 
            List<cscfga__Product_Configuration__c> productConfigListToUpdate = new List<cscfga__Product_Configuration__c>();
            map<string,string> serviceIdSubscriptionIdMap = new map<string,string>();
                
            s = 'Service';
            List<LG_DWHFeedStagingTable__c> service_DWHRecords = new List<LG_DWHFeedStagingTable__c>();
            map<string, csord__Service__c> serviceRecordMap = new map<string, csord__Service__c>();
            
            if(serviceDWHMap.get(s) != null){
                
                service_DWHRecords = serviceDWHMap.get(s);
                integer indexForPhoneNumbers = 0;
                integer indexForMultiWifiAccessPoint = 0;
                
                for(LG_DWHFeedStagingTable__c dwh: service_DWHRecords){
                    
                    string productName = dwh.LG_ServiceName__c.toLowerCase();
                    if(listOfAllMACDEnabledProducts.contains(productName)){
                        
                        cscfga__Product_Configuration__c prodconfig = new cscfga__Product_Configuration__c();
                        prodconfig.Name = dwh.LG_ServiceName__c;
                        prodconfig.cscfga__Description__c = dwh.LG_ServiceExternalId__c;
                        prodconfig.cscfga__Product_Family__c = dwh.LG_ServiceName__c;
                        if(dwh.LG_ServiceName__c.length() > 40){
                            prodconfig.cscfga__Product_Family__c = dwh.LG_ServiceName__c.substring(0,40);
                        }
                        prodconfig.cscfga__Quantity__c = 1;
                        prodconfig.cscfga__Unit_Price__c = dwh.LG_ServiceUnitPrice__c;
                        if(prodconfig.cscfga__Unit_Price__c != null){
                            prodconfig.cscfga__Total_Price__c = dwh.LG_ServiceUnitPrice__c * dwh.LG_ServiceQuantity__c;
                        }
                        prodconfig.cscfga__Billing_Frequency__c = 12;
                        prodconfig.cscfga__Recurrence_Frequency__c = 12;
                        prodconfig.cscfga__Product_Basket__c = productBasketId;
                        if(premiseExternalIdPremiseIdMap.containsKey(dwh.LG_ServicePremiseId__c)){
                            prodconfig.LG_Address__c = premiseExternalIdPremiseIdMap.get(dwh.LG_ServicePremiseId__c);
                        }
                        string serviceName = dwh.LG_ServiceName__c;
                        serviceName = serviceName.toLowerCase();
                        if(listOfPhoneNumberProducts.contains(serviceName)){
                            prodconfig.cscfga__Index__c = indexForPhoneNumbers;
                            indexForPhoneNumbers++;
                        }
                        else if(listOfMiltiWifiAccessPointProducts.contains(serviceName)){   
                            prodconfig.cscfga__Index__c = indexForMultiWifiAccessPoint;
                            indexForMultiWifiAccessPoint++;
                        }
                        else{
                            prodconfig.cscfga__Index__c = 0;
                        }
                        
                        string subscriptionName = subscriptionNameMap.get(dwh.LG_ServiceSubscriptionExternalId__c);
                        if(subscriptionNameForLegacyPhoneNumbersSet.contains(subscriptionName) && listOfPhoneNumberProducts.contains(serviceName)){
                            serviceName = 'legacy ' + serviceName;
                        }
                        
                        prodconfig.cscfga__Product_Definition__c = productNameAndProductDefinitionIdMap.get(serviceName);
                        prodconfig.csordtelcoa__Hierarchy_Level__c = productNameAndHierarchyLevelMap.get(serviceName);
                        
                        productConfigInsertList.add(prodconfig);
                        system.debug('### product Definition Id : ' +  prodconfig.Name +  ' -- '  + prodconfig.cscfga__Product_Definition__c );
                        system.debug('### index for : ' +  prodconfig.Name +  ' -- '  + prodconfig.cscfga__Index__c);
                        system.debug('### hierarchy level for : ' +  prodconfig.Name +  ' -- '  + prodconfig.csordtelcoa__Hierarchy_Level__c);
                    }
                    
                    serviceIdSubscriptionIdMap.put(dwh.LG_ServiceExternalId__c, dwh.LG_ServiceSubscriptionExternalId__c);
                }
                
                if(productConfigInsertList.size() > 0){
                    insert productConfigInsertList;
                }
                
                List<cscfga__Product_Configuration__c> productConfigListFetched = new List<cscfga__Product_Configuration__c>();            
                prodConfigExternalIdAndIdMap = new map<string, string>();                
                productConfigHierarchyMap = new map<string, List<string>>();
                  
                productConfigListFetched = [Select Id, Name, csordtelcoa__Hierarchy_Level__c, cscfga__Root_Configuration__c, cscfga__Description__c 
                                            from cscfga__Product_Configuration__c where Id IN: productConfigInsertList];
                string productName = '';
                
                for(cscfga__Product_Configuration__c pc: productConfigListFetched){
                    prodConfigExternalIdAndIdMap.put(pc.cscfga__Description__c, pc.Id);
                    
                    productName = pc.Name;
                    productName = productName.toLowerCase();
                    
                    string subscriptionExternalId = serviceIdSubscriptionIdMap.get(pc.cscfga__Description__c);
                    string subscriptionName = subscriptionNameMap.get(subscriptionExternalId);
                    if(subscriptionNameForLegacyPhoneNumbersSet.contains(subscriptionName) && listOfPhoneNumberProducts.contains(productName)){
                        productName = 'legacy ' + productName;
                    }
                    
                        
                    if(pc.csordtelcoa__Hierarchy_Level__c == 0){
                        string firstLevelProductsKey = '';
                        
                        if(listOfConnectMKBProducts.contains(productName)){
                            firstLevelProductsKey = '0_' + pd_ConnectMKBInternet;
                        }
                        else if(listOfMultiWifiProducts.contains(productName)){
                            firstLevelProductsKey = '0_' + pd_MultiWifi;
                        }
                        else if(listOfTelephonyProducts.contains(productName)){
                            firstLevelProductsKey = '0_' + pd_Telephony;
                        }
                        else if(listOfInternetPlusProducts.contains(productName)){
                            firstLevelProductsKey = '0_' + pd_InternetPlus;
                        }
                        
                        if(productConfigHierarchyMap.containsKey(firstLevelProductsKey)){
                            productConfigHierarchyMap.get(firstLevelProductsKey).add(pc.Id);
                        }
                        else{
                            productConfigHierarchyMap.put(firstLevelProductsKey, new List<String>{pc.Id});
                        }
                    }
                    
                    if(pc.csordtelcoa__Hierarchy_Level__c == 1){
                        string secondLevelProductsKey = '';
                        subscriptionName = '';
                        string productConfigServiceExternalId = pc.cscfga__Description__c;
                        string subscriptionId = serviceIdSubscriptionIdMap.get(productConfigServiceExternalId);
                        
                        if(listOfPinProducts.contains(productName)){
                            
                            if(subscriptionNameMap.get(subscriptionId) != null){
                                subscriptionName = subscriptionNameMap.get(subscriptionId);
                            }
                            if(subscriptionName.containsIgnoreCase('MKB')){
                                secondLevelProductsKey = '1_' + pd_Pin + pd_ConnectMKBInternet;
                            }
                            if(subscriptionName.containsIgnoreCase('Internet Plus')){
                                secondLevelProductsKey = '1_' + pd_Pin + pd_InternetPlus;
                            } 
                        }
                        else if(listOfMiltiWifiAccessPointProducts.contains(productName)){
                            secondLevelProductsKey = '1_' + pd_WiFiAccessPoint;
                        }
                        else if(listOfPhoneNumberProducts.contains(productName)){
                            secondLevelProductsKey = '1_' + pd_PhoneNumbers;
                        }
                        else if(listOfTelephonyPlusProducts.contains(productName)){
                            secondLevelProductsKey = '1_' + pd_TelephonyPlus;
                        }
                        
                        if(productConfigHierarchyMap.containsKey(secondLevelProductsKey)){
                            productConfigHierarchyMap.get(secondLevelProductsKey).add(pc.Id);
                        }
                        else{
                            productConfigHierarchyMap.put(secondLevelProductsKey, new List<String>{pc.Id});
                        }
                    }
                    
                    if(pc.csordtelcoa__Hierarchy_Level__c == 2){
                        string thirdLevelProductsKey = '';
                        
                        if(listOfPhoneNumberProducts.contains(productName)){
                            thirdLevelProductsKey = '2_' + pd_PhoneNumbers;
                        }
                        
                        
                        if(productConfigHierarchyMap.containsKey(thirdLevelProductsKey)){
                            productConfigHierarchyMap.get(thirdLevelProductsKey).add(pc.Id);
                        }
                        else{
                            productConfigHierarchyMap.put(thirdLevelProductsKey, new List<String>{pc.Id});
                        }
                    }               
                }
                system.debug('### prodConfigExternalIdAndIdMap: ' + prodConfigExternalIdAndIdMap);
                system.debug('### productConfigHierarchyMap: ' + productConfigHierarchyMap);
                
                for(cscfga__Product_Configuration__c pc: productConfigListFetched){
                    
                    productName = pc.Name;
                    productName = productName.toLowerCase();
                    string subscriptionExternalId = serviceIdSubscriptionIdMap.get(pc.cscfga__Description__c);
                    string subscriptionName = subscriptionNameMap.get(subscriptionExternalId);
                    if(subscriptionNameForLegacyPhoneNumbersSet.contains(subscriptionName) && listOfPhoneNumberProducts.contains(productName)){
                        productName = 'legacy ' + productName;
                    }
                    
                    
                    if(pc.csordtelcoa__Hierarchy_Level__c == 1){
                        string firstLevelProductsKey = '';
                        subscriptionName = '';
                        string productConfigServiceExternalId = pc.cscfga__Description__c;
                        string subscriptionId = serviceIdSubscriptionIdMap.get(productConfigServiceExternalId);
                        
                        if(listOfPinProducts.contains(productName)){
                            if(subscriptionNameMap.get(subscriptionId) != null){
                                subscriptionName = subscriptionNameMap.get(subscriptionId);
                            }
                            if(subscriptionName.containsIgnoreCase('MKB')){
                                firstLevelProductsKey = '0_' + pd_ConnectMKBInternet;
                            }
                            if(subscriptionName.containsIgnoreCase('Internet Plus')){
                                firstLevelProductsKey = '0_' + pd_InternetPlus;
                            }
                        }
                        else if(listOfMiltiWifiAccessPointProducts.contains(productName)){
                            firstLevelProductsKey = '0_' + pd_MultiWifi;
                        }
                        else if(listOfPhoneNumberProducts.contains(productName)){
                            firstLevelProductsKey = '0_' + pd_Telephony;
                        }
                        else if(listOfTelephonyPlusProducts.contains(productName)){
                            firstLevelProductsKey = '0_' + pd_InternetPlus;
                        }
                        
                        
                            pc.cscfga__Parent_Configuration__c = productConfigHierarchyMap.get(firstLevelProductsKey)[0];
                            pc.cscfga__Root_Configuration__c = productConfigHierarchyMap.get(firstLevelProductsKey)[0];
                        }
                    if(pc.csordtelcoa__Hierarchy_Level__c == 2){
                        string firstLevelProductsKey = '';
                        string secondLevelProductsKey = '';
                        
                        if(listOfPhoneNumberProducts.contains(productName)){
                            firstLevelProductsKey = '0_' + pd_InternetPlus;
                            secondLevelProductsKey = '1_' + pd_TelephonyPlus;
                        }
                         
                        pc.cscfga__Parent_Configuration__c = productConfigHierarchyMap.get(secondLevelProductsKey)[0];
                            pc.cscfga__Root_Configuration__c = productConfigHierarchyMap.get(firstLevelProductsKey)[0];
                        }
                    productConfigListToUpdate.add(pc);
                }
                
                system.debug('### productConfigListToUpdate: ' + productConfigListToUpdate);
                if(productConfigListToUpdate.size() > 0){
                    update productConfigListToUpdate;
                } 
                 
                for(LG_DWHFeedStagingTable__c dwh: service_DWHRecords){
                    
                    csord__Service__c service = new csord__Service__c();
                    service.LG_ServiceExternalId__c = dwh.LG_ServiceExternalId__c;
                    service.Name = dwh.LG_ServiceName__c;
                    service.LG_ExternalSubscriptionName__c = subscriptionNameMap.get(dwh.LG_ServiceSubscriptionExternalId__c);
                    service.csord__Order_Request__c = orderRequestId;
                    service.LG_OrderNumber__c = dwh.LG_ServiceSubscriptionExternalId__c;
                    service.csordtelcoa__Product_Configuration__c = prodConfigExternalIdAndIdMap.get(dwh.LG_ServiceExternalId__c);
                    service.csord__Identification__c = orderRequestId;
                    service.csord__Status__c = dwh.LG_ServiceStatus__c;
                    if(subscriptionIdMap.containsKey(dwh.LG_ServiceSubscriptionExternalId__c)){
                        service.csord__Subscription__c = subscriptionIdMap.get(dwh.LG_ServiceSubscriptionExternalId__c);
                    }
                    if(premiseExternalIdPremiseIdMap.containsKey(dwh.LG_ServicePremiseId__c)){
                        service.LG_Address__c = premiseExternalIdPremiseIdMap.get(dwh.LG_ServicePremiseId__c);
                    }
                    service.LG_BillingFrequency__c = 'Monthly';
                    service.LG_CurrencyCode__c = 'EUR';
                    serviceRecordMap.put(service.LG_ServiceExternalId__c, service);
                }                
            }
            
            //********** create Data from for Attribute DWH records
            s = 'Attribute';
            List<LG_DWHFeedStagingTable__c> attribute_DWHRecords = new List<LG_DWHFeedStagingTable__c>();
    
            if(attributeDWHMap.get(s) != null){
                
                attribute_DWHRecords = attributeDWHMap.get(s);
                string productName = '';
                string productNameForServiceLineItem = '';
                string typeForServiceLineItem = 'Product';
                string prodConfigId = '';
                integer quantityForInternetSecurityForInternetPlus = null;
                string premiseIdAttribute = mapForHardCodedValues.get('LG_AttributeForPremiseId');
                map<string, string> subscriptionIdSLAKeyMap = new map<string, string>();
                List<cscfga__Attribute__c> attributeInsertList = new List<cscfga__Attribute__c>();
                system.debug('### priceItemIdMap: ' + priceItemIdMap);
                system.debug('### discountIdMap: ' + discountIdMap);
                system.debug('### addOnPriceItemIdMap: ' + addOnPriceItemIdMap);
                
                
                for(LG_DWHFeedStagingTable__c dwh: attribute_DWHRecords){
                    
                    if(serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c) != null){
                        productName = serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).Name;
                        productNameForServiceLineItem = productName;
                    }
                    
                    productName = productName.toLowerCase();
                    if(listOfSLAProducts.contains(productName)){
                        
                        string sla_type = dwh.LG_AttributeSLA__c.toLowerCase();
                        string displayValueForSLA = sla_DisplayMap.get(sla_type);
                        string keyForSLA = dwh.LG_AttributeContractTerm__c + '_' + displayValueForSLA;
                        system.debug('### keyForSLA: ' + keyForSLA);
                        string serviceExternalId = dwh.LG_AttributeServiceExternalId__c;
                        string subscriptionExternalId = serviceIdSubscriptionIdMap.get(serviceExternalId);
                        subscriptionIdSLAKeyMap.put(subscriptionExternalId, keyForSLA);
                        
                        string subscriptionName = subscriptionNameMap.get(subscriptionExternalId);
                        string serviceExternalIdForSLI = '';
                        if(listOfConnectMKBSubscriptionName.contains(subscriptionName)){
                            for(string serviceExtId: serviceRecordMap.keyset()){
                                if(listOfConnectMKBProducts.contains(serviceRecordMap.get(serviceExtId).Name.toLowerCase())){
                                    serviceExternalIdForSLI = serviceExtId;
                                }
                            }
                        }
                        else if(listOfMultiWifiSubscriptionName.contains(subscriptionName)){
                            for(string serviceExtId: serviceRecordMap.keyset()){
                                if(listOfMultiWifiProducts.contains(serviceRecordMap.get(serviceExtId).Name.toLowerCase())){
                                    serviceExternalIdForSLI = serviceExtId;
                                }
                            }
                        }
                        else if(listOfTelephonySubscriptionName.contains(subscriptionName)){
                            for(string serviceExtId: serviceRecordMap.keyset()){
                                if(listOfTelephonyProducts.contains(serviceRecordMap.get(serviceExtId).Name.toLowerCase())){
                                    serviceExternalIdForSLI = serviceExtId;
                                }
                            }
                        }
                        else if(listOfInternetPlusSubscriptionName.contains(subscriptionName)){
                            for(string serviceExtId: serviceRecordMap.keyset()){
                                if(listOfInternetPlusProducts.contains(serviceRecordMap.get(serviceExtId).Name.toLowerCase())){
                                    serviceExternalIdForSLI = serviceExtId;
                                }
                            }
                        }
                        system.debug('### serviceExternalIdForSLI: ' + serviceExternalIdForSLI);
                        
                        //Code for initializing sli insert for SLA... 
                        typeForServiceLineItem = 'Add On';
                        if(dwh.LG_AttributeOneOffCharge__c != null){
                            csord__Service_Line_Item__c sli1_sla = new csord__Service_Line_Item__c();
                            sli1_sla.Name = productNameForServiceLineItem;
                            sli1_sla.LG_ExternalServiceName__c = productNameForServiceLineItem;
                            sli1_sla.csord__Total_Price__c = dwh.LG_AttributeOneOffCharge__c;
                            sli1_sla.csord__Is_Recurring__c = False;
                            sli1_sla.csord__Order_Request__c = orderRequestId;
                            sli1_sla.csord__Identification__c = orderRequestId;
                            sli1_sla.csord__Line_Description__c = serviceExternalIdForSLI;
                            sli1_sla.LG_ToBeSent__c  = 'True';
                            if(billingAccountExternalIdBillingAccountIdMap.get(dwh.LG_AttributeBillingAccount__c) != null){
                                sli1_sla.LG_BillingAccount__c = billingAccountExternalIdBillingAccountIdMap.get(dwh.LG_AttributeBillingAccount__c);
                            }
                            sliInsertList.add(sli1_sla);
                        }
                        if(dwh.LG_AttributeRecurringCharge__c != null){
                            csord__Service_Line_Item__c sli2_sla = new csord__Service_Line_Item__c();
                            sli2_sla.Name = productNameForServiceLineItem;
                            sli2_sla.LG_ExternalServiceName__c = productNameForServiceLineItem;
                            sli2_sla.csord__Total_Price__c = dwh.LG_AttributeRecurringCharge__c;
                            sli2_sla.csord__Is_Recurring__c = True;
                            sli2_sla.csord__Order_Request__c = orderRequestId;
                            sli2_sla.csord__Identification__c = orderRequestId;
                            sli2_sla.csord__Line_Description__c = serviceExternalIdForSLI;
                            sli2_sla.LG_ToBeSent__c  = 'True';
                            if(billingAccountExternalIdBillingAccountIdMap.get(dwh.LG_AttributeBillingAccount__c) != null){
                                sli2_sla.LG_BillingAccount__c = billingAccountExternalIdBillingAccountIdMap.get(dwh.LG_AttributeBillingAccount__c);
                            }
                            sliInsertList.add(sli2_sla);
                        }
                        
                    }
                    
                    if(listOfInternetSecurityProductsForInternetPlus.contains(productName)){
                        if(productName == mapForHardCodedValues.get('LG_InternetSecurity_1').toLowerCase()){
                            quantityForInternetSecurityForInternetPlus = 1;
                        }
                        if(productName == mapForHardCodedValues.get('LG_InternetSecurity_2').toLowerCase()){
                            quantityForInternetSecurityForInternetPlus = 5;
                        }
                    }
                }
                system.debug('### subscriptionIdSLAKeyMap: ' + subscriptionIdSLAKeyMap);
                
                for(LG_DWHFeedStagingTable__c dwh: attribute_DWHRecords){
                    
                    if(serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c) != null){
                        productName = serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).Name;
                        productNameForServiceLineItem = productName;
                    }
                    productName = productName.toLowerCase();
                    
                    string subscriptionExternalId = serviceIdSubscriptionIdMap.get(dwh.LG_AttributeServiceExternalId__c);
                    string subscriptionName = subscriptionNameMap.get(subscriptionExternalId);
                    if(subscriptionNameForLegacyPhoneNumbersSet.contains(subscriptionName) && listOfPhoneNumberProducts.contains(productName)){
                        productName = 'legacy ' + productName;
                    }
                    
                    // process all the attribute records which should create a separate service according to the Cloudsense model
                    if(!listOfProductsWithoutService.contains(productName)){
                        
                        string relatedProductAttributeDefinitionName = '';
                        string relatedProductAttributeDefinitionName_Pin = '';
                        string relatedProductAttributeDefinitionName_Discount = '';
                        string relatedProductAttributeDefinitionName_Telephony = '';
                        string productNameAttributeDefinitionName = '';
                        string commaSeperatedIds = '';
                        
                        if(serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c) != null){
                            system.debug('### productName : ' + productName);
                            
                            if(listOfConnectMKBProducts.contains(productName)){
                                system.debug('### Connect MKB ');
                                typeForServiceLineItem = 'Product';
                                string priceItemId = '';
                                string productDisplayName = productNameDisplayValueMap.get(productName);
                                productDisplayName = productDisplayName.toLowerCase();
                                string uniqueString = dwh.LG_AttributeContractTerm__c + '_' + productDisplayName;
                                if(priceItemIdMap.get(uniqueString) != null){
                                    priceItemId = priceItemIdMap.get(uniqueString);      
                                }
                                system.debug('### priceItemId for MKB: ' + priceItemId);
                                
                                string discountId = '';
                                string uniqueStringForDiscount = dwh.LG_AttributeDiscount__c + '_' + dwh.LG_AttributeContractTerm__c;
                                if(discountIdMap.get(uniqueStringForDiscount) != null){
                                     discountId = discountIdMap.get(uniqueStringForDiscount); 
                                }
                                
                                string addOnPriceItemIdForSLA = '';
                                subscriptionExternalId = serviceIdSubscriptionIdMap.get(dwh.LG_AttributeServiceExternalId__c);
                                string keyForSLA = '';
                                if(subscriptionIdSLAKeyMap.containsKey(subscriptionExternalId)){
                                    keyForSLA = subscriptionIdSLAKeyMap.get(subscriptionExternalId);
                                }
                                if(addOnPriceItemIdMap.containsKey(keyForSLA) != null){
                                    addOnPriceItemIdForSLA = addOnPriceItemIdMap.get(keyForSLA);      
                                }
                                system.debug('### addOnPriceItemIdForSLA for MKB: ' + addOnPriceItemIdForSLA);
                                
                                if(prodConfigExternalIdAndIdMap.get(dwh.LG_AttributeServiceExternalId__c) != null){
                                    prodConfigId = prodConfigExternalIdAndIdMap.get(dwh.LG_AttributeServiceExternalId__c);     
                                }
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ProductFamily__c = pc_Internet;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ContractTerm__c = dwh.LG_AttributeContractTerm__c;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ProductName__c = priceItemId;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_SLA__c = dwh.LG_AttributeSLA__c;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_MarketSegment__c = attributeDefinitionHardCodedValueMap.get(pd_ConnectMKBInternet + '_' + 'Market Segment');
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Capability__c = attributeDefinitionHardCodedValueMap.get(pd_ConnectMKBInternet + '_' + 'Capability');
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ExternalSubscriptionName__c = attributeDefinitionHardCodedValueMap.get(pd_ConnectMKBInternet + '_' + 'External Subscription Name');
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ProductFamily__c = attributeDefinitionHardCodedValueMap.get(pd_ConnectMKBInternet + '_' + 'Product Family');
                                
                                if(productDefinitionRelatedProductAttDefNameMap.get(pd_ConnectMKBInternet+'_Pin') != null){
                                    relatedProductAttributeDefinitionName_Pin = productDefinitionRelatedProductAttDefNameMap.get(pd_ConnectMKBInternet+'_Pin');
                                }
                                if(productDefinitionRelatedProductAttDefNameMap.get(pd_ConnectMKBInternet+'_Discount') != null){
                                    relatedProductAttributeDefinitionName_Discount = productDefinitionRelatedProductAttDefNameMap.get(pd_ConnectMKBInternet+'_Discount');
                                }
                                
                                string relatedProductAttributeDefinitionName_SLA = '';
                                if(productDefinitionRelatedProductAttDefNameMap.get(pd_ConnectMKBInternet+'_SLA') != null){
                                    relatedProductAttributeDefinitionName_SLA = productDefinitionRelatedProductAttDefNameMap.get(pd_ConnectMKBInternet+'_SLA');
                                }
                                
                                if(productDefinitionProductNameAttDefNameMap.get(pd_ConnectMKBInternet) != null){
                                    productNameAttributeDefinitionName = productDefinitionProductNameAttDefNameMap.get(pd_ConnectMKBInternet);
                                }
                                string secondLevelProductsKey = '1_' + pd_Pin + pd_ConnectMKBInternet;
                                if(productConfigHierarchyMap.containsKey(secondLevelProductsKey)){
                                    commaSeperatedIds = createCommaSeperatedStringForProductConfigIds(productConfigHierarchyMap.get(secondLevelProductsKey));
                                }
                                system.debug('### commaSeperatedIds for Connect MKB: ' + commaSeperatedIds);
                                attributeInsertList.addAll(createAttributeListForProductDefinition(pd_ConnectMKBInternet, prodConfigId));
                                for(cscfga__Attribute__c att: attributeInsertList){
                                    if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == relatedProductAttributeDefinitionName_Pin){
                                        att.cscfga__Value__c = commaSeperatedIds;
                                        if(att.cscfga__Value__c != ''){
                                            att.cscfga__Display_Value__c = pd_Pin;
                                        }
                                    }
                                    if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == relatedProductAttributeDefinitionName_Discount){
                                        att.cscfga__Value__c = discountId;
                                        att.cscfga__Display_Value__c = dwh.LG_AttributeDiscount__c;
                                    }
                                    
                                    if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == relatedProductAttributeDefinitionName_SLA){
                                        att.cscfga__Value__c = addOnPriceItemIdForSLA;
                                        att.cscfga__Display_Value__c = addOnPriceItemNameMap.get(keyForSLA);
                                    }
                                    
                                    if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == productNameAttributeDefinitionName){
                                        att.cscfga__Value__c = priceItemId;
                                        att.cscfga__Display_Value__c = productName;
                                    }
                                    if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == premiseIdAttribute){
                                        att.cscfga__Value__c = serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Address__c;
                                        att.cscfga__Display_Value__c = serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Address__c;
                                    }
                                }
                            }
                            
                            else if(listOfPinProducts.contains(productName)){
                                system.debug('### Pin ');
                                
                                typeForServiceLineItem = 'Add On';
                                string addOnPriceItemId = '';
                                if(productDefinitionProductNameAttDefNameMap.get(pd_Pin) != null){
                                    productNameAttributeDefinitionName = productDefinitionProductNameAttDefNameMap.get(pd_Pin);
                                }
                                if(prodConfigExternalIdAndIdMap.get(dwh.LG_AttributeServiceExternalId__c) != null){
                                    prodConfigId = prodConfigExternalIdAndIdMap.get(dwh.LG_AttributeServiceExternalId__c);     
                                }
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ProductFamily__c = pc_RelatedProduct;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ContractTerm__c = dwh.LG_AttributeContractTerm__c;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Capability__c = attributeDefinitionHardCodedValueMap.get(pd_Pin + '_' + 'Capability');
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ExternalSubscriptionName__c = attributeDefinitionHardCodedValueMap.get(pd_Pin + '_' + 'External Subscription Name');
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ProductFamily__c = attributeDefinitionHardCodedValueMap.get(pd_Pin + '_' + 'Product Family');
                                
                                if(addOnPriceItemIdMap.get(pd_Pin) != null){
                                    addOnPriceItemId = addOnPriceItemIdMap.get(pd_Pin);
                                }
                                system.debug('### addOnPriceItemId: ' + addOnPriceItemId);
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_AddOn__c = addOnPriceItemId;
                                attributeInsertList.addAll(createAttributeListForProductDefinition(pd_Pin, prodConfigId));
                                for(cscfga__Attribute__c att: attributeInsertList){
                                    if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == productNameAttributeDefinitionName){
                                        att.cscfga__Value__c = addOnPriceItemId;
                                        att.cscfga__Display_Value__c = productName;
                                    }
                                    if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == premiseIdAttribute){
                                        att.cscfga__Value__c = serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Address__c;
                                        att.cscfga__Display_Value__c = serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Address__c;
                                    }
                                }
                            }
                            
                            else if(listOfMultiWifiProducts.contains(productName)){
                                system.debug('### Multi Wifi ');
                                
                                typeForServiceLineItem = 'Product';
                                if(prodConfigExternalIdAndIdMap.get(dwh.LG_AttributeServiceExternalId__c) != null){
                                    prodConfigId = prodConfigExternalIdAndIdMap.get(dwh.LG_AttributeServiceExternalId__c);     
                                }
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ProductFamily__c = pc_Internet;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ContractTerm__c = dwh.LG_AttributeContractTerm__c;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_MarketSegment__c = attributeDefinitionHardCodedValueMap.get(pd_MultiWifi + '_' + 'Market Segment');
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_MultiWifiAccessPoint__c = attributeDefinitionHardCodedValueMap.get(pd_MultiWifi + '_' + 'Multi WiFi Access Point');
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ExternalSubscriptionName__c = attributeDefinitionHardCodedValueMap.get(pd_MultiWifi + '_' + 'External Subscription Name');
                                
                                if(productDefinitionRelatedProductAttDefNameMap.get(pd_MultiWifi) != null){
                                  relatedProductAttributeDefinitionName = productDefinitionRelatedProductAttDefNameMap.get(pd_MultiWifi);
                                }
                                string secondLevelProductsKey = '1_' + pd_WiFiAccessPoint;
                                if(productConfigHierarchyMap.containsKey(secondLevelProductsKey)){
                                  commaSeperatedIds = createCommaSeperatedStringForProductConfigIds(productConfigHierarchyMap.get(secondLevelProductsKey));
                                }
                                system.debug('### commaSeperatedIds for Multi Wifi: ' + commaSeperatedIds);
                                attributeInsertList.addAll(createAttributeListForProductDefinition(pd_MultiWifi, prodConfigId));
                                for(cscfga__Attribute__c att: attributeInsertList){
                                  if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == relatedProductAttributeDefinitionName){
                                        att.cscfga__Value__c = commaSeperatedIds;
                                        if(att.cscfga__Value__c != ''){
                                                att.cscfga__Display_Value__c = pd_WiFiAccessPoint;
                                        }
                                  }
                                  if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == premiseIdAttribute){
                                        att.cscfga__Value__c = serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Address__c;
                                        att.cscfga__Display_Value__c = serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Address__c;
                                    }
                                }
                            }
                            
                            else if(listOfMiltiWifiAccessPointProducts.contains(productName)){
                                system.debug('### Wifi Access Point');
                                
                                typeForServiceLineItem = 'Add On';
                                string addOnPriceItemId = '';
                                string multiWifiType = productNameDisplayValueMap.get(productName).toLowerCase();
                                string uniqueString = dwh.LG_AttributeContractTerm__c + '_' + multiWifiType;
                                
                                if(productDefinitionProductNameAttDefNameMap.get(pd_WiFiAccessPoint) != null){
                                    productNameAttributeDefinitionName = productDefinitionProductNameAttDefNameMap.get(pd_WiFiAccessPoint);
                                }
                                if(prodConfigExternalIdAndIdMap.get(dwh.LG_AttributeServiceExternalId__c) != null){
                                    prodConfigId = prodConfigExternalIdAndIdMap.get(dwh.LG_AttributeServiceExternalId__c);     
                                }
                                if(addOnPriceItemIdMap.get(uniqueString) != null){
                                    addOnPriceItemId = addOnPriceItemIdMap.get(uniqueString);      
                                }
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ProductFamily__c = pc_RelatedProduct;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ContractTerm__c = dwh.LG_AttributeContractTerm__c;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_AddOn__c = addOnPriceItemId;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Quantity__c = decimal.ValueOf(attributeDefinitionHardCodedValueMap.get(pd_WiFiAccessPoint + '_' + 'Quantity'));
                                attributeInsertList.addAll(createAttributeListForProductDefinition(pd_WiFiAccessPoint, prodConfigId));
                                for(cscfga__Attribute__c att: attributeInsertList){
                                  if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == productNameAttributeDefinitionName){
                                    att.cscfga__Value__c = addOnPriceItemId;
                                    att.cscfga__Display_Value__c = productNameDisplayValueMap.get(productName);
                                  }
                                  if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == premiseIdAttribute){
                                        att.cscfga__Value__c = serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Address__c;
                                        att.cscfga__Display_Value__c = serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Address__c;
                                    }
                                }
                            }
                            
                            else if(listOfTelephonyProducts.contains(productName)){
                                system.debug('### Telephony');
                                
                                typeForServiceLineItem = 'Product';
                                if(prodConfigExternalIdAndIdMap.get(dwh.LG_AttributeServiceExternalId__c) != null){
                                    prodConfigId = prodConfigExternalIdAndIdMap.get(dwh.LG_AttributeServiceExternalId__c);     
                                }
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ContractTerm__c = dwh.LG_AttributeContractTerm__c;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_InstallationType__c = dwh.LG_AttributeInstallationType__c;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_MarketSegment__c = attributeDefinitionHardCodedValueMap.get(pd_Telephony + '_' + 'Market Segment');
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Capability__c = attributeDefinitionHardCodedValueMap.get(pd_Telephony + '_' + 'Capability');
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_TypeTelephony__c = attributeDefinitionHardCodedValueMap.get(pd_Telephony + '_' + 'Type');
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_NameTelephony__c = attributeDefinitionHardCodedValueMap.get(pd_Telephony + '_' + 'Name');
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ProductFamily__c = attributeDefinitionHardCodedValueMap.get(pd_Telephony + '_' + 'Product Family');
                                if(priceItemIdForMKBTelephony != null){
                                    serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ProductName__c = priceItemIdForMKBTelephony;
                                }
                                if(productDefinitionRelatedProductAttDefNameMap.get(pd_Telephony) != null){
                                  relatedProductAttributeDefinitionName = productDefinitionRelatedProductAttDefNameMap.get(pd_Telephony);
                                }
                                string secondLevelProductsKey = '1_' + pd_PhoneNumbers;
                                if(productConfigHierarchyMap.containsKey(secondLevelProductsKey)){
                                  commaSeperatedIds = createCommaSeperatedStringForProductConfigIds(productConfigHierarchyMap.get(secondLevelProductsKey));
                                }
                                system.debug('### commaSeperatedIds for Telephony: ' + commaSeperatedIds);
                                attributeInsertList.addAll(createAttributeListForProductDefinition(pd_Telephony, prodConfigId));
                                for(cscfga__Attribute__c att: attributeInsertList){
                                  if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == relatedProductAttributeDefinitionName){
                                    att.cscfga__Value__c = commaSeperatedIds;
                                    if(att.cscfga__Value__c != ''){
                                        att.cscfga__Display_Value__c = pd_PhoneNumbers;
                                    }
                                  }
                                  if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == premiseIdAttribute){
                                        att.cscfga__Value__c = serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Address__c;
                                        att.cscfga__Display_Value__c = serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Address__c;
                                    }
                                }
                            }
                            
                            else if(listOfPhoneNumberProducts.contains(productName)){
                                system.debug('### Phone Numbers');
                                
                                typeForServiceLineItem = 'Add On';
                                string addOnPriceItemId = '';
                                if(productDefinitionProductNameAttDefNameMap.get(pd_PhoneNumbers) != null){
                                    productNameAttributeDefinitionName = productDefinitionProductNameAttDefNameMap.get(pd_PhoneNumbers);
                                }
                                if(prodConfigExternalIdAndIdMap.get(dwh.LG_AttributeServiceExternalId__c) != null){
                                    prodConfigId = prodConfigExternalIdAndIdMap.get(dwh.LG_AttributeServiceExternalId__c);     
                                }
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Quantity__c = decimal.ValueOf(attributeDefinitionHardCodedValueMap.get(pd_PhoneNumbers + '_' + 'Quantity'));
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_CallBarringLevel__c = dwh.LG_AttributeCallBarringLevel__c;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_BNumberShielding__c = dwh.LG_AttributeBNumberShielding__c;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_CallerID__c = dwh.LG_AttributeCallerID__c;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_TypeOfPhoneRange__c = dwh.LG_AttributeTypeOfPhoneRange__c;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_AreaCodes__c = dwh.LG_AttributeAreaCode__c;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Phonenumbers__c = dwh.LG_AttributePhoneNumbers__c;
                                string uniqueString;
                                string blockType = productNameDisplayValueMap.get(productName);
                                string typeOfPhoneRange = '';
                                if(dwh.LG_AttributeAreaCode__c == '088'){
                                    typeOfPhoneRange = '088';
                                }
                                else{
                                    typeOfPhoneRange = productNameAdditionalDisplayValueMap.get(productName).toLowerCase();
                                }
                                
                                if(productName.containsIgnoreCase('Legacy')){
                                    uniqueString = blockType + '_' + typeOfPhoneRange + '_' + 'LegacyTrue';
                                }
                                else{
                                    uniqueString = blockType + '_' + typeOfPhoneRange + '_' + 'LegacyFalse';
                                }
                                if(addOnPriceItemIdMap.get(uniqueString) != null){
                                    addOnPriceItemId = addOnPriceItemIdMap.get(uniqueString);      
                                }
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_AddOn__c = addOnPriceItemId;
                                attributeInsertList.addAll(createAttributeListForProductDefinition(pd_PhoneNumbers, prodConfigId));
                                for(cscfga__Attribute__c att: attributeInsertList){
                                  if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == productNameAttributeDefinitionName){
                                    att.cscfga__Value__c = addOnPriceItemId;
                                    att.cscfga__Display_Value__c = dwh.LG_AttributeBlockType__c + '-nummerblok';
                                  }
                                  if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == premiseIdAttribute){
                                      att.cscfga__Value__c = serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Address__c;
                                      att.cscfga__Display_Value__c = serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Address__c;
                                  }
                                }
                            }
                            
                            else if(listOfInternetPlusProducts.contains(productName)){
                                system.debug('### Internet Plus');
                                
                                typeForServiceLineItem = 'Product';
                                if(prodConfigExternalIdAndIdMap.get(dwh.LG_AttributeServiceExternalId__c) != null){
                                    prodConfigId = prodConfigExternalIdAndIdMap.get(dwh.LG_AttributeServiceExternalId__c);     
                                }
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ProductFamily__c = pc_Internet;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_IPAddressExtensionLegacy__c = dwh.LG_AttributeIPAddressExtension__c;
                                if(dwh.LG_AttributeInternetSecurity__c != null){
                                    serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_InternetSecurityLegacy__c = dwh.LG_AttributeInternetSecurity__c;
                                }
                                else if(quantityForInternetSecurityForInternetPlus != null){
                                    serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_InternetSecurityLegacy__c = quantityForInternetSecurityForInternetPlus;
                                }
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ProductFamily__c = attributeDefinitionHardCodedValueMap.get(pd_InternetPlus + '_' + 'Product Family');
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_MarketSegment__c = attributeDefinitionHardCodedValueMap.get(pd_InternetPlus + '_' + 'Market Segment');
                                
                                string internetType = '';
                                if(productNameDisplayValueMap.get(productName) !=  null){
                                    internetType = productNameDisplayValueMap.get(productName);
                                }
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_InternetTypeLegacy__c = internetType;
                                
                                if(productDefinitionRelatedProductAttDefNameMap.get(pd_InternetPlus+'_Telephony') != null){
                                  relatedProductAttributeDefinitionName_Telephony = productDefinitionRelatedProductAttDefNameMap.get(pd_InternetPlus+'_Telephony');
                                }
                                if(productDefinitionRelatedProductAttDefNameMap.get(pd_InternetPlus+'_Pin') != null){
                                  relatedProductAttributeDefinitionName_Pin = productDefinitionRelatedProductAttDefNameMap.get(pd_InternetPlus+'_Pin');
                                }
                                string commaSeperatedIdsForTelephony = '';
                                string commaSeperatedIdsForPin = '';
                                
                                string secondLevelProductsKeyForTelephony = '1_' + pd_TelephonyPlus;
                                if(productConfigHierarchyMap.containsKey(secondLevelProductsKeyForTelephony)){
                                  commaSeperatedIdsForTelephony = createCommaSeperatedStringForProductConfigIds(productConfigHierarchyMap.get(secondLevelProductsKeyForTelephony));
                                }
                                system.debug('### commaSeperatedIds for InternetPlus Telephony: ' + commaSeperatedIdsForTelephony);
                                string secondLevelProductsKeyForPin = '1_' + pd_Pin + pd_InternetPlus;
                                if(productConfigHierarchyMap.containsKey(secondLevelProductsKeyForPin)){
                                  commaSeperatedIdsForPin = createCommaSeperatedStringForProductConfigIds(productConfigHierarchyMap.get(secondLevelProductsKeyForPin));
                                }
                                system.debug('### commaSeperatedIds for InternetPlus Pin: ' + commaSeperatedIdsForPin);
                                
                                attributeInsertList.addAll(createAttributeListForProductDefinition(pd_InternetPlus, prodConfigId));
                                for(cscfga__Attribute__c att: attributeInsertList){
                                  if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == relatedProductAttributeDefinitionName_Telephony){
                                    att.cscfga__Value__c = commaSeperatedIdsForTelephony;
                                    if(att.cscfga__Value__c != ''){
                                        att.cscfga__Display_Value__c = pd_TelephonyPlus;
                                    }
                                  }
                                  if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == relatedProductAttributeDefinitionName_Pin){
                                    att.cscfga__Value__c = commaSeperatedIdsForPin;
                                    if(att.cscfga__Value__c != ''){
                                        att.cscfga__Display_Value__c = pd_Pin;
                                    }
                                  }
                                  if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == premiseIdAttribute){
                                      att.cscfga__Value__c = serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Address__c;
                                      att.cscfga__Display_Value__c = serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Address__c;
                                  }
                                  if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == mapForHardCodedValues.get('LG_InternetSecurity_CableAccess')){
                                      att.cscfga__Value__c = attributeDefinitionHardCodedValueMap.get(pd_InternetPlus + '_' + 'Cable Access');
                                      att.cscfga__Display_Value__c = attributeDefinitionHardCodedValueMap.get(pd_InternetPlus + '_' + 'Cable Access');
                                  }
                                }   
                            }
                            
                            else if(listOfTelephonyPlusProducts.contains(productName)){
                                system.debug('### Telephony Plus');
                                
                                typeForServiceLineItem = 'Add On';
                                if(prodConfigExternalIdAndIdMap.get(dwh.LG_AttributeServiceExternalId__c) != null){
                                    prodConfigId = prodConfigExternalIdAndIdMap.get(dwh.LG_AttributeServiceExternalId__c);     
                                }
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_TelephonyPlusTypeLegacy__c = productName;
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_ProductFamily__c = attributeDefinitionHardCodedValueMap.get(pd_TelephonyPlus + '_' + 'Product Family');
                                if(productDefinitionRelatedProductAttDefNameMap.get(pd_TelephonyPlus) != null){
                                  relatedProductAttributeDefinitionName = productDefinitionRelatedProductAttDefNameMap.get(pd_TelephonyPlus);
                                }
                                string thirdLevelProductsKey = '2_' + pd_PhoneNumbers;
                                if(productConfigHierarchyMap.containsKey(thirdLevelProductsKey)){
                                  commaSeperatedIds = createCommaSeperatedStringForProductConfigIds(productConfigHierarchyMap.get(thirdLevelProductsKey));
                                }
                                system.debug('### commaSeperatedIds for Telephonie Plus: ' + commaSeperatedIds);
                                attributeInsertList.addAll(createAttributeListForProductDefinition(pd_TelephonyPlus, prodConfigId));
                                for(cscfga__Attribute__c att: attributeInsertList){
                                  if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == relatedProductAttributeDefinitionName){
                                    att.cscfga__Value__c = commaSeperatedIds;
                                    if(att.cscfga__Value__c != ''){
                                        att.cscfga__Display_Value__c = pd_PhoneNumbers;
                                    }
                                  }
                                  if(att.cscfga__Product_Configuration__c == prodConfigId && att.Name == premiseIdAttribute){
                                      att.cscfga__Value__c = serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Address__c;
                                      att.cscfga__Display_Value__c = serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_Address__c;
                                  }
                                }
                            }
                            
                            else if(listOfZiggoBreedbandProducts.contains(productName)){
                                system.debug('### Ziggo Breedband');
                                typeForServiceLineItem = 'Product';
                                serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c).LG_MarketSegment__c = attributeDefinitionHardCodedValueMap.get(pd_ZiggoBreedband + '_' + 'Market Segment');
                            }
                            
                            serviceInsertList.add(serviceRecordMap.get(dwh.LG_AttributeServiceExternalId__c));
                            
                            //Code for initializing sli insert... 
                            if(dwh.LG_AttributeOneOffCharge__c != null){
                                csord__Service_Line_Item__c sli1 = new csord__Service_Line_Item__c();
                                sli1.Name = productNameForServiceLineItem;
                                sli1.LG_ExternalServiceName__c = productNameForServiceLineItem;
                                sli1.csord__Total_Price__c = dwh.LG_AttributeOneOffCharge__c;
                                sli1.csord__Is_Recurring__c = False;
                                sli1.csord__Order_Request__c = orderRequestId;
                                sli1.csord__Identification__c = orderRequestId;
                                sli1.csord__Line_Description__c = dwh.LG_AttributeServiceExternalId__c;
                                sli1.LG_ToBeSent__c  = 'True';
                                sli1.LG_Type__c = typeForServiceLineItem;
                                if(billingAccountExternalIdBillingAccountIdMap.get(dwh.LG_AttributeBillingAccount__c) != null){
                                    sli1.LG_BillingAccount__c = billingAccountExternalIdBillingAccountIdMap.get(dwh.LG_AttributeBillingAccount__c);
                                }
                                sliInsertList.add(sli1);
                            }
                            if(dwh.LG_AttributeRecurringCharge__c != null){
                                csord__Service_Line_Item__c sli2 = new csord__Service_Line_Item__c();
                                sli2.Name = productNameForServiceLineItem;
                                sli2.LG_ExternalServiceName__c = productNameForServiceLineItem;
                                sli2.csord__Total_Price__c = dwh.LG_AttributeRecurringCharge__c;
                                sli2.csord__Is_Recurring__c = True;
                                sli2.csord__Order_Request__c = orderRequestId;
                                sli2.csord__Identification__c = orderRequestId;
                                sli2.csord__Line_Description__c = dwh.LG_AttributeServiceExternalId__c;
                                sli2.LG_ToBeSent__c  = 'True';
                                sli2.LG_Type__c = typeForServiceLineItem;
                                if(billingAccountExternalIdBillingAccountIdMap.get(dwh.LG_AttributeBillingAccount__c) != null){
                                    sli2.LG_BillingAccount__c = billingAccountExternalIdBillingAccountIdMap.get(dwh.LG_AttributeBillingAccount__c);
                                }
                                sliInsertList.add(sli2);
                            }
                        }
                    
                    
                    }
                 }
                
                if(attributeInsertList.size() > 0){
                    insert attributeInsertList;
                }
                
                if(serviceInsertList.size() > 0){
                    insert serviceInsertList;
                }
                
                Map<String, String> serviceMap = new Map<String, String>();
                for(csord__Service__c service: serviceInsertList){
                    serviceMap.put(service.LG_ServiceExternalId__c, service.Id);
                }

                for(csord__Service_Line_Item__c sli: sliinsertlist){
                    sli.csord__Service__c = servicemap.get(sli.csord__Line_Description__c);
                }
                insert sliInsertList;                
            }
        
        }      
        
    }
    
    /*
        Name: createMapFromFeedRecords
        Purpose: to create a map of DWH feed records from the staging table 
        Argument: none
        Return type: map<string, List<map<string, List<LG_DWHFeedStagingTable__c>> > >
    */
    
    /*
    public map<string, List<map<string, List<LG_DWHFeedStagingTable__c>> > > createMapFromFeedRecords(){
        
        
        createQueries('LG_DWHFeedStagingTable__c');
        List<LG_DWHFeedStagingTable__c> dwhRecordsFetchedForAccount = new List<LG_DWHFeedStagingTable__c>();
        List<LG_DWHFeedStagingTable__c> dwhRecordsFetchedForContact = new List<LG_DWHFeedStagingTable__c>();
        List<LG_DWHFeedStagingTable__c> dwhRecordsFetchedForSubscription = new List<LG_DWHFeedStagingTable__c>();
        List<LG_DWHFeedStagingTable__c> dwhRecordsFetchedForService = new List<LG_DWHFeedStagingTable__c>();
        List<LG_DWHFeedStagingTable__c> dwhRecordsFetchedForPremise = new List<LG_DWHFeedStagingTable__c>();
        List<LG_DWHFeedStagingTable__c> dwhRecordsFetchedForBillingAccount = new List<LG_DWHFeedStagingTable__c>();
        List<LG_DWHFeedStagingTable__c> dwhRecordsFetchedForAttribute = new List<LG_DWHFeedStagingTable__c>();
        List<LG_DWHFeedStagingTable__c> dwhRecordsFetchedForContract = new List<LG_DWHFeedStagingTable__c>();
        
        dwhRecordsFetchedForAccount = Database.query(soqlQueryForAccount);

        feedMap = new map<string, List<map<string, List<LG_DWHFeedStagingTable__c>>> >();
        list<LG_DWHFeedStagingTable__c> feedListTemp = new list<LG_DWHFeedStagingTable__c>();
        map<string, List<LG_DWHFeedStagingTable__c>> feedMapTemp = new map<string, List<LG_DWHFeedStagingTable__c>>();
        List<map<string, List<LG_DWHFeedStagingTable__c>>> feedMapTempList;
        
        set<string> uniqueIdSet = new set<string>();
        set<string> accountExternalIdSet = new set<string>();
        set<string> customAccountNumberSet = new set<string>();
        set<string> chamberOfCommerceNumberSet = new set<string>();
        map<string, string> uniqueIdAccountExternalIdMap = new map<string, string>();
        map<string, string> uniqueIdAccountCustomAccountNumberMap = new map<string, string>();
        map<string, string> uniqueIdAccountChamberOfCommerceNumberMap = new map<string, string>();
        
        //********** create Feed Map for Account DWH records       
        for(LG_DWHFeedStagingTable__c accountfeed: dwhRecordsFetchedForAccount){
            
            string uniqueId = accountfeed.LG_TransactionIdAccountId__c;
            uniqueIdSet.add(uniqueId);
            if(accountfeed.LG_AccountExternalId__c != null && accountfeed.LG_AccountExternalId__c != ''){
                accountExternalIdSet.add(accountfeed.LG_AccountExternalId__c);
                uniqueIdAccountExternalIdMap.put(uniqueId, accountfeed.LG_AccountExternalId__c);
            }
            if(accountfeed.LG_AccountNumber__c != null && accountfeed.LG_AccountNumber__c != ''){
                customAccountNumberSet.add(accountfeed.LG_AccountNumber__c);
                uniqueIdAccountCustomAccountNumberMap.put(uniqueId, accountfeed.LG_AccountNumber__c);
            }  
            if(accountfeed.LG_AccountChamberOfCommerceNumber__c != null && accountfeed.LG_AccountChamberOfCommerceNumber__c != ''){
                chamberOfCommerceNumberSet.add(accountfeed.LG_AccountChamberOfCommerceNumber__c);
                uniqueIdAccountChamberOfCommerceNumberMap.put(uniqueId, accountfeed.LG_AccountChamberOfCommerceNumber__c);
            }
            feedListTemp = new list<LG_DWHFeedStagingTable__c>();
            feedMapTemp = new map<string, List<LG_DWHFeedStagingTable__c>>();
            
            feedListTemp.add(accountfeed);
            feedMapTemp.put('Account', feedListTemp);
            
            if(feedMap.containsKey(uniqueId)){ 
               feedMap.get(uniqueId).add(feedMapTemp);
               }
             else{
               feedMap.put(uniqueId,new List<map<string, List<LG_DWHFeedStagingTable__c>>>{feedMapTemp});
            }
        }
        
        soqlQueryForContact+= ' AND LG_AccountExternalId__c IN: accountExternalIdSet';
        soqlQueryForSubscription+= ' AND LG_AccountExternalId__c IN: accountExternalIdSet';
        soqlQueryForService+= ' AND LG_AccountExternalId__c IN: accountExternalIdSet';
        soqlQueryForPremise+= ' AND LG_AccountExternalId__c IN: accountExternalIdSet';
        soqlQueryForBillingAccount+= ' AND LG_AccountExternalId__c IN: accountExternalIdSet';
        soqlQueryForAttribute+= ' AND LG_AccountExternalId__c IN: accountExternalIdSet';
        soqlQueryForContract+= ' AND LG_AccountExternalId__c IN: accountExternalIdSet';
        
        dwhRecordsFetchedForContact = Database.query(soqlQueryForContact);
        dwhRecordsFetchedForSubscription = Database.query(soqlQueryForSubscription);
        dwhRecordsFetchedForService = Database.query(soqlQueryForService);
        dwhRecordsFetchedForPremise = Database.query(soqlQueryForPremise);
        dwhRecordsFetchedForBillingAccount = Database.query(soqlQueryForBillingAccount);
        dwhRecordsFetchedForAttribute = Database.query(soqlQueryForAttribute);
        dwhRecordsFetchedForContract = Database.query(soqlQueryForContract);
        
        //********** create Feed Map for Contact DWH records 
        feedMapTemp = new map<string, List<LG_DWHFeedStagingTable__c>>();
        contactExternalIdList = new Set<string>();
        for(LG_DWHFeedStagingTable__c contactfeed: dwhRecordsFetchedForContact){
            
            string uniqueId = contactfeed.LG_TransactionIdAccountId__c;
            if(contactfeed.LG_ContactExternalID__c != null && contactfeed.LG_ContactExternalID__c != ''){
                contactExternalIdList.add(contactfeed.LG_ContactExternalID__c);
            }
            
            feedMapTempList = new List<map<string, List<LG_DWHFeedStagingTable__c>>>();
            if(feedMap.containsKey(uniqueId)){
                feedMapTempList = feedMap.get(uniqueId);
            }
            for(map<string, List<LG_DWHFeedStagingTable__c>> internalMap: feedMapTempList){
                if(internalMap.containsKey('Contact')){
                    feedMapTemp = internalMap;
                }
            }
            
            if(feedMapTemp.containsKey('Contact') && feedMapTemp.get('Contact')[0].LG_TransactionIdAccountId__c == uniqueId){
                feedMapTemp.get('Contact').add(contactfeed);
            }
            else{
                feedMapTemp = new map<string, List<LG_DWHFeedStagingTable__c>>();
                feedMapTemp.put('Contact', new List<LG_DWHFeedStagingTable__c> {contactfeed});
            }
            
            boolean contactFound = false;
            if(feedMap.containsKey(uniqueId)){ 
               for(map<string, List<LG_DWHFeedStagingTable__c>> internalMap: feedMap.get(uniqueId)){
                    if(internalMap.containsKey('Contact')){
                        internalMap = feedMapTemp;
                        contactFound = true;
                    }
                }
                if(contactFound == false){
                    feedMap.get(uniqueId).add(feedMapTemp);
                }
             }
             else{
               feedMap.put(uniqueId,new List<map<string, List<LG_DWHFeedStagingTable__c>>>{feedMapTemp});
            }
            
        }
        
        
        //********** create Feed Map for Subscription DWH records 
        feedMapTemp = new map<string, List<LG_DWHFeedStagingTable__c>>();
        map<string, string> subscriptionNumberUniqueIdMap = new map<string, string>();
        set<string> subscriptionNumberSet = new set<string>();
        for(LG_DWHFeedStagingTable__c subscriptionfeed: dwhRecordsFetchedForSubscription){
            
            string uniqueId = subscriptionfeed.LG_TransactionIdAccountId__c;
            
            if(subscriptionfeed.LG_SubscriptionNumber__c != ''){
                subscriptionNumberUniqueIdMap.put(subscriptionfeed.LG_SubscriptionNumber__c, uniqueId);
                subscriptionNumberSet.add(subscriptionfeed.LG_SubscriptionNumber__c);
            }
            
            feedMapTempList = new List<map<string, List<LG_DWHFeedStagingTable__c>>>();
            if(feedMap.containsKey(uniqueId)){
                feedMapTempList = feedMap.get(uniqueId);
            }
            for(map<string, List<LG_DWHFeedStagingTable__c>> internalMap: feedMapTempList){
                if(internalMap.containsKey('Subscription')){
                    feedMapTemp = internalMap;
                }
            }
            if(feedMapTemp.containsKey('Subscription') && feedMapTemp.get('Subscription')[0].LG_TransactionIdAccountId__c == uniqueId){
                feedMapTemp.get('Subscription').add(subscriptionfeed);
            }
            else{
                feedMapTemp = new map<string, List<LG_DWHFeedStagingTable__c>>();
                feedMapTemp.put('Subscription', new List<LG_DWHFeedStagingTable__c> {subscriptionfeed});
            }
            
            boolean subscriptionFound = false;
            if(feedMap.containsKey(uniqueId)){ 
                for(map<string, List<LG_DWHFeedStagingTable__c>> internalMap: feedMap.get(uniqueId)){
                    if(internalMap.containsKey('Subscription')){
                        internalMap = feedMapTemp;
                        subscriptionFound = true;
                    }
                }
                if(subscriptionFound == false){
                    feedMap.get(uniqueId).add(feedMapTemp);
                }
            }
             else{
               feedMap.put(uniqueId,new List<map<string, List<LG_DWHFeedStagingTable__c>>>{feedMapTemp});
            }
            
        }
        
        //********** create Feed Map for Service DWH records 
        feedMapTemp = new map<string, List<LG_DWHFeedStagingTable__c>>();
        map<string, string> serviceNumberUniqueIdMap = new map<string, string>();
        set<string> serviceNumberSet = new set<string>();
        for(LG_DWHFeedStagingTable__c servicefeed: dwhRecordsFetchedForService){
            
            string uniqueId = servicefeed.LG_TransactionIdAccountId__c;
            
            if(servicefeed.LG_ServiceNumber__c != ''){
                serviceNumberUniqueIdMap.put(servicefeed.LG_ServiceNumber__c, uniqueId);
                serviceNumberSet.add(servicefeed.LG_ServiceNumber__c);
            }
            
            feedMapTempList = new List<map<string, List<LG_DWHFeedStagingTable__c>>>();
            if(feedMap.containsKey(uniqueId)){
                feedMapTempList = feedMap.get(uniqueId);
            }
            for(map<string, List<LG_DWHFeedStagingTable__c>> internalMap: feedMapTempList){
                if(internalMap.containsKey('Service')){
                    feedMapTemp = internalMap;
                }
            }
            
            if(feedMapTemp.containsKey('Service') && feedMapTemp.get('Service')[0].LG_TransactionIdAccountId__c == uniqueId){
                feedMapTemp.get('Service').add(servicefeed);
            }
            else{
                feedMapTemp = new map<string, List<LG_DWHFeedStagingTable__c>>();
                feedMapTemp.put('Service', new List<LG_DWHFeedStagingTable__c> {servicefeed});
            }
            
            boolean serviceFound = false;
            if(feedMap.containsKey(uniqueId)){ 
               for(map<string, List<LG_DWHFeedStagingTable__c>> internalMap: feedMap.get(uniqueId)){
                    if(internalMap.containsKey('Service')){
                        internalMap = feedMapTemp;
                        serviceFound = true;
                    }
                }
                if(serviceFound  == false){
                    feedMap.get(uniqueId).add(feedMapTemp);
                }
               }
             else{
               feedMap.put(uniqueId,new List<map<string, List<LG_DWHFeedStagingTable__c>>>{feedMapTemp});
            }
        }
        
        //********** create Feed Map for Premise DWH records 
        List<string> houseNumberList = new List<string>();
        List<string> houseNumberExtList = new List<string>();
        List<string> postalCodeList = new List<string>();
        
        feedMapTemp = new map<string, List<LG_DWHFeedStagingTable__c>>();
        for(LG_DWHFeedStagingTable__c premisefeed: dwhRecordsFetchedForPremise){
            
            string uniqueId = premisefeed.LG_TransactionIdAccountId__c;
            if(premisefeed.LG_PremiseTechnicalContact__c != null && premisefeed.LG_PremiseTechnicalContact__c != ''){
                contactExternalIdList.add(premisefeed.LG_PremiseTechnicalContact__c);
            }
            
            feedMapTempList = new List<map<string, List<LG_DWHFeedStagingTable__c>>>();
            if(feedMap.containsKey(uniqueId)){
                feedMapTempList = feedMap.get(uniqueId);
            }
            for(map<string, List<LG_DWHFeedStagingTable__c>> internalMap: feedMapTempList){
                if(internalMap.containsKey('Premise')){
                    feedMapTemp = internalMap;
                }
            }
            
            if(feedMapTemp.containsKey('Premise') && feedMapTemp.get('Premise')[0].LG_TransactionIdAccountId__c == uniqueId){
                feedMapTemp.get('Premise').add(premisefeed);
            }
            else{
                feedMapTemp = new map<string, List<LG_DWHFeedStagingTable__c>>();
                feedMapTemp.put('Premise', new List<LG_DWHFeedStagingTable__c> {premisefeed});
            }
            
            boolean premiseFound = false;
            if(feedMap.containsKey(uniqueId)){ 
               for(map<string, List<LG_DWHFeedStagingTable__c>> internalMap: feedMap.get(uniqueId)){
                    if(internalMap.containsKey('Premise')){
                        internalMap = feedMapTemp;
                        premiseFound = true;
                    }
                }
                if(premiseFound == false){
                    feedMap.get(uniqueId).add(feedMapTemp);
                }
            }
             else{
               feedMap.put(uniqueId,new List<map<string, List<LG_DWHFeedStagingTable__c>>>{feedMapTemp});
            }
            
            houseNumberList.add(premisefeed.LG_PremiseHouseNumber__c);
            houseNumberExtList.add(premisefeed.LG_PremiseHouseNumberExtension__c);
            postalCodeList.add(premisefeed.LG_PremisePostalCode__c);
        }
        
        existingPremiseMap = new map<string, cscrm__Address__c>();
        for(cscrm__Address__c pre: [Select Id, Name, cscrm__Account__c, cscrm__Country__c, LG_Footprint__c, LG_DWHExternalID__c, cscrm__External_ID__c, 
                                      LG_HouseNumber__c, LG_HouseNumberExtension__c, cscrm__Street__c, cscrm__City__c, cscrm__State_Province__c,
                                      cscrm__Zip_Postal_Code__c, cscrm__Account__r.LG_ExternalID__c, LG_TechnicalContact__c from cscrm__Address__c where 
                                      LG_HouseNumber__c IN: houseNumberList AND
                                      LG_HouseNumberExtension__c IN: houseNumberExtList AND 
                                      cscrm__Zip_Postal_Code__c IN: postalCodeList AND 
                                      cscrm__Account__r.LG_ExternalID__c IN: accountExternalIdSet]){
            string extensionInUpperCase = '';
            if(pre.LG_HouseNumberExtension__c != null){
            extensionInUpperCase = pre.LG_HouseNumberExtension__c.toUpperCase();
            }                          
            string uniqueKeyForPremise = pre.cscrm__Account__r.LG_ExternalID__c + '_' + pre.LG_HouseNumber__c + '_' + extensionInUpperCase + '_'  + pre.cscrm__Zip_Postal_Code__c;
            existingPremiseMap.put(uniqueKeyForPremise, pre);
        }
        
        //********** create Feed Map for Billing Account DWH records 
        feedMapTemp = new map<string, List<LG_DWHFeedStagingTable__c>>();
        for(LG_DWHFeedStagingTable__c billingAccountfeed: dwhRecordsFetchedForBillingAccount){
            
            string uniqueId = billingAccountfeed.LG_TransactionIdAccountId__c;
            
            feedMapTempList = new List<map<string, List<LG_DWHFeedStagingTable__c>>>();
            if(feedMap.containsKey(uniqueId)){
                feedMapTempList = feedMap.get(uniqueId);
            }
            for(map<string, List<LG_DWHFeedStagingTable__c>> internalMap: feedMapTempList){
                if(internalMap.containsKey('BillingAccount')){
                    feedMapTemp = internalMap;
                }
            }
            
            if(feedMapTemp.containsKey('BillingAccount') && feedMapTemp.get('BillingAccount')[0].LG_TransactionIdAccountId__c == uniqueId){
                feedMapTemp.get('BillingAccount').add(billingAccountfeed);
            }
            else{
                feedMapTemp = new map<string, List<LG_DWHFeedStagingTable__c>>();
                feedMapTemp.put('BillingAccount', new List<LG_DWHFeedStagingTable__c> {billingAccountfeed});
            }
            
            boolean billingAccountFound = false;
            if(feedMap.containsKey(uniqueId)){ 
               for(map<string, List<LG_DWHFeedStagingTable__c>> internalMap: feedMap.get(uniqueId)){
                    if(internalMap.containsKey('BillingAccount')){
                        internalMap = feedMapTemp;
                        billingAccountFound = true;
                    }
                }
                if(billingAccountFound == false){
                    feedMap.get(uniqueId).add(feedMapTemp);
                }
            }
             else{
               feedMap.put(uniqueId,new List<map<string, List<LG_DWHFeedStagingTable__c>>>{feedMapTemp});
            }
        }
        
        //********** create Feed Map for Attribute DWH records 
        feedMapTemp = new map<string, List<LG_DWHFeedStagingTable__c>>();
        for(LG_DWHFeedStagingTable__c attributefeed: dwhRecordsFetchedForAttribute){
            
            string uniqueId = attributefeed.LG_TransactionIdAccountId__c;
            feedMapTempList = new List<map<string, List<LG_DWHFeedStagingTable__c>>>();
            if(feedMap.containsKey(uniqueId)){
                feedMapTempList = feedMap.get(uniqueId);
            }
            for(map<string, List<LG_DWHFeedStagingTable__c>> internalMap: feedMapTempList){
                if(internalMap.containsKey('Attribute')){
                    feedMapTemp = internalMap;
                }
            }
            
            if(feedMapTemp.containsKey('Attribute') && feedMapTemp.get('Attribute')[0].LG_TransactionIdAccountId__c == uniqueId){
                feedMapTemp.get('Attribute').add(attributefeed);
            }
            else{
                feedMapTemp = new map<string, List<LG_DWHFeedStagingTable__c>>();
                feedMapTemp.put('Attribute', new List<LG_DWHFeedStagingTable__c> {attributefeed});
            }
            
            boolean attributeFound = false;
            if(feedMap.containsKey(uniqueId)){ 
               for(map<string, List<LG_DWHFeedStagingTable__c>> internalMap: feedMap.get(uniqueId)){
                    if(internalMap.containsKey('Attribute')){
                        internalMap = feedMapTemp;
                        attributeFound = true;
                    }
                }
                if(attributeFound == false){
                    feedMap.get(uniqueId).add(feedMapTemp);
                }
            }
             else{
               feedMap.put(uniqueId,new List<map<string, List<LG_DWHFeedStagingTable__c>>>{feedMapTemp});
            }
        }
        
        //********** create Feed Map for Contract DWH records 
        feedMapTemp = new map<string, List<LG_DWHFeedStagingTable__c>>();
        for(LG_DWHFeedStagingTable__c contractfeed: dwhRecordsFetchedForContract){
            
            string uniqueId = contractfeed.LG_TransactionIdAccountId__c;
            
            feedMapTempList = new List<map<string, List<LG_DWHFeedStagingTable__c>>>();
            if(feedMap.containsKey(uniqueId)){
                feedMapTempList = feedMap.get(uniqueId);
            }
            for(map<string, List<LG_DWHFeedStagingTable__c>> internalMap: feedMapTempList){
                if(internalMap.containsKey('Contract')){
                    feedMapTemp = internalMap;
                }
            }
            
            if(feedMapTemp.containsKey('Contract') && feedMapTemp.get('Contract')[0].LG_TransactionIdAccountId__c == uniqueId){
                feedMapTemp.get('Contract').add(contractfeed);
            }
            else{
                feedMapTemp = new map<string, List<LG_DWHFeedStagingTable__c>>();
                feedMapTemp.put('Contract', new List<LG_DWHFeedStagingTable__c> {contractfeed});
            }
            
            boolean contractFound = false;
            if(feedMap.containsKey(uniqueId)){ 
               for(map<string, List<LG_DWHFeedStagingTable__c>> internalMap: feedMap.get(uniqueId)){
                    if(internalMap.containsKey('Contract')){
                        internalMap = feedMapTemp;
                        contractFound = true;
                    }
                }
                if(contractFound == false){
                    feedMap.get(uniqueId).add(feedMapTemp);
                }
            }
             else{
               feedMap.put(uniqueId,new List<map<string, List<LG_DWHFeedStagingTable__c>>>{feedMapTemp});
            }
        }
        
        // Creating a map for account external Ids and records Ids.
        uniqueIdAccountIdMap = new map<string, string>();
        List<Account> accListFetched = new List<Account>();
        accListFetched = [Select Id, LG_ExternalID__c, LG_ChamberOfCommerceNumber__c, LG_CustomAccountNumber__c, LG_AccountBackendSource__c from Account where 
                          LG_ExternalID__c IN: accountExternalIdSet OR LG_ChamberOfCommerceNumber__c IN: chamberOfCommerceNumberSet OR 
                          LG_CustomAccountNumber__c IN: customAccountNumberSet];
        
        map<string, string> uniqueIdentifierIdAccountIdMap = new map<string, string>();
        accountIdBackendSourceMap = new map<string, string>();
        
        for(Account acc: accListFetched){  
            uniqueIdentifierIdAccountIdMap.put(acc.LG_ExternalID__c, acc.Id);
            uniqueIdentifierIdAccountIdMap.put(acc.LG_ChamberOfCommerceNumber__c, acc.Id);  
            uniqueIdentifierIdAccountIdMap.put(acc.LG_CustomAccountNumber__c, acc.Id);
            accountIdBackendSourceMap.put(acc.Id, acc.LG_AccountBackendSource__c);          
        }
        
        for(string s: uniqueIdSet){
            string accountId = '';
            string customAccountNumber = '';
            string externalId = '';
            string chamberOfCommerceNumber = '';
            
            if(uniqueIdAccountCustomAccountNumberMap.get(s) != null){
                customAccountNumber = uniqueIdAccountCustomAccountNumberMap.get(s);
            }
            if(uniqueIdAccountExternalIdMap.get(s) != null){
                externalId = uniqueIdAccountExternalIdMap.get(s);
            }
            if(uniqueIdAccountChamberOfCommerceNumberMap.get(s) != null){
                chamberOfCommerceNumber = uniqueIdAccountChamberOfCommerceNumberMap.get(s);
            }
            
            if(uniqueIdentifierIdAccountIdMap.containsKey(customAccountNumber)){
                accountId = uniqueIdentifierIdAccountIdMap.get(customAccountNumber);
            }
            else if(uniqueIdentifierIdAccountIdMap.containsKey(externalId)){
                accountId = uniqueIdentifierIdAccountIdMap.get(externalId);
            }
            else if(uniqueIdentifierIdAccountIdMap.containsKey(chamberOfCommerceNumber)){
                accountId = uniqueIdentifierIdAccountIdMap.get(chamberOfCommerceNumber);
            }
            
            uniqueIdAccountIdMap.put(s,accountId);
        }
        
        // fetch existing subscription records with blank Tracy Ids
        List<csord__Subscription__c> subscriptionListFetched = new List<csord__Subscription__c>();
        subscriptionNumberSubscriptionIdMap = new map<string, string>();
        subscriptionNumberOrderIdMap = new map<string, string>();
        subscriptionUniqueIdSet = new set<String>();
        
        if(subscriptionNumberSet.size() > 0 && subscriptionNumberSet != null){
            subscriptionListFetched = [select Id, csordtelcoa__Subscription_Number__c, LG_SubscriptionExternalId__c, csord__Order__c  
                                       from csord__Subscription__c 
                                       where csordtelcoa__Subscription_Number__c IN: subscriptionNumberSet and LG_SubscriptionExternalId__c = ''];
        
            for(csord__Subscription__c sub: subscriptionListFetched){
                if(subscriptionNumberSet.contains(sub.csordtelcoa__Subscription_Number__c)){
                    subscriptionUniqueIdSet.add(subscriptionNumberUniqueIdMap.get(sub.csordtelcoa__Subscription_Number__c));
                }
                subscriptionNumberSubscriptionIdMap.put(sub.csordtelcoa__Subscription_Number__c, sub.Id);
                subscriptionNumberOrderIdMap.put(sub.csordtelcoa__Subscription_Number__c, sub.csord__Order__c);
            }
            system.debug('### subscriptionNumberSubscriptionIdMap: ' + subscriptionNumberSubscriptionIdMap);
        
        }

        // fetch existing service records with blank Tracy Ids
        List<csord__Service__c> serviceListFetched = new List<csord__Service__c>();
        serviceNumberServiceIdMap = new map<string, string>();
        
        if(serviceNumberSet.size() > 0 && serviceNumberSet != null){
            serviceListFetched = [select Id, csordtelcoa__Service_Number__c, LG_ServiceExternalId__c from csord__Service__c 
                                       where csordtelcoa__Service_Number__c IN: serviceNumberSet and LG_ServiceExternalId__c = ''];
        
            serviceUniqueIdSet = new set<String>(); 
            for(csord__Service__c ser: serviceListFetched){
                if(serviceNumberSet.contains(ser.csordtelcoa__Service_Number__c)){
                    serviceUniqueIdSet.add(serviceNumberServiceIdMap.get(ser.csordtelcoa__Service_Number__c));
                }
                serviceNumberServiceIdMap.put(ser.csordtelcoa__Service_Number__c, ser.Id);
            }
            system.debug('### serviceNumberServiceIdMap: ' + serviceNumberServiceIdMap);
        
        }
        
        return feedMap;        
    } 
    
    /*
        Name: createQueries
        Purpose: to create a query string that has all the records from the staging table and a condition 
        Argument: string
        Return type: string
    */
    /*
    public void createQueries(string objectAPIName){
        
        soqlQueryForAccount = '';
        soqlQueryForContact = '';
        soqlQueryForSubscription = '';
        soqlQueryForService = '';
        soqlQueryForBillingAccount = '';
        soqlQueryForPremise = '';
        soqlQueryForAttribute = '';
        soqlQueryForContract = '';

        LG_DWHIntegrationVariables__c customSettingRecord = LG_DWHIntegrationVariables__c.getValues('Limit_on_Accounts_Fetched');
        string limitOnAccountsFetched = customSettingRecord.LG_DisplayValue__c;
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(objectAPIName).getDescribe().fields.getMap();
        
        //********** create query for Account DWH records
        String commaSepratedFieldsForAccount = '';
        for(String fieldName : fieldMap.keyset()){
            
            if(fieldName.startsWithIgnoreCase('LG_Account')){
                if(commaSepratedFieldsForAccount == null || commaSepratedFieldsForAccount == ''){
                    commaSepratedFieldsForAccount = fieldName;
                }else{
                    commaSepratedFieldsForAccount = commaSepratedFieldsForAccount + ', ' + fieldName;
                }
            }
        }
        commaSepratedFieldsForAccount = commaSepratedFieldsForAccount + ', LG_TransactionIdAccountId__c';
        
        soqlQueryForAccount = 'select ' + commaSepratedFieldsForAccount + ' from ' + objectAPIName + ' where LG_TypeofRecord__c =: DWHTypeAccount AND ';
        if(manualSync){
            soqlQueryForAccount+= 'LG_TransactionIdAccountId__c =: uniqueIdForManualSync';
        }
        else{
            soqlQueryForAccount+= 'LG_Status__c =: newStatus limit ' + limitOnAccountsFetched;
        }
        
        
        //********** create query for Contact DWH records
        String commaSepratedFieldsForContact = '';
        for(String fieldName : fieldMap.keyset()){
            
            if(fieldName.startsWithIgnoreCase('LG_Contact')){
                if(commaSepratedFieldsForContact == null || commaSepratedFieldsForContact == ''){
                    commaSepratedFieldsForContact = fieldName;
                }else{
                    commaSepratedFieldsForContact = commaSepratedFieldsForContact + ', ' + fieldName;
                }
            }
        }
        commaSepratedFieldsForContact = commaSepratedFieldsForContact + ', LG_TransactionIdAccountId__c, LG_AccountExternalId__c';
        
        soqlQueryForContact = 'select ' + commaSepratedFieldsForContact + ' from ' + objectAPIName + ' where LG_TypeofRecord__c =: DWHTypeContact AND ';
        if(manualSync){
            soqlQueryForContact+= 'LG_TransactionIdAccountId__c =: uniqueIdForManualSync';
        }
        else{
            soqlQueryForContact+= 'LG_Status__c =: newStatus';
        }
        
        
        //********** create query for Subscription DWH records
        String commaSepratedFieldsForSubscription = '';
        for(String fieldName : fieldMap.keyset()){
            
            if(fieldName.startsWithIgnoreCase('LG_Subscription')){
                if(commaSepratedFieldsForSubscription == null || commaSepratedFieldsForSubscription == ''){
                    commaSepratedFieldsForSubscription = fieldName;
                }else{
                    commaSepratedFieldsForSubscription = commaSepratedFieldsForSubscription + ', ' + fieldName;
                }
            }
        }
        commaSepratedFieldsForSubscription = commaSepratedFieldsForSubscription + ', LG_TransactionIdAccountId__c, LG_AccountExternalId__c';
        
        soqlQueryForSubscription = 'select ' + commaSepratedFieldsForSubscription + ' from ' + objectAPIName + ' where LG_TypeofRecord__c =: DWHTypeSubscription AND ';
        if(manualSync){
            soqlQueryForSubscription+= 'LG_TransactionIdAccountId__c =: uniqueIdForManualSync';
        }
        else{
            soqlQueryForSubscription+= 'LG_Status__c =: newStatus';
        }
        
        //********** create query for Service DWH records
        String commaSepratedFieldsForService = '';
        for(String fieldName : fieldMap.keyset()){
            
            if(fieldName.startsWithIgnoreCase('LG_Service')){
                if(commaSepratedFieldsForService == null || commaSepratedFieldsForService == ''){
                    commaSepratedFieldsForService = fieldName;
                }else{
                    commaSepratedFieldsForService = commaSepratedFieldsForService + ', ' + fieldName;
                }
            }
        }
        commaSepratedFieldsForService = commaSepratedFieldsForService + ', LG_TransactionIdAccountId__c, LG_AccountExternalId__c';
        
        soqlQueryForService = 'select ' + commaSepratedFieldsForService + ' from ' + objectAPIName + ' where LG_TypeofRecord__c =: DWHTypeService AND ';
        if(manualSync){
            soqlQueryForService+= 'LG_TransactionIdAccountId__c =: uniqueIdForManualSync';
        }
        else{
            soqlQueryForService+= 'LG_Status__c =: newStatus';
        }
        
        
        //********** create query for Premise DWH records
        String commaSepratedFieldsForPremise = '';
        for(String fieldName : fieldMap.keyset()){
            
            if(fieldName.startsWithIgnoreCase('LG_Premise')){
                if(commaSepratedFieldsForPremise == null || commaSepratedFieldsForPremise == ''){
                    commaSepratedFieldsForPremise = fieldName;
                }else{
                    commaSepratedFieldsForPremise = commaSepratedFieldsForPremise + ', ' + fieldName;
                }
            }
        }
        commaSepratedFieldsForPremise = commaSepratedFieldsForPremise + ', LG_TransactionIdAccountId__c, LG_AccountExternalId__c';
        
        soqlQueryForPremise = 'select ' + commaSepratedFieldsForPremise + ' from ' + objectAPIName + ' where LG_TypeofRecord__c =: DWHTypePremise AND ';
        if(manualSync){
            soqlQueryForPremise+= 'LG_TransactionIdAccountId__c =: uniqueIdForManualSync';
        }
        else{
            soqlQueryForPremise+= 'LG_Status__c =: newStatus';
        }
        
        
        //********** create query for Billing Account DWH records
        String commaSepratedFieldsForBillingAccount = '';
        for(String fieldName : fieldMap.keyset()){
            
            if(fieldName.startsWithIgnoreCase('LG_BillingAccount')){
                if(commaSepratedFieldsForBillingAccount == null || commaSepratedFieldsForBillingAccount == ''){
                    commaSepratedFieldsForBillingAccount = fieldName;
                }else{
                    commaSepratedFieldsForBillingAccount = commaSepratedFieldsForBillingAccount + ', ' + fieldName;
                }
            }
        }
        commaSepratedFieldsForBillingAccount = commaSepratedFieldsForBillingAccount + ', LG_TransactionIdAccountId__c, LG_AccountExternalId__c';
        
        soqlQueryForBillingAccount = 'select ' + commaSepratedFieldsForBillingAccount + ' from ' + objectAPIName + ' where LG_TypeofRecord__c =: DWHTypeBillingAccount AND ';
        if(manualSync){
            soqlQueryForBillingAccount+= 'LG_TransactionIdAccountId__c =: uniqueIdForManualSync';
        }
        else{
            soqlQueryForBillingAccount+= 'LG_Status__c =: newStatus';
        }
        
        
        //********** create query for Attribute DWH records
        String commaSepratedFieldsForAttribute = '';
        for(String fieldName : fieldMap.keyset()){
            
            if(fieldName.startsWithIgnoreCase('LG_Attribute')){
                if(commaSepratedFieldsForAttribute == null || commaSepratedFieldsForAttribute == ''){
                    commaSepratedFieldsForAttribute = fieldName;
                }else{
                    commaSepratedFieldsForAttribute = commaSepratedFieldsForAttribute + ', ' + fieldName;
                }
            }
        }
        commaSepratedFieldsForAttribute = commaSepratedFieldsForAttribute + ', LG_TransactionIdAccountId__c, LG_AccountExternalId__c';
        
        soqlQueryForAttribute = 'select ' + commaSepratedFieldsForAttribute + ' from ' + objectAPIName + ' where LG_TypeofRecord__c =: DWHTypeAttribute AND ';
        if(manualSync){
            soqlQueryForAttribute+= 'LG_TransactionIdAccountId__c =: uniqueIdForManualSync';
        }
        else{
            soqlQueryForAttribute+= 'LG_Status__c =: newStatus';
        }
        
        
        //********** create query for Contract DWH records
        String commaSepratedFieldsForContract = '';
        for(String fieldName : fieldMap.keyset()){
            
            if(fieldName.startsWithIgnoreCase('LG_Contract')){
                if(commaSepratedFieldsForContract == null || commaSepratedFieldsForContract == ''){
                    commaSepratedFieldsForContract = fieldName;
                }else{
                    commaSepratedFieldsForContract = commaSepratedFieldsForContract + ', ' + fieldName;
                }
            }
        }
        commaSepratedFieldsForContract = commaSepratedFieldsForContract + ', LG_TransactionIdAccountId__c, LG_AccountExternalId__c';
        
        soqlQueryForContract = 'select ' + commaSepratedFieldsForContract + ' from ' + objectAPIName + ' where LG_TypeofRecord__c =: DWHTypeContract AND ';
        if(manualSync){
            soqlQueryForContract+= 'LG_TransactionIdAccountId__c =: uniqueIdForManualSync';
        }
        else{
            soqlQueryForContract+= 'LG_Status__c =: newStatus';
        }        
    }
    

    /*
        Name: createMapOfDWHCustomSetting
        Purpose: to create a map of name and Ids of product definitions. 
        Argument: string
        Return type: string
    */
    
    /*
    public void createMapOfDWHCustomSetting(){
        
        productNameAndProductDefinitionIdMap = new map<string, string>();
        productNameAndHierarchyLevelMap = new map<string, Decimal>();
        productNameDisplayValueMap = new map<string, string>();
        productNameAdditionalDisplayValueMap = new map<string, string>();
        productDefinitionRelatedProductAttDefNameMap = new map<string, string>();
        productDefinitionProductNameAttDefNameMap = new map<string, string>();
        attributeDefinitionHardCodedValueMap = new map<string, string>();
        mapForHardCodedValues = new map<string, string>();
        mapForProductCategoryNames = new map<string, string>();
        mapForProductDefintionNames = new map<string, string>();
        listOfProductDefinitionNames = new list<string>();
        listOfAllMACDEnabledProducts = new Set<string>();
        listOfConnectMKBProducts = new Set<string>();
        listOfPinProducts = new Set<string>();
        listOfMultiWifiProducts = new Set<string>();
        listOfMiltiWifiAccessPointProducts = new Set<string>();
        listOfTelephonyProducts = new Set<string>();
        listOfPhoneNumberProducts = new Set<string>();
        listOfInternetPlusProducts = new Set<string>();
        listOfTelephonyPlusProducts = new Set<string>();
        listOfZiggoBreedbandProducts = new Set<string>();
        listOfProductsWithoutService = new Set<string>();
        listOfInternetSecurityProductsForInternetPlus = new Set<string>();
        listOfSLAProducts = new Set<string>();
        listOfConnectMKBSubscriptionName = new Set<string>();
        listOfMultiWifiSubscriptionName = new Set<string>();
        listOfTelephonySubscriptionName = new Set<string>();
        listOfInternetPlusSubscriptionName = new Set<string>();
        subscriptionNameForLegacyPhoneNumbersSet = new Set<string>();
        sla_DisplayMap = new map<string, string>();
        
        map<string, string> csMapForProductDefinition = new map<string, string>();
        map<string, string> mapForProductDefinitionIdAndName = new map<string, string>();
        
        List<LG_DWHIntegrationVariables__c> DWHEnvironmentalVariableList = new List<LG_DWHIntegrationVariables__c>();
        DWHEnvironmentalVariableList = LG_DWHIntegrationVariables__c.getall().values(); 
        
        for(LG_DWHIntegrationVariables__c cs: DWHEnvironmentalVariableList){
            // populating the exact product category names
            if(cs.LG_Type__c == 'Product_Category'){
                mapForProductCategoryNames.put(cs.Name, cs.LG_DisplayValue__c);
            }
            
            // populating the exact product definition names
            if(cs.LG_Type__c == 'Product_Definition'){
                mapForProductDefintionNames.put(cs.Name, cs.LG_DisplayValue__c);
            }
        }
        
        pc_Internet = mapForProductCategoryNames.get('ProductCategory_Internet').toLowerCase();
        pc_RelatedProduct = mapForProductCategoryNames.get('ProductCategory_RelatedProducts').toLowerCase();
        pc_Telephony = mapForProductCategoryNames.get('ProductCategory_Telephony').toLowerCase();
        pc_LegacyProducts = mapForProductCategoryNames.get('ProductCategory_LegacyProducts').toLowerCase();
        pc_LegacyRelatedProducts = mapForProductCategoryNames.get('ProductCategory_LegacyRelatedProducts').toLowerCase();    
        
        pd_ConnectMKBInternet = mapForProductDefintionNames.get('ProductDefinition_ConnectMKBInternet');
        pd_Pin = mapForProductDefintionNames.get('ProductDefinition_Pin');
        pd_MultiWifi = mapForProductDefintionNames.get('ProductDefinition_MultiWiFi');
        pd_WiFiAccessPoint = mapForProductDefintionNames.get('ProductDefinition_WiFiAccessPoint');
        pd_Telephony = mapForProductDefintionNames.get('ProductDefinition_Telephony');
        pd_PhoneNumbers = mapForProductDefintionNames.get('ProductDefinition_PhoneNumbers');
        pd_InternetPlus = mapForProductDefintionNames.get('ProductDefinition_InternetPlus');
        pd_ZiggoBreedband = mapForProductDefintionNames.get('ProductDefinition_ZiggoBreedband');
        pd_TelephonyPlus = mapForProductDefintionNames.get('ProductDefinition_TelephonyPlus');
        
        listOfProductDefinitionNames = mapForProductDefintionNames.values();
        
        for(LG_DWHIntegrationVariables__c cs: DWHEnvironmentalVariableList){
            
            if(cs.LG_Type__c == 'Product'){
                
                string productName = cs.LG_ProductName__c.toLowerCase();
                csMapForProductDefinition.put(cs.LG_ProductName__c, cs.LG_ProductDefinitionName__c);
                productNameAndHierarchyLevelMap.put(productName, cs.LG_HierarchyLevel__c);
                
                //populating the map for product names and display values (Internet Plus and Connect MKB) 
                if(cs.LG_ProductDefinitionName__c== pd_InternetPlus){
                    productNameDisplayValueMap.put(productName, cs.LG_DisplayValue__c);
                }
                if(cs.LG_ProductDefinitionName__c == pd_ConnectMKBInternet){
                    productNameDisplayValueMap.put(productName, cs.LG_DisplayValue__c);
                }
                if(cs.LG_ProductDefinitionName__c == pd_PhoneNumbers){
                    productNameDisplayValueMap.put(productName, cs.LG_DisplayValue__c);
                    productNameAdditionalDisplayValueMap.put(productName, cs.LG_AdditionalDisplayValue__c);
                }
                if(cs.LG_ProductDefinitionName__c == pd_WiFiAccessPoint){
                    productNameDisplayValueMap.put(productName, cs.LG_DisplayValue__c);
                }
                
                //populating the list of products 
                if(cs.LG_ProductDefinitionName__c == pd_ConnectMKBInternet){
                    listOfConnectMKBProducts.add(productName);
                }
                if(cs.LG_ProductDefinitionName__c == pd_Pin){
                    listOfPinProducts.add(productName);
                }
                if(cs.LG_ProductDefinitionName__c == pd_MultiWifi){
                    listOfMultiWifiProducts.add(productName);
                }
                if(cs.LG_ProductDefinitionName__c == pd_WiFiAccessPoint){
                    listOfMiltiWifiAccessPointProducts.add(productName);
                }
                if(cs.LG_ProductDefinitionName__c == pd_Telephony){
                    listOfTelephonyProducts.add(productName);
                }
                if(cs.LG_ProductDefinitionName__c == pd_PhoneNumbers){
                    listOfPhoneNumberProducts.add(productName);
                }
                if(cs.LG_ProductDefinitionName__c == pd_InternetPlus){
                    listOfInternetPlusProducts.add(productName);
                }
                if(cs.LG_ProductDefinitionName__c == pd_TelephonyPlus){
                    listOfTelephonyPlusProducts.add(productName);
                }
                if(cs.LG_ProductDefinitionName__c == pd_ZiggoBreedband){
                    listOfZiggoBreedbandProducts.add(productName);
                }
            }
            
            // populating the list of names of attributes for related products
            if(cs.LG_Type__c == 'Attribute_Definition_For_Related_Product'){
                productDefinitionRelatedProductAttDefNameMap.put(cs.LG_ProductDefinitionName__c, cs.LG_AttributeDefinitionName__c);
            }
            
            // populating the list of names of attributes for lookup type attribute definitions
            if(cs.LG_Type__c == 'Attribute_Definition_For_Product_Name'){
                productDefinitionProductNameAttDefNameMap.put(cs.LG_ProductDefinitionName__c, cs.LG_AttributeDefinitionName__c);
            }
            
            // populating the list of names of attributes and display values that are hard coded
            if(cs.LG_Type__c == 'Attribute_Definitions_with_Hard_Coded_values'){
                string uniqueString = cs.LG_ProductDefinitionName__c + '_' + cs.LG_AttributeDefinitionName__c;
                attributeDefinitionHardCodedValueMap.put(uniqueString, cs.LG_DisplayValue__c);
            }
            
            // populating the list of other hard coded values
            if(cs.LG_Type__c == 'Other_Hard_Coded_Values'){
                mapForHardCodedValues.put(cs.Name, cs.LG_DisplayValue__c);
                if(cs.Name.containsIgnoreCase('SubscriptionForLegacyPhoneNumbers')){
                    subscriptionNameForLegacyPhoneNumbersSet.add(cs.LG_DisplayValue__c);
                }
            }
            
            // populating the list of products that dont need a service record in cloudsense
            if(cs.LG_Type__c == 'SLA_Products'){
                string productName = cs.LG_ProductName__c.toLowerCase();
                string displayValue = cs.LG_DisplayValue__c.toLowerCase();
                listOfSLAProducts.add(productName);
                sla_DisplayMap.put(productName, displayValue);
            }
            
            // populating the list of Subscription Names
            if(cs.LG_Type__c == 'Subscription_Name'){
                if(cs.LG_ProductDefinitionName__c == pd_ConnectMKBInternet){
                    listOfConnectMKBSubscriptionName.add(cs.LG_DisplayValue__c);
                }
                if(cs.LG_ProductDefinitionName__c == pd_MultiWifi){
                    listOfMultiWifiSubscriptionName.add(cs.LG_DisplayValue__c);
                }
                if(cs.LG_ProductDefinitionName__c == pd_Telephony){
                    listOfTelephonySubscriptionName.add(cs.LG_DisplayValue__c);
                }
                if(cs.LG_ProductDefinitionName__c == pd_InternetPlus){
                    listOfInternetPlusSubscriptionName.add(cs.LG_DisplayValue__c);
                }
            }
            
            // populating the list of products that dont need a service record in cloudsense
            if(cs.LG_Type__c == 'Products_NoSeparateServiceRecord'){
                
                string productName = cs.LG_ProductName__c.toLowerCase(); 
                listOfProductsWithoutService.add(productName);
                
                if(cs.LG_DisplayValue__c != null){
                    string displayValue = cs.LG_DisplayValue__c.toLowerCase();  
                    if(displayValue.contains('internetplus')){
                        listOfInternetSecurityProductsForInternetPlus.add(productName);
                    }
                }               
            }
        }
        
        listOfAllMACDEnabledProducts.addAll(listOfConnectMKBProducts);
        listOfAllMACDEnabledProducts.addAll(listOfPinProducts); 
        listOfAllMACDEnabledProducts.addAll(listOfMultiWifiProducts); 
        listOfAllMACDEnabledProducts.addAll(listOfMiltiWifiAccessPointProducts); 
        listOfAllMACDEnabledProducts.addAll(listOfTelephonyProducts); 
        listOfAllMACDEnabledProducts.addAll(listOfPhoneNumberProducts); 
        listOfAllMACDEnabledProducts.addAll(listOfInternetPlusProducts); 
        listOfAllMACDEnabledProducts.addAll(listOfTelephonyPlusProducts); 
        listOfAllMACDEnabledProducts.addAll(listOfZiggoBreedbandProducts);                 
        
        List<cscfga__Product_Definition__c> productDefinitionList = new List<cscfga__Product_Definition__c>();
        productDefinitionList = [Select Id, Name from cscfga__Product_Definition__c where Name IN: csMapForProductDefinition.values()];
        
        for(cscfga__Product_Definition__c pd: productDefinitionList){
            mapForProductDefinitionIdAndName.put(pd.Name, pd.Id);
        } 
        
        for(string s: csMapForProductDefinition.keyset()){
            
            string productNameLowerCase = s.toLowerCase();
            string productDefinitionName = csMapForProductDefinition.get(s);
            string productDefinitionId = mapForProductDefinitionIdAndName.get(productDefinitionName);
            productNameAndProductDefinitionIdMap.put(productNameLowerCase, productDefinitionId);
        }             
        
        accountSource_Derby = mapForHardCodedValues.get('AccountSource_DERBY');
        accountSource_Dynamics = mapForHardCodedValues.get('AccountSource_DYNAMICS');
        accountSource_EBS = mapForHardCodedValues.get('AccountSource_EBS');
        accountSource_Taifun = mapForHardCodedValues.get('AccountSource_TAIFUN');
        system.debug('### productNameAndProductDefinitionIdMap: ' + productNameAndProductDefinitionIdMap);
        
        
        
    }
   
    
    /*
        Name: createMapOfDiscountIds
        Purpose: to create a map of Discount Ids and Names/ExternalIds
        Argument: none
        Return type: none
     

    public void createMapOfDiscountIds(){
        
        discountIdMap = new map<string, string>();
        List<LG_Discount__c> discountList = new List<LG_Discount__c> ();
        discountList = [Select Id, Name, LG_DiscountMessage__c, LG_ContractTerm__c from LG_Discount__c where LG_Active__c = True];
        for(LG_Discount__c d: discountList){
            string uniqueStringForDiscount = d.LG_DiscountMessage__c + '_' + d.LG_ContractTerm__c;
            discountIdMap.put(uniqueStringForDiscount, d.Id);
        }
    } 
    
    /*
        Name: createMapOfPriceItemIds
        Purpose: to create a map of Price Items Ids and Names/ExternalIds
        Argument: none
        Return type: none
     
    public void createMapOfPriceItemIds(){
        
        priceItemIdMap = new map<string, string>();
        
        string productDefinitionNameForMKBTelephony = mapForHardCodedValues.get('LG_ProdDefNameForMKBTelephony');
        system.debug('### productDefinitionNameForMKBTelephony: ' + productDefinitionNameForMKBTelephony);
        
        List<cspmb__Price_Item__c> priceItemList = new List<cspmb__Price_Item__c> ();
        priceItemList = [Select Id, Name, cspmb__Contract_Term__c, cspmb__Product_Definition_Name__c from cspmb__Price_Item__c where cspmb__Is_Active__c = True];
        for(cspmb__Price_Item__c p: priceItemList){
            if(p.Name.contains(pd_ConnectMKBInternet)){
                string uniqueString = p.cspmb__Contract_Term__c + '_' + p.Name.toLowerCase();
                priceItemIdMap.put(uniqueString, p.Id);
            }
            if(p.cspmb__Product_Definition_Name__c == productDefinitionNameForMKBTelephony){
                priceItemIdForMKBTelephony = p.Id; 
            }
        }
        system.debug('### priceItemIdForMKBTelephony in method: ' + priceItemIdForMKBTelephony);
    }
    
    /*
        Name: createMapOfAddOnPriceItemIds
        Purpose: to create a map of Add On Price Items Ids and Names/ExternalIds
        Argument: none
        Return type: none
    
    public void createMapOfAddOnPriceItemIds(){
        
        addOnPriceItemIdMap = new map<string, string>();
        addOnPriceItemNameMap = new map<string, string>();
        
        string productDefinitionNameForPinZeker = mapForHardCodedValues.get('LG_ProdDefNameForPinZeker');
        string productDefinitionTypeForPhoneNumbers = mapForHardCodedValues.get('LG_ProdDefTypeForPhoneNumbers');
        string productDefinitionTypeForAccessPoints = mapForHardCodedValues.get('LG_ProdDefTypeForAccessPoints');
        string productDefinitionTypeForSLA = mapForHardCodedValues.get('LG_ProdDefTypeForSLA');
        
        List<cspmb__Add_On_Price_Item__c> addOnPriceItemList = new List<cspmb__Add_On_Price_Item__c> ();
        addOnPriceItemList = [Select Id, Name, cspmb__Product_Definition_Name__c, cspmb__Contract_Term__c, LG_ProductDefinitionType__c, LG_Quantity__c, 
                              LG_TypeOfPhoneRange__c, LG_LegacyProduct__c from cspmb__Add_On_Price_Item__c 
                              where cspmb__Is_Active__c = True AND 
                              (cspmb__Product_Definition_Name__c =: productDefinitionNameForPinZeker OR 
                               LG_ProductDefinitionType__c =: productDefinitionTypeForPhoneNumbers OR 
                               LG_ProductDefinitionType__c =: productDefinitionTypeForAccessPoints OR 
                               LG_ProductDefinitionType__c =: productDefinitionTypeForSLA
                              )];
        
        for(cspmb__Add_On_Price_Item__c p: addOnPriceItemList){
            if(p.cspmb__Product_Definition_Name__c == productDefinitionNameForPinZeker){
                addOnPriceItemIdMap.put(pd_Pin, p.Id);
            }
            if(p.LG_ProductDefinitionType__c == productDefinitionTypeForAccessPoints){
                string uniqueString = p.cspmb__Contract_Term__c + '_' + p.cspmb__Product_Definition_Name__c.toLowerCase();
                addOnPriceItemIdMap.put(uniqueString, p.Id);
            }
            
            if(p.LG_ProductDefinitionType__c == productDefinitionTypeForSLA){
                string uniqueString = p.cspmb__Contract_Term__c + '_' + p.cspmb__Product_Definition_Name__c.toLowerCase();
                addOnPriceItemIdMap.put(uniqueString, p.Id);
                addOnPriceItemNameMap.put(uniqueString, p.cspmb__Product_Definition_Name__c);
            }
            if(p.LG_ProductDefinitionType__c == productDefinitionTypeForPhoneNumbers && p.LG_LegacyProduct__c == True){
                string quantity = string.valueOf(p.LG_Quantity__c);
                string uniqueString = quantity + '_' + p.LG_TypeOfPhoneRange__c.toLowerCase() + '_' + 'LegacyTrue';
                addOnPriceItemIdMap.put(uniqueString, p.Id);
            }
            if(p.LG_ProductDefinitionType__c == productDefinitionTypeForPhoneNumbers && p.LG_LegacyProduct__c == False){
                string quantity = string.valueOf(p.LG_Quantity__c);
                string uniqueString = quantity + '_' + p.LG_TypeOfPhoneRange__c.toLowerCase() + '_' + 'LegacyFalse';
                addOnPriceItemIdMap.put(uniqueString, p.Id);
            }           
                                  
        }        
        system.debug('### addOnPriceItemIdMap in method: ' + addOnPriceItemIdMap);
        system.debug('### addOnPriceItemNameMap in method: ' + addOnPriceItemNameMap);       
    }
    
    /*
        Name: createCommaSeperatedStringForProductConfigIds
        Purpose: to create a string with comma seperated product configuration Ids 
        Argument: List<string>
        Return type: none
     
    public string createCommaSeperatedStringForProductConfigIds(List<string> productConfigIdList){
        
        string returnString = null;
        for(string s: productConfigIdList){
            if(returnString == null){
                returnString = s;
            }
            else{
                returnString = returnString + ',' + s;
            }
        }
        
        return returnString;
    }
    
    /*
        Name: createListOfAttributesForProducts
        Purpose: to create lists of attribute names for products 
        Argument: none
        Return type: none
    
    public void createListOfAttributeNamesForProducts(set<string> productDefinitionNameList){
        
        List<cscfga__Attribute_Definition__c> attributeList = new List<cscfga__Attribute_Definition__c>();
        attributeList = [Select Id, Name, cscfga__Product_Definition__c, cscfga__Product_Definition__r.Name,  
                        cscfga__Is_Line_Item__c, cscfga__Recurring__c from cscfga__Attribute_Definition__c 
                        where cscfga__Product_Definition__r.Name IN: productDefinitionNameList];
                        
        mapForAttributeDefinition = new map<string,List<cscfga__Attribute_Definition__c>>();
        
        For(cscfga__Attribute_Definition__c att: attributeList){
            if(mapForAttributeDefinition.containsKey(att.cscfga__Product_Definition__r.Name)){
                mapForAttributeDefinition.get(att.cscfga__Product_Definition__r.Name).add(att);
            }
            else{
                mapForAttributeDefinition.put(att.cscfga__Product_Definition__r.Name,new List<cscfga__Attribute_Definition__c>{att});
            }
            
        }
     }
     
     
     /*
        Name: createAttributeListForProductDefinition
        Purpose: to process the feed records to create Attribute records in SFDC objects for the specified product definition  
        Argument: string, string
        Return type: List<cscfga__Attribute__c>
    
    public List<cscfga__Attribute__c> createAttributeListForProductDefinition(string productDefinitionName, string prodConfigId){
    
        List<cscfga__Attribute__c> tempAttributeList = new List<cscfga__Attribute__c>();
        List<cscfga__Attribute_Definition__c> listOfConnectMKBAttributeDefinition = new List<cscfga__Attribute_Definition__c>();
        listOfConnectMKBAttributeDefinition = mapForAttributeDefinition.get(productDefinitionName);
        
        for(cscfga__Attribute_Definition__c ad: listOfConnectMKBAttributeDefinition){
            
            cscfga__Attribute__c att1 = new cscfga__Attribute__c();
            att1.Name = ad.Name;
            att1.cscfga__Value__c = '';
            att1.cscfga__Display_Value__c = '';
            att1.cscfga__Attribute_Definition__c = ad.Id;
            att1.cscfga__Is_Line_Item__c = ad.cscfga__Is_Line_Item__c;
            att1.cscfga__Recurring__c = ad.cscfga__Recurring__c;
            att1.cscfga__Line_Item_Description__c = '';
            att1.cscfga__Price__c = 0;
            att1.cscfga__Product_Configuration__c = prodConfigId;
            tempAttributeList.add(att1);            
        }
        
        return tempAttributeList;
    }
    
    */
    
}