@isTest
public class SendDataToULM_Test {

    public static Account acc;
    public static Contact con;

    public static testmethod void setupTestData(){
    
    acc = new Account(Name = 'Test Acc');
	insert acc;
    String ulmUserId = 'test@test.com';
    
    con = new Contact(firstname = 'Ram', lastname = 'Reddy', Salutation ='Mr.', MobilePhone = '1234567890', account = acc, B2B_ULM_User_Id__c = 'test@test.com', Phone = '44087267557');
	insert con;
    
        
    B2B_Akana_Oath__c akana = new B2B_Akana_Oath__c();
                akana.Name = 'USMS Oath Akana';
                //Date d = Date.today();
                //Time t = Time.newInstance(0, 0, 0, 0);
                //DateTime dt = DateTime.newInstance(d, t);  
                //akana.Token_Date__c = dt;
                akana.Access_Token__c = null;
                akana.End_URL__c = 'https://jit-api-libertyglobal-com.upc.biz/oauth/oauth20/token';
                akana.Authorization_Body__c = 'client_secret=70ede9ebd2b22ddb906b79e3da6ac481e2bc950c&client_id=SALESFORCE_DE&grant_type=client_credentials';
        		 
        insert akana;   
        B2B_Care_Ext_Connections__c connect = new B2B_Care_Ext_Connections__c();
        connect.Name = 'Self Care Contact Sync';
        connect.Connection_URL__c = 'www.google.com';  
        insert connect;
    //B2B_Akana_Oath__c temp = LG_Care_Oath_Authentication_akana.CreateToken();
	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Integer res = SendDataToULM.sendData(ulmUserId);
      Test.stopTest();  
        // Verify response received contains fake values
       /* String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"example":"test"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    /*test.startTest();
    RestRequest request = new RestRequest();
    RestResponse res = new RestResponse();
    //request.setEndpoint('https://10.20.35.123:8081/platform/rest/v60/external/user/byusername/ulmUserId/event');
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{ulmUserId" : "ulmUserId"}');
        RestContext.request = request;
      	RestContext.response = res;
    
    SendDataToULM.sendData(ulmUserId);
    test.stopTest();*/
    }
}