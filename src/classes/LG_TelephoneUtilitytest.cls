@istest
public class LG_TelephoneUtilitytest {
    
    public static testmethod void utiltest(){
             Account acc = new Account();
        acc.Name = 'Planned Maintenance Account';
        acc.LG_VisitCountry__c = 'Germany';
        acc.LG_ChamberOfCommerceNumber__c = '7';
        acc.LG_Footprint__c = 'UPC';
        insert acc;
        
          Account account = LG_GeneralTest.CreateAccount('AccountSFDT', '12345678', 'Ziggo', true);
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
        
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('PC Test Basket', account, null, opp, false);
        
        basket.LG_CreatedFrom__c = 'Tablet';
        insert basket;
        
        cscfga__Product_Category__c productCategory = LG_GeneralTest.createProductCategory('PC Test Category', true);
        cscfga__Product_Definition__c productDefinition = LG_GeneralTest.createProductDefinition('PC Test Product', false);
        
        productDefinition.cscfga__Product_Category__c = productCategory.Id;
        
        insert productDefinition;
        cscfga__Product_Configuration__c pc = LG_GeneralTest.createProductConfiguration('Test', 12, basket, productDefinition, true);

        
        Opportunity tmpOpp = LG_GeneralTest.CreateOpportunity(acc);
        system.debug(tmpOpp.id);
       test.startTest();
        LG_TelephoneUtility.CreatePortingStructure('SOHO Telephony', '{"Existing_Phone_Numbers_0": "true" ,"Telephone_Number_0": "1234567891"}', pc.id,tmpOpp.id );
       test.stopTest();
        
    }
   
      public static testmethod void porttest(){
        
       test.startTest();
          LG_TelephoneUtility.CreatePortingStructure('SOHO Telephony', '{"Extra_Line_Porting_Number_0": "true"}',' pPCId', 'pOppId');
       test.stopTest();
        
    }
      public static testmethod void structtest(){
            Account acc = new Account();
        acc.Name = 'Planned Maintenance Account';
        acc.LG_VisitCountry__c = 'Germany';
        acc.LG_ChamberOfCommerceNumber__c = '7';
        acc.LG_Footprint__c = 'UPC';
        insert acc;
          
           Account account = LG_GeneralTest.CreateAccount('AccountSFDT', '12345678', 'Ziggo', true);
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
        
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('PC Test Basket', account, null, opp, false);
        
        basket.LG_CreatedFrom__c = 'Tablet';
        insert basket;
        
        cscfga__Product_Category__c productCategory = LG_GeneralTest.createProductCategory('PC Test Category', true);
        cscfga__Product_Definition__c productDefinition = LG_GeneralTest.createProductDefinition('PC Test Product', false);
        
        productDefinition.cscfga__Product_Category__c = productCategory.Id;
        
        insert productDefinition;
        cscfga__Product_Configuration__c pc = LG_GeneralTest.createProductConfiguration('Test', 12, basket, productDefinition, true);


        
        Opportunity tmpOpp = LG_GeneralTest.CreateOpportunity(acc);
        system.debug(tmpOpp.id);
       test.startTest();
          LG_TelephoneUtility.CreatePortingStructure('Mobile Telephony', '[{"simType": "port number","contractType":"contract"},{"contractType":"contract1"}]',pc.id, tmpOpp.id);
       test.stopTest();
        
    }
     public static testmethod void util(){
        
       test.startTest();
       LG_TelephoneUtility.CreatePortingStructure('Mobile Telephony', 'JSONString',' pPCId', 'pOppId');
       test.stopTest();
        
    }
}