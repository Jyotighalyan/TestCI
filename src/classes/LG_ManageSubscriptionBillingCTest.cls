@isTest
public class LG_ManageSubscriptionBillingCTest {
@testSetup 
    static void setup() {
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    noTriggers.Flag__c = true;
    noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
    upsert noTriggers;
        
        //Order
        csord__Order__c order = new csord__Order__c(Name='Test Order',csord__Identification__c = '6465467986');
        insert order;
        
        //product configuration
        cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c(cscfga__Attribute_Name__c='testAttribute',Name='TestName');
        insert pc;
        
        // Subscripton 
    csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '6465467986');
    insert sub; 
        
        // Service 
    csord__Service__c service = new csord__Service__c(csordtelcoa__Product_Configuration__c=pc.Id,Name='TestService',csord__Subscription__c=sub.Id,csord__Identification__c='6465467986',LG_RootOrder__c=order.Id,csord__Activation_Date__c=Date.today());
    insert service;
        
        //Attribute
        cscfga__Attribute__c a = new cscfga__Attribute__c(cscfga__Product_Configuration__c = pc.Id,Name='TestAttribute',cscfga__Value__c='15',cscfga__Display_value__c='TestDisplayValue');
        insert a;
        
        //Attribute Field
        cscfga__Attribute_Field__c af = new cscfga__Attribute_Field__c(cscfga__Attribute__c = a.Id,Name='TestAttributeFieldName',cscfga__Value__c='Hello');
        insert af;
        
        //Service Line Item
        csord__Service_Line_Item__c serviceLineItem1 = new csord__Service_Line_Item__c(Name='test Line item 1',csord__Service__c = service.Id,csord__Identification__c = '6465467986');
        insert serviceLineItem1;
        
         //Service Line Item
        csord__Service_Line_Item__c serviceLineItem2 = new csord__Service_Line_Item__c(Name='test Line item 2',csord__Service__c = service.Id,csord__Identification__c = '6465467986');
        insert serviceLineItem2;
        
        //Service Line Item
        csord__Service_Line_Item__c serviceLineItem3 = new csord__Service_Line_Item__c(Name='test Line item 3',csord__Service__c = service.Id,csord__Identification__c = '6465467986');
        insert serviceLineItem3;
        
        //Solution
        csord__Solution__c solution = new csord__Solution__c(Name = 'test solution',csord__Identification__c = '6465467986',csord__Order__c=order.Id);
        insert solution;
        
        //Case
        Case c = new Case(LG_Service__c = service.Id,LG_Solution__c = solution.Id);
        c.RecordTypeId = [Select Id,SobjectType,Name From RecordType where Name ='Manage Subscriptions' 
                          and SobjectType ='Case'  limit 1].Id;
        insert c;
        
        
        service.LG_Suborder__c = solution.Id;
        service.csord__Solution__c = solution.Id;
        update service;
        
        
        
    }
    public static testMethod void TestLG_ViewAttributeDefenitionController(){
        
        Case c = [select Id,LG_Service__c from Case LIMIT 1];
        csord__Solution__c s = [select Id,Name,csord__Identification__c,csord__Order__c from csord__Solution__c limit 1];
        csord__Order__c o = [Select Id from csord__Order__c LIMIT 1];
        List<csord__Service_Line_Item__c> lineItems = [select Id from csord__Service_Line_Item__c where csord__Service__c=:c.LG_Service__c];
        List<csord__Service__c> services = [Select Id from csord__Service__c where Id=:c.LG_Service__c];
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        LG_ManageSubscriptionBillingController controller = new LG_ManageSubscriptionBillingController(sc);
        
        System.assertEquals(c.Id, controller.caseRecord.Id);
        System.assertEquals(s.Id, controller.getRelatedSolution().Id);
        System.assertEquals(o.Id, controller.getRelatedOrder().Id);
        System.assertEquals(s.Id, controller.getRelatedSubOrder().Id);
        System.assertEquals(lineItems.size(), controller.getRelatedServiceLineItems().size());
        System.assertEquals(services.size(), controller.getRelatedServices().size());
        //system.assertEquals('Support', controller.getCaseRecordType());
        controller.getCaseRecordType();
        controller.getRelatedSolution();
        controller.populateRelatedSolution();
        
        Test.stopTest();
         }
    }
}