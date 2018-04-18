/*******************************************************************************************************************************************
* File Name     :  LG_CreateDataFromDWHFeedControllerTest
* Description   :  Test class for LG_CreateDataFromDWHFeedController, LG_CreateAttributesForProducts, LG_CreateDataFromDWHFeedBatch,  
                   LG_CreateDataFromDWHFeedSchedulable and LG_ManuallySyncDataFromDWH

* @author       :   Shreyas
* Modification Log
===================================================================================================
* Ver.    Date          Author              Modification
---------------------------------------------------------------------------------------------------
* 1.0     29th-Feb-16    Shreyas             Created the class for release R1*
********************************************************************************************************************************************/
/*******************************************************************************************************************************************************************
					Class is commented as Class specific to Ziggo,not used in UM
**********************************************************************************************************************************************************/
@isTest /* (SeeAllData = True) */
private class LG_CreateDataFromDWHFeedControllerTest {
    static testmethod void TestMethod1(){
        LG_CreateDataFromDWHFeedController.dummy();
        //Main class is commented as Class specific to Ziggo,not used in UM
       
    }
    
    
    /*

    @testSetup static void prepareCustomSettings() {

        List<LG_DWHIntegrationVariables__c> settings = new List<LG_DWHIntegrationVariables__c>();

        LG_DWHIntegrationVariables__c setting = new LG_DWHIntegrationVariables__c();
        setting.Name = 'Limit_on_Accounts_Fetched';
        setting.LG_Type__c = 'Other_Hard_Coded_Values';
        setting.LG_DisplayValue__c = '1';
        settings.add( setting );

        setting = new LG_DWHIntegrationVariables__c();
        setting.Name = 'ProductCategory_Internet';
        setting.LG_Type__c = 'Product_Category';
        setting.LG_DisplayValue__c = 'Internet';
        settings.add( setting );

        setting = new LG_DWHIntegrationVariables__c();
        setting.Name = 'ProductCategory_LegacyProducts';
        setting.LG_Type__c = 'Product_Category';
        setting.LG_DisplayValue__c = 'Legacy Products';
        settings.add( setting );

        setting = new LG_DWHIntegrationVariables__c();
        setting.Name = 'ProductCategory_LegacyRelatedProducts';
        setting.LG_Type__c = 'Product_Category';
        setting.LG_DisplayValue__c = 'Legacy Related Products';
        settings.add( setting );

        setting = new LG_DWHIntegrationVariables__c();
        setting.Name = 'ProductCategory_RelatedProducts';
        setting.LG_Type__c = 'Product_Category';
        setting.LG_DisplayValue__c = 'Related Products';
        settings.add( setting );

        setting = new LG_DWHIntegrationVariables__c();
        setting.Name = 'ProductCategory_Telephony';
        setting.LG_Type__c = 'Product_Category';
        setting.LG_DisplayValue__c = 'Telephony';
        settings.add( setting );

        insert settings;            
    }

    /*
        Name: TestMethod1_ConnectMKB_and_Pin
        Purpose: Test method for testing the logic for syncing Connect MKB and Pin
        Argument: none
        Return type: none
    
    static testmethod void TestMethod1_ConnectMKB_and_Pin() {

        /*LG_DWHIntegrationVariables__c dwhVar = new LG_DWHIntegrationVariables__c();
        dwhVar = [Select Id, Name from LG_DWHIntegrationVariables__c where Name = 'Limit_on_Accounts_Fetched'];
        dwhVar.LG_DisplayValue__c = '1';
        update dwhVar;*/
       /* 
        List<LG_DWHFeedStagingTable__c> dwhInsertList = new List<LG_DWHFeedStagingTable__c>();
        string userId = userInfo.getuserId();
        
        string transactionId = generateRandomNumber();
        transactionId = transactionId + '1';
        
        string externalId_Account = generateRandomNumber();
        externalId_Account = externalId_Account + '11_Account';
        
        //initializing the account DWH data
        LG_DWHFeedStagingTable__c dwh_account1 = new LG_DWHFeedStagingTable__c();
        dwh_account1.LG_Status__c = 'New';
        dwh_account1.LG_TypeofRecord__c = 'Account';
        dwh_account1.LG_AccountName__c = 'DWH Test Account Only For TestClassCoverage';
        dwh_account1.LG_AccountPhone__c = '00001111';
        dwh_account1.LG_DWHTransactionId__c = transactionId;
        dwh_account1.LG_AccountExternalId__c = externalId_Account;
        dwh_account1.LG_AccountOwnerId__c = userId;
        string chamberOfCommerce = generateRandomNumberForChamberOfCommerce();
        chamberOfCommerce = chamberOfCommerce + '1';
        dwh_account1.LG_AccountChamberOfCommerceNumber__c = chamberOfCommerce;
        dwhInsertList.add(dwh_account1);
        
        //initializing the contact DWH data
        string externalId_Contact = generateRandomNumber();
        externalId_Contact = externalId_Contact + '11_Contact';
        LG_DWHFeedStagingTable__c dwh_contact1 = new LG_DWHFeedStagingTable__c();
        dwh_contact1.LG_Status__c = 'New';
        dwh_contact1.LG_TypeofRecord__c = 'Contact';
        dwh_contact1.LG_ContactFirstName__c = 'Test First Name';
        dwh_contact1.LG_ContactLastName__c = 'Test Last Name';
        dwh_contact1.LG_DWHTransactionId__c = transactionId;
        dwh_contact1.LG_AccountExternalId__c = externalId_Account;
        dwh_contact1.LG_ContactExternalID__c = externalId_Contact;
        dwh_contact1.LG_ContactOwnerId__c = userId;
        dwhInsertList.add(dwh_contact1);
        
        //initializing the premise DWH data
        LG_DWHFeedStagingTable__c dwh_premise1 = new LG_DWHFeedStagingTable__c();
        string externalId_Premise = generateRandomNumber();
        externalId_Premise = externalId_Premise + '11_Premise';
        dwh_premise1.LG_Status__c = 'New';
        dwh_premise1.LG_TypeofRecord__c = 'Premise';
        dwh_premise1.LG_PremiseName__c = 'Home';
        dwh_premise1.LG_DWHTransactionId__c = transactionId;
        dwh_premise1.LG_AccountExternalId__c = externalId_Account;
        dwh_premise1.LG_PremiseExternalId__c = externalId_Premise;
        dwh_premise1.LG_PremiseHouseNumber__c = '1';
        dwh_premise1.LG_PremiseHouseNumberExtension__c = '11';
        dwh_premise1.LG_PremiseStreet__c = 'Test Street 123';
        dwh_premise1.LG_PremiseCity__c = 'Test City 123';
        dwh_premise1.LG_PremisePostalCode__c = '9999XX';
        dwhInsertList.add(dwh_premise1);
        
        //initializing the Billing Account DWH data
        LG_DWHFeedStagingTable__c dwh_billingAccount1 = new LG_DWHFeedStagingTable__c();
        string externalId_billingAccount = generateRandomNumber();
        externalId_billingAccount = externalId_billingAccount + '11_billingAccount';
        dwh_billingAccount1.LG_Status__c = 'New';
        dwh_billingAccount1.LG_TypeofRecord__c = 'Billing Account';
        dwh_billingAccount1.LG_BillingAccountName__c = 'BillingAccount 1';
        dwh_billingAccount1.LG_BillingAccountName__c = 'BillingAccount 1';
        dwh_billingAccount1.LG_BillingAccountBillingChannel__c = 'Paper bill';
        dwh_billingAccount1.LG_BillingAccountDefault__c = True;
        dwh_billingAccount1.LG_DWHTransactionId__c = transactionId;
        dwh_billingAccount1.LG_AccountExternalId__c = externalId_Account;
        dwh_billingAccount1.LG_BillingAccountExternalId__c = externalId_billingAccount;
        dwhInsertList.add(dwh_billingAccount1);
        
        //initializing the Contract DWH data
        LG_DWHFeedStagingTable__c dwh_contract1 = new LG_DWHFeedStagingTable__c();
        string externalId_contract = generateRandomNumber();
        externalId_contract = externalId_contract + '11_contract';
        dwh_contract1.LG_Status__c = 'New';
        dwh_contract1.LG_TypeofRecord__c = 'Contract';
        dwh_contract1.LG_DWHTransactionId__c = transactionId;
        dwh_contract1.LG_AccountExternalId__c = externalId_Account;
        dwh_contract1.LG_ContractNumber__c = externalId_contract;
        dwh_contract1.LG_ContractStatus__c = 'Open';
        dwh_contract1.LG_ContractStartDate__c = system.today();
        dwh_contract1.LG_ContractEndDate__c = system.today() + 10;
        dwh_contract1.LG_ContractExpirationDate__c = system.today() + 100;
        dwhInsertList.add(dwh_contract1);
        
        //initializing the Subscription DWH data
        LG_DWHFeedStagingTable__c dwh_subscription1 = new LG_DWHFeedStagingTable__c();
        dwh_subscription1.LG_Status__c = 'New';
        dwh_subscription1.LG_TypeofRecord__c = 'Subscription';
        dwh_subscription1.LG_DWHTransactionId__c = transactionId;
        dwh_subscription1.LG_AccountExternalId__c = externalId_Account;
        dwh_subscription1.LG_SubscriptionName__c = 'Connect MKB Internet';
        dwh_subscription1.LG_SubscriptionStatus__c = 'Active';
        dwh_subscription1.LG_SubscriptionContractNumber__c = externalId_contract;
        dwh_subscription1.LG_SubscriptionExternalId__c = ''; //externalId_Account +'_subs_MKB';
        dwhInsertList.add(dwh_subscription1);
        
        //initializing the Service DWH data for Connect MKB
        LG_DWHFeedStagingTable__c dwh_service1_ConnectMKB = new LG_DWHFeedStagingTable__c();
        dwh_service1_ConnectMKB.LG_Status__c = 'New';
        dwh_service1_ConnectMKB.LG_TypeofRecord__c = 'Service';
        dwh_service1_ConnectMKB.LG_DWHTransactionId__c = transactionId;
        dwh_service1_ConnectMKB.LG_AccountExternalId__c = externalId_Account;
        dwh_service1_ConnectMKB.LG_ServiceName__c = 'Connect MKB Internet Compleet';
        dwh_service1_ConnectMKB.LG_ServiceStatus__c = 'Active';
        dwh_service1_ConnectMKB.LG_ServiceQuantity__c = 2;
        dwh_service1_ConnectMKB.LG_ServiceUnitPrice__c = 20;
        dwh_service1_ConnectMKB.LG_ServiceContractTerm__c = 24;
        dwh_service1_ConnectMKB.LG_ServicePremiseId__c = externalId_Premise;
        dwh_service1_ConnectMKB.LG_ServiceSubscriptionExternalId__c = externalId_Account +'_subs_MKB';
        dwh_service1_ConnectMKB.LG_ServiceExternalId__c = externalId_Account +'_serv_MKB';
        dwhInsertList.add(dwh_service1_ConnectMKB);
        
        //initializing the Attribute DWH data for Connect MKB
        LG_DWHFeedStagingTable__c dwh_attribute1_ConnectMKB = new LG_DWHFeedStagingTable__c();
        dwh_attribute1_ConnectMKB.LG_Status__c = 'New';
        dwh_attribute1_ConnectMKB.LG_TypeofRecord__c = 'Attribute';
        dwh_attribute1_ConnectMKB.LG_DWHTransactionId__c = transactionId;
        dwh_attribute1_ConnectMKB.LG_AccountExternalId__c = externalId_Account;
        dwh_attribute1_ConnectMKB.LG_AttributeProductCategory__c = 'Internet';
        dwh_attribute1_ConnectMKB.LG_AttributeProductName__c = 'Connect MKB Internet Compleet';
        dwh_attribute1_ConnectMKB.LG_AttributeContractTerm__c = 24;
        dwh_attribute1_ConnectMKB.LG_AttributeDiscount__c = 'DISC-000030';
        dwh_attribute1_ConnectMKB.LG_AttributeOneOffCharge__c = 19.99;
        dwh_attribute1_ConnectMKB.LG_AttributeRecurringCharge__c = 19.99;
        dwh_attribute1_ConnectMKB.LG_AttributeServiceExternalId__c = externalId_Account +'_serv_MKB';
        dwhInsertList.add(dwh_attribute1_ConnectMKB);
    
        //initializing the Service DWH data for Pin
        LG_DWHFeedStagingTable__c dwh_service1_Pin = new LG_DWHFeedStagingTable__c();
        dwh_service1_Pin.LG_Status__c = 'New';
        dwh_service1_Pin.LG_TypeofRecord__c = 'Service';
        dwh_service1_Pin.LG_DWHTransactionId__c = transactionId;
        dwh_service1_Pin.LG_AccountExternalId__c = externalId_Account;
        dwh_service1_Pin.LG_ServiceName__c = 'Pin Zeker';
        dwh_service1_Pin.LG_ServiceStatus__c = 'Active';
        dwh_service1_Pin.LG_ServiceQuantity__c = 2;
        dwh_service1_Pin.LG_ServiceUnitPrice__c = 20;
        dwh_service1_Pin.LG_ServiceContractTerm__c = 24;
        dwh_service1_Pin.LG_ServicePremiseId__c = externalId_Premise;
        dwh_service1_Pin.LG_ServiceSubscriptionExternalId__c = externalId_Account +'_subs_MKB';
        dwh_service1_Pin.LG_ServiceExternalId__c = externalId_Account +'_serv_Pin';
        dwhInsertList.add(dwh_service1_Pin);
        
        //initializing the Attribute DWH data for Pin
        LG_DWHFeedStagingTable__c dwh_attribute1_Pin = new LG_DWHFeedStagingTable__c();
        dwh_attribute1_Pin.LG_Status__c = 'New';
        dwh_attribute1_Pin.LG_TypeofRecord__c = 'Attribute';
        dwh_attribute1_Pin.LG_DWHTransactionId__c = transactionId;
        dwh_attribute1_Pin.LG_AccountExternalId__c = externalId_Account;
        dwh_attribute1_Pin.LG_AttributeProductCategory__c = 'Related Products';
        dwh_attribute1_Pin.LG_AttributeProductName__c = 'Pin Zeker';
        dwh_attribute1_Pin.LG_AttributeContractTerm__c = 24;
        dwh_attribute1_Pin.LG_AttributePinType__c = 'Pin Zeker';
        dwh_attribute1_Pin.LG_AttributeOneOffCharge__c = 19.99;
        dwh_attribute1_Pin.LG_AttributeRecurringCharge__c = 19.99;
        dwh_attribute1_Pin.LG_AttributeServiceExternalId__c = externalId_Account +'_serv_Pin';
        dwhInsertList.add(dwh_attribute1_Pin);
    
        //initializing the Service DWH data for SLA
        LG_DWHFeedStagingTable__c dwh_service1_SLA = new LG_DWHFeedStagingTable__c();
        dwh_service1_SLA.LG_Status__c = 'New';
        dwh_service1_SLA.LG_TypeofRecord__c = 'Service';
        dwh_service1_SLA.LG_DWHTransactionId__c = transactionId;
        dwh_service1_SLA.LG_AccountExternalId__c = externalId_Account;
        dwh_service1_SLA.LG_ServiceName__c = 'Service Standaard';
        dwh_service1_SLA.LG_ServiceStatus__c = 'Active';
        dwh_service1_SLA.LG_ServiceQuantity__c = 2;
        dwh_service1_SLA.LG_ServiceUnitPrice__c = 20;
        dwh_service1_SLA.LG_ServiceContractTerm__c = 24;
        dwh_service1_SLA.LG_ServicePremiseId__c = externalId_Premise;
        dwh_service1_SLA.LG_ServiceSubscriptionExternalId__c = externalId_Account +'_subs_MKB';
        dwh_service1_SLA.LG_ServiceExternalId__c = externalId_Account +'_serv_MKB_SLA';
        dwhInsertList.add(dwh_service1_SLA);
        
        //initializing the Attribute DWH data for SLA
        LG_DWHFeedStagingTable__c dwh_attribute1_SLA = new LG_DWHFeedStagingTable__c();
        dwh_attribute1_SLA.LG_Status__c = 'New';
        dwh_attribute1_SLA.LG_TypeofRecord__c = 'Attribute';
        dwh_attribute1_SLA.LG_DWHTransactionId__c = transactionId;
        dwh_attribute1_SLA.LG_AccountExternalId__c = externalId_Account;
        dwh_attribute1_SLA.LG_AttributeProductCategory__c = 'Service Standaard';
        dwh_attribute1_SLA.LG_AttributeProductName__c = 'Service Standaard';
        dwh_attribute1_SLA.LG_AttributeContractTerm__c = 24;
        dwh_attribute1_SLA.LG_AttributeSLA__c = 'Service Standaard';
        dwh_attribute1_SLA.LG_AttributeOneOffCharge__c = 19.99;
        dwh_attribute1_SLA.LG_AttributeRecurringCharge__c = 19.99;
        dwh_attribute1_SLA.LG_AttributeServiceExternalId__c = externalId_Account +'_serv_MKB_SLA';
        dwhInsertList.add(dwh_attribute1_SLA);
        
        insert dwhInsertList;
        
        Test.startTest();
        string CRON_EXP = '0 10 * * * ? ';
        String jobId = System.schedule('LG_CreateDataFromDWHFeedSchedulable',CRON_EXP,new LG_CreateDataFromDWHFeedSchedulable());
        Test.stopTest();        
    }
    
    /*
        Name: TestMethod2_MultiWifi_AccessPoint
        Purpose: Test method for testing the logic for syncing Multi Wifi and Access Point
        Argument: none
        Return type: none
    */
    /*
    static testmethod void TestMethod2_MultiWifi_AccessPoint(){
        
        /*LG_DWHIntegrationVariables__c dwhVar = new LG_DWHIntegrationVariables__c();
        dwhVar = [Select Id, Name from LG_DWHIntegrationVariables__c where Name = 'Limit_on_Accounts_Fetched'];
        dwhVar.LG_DisplayValue__c = '1';
        update dwhVar;*/
     
    /*
        List<LG_DWHFeedStagingTable__c> dwhInsertList = new List<LG_DWHFeedStagingTable__c>();
        string userId = userInfo.getuserId();
        
        string transactionId = generateRandomNumber();
        transactionId = transactionId + '2';
        
        string externalId_Account = generateRandomNumber();
        externalId_Account = externalId_Account + '22_Account';
        
        //initializing the account DWH data
        LG_DWHFeedStagingTable__c dwh_account1 = new LG_DWHFeedStagingTable__c();
        dwh_account1.LG_Status__c = 'New';
        dwh_account1.LG_TypeofRecord__c = 'Account';
        dwh_account1.LG_AccountName__c = 'DWH Test Account Only For TestClassCoverage';
        dwh_account1.LG_AccountPhone__c = '00001111';
        dwh_account1.LG_DWHTransactionId__c = transactionId;
        dwh_account1.LG_AccountExternalId__c = externalId_Account;
        dwh_account1.LG_AccountOwnerId__c = userId;
        string chamberOfCommerce = generateRandomNumberForChamberOfCommerce();
        chamberOfCommerce = chamberOfCommerce + '2';
        dwh_account1.LG_AccountChamberOfCommerceNumber__c = chamberOfCommerce;
        dwhInsertList.add(dwh_account1);
        
        //initializing the contact DWH data
        string externalId_Contact = generateRandomNumber();
        externalId_Contact = externalId_Contact + '22_Contact';
        LG_DWHFeedStagingTable__c dwh_contact1 = new LG_DWHFeedStagingTable__c();
        dwh_contact1.LG_Status__c = 'New';
        dwh_contact1.LG_TypeofRecord__c = 'Contact';
        dwh_contact1.LG_ContactFirstName__c = 'Test First Name';
        dwh_contact1.LG_ContactLastName__c = 'Test Last Name';
        dwh_contact1.LG_DWHTransactionId__c = transactionId;
        dwh_contact1.LG_AccountExternalId__c = externalId_Account;
        dwh_contact1.LG_ContactExternalID__c = externalId_Contact;
        dwh_contact1.LG_ContactOwnerId__c = userId;
        dwhInsertList.add(dwh_contact1);
        
        //initializing the premise DWH data
        LG_DWHFeedStagingTable__c dwh_premise1 = new LG_DWHFeedStagingTable__c();
        string externalId_Premise = generateRandomNumber();
        externalId_Premise = externalId_Premise + '22_Premise';
        dwh_premise1.LG_Status__c = 'New';
        dwh_premise1.LG_TypeofRecord__c = 'Premise';
        dwh_premise1.LG_PremiseName__c = 'Home';
        dwh_premise1.LG_DWHTransactionId__c = transactionId;
        dwh_premise1.LG_AccountExternalId__c = externalId_Account;
        dwh_premise1.LG_PremiseExternalId__c = externalId_Premise;
        dwhInsertList.add(dwh_premise1);
        
        //initializing the Billing Account DWH data
        LG_DWHFeedStagingTable__c dwh_billingAccount1 = new LG_DWHFeedStagingTable__c();
        string externalId_billingAccount = generateRandomNumber();
        externalId_billingAccount = externalId_billingAccount + '22_billingAccount';
        dwh_billingAccount1.LG_Status__c = 'New';
        dwh_billingAccount1.LG_TypeofRecord__c = 'Billing Account';
        dwh_billingAccount1.LG_BillingAccountName__c = 'BillingAccount 2';
        dwh_billingAccount1.LG_BillingAccountBillingChannel__c = 'Paper bill';
        dwh_billingAccount1.LG_BillingAccountDefault__c = True;
        dwh_billingAccount1.LG_DWHTransactionId__c = transactionId;
        dwh_billingAccount1.LG_AccountExternalId__c = externalId_Account;
        dwh_billingAccount1.LG_BillingAccountExternalId__c = externalId_billingAccount;
        dwhInsertList.add(dwh_billingAccount1);
        
        //initializing the Contract DWH data
        LG_DWHFeedStagingTable__c dwh_contract1 = new LG_DWHFeedStagingTable__c();
        string externalId_contract = generateRandomNumber();
        externalId_contract = externalId_contract + '11_contract';
        dwh_contract1.LG_Status__c = 'New';
        dwh_contract1.LG_TypeofRecord__c = 'Contract';
        dwh_contract1.LG_DWHTransactionId__c = transactionId;
        dwh_contract1.LG_AccountExternalId__c = externalId_Account;
        dwh_contract1.LG_ContractNumber__c = externalId_contract;
        dwh_contract1.LG_ContractStatus__c = 'Open';
        dwh_contract1.LG_ContractStartDate__c = system.today();
        dwh_contract1.LG_ContractEndDate__c = system.today() + 10;
        dwh_contract1.LG_ContractExpirationDate__c = system.today() + 100;
        dwhInsertList.add(dwh_contract1);
        
        //initializing the Subscription DWH data
        LG_DWHFeedStagingTable__c dwh_subscription1 = new LG_DWHFeedStagingTable__c();
        dwh_subscription1.LG_Status__c = 'New';
        dwh_subscription1.LG_TypeofRecord__c = 'Subscription';
        dwh_subscription1.LG_DWHTransactionId__c = transactionId;
        dwh_subscription1.LG_AccountExternalId__c = externalId_Account;
        dwh_subscription1.LG_SubscriptionName__c = 'Multi Wifi';
        dwh_subscription1.LG_SubscriptionStatus__c = 'Active';
        dwh_subscription1.LG_SubscriptionContractNumber__c = externalId_contract;
        dwh_subscription1.LG_SubscriptionExternalId__c = externalId_Account +'_subs_Multiwifi';
        dwhInsertList.add(dwh_subscription1);
        
        //initializing the Service DWH data for Multi Wifi
        LG_DWHFeedStagingTable__c dwh_service1_MultiWifi = new LG_DWHFeedStagingTable__c();
        dwh_service1_MultiWifi.LG_Status__c = 'New';
        dwh_service1_MultiWifi.LG_TypeofRecord__c = 'Service';
        dwh_service1_MultiWifi.LG_DWHTransactionId__c = transactionId;
        dwh_service1_MultiWifi.LG_AccountExternalId__c = externalId_Account;
        dwh_service1_MultiWifi.LG_ServiceName__c = 'Accesspoint';
        dwh_service1_MultiWifi.LG_ServiceStatus__c = 'Active';
        dwh_service1_MultiWifi.LG_ServiceQuantity__c = 2;
        dwh_service1_MultiWifi.LG_ServiceUnitPrice__c = 20;
        dwh_service1_MultiWifi.LG_ServiceContractTerm__c = 24;
        dwh_service1_MultiWifi.LG_ServicePremiseId__c = externalId_Premise;
        dwh_service1_MultiWifi.LG_ServiceSubscriptionExternalId__c = externalId_Account +'_subs_Multiwifi';
        dwh_service1_MultiWifi.LG_ServiceExternalId__c = externalId_Account +'_serv_Multiwifi';
        dwhInsertList.add(dwh_service1_MultiWifi);
        
        //initializing the Attribute DWH data for Multi Wifi
        LG_DWHFeedStagingTable__c dwh_attribute1_MultiWifi = new LG_DWHFeedStagingTable__c();
        dwh_attribute1_MultiWifi.LG_Status__c = 'New';
        dwh_attribute1_MultiWifi.LG_TypeofRecord__c = 'Attribute';
        dwh_attribute1_MultiWifi.LG_DWHTransactionId__c = transactionId;
        dwh_attribute1_MultiWifi.LG_AccountExternalId__c = externalId_Account;
        dwh_attribute1_MultiWifi.LG_AttributeProductCategory__c = 'Internet';
        dwh_attribute1_MultiWifi.LG_AttributeProductName__c = 'Accesspoint';
        dwh_attribute1_MultiWifi.LG_AttributeContractTerm__c = 24;
        dwh_attribute1_MultiWifi.LG_AttributeQuantity__c = 3;
        dwh_attribute1_MultiWifi.LG_AttributeOneOffCharge__c = 19.99;
        dwh_attribute1_MultiWifi.LG_AttributeRecurringCharge__c = 19.99;
        dwh_attribute1_MultiWifi.LG_AttributeServiceExternalId__c = externalId_Account +'_serv_Multiwifi';
        dwhInsertList.add(dwh_attribute1_MultiWifi);
    
        //initializing the Service DWH data for Access Point
        LG_DWHFeedStagingTable__c dwh_service1_AccessPoint = new LG_DWHFeedStagingTable__c();
        dwh_service1_AccessPoint.LG_Status__c = 'New';
        dwh_service1_AccessPoint.LG_TypeofRecord__c = 'Service';
        dwh_service1_AccessPoint.LG_DWHTransactionId__c = transactionId;
        dwh_service1_AccessPoint.LG_AccountExternalId__c = externalId_Account;
        dwh_service1_AccessPoint.LG_ServiceName__c = 'Accesspoint Start';
        dwh_service1_AccessPoint.LG_ServiceStatus__c = 'Active';
        dwh_service1_AccessPoint.LG_ServiceQuantity__c = 2;
        dwh_service1_AccessPoint.LG_ServiceUnitPrice__c = 20;
        dwh_service1_AccessPoint.LG_ServiceContractTerm__c = 24;
        dwh_service1_AccessPoint.LG_ServicePremiseId__c = externalId_Premise;
        dwh_service1_AccessPoint.LG_ServiceSubscriptionExternalId__c = externalId_Account +'_subs_Multiwifi';
        dwh_service1_AccessPoint.LG_ServiceExternalId__c = externalId_Account +'_serv_AccessPoint';
        dwhInsertList.add(dwh_service1_AccessPoint);
        
        //initializing the Attribute DWH data for Access Point
        LG_DWHFeedStagingTable__c dwh_attribute1_AccessPoint = new LG_DWHFeedStagingTable__c();
        dwh_attribute1_AccessPoint.LG_Status__c = 'New';
        dwh_attribute1_AccessPoint.LG_TypeofRecord__c = 'Attribute';
        dwh_attribute1_AccessPoint.LG_DWHTransactionId__c = transactionId;
        dwh_attribute1_AccessPoint.LG_AccountExternalId__c = externalId_Account;
        dwh_attribute1_AccessPoint.LG_AttributeProductCategory__c = 'Related Products';
        dwh_attribute1_AccessPoint.LG_AttributeProductName__c = 'Accesspoint Start';
        dwh_attribute1_AccessPoint.LG_AttributeContractTerm__c = 24;
        dwh_attribute1_AccessPoint.LG_AttributeQuantity__c = 3;
        dwh_attribute1_AccessPoint.LG_AttributeMultiWifiType__c = 'Multi Wifi Compleet';
        dwh_attribute1_AccessPoint.LG_AttributeOneOffCharge__c = 19.99;
        dwh_attribute1_AccessPoint.LG_AttributeRecurringCharge__c = 19.99;
        dwh_attribute1_AccessPoint.LG_AttributeServiceExternalId__c = externalId_Account +'_serv_AccessPoint';
        dwhInsertList.add(dwh_attribute1_AccessPoint);
    
        insert dwhInsertList;
        
        Test.startTest();
        string CRON_EXP = '0 10 * * * ? ';
        String jobId = System.schedule('LG_CreateDataFromDWHFeedSchedulable',CRON_EXP,new LG_CreateDataFromDWHFeedSchedulable());
        Test.stopTest();        
    }
    
    
    /*
        Name: TestMethod3_Telephony_PhoneNumbers
        Purpose: Test method for testing the logic for syncing Telephony and Phone Numbers
        Argument: none
        Return type: none
    */
    /*
    static testmethod void TestMethod3_Telephony_PhoneNumbers(){
        
        /*LG_DWHIntegrationVariables__c dwhVar = new LG_DWHIntegrationVariables__c();
        dwhVar = [Select Id, Name from LG_DWHIntegrationVariables__c where Name = 'Limit_on_Accounts_Fetched'];
        dwhVar.LG_DisplayValue__c = '1';
        update dwhVar;*/
        /*
        List<LG_DWHFeedStagingTable__c> dwhInsertList = new List<LG_DWHFeedStagingTable__c>();
        string userId = userInfo.getuserId();
        
        string transactionId = generateRandomNumber();
        transactionId = transactionId + '3';
        
        string externalId_Account = generateRandomNumber();
        externalId_Account = externalId_Account + '33_Account';
        
        //initializing the account DWH data
        LG_DWHFeedStagingTable__c dwh_account1 = new LG_DWHFeedStagingTable__c();
        dwh_account1.LG_Status__c = 'New';
        dwh_account1.LG_TypeofRecord__c = 'Account';
        dwh_account1.LG_AccountName__c = 'DWH Test Account Only For TestClassCoverage';
        dwh_account1.LG_AccountPhone__c = '00001111';
        dwh_account1.LG_DWHTransactionId__c = transactionId;
        dwh_account1.LG_AccountExternalId__c = externalId_Account;
        dwh_account1.LG_AccountOwnerId__c = userId;
        string chamberOfCommerce = generateRandomNumberForChamberOfCommerce();
        chamberOfCommerce = chamberOfCommerce + '3';
        dwh_account1.LG_AccountChamberOfCommerceNumber__c = chamberOfCommerce;
        dwhInsertList.add(dwh_account1);
        
        //initializing the contact DWH data
        string externalId_Contact = generateRandomNumber();
        externalId_Contact = externalId_Contact + '33_Contact';
        LG_DWHFeedStagingTable__c dwh_contact1 = new LG_DWHFeedStagingTable__c();
        dwh_contact1.LG_Status__c = 'New';
        dwh_contact1.LG_TypeofRecord__c = 'Contact';
        dwh_contact1.LG_ContactFirstName__c = 'Test First Name';
        dwh_contact1.LG_ContactLastName__c = 'Test Last Name';
        dwh_contact1.LG_DWHTransactionId__c = transactionId;
        dwh_contact1.LG_AccountExternalId__c = externalId_Account;
        dwh_contact1.LG_ContactExternalID__c = externalId_Contact;
        dwh_contact1.LG_ContactOwnerId__c = userId;
        dwhInsertList.add(dwh_contact1);
        
        //initializing the premise DWH data
        LG_DWHFeedStagingTable__c dwh_premise1 = new LG_DWHFeedStagingTable__c();
        string externalId_Premise = generateRandomNumber();
        externalId_Premise = externalId_Premise + '33_Premise';
        dwh_premise1.LG_Status__c = 'New';
        dwh_premise1.LG_TypeofRecord__c = 'Premise';
        dwh_premise1.LG_PremiseName__c = 'Home';
        dwh_premise1.LG_DWHTransactionId__c = transactionId;
        dwh_premise1.LG_AccountExternalId__c = externalId_Account;
        dwh_premise1.LG_PremiseExternalId__c = externalId_Premise;
        dwhInsertList.add(dwh_premise1);
        
        //initializing the Billing Account DWH data
        LG_DWHFeedStagingTable__c dwh_billingAccount1 = new LG_DWHFeedStagingTable__c();
        string externalId_billingAccount = generateRandomNumber();
        externalId_billingAccount = externalId_billingAccount + '33_billingAccount';
        dwh_billingAccount1.LG_Status__c = 'New';
        dwh_billingAccount1.LG_TypeofRecord__c = 'Billing Account';
        dwh_billingAccount1.LG_BillingAccountName__c = 'BillingAccount 2';
        dwh_billingAccount1.LG_BillingAccountBillingChannel__c = 'Paper bill';
        dwh_billingAccount1.LG_BillingAccountDefault__c = True;
        dwh_billingAccount1.LG_DWHTransactionId__c = transactionId;
        dwh_billingAccount1.LG_AccountExternalId__c = externalId_Account;
        dwh_billingAccount1.LG_BillingAccountExternalId__c = externalId_billingAccount;
        dwhInsertList.add(dwh_billingAccount1);
        
        //initializing the Contract DWH data
        LG_DWHFeedStagingTable__c dwh_contract1 = new LG_DWHFeedStagingTable__c();
        string externalId_contract = generateRandomNumber();
        externalId_contract = externalId_contract + '33_contract';
        dwh_contract1.LG_Status__c = 'New';
        dwh_contract1.LG_TypeofRecord__c = 'Contract';
        dwh_contract1.LG_DWHTransactionId__c = transactionId;
        dwh_contract1.LG_AccountExternalId__c = externalId_Account;
        dwh_contract1.LG_ContractNumber__c = externalId_contract;
        dwh_contract1.LG_ContractStatus__c = 'Open';
        dwh_contract1.LG_ContractStartDate__c = system.today();
        dwh_contract1.LG_ContractEndDate__c = system.today() + 10;
        dwh_contract1.LG_ContractExpirationDate__c = system.today() + 100;
        dwhInsertList.add(dwh_contract1);
        
        //initializing the Subscription DWH data
        LG_DWHFeedStagingTable__c dwh_subscription1 = new LG_DWHFeedStagingTable__c();
        dwh_subscription1.LG_Status__c = 'New';
        dwh_subscription1.LG_TypeofRecord__c = 'Subscription';
        dwh_subscription1.LG_DWHTransactionId__c = transactionId;
        dwh_subscription1.LG_AccountExternalId__c = externalId_Account;
        dwh_subscription1.LG_SubscriptionName__c = 'Zakelijk Hosted Bellen';
        dwh_subscription1.LG_SubscriptionStatus__c = 'Active';
        dwh_subscription1.LG_SubscriptionContractNumber__c = externalId_contract;
        dwh_subscription1.LG_SubscriptionExternalId__c = externalId_Account +'_subs_Tele';
        dwhInsertList.add(dwh_subscription1);
        
        //initializing the Service DWH data for Telephony
        LG_DWHFeedStagingTable__c dwh_service1 = new LG_DWHFeedStagingTable__c();
        dwh_service1.LG_Status__c = 'New';
        dwh_service1.LG_TypeofRecord__c = 'Service';
        dwh_service1.LG_DWHTransactionId__c = transactionId;
        dwh_service1.LG_AccountExternalId__c = externalId_Account;
        dwh_service1.LG_ServiceName__c = 'Zakelijk Hosted Bellen';
        dwh_service1.LG_ServiceStatus__c = 'Active';
        dwh_service1.LG_ServiceQuantity__c = 2;
        dwh_service1.LG_ServiceUnitPrice__c = 20;
        dwh_service1.LG_ServiceContractTerm__c = 24;
        dwh_service1.LG_ServicePremiseId__c = externalId_Premise;
        dwh_service1.LG_ServiceSubscriptionExternalId__c = externalId_Account +'_subs_Tele';
        dwh_service1.LG_ServiceExternalId__c = externalId_Account +'_serv_Tele';
        dwhInsertList.add(dwh_service1);
        
        //initializing the Attribute DWH data for Telephony
        LG_DWHFeedStagingTable__c dwh_attribute1 = new LG_DWHFeedStagingTable__c();
        dwh_attribute1.LG_Status__c = 'New';
        dwh_attribute1.LG_TypeofRecord__c = 'Attribute';
        dwh_attribute1.LG_DWHTransactionId__c = transactionId;
        dwh_attribute1.LG_AccountExternalId__c = externalId_Account;
        dwh_attribute1.LG_AttributeProductCategory__c = 'Telephony';
        dwh_attribute1.LG_AttributeProductName__c = 'Zakelijk Hosted Bellen';
        dwh_attribute1.LG_AttributeContractTerm__c = 24;
        dwh_attribute1.LG_AttributeInstallationType__c = 'Zelf installeren';
        dwh_attribute1.LG_AttributeOneOffCharge__c = 19.99;
        dwh_attribute1.LG_AttributeRecurringCharge__c = 19.99;
        dwh_attribute1.LG_AttributeServiceExternalId__c = externalId_Account +'_serv_Tele';
        dwhInsertList.add(dwh_attribute1);
    
        //initializing the Service DWH data for Phone Numbers
        LG_DWHFeedStagingTable__c dwh_service2 = new LG_DWHFeedStagingTable__c();
        dwh_service2.LG_Status__c = 'New';
        dwh_service2.LG_TypeofRecord__c = 'Service';
        dwh_service2.LG_DWHTransactionId__c = transactionId;
        dwh_service2.LG_AccountExternalId__c = externalId_Account;
        dwh_service2.LG_ServiceName__c = '100-nummerblok';
        dwh_service2.LG_ServiceStatus__c = 'Active';
        dwh_service2.LG_ServiceQuantity__c = 2;
        dwh_service2.LG_ServiceUnitPrice__c = 20;
        dwh_service2.LG_ServiceContractTerm__c = 24;
        dwh_service2.LG_ServicePremiseId__c = externalId_Premise;
        dwh_service2.LG_ServiceSubscriptionExternalId__c = externalId_Account +'_subs_Tele';
        dwh_service2.LG_ServiceExternalId__c = externalId_Account +'_serv_Tele1';
        dwhInsertList.add(dwh_service2);
        
        //initializing the Attribute DWH data for Phone Numbers
        LG_DWHFeedStagingTable__c dwh_attribute2 = new LG_DWHFeedStagingTable__c();
        dwh_attribute2.LG_Status__c = 'New';
        dwh_attribute2.LG_TypeofRecord__c = 'Attribute';
        dwh_attribute2.LG_DWHTransactionId__c = transactionId;
        dwh_attribute2.LG_AccountExternalId__c = externalId_Account;
        dwh_attribute2.LG_AttributeProductCategory__c = 'Related Products';
        dwh_attribute2.LG_AttributeProductName__c = '100-nummerblok';
        dwh_attribute2.LG_AttributeContractTerm__c = 24;
        dwh_attribute2.LG_AttributeBlockType__c = '10';
        dwh_attribute2.LG_AttributeBNumberShielding__c = 'Yes';
        dwh_attribute2.LG_AttributeCallBarringLevel__c = '99- Geen blokkering';
        dwh_attribute2.LG_AttributeCallerID__c = 'Yes';
        dwh_attribute2.LG_AttributeTypeOfPhoneRange__c = 'New';
        dwh_attribute2.LG_AttributeQuantity__c = 2;
        dwh_attribute2.LG_AttributeOneOffCharge__c = 19.99;
        dwh_attribute2.LG_AttributeRecurringCharge__c = 19.99;
        dwh_attribute2.LG_AttributeServiceExternalId__c = externalId_Account +'_serv_Tele1';
        dwhInsertList.add(dwh_attribute2);
    
        insert dwhInsertList;
        
        Test.startTest();
        string CRON_EXP = '0 10 * * * ? ';
        String jobId = System.schedule('LG_CreateDataFromDWHFeedSchedulable',CRON_EXP,new LG_CreateDataFromDWHFeedSchedulable());
        Test.stopTest();        
    }
    
    /*
        Name: TestMethod4_InternetPlus_Telephony_PhoneNumbers
        Purpose: Test method for testing the logic for syncing InternetPlus, Legacy Telephony and Legacy Phone Numbers
        Argument: none
        Return type: none
    */
    /*
    static testmethod void TestMethod4_InternetPlus_Telephony_PhoneNumbers(){
        
        /*LG_DWHIntegrationVariables__c dwhVar = new LG_DWHIntegrationVariables__c();
        dwhVar = [Select Id, Name from LG_DWHIntegrationVariables__c where Name = 'Limit_on_Accounts_Fetched'];
        dwhVar.LG_DisplayValue__c = '1';
        update dwhVar;*/
        /*
        List<LG_DWHFeedStagingTable__c> dwhInsertList = new List<LG_DWHFeedStagingTable__c>();
        string userId = userInfo.getuserId();
        
        string transactionId = generateRandomNumber();
        transactionId = transactionId + '4';
        
        string externalId_Account = generateRandomNumber();
        externalId_Account = externalId_Account + '44_Account';
        
        //initializing the account DWH data
        LG_DWHFeedStagingTable__c dwh_account1 = new LG_DWHFeedStagingTable__c();
        dwh_account1.LG_Status__c = 'New';
        dwh_account1.LG_TypeofRecord__c = 'Account';
        dwh_account1.LG_AccountName__c = 'DWH Test Account Only For TestClassCoverage';
        dwh_account1.LG_AccountPhone__c = '00001111';
        dwh_account1.LG_DWHTransactionId__c = transactionId;
        dwh_account1.LG_AccountExternalId__c = externalId_Account;
        dwh_account1.LG_AccountOwnerId__c = userId;
        string chamberOfCommerce = generateRandomNumberForChamberOfCommerce();
        chamberOfCommerce = chamberOfCommerce + '4';
        dwh_account1.LG_AccountChamberOfCommerceNumber__c = chamberOfCommerce;
        dwhInsertList.add(dwh_account1);
        
        //initializing the contact DWH data
        string externalId_Contact = generateRandomNumber();
        externalId_Contact = externalId_Contact + '44_Contact';
        LG_DWHFeedStagingTable__c dwh_contact1 = new LG_DWHFeedStagingTable__c();
        dwh_contact1.LG_Status__c = 'New';
        dwh_contact1.LG_TypeofRecord__c = 'Contact';
        dwh_contact1.LG_ContactFirstName__c = 'Test First Name';
        dwh_contact1.LG_ContactLastName__c = 'Test Last Name';
        dwh_contact1.LG_DWHTransactionId__c = transactionId;
        dwh_contact1.LG_AccountExternalId__c = externalId_Account;
        dwh_contact1.LG_ContactExternalID__c = externalId_Contact;
        dwh_contact1.LG_ContactOwnerId__c = userId;
        dwhInsertList.add(dwh_contact1);
        
        //initializing the premise DWH data
        LG_DWHFeedStagingTable__c dwh_premise1 = new LG_DWHFeedStagingTable__c();
        string externalId_Premise = generateRandomNumber();
        externalId_Premise = externalId_Premise + '44_Premise';
        dwh_premise1.LG_Status__c = 'New';
        dwh_premise1.LG_TypeofRecord__c = 'Premise';
        dwh_premise1.LG_PremiseName__c = 'Home';
        dwh_premise1.LG_DWHTransactionId__c = transactionId;
        dwh_premise1.LG_AccountExternalId__c = externalId_Account;
        dwh_premise1.LG_PremiseExternalId__c = externalId_Premise;
        dwhInsertList.add(dwh_premise1);
        
        //initializing the Billing Account DWH data
        LG_DWHFeedStagingTable__c dwh_billingAccount1 = new LG_DWHFeedStagingTable__c();
        string externalId_billingAccount = generateRandomNumber();
        externalId_billingAccount = externalId_billingAccount + '44_billingAccount';
        dwh_billingAccount1.LG_Status__c = 'New';
        dwh_billingAccount1.LG_TypeofRecord__c = 'Billing Account';
        dwh_billingAccount1.LG_BillingAccountName__c = 'BillingAccount 4';
        dwh_billingAccount1.LG_BillingAccountBillingChannel__c = 'Paper bill';
        dwh_billingAccount1.LG_BillingAccountDefault__c = True;
        dwh_billingAccount1.LG_DWHTransactionId__c = transactionId;
        dwh_billingAccount1.LG_AccountExternalId__c = externalId_Account;
        dwh_billingAccount1.LG_BillingAccountExternalId__c = externalId_billingAccount;
        dwhInsertList.add(dwh_billingAccount1);
        
        //initializing the Contract DWH data
        LG_DWHFeedStagingTable__c dwh_contract1 = new LG_DWHFeedStagingTable__c();
        string externalId_contract = generateRandomNumber();
        externalId_contract = externalId_contract + '44_contract';
        dwh_contract1.LG_Status__c = 'New';
        dwh_contract1.LG_TypeofRecord__c = 'Contract';
        dwh_contract1.LG_DWHTransactionId__c = transactionId;
        dwh_contract1.LG_AccountExternalId__c = externalId_Account;
        dwh_contract1.LG_ContractNumber__c = externalId_contract;
        dwh_contract1.LG_ContractStatus__c = 'Open';
        dwh_contract1.LG_ContractStartDate__c = system.today();
        dwh_contract1.LG_ContractEndDate__c = system.today() + 10;
        dwh_contract1.LG_ContractExpirationDate__c = system.today() + 100;
        dwhInsertList.add(dwh_contract1);
        
        //initializing the Subscription DWH data
        LG_DWHFeedStagingTable__c dwh_subscription1 = new LG_DWHFeedStagingTable__c();
        dwh_subscription1.LG_Status__c = 'New';
        dwh_subscription1.LG_TypeofRecord__c = 'Subscription';
        dwh_subscription1.LG_DWHTransactionId__c = transactionId;
        dwh_subscription1.LG_AccountExternalId__c = externalId_Account;
        dwh_subscription1.LG_SubscriptionName__c = 'Internet Plus';
        dwh_subscription1.LG_SubscriptionStatus__c = 'Active';
        dwh_subscription1.LG_SubscriptionContractNumber__c = externalId_contract;
        dwh_subscription1.LG_SubscriptionExternalId__c = externalId_Account +'_subs_InternetPlus';
        dwhInsertList.add(dwh_subscription1);
        
        //initializing the Service DWH data for Internet Plus
        LG_DWHFeedStagingTable__c dwh_service1 = new LG_DWHFeedStagingTable__c();
        dwh_service1.LG_Status__c = 'New';
        dwh_service1.LG_TypeofRecord__c = 'Service';
        dwh_service1.LG_DWHTransactionId__c = transactionId;
        dwh_service1.LG_AccountExternalId__c = externalId_Account;
        dwh_service1.LG_ServiceName__c = '40Mbps/4Mbps';
        dwh_service1.LG_ServiceStatus__c = 'Active';
        dwh_service1.LG_ServiceQuantity__c = 2;
        dwh_service1.LG_ServiceUnitPrice__c = 20;
        dwh_service1.LG_ServiceContractTerm__c = 24;
        dwh_service1.LG_ServicePremiseId__c = externalId_Premise;
        dwh_service1.LG_ServiceSubscriptionExternalId__c = externalId_Account +'_subs_InternetPlus';
        dwh_service1.LG_ServiceExternalId__c = externalId_Account +'_serv_InternetPlus';
        dwhInsertList.add(dwh_service1);
        
        //initializing the Attribute DWH data for Internet Plus
        LG_DWHFeedStagingTable__c dwh_attribute1 = new LG_DWHFeedStagingTable__c();
        dwh_attribute1.LG_Status__c = 'New';
        dwh_attribute1.LG_TypeofRecord__c = 'Attribute';
        dwh_attribute1.LG_DWHTransactionId__c = transactionId;
        dwh_attribute1.LG_AccountExternalId__c = externalId_Account;
        dwh_attribute1.LG_AttributeProductCategory__c = 'Legacy Products';
        dwh_attribute1.LG_AttributeProductName__c = '40Mbps/4Mbps';
        dwh_attribute1.LG_AttributeInternetSecurity__c = 2;
        dwh_attribute1.LG_AttributeIPAddressExtension__c = 'Yes';
        dwh_attribute1.LG_AttributeOneOffCharge__c = 19.99;
        dwh_attribute1.LG_AttributeRecurringCharge__c = 19.99;
        dwh_attribute1.LG_AttributeServiceExternalId__c = externalId_Account +'_serv_InternetPlus';
        dwhInsertList.add(dwh_attribute1);
    
        //initializing the Service DWH data for Telephonie
        LG_DWHFeedStagingTable__c dwh_service2 = new LG_DWHFeedStagingTable__c();
        dwh_service2.LG_Status__c = 'New';
        dwh_service2.LG_TypeofRecord__c = 'Service';
        dwh_service2.LG_DWHTransactionId__c = transactionId;
        dwh_service2.LG_AccountExternalId__c = externalId_Account;
        dwh_service2.LG_ServiceName__c = '2 Lijnen Digitaal';
        dwh_service2.LG_ServiceStatus__c = 'Active';
        dwh_service2.LG_ServiceQuantity__c = 2;
        dwh_service2.LG_ServiceUnitPrice__c = 20;
        dwh_service2.LG_ServiceContractTerm__c = 24;
        dwh_service2.LG_ServicePremiseId__c = externalId_Premise;
        dwh_service2.LG_ServiceSubscriptionExternalId__c = externalId_Account +'_subs_InternetPlus';
        dwh_service2.LG_ServiceExternalId__c = externalId_Account +'_serv_TelePhonyPlus';
        dwhInsertList.add(dwh_service2);
        
        //initializing the Attribute DWH data for Telephonie
        LG_DWHFeedStagingTable__c dwh_attribute2 = new LG_DWHFeedStagingTable__c();
        dwh_attribute2.LG_Status__c = 'New';
        dwh_attribute2.LG_TypeofRecord__c = 'Attribute';
        dwh_attribute2.LG_DWHTransactionId__c = transactionId;
        dwh_attribute2.LG_AccountExternalId__c = externalId_Account;
        dwh_attribute2.LG_AttributeProductCategory__c = 'Legacy Related Products';
        dwh_attribute2.LG_AttributeProductName__c = '2 Lijnen Digitaal';
        dwh_attribute2.LG_AttributeTelephonieType__c = '2 Lijnen Digitaal';
        dwh_attribute2.LG_AttributeOneOffCharge__c = 19.99;
        dwh_attribute2.LG_AttributeRecurringCharge__c = 19.99;
        dwh_attribute2.LG_AttributeServiceExternalId__c = externalId_Account +'_serv_TelePhonyPlus';
        dwhInsertList.add(dwh_attribute2);
    
        //initializing the Service DWH data for Legacy Phone Numbers 1
        LG_DWHFeedStagingTable__c dwh_service3 = new LG_DWHFeedStagingTable__c();
        dwh_service3.LG_Status__c = 'New';
        dwh_service3.LG_TypeofRecord__c = 'Service';
        dwh_service3.LG_DWHTransactionId__c = transactionId;
        dwh_service3.LG_AccountExternalId__c = externalId_Account;
        dwh_service3.LG_ServiceName__c = '10-nummerblok';
        dwh_service3.LG_ServiceStatus__c = 'Active';
        dwh_service3.LG_ServiceQuantity__c = 2;
        dwh_service3.LG_ServiceUnitPrice__c = 20;
        dwh_service3.LG_ServiceContractTerm__c = 24;
        dwh_service3.LG_ServicePremiseId__c = externalId_Premise;
        dwh_service3.LG_ServiceSubscriptionExternalId__c = externalId_Account +'_subs_InternetPlus';
        dwh_service3.LG_ServiceExternalId__c = externalId_Account +'_serv_LegacyTele1';
        dwhInsertList.add(dwh_service3);
        
        //initializing the Attribute DWH data for Legacy Phone Numbers 1
        LG_DWHFeedStagingTable__c dwh_attribute3 = new LG_DWHFeedStagingTable__c();
        dwh_attribute3.LG_Status__c = 'New';
        dwh_attribute3.LG_TypeofRecord__c = 'Attribute';
        dwh_attribute3.LG_DWHTransactionId__c = transactionId;
        dwh_attribute3.LG_AccountExternalId__c = externalId_Account;
        dwh_attribute3.LG_AttributeProductCategory__c = 'Related Products';
        dwh_attribute3.LG_AttributeProductName__c = '10-nummerblok';
        dwh_attribute3.LG_AttributeContractTerm__c = 24;
        dwh_attribute3.LG_AttributeBlockType__c = '10';
        dwh_attribute3.LG_AttributeBNumberShielding__c = 'Yes';
        dwh_attribute3.LG_AttributeCallBarringLevel__c = '99- Geen blokkering';
        dwh_attribute3.LG_AttributeCallerID__c = 'Yes';
        dwh_attribute3.LG_AttributeTypeOfPhoneRange__c = 'New';
        dwh_attribute3.LG_AttributeQuantity__c = 2;
        dwh_attribute3.LG_AttributeOneOffCharge__c = 19.99;
        dwh_attribute3.LG_AttributeRecurringCharge__c = 19.99;
        dwh_attribute3.LG_AttributeServiceExternalId__c = externalId_Account +'_serv_LegacyTele1';
        dwhInsertList.add(dwh_attribute3);
    
        //initializing the Service DWH data for Legacy Phone Numbers 2
        LG_DWHFeedStagingTable__c dwh_service4 = new LG_DWHFeedStagingTable__c();
        dwh_service4.LG_Status__c = 'New';
        dwh_service4.LG_TypeofRecord__c = 'Service';
        dwh_service4.LG_DWHTransactionId__c = transactionId;
        dwh_service4.LG_AccountExternalId__c = externalId_Account;
        dwh_service4.LG_ServiceName__c = 'Extra telefoonnummer';
        dwh_service4.LG_ServiceStatus__c = 'Active';
        dwh_service4.LG_ServiceQuantity__c = 2;
        dwh_service4.LG_ServiceUnitPrice__c = 20;
        dwh_service4.LG_ServiceContractTerm__c = 24;
        dwh_service4.LG_ServicePremiseId__c = externalId_Premise;
        dwh_service4.LG_ServiceSubscriptionExternalId__c = externalId_Account +'_subs_InternetPlus';
        dwh_service4.LG_ServiceExternalId__c = externalId_Account +'_serv_LegacyTele2';
        dwhInsertList.add(dwh_service4);
        
        //initializing the Attribute DWH data for Legacy Phone Numbers 2
        LG_DWHFeedStagingTable__c dwh_attribute4 = new LG_DWHFeedStagingTable__c();
        dwh_attribute4.LG_Status__c = 'New';
        dwh_attribute4.LG_TypeofRecord__c = 'Attribute';
        dwh_attribute4.LG_DWHTransactionId__c = transactionId;
        dwh_attribute4.LG_AccountExternalId__c = externalId_Account;
        dwh_attribute4.LG_AttributeProductCategory__c = 'Related Products';
        dwh_attribute4.LG_AttributeProductName__c = 'Extra telefoonnummer';
        dwh_attribute4.LG_AttributeContractTerm__c = 24;
        dwh_attribute4.LG_AttributeBlockType__c = '10';
        dwh_attribute4.LG_AttributeBNumberShielding__c = 'Yes';
        dwh_attribute4.LG_AttributeCallBarringLevel__c = '99- Geen blokkering';
        dwh_attribute4.LG_AttributeCallerID__c = 'Yes';
        dwh_attribute4.LG_AttributeTypeOfPhoneRange__c = 'New';
        dwh_attribute4.LG_AttributeQuantity__c = 2;
        dwh_attribute4.LG_AttributeOneOffCharge__c = 19.99;
        dwh_attribute4.LG_AttributeRecurringCharge__c = 19.99;
        dwh_attribute4.LG_AttributeServiceExternalId__c = externalId_Account +'_serv_LegacyTele2';
        dwhInsertList.add(dwh_attribute4);
    
        //initializing the Service DWH data for Legacy Phone Numbers 2
        LG_DWHFeedStagingTable__c dwh_service5 = new LG_DWHFeedStagingTable__c();
        dwh_service5.LG_Status__c = 'New';
        dwh_service5.LG_TypeofRecord__c = 'Service';
        dwh_service5.LG_DWHTransactionId__c = transactionId;
        dwh_service5.LG_AccountExternalId__c = externalId_Account;
        dwh_service5.LG_ServiceName__c = '5 PC Licentie';
        dwh_service5.LG_ServiceStatus__c = 'Active';
        dwh_service5.LG_ServiceQuantity__c = 2;
        dwh_service5.LG_ServiceUnitPrice__c = 20;
        dwh_service5.LG_ServiceContractTerm__c = 24;
        dwh_service5.LG_ServicePremiseId__c = externalId_Premise;
        dwh_service5.LG_ServiceSubscriptionExternalId__c = externalId_Account +'_subs_InternetPlus';
        dwh_service5.LG_ServiceExternalId__c = externalId_Account +'_serv_InterSec';
        dwhInsertList.add(dwh_service5);
        
        //initializing the Attribute DWH data for Telephonie
        LG_DWHFeedStagingTable__c dwh_attribute6 = new LG_DWHFeedStagingTable__c();
        dwh_attribute6.LG_Status__c = 'New';
        dwh_attribute6.LG_TypeofRecord__c = 'Attribute';
        dwh_attribute6.LG_DWHTransactionId__c = transactionId;
        dwh_attribute6.LG_AccountExternalId__c = externalId_Account;
        dwh_attribute6.LG_AttributeProductCategory__c = 'Legacy Related Products';
        dwh_attribute6.LG_AttributeProductName__c = '5 PC Licentie';
        dwh_attribute6.LG_AttributeOneOffCharge__c = 19.99;
        dwh_attribute6.LG_AttributeRecurringCharge__c = 19.99;
        dwh_attribute6.LG_AttributeServiceExternalId__c = externalId_Account +'_serv_InterSec';
        dwhInsertList.add(dwh_attribute6);
        
        insert dwhInsertList;
        
        Test.startTest();
        string CRON_EXP = '0 10 * * * ? ';
        String jobId = System.schedule('LG_CreateDataFromDWHFeedSchedulable',CRON_EXP,new LG_CreateDataFromDWHFeedSchedulable());
        Test.stopTest();        
    }
    
    
    /*
        Name: TestMethod5_ExceptionHandling
        Purpose: Test method for testing the logic for handling the exception
        Argument: none
        Return type: none
    */
    /*
    static testmethod void TestMethod5_ExceptionHandling() {
        
        /*LG_DWHIntegrationVariables__c dwhVar = new LG_DWHIntegrationVariables__c();
        dwhVar = [Select Id, Name from LG_DWHIntegrationVariables__c where Name = 'Limit_on_Accounts_Fetched'];
        dwhVar.LG_DisplayValue__c = '1';
        update dwhVar;*/
    /*
        
        List<LG_DWHFeedStagingTable__c> dwhInsertList = new List<LG_DWHFeedStagingTable__c>();
        string userId = userInfo.getuserId();
        
        string transactionId = generateRandomNumber();
        transactionId = transactionId + '4';
        
        string externalId_Account = generateRandomNumber();
        externalId_Account = externalId_Account + '44_Account';
        
        //initializing the account DWH data with incorrect Chamber of Commerce number
        LG_DWHFeedStagingTable__c dwh_account1 = new LG_DWHFeedStagingTable__c();
        dwh_account1.LG_Status__c = 'New';
        dwh_account1.LG_TypeofRecord__c = 'Account';
        dwh_account1.LG_AccountName__c = 'DWH Test Account Only For TestClassCoverage';
        dwh_account1.LG_AccountPhone__c = '00001111';
        dwh_account1.LG_DWHTransactionId__c = transactionId;
        dwh_account1.LG_AccountExternalId__c = externalId_Account;
        dwh_account1.LG_AccountOwnerId__c = userId;
        string chamberOfCommerce = generateRandomNumberForChamberOfCommerce();
        chamberOfCommerce = chamberOfCommerce + '55';
        dwh_account1.LG_AccountChamberOfCommerceNumber__c = chamberOfCommerce;
        dwhInsertList.add(dwh_account1);
    
        insert dwhInsertList;
            
        Test.startTest();
        string CRON_EXP = '0 10 * * * ? ';
        String jobId = System.schedule('LG_CreateDataFromDWHFeedSchedulable',CRON_EXP,new LG_CreateDataFromDWHFeedSchedulable());
        Test.stopTest();    
    }
    
    
    /*
        Name: TestMethod6_ExternalIDUpdateFromTracy
        Purpose: Test method for testing the logic for updating just the external Id field on subscription and service.
        Argument: none
        Return type: none
    */
    /*
    static testmethod void TestMethod6_ExternalIDUpdateFromTracy() {
        
        /*LG_DWHIntegrationVariables__c dwhVar = new LG_DWHIntegrationVariables__c();
        dwhVar = [Select Id, Name from LG_DWHIntegrationVariables__c where Name = 'Limit_on_Accounts_Fetched'];
        dwhVar.LG_DisplayValue__c = '1';
        update dwhVar;*/
        /*
        List<LG_DWHFeedStagingTable__c> dwhInsertList = new List<LG_DWHFeedStagingTable__c>();
        string userId = userInfo.getuserId();
        
        string transactionId = generateRandomNumber();
        transactionId = transactionId + '6';
        
        string externalId_Account = generateRandomNumber();
        externalId_Account = externalId_Account + '66_Account';
        
        //initializing the account DWH data
        LG_DWHFeedStagingTable__c dwh_account1 = new LG_DWHFeedStagingTable__c();
        dwh_account1.LG_Status__c = 'New';
        dwh_account1.LG_TypeofRecord__c = 'Account';
        dwh_account1.LG_AccountName__c = 'DWH Test Account Only For TestClassCoverage';
        dwh_account1.LG_AccountPhone__c = '00001111';
        dwh_account1.LG_DWHTransactionId__c = transactionId;
        dwh_account1.LG_AccountExternalId__c = externalId_Account;
        dwh_account1.LG_AccountOwnerId__c = userId;
        string chamberOfCommerce = generateRandomNumberForChamberOfCommerce();
        chamberOfCommerce = chamberOfCommerce + '6';
        dwh_account1.LG_AccountChamberOfCommerceNumber__c = chamberOfCommerce;
        dwhInsertList.add(dwh_account1);
        
        //initializing the contact DWH data
        string externalId_Contact = generateRandomNumber();
        externalId_Contact = externalId_Contact + '66_Contact';
        LG_DWHFeedStagingTable__c dwh_contact1 = new LG_DWHFeedStagingTable__c();
        dwh_contact1.LG_Status__c = 'New';
        dwh_contact1.LG_TypeofRecord__c = 'Contact';
        dwh_contact1.LG_ContactFirstName__c = 'Test First Name';
        dwh_contact1.LG_ContactLastName__c = 'Test Last Name';
        dwh_contact1.LG_DWHTransactionId__c = transactionId;
        dwh_contact1.LG_AccountExternalId__c = externalId_Account;
        dwh_contact1.LG_ContactExternalID__c = externalId_Contact;
        dwh_contact1.LG_ContactOwnerId__c = userId;
        dwhInsertList.add(dwh_contact1);
        
        //initializing the premise DWH data
        LG_DWHFeedStagingTable__c dwh_premise1 = new LG_DWHFeedStagingTable__c();
        string externalId_Premise = generateRandomNumber();
        externalId_Premise = externalId_Premise + '66_Premise';
        dwh_premise1.LG_Status__c = 'New';
        dwh_premise1.LG_TypeofRecord__c = 'Premise';
        dwh_premise1.LG_PremiseName__c = 'Home';
        dwh_premise1.LG_DWHTransactionId__c = transactionId;
        dwh_premise1.LG_AccountExternalId__c = externalId_Account;
        dwh_premise1.LG_PremiseExternalId__c = externalId_Premise;
        dwhInsertList.add(dwh_premise1);
        
        //initializing the Billing Account DWH data
        LG_DWHFeedStagingTable__c dwh_billingAccount1 = new LG_DWHFeedStagingTable__c();
        string externalId_billingAccount = generateRandomNumber();
        externalId_billingAccount = externalId_billingAccount + '66_billingAccount';
        dwh_billingAccount1.LG_Status__c = 'New';
        dwh_billingAccount1.LG_TypeofRecord__c = 'Billing Account';
        dwh_billingAccount1.LG_BillingAccountName__c = 'BillingAccount 6';
        dwh_billingAccount1.LG_BillingAccountName__c = 'BillingAccount 6';
        dwh_billingAccount1.LG_BillingAccountBillingChannel__c = 'Paper bill';
        dwh_billingAccount1.LG_BillingAccountDefault__c = True;
        dwh_billingAccount1.LG_DWHTransactionId__c = transactionId;
        dwh_billingAccount1.LG_AccountExternalId__c = externalId_Account;
        dwh_billingAccount1.LG_BillingAccountExternalId__c = externalId_billingAccount;
        dwhInsertList.add(dwh_billingAccount1);
        
        //initializing the Contract DWH data
        LG_DWHFeedStagingTable__c dwh_contract1 = new LG_DWHFeedStagingTable__c();
        string externalId_contract = generateRandomNumber();
        externalId_contract = externalId_contract + '66_contract';
        dwh_contract1.LG_Status__c = 'New';
        dwh_contract1.LG_TypeofRecord__c = 'Contract';
        dwh_contract1.LG_DWHTransactionId__c = transactionId;
        dwh_contract1.LG_AccountExternalId__c = externalId_Account;
        dwh_contract1.LG_ContractNumber__c = externalId_contract;
        dwh_contract1.LG_ContractStatus__c = 'Open';
        dwh_contract1.LG_ContractStartDate__c = system.today();
        dwh_contract1.LG_ContractEndDate__c = system.today() + 10;
        dwh_contract1.LG_ContractExpirationDate__c = system.today() + 100;
        dwhInsertList.add(dwh_contract1);
        
        //Create subscription and services in the database which are supposed to be updated by Tracy
        csord__Order_Request__c orderReq = new csord__Order_Request__c();
        orderReq.Name = 'OR Via Console 1';
        orderReq.csord__Module_Name__c = 'CS Order Implementation Module Telco A';
        orderReq.csord__Module_Version__c = '1.0';
        insert orderReq;
        
        Account acc = new Account();
        acc.Name = 'Test Account For DWH Test';
        acc.LG_ChamberOfCommerceNumber__c = chamberOfCommerce;
        acc.LG_Footprint__c = 'Ziggo';
        insert acc;
        
        csord__Order__c o = new csord__Order__c();
        o.Name = 'Order For ' + acc.Id;
        o.csord__Account__c = acc.Id;
        o.csord__Status2__c = 'Order Submitted';
        o.csord__Order_Request__c = orderReq.Id;
        o.csord__Identification__c = 'DWHTestBatchOn_' + system.now();
        insert o; 
                
        csord__Subscription__c subs = new csord__Subscription__c();
        subs.name = 'Connect MKB Internet Compleet';
        subs.csord__Account__c = acc.Id;
        subs.csord__Order_Request__c = orderReq.Id;
        subs.csord__Identification__c = 'externalId';
        subs.csord__Order__c = o.Id;
        insert subs;
        
        csord__Subscription__c subscriptionRecordFetched = new csord__Subscription__c();
        subscriptionRecordFetched = [Select Id, csordtelcoa__Subscription_Number__c from csord__Subscription__c where Id =: subs.Id limit 1];
        string subscriptionNumber = subscriptionRecordFetched.csordtelcoa__Subscription_Number__c;
        
        List<csord__Service__c> serviceList = new List<csord__Service__c>();
        csord__Service__c serv1 = new csord__Service__c();
        serv1.name = 'Connect MKB Internet Compleet';
        serv1.csord__Status__c = 'Service created';
        serv1.csord__Subscription__c = subs.Id;
        serv1.csord__Identification__c = 'someIdentificationNumber1';
        serv1.csord__Order_Request__c = orderReq.Id;
        serviceList.add(serv1);
        
        csord__Service__c serv2 = new csord__Service__c();
        serv2.name = 'Pin Zeker';
        serv2.csord__Status__c = 'Service created';
        serv2.csord__Subscription__c = subs.Id;
        serv2.csord__Identification__c = 'someIdentificationNumber2';
        serv2.csord__Order_Request__c = orderReq.Id;
        serviceList.add(serv2);
        
        insert serviceList;
        
        map<string, string> serviceMap = new map<string, string>();
        for(csord__Service__c serv: [Select Id, csordtelcoa__Service_Number__c, Name from csord__Service__c where Id IN: serviceList]){
            serviceMap.put(serv.Name, serv.csordtelcoa__Service_Number__c);
        }       
        
        
        //initializing the Subscription DWH data
        LG_DWHFeedStagingTable__c dwh_subscription1 = new LG_DWHFeedStagingTable__c();
        dwh_subscription1.LG_Status__c = 'New';
        dwh_subscription1.LG_TypeofRecord__c = 'Subscription';
        dwh_subscription1.LG_DWHTransactionId__c = transactionId;
        dwh_subscription1.LG_AccountExternalId__c = externalId_Account;
        dwh_subscription1.LG_SubscriptionNumber__c = subscriptionNumber;
        dwh_subscription1.LG_SubscriptionName__c = 'Connect MKB Internet Compleet';
        dwh_subscription1.LG_SubscriptionStatus__c = 'Active';
        dwh_subscription1.LG_SubscriptionContractNumber__c = externalId_contract;
        string externalId_subscription = generateRandomNumber();
        externalId_subscription = externalId_subscription + '11_Subs1';
        dwh_subscription1.LG_SubscriptionExternalId__c = externalId_subscription;
        dwhInsertList.add(dwh_subscription1);
        
        //initializing the Service DWH data for Connect MKB
        LG_DWHFeedStagingTable__c dwh_service1_ConnectMKB = new LG_DWHFeedStagingTable__c();
        dwh_service1_ConnectMKB.LG_Status__c = 'New';
        dwh_service1_ConnectMKB.LG_TypeofRecord__c = 'Service';
        dwh_service1_ConnectMKB.LG_DWHTransactionId__c = transactionId;
        dwh_service1_ConnectMKB.LG_AccountExternalId__c = externalId_Account;
        dwh_service1_ConnectMKB.LG_ServiceName__c = 'Connect MKB Internet Compleet';
        dwh_service1_ConnectMKB.LG_ServiceStatus__c = 'Active';
        dwh_service1_ConnectMKB.LG_ServiceNumber__c = serviceMap.get(dwh_service1_ConnectMKB.LG_ServiceName__c);
        dwh_service1_ConnectMKB.LG_ServiceQuantity__c = 2;
        dwh_service1_ConnectMKB.LG_ServiceUnitPrice__c = 20;
        dwh_service1_ConnectMKB.LG_ServiceContractTerm__c = 24;
        dwh_service1_ConnectMKB.LG_ServicePremiseId__c = externalId_Premise;
        string externalId_service1 = generateRandomNumber();
        externalId_service1 = externalId_service1 + '11_Serv1';
        dwh_service1_ConnectMKB.LG_ServiceExternalId__c = externalId_service1;
        dwhInsertList.add(dwh_service1_ConnectMKB);
        
        //initializing the Attribute DWH data for Connect MKB
        LG_DWHFeedStagingTable__c dwh_attribute1_ConnectMKB = new LG_DWHFeedStagingTable__c();
        dwh_attribute1_ConnectMKB.LG_Status__c = 'New';
        dwh_attribute1_ConnectMKB.LG_TypeofRecord__c = 'Attribute';
        dwh_attribute1_ConnectMKB.LG_DWHTransactionId__c = transactionId;
        dwh_attribute1_ConnectMKB.LG_AccountExternalId__c = externalId_Account;
        dwh_attribute1_ConnectMKB.LG_AttributeProductCategory__c = 'Internet';
        dwh_attribute1_ConnectMKB.LG_AttributeProductName__c = 'Connect MKB Internet Compleet';
        dwh_attribute1_ConnectMKB.LG_AttributeContractTerm__c = 24;
        dwh_attribute1_ConnectMKB.LG_AttributeOneOffCharge__c = 19.99;
        dwh_attribute1_ConnectMKB.LG_AttributeRecurringCharge__c = 19.99;
        dwhInsertList.add(dwh_attribute1_ConnectMKB);
    
        //initializing the Service DWH data for Pin
        LG_DWHFeedStagingTable__c dwh_service1_Pin = new LG_DWHFeedStagingTable__c();
        dwh_service1_Pin.LG_Status__c = 'New';
        dwh_service1_Pin.LG_TypeofRecord__c = 'Service';
        dwh_service1_Pin.LG_DWHTransactionId__c = transactionId;
        dwh_service1_Pin.LG_AccountExternalId__c = externalId_Account;
        dwh_service1_Pin.LG_ServiceName__c = 'Pin Zeker';
        dwh_service1_Pin.LG_ServiceStatus__c = 'Active';
        dwh_service1_Pin.LG_ServiceNumber__c = serviceMap.get(dwh_service1_Pin.LG_ServiceName__c);
        dwh_service1_Pin.LG_ServiceQuantity__c = 2;
        dwh_service1_Pin.LG_ServiceUnitPrice__c = 20;
        dwh_service1_Pin.LG_ServiceContractTerm__c = 24;
        dwh_service1_Pin.LG_ServicePremiseId__c = externalId_Premise;
        string externalId_service2 = generateRandomNumber();
        externalId_service2 = externalId_service2 + '11_Serv2';
        dwh_service1_Pin.LG_ServiceExternalId__c = externalId_service2;
        dwhInsertList.add(dwh_service1_Pin);
        
        //initializing the Attribute DWH data for Pin
        LG_DWHFeedStagingTable__c dwh_attribute1_Pin = new LG_DWHFeedStagingTable__c();
        dwh_attribute1_Pin.LG_Status__c = 'New';
        dwh_attribute1_Pin.LG_TypeofRecord__c = 'Attribute';
        dwh_attribute1_Pin.LG_DWHTransactionId__c = transactionId;
        dwh_attribute1_Pin.LG_AccountExternalId__c = externalId_Account;
        dwh_attribute1_Pin.LG_AttributeProductCategory__c = 'Related Products';
        dwh_attribute1_Pin.LG_AttributeProductName__c = 'Pin Zeker';
        dwh_attribute1_Pin.LG_AttributeContractTerm__c = 24;
        dwh_attribute1_Pin.LG_AttributePinType__c = 'Pin Zeker';
        dwh_attribute1_Pin.LG_AttributeOneOffCharge__c = 19.99;
        dwh_attribute1_Pin.LG_AttributeRecurringCharge__c = 19.99;
        dwhInsertList.add(dwh_attribute1_Pin);
    
        insert dwhInsertList;
        
        Test.startTest();
        string CRON_EXP = '0 10 * * * ? ';
        String jobId = System.schedule('LG_CreateDataFromDWHFeedSchedulable',CRON_EXP,new LG_CreateDataFromDWHFeedSchedulable());
        Test.stopTest();        
    }
    
    /*
        Name: TestMethod5_ExceptionHandling
        Purpose: Test method for testing the logic for handling the exception
        Argument: none
        Return type: none
    */
    /*
    static testmethod void TestMethod7_ManualSync() {
        
        /*LG_DWHIntegrationVariables__c dwhVar = new LG_DWHIntegrationVariables__c();
        dwhVar = [Select Id, Name from LG_DWHIntegrationVariables__c where Name = 'Limit_on_Accounts_Fetched'];
        dwhVar.LG_DisplayValue__c = '1';
        update dwhVar;*/
        /*
        List<LG_DWHFeedStagingTable__c> dwhInsertList = new List<LG_DWHFeedStagingTable__c>();
        string userId = userInfo.getuserId();
        
        string transactionId = generateRandomNumber();
        transactionId = transactionId + '1';
        
        string externalId_Account = generateRandomNumber();
        externalId_Account = externalId_Account + '11_Account';
        
        //initializing the account DWH data
        LG_DWHFeedStagingTable__c dwh_account1 = new LG_DWHFeedStagingTable__c();
        dwh_account1.LG_Status__c = 'New';
        dwh_account1.LG_TypeofRecord__c = 'Account';
        dwh_account1.LG_AccountName__c = 'DWH Test Account Only For TestClassCoverage';
        dwh_account1.LG_AccountPhone__c = '00001111';
        dwh_account1.LG_DWHTransactionId__c = transactionId;
        dwh_account1.LG_AccountExternalId__c = externalId_Account;
        dwh_account1.LG_AccountOwnerId__c = userId;
        string chamberOfCommerce = generateRandomNumberForChamberOfCommerce();
        chamberOfCommerce = chamberOfCommerce + '1';
        dwh_account1.LG_AccountChamberOfCommerceNumber__c = chamberOfCommerce;
        dwhInsertList.add(dwh_account1);
        
        //initializing the contact DWH data
        string externalId_Contact = generateRandomNumber();
        externalId_Contact = externalId_Contact + '11_Contact';
        LG_DWHFeedStagingTable__c dwh_contact1 = new LG_DWHFeedStagingTable__c();
        dwh_contact1.LG_Status__c = 'New';
        dwh_contact1.LG_TypeofRecord__c = 'Contact';
        dwh_contact1.LG_ContactFirstName__c = 'Test First Name';
        dwh_contact1.LG_ContactLastName__c = 'Test Last Name';
        dwh_contact1.LG_DWHTransactionId__c = transactionId;
        dwh_contact1.LG_AccountExternalId__c = externalId_Account;
        dwh_contact1.LG_ContactExternalID__c = externalId_Contact;
        dwh_contact1.LG_ContactOwnerId__c = userId;
        dwhInsertList.add(dwh_contact1);
        
        //initializing the premise DWH data
        LG_DWHFeedStagingTable__c dwh_premise1 = new LG_DWHFeedStagingTable__c();
        string externalId_Premise = generateRandomNumber();
        externalId_Premise = externalId_Premise + '11_Premise';
        dwh_premise1.LG_Status__c = 'New';
        dwh_premise1.LG_TypeofRecord__c = 'Premise';
        dwh_premise1.LG_PremiseName__c = 'Home';
        dwh_premise1.LG_DWHTransactionId__c = transactionId;
        dwh_premise1.LG_AccountExternalId__c = externalId_Account;
        dwh_premise1.LG_PremiseExternalId__c = externalId_Premise;
        dwh_premise1.LG_PremiseHouseNumber__c = '1';
        dwh_premise1.LG_PremiseHouseNumberExtension__c = '11';
        dwh_premise1.LG_PremiseStreet__c = 'Test Street 123';
        dwh_premise1.LG_PremiseCity__c = 'Test City 123';
        dwh_premise1.LG_PremisePostalCode__c = '9999XX';
        dwhInsertList.add(dwh_premise1);
        
        //initializing the Billing Account DWH data
        LG_DWHFeedStagingTable__c dwh_billingAccount1 = new LG_DWHFeedStagingTable__c();
        string externalId_billingAccount = generateRandomNumber();
        externalId_billingAccount = externalId_billingAccount + '11_billingAccount';
        dwh_billingAccount1.LG_Status__c = 'New';
        dwh_billingAccount1.LG_TypeofRecord__c = 'Billing Account';
        dwh_billingAccount1.LG_BillingAccountName__c = 'BillingAccount 1';
        dwh_billingAccount1.LG_BillingAccountName__c = 'BillingAccount 1';
        dwh_billingAccount1.LG_BillingAccountBillingChannel__c = 'Paper bill';
        dwh_billingAccount1.LG_BillingAccountDefault__c = True;
        dwh_billingAccount1.LG_DWHTransactionId__c = transactionId;
        dwh_billingAccount1.LG_AccountExternalId__c = externalId_Account;
        dwh_billingAccount1.LG_BillingAccountExternalId__c = externalId_billingAccount;
        dwhInsertList.add(dwh_billingAccount1);
        
        //initializing the Contract DWH data
        LG_DWHFeedStagingTable__c dwh_contract1 = new LG_DWHFeedStagingTable__c();
        string externalId_contract = generateRandomNumber();
        externalId_contract = externalId_contract + '11_contract';
        dwh_contract1.LG_Status__c = 'New';
        dwh_contract1.LG_TypeofRecord__c = 'Contract';
        dwh_contract1.LG_DWHTransactionId__c = transactionId;
        dwh_contract1.LG_AccountExternalId__c = externalId_Account;
        dwh_contract1.LG_ContractNumber__c = externalId_contract;
        dwh_contract1.LG_ContractStatus__c = 'Open';
        dwh_contract1.LG_ContractStartDate__c = system.today();
        dwh_contract1.LG_ContractEndDate__c = system.today() + 10;
        dwh_contract1.LG_ContractExpirationDate__c = system.today() + 100;
        dwhInsertList.add(dwh_contract1);
        
        //initializing the Subscription DWH data
        LG_DWHFeedStagingTable__c dwh_subscription1 = new LG_DWHFeedStagingTable__c();
        dwh_subscription1.LG_Status__c = 'New';
        dwh_subscription1.LG_TypeofRecord__c = 'Subscription';
        dwh_subscription1.LG_DWHTransactionId__c = transactionId;
        dwh_subscription1.LG_AccountExternalId__c = externalId_Account;
        dwh_subscription1.LG_SubscriptionName__c = 'Connect MKB Internet Compleet';
        dwh_subscription1.LG_SubscriptionStatus__c = 'Active';
        dwh_subscription1.LG_SubscriptionContractNumber__c = externalId_contract;
        dwhInsertList.add(dwh_subscription1);
        
        //initializing the Service DWH data for Connect MKB
        LG_DWHFeedStagingTable__c dwh_service1_ConnectMKB = new LG_DWHFeedStagingTable__c();
        dwh_service1_ConnectMKB.LG_Status__c = 'New';
        dwh_service1_ConnectMKB.LG_TypeofRecord__c = 'Service';
        dwh_service1_ConnectMKB.LG_DWHTransactionId__c = transactionId;
        dwh_service1_ConnectMKB.LG_AccountExternalId__c = externalId_Account;
        dwh_service1_ConnectMKB.LG_ServiceName__c = 'Connect MKB Internet Compleet';
        dwh_service1_ConnectMKB.LG_ServiceStatus__c = 'Active';
        dwh_service1_ConnectMKB.LG_ServiceQuantity__c = 2;
        dwh_service1_ConnectMKB.LG_ServiceUnitPrice__c = 20;
        dwh_service1_ConnectMKB.LG_ServiceContractTerm__c = 24;
        dwh_service1_ConnectMKB.LG_ServicePremiseId__c = externalId_Premise;
        dwhInsertList.add(dwh_service1_ConnectMKB);
        
        //initializing the Attribute DWH data for Connect MKB
        LG_DWHFeedStagingTable__c dwh_attribute1_ConnectMKB = new LG_DWHFeedStagingTable__c();
        dwh_attribute1_ConnectMKB.LG_Status__c = 'New';
        dwh_attribute1_ConnectMKB.LG_TypeofRecord__c = 'Attribute';
        dwh_attribute1_ConnectMKB.LG_DWHTransactionId__c = transactionId;
        dwh_attribute1_ConnectMKB.LG_AccountExternalId__c = externalId_Account;
        dwh_attribute1_ConnectMKB.LG_AttributeProductCategory__c = 'Internet';
        dwh_attribute1_ConnectMKB.LG_AttributeProductName__c = 'Connect MKB Internet Compleet';
        dwh_attribute1_ConnectMKB.LG_AttributeContractTerm__c = 24;
        dwh_attribute1_ConnectMKB.LG_AttributeDiscount__c = 'DISC-000030';
        dwh_attribute1_ConnectMKB.LG_AttributeOneOffCharge__c = 19.99;
        dwh_attribute1_ConnectMKB.LG_AttributeRecurringCharge__c = 19.99;
        dwhInsertList.add(dwh_attribute1_ConnectMKB);
    
        //initializing the Service DWH data for Pin
        LG_DWHFeedStagingTable__c dwh_service1_Pin = new LG_DWHFeedStagingTable__c();
        dwh_service1_Pin.LG_Status__c = 'New';
        dwh_service1_Pin.LG_TypeofRecord__c = 'Service';
        dwh_service1_Pin.LG_DWHTransactionId__c = transactionId;
        dwh_service1_Pin.LG_AccountExternalId__c = externalId_Account;
        dwh_service1_Pin.LG_ServiceName__c = 'Pin Zeker';
        dwh_service1_Pin.LG_ServiceStatus__c = 'Active';
        dwh_service1_Pin.LG_ServiceQuantity__c = 2;
        dwh_service1_Pin.LG_ServiceUnitPrice__c = 20;
        dwh_service1_Pin.LG_ServiceContractTerm__c = 24;
        dwh_service1_Pin.LG_ServicePremiseId__c = externalId_Premise;
        dwhInsertList.add(dwh_service1_Pin);
        
        //initializing the Attribute DWH data for Pin
        LG_DWHFeedStagingTable__c dwh_attribute1_Pin = new LG_DWHFeedStagingTable__c();
        dwh_attribute1_Pin.LG_Status__c = 'New';
        dwh_attribute1_Pin.LG_TypeofRecord__c = 'Attribute';
        dwh_attribute1_Pin.LG_DWHTransactionId__c = transactionId;
        dwh_attribute1_Pin.LG_AccountExternalId__c = externalId_Account;
        dwh_attribute1_Pin.LG_AttributeProductCategory__c = 'Related Products';
        dwh_attribute1_Pin.LG_AttributeProductName__c = 'Pin Zeker';
        dwh_attribute1_Pin.LG_AttributeContractTerm__c = 24;
        dwh_attribute1_Pin.LG_AttributePinType__c = 'Pin Zeker';
        dwh_attribute1_Pin.LG_AttributeOneOffCharge__c = 19.99;
        dwh_attribute1_Pin.LG_AttributeRecurringCharge__c = 19.99;
        dwhInsertList.add(dwh_attribute1_Pin);
    
        insert dwhInsertList;
        
        string uniqueId = transactionId + externalId_Account;
        LG_ManuallySyncDataFromDWH.syncManually(uniqueId);
        LG_ManuallySyncDataFromDWH.afterSyncAction(uniqueId, 'Processed Successfully');
        LG_ManuallySyncDataFromDWH.afterSyncAction(uniqueId, 'Failed');
            
    }
    
    /*
        Name: TestMethod5_ExceptionHandling
        Purpose: Test method for testing the logic for handling the exception
        Argument: none
        Return type: none
    */
    /*
    static testmethod void TestMethod8_ManualSyncErrorHandling() {
        
        /*LG_DWHIntegrationVariables__c dwhVar = new LG_DWHIntegrationVariables__c();
        dwhVar = [Select Id, Name from LG_DWHIntegrationVariables__c where Name = 'Limit_on_Accounts_Fetched'];
        dwhVar.LG_DisplayValue__c = '1';
        update dwhVar;*/
        /*
        List<LG_DWHFeedStagingTable__c> dwhInsertList = new List<LG_DWHFeedStagingTable__c>();
        string userId = userInfo.getuserId();
        
        string transactionId = generateRandomNumber();
        transactionId = transactionId + '4';
        
        string externalId_Account = generateRandomNumber();
        externalId_Account = externalId_Account + '44_Account';
        
        //initializing the account DWH data with incorrect Chamber of Commerce number
        LG_DWHFeedStagingTable__c dwh_account1 = new LG_DWHFeedStagingTable__c();
        dwh_account1.LG_Status__c = 'New';
        dwh_account1.LG_TypeofRecord__c = 'Account';
        dwh_account1.LG_AccountName__c = 'DWH Test Account Only For TestClassCoverage';
        dwh_account1.LG_AccountPhone__c = '00001111';
        dwh_account1.LG_DWHTransactionId__c = transactionId;
        dwh_account1.LG_AccountExternalId__c = externalId_Account;
        dwh_account1.LG_AccountOwnerId__c = userId;
        string chamberOfCommerce = generateRandomNumberForChamberOfCommerce();
        chamberOfCommerce = chamberOfCommerce + '5555';
        dwh_account1.LG_AccountChamberOfCommerceNumber__c = chamberOfCommerce;
        dwhInsertList.add(dwh_account1);
    
        insert dwhInsertList;
        
        string uniqueId = transactionId + externalId_Account;
        LG_ManuallySyncDataFromDWH.syncManually(uniqueId);
    }
    
    /*
        Name: generateRandomNumber
        Purpose: Method to create random external Id
        Argument: none
        Return type: none
    */
    /*
    public static string generateRandomNumber() {
        double a=(Math.random() + 1)*100000;
        integer b = a.intValue();
        string c = String.valueOf(b);
        return c;     
    }
    
    /*
        Name: generateRandomNumber
        Purpose: Method to create random Chamber Of Commerce Number
        Argument: none
        Return type: none
    */
    /*
    public static string generateRandomNumberForChamberOfCommerce() {
        double a=(Math.random() + 1)*1000000;
        integer b = a.intValue();
        string c = String.valueOf(b);
        return c;     
    } 
*/

}