/**
* Test class Service Details Extension
* 
* @author Ganesh Subbiah 
*/
@isTest
public class LG_SConsoleServiceDetailsTest {
    @testSetup
    static void createTestData()
    {
        /** data set up **/
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

        Account accountObj= new Account(Name = 'testFname');
        Insert accountObj;
        
        Contact contactObj = new Contact(accountId=accountObj.id, Salutation ='Mr', FirstName ='Test', LastName ='Contact', Phone = '09876543210', Email = 'test@email.com');
        insert contactObj;
        
        csord__Subscription__c SubscriptionObj= new csord__Subscription__c(Name = 'Test', csord__Identification__c = 'test');
        insert SubscriptionObj;
        
        csord__Service__c serviceObj = new csord__Service__c (LG_ExternalSubscriptionName__c = SubscriptionObj.id, Name = 'Test', csord__Status__c = 'test', LG_ServiceStatus__c = 'Provisioned', csord__Subscription__c =SubscriptionObj.id, csord__Identification__c = 'Test');
        insert serviceObj;
        
        csord__Order__c Ord = new csord__Order__c(Name = 'Test', csord__Status2__c = 'New', csord__Identification__c = 'Test');
        insert Ord;
        
        cscrm__Address__c address=new cscrm__Address__c(name='test Address', cscrm__Account__c = accountObj.id, LG_Technicalcontact__c = contactObj.id);
        insert address;
        
        csord__Solution__c Sol = new csord__Solution__c (Name = 'test', csord__Order__c =Ord.id, csord__Identification__c = 'Test', LG_EarliestInstallDate__c = system.today(), LG_LatestPortingWishDate__c = system.today(), LG_TargetDate__c = system.today().adddays(10), LG_Address__c = address.id);
        insert Sol;
        
        Id CaseRtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Assign Owner').getRecordTypeId();		

        case c= new case(LG_Service__c =serviceObj.id, recordtypeid = CaseRtId, LG_Solution__c= sol.id, Status = 'New');
        insert c;

        noTriggers.Flag__c = false;
        upsert noTriggers;
        /** End of data set up **/
    }
    static testMethod void orderCase() 
    {
        Id CaseRtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Assign Order Owner').getRecordTypeId();		
        csord__Order__c ord = [SELECt id,name FROM  csord__Order__c WHERE name= 'Test' LIMIT 1];
        Case c = [SELECT id,LG_Service__c,LG_Solution__c, RecordType.Name FROM Case LIMIT 1];
        c.recordtypeid = CaseRtId;
        c.LG_Solution__c = NULL;
        c.LG_Order__c = ord.id;
        update c;
        csord__Solution__c sol = [SELECt id,name,csord__Order__c,LG_LatestPortingWishDate__c,LG_EarliestInstallDate__c,LG_Address__c,  LG_Address__r.LG_TechnicalContact__C FROM  csord__Solution__c WHERE name= 'Test'];
        test.starttest();
        
        LG_SConsoleServiceDetailsExtension controller = new LG_SConsoleServiceDetailsExtension(new ApexPages.StandardController(c));
        PageReference pageRef = Page.LG_SConsoleServiceDetails;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',c.id);
        controller.getService();
        controller.getServiceItems();
        controller.getServiceLineItems();
        controller.getRecordType();
        controller.cancel();
        controller.edit();
        controller.save();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Saved Successfully')) b = true;
        }
        test.stoptest();
    }
    static testMethod void suborderCase() 
    {
        Case c = [SELECT id,LG_Service__c,LG_Solution__c, RecordType.Name FROM Case LIMIT 1];
        csord__Solution__c sol = [SELECt id,name,csord__Order__c,LG_LatestPortingWishDate__c,LG_EarliestInstallDate__c,LG_Address__c,  LG_Address__r.LG_TechnicalContact__C FROM  csord__Solution__c WHERE name= 'Test'];
        test.starttest();
        
        LG_SConsoleServiceDetailsExtension controller = new LG_SConsoleServiceDetailsExtension(new ApexPages.StandardController(c));
        PageReference pageRef = Page.LG_SConsoleSolutionDetails;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',c.id);
        controller.getRecordType();
        controller.getService();
        controller.getServiceItems();
        controller.getServiceLineItems();
        controller.cancel();
        controller.edit();
        controller.save();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Saved Successfully')) b = true;
        }
        test.stoptest();
    }    
}