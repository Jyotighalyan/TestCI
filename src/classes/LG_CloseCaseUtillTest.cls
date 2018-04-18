@isTest
global class LG_CloseCaseUtillTest {
@testSetup 
    static void setup() {
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        //account
        Account acc= new Account(Name = 'testFname');
        Insert acc;
        
        //Contact
        Contact con = new Contact(accountId=acc.id, FirstName ='Test', LastName ='Contact', Phone = '09876543210', Email = 'test@email.com');
        con.salutation='Mr.';
        insert con;
        
        //Order
        csord__Order__c order = new csord__Order__c(Name='Test Order',csord__Identification__c = '6465467986');
        insert order;
        
        //product configuration
        cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c(cscfga__Attribute_Name__c='testAttribute',Name='TestName');
        insert pc;
        
        // Subscripton 
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '6465467986');
        insert sub; 
        
        //Solution
        csord__Solution__c solution = new csord__Solution__c(Name = 'test solution',csord__Identification__c = '6465467986', LG_LatestPortingWishDate__c = (Date.today() + 10),LG_TargetDate__c = (Date.today() + 15));
        insert solution;
        
        // Service 
        csord__Service__c service = new csord__Service__c(csordtelcoa__Product_Configuration__c=pc.Id,Name='TestService',csord__Subscription__c=sub.Id,csord__Identification__c='6465467986',LG_RootOrder__c=order.Id,csord__Activation_Date__c=Date.today(), LG_Suborder__c = solution.Id,csord__Solution__c = solution.Id );
        insert service;

        Id CaseRtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Schedule Appointment').getRecordTypeId();     

        //Case
        Case c = new Case(LG_Service__c = service.Id,LG_Solution__c = solution.Id, type='Modify', recordtypeid = CaseRtId, reason = 'Test Reason', status = 'Open');
        insert c;
        
        LG_ScheduleAppointment__c scheduleApp = new LG_ScheduleAppointment__c(LG_Case__c = c.Id, LG_Status__c = 'Scheduled',LG_Reasons__c='Blockage',LG_Solution__C = solution.id, LG_InstallationContact__c = con.id, LG_AgreedInstallDate__c=(Date.today()+10),LG_Slot__c = 'Morning Slot');
        insert scheduleApp;
        
        CSPOFA__Orchestration_Process_Template__c processTemplate = new CSPOFA__Orchestration_Process_Template__c(Name = 'Test Orchestration');
        insert processTemplate;
        
        CSPOFA__Orchestration_Process__c processIds = new CSPOFA__Orchestration_Process__c(Name = 'Test Orchestration',LG_Solution__c = solution.Id,CSPOFA__Orchestration_Process_Template__c = processTemplate.id);
        insert processIds;
        
        CSPOFA__Orchestration_Step__c OrchStep = new CSPOFA__Orchestration_Step__c(Name='Orch Step', CSPOFA__Status__c = 'In Progress');
        OrchStep.CSPOFA__Step_Order__c= 67;
        OrchStep.CSPOFA__Orchestration_Process__c = processIds.Id;
        insert OrchStep; 

        LG_InflightChangeStep__c inflightSetting = new LG_InflightChangeStep__c(Name= 'Test', LG_OrchestrationProcess__c = processTemplate.id, LG_InstallLoop__c=55, LG_NumberPortLoop__c=38,LG_PortingWindow__c=7, LG_ProvisionLoop__c=27,LG_RetryInstall__c=37,LG_RetryNumberPort__c=34,LG_RetryProvision__c=21);
        insert inflightSetting;
        noTriggers.Flag__c = False;
        upsert noTriggers;        
    }

    public static testMethod void TestLG_appointmentCaseUtill(){
        
        Case c = [select Id,LG_Solution__c from Case LIMIT 1];
        csord__Solution__c sol = [select Id,LG_Jeopardy__c, LG_RetryNumberPort__c, LG_RetryProvision__c,  LG_InflightChange__c from csord__Solution__c where id = :c.LG_Solution__c LIMIT 1];
        LG_ScheduleAppointment__c app = [select id, LG_Solution__c from LG_ScheduleAppointment__c where LG_Case__c = :c.id limit 1]; 
        //Jeopardy as False and Number port False and process - Test Retry Install
        sol.LG_Jeopardy__c = False;
        sol.LG_RetryInstall__c = False;
        sol.LG_InflightChange__c = False;
        update sol;
        CSPOFA__Orchestration_Process__c pro = [select id from CSPOFA__Orchestration_Process__c where LG_Solution__c = :sol.Id limit 1];
        CSPOFA__Orchestration_Step__c OrchStep = [select id, Name, CSPOFA__Status__c, CSPOFA__Step_Order__c from CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__c = :pro.id limit 1];
        
        List<Id> recIds = new List<Id>();      
        recIds.add(c.Id);
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
        string msg1 = LG_CloseCaseUtill.closeCase(recIds);

        csord__Solution__c sol1 = [select Id,LG_Jeopardy__c, LG_RetryInstall__c, LG_RetryProvision__c,  LG_InflightChange__c from csord__Solution__c where id = :c.LG_Solution__c LIMIT 1];
        System.assertEquals(msg1, 'Success');
        System.assertEquals(True, sol1.LG_RetryInstall__c);  
        System.assertEquals(True, sol1.LG_InflightChange__c);        
        Case c1 = [select Id,LG_Service__c, LG_Solution__c, status from Case LIMIT 1];
        System.assertEquals('Closed', c1.Status); 
        
        //Jeopardy as True and Number port False and process - Test Retry Install
        sol.LG_Jeopardy__c = True;
        sol.LG_RetryInstall__c = False;
        sol.LG_InflightChange__c = False;
        update sol;
        //c.status = 'Open';
        //update c;
        Id CaseRtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Schedule Appointment').getRecordTypeId();     

        //Case
        Case nc2 = new Case(LG_Solution__c = sol.Id, type='Modify', recordtypeid = CaseRtId, reason = 'Test Reason', status = 'Open');
        insert nc2;
        app.LG_Case__c = nc2.id;
        update app;
        
        List<Id> recIds2 = new List<Id>();      
        recIds2.add(nc2.Id);

        OrchStep.CSPOFA__Step_Order__c = 55; 
        update OrchStep;

        string msg2 = LG_CloseCaseUtill.closeCase(recIds2);
        
        csord__Solution__c sol2 = [select Id,LG_Jeopardy__c, LG_RetryInstall__c, LG_RetryProvision__c,  LG_InflightChange__c from csord__Solution__c where id = :c.LG_Solution__c LIMIT 1];
        Case c2 = [select Id,LG_Service__c, LG_Solution__c, status from Case LIMIT 1];
        System.assertEquals(msg2, 'Success');        
        System.assertEquals(True, sol2.LG_RetryInstall__c);        
        System.assertEquals('Closed', c2.Status);
        
        test.stopTest();
         }
    }
    public static testMethod void TestLG_numberTrueJeoFalseUtill(){
        Case c = [select Id,LG_Solution__c from Case LIMIT 1];
        csord__Solution__c sol = [select Id,LG_Jeopardy__c, LG_RetryNumberPort__c, LG_RetryProvision__c,  LG_InflightChange__c from csord__Solution__c where id = :c.LG_Solution__c LIMIT 1];
        LG_ScheduleAppointment__c app = [select id, LG_Solution__c from LG_ScheduleAppointment__c where LG_Case__c = :c.id limit 1]; 

        CSPOFA__Orchestration_Process__c pro = [select id from CSPOFA__Orchestration_Process__c where LG_Solution__c = :sol.Id limit 1];
        CSPOFA__Orchestration_Step__c OrchStep = [select id, Name, CSPOFA__Status__c, CSPOFA__Step_Order__c from CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__c = :pro.id limit 1];

        //Jeopardy as False and Number port True and process - Test Retry Install
        sol.LG_AnyNumbersToPort__c = True;
        sol.LG_Jeopardy__c = False;
        sol.LG_RetryInstall__c = False;
        sol.LG_InflightChange__c = False;
        update sol;
        
        List<Id> recIds3 = new List<Id>();      
        recIds3.add(c.Id);
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
        string msg3 = LG_CloseCaseUtill.closeCase(recIds3);
        
        csord__Solution__c sol3 = [select Id,LG_Jeopardy__c, LG_RetryInstall__c, LG_RetryProvision__c,  LG_InflightChange__c from csord__Solution__c where id = :c.LG_Solution__c LIMIT 1];
        Case c3 = [select Id,LG_Service__c, LG_Solution__c, status from Case LIMIT 1];
        System.assertEquals(msg3, 'Success');        
        System.assertEquals(True, sol3.LG_RetryInstall__c);        
        System.assertEquals(True, sol3.LG_InflightChange__c);        
        System.assertEquals('Closed', c3.Status);          

       //Jeopardy as False and Number port True and process - Test Retry Number Port
        OrchStep.CSPOFA__Step_Order__c = 38; 
        update OrchStep;
        sol.LG_LatestPortingWishDate__c = (Date.today() + 5);
        sol.LG_AnyNumbersToPort__c = True;
        sol.LG_Jeopardy__c = False;
        sol.LG_RetryNumberPort__c = False;
        sol.LG_InflightChange__c = False;
        update sol;
        //c.status = 'Open';
        //update c;        
        Id CaseRtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Schedule Appointment').getRecordTypeId();     

        //Case
        Case nc4 = new Case(LG_Solution__c = sol.Id, type='Modify', recordtypeid = CaseRtId, reason = 'Test Reason', status = 'Open');
        insert nc4;
        app.LG_Case__c = nc4.id;
        update app;
        
        List<Id> recIds4 = new List<Id>();      
        recIds4.add(nc4.Id);
        
        string msg4 = LG_CloseCaseUtill.closeCase(recIds4);
        
        csord__Solution__c sol4 = [select Id,LG_RetryNumberPort__c, LG_Jeopardy__c, LG_RetryInstall__c, LG_RetryProvision__c,  LG_InflightChange__c from csord__Solution__c where id = :c.LG_Solution__c LIMIT 1];
        Case c4 = [select Id,LG_Service__c, LG_Solution__c, status from Case LIMIT 1];
        System.assertEquals(msg4, 'Success');        
        System.assertEquals(True, sol4.LG_RetryNumberPort__c);        
        System.assertEquals(True, sol4.LG_InflightChange__c);        
        System.assertEquals('Closed', c4.Status);          

        Test.stopTest();
         }
        
    }
    public static testMethod void TestLG_numberTrueJeoTrueUtill(){
        
        Case c = [select Id,LG_Solution__c from Case LIMIT 1];
        csord__Solution__c sol = [select Id,LG_Jeopardy__c, LG_RetryNumberPort__c, LG_RetryProvision__c,  LG_InflightChange__c from csord__Solution__c where id = :c.LG_Solution__c LIMIT 1];
        sol.LG_AnyNumbersToPort__c = True;
        sol.LG_LatestPortingWishDate__c = (Date.today() + 10);
        sol.LG_Jeopardy__c = True;
        sol.LG_RetryInstall__c = False;
        sol.LG_InflightChange__c = False;
        update sol;
        LG_ScheduleAppointment__c app = [select id, LG_Solution__c from LG_ScheduleAppointment__c where LG_Case__c = :c.id limit 1]; 
        CSPOFA__Orchestration_Process__c pro = [select id from CSPOFA__Orchestration_Process__c where LG_Solution__c = :sol.Id limit 1];
        CSPOFA__Orchestration_Step__c OrchStep = [select id, Name, CSPOFA__Status__c, CSPOFA__Step_Order__c from CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__c = :pro.id limit 1];
        
        List<Id> recIds = new List<Id>();      
        recIds.add(c.Id);
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
       
        OrchStep.CSPOFA__Step_Order__c = 55; 
        update OrchStep;

        //Jeopardy as True and Number port True and process - Test Retry Install
        string msg1 = LG_CloseCaseUtill.closeCase(recIds);
        
        csord__Solution__c sol1 = [select Id,LG_Jeopardy__c, LG_RetryInstall__c, LG_RetryProvision__c,  LG_InflightChange__c from csord__Solution__c where id = :c.LG_Solution__c LIMIT 1];
        Case c1 = [select Id,LG_Service__c, LG_Solution__c, status from Case LIMIT 1];
        System.assertEquals(msg1, 'Success');        
        System.assertEquals(True, sol1.LG_RetryInstall__c);        
        System.assertEquals('Closed', c1.Status);         

        //Jeopardy as True and Number port True and process - Test Retry Number port
        OrchStep.CSPOFA__Step_Order__c = 38; 
        update OrchStep;
        sol.LG_LatestPortingWishDate__c = (Date.today() + 5);
        sol.LG_AnyNumbersToPort__c = True;
        sol.LG_Jeopardy__c = True;
        sol.LG_RetryInstall__c = False;
        sol.LG_RetryNumberPort__c = False;
        sol.LG_InflightChange__c = False;
        update sol;
        //c.status = 'Open';
        //update c;        
        Id CaseRtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Schedule Appointment').getRecordTypeId();     

        //Case
        Case nc2 = new Case(LG_Solution__c = sol.Id, type='Modify', recordtypeid = CaseRtId, reason = 'Test Reason', status = 'Open');
        insert nc2;
        app.LG_Case__c = nc2.id;
        update app;
                
        List<Id> recIds2 = new List<Id>();      
        recIds2.add(nc2.Id);
        
        string msg2 = LG_CloseCaseUtill.closeCase(recIds2);
        
        csord__Solution__c sol2 = [select Id,LG_Jeopardy__c, LG_RetryNumberPort__c, LG_RetryInstall__c, LG_RetryProvision__c,  LG_InflightChange__c from csord__Solution__c where id = :c.LG_Solution__c LIMIT 1];
        Case c2 = [select Id,LG_Service__c, LG_Solution__c, status from Case LIMIT 1];
        System.assertEquals(msg2, 'Success');        
        System.assertEquals(True, sol2.LG_RetryNumberPort__c);        
        System.assertEquals('Closed', c2.Status);          

        //Test solution without appointment
        //app.LG_Case__c = NULL;
        //update app;
        //c.status = 'Open';
        //update c;        

        //Case
        Case nc3 = new Case(LG_Solution__c = sol.Id, type='Modify', recordtypeid = CaseRtId, reason = 'Test Reason', status = 'Open');
        insert nc3;
        
        List<Id> recIds3 = new List<Id>();      
        recIds3.add(nc3.Id);

        string msg3 = LG_CloseCaseUtill.closeCase(recIds3);
        
        Case c3 = [select Id,LG_Service__c, LG_Solution__c, status from Case LIMIT 1];
        System.assertEquals('Case cannot be closed without a valid appointment', msg3);        

        Test.stopTest();
         }
    }
    public static testMethod void TestLG_ConfigurationCaseUtill(){
        
        Case c = [select Id,LG_Service__c, LG_Solution__c, status from Case LIMIT 1];
        Id CaseRtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Inflight Configuration').getRecordTypeId();       
        c.RecordTypeId = CaseRtId;
        c.status = 'Open';
        update c;
        csord__Solution__c sol = [select Id,LG_Jeopardy__c, LG_RetryProvision__c,  LG_InflightChange__c from csord__Solution__c where id = :c.LG_Solution__c LIMIT 1];
        sol.LG_Jeopardy__c = True;
        sol.LG_RetryProvision__c = False;
        sol.LG_InflightChange__c = False;
        update sol;
        
        List<Id> recIds = new List<Id>();      
        recIds.add(c.Id);
		  User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
        //Test solution in Jeopardy
        string msg1 = LG_CloseCaseUtill.closeCase(recIds);

        csord__Solution__c sol1 = [select Id,LG_Jeopardy__c, LG_RetryProvision__c,  LG_InflightChange__c from csord__Solution__c where id = :c.LG_Solution__c LIMIT 1];
        System.assertEquals(msg1, 'Success');
        System.assertEquals(True, sol1.LG_RetryProvision__c);  
        System.assertEquals(False, sol1.LG_InflightChange__c);        
        Case c1 = [select Id,LG_Service__c, LG_Solution__c, status from Case LIMIT 1];
        System.assertEquals('Closed', c1.Status);        
        
        sol.LG_Jeopardy__c = False;
        sol.LG_RetryProvision__c = False;
        sol.LG_InflightChange__c = False;
        update sol;
        //c.status = 'Open';
        //update c;

        //Case
        Case nc2 = new Case(LG_Solution__c = sol.Id, type='Modify', recordtypeid = CaseRtId, reason = 'Test Reason', status = 'Open');
        insert nc2;
        
        List<Id> recIds2 = new List<Id>();      
        recIds2.add(nc2.Id);
        
        //Test solution not in Jeopardy
        string msg2 = LG_CloseCaseUtill.closeCase(recIds2);
        Test.stopTest();
         
        
        csord__Solution__c sol2 = [select Id,LG_Jeopardy__c, LG_RetryProvision__c,  LG_InflightChange__c from csord__Solution__c where id = :c.LG_Solution__c LIMIT 1];
        Case c2 = [select Id,LG_Service__c, LG_Solution__c, status from Case LIMIT 1];
        System.assertEquals(msg2, 'Success');        
        System.assertEquals(True, sol2.LG_RetryProvision__c);        
        System.assertEquals(True, sol2.LG_InflightChange__c);        
        System.assertEquals('Closed', c2.Status);   
         }
    }

    public static testMethod void TestLG_JeopardyCaseUtill(){
        
        Case c = [select Id,LG_Solution__c from Case LIMIT 1];
        Id CaseRtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Jeopardy').getRecordTypeId();     
        c.RecordTypeId = CaseRtId;
        update c;
        
        csord__Solution__c sol = [select Id,LG_AnyNumbersToPort__c, LG_Jeopardy__c, LG_RetryInstall__c, LG_RetryProvision__c,  LG_InflightChange__c from csord__Solution__c where id = :c.LG_Solution__c LIMIT 1];
        sol.LG_Jeopardy__c = True;
        sol.LG_RetryProvision__c = False;
        sol.LG_InflightChange__c = False;
        sol.LG_RetryInstall__c = False;
        update sol;        
        
        CSPOFA__Orchestration_Process__c pro = [select id from CSPOFA__Orchestration_Process__c where LG_Solution__c = :sol.Id limit 1];
        CSPOFA__Orchestration_Step__c OrchStep = [select id, Name, CSPOFA__Status__c, CSPOFA__Step_Order__c from CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__c = :pro.id limit 1];
        OrchStep.CSPOFA__Step_Order__c = 55; 
        update OrchStep;
        
        List<Id> recIds = new List<Id>();      
        recIds.add(c.Id);
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
        string msg1 = LG_CloseCaseUtill.closeCase(recIds);
        
        csord__Solution__c sol1 = [select Id,LG_Jeopardy__c, LG_RetryInstall__c, LG_RetryProvision__c,  LG_InflightChange__c from csord__Solution__c where id = :c.LG_Solution__c LIMIT 1];
        System.assertEquals(msg1, 'Success');
        System.assertEquals(True, sol1.LG_RetryInstall__c);  
        Case c1 = [select Id,LG_Service__c, LG_Solution__c, status from Case LIMIT 1];
        System.assertEquals('Closed', c1.Status); 
        
        sol.LG_Jeopardy__c = True;
        sol.LG_RetryProvision__c = False;
        sol.LG_InflightChange__c = False;
        sol.LG_RetryInstall__c = False;
        update sol;          

        OrchStep.CSPOFA__Step_Order__c = 27; 
        update OrchStep;        

        //Case
        Case nc2 = new Case(LG_Solution__c = sol.Id, type='Modify', recordtypeid = CaseRtId, reason = 'Test Reason', status = 'Open');
        insert nc2;
        
        List<Id> recIds2 = new List<Id>();      
        recIds2.add(nc2.Id);
        
        LG_CloseCaseUtill.closeCase(recIds2);
        csord__Solution__c sol2 = [select Id,LG_Jeopardy__c, LG_RetryInstall__c, LG_RetryProvision__c,  LG_InflightChange__c from csord__Solution__c where id = :c.LG_Solution__c LIMIT 1];
        System.assertEquals(True, sol2.LG_RetryProvision__c);  

        sol.LG_Jeopardy__c = True;
        sol.LG_RetryProvision__c = False;
        sol.LG_InflightChange__c = False;
        sol.LG_RetryInstall__c = False;
        sol.LG_RetryNumberPort__c = False;
        update sol;          

        OrchStep.CSPOFA__Step_Order__c = 38; 
        update OrchStep;        

        //Case
        Case nc3 = new Case(LG_Solution__c = sol.Id, type='Modify', recordtypeid = CaseRtId, reason = 'Test Reason', status = 'Open');
        insert nc3;
        
        List<Id> recIds3 = new List<Id>();      
        recIds3.add(nc3.Id);

        LG_CloseCaseUtill.closeCase(recIds3);
        csord__Solution__c sol3 = [select Id,LG_Jeopardy__c, LG_RetryInstall__c, LG_RetryProvision__c,  LG_InflightChange__c, LG_RetryNumberPort__c from csord__Solution__c where id = :c.LG_Solution__c LIMIT 1];
        System.assertEquals(True, sol3.LG_RetryNumberPort__c);  
        
        Test.stopTest();
         }
    }
    public static testMethod void TestLG_NumbersCaseUtill(){
        
        Case c = [select Id,LG_Service__c, LG_Solution__c, status from Case LIMIT 1];
        Id CaseRtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Manage Numbers').getRecordTypeId();       
        c.RecordTypeId = CaseRtId;
        update c;
        csord__Solution__c sol = [select Id,LG_Jeopardy__c, LG_RetryInstall__c, LG_RetryProvision__c,  LG_InflightChange__c from csord__Solution__c where id = :c.LG_Solution__c LIMIT 1];
        sol.LG_Jeopardy__c = False;
        sol.LG_RetryProvision__c = False;
        sol.LG_InflightChange__c = False;
        sol.LG_RetryInstall__c = True;
        update sol;
        
        //Insert Install case
        Id CaseRtId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Install').getRecordTypeId(); 
       
        Case c2 = new Case(LG_Solution__c = sol.Id, recordtypeid = CaseRtId1, reason = 'Test Reason', status = 'New' ,type='Modify');
        insert c2;
        
        List<Id> recIds = new List<Id>();      
        recIds.add(c.Id);
		  User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
        string msg = LG_CloseCaseUtill.closeCase(recIds);
        Test.stopTest();

        csord__Solution__c sol1 = [select Id,LG_Jeopardy__c, LG_RetryProvision__c,  LG_InflightChange__c from csord__Solution__c where id = :c.LG_Solution__c LIMIT 1];
        Case c1 = [select Id,LG_Service__c, LG_Solution__c,type, status from Case where recordtypeid = :CaseRtId LIMIT 1];
        System.assertEquals('Closed', c1.Status);     
        Case c3 = [select Id,LG_Service__c, LG_Solution__c, status,type from Case where recordtypeid = :CaseRtId1 LIMIT 1];
        System.assertEquals('Cancelled', c3.Status); 
         }
    }    
}