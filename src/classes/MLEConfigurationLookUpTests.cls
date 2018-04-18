@isTest
private class MLEConfigurationLookUpTests {
    @isTest
    static void testdoLookupSearchBDSSet() {
        Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);
            Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
            LG_GeneralTest.createBillingAccount('BillingAccount', account.Id, true, true);
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Basket', account, null, opp, false);
        insert basket;
        
        cscfga__Product_Definition__c prodDefBDS = LG_GeneralTest.createProductDefinition(Label.BDS_Site, false);
        cscfga__Product_Definition__c prodDefVPN = LG_GeneralTest.createProductDefinition(Label.VPN_services, false);        
        
        cscfga__Product_Configuration__c prodConfBDS = LG_GeneralTest.createProductConfiguration(
            'Site : test 1234', 0, basket, prodDefBDS, false);
        prodConfBDS.cscfga__Product_Family__c = Label.BDS_Site;
        Insert prodConfBDS;
        
        cscfga__Product_Configuration__c prodConfVPN1 = LG_GeneralTest.createProductConfiguration(
            'Company VPN : test1', 0, basket, prodDefVPN, false);
        prodConfVPN1.cscfga__Product_Family__c = Label.VPN_services;
        Insert prodConfVPN1;
        
        cscfga__Product_Configuration__c prodConfVPN2 = LG_GeneralTest.createProductConfiguration(
            'Company VPN : test2', 0, basket, prodDefVPN, false);
        prodConfVPN2.cscfga__Product_Family__c = Label.VPN_services;
        Insert prodConfVPN2;
        
        Map<String,String> searchFileds = new Map<String,String>();
        searchFileds.put('Basket Id',basket.Id);
        searchFileds.put('Site Configuration Id',prodConfBDS.Id);      
               
        MLEConfigurationLookUp testClass = new MLEConfigurationLookUp();
        Object[] pcs = testClass.doLookupSearch(searchFileds,null,null,null,null);
    }
    
    @isTest
    static void testdoLookupSearchVPNSet() {
        Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);
            Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
            LG_GeneralTest.createBillingAccount('BillingAccount', account.Id, true, true);
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Basket', account, null, opp, false);
        insert basket;
        
        cscfga__Product_Definition__c prodDefBDS = LG_GeneralTest.createProductDefinition(Label.BDS_Site, false);
        cscfga__Product_Definition__c prodDefVPN = LG_GeneralTest.createProductDefinition(Label.VPN_services, false);        
        
        cscfga__Product_Configuration__c prodConfBDS1 = LG_GeneralTest.createProductConfiguration(
            'Site : test 1234', 0, basket, prodDefBDS, false);
        prodConfBDS1.cscfga__Product_Family__c = Label.BDS_Site;
        Insert prodConfBDS1 ;
        
        cscfga__Product_Configuration__c prodConfVPN1 = LG_GeneralTest.createProductConfiguration(
            'Company VPN : test1', 0, basket, prodDefVPN, false);
        prodConfVPN1.cscfga__Product_Family__c = Label.VPN_services;
        Insert prodConfVPN1;
        
        Map<String,String> searchFileds = new Map<String,String>();
        searchFileds.put('Basket Id',basket.Id);
        searchFileds.put('VPN Configuration Id',prodConfVPN1.Id);       
        
        MLEConfigurationLookUp testClass = new MLEConfigurationLookUp();
        Object[] pcs = testClass.doLookupSearch(searchFileds,null,null,null,null);
    }
}