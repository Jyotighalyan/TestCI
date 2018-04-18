/**********************************************************
 * Date : 15-dec-17
 * Name : BDSfindDuplicateBusinessAnywhereTest
 * Author : BDS Team
 **********************************************************/
@isTest
public class BDSfindDuplicateBusinessAnywhereTest {

    @isTest
    static void testBusinessAnywhereOnBasketCase() {
        Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);
            Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
            LG_GeneralTest.createBillingAccount('BillingAccount', account.Id, true, true);        
        
        cscfga__Product_Basket__c basket = new cscfga__Product_Basket__c(Name='basket1', csbb__Account__c=account .id);
        Insert basket;
        
        cscfga__Product_Definition__c prodDefBusiness = LG_GeneralTest.createProductDefinition(Label.Business_Anywhere, true);
       
        
        cscfga__Product_Configuration__c prodDefBusinessConf = LG_GeneralTest.createProductConfiguration(
            'BusinessTEST', 0, basket, prodDefBusiness, false);
        prodDefBusinessConf.cscfga__Product_Family__c = Label.Business_Anywhere;
        Insert prodDefBusinessConf;
        
        cscfga__Product_Configuration__c prodDefBusinessConf2 = LG_GeneralTest.createProductConfiguration(
            'BusinessTEST2', 0, basket, prodDefBusiness, false);
        prodDefBusinessConf2.cscfga__Product_Family__c = Label.Business_Anywhere;
        Insert prodDefBusinessConf2;
        
        Map<String,String> searchFileds = new Map<String,String>();
        searchFileds.put('Product Type', 'Business Anywhere');
        searchFileds.put('Basket Id',basket.id);
        searchFileds.put('Configuration Id',prodDefBusinessConf.Id);
        
        BDSfindDuplicateBusinessAnywhere bdsBusiness = new BDSfindDuplicateBusinessAnywhere();
        
        List<Object> onBasket = new List<Object>(bdsBusiness.doDynamicLookupSearch(searchFileds, null));
        
        if(onBasket.size()>0){
            
           System.assertEquals(((cscfga__Product_Configuration__c)onBasket.get(0)).id, prodDefBusinessConf2.Id);
        }
        else{
            System.assert(false);
        }
        
    }
    
    @isTest
    static void testBusinessAnywhereFromAccountCase() {
        Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
        LG_GeneralTest.createBillingAccount('BillingAccount', account.Id, true, true);
        
        cscfga__Product_Basket__c basket1 = new cscfga__Product_Basket__c(Name='basket1', csbb__Account__c=account .id,
            cscfga__Opportunity__c =opp.Id);
        Insert basket1;        
        cscfga__Product_Definition__c prodDefBusiness = LG_GeneralTest.createProductDefinition(Label.Business_Anywhere, true);       
        
        cscfga__Product_Configuration__c prodDefBusinessConf = LG_GeneralTest.createProductConfiguration(
            'BusinessTEST1', 0, basket1, prodDefBusiness, false);
        prodDefBusinessConf.cscfga__Product_Family__c = Label.Business_Anywhere;
        Insert prodDefBusinessConf;
        
        
        csord__Subscription__c subscr = new csord__Subscription__c(Name='testSubscription', csord__Status__c='Active', 
        csord__Account__c=account.id,csord__Identification__c='Subscription_111');
        insert subscr;
            
        csord__Service__c ser = new csord__Service__c(Name='testService',csord__Subscription__c= subscr.id, 
        csordtelcoa__Product_Configuration__c=prodDefBusinessConf.id,csord__Identification__c='Service_111');
        insert ser;
        
        Map<String,String> searchFileds = new Map<String,String>();
        searchFileds.put('Product Type', 'Business Anywhere');
        searchFileds.put('Basket Id',basket1.id);
        searchFileds.put('Configuration Id',prodDefBusinessConf.Id);
        
        BDSfindDuplicateBusinessAnywhere bdsBusiness = new BDSfindDuplicateBusinessAnywhere();
        
        List<Object> onBasket = new List<Object>(bdsBusiness.doDynamicLookupSearch(searchFileds, null));
        if(onBasket.size()>0){            
           System.assertEquals(((cscfga__Product_Configuration__c)onBasket.get(0)).id, prodDefBusinessConf.Id);
        }
        else{
            System.assert(false);
        }       
        
    }
    
     @isTest
    static void testBusinessAnywhereNoRecordsCase() {
        Map<String,String> searchFileds = new Map<String,String>();
        searchFileds.put('Product Type', 'Business Anywhere');
        searchFileds.put('Basket Id','1234');
        searchFileds.put('Configuration Id','1234');
        
        BDSfindDuplicateBusinessAnywhere bdsBusiness = new BDSfindDuplicateBusinessAnywhere();
        List<Object> onBasket = new List<Object>(bdsBusiness.doDynamicLookupSearch(searchFileds, null));
    }
    
    @isTest
    static void getRequiredAttributesTest(){
     
        String returnString = new BDSfindDuplicateBusinessAnywhere().getRequiredAttributes();
        
       
    }
    
    
}