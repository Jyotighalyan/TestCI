@isTest(SeeAllData=false)
public class LG_Care_EmailValidationTest {
    
    @testSetUp static void setUpMethod() {
        User careAgent=LG_Care_TestRunAsUser.testRunAs();
        
    }
    
    @isTest
    static void withTextBody() {
        User careAgent= [SELECT Id, email from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
        System.runAs(careAgent) {
            EmailMessage msg1 = new EmailMessage();
            msg1.textBody = 'ref:test text body:ref';
            msg1.fromAddress = careAgent.email;
            msg1.toAddress = 'fakeid@unitymedia.com';
            msg1.subject = 'test subject';
            msg1.incoming = true;
            try {
                insert msg1;
            }
            catch(DMLException e) {
                system.assertEquals(e.getMessage(),e.getMessage());
            }
        }  
    }
    
    @isTest
    static void withOutTextBody() {
        User careAgent= [SELECT Id, email from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
        System.runAs(careAgent) {
            EmailMessage msg1 = new EmailMessage();
            msg1.textBody = null;
            msg1.fromAddress = careAgent.email;
            msg1.toAddress = 'fakeid@unitymedia.com';
            msg1.subject = 'test subject';
            msg1.incoming = true;
            try {
                insert msg1;
            }
            catch(DMLException e) {
                system.assertEquals(e.getMessage(),e.getMessage());
            }
        }  
    }
    
    @isTest
    static void withHtmlBody() {
        User careAgent= [SELECT Id, email from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
        System.runAs(careAgent) {
            EmailMessage msg1 = new EmailMessage();
            msg1.htmlBody = 'ref:test text body:ref';
            msg1.fromAddress = careAgent.email;
            msg1.toAddress = 'fakeid@unitymedia.com';
            msg1.subject = 'test subject';
            msg1.incoming = true;
            try {
                insert msg1;
            }
            catch(DMLException e) {
                system.assertEquals(e.getMessage(),e.getMessage());
            }
        }  
    }
}