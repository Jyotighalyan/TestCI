/**
 * Test class for LG_ChangeProvisionExtStep 
 *
 * @author Raju
 * @ticket SFOM-2789
 * @since  14/03/2017
 */
@isTest
public class LG_ChangeProvisionExtStepTest {
    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c      = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        Account acc = new Account(Name = 'TestAcc');
        insert acc;
        Contact con = new Contact(Salutation='Mr.', lastname='TestCon', AccountId = acc.Id,phone='1234567', Email='testemail@test.com');
        insert con;
                                  
        Opportunity opp = new Opportunity(Name='TestOpp', AccountId=acc.Id, Type='New Business', UM_QuotingDate__c=date.today(),
                                         CloseDate=date.today()+2, StageName='Ready for Order',
                                         LG_QuoteExpirationDays__c=10, csordtelcoa__Change_Type__c='Change');
		insert opp;
		
       	csord__Order__c order = new csord__Order__c(Name='Test Order',csord__Identification__c = '6465467986',csordtelcoa__Opportunity__c=opp.id);
        insert order;
        
        List<csord__Solution__c> solutions = new List<csord__Solution__c>();
        csord__Solution__c solutionActiveServiceReplaced = new csord__Solution__c(Name = 'SolActiveServiceReplaced', csord__Identification__c = '1122334455', csord__Order__c =order.Id,LG_OldESNNumber__c='345');
        solutions.add(solutionActiveServiceReplaced);
        insert solutions;

       

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'IdentSub');
        insert sub;

        List<csord__Service__c> serv = new List<csord__Service__c>();
        csord__Service__c serviceActive = new csord__Service__c(UM_ESN__c='123',LG_ServiceStatus__c = 'Activation Completed', csord__Subscription__c = sub.Id,
                                                                csord__Identification__c = 'serviceActive', LG_RootOrder__c=order.id,UM_ProvisioningServiceExternalId__c='135436');
        serv.add(serviceActive);
        insert serv;
        
        List<csord__Service__c> services = new List<csord__Service__c>();
        csord__Service__c serviceActiveReplaced = new csord__Service__c(UM_ESN__c='1234',LG_ServiceStatus__c = 'Activation Completed', csord__Subscription__c = sub.Id,csord__Order__c =order.id,
                                                                        csord__Identification__c = 'serviceActiveReplaced', 
                                                                        LG_Suborder__c = solutionActiveServiceReplaced.Id,
                                                                       LG_RootOrder__c=order.id,UM_ProvisioningServiceExternalId__c=null, csordtelcoa__Replaced_Service__c = serviceActive.Id );
                      
        services.add(serviceActiveReplaced);
        insert services;
      //  csord__Service__c s=[select id,csordtelcoa__Replaced_Service__r.UM_ProvisioningServiceExternalId__c from csord__Service__c where id=:serviceActive.id];
      //  s.csordtelcoa__Replaced_Service__c=serviceActiveReplaced.id;
      //  update s;
      
       CSPOFA__Orchestration_Process_Template__c orcTemplate = new CSPOFA__Orchestration_Process_Template__c();
        insert orcTemplate;
              
       List<CSPOFA__Orchestration_Process__c> processes = new List<CSPOFA__Orchestration_Process__c>();
        CSPOFA__Orchestration_Process__c processActReplaced = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id,
                                                                                                   LG_Solution__c = solutionActiveServiceReplaced.Id);
        processes.add(processActReplaced);
        insert processes;
      
       List<CSPOFA__Orchestration_Step__c> steps = new List<CSPOFA__Orchestration_Step__c>();
        steps.add(new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = processActReplaced.Id));
        insert steps;
      
      
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    private static testmethod void testProcess()
    {
        List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c];

        for (SObject obj : steps) {
            CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
            System.assertNotEquals('Complete', step.CSPOFA__Status__c, 'Status should not be complete');
        }


        Test.startTest();
        LG_ChangeProvisionExtStep a= new LG_ChangeProvisionExtStep ();
        steps = a.process(steps);
        Test.stopTest();

        for (SObject obj : steps) {
            CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
            System.assertEquals('Complete', step.CSPOFA__Status__c, 'Status should not be complete');
        }
    }
    private static testmethod void testMacEsnNumberBlank(){
        
        
        Map<Id, CSPOFA__Orchestration_Process__c> processMap = new Map<Id, CSPOFA__Orchestration_Process__c>([SELECT Id FROM CSPOFA__Orchestration_Process__c where LG_Solution__r.csord__Identification__c = '1122334455']);

    	Test.startTest();

   		LG_ChangeProvisionExtStep  changeProvisionExtStep = new LG_ChangeProvisionExtStep();
    	changeProvisionExtStep.provisioningExtChnage(processMap.keySet());

   		 Test.stopTest();

    	csord__service__c updatedServ = [SELECT Id, Name, UM_ProvisioningServiceExternalId__c  FROM csord__service__c WHERE LG_Suborder__r.csord__Identification__c = '1122334455'];
    
    	// Assert after
     	System.assertequals(updatedServ.UM_ProvisioningServiceExternalId__c,'135436' , 'UM_ProvisioningServiceExternalId__c for the replaced is not updated');
        
    }

}