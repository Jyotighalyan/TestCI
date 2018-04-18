@isTEST
public class LG_SyncBasketFromPageLayoutTest {
    
    public static testmethod void basktfrmpglayout(){
    Account tmpAccount = LG_GeneralTest.CreateAccount('Stichting Statenkliniek', 'Customer', 'SoHo', 5, 'Qualified', '070-3220919', '55107192', 'Ziggo', 'Frankenslag', '357', 'A', '2582 HP', 'MONNICKENDAM', 'Netherlands');
	cscfga__Product_Basket__c tmpAccountBasket = LG_GeneralTest.createProductBasket('Test Basket Account', tmpAccount, null, null);
    tmpAccountBasket.csordtelcoa__Synchronised_with_Opportunity__c=true;
    update tmpAccountBasket;
    test.startTest();
    LG_SyncBasketFromPageLayout.SynchronizeBasket(tmpAccountBasket.id);    
        
    test.stopTest();
        
        
    }

}