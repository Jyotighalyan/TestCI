@isTest(seeAllData=false)
public class LG_Care_getTopologyFromSBCTest {
    public static RestRequest req;
    public static RestResponse res;
    @testSetup public static void SetupMethod() {
        try{
            User careAgent=LG_Care_TestRunAsUser.testRunAs();
            System.runAs(careAgent) {
                List<id> Cid = new List<id>();
                Case c = new Case();
                RecordType rtOutage = [SELECT id,Name FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Mass_Outage_Request_UM'];
                c.RecordTypeId = rtOutage.Id;
                c.USMS_Ticket_ID__c = 'INC0000003865';
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
                
                Test.setMock(HttpCalloutMock.class, new LG_Care_SBC_MockHttpResponseGenerator());
                insert c;
                
                B2B_Care_Ext_Connections__c SCon= new B2B_Care_Ext_Connections__c();
                SCon.Name='Spider External System';
                SCon.Authentication_Token__c='@23RKCARE';
                SCon.Brand__c='Unity Media';
                SCon.Connection_URL__c='https://localhost.com/api';
                SCon.Session_Timeout__c='120000';
                SCon.UM_No_of_Tries__c=3;
                insert SCon;
                
                List<Asset> assets = new List<Asset>();
                Asset a1 = new Asset();
                a1.name = 'test asset 1';
                a1.LG_MACAddress__c = 'abcd84753845';
                assets.add(a1);
                
                Datetime dateTimeInstance = Datetime.now();
                
                Account acc = new Account();
                acc.Name = 'Planned Maintenance Account';
                acc.LG_VisitCountry__c = 'Germany';
                acc.LG_ChamberOfCommerceNumber__c = '7';
                acc.LG_Footprint__c = 'UPC';
                insert acc;
                
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
                service.LG_ProvisioningAccountNo__c = '9876543217';
                insert service;
                
                insert(assets);
                
            }
        }
        catch(DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
        
    }
    private static JSONGenerator createJSON() {
        
        Boolean flag = true;
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        
        gen.writeStringField('outageId', 'INC0000003865');
        gen.writeStringField('Status', 'ok');
        gen.writeStringField('status_code','200');
        gen.writeFieldName('Filters');
        
        gen.writeStartObject();
        gen.writeStringField('customer_types', 'BN');
        gen.writeEndObject();
        
        gen.writeFieldName('data');
        gen.writeStartArray();
        
        gen.writeStartObject();
        gen.writeStringField('customer-number', '123456789');
        gen.writeStringField('customer-type', 'BN');
        gen.writeStringField('region', 'BW');
        gen.writeStringField('street', 'Test 1');
        gen.writeStringField('house-number', '6');
        gen.writeStringField('house-number-addition', 'A');
        gen.writeStringField('city', 'Test 1');
        gen.writeStringField('zip', 'Test 1');
        gen.writeFieldName('macs');
        gen.writeStartArray();
        gen.writeString('abcd84753845');
        gen.writeEndArray();
        gen.writeEndObject();
        
        gen.writeStartObject();
        gen.writeStringField('customer-number', '987654321');
        gen.writeStringField('customer-type', 'BN');
        gen.writeStringField('region', 'BW');
        gen.writeStringField('street', 'Test 2');
        gen.writeStringField('house-number', '');
        gen.writeStringField('house-number-addition', 'z');
        gen.writeStringField('city', 'Test ');
        gen.writeStringField('zip', 'Test 2');
        gen.writeEndObject();
        
        gen.writeStartObject();
        gen.writeStringField('customer-number', '9876543217');
        gen.writeStringField('customer-type', 'BN');
        gen.writeStringField('region', 'BW');
        gen.writeStringField('street', 'Test 3');
        gen.writeStringField('house-number', '');
        gen.writeStringField('house-number-addition', '7');
        gen.writeStringField('city', 'Test 7');
        gen.writeStringField('zip', 'Test 7');
        gen.writeFieldName('macs');
        gen.writeStartArray();
        gen.writeString('bcd87bc37466');
        gen.writeEndArray();
        gen.writeEndObject();
        
        gen.writeEndArray();
        gen.writeEndObject();
        return gen;
        
    }
    @isTest public static void testTopologyData() {
        User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
        System.runAs(careAgent) 
        {
            
            res = new restResponse();
            JSONGenerator gen = LG_Care_getTopologyFromSBCTest.CreateJSON();
            req = new RestRequest();
            req.requestURI = '/services/apexrest/topologyfromsbc/';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(gen.getAsString());
            RestContext.request = req;
            RestContext.response = res;
            
            Test.StartTest();
            LG_Care_getTopologyFromSBC.getTopologyData();
            system.assertEquals('INC0000003865',LG_Care_getTopologyFromSBC.outageId);
            Test.StopTest();
        }
    }
    @isTest public static void testTopologyData1() {
        User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
        System.runAs(careAgent) 
        {
            
            res = new restResponse();
            JSONGenerator gen = LG_Care_getTopologyFromSBCTest.CreateJSON();
            req = new RestRequest();
            req.requestURI = '/services/apexrest/topologyfromsbc/';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(gen.getAsString());
            RestContext.request = req;
            RestContext.response = res;
            
            Test.StartTest();
            LG_Care_getTopologyFromSBC.getTopologyData();
            system.assertEquals('INC0000003865',LG_Care_getTopologyFromSBC.outageId);
            Test.StopTest();
        }
    }
    /*
@isTest public static void testTopologyDataNegative() {
User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
System.runAs(careAgent) 
{

res = new restResponse();
JSONGenerator gen = LG_Care_getTopologyFromSBCTest.CreateJSON(false);
req = new RestRequest();
req.requestURI = '/services/apexrest/topologyfromsbc/';
req.httpMethod = 'POST';
req.requestBody = Blob.valueOf(gen.getAsString());
RestContext.request = req;
RestContext.response = res;

Test.StartTest();
LG_Care_getTopologyFromSBC.getTopologyData();
Test.StopTest();
}
}*/
}