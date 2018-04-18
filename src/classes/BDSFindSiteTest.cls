/**********************************************************************
* Date         :   23-Feb-18
* Name         :   BDSFindSiteTest
* Author       :   BDS Team
* Description  :   Test class for BDSFindSite
**********************************************************************/

@isTest
public class BDSFindSiteTest {

    @testSetup
    public static void testData(){
        
       List<cscfga__Product_Basket__c> basketList = new List<cscfga__Product_Basket__c>();
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        //Account 
        Account acc = LG_GeneralTest.CreateAccount('Account', '1234567', 'vpnTest', true);
        
        //------------------------ onbasket data ------------------------//
        //Opportuniy of VPN
        Opportunity Opp = LG_GeneralTest.CreateOpportunity(acc , true);
        
        //basket
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('basket', acc, null , opp, false);
        basketList.add(basket);
        
        //------------------------ Onaccount data ------------------------// 
        //Opportunity for vpn1
        Opportunity opp1 = new Opportunity(Name = 'Opp1', AccountId = acc.Id, StageName = 'Awareness of interest', CloseDate = Date.today()+5);
        insert opp1;
   
        //basket of opporunity opp1
        cscfga__Product_Basket__c basket1 = LG_GeneralTest.createProductBasket('basket1', acc, null , opp1, false);
        basketList.add(basket1);
        
        //insert baskets
        insert basketList;
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
        
        
        //------------------------ onbasket data ------------------------//
        //Product Definitions
        cscfga__Product_Definition__c prodDefBDS = LG_GeneralTest.createProductDefinition('BDS Standort', true);
        
        //Product Configuration for BDS
        cscfga__Product_Configuration__c prodConfBDS = LG_GeneralTest.createProductConfiguration('BDS Standort : test', 24, basket, prodDefBDS, false);
        prodConfBDS.LG_Persistent_Id__c = '123654789';
        insert prodConfBDS;
        
        //attribute definition for BDS
        cscfga__Attribute_Definition__c attrdefPersistentId = LG_GeneralTest.createAttributeDefinition('Persistent Id', prodDefBDS, 'User Input', 'String', '', '', '', true); 
        
        //attribute value of BDS PersistentId
        cscfga__Attribute__c attrVal = LG_GeneralTest.createAttribute('Persistent Id',  attrdefPersistentId, false, 10,prodConfBDS, false, '123654789', true);

        
        //order request
        csord__Order_Request__c oreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert oreq;
        
        //Subscription record
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestSub', csord__Order_Request__c = oreq.Id,csord__Account__c= acc.id,csord__Status__c = 'Active' );
        insert sub;

        //Service record
        csord__Service__c ser = new csord__Service__c(Name='testService', csord__Subscription__c= sub.id, csordtelcoa__Product_Configuration__c = prodConfBDS.id,csord__Identification__c='servBDS');
        insert ser;
        
    }
    
    public static testmethod void returnNull(){

        Map<String, String> searchFields = new Map<String, String>();
        string PersistentId = '';
        string productDefinitionId = '';
        
        //basket
        cscfga__Product_Basket__c basket = [select id,name from cscfga__Product_Basket__c where Name = 'basket'];
        
        //create input paramaters 
        searchFields.put('Site Configuration Shadow',PersistentId);
        searchFields.put('Basket Id',basket.Id);  
        
        //start test
        Test.startTest();
        
        BDSFindSite find = new BDSFindSite();

        List<Object> siteResult = find.doDynamicLookupSearch(searchFields, productDefinitionId);
        
        //stop test
        Test.stopTest();
        
        system.assertEquals(null, siteResult, 'returns null value');
    }
    
    //return on Basket
    public static testmethod void returnOnBasket(){
        
        Map<String, String> searchFields = new Map<String, String>();
        string PersistentId = '123654789';
        string productDefinitionId = '';

        //basket
        cscfga__Product_Basket__c basket = [select id,name from cscfga__Product_Basket__c where Name = 'basket'];
        
        //Product configuration : Product config to be found in basket
        List<cscfga__Product_Configuration__c> ProdConList = [select Id,Name from cscfga__Product_Configuration__c where cscfga__Product_Basket__c =: basket.id];
        
        //create input paramaters 
        searchFields.put('Site Configuration Shadow',PersistentId);
        searchFields.put('Basket Id',basket.Id); 
        
        //start test
        Test.startTest();
        
        BDSFindSite find = new BDSFindSite();
        
        string result = find.getRequiredAttributes();
        
        List<Object> siteResult = find.doDynamicLookupSearch(searchFields, productDefinitionId);
        
        //stop test
        Test.stopTest();
        
        system.assertEquals(result,'["Site Configuration Shadow","Basket Id"]');
        system.assertEquals(ProdConList,(List<cscfga__Product_Configuration__c>)siteResult, 'product configs found on basket');
    }
    
    //return on Account
    public static testmethod void returnOnAccount(){
        
        Map<String, String> searchFields = new Map<String, String>();
        string PersistentId = '123654789';
        string productDefinitionId = '';

        //basket
        cscfga__Product_Basket__c basket = [select id,name,cscfga__Opportunity__r.AccountId from cscfga__Product_Basket__c where Name = 'basket1'];
        
        //account 
        Id accId = basket.cscfga__Opportunity__r.AccountId;
        
        //Product configuration : prodConfig to be found on account
        List<cscfga__Product_Configuration__c> ProdConList = [select Id,Name from cscfga__Product_Configuration__c where cscfga__Product_Basket__r.cscfga__Opportunity__r.AccountId =: accId];
        
        //create input paramaters 
        searchFields.put('Site Configuration Shadow',PersistentId);
        searchFields.put('Basket Id',basket.Id);  
        
        //start test
        Test.startTest();
        
        BDSFindSite find = new BDSFindSite();
        
        List<Object> siteResult = find.doDynamicLookupSearch(searchFields, productDefinitionId);
       
        cscfga__Product_Configuration__c prodCon = (cscfga__Product_Configuration__c) siteResult[0];
        
        //stop test
        Test.stopTest();
        
        system.assertEquals(ProdConList[0].id,prodCon.Id, 'product config found on account ');
    }
}