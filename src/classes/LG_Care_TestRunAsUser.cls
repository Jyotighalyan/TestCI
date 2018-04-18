@isTest(seealldata=false)
public class LG_Care_TestRunAsUser {
    public static testMethod User testRunAs() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='UM_CSR_Profile']; 
        
        User testUser = new User(Alias = 'cAgnt', Email='careAgent@unityMediaorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='UM', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='careagent.testuser@unityMediaorg.com',CompanyName='Infosys');
        Insert testUser;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'UM_Care_Agent'];
        
        
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = testUser.Id;
        psa.PermissionSetId = ps.Id;
        
        insert psa;
        
        
        
        return testUser;
        
    }
    
    public static testMethod User getUserAsAdmin() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User testUser = new User(Alias = 'cAgnt', Email='admin@unityMediaorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='UM', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='admin.testuser@unityMediaorg.com',CompanyName='Infosys');
        Insert testUser;
        
        return testUser;
        
    }
    
    public static testMethod User getUserAsAPIUser() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='UM_API_User']; 
        
        User testUser = new User(Alias = 'cAgnt', Email='apiuser@unityMediaorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='UM', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='apiuser.testuser@unityMediaorg.com',CompanyName='Infosys');
        Insert testUser;
        
        return testUser;
        
    }
    
}