/**
* Used for the Product Basket new custom button 'Billing Account'
* Button opens the LG_SeparateInvoices VF page.
* 
* @author Tomislav Blazek
* @ticket SFDT-58
* @since  13/01/2016
*/
global with sharing class CustomButtonSetBillingAccountOnLineItems extends csbb.CustomButtonExt {
    
	public static final String errorMsg = '{"status":"error","title":"Error",'
                        + '"text":"Basket does not have a Customer Account field populated. '
                        + 'It is not possible to assign the Billing Accounts."}';
    
    public String performAction (String basketId) {
        
        String action = '';
        
        if (basketHasAccountFieldPopulated(basketId))
        {
            String newUrl = LG_Util.getSalesforceBaseUrl() 
                            + '/apex/LG_SeparateInvoices?basketId=' + basketId;
            
            action = '{"status":"ok","redirectURL":"' + newUrl + '"}';
        }
        else
        {
            action = errorMsg;
        }
        
        return action;
    }
    
    private boolean basketHasAccountFieldPopulated(String basketId)
    {
        cscfga__Product_Basket__c basket = [SELECT Id, csbb__Account__c 
                                            FROM cscfga__Product_Basket__c WHERE Id = :basketId];
        
        return basket.csbb__Account__c != null;
    }
}