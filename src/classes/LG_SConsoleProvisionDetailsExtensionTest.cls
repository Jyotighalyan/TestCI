@isTest
public class LG_SConsoleProvisionDetailsExtensionTest {
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

		//Solution
		csord__Solution__c solution = new csord__Solution__c(Name = 'test solution', csord__Identification__c = '6465467986', csord__Order__c = order.Id);
		solution.LG_JeopardyExplanation__c = '';
		solution.LG_Jeopardy__c = true;
		insert solution;

		//Service
		csord__Service__c service = new csord__Service__c(csordtelcoa__Product_Configuration__c = pc.Id, Name = 'TestService', csord__Subscription__c = sub.Id, csord__Identification__c = '6465467986', csord__Order__c = order.Id, csord__Activation_Date__c = Date.today());
		service.LG_Suborder__c = solution.Id;
        service.LG_ProvisionValid__c = 'Yes';
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
		c.RecordTypeId = [Select Id, SobjectType, Name From RecordType where Name = 'Provision'
		                  and SobjectType = 'Case'  limit 1].Id;
		insert c;
	}
	public static testMethod void TestCodeCoverage() 
	{
		Case c = [select Id, LG_Service__c, LG_Solution__c, recordTypeId from Case LIMIT 1];
		csord__Solution__c sol = [select Id, Name, LG_Jeopardy__c, LG_JeopardyExplanation__c, csord__Order__c from csord__Solution__c LIMIT 1];
		List<csord__Service__c> service = [select Id, csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name,  
                                           LG_ProvisionValid__c,
                                           LG_Product_Category__c
                                           from csord__Service__c where LG_Suborder__c = :sol.Id];
		List<csord__Service_Line_Item__c> sli = [Select Id from csord__Service_Line_Item__c where csord__Service__c = :service.get(0).Id];
		User thisUser=[select id from User where id=:UserInfo.getUserId()];
        System.runAs(thisUser){
            Test.startTest();
    		PageReference pageRef = Page.LG_SConsoleProvisionDetails;
    		Test.setCurrentPage(pageRef);
    		pageRef.getParameters().put('id', c.id);
    		LG_SConsoleProvisionDetailsExtension controller = new LG_SConsoleProvisionDetailsExtension(new ApexPages.StandardController(c));
    		controller.edit();
    		controller.cancel();
    		System.assertEquals(sol.Id, controller.getSolution().Id);
    		System.assertEquals(service.size(), controller.getService().size());
    		System.assertEquals((sli.size()+service.size()), controller.getBillingDetails().size());
    		LG_SConsoleProvisionDetailsExtension.ProvisioningDetails provDetails = new LG_SConsoleProvisionDetailsExtension.ProvisioningDetails(controller.getRecordType(), service[0]);
    		System.assertEquals(service.size(), controller.getProvisioningDetails().size());
    
    		//To test jeopardy
    		controller.jeopardy = true;
    		controller.save();
    
    		controller.jeopardy = false;
    		controller.save();
    
    		//Making solution obj as null to test exception
    		controller.solutionObject = null;
    		controller.save();
            Test.stopTest();
         }
	}

}