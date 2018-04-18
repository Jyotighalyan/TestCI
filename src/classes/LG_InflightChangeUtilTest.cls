/**
 * Utillity class for Inflight Change Step HLD
 *
 * @author Petar Miletic
 * @ticket SFOM-355
 * @since  20/02/2017
*/
@IsTest
public class LG_InflightChangeUtilTest {

    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        Account acc = LG_GeneralTest.CreateAccount('TestAccount', '321654987', 'Test', true);
		
        csconta__Billing_Account__c ba = new csconta__Billing_Account__c();
    	ba.csconta__Account__c = acc.id;
    	ba.csconta__Status__c = 'New';
    	ba.csconta__Billing_Channel__c = 'Paper';
    	ba.csconta__Format_Type__c = 'Summary';
    	insert ba;
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, true);
        
		// Solution 
		csord__Solution__c sol = new csord__Solution__c(Name = 'Test Solution', csord__Identification__c = '123456789');
		insert sol;
        
	   // SFOM-427 test data starts
       //Appointment
        LG_ScheduleAppointment__c app = new LG_ScheduleAppointment__c(Name = 'Test Appointment', LG_Status__C = 'Scheduled', LG_Solution__C = sol.id, LG_AgreedInstallDate__c = Date.today(), LG_JobReference__c = 'Test Ref', LG_Slot__c= 'Morning Slot');
		insert app;
        
        // Subscripton 
		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '6465467986',csconta__Billing_Account__c = ba.id);
        insert sub; 

        // Service 
		csord__Service__c service = new csord__Service__c(Name='TestService0',csord__Identification__c='6465467986',csord__Activation_Date__c=Date.today(),LG_Effectivedate__c=Date.today(), LG_ServiceStatus__C = 'Provisioned', LG_Suborder__c = sol.Id, csord__Subscription__c= sub.id ) ;
        insert service;
      
        //SFOM-427 test data ends
        
        // Inflight Configuration [0]
        // Manage Numbers [1]
        // Schedule Appointment [2]
		List<RecordType> objs = [SELECT Id, Name, IsActive FROM RecordType WHERE SobjectType = 'Case' AND Name IN ('Inflight Configuration', 'Manage Numbers', 'Schedule Appointment') ORDER BY Name ASC];

        Case reScheduleCase = new Case();
        reScheduleCase.RecordTypeId = objs[2].Id;
        reScheduleCase.Status = 'New';
        reScheduleCase.LG_Solution__c = sol.Id;
        reScheduleCase.Type = 'Modify';
        
        insert reScheduleCase;
        
        Case manageNumbers = new Case();
        manageNumbers.RecordTypeId = objs[1].Id;
        manageNumbers.Status = 'Closed';
        manageNumbers.LG_Solution__c = sol.Id;
        manageNumbers.Type = 'Inflight Change';
        
        insert manageNumbers;

        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    
    @isTest
    public static void reScheduleTest() {
        
        csord__Solution__c sol = [SELECT Id, Name FROM csord__Solution__c LIMIT 1];
        
		Test.startTest();
		
        Id caseId = LG_InflightChangeUtil.reSchedule(sol.Id);

		Test.stopTest();
		
		// 'Schedule Appointment', 'Modify'
		List<Case> cases = [SELECT Id FROM Case WHERE RecordType.Name = 'Schedule Appointment' AND Type = 'Modify'];
		
		System.assertEquals(1, cases.size(), 'Invalid data');
    }
    
    @isTest
    public static void correctNumbersTest() {
        
        csord__Solution__c sol = [SELECT Id, Name FROM csord__Solution__c LIMIT 1];
        
        Test.startTest();
		
        Id caseId = LG_InflightChangeUtil.correctNumbers(sol.Id);

		Test.stopTest();
		
		// 'Manage Numbers', 'Inflight Change'
		List<Case> cases = [SELECT Id FROM Case WHERE RecordType.Name = 'Manage Numbers' AND Type = 'Inflight Change'];
		
		System.assertEquals(2, cases.size(), 'Invalid data');
    }
    
    @isTest
    public static void configureTest() {
        
        csord__Solution__c sol = [SELECT Id, Name FROM csord__Solution__c LIMIT 1];
        
        Test.startTest();
		
        Id caseId = LG_InflightChangeUtil.configure(sol.Id);

		Test.stopTest();
		
		// 'Inflight Configuration', 'Standard'
		List<Case> cases = [SELECT Id FROM Case WHERE RecordType.Name = 'Inflight Configuration' AND Type = 'Standard'];
		
		System.assertEquals(1, cases.size(), 'Invalid data');
    }
    
    @IsTest
    public static void errorTest() {
		
        Account acc = LG_GeneralTest.CreateAccount('TestAccount1', '321654989', 'Test', true);
		
        csconta__Billing_Account__c ba = new csconta__Billing_Account__c();
    	ba.csconta__Account__c = acc.id;
    	ba.csconta__Status__c = 'New';
    	ba.csconta__Billing_Channel__c = 'Paper';
    	ba.csconta__Format_Type__c = 'Summary';
    	insert ba;
        
        
        // Trigger error by sending incorrect id        
        Id accountId = '0016E000002Qmq2';
        
                
		// Solution  with service not in valid status
		csord__Solution__c sol1 = new csord__Solution__c(Name = 'Test Solution1', csord__Identification__c = '123456780');
		insert sol1;
        
        //Appointment
        LG_ScheduleAppointment__c app1 = new LG_ScheduleAppointment__c(Name = 'Test Appointment', LG_Status__C = 'Scheduled', LG_Solution__C = sol1.id, LG_AgreedInstallDate__c = Date.today(), LG_JobReference__c = 'Test Ref', LG_Slot__c= 'Morning Slot');
		insert app1;
        
        // Subscripton 
		csord__Subscription__c sub1 = new csord__Subscription__c(csord__Identification__c = '6465467986',csconta__Billing_Account__c = ba.id);
		insert sub1; 
        
        // Solution  with no valid service
		csord__Solution__c sol2 = new csord__Solution__c(Name = 'Test Solution2', csord__Identification__c = '123456789');
		insert sol2;
        
        //Appointment
        LG_ScheduleAppointment__c app2 = new LG_ScheduleAppointment__c(Name = 'Test Appointment', LG_Status__C = 'Scheduled', LG_Solution__C = sol2.id, LG_AgreedInstallDate__c = Date.today(), LG_JobReference__c = 'Test Ref', LG_Slot__c= 'Morning Slot');
		insert app2;
        
        // Solution  with vo valid appointment
		csord__Solution__c sol3 = new csord__Solution__c(Name = 'Test Solution3', csord__Identification__c = '123456789');
		insert sol3;
  
		// Solution  with appointment in the past
		csord__Solution__c sol4 = new csord__Solution__c(Name = 'Test Solution4', csord__Identification__c = '123456789');
		insert sol4;
        
        //Appointment
        LG_ScheduleAppointment__c app4 = new LG_ScheduleAppointment__c(Name = 'Test Appointment', LG_Status__C = 'Scheduled', LG_Solution__C = sol4.id, LG_AgreedInstallDate__c = Date.today()-4, LG_JobReference__c = 'Test Ref', LG_Slot__c= 'Morning Slot');
		insert app4;
        
        // Subscripton 
		csord__Subscription__c sub4 = new csord__Subscription__c(csord__Identification__c = '6465467986',csconta__Billing_Account__c=ba.id);
		insert sub4; 
               
        Test.startTest();
        
		String reschedule = LG_InflightChangeUtil.reSchedule(accountId);
		String numbers = LG_InflightChangeUtil.correctNumbers(accountId);
        String configure = LG_InflightChangeUtil.configure(accountId);
        String invalidstatus = LG_InflightChangeUtil.reSchedule(sol1.id);  //SFOM-427
        String noservice = LG_InflightChangeUtil.reSchedule(sol2.id);  //SFOM-427
        String noapp = LG_InflightChangeUtil.reSchedule(sol3.id);  //SFOM-427
        String pastapp = LG_InflightChangeUtil.reSchedule(sol4.id);  //SFOM-427
         
		Test.stopTest();
		
		System.debug(reschedule);
		System.debug(numbers);
		System.debug(configure);
		
		System.assertEquals(false, LG_Util.IsValidId(reschedule), 'Invalid data');
		System.assertEquals(false, LG_Util.IsValidId(numbers), 'Invalid data');
		System.assertEquals(false, LG_Util.IsValidId(configure), 'Invalid data');
		System.assertEquals(noservice, 'No valid service is available to update');  
        System.assertEquals(noapp, 'There is no appointment to modify'); 
        System.assertEquals(pastapp, 'Appointment cannot be modified as appointment is in the past'); 
    }
}