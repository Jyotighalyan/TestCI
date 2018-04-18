/**
 * Case trigger test
 * 
 * @author Petar Miletic
 * @ticket SFOM-317
 * @since 30/01/2017
*/
@IsTest
public class LG_CaseTriggerHandlerTest {

    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        List<Case> cases = new List<Case>();
        List<csord__Solution__c> solutions = new List<csord__Solution__c>();
        List<csord__Service__c> services = new List<csord__Service__c>();
        
        List<RecordType> caseRecordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND Name IN ('Install', 'Provision', 'Number Port', 'Activate Service', 'Access Planning','Manage Logistics','Manage Tenant','Provision One Step')];
        
        for (Integer i = 0; i < caseRecordTypes.size(); i++) 
        {
        
            solutions.add(new csord__Solution__c(Name = 'Solution ' + i, csord__Identification__c = '123456' + i));
            services.add(new csord__Service__c(Name = 'Service ' + i, csord__Identification__c = '123456' + i,UM_LogisticsReference__c='',UM_ESN__c=''));
            Case obj = new Case();
            obj.subject= caseRecordTypes[i].Name + '_test';
            obj.priority='p2';
            obj.type='Service';
            obj.Description='description';
            obj.origin='Email';
            obj.RecordTypeId = caseRecordTypes[i].Id;
            obj.Status = 'New';
            obj.Type = '';
            cases.add(obj);
            
        }

        insert solutions;


        // Subscripton 
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '6465467986');
        insert sub; 
        
        for (Integer i = 0; i < solutions.size(); i++)
        {
            cases[i].LG_Solution__c = solutions[i].Id;
            services[i].csord__Subscription__c = sub.Id;
            services[i].csord__Solution__c = solutions[i].Id;
            services[i].csord__Activation_Date__c = Date.today();
        }
        
        insert cases;
        insert services;
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }

   
    /*
     * Case trigger, Constrain selection of Case Reason based on Case Record Type
     * 
     * @author Petar Miletic
     * @ticket SFOM-317
     * @since 30/01/2017
    */
    @IsTest
    public static void updateSolutionJeopardyReasonTest() 
    {
        Map<Id, Case> oldCases = new Map<Id, Case>([SELECT Id, LG_Solution__c, Reason, RecordType.Name FROM Case WHERE RecordType.Name IN ('Install', 'Provision', 'Number Port', 'Activate Service', 'Access Planning')]);
        List<Case> cases = [SELECT Id, LG_Solution__c, Reason, RecordType.Name FROM Case WHERE RecordType.Name IN ('Install', 'Provision', 'Number Port', 'Activate Service', 'Access Planning')];
        User thisUser=[select id from User where id=:UserInfo.getUserId()];
        System.runAs(thisUser){
        test.startTest();
        
        // Set values based on Record Type
        for (Case obj :cases) 
        {
        
            if (obj.RecordType.Name == 'Install') 
            {
            obj.Reason = 'Field Support (Contractor)';
            } 
            else if (obj.RecordType.Name == 'Provision')  
            {
            obj.Reason = 'Address not found';
            } 
            else if (obj.RecordType.Name == 'Number Port')  
            {
            obj.Reason = 'Customer has uncleared debts';
            } 
            else if (obj.RecordType.Name == 'Activate Service')  
            {
            obj.Reason = 'Resource not available';
            } 
            else if (obj.RecordType.Name == 'Access Planning')  
            {
            obj.Reason = 'Site not serviceable';
            } 
            else 
            {
            throw new LG_Exception('Unsupported record type');
            }
        }
        
        // Update cases to populate Reason field
        update cases;
        
        // Resolve Jeopardy Reason
        LG_CaseTriggerHandler.updateSolutionJeopardyReason(cases, oldCases);
        
        test.stopTest();
        }
        
        // Reload cases
        Map<Id, Case> newCases = new Map<Id, Case>([SELECT Id, LG_Solution__c, LG_Solution__r.Jeopardy_Reason__c, Reason, RecordType.Name FROM Case WHERE RecordType.Name IN ('Install', 'Provision', 'Number Port', 'Activate Service', 'Access Planning')]);
        
        // Test values
        for (Case updatedCase :newCases.values()) {
        
        String reason = updatedCase.Reason.toLowerCase();
        String jeopardy = updatedCase.LG_Solution__r.Jeopardy_Reason__c.toLowerCase();
        
        System.assertEquals(reason, jeopardy, 'Invalid data');
        }
    }
    
  
   @IsTest
    public static void validateAppointmentTest()
    {
        csord__Solution__c sol = new csord__Solution__c(Name = 'Solution Insert', csord__Identification__c = '654321789');
        sol.LG_AnyNumbersToPort__c = true;
        sol.LG_LatestPortingWishDate__c = (Date.today() + 8);
        sol.LG_TargetDate__c = (Date.today() + 10);
        insert sol;
        system.assertequals('Solution Insert',sol.Name);
        List<RecordType> caseRecordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND Name IN ('Schedule Appointment') ORDER BY Name];
        
        Case newObj = new Case();
        newObj.RecordTypeId = caseRecordTypes[0].Id;
        newObj.Status = 'Closed';
        newObj.type = 'Modify';
        newObj.LG_Solution__c = sol.Id;
        newObj.Reason = 'Site not serviceable';
        insert newObj;
        
        CSPOFA__Orchestration_Process_Template__c processTemplate = new CSPOFA__Orchestration_Process_Template__c();
        processTemplate.Name = 'Process template';
        insert processTemplate;
        
        CSPOFA__Orchestration_Process__c orchProcess = new CSPOFA__Orchestration_Process__c();
        orchProcess.Name = 'Orch Process';
        orchProcess.CSPOFA__Orchestration_Process_Template__c = processTemplate.Id;
        orchProcess.CSPOFA__Process_On_Hold__c = false;
        orchProcess.LG_Solution__c = sol.Id;
        insert orchProcess;
        
        CSPOFA__Orchestration_Step__c processstep = new CSPOFA__Orchestration_Step__c();
        processstep.CSPOFA__Step_Order__c = 37;
        processstep.CSPOFA__Status__c = 'In Progress';
        processstep.CSPOFA__Orchestration_Process__c = orchProcess.Id;
        insert processstep;
        
        List<Case> cases = [SELECT Id, LG_Solution__c, Reason, RecordType.Name, Status FROM Case WHERE Status= 'Closed'];
        
        //cases.add(newObj);
        System.debug('cases-->'+cases);
        User thisUser=[select id from User where id=:UserInfo.getUserId()];
        System.runAs(thisUser)
        {
            test.startTest();
            // Resolve Jeopardy Reason
            LG_CaseTriggerHandler.validateAppointment(cases);
            sol.LG_AnyNumbersToPort__c = false;
            update sol;
            LG_CaseTriggerHandler.validateAppointment(cases);
            test.stopTest();
        }
    }
    /*
     * Test Method to validate case status
     * 
     * @author Preetha N
     *
     * @since 27/03/2018
    */
   Public  static testmethod  void  validateCaseStatusTest()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        Account acc = LG_GeneralTest.CreateAccount('OMTestAccount', '321654987', 'Test', true);
        acc.LG_ChamberOfCommerceNumber__c='123';
        update acc;
        
        Contact con = new Contact();
        con.Email = 'rishi.kapoor@gmail.com';
        con.LG_DecisionMaker__c = true;
        con.HasOptedOutOfEmail = false;
        con.Salutation ='Mr.';
        con.LastName = 'Kapoor';
        con.FirstName = 'Rishi';
        con.AccountId = acc.Id;
        con.LG_Role__c = 'Business User;Financial Contact';
        con.Generate_Activation_Code__c=True;
        insert con;
        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, false);
        opp.LG_PrimaryContact__c=con.id;
        insert opp;
        
        //Solution
        csord__Solution__c solution = new csord__Solution__c(Name = 'test solution',csord__Identification__c = '6465467986',LG_JeopardyExplanation__c='');
        insert solution;
        cscrm__Address__c address = LG_GeneralTest.crateAddress('TestAddress', 'street', 'city', '5', '73', '2014GC', 'Netherlands', acc, true);
        address.LG_AddressID__c = '123456';
        upsert address ;
        
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'IdentSub');
        insert sub;
        //Services
        List<csord__Service__c> services = new List<csord__Service__c>();
        csord__Service__c serviceActive = new csord__Service__c(csord__Status__c = 'Activation Completed', csord__Subscription__c = sub.Id,
        LG_ProvisioningCode__c='1PLAY150B',  csord__Identification__c = 'serviceActive', LG_Suborder__c = solution.Id,LG_Address__c = address.Id,LG_DecompositionCriteria__c = 'Set 10 - SIPWISE');
        services.add(serviceActive);
        insert services;
        
        //Case
        List<RecordType> caseRecordTypes = [SELECT Id, Name,SobjectType FROM RecordType WHERE SobjectType = 'Case' AND Name IN ('Install', 'Provision', 'Number Port', 'Activate Service', 'Access Planning','Manage Logistics','Manage Tenant','Provision One Step','Schedule Appointment')];
        csord__Order__c ord = new csord__Order__C(Name = 'Test Order', csord__Account__c =acc.id, csordtelcoa__Opportunity__c= opp.id, csord__Identification__c = '12345');
        ord.csord__Status2__c = 'Cancel Requested';
        insert ord;
        
        List<Case> casesNew = new List<Case>();
        for (Integer i = 0; i < caseRecordTypes.size(); i++)
        {
            Case c = new Case(LG_Solution__c = solution.Id,Status = 'Closed',type='Hpbx-Provision Kundensetup');
            c.RecordTypeId = caseRecordTypes[i].Id;
            c.Reason = 'Customer Issue';
            c.LG_Order__c=ord.id;
            casesNew.add(c);
        }
        insert casesNew;
        test.startTest();
        LG_CaseTriggerHandler.validateCaseStatus(casesNew);
        LG_CaseTriggerHandler.updateSolutionJeopardyReason(casesNew);
        test.stoptest();
    }

}