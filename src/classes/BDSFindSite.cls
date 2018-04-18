global class BDSFindSite extends cscfga.ALookupSearch {
    
   /******************************************************************************************************
    * Input parameter  :   --     
    * Return Type      :   String
    *****************************************************************************************************/
    public override String getRequiredAttributes(){
        return '["Site Configuration Shadow","Basket Id"]';
    }
    
   /******************************************************************************************************
    * Input parameter  :   Map<String, String> searchFields, String productDefinitionId     
    * Return Type      :   List<Object>
    * Description      :   peforms search lookup based on the input criteria 
    *****************************************************************************************************/
    public override Object[] doDynamicLookupSearch(Map<String, String> searchFields, String productDefinitionId) {
        String persistentId = searchFields.get('Site Configuration Shadow');
        String basketId = searchFields.get('Basket Id');

        if(persistentId == null || String.isBlank(persistentId)){
        
            return null;
        }
        
         //Fetch business anywhere products on basket other thank current configuration   
        List<cscfga__Product_Configuration__c> onBasket = [SELECT Id,Name,LG_CustomProductName__c,LG_Address__c from cscfga__Product_Configuration__c where cscfga__Product_Basket__c=:basketId and LG_Persistent_Id__c = :persistentId and cscfga__Configuration_Status__c='Valid' limit 1];
        
        if(onBasket.size() > 0){        
            return onBasket;
        }
        
        
        String accountId = '';
        
        List<cscfga__Product_Basket__c> accountIds = [SELECT cscfga__Opportunity__r.AccountId FROM cscfga__Product_Basket__c where Id =:basketId];
        
        //Get account Id for current basket      
        if(!accountIds.isEmpty()){        
             accountId = accountIds[0].cscfga__Opportunity__r.AccountId;
        }
        
        
        
        //Fetch active business anywhere service for the account
        List<csord__Service__c> existingServices = [SELECT csordtelcoa__Product_Configuration__r.Id FROM csord__Service__c where csordtelcoa__Product_Configuration__r.LG_Persistent_Id__c =:persistentId AND
            csord__Subscription__r.csord__Account__c=:accountId AND csord__Subscription__r.csord__Status__c = 'Active' limit 1 ];
        
        if(existingServices.size() > 0){
            List<cscfga__Product_Configuration__c> onAccount = [SELECT Id,Name,LG_CustomProductName__c,LG_Address__c from cscfga__Product_Configuration__c where id=:existingServices.get(0).csordtelcoa__Product_Configuration__r.id limit 1];           
            
            if(onAccount.size()>0){
            
                    return onAccount;
            }           
                       
        }
        
       
        
        return null;
    }

}