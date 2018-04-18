@isTest(seeAllData=false)
public class LG_Care_CaMaTicket_Transaction_Test {
    
    @testSetUp static void setUpMethod() {
    try {
        User careAgent=LG_Care_TestRunAsUser.testRunAs();
        System.runAs(careAgent) {
            RecordType rt = [SELECT id,DeveloperName FROM RecordType WHERE DeveloperName = 'LG_B2B_CaMa_Ticket_Request_UM'];
            Case camaCase = new Case();
            camaCase.RecordTypeId = rt.Id;
            camaCase.B2B_Region__c = 'NRW';
            camaCase.B2B_Customer_Number__c = '12345';
            camaCase.B2B_Outage_Service__c = 'Testing CaMa';
            camaCase.B2B_Order_Type__c = 'S2B';
            camaCase.B2B_Problem_Code__c = 'H1';
            camaCase.B2B_Source_Code__c = '02';
            camaCase.B2B_Outage_Type__c = 'Failure';
            camaCase.B2B_Ticket_Priority__c = '1';
            camaCase.B2B_Order_Remarks__c = 'Testing CAMA';
            camaCase.B2B_Order_Comment__c = 'Testing CAMA';
            camaCase.CaMa_Ticket_ID__c = '1902';
            camaCase.B2B_Success__c = false;
            camaCase.B2B_Account_Name__c = 'Demo Account';
            camacase.B2B_Customer_Situation__c = 'DemoSituation';
            camaCase.B2B_Care_Cancellation_Code__c = '01  Kunde verweigert Zutritt';
            camaCase.UM_Order_Comment_Prior_value__c = '';
            
            insert camaCase;
            
            B2B_Care_Ext_Connections__c camaConn = new B2B_Care_Ext_Connections__c();
            camaConn.Name = 'CaMa External System Info';
            camaConn.Authentication_Token__c = 'Basic cmVtZWR5LWVjby53czpyM20zZHktU0YzYzA=';
            camaConn.Connection_URL__c = 'https://appst.unitymedia.de/TicketWS/TicketWSService';
            camaConn.UM_No_of_Tries__c = 3;
            
            insert camaConn;
        }
        }
        Catch(DMLException e) {
            
        }
        
    }
    
    static testmethod void createCaMaTicket() {
        
        User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
        System.runAs(careAgent) {
            
            
            
            Case cama = [SELECT id,B2B_Region__c,B2B_Customer_Number__c,B2B_Order_Type__c,B2B_Problem_Code__c,B2B_Source_Code__c,B2B_Ticket_Priority__c,B2B_Order_Remarks__c,B2B_Order_Comment__c,B2B_Outage_Service__c,B2B_Outage_Type__c,B2B_Customer_Situation__c FROM Case LIMIT 1];
            
            Test.startTest();
            
            Test.setMock(HttpCalloutMock.class, new LG_Care_CaMa_MockHttpResponseGenerator());
            LG_Care_CaMaTicket_Transaction.createXML_for_CreateTicketRequest(cama);
            system.assertNotEquals(null,LG_Care_CaMaTicket_Transaction.createXml);
            
            
            Test.stopTest(); 
        }
        
        
    }
    
    static testmethod void updateCaMaTicket() {
        User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
        System.runAs(careAgent){
            Case cama = [SELECT id,UM_Order_Comment_Prior_value__c,B2B_Order_Remarks__c,B2B_Care_Cancellation_Code__c,B2B_Status_Change_Code__c,CaMa_Ticket_ID__c,caseNumber,B2B_Region__c FROM Case LIMIT 1];
            
            cama.B2B_Order_Remarks__c = cama.B2B_Order_Remarks__c + ' changed';
            Test.setMock(HttpCalloutMock.class, new LG_Care_CaMa_MockHttpResponseGenerator());
            Test.startTest();
            update cama; 
            //List<Id> camaIds = new List<id>();
            //camaIds.add(cama.Id);
            
            
            
            //LG_Care_CaMaTicket_Transaction.createXML_for_UpdateTicketRequest(camaIds);
            
            //system.assertNotEquals(null,LG_Care_CaMaTicket_Transaction.createXml);
            Test.stopTest();
        }
    }
    
    static testmethod void cancelCaMaTicket() {
        User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
        System.runAs(careAgent){
            Case cama = [SELECT id,B2B_Care_Cancellation_Code__c,B2B_Status_Change_Code__c,CaMa_Ticket_ID__c,caseNumber,B2B_Region__c FROM Case LIMIT 1];
            //User us=LG_Care_TestRunAsUser.testRunAs();
            
            
            
            List<Id> camaIds = new List<id>();
            camaIds.add(cama.Id);
            Test.startTest();
            
            Test.setMock(HttpCalloutMock.class, new LG_Care_CaMa_MockHttpResponseGenerator());
            LG_Care_CaMaTicket_Transaction.createXML_for_CancelTicketRequest(cama);
            system.assertNotEquals(null,LG_Care_CaMaTicket_Transaction.createXml);
            Test.stopTest();
        }
    } 
}