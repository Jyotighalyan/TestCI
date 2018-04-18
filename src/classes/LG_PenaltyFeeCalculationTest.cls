@IsTest
public class LG_PenaltyFeeCalculationTest {

    public class PenaltyMock extends LG_PenaltyFeeCalculation {

        public override Map<Id, Decimal> calculatePenaltyFees(List<csord__Service__c> services, Id basketId, Map<Id, Date> subToWishdate) {

            Map<Id, Decimal> sliPrice = new Map<Id, Decimal>();

            List<csord__Service_Line_Item__c> slis = [SELECT Id, Name FROM csord__Service_Line_Item__c
                    WHERE csord__Service__c IN :services];

            for (csord__Service_Line_Item__c sli : slis) {

                if (sli.Name == 'Test SLI') {

                    sliPrice.put(sli.Id, 50);
                } else {

                    sliPrice.put(sli.Id, 100);
                }
            }

            return sliPrice;
        }
    }

    @IsTest
    private static void testGetCalcInstance() {

        LG_PenaltyFeeCalculation calcInstance = LG_PenaltyFeeCalculation.getCalcInstance();

       // System.assertEquals(true, calcInstance instanceof ZG_PenaltyFeeCalculation, 'Instance should be of ZG_PenaltyFeeCalculation class');
    }

    @testsetup
    private static void setupTestData() {

        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        LG_GeneralTest.setupServiceRequestUrls();

        LG_TerminationSpecificVariables__c termSpecifics = new LG_TerminationSpecificVariables__c();
        //termSpecifics.LG_PenaltyFeeCalculationClass__c = 'ZG_PenaltyFeeCalculation';
        termSpecifics.LG_NumberOfToleratedDays__c      = 0;
        insert termSpecifics;

        // Generate Account
        Account acc = LG_GeneralTest.CreateAccount('AccountSFDT', '12345678', 'Ziggo', true);

        // Generate Opportunity and Product Basket
        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, false);
        opp.LG_CalculatedPenaltyFee__c = 6000;
        opp.LG_FinalPenalty__c         = 300;
        insert opp;

        Opportunity opp22 = LG_GeneralTest.CreateOpportunity(acc, false);
        opp22.LG_CalculatedPenaltyFee__c = 6000;
        opp22.LG_FinalPenalty__c         = 300;
        insert opp22;

        // Generate Address (Premise)
        cscrm__Address__c address = LG_GeneralTest.crateAddress('TestAddress', 'street', 'city', '5', '73', '2014GC', 'Netherlands', acc, true);
        address.cscrm__Geolocation__latitude__s = 12.123456 ;
        address.cscrm__Geolocation__Longitude__s = 35.124531;
        update address;

        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('TestBasket', acc, null, opp, false);
        basket.csordtelcoa__Change_Type__c                   = 'Terminate';
        basket.csordtelcoa__Synchronised_with_Opportunity__c = true;
        insert basket;
        cscfga__Product_Basket__c basket1 = LG_GeneralTest.createProductBasket('TestteBasket11', acc, null, opp22, false);
        // basket.csordtelcoa__Change_Type__c                   = 'Terminate';
        basket1.csordtelcoa__Synchronised_with_Opportunity__c = true;
        insert basket1;
        
        cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('Termination', true);
        
        csbb__Product_Configuration_Request__c prodReq = LG_GeneralTest.createProdConfigurationRequest(prodCategory.Id, basket.Id, 50, 100, true);


        // Prepare Product Configurations with Total Price
        cscfga__Product_Definition__c prodDef = LG_GeneralTest.createProductDefinition('Penalty Fee', false);
        prodDef.cscfga__Product_Category__c = prodCategory.Id;
        prodDef.LG_ProductSubtype__c = 'Penalty Fee';
        insert prodDef;

        List<cscfga__Product_Configuration__c> prodConfs = new List<cscfga__Product_Configuration__c>();
        cscfga__Product_Configuration__c pc = LG_GeneralTest.createProductConfiguration('ProdConf58', 3, basket, prodDef, false);
        pc.cscfga__total_one_off_charge__c = 1000;
        pc.cscfga__Total_Price__c          = 1000;
        pc.cscfga__Unit_Price__c           = 1000;

        cscfga__Product_Configuration__c pc1 = LG_GeneralTest.createProductConfiguration('ProdConf581', 3, basket, prodDef, false);
        pc1.cscfga__total_one_off_charge__c = 1000;
        pc1.cscfga__Total_Price__c          = 1000;
        pc1.cscfga__Unit_Price__c           = 1000;

        cscfga__Product_Configuration__c pc2 = LG_GeneralTest.createProductConfiguration('ProdConf582', 3, basket, prodDef, false);
        pc2.cscfga__total_one_off_charge__c = 1000;
        pc2.cscfga__Total_Price__c          = 1000;
        pc2.cscfga__Unit_Price__c           = 1000;

        prodConfs.add(pc);
        prodConfs.add(pc1);
        prodConfs.add(pc2);

        insert prodConfs;

        // Create Attribute Definition
        cscfga__Attribute_Definition__c attributeDefinition     = LG_GeneralTest.createAttributeDefinition('Test definition', prodDef, 'Calculation', 'Decimal', '', 'Main OLI', '');
        cscfga__Attribute_Definition__c attributeDefinitionOp   = LG_GeneralTest.createAttributeDefinition('Overridden Price', prodDef, 'Calculation', 'Decimal', '', 'Main OLI', '');
        cscfga__Attribute_Definition__c attributeDefinitionCp   = LG_GeneralTest.createAttributeDefinition('Calculated Price', prodDef, 'Calculation', 'Decimal', '', 'Main OLI', '');
        cscfga__Attribute_Definition__c attributeDefinitionPn   = LG_GeneralTest.createAttributeDefinition('Product Name', prodDef, 'Calculation', 'String', '', 'Main OLI', '');
        cscfga__Attribute_Definition__c attributeDefinitionPi   = LG_GeneralTest.createAttributeDefinition('Premise Id', prodDef, 'Calculation', 'String', '', 'Main OLI', '');
        cscfga__Attribute_Definition__c attributeDefinitionSi   = LG_GeneralTest.createAttributeDefinition('Site Id', prodDef, 'Calculation', 'String', '', 'Main OLI', '');
        cscfga__Attribute_Definition__c attributeDefinitionPNmb = LG_GeneralTest.createAttributeDefinition('Premise Number', prodDef, 'Calculation', 'String', '', 'Main OLI', '');
        cscfga__Attribute_Definition__c attributeDefinitionBn   = LG_GeneralTest.createAttributeDefinition('Basket Number', prodDef, 'Calculation', 'String', '', 'Main OLI', '');
        cscfga__Attribute_Definition__c attributeDefinitionOn   = LG_GeneralTest.createAttributeDefinition('Order Number', prodDef, 'Calculation', 'String', '', 'Main OLI', '');
        cscfga__Attribute_Definition__c attributeDefinitionD    = LG_GeneralTest.createAttributeDefinition('Description', prodDef, 'Calculation', 'String', '', 'Main OLI', '');

        cscfga__Attribute__c a  = LG_GeneralTest.createAttribute('Overridden Price', attributeDefinition, true, 0, pc, false, '2000', false);
        cscfga__Attribute__c c  = LG_GeneralTest.createAttribute('Calculated Price', attributeDefinition, true, 0, pc, false, '2000', false);
        cscfga__Attribute__c a1 = LG_GeneralTest.createAttribute('Overridden Price', attributeDefinition, true, 0, pc1, false, '2000', false);
        cscfga__Attribute__c c1 = LG_GeneralTest.createAttribute('Calculated Price', attributeDefinition, true, 0, pc1, false, '2000', false);
        cscfga__Attribute__c a2 = LG_GeneralTest.createAttribute('Overridden Price', attributeDefinition, true, 0, pc2, false, '2000', false);
        cscfga__Attribute__c c2 = LG_GeneralTest.createAttribute('Calculated Price', attributeDefinition, true, 0, pc2, false, '2000', false);

        a.cscfga__Price__c  = 2000;
        a1.cscfga__Price__c = 2000;
        a2.cscfga__Price__c = 2000;

        c.cscfga__Price__c  = 2000;
        c1.cscfga__Price__c = 2000;
        c2.cscfga__Price__c = 2000;

        List<cscfga__Attribute__c> attrs = new List<cscfga__Attribute__c> { a, a1, a2, c, c1, c2 };
        insert attrs;

        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert coreq;

        csord__Order_Request__c coreq1 = new csord__Order_Request__c(csord__Module_Name__c = 'Test1', csord__Module_Version__c = '1.0');
        insert coreq1;

        Opportunity opp2 = LG_GeneralTest.CreateOpportunity(acc, false);
        opp2.LG_CalculatedPenaltyFee__c = 6000;
        opp2.LG_FinalPenalty__c         = 300;
        insert opp2;

        cscfga__Product_Configuration__c pc11 = LG_GeneralTest.createProductConfiguration('ProdConf58', 3, basket1, prodDef, false);
        pc11.cscfga__total_one_off_charge__c = 1000;
        pc11.cscfga__Total_Price__c          = 1000;
        pc11.cscfga__Unit_Price__c           = 1000;
        pc11.LG_InstallationWishDate__c = Date.today();
        insert pc11;

        csconta__Contract__c cont = new csconta__Contract__c();
        cont.LG_TerminationDate__c = Date.today() + 200;
        cont.csconta__Valid_To__c = system.today() + 10;
        insert cont;

        csconta__Contract__c cont2 = new csconta__Contract__c();
        cont2.csconta__Valid_To__c = system.today() + 10;
        insert cont2;

         csconta__Billing_Account__c bAcc= new csconta__Billing_Account__c(csconta__Account__c= acc.ID, csconta__Status__c='New', LG_ContractualOrganization__c='Hessen (HSN)', csconta__Billing_Channel__c='Paper', UM_BillFormatOptions__c='Summary');
    	 insert bAcc;
        
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = coreq.Id);
        sub.csconta__Billing_Account__c = bAcc.id;
        sub.LG_Address__c  = address.Id;
        sub.LG_Contract__c = cont.Id;
        insert sub;

        csord__Subscription__c sub2 = new csord__Subscription__c(csord__Identification__c = 'TestIdent2', csord__Order_Request__c = coreq.Id);
        sub2.LG_Address__c  = address.Id;
        sub2.csconta__Billing_Account__c = bAcc.id;
        sub2.LG_Contract__c = cont.Id;
        insert sub2;

        csord__Subscription__c sub3 = new csord__Subscription__c(csord__Identification__c = 'TestIdent3', csord__Order_Request__c = coreq1.Id);
        sub3.LG_Address__c  = address.Id;
        sub3.csconta__Billing_Account__c = bAcc.id;
        sub3.LG_Contract__c = cont2.Id;
        sub3.csordtelcoa__Product_Configuration__c = pc11.Id;
        insert sub3;

        csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestService', csord__Subscription__c = sub.Id, csord__Order_Request__c = coreq.Id);
        service.LG_Address__c = address.Id;
        insert service;

        csord__Service__c service2 = new csord__Service__c(csord__Identification__c = 'TestService3', csord__Subscription__c = sub2.Id, csord__Order_Request__c = coreq.Id);
        service2.LG_Address__c = address.Id;
        insert service2;

        csord__Service__c service3 = new csord__Service__c(csord__Identification__c = 'TestService2', csord__Subscription__c = sub3.Id, csord__Order_Request__c = coreq1.Id);
        service3.LG_Address__c = address.Id;
        service3.csordtelcoa__Product_Configuration__c = pc11.id;
        insert service3;

        insert new csord__Service_Line_Item__c(Name = 'Test SLI',
                                               csord__Total_Price__c = 1525,
                                               csord__Service__c = service.Id,
                                               LG_Commitment__c = 'YES',
                                               csord__Is_Recurring__c = true,
                                               csord__Identification__c = '123456789',
                                               csord__Order_Request__c = coreq.Id);

        insert new csord__Service_Line_Item__c(Name = 'Test SLI2',
                                               csord__Total_Price__c = 3050,
                                               csord__Service__c = service2.Id,
                                               LG_Commitment__c = 'YES',
                                               csord__Is_Recurring__c = true,
                                               csord__Identification__c = '123456789',
                                               csord__Order_Request__c = coreq.Id);


        insert new csord__Service_Line_Item__c(Name = 'Test SLI3',
                                               csord__Total_Price__c = 3050,
                                               csord__Service__c = service3.Id,
                                               LG_Commitment__c = 'Yes',
                                               csord__Is_Recurring__c = true,
                                               csord__Identification__c = '123456789',
                                               csord__Order_Request__c = coreq1.Id);

        cscfga__Product_Definition__c prodDefTerm = LG_GeneralTest.createProductDefinition('Termination', true);
        cscfga__Product_Configuration__c pcTerm   = LG_GeneralTest.createProductConfiguration('Termination', 3, basket, prodDefTerm, false);
        pcTerm.cscfga__Product_Family__c  = 'Termination';
        pcTerm.LG_InstallationWishDate__c = Date.today();
        pcTerm.LG_Address__c              = address.Id;

        insert pcTerm;

        /*
         * MACD Change with downgrade (penalty fee)
        */
        cscfga__Product_Basket__c basket2 = LG_GeneralTest.createProductBasket('Change Basket', acc, null, opp2, false);
        basket2.csordtelcoa__Change_Type__c                   = 'Change';
        basket2.csordtelcoa__Synchronised_with_Opportunity__c = true;
        insert basket2;

        cscfga__Product_Configuration__c pc22 = LG_GeneralTest.createProductConfiguration('ProdConf58', 3, basket2, prodDef, false);
        pc22.cscfga__total_one_off_charge__c = 1000;
        pc22.cscfga__Total_Price__c          = 1000;
        pc22.cscfga__Unit_Price__c           = 1000;
        pc22.csordtelcoa__Replaced_Product_Configuration__c = pc11.Id;
        pc22.csordtelcoa__Replaced_Service__c = service3.Id;
        pc22.LG_ChangeType__c = 'Change';
        pc22.LG_InstallationWishDate__c = Date.today();

        insert pc22;

        List<csordtelcoa__Subscr_MACDProductBasket_Association__c> subBasketRelations = new List<csordtelcoa__Subscr_MACDProductBasket_Association__c>();

        subBasketRelations.add(new csordtelcoa__Subscr_MACDProductBasket_Association__c(csordtelcoa__Subscription__c = sub.Id,
                               csordtelcoa__Product_Basket__c = basket.Id, LG_DeactivationWishDate__c = Date.today()));

        subBasketRelations.add(new csordtelcoa__Subscr_MACDProductBasket_Association__c(csordtelcoa__Subscription__c = sub2.Id,
                               csordtelcoa__Product_Basket__c = basket.Id, LG_DeactivationWishDate__c = Date.today()));

        insert subBasketRelations;

        cscfga__Attribute_Definition__c attributeDefinition22     = LG_GeneralTest.createAttributeDefinition('Test definition', prodDef, 'Calculation', 'Decimal', '', 'Main OLI', '');

        cscfga__Attribute__c  att1 = new cscfga__Attribute__c();

        att1.Name = 'Month';
        att1.cscfga__Attribute_Definition__c = attributeDefinition22.Id;
        att1.cscfga__Is_Line_Item__c = true;
        att1.cscfga__Price__c = 2500.00;
        att1.cscfga__Product_Configuration__c = pc11.Id;
        att1.cscfga__Recurring__c = true;
        att1.cscfga__Value__c = '2500.00';
        att1.cscfga__Line_Item_Description__c = 'name';
        insert att1;

        cscfga__Attribute__c  att2 = new cscfga__Attribute__c();
        att2.Name = 'Month';
        att2.cscfga__Attribute_Definition__c = attributeDefinition22.Id;
        att2.cscfga__Is_Line_Item__c = true;
        att2.cscfga__Price__c = 2050.00;
        att2.cscfga__Product_Configuration__c = pc22.Id;
        att2.cscfga__Recurring__c = True;
        att2.cscfga__Value__c = '2050.00';
        att2.cscfga__Line_Item_Description__c = 'name';
        insert att2;

        cscfga__Attribute_Field__c atfi1 = LG_GeneralTest.createAttributeField('Commitment', att1, 'Yes', true);
        cscfga__Attribute_Field__c atfil2 = LG_GeneralTest.createAttributeField('Commitment', att2, 'Yes', true);

        noTriggers.Flag__c = false;
        upsert noTriggers;
    }

    /**
     * Implement the overwrite penalty fees method
     *
     * @author Petar Miletic
     * @story SFDT-1188, SFDT-1309
     * @since  13/07/2016
     */
    @IsTest
    public static void overwritePenaltyFees () {

        Opportunity opp = [SELECT Id, LG_CalculatedPenaltyFee__c FROM Opportunity LIMIT 1];

        cscfga__Product_Basket__c basket = [SELECT Id, Name FROM cscfga__Product_Basket__c WHERE cscfga__Opportunity__c = :opp.Id];

        Test.startTest();

        new PenaltyMock().overwritePenaltyFees(3000, opp.Id);

        Test.stopTest();

        List<cscfga__Attribute__c> attribs = [SELECT Id, Name,
                                              cscfga__Product_Configuration__c,
                                              cscfga__Product_Configuration__r.cscfga__Product_Basket__c,
                                              cscfga__Value__c,
                                              cscfga__Price__c,
                                              cscfga__Product_Configuration__r.cscfga__total_one_off_charge__c,
                                              cscfga__Product_Configuration__r.cscfga__Total_Price__c,
                                              cscfga__Product_Configuration__r.cscfga__Unit_Price__c
                                              FROM cscfga__Attribute__c
                                              WHERE Name = 'Overridden Price' AND
                                                      cscfga__Product_Configuration__r.cscfga__Product_Basket__c = :basket.Id];
        // Calculate percentage
        decimal penaltyTotal   = 6000;
        decimal overridenTotal = 3000;
        decimal difference     = (((overridenTotal * 100) / penaltyTotal) - 100);

        // Calculate value
        decimal val = 2000 + ((2000 * difference) / 100);

        Boolean attribsOK = true;
        Boolean pcsOK     = true;

        for (cscfga__Attribute__c a : attribs) {
            if (a.cscfga__Price__c != val) {
                attribsOK = false;
            }

            cscfga__Product_Configuration__c pc = a.cscfga__Product_Configuration__r;

            if (pc.cscfga__total_one_off_charge__c != val || pc.cscfga__Total_Price__c != val || pc.cscfga__Unit_Price__c != val) {
                pcsOK = false;
            }
        }

        System.assertEquals(3, attribs.size(), 'Invalid data');
        System.assertEquals(true, attribsOK, 'Invalid data');
        System.assertEquals(true, pcsOK, 'Invalid data');
    }

    private static testmethod void testCalculateCreatePenaltyFee() {
        Set<Id> serviceIds = new Set<Id>();
        for (csord__Service__c service : [SELECT Id FROM csord__Service__c  ]) {
            serviceIds.add(service.Id);
        }
        cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'TestBasket' ];

        Test.startTest();
        new PenaltyMock().calculateCreatePenaltyFee(basket.Id, serviceIds);
        Test.stopTest();

        List<cscfga__Product_Configuration__c> prodConfs = [SELECT Id, Name, cscfga__Total_Price__c
                FROM cscfga__Product_Configuration__c
                WHERE cscfga__Product_Basket__c = :basket.Id
                        AND cscfga__Product_Family__c = 'Penalty Fee'];

        System.assertEquals(3, prodConfs.size(), 'Penalty Fees should be created');

        for (cscfga__Product_Configuration__c prodC : prodConfs) {
            if (prodC.Name == 'Penalty Fee for Test SLI') {
                System.assertEquals(50, prodC.cscfga__Total_Price__c, 'Price should be 50');
            } else {
                System.assertEquals(100, prodC.cscfga__Total_Price__c, 'Price should be 50');
            }
        }
    }
}