@isTest
public class CustomCalloutsTest {
    
    public static testmethod void custcall(){
    Account acc = LG_GeneralTest.CreateAccount('AccountSFDT', '12345678', 'Ziggo', true);
	Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, true);
    Account tmpAccount = LG_GeneralTest.CreateAccount('Stichting Statenkliniek', 'Customer', 'SoHo', 5, 'Qualified', '070-3220919', '55107192', 'Ziggo', 'Frankenslag', '357', 'A', '2582 HP', 'MONNICKENDAM', 'Netherlands');
	cscfga__Product_Basket__c tmpAccountBasket = LG_GeneralTest.createProductBasket('Test Basket Account', tmpAccount, null, null);
    tmpAccountBasket.cscfga__Opportunity__c=opp.id;
    update tmpAccountBasket;
    test.startTest();
    CustomCallouts.getCustomAddresses('poastal code');
         CustomCallouts.getCustomAddresses('');
    CustomCallouts.synchronizeBasket(tmpAccountBasket.Id);
    test.stopTest();
        }

}