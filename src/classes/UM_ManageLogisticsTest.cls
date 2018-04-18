@isTest
public class UM_ManageLogisticsTest {

    @testSetup
  static void setup() {

    No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    noTriggers.Flag__c = true;
    noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
    upsert noTriggers;

    	//Account
        Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);
        
		Opportunity opp = LG_GeneralTest.CreateOpportunity(account, false);
		insert opp;
	
      	//Order
    	csord__Order__c order = new csord__Order__c(Name = 'Test Order', csord__Identification__c = '6465467986');
    	order.csord__Account__c = account.Id;
    	order.csordtelcoa__Opportunity__c = opp.Id;
    	insert order;

    	//product definition
    	cscfga__Product_Definition__c prdConf = new cscfga__Product_Definition__c(Name = 'TestProductDefinition', cscfga__Description__c = 'Description of TestProductDefinition');
    	insert prdConf;

    	//product configuration
    	cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c(cscfga__Attribute_Name__c = 'testAttribute', Name = 'TestProductConfiguration', cscfga__Product_Definition__c = prdConf.Id);
        pc.LG_ProvisionValid__c = 'Yes';
    	insert pc;

		//Billing Account
        csconta__Billing_Account__c bAcc= new csconta__Billing_Account__c(csconta__Account__c= account.ID, csconta__Status__c='New', LG_ContractualOrganization__c='Hessen (HSN)', csconta__Billing_Channel__c='Paper', UM_BillFormatOptions__c='Summary');
		insert bAcc;

    	// Subscripton
    	csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '6465467986',csconta__Billing_Account__c=bAcc.id);
    	insert sub;

        //Address
        cscrm__Address__c address = new cscrm__Address__c();
        address.Name = 'Address Name';
        address.LG_HouseNumberExtension__c = '2nd floor';
        address.LG_HouseNumber__c = '35';
        address.cscrm__Street__c = 'street';
        address.cscrm__City__c = 'city';
        address.cscrm__Country__c = 'country';
        address.cscrm__Zip_Postal_Code__c = 'T1234';
        insert address;


    //Solution
    csord__Solution__c solution = new csord__Solution__c(Name = 'test solution', csord__Identification__c = '6465467986', csord__Order__c = order.Id);
    solution.LG_JeopardyExplanation__c = '';
    solution.LG_Jeopardy__c = false;
    solution.UM_DeliveryCompletionDate__c = null;
    solution.LG_Address__c = address.Id;
    insert solution;

        Site_Survey__c siteSurvey = new Site_Survey__c(Name= 'Site',Date__c = Date.today().addDays(4),Access_Technology__c ='');
        siteSurvey.Address__c = address.Id;
        insert siteSurvey;

    // Service
    csord__Service__c service = new csord__Service__c(csordtelcoa__Product_Configuration__c = pc.Id, Name = 'TestService', csord__Subscription__c = sub.Id, csord__Identification__c = '6465467986', LG_RootOrder__c = order.Id, csord__Activation_Date__c = Date.today());
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
    c.RecordTypeId = [Select Id, SobjectType, Name From RecordType where Name = 'Access Planning'
                      and SobjectType = 'Case'  limit 1].Id;
    insert c;


  }

    public static testMethod void TestCodeCoverage() {
        User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){ 
        Case c = [SELECT Id, LG_Service__c, LG_Solution__c, recordTypeId FROM Case LIMIT 1];
    csord__Solution__c sol = [SELECT Id, Name, LG_Address__c,LG_Address__r.LG_FullAddressDetails__c,
                                LG_Address__r.LG_TechnicalContact__r.Name, csord__Order__c,  csord__Account__c,
                                csord__Order__r.csordtelcoa__Opportunity__c, UM_DeliveryCompletionDate__c,
                                csord__Order__r.csord__Account__c FROM csord__Solution__c LIMIT 1];
    List<csord__Service__c> service = [SELECT Id, Name, csord__Status__c,csordtelcoa__Delta_Status__c,LG_Access_Technology__c,LG_Action__c
                                           FROM csord__Service__c where LG_Suborder__c = :sol.Id];
        List<Site_Survey__c> siteSurveyList = [SELECT Id,Name,Date__c,Access_Technology__c FROM Site_Survey__c WHERE Address__c= :sol.LG_Address__c ORDER BY Date__c Desc];
    Test.startTest();
    PageReference pageRef = Page.UM_ManageLogistics;
    Test.setCurrentPage(pageRef);
    pageRef.getParameters().put('id', c.id);
    UM_ManageLogisticsExtension controller = new UM_ManageLogisticsExtension(new ApexPages.StandardController(c));
        controller.cancel();
        controller.getProvisioningDetails();
        //controller.caseId = c.id;

    System.assertEquals(sol.Id, controller.getSolution().Id);
    System.assertEquals(service[0].Id, controller.getService()[0].Id);
    controller.solutionObject = sol;
    controller.edit();
    controller.Save();
    controller.PageRefresh();
    
    //Check with wrong delivery date
    sol.UM_DeliveryCompletionDate__c = Date.Today()+1;
    update sol;
    controller.Save();

    //SaveSOrder Negative Scenario
    csord__Solution__c solution = new csord__Solution__c();
    controller.solutionObject = solution;
    controller.Save();

    List<Apexpages.Message> msgs = ApexPages.getMessages();
    boolean b = false;
    for(Apexpages.Message msg:msgs){
        if (msg.getDetail().contains('Error updating suborder')) b = true;
    }
    System.assertEquals(true, b);


    Test.stopTest();
         }
    }

}