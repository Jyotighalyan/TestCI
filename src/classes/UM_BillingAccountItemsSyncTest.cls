
@isTest
private class UM_BillingAccountItemsSyncTest
{

    @testSetup static void setupData(){
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        String language, userLanguage = UserInfo.getLanguage();
        for(PicklistEntry value: User.LanguageLocalekey.getDescribe().getPicklistValues()) {
            if(value.getValue() == userLanguage) {
                language = value.getLabel();
                    break;
            }
        }
        
        Account masterAcc = LG_GeneralTest.CreateAccount('TestAcc','123123','123123',true);

        csconta__Billing_Account__c billAcc = LG_GeneralTest.createBillingAccount('1234',masterAcc.id,true,true);
        billAcc.LG_ExternalId__c = '123';
        billAcc.csconta__Status__c = 'Active';
        update billAcc;

        noTriggers.Flag__c = false;
        upsert noTriggers;

    }

    static testMethod void  testExecute(){
       
       KenanServiceConnection__c kenanSettings = KenanServiceConnection__c.getInstance();
          system.debug(kenanSettings.Stored_Language_Code__c);
        kenanSettings.Stored_Language_Code__c='1';
        kenanSettings.Authentication_Token__c='Authorization';
      
        kenanSettings.Session_Timeout__c='120000';
        kenanSettings.Connection_URL__c='https://uat-aws-oag-pe.upc.biz';
        kenanSettings.REST_Application_Base__c='/kenan-salesforce-api';
        insert kenanSettings;
       
        system.debug(userinfo.getDefaultCurrency());
        system.debug(kenanSettings.Stored_Language_Code__c);
        csconta__Billing_Account__c billAcc = [select id from csconta__Billing_Account__c WHERE csconta__Status__c='Active' limit 1];
        system.debug(billAcc.id);
        //User adminUser = [SELECT id FROM USER WHERE profile.name='System Administrator' and isActive= true LIMIT 1];
        Id discountRecordTypeId = Schema.SObjectType.UM_BillingAccountItem__c.getRecordTypeInfosByName().get('Discount').getRecordTypeId();
        UM_BillingAccountItem__c billAccItem = new UM_BillingAccountItem__c();
        //system.RunAs(adminUser)
        //{
            
            billAccItem.UM_BillingAccount__c = billAcc.id;
            billAccItem.UM_BillingCode__c = '1905';
            billAccItem.UM_EndDate__c = Date.Today()+5;
            billAccItem.UM_StartDate__c = Date.Today();
            billAccItem.UM_Percentage__c = 10;
            billAccItem.UM_ItemType__c = 'Discount';
            billAccItem.recordTypeId = discountRecordTypeId ;
            insert billAccItem;
        //}
       system.debug(billAccItem);
          Test.startTest();
        list<sobject> itemsList=NEW list<sobject>();
        itemsList.add(billAccItem);
        
        //KenanAccountItem
        KenanAccountItem ksi = new KenanAccountItem();
        ksi.serviceExternalId = 'serviceExternalId';
        ksi.serviceExternalIdType = 2;
        ksi.itemId = 1302;
        ksi.itemType = 1;

        KenanAccountItemCalloutMock accountItemMock = new KenanAccountItemCalloutMock();
        accountItemMock.numberOfRecords = 3;
        Test.setMock(HttpCalloutMock.class, accountItemMock);

        
    /*  KenanConnectorService service = new KenanConnectorService();
        List<KenanAccountItem> returnAccountItems = service.accountItemCreate(ksi); 
        Test.stopTest();
    
        System.assertNotEquals(null, returnAccountItems);
        System.assert(!returnAccountItems.isEmpty());
        System.assertEquals(accountItemMock.numberOfRecords, returnAccountItems.size());

        for (KenanAccountItem accountItem: returnAccountItems) {
            System.assertEquals('Test Annotation', accountItem.annotation);
            System.assertEquals('Test Annotation 2', accountItem.annotation2);
            System.assertEquals('EUR', accountItem.currencyCode);
            System.assertEquals(0.0, accountItem.rate);
            System.assertEquals('1', accountItem.salesforceId);
        }*/
    
        
        
        
        UM_BillingAccountItemsSync S1=NEW UM_BillingAccountItemsSync();
        S1.execute(itemsList);
        Test.stopTest();
        //system.assertEquals(, );

       // System.assertNotEquals(null,[select id,UM_External_Id__c from UM_BillingAccountItem__c where id = :billAccItem.id].UM_External_Id__c);
    }
}