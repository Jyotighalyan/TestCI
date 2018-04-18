/*********************************************************************************************************
* Date         :   31-Jan-18
* Name         :   BdsAccessProductsInBasketTest
* Author       :   BDS Team
* Description  :   Test class for BdsPrimaryAccessProductsInBasket & BdsSecondaryAccessProductsInBasket
*********************************************************************************************************/
@isTest
public class BdsAccessProductsInBasketTest {
    
    @testsetup()
    public static void testData(){
        
        List<csord__Service__c> servList = new List<csord__Service__c>();
        
        //account
        Account acc = LG_GeneralTest.CreateAccount('TestAcc', '1234567', 'testing', true); 
        
        //opportunity
        Opportunity opp = new Opportunity(Name = 'TestOpp', AccountId = acc.Id, StageName = 'Awareness of interest', CloseDate = Date.today()+5);
        insert opp ;
        
        //product basket
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('TestBasket', acc, null, opp, true);
        
        
        //product defination : Company Fiber
        cscfga__Product_Definition__c prodDefCF = LG_GeneralTest.createProductDefinition('Company Fiber', true);
        
        
        //product configuration : Company Fiber
        cscfga__Product_Configuration__c CFProdCon = LG_GeneralTest.createProductConfiguration('Company Fiber', 0, basket, prodDefCF, false);
    CFProdCon.cscfga__Product_Family__c = Label.Company_Fiber;
    Insert CFProdCon;
        
        
        //attribute definition: CF
        cscfga__Attribute_Definition__c attrdefinitionCF = LG_GeneralTest.createAttributeDefinition('Premise Id', prodDefCF, 'User Input', 'String', '', '', '', true); 
        
        cscfga__Attribute_Definition__c attrdefinitionCF1 = LG_GeneralTest.createAttributeDefinition('service', prodDefCF, 'Select List', 'String', '', '', '', true); 
        
        //address
        cscrm__Address__c addr= LG_GeneralTest.crateAddress('Test Addr','ABC', 'Munich','45', '78','we','Germany', acc, true);
        
        
        //attribute : CF
        cscfga__Attribute__c attrCF= LG_GeneralTest.createAttribute('Premise Id',  attrdefinitionCF, false, 1,CFProdCon, false, string.valueof(addr.Id), true);
        cscfga__Attribute__c attrCF1= LG_GeneralTest.createAttribute('service',  attrdefinitionCF, false, 1,CFProdCon, false, string.valueof(addr.Id), false);
        attrCF1.cscfga__Value__c = Label.Company_Cloud_Fiber;
        
        insert attrCF1;
        
        cscfga__Attribute_Definition__c attrdefCF = LG_GeneralTest.createAttributeDefinition('isCCFPresent', prodDefCF, 'Checkbox', 'Boolean', '', '', '',true); 
        
        //attribute value
        cscfga__Attribute__c attrCF2= LG_GeneralTest.createAttribute('isCCFPresent',  attrdefCF, false, 10,CFProdCon, false, string.valueof(addr.Id), false);
        attrCF2.cscfga__Value__c = 'No';
        insert attrCF2;
        
        //list of product congif to update with lg_address
        List<cscfga__Product_Configuration__c> configList = new List<cscfga__Product_Configuration__c>();
        
        //updating CF
        CFProdCon.LG_Address__c = addr.Id;
        configList.add(CFProdCon);
        
        update configList;
        
        csord__Order_Request__c oreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert oreq;
        
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = oreq.Id,csord__Account__c= basket.csbb__Account__c,csord__Status__c = 'Active' );
        insert sub;
        
        csord__Service__c ser = new csord__Service__c(Name='testService', csord__Subscription__c= sub.id, csordtelcoa__Product_Configuration__c = CFProdCon.id,csord__Identification__c='ServiceCF');
        servList.add(ser);
        
        insert servList;
    }
    
    //BdsPrimaryAccessProductsInBasket
    public static testmethod void testCFPrimary(){
        cscfga__Product_Configuration__c CFProdCon = [select id,name,cscfga__Product_Basket__c,LG_Address__c,cscfga__Product_Definition__c, (select id,name,cscfga__Value__c from cscfga__Attributes__r ) from cscfga__Product_Configuration__c where cscfga__Product_Definition__r.name='Company Fiber'];
        string premiseId = '';
        
        for(cscfga__Attribute__c attr : CFProdCon.cscfga__Attributes__r){
            if(attr.name == 'Premise Id'){
                premiseId =  attr.cscfga__Value__c; 
            }
        }
        
        Map<String, String> searchFields = new Map<String, String>();
        searchFields.put('Primary Access Products','Company Fiber,Company Cloud Fiber');
        searchFields.put('Basket Id',CFProdCon.cscfga__Product_Basket__c);  
        searchFields.put('Premise Id',premiseId);
        
        test.startTest();
        
        BdsPrimaryAccessProductsInBasket call = new BdsPrimaryAccessProductsInBasket();
        
        string result = call.getRequiredAttributes();
        
        List<Id> ids = new List<Id>();
        List<Object> objList = call.doLookupSearch(searchFields, CFProdCon.cscfga__Product_Definition__c,ids, 1,1);
        
        test.stopTest();
        
        system.assertEquals(objList.size(), 1);
        system.assertEquals(result, '["Primary Access Products","Basket Id","Premise Id"]');
    }
    
    //BdsSecondaryAccessProductsInBasket
    public static testmethod void testCFSecondary(){
        cscfga__Product_Configuration__c CFProdCon = [select id,name,cscfga__Product_Basket__c,LG_Address__c,cscfga__Product_Definition__c, (select id,name,cscfga__Value__c from cscfga__Attributes__r ) from cscfga__Product_Configuration__c where cscfga__Product_Definition__r.name='Company Fiber'];
        string premiseId = '';
        
        for(cscfga__Attribute__c attr : CFProdCon.cscfga__Attributes__r){
            if(attr.name == 'Premise Id'){
                premiseId =  attr.cscfga__Value__c; 
            }
        }
        
        Map<String, String> searchFields = new Map<String, String>();
        searchFields.put('Secondary Access Products','Company Fiber,Company Cloud Fiber');
        searchFields.put('Basket Id',CFProdCon.cscfga__Product_Basket__c);  
        searchFields.put('Premise Id',premiseId);
        
        test.startTest();
        
        BdsSecondaryAccessProductsInBasket call = new BdsSecondaryAccessProductsInBasket();
        
        string result = call.getRequiredAttributes();
        
        List<Id> ids = new List<Id>();
        List<Object> objList = call.doLookupSearch(searchFields, CFProdCon.cscfga__Product_Definition__c,ids, 1,1);
        
        test.stopTest();
        
        system.assertEquals(objList.size(), 0);
        system.assertEquals(result, '["Secondary Access Products","Basket Id","Premise Id"]');
    }
    
}