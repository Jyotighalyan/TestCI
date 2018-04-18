@isTest
private class CustomButtonBDSSiteConnectionsTests {
    @isTest
    static void testperformAction() {
        Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
        LG_GeneralTest.createBillingAccount('BillingAccount', account.Id, true, true);
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Basket', account, null, opp, false);
        insert basket;
        
        cscfga__Product_Definition__c prodDefBDS = LG_GeneralTest.createProductDefinition(Label.BDS_Site, true);
        cscfga__Product_Definition__c prodDefVPN = LG_GeneralTest.createProductDefinition(Label.VPN_services, true);
        cscfga__Product_Definition__c prodDefConnection = LG_GeneralTest.createProductDefinition(Label.Company_VPN_Connection, false);     
        prodDefConnection.cscfga__Active__c= true;
        prodDefConnection.cscfga__IsArchived__c = false;
        Insert prodDefConnection;
        
        cscfga__Product_Configuration__c prodConfBDS = LG_GeneralTest.createProductConfiguration(
            'Site : test 1234', 0, basket, prodDefBDS, false);
        prodConfBDS.cscfga__Configuration_Status__c = 'Valid';
        prodConfBDS.LG_Persistent_Id__c = '1234';
        Insert prodConfBDS;        
        cscfga__Product_Configuration__c prodConfVPN1 = LG_GeneralTest.createProductConfiguration(
            'Company VPN : test1', 0, basket, prodDefVPN, false);
        prodConfVPN1.cscfga__Configuration_Status__c = 'Valid';
        prodConfVPN1.LG_Persistent_Id__c = '1234';
        Insert prodConfVPN1;        
        cscfga__Product_Configuration__c prodConfVPN2 = LG_GeneralTest.createProductConfiguration(
            'Company VPN : test2', 0, basket, prodDefVPN, false);
        prodConfVPN2.cscfga__Configuration_Status__c = 'Valid';
        prodConfVPN2.LG_Persistent_Id__c = '1234';
        Insert prodConfVPN2;       
                
    csbb__Product_Configuration_Request__c  pcr = new csbb__Product_Configuration_Request__c();
    pcr.csbb__Product_Configuration__c = prodConfBDS.Id;
    Insert pcr;
    
    CustomButtonManageBDSSiteConnections testClass = new CustomButtonManageBDSSiteConnections ();
    testClass.performAction(basket.Id,pcr.Id);
    }
    
    @isTest
    static void testperformActionNoValidConfig() {
        Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
        LG_GeneralTest.createBillingAccount('BillingAccount', account.Id, true, true);
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Basket', account, null, opp, false);
        insert basket;
        
        cscfga__Product_Definition__c prodDefBDS = LG_GeneralTest.createProductDefinition(Label.BDS_Site, false);
        cscfga__Product_Definition__c prodDefVPN = LG_GeneralTest.createProductDefinition(Label.VPN_services, false);        
        
        cscfga__Product_Configuration__c prodConfBDS = LG_GeneralTest.createProductConfiguration(
            'Site : test 1234', 0, basket, prodDefBDS, false);
        prodConfBDS.LG_Persistent_Id__c = '1234';
        Insert prodConfBDS;        
        cscfga__Product_Configuration__c prodConfVPN1 = LG_GeneralTest.createProductConfiguration(
            'Company VPN : test1', 0, basket, prodDefVPN, false);
        prodConfVPN1.cscfga__Configuration_Status__c = 'Valid';
        prodConfVPN1.LG_Persistent_Id__c = '1234';
        Insert prodConfVPN1;        
        cscfga__Product_Configuration__c prodConfVPN2 = LG_GeneralTest.createProductConfiguration(
            'Company VPN : test2', 0, basket, prodDefVPN, false);
        prodConfVPN2.cscfga__Configuration_Status__c = 'Valid';
        prodConfVPN2.LG_Persistent_Id__c = '1234';
        Insert prodConfVPN2;        
            
    csbb__Product_Configuration_Request__c  pcr = new csbb__Product_Configuration_Request__c();
    pcr.csbb__Product_Configuration__c = prodConfBDS.Id;
    Insert pcr;
    
    CustomButtonManageBDSSiteConnections testClass = new CustomButtonManageBDSSiteConnections ();
    testClass.performAction(basket.Id,pcr.Id);

    }
}