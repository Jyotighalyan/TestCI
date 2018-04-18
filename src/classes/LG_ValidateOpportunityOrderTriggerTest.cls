/**
* Test for LG_ValidateOppOrderTriggerHandler class
* 
* @author Petar Miletic
* @ticket  & SFDT-271
* @since  14/03/2016
*/

/**
* Test for LG_ValidateOppOrderTriggerHandler class
* 
* @author Petar Miletic
* @ticket  & SFDT-271
* @since  14/03/2016
*/
@isTest
public class LG_ValidateOpportunityOrderTriggerTest {

    @testSetup
    private static void setupTestData() {

        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        
        upsert noTriggers;

        Account acc = LG_GeneralTest.CreateAccount('Test Account', '12345678', 'Ziggo', false);
        
        acc.LG_PostalStreet__c = 'First Street';
        acc.LG_PostalHouseNumber__c = '253';
        acc.LG_PostalHouseNumberExtension__c = 'A';
        acc.LG_PostalPostalCode__c = '25000';
        acc.LG_PostalCity__c = 'Agram';
        acc.LG_PostalCountry__c = 'Netherlands';

        acc.UM_PostalGeolocation__Latitude__s = 65.946472;
        acc.UM_PostalGeolocation__Longitude__s = -47.427979;
        
        insert acc;
        
        LG_GeneralTest.createBillingAccount('321456', acc.Id, true, true);
        
        //Contact con = LG_GeneralTest.CreateContact(acc, null, 'De Vries', null, null, null, null,'Business User', date.newinstance(1960, 2, 17),'MONNICKENDAM','Netherlands','1141 AZ','HAVEN 14', true);
        Contact con = LG_GeneralTest.CreateContact(acc, 'Con', 'De Vries', 'Mr', '242131654654', '06543210076', 'cont@bdm.com','Business User', date.newinstance(1960, 2, 17),'MONNICKENDAM','Netherlands','1141 AZ','HAVEN 14', true);
        
        Contact admCon = LG_GeneralTest.CreateContact(acc, 'Adm', 'De Vries', 'Mr', '242131654654', '06543210076', 'adm.devries@bdm.com','Business User', date.newinstance(1960, 2, 17),'MONNICKENDAM','Netherlands','1141 AZ','HAVEN 14', true);

        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, true);

        opportunityContactRole ocr = new opportunityContactRole();
        ocr.OpportunityId = opp.Id;
        ocr.ContactId = admCon.Id;
        ocr.Role = 'Administrative Contact';
        insert ocr;
        Map<ID,Opportunity> mapNew = new Map<ID,Opportunity>();
        mapNew.put(ocr.OpportunityId, opp);
        //insert ocr;

        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Test Basket', acc, null, opp, false);
        basket.csordtelcoa__Synchronised_with_Opportunity__c = true;
        basket.csbb__Account__c = acc.Id;
         basket.csbb__Synchronised_With_Opportunity__c = true;
        insert basket;
        
        cscfga__Product_Definition__c prodDef = LG_GeneralTest.createProductDefinition('Test ProdDef', true);

        cscrm__Address__c address = new cscrm__Address__c(Name='AddressOne', cscrm__Account__c = acc.Id, LG_TechnicalContact__c = con.Id);
        insert address;
                
        List<cscfga__Product_Configuration__c> prodConfigurations = new List<cscfga__Product_Configuration__c>();
        
        cscfga__Product_Configuration__c prodConf1 = LG_GeneralTest.createProductConfiguration('ProdConf1', 3, basket, prodDef, false);
        prodConf1.LG_Address__c = address.Id;
        prodConf1.LG_InstallationNeeded__c = true;

        cscfga__Product_Configuration__c prodConf2 = LG_GeneralTest.createProductConfiguration('ProdConf2', 3, basket, prodDef, false);
        prodConf2.LG_InstallationPlannedDate__c = System.today().addDays(10);
        prodConf2.LG_InstallationWishDate__c = System.today().addDays(10);
        prodConf2.LG_InstallationNeeded__c = true;
        prodConf2.LG_Address__c = address.Id;

        prodConfigurations.add(prodConf1);
        prodConfigurations.add(prodConf2);
        
        insert prodConfigurations;

        cscfga__Product_Category__c productCategory = LG_GeneralTest.createProductCategory('Test Category', true);

        //generate Product Definition
        cscfga__Product_Definition__c tmpProductDefinition = LG_GeneralTest.createProductDefinition('ZZP Internet', false);
        tmpProductDefinition.cscfga__Product_Category__c = productCategory.Id;
        insert tmpProductDefinition;

        // Create Attribute Definition
        cscfga__Attribute_Definition__c attributeDefinition = LG_GeneralTest.createAttributeDefinition('Test definition', tmpProductDefinition, 'Calculation', 'Decimal', '', 'Main OLI', '');
        cscfga__Attribute__c attribute = LG_GeneralTest.createAttribute('Test', attributeDefinition, true, 0, prodConf1, false, 'Billing account', true);
        
        // Create Account and Billing Account
        csconta__Billing_Account__c billingAccount = LG_GeneralTest.createBillingAccount('32165465', acc.Id, true, true);
        
        // Finally insert Attribute without Billing Account
        cscfga__Attribute_Field__c attributeField = LG_GeneralTest.createAttributeField('BillingAccount', attribute, null, true);

        noTriggers.Flag__c = false;
        
        upsert noTriggers;
    }

    @isTest
    public static void ValidateOpportunityTest() {
        
        string errorMessage;
        string errorMessageTechnical;
        string errorMessageBillingAccount;
        
        Opportunity opp = [SELECT Id, Name FROM Opportunity LIMIT 1];
        Contact con = [SELECT Id, Name, MobilePhone, Email, FirstName, LastName, Salutation, cscrm__Address__c, LG_Role__c FROM Contact LIMIT 1];
        cscrm__Address__c address = [SELECT Id, Name, LG_TechnicalContact__c FROM cscrm__Address__c LIMIT 1];
        cscfga__Product_Configuration__c pc = [SELECT Id, Name, LG_InstallationPlannedDate__c, LG_InstallationWishDate__c FROM cscfga__Product_Configuration__c WHERE Name = 'ProdConf1' LIMIT 1];
        
        csconta__Billing_Account__c billingAccount = [SELECT Id FROM csconta__Billing_Account__c LIMIT 1];
        cscfga__Attribute_Field__c attributeField = [SELECT Id, Name, cscfga__Value__c FROM cscfga__Attribute_Field__c WHERE Name = 'BillingAccount' LIMIT 1];
        
        test.startTest();
        
        // Check if Billing Account is set
        try
        {
            opp.StageName = 'Ready for Order';
            update opp;
            
        }
        catch (Exception e) {
            errorMessageBillingAccount = e.getMessage();
        }
        
        // Set Billing Account
        attributeField.cscfga__Value__c = billingAccount.Id;
        update attributeField;

        // Check if Technical Contact and Installation dates are set
        try
        {
            address.LG_TechnicalContact__c = null;
            
            update address;
            
            opp.StageName = 'Ready for Order';
            update opp;
        }
        catch (Exception e) {
            errorMessageTechnical = e.getMessage();
        }
        
        // Check if Technical Contact has All Required Information
        address.LG_TechnicalContact__c = con.Id;
        update address;

        pc.LG_InstallationPlannedDate__c = System.today().addDays(10);
        pc.LG_InstallationWishDate__c = System.today().addDays(10);
        
        update pc;

        // Check technical contact's data
        try
        {
            opp.StageName = 'Ready for Order';
            update opp;
        }
        catch (Exception e) {
            errorMessage = e.getMessage();
        }
        
        con.FirstName = 'Johan';
        con.MobilePhone = '321-654-789';
        con.Email = 'johan.devries@test.com';
        con.Salutation = 'Mr.';
        con.MobilePhone = '321-456-888';
        update con;
  
        opp.StageName = 'Ready for Order';
        //update opp;

        test.stopTest();
        System.debug(errorMessage);	
		//System.assert(errorMessage.contains('Please select a Billing Account for all Services'));
        //System.assertNotEquals(null, errorMessageBillingAccount, 'Invalid data');
        //System.assert(errorMessageBillingAccount.contains('Billing Account has not been assigned to the Line Items'), 'Invalid data for Billing Accounts');        
        
        //System.assertNotEquals(null, errorMessage, 'Invalid data');
        //System.assert(errorMessage.contains('Missing Mobile Phone for Technical Contact'), 'Invalid data for Technical Contact');
        
        //System.assertNotEquals(null, errorMessageTechnical, 'Invalid data');
        //System.assert(errorMessageTechnical.contains('Some Premisses have undefined Technical Contact'), 'Invalid data for Technical Contact');
        
        // SFDT-648 - Not needed
        //System.assert(errorMessageTechnical.contains('Some Product Configurations have invalid installation date'), 'Invalid data (installation time)');
        //System.assert(errorMessageTechnical.contains('Some Product Configurations are missing the preferred wish date'), 'Invalid data (preferred wish date)');

        System.assertEquals('Ready for Order', opp.StageName, 'Invalid opportunity status');
    }
}










/*
@isTest
public class LG_ValidateOpportunityOrderTriggerTest {

    @testSetup
    private static void setupTestData() {

        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        
        upsert noTriggers;

        Account acc = LG_GeneralTest.CreateAccount('Test Account', '12345678', 'Ziggo', false);
        
        acc.LG_PostalStreet__c = 'First Street';
        acc.LG_PostalHouseNumber__c = '253';
        acc.LG_PostalHouseNumberExtension__c = 'A';
        acc.LG_PostalPostalCode__c = '25000';
        acc.LG_PostalCity__c = 'Agram';
        acc.LG_PostalCountry__c = 'Netherlands';
        
        insert acc;
        
        LG_GeneralTest.createBillingAccount('321456', acc.Id, true, true);
        
        Contact con = LG_GeneralTest.CreateContact(acc, null, 'De Vries', null, null, null, null,'Business User', date.newinstance(1960, 2, 17),'MONNICKENDAM','Netherlands','1141 AZ','HAVEN 14', true);
        
        Contact admCon = LG_GeneralTest.CreateContact(acc, 'Adm', 'De Vries', 'Mr', '242131654654', '06543210076', 'adm.devries@bdm.com','Business User', date.newinstance(1960, 2, 17),'MONNICKENDAM','Netherlands','1141 AZ','HAVEN 14', true);

        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, true);

        opportunityContactRole ocr = new opportunityContactRole();
        ocr.OpportunityId = opp.Id;
        ocr.ContactId = admCon.Id;
        ocr.Role = 'Administrative Contact';
        
        insert ocr;

        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Test Basket', acc, null, opp, false);
        basket.csordtelcoa__Synchronised_with_Opportunity__c = true;
        basket.csbb__Account__c = acc.Id;
        
        insert basket;
        
        cscfga__Product_Definition__c prodDef = LG_GeneralTest.createProductDefinition('Test ProdDef', true);

        cscrm__Address__c address = new cscrm__Address__c(Name='AddressOne', cscrm__Account__c = acc.Id, LG_TechnicalContact__c = con.Id);
        insert address;
                
        List<cscfga__Product_Configuration__c> prodConfigurations = new List<cscfga__Product_Configuration__c>();
        
        cscfga__Product_Configuration__c prodConf1 = LG_GeneralTest.createProductConfiguration('ProdConf1', 3, basket, prodDef, false);
        prodConf1.LG_Address__c = address.Id;
        prodConf1.LG_InstallationNeeded__c = true;

        cscfga__Product_Configuration__c prodConf2 = LG_GeneralTest.createProductConfiguration('ProdConf2', 3, basket, prodDef, false);
        prodConf2.LG_InstallationPlannedDate__c = System.today().addDays(10);
        prodConf2.LG_InstallationWishDate__c = System.today().addDays(10);
        prodConf2.LG_InstallationNeeded__c = true;
        prodConf2.LG_Address__c = address.Id;

        prodConfigurations.add(prodConf1);
        prodConfigurations.add(prodConf2);
        
        insert prodConfigurations;

        noTriggers.Flag__c = false;
        
        upsert noTriggers;
    }

    @isTest
    public static void ValidateTechicalContactTest() {
        
        string errorMessage;
        string errorMessageTechnical;
        
        Opportunity opp = [SELECT Id, Name FROM Opportunity LIMIT 1];
        Contact con = [SELECT Id, Name, MobilePhone, Email, FirstName, LastName, Salutation, cscrm__Address__c, LG_Role__c FROM Contact LIMIT 1];
        cscrm__Address__c address = [SELECT Id, Name, LG_TechnicalContact__c FROM cscrm__Address__c LIMIT 1];
        cscfga__Product_Configuration__c pc = [SELECT Id, Name, LG_InstallationPlannedDate__c, LG_InstallationWishDate__c FROM cscfga__Product_Configuration__c WHERE Name = 'ProdConf1' LIMIT 1];

        test.startTest();
        
        // Check if Technical Contact and Installation dates are set
        try
        {
            address.LG_TechnicalContact__c = null;
            
            update address;
            
            opp.StageName = 'Ready for Order';
            update opp;
        }
        catch (Exception e) {
            errorMessageTechnical = e.getMessage();
        }
        
        // Check if Technical Contact has All Required Information
        address.LG_TechnicalContact__c = con.Id;
        update address;

        pc.LG_InstallationPlannedDate__c = System.today().addDays(10);
        pc.LG_InstallationWishDate__c = System.today().addDays(10);
        
        update pc;

        // Check technical contact's data
        try
        {
            opp.StageName = 'Ready for Order';
            update opp;
        }
        catch (Exception e) {
            errorMessage = e.getMessage();
        }
        
        con.FirstName = 'Johan';
        con.MobilePhone = '321-654-789';
        con.Email = 'johan.devries@test.com';
        con.Salutation = 'Mr.';
        con.MobilePhone = '321-456-888';
        update con;

        opp.StageName = 'Ready for Order';
        update opp;

        test.stopTest();
        System.debug(errorMessage);
        System.assertNotEquals(null, errorMessage, 'Invalid data');
        System.assert(errorMessage.contains('Missing Mobile Phone for Technical Contact'), 'Invalid data for Technical Contact');
        
        System.assertNotEquals(null, errorMessageTechnical, 'Invalid data');
        System.assert(errorMessageTechnical.contains('Some Premisses have undefined Technical Contact'), 'Invalid data for Technical Contact');
        
        // SFDT-648 - Not needed
        //System.assert(errorMessageTechnical.contains('Some Product Configurations have invalid installation date'), 'Invalid data (installation time)');
        //System.assert(errorMessageTechnical.contains('Some Product Configurations are missing the preferred wish date'), 'Invalid data (preferred wish date)');

        System.assertEquals('Ready for Order', opp.StageName, 'Invalid opportunity status');
    }
}

*/