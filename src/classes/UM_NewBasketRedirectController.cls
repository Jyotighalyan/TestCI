public class UM_NewBasketRedirectController {

    public cscfga__Product_Basket__c basket {get; set;}
    
    public UM_NewBasketRedirectController (ApexPages.StandardController c) {
        this.basket = (cscfga__Product_Basket__c)c.getRecord();
    }
    
    public PageReference createNewBasketAndRedirect() {
        this.basket.name = 'New Basket ' + DateTime.now();
        insert basket;
        
        PageReference p = Page.csbb__BasketBuilderApp;
        p.getParameters().put('Id', basket.id);
        return p;
    }
}