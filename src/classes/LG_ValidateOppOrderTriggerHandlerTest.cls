/*
 * Test class for LG_ValidateOppOrderTriggerHandler
 @ Author : Shruthi Gopal
 @ Date   : 23/10/2017
*/

@isTest
public class LG_ValidateOppOrderTriggerHandlerTest {
    
	public static testmethod void BeforeUpdateHandleTest(){
      
        Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'New Accoun 1', true);
        
        Contact tmpContact = new Contact();
        tmpContact.AccountId=account.Id;
        tmpContact.Firstname='Firstname';
        tmpContact.LastName='LastName';
        tmpContact.Salutation='Mr.';
        insert tmpContact;
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, false);
        insert opp;

        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Basket', account, null, opp, false);
        basket.csordtelcoa__Synchronised_with_Opportunity__c = true;
        insert basket;

        cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('Test Category', true);

        cscfga__Product_Definition__c prodDef = LG_GeneralTest.createProductDefinition('Phone Numbers', false);

        prodDef.cscfga__Product_Category__c = prodCategory.Id;
        insert prodDef;

        cscrm__Address__c address = new cscrm__Address__c(cscrm__Street__c = 'TestStreet');
        address.LG_TechnicalContact__c = null;
        insert address;
        
        cscfga__Product_Configuration__c pc = LG_GeneralTest.createProductConfiguration('TestConf', 12, basket, prodDef, false);
        pc.LG_Address__r = address;
        pc.LG_InstallationWishDate__c = date.today();
        pc.LG_InstallationPlannedDate__c = date.today();
        pc.LG_InstallationNeeded__c = true;
        insert pc;
        
        Map<Id, Opportunity> mapNew = new Map<Id, Opportunity>();
        opp.StageName = 'Awareness of interest';
       
        update opp;
        mapNew.put(opp.id, opp);
        
        
        Map<Id, Opportunity> mapOld = new Map<Id, Opportunity>();
        opp.StageName = 'Closed Lost';
        update opp;
        mapOld.put(opp.id, opp);
        
        test.startTest();
        LG_ValidateOppOrderTriggerHandler.BeforeUpdateHandle(mapNew, mapOld);
        pc.LG_Address__c = address.id;
        update pc;
        LG_ValidateOppOrderTriggerHandler.BeforeUpdateHandle(mapNew, mapOld);
        test.stopTest();
    }
}