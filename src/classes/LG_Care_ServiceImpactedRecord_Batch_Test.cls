@isTest
public class LG_Care_ServiceImpactedRecord_Batch_Test {
    
    Static testmethod void batchJob_TestMethod() {
        try{
            User careAgent=LG_Care_TestRunAsUser.testRunAs();
            System.runAs(careAgent)
            {
                StaticResource doc = [SELECT id,body FROM StaticResource WHERE name = 'Service_Impacted_Test' LIMIT 1];
                
                RecordType rt = [SELECT id,DeveloperName FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Planned_Maintenance_Request_UM'];
                Case c = new Case();
                c.RecordTypeId = rt.Id;
                c.type = 'Service Down';
                c.LG_Case_Reason__c = 'Node';
                c.Description = 'Testing';
                c.LG_Estimated_Start_Time__c = DateTime.now().addDays(1);
                c.LG_Estimated_resolution_time__c = DateTime.now().addDays(2);
                insert c;
                
                Attachment att = new Attachment();
                att.Body = doc.Body;
                att.Name = 'Services Impacted.csv';
                att.ContentType = 'csv';
                att.parentId = c.Id;
                insert att;
                
                
                
                Test.startTest();
                LG_Care_ServiceImpactedRecord_Batch b = new LG_Care_ServiceImpactedRecord_Batch(c);
                LG_Care_ServiceImpactedRecord_Batch.executeBatchMethod(c);
                system.assertNotEquals(null,b.id);
                Test.stopTest();
                //List<SObject> silist = Test.loadData(Service_Impacted__c.sObjectType,'Service_Impacted_Test');
            }
        }
        
        catch(DMLexception e){
        }
    }
}