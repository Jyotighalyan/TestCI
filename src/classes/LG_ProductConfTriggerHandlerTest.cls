@isTest
private class LG_ProductConfTriggerHandlerTest {

    @testsetup
    private static void setupTestData()
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
        insert mngSettings;

        Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);
		 
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);

        LG_GeneralTest.createBillingAccount('BillingAccount', account.Id, true, true);

        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Basket', account, null, opp, false);

        basket.LG_CreatedFrom__c = 'Tablet';
        insert basket;

        cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('Test Category', true);

        cscfga__Product_Definition__c prodDef = LG_GeneralTest.createProductDefinition('Phone Numbers', false);

        prodDef.cscfga__Product_Category__c = prodCategory.Id;
        insert prodDef;

        cscfga__Product_Definition__c prodDefNmbrRange = LG_GeneralTest.createProductDefinition('Number Range', true);

        cscfga__Product_Configuration__c prodConfNumberRange = LG_GeneralTest.createProductConfiguration('Number Range 1', 3, basket, prodDefNmbrRange, true);

        cscfga__Product_Definition__c prodDefTelephony = LG_GeneralTest.createProductDefinition('Telephony', true);

        cscfga__Product_Configuration__c prodConfTelephony = LG_GeneralTest.createProductConfiguration('Telephony 1', 3, basket, prodDefTelephony, true);

        cscfga__Product_Category__c prodCategoryPenaltyFee = LG_GeneralTest.createProductCategory('Termination Products', true);

        cscfga__Product_Definition__c prodDefpenaltyFee = LG_GeneralTest.createProductDefinition('Penalty Fee', false);
      
        cscfga__Product_Definition__c prodDefSC = LG_GeneralTest.createProductDefinition('Company VPN Verbindung', false);
        insert  prodDefSC;
        cscfga__Product_Definition__c prodDefVPN = LG_GeneralTest.createProductDefinition('VPN Services', false);
		insert prodDefVPN;
        prodDefpenaltyFee.cscfga__Product_Category__c = prodCategoryPenaltyFee.Id;
        insert prodDefpenaltyFee;

        cscrm__Address__c a2 = new cscrm__Address__c(cscrm__City__c = 'Agram');
        insert a2;

                
        cscfga__Product_Configuration__c prodConVPN = LG_GeneralTest.createProductConfiguration('VPN Services', 24, basket, prodDefVPN, false);
        prodConVPN.LG_CustomProductName__c = 'ABC';
        insert prodConVPN;
        
        
        cscfga__Product_Configuration__c prodConSC = LG_GeneralTest.createProductConfiguration('Company VPN Verbindung', 24, basket, prodDefSC, false);
        prodConSC.LG_From_Configuration__c = prodConVPN.LG_Persistent_Id__c;
        prodConSC.Product_Group__c = prodConVPN.LG_CustomProductName__c;
        prodConSC.Name='TEST Site Connection';
        prodConSC.cscfga__Description__c='TEST Site Connection';
        insert prodConSC;
        
        cscfga__Product_Configuration__c prodConfTermination = LG_GeneralTest.createProductConfiguration('Termination Configuration', 3, basket, prodDefpenaltyFee, false);
        prodConfTermination.LG_Address__c = a2.Id;
        insert prodConfTermination;

         cscfga__Attribute_Definition__c attrdef1 = LG_GeneralTest.createAttributeDefinition('Multiple VPN Network', prodDefSC, 'Calculation', 'String', '', '', '', true);  
         cscfga__Attribute_Definition__c attrdef2 = LG_GeneralTest.createAttributeDefinition('VPN Network', prodDefSC, 'Calculation', 'String', '', '', '', true);
         cscfga__Attribute_Definition__c attrdef3 = LG_GeneralTest.createAttributeDefinition('Product Group', prodDefSC, 'Calculation', 'String', '', '', '', true);
         cscfga__Attribute_Definition__c attrdef4 = LG_GeneralTest.createAttributeDefinition('Group Charge Name Shadow', prodDefSC, 'Calculation', 'String', '', '', '', true);
         cscfga__Attribute_Definition__c attrdef5 = LG_GeneralTest.createAttributeDefinition('Group Charge Name', prodDefSC, 'Calculation', 'String', '', '', '', true);
         cscfga__Attribute_Definition__c attrdef6 = LG_GeneralTest.createAttributeDefinition('Product Full Name', prodDefSC, 'Calculation', 'String', '', '', '', true);
        
        
      
		List<cscfga__Attribute__c> siteConnAttr= New List<cscfga__Attribute__c>();
      
	 	cscfga__Attribute__c attr1= LG_GeneralTest.createAttribute('Multiple VPN Network',  attrdef1, false, 10,prodConSC, false, 'TEST Address', false);
        attr1.cscfga__Value__c =prodConVPN.LG_Persistent_Id__c ;
        attr1.cscfga__Display_Value__c=prodConVPN.LG_CustomProductName__c;
        siteConnAttr.add(attr1);
        
        cscfga__Attribute__c attr2= LG_GeneralTest.createAttribute('VPN Network',  attrdef2, false, 10,prodConSC, false, 'TEST Address', false);
        attr2.cscfga__Value__c =prodConVPN.LG_CustomProductName__c;
        siteConnAttr.add(attr2);
                
        cscfga__Attribute__c attr3= LG_GeneralTest.createAttribute('Product Group',  attrdef3, false, 10,prodConSC, false, 'TEST Address', false);
        attr3.cscfga__Value__c =prodConVPN.LG_CustomProductName__c;
        siteConnAttr.add(attr3);
                
        cscfga__Attribute__c attr4= LG_GeneralTest.createAttribute('Group Charge Name Shadow',  attrdef4, false, 10,prodConSC, false, 'TEST Address', false);
        attr4.cscfga__Value__c =prodConVPN.LG_CustomProductName__c;
        siteConnAttr.add(attr4);
                
        cscfga__Attribute__c attr5= LG_GeneralTest.createAttribute('Group Charge Name',  attrdef5, false, 10,prodConSC, false, 'TEST Address', false);
        attr5.cscfga__Value__c =prodConVPN.LG_CustomProductName__c;
        siteConnAttr.add(attr5);
        
        cscfga__Attribute__c attr6= LG_GeneralTest.createAttribute('Product Full Name',  attrdef6, false, 10,prodConSC, false, 'TEST Address', false);
        attr6.cscfga__Display_Value__c = prodConSC.Name;
        attr6.cscfga__Value__c = prodConSC.Name;
        siteConnAttr.add(attr6);
		
		insert siteConnAttr;


        
        
        cscfga__Product_Configuration__c prodConfPenaltyFee = LG_GeneralTest.createProductConfiguration('Penalty Fee for public hosted bellen', 3, basket, prodDefpenaltyFee, false);
        prodConfPenaltyFee.cscfga__Product_Family__c = 'Penalty Fee';
        prodConfPenaltyFee.LG_Address__c             = a2.Id;
        insert prodConfPenaltyFee;

        cscfga__Attribute_Definition__c attDefOverPrice = LG_GeneralTest.createAttributeDefinition('Overridden Price', prodDefpenaltyFee, 'Calculation', 'Decimal',
                                                                                                   null, null, null, true);

        cscfga__Product_Configuration__c prodConf = LG_GeneralTest.createProductConfiguration('Phone Numbers 1', 3, basket, prodDef, true);

        cscfga__Attribute_Definition__c attDef = LG_GeneralTest.createAttributeDefinition('Phone Numbers', prodDef, 'Text Display', 'String',
                                                                                          null, null, null, true);

        String publicJson = '{"phoneNumbers": [{"phoneNumber":"005065832","publiclyListed":"true","listingName":"Tomsi ei sBpoz kau "},{"phoneNumber":"005065833",'
                            + '"publiclyListed":"false","listingName":""},{"phoneNumber":"005065834","publiclyListed":"false","listingName":""},{"phoneNumber":"005065835",'
                            + '"publiclyListed":"true","listingName":"TBTo ao os op"},{"phoneNumber":"005065836","publiclyListed":"false","listingName":""},{"phoneNumber"'
                            + ':"005065837","publiclyListed":"false","listingName":""},{"phoneNumber":"005065838","publiclyListed":"false","listingName":""},{"phoneNumber"'
                            + ':"005065839","publiclyListed":"false","listingName":""},{"phoneNumber":"005065840","publiclyListed":"false","listingName":""},{"phoneNumber":'
                            + '"005065841","publiclyListed":"false","listingName":""}]}';

        LG_GeneralTest.createAttribute('PublicListingJson', attDef, false, null, prodConf, false, publicJson, true);
        LG_GeneralTest.createAttribute('Number of lines', attDef, false, null, prodConf, false, '10', true);
        LG_GeneralTest.createAttribute('Phonenumbers', attDef, false, null, prodConf, false, '03012345678', true);

        List<LG_PortingNumber__c> numbersToInsert = new List<LG_PortingNumber__c>();

        LG_PortingNumber__c portingNumber = new LG_PortingNumber__c();
        portingNumber.LG_PhoneNumber__c          = '012349870';
        portingNumber.LG_InDirectory__c          = 'true';
        portingNumber.LG_DirectoryListingName__c = 'Public HR';
        portingNumber.LG_Type__c                 = 'SB Telephony';
        portingNumber.LG_ProductConfiguration__c = prodConf.Id;
        numbersToInsert.add(portingNumber);

        LG_PortingNumber__c portingNumber2 = new LG_PortingNumber__c();
        portingNumber2.LG_PhoneNumber__c          = '012349875';
        portingNumber2.LG_InDirectory__c          = 'true';
        portingNumber2.LG_DirectoryListingName__c = 'Public Helpdesk';
        portingNumber2.LG_Type__c                 = 'SB Telephony';
        portingNumber2.LG_ProductConfiguration__c = prodConf.Id;
        numbersToInsert.add(portingNumber2);

        insert numbersToInsert;

        cscfga__Attribute_Definition__c attDefLineItem = LG_GeneralTest.createAttributeDefinition('LineItemDef', prodDef, 'Lookup', 'String',
                                                                                                  null, null, null, true);

        Double price = 5.15;

        LG_GeneralTest.createAttribute('LineItemDef-1', attDefLineItem, true, price, prodConf, true, '58', true);
        LG_GeneralTest.createAttribute('LineItemDef-2', attDefLineItem, true, price, prodConf, true, '58', true);

        Asset numberAsset = new Asset();
        numberAsset.LG_NumberRangeProductConfiguration__c = prodConfNumberRange.Id;
        numberAsset.AccountId                             = account.Id;
        numberAsset.Name                                  = 'TestNumberAsset';
        insert numberAsset;

        noTriggers.Flag__c = false;
        upsert noTriggers;
    }

    
    private static testmethod void testSiteConnUpdate()
    {
            
        cscfga__Product_Configuration__c testvpn = [Select id,name, LG_CustomProductName__c from cscfga__Product_Configuration__c where Name ='VPN Services'];
     Test.startTest();
        testvpn.LG_CustomProductName__c='CDE';
        //update testvpn;
      Test.stopTest(); 
        List<cscfga__Product_Configuration__c> testSC = [Select id,name, Product_Group__c from cscfga__Product_Configuration__c where LG_From_Configuration__c =:testvpn.LG_Persistent_Id__c limit 1];
        system.debug(testSC);
        
         // System.assertEquals(testSC[0].Product_Group__c, testvpn.LG_CustomProductName__c, 'VPN Custom Product name should match Site Connection Product group');
        
    }

    private static testmethod void testRecalculatePenalityFees()
    {
        cscfga__Product_Configuration__c prodConf = [SELECT Id, LG_InstallationWishDate__c, LG_Address__c, cscfga__Product_Basket__c FROM cscfga__Product_Configuration__c
                                                     WHERE Name = 'Termination Configuration'];
        Test.startTest();

        prodConf.LG_InstallationWishDate__c = Date.today();
        prodConf.cscfga__Product_Family__c  = 'Termination';
        update prodConf;

        Test.stopTest();

        List<cscfga__Product_Configuration__c> prodConfs = [SELECT Id, LG_InstallationWishDate__c, LG_Address__c, cscfga__Product_Basket__c FROM cscfga__Product_Configuration__c
                                                            WHERE cscfga__Product_Family__c = 'Penalty Fee'];

        //system.assertEquals(0, prodConfs.size(), 'No more penalty fee records');
    }

    private static testmethod void testSetBillingAccOnLineItems()
    {
        csconta__Billing_Account__c billingAccount = [SELECT Id FROM csconta__Billing_Account__c WHERE csconta__Financial_Account_Number__c = 'BillingAccount'];
        cscfga__Product_Configuration__c prodConf  = [SELECT Id, LG_BillingAccount__c FROM cscfga__Product_Configuration__c
                                                      WHERE Name = 'Phone Numbers 1'];

        Test.startTest();
        prodConf.LG_BillingAccount__c = billingAccount.Id;
        update prodConf;
        Test.stopTest();

        for (cscfga__Attribute__c attribute : [SELECT Id, cscfga__Product_Configuration__r.LG_BillingAccount__c,
                                               (SELECT Id, Name, cscfga__Value__c FROM cscfga__Attribute_Fields__r WHERE Name = 'BillingAccount')
                                               FROM cscfga__Attribute__c
                                               WHERE cscfga__Is_Line_Item__c = true
                                                                               AND cscfga__Product_Configuration__c = :prodConf.Id]) {


            for (cscfga__Attribute_Field__c attField : attribute.cscfga__Attribute_Fields__r) {
                System.assertEquals(billingAccount.Id, attField.cscfga__Value__c, 'Value should be set to the Billing Account set on Prod Conf.');
            }

        }
    }

    private static testmethod void testDeleteNumberAssets()
    {
        List<Asset> asset = [SELECT Id FROM Asset WHERE Name = 'TestNumberAsset'];
        System.assertEquals(false, asset.isEmpty(), 'Asset record should exist');

        Test.startTest();
        delete [SELECT Id FROM cscfga__Product_Configuration__c WHERE Name = 'Number Range 1'];
        Test.stopTest();

        asset = [SELECT Id FROM Asset WHERE Name = 'TestNumberAsset'];
        System.assertEquals(true, asset.isEmpty(), 'Assets should have been deleted');
    }

    private static testmethod void testUpdateTelephonyConfOnAssets()
    {
        cscfga__Product_Configuration__c numberRangeProdConf = [SELECT Id, cscfga__Parent_Configuration__c FROM cscfga__Product_Configuration__c WHERE Name = 'Number Range 1'];
        cscfga__Product_Configuration__c telephonyProdConf = [SELECT Id FROM cscfga__Product_Configuration__c WHERE Name = 'Telephony 1'];
        Asset numberAsset = [SELECT Id, LG_NumberRangeProductConfiguration__c, LG_TelephonyProductConfiguration__c FROM Asset WHERE Name = 'TestNumberAsset'];
        System.assertEquals(numberRangeProdConf.Id, numberAsset.LG_NumberRangeProductConfiguration__c, 'Number Range should be set');
        System.assertEquals(null, numberAsset.LG_TelephonyProductConfiguration__c, 'Telephony should not be set');
        Test.startTest();
            numberRangeProdConf.cscfga__Parent_Configuration__c = telephonyProdConf.Id;
            update numberRangeProdConf;
        Test.stopTest();

        numberAsset = [SELECT Id, LG_NumberRangeProductConfiguration__c, LG_TelephonyProductConfiguration__c FROM Asset WHERE Name = 'TestNumberAsset'];
        System.assertEquals(numberRangeProdConf.Id, numberAsset.LG_NumberRangeProductConfiguration__c, 'Number Range should be set');
      
    }
}