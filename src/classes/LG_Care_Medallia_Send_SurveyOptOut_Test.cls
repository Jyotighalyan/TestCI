@isTest(seeAllData=false)
public class LG_Care_Medallia_Send_SurveyOptOut_Test {
    @testSetUp static void setUpMethod() {
        try {
            User careAgent=LG_Care_TestRunAsUser.testRunAs();
            System.runAs(careAgent) {
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
                con.Salutation ='Mr.';
                con.LastName = 'Mishra';
                con.FirstName = 'Abhisek';
                con.AccountId = acc.Id;
                con.LG_Role__c = 'Business User;Financial Contact';
                insert con;
                
                B2B_Care_Ext_Connections__c medConn = new B2B_Care_Ext_Connections__c();
                medConn.name = 'Medallia SurveyOptOut';
                medConn.UM_No_of_Tries__c = 3;
                medConn.Connection_URL__c = 'https://www.google.com';
                insert medConn;
            }
            
        }
        Catch(Exception e) {
            
        }
    }
    static testmethod void sendSurveyOptout() {
        
        User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
        System.runAs(careAgent) {
            
            
            
            Contact con = [SELECT id, LG_Care_Survey_Opt_Out__c FROM Contact LIMIT 1];
            
            Test.startTest();
            
            Test.setMock(HttpCalloutMock.class, new LG_Care_Medallia_Send_SurveyOptout_Mock());
                con.LG_Care_Survey_Opt_Out__c = true;
                update con;
            
            Test.stopTest(); 
        }
        
        
    }

}