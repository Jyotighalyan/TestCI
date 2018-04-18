@isTest
private class MLEConfigurationFilterTests {
    @isTest
    static void testGetConfigurationFilterClauseForVPN() {
        Map<String,String> paramMap = new Map<String,String>();
        String queryString;
        paramMap.put('networkId', 'testVPN');        
        MLEConfigurationFilter filter = new MLEConfigurationFilter();
        queryString = filter.getConfigurationFilterClause(paramMap);
        System.assertEquals(queryString,'LG_From_Configuration__c In (\'testVPN\')');
    }
    
    @isTest
    static void testGetConfigurationFilterClauseForVPN1() {
        Map<String,String> paramMap = new Map<String,String>();
        String queryString;
        paramMap.put('siteId', 'testBDS');
        paramMap.put('macConfig', 'testMac');
        MLEConfigurationFilter filter = new MLEConfigurationFilter();
        queryString = filter.getConfigurationFilterClause(paramMap);
        System.assertEquals(queryString,'LG_To_Configuration__c In (\'testBDS\')');
    }
}