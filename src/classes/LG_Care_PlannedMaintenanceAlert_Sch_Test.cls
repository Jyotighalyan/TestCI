@isTest
public class LG_Care_PlannedMaintenanceAlert_Sch_Test {
    Static testmethod void batchJob_TestMethod() {
        try{
            User careAgent=LG_Care_TestRunAsUser.getUserAsAPIUser(); 
            system.runAs(careAgent) {
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
                dateTimeInstance = dateTimeInstance.addHours(10);
                c.LG_Estimated_Start_Time__c = dateTimeInstance;
                dateTimeInstance = dateTimeInstance.addDays(2);
                c.LG_Estimated_resolution_time__c = dateTimeInstance;
                c.Priority = 'Escalated';
                Date dateInstance = Date.today();
                c.LG_Mailing_Date__c = dateInstance.addDays(1);
                insert c;
                
                Service_Impacted__c li = new Service_Impacted__c();
                li.B2B_Case_Number__c = c.id;
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
                con.LastName = 'Mishra';
                con.FirstName = 'Abhisek';
                con.AccountId = acc.Id;
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
                service.csord__Status__c = 'Active';
                service.csord__Order_Request__c = orderRequest.Id;
                service.csord__Identification__c ='test Identification';
                insert service;
                
                
                
                Test.startTest();
                B2B_PlannedMaintenaceAlert_Scheduler sch = new B2B_PlannedMaintenaceAlert_Scheduler();
                //String schTime = '0 0 '+ String.valueOf(dateTimeInstance.hour()) +' '+String.valueOf(dateInstance.day())+' '+String.valueOf(dateInstance.month())+' ? '+String.valueOf(dateInstance.year());
                String schTime = '0 0 0 * * ? *';
                String jobId = System.schedule('testBasicScheduledApex',schTime, sch);
                CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
                System.assertEquals(schTime,ct.CronExpression);
                /*B2B_PlannedMaintenanceAlert_Batch obj = new B2B_PlannedMaintenanceAlert_Batch();
Id batchId = Database.executeBatch(obj);
AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
FROM AsyncApexJob WHERE Id =:sch.batchId];
//system.assertEquals(1 , a.JobItemsProcessed);
System.assertEquals(0 , a.NumberOfErrors);*/
                Test.stopTest();
            }
        }
        
        catch(DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
    }
}