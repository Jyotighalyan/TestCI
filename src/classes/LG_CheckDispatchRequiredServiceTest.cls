/**
 * Test class for  LG_CheckDispatchRequiredServiceTest
 *
 * @author Navneet Sanotra
 * @ticket SFOM-2766
 * @since  13/03/2018
 */
@isTest
public class LG_CheckDispatchRequiredServiceTest {

  @testSetup
  private static void setupTestData() {

    No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    noTriggers.Flag__c      = true;
    noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
    upsert noTriggers;
    
    Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'New Accoun 1', true);

    Opportunity opp = LG_GeneralTest.CreateOpportunity(account, false);
    insert opp;
    
    opp.csordtelcoa__Change_Type__c = 'New'; // for New scenario.
   // opp.csordtelcoa__Change_Type__c = 'Change'; // for change scenario.
    update opp;
    
    //product definition
    cscfga__Product_Definition__c prdConf = new cscfga__Product_Definition__c(Name='Company Cloud Connect Offnet',cscfga__Description__c='Description of TestProductDefinition');
    insert prdConf;
    
   // cscfga__Product_Definition__c prdConf = new cscfga__Product_Definition__c(Name='Company Cloud Connect',cscfga__Description__c='Description of TestProductDefinition');
   // insert prdConf;
    
    //product configuration
    cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c(cscfga__Product_Family__c = prdConf.Name,cscfga__Attribute_Name__c='testAttribute',Name='Company Cloud Connect Offnet',cscfga__Product_Definition__c = prdConf.Id);
   	insert pc;
    
    // Insert two Orders
    List<csord__Order__c> orders = new List<csord__Order__c>();

    orders.add(new csord__Order__c(Name = 'Test Order First', csord__Status2__c = 'In Provisioning', csord__Identification__c = '123456789', csordtelcoa__Opportunity__c = opp.Id));
    
    insert orders;

    List<csord__Solution__c> solutions = new List<csord__Solution__c>();    
    csord__Solution__c solution1 = new csord__Solution__c(Name = 'Test Solution First', csord__Order__c = orders[0].Id, csord__Status__c = 'In Progress', csord__Identification__c = '2222334455', LG_LogisticsDispatchNeeded__c = false);
    solutions.add(solution1);
    csord__Solution__c solution2 = new csord__Solution__c(Name = 'Test Solution Two', csord__Order__c = orders[0].Id, csord__Status__c = 'In Progress', csord__Identification__c = '1122334455', LG_LogisticsDispatchNeeded__c = false);
    solutions.add(solution2);
    insert solutions;
    
    
    List<csord__Subscription__c> subscriptions = new List<csord__Subscription__c>();
    subscriptions.add(new csord__Subscription__c(Name = 'Test Subscription First',  csord__Solution__c = solutions[0].Id, csord__Identification__c = '2335558881'));
    insert subscriptions;
    
    List<csord__Service__c> services1 = new List<csord__Service__c>();
    csord__Service__c ser = new csord__Service__c(csordtelcoa__Product_Configuration__c=pc.Id, Name = 'VDSL',LG_ServiceStatus__c ='Requested',LG_Primary_Access_Type__c = 'Offnet',LG_Primary_Check__c = true, LG_Suborder__c = solution1.Id, csord__Subscription__c = subscriptions[0].Id, csord__Status__c = 'Requested', csord__Solution__c = solution1.Id, csord__Identification__c = '3445556659', LG_ProvisioningAccountNo__c = '123444');
   
    services1.add(ser);
    insert services1;
    
    List<csord__Service__c> services = new List<csord__Service__c>();
    services.add(new csord__Service__c(Name = 'Test INTS Child',LG_ServiceStatus__c ='Requested', LG_IsExistingHardware__c = false, LG_Suborder__c = solution2.Id, csord__Subscription__c = subscriptions[0].Id, csord__Status__c = 'Requested', csord__Solution__c = solution2.Id, csord__Identification__c = '4445556660', LG_ProvisioningAccountNo__c = '1234', UM_DependsOnService__c = null , LG_DependsOnSecondaryService__c = null, LG_RootOrder__c = orders[0].Id));
    services.add(new csord__Service__c(Name = 'Test BGP First',LG_ServiceStatus__c ='Requested', LG_IsExistingHardware__c = false, LG_Suborder__c = solution2.Id, csord__Subscription__c = subscriptions[0].Id, csord__Status__c = 'Requested', csord__Solution__c = solution2.Id, csord__Identification__c = '4445556659', LG_ProvisioningAccountNo__c = '1234', UM_DependsOnService__c = ser.Id, LG_DependsOnSecondaryService__c = null, LG_RootOrder__c = orders[0].Id));
    //services.add(new csord__Service__c(Name = 'Test Company Cloud Fiber First',LG_ServiceStatus__c ='Requested', LG_Suborder__c = solution.Id, csord__Subscription__c = subscriptions[0].Id, csord__Status__c = 'Requested', csord__Solution__c = solution.Id, csord__Identification__c = '4445556659', LG_ProvisioningAccountNo__c = '12345',csord__Service__c = ser1.Id));
    
    insert services;

    // Orcestrator stuff
    CSPOFA__Orchestration_Process_Template__c orcTemplate = new CSPOFA__Orchestration_Process_Template__c();
    insert orcTemplate;

    // Process first Solution, first Order
    CSPOFA__Orchestration_Process__c process = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id, LG_Solution__c = solution2.Id);
    insert process;

    CSPOFA__Orchestration_Step__c step = new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = process.Id);
    insert step;   

    noTriggers.Flag__c = false;
    upsert noTriggers;
  }

  @isTest
  private static void processTest() {

    List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c];

    for (SObject obj : steps) {

      CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
      System.assertNotEquals('Complete', step.CSPOFA__Status__c, 'Status should not be complete');
    }

    Test.startTest();

    LG_CheckDispatchRequiredService  isDispatchRequiredService = new LG_CheckDispatchRequiredService();
    steps = isDispatchRequiredService.process(steps);

    Test.stopTest();

    for (SObject obj : steps) {

      CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
      System.assertEquals('Complete', step.CSPOFA__Status__c, 'Status should be complete');
    }
  }

  @IsTest
  public static void checkDependentServiceTypeTest() {

    Map<Id, CSPOFA__Orchestration_Process__c> processMap = new Map<Id, CSPOFA__Orchestration_Process__c>([SELECT Id FROM CSPOFA__Orchestration_Process__c where LG_Solution__r.csord__Identification__c = '1122334455']);

    Test.startTest();

    LG_CheckDispatchRequiredService  isDispatchRequiredService = new LG_CheckDispatchRequiredService();
    isDispatchRequiredService.checkDependentServiceType(processMap.keySet());

    Test.stopTest();

    csord__Solution__c sol= [SELECT Id, LG_LogisticsDispatchNeeded__c  FROM csord__Solution__c WHERE csord__Identification__c = '1122334455'];
    
    // Assert after
     System.assert(sol.LG_LogisticsDispatchNeeded__c , 'LG_LogisticsDispatchNeeded__c is not updated');
  }
}
