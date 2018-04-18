/************************************************************************************************************************************
*        Class: LG_Care_ServiceImpactedRecord_Batch
*     Program : B2B CARE CATALYST PROGRAM
*  Description: It will create service impacted records for a planned maintenance / outage case by parsing an CSV file.
*    Author(s): Abhisek Mishra (Infosys Limited)
* Created Date: 02-AUG-2017
*   Test Class: LG_Care_ServiceImpactedRecord_Batch_Test
*************************************************************************************************************************************/
global class LG_Care_ServiceImpactedRecord_Batch  implements Database.Batchable<sobject> {
     Static final String fileName = 'Services Impacted.csv';
     Static final String caseRecordType = 'LG_B2B_Care_Planned_Maintenance_Request_UM';
     Case cs = null;
     public String id; 
     Static final String lineFieldHeader1 = 'B2B_Service_Id__c';
     Static final String lineFieldHeader2 = 'B2B_External_case_number__c';
     global LG_Care_ServiceImpactedRecord_Batch(Case c) {
        cs = c;
        id = cs.Id;
     }
     webservice Static void executeBatchMethod (Case c) {
         LG_Care_ServiceImpactedRecord_Batch b = new LG_Care_ServiceImpactedRecord_Batch(c);
         Database.executeBatch(b);
     }
     
     global Database.QueryLocator start(Database.BatchableContext BC) {
     
         String query = 'SELECT Id, Name, Body, parentId FROM Attachment WHERE Name = :fileName AND parentId = :id LIMIT 1';
         return Database.getQueryLocator(query);
            
     }
     global void execute(Database.BatchableContext BC, List<Attachment> listOfObjects) {
         
         try {
             Attachment att =  listOfObjects[0];
             String attBody = att.Body.toString();
             List<String> body = attbody.split('\n');
             Set<String> serviceIds = new Set<String>();
             String extCaseNumber = body[1].split(',')[1].trim();
             List<Service_Impacted__c> siList = new List<Service_Impacted__c>();
             for(integer i=1; i<body.size(); i++) {
                 serviceIds.add(body[i].split(',')[0]);
             }
             List<Service_Impacted__c> siCheck = [SELECT id,B2B_External_case_number__c,B2B_Service_Id__c FROM Service_Impacted__c WHERE B2B_Case_Number__c = :att.parentId  AND B2B_Service_Id__c in :serviceIds AND B2B_External_case_number__c = :extCaseNumber];
             
             Set<String> checkString = new Set<string>();
             if(siCheck != null && siCheck.size() > 0) {
                 for(Service_Impacted__c s : siCheck) {
                     checkString.add(s.B2B_Service_Id__c+s.B2B_External_case_number__c);
                 }
                 
             }
             
             for(integer i=1; i<body.size(); i++) {
                 List<String> lineFields = body[i].split(',');
                 if(!(checkString != null && checkString.size()>0 && checkString.contains(lineFields[0].trim()+lineFields[1].trim()))) {
                     Service_Impacted__c si = new Service_Impacted__c();
                     si.put(lineFieldHeader1, lineFields[0].trim());
                     si.put(lineFieldHeader2, lineFields[1].trim());
                     si.B2B_Case_Number__c = att.parentId;
                     si.RecordTypeId = Schema.SObjectType.Service_Impacted__c.getRecordTypeInfosByName().get('Service Id').getRecordTypeId();
                     si.B2B_Status__c = 'Open';
                     siList.add(si);
                 }
             }
             Database.upsert(siList,false);
         }
         Catch(Exception ex) {
         
         }
         
         
         
     }
     global void finish(Database.BatchableContext BC) {
     }
}