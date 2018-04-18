@isTest
public class LG_SetActivationCompletedStatusStepTest {
    
  @testSetup
  private static void setupTestData(){
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
        
        contact c=new contact();
		c.Salutation='Mr';
        c.LastName='test';
        c.AccountId=acc.id;
        c.Email='test@gtr.com';
        c.Phone='09850027690';
        insert c;
        

        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, true);
         cscrm__Address__c address = LG_GeneralTest.crateAddress('TestAddress', 'street', 'city', '5', '73', '2014GC', 'Netherlands', acc, true);
        address.LG_AddressID__c = '123456';
        address.LG_TechnicalContact__c=c.id;
        upsert address ;
        
          cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('TestBasket', acc, null, opp, true);
         

        // Generate Product Definition
        cscfga__Product_Definition__c prodDef = LG_GeneralTest.createProductDefinition('ProdDef58', false);
        prodDef.LG_NeedsActivation__c   = 'Y,Y,Y';
        prodDef.LG_NeedsInstallation__c = 'N,N,N';
        insert prodDef;

        // Generate Product Definition
        cscfga__Product_Definition__c prodDefEmpty = LG_GeneralTest.createProductDefinition('ProdDef58', false);
        prodDefEmpty.LG_NeedsActivation__c = '';
        insert prodDefEmpty;

        // Generate Product Configuration
        cscfga__Product_Configuration__c prodConfig = LG_GeneralTest.createProductConfiguration('ProdConf58', 3, basket, prodDef, true);
        prodConfig.LG_Address__c=address.id;
        update prodConfig;

        // Generate Product Configuration
        cscfga__Product_Configuration__c prodConfigEmpty = LG_GeneralTest.createProductConfiguration('ProdConfEmpty', 3, basket, prodDefEmpty, true);
             basket.csordtelcoa__Synchronised_with_Opportunity__c=true;
             update basket;
        
       
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
    csord__Service__c serviceActive = new csord__Service__c(Name='testservice',csord__Status__c = 'Requested', csord__Subscription__c = sub.Id,
                              LG_ProvisioningCode__c='1PLAY150B',  csord__Identification__c = 'serviceActive', LG_Suborder__c = solutionObject.Id,LG_Address__c = address.Id, LG_ProductFamily__c='Connection');
    services.add(serviceActive);
    insert services;

    noTriggers.Flag__c = false;
    upsert noTriggers;
  }
  
    public static testmethod void testProcess(){
        List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c where CSPOFA__Orchestration_Process__r.name='Orch Process'];
        System.debug('Steps' + steps);
        csord__Service__c  ser=[select id,LG_ProvisioningAccountNo__c from csord__Service__c   where name='testservice' limit 1 ];
        ser.LG_ProvisioningAccountNo__c='123';
        update ser;
        csord__Solution__c sol=[select id,name,csord__Account__c,csord__Account__r.NumberOfEmployees, csord__Account__r.LG_ChamberOfCommerceNumber__c,LG_Address__r.cscrm__State_Province__c,LG_Address__c,LG_Address__r.LG_AddressID__c,csord__Status__c,csord__Order__c from csord__Solution__c where name = 'test'];
        for (SObject obj : steps) {
          CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
          System.assertNotEquals('Complete', step.CSPOFA__Status__c, 'Status should not be complete');
        }
        
        
        Test.startTest();
        LG_SetActivationCompletedStatusStep checkServices = new LG_SetActivationCompletedStatusStep();
        steps = checkServices.process(steps);
        Test.stopTest();
        
        for (SObject obj : steps) {
          CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
         // System.assertEquals('Complete', step.CSPOFA__Status__c, 'Complete');
        }
        
     //   System.assertEquals('Activation Completed',[select id,LG_ProvisioningAccountNo__c,csord__Status__c from csord__Service__c   where name='testservice' limit 1 ].csord__Status__c);

    }

}