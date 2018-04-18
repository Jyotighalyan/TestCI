/**
 * Test class for  LG_checkSecondaryDependentService
 *
 * @author Navneet Sanotra
 * @ticket SFOM-2766
 * @since  13/03/2018
 */
@isTest
public class LG_checkSecondaryDependentServiceTest {

  @testSetup
  private static void setupTestData() {

    No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    noTriggers.Flag__c      = true;
    noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
    upsert noTriggers;

    // Insert two Orders
    List<csord__Order__c> orders = new List<csord__Order__c>();

    orders.add(new csord__Order__c(Name = 'Test Order First', csord__Status2__c = 'In Provisioning', csord__Identification__c = '123456789'));
    
    insert orders;

    List<csord__Solution__c> solutions = new List<csord__Solution__c>();    
    csord__Solution__c solution = new csord__Solution__c(Name = 'Test Solution First', csord__Order__c = orders[0].Id, csord__Status__c = 'In Progress', csord__Identification__c = '1122334455', LG_DependsOnSecondary__c = false);
    solutions.add(solution);
    insert solutions;
    
    
    List<csord__Subscription__c> subscriptions = new List<csord__Subscription__c>();
    subscriptions.add(new csord__Subscription__c(Name = 'Test Subscription First',  csord__Solution__c = solutions[0].Id, csord__Identification__c = '2335558881'));
    insert subscriptions;
    List<csord__Service__c> services1 = new List<csord__Service__c>();
    csord__Service__c ser = new csord__Service__c(Name = 'Test Service1',LG_ServiceStatus__c ='Requested', LG_Suborder__c = solution.Id, csord__Subscription__c = subscriptions[0].Id, csord__Status__c = 'Requested', csord__Solution__c = solution.Id, csord__Identification__c = '3445556659', LG_ProvisioningAccountNo__c = '123444');
    csord__Service__c secondarySer = new csord__Service__c(Name = 'Test Service2',LG_ServiceStatus__c ='Requested', LG_Suborder__c = solution.Id, csord__Subscription__c = subscriptions[0].Id, csord__Status__c = 'Requested', csord__Solution__c = solution.Id, csord__Identification__c = '3445556659', LG_ProvisioningAccountNo__c = '123455');
    //csord__Service__c ser1 = new csord__Service__c(Name = 'Test Service 2',LG_ServiceStatus__c ='Requested', LG_Suborder__c = solution.Id, csord__Subscription__c = subscriptions[0].Id, csord__Status__c = 'Requested', csord__Solution__c = solution.Id, csord__Identification__c = '34445556659', LG_ProvisioningAccountNo__c = '1442345');
    services1.add(ser);
    services1.add(secondarySer);
    //services1.add(ser1);
    insert services1;
    
    List<csord__Service__c> services = new List<csord__Service__c>();
    services.add(new csord__Service__c(Name = 'Test BGP First',LG_ServiceStatus__c ='Requested', LG_Suborder__c = solution.Id, csord__Subscription__c = subscriptions[0].Id, csord__Status__c = 'Requested', csord__Solution__c = solution.Id, csord__Identification__c = '4445556659', LG_ProvisioningAccountNo__c = '1234', UM_DependsOnService__c = ser.Id, LG_DependsOnSecondaryService__c = secondarySer.Id));
    //services.add(new csord__Service__c(Name = 'Test Company Cloud Fiber First',LG_ServiceStatus__c ='Requested', LG_Suborder__c = solution.Id, csord__Subscription__c = subscriptions[0].Id, csord__Status__c = 'Requested', csord__Solution__c = solution.Id, csord__Identification__c = '4445556659', LG_ProvisioningAccountNo__c = '12345',csord__Service__c = ser1.Id));
    
    insert services;

    // Orcestrator stuff
    CSPOFA__Orchestration_Process_Template__c orcTemplate = new CSPOFA__Orchestration_Process_Template__c();
    insert orcTemplate;

    // Process first Solution, first Order
    CSPOFA__Orchestration_Process__c process = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id, LG_Solution__c = solutions[0].Id);
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

    LG_checkSecondaryDependentService  checkSecDependentService= new LG_checkSecondaryDependentService();
    steps = checkSecDependentService.process(steps);

    Test.stopTest();

    for (SObject obj : steps) {

      CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
      System.assertEquals('Complete', step.CSPOFA__Status__c, 'Status should be complete');
    }
  }

  @IsTest
  public static void scanDependentServicesTest() {

    Map<Id, CSPOFA__Orchestration_Process__c> processMap = new Map<Id, CSPOFA__Orchestration_Process__c>([SELECT Id FROM CSPOFA__Orchestration_Process__c]);

    Test.startTest();

    LG_checkSecondaryDependentService  checkSecondaryDependentService = new LG_checkSecondaryDependentService();
    checkSecondaryDependentService.scanDependentServices(processMap.keySet());

    Test.stopTest();

    csord__Solution__c sol= [SELECT Id, LG_DependsOnSecondary__c  FROM csord__Solution__c WHERE csord__Identification__c = '1122334455'];
   // csord__Solution__c sol1= [SELECT Id, Jira_Flow__c FROM csord__Solution__c WHERE csord__Identification__c = '1122334454'];
    
    // Assert after
     System.assert(sol.LG_DependsOnSecondary__c , 'depends on secondary service solution flag is not updated');
    //System.assertEquals('Manual', sol1.Jira_Flow__c , 'should be Manual flow');
  }
}