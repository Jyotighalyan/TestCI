@isTest
private class LG_ProductConfigurationUtilTest {

    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        Account acc = LG_GeneralTest.CreateAccount('AccountSFDT', '12345678', 'Ziggo', true);

        csconta__Billing_Account__c billingAccount = LG_GeneralTest.createBillingAccount('SFDT-59 Bill1', acc.Id, true, true);

        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, true);

        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('BAsket58', acc, null, opp, false);
        basket.csbb__Account__c = acc.Id;
        basket.csordtelcoa__Change_Type__c = 'Test';
        basket.LG_BillingAccount__c = billingAccount.Id;
        insert basket;

        // Generate Product Definition
        cscfga__Product_Definition__c prodDef = LG_GeneralTest.createProductDefinition('ProdDef58', true);

        // Generate Product Definition
        cscfga__Product_Definition__c prodDefNoKey = LG_GeneralTest.createProductDefinition('ProdDef58NoKey', true);

        // Generate Address (Premise)
        cscrm__Address__c premise = LG_GeneralTest.crateAddress('TestAddress', 'street', 'city', '5', '73', '2014GC', 'Netherlands', acc, true);

        // Generate Product Configuration
        cscfga__Product_Configuration__c prodConfiguration = LG_GeneralTest.createProductConfiguration('ProdConf58', 3, basket, prodDef, false);
        prodConfiguration.LG_PortIn__c = true;
        prodConfiguration.LG_MaximumQuantity__c = 20;
        prodConfiguration.LG_Address__c = premise.Id;
        prodConfiguration.cscfga__Product_Basket__c = basket.Id;
        insert prodConfiguration;

        cscfga__Product_Configuration__c prodConfiguration2 = LG_GeneralTest.createProductConfiguration('ProdConf582', 3, basket, prodDefNoKey, false);
        prodConfiguration2.LG_PortIn__c = true;
        prodConfiguration2.LG_MaximumQuantity__c = 20;
        prodConfiguration2.LG_Address__c = premise.Id;
        prodConfiguration2.cscfga__Product_Basket__c = basket.Id;
        insert prodConfiguration2;

		cscfga__Attribute_Definition__c attrDef = LG_GeneralTest.createAttributeDefinition('NonKeyAttribute', prodDef, '', 'String', '', '', '');

        cscfga__Attribute_Definition__c attrDefKeyAttribute = LG_GeneralTest.createAttributeDefinition('Key Attribute', prodDef, '', 'String', '', '', '');
        attrDefKeyAttribute.LG_KeyAttribute__c = true;
        attrDefKeyAttribute.LG_KeyAttributeSequence__c = 100;
        upsert attrDefKeyAttribute;

        cscfga__Attribute_Definition__c attrDefKeyAttributeSecond = LG_GeneralTest.createAttributeDefinition('Key Attribute Second', prodDef, '', 'String', '', '', '');
        attrDefKeyAttributeSecond.LG_KeyAttribute__c = true;
        attrDefKeyAttributeSecond.LG_KeyAttributeSequence__c = 40;
        upsert attrDefKeyAttributeSecond;

		cscfga__Attribute__c attribute = LG_GeneralTest.createAttribute('NonKeyAttribute', attrDef, true, 0, prodConfiguration, false, 'BTest', true);
        cscfga__Attribute__c attributeKey = LG_GeneralTest.createAttribute('Key Attribute', attrDefKeyAttribute, true, 0, prodConfiguration, false, 'BTestKey', true);
        attributeKey.cscfga__Display_Value__c = 'First Key';
        upsert attributeKey;
        cscfga__Attribute__c attributeKeySecond = LG_GeneralTest.createAttribute('Key Attribute Second', attrDefKeyAttributeSecond, true, 0, prodConfiguration, false, 'BTestKeyTwo', true);
		attributeKeySecond.cscfga__Display_Value__c = 'Second Key';
		upsert attributeKeySecond;

		cscfga__Attribute__c attributeConf2 = LG_GeneralTest.createAttribute('NonKeyAttribute', attrDef, true, 0, prodConfiguration2, false, 'BTest', true);
		LG_GeneralTest.createAttributeField('TestAttField', attributeConf2, 'AttFieldValue', true);

        noTriggers.Flag__c = false;
        upsert noTriggers;
    }

	private static testmethod void testGetProductConfigurations()
	{
        List<cscfga__Product_Configuration__c> prodConfs = [SELECT Id, Name FROM cscfga__Product_Configuration__c];
        List<Id> prodConfIds = new List<Id>();
        Map<Id, String> prodConfNameToId = new Map<Id,String>();
        for(cscfga__Product_Configuration__c conf : prodConfs)
        {
            prodConfIds.add(conf.Id);
            prodConfNameToId.put(conf.Id, conf.Name);
        }

        Map<Id, LG_ProductConfigurationUtil.ProductConfiguration> mapProdConfs;
        Test.startTest();
            LG_ProductConfigurationUtil util = new LG_ProductConfigurationUtil(prodConfIds);
            mapProdConfs = util.getProductConfigurations();
        Test.stopTest();

        for(Id confId : mapProdConfs.keySet())
        {
            LG_ProductConfigurationUtil.ProductConfiguration prodConf = mapProdConfs.get(confId);
            System.assertEquals(prodConfNameToId.get(confId), prodConf.prodConfiguration.Name, 'Names should be equals');
            if (prodConf.prodConfiguration.Name == 'ProdConf58')
            {
                System.assertEquals(3, prodConf.attributes.size(), 'ProdConf58 should have three attributes');
                System.assertEquals(2, prodConf.keyAttributesList.size(), 'ProdConf58 should have two key attribute');
            }
            else
            {
                System.assertEquals(1, prodConf.attributes.size(), 'ProdConf582 should have one attribute');
                System.assertEquals(0, prodConf.keyAttributesList.size(), 'ProdConf582 should have no key attribute');
            }
        }
	}

	private static testmethod void testGetKeyAttributesPerProdConf()
	{
        cscfga__Product_Configuration__c prodConf = [SELECT Id FROM cscfga__Product_Configuration__c
        													WHERE Name = 'ProdConf58'];
        List<Id> prodConfIds = new List<Id>();
        prodConfIds.add(prodConf.Id);

        String keyAttributes = '';
        Map<Id, LG_ProductConfigurationUtil.ProductConfiguration> mapProdConfs;
        Test.startTest();
            LG_ProductConfigurationUtil util = new LG_ProductConfigurationUtil(prodConfIds);
            keyAttributes = util.getKeyAttributesPerProdConf(prodConf.Id);
        Test.stopTest();

        System.assertEquals('Second Key, First Key', keyAttributes, 'Prod Conf key attributes value should be Second Key, First Key');
	}
}