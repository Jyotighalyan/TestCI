@isTest
public class LG_QuickCreatePremisePageControllertest {
    
    public static testmethod void pagcontrol(){
        
        test.startTest();
        cscfga__Product_Definition__c def=LG_GeneralTest.createProductDefinition('prod',true);
         Account acc = LG_GeneralTest.CreateAccount('AccountSFDT', '12345678', 'Ziggo', true);
        LG_GeneralTest.crateAddress('To be deleted','street','city','country','zip','postalcode','housenumb',acc,true);
        System.currentPageReference().getParameters().put('lookupId', acc.ID);
       	System.currentPageReference().getParameters().put('productDefinitionId', def.id);
         System.currentPageReference().getParameters().put('attributeValues','001');
        LG_QuickCreatePremisePageController premiscont=new LG_QuickCreatePremisePageController();
        premiscont.createNewPremise();
        
        test.stopTest();
        
    }

}