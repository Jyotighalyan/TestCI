@isTest
public class CloseProductConfigurationControllerTest {

    static testMethod void testPlanningDetailsStatusTrue(){
        cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c();
        pc.Name = 'Product Configuration Name';
        pc.LG_PlanningDetailsStatus__c = 'complete';
        pc.cscfga__Configuration_Status__c = 'valid';
        insert pc;
        PageReference pageRef = Page.CloseProductConfiguration;
        pageRef.getParameters().put('configId', pc.Id);        
        Test.setCurrentPage(pageRef);
        CloseProductConfigurationController closeCtrl = new CloseProductConfigurationController();
        System.assertEquals(true,closeCtrl.completed);
    }
    
    static testMethod void testPlanningDetailsStatusFalse(){
        cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c();
        pc.Name = 'Product Configuration Name';
        pc.LG_PlanningDetailsStatus__c = 'pending';
        pc.cscfga__Configuration_Status__c = 'valid';
        insert pc;
        PageReference pageRef = Page.CloseProductConfiguration;
        pageRef.getParameters().put('configId', pc.Id);        
        Test.setCurrentPage(pageRef);
        CloseProductConfigurationController closeCtrl = new CloseProductConfigurationController();
        System.assertEquals(false,closeCtrl.completed);
    }

}