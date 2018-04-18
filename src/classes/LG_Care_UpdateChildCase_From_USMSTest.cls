@isTest
public class LG_Care_UpdateChildCase_From_USMSTest {
    public static RestRequest req;
    public static RestResponse res;
    public static JSONGenerator createSampleJSON() {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('updateIncident');
        gen.writeStartObject();
        gen.writeStringField('IncidentId', 'INC7777');
        gen.writeStringField('IncidentStatus', 'Critical');
        gen.writeStringField('IncidentEndTime', '2050-09-18T00:07:00+02:00');
        gen.writeStringField('IncidentNotes', 'Testing the incident');
        gen.writeStringField('WorkInfoNotes', 'Ronaldo');
        gen.writeStringField('WorkInfoType', 'Cristiano');
        gen.writeEndObject();
        gen.writeEndObject();
        return gen;
    }
    
    @isTest public static void testMethod1() {
        User careAgent=LG_Care_TestRunAsUser.testRunAs();
        System.runAs(careAgent)
        {
            Case c = new Case();
            try{
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
                JSONGenerator gen = createSampleJSON();
                req = new RestRequest();
                req.requestURI = '/services/apexrest/updatechildcase/';
                req.httpMethod = 'POST';
                req.requestBody = Blob.valueOf(gen.getAsString());
                //req.addParameter('request', gen.getAsString());
                RestContext.request = req;
                RestContext.response = res;
                LG_Care_UpdateChildCase_From_USMS.doPost();
                system.assertEquals(200, res.statusCode);
            }
            
            catch(exception e)
            {
                
            }
        }
    }
}