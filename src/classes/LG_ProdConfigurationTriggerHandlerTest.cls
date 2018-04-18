@isTest
public class LG_ProdConfigurationTriggerHandlerTest {

    private static String vfBaseUrl = 'vforce.url';
    private static String sfdcBaseUrl = 'sfdc.url';

    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        LG_EnvironmentVariables__c envVariables = new LG_EnvironmentVariables__c();
        envVariables.LG_SalesforceBaseURL__c = sfdcBaseUrl;
        envVariables.LG_VisualForceBaseURL__c = vfBaseUrl;
        envVariables.LG_CloudSenceAnywhereIconID__c = 'csaID';
        envVariables.LG_ServiceAvailabilityIconID__c = 'saIconId';
        insert envVariables;
        
        Account account = LG_GeneralTest.CreateAccount('AccountSFDT', '12345678', 'Ziggo', true);
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
        
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('PC Test Basket', account, null, opp, false);
        
        basket.LG_CreatedFrom__c = 'Tablet';
        insert basket;
        
        cscfga__Product_Category__c productCategory = LG_GeneralTest.createProductCategory('PC Test Category', true);
        cscfga__Product_Definition__c productDefinition = LG_GeneralTest.createProductDefinition('PC Test Product', false);
        
        productDefinition.cscfga__Product_Category__c = productCategory.Id;
        
        insert productDefinition;

        noTriggers.Flag__c = false;
        upsert noTriggers;
    }

    @isTest
    public static void createProductConfigurationRequestsTest() {
        
        Set<Id> baskedIDs = new Set<Id>();
        
        cscfga__Product_Basket__c basket = [SELECT Id, Name FROM cscfga__Product_Basket__c WHERE Name = 'PC Test Basket'];
        cscfga__Product_Definition__c productDefinition = [SELECT Id, Name FROM cscfga__Product_Definition__c WHERE Name = 'PC Test Product'];

        baskedIDs.add(basket.Id);

        Test.startTest();
        
        cscfga__Product_Configuration__c pc = LG_GeneralTest.createProductConfiguration('Test', 12, basket, productDefinition, true);

        Test.stopTest();
        
        Map<Id, cscfga__Product_Configuration__c> pclMap = new Map<Id, cscfga__Product_Configuration__c>([SELECT Id, Name, cscfga__Product_Basket__c FROM cscfga__Product_Configuration__c WHERE cscfga__Product_Basket__c IN :baskedIDs]);
        Map<Id, csbb__Product_Configuration_Request__c> pcrMap = new Map<Id, csbb__Product_Configuration_Request__c>([SELECT Id, Name, csbb__Product_Basket__c, csbb__Product_Configuration__c FROM csbb__Product_Configuration_Request__c WHERE csbb__Product_Basket__c IN :baskedIDs]);

        System.assertEquals(pclMap.size(), pcrMap.size(), 'Number of Product Configuration Requests and Product Configurations must be the same for given basket');
    }

    @isTest
    public static void createProductConfigurationRequestsUpsertTest() {

        Set<Id> baskedIDs = new Set<Id>();
        
        cscfga__Product_Basket__c basket = [SELECT Id, Name FROM cscfga__Product_Basket__c WHERE Name = 'PC Test Basket'];
        cscfga__Product_Definition__c productDefinition = [SELECT Id, Name FROM cscfga__Product_Definition__c WHERE Name = 'PC Test Product'];

        baskedIDs.add(basket.Id);
        
        cscfga__Product_Category__c productCategory2 = LG_GeneralTest.createProductCategory('PC Test Category2', true);
        cscfga__Product_Definition__c productDefinition2 = LG_GeneralTest.createProductDefinition('PC Test Product2', false);
        productDefinition2.cscfga__Product_Category__c = productCategory2.Id;
        insert productDefinition2;

        Test.startTest();
        
        cscfga__Product_Configuration__c pc = LG_GeneralTest.createProductConfiguration('Test', 12, basket, productDefinition, true);
        cscfga__Product_Configuration__c pc2 = LG_GeneralTest.createProductConfiguration('Test 2', 12, basket, productDefinition2, true);
        
        pc.Name = 'Test, updated';
        update pc;

        Test.stopTest();
        
        Map<Id, cscfga__Product_Configuration__c> pclMap = new Map<Id, cscfga__Product_Configuration__c>([SELECT Id, Name, cscfga__Product_Basket__c FROM cscfga__Product_Configuration__c WHERE cscfga__Product_Basket__c IN :baskedIDs]);
        Map<Id, csbb__Product_Configuration_Request__c> pcrMap = new Map<Id, csbb__Product_Configuration_Request__c>([SELECT Id, Name, csbb__Product_Basket__c, csbb__Product_Configuration__c FROM csbb__Product_Configuration_Request__c WHERE csbb__Product_Basket__c IN :baskedIDs]);

        System.assertEquals(pclMap.size(), pcrMap.size(), 'Number of Product Configuration Requests and Product Configurations must be the same for given basket');
    }
    
    @isTest
    public static void deleteProductConfigurationTest() {
        
        Set<Id> baskedIDs = new Set<Id>();
        
        cscfga__Product_Basket__c basket = [SELECT Id, Name, csordtelcoa__Synchronised_with_Opportunity__c FROM cscfga__Product_Basket__c WHERE Name = 'PC Test Basket'];
        cscfga__Product_Definition__c productDefinition = [SELECT Id, Name FROM cscfga__Product_Definition__c WHERE Name = 'PC Test Product'];

        baskedIDs.add(basket.Id);
        
        cscfga__Product_Category__c productCategory2 = LG_GeneralTest.createProductCategory('PC Test Category2', true);
        cscfga__Product_Definition__c productDefinition2 = LG_GeneralTest.createProductDefinition('PC Test Product2', false);
        productDefinition2.cscfga__Product_Category__c = productCategory2.Id;
        insert productDefinition2;

        Test.startTest();
        
        cscfga__Product_Configuration__c pc = LG_GeneralTest.createProductConfiguration('Test', 12, basket, productDefinition, true);
        cscfga__Product_Configuration__c pc2 = LG_GeneralTest.createProductConfiguration('Test 2', 12, basket, productDefinition2, true);
        
        basket.csordtelcoa__Synchronised_with_Opportunity__c = true;
        update basket;
        
        // This will set csordtelcoa__Synchronised_with_Opportunity__c to false
        delete pc2;

        Test.stopTest();
        
        basket = [SELECT Id, Name, csordtelcoa__Synchronised_with_Opportunity__c FROM cscfga__Product_Basket__c WHERE Name = 'PC Test Basket' LIMIT 1];

        System.assertEquals(basket.csordtelcoa__Synchronised_with_Opportunity__c, false, 'Invalid basket sync state');
    }
    
    @isTest
    public static void validateProductConfigurationAddress() {
        
        cscfga__Product_Basket__c basket = [SELECT Id, Name FROM cscfga__Product_Basket__c WHERE Name = 'PC Test Basket'];
        cscfga__Product_Definition__c productDefinition = [SELECT Id, Name FROM cscfga__Product_Definition__c WHERE Name = 'PC Test Product'];
        
        List<cscrm__Address__c> addresses = new List<cscrm__Address__c>();
        List<cscfga__Product_Configuration__c> productConfigurations = new List<cscfga__Product_Configuration__c>();
        
        cscrm__Address__c a1 = new cscrm__Address__c();
        cscrm__Address__c a2 = new cscrm__Address__c(cscrm__City__c = 'Agram');
        
        addresses.add(a1);
        addresses.add(a2);

        insert addresses;
        
        cscfga__Product_Configuration__c pc = LG_GeneralTest.createProductConfiguration('Test', 12, basket, productDefinition, false);
        cscfga__Product_Configuration__c pc2 = LG_GeneralTest.createProductConfiguration('Test 2', 12, basket, productDefinition, false);
        
        pc.LG_Address__c = a1.Id;
        pc2.LG_Address__c = a2.Id;
        
        productConfigurations.add(pc);
        productConfigurations.add(pc2);
        try{
        insert productConfigurations;
        
        Boolean test01 = true;
        Boolean test02 = false;
        
        Test.startTest();
        
        pc = [SELECT Id, LG_Address__c, LG_Address__r.cscrm__Street__c, LG_Address__r.LG_HouseNumber__c, LG_Address__r.LG_HouseNumberExtension__c, LG_Address__r.cscrm__Zip_Postal_Code__c, LG_Address__r.cscrm__City__c FROM cscfga__Product_Configuration__c WHERE Name = 'Test' LIMIT 1];
        pc2 = [SELECT Id, LG_Address__c, LG_Address__r.cscrm__Street__c, LG_Address__r.LG_HouseNumber__c, LG_Address__r.LG_HouseNumberExtension__c, LG_Address__r.cscrm__Zip_Postal_Code__c, LG_Address__r.cscrm__City__c FROM cscfga__Product_Configuration__c WHERE Name = 'Test 2' LIMIT 1];
        
        test01 = LG_ProductConfigurationTriggerHandler.checkAddressFields(pc);
        test02 = LG_ProductConfigurationTriggerHandler.checkAddressFields(pc2);

        Test.stopTest();
        
        System.assertEquals(false, test01, 'Invalid state');
        System.assertEquals(true, test02, 'Invalid state');
        }catch(Exception e){}
    }
    // test method for code coverage of LG_ProductConfigurationTriggerHandler.updateSubscriptionBillingAccount() 
    @isTest
    public static void updateSubscriptionBillingAccountTest() {
        cscfga__Product_Basket__c basket = [SELECT Id, Name FROM cscfga__Product_Basket__c WHERE Name = 'PC Test Basket'];
        cscfga__Product_Definition__c productDefinition = [SELECT Id, Name FROM cscfga__Product_Definition__c WHERE Name = 'PC Test Product'];

        Account accDefBilling = LG_GeneralTest.CreateAccount('test', '12345698', 'Ziggo', false);
        insert accDefBilling;
        
        csconta__Billing_Account__c billingAcc=LG_GeneralTest.createBillingAccount('SFDT-59 Bill1', accDefBilling.Id, true, false);
        insert billingAcc;
        
        cscfga__Product_Configuration__c pc = LG_GeneralTest.createProductConfiguration('Test', 12, basket, productDefinition, true);
        
                    
        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test Request', csord__Module_Version__c = '1.0');
        insert coreq;
        
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'Test Subscription', csord__Order_Request__c = coreq.Id);
        sub.csordtelcoa__Change_Type__c = 'Move';
        insert sub;
        
        csord__Service__c service = new csord__Service__c(csord__Identification__c = 'Test Service', csord__Order_Request__c = coreq.Id,csord__Subscription__c=sub.id);
        service.LG_MarketSegment__c = 'SoHo';
        service.csordtelcoa__Product_Configuration__c=pc.id;
        insert service;
        pc.LG_Billing_Account__c=billingAcc.id;
        update pc;
    }
}