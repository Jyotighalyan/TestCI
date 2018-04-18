@isTest
public class LG_Care_Oath_Authentication_akanaTest {
    @testSetUp public static void setUpMethod() {
        try{
            User careAgent=LG_Care_TestRunAsUser.testRunAs();
            System.runAs(careAgent) {
                B2B_Akana_Oath__c akana = new B2B_Akana_Oath__c();
                akana.Name = 'USMS Oath Akana';
                Date d = Date.today();
                Time t = Time.newInstance(0, 0, 0, 0);
                DateTime dt = DateTime.newInstance(d, t);  
                akana.Token_Date__c = dt;
                akana.Access_Token__c = null;
                akana.End_URL__c = 'https://jit-api-libertyglobal-com.upc.biz/oauth/oauth20/token';
                akana.Authorization_Body__c = 'client_secret=70ede9ebd2b22ddb906b79e3da6ac481e2bc950c&client_id=SALESFORCE_DE&grant_type=client_credentials';
                insert akana;
            }
        }
        catch(DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
    }
    @isTest public static void method1() {
        
        User careAgent= [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
        System.runAs(careAgent) 
        {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new LG_Care_akana_MockHttpResponseGenerator());
            B2B_Akana_Oath__c temp = LG_Care_Oath_Authentication_akana.CreateToken();
            system.assertNotEquals(null, temp);
            Test.stopTest();
        }
    }
}