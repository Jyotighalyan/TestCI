@isTest
private class CustomBttnSynchronizeWithOpportunityTest {
    
    @testsetup
    private static void setupTestData() {  
        
        //variable decalration
        List<cscfga__Product_Definition__c> prodDefList = new List<cscfga__Product_Definition__c>();
        List<cscfga__Product_Configuration__c> prodConList = new List<cscfga__Product_Configuration__c>();
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        //account
        Account account = LG_GeneralTest.CreateAccount('AccountTEstBA', '1234567', 'IAMYCS', true);
        Account account1 = LG_GeneralTest.CreateAccount('Testing Account', '5896474', 'qwerty', true);
        
        //Opportunity
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
        
        
        //Basket
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Basket', account, null, opp, false);
        basket.csbb__Synchronised_With_Opportunity__c = true;
        insert basket;
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
        
        //Product Definitions
        cscfga__Product_Definition__c prodDefSite = LG_GeneralTest.createProductDefinition(Label.BDS_Site, true);
        cscfga__Product_Definition__c prodDefVPN = LG_GeneralTest.createProductDefinition(Label.VPN_services, false); 
        cscfga__Product_Definition__c prodDefCCC = LG_GeneralTest.createProductDefinition(Label.Company_Cloud_Connect, false); 
        cscfga__Product_Definition__c prodDefCCF = LG_GeneralTest.createProductDefinition(Label.Company_Cloud_Fiber, false); 
        cscfga__Product_Definition__c prodDefBA = LG_GeneralTest.createProductDefinition(Label.Business_Anywhere, false);
        cscfga__Product_Definition__c prodDefCFSC = LG_GeneralTest.createProductDefinition(Label.CF_Service_Configuration, false);
        cscfga__Product_Definition__c prodDefCF = LG_GeneralTest.createProductDefinition(Label.Company_Fiber, false);
        cscfga__Product_Definition__c prodDefCVPN = LG_GeneralTest.createProductDefinition(Label.Company_VPN_Connection, false);
        cscfga__Product_Definition__c prodDefVDSL = LG_GeneralTest.createProductDefinition(Label.CCC_VDSL, false);
        cscfga__Product_Definition__c prodDefOffnet = LG_GeneralTest.createProductDefinition(Label.CCC_Offnet, false);
        
        prodDefList.add(prodDefVPN);
        prodDefList.add(prodDefCCC);
        prodDefList.add(prodDefCCF);
        prodDefList.add(prodDefBA);
        prodDefList.add(prodDefCFSC);
        prodDefList.add(prodDefCF);
        prodDefList.add(prodDefCVPN);
        prodDefList.add(prodDefVDSL);
        prodDefList.add(prodDefOffnet);
        
        insert prodDefList;
        
        //address
        cscrm__Address__c addr= LG_GeneralTest.crateAddress('Test Addr','ABC', 'Munich','45', '78','we','Germany', account, true);
        
    }
    
        
    /*success in sync*/
    private static testmethod void testPerformActionSuccess() {
    
        //account
        Account account = LG_GeneralTest.CreateAccount('AccountTEstBA1', '12345678', 'IAMYCS1', true);
        
        //Opportunity
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
    
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Basket1', account, null, opp, false);
        basket.csbb__Synchronised_With_Opportunity__c = true;
        insert basket;    
        
         //address
        cscrm__Address__c addr= [select id,name from cscrm__Address__c where name = 'Test Addr'];
        
        //Product Definition
        cscfga__Product_Definition__c prodDefCCC = [select id,name from cscfga__Product_Definition__c where name =:Label.Company_Cloud_Connect];
        cscfga__Product_Definition__c prodDefSite = [select id,name from cscfga__Product_Definition__c where name =:Label.BDS_Site];
        cscfga__Product_Definition__c prodDefBA = [select id,name from cscfga__Product_Definition__c where name =:Label.Business_Anywhere];
        cscfga__Product_Definition__c prodDefCVPNV = [select id,name from cscfga__Product_Definition__c where name =:Label.Company_VPN_Connection];
        cscfga__Product_Definition__c prodDefVPN = [select id,name from cscfga__Product_Definition__c where name =:Label.VPN_services];
        cscfga__Product_Definition__c prodDefVDSL = [select id,name from cscfga__Product_Definition__c where name =:Label.CCC_VDSL];
    
        //Product Configuration
        cscfga__Product_Configuration__c prodConfCCC = LG_GeneralTest.createProductConfiguration(Label.Company_Cloud_Connect, 24, basket, prodDefCCC, false); 
        prodConfCCC.LG_Address__c = addr.Id;
        insert prodConfCCC;
    
        cscfga__Product_Configuration__c prodConfCCCVDSL = LG_GeneralTest.createProductConfiguration(Label.CCC_VDSL, 24, basket, prodDefVDSL, false); 
        prodConfCCC.LG_Address__c = addr.Id;
        insert prodConfCCCVDSL;
        
        cscfga__Product_Configuration__c prodConfSite = LG_GeneralTest.createProductConfiguration('BDS Standort : test', 24, basket, prodDefSite, false); 
        prodConfSite.LG_Address__c = addr.Id;
        prodConfSite.UM_DependsOnProductConfiguration__c = prodConfCCC.Id;
        prodConfSite.LG_SecondaryAccess__c = prodConfCCCVDSL.Id;
        prodConfSite.LG_Persistent_Id__c = 'Test';
        insert prodConfSite;
    
        cscfga__Product_Configuration__c prodConfVPN = LG_GeneralTest.createProductConfiguration('VPN : test', 24, basket, prodDefVPN, false);
        prodConfVPN.LG_Persistent_Id__c = 'TestVPN';
        insert prodConfVPN;
        
        cscfga__Product_Configuration__c prodConfBA = LG_GeneralTest.createProductConfiguration('Business Anywhere : test', 24, basket, prodDefBA, true);
        cscfga__Product_Configuration__c prodConCVPNV = LG_GeneralTest.createProductConfiguration(Label.Company_VPN_Connection, 24, basket, prodDefCVPNV, false);
        prodConCVPNV.LG_From_Configuration__c = 'Test';
        prodConCVPNV.LG_To_Configuration__c = 'TestVPN';
        insert prodConCVPNV;
        
        //attribute definitions
        cscfga__Attribute_Definition__c attrdef = LG_GeneralTest.createAttributeDefinition('Primary Access Type', prodDefSite, 'Select List', 'String', '', '', '', true);
        
        //attributes
        cscfga__Attribute__c attr= LG_GeneralTest.createAttribute('Primary Access Type',  attrdef, false, 10,prodConfSite, false, string.valueof(addr.Id), false);
        attr.cscfga__Value__c = 'Onnet';
        insert attr;

        //start test
        Test.startTest();
        
        CustomButtonSynchronizeWithOpportunity cstBtn = new CustomButtonSynchronizeWithOpportunity();
        String performActionResult = cstBtn.performAction(basket.Id);
        
        //stop test
        Test.stopTest();    
        
        System.assertEquals(true, basket.csbb__Synchronised_With_Opportunity__c,
                    'Basket should be synced with the opp');
    
        String oppId = opp.Id;
    
        System.assertEquals('{"status":"ok","redirectURL":"/' + oppId.substring(0,15) + '"}',
                    performActionResult, 'result should match');
                    
    }
    
     /* to throw error message*/
    private static testmethod void testPerformActionError(){ 


        cscfga__Product_Basket__c basket = [SELECT Id, cscfga__Basket_Status__c
                                            FROM cscfga__Product_Basket__c WHERE Name = 'Basket'];
        basket.cscfga__Basket_Status__c = 'SomethingDummy';
        update basket;

        //start test
        Test.startTest();
        
        CustomButtonSynchronizeWithOpportunity cstBtn = new CustomButtonSynchronizeWithOpportunity();
        String performActionResult = cstBtn.performAction(basket.Id);
        
        //stop test
        Test.stopTest();

        System.assertEquals(CustomButtonSynchronizeWithOpportunity.errorMsg,performActionResult, 'result should match');
    }
    
    /*To Throw "Some configurations are invalid" error message*/
    public static testmethod void throwProdConfigStatusError(){
        
        //basket
        cscfga__Product_Basket__c basket = [SELECT Id, cscfga__Basket_Status__c,csbb__Account__c,csordtelcoa__Synchronised_with_Opportunity__c, cscfga__Opportunity__r.Id FROM cscfga__Product_Basket__c WHERE Name = 'Basket'];
        
        //Product Definition
        cscfga__Product_Definition__c prodDefSite = [select id,name from cscfga__Product_Definition__c where name =:Label.BDS_Site];
        
        //Product Configuration
        cscfga__Product_Configuration__c prodConfSite = LG_GeneralTest.createProductConfiguration('BDS Standort : test', 24, basket, prodDefSite, false); 
        prodConfSite.cscfga__Configuration_Status__c = 'InComplete';
        
        
        //start test
        Test.startTest();
        
        insert prodConfSite; 
        
        CustomButtonSynchronizeWithOpportunity cstBtn = new CustomButtonSynchronizeWithOpportunity();
        
        String performActionResult  = cstBtn.performAction(basket.Id);
        
        prodConfSite.LG_ChangeType__c = 'New';
        update prodConfSite;
        
        basket.csordtelcoa__Change_Type__c = 'Change';
        update basket;
        
        String performActionResult1  = cstBtn.performAction(basket.Id);
        
        //stop test
        Test.stopTest();
        
        //Error Message 
        //Label.Invalid_Configuration_Basket ='{"status":"error","title":"Error","text": "Some configurations are invalid, please refresh the page and update products that need attention."}'
        
        system.assertEquals('{"status":"error","title":"Error",'+ '"text": "' + Label.Invalid_Configuration_Basket + '"}', performActionResult,'result should match');
        system.assertEquals('{"status":"error","title":"Error",'+ '"text": "' + Label.Invalid_Configuration_Basket + '"}', performActionResult1,'result should match');
        
    }
    
    /*to throw "Mandatory BGP details are not captured in Installation page" error*/
    public static testmethod void throwBGPError(){
        
        //basket
        cscfga__Product_Basket__c basket = [SELECT Id, cscfga__Basket_Status__c,csbb__Account__c,csordtelcoa__Synchronised_with_Opportunity__c, cscfga__Opportunity__r.Id FROM cscfga__Product_Basket__c WHERE Name = 'Basket'];
        
        //Product Definition
        cscfga__Product_Definition__c prodDefCCF = [select id,name from cscfga__Product_Definition__c where name =:Label.CF_Service_Configuration];
        
        //Product Configuration
        cscfga__Product_Configuration__c prodConCF = LG_GeneralTest.createProductConfiguration(Label.Company_Fiber, 24, basket, prodDefCCF, false); 
        prodConCF.cscfga__Product_Family__c = Label.CF_Service_Configuration;
        prodConCF.LG_PlanningDetailsStatus__c ='Pending';
        
        //start test
        Test.startTest();
        
        insert prodConCF;
        
        CustomButtonSynchronizeWithOpportunity cstBtn = new CustomButtonSynchronizeWithOpportunity();
        
        String performActionResult  = cstBtn.performAction(basket.Id);
        
        prodConCF.LG_ChangeType__c = 'New';
        update prodConCF;
        
        basket.csordtelcoa__Change_Type__c = 'Change';
        update basket;

        
        String performActionResult1  = cstBtn.performAction(basket.Id);
        
        //stop test
        Test.stopTest();
        
        system.assertEquals('{"status":"error","title":"Error","text":"Mandatory BGP details are not captured in Installation page. Please check."}',performActionResult, 'result should match');
        system.assertEquals('{"status":"error","title":"Error","text":"Mandatory BGP details are not captured in Installation page. Please check."}',performActionResult1, 'result should match');
    }
    
   
    
    /*Busniess Anywhere validation error*/
    public static testmethod void busniessAnywhereValidationErr(){
        
        //basket
        cscfga__Product_Basket__c basket = [SELECT Id, cscfga__Basket_Status__c,csbb__Account__c,csordtelcoa__Synchronised_with_Opportunity__c, cscfga__Opportunity__r.Id FROM cscfga__Product_Basket__c WHERE Name = 'Basket'];
        
        //Product Definition
        cscfga__Product_Definition__c prodDefBA = [select id,name from cscfga__Product_Definition__c where name =:Label.Business_Anywhere];
        
        //Product Configuration
        cscfga__Product_Configuration__c prodConfBA = LG_GeneralTest.createProductConfiguration('Business Anywhere : test', 24, basket, prodDefBA, true);
        
        //start test
        Test.startTest();
        
        CustomButtonSynchronizeWithOpportunity cstBtn = new CustomButtonSynchronizeWithOpportunity();
        String performActionResult  = cstBtn.performAction(basket.Id);
        
        //stop test
        Test.stopTest();
        
        system.assertEquals('{"status":"error","title":"Error","text":"Please add BDS Site product to add Business Anywhere."}', performActionResult);
    }
    
    /*BDS standort validation error */
    public static testmethod void BDSError(){
        
        List<csord__Service__c> servList = new List<csord__Service__c>();
        List<cscfga__Product_Configuration__c> prodConList = new List<cscfga__Product_Configuration__c>();
        
        //basket
        cscfga__Product_Basket__c basket = [SELECT Id, cscfga__Basket_Status__c,csbb__Account__c,csordtelcoa__Synchronised_with_Opportunity__c, cscfga__Opportunity__r.Id FROM cscfga__Product_Basket__c WHERE Name = 'Basket'];
        
        //address
        cscrm__Address__c addr= [select id,name from cscrm__Address__c where name = 'Test Addr'];
        
        //Product Definitions
        cscfga__Product_Definition__c prodDefSite = [select id,name from cscfga__Product_Definition__c where name =:Label.BDS_Site];
        cscfga__Product_Definition__c prodDefVDSL = [select id,name from cscfga__Product_Definition__c where name =:Label.CCC_VDSL];
        cscfga__Product_Definition__c prodDefCF = [Select id,name from cscfga__Product_Definition__c where name=:Label.Company_Fiber];
        cscfga__Product_Definition__c prodDefOffnet = [select id,name from cscfga__Product_Definition__c where name = :Label.CCC_Offnet];
        cscfga__Product_Definition__c prodDefCCC = [select id,name from cscfga__Product_Definition__c where name = :Label.Company_Cloud_Connect];
        
        //Product Configuration
        
        //vdsl 
        cscfga__Product_Configuration__c prodConfVDSL = LG_GeneralTest.createProductConfiguration('Company Cloud Connect VDSL : test', 24, basket, prodDefVDSL, true); 
        
        //offnet
        cscfga__Product_Configuration__c prodConfOffnet = LG_GeneralTest.createProductConfiguration(Label.CCC_Offnet, 24, basket, prodDefOffnet, false);
        prodConList.add(prodConfOffnet);
        
        //bds standort
        cscfga__Product_Configuration__c prodConfSite = LG_GeneralTest.createProductConfiguration('BDS Standort : test', 24, basket, prodDefSite, false); 
        prodConfSite.LG_Persistent_Id__c = 'TestPersistentId4';
        prodConfSite.LG_Address__c = addr.Id;
        prodConfSite.LG_SecondaryAccess__c = prodConfVDSL.Id;
        prodConList.add(prodConfSite);

        //Company Fiber
        cscfga__Product_Configuration__c prodConfCF = LG_GeneralTest.createProductConfiguration(Label.Company_Fiber, 24, basket, prodDefCF, false); 
        prodConList.add(prodConfCF);
        
        //CCC
        cscfga__Product_Configuration__c prodConfCCC = LG_GeneralTest.createProductConfiguration(Label.Company_Cloud_Connect, 24, basket, prodDefCCC, false); 
        prodConfCCC.LG_ChangeType__c = 'New';
        prodConList.add(prodConfCCC);
        
        insert prodConList;
        
        //attribute definition
        cscfga__Attribute_Definition__c attrdefCF = LG_GeneralTest.createAttributeDefinition('isCCFPresent', prodDefCF, 'Checkbox', 'Boolean', '', '', '',true); 
        
        //attribute value
        cscfga__Attribute__c attrCF= LG_GeneralTest.createAttribute('isCCFPresent',  attrdefCF, false, 10,prodConfCF, false, string.valueof(addr.Id), false);
        attrCF.cscfga__Value__c = 'Yes';
        insert attrCF;
        
        csord__Order_Request__c oreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert oreq;
        
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = oreq.Id,csord__Account__c= basket.csbb__Account__c,csord__Status__c = 'Active' );
        insert sub;
        
        csord__Service__c ser = new csord__Service__c(Name='testService', csord__Subscription__c= sub.id, csordtelcoa__Product_Configuration__c = prodConfCF.id,csord__Identification__c='ServiceBA');
        ser.LG_Address__c = addr.id;
        servList.add(ser);
        
        csord__Service__c ser1 = new csord__Service__c(Name='testService1', csord__Subscription__c= sub.id, csordtelcoa__Product_Configuration__c = prodConfSite.id,csord__Identification__c='ServiceBA');
        servList.add(ser1);
        
        insert servList;
        
        //start test
        Test.startTest();
        
        CustomButtonSynchronizeWithOpportunity cstBtn = new CustomButtonSynchronizeWithOpportunity();
        String performActionResult  = cstBtn.performAction(basket.Id);
        
        List<cscfga__Product_Configuration__c> pcList = new List<cscfga__Product_Configuration__c>();
        
        prodConfCF.LG_ChangeType__c = 'New';
        //prodConfSite.LG_ChangeType__c = 'New';
        prodConfVDSL.LG_ChangeType__c = 'New';
        prodConfOffnet.LG_ChangeType__c = 'New';
        
        pcList.add(prodConfOffnet);
        pcList.add(prodConfCF);
        pcList.add(prodConfSite);
        pcList.add(prodConfVDSL);
        
        update pcList;
        
        basket.csordtelcoa__Change_Type__c = 'Change';
        update basket;

        
        String performActionResult1  = cstBtn.performAction(basket.Id);
        
        //stop test
        Test.stopTest();
        
        system.assertEquals('{"status":"error","title":"Error","text":"BDS Site & Access products are offered together. No individual product sale for BDS Site or Access."}', performActionResult);
        system.assertEquals('{"status":"error","title":"Error","text":"BDS Site & Access products are offered together. No individual product sale for BDS Site or Access."}', performActionResult1);
    }
    
    /*To throw duplication error*/
    public static testmethod void duplicateValidation(){
        
        List<cscfga__Product_Configuration__c> prodConList = new List<cscfga__Product_Configuration__c>();
        List<cscfga__Product_Configuration__c> prodConList1 = new List<cscfga__Product_Configuration__c>();
        
        //basket
        cscfga__Product_Basket__c basket = [SELECT Id, cscfga__Basket_Status__c,csbb__Account__c,csordtelcoa__Synchronised_with_Opportunity__c, cscfga__Opportunity__r.Id FROM cscfga__Product_Basket__c WHERE Name = 'Basket'];
        
         //address
        cscrm__Address__c addr= [select id,name from cscrm__Address__c where name = 'Test Addr'];
        
        //Product Definition
        cscfga__Product_Definition__c prodDefCCC = [select id,name from cscfga__Product_Definition__c where name =:Label.Company_Cloud_Connect];
        cscfga__Product_Definition__c prodDefSite = [select id,name from cscfga__Product_Definition__c where name =:Label.BDS_Site];
        cscfga__Product_Definition__c prodDefBA = [select id,name from cscfga__Product_Definition__c where name =:Label.Business_Anywhere];
        cscfga__Product_Definition__c prodDefCVPNV = [select id,name from cscfga__Product_Definition__c where name =:Label.Company_VPN_Connection];
        cscfga__Product_Definition__c prodDefVPN = [select id,name from cscfga__Product_Definition__c where name =:Label.VPN_services];
        cscfga__Product_Definition__c prodDefVDSL = [select id,name from cscfga__Product_Definition__c where name =:Label.CCC_VDSL];
    
        //Product Configuration
        
        //ccc
        cscfga__Product_Configuration__c prodConfCCC = LG_GeneralTest.createProductConfiguration(Label.Company_Cloud_Connect, 24, basket, prodDefCCC, false); 
        prodConfCCC.LG_Address__c = addr.Id;
        prodConList.add(prodConfCCC);
    
        //cccvdsl
        cscfga__Product_Configuration__c prodConfCCCVDSL = LG_GeneralTest.createProductConfiguration(Label.CCC_VDSL, 24, basket, prodDefVDSL, false); 
        prodConfCCC.LG_Address__c = addr.Id;
        prodConList.add(prodConfCCCVDSL);
        
        insert prodConList;
        
        //bds standort
        cscfga__Product_Configuration__c prodConfSite = LG_GeneralTest.createProductConfiguration('BDS Standort : test', 24, basket, prodDefSite, false); 
        prodConfSite.LG_Address__c = addr.Id;
        prodConfSite.UM_DependsOnProductConfiguration__c = prodConfCCC.Id;
        prodConfSite.LG_SecondaryAccess__c = prodConfCCCVDSL.Id;
        prodConfSite.LG_Persistent_Id__c = 'Test';
        prodConList1.add(prodConfSite);
    
        //Vpn services
        cscfga__Product_Configuration__c prodConfVPN = LG_GeneralTest.createProductConfiguration('VPN : test', 24, basket, prodDefVPN, false);
        prodConfVPN.LG_Persistent_Id__c = 'TestVPN';
        prodConList1.add(prodConfVPN);
        
        //Business Anywhere
        cscfga__Product_Configuration__c prodConfBA = LG_GeneralTest.createProductConfiguration('Business Anywhere : test', 24, basket, prodDefBA, true);
        
        //site Connection
        cscfga__Product_Configuration__c prodConCVPNV = LG_GeneralTest.createProductConfiguration(Label.Company_VPN_Connection, 24, basket, prodDefCVPNV, false);
        prodConCVPNV.LG_From_Configuration__c = 'Test';
        prodConCVPNV.LG_To_Configuration__c = 'TestVPN';
        prodConList1.add(prodConCVPNV);
    
        //site connection
        cscfga__Product_Configuration__c prodConCVPNV1 = LG_GeneralTest.createProductConfiguration(Label.Company_VPN_Connection, 24, basket, prodDefCVPNV, false);
        prodConCVPNV1.LG_From_Configuration__c = 'Test';
        prodConCVPNV1.LG_To_Configuration__c = 'TestVPN';
        prodConList1.add(prodConCVPNV1);
        
        insert prodConList1;
        
        //attribute definitions
        cscfga__Attribute_Definition__c attrdef = LG_GeneralTest.createAttributeDefinition('Primary Access Type', prodDefSite, 'Select List', 'String', '', '', '', true);
        
        //attributes
        cscfga__Attribute__c attr= LG_GeneralTest.createAttribute('Primary Access Type',  attrdef, false, 10,prodConfSite, false, string.valueof(addr.Id), false);
        attr.cscfga__Value__c = 'Onnet';
        insert attr;

        //start test
        Test.startTest();
        
        CustomButtonSynchronizeWithOpportunity cstBtn = new CustomButtonSynchronizeWithOpportunity();
        
        String performActionResult = cstBtn.performAction(basket.Id);
        
        //on change 
        List<cscfga__Product_Configuration__c> pcList = new List<cscfga__Product_Configuration__c>();
        
        prodConCVPNV.LG_ChangeType__c = 'New';
        prodConCVPNV1.LG_ChangeType__c = 'New';
        
        pcList.add(prodConCVPNV);
        pcList.add(prodConCVPNV1);
        
        update pcList;
        
        basket.csordtelcoa__Change_Type__c = 'Change';
        update basket;
        
        String performActionResult1 = cstBtn.performAction(basket.Id);
        
        //stop test
        Test.stopTest();    

        System.assertEquals('{"status":"error","title":"Error","text":"Please remove duplicate record(s) for Connection from BDS Site to VPN."}',performActionResult, 'result should match');
        System.assertEquals('{"status":"error","title":"Error","text":"Please remove duplicate record(s) for Connection from BDS Site to VPN."}',performActionResult1, 'result should match');
    } 
    
    /*to throw un-used vpn or site error*/
    public static testmethod void unUsedError(){
        
        List<cscfga__Product_Configuration__c> prodConList = new List<cscfga__Product_Configuration__c>();
        List<cscfga__Product_Configuration__c> prodConList1 = new List<cscfga__Product_Configuration__c>();
        
        //basket
        cscfga__Product_Basket__c basket = [SELECT Id, cscfga__Basket_Status__c,csbb__Account__c,csordtelcoa__Synchronised_with_Opportunity__c, cscfga__Opportunity__r.Id FROM cscfga__Product_Basket__c WHERE Name = 'Basket'];
        
         //address
        cscrm__Address__c addr= [select id,name from cscrm__Address__c where name = 'Test Addr'];
        
        //Product Definition
        cscfga__Product_Definition__c prodDefCCC = [select id,name from cscfga__Product_Definition__c where name =:Label.Company_Cloud_Connect];
        cscfga__Product_Definition__c prodDefBDSSite = [select id,name from cscfga__Product_Definition__c where name =:Label.BDS_Site];
        cscfga__Product_Definition__c prodDefCVPNV = [select id,name from cscfga__Product_Definition__c where name =:Label.Company_VPN_Connection];
        cscfga__Product_Definition__c prodDefVPN = [select id,name from cscfga__Product_Definition__c where name =:Label.VPN_services];
        cscfga__Product_Definition__c prodDefVPN1 = [select id,name from cscfga__Product_Definition__c where name =:Label.VPN_services];
        
        //Product Configuration
        
        //ccc
        cscfga__Product_Configuration__c prodConfCCC = LG_GeneralTest.createProductConfiguration(Label.Company_Cloud_Connect, 24, basket, prodDefCCC, false); 
        prodConfCCC.LG_Address__c = addr.Id;
        prodConList.add(prodConfCCC);
        
        insert prodConList;
        
        //Bds 
        cscfga__Product_Configuration__c prodConfSite = LG_GeneralTest.createProductConfiguration('BDS Standort : test', 24, basket, prodDefBDSSite, false); 
        prodConfSite.LG_Address__c = addr.Id;
        prodConfSite.UM_DependsOnProductConfiguration__c = prodConfCCC.Id;
        prodConfSite.LG_Persistent_Id__c = 'Test';
        prodConList1.add(prodConfSite);
        
        //vpn service
        cscfga__Product_Configuration__c prodConfVPN = LG_GeneralTest.createProductConfiguration('VPN : test', 24, basket, prodDefVPN, false);
        prodConfVPN.LG_Persistent_Id__c = 'TestVPN';
        prodConList1.add(prodConfVPN);
        
        //vpn service
        cscfga__Product_Configuration__c prodConfVPN1 = LG_GeneralTest.createProductConfiguration('VPN : test', 24, basket, prodDefVPN1, false);
        prodConfVPN1.LG_Persistent_Id__c = 'TestVPN1';
        prodConList1.add(prodConfVPN1);
        
        //site connection
        cscfga__Product_Configuration__c prodConCVPNV = LG_GeneralTest.createProductConfiguration('Company Cloud Fiber25', 24, basket, prodDefCVPNV, false);
        prodConCVPNV.LG_From_Configuration__c = 'Test';
        prodConCVPNV.LG_To_Configuration__c = 'TestVPN';
        prodConList1.add(prodConCVPNV);
        
        insert prodConList1;
        
        //start test
        Test.startTest();
        
        CustomButtonSynchronizeWithOpportunity cstBtn = new CustomButtonSynchronizeWithOpportunity();
        
        String performActionResult = cstBtn.performAction(basket.Id);
        
        //on change
        List<cscfga__Product_Configuration__c> pcList = new List<cscfga__Product_Configuration__c>();
        
        prodConCVPNV.LG_ChangeType__c = 'New';
        prodConfSite.LG_ChangeType__c = 'New';
        prodConfVPN.LG_ChangeType__c = 'New';
        prodConfVPN1.LG_ChangeType__c = 'New';
        
        pcList.add(prodConCVPNV);
        pcList.add(prodConfSite);
        pcList.add(prodConfVPN);
        pcList.add(prodConfVPN1);
        
        update pcList;
        
        basket.csordtelcoa__Change_Type__c = 'Change';
        update basket;
        
        String performActionResult1 = cstBtn.performAction(basket.Id);
        
        //stop test
        Test.stopTest();    

        System.assertEquals('{"status":"error","title":"Error","text":"Some VPN Service or BDS Sites are unused in connections products"}',performActionResult, 'result should match');
        System.assertEquals('{"status":"error","title":"Error","text":"Some VPN Service or BDS Sites are unused in connections products"}',performActionResult1, 'result should match');

    }

}