/**
 * Utillity class for blocking CAMA Inflight simple change
 *
 * @author Ravi Choudhary
 * @ticket SFOM-1133
 * @since  25/07/2017
*/
@IsTest
public class LG_CamaOrderUtilTest {

    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        Account acc = LG_GeneralTest.CreateAccount('TestAccount', '321654987', 'Test', true);

        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, true);
        
        // Solution 
        csord__Solution__c sol = new csord__Solution__c(Name = 'Test Solution', LG_ProvisioningWorkOrder__c ='Cama-1', csord__Identification__c = '123456789');
        insert sol;
        
        // Solution 
        csord__Solution__c sol1 = new csord__Solution__c(Name = 'Test Solution', LG_ProvisioningWorkOrder__c ='', csord__Identification__c = '1234567891');
        insert sol1;
            
             
        // Subscripton 
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '6465467986');
        insert sub; 
    
        // Service 
        csord__Service__c service = new csord__Service__c(Name='TestService0',csord__Identification__c='6465467986',csord__Activation_Date__c=Date.today(),LG_Effectivedate__c=Date.today(), LG_ServiceStatus__C = 'Provisioned',LG_ProvisioningSystem__c = 'CAMA', LG_Suborder__c = sol.Id, csord__Subscription__c= sub.id ) ;
        insert service;
        
        // Service 
        csord__Service__c service1 = new csord__Service__c(Name='TestService1',csord__Identification__c='6465467996',csord__Activation_Date__c=Date.today(),LG_Effectivedate__c=Date.today(), LG_ServiceStatus__C = 'Provisioned',LG_ProvisioningSystem__c = 'test', LG_Suborder__c = sol1.Id, csord__Subscription__c= sub.id ) ;
        insert service1;
          
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    
    @isTest
    public static void validateProvisioningSystemTest()
    {        
        Id solutionId;
        String temp = '123456789';
        List<csord__Solution__c> sol = [SELECT Id, Name FROM csord__Solution__c where csord__Identification__c =:temp ];
        for (csord__Solution__c solutions : sol ) {
            solutionId = solutions.Id;
        }       
        Test.startTest();
        String message = LG_CamaOrderUtil.checkProvisioningSystem(solutionId);
        system.debug('message'+ message);
        Test.stopTest();
    
        System.assertEquals(message,'This suborder is covered by Cama-1 in CAMA. Please request this change there.');
    }
    
    
    @isTest
    public static void validateProvisioningSystemFailureTest()
    {        
        Id solutionId;
        String temp = '1234567891';
        List<csord__Solution__c> sol = [SELECT Id, Name FROM csord__Solution__c where csord__Identification__c =:temp ];
        for (csord__Solution__c solutions : sol ) {
            solutionId = solutions.Id;
        }       
        Test.startTest();
        String message = LG_CamaOrderUtil.checkProvisioningSystem(solutionId);
        Test.stopTest();
    
        System.assertEquals(message,'Success');
    }
    
}