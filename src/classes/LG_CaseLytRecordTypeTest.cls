@isTest
public class LG_CaseLytRecordTypeTest {
    @testSetup
    static void setup() {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        //Solution
        csord__Solution__c solution = new csord__Solution__c(Name = 'test solution',csord__Identification__c = '6465467986',LG_JeopardyExplanation__c='');
        insert solution;
        
        //Case
        Case c = new Case(LG_Solution__c = solution.Id,Status = 'New');
        c.RecordTypeId = [Select Id,SobjectType,Name From RecordType where Name ='Install' 
                          and SobjectType ='Case'  limit 1].Id;
        c.Reason = '';
        insert c;
    }
    
    public static testMethod void TestMethods(){
        Case c = [select Subject, OwnerId, Status, Reason, CaseNumber, LG_Service__c, LG_Solution__c, Type, ContactId, LG_Order__c, 
                  RecordTypeId, RecordType.Name from Case LIMIT 1];
        Test.startTest();
        LG_CaseLytRecordTypeExtension controller = new LG_CaseLytRecordTypeExtension(new ApexPages.StandardController(c));
        controller.getCaseClosed();
        controller.getCaseDetail();
        controller.getNoCaseReason();
        controller.getNoPublicListing();
        controller.getCaseOrderCancelReq();
        controller.CloseCase();
        controller.PublicListing();
        controller.getManageNumbers();
        controller.getFieldList();
        controller.UpdateCase();
        controller.ComplexChange();
        
        //Test ManageNumber page redirect
        //PageReference page = new PageReference('/apex/LG_NumberManagement?isdtp=vw&id='+c.Id);
        //system.assertEquals(page.getURL(),controller.ManageNumbers().getURL());
        
        //Test Public Listing page redirect
        PageReference page = new PageReference('/apex/LG_PublicListing?id='+c.Id);
        system.assertEquals(page.getUrl(),controller.PublicListing().getURL());
        
        //Test NoCaseReason method
        system.assertEquals(false,controller.getNoCaseReason());
        
        //Test NoPublicListing method
        system.assertEquals(false,controller.getNoPublicListing());
        
        
        system.assertEquals(false,controller.getCaseOnHold());
        
        system.assertEquals(true,controller.getCaseNew());
        
        system.assertEquals(false,controller.getCaseFollowOnOrder());
        system.assertEquals(false,controller.getCaseProvision());
        //system.assertEquals(false,controller.getCaseAppointment());
        system.assertEquals(false,controller.getNoManageNumber());
        
        Test.stopTest();
    }

}