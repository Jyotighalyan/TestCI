@isTest()
public class UM_UpdateServiceStatusBatchTest {

    static testMethod void myUnitTest() {
        
        
        Account acc1 = new Account (name='testAccount1');
        Insert acc1;
        
        csord__Order__c ord = new csord__Order__c();
        ord.Name = 'Test';
        ord.csord__Status2__c = 'New';
        ord.csord__Identification__c = 'Test';
        ord.csord__Account__c= acc1.id;
        insert ord;
        
        csord__Subscription__c SubscriptionObj= new csord__Subscription__c(Name = 'Test', csord__Identification__c = 'test');
        insert SubscriptionObj;
        
        csord__Service__c serviceObj = new csord__Service__c (LG_ExternalSubscriptionName__c = SubscriptionObj.id, LG_RootOrder__c=ord.Id, Name = 'Test', csord__Status__c = 'Active', LG_MarketSegment__c='Soho',LG_ServiceStatus__c = 'Ready for Billing', csord__Subscription__c =SubscriptionObj.id,LG_ProductFamily__c='Office Internet', csord__Identification__c = 'Test',csord__Activation_Date__c=System.today());
        insert serviceObj;
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){                    
        Test.StartTest();

        UM_UpdateServiceStatusBatch newServiceStatusChange = new UM_UpdateServiceStatusBatch();
        
        Database.executeBatch(newServiceStatusChange); 
                       
        Test.StopTest(); 
      
        List<csord__Service__c> serv = Database.query('SELECT Id,LG_ServiceStatus__c FROM csord__Service__c WHERE Id = \'' + serviceObj.Id + '\'');
         }
                
    }

}