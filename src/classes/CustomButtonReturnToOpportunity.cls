global with sharing class CustomButtonReturnToOpportunity extends csbb.CustomButtonExt
{
    // Perform action implementation
    public String performAction(String basketId)
    {
        String newUrl = CustomButtonReturnToOpportunity.openOpportunity(basketId);
        return '{"status":"ok","redirectURL":"' + newUrl + '"}';
    }
    
    // Set url for redirect after action
    public static String openOpportunity(String basketId)
    {
        // Retrieve the basket
        cscfga__Product_Basket__c basket = [select id, name, cscfga__opportunity__c from cscfga__product_basket__c where id = :basketId];
        // Set page reference to the opportunity
        String baseUrl = '';
        if (UserInfo.getUserType() == 'Standard')
        {
            baseUrl = '/';
        }
        else if (UserInfo.getUserType() == 'PowerPartner')
        {
            baseUrl = '/partners/';
        }
       PageReference redirectPage = new PageReference(baseUrl + basket.cscfga__Opportunity__c);     
       return redirectPage.getUrl();
    }
}