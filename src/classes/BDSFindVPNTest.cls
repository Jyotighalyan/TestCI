/**********************************************************************
* Date         :   27-Feb-2018
* Name         :   BDSFindVPNTest
* Author       :   BDS Team
* Description  :   Test class for BDSFindVPN
**********************************************************************/

@isTest
public class BDSFindVPNTest {
    
    @testSetup public static void testData(){
        
        List<cscfga__Product_Basket__c> basketList = new List<cscfga__Product_Basket__c>();
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        //Account 
        Account VPNAcc = LG_GeneralTest.CreateAccount('VPNAccount', '1234567', 'vpnTest', true);
        
        //------------------------ onbasket data ------------------------//
        //Opportuniy of VPN
        Opportunity VPNOpp = LG_GeneralTest.CreateOpportunity(VPNAcc , true);
        
                
        //Basket
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('basketvpn', VPNAcc, null , VPNOpp, false);
        basketList.add(basket);
        
        
        //------------------------ On account data ------------------------//  
        //Opportunity for vpn1
        Opportunity opp1 = new Opportunity(Name = 'vpnOpp1', AccountId = VPNAcc.Id, StageName = 'Awareness of interest', CloseDate = Date.today()+5);
        insert opp1;
        
             
        //basket of opporunity opp1
        cscfga__Product_Basket__c basket1 = LG_GeneralTest.createProductBasket('basketvpn1', VPNAcc, null , opp1, false);
        basketList.add(basket1);

        
        insert basketList;
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
        
        //------------------------ onbasket data ------------------------//
        
        //Product definition of VPN
        cscfga__Product_Definition__c prodDefVPN = LG_GeneralTest.createProductDefinition('VPN Services', true);
        
        //Product Configuration for VPN
        cscfga__Product_Configuration__c prodConfVPN = LG_GeneralTest.createProductConfiguration('VPN Services : test', 24, basket, prodDefVPN, false);
                
        prodConfVPN.LG_Persistent_Id__c = '1234567889';
        insert prodConfVPN;
        
        //attribute definition for vpn 
        cscfga__Attribute_Definition__c persistentIdVPN = LG_GeneralTest.createAttributeDefinition('Persistent Id', prodDefVPN, 'User Input', 'String', '', '', '', true); 
        
        //attribute value of VPN persistent id
        cscfga__Attribute__c attrVal = LG_GeneralTest.createAttribute('Persistent Id',  persistentIdVPN, false, 10,prodConfVPN, false, '1234567889', true);
        
                
        csord__Order_Request__c oreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert oreq;
        
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = oreq.Id,csord__Account__c= VPNAcc.id ,csord__Status__c = 'Active' );
        insert sub;
        
        csord__Service__c ser = new csord__Service__c(Name='testService', csord__Subscription__c= sub.id, csordtelcoa__Product_Configuration__c = prodConfVPN.id,csord__Identification__c='ServiceBA');
        insert ser;

    }
    
    public static testmethod void testEmpty(){
        
        Map<String, String> searchFields = new Map<String, String>();
        string PersistentId = '';
        string productDefinitionId = '';
        //basket
        cscfga__Product_Basket__c basket = [select id,name from cscfga__Product_Basket__c where Name = 'basketvpn'];
        
        //create input paramaters 
        searchFields.put('VPN Configuration Shadow',PersistentId);
        searchFields.put('Basket Id',basket.Id);  
        
        //start test
        Test.startTest();
        
        BDSFindVPN find = new BDSFindVPN();
        
        string result = find.getRequiredAttributes();

        List<Object> siteResult = find.doDynamicLookupSearch(searchFields, productDefinitionId);
        
        //stop test
        Test.stopTest();
        
        system.assertEquals(null, siteResult, 'returns null value');
        
    }
    
    public static testmethod void returnOnBasket(){
        
        Map<String, String> searchFields = new Map<String, String>();
        string PersistentId = '1234567889';
        string productDefinitionId = '';
        
        //basket
        cscfga__Product_Basket__c basket = [select id,name from cscfga__Product_Basket__c where Name = 'basketvpn'];
        
        //Product configuration : Product config to be found in basket 
        List<cscfga__Product_Configuration__c> ProdConList = [select Id,Name from cscfga__Product_Configuration__c where cscfga__Product_Basket__c =: basket.id];
        
        //create input paramaters 
        searchFields.put('VPN Configuration Shadow',PersistentId);
        searchFields.put('Basket Id',basket.Id);  
        
        //start test
        Test.startTest();
        
        BDSFindVPN find = new BDSFindVPN();
        
        string result = find.getRequiredAttributes();
        
        system.debug('Object msg::::');
        List<Object> siteResult = find.doDynamicLookupSearch(searchFields, productDefinitionId);

        
        system.assertEquals(result,'["VPN Configuration Shadow","Basket Id"]');
        system.assertEquals(ProdConList,(List<cscfga__Product_Configuration__c>)siteResult, 'List of product config on basket');

        //stop test
        Test.stopTest();
    }
    
    //return on Account
    public static testmethod void returnOnAccount(){
        
        Map<String, String> searchFields = new Map<String, String>();
        string productDefinitionId = '';
        string PersistentId = '1234567889';
        
        //basket
        cscfga__Product_Basket__c basket = [select id,name,cscfga__Opportunity__r.AccountId from cscfga__Product_Basket__c where Name = 'basketvpn1'];
        
        //account 
        Id accId = basket.cscfga__Opportunity__r.AccountId;
        
        //Product configuration : prodConfig to be found on account
        List<cscfga__Product_Configuration__c> ProdConList = [select Id,Name from cscfga__Product_Configuration__c where cscfga__Product_Basket__r.cscfga__Opportunity__r.AccountId =: accId];
        
        //create input paramaters 
        searchFields.put('VPN Configuration Shadow',PersistentId);
        searchFields.put('Basket Id',basket.Id);  
        
        
        //start test
        Test.startTest();
        
        BDSFindVPN find = new BDSFindVPN();

        List<Object> siteResult = find.doDynamicLookupSearch(searchFields, productDefinitionId);
        
        cscfga__Product_Configuration__c prodCon = (cscfga__Product_Configuration__c) siteResult[0];
        
        //stop test
        Test.stopTest();
        
        system.assertEquals(ProdConList[0].id,prodCon.Id, 'product config found on account ');
        
    }
}