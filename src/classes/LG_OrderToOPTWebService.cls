/*******************************************************************************************************************************************
* File Name     :  LG_OrderToOPTWebService
* Description   :  This is a webservice that sends the order data to external system. 

* @author       :   Shreyas
* Modification Log
===================================================================================================
* Ver.    Date          Author              Modification
---------------------------------------------------------------------------------------------------
* 1.0     2nd-Mar-16    Shreyas             Created the class for release R1*

********************************************************************************************************************************************/

global class LG_OrderToOPTWebService {/*
    
   
    global class returnData {
        webservice String error {get;set;}
        webservice String status {get;set;}        
        webservice list<orderData> orderData {get;set;}        
    }
    
    global class orderData {
        webservice LG_Account accountDetail {get;set;}
        webservice LG_OrderDetail orderDetail {get;set;}
        webservice LG_Opportunity opportunityDetail {get;set;}
    }
    
    global class LG_Account {
        
        webservice string Name {get;set;}
        webservice string CustomAccountNumber {get;set;}
        webservice string Phone {get;set;}
        webservice string Fax {get;set;}
        webservice string Website {get;set;}
        webservice string EmailAdministrativeContact {get;set;}
        webservice string ChamberOfCommerceNumber {get;set;}
        webservice string ExternalAccountID {get;set;}
        webservice string VisitCountry {get;set;}
        webservice string VisitPostalCode {get;set;}
        webservice string VisitHouseNumber {get;set;}
        webservice string VisitStreet {get;set;}
        webservice string VisitHouseNumberExtension {get;set;}
        webservice string VisitCity {get;set;}
        webservice string PostalCountry {get;set;}
        webservice string PostalPostalCode {get;set;}
        webservice string PostalHouseNumber {get;set;}
        webservice string PostalStreet {get;set;}
        webservice string PostalHouseNumberExtension {get;set;}
        webservice string PostalCity {get;set;}
        webservice List<LG_Contact> contactList {get;set;}
        webservice List<LG_BillingAccount> billingAccountList {get;set;}
    }

    global class LG_Contact {
        webservice string Name {get;set;}
        webservice string FirstName {get;set;}
        webservice string LastName {get;set;}
        webservice string Salutation {get;set;}
        webservice string Phone {get;set;}
        webservice string MobilePhone {get;set;}
        webservice string Fax {get;set;}
        webservice string Email {get;set;}
        webservice string TechnicalContact {get;set;}
        webservice string CommercialContact {get;set;}
        webservice string FinancialContact {get;set;}
        webservice date Birthdate {get;set;}
    }
    
    global class LG_BillingAccount { 
        webservice string BankAccountHolder  {get;set;}
        webservice string ExternalID  {get;set;}
        webservice string CustomerExternalID  {get;set;}
        webservice string PaymentType  {get;set;}
        webservice string PaymentTerms  {get;set;}
        webservice string BillingAccountNumber  {get;set;}
        webservice string CustomerReference  {get;set;}
        webservice string BillingEmailAddress  {get;set;}
        webservice string BillingChannel  {get;set;}
        webservice string BankAccountNumberIBAN  {get;set;}
        webservice string FormatType  {get;set;}
        webservice string Country  {get;set;}
        webservice string Street  {get;set;}
        webservice string HouseNumber  {get;set;}
        webservice string HouseNumberExtension  {get;set;}
        webservice string Postcode  {get;set;}
        webservice string City  {get;set;}
    }
    
     global class LG_OrderDetail {
        webservice string OrderNumber {get;set;}
        webservice string CustomAccountNumber {get;set;}
        webservice string ExternalAccountID {get;set;}
        webservice string OpportunityName {get;set;}
        webservice string BillingAccountPaymentType {get;set;}
        webservice date PreferredInstallationDate {get;set;}
        webservice string ContractTerm {get;set;}  
        webservice string OpportunityOwner {get;set;}
        webservice string CommercialContact {get;set;}
        webservice string TechnicalContact {get;set;}
        webservice string ChangeTypeCode {get;set;}
        webservice string Remark {get;set;}
        webservice List<LG_OrderLine> orderLineList {get;set;}
     }
     
     global class LG_OrderLine {
        webservice string BillingAccountExternalId {get;set;}
        webservice string BillingAccountNumber {get;set;}
        webservice string SubscriptionName {get;set;}
        webservice string ServiceName {get;set;}
        webservice string ExternalPriceName {get;set;}
        webservice string PremiseName  {get;set;}
        webservice string PremiseStreet  {get;set;}
        webservice string PremiseHouseNumber  {get;set;}
        webservice string PremiseHouseNumberExtension  {get;set;}
        webservice string PremiseZIPPostalCode  {get;set;}
        webservice string PremiseCity  {get;set;}
        webservice string PremiseFootprint  {get;set;}
        webservice string SubscriptionPublicId {get;set;}
        webservice string ServicePublicId {get;set;}
        webservice string SubscriptionExternalId {get;set;}
        webservice string ServiceExternalId {get;set;}
        webservice string contractstatus {get;set;}
        webservice List<LG_AddOns> addOnList {get;set;}
        webservice List<LG_PhoneNumbers> phoneNumberList {get;set;}
        webservice List<LG_Discounts> discountList {get;set;}       
     }
     
     global class LG_AddOns {
        webservice string ExternalSubscriptionName {get;set;}
        webservice string ExternalServiceName {get;set;}
        webservice string Quantity {get;set;}
        webservice string ServiceLineItemExternalDescription {get;set;}
        webservice string ServiceLineItemPriceName {get;set;}
        webservice string ServiceLineItemLineNumber {get;set;}
        webservice string ServiceLineItemExternalID {get;set;}
        webservice string Yes_No {get;set;}
        webservice List<LG_Discounts> addOnDiscountList {get;set;}
     }
     
     global class LG_Discounts {
        webservice string DiscountName {get;set;}
     }
     
     global class LG_PhoneNumbers {
        webservice string AreaCodes {get;set;}
        webservice string Phonenumbers {get;set;}
        webservice string TypeOfPhoneRange {get;set;}
        webservice string DonorOperatorCode {get;set;}
        webservice string PortingName {get;set;}
        webservice string PortingInitials {get;set;}
        webservice string PortingPrefix {get;set;}
        webservice string PortingStreet {get;set;}
        webservice string PortingHouseNumber {get;set;}
        webservice string PortingHouseNumberAddition {get;set;}
        webservice string PortingZipcode {get;set;}
        webservice string PortingCity {get;set;}
        webservice date PortingWishDate {get;set;}
        webservice string CallerID {get;set;}
        webservice string CallBarringLevel {get;set;}
        webservice string BNumberShielding {get;set;}
        webservice string InDirectory {get;set;}
        webservice string DirectoryListingName {get;set;}
     }
     
     global class LG_Opportunity {
        
        webservice string Id  {get;set;}
        webservice string Type  {get;set;}
        webservice string AccountSegment  {get;set;}
        webservice string FootPrint  {get;set;}
        webservice string Description  {get;set;}
        webservice string Name  {get;set;}
        webservice string AccountId  {get;set;}
        webservice string AccountName  {get;set;}
        webservice string AccountPhone  {get;set;}
        webservice string AccountChamberOfCommerce  {get;set;}
        webservice date PreferredInstallationDate {get;set;}
        webservice boolean SharedOfficeBuilding  {get;set;}
        webservice string COAXConnectionLocation  {get;set;}
        webservice string ContractTermMonths  {get;set;}
        webservice string PaymentType  {get;set;}
        webservice string PartnerAccountId  {get;set;}
        webservice string PartnerAccountName  {get;set;}
        webservice string NEWSalesChannel  {get;set;}
        webservice string BillingStreet {get;set;}
        webservice string BillingHouseNumber {get;set;}
        webservice string BillingHouseNumberExtension {get;set;}
        webservice string BillingPostalCode {get;set;}
        webservice string BillingCity {get;set;}
        webservice string BillingCountry {get;set;}
        webservice string BankAccountName {get;set;}
        webservice string BankNumber {get;set;}
        webservice string CustomerReference {get;set;}
        webservice string InstallationStreet {get;set;}
        webservice string InstallationHouseNumber {get;set;}
        webservice string InstallationHouseNumberExtension {get;set;}
        webservice string InstallationPostalCode {get;set;}
        webservice string InstallationCity {get;set;}
        webservice string InstallationCountry {get;set;}
        webservice string PostalStreet {get;set;}
        webservice string PostalHouseNumber {get;set;}
        webservice string PostalHouseNumberExtension {get;set;}
        webservice string PostalCode {get;set;}
        webservice string PostalCity {get;set;}
        webservice string PostalCountry {get;set;}      
        webservice List<LG_OpportunityLineItem> opportunityLineItemList {get;set;}
        webservice List<LG_OpportunityContactRole> opportunityContactRoleList {get;set;}
        webservice List<LG_ProductDetail> productDetailList {get;set;}
        webservice List<LG_PortingNumbersForSoho> portingNumberList {get;set;}
     }
     
     global class LG_OpportunityLineItem {
        
        webservice string PricebookEntryName  {get;set;}
        webservice string TotalPrice  {get;set;}
        webservice string OneOffPrice  {get;set;}
        webservice string Type  {get;set;}
        webservice boolean MainOLI  {get;set;}
     }
     
     global class LG_OpportunityContactRole {
        
        webservice string Role  {get;set;}
        webservice string Name  {get;set;}
        webservice string Salutation  {get;set;}
        webservice string LastName  {get;set;}
        webservice string Phone  {get;set;}
        webservice string MobilePhone  {get;set;}
        webservice string Fax  {get;set;}
        webservice string Email  {get;set;}
        webservice date Birthdate  {get;set;}
     }
     
     global class LG_ProductDetail {
        webservice string Name  {get;set;}
        webservice string Product  {get;set;}
        webservice string Value  {get;set;}
     }
     
     global class LG_PortingNumbersForSoho {
        webservice date PortingDate  {get;set;}
        webservice string PhoneNumber  {get;set;}
        webservice string Operator  {get;set;}
        webservice string CustomerName  {get;set;}
        webservice string InDirectory  {get;set;}
     }

    /*
        Name: getOrders
        Purpose: to fetch the order data from SFDC and send it to external systems.
        Argument: integer numberOfDays, string typeOfOrders
        Return type: returnData
    */
  /*  Webservice static returnData getOrders(integer numberOfDays, string typeOfOrders) { 
        
        returnData returnDataObj = new returnData();
        returnDataObj.error = '';
        returnDataObj.status = 'Success';
        returnDataObj.orderData = new List<orderData>();
        
        string opportunityStage_SoHo = '';
        string newSubscriptionStatus_Small = '';
        string newServiceStatus_Small = '';
        string administrativeContactRole = '';
        string financialContactRole = '';
        string technicalContactRole = '';
        string administrativeRoleContactName = '';
        string technicalRoleContactName = '';
        string serviceLineItemType_Product = '';
        string serviceLineItemType_AddOn = '';
        string serviceLineItemType_Discount = '';
        string subscriptionStatusForInDelivery = '';
        string serviceStatusForInDelivery = '';
        string subscriptionStatusForTerminationRequested = '';
        string serviceStatusForTerminationRequested = '';
        string subscriptionStatusForTerminationInProgress = '';
        string serviceStatusForTerminationInProgress = '';
        string orderStatusForSubmitted = '';
        string orderStatusForInDelivery = '';
        string attributeFieldNameForBillingAccount = '';
        string toBeSentForServiceLineItems_Small = '';
        string segmentForOpportunityLineItems_SoHo = '';
        string changeTypeForTerminatedService = '';
        
        List<LG_OrderWebserviceVariables__c> orderWebserviceVariableList = new List<LG_OrderWebserviceVariables__c>();
        orderWebserviceVariableList = LG_OrderWebserviceVariables__c.getall().values(); 
        
        for(LG_OrderWebserviceVariables__c obj: orderWebserviceVariableList){
            
            if(obj.Name == 'Opportunity_Status_for_SoHo_Products'){
                opportunityStage_SoHo = obj.LG_Value__c;
            }
            if(obj.Name == 'Subscription_Status_for_InDelivery'){
                subscriptionStatusForInDelivery = obj.LG_Value__c;
            }
            if(obj.Name == 'SubsStatusforTerminationInProgress'){
                subscriptionStatusForTerminationInProgress = obj.LG_Value__c;
            }
            if(obj.Name == 'Service_Status_for_InDelivery'){
                serviceStatusForInDelivery = obj.LG_Value__c;
            }
            if(obj.Name == 'ServiceStatusforTerminationInProgress'){
                serviceStatusForTerminationInProgress = obj.LG_Value__c;
            }
            if(obj.Name == 'ContactRole_Administrative'){
                administrativeContactRole = obj.LG_Value__c;
            }
            if(obj.Name == 'ContactRole_Technical'){
                technicalContactRole = obj.LG_Value__c;
            }
            if(obj.Name == 'ContactRole_Financial'){
                financialContactRole = obj.LG_Value__c;
            }
            if(obj.Name == 'ServiceLineItem_Type_Product'){
                serviceLineItemType_Product = obj.LG_Value__c;
            }
            if(obj.Name == 'ServiceLineItem_Type_AddOn'){
                serviceLineItemType_AddOn = obj.LG_Value__c;
            }
            if(obj.Name == 'ServiceLineItem_Type_Discount'){
                serviceLineItemType_Discount = obj.LG_Value__c;
            }
            if(obj.Name == 'Order_Status_In_Delivery'){
                orderStatusForInDelivery = obj.LG_Value__c;
            }
            if(obj.Name == 'Order_Status_Submitted'){
                orderStatusForSubmitted= obj.LG_Value__c;
            }
            if(obj.Name == 'AttributeFieldName_For_BillingAccount'){
                attributeFieldNameForBillingAccount = obj.LG_Value__c;
            }
            if(obj.Name == 'ToBeSent_ServiceLineItems_Small'){
                toBeSentForServiceLineItems_Small = obj.LG_Value__c;
            }
            if(obj.Name == 'Segment_OpportunityLineItem_SoHo'){
                segmentForOpportunityLineItems_SoHo = obj.LG_Value__c;
            }
            if(obj.Name == 'ChangeTypeForTerminateService'){
                changeTypeForTerminatedService = obj.LG_Value__c;
            }
        }
        
        csordtelcoa__Orders_Subscriptions_Options__c cs_obj = csordtelcoa__Orders_Subscriptions_Options__c.getInstance();
        if(cs_obj != null){
            newSubscriptionStatus_Small = cs_obj.csordtelcoa__Subscription_Initial_State__c;
            subscriptionStatusForTerminationRequested = cs_obj.LG_SubscriptionRequestDeactivateStatus__c;
            newServiceStatus_Small = cs_obj.csordtelcoa__Service_Initial_State__c;
            serviceStatusForTerminationRequested = cs_obj.LG_ServiceRequestDeactivateStatus__c;
        }

        
        string orderType = typeOfOrders;
        orderType = orderType.toLowerCase();
        
        try{
            
            if(orderType == 'small' || orderType == 'all'){
                
                List<csord__Subscription__c> subscriptionListFetched = new List<csord__Subscription__c>();  
                List<string> subscriptionIdList = new List<string>();
                List<csord__Subscription__c> subscriptionListToUpdate = new List<csord__Subscription__c>();
                
                List<csord__Service__c> serviceListFetched = new List<csord__Service__c>(); 
                List<csord__Service__c> serviceListToUpdate = new List<csord__Service__c>();
                
                Set<string> setOfProductLevelServiceIds = new Set<string>();
                Set<string> setOfAddOnLevelServiceIds = new Set<string>();
                
                List<csord__Service_Line_Item__c> serviceLineItemListFetched = new List<csord__Service_Line_Item__c>(); 
                map<string, List<csord__Service_Line_Item__c>> orderNumberServiceLineItemMap = new map<string, List<csord__Service_Line_Item__c>>();
                
                Set<string> replacedOrderNumberSet = new Set<string>();
                map<string, string> replacedOrderMovedOrderMap = new map<string, string>();
                map<string, LG_OrderDetail> orderDetailMap = new map<string, LG_OrderDetail>();
                
                List<csord__Order__c> orderListFetched = new List<csord__Order__c>();
                Set<string> orderIdSet = new Set<string>();
                List<csord__Order__c> orderListToUpdate = new List<csord__Order__c>();
                
                map<string, string> orderNumberAccountIdMap = new map<string, string>();
                map<string, Set<string>> orderNumberProductConfigurationIdMap = new map<string, Set<string>>();
                Set<string> orderNumberSet = new Set<string>();
                Set<string> productConfigurationIdSet = new Set<string>();
                
                List<Account> accountListFetched = new List<Account>(); 
                map<string, Account> accountMap = new map<string, Account>();
                Set<string> accountIdSet = new Set<string>();
                
                List<Contact> contactListFetched = new List<Contact>(); 
                map<string, List<Contact>> accountIdContactMap = new map<string, List<Contact>>(); 
                
                List<csconta__Billing_Account__c> billingAccountListFetched = new List<csconta__Billing_Account__c>();  
                map<string, List<csconta__Billing_Account__c>> accountIdBillingAccountMap = new map<string, List<csconta__Billing_Account__c>>();
                
                Set<string> opportunityIdSet = new Set<string>();
                map<string, string> orderNumberOpportunityIdMap = new map<string, string>();
                List<OpportunityContactRole> opportunityContactRoleListFetched = new List<OpportunityContactRole>(); 
                map<string, Set<string>> contactIdContactRoleSetMap = new map<string, Set<string>>();
                map<string, OpportunityContactRole> opportunityIdAdministrativeContactRoleMap = new map<string, OpportunityContactRole>();
                map<string, Contact> orderNumberTechnicalContactMap = new map<string, Contact>();
                
                List<LG_PortingNumber__c> portingNumberListFetched = new List<LG_PortingNumber__c>(); 
                map<string, List<LG_PortingNumber__c>> productConfigIdPortingNumberMap = new map<string, List<LG_PortingNumber__c>>();
                Set<string> prodConfigSetWithPhoneNumber = new Set<string>();
                
                //variables for migrate MACD scenario
                map<string, string> subscriptionIdOrderNumberMap = new map<string, string>();
                map<string, string> subscriptionIdPremiseIdMap = new map<string, string>();
                Set<string> subscriptionIdSetForMigrate = new Set<string>();
                Set<string> opportunityIdSetForMigrate = new Set<string>();
                Set<string> productbasketIdListForMigrate = new Set<string>();
                List<cscfga__Product_Basket__c> productBasketListFetchedForMigrate = new List<cscfga__Product_Basket__c>(); 
                List<csordtelcoa__Subscr_MACDProductBasket_Association__c> associationListFetchedForMigrate = new List<csordtelcoa__Subscr_MACDProductBasket_Association__c>(); 
                map<string, string> premiseIdSubscriptionIdMapForMigrate = new map<string, string>();
                
                //fetch subscription records
                string soqlQueryForSubscription = 'Select Id, csord__Status__c, csord__Order__r.csordtelcoa__Opportunity__r.Name, csord__Account__c, csord__Order_Request__c, ';
                soqlQueryForSubscription = soqlQueryForSubscription + 'csord__Order__r.csordtelcoa__Opportunity__c, csord__Order__c from csord__Subscription__c ';
                soqlQueryForSubscription = soqlQueryForSubscription + 'where (csord__Status__c =: newSubscriptionStatus_Small OR csord__Status__c =: subscriptionStatusForTerminationRequested)';
                soqlQueryForSubscription = soqlQueryForSubscription + ' AND LastModifiedDate = LAST_N_DAYS: ' + numberOfDays;    
                subscriptionListFetched = Database.query(soqlQueryForSubscription);
                                        
                for(csord__Subscription__c subs: subscriptionListFetched){
                    subscriptionIdList.add(subs.Id);
                    accountIdSet.add(subs.csord__Account__c);
                    opportunityIdSet.add(subs.csord__Order__r.csordtelcoa__Opportunity__c);
                    orderIdSet.add(subs.csord__Order__c);
                }
                
                //fetch service records  
                serviceListFetched = [Select Id, csord__Status__c, csordtelcoa__Product_Configuration__c, csord__Subscription__c, LG_ChangeType__c, LG_OrderNumber__c, 
                                      LG_AreaCodes__c, LG_Phonenumbers__c, LG_TypeOfPhoneRange__c, LG_PortingName__c, LG_PortingInitials__c, LG_PortingPrefix__c, LG_BlockType__c, 
                                      LG_PortingStreet__c, LG_PortingHouseNumber__c, LG_PortingHouseNumberAddition__c, LG_PortingZipcode__c, LG_PortingCity__c, LG_PortingWishDate__c, 
                                      LG_CallerID__c, LG_CallBarringLevel__c, LG_BNumberShielding__c, LG_DonorOperatorCode__c                 
                                      from csord__Service__c where csord__Subscription__c IN: subscriptionIdList];
                                      
                for(csord__Service__c serv: serviceListFetched ){
                    subscriptionIdOrderNumberMap.put(serv.csord__Subscription__c, serv.LG_OrderNumber__c);
                }                      

                
                //fetch order records  
                orderListFetched = [Select Id, csord__Status2__c from csord__Order__c where Id IN: orderIdSet];                      
                                      
               //fetch account records 
                accountListFetched = [Select Id, Name, LG_CustomAccountNumber__c, Phone, Fax, Website, LG_ChamberOfCommerceNumber__c, AccountNumber, LG_VisitCountry__c, LG_ExternalID__c, 
                                                        LG_VisitPostalCode__c, LG_VisitHouseNumber__c, LG_VisitStreet__c, LG_VisitHouseNumberExtension__c, LG_VisitCity__c, 
                                                        LG_PostalCountry__c, LG_PostalPostalCode__c, LG_PostalHouseNumber__c, LG_PostalStreet__c, LG_PostalHouseNumberExtension__c, 
                                                        LG_PostalCity__c, LG_Segment__c from Account where id IN: accountIdSet];
                for(Account acc: accountListFetched){
                    accountMap.put(acc.Id, acc);
                }
                  
                //fetch contact records 
                contactListFetched = [Select Id, accountId, Name, FirstName, LastName, Salutation, MobilePhone, Fax, Email, Birthdate, Phone
                                      from contact where accountId IN: accountIdSet];
                for(Contact con: contactListFetched){
                    if(accountIdContactMap.containsKey(con.accountId)){
                        accountIdContactMap.get(con.accountId).add(con);
                    }
                    else{
                        accountIdContactMap.put(con.accountId, new List<Contact>{con});
                    }
                }
                
                //fetch the opportunity contact role records
                opportunityContactRoleListFetched = [Select Id, contactId, opportunityId, role, contact.Email, contact.Name from OpportunityContactRole 
                                                     where opportunityId IN: opportunityIdSet];
                for(OpportunityContactRole ocr: opportunityContactRoleListFetched){
                    if(contactIdContactRoleSetMap.containsKey(ocr.contactId)){
                        contactIdContactRoleSetMap.get(ocr.contactId).add(ocr.role);
                    }
                    else{
                        contactIdContactRoleSetMap.put(ocr.contactId, new set<string>{ocr.role});
                    }
                    if(ocr.role == administrativeContactRole){
                        opportunityIdAdministrativeContactRoleMap.put(ocr.opportunityId, ocr);
                    }
                }
                       
                //fetch billing account records 
                billingAccountListFetched = [Select Id, csconta__Account__c, LG_BankAccountHolder__c, LG_ExternalId__c, LG_PaymentType__c, csconta__Payment_Terms__c, Name, 
                                             LG_CustomerReference__c, LG_BillingEmailAddress__c, csconta__Billing_Channel__c, LG_BankAccountNumberIBAN__c, csconta__Format_Type__c, 
                                             csconta__Street__c, LG_HouseNumber__c, LG_HouseNumberExtension__c, csconta__Postcode__c, csconta__City__c, csconta__Country__c
                                             from csconta__Billing_Account__c where csconta__Account__c IN: accountIdSet];
                for(csconta__Billing_Account__c ba: billingAccountListFetched){
                    if(accountIdBillingAccountMap.containsKey(ba.csconta__Account__c)){
                        accountIdBillingAccountMap.get(ba.csconta__Account__c).add(ba);
                    }
                    else{
                        accountIdBillingAccountMap.put(ba.csconta__Account__c, new List<csconta__Billing_Account__c>{ba});
                    }
                }
            
                //fetch serviceLineItem records 
                serviceLineItemListFetched = [Select Id, LG_Type__c, LG_ExternalServiceName__c, LG_ExternalPriceName__c, LG_Quantity__c, LG_ExternalDescription__c, csord__Service__c, 
                                              csord__Line_Number__c, LG_ServiceLineItemExternalId__c, LG_ToBeSent__c, 
                                              csord__Service__r.LG_OrderNumber__c, 
                                              csord__Service__r.LG_ExternalSubscriptionName__c,
                                              csord__Service__r.LG_ContractTerm__c, 
                                              csord__Service__r.LG_InstallationWishDate__c, 
                                              csord__Service__r.csordtelcoa__Service_Number__c,
                                              csord__Service__r.LG_ServiceExternalId__c, 
                                              csord__Service__r.csordtelcoa__Product_Configuration__c, 
                                              csord__Service__r.LG_IgnoreContractTerm__c, 
                                              csord__Service__r.LG_ChangeType__c, 
                                              csord__Service__r.LG_ChangeTypeCode__c, 
                                              csord__Service__r.csordtelcoa__Replaced_Service__c,
                                              csord__Service__r.csordtelcoa__Replaced_Service__r.LG_OrderNumber__c, 
                                              csord__Service__r.csord__Subscription__c, 
                                              csord__Service__r.csord__Subscription__r.csord__Account__c, 
                                              csord__Service__r.csord__Subscription__r.csord__Account__r.LG_CustomAccountNumber__c, 
                                              csord__Service__r.csord__Subscription__r.csord__Account__r.LG_ExternalID__c,
                                              csord__Service__r.csord__Subscription__r.csordtelcoa__Subscription_Number__c,
                                              csord__Service__r.csord__Subscription__r.LG_SubscriptionExternalId__c, 
                                              csord__Service__r.csord__Subscription__r.csord__Status__c, 
                                              csord__Service__r.csord__Subscription__r.csordtelcoa__Replaced_Subscription__c,
                                              csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__c,
                                              csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.Name,
                                              csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.Owner.Name,
                                              csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_ClientNumber__c,
                                              csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_ExistingSubscription__c,
                                              csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_DTV__c,
                                              csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_IPAddress__c,
                                              csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_Telephony__c,
                                              LG_BillingAccount__r.LG_PaymentType__c, 
                                              LG_BillingAccount__r.LG_ExternalId__c, 
                                              LG_BillingAccount__r.Name, 
                                              csord__Service__r.LG_Address__c, 
                                              csord__Service__r.LG_Address__r.Name, 
                                              csord__Service__r.LG_Address__r.cscrm__Street__c, 
                                              csord__Service__r.LG_Address__r.LG_HouseNumber__c, 
                                              csord__Service__r.LG_Address__r.LG_HouseNumberExtension__c, 
                                              csord__Service__r.LG_Address__r.cscrm__Zip_Postal_Code__c, 
                                              csord__Service__r.LG_Address__r.cscrm__City__c, 
                                              csord__Service__r.LG_Address__r.LG_Footprint__c,
                                              csord__Service__r.LG_Address__r.LG_TechnicalContact__c, 
                                              csord__Service__r.LG_Address__r.LG_TechnicalContact__r.Name,
                                              csord__Service__r.LG_Address__r.LG_TechnicalContact__r.Id    
                                              from csord__Service_Line_Item__c where 
                                              csord__Service__r.csord__Subscription__c IN: subscriptionIdList AND 
                                              csord__Service__r.LG_OrderNumber__c != null AND 
                                              csord__Service__r.LG_OrderNumber__c != '' AND 
                                              csord__Is_Recurring__c = True AND 
                                              LG_ToBeSent__c =: toBeSentForServiceLineItems_Small];
                                              
                for(csord__Service_Line_Item__c sli: serviceLineItemListFetched){
                    
                    if(orderNumberServiceLineItemMap.containsKey(sli.csord__Service__r.LG_OrderNumber__c)){
                        orderNumberServiceLineItemMap.get(sli.csord__Service__r.LG_OrderNumber__c).add(sli);
                    }
                    else{
                        orderNumberServiceLineItemMap.put(sli.csord__Service__r.LG_OrderNumber__c, new List<csord__Service_Line_Item__c>{sli});
                    }
                    
                    orderNumberAccountIdMap.put(sli.csord__Service__r.LG_OrderNumber__c, sli.csord__Service__r.csord__Subscription__r.csord__Account__c);
                    orderNumberOpportunityIdMap.put(sli.csord__Service__r.LG_OrderNumber__c, sli.csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__c);
                    productConfigurationIdSet.add(sli.csord__Service__r.csordtelcoa__Product_Configuration__c); 
                    
                    if(orderNumberProductConfigurationIdMap.containsKey(sli.csord__Service__r.LG_OrderNumber__c)){
                        orderNumberProductConfigurationIdMap.get(sli.csord__Service__r.LG_OrderNumber__c).add(sli.csord__Service__r.csordtelcoa__Product_Configuration__c);
                    }
                    else{
                        orderNumberProductConfigurationIdMap.put(sli.csord__Service__r.LG_OrderNumber__c, new Set<string>{sli.csord__Service__r.csordtelcoa__Product_Configuration__c});
                    }
                    
                    orderNumberSet.add(sli.csord__Service__r.LG_OrderNumber__c);
                    
                    if(sli.LG_Type__c == serviceLineItemType_Product){
                        setOfProductLevelServiceIds.add(sli.csord__Service__c);
                    }   
                    if(sli.LG_Type__c == serviceLineItemType_AddOn){
                        setOfAddOnLevelServiceIds.add(sli.csord__Service__c);
                    }
                    
                    if(sli.csord__Service__r.LG_ChangeType__c == 'Move' || sli.csord__Service__r.LG_ChangeType__c == 'Change' ){
                        string replacedOrderNumber = '';
                        if(subscriptionIdOrderNumberMap.get(sli.csord__Service__r.csord__Subscription__r.csordtelcoa__Replaced_Subscription__c) != null){
                            replacedOrderNumber = subscriptionIdOrderNumberMap.get(sli.csord__Service__r.csord__Subscription__r.csordtelcoa__Replaced_Subscription__c);
                        }
                        replacedOrderNumberSet.add(replacedOrderNumber);
                        replacedOrderMovedOrderMap.put(replacedOrderNumber, sli.csord__Service__r.LG_OrderNumber__c);
                    }
                    
                    if(sli.csord__Service__r.LG_ChangeType__c == 'Migrate'){
                        subscriptionIdPremiseIdMap.put(sli.csord__Service__r.csord__Subscription__c, sli.csord__Service__r.LG_Address__c);
                        subscriptionIdSetForMigrate.add(sli.csord__Service__r.csord__Subscription__c);
                        opportunityIdSetForMigrate.add(sli.csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__c);
                    }
                    
                    orderNumberTechnicalContactMap.put(sli.csord__Service__r.LG_OrderNumber__c, sli.csord__Service__r.LG_Address__r.LG_TechnicalContact__r);            
                }
                
                setOfAddOnLevelServiceIds.removeAll(setOfProductLevelServiceIds);
                
                if(opportunityIdSetForMigrate.size() > 0){
                    productBasketListFetchedForMigrate = [Select Id, cscfga__Opportunity__c from cscfga__Product_Basket__c where cscfga__Opportunity__c IN: opportunityIdSetForMigrate
                                                          AND csordtelcoa__Synchronised_with_Opportunity__c = True];
                    for(cscfga__Product_Basket__c pb: productBasketListFetchedForMigrate){
                        productbasketIdListForMigrate.add(pb.Id);
                    }
                }
                
                if(productbasketIdListForMigrate.size() > 0){
                    associationListFetchedForMigrate = [Select Id, csordtelcoa__Product_Basket__c, csordtelcoa__Subscription__c, csordtelcoa__Subscription__r.LG_Address__c 
                                                        from csordtelcoa__Subscr_MACDProductBasket_Association__c
                                                        where csordtelcoa__Product_Basket__c IN: productbasketIdListForMigrate];
                    for(csordtelcoa__Subscr_MACDProductBasket_Association__c macdAssoc: associationListFetchedForMigrate){
                        premiseIdSubscriptionIdMapForMigrate.put(macdAssoc.csordtelcoa__Subscription__r.LG_Address__c, macdAssoc.csordtelcoa__Subscription__c);
                    } 
                }
                
                for(string subId: subscriptionIdSetForMigrate){
                    
                    string premiseId = '';
                    if(subscriptionIdPremiseIdMap.get(subId) != null){
                        premiseId = subscriptionIdPremiseIdMap.get(subId);
                    }
                    if(premiseIdSubscriptionIdMapForMigrate.containsKey(premiseId)){
                        string oldSubscriptionId = premiseIdSubscriptionIdMapForMigrate.get(premiseId);
                        if(subscriptionIdOrderNumberMap.get(oldSubscriptionId) != null && subscriptionIdOrderNumberMap.get(subId) != null){
                            replacedOrderMovedOrderMap.put(subscriptionIdOrderNumberMap.get(oldSubscriptionId), subscriptionIdOrderNumberMap.get(subId));
                            replacedOrderNumberSet.add(subscriptionIdOrderNumberMap.get(oldSubscriptionId));
                        }
                    }
                }                                   
                
                
                //fetch portingNumber records  
                portingNumberListFetched = [Select Id, LG_PhoneNumber__c, LG_InDirectory__c, LG_DirectoryListingName__c, LG_ProductConfiguration__c 
                                            from LG_PortingNumber__c where LG_ProductConfiguration__c IN: productConfigurationIdSet AND LG_InDirectory__c = 'true'];
                
                for(LG_PortingNumber__c pn: portingNumberListFetched){
                    if(productConfigIdPortingNumberMap.containsKey(pn.LG_ProductConfiguration__c)){
                        productConfigIdPortingNumberMap.get(pn.LG_ProductConfiguration__c).add(pn);
                    }
                    else{
                        productConfigIdPortingNumberMap.put(pn.LG_ProductConfiguration__c, new List<LG_PortingNumber__c>{pn});
                    }
                    
                    prodConfigSetWithPhoneNumber.add(pn.LG_ProductConfiguration__c);
                    
                }
                
                map<string, csord__Service__c> productConfigIdServiceMap = new map<string, csord__Service__c>();
                for(csord__Service__c serv: serviceListFetched){
                    if(prodConfigSetWithPhoneNumber.contains(serv.csordtelcoa__Product_Configuration__c)){
                        productConfigIdServiceMap.put(serv.csordtelcoa__Product_Configuration__c, serv);
                    }
                }
                
                for(string s: orderNumberSet){
                    
                    orderData orderDataObj_Small = new orderData();
                    
                    string accountId = '';
                    string opportunityId = '';
                    
                    if(orderNumberAccountIdMap.get(s) != null){
                        accountId = orderNumberAccountIdMap.get(s);
                    }
                    if(orderNumberOpportunityIdMap.get(s) != null){
                        opportunityId = orderNumberOpportunityIdMap.get(s);
                    }
                    
                    //populating the LG_Account class variables
                    orderDataObj_Small.accountDetail = new LG_Account();
                    LG_Account wsAccount = new LG_Account();
                    wsAccount.Name = accountMap.get(accountId).Name;
                    wsAccount.CustomAccountNumber = accountMap.get(accountId).LG_CustomAccountNumber__c;
                    wsAccount.Phone = accountMap.get(accountId).Phone;
                    wsAccount.Fax = accountMap.get(accountId).Fax;
                    wsAccount.Website = accountMap.get(accountId).Website;
                    wsAccount.ChamberOfCommerceNumber = accountMap.get(accountId).LG_ChamberOfCommerceNumber__c;
                    wsAccount.ExternalAccountID = accountMap.get(accountId).LG_ExternalID__c;
                    wsAccount.VisitCountry = accountMap.get(accountId).LG_VisitCountry__c;
                    wsAccount.VisitPostalCode = accountMap.get(accountId).LG_VisitPostalCode__c;
                    wsAccount.VisitHouseNumber = accountMap.get(accountId).LG_VisitHouseNumber__c;
                    wsAccount.VisitStreet = accountMap.get(accountId).LG_VisitStreet__c;
                    wsAccount.VisitHouseNumberExtension = accountMap.get(accountId).LG_VisitHouseNumberExtension__c;
                    wsAccount.VisitCity = accountMap.get(accountId).LG_VisitCity__c;
                    wsAccount.PostalCountry = accountMap.get(accountId).LG_PostalCountry__c;
                    wsAccount.PostalPostalCode = accountMap.get(accountId).LG_PostalPostalCode__c;
                    wsAccount.PostalHouseNumber = accountMap.get(accountId).LG_PostalHouseNumber__c;
                    wsAccount.PostalStreet = accountMap.get(accountId).LG_PostalStreet__c;
                    wsAccount.PostalHouseNumberExtension = accountMap.get(accountId).LG_PostalHouseNumberExtension__c;
                    wsAccount.PostalCity = accountMap.get(accountId).LG_PostalCity__c;
                    if(opportunityIdAdministrativeContactRoleMap.get(opportunityId) != null){
                        wsAccount.EmailAdministrativeContact = opportunityIdAdministrativeContactRoleMap.get(opportunityId).contact.Email;
                    }
                    orderDataObj_Small.accountDetail = wsAccount;
                    
                    //populating the LG_Contact class variables
                    orderDataObj_Small.accountDetail.contactList = new List<LG_Contact>();
                    List<contact> contactListForAccount = new List<contact>();
                    if(accountIdContactMap.containsKey(accountId)){
                        contactListForAccount = accountIdContactMap.get(accountId);
                    }
                    for(contact con: contactListForAccount){
                        LG_Contact wsContact = new LG_Contact();
                        wsContact.Name = con.Name;
                        wsContact.FirstName = con.FirstName;
                        wsContact.LastName = con.LastName;
                        wsContact.Salutation = con.Salutation;
                        wsContact.Phone = con.Phone;
                        wsContact.MobilePhone = con.MobilePhone;
                        wsContact.Fax = con.Fax;
                        wsContact.Email = con.Email;
                        wsContact.TechnicalContact = 'No';
                        wsContact.CommercialContact = 'No';
                        wsContact.FinancialContact = 'No';
              
                        if(orderNumberTechnicalContactMap.get(s) != null){
                            if(orderNumberTechnicalContactMap.get(s).Id == con.Id){
                                wsContact.TechnicalContact = 'Yes';
                            }
                        }
                        if(contactIdContactRoleSetMap.containsKey(con.Id)){
                            set<string> roleSet = new set<string>();
                            roleSet = contactIdContactRoleSetMap.get(con.Id);
                            if(roleSet.contains(administrativeContactRole)){
                                wsContact.CommercialContact = 'Yes';
                            }
                            if(roleSet.contains(financialContactRole)){
                                wsContact.FinancialContact = 'Yes';
                            }
                        }
                        wsContact.Birthdate = con.Birthdate;
                        orderDataObj_Small.accountDetail.contactList.add(wsContact);
                    }
                    
                    //populating the LG_BillingAccount class variables
                    orderDataObj_Small.accountDetail.billingAccountList = new List<LG_BillingAccount>();
                    List<csconta__Billing_Account__c> billingAccountListForAccount = new List<csconta__Billing_Account__c>();
                    if(accountIdBillingAccountMap.containsKey(accountId)){
                        billingAccountListForAccount = accountIdBillingAccountMap.get(accountId);
                    }
                    for(csconta__Billing_Account__c ba: billingAccountListForAccount){
                        LG_BillingAccount wsBillingAccount = new LG_BillingAccount();
                        wsBillingAccount.BankAccountHolder = ba.LG_BankAccountHolder__c;
                        wsBillingAccount.ExternalID = ba.LG_ExternalId__c;
                        wsBillingAccount.CustomerExternalID = ba.LG_ExternalID__c;
                        wsBillingAccount.PaymentType = ba.LG_PaymentType__c;
                        wsBillingAccount.PaymentTerms = ba.csconta__Payment_Terms__c;
                        wsBillingAccount.BillingAccountNumber = ba.Name;
                        wsBillingAccount.CustomerReference = ba.LG_CustomerReference__c;
                        wsBillingAccount.BillingEmailAddress = ba.LG_BillingEmailAddress__c;
                        wsBillingAccount.BillingChannel = ba.csconta__Billing_Channel__c;
                        wsBillingAccount.BankAccountNumberIBAN = ba.LG_BankAccountNumberIBAN__c;
                        wsBillingAccount.FormatType = ba.csconta__Format_Type__c;
                        wsBillingAccount.Street = ba.csconta__Street__c;
                        wsBillingAccount.HouseNumber = ba.LG_HouseNumber__c;
                        wsBillingAccount.HouseNumberExtension = ba.LG_HouseNumberExtension__c;
                        wsBillingAccount.Postcode = ba.csconta__Postcode__c;
                        wsBillingAccount.City = ba.csconta__City__c;
                        wsBillingAccount.Country = ba.csconta__Country__c;
                        orderDataObj_Small.accountDetail.billingAccountList.add(wsBillingAccount);
                    }

                    List<csord__Service_Line_Item__c> serviceLineItemListForOrder = new List<csord__Service_Line_Item__c>(); 
                    if(orderNumberServiceLineItemMap.get(s) != null){
                        serviceLineItemListForOrder = orderNumberServiceLineItemMap.get(s);
                    }
                    
                    
                    
                    //populating the LG_OrderDetail class variables
                    for(csord__Service_Line_Item__c sli: serviceLineItemListForOrder){
                        if(sli.LG_Type__c == serviceLineItemType_Product){
                            
                            string clientNumber = sli.csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_ClientNumber__c; 
                            string existingSubscription = sli.csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_ExistingSubscription__c; 
                            string dtv = sli.csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_DTV__c; 
                            string ipaddress = sli.csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_IPAddress__c; 
                            string telephony = sli.csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.LG_Telephony__c;
                            
                            orderDataObj_Small.orderDetail = new LG_OrderDetail();
                            LG_OrderDetail wsOrderDetail = new LG_OrderDetail();
                            wsOrderDetail.OrderNumber = sli.csord__Service__r.LG_OrderNumber__c;
                            wsOrderDetail.CustomAccountNumber = sli.csord__Service__r.csord__Subscription__r.csord__Account__r.LG_CustomAccountNumber__c;
                            wsOrderDetail.ExternalAccountID = sli.csord__Service__r.csord__Subscription__r.csord__Account__r.LG_ExternalID__c;
                            wsOrderDetail.OpportunityName = sli.csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.Name;
                            wsOrderDetail.BillingAccountPaymentType = sli.LG_BillingAccount__r.LG_PaymentType__c;
                            wsOrderDetail.PreferredInstallationDate = sli.csord__Service__r.LG_InstallationWishDate__c;
                            wsOrderDetail.ContractTerm = string.valueOf(sli.csord__Service__r.LG_ContractTerm__c);
                            wsOrderDetail.OpportunityOwner = sli.csord__Service__r.csord__Order__r.csordtelcoa__Opportunity__r.Owner.Name;
                            wsOrderDetail.ChangeTypeCode = sli.csord__Service__r.LG_ChangeTypeCode__c;
                            
                            string remark = '';
                            if(clientNumber != null && existingSubscription != null && existingSubscription != 'N/A'){
                                remark = 'Existing Client Number: ' + clientNumber + '. ' + 'Existing Subscription: ' + existingSubscription + '. ';
                                remark = remark + 'Existing DTV: ' + dtv + '. ';
                                remark = remark + 'Existing IP Address: ' + ipaddress + '. ';
                                remark = remark + 'Existing Telephony: ' + telephony + '. ';
                            }
                            wsOrderDetail.Remark = remark;
                            
                            if(opportunityIdAdministrativeContactRoleMap.get(opportunityId) != null){
                                wsOrderDetail.CommercialContact = opportunityIdAdministrativeContactRoleMap.get(opportunityId).contact.Name;
                            }
                            if(orderNumberTechnicalContactMap.get(s) != null){
                                wsOrderDetail.TechnicalContact = orderNumberTechnicalContactMap.get(s).Name;
                            }
                            orderDataObj_Small.orderDetail = wsOrderDetail;
                            orderDataObj_Small.orderDetail.orderLineList = new List<LG_OrderLine>();
                            orderDetailMap.put(sli.csord__Service__r.LG_OrderNumber__c, wsOrderDetail);
                            break;
                        }
                    }
                    
                    
                    boolean moveOrder = false;
                    for(csord__Service_Line_Item__c sli: serviceLineItemListForOrder){
                        if(sli.LG_Type__c == serviceLineItemType_Product){
                            string changeTypeCode = sli.csord__Service__r.LG_ChangeTypeCode__c;
                            if(changeTypeCode == '405'){
                                moveOrder = True;
                            }
                        }
                    }                    
                    
                    if(moveOrder == True){
                        orderDataObj_Small.orderDetail.ChangeTypeCode = '405';
                    }
                    
                    map<string, LG_OrderLine> orderLineMap = new map<string, LG_OrderLine>();
                    map<string, LG_AddOns> addOnMap = new map<string, LG_AddOns>();
                    
                    for(csord__Service_Line_Item__c sli: serviceLineItemListForOrder){
                    
                        
                        if(sli.LG_Type__c == serviceLineItemType_Product){
                            
                            LG_OrderLine wsOrderLine = new LG_OrderLine();
                            wsOrderLine.BillingAccountExternalId = sli.LG_BillingAccount__r.LG_ExternalId__c;
                            wsOrderLine.BillingAccountNumber = sli.LG_BillingAccount__r.Name;
                            wsOrderLine.SubscriptionName = sli.csord__Service__r.LG_ExternalSubscriptionName__c;
                            wsOrderLine.ServiceName = sli.LG_ExternalServiceName__c;
                            wsOrderLine.ExternalPriceName = sli.LG_ExternalPriceName__c;
                            wsOrderLine.PremiseName = sli.csord__Service__r.LG_Address__r.Name;
                            wsOrderLine.PremiseStreet = sli.csord__Service__r.LG_Address__r.cscrm__Street__c;
                            wsOrderLine.PremiseHouseNumber = sli.csord__Service__r.LG_Address__r.LG_HouseNumber__c;
                            wsOrderLine.PremiseHouseNumberExtension = sli.csord__Service__r.LG_Address__r.LG_HouseNumberExtension__c;
                            wsOrderLine.PremiseZIPPostalCode = sli.csord__Service__r.LG_Address__r.cscrm__Zip_Postal_Code__c;
                            wsOrderLine.PremiseCity = sli.csord__Service__r.LG_Address__r.cscrm__City__c;
                            wsOrderLine.PremiseFootprint = sli.csord__Service__r.LG_Address__r.LG_Footprint__c;
                            wsOrderLine.SubscriptionPublicId = sli.csord__Service__r.csord__Subscription__r.csordtelcoa__Subscription_Number__c;
                            wsOrderLine.ServicePublicId = sli.csord__Service__r.csordtelcoa__Service_Number__c;
                            wsOrderLine.SubscriptionExternalId = sli.csord__Service__r.csord__Subscription__r.LG_SubscriptionExternalId__c;
                            wsOrderLine.ServiceExternalId = sli.csord__Service__r.LG_ServiceExternalId__c;
                            if(sli.csord__Service__r.csord__Subscription__r.csord__Status__c == subscriptionStatusForTerminationRequested){
                                wsOrderLine.contractstatus = '4';
                            }
                            orderDataObj_Small.orderDetail.orderLineList.add(wsOrderLine);
                            wsOrderLine.addOnList = new List<LG_AddOns>();
                            wsOrderLine.discountList = new List<LG_Discounts>();
                            wsOrderLine.phoneNumberList = new List<LG_PhoneNumbers>();
                            orderLineMap.put(sli.csord__Service__r.csord__Subscription__c, wsOrderLine);
                        }
                    }

                    for(csord__Service_Line_Item__c sli: serviceLineItemListForOrder){
                        
                        if(sli.LG_Type__c == serviceLineItemType_AddOn){
                            
                            LG_AddOns wsAddOn = new LG_AddOns();
                            wsAddOn.ExternalSubscriptionName = sli.csord__Service__r.LG_ExternalSubscriptionName__c;
                            wsAddOn.ExternalServiceName = sli.LG_ExternalServiceName__c;
                            wsAddOn.Quantity = sli.LG_Quantity__c;
                            wsAddOn.ServiceLineItemExternalDescription = sli.LG_ExternalDescription__c;
                            wsAddOn.ServiceLineItemPriceName = sli.LG_ExternalPriceName__c;
                            wsAddOn.ServiceLineItemLineNumber = sli.csord__Line_Number__c;
                            wsAddOn.ServiceLineItemExternalID = sli.LG_ServiceLineItemExternalId__c;
                            wsAddOn.Yes_No  = '';
                            if(sli.LG_ExternalServiceName__c != null && sli.LG_ExternalServiceName__c != ''){
                                if(sli.LG_ExternalServiceName__c.containsIgnoreCase('pin')){
                                    wsAddOn.Yes_No  = 'Yes';
                                }
                            }
                            wsAddOn.addOnDiscountList = new List<LG_Discounts>();
                            if(orderLineMap.get(sli.csord__Service__r.csord__Subscription__c) != null){
                                orderLineMap.get(sli.csord__Service__r.csord__Subscription__c).addOnList.add(wsAddOn);
                            }
                            addOnMap.put(sli.csord__Service__r.csord__Subscription__c,wsAddOn);
                        }
                    }
                    
                    for(csord__Service_Line_Item__c sli: serviceLineItemListForOrder){
                        
                        if(sli.LG_Type__c == serviceLineItemType_Discount){
                            
                            
                            string serviceId = '';
                            serviceId = sli.csord__Service__c;
                            if(setOfProductLevelServiceIds.contains(serviceId)){
                                LG_Discounts wsDiscount = new LG_Discounts();
                                wsDiscount.DiscountName = sli.LG_ExternalDescription__c;
                                if(orderLineMap.get(sli.csord__Service__r.csord__Subscription__c) != null){
                                    orderLineMap.get(sli.csord__Service__r.csord__Subscription__c).discountList.add(wsDiscount);
                                }
                            }
                            else if(setOfAddOnLevelServiceIds.contains(serviceId)){
                                LG_Discounts wsDiscount = new LG_Discounts();
                                wsDiscount.DiscountName = sli.LG_ExternalDescription__c;
                                if(orderLineMap.get(sli.csord__Service__r.csord__Subscription__c) != null){
                                    addOnMap.get(sli.csord__Service__r.csord__Subscription__c).addOnDiscountList.add(wsDiscount);
                                }
                            }
                            
                        }
                    }
                    
                    
                    for(string pcId: prodConfigSetWithPhoneNumber){
                        
                            
                        if(productConfigIdPortingNumberMap.get(pcId) != null){
                            
                            List<LG_PortingNumber__c> pnList = new List<LG_PortingNumber__c>();
                            pnList = productConfigIdPortingNumberMap.get(pcId);
                            for(LG_PortingNumber__c pn: pnList){
                                
                                LG_PhoneNumbers wsPhoneNumber = new LG_PhoneNumbers();
                                if(productConfigIdServiceMap.get(pcId) != null){
                                    wsPhoneNumber.AreaCodes = productConfigIdServiceMap.get(pcId).LG_AreaCodes__c;
                                    wsPhoneNumber.TypeOfPhoneRange = string.valueOf(productConfigIdServiceMap.get(pcId).LG_BlockType__c);
                                    wsPhoneNumber.DonorOperatorCode = productConfigIdServiceMap.get(pcId).LG_DonorOperatorCode__c;
                                    wsPhoneNumber.PortingName = productConfigIdServiceMap.get(pcId).LG_PortingName__c;
                                    wsPhoneNumber.PortingInitials = productConfigIdServiceMap.get(pcId).LG_PortingInitials__c;
                                    wsPhoneNumber.PortingPrefix = productConfigIdServiceMap.get(pcId).LG_PortingPrefix__c;
                                    wsPhoneNumber.PortingStreet = productConfigIdServiceMap.get(pcId).LG_PortingStreet__c;
                                    wsPhoneNumber.PortingHouseNumber = productConfigIdServiceMap.get(pcId).LG_PortingHouseNumber__c;
                                    wsPhoneNumber.PortingHouseNumberAddition = productConfigIdServiceMap.get(pcId).LG_PortingHouseNumberAddition__c;
                                    wsPhoneNumber.PortingZipcode = productConfigIdServiceMap.get(pcId).LG_PortingZipcode__c;
                                    wsPhoneNumber.PortingCity = productConfigIdServiceMap.get(pcId).LG_PortingCity__c;
                                    wsPhoneNumber.PortingWishDate = productConfigIdServiceMap.get(pcId).LG_PortingWishDate__c;
                                    wsPhoneNumber.CallBarringLevel = productConfigIdServiceMap.get(pcId).LG_CallBarringLevel__c;
                                    
                                    if(productConfigIdServiceMap.get(pcId).LG_CallerID__c.toLowerCase() == 'yes'){
                                        wsPhoneNumber.CallerID = 'Y';
                                    }
                                    else{
                                        wsPhoneNumber.CallerID = 'N';
                                    }
                                    
                                    if(productConfigIdServiceMap.get(pcId).LG_BNumberShielding__c.toLowerCase() == 'yes'){
                                        wsPhoneNumber.BNumberShielding = 'Y';
                                    }
                                    else{
                                        wsPhoneNumber.BNumberShielding = 'N';
                                    }
                                    
                                }
                                wsPhoneNumber.Phonenumbers = pn.LG_PhoneNumber__c;
                                wsPhoneNumber.DirectoryListingName = pn.LG_DirectoryListingName__c;
                                
                                if(pn.LG_InDirectory__c.toLowerCase() == 'true'){
                                    wsPhoneNumber.InDirectory = 'Y';
                                }
                                else{
                                    wsPhoneNumber.InDirectory = 'N';
                                }
                                
                                if(orderLineMap.get(productConfigIdServiceMap.get(pcId).csord__Subscription__c) != null){
                                    orderLineMap.get(productConfigIdServiceMap.get(pcId).csord__Subscription__c).phoneNumberList.add(wsPhoneNumber);
                                }
                            }
                        }
                    } 
                    
                    // adding objects to the final return list
                    returnDataObj.orderData.add(orderDataObj_Small);
                    
                } 
                
                set<orderData> orderDataElementSet = new set<orderData>(returnDataObj.orderData);
                
                List<orderData> orderDataElementToBeRemoved = new List<orderData>();
                for(orderData o: returnDataObj.orderData){
                    
                    if(o.orderDetail != null){
                        
                        string orderNumber = o.orderDetail.OrderNumber;
                        if(replacedOrderNumberSet.contains(orderNumber)){
                            
                            orderDataElementToBeRemoved.add(o);
                            
                            List<LG_OrderLine> orderLineListForReplacedSubscription = new List<LG_OrderLine>();
                            orderLineListForReplacedSubscription = o.orderDetail.orderLineList;
                            
                            string newOrderNumberForReplacedOrder = '';
                            if(replacedOrderMovedOrderMap.get(orderNumber) != null){
                                newOrderNumberForReplacedOrder = replacedOrderMovedOrderMap.get(orderNumber);
                            }
                            
                            if(orderDetailMap.get(newOrderNumberForReplacedOrder) != null){
                                orderDetailMap.get(newOrderNumberForReplacedOrder).orderLineList.addAll(orderLineListForReplacedSubscription);
                            }
                        }
                    }
                }

                
                orderDataElementSet.removeAll(orderDataElementToBeRemoved);
                List<orderData> orderDataList_Final = new List<orderData>(orderDataElementSet);
                returnDataObj.orderData = null;
                returnDataObj.orderData = orderDataList_Final;
                
                for(csord__Subscription__c sub: subscriptionListFetched){
                    if(sub.csord__Status__c == newSubscriptionStatus_Small){
                        sub.csord__Status__c = subscriptionStatusForInDelivery;
                        subscriptionListToUpdate.add(sub);
                    }
                    if(sub.csord__Status__c == subscriptionStatusForTerminationRequested){
                        sub.csord__Status__c = subscriptionStatusForTerminationInProgress;
                        subscriptionListToUpdate.add(sub);
                    }
                }
                for(csord__Service__c serv: serviceListFetched){
                    if(serv.csord__Status__c == newServiceStatus_Small){
                        serv.csord__Status__c = serviceStatusForInDelivery;
                        serviceListToUpdate.add(serv);
                    }
                    if(serv.csord__Status__c == serviceStatusForTerminationRequested){
                        serv.csord__Status__c = serviceStatusForTerminationInProgress;
                        serv.LG_ChangeType__c = changeTypeForTerminatedService;
                        serviceListToUpdate.add(serv);
                    }
                }
                for(csord__Order__c ord: orderListFetched){
                    if(ord.csord__Status2__c == orderStatusForSubmitted){
                        ord.csord__Status2__c = orderStatusForInDelivery; 
                        orderListToUpdate.add(ord);
                    }
                }
                
                if(subscriptionListToUpdate.size() > 0){
                    update subscriptionListToUpdate;
                }
                if(serviceListToUpdate.size() > 0){
                    update serviceListToUpdate;
                }
                if(orderListToUpdate.size() > 0){
                    update orderListToUpdate;
                }
            } // end of small logic
            
            
            
            if(orderType == 'soho' || orderType == 'all'){
                
                Set<string> opportunityIdSetForSoHo = new Set<string>();
                List<Opportunity> opportunityListFetchedForSoho = new List<Opportunity>();
                map<string, Opportunity> opportunityMapForSoho = new map<string, Opportunity>();
                List<OpportunityLineItem> opportunityLineItemListFetchedForSoho = new List<OpportunityLineItem>();
                List<OpportunityContactRole> opportunityContactRoleListFetchedForSoho = new List<OpportunityContactRole>(); 
                map<string, List<OpportunityLineItem>> opportunitytIdOpportunityLineItemMapForSoho = new map<string, List<OpportunityLineItem>>();
                map<string, List<OpportunityContactRole>> opportunitytIdContactRoleMapForSoho = new map<string, List<OpportunityContactRole>>();
                
                List<LG_ProductDetail__c> productDetailListFetchedForSoho = new List<LG_ProductDetail__c>(); 
                map<string, List<LG_ProductDetail__c>> opportunityIdProductDetailMapForSoho = new map<string, List<LG_ProductDetail__c>>();
                
                List<LG_PortingNumber__c> portingNumberListFetchedForSoho = new List<LG_PortingNumber__c>(); 
                map<string, List<LG_PortingNumber__c>> opportunityIdPortingNumberMapForSoho = new map<string, List<LG_PortingNumber__c>>();
                
                List<cscfga__Product_Configuration__c> productConfigurationListForSoHo = new List<cscfga__Product_Configuration__c>();
                Set<String> productConfigIdSetForSoHo = new Set<String>();
                Set<String> addressIdSetForSoHo = new Set<String>();
                map<String, string> productConfigIdOpportunityIdMapForSoHo = new map<String, string>();
                map<String, cscfga__Product_Configuration__c> productConfigIdMapForSoHo = new map<String, cscfga__Product_Configuration__c>();
            
                List<cscfga__Attribute_Field__c> attributeFieldListForSoho = new List<cscfga__Attribute_Field__c>();
                List<String> billingAccountIdListForSoHo = new List<String>();
                map<String,String> productConfigIdBillingAccountIdMapForSoHo = new map<String,String>();
                List<csconta__Billing_Account__c> billingAccountListForSoho = new List<csconta__Billing_Account__c>();
                map<String, csconta__Billing_Account__c> billingAccountMapForSoHo = new map<String, csconta__Billing_Account__c>();
                
                
                String soqlQueryForOli = 'select PricebookEntry.Name, TotalPrice, LG_OneOffPrice__c, LG_Type__c,LG_MainOLI__c, OpportunityId,  Opportunity.StageName, LG_Segment__c ';
                soqlQueryForOli = soqlQueryForoli + 'FROM OpportunityLineItem where Opportunity.StageName =: opportunityStage_SoHo AND LG_Segment__c =: segmentForOpportunityLineItems_SoHo ';
                soqlQueryForOli = soqlQueryForoli + 'AND Opportunity.CreatedDate = LAST_N_DAYS: ' + numberOfDays; 
                
                opportunityLineItemListFetchedForSoho = Database.query(soqlQueryForOli);
                for(OpportunityLineItem oli: opportunityLineItemListFetchedForSoho){
                    
                    opportunityIdSetForSoHo.add(oli.OpportunityId);
                    if(opportunitytIdOpportunityLineItemMapForSoho.containsKey(oli.OpportunityId)){
                        opportunitytIdOpportunityLineItemMapForSoho.get(oli.OpportunityId).add(oli);
                    }
                    else{
                        opportunitytIdOpportunityLineItemMapForSoho.put(oli.OpportunityId, new List<opportunityLineItem>{oli});
                    }
                }
                
                opportunityListFetchedForSoho = [SELECT Id,Type,Account.LG_Segment__c,Account.LG_Footprint__c,Description,Name,AccountId,Account.Name,Account.LG_ChamberOfCommerceNumber__c,Account.LG_CustomAccountNumber__c,
                LG_PreferredInstallationDate__c,LG_PreferredInstallationTime__c,LG_SharedOfficeBuilding__c,LG_COAXConnectionLocation__c,LG_ContractTermMonths__c,LG_PaymentType__c,Account.Phone,
                /*PartnerAccountId,PartnerAccount.Name,*//*LG_NEWSalesChannel__c,LG_BillingStreet__c,LG_BillingHouseNumber__c,LG_BillingHouseNumberExtension__c,LG_BillingPostalCode__c,
                LG_BillingCity__c,LG_BillingCountry__c,LG_BankAccountName__c,LG_BankNumber__c,LG_CustomerReference__c,LG_InstallationStreet__c,LG_InstallationHouseNumber__c,
                LG_InstallationHouseNumberExtension__c,LG_InstallationPostalCode__c,LG_InstallationCity__c,LG_InstallationCountry__c,LG_PostalStreet__c,LG_PostalHouseNumber__c,
                LG_PostalHouseNumberExtension__c,LG_PostalCode__c,LG_PostalCity__c,LG_PostalCountry__c, Account.LG_PostalStreet__c, Account.LG_PostalHouseNumber__c, Account.LG_PostalHouseNumberExtension__c,
                Account.LG_PostalPostalCode__c, Account.LG_PostalCity__c, Account.LG_PostalCountry__c  
                FROM Opportunity WHERE Id IN: opportunityIdSetForSoHo];
                
                
                for(Opportunity opp: opportunityListFetchedForSoho){
                    opportunityIdSetForSoho.add(opp.Id);
                    opportunityMapForSoho.put(opp.Id, opp);
                }
                
                
                
                productConfigurationListForSoHo = [Select Id, cscfga__Product_Basket__c, cscfga__Product_Basket__r.csordtelcoa__Synchronised_with_Opportunity__c,
                                                   LG_Address__c, LG_InstallationWishDate__c, cscfga__Contract_Term__c, cscfga__Parent_Configuration__c,   
                                                   cscfga__Product_Basket__r.cscfga__Opportunity__c, 
                                                   LG_Address__r.LG_Footprint__c, LG_Address__r.LG_SharedOfficeBuilding__c, LG_Address__r.LG_COAXConnectionLocation__c, 
                                                   LG_Address__r.cscrm__Street__c, LG_Address__r.cscrm__City__c, LG_Address__r.LG_HouseNumber__c, 
                                                   LG_Address__r.LG_HouseNumberExtension__c, LG_Address__r.cscrm__Zip_Postal_Code__c, LG_Address__r.cscrm__Country__c 
                                                   from cscfga__Product_Configuration__c where
                                                   cscfga__Product_Basket__r.cscfga__Opportunity__c IN: opportunityIdSetForSoho AND 
                                                   cscfga__Product_Basket__r.csordtelcoa__Synchronised_with_Opportunity__c = True AND 
                                                   cscfga__Parent_Configuration__c =  null];
                                                   
                for(cscfga__Product_Configuration__c pc: productConfigurationListForSoHo){
                    productConfigIdSetForSoHo.add(pc.Id);
                    productConfigIdMapForSoHo.put(pc.Id, pc);
                    productConfigIdOpportunityIdMapForSoHo.put(pc.cscfga__Product_Basket__r.cscfga__Opportunity__c, pc.Id);
                }
                
                attributeFieldListForSoho = [Select Name, cscfga__Attribute__r.cscfga__Product_Configuration__c, cscfga__Attribute__r.cscfga__Is_Line_Item__c, 
                                             cscfga__Value__c from cscfga__Attribute_Field__c where 
                                             Name =: attributeFieldNameForBillingAccount AND cscfga__Attribute__r.cscfga__Is_Line_Item__c = True AND 
                                             cscfga__Attribute__r.cscfga__Product_Configuration__c IN: productConfigIdSetForSoHo];
                
                
                for(cscfga__Attribute_Field__c af: attributeFieldListForSoho){
                    productConfigIdBillingAccountIdMapForSoHo.put(af.cscfga__Attribute__r.cscfga__Product_Configuration__c, af.cscfga__Value__c);
                    billingAccountIdListForSoHo.add(af.cscfga__Value__c);
                }
                
                
                billingAccountListForSoho = [Select Id, csconta__Street__c, csconta__City__c, csconta__Postcode__c, csconta__Country__c, LG_HouseNumber__c, LG_HouseNumberExtension__c,
                                             LG_BankAccountHolder__c, LG_BankAccountNumberIBAN__c, LG_CustomerReference__c, LG_PaymentType__c
                                             from csconta__Billing_Account__c where Id IN: billingAccountIdListForSoHo];
                for(csconta__Billing_Account__c ba: billingAccountListForSoho){
                    billingAccountMapForSoHo.put(ba.Id, ba);
                }
                
                opportunityContactRoleListFetchedForSoho = [SELECT Role, OpportunityId, Contact.Salutation, Contact.Name, Contact.LastName, Contact.Phone, Contact.MobilePhone, 
                                                     Contact.Fax, Contact.Email, Contact.Birthdate FROM OpportunityContactRole where OpportunityId IN: opportunityIdSetForSoHo];
                                                     
                for(OpportunityContactRole ocr: opportunityContactRoleListFetchedForSoho){
                    
                    if(opportunitytIdContactRoleMapForSoho.containsKey(ocr.OpportunityId)){
                        opportunitytIdContactRoleMapForSoho.get(ocr.OpportunityId).add(ocr);
                    }
                    else{
                        opportunitytIdContactRoleMapForSoho.put(ocr.OpportunityId, new List<OpportunityContactRole>{ocr});
                    }
                }
                
                productDetailListFetchedForSoho = [Select LG_Name__c, LG_Product__c, LG_Value__c, LG_Opportunity__c FROM LG_ProductDetail__c 
                                                   where LG_Opportunity__c IN: opportunityIdSetForSoHo];
                
                for(LG_ProductDetail__c pd: productDetailListFetchedForSoho){
                    
                    if(opportunityIdProductDetailMapForSoho.containsKey(pd.LG_Opportunity__c)){
                        opportunityIdProductDetailMapForSoho.get(pd.LG_Opportunity__c).add(pd);
                    }
                    else{
                        opportunityIdProductDetailMapForSoho.put(pd.LG_Opportunity__c, new List<LG_ProductDetail__c>{pd});
                    }
                }
                
                portingNumberListFetchedForSoho = [SELECT LG_PortingDate__c, LG_PhoneNumber__c, LG_Operator__c, LG_CustomerName__c, LG_InDirectory__c, LG_Opportunity__c  
                                                   FROM LG_PortingNumber__c where LG_Opportunity__c IN: opportunityIdSetForSoHo];
            
                for(LG_PortingNumber__c pn: portingNumberListFetchedForSoho){
                    
                    if(opportunityIdPortingNumberMapForSoho.containsKey(pn.LG_Opportunity__c)){
                        opportunityIdPortingNumberMapForSoho.get(pn.LG_Opportunity__c).add(pn);
                    }
                    else{
                        opportunityIdPortingNumberMapForSoho.put(pn.LG_Opportunity__c, new List<LG_PortingNumber__c>{pn});
                    }
                }
                
                
                
                for(string oppId: opportunityIdSetForSoHo){
                    
                    string productConfigId = '';
                    string billingAccountId = '';
                    
                    if(productConfigIdOpportunityIdMapForSoHo.get(oppId) != null){
                        productConfigId = productConfigIdOpportunityIdMapForSoHo.get(oppId);
                    }
                    
                    if(productConfigIdBillingAccountIdMapForSoHo.get(productConfigId) != null){
                        billingAccountId = productConfigIdBillingAccountIdMapForSoHo.get(productConfigId);
                    }
                    
                    orderData orderDataObj_SoHo = new orderData();
                    
                    //populating the LG_Opportunity class variables
                    orderDataObj_SoHo.opportunityDetail = new LG_Opportunity();
                    LG_Opportunity wsOpportunity = new LG_Opportunity();
                    wsOpportunity.Id = opportunityMapForSoho.get(oppId).Id;
                    wsOpportunity.Type = opportunityMapForSoho.get(oppId).Type;
                    wsOpportunity.Description= opportunityMapForSoho.get(oppId).Description;
                    wsOpportunity.Name = opportunityMapForSoho.get(oppId).Name;
                    wsOpportunity.AccountId = opportunityMapForSoho.get(oppId).Account.LG_CustomAccountNumber__c;
                    //wsOpportunity.PartnerAccountId = opportunityMapForSoho.get(oppId).PartnerAccountId;
                    //wsOpportunity.PartnerAccountName = opportunityMapForSoho.get(oppId).PartnerAccount.Name;
                    wsOpportunity.NEWSalesChannel = opportunityMapForSoho.get(oppId).LG_NEWSalesChannel__c;
                    
                    wsOpportunity.AccountName = opportunityMapForSoho.get(oppId).Account.Name;
                    wsOpportunity.AccountSegment = opportunityMapForSoho.get(oppId).Account.LG_Segment__c;
                    wsOpportunity.AccountPhone = opportunityMapForSoho.get(oppId).Account.Phone;
                    wsOpportunity.AccountChamberOfCommerce = opportunityMapForSoho.get(oppId).Account.LG_ChamberOfCommerceNumber__c;
                    wsOpportunity.PostalStreet = opportunityMapForSoho.get(oppId).Account.LG_PostalStreet__c;
                    wsOpportunity.PostalHouseNumber = opportunityMapForSoho.get(oppId).Account.LG_PostalHouseNumber__c;
                    wsOpportunity.PostalHouseNumberExtension = opportunityMapForSoho.get(oppId).Account.LG_PostalHouseNumberExtension__c;
                    wsOpportunity.PostalCode = opportunityMapForSoho.get(oppId).Account.LG_PostalPostalCode__c;
                    wsOpportunity.PostalCity = opportunityMapForSoho.get(oppId).Account.LG_PostalCity__c;
                    wsOpportunity.PostalCountry = opportunityMapForSoho.get(oppId).Account.LG_PostalCountry__c;
                    
                    if(billingAccountMapForSoHo.get(billingAccountId) != null){
                        wsOpportunity.BillingStreet = billingAccountMapForSoHo.get(billingAccountId).csconta__Street__c;
                        wsOpportunity.BillingHouseNumber = billingAccountMapForSoHo.get(billingAccountId).LG_HouseNumber__c;
                        wsOpportunity.BillingHouseNumberExtension = billingAccountMapForSoHo.get(billingAccountId).LG_HouseNumberExtension__c;
                        wsOpportunity.BillingPostalCode = billingAccountMapForSoHo.get(billingAccountId).csconta__Postcode__c;
                        wsOpportunity.BillingCity = billingAccountMapForSoHo.get(billingAccountId).csconta__City__c;
                        wsOpportunity.BillingCountry = billingAccountMapForSoHo.get(billingAccountId).csconta__Country__c;
                        wsOpportunity.BankAccountName = billingAccountMapForSoHo.get(billingAccountId).LG_BankAccountHolder__c;
                        wsOpportunity.BankNumber = billingAccountMapForSoHo.get(billingAccountId).LG_BankAccountNumberIBAN__c;
                        wsOpportunity.CustomerReference = billingAccountMapForSoHo.get(billingAccountId).LG_CustomerReference__c;
                        wsOpportunity.PaymentType = billingAccountMapForSoHo.get(billingAccountId).LG_PaymentType__c;
                    }

                    if(productConfigIdMapForSoHo.get(productConfigId) != null){
                        wsOpportunity.PreferredInstallationDate = productConfigIdMapForSoHo.get(productConfigId).LG_InstallationWishDate__c;
                        wsOpportunity.ContractTermMonths = string.ValueOf(productConfigIdMapForSoHo.get(productConfigId).cscfga__Contract_Term__c);
                        wsOpportunity.InstallationStreet = productConfigIdMapForSoHo.get(productConfigId).LG_Address__r.cscrm__Street__c;
                        wsOpportunity.InstallationHouseNumber = productConfigIdMapForSoHo.get(productConfigId).LG_Address__r.LG_HouseNumber__c;
                        wsOpportunity.InstallationHouseNumberExtension = productConfigIdMapForSoHo.get(productConfigId).LG_Address__r.LG_HouseNumberExtension__c;
                        wsOpportunity.InstallationPostalCode = productConfigIdMapForSoHo.get(productConfigId).LG_Address__r.cscrm__Zip_Postal_Code__c;
                        wsOpportunity.InstallationCity = productConfigIdMapForSoHo.get(productConfigId).LG_Address__r.cscrm__City__c;
                        wsOpportunity.InstallationCountry = productConfigIdMapForSoHo.get(productConfigId).LG_Address__r.cscrm__Country__c;
                        wsOpportunity.SharedOfficeBuilding = productConfigIdMapForSoHo.get(productConfigId).LG_Address__r.LG_SharedOfficeBuilding__c;
                        wsOpportunity.COAXConnectionLocation = productConfigIdMapForSoHo.get(productConfigId).LG_Address__r.LG_COAXConnectionLocation__c;
                        wsOpportunity.FootPrint = productConfigIdMapForSoHo.get(productConfigId).LG_Address__r.LG_Footprint__c;
                    }

                    orderDataObj_SoHo.opportunityDetail = wsOpportunity;
                    
                    //populating the LG_OpportunityLineItem class variables
                    orderDataObj_SoHo.opportunityDetail.opportunityLineItemList = new List<LG_OpportunityLineItem>();
                    List<OpportunityLineItem> opportunityLineItemListForOpportunity = new List<OpportunityLineItem>();
                    if(opportunitytIdOpportunityLineItemMapForSoho.containsKey(oppId)){
                        opportunityLineItemListForOpportunity = opportunitytIdOpportunityLineItemMapForSoho.get(oppId);
                    }
                    
                    for(OpportunityLineItem oli: opportunityLineItemListForOpportunity){
                        LG_OpportunityLineItem wsOpportunityLineItem = new LG_OpportunityLineItem();
                        wsOpportunityLineItem.PricebookEntryName = oli.PricebookEntry.Name;
                        wsOpportunityLineItem.TotalPrice = String.valueOf(oli.TotalPrice);
                        wsOpportunityLineItem.OneOffPrice = String.valueOf(oli.LG_OneOffPrice__c);
                        wsOpportunityLineItem.Type = oli.LG_Type__c;
                        wsOpportunityLineItem.MainOLI = oli.LG_MainOLI__c;
                        orderDataObj_SoHo.opportunityDetail.opportunityLineItemList.add(wsOpportunityLineItem);
                    }
                    
                    
                    
                    //populating the LG_OpportunityContactRole class variables
                    orderDataObj_SoHo.opportunityDetail.opportunityContactRoleList = new List<LG_OpportunityContactRole>();
                    List<OpportunityContactRole> opportunityContactRoleListForOpportunity = new List<OpportunityContactRole>();
                    if(opportunitytIdContactRoleMapForSoho.containsKey(oppId)){
                        opportunityContactRoleListForOpportunity = opportunitytIdContactRoleMapForSoho.get(oppId);
                    }
                    
                    for(OpportunityContactRole ocr: opportunityContactRoleListForOpportunity){
                        LG_OpportunityContactRole wsOpportunityContactRole = new LG_OpportunityContactRole();
                        wsOpportunityContactRole.Role = ocr.Role;
                        wsOpportunityContactRole.Name = ocr.Contact.Name;
                        wsOpportunityContactRole.Salutation = ocr.Contact.Salutation;
                        wsOpportunityContactRole.LastName = ocr.Contact.LastName;
                        wsOpportunityContactRole.Phone = ocr.Contact.Phone;
                        wsOpportunityContactRole.MobilePhone = ocr.Contact.MobilePhone;
                        wsOpportunityContactRole.Fax = ocr.Contact.Fax;
                        wsOpportunityContactRole.Email = ocr.Contact.Email;
                        wsOpportunityContactRole.Birthdate = ocr.Contact.Birthdate;
                        orderDataObj_SoHo.opportunityDetail.opportunityContactRoleList.add(wsOpportunityContactRole);
                    }
                    
                    
                    //populating the LG_ProductDetail class variables
                    orderDataObj_SoHo.opportunityDetail.productDetailList = new List<LG_ProductDetail>();
                    List<LG_ProductDetail__c> productDetailListForOpportunity = new List<LG_ProductDetail__c>();
                    if(opportunityIdProductDetailMapForSoho.containsKey(oppId)){
                        productDetailListForOpportunity = opportunityIdProductDetailMapForSoho.get(oppId);
                    }
                    
                    for(LG_ProductDetail__c pd: productDetailListForOpportunity){
                        LG_ProductDetail wsProductDetail = new LG_ProductDetail();
                        wsProductDetail.Name = pd.LG_Name__c;
                        wsProductDetail.Product = pd.LG_Product__c;
                        wsProductDetail.Value = pd.LG_Value__c;
                        orderDataObj_SoHo.opportunityDetail.productDetailList.add(wsProductDetail);
                    }
                    
                    //populating the LG_PortingNumbersForSoho class variables
                    orderDataObj_SoHo.opportunityDetail.portingNumberList = new List<LG_PortingNumbersForSoho>();
                    List<LG_PortingNumber__c> portingNumberListForOpportunity = new List<LG_PortingNumber__c>();
                    if(opportunityIdPortingNumberMapForSoho.containsKey(oppId)){
                        portingNumberListForOpportunity = opportunityIdPortingNumberMapForSoho.get(oppId);
                    }
                    
                    for(LG_PortingNumber__c pn: portingNumberListForOpportunity){
                        LG_PortingNumbersForSoho wsPortingNumber = new LG_PortingNumbersForSoho();
                        wsPortingNumber.PortingDate = pn.LG_PortingDate__c;
                        wsPortingNumber.PhoneNumber = pn.LG_PhoneNumber__c;
                        wsPortingNumber.Operator = pn.LG_Operator__c;
                        wsPortingNumber.CustomerName = pn.LG_CustomerName__c;
                        wsPortingNumber.InDirectory = pn.LG_InDirectory__c;
                        orderDataObj_SoHo.opportunityDetail.portingNumberList.add(wsPortingNumber);
                    }
                    
                    
                    // adding objects to the final return list
                    returnDataObj.orderData.add(orderDataObj_SoHo);
                }
                
            } // end of soho logic
            
        }
        
        catch(Exception e) {
            returnDataObj.status= 'Error';
            string errorMessage = e.getMessage();
            errorMessage = errorMessage + '\nStack Trace:-- ' + e.getStackTraceString();
            returnDataObj.error = String.valueof(errorMessage);
        }
        
        return returnDataObj;
    }*/
    public void method(){
    
    }
}