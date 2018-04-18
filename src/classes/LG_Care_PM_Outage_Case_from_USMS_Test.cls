@isTest
public class LG_Care_PM_Outage_Case_from_USMS_Test {
    public static RestRequest req;
    public static RestResponse res;
    
    @testSetUp static void setUpMethod() {
        User careAgent=LG_Care_TestRunAsUser.testRunAs();
        System.RunAs(careAgent) {
            No_Triggers__c noTriggers = new No_Triggers__c();
            noTriggers.setUpOwnerId = UserInfo.getUserId();
            noTriggers.Flag__c = true;
            insert noTriggers;
            
            system.debug(noTriggers);
        }
    }
    
    private static JSONGenerator createJSON(String type, Integer switchType, String serviceType) {
        Boolean flag = true;
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        if(type.equalsIgnoreCase('insert')) {
            gen.writeFieldName('setIncident');
            gen.writeStartObject();
            gen.writeStringField('Action','insert');
            if(serviceType == 'B2B VPN DE PROD') {
                gen.writeStringField('service',serviceType);
                gen.writeStringField('Impacted_service_ids','112233');
                gen.writeStringField('Impacted_equipment_ids','112233mac,112233mac2');
                
            }
        }
        else if(type.equalsIgnoreCase('update') || type.equalsIgnoreCase('delete')) {
            gen.writeFieldName('updateIncident');
            gen.writeStartObject();
            if(type.equalsIgnoreCase('update')) {
                gen.writeStringField('Action','update');
            }
            else if(type.equalsIgnoreCase('delete')) {
                gen.writeStringField('Action','delete');
                flag = false;
            }
        }
        if(switchType == 1) {
            gen.writeStringField('Outage_id','CRQ7777');
        }
        else if(switchType == 2) {
            gen.writeStringField('Outage_id','INC7777');
        }
        if(flag) {
            gen.writeStringField('Description','testing');
            gen.writeStringField('Estimated_start_time','2050-09-18T00:07:00+02:00');
            gen.writeStringField('Estimated_end_time','2051-06-18T00:07:00+02:00');
            gen.writeStringField('Priority','Critical');
            gen.writeStringField('Status','Scheduled');
            gen.writeStringField('Element_id','Element_idTest');
            gen.writeStringField('affected_services','affected_servicesTest');
            //gen.writeStringField('service','Not BDS');
        }
        gen.writeEndObject();
        gen.writeEndObject();
        return gen;
    }
    
    @isTest public static void recordCreation() {
        User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
        System.runAs(careAgent) 
        {
            res = new restResponse();
            JSONGenerator gen = LG_Care_PM_Outage_Case_from_USMS_Test.createJSON('insert',1,'');
            req = new RestRequest();
            req.requestURI = '/services/apexrest/ticketinsalesforce/';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(gen.getAsString());
            //req.addParameter('request', gen.getAsString());
            RestContext.request = req;
            RestContext.response = res;
            LG_Care_PM_Outage_Case_from_USMS.create_Update_Case();
            system.assertEquals(200, res.statusCode);
        }
    }
    @isTest public static void recordCreationBDSService() {
        User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
        System.runAs(careAgent) 
        {
            // creating a service
            Datetime dateTimeInstance = Datetime.now();
            csord__Order_Request__c orderRequest = new csord__Order_Request__c();
            orderRequest.Name = 'Test Order Request';
            orderRequest.csord__Module_Name__c = 'Test Module';
            orderRequest.csord__Module_Version__c = 'Test v1.0';
            orderRequest.csord__Process_Status__c = 'Testing';
            orderRequest.csord__Request_DateTime__c = dateTimeInstance;
            insert orderRequest;
            
            Account acc = new Account();
            acc.Name = 'Planned Maintenance Account';
            acc.LG_VisitCountry__c = 'Germany';
            acc.LG_ChamberOfCommerceNumber__c = '7';
            acc.LG_Footprint__c = 'UPC';
            insert acc;
            
            csord__Subscription__c sub = new csord__Subscription__c();
            sub.Name = 'Business Broadband';
            sub.csord__Account__c = acc.id;
            sub.csord__Identification__c = 'Test Identification';
            sub.csord__Order_Request__c = orderRequest.id;
            insert sub;
            
            csord__Service__c service = new csord__Service__c();
            service.csord__Subscription__c = sub.id;
            service.LG_ServiceExternalId__c = '112245 testing';
            //service.LG_Address__c = address.id;
            service.Name = 'Test Service';
            service.LG_ServiceStatus__c = 'Active';
            service.csord__Order_Request__c = orderRequest.Id;
            service.csord__Identification__c ='test Identification';
            service.UM_ProvisioningServiceExternalId__c='112233';
            insert service;
                        
            Asset a = new Asset();
            a.name = 'hardware';
            a.AccountId = acc.Id;
            a.LG_MACAddress__c = '112233mac';
            a.csord__Service__c = service.Id;
            insert a;
            
            res = new restResponse();
            JSONGenerator gen = LG_Care_PM_Outage_Case_from_USMS_Test.createJSON('insert',1,'B2B VPN DE PROD');
            req = new RestRequest();
            req.requestURI = '/services/apexrest/ticketinsalesforce/';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(gen.getAsString());
            //req.addParameter('request', gen.getAsString());
            RestContext.request = req;
            RestContext.response = res;
            LG_Care_PM_Outage_Case_from_USMS.create_Update_Case();
            system.assertEquals(200, res.statusCode);
        }
    }
    @isTest public static void recordUpdation() {
        try{
            User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
            System.runAs(careAgent) {
                Case c = new Case();
                RecordType rtOutage = [SELECT id,Name FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Mass_Outage_Request_UM'];
                c.RecordTypeId = rtOutage.Id;
                c.USMS_Ticket_ID__c = 'INC7777';
                c.Description = 'test';
                DateTime dt = Datetime.now();
                dt = dt.addDays(1);
                c.LG_Estimated_Start_Time__c = dt;
                c.LG_Estimated_resolution_time__c = dt.addDays(1);
                c.priority = 'Escalated';
                c.status = 'Critical';
                c.B2B_Care_Element_Id__c = 'Element Ids';
                c.B2B_Care_Affected_Services__c = 'Affected Services';
                c.B2B_Care_Created_Ticket_From_USMS__c = true;
                insert c;
                
                res = new restResponse();
                
                JSONGenerator gen = LG_Care_PM_Outage_Case_from_USMS_Test.createJSON('update',2,'');
                req = new RestRequest();
                req.requestURI = '/services/apexrest/ticketinsalesforce/';
                req.httpMethod = 'POST';
                req.requestBody = Blob.valueOf(gen.getAsString());
                //req.addParameter('request', gen.getAsString());
                RestContext.request = req;
                RestContext.response = res;
                LG_Care_PM_Outage_Case_from_USMS.create_Update_Case();
                system.assertEquals(200, res.statusCode);
            }
        }
        catch(exception e)
        {
            
        }
    }
    @isTest public static void recordDeletion() {
        try{
            User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
            System.runAs(careAgent) {
                Case c = new Case();
                RecordType rtOutage = [SELECT id,Name FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Mass_Outage_Request_UM'];
                c.RecordTypeId = rtOutage.Id;
                c.USMS_Ticket_ID__c = 'INC7777';
                c.Description = 'test';
                DateTime dt = Datetime.now();
                dt = dt.addDays(1);
                c.LG_Estimated_Start_Time__c = dt;
                c.LG_Estimated_resolution_time__c = dt.addDays(1);
                c.priority = 'Escalated';
                c.status = 'Critical';
                c.B2B_Care_Element_Id__c = 'Element Ids';
                c.B2B_Care_Affected_Services__c = 'Affected Services';
                c.B2B_Care_Created_Ticket_From_USMS__c = true;
                insert c;
                
                
                res = new restResponse();
                
                JSONGenerator gen = LG_Care_PM_Outage_Case_from_USMS_Test.createJSON('delete',2,'');
                req = new RestRequest();
                req.requestURI = '/services/apexrest/ticketinsalesforce/';
                req.httpMethod = 'POST';
                req.requestBody = Blob.valueOf(gen.getAsString());
                //req.addParameter('request', gen.getAsString());
                RestContext.request = req;
                RestContext.response = res;
                LG_Care_PM_Outage_Case_from_USMS.create_Update_Case();
                system.assertEquals(200, res.statusCode);
            }
        }
        catch(exception e){}
    }
}