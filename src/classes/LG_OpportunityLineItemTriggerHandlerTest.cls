@isTest
public class LG_OpportunityLineItemTriggerHandlerTest 
{
    /*
    static testMethod void Test()
    {
        Account tmpAccount = LG_GeneralTest.CreateAccount('Test Acc');
        
        Opportunity tmpOpp = LG_GeneralTest.CreateOpportunity(tmpAccount);
        
        LG_Discount__c tmpDiscountAmountOff = LG_GeneralTest.createDiscount(10,'ABC123',3,'Discount Amount Off');
        
        cscfga__Product_Definition__c tmpProductDefinition = LG_GeneralTest.createProductDefinition('Internet');
        
        cscfga__Attribute_Definition__c tmpProductAttributeDefinitionTotal = LG_GeneralTest.createAttributeDefinition('Total Basic Price', tmpProductDefinition, 'Display Value');
        cscfga__Attribute_Definition__c tmpProductAttributeDefinitionDiscount = LG_GeneralTest.createAttributeDefinition('Discount', tmpProductDefinition, 'Lookup');
        cscfga__Attribute_Definition__c tmpProductAttributeDefinitionOneOff = LG_GeneralTest.createAttributeDefinition('Install', tmpProductDefinition, 'Display Value');
        
        cscfga__Attribute_Field_Definition__c tmpAttributeFieldDefinition = LG_GeneralTest.createAttributeFieldDefinition('Main','Yes',tmpProductAttributeDefinitionTotal);
        
        //not synced with Opp first
        cscfga__Product_Basket__c tmpProductBasket = LG_GeneralTest.createProductBasket('Basket', tmpAccount, tmpOpp, false);
        

        cscfga__Product_Configuration__c tmpProductConfiguration = LG_GeneralTest.createProductConfiguration('Internet', 12, tmpProductBasket, tmpProductDefinition);
        
        cscfga__Attribute__c tmpProductAttributeTotal = LG_GeneralTest.createAttribute('Total Basic Price',tmpProductAttributeDefinitionTotal,true,100,
            tmpProductConfiguration, true,'100');

        cscfga__Attribute__c tmpProductAttributeDiscount = LG_GeneralTest.createAttribute('Discount',tmpProductAttributeDefinitionDiscount,true,0,
            tmpProductConfiguration, false, string.valueOf(tmpDiscountAmountOff.Id));
            
        cscfga__Attribute__c tmpProductAttributeOneOff = LG_GeneralTest.createAttribute('Install',tmpProductAttributeDefinitionOneOff,true,10,
            tmpProductConfiguration, false,'10');
        
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = false;
        noTriggers.SetupOwnerId = UserInfo.getUserId();
        upsert noTriggers;
         
        
        Synchronize controller = new Synchronize(new ApexPages.StandardController(tmpProductBasket));
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', tmpProductBasket.Id);
        controller.SynchronizeRedirect();
        Test.stopTest();
        
            
    }
    */
}