/*`Test class for UM_getOpenWorkOrders
* @author Ankur Gupta
* @ticket SFOM-2297
* @since  13/12/2017
*/
@istest
public class UM_getOpenWorkOrdersTest{
    
    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        Account acc = LG_GeneralTest.CreateAccount('AccountSFDT', '12345678', 'Ziggo', true);
        
        csconta__Billing_Account__c billingAcc = LG_GeneralTest.createBillingAccount('SFDT-59 Bill1', acc.Id, true, true);
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, true);
        
        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert coreq;
        
        csord__Order__c  order = LG_GeneralTest.createOrder('Company Internet',acc,'In Progress',coreq, opp, true);
        
        csord__Solution__c sol = new csord__Solution__c();
        sol.Name = 'UM Company Internet - 6912173';
        sol.csord__Account__c = acc.id;
        sol.csord__Order__c   = order.id;
        sol.csord__Status__c  = 'In Progress';
        sol.LG_Integration_Status__c = 'Work Order Created';
        sol.csord__Identification__c = 'UM Company Internet - 6912173';
        sol.csord__Order_Request__c  = coreq.id;
        sol.LG_TargetDate__c           = System.today();
        sol.LG_InstallationWishDate__c = System.today()+10;
        sol.LG_Provisioning_External_Id__c= '123';
        insert sol;
        
        cscrm__Address__c address = LG_GeneralTest.crateAddress('TestAddress', 'street', 'city', '5', '73', '2014GC', 'Netherlands', acc, true);
        
        csord__Subscription__c subscription = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = coreq.Id);
        subscription.LG_Address__c      = address.Id;
        subscription.csord__Account__c  = acc.Id;
        subscription.csord__Order__c    = order.Id;
        subscription.csord__Solution__c = sol.Id;
        subscription.csconta__Billing_Account__c = billingAcc.id;
        insert subscription;
        
        csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestService', csord__Subscription__c = subscription.Id, csord__Order_Request__c = coreq.Id);
        service.LG_Address__c = address.Id;
        service.LG_Suborder__c= sol.id;
        insert service;
        
        LG_ScheduleAppointment__c app = new LG_ScheduleAppointment__c();
        app.LG_AgreedInstallDate__c = System.today();
        app.Name ='Appointment '+ sol.Name;
        app.LG_Status__c = 'Scheduled';
        app.LG_Solution__c = sol.id;
        insert app;
        
        csord__Solution__c sol2 = new csord__Solution__c();
        sol2.Name = 'UM Company Internet - 6912174';
        sol2.csord__Account__c = acc.id;
        sol2.csord__Order__c   = order.id;
        sol2.csord__Status__c  = 'In Progress';
        sol2.LG_Integration_Status__c = 'Work Order Created';
        sol2.csord__Identification__c = 'UM Company Internet - 6912173';
        sol2.csord__Order_Request__c  = coreq.id;
        sol2.LG_TargetDate__c           = System.today();
        sol2.LG_InstallationWishDate__c = System.today()+10;
        sol2.LG_Provisioning_External_Id__c= '123';
        insert sol2;
        
        csord__Subscription__c subscription2 = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = coreq.Id);
        subscription2.LG_Address__c      = address.Id;
        subscription2.csord__Account__c  = acc.Id;
        subscription2.csord__Order__c    = order.Id;
        subscription2.csord__Solution__c = sol2.Id;
        insert subscription2;
        
        csord__Service__c service2 = new csord__Service__c(csord__Identification__c = 'TestService2', csord__Subscription__c = subscription.Id, csord__Order_Request__c = coreq.Id);
        service2.LG_Address__c = address.Id;
        service2.LG_Suborder__c= sol.id;
        insert service2;
        
        LG_ScheduleAppointment__c app2 = new LG_ScheduleAppointment__c();
        app2.LG_AgreedInstallDate__c = null;
        app2.Name ='Appointment '+ sol.Name;
        app2.LG_Status__c = 'Scheduled';
        app2.LG_Solution__c = sol2.id;
        insert app2;
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    
    @isTest static void  testOpenWorkOrderSuccess()
    { 
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/UM_getOpenWorkOrders/'; 
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        UM_getOpenWorkOrders.ResponseWrapper response = new UM_getOpenWorkOrders.ResponseWrapper();
        response = UM_getOpenWorkOrders.getOpenOrders();
        Test.stopTest();
        
        System.assertEquals('Success', response.status);
        System.assertEquals('Success', response.statusMessage);
        System.assertEquals(2, response.workOrder.size());
    }
    
    @isTest static void  testOpenWorkOrderFailure()
    { 
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/UM_getOpenWorkOrders/'; 
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response = res;
        
        List<csord__solution__c> solutionList = new List<csord__solution__c>();
        for(csord__solution__c solution : [SELECT LG_Integration_Status__c FROM csord__solution__c WHERE Name LIKE 'UM Company Internet%'])
        {
            solution.LG_Integration_Status__c = 'Installation Complete';
            solutionList.add(solution);
        }
        update solutionList;
        
        Test.startTest();
        UM_getOpenWorkOrders.ResponseWrapper response = new UM_getOpenWorkOrders.ResponseWrapper();
        response = UM_getOpenWorkOrders.getOpenOrders();
        Test.stopTest();
        
        System.assertEquals('Failure', response.status);
        System.assertEquals('Failure', response.statusMessage);
        System.assertEquals(null, response.workOrder);
    }
}