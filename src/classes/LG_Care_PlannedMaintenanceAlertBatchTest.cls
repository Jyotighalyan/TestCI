@isTest
public class LG_Care_PlannedMaintenanceAlertBatchTest {
    Static testmethod void batchJob_TestMethod() {
         
            User apiUser=LG_Care_TestRunAsUser.getUserAsAdmin();
            System.runAs(apiUser) {
                RecordType rt = [SELECT id,DeveloperName FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Planned_Maintenance_Request_UM'];
                Case c = new Case();
                c.RecordTypeId = rt.id;
                c.Origin = 'Email';
                c.Type = 'Service Down';
                c.LG_Case_Reason__c = 'Node';
                c.Status = 'New';
                c.Description = 'Testing';
                c.LG_Notify_Customers__c = 'Yes';
                Datetime dateTimeInstance = Datetime.now();
                dateTimeInstance = dateTimeInstance.addDays(2);
                c.LG_Estimated_Start_Time__c = dateTimeInstance;
                dateTimeInstance = dateTimeInstance.addDays(3);
                c.LG_Estimated_resolution_time__c = dateTimeInstance;
                c.Priority = 'Escalated';
                Date dateInstance = Date.today();
                c.LG_Mailing_Date__c = dateInstance;
                c.LG_Send_Email_To_Decision_Maker__c = true;
                c.LG_Choose_Specific_Role__c= 'Business User;Financial Contact';
                insert c;
                
                 Case c1 = new Case();
                c1.RecordTypeId = rt.id;
                c1.Origin = 'Email';
                c1.Type = 'Service Down';
                c1.LG_Case_Reason__c = 'Node';
                c1.Status = 'New';
                c1.Description = 'Testing2';
                c1.LG_Notify_Customers__c = 'Yes';
                Datetime dateTimeInstance2 = Datetime.now();
                dateTimeInstance2 = dateTimeInstance2.addDays(2);
                c1.LG_Estimated_Start_Time__c = dateTimeInstance2;
                 dateTimeInstance2 = dateTimeInstance2.addDays(3);
                c1.LG_Estimated_resolution_time__c = dateTimeInstance2;
                c1.Priority = 'Escalated';
                c1.LG_Mailing_Date__c = dateInstance;
                c1.LG_Send_Email_To_Decision_Maker__c = true;
                c1.LG_Choose_Specific_Role__c= 'Business User;Financial Contact';
                c1.LG_Care_USMS_Service__c='HPBX PROD DE';
                insert c1;
                
                Service_Impacted__c li = new Service_Impacted__c();
                li.B2B_Case_Number__c = c.id;
                li.B2B_Street__c = '7 avenue';
                li.B2B_City__c = 'madrid';
                li.B2B_Postcode__c = '761104';
                li.B2B_Service_Id__c = '112245';
                insert li;
                
                Account acc = new Account();
                acc.Name = 'Planned Maintenance Account';
                acc.LG_VisitCountry__c = 'Germany';
                acc.LG_ChamberOfCommerceNumber__c = '7';
                acc.LG_Footprint__c = 'UPC';
                insert acc;
                
                Contact con = new Contact();
                con.Email = 'bubun.abhishek@gmail.com';
                con.LG_DecisionMaker__c = true;
                con.HasOptedOutOfEmail = false;
                con.Salutation ='Mr.';
                con.LastName = 'Mishra';
                con.FirstName = 'Abhisek';
                con.AccountId = acc.Id;
                con.LG_Role__c = 'Business User;Financial Contact';
                insert con;
                
                cscrm__Address__c address = new cscrm__Address__c();
                address.cscrm__Zip_Postal_Code__c = '761104 abc 58';
                address.Name = 'Test Address';
                insert address;
                
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
                service.LG_Address__c = address.id;
                service.Name = 'Hpbx Service';
                service.LG_ServiceStatus__c = 'Active';
                service.csord__Order_Request__c = orderRequest.Id;
                service.csord__Identification__c ='test Identification';
                service.LG_ProductFamily__c='Virtual Voice';
                insert service;
                
                service.LG_ServiceStatus__c = 'Active';
                update service;
                
                csord__Service__c service1 = new csord__Service__c();
                service1.csord__Subscription__c = sub.id;
                service1.LG_ServiceExternalId__c = '112245 ok';
                service1.Name = 'Test Service';
                service1.LG_ServiceStatus__c = 'Active';
                service1.csord__Order_Request__c = orderRequest.Id;
                service1.csord__Identification__c ='test Identification';
                insert service1;
                
                service1.LG_ServiceStatus__c = 'Active';
                update service1;
                /*
                OrgWideEmailAddress owea = new OrgWideEmailAddress();
                owea.IsAllowAllProfiles = true;
                owea.Address = 'noreply_care@unitymedia.de';
                owea.DisplayName = 'Unitymedia Business';*/
                //insert owea;
                
                Test.startTest();
                /*B2B_PlannedMaintenaceAlert_Scheduler sch = new B2B_PlannedMaintenaceAlert_Scheduler();

String jobId = System.schedule('testBasicScheduledApex','0 0 17 10 4 ? 2017', sch);
CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
System.assertEquals('0 0 17 10 4 ? 2017',ct.CronExpression);*/
                LG_Care_PlannedMaintenanceAlert_Batch pma = new LG_Care_PlannedMaintenanceAlert_Batch();
                Database.executeBatch(pma, 2);
                System.assertEquals(0,pma.exceptionMessages.size());
                /*B2B_PlannedMaintenanceAlert_Batch obj = new B2B_PlannedMaintenanceAlert_Batch();
Id batchId = Database.executeBatch(obj);
AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
FROM AsyncApexJob WHERE Id =:sch.batchId];
//system.assertEquals(1 , a.JobItemsProcessed);
System.assertEquals(0 , a.NumberOfErrors);*/
                Test.stopTest();
            }
        
    }
    
    Static testmethod void batchJob_TestMethod2() {
         
            User apiUser=LG_Care_TestRunAsUser.getUserAsAdmin();
            System.runAs(apiUser) {
                RecordType rt = [SELECT id,DeveloperName FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Planned_Maintenance_Request_UM'];
                Case c = new Case();
                c.RecordTypeId = rt.id;
                c.Origin = 'Email';
                c.Type = 'Service Down';
                c.LG_Case_Reason__c = 'Node';
                c.Status = 'New';
                c.Description = 'Testing';
                c.LG_Notify_Customers__c = 'Yes';
                Datetime dateTimeInstance = Datetime.now();
                dateTimeInstance = dateTimeInstance.addDays(2);
                c.LG_Estimated_Start_Time__c = dateTimeInstance;
                dateTimeInstance = dateTimeInstance.addDays(3);
                c.LG_Estimated_resolution_time__c = dateTimeInstance;
                c.Priority = 'Escalated';
                Date dateInstance = Date.today();
                c.LG_Mailing_Date__c = dateInstance;
                c.LG_Send_Email_To_Decision_Maker__c = true;
                c.LG_Choose_Specific_Role__c= 'Business User;Financial Contact';
                insert c;
                
                Service_Impacted__c li = new Service_Impacted__c();
                li.B2B_Case_Number__c = c.id;
                li.B2B_Street__c = '7 avenue';
                li.B2B_City__c = 'madrid';
                li.B2B_Postcode__c = '761104';
                li.LG_Care_House_Number__c = 'CR';
                li.LG_Care_House_Number_Extension__c = 'CR7';
                insert li;
                
                Account acc = new Account();
                acc.Name = 'Planned Maintenance Account';
                acc.LG_VisitCountry__c = 'Germany';
                acc.LG_ChamberOfCommerceNumber__c = '7';
                acc.LG_Footprint__c = 'UPC';
                insert acc;
                
                Contact con = new Contact();
                con.Email = 'bubun.abhishek@gmail.com';
                con.LG_DecisionMaker__c = true;
                con.HasOptedOutOfEmail = false;
                con.Salutation ='Mr.';
                con.LastName = 'Mishra';
                con.FirstName = 'Abhisek';
                con.AccountId = acc.Id;
                con.LG_Role__c = 'Business User;Financial Contact';
                insert con;
                
                cscrm__Address__c address = new cscrm__Address__c();
                address.cscrm__Zip_Postal_Code__c = '761104 abc 58';
                address.Name = 'Test Address';
                insert address;
                
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
                service.LG_Address__c = address.id;
                service.Name = 'Test Service';
                service.LG_ServiceStatus__c = 'Active';
                service.csord__Order_Request__c = orderRequest.Id;
                service.csord__Identification__c ='test Identification';
                insert service;
                
                service.LG_ServiceStatus__c = 'Active';
                update service;
                
                csord__Service__c service1 = new csord__Service__c();
                service1.csord__Subscription__c = sub.id;
                service1.LG_ServiceExternalId__c = '112245 ok';
                service1.Name = 'Test Service';
                service1.LG_ServiceStatus__c = 'Active';
                service1.csord__Order_Request__c = orderRequest.Id;
                service1.csord__Identification__c ='test Identification';
                insert service1;
                
                service1.LG_ServiceStatus__c = 'Active';
                update service1;
                
                
                
                
                /*
                OrgWideEmailAddress owea = new OrgWideEmailAddress();
                owea.IsAllowAllProfiles = true;
                owea.Address = 'noreply_care@unitymedia.de';
                owea.DisplayName = 'Unitymedia Business';*/
                //insert owea;
                
                Test.startTest();
                /*B2B_PlannedMaintenaceAlert_Scheduler sch = new B2B_PlannedMaintenaceAlert_Scheduler();

String jobId = System.schedule('testBasicScheduledApex','0 0 17 10 4 ? 2017', sch);
CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
System.assertEquals('0 0 17 10 4 ? 2017',ct.CronExpression);*/
                LG_Care_PlannedMaintenanceAlert_Batch pma = new LG_Care_PlannedMaintenanceAlert_Batch();
                Database.executeBatch(pma, 1);
                System.assertEquals(0,pma.exceptionMessages.size());
                /*B2B_PlannedMaintenanceAlert_Batch obj = new B2B_PlannedMaintenanceAlert_Batch();
Id batchId = Database.executeBatch(obj);
AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
FROM AsyncApexJob WHERE Id =:sch.batchId];
//system.assertEquals(1 , a.JobItemsProcessed);
System.assertEquals(0 , a.NumberOfErrors);*/
                Test.stopTest();
            }
       
    }
    
    Static testmethod void batchJob_TestMethod3() {
        
            User apiUser=LG_Care_TestRunAsUser.getUserAsAdmin();
            System.runAs(apiUser) {
                RecordType rt = [SELECT id,DeveloperName FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Planned_Maintenance_Request_UM'];
                Case c = new Case();
                c.RecordTypeId = rt.id;
                c.Origin = 'Email';
                c.Type = 'Service Down';
                c.LG_Case_Reason__c = 'Node';
                c.Status = 'New';
                c.Description = 'Testing';
                c.LG_Notify_Customers__c = 'Yes';
                c.LG_Care_USMS_Service__c='HPBX PROD DE';
                Datetime dateTimeInstance = Datetime.now();
                dateTimeInstance = dateTimeInstance.addDays(2);
                c.LG_Estimated_Start_Time__c = dateTimeInstance;
                dateTimeInstance = dateTimeInstance.addDays(3);
                c.LG_Estimated_resolution_time__c = dateTimeInstance;
                c.Priority = 'Escalated';
                Date dateInstance = Date.today();
                c.LG_Mailing_Date__c = dateInstance;
                c.LG_Send_Email_To_Decision_Maker__c = true;
                c.LG_Choose_Specific_Role__c= 'Business User;Financial Contact';
                insert c;
                
                Case c1 = new Case();
                c1.RecordTypeId = rt.id;
                c1.Origin = 'Email';
                c1.Type = 'Service Down';
                c1.LG_Case_Reason__c = 'Node';
                c1.Status = 'New';
                c1.Description = 'Testing';
                c1.LG_Notify_Customers__c = 'Yes';
                Datetime dateTimeInstance2 = Datetime.now();
                dateTimeInstance2 = dateTimeInstance2.addDays(2);
                c1.LG_Estimated_Start_Time__c = dateTimeInstance2;
                 dateTimeInstance2 = dateTimeInstance2.addDays(3);
                c1.LG_Estimated_resolution_time__c = dateTimeInstance2;
                c1.Priority = 'Escalated';
                c1.LG_Mailing_Date__c = dateInstance;
                c1.LG_Send_Email_To_Decision_Maker__c = true;
                c1.LG_Choose_Specific_Role__c= 'Business User;Financial Contact';
                insert c1;
                
               
                Account acc = new Account();
                acc.Name = 'Planned Maintenance Account3';
                acc.LG_VisitCountry__c = 'Germany';
                acc.LG_ChamberOfCommerceNumber__c = '7';
                acc.LG_Footprint__c = 'UPC';
                insert acc;
                
                Contact con = new Contact();
                con.Email = 'rishi.kapoor@infosys.com';
                con.LG_DecisionMaker__c = true;
                con.HasOptedOutOfEmail = false;
                con.Salutation ='Mr.';
                con.LastName = 'Kapoor';
                con.FirstName = 'Rishi';
                con.AccountId = acc.Id;
                con.LG_Role__c = 'Business User;Financial Contact';
                insert con;
                
                Contact con2 = new Contact();
                con2.Email = 'abhisek.mishra@infosys.com';
                con2.LG_DecisionMaker__c = true;
                con2.HasOptedOutOfEmail = false;
                con2.Salutation ='Mr.';
                con2.LastName = 'Mishra';
                con2.FirstName = 'Abhisek';
                con2.AccountId = acc.Id;
                con2.LG_Role__c = 'Business User;Financial Contact';
                insert con2;
                 
                Service_Impacted__c li = new Service_Impacted__c();
                li.B2B_Case_Number__c = c1.id;
                li.B2B_Street__c = '7 avenue2';
                li.B2B_City__c = 'madrid2';
                li.B2B_Postcode__c = '7611042';
                li.LG_Care_House_Number__c = 'CR7';
                li.LG_Care_House_Number_Extension__c = 'CR1';
                insert li;
                
                
                cscrm__Address__c address = new cscrm__Address__c();
                address.cscrm__Zip_Postal_Code__c = '761104 abc 58';
                address.Name = 'Test Address';
                insert address;
                
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
                service.LG_Address__c = address.id;
                service.Name = 'Hpbx Service';
                service.LG_ServiceStatus__c = 'Active';
                service.csord__Order_Request__c = orderRequest.Id;
                service.csord__Identification__c ='test Identification';
                service.LG_ProductFamily__c='Virtual Voice';
                insert service;
                
                service.LG_ServiceStatus__c = 'Active';
                update service;
                
                csord__Service__c service1 = new csord__Service__c();
                service1.csord__Subscription__c = sub.id;
                service1.LG_ServiceExternalId__c = '112245 ok';
                service1.Name = 'Hpbx Service2';
                service1.LG_ServiceStatus__c = 'Active';
                service1.csord__Order_Request__c = orderRequest.Id;
                service1.csord__Identification__c ='test Identification';
                service1.LG_ProductFamily__c='test family';
                insert service1;
                
                service1.LG_ServiceStatus__c = 'Active';
                update service1;
        
                
                Test.startTest();
               
                LG_Care_PlannedMaintenanceAlert_Batch pma = new LG_Care_PlannedMaintenanceAlert_Batch();
                Database.executeBatch(pma, 2);
                System.assertEquals(0,pma.exceptionMessages.size());
               
                Test.stopTest();
            }
        
        
    }
}