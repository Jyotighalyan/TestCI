@isTest
private class UM_BatchAutoRenewContractTest{
    @testSetup
    static void setup() {

        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'TestM', csord__Module_Version__c = '1.0');
        insert coreq;

        csord__Subscription__c sub = new csord__Subscription__c(csord__Status__c='Active',csord__Identification__c = 'TestIdentM', csord__Order_Request__c = coreq.Id);
        insert sub;

        csconta__Contract__c contract = new csconta__Contract__c();
        contract.csconta__Subscription__c = sub.id;
        contract.csconta__Valid_From__c = Date.today().addYears(-2);
        contract.csconta__Valid_To__c = Date.Today();
        insert contract;

        sub.LG_Contract__c = contract.id;
        update sub;

        cscrm__Address__c add= new cscrm__Address__c(cscrm__Street__c = 'TestStreetM');
        insert add;
        csord__Service__c intService = new csord__Service__c(csord__Identification__c = 'TestIdentSubM', csord__Order_Request__c = coreq.Id,
                                  csord__Subscription__c = sub.Id, LG_Address__c = add.Id, LG_ProductFamily__c = 'Internet');
        insert intService;
    }
       
    static testmethod void test_UM_ContractUpdateBatch() {
        UM_BatchAutoRenewContract updateEndDate = new UM_BatchAutoRenewContract();
        Test.startTest();
        Database.executeBatch(updateEndDate);
        Test.stopTest();
        List<csconta__Contract__c> contractList=[SELECT id,csconta__Valid_To__c
                                                    FROM csconta__Contract__c 
                                                     LIMIT 1];
        for(csconta__Contract__c contract_Obj :contractList){
            System.assertEquals(Date.today().addYears(1), contract_Obj .csconta__Valid_To__c);
        }  
    }
}