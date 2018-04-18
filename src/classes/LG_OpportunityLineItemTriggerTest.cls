/**
**Test Class for LG_OpportunityLineItemTrigger
 * @author Preetha N
 * @since  24/10/2016
*/
@isTest
public class LG_OpportunityLineItemTriggerTest {
    public static testmethod void lineitem(){
        Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'New Accoun 1', true);
        Product2 prod = new Product2(Name = 'Laptop X200', 
                                     Family = 'Hardware');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
        Pricebook2Id = pricebookId, Product2Id = prod.Id,
        UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        PricebookEntry pbe = new PricebookEntry();
        pbe.UseStandardPrice = false;
        pbe.Pricebook2Id=customPB.id;
        pbe.Product2Id=prod.id;
        pbe.IsActive=true;
        pbe.UnitPrice=99;
        insert pbe;
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, false);
        insert opp;
        OpportunityLineItem oppitem=new OpportunityLineItem();
        oppitem.OpportunityId=opp.id;
        oppitem.Quantity=123456;
        oppitem.TotalPrice=10;
        oppitem.PricebookEntryId=pbe.id;
        insert oppitem;
        
    }
    
}