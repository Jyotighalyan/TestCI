@isTest
private class UM_ContractTriggerHandlerTest {
    @testsetup
    private static void setupTestData(){
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'TestM', csord__Module_Version__c = '1.0');
        insert coreq;

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdentM', csord__Order_Request__c = coreq.Id);
        insert sub;

        csconta__Contract__c contract = new csconta__Contract__c();
        contract.csconta__Subscription__c = sub.id;
        contract.csconta__Valid_From__c = Date.today();
        contract.csconta__Valid_To__c = Date.Today().addYears(1);
        insert contract;

        sub.LG_Contract__c = contract.id;
        update sub;

        cscrm__Address__c add= new cscrm__Address__c(cscrm__Street__c = 'TestStreetM');
        insert add;
        csord__Service__c intService = new csord__Service__c(csord__Identification__c = 'TestIdentSubM', csord__Order_Request__c = coreq.Id,
                                  csord__Subscription__c = sub.Id, LG_Address__c = add.Id, LG_ProductFamily__c = 'Internet');
        insert intService;

        noTriggers.Flag__c = false;
        update noTriggers;
    }
    
     private static TestMethod void updateServiceOnContractUpdateTest() {
        Test.startTest();
        csconta__Contract__c contract = [select id,csconta__Valid_To__c,csconta__Subscription__c from csconta__Contract__c limit 1];
        System.debug('*** contract='+contract);

        contract.csconta__Valid_To__c = Date.Today().addYears(2);
        update contract;

        csord__service__c service = [select id,csord__Subscription__r.LG_Contract__c,UM_Latest_Cancellation_Letter_Arrival__c,LG_ContractStartDate__c from csord__service__c where csord__Subscription__c=:contract.csconta__Subscription__c];
        System.debug('*** service='+service);
        Test.stopTest();
        System.assertEquals(contract.csconta__Valid_To__c.addMonths(integer.valueof(-3)),service.UM_Latest_Cancellation_Letter_Arrival__c);
    }
}