/**************************************************************************************************************************
* Name         : BdsSecondaryAccessProductsInBasket 
* Created      : 14/12/2017
* Description  : Performs lookups search for based on the Basketid, premise id and access products selected
* Author       : BDS Dev Team
* Called From  : BdsAccessProductsInBasketConfig Lookup Configs
*************************************************************************************************************************/
global class BdsSecondaryAccessProductsInBasket extends cscfga.ALookupSearch {

    
    /******************************************************************************************************
    * Input parameter  :   --     
    * Return Type      :   String
    *****************************************************************************************************/
    public override String getRequiredAttributes(){
        return '["Secondary Access Products","Basket Id","Premise Id"]';
    }
    
    
    /******************************************************************************************************
    * Input parameter  :   Map<String, String> searchFields, String productDefinitionId     
    * Return Type      :   List<Object>
    * Description      :   peforms search lookup based on the input criteria 
    *****************************************************************************************************/
    public override object[] doLookupSearch(Map<String, String> searchFields, String productDefinitionId, Id[] excludeIds, Integer pageOffset, Integer pageLimit) {
        
        
        String basketId = searchFields.get('Basket Id');
        String accessProducts = searchFields.get('Secondary Access Products');
        String premiseId = searchFields.get('Premise Id');
        String fiberProduct = 'Company Fiber';
        String accountId = '';
        
        List<String> acessProductList = accessProducts.split(','); 
        List<id> validPCInAccount = new List<id>();
        List<id> CCFProductPC = new List<id>();
        List<cscfga__Product_Configuration__c> validPCInBasket = new List<cscfga__Product_Configuration__c>();
        
        List<cscfga__Product_Basket__c> accountIds = [SELECT cscfga__Opportunity__r.AccountId FROM cscfga__Product_Basket__c where Id =:basketId];
        //Get account Id for current basket      
        if(!accountIds.isEmpty()){        
             accountId = accountIds[0].cscfga__Opportunity__r.AccountId;
        }
        
        List<csord__Service__c> validProductsInAccount = [select id, csordtelcoa__Product_Configuration__c, csordtelcoa__Product_Configuration__r.name from csord__Service__c where 
        LG_Address__c =:premiseId and csord__Subscription__r.csord__Account__c=:accountId AND csord__Subscription__r.csord__Status__c = 'Active' and 
        csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c in:acessProductList and 
        id not in (select csordtelcoa__Replaced_Service__c from cscfga__Product_Configuration__c where cscfga__Product_Basket__c =:basketId)];
        
        for(csord__Service__c pcAccount: validProductsInAccount){
        
            validPCInAccount.add(pcAccount.csordtelcoa__Product_Configuration__c);
        }
        
        /*fetch product configuration based on the basket id , premise id and access product*/
        Map<id, cscfga__Product_Configuration__c> pcInBasket = new Map<id,cscfga__Product_Configuration__c>([select Id,Name,LG_Address__c,LG_UploadSpeed__c,LG_AccessNetwork__c,LG_AccessType__c from cscfga__Product_Configuration__c 
                                                                  where (cscfga__Configuration_Status__c = 'Valid' AND cscfga__Product_Basket__c =:basketId
                                                                  AND LG_Address__c =:premiseId AND Name In:acessProductList) OR (id in:validPCInAccount) ]);
        
        if (pcInBasket.size() == 0) {
            return new List<cscfga__Product_Configuration__c>();
        }
       
        for(cscfga__Product_Configuration__c pc: pcInBasket.values()){
        
            if (pc.Name == fiberProduct) {
            
                    CCFProductPC.add(pc.id);
            }
        }
                    
        for( cscfga__Attribute__c CCFServices : [select cscfga__Value__c,cscfga__Product_Configuration__c 
                                                  from cscfga__Attribute__c
                                                  where Name = 'isCCFPresent' AND cscfga__Product_Configuration__c in :CCFProductPC])
        {
                if (CCFServices.cscfga__Value__c == 'No') {
                        pcInBasket.remove(CCFServices.cscfga__Product_Configuration__c);
                }
        }

        return pcInBasket.values();
        
    }       
        
}