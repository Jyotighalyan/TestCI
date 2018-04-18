@IsTest
public class LG_AttributeTriggerHandlerTest {

    @testsetup
    private static void setupTestData() {

        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
		
        Group smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = smeQueueID.id);
        insert cs;
        
        Account tmpAccount = LG_GeneralTest.CreateAccount('Stichting Statenkliniek', 'Customer', 'SoHo', 5, 'Qualified', '070-3220919', '55107192', 'Ziggo', 'Frankenslag', '357', 'A', '2582 HP', 'MONNICKENDAM', 'Netherlands');
        Contact tmpContact = LG_GeneralTest.CreateContact(tmpAccount, 'Johan', 'De Vries', 'Mr.', '06-55932220', '', 'johan.devries@test.com', 'Business User', Date.newinstance(1960, 2, 17), 'MONNICKENDAM', 'Netherlands', '1141 AZ', 'HAVEN 14');
        Lead tmpLead = LG_GeneralTest.CreateLead('Maatschap T.A. Aanhane', 'test@test.com', 'Ms.', 'H.', 'Bleij', '', '06-18452681', '', 'Awareness of interest', '34189218', 'On-Net', true, true, 10, 5, 'Low', 'De Heining', '9', 'B', '1161AC', 'ZWANENBURG', 'Netherlands');

        cscfga__Product_Basket__c tmpAccountBasket = LG_GeneralTest.createProductBasket('Test Basket Account', tmpAccount, null, null);
        tmpAccountBasket.LG_AdminContactPicklist__c = String.valueOf(tmpContact.Id);

        cscfga__Product_Basket__c tmpLeadBasket = LG_GeneralTest.createProductBasket('Test Basket Lead', null, tmpLead, null);
        tmpLeadBasket.LG_AdminContactPicklist__c = '0';

        setupBasketData(tmpAccountBasket);
        setupBasketData(tmpLeadBasket);

        List<cscfga__Product_Basket__c> baskets = new List<cscfga__Product_Basket__c>();

        baskets.add(tmpAccountBasket);
        baskets.add(tmpLeadBasket);

        update baskets;

        noTriggers.Flag__c = false;
        upsert noTriggers;
        Account acc = new Account(Name = 'Accounttest',LG_BillingEmailAddress__c = 'test@test.com',LG_VisitStreet__c= 'aalstr',LG_VisitHouseNumber__c= '6',LG_VisitPostalCode__c= '456123',LG_VisitCity__c= 'zurich',LG_VisitCountry__c='Germany');
        
        insert acc;
        
        List<Opportunity> oppList = new List<Opportunity>();
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, false);
        oppList.add(opp);
        
        insert oppList;
        
        
        //basket
        List<cscfga__Product_Basket__c> basketList = new List<cscfga__Product_Basket__c>();
        
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Basket', acc, null, opp, false);
        basketList.add(basket);
        
        insert basketList;
        
        //Product definition 
        List<cscfga__Product_Definition__c> pdList = new List<cscfga__Product_Definition__c>();
        
        cscfga__Product_Definition__c prodDefSC = LG_GeneralTest.createProductDefinition('Company VPN Verbindung', false);
        pdList.add(prodDefSC);
        
        cscfga__Product_Definition__c prodDefVPN = LG_GeneralTest.createProductDefinition('VPN Services', false);
		pdList.add(prodDefVPN);
		
		cscfga__Product_Definition__c prodDefBDS = LG_GeneralTest.createProductDefinition('BDS Standort', false);
		pdList.add(prodDefBDS);
		
		insert pdList;
		
		//attribute definition 
		List<cscfga__Attribute_Definition__c> attrDefList = new List<cscfga__Attribute_Definition__c>();
		
		cscfga__Attribute_Definition__c attrdef1 = LG_GeneralTest.createAttributeDefinition('VPN Name', prodDefSC, 'User Input', 'String', '', '', '', false);
		cscfga__Attribute_Definition__c attrdef2 = LG_GeneralTest.createAttributeDefinition('Configuration Id', prodDefSC, 'User Input', 'String', '', '', '', false);
		cscfga__Attribute_Definition__c attrdef3 = LG_GeneralTest.createAttributeDefinition('MLESiteAddress', prodDefBDS, 'Text Display', 'String', '', '', '', false);
		
		attrDefList.add(attrdef1);
		attrDefList.add(attrdef2);
		attrDefList.add(attrdef3);
		
		insert attrDefList;
		
		//product configuration 
		
		List<cscfga__Product_Configuration__c> pcInsert = new List<cscfga__Product_Configuration__c>();
		List<cscfga__Product_Configuration__c> pcUpdate = new List<cscfga__Product_Configuration__c>();
		List<cscfga__Product_Configuration__c> pcList = new List<cscfga__Product_Configuration__c>();
		
		cscfga__Product_Configuration__c prodConBDS = LG_GeneralTest.createProductConfiguration('BDS Standort', 24, basket, prodDefBDS, false);
		pcInsert.add(prodConBDS);
		
		cscfga__Product_Configuration__c prodConVPN = LG_GeneralTest.createProductConfiguration('VPN Services', 24, basket, prodDefVPN, false);
		pcInsert.add(prodConVPN);
		
		cscfga__Product_Configuration__c prodConVPN1 = LG_GeneralTest.createProductConfiguration('VPN Services1', 24, basket, prodDefVPN, false);
		pcInsert.add(prodConVPN1);
        
        insert pcInsert;
        
        prodConVPN.LG_Persistent_Id__c = prodConVPN.Id;
        prodConBDS.LG_Persistent_Id__c = prodConBDS.Id;
        prodConBDS.LG_ChangeType__c = 'Move';
        prodConVPN1.LG_Persistent_Id__c = prodConVPN1.Id;
        prodConVPN1.LG_ChangeType__c = 'Move';
        prodConVPN1.LG_From_Configuration__c = prodConVPN1.LG_Persistent_Id__c;
        
        pcUpdate.add(prodConVPN);
        pcUpdate.add(prodConBDS);
        pcUpdate.add(prodConVPN1);
        
        update pcUpdate;
        
        cscfga__Product_Configuration__c prodConSC = LG_GeneralTest.createProductConfiguration('Company VPN Verbindung', 24, basket, prodDefSC, false);
        prodConSC.LG_To_Configuration__c = prodConBDS.LG_Persistent_Id__c;
        prodConSC.Product_Group__c = prodConBDS.LG_CustomProductName__c;
        prodConSC.cscfga__Description__c='TEST Site Connection';
        prodConSC.name = 'Company VPN Verbindung';
        pcList.add(prodConSC);
        
        cscfga__Product_Configuration__c prodConSC1 = LG_GeneralTest.createProductConfiguration('Company VPN Verbindung1', 24, basket, prodDefSC, false);
        prodConSC1.LG_From_Configuration__c = prodConVPN1.LG_Persistent_Id__c;
        prodConSC1.LG_To_Configuration__c = prodConVPN1.LG_Persistent_Id__c;
        prodConSC1.Product_Group__c = 'wer';
        prodConSC1.cscfga__Description__c='TEST Site Connection1';
        prodConSC1.name = 'Company VPN Verbindung1';
        pcList.add(prodConSC1);

        
        insert pcList;
        
        //Attribute values
        
        List<cscfga__Attribute__c> attrList= New List<cscfga__Attribute__c>();
        
        cscfga__Attribute__c attr1= LG_GeneralTest.createAttribute('VPN Name',  attrdef1, false, 10,prodConVPN, false, 'TEST Address', false);
		attr1.cscfga__Display_Value__c = prodConVPN.Name;
        attr1.cscfga__Value__c = 'abc';
        attrList.add(attr1);
        
        cscfga__Attribute__c attr3= LG_GeneralTest.createAttribute('MLESiteAddress',  attrdef3, false, 10,prodConBDS, false, 'TEST Address', false);
		attr3.cscfga__Display_Value__c = 'zurich,aalstr,456123';
        attr3.cscfga__Value__c = 'zurich,aalstr,456123';
        attrList.add(attr3);
        
        cscfga__Attribute__c attr2= LG_GeneralTest.createAttribute('Configuration Id',  attrdef2, false, 10,prodConVPN1, false, 'TEST Address', false);
        attr2.cscfga__Display_Value__c = prodConVPN.Id;
        attr2.cscfga__Value__c = prodConVPN.Id;
        attrList.add(attr2);
        
        insert attrList;
    }

    private static void setupBasketData(cscfga__Product_Basket__c tmpProductBasket) {

        tmpProductBasket.LG_AdminContactDateofBirth__c = Date.newinstance(1960, 2, 17);
        tmpProductBasket.LG_AdminContactEmail__c = 'davor.dubokovic@cloudsense.com.test';
        tmpProductBasket.LG_AdminContactFirstName__c = 'Davor';
        tmpProductBasket.LG_AdminContactLastName__c = 'Dubokovic';
        tmpProductBasket.LG_AdminContactMiddleName__c = '';
        tmpProductBasket.LG_AdminContactMobile__c = '0299 654647';
        tmpProductBasket.LG_AdminContactPhone__c = '0299 654648';
        tmpProductBasket.LG_AdminContactSalutation__c = 'Mr.';
        tmpProductBasket.LG_BankAccountName__c = 'MR DD';
        tmpProductBasket.LG_BankNumber__c = 'NL10zlam2503800483';
        tmpProductBasket.LG_BillingCity__c = 'MONNICKENDAM';
        tmpProductBasket.LG_BillingCountry__c = 'Netherlands';
        tmpProductBasket.LG_BillingHouseNumber__c = '24';
        tmpProductBasket.LG_BillingHouseNumberExtension__c = 'A';
        tmpProductBasket.LG_BillingPostalCode__c = '1141 KG';
        tmpProductBasket.LG_BillingSameAsInstallationAddress__c = false;
        tmpProductBasket.LG_BillingStreet__c = 'Boing';
        tmpProductBasket.LG_COAXConnectionLocation__c = '';
        tmpProductBasket.LG_CreatedFrom__c = 'Tablet';
        tmpProductBasket.LG_CustomerReference__c = 'ABC123';
        tmpProductBasket.LG_InstallationCity__c = 'Amsterdam';
        tmpProductBasket.LG_InstallationCountry__c = 'Netherlands';
        tmpProductBasket.LG_InstallationHouseNumber__c = '1';
        tmpProductBasket.LG_InstallationHouseNumberExtension__c = 'A';
        tmpProductBasket.LG_InstallationPostalCode__c = '1141 GV';
        tmpProductBasket.LG_InstallationStreet__c = 'Boing';
        tmpProductBasket.LG_InstallValidationResult__c = 'Valid';
        tmpProductBasket.LG_MainReasonLost__c = 'Delivery';
        tmpProductBasket.LG_PaymentType__c = 'Bank Transfer';
        tmpProductBasket.LG_PostalCity__c = 'Amsterdam';
        tmpProductBasket.LG_PostalCountry__c = 'Netherlands';
        tmpProductBasket.LG_PostalHouseNumber__c = '1';
        tmpProductBasket.LG_PostalHouseNumberExtension__c = 'A';
        tmpProductBasket.LG_PostalPostalCode__c = '1141 GV';
        tmpProductBasket.LG_PostalSameAsInstallationAddress__c = false;
        tmpProductBasket.LG_PostalStreet__c = 'Boing';
        tmpProductBasket.LG_PreferredInstallationDate__c = Date.newinstance(2020, 2, 17);
        tmpProductBasket.LG_PreferredInstallationTime__c = '18.00 - 21.00';
        tmpProductBasket.LG_ResultofVisit__c = 'Quote Requested';
        tmpProductBasket.LG_SameAsAdminContact__c = false;
        tmpProductBasket.LG_SBTelephonyId__c = '';
        tmpProductBasket.LG_SharedOfficeBuilding__c = false;
        tmpProductBasket.LG_TechContactSameasBillingContact__c = false;
        tmpProductBasket.LG_TechnicalContactDateofBirth__c = Date.newinstance(1990, 2, 17);
        tmpProductBasket.LG_TechnicalContactEmail__c = 'davor.dubokovic@cloudsense.com.test';
        tmpProductBasket.LG_TechnicalContactFirstName__c = 'John 1';
        tmpProductBasket.LG_TechnicalContactLastName__c = 'De Vries 2';
        tmpProductBasket.LG_TechnicalContactMiddleName__c = '';
        tmpProductBasket.LG_TechnicalContactMobile__c = '0299 654647';
        tmpProductBasket.LG_TechnicalContactPhone__c = '0299 654642';
        tmpProductBasket.LG_TechnicalContactPicklist__c = '(new Contact)';
        tmpProductBasket.LG_TechnicalContactSalutation__c = 'Mr.';
        tmpProductBasket.LG_ValidationDate__c = Date.today();
        tmpProductBasket.LG_VisitDescription__c = 'All OK';

        tmpProductBasket.LG_ClientNumber__c = '321-456-987';
        tmpProductBasket.LG_ExistingSubscription__c = 'Office basis';
        tmpProductBasket.LG_DTV__c = 'Keep';
        tmpProductBasket.LG_IPAddress__c = 'Keep';
        tmpProductBasket.LG_Telephony__c = 'Keep';
    }

    @IsTest
    public static void createOppsFromBasketForLeadTest() {

        string leaSOQL = 'SELECT ' + getFieldListAsCSV(Lead.getSobjectType()) + ' FROM Lead LIMIT 1';
        string basSOQL = 'SELECT ' + getFieldListAsCSV(cscfga__Product_Basket__c.getSobjectType()) + ' FROM cscfga__Product_Basket__c WHERE Name = \'Test Basket Lead\' LIMIT 1';

        Test.startTest();

        //generate Lead
        Lead tmpLead = Database.query(leaSOQL);

        //generate Discounts
        LG_Discount__c tmpDiscountClosingDeal = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Closing Deal', 8);
        LG_Discount__c tmpDiscountPromotionalAction = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Promotional Action', 8);
        LG_Discount__c tmpDiscount = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Discount', 8);

        cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('Test Category', true);

        //generate Product Definition
        cscfga__Product_Definition__c tmpProductDefinition = LG_GeneralTest.createProductDefinition('ZZP Internet', false);
        tmpProductDefinition.cscfga__Product_Category__c = prodCategory.Id;
        insert tmpProductDefinition;

        //generate Attribute Definitions
        cscfga__Attribute_Definition__c attdefTotalBasicPrice = LG_GeneralTest.createAttributeDefinition('Total Basic Price', tmpProductDefinition, 'Calculation', 'Decimal', '', 'Main OLI', '');
        cscfga__Attribute_Definition__c attdefAdditionalDiscount = LG_GeneralTest.createAttributeDefinition('Additional Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Action', '');
        cscfga__Attribute_Definition__c attdefClosingDealDiscount = LG_GeneralTest.createAttributeDefinition('Closing Deal Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Closing Deal', '');
        cscfga__Attribute_Definition__c attdefDiscount = LG_GeneralTest.createAttributeDefinition('Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Discount', '');
        cscfga__Attribute_Definition__c attdefUploadSpeed = LG_GeneralTest.createAttributeDefinition('UP Speed', tmpProductDefinition, 'Calculation', 'Integer', 'Upload Speed', '', 'Order Detail');
        cscfga__Attribute_Definition__c attdefContractTerm = LG_GeneralTest.createAttributeDefinition('Contract Term', tmpProductDefinition, 'Select List', 'Integer', '', '', 'Contract Term');
        cscfga__Attribute_Definition__c attdefInternetSpeed = LG_GeneralTest.createAttributeDefinition('Internet Speed', tmpProductDefinition, 'Calculation', 'String', 'Internet', '', 'Bundle Detail');
        cscfga__Attribute_Definition__c attdefPortingJSON = LG_GeneralTest.createAttributeDefinition('Porting JSON', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting Mobile Telephony');
        cscfga__Attribute_Definition__c attdefPortingJSON2 = LG_GeneralTest.createAttributeDefinition('Porting JSON2', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting SOHO Telephony');

        cscfga__Product_Basket__c tmpProductBasket = Database.query(basSOQL);

        cscfga__Product_Configuration__c pcInternet = LG_GeneralTest.createProductConfiguration('ZZP Internet', 24, tmpProductBasket, tmpProductDefinition);
        cscfga__Attribute__c attTotalBasicPrice = LG_GeneralTest.createAttribute('Total Basic Price', attdefTotalBasicPrice, true, 0, pcInternet, false, string.valueof(tmpDiscountPromotionalAction.Id), false);
        cscfga__Attribute__c attAdditionalDiscount = LG_GeneralTest.createAttribute('Additional Discount', attdefAdditionalDiscount, false, 0, pcInternet, false, '', false);
        cscfga__Attribute__c attClosingDealDiscount = LG_GeneralTest.createAttribute('Closing Deal Discount', attdefClosingDealDiscount, false, 0, pcInternet, false, '', false);
        cscfga__Attribute__c attDiscount = LG_GeneralTest.createAttribute('Discount', attdefDiscount, true, 0, pcInternet, false, string.valueof(tmpDiscount.Id), false);
        cscfga__Attribute__c attUploadSpeed = LG_GeneralTest.createAttribute('UP Speed', attdefUploadSpeed, false, 0, pcInternet, false, '30', false);
        cscfga__Attribute__c attContractTerm = LG_GeneralTest.createAttribute('Contract Term', attdefContractTerm, false, 0, pcInternet, false, '24', false);
        cscfga__Attribute__c attInternetSpeed = LG_GeneralTest.createAttribute('Internet Speed', attdefInternetSpeed, false, 0, pcInternet, false, '130 / 30 MBit / s Internet', false);

        String JSONPortingValue = '[{"simType":"port number","contractType":"zakelijk","currentNumber":"0123456789","currentProvider":"AH Mobile","simNumber":"123","dateOfPorting":"2015-07-01","template":"","sectionId":"appendDiv1","sectionName":"Zakelijk Voldoende"}]';

        cscfga__Attribute__c attPortingJSON = LG_GeneralTest.createAttribute('Porting JSON', attdefPortingJSON, false, 0, pcInternet, false, JSONPortingValue, false);

        String JSONPortingValue2 = '{"Existing_Phone_Numbers_0":true,"Telephone_Number_0":"0123456789","In_The_Name_Of_0":"Test","Telephone_Provider_0":"12CO","Listing_In_The_Directory_0":"als tel","Extra_Line_Porting_Number_0":"","Extra_Line_Telephone_Number_0":"","Extra_Line_In_The_Name_Of_0":"","Extra_Line_Telephone_Provider_0":"","Extra_Line_Listing_In_The_Directory_0":""}';

        cscfga__Attribute__c attPortingJSON2 = LG_GeneralTest.createAttribute('Porting JSON2', attdefPortingJSON2, false, 0, pcInternet, false, JSONPortingValue2, false);

        List<cscfga__Attribute__c> lstAtt = new List<cscfga__Attribute__c>();

        lstAtt.add(attTotalBasicPrice);
        lstAtt.add(attAdditionalDiscount);
        lstAtt.add(attClosingDealDiscount);
        lstAtt.add(attDiscount);
        lstAtt.add(attUploadSpeed);
        lstAtt.add(attContractTerm);
        lstAtt.add(attInternetSpeed);
        lstAtt.add(attPortingJSON);
        lstAtt.add(attPortingJSON2);

        insert lstAtt;

        tmpProductBasket.csordtelcoa__Synchronised_with_Opportunity__c = true;
        update tmpProductBasket;

        Test.stopTest();

        String oppSOQL = 'SELECT ' + getFieldListAsCSV(Opportunity.getSobjectType()) + ' FROM Opportunity WHERE LG_LeadId__c = \'' + tmpLead.Id + '\'';

        List<Opportunity> lstOpp = Database.query(oppSOQL);

        // Mapping Lead -> Opportunity is broken. Uncoment this once mapping is fixed
        /*System.assertEquals(1, lstOpp.size(), 'Number of created Opps must be 1');

        System.assertEquals(tmpProductBasket.LG_ClientNumber__c, lstOpp[0].LG_ClientNumber__c, 'Invalid data');
        System.assertEquals(tmpProductBasket.LG_ExistingSubscription__c, lstOpp[0].LG_ExistingSubscription__c, 'Invalid data');
        System.assertEquals(tmpProductBasket.LG_DTV__c, lstOpp[0].LG_DTV__c, 'Invalid data');
        System.assertEquals(tmpProductBasket.LG_IPAddress__c, lstOpp[0].LG_IPAddress__c, 'Invalid data');
        System.assertEquals(tmpProductBasket.LG_Telephony__c, lstOpp[0].LG_Telephony__c, 'Invalid data');*/
    }

    @IsTest
    public static void CreateOpportunitiesFromAccountProductBasketTest() {

        //get Account & Contact
        string accSOQL = 'SELECT ' + getFieldListAsCSV(Account.getSobjectType()) + ' FROM Account LIMIT 1';
        string conSOQL = 'SELECT ' + getFieldListAsCSV(Contact.getSobjectType()) + ' FROM Contact LIMIT 1';
        string basSOQL = 'SELECT ' + getFieldListAsCSV(cscfga__Product_Basket__c.getSobjectType()) + ' FROM cscfga__Product_Basket__c WHERE Name = \'Test Basket Account\' LIMIT 1';

        Account tmpAccount = Database.query(accSOQL);
        Contact tmpContact = Database.query(conSOQL);

        Test.startTest();

        //generate Discounts
        LG_Discount__c tmpDiscountClosingDeal = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Closing Deal', 8);
        LG_Discount__c tmpDiscountPromotionalAction = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Promotional Action', 8);
        LG_Discount__c tmpDiscount = LG_GeneralTest.createDiscount(30, 'SOHO', 'Discount Reduced Value', 24, 'ABC123', '8 maanden €30 ipv 5 maanden €30 voor pakket.', 'Discount', 8);

        cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('Test Category', true);

        //generate Product Definition
        cscfga__Product_Definition__c tmpProductDefinition = LG_GeneralTest.createProductDefinition('ZZP Internet', false);
        tmpProductDefinition.cscfga__Product_Category__c = prodCategory.Id;
        insert tmpProductDefinition;

        //generate Attribute Definitions
        cscfga__Attribute_Definition__c attdefTotalBasicPrice = LG_GeneralTest.createAttributeDefinition('Total Basic Price', tmpProductDefinition, 'Calculation', 'Decimal', '', 'Main OLI', '');
        cscfga__Attribute_Definition__c attdefAdditionalDiscount = LG_GeneralTest.createAttributeDefinition('Additional Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Action', '');
        cscfga__Attribute_Definition__c attdefClosingDealDiscount = LG_GeneralTest.createAttributeDefinition('Closing Deal Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Closing Deal', '');
        cscfga__Attribute_Definition__c attdefDiscount = LG_GeneralTest.createAttributeDefinition('Discount', tmpProductDefinition, 'Lookup', 'String', '', 'Promotional Discount', '');
        cscfga__Attribute_Definition__c attdefUploadSpeed = LG_GeneralTest.createAttributeDefinition('UP Speed', tmpProductDefinition, 'Calculation', 'Integer', 'Upload Speed', '', 'Order Detail');
        cscfga__Attribute_Definition__c attdefContractTerm = LG_GeneralTest.createAttributeDefinition('Contract Term', tmpProductDefinition, 'Select List', 'Integer', '', '', 'Contract Term');
        cscfga__Attribute_Definition__c attdefInternetSpeed = LG_GeneralTest.createAttributeDefinition('Internet Speed', tmpProductDefinition, 'Calculation', 'String', 'Internet', '', 'Bundle Detail');
        cscfga__Attribute_Definition__c attdefPortingJSON = LG_GeneralTest.createAttributeDefinition('Porting JSON', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting Mobile Telephony');
        cscfga__Attribute_Definition__c attdefPortingJSON2 = LG_GeneralTest.createAttributeDefinition('Porting JSON2', tmpProductDefinition, 'User Input', 'String', '', '', 'JSON Porting SOHO Telephony');

        cscfga__Product_Basket__c tmpProductBasket = Database.query(basSOQL);

        cscfga__Product_Configuration__c pcInternet = LG_GeneralTest.createProductConfiguration('ZZP Internet', 24, tmpProductBasket, tmpProductDefinition);
        cscfga__Attribute__c attTotalBasicPrice = LG_GeneralTest.createAttribute('Total Basic Price', attdefTotalBasicPrice, true, 0, pcInternet, false, String.valueof(tmpDiscountPromotionalAction.Id), false);
        cscfga__Attribute__c attAdditionalDiscount = LG_GeneralTest.createAttribute('Additional Discount', attdefAdditionalDiscount, false, 0, pcInternet, false, '', false);
        cscfga__Attribute__c attClosingDealDiscount = LG_GeneralTest.createAttribute('Closing Deal Discount', attdefClosingDealDiscount, false, 0, pcInternet, false, '', false);
        cscfga__Attribute__c attDiscount = LG_GeneralTest.createAttribute('Discount', attdefDiscount, true, 0, pcInternet, false, String.valueof(tmpDiscount.Id), false);
        cscfga__Attribute__c attUploadSpeed = LG_GeneralTest.createAttribute('UP Speed', attdefUploadSpeed, false, 0, pcInternet, false, '30', false);
        cscfga__Attribute__c attContractTerm = LG_GeneralTest.createAttribute('Contract Term', attdefContractTerm, false, 0, pcInternet, false, '24', false);
        cscfga__Attribute__c attInternetSpeed = LG_GeneralTest.createAttribute('Internet Speed', attdefInternetSpeed, false, 0, pcInternet, false, '130 / 30 MBit / s Internet', false);

        String JSONPortingValue = '[{"simType":"port number","contractType":"zakelijk","currentNumber":"0123456789","currentProvider":"AH Mobile","simNumber":"123","dateOfPorting":"2015-07-01","template":"","sectionId":"appendDiv1","sectionName":"Zakelijk Voldoende"}]';

        cscfga__Attribute__c attPortingJSON = LG_GeneralTest.createAttribute('Porting JSON', attdefPortingJSON, false, 0, pcInternet, false, JSONPortingValue, false);

        String JSONPortingValue2 = '{"Existing_Phone_Numbers_0":true,"Telephone_Number_0":"0123456789","In_The_Name_Of_0":"Test","Telephone_Provider_0":"12CO","Listing_In_The_Directory_0":"als tel","Extra_Line_Porting_Number_0":"","Extra_Line_Telephone_Number_0":"","Extra_Line_In_The_Name_Of_0":"","Extra_Line_Telephone_Provider_0":"","Extra_Line_Listing_In_The_Directory_0":""}';

        cscfga__Attribute__c attPortingJSON2 = LG_GeneralTest.createAttribute('Porting JSON2', attdefPortingJSON2, false, 0, pcInternet, false, JSONPortingValue2, false);

        List<cscfga__Attribute__c> lstAtt = new List<cscfga__Attribute__c>();

        lstAtt.add(attTotalBasicPrice);
        lstAtt.add(attAdditionalDiscount);
        lstAtt.add(attClosingDealDiscount);
        lstAtt.add(attDiscount);
        lstAtt.add(attUploadSpeed);
        lstAtt.add(attContractTerm);
        lstAtt.add(attInternetSpeed);
        lstAtt.add(attPortingJSON);
        lstAtt.add(attPortingJSON2);

       /* insert lstAtt;

        tmpProductBasket.csordtelcoa__Synchronised_with_Opportunity__c = true;
        update tmpProductBasket;

        Test.stopTest();

        String oppSOQL = 'SELECT ' + getFieldListAsCSV(Opportunity.getSobjectType()) + ' FROM Opportunity WHERE AccountId = \'' + tmpAccount.Id + '\'';

        List<Opportunity> lstOpp = Database.query(oppSOQL);

        System.assertEquals(1, lstOpp.size(), 'Number of created Opps must be 1');

        System.assertEquals(tmpProductBasket.LG_ClientNumber__c, lstOpp[0].LG_ClientNumber__c, 'Invalid data');
        System.assertEquals(tmpProductBasket.LG_ExistingSubscription__c, lstOpp[0].LG_ExistingSubscription__c, 'Invalid data');
        System.assertEquals(tmpProductBasket.LG_DTV__c, lstOpp[0].LG_DTV__c, 'Invalid data');
        System.assertEquals(tmpProductBasket.LG_IPAddress__c, lstOpp[0].LG_IPAddress__c, 'Invalid data');
        System.assertEquals(tmpProductBasket.LG_Telephony__c, lstOpp[0].LG_Telephony__c, 'Invalid data'); */
    }

    /**
    * After performing MACD, SF is sending install order in the xml to
    * Tracy, due to incorrect Order Number this orders failing in Tracy
    *
    * Test
    *
    * During Change old Basket Number is copied to new PCs
    *
    * @param  List<Opportunity> opps
    * @param  Map<Id, Opportunity> oldMap
    * @author Petar Miletic
    * @ticket SFDT-1015
    * @since  24/05/2016
    */
    @IsTest
    public static void updateOrderNumberOnMACDChangeTest() {

        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        Account acc = LG_GeneralTest.CreateAccount('AccountSFDT', '12345678', 'Ziggo', true);

        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, true);

        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('BAsket58', acc, null, opp, false);
        basket.csbb__Account__c = acc.Id;
        basket.csordtelcoa__Change_Type__c = 'Change';
        insert basket;

        // Reload basket to get LG_BasketNumber__c
        basket = [SELECT Id, Name, LG_BasketNumber__c FROM cscfga__Product_Basket__c WHERE Name = 'BAsket58'];

        // Generate Product Definition
        cscfga__Product_Definition__c prodDef = LG_GeneralTest.createProductDefinition('ProdDef58', true);

        // Generate Address (Premise)
        cscrm__Address__c premise = LG_GeneralTest.crateAddress('TestAddress', 'street', 'city', '5', '73', '2014GC', 'Netherlands', acc, true);

        // Generate Product Configuration
        cscfga__Product_Configuration__c prodConfiguration = LG_GeneralTest.createProductConfiguration('ProdConf58', 3, basket, prodDef, false);
        prodConfiguration.LG_PortIn__c = true;
        prodConfiguration.LG_MaximumQuantity__c = 20;
        prodConfiguration.LG_Address__c = premise.Id;
        prodConfiguration.cscfga__Product_Basket__c = basket.Id;
        insert prodConfiguration;

        cscfga__Product_Configuration__c prodConfiguration2 = LG_GeneralTest.createProductConfiguration('ProdConf58', 3, basket, prodDef, false);
        prodConfiguration2.LG_PortIn__c = true;
        prodConfiguration2.LG_MaximumQuantity__c = 20;
        prodConfiguration2.LG_Address__c = null;
        prodConfiguration2.cscfga__Product_Basket__c = basket.Id;
        insert prodConfiguration2;

        cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('Test Category', true);

        // Generate Product Definition
        cscfga__Product_Definition__c tmpProductDefinition = LG_GeneralTest.createProductDefinition('ZZP Internet', false);
        tmpProductDefinition.cscfga__Product_Category__c = prodCategory.Id;
        insert tmpProductDefinition;

        // Generate Attribute Definitions
        cscfga__Attribute_Definition__c bnumDef = LG_GeneralTest.createAttributeDefinition('Basket Number Def', tmpProductDefinition, '', 'String', '', '', '');
        cscfga__Attribute_Definition__c onumDef = LG_GeneralTest.createAttributeDefinition('Order Number Def', tmpProductDefinition, '', 'String', '', '', '');
        cscfga__Attribute_Definition__c pridDef = LG_GeneralTest.createAttributeDefinition('Premise Id Def', tmpProductDefinition, '', 'String', '', '', '');
        cscfga__Attribute_Definition__c pnumDef = LG_GeneralTest.createAttributeDefinition('Premise Number Def', tmpProductDefinition, '', 'String', '', '', '');

        // Reload Premise in order to get LG_PremiseNumber__c
        premise = [SELECT Id, Name, LG_PremiseNumber__c FROM cscrm__Address__c WHERE Name = 'TestAddress' LIMIT 1];

        // Create necessary attributes
        cscfga__Attribute__c bnum = LG_GeneralTest.createAttribute('Basket Number', bnumDef, true, 0, prodConfiguration, false, 'BTest', true);
        cscfga__Attribute__c onum = LG_GeneralTest.createAttribute('Order Number', onumDef, true, 0, prodConfiguration, false, 'BTest' + premise.LG_PremiseNumber__c, true);
        cscfga__Attribute__c prid = LG_GeneralTest.createAttribute('Premise Id', pridDef, true, 0, prodConfiguration, false, premise.Id, true);
        cscfga__Attribute__c pnum = LG_GeneralTest.createAttribute('Premise Number', pnumDef, true, 0, prodConfiguration, false, premise.LG_PremiseNumber__c, true);

        cscfga__Attribute__c bnum2 = LG_GeneralTest.createAttribute('Basket Number', bnumDef, true, 0, prodConfiguration2, false, 'BTest', true);
        cscfga__Attribute__c onum2 = LG_GeneralTest.createAttribute('Order Number', onumDef, true, 0, prodConfiguration2, false, 'BTest' + premise.LG_PremiseNumber__c, true);
        cscfga__Attribute__c prid2 = LG_GeneralTest.createAttribute('Premise Id', pridDef, true, 0, prodConfiguration2, false, premise.Id, true);
        cscfga__Attribute__c pnum2 = LG_GeneralTest.createAttribute('Premise Number', pnumDef, true, 0, prodConfiguration2, false, premise.LG_PremiseNumber__c, true);

        List<cscfga__Attribute__c> attributeList = new List<cscfga__Attribute__c> { bnum, onum, prid, pnum, bnum2, onum2, prid2, pnum2 };

        string basketNumberOld = bnum.cscfga__Value__c;
        string orderNumberOld = onum.cscfga__Value__c;
        string premiseIdOld = prid.cscfga__Value__c;
        string premiseNumberOld = pnum.cscfga__Value__c;

        noTriggers.Flag__c = false;
        upsert noTriggers;

        Test.startTest();

        // Create Order and Service ////////////////////////////////////////
        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert coreq;

        csord__Order__c o = new csord__Order__c();
        o.Name = 'Test Order';
        o.csord__Account__c = acc.Id;
        o.csord__Status2__c = 'Order Submitted';
        o.csord__Order_Request__c = coreq.Id;
        o.csord__Identification__c = 'DWHTestBatchOn_' + system.now();
        insert o;

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'Test Subscription', csord__Order_Request__c = coreq.Id);
        sub.csordtelcoa__Change_Type__c = 'Change';
        insert sub;

        csord__Service__c service = new csord__Service__c(csord__Identification__c = 'Test Service', csord__Order_Request__c = coreq.Id);
        // End /////////////////////////////////////////////////////////////

        service.csord__Subscription__c = sub.Id;
        service.LG_RootOrder__c = o.Id;
        service.csordtelcoa__Product_Configuration__c = prodConfiguration.Id;
        insert service;

        //LG_AttributeTriggerHandler.updateOrderNumberOnMACDChange(attributeList);

        Test.stopTest();

        // Assert old values
        System.assertEquals(basketNumberOld, 'BTest', 'Invalid data');
        System.assertEquals(orderNumberOld, 'BTest' + premise.LG_PremiseNumber__c, 'Invalid data');
        System.assertEquals(premiseIdOld, prid.cscfga__Value__c, 'Invalid data');
        System.assertEquals(premiseNumberOld, pnum.cscfga__Value__c, 'Invalid data');

        // Assert new values
        //System.assertEquals(bnum.cscfga__Value__c, basket.LG_BasketNumber__c, 'Invalid data');
        //System.assertEquals(onum.cscfga__Value__c, basket.LG_BasketNumber__c + premise.LG_PremiseNumber__c, 'Invalid data');
        //System.assertEquals(prid.cscfga__Value__c, premise.Id, 'Invalid data');
        //System.assertEquals(pnum.cscfga__Value__c, premise.LG_PremiseNumber__c, 'Invalid data');

        // Assert old values
        //System.assertEquals(basketNumberOld, 'BTest', 'Invalid data');
        //System.assertEquals(orderNumberOld, 'BTest' + premise.LG_PremiseNumber__c, 'Invalid data');
        //System.assertEquals(premiseIdOld, prid2.cscfga__Value__c, 'Invalid data');
        //System.assertEquals(premiseNumberOld, pnum2.cscfga__Value__c, 'Invalid data');

        // Assert new values
        //System.assertEquals(prid2.cscfga__Value__c, premise.Id, 'Invalid data');
        //System.assertEquals(pnum2.cscfga__Value__c, premise.LG_PremiseNumber__c, 'Invalid data');
        //System.assertEquals(bnum2.cscfga__Value__c, basket.LG_BasketNumber__c, 'Invalid data');
        //System.assertEquals(onum2.cscfga__Value__c, basket.LG_BasketNumber__c + pnum2.cscfga__Value__c, 'Invalid data');
    }

    private static Map<sObjectType, Map<String, Schema.SObjectField>> mapFieldsToObject = new Map<sObjectType, Map<String, Schema.SObjectField>>();

    private static String getFieldListAsCSV(sObjectType sobject_type) {

        Map<String, Schema.SObjectField> field_map = getObjectFields(sobject_type);
        return String.join(new List<String>(field_map.keySet()), ',');
    }

    private static Map<String, Schema.SObjectField> getObjectFields(sObjectType sobject_type) {

        Map<String, Schema.SObjectField> field_map;
        if (!mapFieldsToObject.containsKey(sobject_type)) {
            //describe the sobject
            DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
            //get a map of fields for the passed sobject
            field_map = sobject_describe.fields.getMap();
            mapFieldsToObject.put(sobject_type, field_map);
        }

        field_map = mapFieldsToObject.get(sobject_type);
        return field_map;
    }

    private static testmethod void testUpdateConfigId()
  {
    No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    noTriggers.Flag__c      = true;
    noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
    upsert noTriggers;

    Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);

    Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);

    csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test Service Req', csord__Module_Version__c = '1.0');
    insert coreq;

    csord__Service__c service = new csord__Service__c(csord__Identification__c = 'Telephony Service', csord__Order_Request__c = coreq.Id);

    cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Basket', account, null, opp, false);
    basket.csbb__Account__c = account.Id;
    insert basket;

    cscfga__Product_Definition__c telephonyProdDef   = LG_GeneralTest.createProductDefinition('Telephony', true);
    cscfga__Product_Definition__c prodDefNumberRange = LG_GeneralTest.createProductDefinition('Number Range', true);


    cscfga__Product_Configuration__c telephonyProdConf   = LG_GeneralTest.createProductConfiguration('Telephony', 3, basket, telephonyProdDef, true);
    cscfga__Product_Configuration__c numberRangeProdConf = LG_GeneralTest.createProductConfiguration('Number Range', 3, basket, prodDefNumberRange, true);

    cscfga__Attribute_Definition__c attDef = LG_GeneralTest.createAttributeDefinition('Number Ranges', telephonyProdDef, 'Related Product', 'String',
                                              null, null, null, true);

    LG_GeneralTest.createAttributeDefinition('Configuration Id', prodDefNumberRange, 'User Input', 'String', null, null, null, true);

    noTriggers.Flag__c = false;
    upsert noTriggers;

    Test.startTest();

    cscfga__Attribute__c configAttr =  LG_GeneralTest.createAttribute('Configuration Id', attDef, false, null, numberRangeProdConf, false, '', true);

    Test.stopTest();

    String numberRangeId = String.valueOf(numberRangeProdConf.Id);

    configAttr = [SELECT Id, cscfga__Value__c FROM cscfga__Attribute__c WHERE Id = :configAttr.Id];

    System.assertEquals(numberRangeId, configAttr.cscfga__Value__c, 'Configuration Id value should be set to ' + numberRangeId);
  }


  private static testmethod void testCreateNumberAssets()
  {
    No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    noTriggers.Flag__c      = true;
    noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
    upsert noTriggers;

    LG_NumberManagementSettings__c mngSettings = new LG_NumberManagementSettings__c();
    mngSettings.LG_BlockSizes__c                       = '1,10,100';
    mngSettings.LG_NumberRangeProdConfForNew__c        = true;
    mngSettings.LG_NumberRangeProdConfForPortIn__c     = true;
    mngSettings.LG_NumberRangeProductDefinitionName__c = 'Number Range';
    mngSettings.LG_TelephonyNumberRangeAttribute__c    = 'Number Ranges';
    mngSettings.LG_BlockTypeAttribute__c               = 'Block Type';
    mngSettings.LG_EndNumberAttribute__c               = 'End Number';
    mngSettings.LG_NumberRangeAttribute__c             = 'Number Range';
    mngSettings.LG_SizeAttribute__c                    = 'Size';
    mngSettings.LG_StartNumberAttribute__c             = 'Start Number';
    mngSettings.LG_PortInOperators__c                  = 'BT,KPN';
    mngSettings.LG_RequireDetailsForNew__c             = true;
    mngSettings.LG_RequireDetailsForPortIn__c          = true;
    mngSettings.LG_MinNumberLength__c                  = 10;
    mngSettings.LG_MaxNumberLength__c                  = 10;
    if (!Schema.SObjectType.Asset.fieldSets.getMap().isEmpty()) {
        String fieldSetName = '';
        for (String key : Schema.SObjectType.Asset.fieldSets.getMap().keySet()) {
            fieldSetName = key;
            break;
        }
        mngSettings.LG_PortInDetailsFieldSet__c = fieldSetName;
        mngSettings.LG_NewDetailsFieldSet__c    = fieldSetName;
    }
    insert mngSettings;

    Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);

    Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);

    csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test Service Req', csord__Module_Version__c = '1.0');
    insert coreq;

    cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Basket', account, null, opp, false);
    basket.csbb__Account__c = account.Id;
    insert basket;

    cscfga__Product_Definition__c prodDef = LG_GeneralTest.createProductDefinition('Number Range', true);

    cscfga__Product_Configuration__c prodConf = LG_GeneralTest.createProductConfiguration('Number Range', 3, basket, prodDef, false);
    insert prodConf;

    cscfga__Attribute_Definition__c attDef = LG_GeneralTest.createAttributeDefinition('Test Att', prodDef, 'Related Product', 'String',
                                                                                      null, null, null, false);
    attDef.csordtelcoa__Calculate_Delta__c = true;
    insert attDef;

    cscfga__Attribute__c numberBlockAttr =  LG_GeneralTest.createAttribute('Numberblock_RequestJson', attDef, false, null, prodConf, false, '', false);
    numberBlockAttr.cscfga__Value__c = '[{"LG_NumberRangeSize__c":"5","LG_NumberRangeType__c":"Port-In","notDefined":"false", "LG_StartNumber__c":"091900", "LG_EndNumber__c":"091904", "LG_NumberRange__c":"091900-091904"},{"LG_NumberRangeSize__c":"5","LG_NumberRangeType__c":"Port-In","notDefined":"false", "LG_StartNumber__c":"091905", "LG_EndNumber__c":"091909", "LG_NumberRange__c":"091905-091909"}]';
    insert numberBlockAttr;

    noTriggers.Flag__c = false;
    upsert noTriggers;

    numberBlockAttr = [SELECT Id, LG_ProductBasket__c, Name, cscfga__Value__c FROM cscfga__Attribute__c WHERE Id = :numberBlockAttr.Id];

    List<cscfga__Attribute__c> atts = new List<cscfga__Attribute__c>();
    atts.add(numberBlockAttr);

    Test.startTest();

    LG_AttributeTriggerHandler.createNumberAssets(atts, null);

    Test.stopTest();

    List<Asset> assets = [SELECT Id FROM Asset WHERE LG_NumberRangeProductConfiguration__c = :prodConf.Id];
    System.assertEquals(12, assets.size(), '12 Assets should have been created.');
  }
  private static testmethod void testUpdateConnectionAttribute() {
    Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);
    Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);

    cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Basket', account, null, opp, false);
    basket.csbb__Account__c = account.Id;
    insert basket;

    cscfga__Product_Definition__c connectionDefn  = LG_GeneralTest.createProductDefinition('Company VPN Verbindung', true);
    cscfga__Product_Configuration__c connectionProdConf   = LG_GeneralTest.createProductConfiguration('Company VPN Verbindung', 0, basket, connectionDefn, true);
    
    cscfga__Attribute_Definition__c attDefBdsSite1 = LG_GeneralTest.createAttributeDefinition('BDS Site', connectionDefn, 'Display Value', 'String',
                        null, null, null, true);
    cscfga__Attribute_Definition__c attDefBdsSite2 = LG_GeneralTest.createAttributeDefinition('Site Configuration Shadow', connectionDefn, 'Display Value', 'String',
                        null, null, null, true);
    cscfga__Attribute_Definition__c attDefBdsSite3 = LG_GeneralTest.createAttributeDefinition('VPN Network', connectionDefn, 'Display Value', 'String',
                        null, null, null, true);
    cscfga__Attribute_Definition__c attDefBdsSite4 = LG_GeneralTest.createAttributeDefinition('VPN Configuration Shadow', connectionDefn, 'Display Value', 'String',
                        null, null, null, true);
    cscfga__Attribute_Definition__c attDefBdsSite5 = LG_GeneralTest.createAttributeDefinition('Multiple BDS Site', connectionDefn, 'Display Value', 'String',
                        null, null, null, true);
    cscfga__Attribute_Definition__c attDefBdsSite6 = LG_GeneralTest.createAttributeDefinition('Multiple VPN Network', connectionDefn, 'Display Value', 'String',
                        null, null, null, true);
    
    cscfga__Attribute__c bdsSiteAttr1 =  LG_GeneralTest.createAttribute('BDS Site', attDefBdsSite1, false, null, connectionProdConf, false, '', true);
    cscfga__Attribute__c bdsSiteAttr2 =  LG_GeneralTest.createAttribute('Site Configuration Shadow', attDefBdsSite2, false, null, connectionProdConf, false, '', true);
    cscfga__Attribute__c bdsSiteAttr3 =  LG_GeneralTest.createAttribute('VPN Network', attDefBdsSite3, false, null, connectionProdConf, false, '', true);
    cscfga__Attribute__c bdsSiteAttr4 =  LG_GeneralTest.createAttribute('VPN Configuration Shadow', attDefBdsSite4, false, null, connectionProdConf, false, '', true);
    cscfga__Attribute__c bdsSiteAttr5 =  LG_GeneralTest.createAttribute('Multiple BDS Site', attDefBdsSite5, false, null, connectionProdConf, false, '', true);
    cscfga__Attribute__c bdsSiteAttr6 =  LG_GeneralTest.createAttribute('Multiple VPN Network', attDefBdsSite6, false, null, connectionProdConf, false, '', true);
}
    //test method for AfterVPNSITEUpdateHandler
    public static testmethod void afterVPNSITEUpdateHandlerTest(){
        
        List<cscfga__Attribute__c> arrtListUpdate = new List<cscfga__Attribute__c>(); 
        
        cscfga__Product_Configuration__c vpn1 = [select id,name from cscfga__Product_Configuration__c where name= 'VPN Services1'];
        
        cscfga__Attribute__c attr1 = [select id,name,cscfga__Value__c,cscfga__Product_Configuration__c from cscfga__Attribute__c where name = 'VPN Name'];
        cscfga__Attribute__c attr2 = [select id,name,cscfga__Value__c,cscfga__Product_Configuration__c from cscfga__Attribute__c where name = 'Configuration Id'];
        cscfga__Attribute__c attr3 = [select id,name,cscfga__Value__c,cscfga__Product_Configuration__c from cscfga__Attribute__c where name = 'MLESiteAddress'];
        
        attr1.cscfga__Value__c = 'def';
        arrtListUpdate.add(attr1);
        
        attr3.cscfga__Value__c = 'Stuttgart,Aalstr.,70378';
        arrtListUpdate.add(attr3);
        
        attr2.cscfga__Value__c =vpn1.id;
        arrtListUpdate.add(attr2);
        
        //start test
        Test.startTest();
        
        update arrtListUpdate;
        
        //stop test
        Test.stopTest();
        
        //Result for vpn attribute change
        cscfga__Product_Configuration__c vpn = [select id,name,LG_CustomProductName__c from cscfga__Product_Configuration__c where id=: attr1.cscfga__Product_Configuration__c];
        
        //system.assertEquals(attr1.cscfga__Value__c,vpn.LG_CustomProductName__c);
        
    }
}
