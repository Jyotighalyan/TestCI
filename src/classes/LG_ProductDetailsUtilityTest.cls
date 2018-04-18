@isTest
public class LG_ProductDetailsUtilityTest {
    public static testmethod void proddetail(){
         Account account = LG_GeneralTest.CreateAccount('AccountSFDT', '12345678', 'Ziggo', true);
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
        
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('PC Test Basket', account, null, opp, false);
        
        basket.LG_CreatedFrom__c = 'Tablet';
        insert basket;
        
        cscfga__Product_Category__c productCategory = LG_GeneralTest.createProductCategory('PC Test Category', true);
        cscfga__Product_Definition__c productDefinition = LG_GeneralTest.createProductDefinition('PC Test Product', false);
     
        productDefinition.cscfga__Product_Category__c = productCategory.Id;
        
        insert productDefinition;
        cscfga__Product_Configuration__c pc = LG_GeneralTest.createProductConfiguration('Test', 12, basket, productDefinition, true);
		system.debug(pc.id);
        Set<string> setProductBasketId =new Set<string>();
        setProductBasketId.add(basket.id);
         List<cscfga__Product_Basket__c> lstNewPB=new List<cscfga__Product_Basket__c>();
        lstNewPB.add(basket);
        cscfga__Attribute_Definition__c AttributeDefinition=lg_generaltest.createAttributeDefinition('attrdef',productDefinition,'User Input','String','avc','vrr','Order Detail',true);
        cscfga__Attribute__c attr=lg_generaltest.createAttribute('Name', AttributeDefinition,true, 1261992,pc, true, 'Value', false);
     attr.cscfga__is_active__c=true;
       //insert  attr;
        system.debug('id'+attr.id+'attr.cscfga__is_active__c'+attr.cscfga__is_active__c+'cscfga__Line_Item_Sequence__c'+attr.cscfga__Line_Item_Sequence__c+'cscfga__Product_Configuration__c'+attr.cscfga__Product_Configuration__c+'cscfga__Product_Basket__c'+attr.cscfga__Product_Configuration__r.cscfga__Product_Basket__c+'cscfga__Product_Configuration__r.cscfga__Product_Family__c'+attr.cscfga__Product_Configuration__r.cscfga__Product_Family__c);
       cscfga__Attribute__c attr1=new cscfga__Attribute__c();
       attr1.cscfga__Product_Configuration__c=pc.id; 
       // insert  attr1;
        test.startTest();
        
        List<cscfga__Attribute__c> lstAttribute = [SELECT Id, cscfga__is_active__c, cscfga__Line_Item_Sequence__c, 
                                        			cscfga__Product_Configuration__c, cscfga__Product_Configuration__r.cscfga__Product_Basket__c, 
                                        			cscfga__Product_Configuration__r.cscfga__Product_Family__c, cscfga__Value__c , cscfga__Attribute_Definition__r.LG_OPTKey__c, 
                                        			cscfga__Attribute_Definition__r.LG_ProductDetailType__c
                                        			FROM cscfga__Attribute__c
                                        			WHERE cscfga__is_active__c=true AND cscfga__Attribute_Definition__r.LG_OPTKey__c!=null ];
                                        			
        system.debug(lstAttribute);
        LG_ProductDetailsUtility.CreateProductDetails(setProductBasketId);
        LG_ProductDetailsUtility.DeleteProductDetails(setProductBasketId);
        LG_ProductDetailsUtility.DeleteProductDetails(setProductBasketId, lstNewPB);
        test.stopTest();
    }
    

}