/**
* Test class Appointment Extension controller
* 
* @author Pankaj Sharma
* @story SFOM-107
* @since  22/12/2016
*/
@isTest
public class LG_SConsoleAppointmentDetailsExtn_Test
{
    @testSetup
    static void createTestData()
    {
        /** data set up **/
        Account accountObj= new Account();
        accountObj.Name = 'testFname';
        Insert accountObj;
        
        Contact contactObj = new Contact();
        contactObj.accountId=accountObj.id;
        contactObj.FirstName ='Test';        
        contactObj.LastName ='Contact';
        contactobj.Phone = '09876543210';
        contactobj.Email = 'test@email.com';
        insert contactObj;
        
        csord__Order_Request__c orderObj = new csord__Order_Request__c();
        orderObj.name = 'Test';
        orderObj.csord__Module_Name__c ='Test';
        orderObj.csord__Module_Version__c = 'Test';
        orderObj.csord__Process_Status__c = 'Requested';
        orderObj.csord__Request_DateTime__c = system.today();
        insert orderObj;
        
        csord__Subscription__c SubscriptionObj= new csord__Subscription__c();
        SubscriptionObj.Name = 'Test';
        SubscriptionObj.csord__Identification__c = 'test';
        SubscriptionObj.csord__Order_Request__c = orderObj.id;
        insert SubscriptionObj;
          Account account = LG_GeneralTest.CreateAccount('Test Jira', '12345678', 'UM', true);
        
        csconta__Billing_Account__c billingAcc = LG_GeneralTest.createBillingAccount('SFDT-59 Bill1', account.Id, true, true);
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
        
        csord__Order_Request__c orderRequest = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert orderRequest;
        
        csord__Order__c order = LG_GeneralTest.createOrder('Company Fibre',account,'In Progress',orderRequest, opp, true);
        
        cscrm__Address__c address = LG_GeneralTest.crateAddress('TestAddress', 'street', 'city', '5', '73', '2014GC', 'Netherlands', account, true);
        
        csord__Solution__c suborder = new csord__Solution__c();
        suborder.Name               = 'UM JIRA Fiber - 123456';
        suborder.csord__Account__c  = account.id;
        suborder.csord__Order__c    = order.id;
        suborder.LG_Address__c     = address.id;
        suborder.csord__Status__c   = 'In Progress';
        suborder.csord__Identification__c = 'UM JIRA Fiber - 123456';
        suborder.csord__Order_Request__c  = orderRequest.id;
        suborder.LG_InstallationWishDate__c = System.today() + 10;
        suborder.LG_TargetDate__c = System.today();
        insert suborder;
        
        csord__Subscription__c subscription = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = orderRequest.Id);
        subscription.LG_Address__c     = address.Id;
        subscription.csord__Account__c   = account.Id;
        subscription.csord__Order__c   = order.Id;
        subscription.csord__Solution__c = suborder.Id;
        subscription.csconta__Billing_Account__c = billingAcc.id;
        insert subscription;             
        
        csord__Service__c serviceObj = new csord__Service__c(csord__Identification__c = 'TestService', csord__Subscription__c = subscription.Id, csord__Order_Request__c = orderRequest.Id);
        serviceObj.LG_Address__c   = address.Id;
        serviceObj.LG_Suborder__c  = suborder.id;
        serviceObj.LG_ProductFamily__c    ='Company Fibre';
        serviceObj.UM_JiraIssueTypeId__c = '12101';
        insert serviceObj;
        
      /*  csord__Service__c serviceObj = new csord__Service__c ();
        serviceObj.LG_ExternalSubscriptionName__c = SubscriptionObj.id;
        serviceObj.Name = 'Test';
        serviceObj.csord__Status__c = 'test';
        serviceobj.LG_ServiceStatus__c = 'Provisioned';
        serviceObj.csord__Subscription__c =SubscriptionObj.id;
        serviceObj.csord__Identification__c = 'Test';
        insert serviceObj;*/
        
        csord__Order__c oOr = new csord__Order__c();
        oOr.Name = 'Test';
        oOr.csord__Status2__c = 'New';
        oOr.csord__Identification__c = 'Test';
        oOr.csord__Order_Request__c =orderObj.id;
        insert oOr;
        
       /* cscrm__Address__c address=new cscrm__Address__c();
        address.name='test Address';
        address.cscrm__Account__c = accountObj.id;
        address.LG_Technicalcontact__c = contactObj.id;
        insert address;*/
        
        csord__Solution__c solutionObject = new csord__Solution__c ();
        solutionObject.Name = 'test';
        solutionObject.csord__Order__c =oOr.id;
        solutionObject.csord__Identification__c = 'Test';
        solutionObject.csord__Order_Request__c= orderObj.id;
        solutionobject.LG_EarliestInstallDate__c = system.today();
        solutionobject.LG_LatestPortingWishDate__c = system.today();
        solutionobject.LG_TargetDate__c = system.today().adddays(10);
        solutionObject.LG_Address__c = address.id;//addr.id; --> address data to be inserted
        insert solutionObject;
        List<RecordType> caseRecordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND Name IN ('Install', 'Provision', 'Number Port', 'Activate Service', 'Access Planning')];

        case c= new case();
        c.LG_Solution__c= solutionObject.id;
        c.Contact = contactObj;
        c.Status = 'New';
        c.Type= 'Visit-New';
        c.RecordTypeId = caseRecordTypes[0].Id;
        insert c;
        system.debug('case inserted'+c);
        
        LG_ScheduleAppointment__C app = new LG_ScheduleAppointment__C();
        app.LG_AgreedInstallDate__c = system.today().adddays(2);
        app.LG_Address__c = address.id;
        app.LG_Slot__c = 'Morning Slot';
        app.LG_Case__c = c.id;
        app.LG_Solution__c = solutionObject.id;
        insert app;
        system.debug('appointment inserted'+app);
        
        /** End of data set up **/
    }
    static testMethod void allPositiveScenarios() 
    {
        Case c = [SELECT id,LG_Service__c,LG_Solution__c,ContactId, RecordType.Name FROM Case LIMIT 1];
        system.debug('case #'+c.LG_Solution__c+'id#'+c.id);
        csord__Solution__c solutionObject = [SELECt id,name,csord__Order__c,LG_LatestPortingWishDate__c,LG_EarliestInstallDate__c,LG_Address__c,  LG_Address__r.LG_TechnicalContact__C FROM  csord__Solution__c WHERE name= 'Test'];
        LG_ScheduleAppointment__C app = [SELECT id, LG_AgreedInstallDate__c, LG_Address__c,LG_Slot__c, LG_Case__c , LG_Solution__c FROM  LG_ScheduleAppointment__C WHERE  LG_Case__c = :c.id limit 1];
        
        test.starttest();
        
        LG_SConsoleAppointmentDetailsExtension controller = new LG_SConsoleAppointmentDetailsExtension(new ApexPages.StandardController(c));
        //     apexpages.currentpage().getparameters().put('id' , c.id);
        PageReference pageRef = Page.LG_SConsoleAppointmentDetails;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',c.id);
        controller.solutionObject=solutionObject;   
  //      controller.appointmentObject = app;
        controller.getService();
        controller.getServiceItems();
        controller.getServiceLineItems();
        controller.getSolutionRecord();
        //getfile(); // test attachment to be inserted
        controller.getServiceItemRecords();
        controller.getServiceLineItemRecords();
        controller.getRecordType();
        controller.edit();
        controller.save();
        controller.getstatusOptions();
        controller.Refresh();
        controller.fileName='Unit Test Attachment';
        controller.fileBody=Blob.valueOf('Unit Test Attachment Body');
        controller.uploadFile();
        controller.cancel();
        controller.showPopup();
        controller.closePopup();
        controller.getfile();
        
        
        controller.solutionObject=null;
        controller.getSolution();         
        
        
        test.stoptest();
        List<Attachment> attList = [SELECT id FROM Attachment Limit 1];
        system.assertEquals(attList.size(),1);
        
    }
 
    static testMethod void saveNegativeScenarios() 
    {
        Case c = [SELECT id,LG_Service__c,LG_Solution__c,ContactId, RecordType.Name FROM Case LIMIT 1];
        c.Type= 'Cancel';
        update c;
        system.debug('modify case #'+c.LG_Solution__c+'id#'+c.id+'Type#'+ c.Type);

        csord__Solution__c solutionObject = [SELECt id,name,csord__Order__c,LG_EarliestInstallDate__c,LG_Address__c,  LG_Address__r.LG_TechnicalContact__C  FROM  csord__Solution__c WHERE name= 'Test'];
        test.starttest();

        LG_SConsoleAppointmentDetailsExtension controller = new LG_SConsoleAppointmentDetailsExtension(new ApexPages.StandardController(c));
        apexpages.currentpage().getparameters().put('id' , c.id);
        controller.solutionObject=solutionObject; 
        controller.solutionObject.LG_LatestPortingWishDate__c = system.today();
        controller.appointmentObject.LG_AgreedInstallDate__c = system.today();
        controller.appointmentObject.LG_Slot__c = 'Morning Slot';            
        controller.save();
        system.assertequals(controller.appointmentObject.LG_AgreedInstallDate__c,system.today());
        
        controller.cs.type = 'Modify';
        controller.save();
        system.assertequals(controller.appointmentObject.LG_AgreedInstallDate__c,system.today());
        
        controller.cs.type = 'Visit-New';		
        solutionobject.LG_EarliestInstallDate__c = system.today().adddays(-2);
        controller.appointmentObject.LG_AgreedInstallDate__c = system.today().adddays(-2);
        controller.save();
        system.assertnotequals(controller.appointmentObject.LG_AgreedInstallDate__c,system.today());
        
        solutionobject.LG_EarliestInstallDate__c = system.today().adddays(10);
        controller.appointmentObject.LG_AgreedInstallDate__c = system.today();
        controller.save();
        system.assertequals(controller.appointmentObject.LG_AgreedInstallDate__c,system.today());
        
        controller.cs.type = 'Cancel';
        controller.getstatusoptions();
        system.assertnotequals(controller.appointmentObject.LG_status__c,'Cancelled');
        

        test.stoptest();

    }
}