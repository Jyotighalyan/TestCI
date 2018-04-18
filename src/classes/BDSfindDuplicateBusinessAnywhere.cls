/**************************************************************************************************************************
* Name         : BDSfindDuplicateBusinessAnywhere
* Created      : 16/11/2017
* Description  : Performs lookups search to find if business anywhere product present in basket/account
* Author       : BDS Dev Team
* Called From  : BDSDuplicateLicenseConfig Lookup Configs
*************************************************************************************************************************/
global class BDSfindDuplicateBusinessAnywhere extends cscfga.ALookupSearch {
    
   /******************************************************************************************************
    * Input parameter  :   --     
    * Return Type      :   String
    *****************************************************************************************************/
    public override String getRequiredAttributes(){
        return '["Product Type","Basket Id", "Configuration Id"]';
    }
    
   /******************************************************************************************************
    * Input parameter  :   Map<String, String> searchFields, String productDefinitionId     
    * Return Type      :   List<Object>
    * Description      :   peforms search lookup based on the input criteria 
    *****************************************************************************************************/
    public override Object[] doDynamicLookupSearch(Map<String, String> searchFields, String productDefinitionId) {
        String productType = searchFields.get('Product Type');
        String basketId = searchFields.get('Basket Id');
        String configId = searchFields.get('Configuration Id');
        String accountId = '';
        List<cscfga__Product_Basket__c> accountIds = [SELECT cscfga__Opportunity__r.AccountId FROM cscfga__Product_Basket__c where Id =:basketId];
        
        //Get account Id for current basket      
        if(!accountIds.isEmpty()){        
             accountId = accountIds[0].cscfga__Opportunity__r.AccountId;
        }
        
        //Fetch active business anywhere service for the account
        List<csord__Service__c> existingServices = [SELECT csordtelcoa__Product_Configuration__r.Id FROM csord__Service__c 
            where csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c =:productType AND
            csord__Subscription__r.csord__Account__c=:accountId AND csord__Subscription__r.csord__Status__c = 'Active' ];
        
        if(existingServices.size() > 0){
            List<cscfga__Product_Configuration__c> onAccount = [SELECT Id,Name from cscfga__Product_Configuration__c where id=:existingServices.get(0).csordtelcoa__Product_Configuration__r.id limit 1];           
            List<cscfga__Product_Configuration__c> MACDReplaceConfig = [select ID from cscfga__Product_Configuration__c  where id=:configId and csordtelcoa__Replaced_Product_Configuration__c=:onAccount];
            if(!(MACDReplaceConfig.size()>0)){
            
                    return onAccount;
            }           
                       
        }
        
        //Fetch business anywhere products on basket other thank current configuration   
        List<cscfga__Product_Configuration__c> onBasket = [SELECT Id,Name from cscfga__Product_Configuration__c where
            Id !=:configId AND
            cscfga__Product_Family__c=:productType AND
            cscfga__Product_Basket__c=:basketId limit 1];
        
        if(onBasket.size() > 0){        
            return onBasket;
        }
        
        return null;
    }

}