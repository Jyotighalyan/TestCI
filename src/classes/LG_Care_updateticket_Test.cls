@isTest
private class LG_Care_updateticket_Test{
    @isTest static void testCallout() {
        try{
            User us=LG_Care_TestRunAsUser.testRunAs();
            System.runAs(us)
            {
                RecordType rt = [SELECT id,DeveloperName FROM RecordType WHERE DeveloperName = 'LG_B2B_CaMa_Ticket_Request_UM'];
                Case camaCase = new Case();
                camaCase.RecordTypeId = rt.Id;
                camaCase.B2B_Region__c = 'NRW';
                camaCase.B2B_Customer_Number__c = '00009';
                camaCase.B2B_Outage_Service__c = 'Testing back';
                camaCase.B2B_Order_Type__c = 'S2B';
                camaCase.B2B_Problem_Code__c = 'H1';
                camaCase.B2B_Source_Code__c = '02';
                camaCase.B2B_Outage_Type__c = 'Failure';
                camaCase.B2B_Ticket_Priority__c = '1';
                camaCase.B2B_Order_Remarks__c = 'Testing';
                camaCase.B2B_Order_Comment__c = 'Testing';
                camaCase.CaMa_Ticket_ID__c = '1902';
                camaCase.B2B_Success__c = false;
                camaCase.B2B_Account_Name__c = 'Demo Account';
                
                insert camaCase;  
                
                Case c =[ select CaseNumber from case limit 1];
                
                String s = '<bulkUpdate>'+
                    '<ticket>'+
                    '<CaseID>'+c.CaseNumber+'</CaseID>'+
                    '<OrderNumber>7654321</OrderNumber>'+
                    '<completionStatus>C</completionStatus>'+
                    '<orderStatus>CN</orderStatus>'+
                    '<technicianId>12345</technicianId>'+
                    '<technicianName>Dhoni</technicianName>'+
                    '<macAddress>08-00-27-00-F8-BA</macAddress>'+
                    '<faultCode>09</faultCode>'+
                    '<findingCode>03</findingCode>'+
                    '<solutionCode>23</solutionCode>'+
                    '<positionComment>Just a Dhoni Test</positionComment>'+
                    '<completionDate>20170623</completionDate>'+
                    '<completionTime>1543</completionTime>'+
                    '<notDoneCode>01</notDoneCode>'+
                    '<cancellationCode>01</cancellationCode>'+
                    '<errorCode>100000002</errorCode>'+
                    '<errorMessage>Unknown error occurred</errorMessage>'+
                    '</ticket>'+
                    '</bulkUpdate>';
                
                XmlStreamReader reader = new XmlStreamReader(s);
                RestRequest req = new RestRequest(); 
                RestResponse res = new RestResponse();
                system.debug('@#2'+ reader);
                req.requestURI = '/services/apexrest/updateticket/';  //Request URL
                req.httpMethod = 'POST';//HTTP Request Type
                req.requestBody = Blob.valueof(s);
                system.debug('@#3'+ req.requestBody );
                RestContext.request = req;
                RestContext.response= res;
                
                Test.startTest();
                LG_Care_updateticket.doPost();
                Test.stopTest();
                
                System.assertEquals(200, res.statusCode);
                
            }
            
        }
        catch(exception e)
        {}
        
    } 
}