@isTest
private class UM_CollectionTriggerHandlerTest {
    
    @testsetup
    private static void setupTestData()
    {
          Account testAcc = LG_GeneralTest.CreateAccount(
            'Test Account', 'Customer', 'SoHo', 5, 'Qualified', '049-3220919', '55107192', 'UnityMedia', 'Flughafen Allee', '25', '', '28199', 'Bremen', 'Germany'
          );

        csconta__Billing_Account__c testbillingAccount = LG_GeneralTest.createBillingAccount('1234', testAcc.Id, true, true);
        testbillingAccount.csconta__Status__c = 'New';
        testbillingAccount.LG_ContractualOrganization__c = 'Baden-Württemberg (BAW)';
        testbillingAccount.csconta__Street__c = 'test Street';
        testbillingAccount.csconta__Country__c = 'UK';
        testbillingAccount.csconta__Payment_Terms__c = 'Monthly 1st - 30 days payment term';
        testbillingAccount.LG_HouseNumber__c = '202';
        testbillingAccount.csconta__Postcode__c = '70378';
        testbillingAccount.csconta__City__c = 'Stuttgart';
        update testbillingAccount;

        List<UM_Collection__c> collectionList = new List<UM_Collection__c>();
        
	    UM_Collection__c collectionObj = new UM_Collection__c(UM_Billing_Location__c = testbillingAccount.Id,Name = '210-10',UM_Collection_ID__c = '210-10',UM_Last_Event_Date__c = '20180205123345');
	    collectionList.add(collectionObj);
	    
	    UM_Collection__c collectionObj1 = new UM_Collection__c(UM_Billing_Location__c = testbillingAccount.Id,Name = '210-11',UM_Collection_ID__c = '210-11',UM_Last_Event_Date__c = '20180205123345');
	    collectionList.add(collectionObj1);
	    
	    insert collectionList;
	     
 
    }

	private static testMethod void collectionBeforeInsertTest() {
	    
	    List<UM_Collection__c> collList = [Select Id,UM_Collection_ID__c,Name,UM_Billing_Location__c,UM_Last_Event_Date__c from UM_Collection__c];
	    
	    Set<String> setOfIds = UM_CollectionTriggerHandler.collectionBeforeInsert(collList);
	    UM_CollectionTriggerHandler.insertCollection(collList,setOfIds);
	    
	    
	    UM_Collection__c collection = [Select Id,Name,UM_Collection_ID__c from UM_Collection__c where UM_Collection_ID__c = '210-10'];
	    System.debug('Name--'+collection.Name);
	    
	    System.assertEquals(collection.Name, 'Mahnzyklus - 1');
	    
	    

	}

}