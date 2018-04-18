@isTest

public class LG_SConsoleProvisionOneDetailsTest {
    
    @testSetup
  static void setup() {

    No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    noTriggers.Flag__c = true;
    noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
    upsert noTriggers;

    //Account
    Account acc = new Account();
    acc.Name = 'TEST NAME';
    acc.LG_ChamberOfCommerceNumber__c = '12345678';
    insert acc;
    
    //Billing Account
    csconta__Billing_Account__c bacc = new csconta__Billing_Account__c();
    bacc.csconta__Account__c = acc.id;
    bacc.csconta__Status__c = 'New';
    bacc.csconta__Billing_Channel__c = 'Paper';
    bacc.csconta__Format_Type__c = 'Summary';
    insert bacc;
    
    //Order
    csord__Order__c order = new csord__Order__c(Name = 'Test Order', csord__Identification__c = '6465467986');
    insert order;

    //product definition
    cscfga__Product_Definition__c prdConf = new cscfga__Product_Definition__c(Name = 'TestProductDefinition', cscfga__Description__c = 'Description of TestProductDefinition');
    insert prdConf;

    //product configuration
    cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c(cscfga__Attribute_Name__c = 'testAttribute', Name = 'TestProductConfiguration', cscfga__Product_Definition__c = prdConf.Id);
    insert pc;



    // Subscripton
    csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '6465467986',csconta__Billing_Account__c = bacc.id);
    insert sub;
    
    // Subscripton
    csord__Subscription__c sub1 = new csord__Subscription__c(csord__Identification__c = '64654679861');
    insert sub1;

    //Solution
    csord__Solution__c solution = new csord__Solution__c(Name = 'test solution', csord__Identification__c = '6465467986', csord__Order__c = order.Id);
    solution.LG_JeopardyExplanation__c = '';
    solution.LG_Jeopardy__c = true;
    insert solution;

    // Service
    csord__Service__c service = new csord__Service__c(csordtelcoa__Product_Configuration__c = pc.Id, Name = 'Company Internet', csord__Subscription__c = sub.Id, csord__Identification__c = '6465467986', LG_RootOrder__c = order.Id, csord__Activation_Date__c = Date.today());
    service.LG_Suborder__c = solution.Id;
    service.LG_ProvisionValid__c = 'Yes';
    service.LG_Product_Category__c = 'Product Category';
    service.csordtelcoa__Delta_Status__c = '';
    service.LG_DecompositionCriteria__c='Set 23 - CCC VDSL Process';
    insert service;
      
    //Asset
    Asset asst=new Asset();
    asst.Name='Test Asset';
    asst.csord__Service__c=service.Id;
    asst.accountId=acc.id;
    asst.LG_MACAddress__c='123';
    asst.LG_IPAddress__c='456';
    asst.Quantity=2;
    asst.Status = 'Active';
    asst.csord__Asset_Value__c = 'Test Val';
    insert asst;
    
    // Service
    csord__Service__c service1 = new csord__Service__c(csordtelcoa__Product_Configuration__c = pc.Id, Name = 'TestService', csord__Subscription__c = sub1.Id, csord__Identification__c = '6465467986', LG_RootOrder__c = order.Id, csord__Activation_Date__c = Date.today());
    service1.LG_Suborder__c = solution.Id;
    service1.LG_ProvisionValid__c = 'Yes';
    service1.LG_Product_Category__c = 'Product Category';
    service1.csordtelcoa__Delta_Status__c = 'Deleted From Subscription';
    insert service1;

    //Attribute
    cscfga__Attribute__c a = new cscfga__Attribute__c(cscfga__Product_Configuration__c = pc.Id, Name = 'TestAttribute', cscfga__Value__c = '15', cscfga__Display_value__c = 'TestDisplayValue');
    insert a;

    //Attribute Field
    cscfga__Attribute_Field__c af = new cscfga__Attribute_Field__c(cscfga__Attribute__c = a.Id, Name = 'TestAttributeFieldName', cscfga__Value__c = 'Hello');
    insert af;

    //Service Line Item
    csord__Service_Line_Item__c serviceLineItem1 = new csord__Service_Line_Item__c(Name = 'test Line item 1', csord__Service__c = service.Id, csord__Identification__c = '6465467986');
    insert serviceLineItem1;

    //Service Line Item
    csord__Service_Line_Item__c serviceLineItem2 = new csord__Service_Line_Item__c(Name = 'test Line item 2', csord__Service__c = service.Id, csord__Identification__c = '6465467986');
    insert serviceLineItem2;

    //Service Line Item
    csord__Service_Line_Item__c serviceLineItem3 = new csord__Service_Line_Item__c(Name = 'test Line item 3', csord__Service__c = service.Id, csord__Identification__c = '6465467986');
    insert serviceLineItem3;



    //Case
    Case c = new Case(LG_Service__c = service.Id, LG_Solution__c = solution.Id);
    c.RecordTypeId = [Select Id, SobjectType, Name From RecordType where Name = 'Provision One Step'
                      and SobjectType = 'Case'  limit 1].Id;
    insert c;


  }
  public static testMethod void TestCodeCoverage() {
    Case c = [select Id, LG_Service__c, LG_Solution__c, recordTypeId from Case LIMIT 1];
    csord__Solution__c sol = [select Id, Name, LG_Jeopardy__c, LG_JeopardyExplanation__c, csord__Order__c from csord__Solution__c LIMIT 1];
    List<csord__Service__c> service = [select Id, csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name,  
                                           LG_ProvisionValid__c, csordtelcoa__Delta_Status__c, 
                                           LG_Product_Category__c
                                           from csord__Service__c where LG_Suborder__c = :sol.Id];
    
    List<csord__Service_Line_Item__c> sli = [Select Id from csord__Service_Line_Item__c where csord__Service__c = :service.get(0).Id];
      User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
      Test.startTest();
    PageReference pageRef = Page.LG_SConsoleProvisionOneDetails;
    Test.setCurrentPage(pageRef);
    pageRef.getParameters().put('id', c.id);
    LG_CheckBdsDecompositionCriteria__c customSett=new LG_CheckBdsDecompositionCriteria__c();
    customSett.LG_Decomposition_Criteria__c='Set 23 - CCC HFC Process';
    customSett.name='CCC HFC';
    insert customSett;
     LG_CheckBdsDecompositionCriteria__c customSettValue=new LG_CheckBdsDecompositionCriteria__c();
    customSettValue.LG_Decomposition_Criteria__c='Set 23 - CCC VDSL Process';
    customSettValue.name='CCC VDSL';
    insert customSettValue;
     LG_CheckBdsDecompositionCriteria__c customSettOffnet=new LG_CheckBdsDecompositionCriteria__c();
    customSettOffnet.LG_Decomposition_Criteria__c='Set 23 - CCC Offnet Process';
    customSettOffnet.name='CCC Offnet';
    insert customSettOffnet;
    
    LG_SConsoleProvisionOneDetailsExtension controller = new LG_SConsoleProvisionOneDetailsExtension(new ApexPages.StandardController(c));
    //controller.getRecordType();
    //controller.getProvisoning();
    controller.edit();
    controller.cancel();
    controller.PageRefresh();
    controller.getAsset();
    controller.getBDSServiceAsset();
    controller.getLInkedBDSvalue();
    controller.FrameAddressInFormat('abc','sty','saas','aas','as');
    
    System.assertEquals(sol.Id, controller.getSolution().Id);
    System.assertEquals(service.size(), controller.getService().size());
    System.assertEquals(true, controller.getProvisioning());
    LG_SConsoleProvisionOneDetailsExtension.ProvisioningDetails provDetails = new LG_SConsoleProvisionOneDetailsExtension.ProvisioningDetails(controller.getRecordType(), service[0]);
    System.assertEquals(service.size(), controller.getProvisioningDetails().size());
    
    Asset astObj= [SELECT Id,Name, LG_MACAddress__c FROM Asset WHERE csord__Service__r.Id =:service.get(0).Id];
    //System.assertEquals(astObj.Id, controller.getAsset().Id);
    //controller.ChangeServiceStatusActive();
    //To test jeopardy
    //controller.jeopardy = true;
    //controller.save();

    //controller.jeopardy = false;
    controller.save();
    
    //Making solution obj as null to test exception
    controller.solutionObject = null;
    controller.save();

    Test.stopTest();
         }
  }
}