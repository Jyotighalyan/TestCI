/**
 * Test class for LG_ServiceProvisioningStep
 *
 * @author ALisha
 * @ticket SFOM-672
 * @since  20/06/2017
 */
@isTest
public class LG_ServiceProvisioningStepTest {

    @testSetup
  private static void setupTestData()
  {
    No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    noTriggers.Flag__c      = true;
    noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
    upsert noTriggers;

        //custom setting to get auth values
        UM_MinervaConnection__c  connection = UM_MinervaConnection__c.getInstance();
        connection.Connection_URL__c   = 'https://appst.unitymedia.de/MinervaWS/MinervaWSService';
        connection.Authentication_Token__c ='Basic bWluZXJ2YS1zZm9tLndzOm0xbjNydkAtczcwbTIwMDA=';
        connection.Session_Timeout__c = '120000';

        insert connection;
        system.debug('connection--' + connection);



        Account acc = LG_GeneralTest.CreateAccount('OMTestAccount', '321654987', 'Test', true);
        acc.LG_ChamberOfCommerceNumber__c='123';
        update acc;

        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, true);
        
        cscrm__Address__c address = LG_GeneralTest.crateAddress('TestAddress', 'street', 'city', '5', '73', '2014GC', 'Netherlands', acc, true);
        address.LG_AddressID__c = '123456';
        upsert address ;
        //Order
        csord__Order__c ord = new csord__Order__C(Name = 'Test Order', csord__Account__c =acc.id, csordtelcoa__Opportunity__c= opp.id, csord__Identification__c = '12345');
        ord.csord__Status2__c = 'Cancel Requested';
        insert ord;
        
        csord__Solution__c solutionObject = new csord__Solution__c ();
        solutionObject.Name = 'test';
        solutionObject.csord__Order__c =ord.Id;
        solutionObject.csord__Identification__c = 'Test';
        solutionObject.csord__Account__c= acc.id;
        solutionObject.LG_Address__c=address.id;
        insert solutionObject;
        
        CSPOFA__Orchestration_Process_Template__c processTemplate = new CSPOFA__Orchestration_Process_Template__c();
         processTemplate.Name = 'Process template';
         insert processTemplate;
         
         CSPOFA__Orchestration_Process__c orchProcess = new CSPOFA__Orchestration_Process__c();
         orchProcess.Name = 'Orch Process';
         orchProcess.CSPOFA__Process_On_Hold__c = false;
         orchProcess.CSPOFA__Orchestration_Process_Template__c = processTemplate.Id;
         orchProcess.LG_Solution__c = solutionObject.Id;
         insert orchProcess;



    List<CSPOFA__Orchestration_Step__c> steps = new List<CSPOFA__Orchestration_Step__c>();
    steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = orchProcess.Id));
    insert steps;
    csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'IdentSub');
    insert sub;

    List<csord__Service__c> services = new List<csord__Service__c>();
    csord__Service__c serviceActive = new csord__Service__c(csord__Status__c = 'Activation Completed', csord__Subscription__c = sub.Id,
                              LG_ProvisioningCode__c='1PLAY150B',  csord__Identification__c = 'serviceActive', LG_Suborder__c = solutionObject.Id,LG_Address__c = address.Id);
    services.add(serviceActive);
    insert services;

    noTriggers.Flag__c = false;
    upsert noTriggers;
  }

  

  public static testmethod void testProcess()
  
  {
    
    List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__r.name='Orch Process'];
    System.debug('Steps' + steps);
    csord__Solution__c sol=[select id,name,csord__Account__c,csord__Account__r.NumberOfEmployees, csord__Account__r.LG_ChamberOfCommerceNumber__c,LG_Address__r.cscrm__State_Province__c,LG_Address__c,LG_Address__r.LG_AddressID__c,csord__Status__c,csord__Order__c from csord__Solution__c where name = 'test'];
    for (SObject obj : steps) {
      CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
      System.assertNotEquals('Complete', step.CSPOFA__Status__c, 'Status should not be complete');
    }


    Test.startTest();
       LG_ServiceProvisioningStep checkServices = new LG_ServiceProvisioningStep();
        steps = checkServices.process(steps);
        
        // UM_PlaceOrder classObj = new UM_PlaceOrder();
        // classObj.createOrder(sol);
        Test.stopTest();

    for (SObject obj : steps) {
      CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
     // System.assertEquals('Complete', step.CSPOFA__Status__c, 'Complete');
    }
  }

  
}