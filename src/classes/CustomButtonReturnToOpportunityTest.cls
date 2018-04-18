@isTest
public class CustomButtonReturnToOpportunityTest {
    public static testmethod void buttnopp(){
    Account tmpAccount = LG_GeneralTest.CreateAccount('Stichting Statenkliniek', 'Customer', 'SoHo', 5, 'Qualified', '070-3220919', '55107192', 'Ziggo', 'Frankenslag', '357', 'A', '2582 HP', 'MONNICKENDAM', 'Netherlands');
	cscfga__Product_Basket__c tmpAccountBasket = LG_GeneralTest.createProductBasket('Test Basket Account', tmpAccount, null, null);
    test.startTest();
        
    CustomButtonReturnToOpportunity oppr=new CustomButtonReturnToOpportunity();
  	oppr.performAction(tmpAccountBasket.id);
  	
     test.stopTest();
        
    }

}