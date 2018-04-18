global class MLEConfigurationFilter implements csmle.MleAPI.ConfigurationFilter {
    public String getConfigurationFilterClause(Map<String, String> params)
    {        
        String queryString;
        String persistentIds='';        
        if (params.get('networkId') != '' && params.get('networkId') != null) {
            persistentIds += '\''+params.get('networkId')+'\'';
            queryString = 'LG_From_Configuration__c In ('+persistentIds+')';
        }else if (params.get('siteId') != '' && params.get('siteId') != null) {
            persistentIds += '\''+params.get('siteId')+'\'';
            queryString = 'LG_To_Configuration__c In ('+persistentIds+')';
        }
        return queryString;
    }
}