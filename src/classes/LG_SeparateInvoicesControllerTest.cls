@isTest
private class LG_SeparateInvoicesControllerTest {
    
    private static String vfBaseUrl = 'vforce.url';
    private static String sfdcBaseUrl = 'sfdc.url';
    
    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        LG_EnvironmentVariables__c envVariables = new LG_EnvironmentVariables__c();
        envVariables.LG_SalesforceBaseURL__c = sfdcBaseUrl;
        envVariables.LG_VisualForceBaseURL__c = vfBaseUrl;
        envVariables.LG_CloudSenceAnywhereIconID__c = 'csaID';
        envVariables.LG_ServiceAvailabilityIconID__c = 'saIconId';
        insert envVariables;
        
        Account account = LG_GeneralTest.CreateAccount('AccountSFDT-58', '12345678', 'Ziggo', true);
        
        csconta__Billing_Account__c billacc=  LG_GeneralTest.createBillingAccount('BillingAccount', account.Id, true, true);
        
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
        
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('BAsket58', account, null, opp, false);
        basket.csbb__Account__c = account.Id;
        insert basket;
        
        cscfga__Product_Definition__c prodDef = LG_GeneralTest.createProductDefinition('ProdDef58', true);
        
        cscfga__Product_Configuration__c prodConf = LG_GeneralTest.createProductConfiguration('ProdConf58', 3, basket, prodDef, true);
        prodConf.LG_Billing_Account__c=billacc.id;
        update prodConf;
        cscfga__Product_Category__c prodCat=LG_GeneralTest.createProductCategory('TestCategory',true);
        
        
        //DvtH7Sep2016 
        //Creating a configuration request does the create attribute definition fail !!
        //
        
        cscfga__Attribute_Definition__c attDef = LG_GeneralTest.createAttributeDefinition('AttDef58', prodDef, 'Lookup', 'String',
            null, null, null, true);
        
        Double price = 5.15;
        
        cscfga__Attribute__c attr= LG_GeneralTest.createAttribute('Att58-1', attDef, true, price, prodConf, true, '58', true);
        cscfga__Attribute__c attr1=LG_GeneralTest.createAttribute('Att58-2', attDef, true, price, prodConf, true, '58', true);
        LG_GeneralTest.createAttributeField('BillingAccount',attr,string.valueof(billacc.id),true);
        LG_GeneralTest.createAttributeField('BillingAccount',attr1,string.valueof(billacc.id),true);
        
        
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    
    private static testmethod void testRedirectToBasket()
    {
        Test.startTest();
        
            LG_SeparateInvoicesController controller = new LG_SeparateInvoicesController();
            PageReference pageRef = controller.redirectToBasket();
            
        Test.stopTest();
        
    //    System.assertEquals(vfBaseUrl + '/apex/BasketbuilderApp?Id=null', pageRef.getUrl(),
    //                        'Url should be ' + vfBaseUrl + '/apex/BasketbuilderApp?Id=');   
    }
    
    private static testmethod void testCreateNewBillAccount()
    {
        cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'BAsket58'];
        Account account = [SELECT Id, Name FROM Account WHERE Name = 'AccountSFDT-58'];
        opportunity opp=[Select Id from Opportunity where accountid=:account.Id];
        cscfga__Product_Configuration__c objPC =[SELECT Id ,LG_Billing_Account__c FROM cscfga__Product_Configuration__c where cscfga__Product_Basket__c=:basket.Id];
        
        csconta__Billing_Account__c billingAccount = [SELECT Id FROM csconta__Billing_Account__c WHERE csconta__Financial_Account_Number__c = 'BillingAccount'];
        List<csbb__Product_Configuration_Request__c> pcr =[Select Id, csbb__Total_MRC__c, csbb__Total_OC__c  from csbb__Product_Configuration_Request__c where csbb__Product_Configuration__c=:objPC.Id];
        PageReference pageRef = Page.LG_SeparateInvoices;
        pageRef.getParameters().put('basketId',basket.Id);
        pageRef.getParameters().put('aId',account.Id);
        pageRef.getParameters().put('oppId',opp.Id);
        Test.setCurrentPageReference(pageRef);
                
        Test.startTest();
        
            LG_SeparateInvoicesController controller = new LG_SeparateInvoicesController();
            pageRef = controller.createNewBillAccount();
            
        Test.stopTest();
        
       /* System.assertEquals('/'+csconta__Billing_Account__c.sObjectType.getDescribe().getKeyPrefix() + '/e?'
                                + 'retURL=%2Fapex%2FLG_SeparateInvoices%3FbasketId%3D' + basket.Id
                                + '&saveURL=%2Fapex%2FLG_SeparateInvoices%3FbasketId%3D' + basket.Id
                                +'&testId='+ account.Name +'&testId_lkid='+account.Id, pageRef.getUrl(),
                            'Url should be ' + csconta__Billing_Account__c.sObjectType.getDescribe().getKeyPrefix() + '/e?'
                                                + '&saveURL=/apex/LG_SeparateInvoices?basketId=' + basket.Id 
                                                    +'&testId='+account.Name + '&testId_lkid='+account.Id
                                                    + '&retURL=/apex/LG_SeparateInvoices?basketId=' + basket.Id);   */
    }
    
    private static testmethod void testSave()
    {
        Account account = [SELECT Id FROM Account WHERE Name = 'AccountSFDT-58'];
        
        cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'BAsket58'];
        Opportunity opp = [SELECT Id FROM Opportunity WHERE AccountID = :account.Id];
        cscfga__Product_Configuration__c objPC =[SELECT Id ,LG_Billing_Account__c FROM cscfga__Product_Configuration__c where cscfga__Product_Basket__c=:basket.Id];
        
        cscfga__Product_Category__c PCat=[select id from cscfga__Product_Category__c where Name='TestCategory'];
        csbb__Product_Configuration_Request__c prodReq=LG_GeneralTest.createProdConfigurationRequest(PCat.Id,basket.Id,99,50,false);
        prodReq.csbb__Product_Configuration__c =objPC.id;
        insert prodReq;
        
        csconta__Billing_Account__c billingAccount = [SELECT Id FROM csconta__Billing_Account__c WHERE csconta__Financial_Account_Number__c = 'BillingAccount'];
        List<csbb__Product_Configuration_Request__c> pcr =[Select Id, csbb__Total_MRC__c, csbb__Total_OC__c from csbb__Product_Configuration_Request__c where csbb__Product_Configuration__c=:objPC.Id];
        string basketid=basket.id;
        PageReference pageRef = Page.LG_SeparateInvoices;
        pageRef.getParameters().put('oppId',opp.Id);
        pageRef.getParameters().put('basketId',basket.Id);
        Test.setCurrentPageReference(pageRef);
        boolean isValid;
        Test.startTest();
        
        LG_SeparateInvoicesController controller = new LG_SeparateInvoicesController();
        List<SelectOption> options = controller.getItems();
        
        
        List<cscfga__Product_Configuration__c> updateBillingAccountToProductsList = new List<cscfga__Product_Configuration__c>();
        List<cscfga__Attribute__c> usertAttributeList = new List<cscfga__Attribute__c>();
        
        
        for (LG_SeparateInvoicesController.PCWrap liwrap : controller.pcwrappers)
        {
            cscfga__Product_Configuration__c pcObj=liwrap.lineItem;
            liwrap.selValBill = billingAccount.Id;
            isValid=  controller.CheckBillingAccount(billingAccount.id);
            updateBillingAccountToProductsList.add(pcObj);
            system.debug(pcObj);
            system.debug(basket.id);
            
            
        }
        
        
        controller.updateAttributeLineitesBillingAccount(updateBillingAccountToProductsList,basket.id);
        
        
        //System.assertEquals(3, options.size(), 'List should contain three options - Select, Direct Debit and BillingAccount');
        
        for(cscfga__Attribute__c attribute : [SELECT Id, Name,
                                                (SELECT Id, Name, cscfga__Value__c FROM cscfga__Attribute_Fields__r WHERE Name = 'BillingAccount')
                                                FROM cscfga__Attribute__c 
                                                WHERE cscfga__Is_Line_Item__c = true
                                                AND cscfga__Product_Configuration__c IN 
                                                (SELECT Id FROM cscfga__Product_Configuration__c WHERE cscfga__Product_Basket__c = :basket.Id)])
        {
            for (cscfga__Attribute_Field__c attField : attribute.cscfga__Attribute_Fields__r)
            {
                if (attField.Name.equals('BillingAccount'))
                {
                    System.assertEquals(billingAccount.Id, attField.cscfga__Value__c, 'BillingAccount Id:' 
                                        + billingAccount.Id + ' should be set on Line Items');
                }
            }
        }
    }
}