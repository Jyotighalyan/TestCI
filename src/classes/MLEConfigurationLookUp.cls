global class MLEConfigurationLookUp extends cscfga.ALookupSearch {

    public override String getRequiredAttributes(){
        return '["Basket Id","Site Configuration Id","VPN Configuration Id"]';
    }
    
    public override Object[] doLookupSearch(Map<String, String> searchFields, String productDefinitionId,
    Id[] excludeIds, Integer pageOffset, Integer pageLimit) {
    
        String basketId = searchFields.get('Basket Id');    
        String bdsSite = searchFields.get('Site Configuration Id');
        String bdsVpn = searchFields.get('VPN Configuration Id');
        
        System.debug('basketId '+basketId);
        System.debug('bdsSite '+bdsSite);
        System.debug('bdsVpn '+bdsVpn);
        
        String mleSetting;
        
        //Decide if site/VPN product selected before navigating to MLE
        if(bdsSite != null && !String.isEmpty(bdsSite)) {
            mleSetting = Label.VPN_services;
        } else if(bdsVpn != null && !String.isEmpty(bdsVpn)) {
            mleSetting = Label.BDS_Site;
        }
        
        //Get existing VPN/site product based on which product was selected
        List<cscfga__Product_Basket__c> accountIds = [SELECT cscfga__Opportunity__r.AccountId FROM cscfga__Product_Basket__c where Id =:basketId];
        String accountId = accountIds[0].cscfga__Opportunity__r.AccountId;
        
        List<csord__Service__c> existingServices = [SELECT csordtelcoa__Product_Configuration__r.Id FROM csord__Service__c 
            where csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c =:mleSetting AND
            csord__Subscription__r.csord__Account__c=:accountId AND csord__Subscription__r.csord__Status__c = 'Active' and
            id not In (select csordtelcoa__Replaced_Service__c from cscfga__Product_Configuration__c where cscfga__Product_Basket__c =:basketId)];           
        
        List<String> existingProdConfigIds = new List<String>();
        for(csord__Service__c existingService:existingServices) {
            existingProdConfigIds.add(existingService.csordtelcoa__Product_Configuration__r.Id);
        }
        
        List<cscfga__Product_Configuration__c> prdCnf = 
            [SELECT LG_CustomProductName__c,Name, cscfga__Product_Basket__c, cscfga__Product_Family__c
                FROM cscfga__Product_Configuration__c where Id In:existingProdConfigIds OR
                (cscfga__Product_Basket__c = :basketId and
                cscfga__Product_Family__c =:mleSetting)];
        return prdCnf;
    }

}