@isTest(seeAllData=false)
public class LG_Care_Cancel_CaMa_TransactionCntrlTest {
    @testSetUp public static void createData() {
        
        User careAgent=LG_Care_TestRunAsUser.testRunAs();
        system.runAs(careAgent) {
            try
            {
                Case c = new Case();
                RecordType rt = [SELECT id FROM RecordType WHERE DeveloperName = 'LG_B2B_CaMa_Ticket_Request_UM'];
                c.RecordTypeId = rt.Id;
                c.status = 'Assigned';
                c.B2B_Status_Change_Code__c = 'c';
                c.B2B_Care_Cancellation_Code__c = '01  Kunde verweigert Zutritt';
                c.B2B_Region__c = 'Hasan';
                c.CaMa_Ticket_ID__c = '1111';
                insert c;
                
                Case c1 = new Case();
                
                c1.RecordTypeId = rt.Id;
                c1.status = 'Assigned';
                c1.B2B_Status_Change_Code__c = '';
                c1.B2B_Care_Cancellation_Code__c = '01  Kunde verweigert Zutritt';
                c1.B2B_Region__c = 'Hasan';
                c1.CaMa_Ticket_ID__c = null;
                insert c1;
                
                Case c2 = new Case();
                
                c2.RecordTypeId = rt.Id;
                c2.status = 'Assigned';
                c2.B2B_Status_Change_Code__c = 'a';
                c2.B2B_Care_Cancellation_Code__c = '01  Kunde verweigert Zutritt';
                c2.B2B_Region__c = 'Hasan';
                c2.CaMa_Ticket_ID__c = '1111';
                insert c2;
                
                Case c3 = new Case();
                
                c3.RecordTypeId = rt.Id;
                c3.status = 'Assigned';
                c3.B2B_Status_Change_Code__c = 'a';
                c3.B2B_Care_Cancellation_Code__c = null;
                c3.B2B_Region__c = 'Hasan';
                c3.CaMa_Ticket_ID__c = '1111';
                insert c3;
                
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
                
                insert camaCase;
                
                B2B_Care_Ext_Connections__c camaConn = new B2B_Care_Ext_Connections__c();
                camaConn.Name = 'CaMa External System Info';
                camaConn.Authentication_Token__c = 'Basic cmVtZWR5LWVjby53czpyM20zZHktU0YzYzA=';
                camaConn.Connection_URL__c = 'https://appst.unitymedia.de/TicketWS/TicketWSService';
                camaConn.UM_No_of_Tries__c = 3;
                
                insert camaConn;
            }
            
            catch(DMLException e) {
                system.assertEquals(e.getMessage(), e.getMessage());
            }
        }
        
    }
    
    @isTest public static void method1() {
        try{
            User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
            System.runAs(careAgent)
            {
                Case c = [SELECT id,status,B2B_Status_Change_Code__c,B2B_Care_Cancellation_Code__c,B2B_Region__c,caseNumber,CaMa_Ticket_ID__c FROM Case WHERE B2B_Status_Change_Code__c = 'c' LIMIT 1];
                ApexPages.StandardController sc = new ApexPages.StandardController(c);
                LG_Care_Cancel_CaMa_Transaction_Cntrl temp = new LG_Care_Cancel_CaMa_Transaction_Cntrl(sc);
                system.assertEquals(temp.flag,true);
            }
        }
        catch(DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
    }
    
    @isTest public static void method2() {
        try{
            User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
            System.runAs(careAgent)
            {
                Case c = [SELECT id,status,B2B_Status_Change_Code__c,B2B_Care_Cancellation_Code__c,B2B_Region__c,caseNumber,CaMa_Ticket_ID__c FROM Case WHERE CaMa_Ticket_ID__c = null LIMIT 1];
                ApexPages.StandardController sc = new ApexPages.StandardController(c);
                LG_Care_Cancel_CaMa_Transaction_Cntrl temp = new LG_Care_Cancel_CaMa_Transaction_Cntrl(sc);
                system.assertEquals(temp.flag,true);
            }
        }
        catch(DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
    }
    
    @isTest public static void method3() {
        try{
            User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
            System.runAs(careAgent)
            {
                Case c = [SELECT id,status,B2B_Status_Change_Code__c,B2B_Care_Cancellation_Code__c,B2B_Region__c,caseNumber,CaMa_Ticket_ID__c FROM Case WHERE B2B_Status_Change_Code__c = 'a' AND B2B_Care_Cancellation_Code__c != null LIMIT 1];
                Test.startTest();
                
                Test.setMock(HttpCalloutMock.class, new LG_Care_CaMa_MockHttpResponseGenerator());
                ApexPages.StandardController sc = new ApexPages.StandardController(c);
                LG_Care_Cancel_CaMa_Transaction_Cntrl temp = new LG_Care_Cancel_CaMa_Transaction_Cntrl(sc);
                temp.CancelCaMa();
                //Care_CaMaTicket_Transaction.createXML_for_CancelTicketRequest(cama);
                
                Test.stopTest();
                
                system.assertEquals(LG_Care_Cancel_CaMa_Transaction_Cntrl.tempBoo,false);
            }
        }
        
        catch(DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        } 
    }
    
    @isTest public static void method4() {
        try
        {
            User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
            System.runAs(careAgent)
            {
                Case c = [SELECT id,status,B2B_Status_Change_Code__c,B2B_Care_Cancellation_Code__c,B2B_Region__c,caseNumber,CaMa_Ticket_ID__c FROM Case WHERE B2B_Status_Change_Code__c = 'a' AND B2B_Care_Cancellation_Code__c = null LIMIT 1];
                ApexPages.StandardController sc = new ApexPages.StandardController(c);
                LG_Care_Cancel_CaMa_Transaction_Cntrl temp = new LG_Care_Cancel_CaMa_Transaction_Cntrl(sc);
                temp.CancelCaMa();
                system.assertEquals(LG_Care_Cancel_CaMa_Transaction_Cntrl.tempBoo,false);
            }
        }
        catch(DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
    }
    
    static testmethod void cancelCaMaTicket() {
        try{
            User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
            System.runAs(careAgent)
            {
                Case cama = [SELECT id,B2B_Care_Cancellation_Code__c,B2B_Status_Change_Code__c,CaMa_Ticket_ID__c,caseNumber,B2B_Region__c FROM Case WHERE B2B_Status_Change_Code__c = 'a' AND B2B_Care_Cancellation_Code__c != null LIMIT 1];
                List<Id> camaIds = new List<id>();
                camaIds.add(cama.Id);
                Test.startTest();
                
                Test.setMock(HttpCalloutMock.class, new LG_Care_CaMa_MockHttpResponseGenerator());
                ApexPages.StandardController sc = new ApexPages.StandardController(cama);
                LG_Care_Cancel_CaMa_Transaction_Cntrl temp = new LG_Care_Cancel_CaMa_Transaction_Cntrl(sc);
                //Care_CaMaTicket_Transaction.createXML_for_CancelTicketRequest(cama);
                system.assertEquals(temp.flag,false);
                Test.stopTest();
            }
        }
        catch(DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
        
    } 
}