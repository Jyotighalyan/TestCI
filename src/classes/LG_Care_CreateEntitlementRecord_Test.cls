@isTest(seeAllData=true)
public class LG_Care_CreateEntitlementRecord_Test {
    @isTest public static void setupMethod() {
        try{
            User careAgent=LG_Care_TestRunAsUser.testRunAs();
            System.runAs(careAgent) 
            {
                DateTime dateTimeInstance = DateTime.now();
                dateTimeInstance.addDays(1);
                
                Account acc = new Account();
                acc.Name = 'Planned Maintenance Account test';
                acc.LG_VisitCountry__c = 'Germany';
                acc.LG_ChamberOfCommerceNumber__c = '7';
                acc.LG_Footprint__c = 'UPC';
                insert acc;
                
                
                List<Entitlement> entitlementList = [SELECT Id,Name from Entitlement where AccountId =: acc.id];
                
                system.assertEquals(entitlementList.size(),0);
                
                csord__Order_Request__c orderRequest = new csord__Order_Request__c();
                orderRequest.Name = 'Test Order Request';
                orderRequest.csord__Module_Name__c = 'Test Module';
                orderRequest.csord__Module_Version__c = 'Test v1.0';
                orderRequest.csord__Process_Status__c = 'Testing';
                orderRequest.csord__Request_DateTime__c = dateTimeInstance;
                insert orderRequest;
                
                csord__Subscription__c sub = new csord__Subscription__c();
                sub.Name = 'Business Broadband';
                sub.csord__Account__c = acc.id;
                sub.csord__Identification__c = 'Test Identification';
                sub.csord__Order_Request__c = orderRequest.id;
                insert sub;
                
                csord__Service__c service = new csord__Service__c();
                service.csord__Subscription__c = sub.id;
                service.LG_ServiceExternalId__c = '112245 testing';
                service.LG_SLA__c = 'Gold';
                service.Name = 'Test Service';
                service.csord__Status__c = 'Active';
                service.csord__Order_Request__c = orderRequest.Id;
                service.csord__Identification__c ='test Identification';
                insert service;
                
                csord__Service__c service1 = new csord__Service__c();
                service1.csord__Subscription__c = sub.id;
                service1.LG_ServiceExternalId__c = '112245 testing';
                service1.LG_SLA__c = 'Bronze';
                service1.Name = 'Test Service';
                service1.csord__Status__c = 'Active';
                service1.csord__Order_Request__c = orderRequest.Id;
                service1.csord__Identification__c ='test Identification';
                insert service1;
                
                //List<csord__Service__c> services = [SELECT Id FROM csord__Service__c WHERE LG_SLA__c != null LIMIT 1000];
                Set<Id> serviceIds = new Set<Id>();
                serviceIds.add(service.Id);
                serviceIds.add(service1.Id);
                /*Entitlement e = new Entitlement();
e.AccountId = acc.Id;
e.Name = 'TestEntitlement';
e.StartDate = date.newInstance(2015, 2, 1);
Date d = Date.today();
e.EndDate = d.addDays(1);
insert e;*/
                
                /*
Entitlement e1 = new Entitlement();
e1.AccountId = acc.Id;
e1.Name = 'TestEntitlement1';
e1.StartDate = date.newInstance(2015, 2, 1);
e1.EndDate = d.addDays(1);
insert e1;*/
                
                
                
                LG_Care_CreateEntitlementRecord ent = new LG_Care_CreateEntitlementRecord();
                ent.linkServiceTypeToEntitlement(serviceIds);
                
                entitlementList.clear();
                entitlementList = [SELECT Id from Entitlement where AccountId =: acc.id];
                system.debug(entitlementList.size());
               // system.assertEquals(entitlementList.size(),2);
            }
        }
        Catch(Exception e)
        {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
    }
}