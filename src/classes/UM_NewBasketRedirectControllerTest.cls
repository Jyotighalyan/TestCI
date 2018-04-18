@isTest
public class UM_NewBasketRedirectControllerTest {
    public static testmethod void redirectcontrol(){
        Account tmpAccount = LG_GeneralTest.CreateAccount('Stichting Statenkliniek', 'Customer', 'SoHo', 5, 'Qualified', '070-3220919', '55107192', 'Ziggo', 'Frankenslag', '357', 'A', '2582 HP', 'MONNICKENDAM', 'Netherlands');
	cscfga__Product_Basket__c tmpAccountBasket = LG_GeneralTest.createProductBasket('Test Basket Account', tmpAccount, null, null);
    tmpAccountBasket.csordtelcoa__Synchronised_with_Opportunity__c=true;
    update tmpAccountBasket;
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(tmpAccountBasket);
      UM_NewBasketRedirectController contr=new UM_NewBasketRedirectController(sc);
      
        test.stopTest();
        
        
    }
    public static testmethod void basktcreate(){
         Account tmpAccount = LG_GeneralTest.CreateAccount('Stichting Statenkliniek', 'Customer', 'SoHo', 5, 'Qualified', '070-3220919', '55107192', 'Ziggo', 'Frankenslag', '357', 'A', '2582 HP', 'MONNICKENDAM', 'Netherlands');
	cscfga__Product_Basket__c tmpAccountBasket = LG_GeneralTest.createProductBasket('Test Basket Account', tmpAccount, null, null,false);
   // tmpAccountBasket.csordtelcoa__Synchronised_with_Opportunity__c=true;
  //  update tmpAccountBasket;
        test.startTest();
          System.currentPageReference().getParameters().put('id', tmpAccountBasket.id);
     
         ApexPages.StandardController sc = new ApexPages.StandardController(tmpAccountBasket);
      UM_NewBasketRedirectController contr=new UM_NewBasketRedirectController(sc);
         contr.createNewBasketAndRedirect();
        test.stopTest();
        
        
    }

}