@isTest
private class LG_ProductBasketTriggerHandlerTest {

  private static String accWithBillAccName = 'SFDT-59 W-Def';
  private static String accWithoutBillAccName = 'SFDT-59 Wo-Def';
  private static String defaultBillingAccountName = 'SFDT-59 Bill1';

  @testsetup
  private static void setupTestData() {
    No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    noTriggers.Flag__c = true;
    noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
    upsert noTriggers;

    List<Account> accounts = new List<Account>();
    Account accWithDefaultBill = LG_GeneralTest.CreateAccount(accWithBillAccName, '12345678', 'Ziggo', false);
    Account accWithoutDefaultBill = LG_GeneralTest.CreateAccount(accWithoutBillAccName, '12345679', 'Ziggo', false);
    accounts.add(accWithoutDefaultBill);
    accounts.add(accWithDefaultBill);
    insert accounts;

    List<csconta__Billing_Account__c> billAccounts = new List<csconta__Billing_Account__c>();
    billAccounts.add(LG_GeneralTest.createBillingAccount(defaultBillingAccountName, accWithDefaultBill.Id, true, false));
    billAccounts.add(LG_GeneralTest.createBillingAccount('SFDT-59 Bill2', accWithDefaultBill.Id, false, false));
    billAccounts.add(LG_GeneralTest.createBillingAccount('SFDT-59 Bill3', accWithoutDefaultBill.Id, false, false));
    insert billAccounts;

    List<Opportunity> opps = new List<Opportunity>();
    Opportunity oppWDefault = LG_GeneralTest.CreateOpportunity(accWithDefaultBill, false);
    Opportunity oppWoDefault = LG_GeneralTest.CreateOpportunity(accWithoutDefaultBill, false);
    opps.add(oppWDefault);
    opps.add(oppWoDefault);
    insert opps;

    noTriggers.Flag__c = false;
    upsert noTriggers;
  }

  private static testmethod void testPopulateTheCustomerAccountField() {
    Account accWithBillAcc = [SELECT Id, Name FROM Account WHERE Name = :accWithBillAccName];
    Opportunity oppWith = [SELECT Id, AccountId FROM Opportunity WHERE AccountId = :accWithBillAcc.Id];

    Test.startTest();

		cscfga__Product_Basket__c basketWithDefaultBillAcc = LG_GeneralTest.createProductBasket('WithBillAcc', accWithBillAcc, null, oppWith, true);
	

		Test.stopTest();

		basketWithDefaultBillAcc = [SELECT Id, csbb__Account__r.Id FROM cscfga__Product_Basket__c WHERE Id = :basketWithDefaultBillAcc.Id];

		System.assertEquals(accWithBillAcc.Id, basketWithDefaultBillAcc.csbb__Account__r.Id, 'Basket should have the customer account field populated');
	}
	
    private static testmethod void testPopulateTheCustomerAccountFieldUpdate() {
		Account accWithBillAcc = [SELECT Id, Name FROM Account WHERE Name = :accWithBillAccName];
		Opportunity oppWith = [SELECT Id, AccountId FROM Opportunity WHERE AccountId = :accWithBillAcc.Id];
		
		Test.startTest();

		cscfga__Product_Basket__c basketWithDefaultBillAcc = LG_GeneralTest.createProductBasket('WithBillAcc', accWithBillAcc, null, null, true);
        cscfga__Product_Basket__c basketWithDefaultBillAcc2 = LG_GeneralTest.createProductBasket('WithBillAcc', accWithBillAcc, null, null, False);
        basketWithDefaultBillAcc2.csordtelcoa__Synchronised_with_Opportunity__c=True;
        insert basketWithDefaultBillAcc2;
        cscfga__Product_Definition__c preoDef=LG_GeneralTest.createProductDefinition('ProductDef',True);
        cscfga__Product_Configuration__c prodConfig=LG_GeneralTest.createProductConfiguration('ProdConfig', 3, basketWithDefaultBillAcc,preoDef,True);
		cscfga__Attribute_Definition__c aattrDef=LG_GeneralTest.createAttributeDefinition('AttrbuteDef', preoDef, 'Select List', 'Integer', '', '', 'Contract Term', True);
		cscfga__Attribute__c attribute = LG_GeneralTest.createAttribute('Test', aattrDef, false, 0, prodConfig, false, '30', true);
		basketWithDefaultBillAcc = [SELECT Id, csbb__Account__r.Id,csordtelcoa__Synchronised_with_Opportunity__c FROM cscfga__Product_Basket__c WHERE Id = :basketWithDefaultBillAcc.Id];
		basketWithDefaultBillAcc.Name='';
        basketWithDefaultBillAcc.cscfga__Opportunity__c=oppWith.Id;
        basketWithDefaultBillAcc.csordtelcoa__Synchronised_with_Opportunity__c=True;

        basketWithDefaultBillAcc2 = [SELECT Id, csbb__Account__r.Id,csordtelcoa__Synchronised_with_Opportunity__c FROM cscfga__Product_Basket__c WHERE Id = :basketWithDefaultBillAcc2.Id];
		basketWithDefaultBillAcc2.Name='';
        basketWithDefaultBillAcc2.cscfga__Opportunity__c=oppWith.Id;
        basketWithDefaultBillAcc2.csordtelcoa__Synchronised_with_Opportunity__c=True;
        List<cscfga__Product_Basket__c>updateLst= new List <cscfga__Product_Basket__c>();
        updateLst.add(basketWithDefaultBillAcc);
        updateLst.add(basketWithDefaultBillAcc2);
        update updateLst;
        Test.stopTest();
		//System.assertEquals(accWithBillAcc.Id, basketWithDefaultBillAcc.csbb__Account__r.Id, 'Basket should have the customer account field populated');
	}

	private static testmethod void testStDefaultBillingAccount() {
		List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name = :accWithoutBillAccName OR Name = :accWithBillAccName];
		Account accWithBillAcc;
		Account accWithoutBillAcc;

    for (Account account : accounts) {
      if (account.Name.equals(accWithBillAccName)) {
        accWithBillAcc = account;
      } else if (account.Name.equals(accWithoutBillAccName)) {
        accWithoutBillAcc = account;
      }
    }

    List<Opportunity> opps = [SELECT Id, AccountId FROM Opportunity WHERE AccountId = :accWithBillAcc.Id OR AccountId = :accWithoutBillAcc.Id];
    Opportunity oppWith;
    Opportunity oppWo;

    for (Opportunity opp : opps) {
      if (opp.AccountId.equals(accWithBillAcc.Id)) {
        oppWith = opp;
      } else if (opp.AccountId.equals(accWithoutBillAcc.Id)) {
        oppWo = opp;
      }
    }

    Test.startTest();

    List<cscfga__Product_Basket__c> baskets = new List<cscfga__Product_Basket__c>();
    cscfga__Product_Basket__c basketWithDefaultBillAcc = LG_GeneralTest.createProductBasket('WithBillAcc', accWithBillAcc, null, oppWith, false);
    cscfga__Product_Basket__c basketWoDefaultBillAcc = LG_GeneralTest.createProductBasket('WithoutBillAcc', accWithoutBillAcc, null, oppWo, false);
    insert baskets;

    Test.stopTest();

    baskets = [SELECT Id, LG_BillingAccount__c, LG_BillingAccount__r.csconta__Financial_Account_Number__c FROM cscfga__Product_Basket__c WHERE Id IN :baskets];
    for (cscfga__Product_Basket__c basket : baskets) {
      if (basket.Name.equals('WithBillAcc')) {
        System.assert(basket.LG_BillingAccount__c != null, 'Billing Account should be populated');
        System.assertEquals(defaultBillingAccountName, basket.LG_BillingAccount__r.csconta__Financial_Account_Number__c, 'Billing Account should be SFDT-59 Bill1');
      } else if (basket.Name.equals('WithoutBillAcc')) {
        System.assert(basket.LG_BillingAccount__c == null, 'Billing Account should not be populated');
      }
    }
  }
	
  private static testmethod void testUpdateOpportunity() {
  	Test.startTest();
    Account accWithBillAcc = [SELECT Id, Name FROM Account WHERE Name = :accWithBillAccName];
    Opportunity oppWith = [SELECT Id, AccountId FROM Opportunity WHERE AccountId = :accWithBillAcc.Id];
    List<cscfga__Product_Basket__c> baskets1 = new List<cscfga__Product_Basket__c>();
    List<cscfga__Product_Basket__c> baskets2 = new List<cscfga__Product_Basket__c>();
    baskets1.add(LG_GeneralTest.createProductBasket('Basket1', accWithBillAcc, null, oppWith, true));
    baskets2.add(LG_GeneralTest.createProductBasket('Basket2', accWithBillAcc, null, oppWith, true));
    LG_ProductBasketTriggerHandler lgpbt = new LG_ProductBasketTriggerHandler();
    Update baskets1;
    oppWith = [SELECT Id, AccountId,UM_TotalContractValue__c,UM_IncrementTCV__c FROM Opportunity WHERE AccountId = :accWithBillAcc.Id];
    System.assertEquals(oppWith.UM_IncrementTCV__c , 0.0);

    Test.stopTest();
    
  }
  
  private static testmethod void testUpdateOpportunityDisc() {
  	Test.startTest();
    Account accWithBillAcc = [SELECT Id, Name FROM Account WHERE Name = :accWithBillAccName];
    Opportunity oppWith = [SELECT Id, AccountId FROM Opportunity WHERE AccountId = :accWithBillAcc.Id];
    List<cscfga__Product_Basket__c> baskets1 = new List<cscfga__Product_Basket__c>();
    List<cscfga__Product_Basket__c> baskets2 = new List<cscfga__Product_Basket__c>();
    baskets1.add(LG_GeneralTest.createProductBasket('Basket1', accWithBillAcc, null, oppWith, true));
    baskets2.add(LG_GeneralTest.createProductBasket('Basket2', accWithBillAcc, null, oppWith, true));
    LG_ProductBasketTriggerHandler lgpbt = new LG_ProductBasketTriggerHandler();
    Update baskets1;
    oppWith = [SELECT Id, AccountId,UM_TotalContractValue__c,UM_IncrementTCV__c FROM Opportunity WHERE AccountId = :accWithBillAcc.Id];
    
    System.assertEquals(oppWith.UM_IncrementTCV__c , 0.0);

    Test.stopTest();
    
  }
    
    public static testmethod void AfterUpdateHandletest(){
         Account accWithBillAcc = [SELECT Id, Name FROM Account WHERE Name = :accWithBillAccName];
    Opportunity oppWith = [SELECT Id, AccountId FROM Opportunity WHERE AccountId = :accWithBillAcc.Id];
        cscfga__Product_Basket__c basketWithDefaultBillAcc = LG_GeneralTest.createProductBasket('New Basket', accWithBillAcc, null, oppWith, true);

        
         Account accWithoutDefaultBill = LG_GeneralTest.CreateAccount(accWithoutBillAccName, '12345679', 'Ziggo', false);
		 Opportunity oppWoDefault = LG_GeneralTest.CreateOpportunity(accWithoutDefaultBill, false);
        cscfga__Product_Basket__c basketWithDefaultBillAcc1 = LG_GeneralTest.createProductBasket('New Basket', accWithoutDefaultBill, null, oppWoDefault, true);
        test.startTest();
        List<cscfga__Product_Basket__c> testdata=[select name,csordtelcoa__Synchronised_with_Opportunity__c,Lead__c,cscfga__Opportunity__c,cscfga__Basket_Status__c from cscfga__Product_Basket__c where cscfga__Opportunity__c!=null];
        system.debug(testdata);
        testdata[0].csordtelcoa__Synchronised_with_Opportunity__c=true;
        update testdata[0];
        system.debug(testdata[0].cscfga__Opportunity__c);
        List<cscfga__Product_Basket__c> testprod=new List<cscfga__Product_Basket__c>();
        testprod.add(basketWithDefaultBillAcc1);
        testprod.add(basketWithDefaultBillAcc);
        LG_ProductBasketTriggerHandler.AfterUpdateHandle(testdata,testprod);
        test.stopTest();
        
    }
    
    /* LG_ProductUtility Test Coverage increase */
    private static testmethod void LG_ProductUtilityTest() {
        Account acc = [SELECT Id, Name FROM Account WHERE Name = :accWithBillAccName];
        Account ac1 = new Account();
        ac1.Name = 'Test 1';
        ac1.LG_AddressValidated__c = true;
        insert ac1;
        
        Account ac2 = new Account();
        ac2.Name = 'Test 2';
        ac2.LG_CompetitorContractEndDate__c = date.today();
        insert ac2;
        
    	Opportunity oppWith = [SELECT Id, AccountId FROM Opportunity WHERE AccountId = :acc.Id];
    	cscfga__Product_Basket__c baskets1 = LG_GeneralTest.createProductBasket('Basket1', acc, null, oppWith, true);
    	cscfga__Product_Basket__c baskets2 = LG_GeneralTest.createProductBasket('Basket2', acc, null, oppWith, true);
       // baskets1.LG_UsedQuoteObjects__c = 'Opportunity';
        update baskets1;
        Set<string> setProductBasketId = new Set<string>();
        setProductBasketId.add(baskets1.id);
        setProductBasketId.add(baskets2.id);
        
        List<cscfga__Product_Basket__c> newpb = new List<cscfga__Product_Basket__c>();
        newpb.add(LG_GeneralTest.createProductBasket('Basket1', acc, null, oppWith, true));
        newpb.add(baskets1);
        
        date d1 = date.today();
        string d = string.valueOf(d1);
   
        
         
        test.startTest();
    	LG_ProductUtility.DeleteHardOLIs(setProductBasketId); 
        LG_ProductUtility.DeleteHardOLIs(setProductBasketId,newpb);
        LG_ProductUtility.getCorrectType(Account.sObjectType,'AnnualRevenue',null);
        LG_ProductUtility.getCorrectType(Account.sObjectType,'AnnualRevenue','123456');
        LG_ProductUtility.getCorrectType(Account.sObjectType,'IsPartner',null);
        LG_ProductUtility.getCorrectType(Account.sObjectType,'IsPartner','no');
        LG_ProductUtility.getCorrectType(Account.sObjectType,'IsPartner','yes');
        LG_ProductUtility.getCorrectType(Account.sObjectType,'LG_CompetitorContractEndDate__c',null);
        LG_ProductUtility.getCorrectType(Account.sObjectType,'LG_CompetitorContractEndDate__c',d);
        LG_ProductUtility.getCorrectType(Account.sObjectType,'UM_LastSyncedwithBilling__c',null);
        LG_ProductUtility.getCorrectType(Account.sObjectType,'LG_NumberOfLaptops__c',null);
        LG_ProductUtility.getCorrectType(Account.sObjectType,'LG_NumberOfLaptops__c','2');
        LG_ProductUtility.getFieldDescribe(Account.sObjectType,'Name');
        LG_ProductUtility.getObjectDescribe(Account.sObjectType);
        LG_ProductUtility.getAttributeValue(ac2.LG_CompetitorContractEndDate__c);
        LG_ProductUtility.getAttributeValue(ac1.LG_AddressValidated__c);
        LG_ProductUtility.getAttributeValue(ac1.Name);
        LG_ProductUtility.MapProductConfigurationsToQuotesObject(setProductBasketId,true);
        LG_ProductUtility.MapProductConfigurationsToQuotesObject(setProductBasketId,false);
        LG_ProductUtility.DeleteOpportunityReports(setProductBasketId,newpb);
        test.stopTest();
    }
    
   
}