@isTest
Public Class LG_Care_SendRequest_SBC_Test {
    
    @isTest static void SBCSendRqst(){
        try{
            User careAgent=LG_Care_TestRunAsUser.testRunAs();
            System.runAs(careAgent)  
            {
                List<id> Cid = new List<id>();
                Case c = new Case();
                RecordType rtOutage = [SELECT id,Name FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Mass_Outage_Request_UM'];
                c.RecordTypeId = rtOutage.Id;
                c.USMS_Ticket_ID__c = 'INC2323';
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
                
                B2B_Care_Ext_Connections__c SCon= new B2B_Care_Ext_Connections__c();
                SCon.Name='SBC Spider External System';
                SCon.Authentication_Token__c='@23RKCARE';
                SCon.Brand__c='Unity Media';
                SCon.Connection_URL__c='https://localhost.com/api/outageid';
                SCon.Session_Timeout__c='120000';
                SCon.UM_No_of_Tries__c=3;
                insert SCon;
                
                Cid.add(c.id);
                Test.StartTest();
                Test.setMock(HttpCalloutMock.class, new LG_Care_SBC_MockHttpResponseGenerator());
                LG_Care_SendRequest_SBC.TriggerSpider(Cid);
                
                Test.StopTest();
                
                system.assertNotEquals(null,LG_Care_SendRequest_SBC.res);
            }
        }
        
        catch(DMLException e)
        {
            
        }
    }
    
    
    
}