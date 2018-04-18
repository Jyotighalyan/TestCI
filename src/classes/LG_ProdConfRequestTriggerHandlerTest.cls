@isTest
private class LG_ProdConfRequestTriggerHandlerTest {

    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        Account account = LG_GeneralTest.CreateAccount('AccountSFDT-58', '12345678', 'Ziggo', true);
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
        
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('BAsket58', account, null, opp, false);
        basket.csbb__Account__c = account.Id;
        insert basket;
        
        cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('TestCategory', true);
        
        LG_GeneralTest.createProdConfigurationRequest(prodCategory.Id, basket.Id, 500, 560, true);
        
        cscfga__Product_Definition__c prodDef = LG_GeneralTest.createProductDefinition('ProdDef', true);                                        
        
        cscrm__Address__c addressOne = new cscrm__Address__c(Name='AddressOne', cscrm__Zip_Postal_Code__c = '10000', LG_HouseNumber__c = '34', 
                                                                cscrm__Street__c = 'Ilica', cscrm__City__c = 'Zagreb', LG_AddressID__c = 'TestAddressId');
        insert addressOne;
                
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    
    private static testmethod void testUpdateRollUpFieldsOnProductBasket()
    {
        cscfga__Product_Basket__c basket = [SELECT Id, LG_TotalRecurringCharge__c,
                                            LG_TotalOneOff__c 
                                            FROM cscfga__Product_Basket__c WHERE Name = 'BAsket58'];
        
        cscfga__Product_Category__c prodCategory = [SELECT Id FROM cscfga__Product_Category__c
                                                    WHERE Name = 'TestCategory'];
        
        System.assertEquals(null, basket.LG_TotalOneOff__c, 'Total One Off should be null');
        System.assertEquals(null, basket.LG_TotalRecurringCharge__c, 'Total Recurring Charge should be null');
        
        csbb__Product_Configuration_Request__c prodReq = [SELECT Id, csbb__Total_OC__c, csbb__Total_MRC__c
                                                            FROM csbb__Product_Configuration_Request__c
                                                            WHERE csbb__Product_Basket__r.Id = :basket.Id];
        Test.startTest();
        
            csbb__Product_Configuration_Request__c prodReqNew = LG_GeneralTest.createProdConfigurationRequest(prodCategory.Id, basket.Id, 800, 900, false);
            prodReq.csbb__Total_OC__c = 0;
            prodReq.csbb__Total_MRC__c = 9999;
            
            List<csbb__Product_Configuration_Request__c> reqs = new List<csbb__Product_Configuration_Request__c>();
            reqs.add(prodReqNew);
            reqs.add(prodReq);
            
            upsert reqs;
        
        Test.stopTest();
        
        basket = [SELECT Id, LG_TotalRecurringCharge__c,
                                            LG_TotalOneOff__c 
                                            FROM cscfga__Product_Basket__c WHERE Name = 'BAsket58'];
                                            
        System.assertEquals(800, basket.LG_TotalOneOff__c, 'Total One Off should be 800');
        System.assertEquals(10899, basket.LG_TotalRecurringCharge__c, 'Total Recurring Charge should be 10899');                                    
    }
    
    private static testmethod void testSetTheOptionalsField()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        cscrm__Address__c address = [SELECT Id, cscrm__City__c, cscrm__Zip_Postal_Code__c, LG_HouseNumberExtension__c,
                                    LG_HouseNumber__c, cscrm__Street__c, LG_AddressID__c, cscrm__State_Province__c,
                                    cscrm__Geolocation__Latitude__s, cscrm__Geolocation__Longitude__s
                                    FROM cscrm__Address__c WHERE Name = 'AddressOne'];
        
        cscfga__Product_Definition__c prodDef = [SELECT Id FROM cscfga__Product_Definition__c WHERE Name = 'ProdDef'];

        cscfga__Product_Basket__c basket = [SELECT Id, LG_TotalRecurringCharge__c,
                                            LG_TotalOneOff__c 
                                            FROM cscfga__Product_Basket__c WHERE Name = 'BAsket58'];
                                                                                                                        
        cscfga__Product_Configuration__c prodConf = LG_GeneralTest.createProductConfiguration('ProdConf', 3, basket, prodDef, false);
        prodConf.LG_Address__c = address.Id;
        prodConf.LG_ChangeType__c = 'Move';
        insert prodConf;
                                                        
        cscfga__Product_Category__c prodCategory = [SELECT Id FROM cscfga__Product_Category__c
                                                    WHERE Name = 'TestCategory'];
                                                    
        noTriggers.Flag__c = false;
        upsert noTriggers;
        
        Test.startTest();
        
            csbb__Product_Configuration_Request__c prodReq = LG_GeneralTest.createProdConfigurationRequest(prodCategory.Id, basket.Id, 800, 900, true);
            
            System.assertEquals(null, prodReq.csbb__Optionals__c, 'Optionals should be null');

            prodReq.csbb__Product_Configuration__c = prodConf.Id;
            upsert prodReq;
            
        Test.stopTest();
        
        prodReq = [SELECT Id, csbb__Optionals__c 
                    FROM csbb__Product_Configuration_Request__c WHERE Id = :prodReq.Id];
                                            
        //System.assertEquals(JSON.serialize(new LG_AddressResponse.OptionalsJson(address)), prodReq.csbb__Optionals__c, 'Optionals should equals to ' + JSON.serialize(new LG_AddressResponse.OptionalsJson(address)));
    }
/*    
    private static testmethod void testUpsertThePremisesRecords()
    {
        cscrm__Address__c address = [SELECT Id, cscrm__City__c, cscrm__Zip_Postal_Code__c, LG_HouseNumberExtension__c,
                                    LG_HouseNumber__c, cscrm__Street__c, LG_AddressID__c, cscrm__State_Province__c,
                                    cscrm__Geolocation__Latitude__s, cscrm__Geolocation__Longitude__s
                                    FROM cscrm__Address__c WHERE Name = 'AddressOne'];
                                    
        cscfga__Product_Basket__c basket = [SELECT Id, csbb__Account__c
                                            FROM cscfga__Product_Basket__c WHERE Name = 'BAsket58'];
        
        cscfga__Product_Category__c prodCategory = [SELECT Id FROM cscfga__Product_Category__c
                                                    WHERE Name = 'TestCategory'];
        
        csbb__Product_Configuration_Request__c prodReq = [SELECT Id, csbb__Optionals__c,
                                                                csbb__Product_Basket__r.csbb__Account__c,
                                                                csbb__Product_Configuration__c
                                                            FROM csbb__Product_Configuration_Request__c
                                                            WHERE csbb__Product_Basket__r.Id = :basket.Id];
        
        prodReq.csbb__Optionals__c = JSON.serialize(new LG_AddressResponse.OptionalsJson(address));
        
        cscfga__Product_Definition__c prodDef = [SELECT Id FROM cscfga__Product_Definition__c WHERE Name = 'ProdDef'];
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;                                                                                                                      
        
        cscfga__Product_Configuration__c prodConf = LG_GeneralTest.createProductConfiguration('ProdConf', 3, basket, prodDef, false);
        insert prodConf;
        
        cscfga__Attribute_Definition__c attDef = LG_GeneralTest.createAttributeDefinition('AttDef', prodDef, 'User Input', 'String',
            null, null, null, true);
        
        LG_GeneralTest.createAttribute('Premise Id', attDef, false, null, prodConf, false, null, true);
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
        
        Test.startTest();
            prodReq.csbb__Product_Configuration__c = prodConf.Id;
            upsert prodReq;
        
            cscrm__Address__c newAddress = [SELECT Id, cscrm__City__c, cscrm__Zip_Postal_Code__c, LG_HouseNumberExtension__c,
                                            LG_HouseNumber__c, cscrm__Street__c, LG_AddressID__c, cscrm__State_Province__c,
                                            cscrm__Geolocation__Latitude__s, cscrm__Geolocation__Longitude__s
                                            FROM cscrm__Address__c 
                                            WHERE cscrm__Account__c = :basket.csbb__Account__c
                                            AND LG_AddressID__c = :address.LG_AddressID__c];
            
            System.assertEquals('Ilica', newAddress.cscrm__Street__c, 'Street should be Ilica');
            
            address.cscrm__Street__c = 'Ilica2';
            address.cscrm__City__c = 'ZGB';
            address.LG_HouseNumber__c = '65';
            address.LG_HouseNumberExtension__c = '2A';
            address.cscrm__Zip_Postal_Code__c = '45555';
            
            prodReq.csbb__Optionals__c = JSON.serialize(new LG_AddressResponse.OptionalsJson(address));
            
                
            upsert prodReq;
        
        Test.stopTest();
        
        newAddress = [SELECT Id, cscrm__City__c, cscrm__Zip_Postal_Code__c, LG_HouseNumberExtension__c,
                        LG_HouseNumber__c, cscrm__Street__c, LG_AddressID__c, cscrm__State_Province__c,
                        cscrm__Geolocation__Latitude__s, cscrm__Geolocation__Longitude__s
                        FROM cscrm__Address__c 
                        WHERE Id = :newAddress.Id];
                        
        cscfga__Attribute__c attribute = [SELECT Name, cscfga__Value__c, cscfga__Product_Configuration__c
                                         FROM cscfga__Attribute__c
                                         WHERE Name = 'Premise Id'
                                         AND cscfga__Product_Configuration__c = :prodConf.Id];
        
        System.assertEquals('Ilica2', newAddress.cscrm__Street__c, 'Upserted street should be Ilica2');
        System.assertEquals('ZGB', newAddress.cscrm__City__c, 'Upserted city should be ZGB');
        System.assertEquals('65', newAddress.LG_HouseNumber__c, 'Upserted house number should be 65');
        System.assertEquals('2A', newAddress.LG_HouseNumberExtension__c, 'Upserted house number extension should be 2A');
        System.assertEquals('45555', newAddress.cscrm__Zip_Postal_Code__c, 'Upserted post code should be 45555');
        System.assertEquals(newAddress.Id, attribute.cscfga__Value__c, 'Premise Id Valuse should be ' + newAddress.Id);
    }
*/    
    private static testmethod void testUpsertThePremisesRecordsProdConfChange()
    {
        cscrm__Address__c address = [SELECT Id, cscrm__City__c, cscrm__Zip_Postal_Code__c, LG_HouseNumberExtension__c,
                                    LG_HouseNumber__c, cscrm__Street__c, LG_AddressID__c, cscrm__State_Province__c,
                                    cscrm__Geolocation__Latitude__s, cscrm__Geolocation__Longitude__s
                                    FROM cscrm__Address__c WHERE Name = 'AddressOne'];
                                    
        cscfga__Product_Basket__c basket = [SELECT Id, csbb__Account__c
                                            FROM cscfga__Product_Basket__c WHERE Name = 'BAsket58'];
        
        cscfga__Product_Category__c prodCategory = [SELECT Id FROM cscfga__Product_Category__c
                                                    WHERE Name = 'TestCategory'];
        
        csbb__Product_Configuration_Request__c prodReq = [SELECT Id, csbb__Optionals__c,
                                                                csbb__Product_Basket__r.csbb__Account__c,
                                                                csbb__Product_Configuration__c
                                                            FROM csbb__Product_Configuration_Request__c
                                                            WHERE csbb__Product_Basket__r.Id = :basket.Id];
        
        prodReq.csbb__Optionals__c = JSON.serialize(new LG_AddressResponse.OptionalsJson(address));
        
        cscfga__Product_Definition__c prodDef = [SELECT Id FROM cscfga__Product_Definition__c WHERE Name = 'ProdDef'];
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;                                                                                                                      
        
        cscfga__Product_Configuration__c prodConf = LG_GeneralTest.createProductConfiguration('ProdConf', 3, basket, prodDef, false);
        insert prodConf;
        
        cscfga__Attribute_Definition__c attDef = LG_GeneralTest.createAttributeDefinition('AttDef', prodDef, 'User Input', 'String',
            null, null, null, true);
        
        LG_GeneralTest.createAttribute('Premise Id', attDef, false, null, prodConf, false, null, true);
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
        
        upsert prodReq;
    
        cscrm__Address__c newAddress = [SELECT Id, cscrm__City__c, cscrm__Zip_Postal_Code__c, LG_HouseNumberExtension__c,
                                        LG_HouseNumber__c, cscrm__Street__c, LG_AddressID__c, cscrm__State_Province__c,
                                        cscrm__Geolocation__Latitude__s, cscrm__Geolocation__Longitude__s
                                        FROM cscrm__Address__c 
                                        WHERE cscrm__Account__c = :basket.csbb__Account__c
                                        AND LG_AddressID__c = :address.LG_AddressID__c];
        
        System.assertEquals('Ilica', newAddress.cscrm__Street__c, 'Street should be Ilica');
        
        address.cscrm__Street__c = 'Ilica2';
        address.cscrm__City__c = 'ZGB';
        address.LG_HouseNumber__c = '65';
        address.LG_HouseNumberExtension__c = '2A';
        address.cscrm__Zip_Postal_Code__c = '45555';
        
        prodReq.csbb__Optionals__c = JSON.serialize(new LG_AddressResponse.OptionalsJson(address));
        
            
        upsert prodReq;
        
        Test.startTest();
            prodReq.csbb__Product_Configuration__c = prodConf.Id;
            update prodReq;
        Test.stopTest();
                        
        cscfga__Attribute__c attribute = [SELECT Name, cscfga__Value__c, cscfga__Product_Configuration__c
                                         FROM cscfga__Attribute__c
                                         WHERE Name = 'Premise Id'
                                         AND cscfga__Product_Configuration__c = :prodConf.Id];
                                         
        System.assertEquals(newAddress.Id, attribute.cscfga__Value__c, 'Premise Id Valuse should be ' + newAddress.Id);
    }    
 private static testmethod void testUpsertThePremisesRecords_EmptyOptionalsJSON()
    {

        Test.startTest();
        
        Account accountTEST = LG_GeneralTest.CreateAccount('AccountSFDT-59', '123456789', 'Ziggo1', true);
        
        Opportunity oppTEST = LG_GeneralTest.CreateOpportunity(accountTEST, true);
        
        cscfga__Product_Basket__c basketTEST = LG_GeneralTest.createProductBasket('BAsket58', accountTEST, null, oppTEST, false);
        basketTEST.csbb__Account__c = accountTEST.Id;
        insert basketTEST;
        
        //cscrm__Address__c newAddress = new cscrm__Address__c(cscrm__Account__c=accountTEST.id);
        
        cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('TestCategory', true);
    
        LG_GeneralTest.createProdConfigurationRequest(prodCategory.Id, basketTEST.Id, 500, 560, true);
        
        csbb__Product_Configuration_Request__c prodReq = [SELECT Id, csbb__Optionals__c,
                                                                csbb__Product_Basket__r.csbb__Account__c,
                                                                csbb__Product_Configuration__c
                                                            FROM csbb__Product_Configuration_Request__c
                                                            WHERE csbb__Product_Basket__r.Id = :basketTEST.Id];
        
        
        cscfga__Product_Definition__c prodDefTEST = LG_GeneralTest.createProductDefinition('ProdDefTEST', true);           
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;                                                                                                                      
        
        cscfga__Product_Configuration__c prodConf = LG_GeneralTest.createProductConfiguration('ProdConf', 3, basketTEST, prodDefTEST, false);
        insert prodConf;
        
        cscfga__Attribute_Definition__c attDef = LG_GeneralTest.createAttributeDefinition('AttDef', prodDefTEST, 'User Input', 'String',
            null, null, null, true);
        
        LG_GeneralTest.createAttribute('Premise Id', attDef, false, null, prodConf, false, null, true);
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
        
        //Test.startTest();
            prodReq.csbb__Product_Configuration__c = prodConf.Id;
            //prodReq.csbb__Optionals__c = JSON.serialize(new LG_AddressResponse.OptionalsJson(newAddress));
            upsert prodReq;

        cscfga__Attribute__c ATTEST = [select id, cscfga__Value__c from cscfga__Attribute__c where cscfga__Product_Configuration__c=:prodConf.Id];
         Test.stopTest();
         
        System.assertEquals(ATTEST.cscfga__Value__c, basketTEST.csbb__Account__r.LG_VisitAddressID__c);
        
    }
}