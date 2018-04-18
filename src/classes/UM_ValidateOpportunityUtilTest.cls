@isTest
private class UM_ValidateOpportunityUtilTest {

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
        
        Contact con = LG_GeneralTest.CreateContact(acc, 'Test', 'De Vries', 'Mr', null, null, 'test@cloudsense.com','Business User', date.newinstance(1960, 2, 17),'MONNICKENDAM','Netherlands','1141 AZ','HAVEN 14', true);

        Contact admCon = LG_GeneralTest.CreateContact(acc, 'Adm', 'De Vries', 'Mr', '01316546541', '07216540711', 'adm.devries@bdm.com','Business User', date.newinstance(1960, 2, 17),'MONNICKENDAM','Netherlands','1141 AZ','HAVEN 14', true);

        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, true);
      
        // Get REcord Type Id
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.CSCAP__Click_Approve_Setting__c; 
        Map<String,Schema.RecordTypeInfo> typeInfo = cfrSchema.getRecordTypeInfosByName();

        Id rtId = typeInfo.get('Sites Approval').getRecordTypeId();

        // Create Click Approve Settings
        CSCAP__Click_Approve_Setting__c setting = new CSCAP__Click_Approve_Setting__c();
        setting.Name = 'Sites Approval Settings - SEPA';
        setting.CSCAP__Associated_Email_Template_Name__c = 'SEPATest';
        setting.CSCAP__Send_Approval_Acknowledgment__c = true;
        setting.CSCAP__Status__c = 'Active';
        setting.RecordTypeId = rtId;
        setting.CSCAP__Acknowledgement_Template_Approvals__c = 'TestApprovals';
        setting.CSCAP__Acknowledgement_Template_Rejection__c = 'TestRejection';
        
        insert setting;

        opportunityContactRole ocr = new opportunityContactRole();
        ocr.OpportunityId = opp.Id;
        ocr.ContactId = admCon.Id;
        ocr.Role = 'Administrative Contact';
        ocr.isprimary=true;
        insert ocr;

        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Test Basket', acc, null, opp, false);
        basket.csordtelcoa__Synchronised_with_Opportunity__c = true;
        basket.LG_MarketSegment__c = 'SoHo';
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

        cscfga__Product_Category__c productCategory = LG_GeneralTest.createProductCategory('Test Category', true);

        //generate Product Definition
        cscfga__Product_Definition__c tmpProductDefinition = LG_GeneralTest.createProductDefinition('ZZP Internet', false);
        tmpProductDefinition.cscfga__Product_Category__c = productCategory.Id;
        insert tmpProductDefinition;

        // Create Attribute Definition
        cscfga__Attribute_Definition__c attributeDefinition = LG_GeneralTest.createAttributeDefinition('Test definition', tmpProductDefinition, 'Calculation', 'Decimal', '', 'Main OLI', '');
        cscfga__Attribute__c attribute = LG_GeneralTest.createAttribute('Test', attributeDefinition, true, 0, prodConf1, false, 'Billing account', true);
        cscfga__Attribute__c attribute2 = LG_GeneralTest.createAttribute('Test', attributeDefinition, true, 0, prodConf2, false, 'Billing account', true);
        

        // Create Account and Billing Account
        csconta__Billing_Account__c billingAccount = LG_GeneralTest.createBillingAccount('32165465', acc.Id, true, false);
        billingAccount.LG_BillingContact__c = con.Id;
        insert billingAccount;
        
        Mandate__c mandateDoc = new Mandate__c();
        mandateDoc.customer_signature__c = true;
        mandateDoc.Billing_Account__c = billingAccount.Id;
        insert mandateDoc;
        
        // Finally insert Attribute without Billing Account
        cscfga__Attribute_Field__c attributeField = LG_GeneralTest.createAttributeField('BillingAccount', attribute, null, true);
        cscfga__Attribute_Field__c attributeField2 = LG_GeneralTest.createAttributeField('BillingAccount', attribute2, null, false);
        attributeField2.cscfga__Value__c = billingAccount.Id;
        insert attributeField2;
        

        noTriggers.Flag__c = false;
        
        upsert noTriggers;
    }

    @isTest
    public static void ValidateOpportunityTest() {
       // Gnerate Email Templates
       User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs ( thisUser ) {
            LG_GeneralTest.crateEmailTemplate(thisUser, 'SEPATest', 'Approval needed', true);
            LG_GeneralTest.crateEmailTemplate(thisUser, 'TestApprovals', 'Approved', true);
            LG_GeneralTest.crateEmailTemplate(thisUser, 'TestRejection', 'Rejected', true);
        }
        
        string errorMessage;
        string errorInvalidatedPremises;
        string errorMessageTechnical;
        string errorMessageSEPA;
        string errorMessageBillingAccount;
        string errorMessageBillinContact;
        
        Opportunity opp = [SELECT Id, Name,stagename FROM Opportunity LIMIT 1];
        Contact con = [SELECT Id, Name, MobilePhone, Email, FirstName, LastName, Salutation, cscrm__Address__c, LG_Role__c FROM Contact LIMIT 1];
        cscrm__Address__c address = [SELECT Id, Name, LG_TechnicalContact__c, LG_AddressID__c FROM cscrm__Address__c LIMIT 1];
        cscfga__Product_Configuration__c pc = [SELECT Id, Name, LG_InstallationPlannedDate__c, LG_InstallationWishDate__c FROM cscfga__Product_Configuration__c WHERE Name = 'ProdConf1' LIMIT 1];
        
        csconta__Billing_Account__c billingAccount = [SELECT Id FROM csconta__Billing_Account__c LIMIT 1];
        cscfga__Attribute_Field__c attributeField = [SELECT Id, Name, cscfga__Value__c FROM cscfga__Attribute_Field__c WHERE Name = 'BillingAccount' AND cscfga__Value__c = NULL LIMIT 1];
        
        
        test.startTest();
        csordtelcoa__Orders_Subscriptions_Options__c cs=csordtelcoa__Orders_Subscriptions_Options__c.getInstance();

        // Check Ivalidated Premises
        try
        {
            opp.StageName = cs.csordtelcoa__Opportunity_Stages_creating_orders__c;
            update opp;
        }
        catch (Exception e) {
            errorInvalidatedPremises = e.getMessage();
        }
        
        address.LG_AddressID__c = '123456';
        update address;

        // Check if Billing Account is set
        try
        {
            opp.StageName = cs.csordtelcoa__Opportunity_Stages_creating_orders__c;
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
            
            opp.StageName = cs.csordtelcoa__Opportunity_Stages_creating_orders__c;
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
        pc.LG_Billing_Account__c = billingAccount.Id;
        update pc;

        // Check technical contact's data
        try
        {
            opp.StageName = cs.csordtelcoa__Opportunity_Stages_creating_orders__c;
            update opp;
        }
        catch (Exception e) {
            errorMessage = e.getMessage();
        }
        
        con.FirstName = 'Johan';
        con.MobilePhone = '07216540789';
        con.Email = 'johan.devries@test.com';
        con.Salutation = 'Mr.';
        con.MobilePhone = '07216540789';
        update con;
        
        // Check SEPA Mandates
        try
        {
            opp.StageName = cs.csordtelcoa__Opportunity_Stages_creating_orders__c;
            update opp;
        }
        catch (Exception e) {
            errorMessageSEPA = e.getMessage();
        }
        
        billingAccount.LG_BillingContact__c = con.Id;
        billingAccount.LG_PaymentType__c = 'Direct Debit';
        billingAccount.LG_BankAccountHolder__c = 'TEST';
        billingAccount.LG_BankAccountNumberIBAN__c = 'DE85604500500002819471';
        update billingAccount;
            try
        {
        opp.StageName = cs.csordtelcoa__Opportunity_Stages_creating_orders__c;
        update opp;
            }
            catch (Exception e) {
            errorMessageBillinContact= e.getMessage();
        }
        
        LG_Submit_Order_Validations_On_Off__c  submittingUser = LG_Submit_Order_Validations_On_Off__c.getInstance(UserInfo.getUserId());
        submittingUser.Method_Name__c = 'checkSendViaEmail;DDmandateCheck;ValidateOpportunity;validatePrimaryContact;';
        submittingUser.Flag__c = true;
        insert submittingUser;
        
        UM_ValidateOpportunityUtil um=new UM_ValidateOpportunityUtil ();
        um.ValidateOpportunityUtil(opp);
        um.DDmandateCheck(opp);
        um.checkProductBasket(opp.id);
        um.getSCCase(opp.id);
        um.servicecasecheck(opp.id);
        um.SCCategorycheck(opp.id);
        um.validatePrimaryContact(opp);
        
        con.FirstName = null;
        con.MobilePhone = null;
        con.Email = null;
        con.MobilePhone = null;
        update con;
        
        um.ValidateOpportunityUtil(opp);
        
        test.stopTest();

        
    }
}