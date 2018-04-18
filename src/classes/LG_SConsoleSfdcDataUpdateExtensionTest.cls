@isTest
public class LG_SConsoleSfdcDataUpdateExtensionTest {
    @testSetup
    static void setup() {
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        //Order
        csord__Order__c order = new csord__Order__c(Name = 'Test Order', csord__Identification__c = '6465467986');
        insert order;
        
        //product definition
        cscfga__Product_Definition__c prdConf = new cscfga__Product_Definition__c(Name = 'TestProductDefinition', cscfga__Description__c = 'Description of TestProductDefinition');
        insert prdConf;
        
        //product configuration
        cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c(cscfga__Attribute_Name__c = 'testAttribute', Name = 'TestProductConfiguration', cscfga__Product_Definition__c = prdConf.Id);
        pc.LG_ProvisionValid__c = 'Yes';
        insert pc;
        
        Account aa=new Account();
        aa.name='nnn';
        aa.LG_ChamberOfCommerceNumber__c='123';
        aa.LG_VisitCountry__c='Germany';
        insert aa;
        
        csconta__Billing_Account__c billingAccount= new csconta__Billing_Account__c(csconta__Account__c=aa.id,LG_BillingAccountName__c = 'Billing Account 1',     LG_PaymentType__c = 'Bank Transfer',
                                                                                    LG_BillingEmailAddress__c = 'abcxyz@sf.com', LG_ExternalId__c = '12-231456789');
        insert billingAccount;
        
        // Subscripton
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '6465367986', csconta__Billing_Account__c = billingAccount.id);
        insert sub;
        
        //Solution
        csord__Solution__c solution = new csord__Solution__c(Name = 'test solution', csord__Identification__c = '6465447986', csord__Order__c = order.Id);
        insert solution;
        
        // Service
        csord__Service__c service = new csord__Service__c(csordtelcoa__Product_Configuration__c = pc.Id, Name = 'TestService', csord__Subscription__c = sub.Id, csord__Identification__c = '6465427986', LG_RootOrder__c = order.Id, csord__Activation_Date__c = Date.today());
        service.LG_Suborder__c = solution.Id;
        service.LG_Product_Category__c = 'Product Category';
        insert service;
        
        
        //Attribute
        cscfga__Attribute__c a = new cscfga__Attribute__c(cscfga__Product_Configuration__c = pc.Id, Name = 'TestAttribute', cscfga__Value__c = '15', cscfga__Display_value__c = 'TestDisplayValue');
        insert a;
        
        //Attribute Field
        cscfga__Attribute_Field__c af = new cscfga__Attribute_Field__c(cscfga__Attribute__c = a.Id, Name = 'TestAttributeFieldName', cscfga__Value__c = 'Hello');
        insert af;
        
        //Service Line Item
        csord__Service_Line_Item__c serviceLineItem1 = new csord__Service_Line_Item__c(Name = 'test Line item 1', csord__Service__c = service.Id, csord__Identification__c = '6465467984');
        insert serviceLineItem1;
        
        //Service Line Item
        csord__Service_Line_Item__c serviceLineItem2 = new csord__Service_Line_Item__c(Name = 'test Line item 2', csord__Service__c = service.Id, csord__Identification__c = '6465467987');
        insert serviceLineItem2;
        
        //Service Line Item
        csord__Service_Line_Item__c serviceLineItem3 = new csord__Service_Line_Item__c(Name = 'test Line item 3', csord__Service__c = service.Id, csord__Identification__c = '6465467988');
        insert serviceLineItem3;
        
        //Case
        Case cas = new Case(LG_Service__c = service.Id, LG_Solution__c = solution.Id, Type='Modify');
        cas.RecordTypeId = [Select Id, SobjectType, Name From RecordType where Name = 'Legacy Fulfilment'
                            and SobjectType = 'Case'  limit 1].Id;
        /*Code changes Joshua C. Joseph
        
        Id casRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Legacy Fulfilment').getRecordTypeId();
        cas.RecordTypeId=casRecordTypeId;
        */
        
        insert cas;
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    
    public static testMethod void TestCodeCoverage() {
        Case casli = [select Id, LG_Service__c, LG_Solution__c, recordTypeId from Case where RecordType.name='Legacy Fulfilment' LIMIT 1];
        csord__Solution__c sol = [select Id, Name,csord__Order__c from csord__Solution__c LIMIT 1];
        List<csord__Service__c> service = [select Id, csord__Subscription__c, csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name
                                           from csord__Service__c where LG_Suborder__c = :sol.Id];
        List<csord__Service_Line_Item__c> sliList = [Select Id from csord__Service_Line_Item__c where csord__Service__r.csord__Subscription__c = :service.get(0).csord__Subscription__c];
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){        
        Test.startTest();
        
        PageReference pageRef = Page.LG_SConsoleSfdcDataUpdate;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', casli.id);
        LG_SConsoleSfdcDataUpdateExtension controller = new LG_SConsoleSfdcDataUpdateExtension(new ApexPages.StandardController(casli ));
        
        controller.getProvisioning();
        controller.edit();
        controller.cancel();
        System.assertEquals(sol.Id, controller.getSolution().Id);
        System.assertEquals(service.size(), controller.getService().size());
        System.assertEquals((sliList.size()+service.size()), controller.getBillingDetails().size());
        LG_SConsoleSfdcDataUpdateExtension.ProvisioningDetails provDetails = new LG_SConsoleSfdcDataUpdateExtension.ProvisioningDetails(controller.getRecordType(), service[0]);
        System.assertEquals(service.size(), controller.getProvisioningDetails().size());
        
        controller.save();
        
        //Making solution obj as null to test exception
        controller.edit();
        controller.solutionObject = null;
        
        try{
            controller.save();
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Some Error Occured ') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        Test.stopTest();
         }
    }
    
    public static testMethod void updatePaccTest() {
        Case casli2 = [select Id, LG_Service__c, LG_Solution__c, recordTypeId from Case where RecordType.name='Legacy Fulfilment' LIMIT 1];
         system.assertnotequals(null,casli2);
        Id casRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Cama PendingOrder').getRecordTypeId();
        casli2.RecordTypeId=casRecordTypeId;
        Update casli2;  
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
        
        PageReference pageRef = Page.LG_SConsoleSfdcDataUpdate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',casli2.Id);
        
        ApexPages.StandardController standrdcontroller = new ApexPages.StandardController(casli2 );
        LG_SConsoleSfdcDataUpdateExtension myController = new LG_SConsoleSfdcDataUpdateExtension(standrdcontroller);
        
        myController .getCama();
        myController .edit();
        myController .cancel();
        myController .save();
        
        Test.stopTest();
         }
        
    } 
}