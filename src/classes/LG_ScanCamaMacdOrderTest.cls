/**
 * Test class for  LG_ScanCamaMacdOrder
 *
 * @author ravi choudhary
 * @ticket 
 * @since  25/08/2017
 */
@isTest
public class LG_ScanCamaMacdOrderTest {

  @testSetup
  private static void setupTestData() {

    No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    noTriggers.Flag__c      = true;
    noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
    upsert noTriggers;

    csordtelcoa__Orders_Subscriptions_Options__c osOptions = new csordtelcoa__Orders_Subscriptions_Options__c();
    osOptions.LG_OrderPartiallyCompletedStatus__c = 'Some Suborders Completed';
    osOptions.LG_OrderCompleteStatus__c           = 'Completed';
    osOptions.LG_OrderCanceledStatus__c           = 'Canceled';
    insert osOptions;

    // Insert two Orders
    List<csord__Order__c> orders = new List<csord__Order__c>();

    orders.add(new csord__Order__c(Name = 'Test Order First', csord__Status2__c = 'In Provisioning', csord__Identification__c = '123456789'));
    
    insert orders;

    List<csord__Solution__c> solutions = new List<csord__Solution__c>();    
    solutions.add(new csord__Solution__c(Name = 'Test Solution First', csord__Order__c = orders[0].Id, csord__Status__c = 'New', csord__Identification__c = '1122334455', LG_ExistingCama__c = false));
    insert solutions;
    
    List<csord__Subscription__c> subscriptions = new List<csord__Subscription__c>();
    subscriptions.add(new csord__Subscription__c(Name = 'Test Subscription First',  csord__Solution__c = solutions[0].Id, csord__Identification__c = '2335558881'));
    insert subscriptions;
    
    List<csord__Service__c> services = new List<csord__Service__c>();
    services.add(new csord__Service__c(Name = 'Test Service First',LG_ServiceStatus__c ='Active', LG_Suborder__c = solutions[0].Id, csord__Subscription__c = subscriptions[0].Id, csord__Status__c = 'Requested', csord__Solution__c = solutions[0].Id, csord__Identification__c = '4445556659', LG_ProvisioningAccountNo__c = '1234'));
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

    LG_ScanCamaMacdOrder  camaOrderStep= new LG_ScanCamaMacdOrder();
    steps = camaOrderStep.process(steps);

    Test.stopTest();

    for (SObject obj : steps) {

      CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
      System.assertEquals('Complete', step.CSPOFA__Status__c, 'Status should be complete');
    }
  }

  @IsTest
  public static void scanCurrentSolutionTest() {

    Map<Id, CSPOFA__Orchestration_Process__c> processMap = new Map<Id, CSPOFA__Orchestration_Process__c>([SELECT Id FROM CSPOFA__Orchestration_Process__c]);

    Test.startTest();

    LG_ScanCamaMacdOrder  camaOrderStep= new LG_ScanCamaMacdOrder();
    camaOrderStep.scanCurrentSolution(processMap.keySet());

    Test.stopTest();

    csord__Solution__c sol= [SELECT Id, LG_ExistingCama__c FROM csord__Solution__c WHERE csord__Identification__c = '1122334455']; 
    
    // Assert after
    System.assertEquals(true, sol.LG_ExistingCama__c , 'should be existing cama order');
  }
}