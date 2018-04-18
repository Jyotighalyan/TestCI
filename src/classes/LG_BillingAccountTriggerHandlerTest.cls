@isTest
private class LG_BillingAccountTriggerHandlerTest {
	
	private static String accDefBillingName = 'AccWithOneDef';
	private static String accUpdateName = 'AccWithTwoDef';
	
	@testsetup
	private static void setupTestData()
	{
		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		List<Account> accounts = new List<Account>();
		Account accDefBilling = LG_GeneralTest.CreateAccount(accDefBillingName, '12345678', 'Ziggo', false);
		Account accUpdate = LG_GeneralTest.CreateAccount(accUpdateName, '12345679', 'Ziggo', false);
		accounts.add(accDefBilling);
		accounts.add(accUpdate);
		insert accounts;		

		Contact tmpContact = new Contact();
        tmpContact.AccountId=accDefBilling.Id;
        tmpContact.Firstname='Firstname';
        tmpContact.LastName='LastName';
        tmpContact.Salutation='Mr.';
        insert tmpContact;

		List<csconta__Billing_Account__c> billAccounts = new List<csconta__Billing_Account__c>();
		billAccounts.add(LG_GeneralTest.createBillingAccount('SFDT-59 Bill1', accDefBilling.Id, true, false));
		billAccounts.add(LG_GeneralTest.createBillingAccount('SFDT-59 Bill2', accUpdate.Id, false, false));
		billAccounts.add(LG_GeneralTest.createBillingAccount('SFDT-59 Bill3', accUpdate.Id, false, false));
		insert billAccounts;

		noTriggers.Flag__c = false;
		upsert noTriggers;
	}
	
	private static testmethod void testSetDefaultBillingAccount()
	{
		List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name = :accDefBillingName OR Name = :accUpdateName];
		Account accDefBilling;
		Account accUpdate;
		
		csconta__Billing_Account__c updateBillAcc = [SELECT Id, csconta__Financial_Account_Number__c, LG_Default__c 
														FROM csconta__Billing_Account__c
														WHERE csconta__Financial_Account_Number__c = 'SFDT-59 Bill2'];
		
		for (Account account : accounts)
		{
			if (account.Name.equals(accDefBillingName))
			{
				accDefBilling = account;
			}
			else if (account.Name.equals(accUpdateName))
			{
				accUpdate = account;
			}
		}
		
		Test.startTest();
			List<csconta__Billing_Account__c> billAccounts = new List<csconta__Billing_Account__c>();
			billAccounts.add(LG_GeneralTest.createBillingAccount('SFDT-59 Bill22', accDefBilling.Id, true, false));
			billAccounts.add(LG_GeneralTest.createBillingAccount('SFDT-59 Bill13', accDefBilling.Id, true, false));
			updateBillAcc.LG_Default__c = true;
			billAccounts.add(updateBillAcc);
			upsert billAccounts;
		Test.stopTest();
		
		for (Account account : [SELECT Id, Name, (SELECT csconta__Financial_Account_Number__c
								FROM csconta__Billing_Accounts__r WHERE LG_Default__c = true)
								FROM Account WHERE Id IN :accounts])
		{
			System.assertEquals(1, account.csconta__Billing_Accounts__r.size(), 'There should be only one default Billing Account per Account');
			if (account.Name.equals(accUpdateName))
			{
				System.assertEquals('SFDT-59 Bill2', account.csconta__Billing_Accounts__r[0].csconta__Financial_Account_Number__c,
									'Default Billing Account should be SFDT-59 Bill2');
			}
			else
			{
				System.assertNotEquals('SFDT-59 Bill1', account.csconta__Billing_Accounts__r[0].csconta__Financial_Account_Number__c,
									'Default Billing Account should not be SFDT-59 Bill1 anymore');
			}
		}
	}
    
    private static testmethod void testSetCreatePaymentProfileFlag(){
        
        csconta__Billing_Account__c billAcc = [SELECT Id,  csconta__Payment_Terms__c ,
                                               		  csconta__Financial_Account_Number__c, 
                                               		  LG_Default__c 
                                               FROM csconta__Billing_Account__c
                                                     WHERE csconta__Financial_Account_Number__c = 'SFDT-59 Bill2'];
        
        billAcc.csconta__Payment_Terms__c = 'Monthly 1st - 30 days payment term';
        update billAcc;
        
        //system.assertEquals(true,[select id, UM_Create_Payment_Profile_in_Billing__c from csconta__Billing_Account__c where id=:billAcc.id ].UM_Create_Payment_Profile_in_Billing__c);
        
    }

}