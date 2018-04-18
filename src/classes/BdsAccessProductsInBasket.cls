/**************************************************************************************************************************
* Name         : BdsAccessProductsInBasket
* Created      : 14/12/2017
* Description  : Performs lookups search for based on the Basketid, premise id and access products selected
* Author       : BDS Dev Team
* Called From  : BdsAccessProductsInBasketConfig Lookup Configs
*************************************************************************************************************************/
global class BdsAccessProductsInBasket extends cscfga.ALookupSearch {

    
    /******************************************************************************************************
    * Input parameter  :   --     
    * Return Type      :   String
    *****************************************************************************************************/
    public override String getRequiredAttributes(){
        return '["Valid Access Products","Basket Id","Premise Id"]';
    }
    
    
    /******************************************************************************************************
    * Input parameter  :   Map<String, String> searchFields, String productDefinitionId     
    * Return Type      :   List<Object>
    * Description      :   peforms search lookup based on the input criteria 
    *****************************************************************************************************/
    public override Object[] doDynamicLookupSearch(Map<String, String> searchFields, String productDefinitionId) {
        
        
        String basketId = searchFields.get('Basket Id');
        String accessProducts = searchFields.get('Valid Access Products');
        String premiseId = searchFields.get('Premise Id');
        
        String connectProduct = 'Company Cloud Connect';
        String fiberProduct = 'Company Fiber';
        String serviceProduct = 'Company Cloud Fiber';
        
        List<String> acessProductList = accessProducts.split(','); 
        
        /*fetch product configuration based on the basket id , premise id and access product*/
        List<cscfga__Product_Configuration__c> validPcInBasket = [select Id,Name from cscfga__Product_Configuration__c 
                                                                  where cscfga__Configuration_Status__c = 'Valid' AND cscfga__Product_Basket__c =:basketId
                                                                  AND LG_Address__c =:premiseId AND Name In:acessProductList Limit 1];
        
        if (validPcInBasket.size() == 0) {
            return null;
        }
        
        /*if access product is 'Company Cloud Connect' then return fetched product configuration*/
        if (validPcInBasket[0].Name == connectProduct) {
            return validPcInBasket;
        }
        
        /* if access product are fiber products and their isCCFPresent attribute value is 'Yes' then return fetched product configuration*/
        if (validPcInBasket[0].Name == fiberProduct) {
            List<cscfga__Attribute__c> services = [select cscfga__Value__c 
                                                  from cscfga__Attribute__c
                                                  where Name = 'isCCFPresent' AND cscfga__Product_Configuration__c = :validPcInBasket[0].Id];
            if (services.size()>0 && services[0].cscfga__Value__c == 'Yes') {
                return validPcInBasket;
            }
            
        }        
        return null;
        
    }//end of method
    
}