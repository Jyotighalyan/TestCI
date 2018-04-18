@isTest
public class LG_CaseLayoutRedirectTest {
	@testSetup
    static void setup() {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
    }
        
    public static testMethod void TestMethods(){
        //Solution
        csord__Solution__c solution = new csord__Solution__c(Name = 'test solution',csord__Identification__c = '6465467986',LG_JeopardyExplanation__c='');
        insert solution;
        
        //Case
        Case case1 = new Case(LG_Solution__c = solution.Id,Status = 'New');
        case1.RecordTypeId = [Select Id,SobjectType,Name From RecordType where Name ='Install' 
                          and SobjectType ='Case'  limit 1].Id;
        case1.Reason = '';
        insert case1;
        
        Case c = [select Subject, OwnerId, Status, Reason, CaseNumber, LG_Service__c, LG_Solution__c, Type, ContactId, LG_Order__c, 
                  RecordTypeId, RecordType.Name from Case LIMIT 1];
                  
        
        Test.startTest();
        LG_CaseLayoutRedirectExtension controller = new LG_CaseLayoutRedirectExtension(new ApexPages.StandardController(c));        
        controller.redirect();
        
        //Test page redirect
        PageReference page = new PageReference('/apex/LG_CaseLayoutA?id='+c.Id);
        system.assertEquals(page.getURL(),controller.redirect().getURL());
        
        Test.stopTest();
    }
    
     public static testMethod void TestMethods1(){
     //Solution
        csord__Solution__c solution = new csord__Solution__c(Name = 'test solution',csord__Identification__c = '6465467986',LG_JeopardyExplanation__c='');
        insert solution;
     //Case
        Case c1 = new Case(LG_Solution__c = solution.Id,Status = 'old');
        c1.RecordTypeId = [Select Id,SobjectType,Name From RecordType where Name ='Default' 
                          and SobjectType ='Case'  limit 1].Id;
        c1.Reason = '';
        insert c1;
        Case c = [select Subject, OwnerId, Status, Reason, CaseNumber, LG_Service__c, LG_Solution__c, Type, ContactId, LG_Order__c, 
                  RecordTypeId, RecordType.Name from Case where RecordType.Name = 'Default'];
                  
        Test.startTest();
        LG_CaseLayoutRedirectExtension controller = new LG_CaseLayoutRedirectExtension(new ApexPages.StandardController(c));
        controller.redirect();
        
        //Test page redirect
        PageReference page = new PageReference('/'+c.Id+'?nooverride=1');
        system.assertEquals(page.getURL(),controller.redirect().getURL());
        
        
        Test.stopTest();
    }

}