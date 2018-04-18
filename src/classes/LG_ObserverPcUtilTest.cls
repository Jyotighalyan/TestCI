/*******************************************************************
* Date : 8-Dec-2017
* Name : LG_ObserverPcUtilTest
* Description : Test class for LG_ObserverPcUtil class
*******************************************************************/ 
@isTest
public class LG_ObserverPcUtilTest {
    
    @testSetup
    public static void dataSetup(){
        
        //account
        Account acc = LG_GeneralTest.CreateAccount('acc', '1234567', 'test', true);
        
        //opportunity
        Opportunity opp = new Opportunity(Name = 'Test', AccountId = acc.Id, StageName = 'Awareness of interest', CloseDate = Date.today()+5);
        insert opp ;
        
        //product basket
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('Basket', acc, null, opp, true);
        
        //product defination : BDS
        cscfga__Product_Definition__c prodDefBDS = LG_GeneralTest.createProductDefinition('BDS Standort', true);
        
        //product configuration 
        cscfga__Product_Configuration__c BDSProdCon = LG_GeneralTest.createProductConfiguration('Site : test 1234', 0, basket, prodDefBDS, true);
        
        
        //attribute definition
        cscfga__Attribute_Definition__c attrdef = LG_GeneralTest.createAttributeDefinition('Persistent Id', prodDefBDS, 'User Input', 'String', '', '', '', true); 
        
        
        cscrm__Address__c addr= LG_GeneralTest.crateAddress('Test Addr','ABC', 'Munich','45', '78','we','Germany', acc, true);
        
        //attribute
        cscfga__Attribute__c attr= LG_GeneralTest.createAttribute('Persistent Id',  attrdef, false, 10,BDSProdCon, false, string.valueof(addr.Id), true);
    }
    
    public static testmethod void testUtil(){
        
        cscfga__Product_Configuration__c BDSprod  = [select cscfga__Product_Definition__r.name,cscfga__Product_Basket__r.csordtelcoa__Change_Type__c,(Select Id, Name,cscfga__Value__c from cscfga__Attributes__r where Name='Persistent Id')  
                                                     from cscfga__Product_Configuration__c 
                                                     where name ='Site : test 1234'];
        
        
        test.startTest();
        
        LG_ObserverPcUtil.updatePersistentId(BDSprod);
       // cscfga__Product_Configuration__c clonedPc= BDSprod.clone(false,false,false,false);
       // insert clonedPc;
        test.stopTest();
    }
}