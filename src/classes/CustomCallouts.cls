/*

    This web service is used to query external data source

*/
global class CustomCallouts {

    webservice static String getCustomAddresses(String postcode) {
            
        String query;
        List<string> params = new List<string>();
        
        if (String.isNotBlank(postcode)) {
            params.add('Postcode__c LIKE \'%' + String.escapeSingleQuotes(postcode) + '%\'');
        }

        if (params.size() == 0) {
            query = 'SELECT Id, Site_Id__c, Postcode__c, Address_Line_1__c, Address_Line_2__c, House_Number__c, House_Number_Extension__c, Town__c FROM Site__c LIMIT 25';
        }
        else {
            String allParams = String.join(params, ' AND ');
            query = 'SELECT Id, Site_Id__c, Postcode__c, Address_Line_1__c, Address_Line_2__c, House_Number__c, House_Number_Extension__c, Town__c FROM Site__c WHERE ' + allParams;
        }
        
        List<Site__c> sl = Database.query(query);
        system.debug('+++address list is: ' + sl);

        return JSON.serialize(sl);
    }

    webservice static String synchronizeBasket(String basketId) {
        
        cscfga__Product_Basket__c basket = [SELECT csbb__synchronised_with_opportunity__c, cscfga__opportunity__c FROM cscfga__Product_Basket__c WHERE id = :basketId];
        basket.csbb__synchronised_with_opportunity__c = true;
        // any other sync logic goes here
        update basket;
        
        Opportunity oppToGoBackTo = [select id from Opportunity where id = :basket.cscfga__Opportunity__c];
        PageReference oppPage = new ApexPages.StandardController(oppToGoBackTo).view();
        return oppPage.getUrl();
    }
}