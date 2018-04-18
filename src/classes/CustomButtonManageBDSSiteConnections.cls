global with sharing class CustomButtonManageBDSSiteConnections extends csbb.CustomButtonExt
{
    public List<String> mleConfigs;
    
    public String bdsSite;
    public String vpnService;
    public String connection;
    
    // Perform action implementation
    public String performAction(String basketId, String pcrIds)
    {          
        bdsSite = Label.BDS_Site;
        vpnService = Label.VPN_services;
        connection = Label.Company_VPN_Connection;
        mleConfigs = new List<String>{bdsSite, vpnService};
            
        String pcrString = pcrIds.remove('["').remove('"]').remove('"');
        boolean isValid = checkValidConfigs(basketId,pcrString);
        
        if (isValid ) {
            String newUrl = openMultiLineEditor(basketId, pcrString);
            return '{"status":"ok","text":"' + Label.MLE_Validation_Success + '", "redirectURL":"' + newUrl + '"}';
        } else {
            return '{"status":"error", "text":"' + Label.MLE_Validation_Failure + '"}';
        }  
    }
    
    private boolean checkValidConfigs(String basketId, String pcrIds) {
        List<String> pcrRecordIds = pcrIds.split(',');        
        if(pcrRecordIds.size() !=1) {
            return false;
        }        
        List<csbb__Product_Configuration_Request__c> validConfigs = [SELECT Id FROM csbb__Product_Configuration_Request__c 
                                                                     WHERE Id  IN :pcrRecordIds 
                                                                     and csbb__Product_Configuration__r.LG_ProductDefinitionName__c In:mleConfigs
                                                                     and csbb__Product_Configuration__r.cscfga__Configuration_Status__c = 'Valid'];
        if (validConfigs.size() != 1) {
            return false;
        }
        return true;
    }
    
    // Set url for redirect after action
    private String openMultiLineEditor(String basketId, String pcrIds)
    {
        
        String urlInstance = String.valueof(System.URL.getSalesforceBaseURL()).replace('Url:[delegate=','').replace(']','');
        String[] instance = urlInstance.split('\\.');
        List<String> pcrRecordIds = pcrIds.split(',');
        String urlConfig;
        String screenflowConfig;
        String macConfig;
        String persistentId;        
        
        List<csbb__Product_Configuration_Request__c> config = [SELECT Id, 
                                                               csbb__Product_Configuration__r.LG_ProductDefinitionName__c,
                                                               csbb__Product_Configuration__r.csordtelcoa__Replaced_Product_Configuration__c,
                                                               csbb__Product_Configuration__r.LG_Persistent_Id__c
                                                               FROM csbb__Product_Configuration_Request__c 
                                                               WHERE Id  IN :pcrRecordIds 
                                                               and csbb__Product_Configuration__r.LG_ProductDefinitionName__c In:mleConfigs
                                                               and csbb__Product_Configuration__r.cscfga__Configuration_Status__c = 'Valid'];        
        
        persistentId = config[0].csbb__Product_Configuration__r.LG_Persistent_Id__c;
        
        if(config[0].csbb__Product_Configuration__r.LG_ProductDefinitionName__c == vpnService){
            urlConfig = 'networkId='+persistentId;
            screenflowConfig = 'screenFlowName=VPNSetForMLE';
        } else if(config[0].csbb__Product_Configuration__r.LG_ProductDefinitionName__c == bdsSite) {
            urlConfig = 'siteId='+persistentId;
            screenflowConfig = 'screenFlowName=siteSetForMLE';
        }      
        
        List<cscfga__Product_Definition__c> prdDefs = [SELECT Id FROM cscfga__Product_Definition__c where cscfga__IsArchived__c  = false and cscfga__Active__c = true and Name =:connection LIMIT 1];
        PageReference editPage = new PageReference('https://csmle.'+instance[1]+'.visual.force.com/apex/Editor?id=' + basketId + 
                                                   '&'+urlConfig +'&retUrl=/'+basketId+'&batchSize=5&productDefinitionId='+prdDefs[0].Id+
                                                   '&'+screenflowConfig+'&'+macConfig+'&configFilter=MLEConfigurationFilter#/');
        return editPage.getUrl();
    }   
    
}