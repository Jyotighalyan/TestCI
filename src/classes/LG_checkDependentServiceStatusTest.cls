/**
 * Test class for  LG_checkDependentServiceStatus
 *
 * @author ravi choudhary
 * @ticket 
 * @since  18/01/2018
 */
@isTest
public class LG_checkDependentServiceStatusTest {

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
    csord__Solution__c solution1 = new csord__Solution__c(Name = 'Test Solution First1', csord__Order__c = orders[0].Id, csord__Status__c = 'In Progress', csord__Identification__c = '1122334455', LG_AccessAvailable__c = False , LG_SecondaryAccessAvailable__c = False);
    solutions.add(solution1);
    csord__Solution__c solution2 = new csord__Solution__c(Name = 'Test Solution First2', csord__Order__c = orders[0].Id, csord__Status__c = 'In Progress', csord__Identification__c = '2222334455', LG_AccessAvailable__c = False , LG_SecondaryAccessAvailable__c = False);
    solutions.add(solution2);
    insert solutions;
    
    
    List<csord__Subscription__c> subscriptions = new List<csord__Subscription__c>();
    subscriptions.add(new csord__Subscription__c(Name = 'Test Subscription First',  csord__Solution__c = solutions[0].Id, csord__Identification__c = '2335558881'));
    insert subscriptions;
    List<csord__Service__c> services1 = new List<csord__Service__c>();
    csord__Service__c secondarySer = new csord__Service__c(Name = 'Test Service2',LG_ServiceStatus__c ='Requested', LG_Suborder__c = solution1.Id, csord__Subscription__c = subscriptions[0].Id, csord__Status__c = 'Requested', csord__Solution__c = solution1.Id, csord__Identification__c = '3445556659', LG_ProvisioningAccountNo__c = '123455');
    services1.add(secondarySer);
    //services1.add(ser1);
    insert services1;
    
    List<csord__Service__c> services = new List<csord__Service__c>();
    
    csord__Service__c ser = new csord__Service__c(Name = 'Test Service1',LG_ServiceStatus__c ='Requested', LG_Suborder__c = solution2.Id, csord__Subscription__c = subscriptions[0].Id, csord__Status__c = 'Requested', csord__Solution__c = solution2.Id, csord__Identification__c = '3445556659', LG_ProvisioningAccountNo__c = '123444', UM_DependsOnService__c = null, LG_DependsOnSecondaryService__c = secondarySer.Id);
    services.add(ser);
    
    csord__Service__c intser = new csord__Service__c(Name = 'Test Service4',LG_ServiceStatus__c ='Requested', LG_Suborder__c = solution2.Id, csord__Subscription__c = subscriptions[0].Id, csord__Status__c = 'Requested', csord__Solution__c = solution2.Id, csord__Identification__c = '3445556659', LG_ProvisioningAccountNo__c = '123444', UM_DependsOnService__c = null , LG_DependsOnSecondaryService__c = null );
    services.add(intser);
    
    services.add(new csord__Service__c(Name = 'Test BGP First',LG_ServiceStatus__c ='Requested', LG_Suborder__c = solution2.Id, csord__Subscription__c = subscriptions[0].Id, csord__Status__c = 'Requested', csord__Solution__c = solution2.Id, csord__Identification__c = '4445556659', LG_ProvisioningAccountNo__c = '1234', UM_DependsOnService__c = intser.Id, LG_DependsOnSecondaryService__c = secondarySer.Id));
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

    LG_checkDependentServiceStatus  checkDependentServiceStatus= new LG_checkDependentServiceStatus();
    steps = checkDependentServiceStatus.process(steps);

    Test.stopTest();

    for (SObject obj : steps) {

      CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
      System.assertEquals('Complete', step.CSPOFA__Status__c, 'Status should be complete');
    }
  }

  @IsTest
  public static void scanSecondaryDependentServicesTest() {

    Map<Id, CSPOFA__Orchestration_Process__c> processMap = new Map<Id, CSPOFA__Orchestration_Process__c>([SELECT Id FROM CSPOFA__Orchestration_Process__c]);

    Test.startTest();

    LG_checkDependentServiceStatus  checkDependentServiceStatus= new LG_checkDependentServiceStatus();
    checkDependentServiceStatus.scanDependentServices(processMap.keySet());

    Test.stopTest();

    csord__Solution__c sol= [SELECT Id, LG_AccessAvailable__c, LG_SecondaryAccessAvailable__c  FROM csord__Solution__c WHERE csord__Identification__c = '2222334455'];
    
   
    System.assert(sol.LG_SecondaryAccessAvailable__c , 'solution is not updated for LG_SecondaryAccessAvailable__c flag');
  }
}