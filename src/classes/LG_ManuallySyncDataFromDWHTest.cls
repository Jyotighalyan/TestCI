@IsTest
public class LG_ManuallySyncDataFromDWHTest {
    static testMethod void testMethod1() 
	{
	
		Account testAccount = new Account();
		testAccount.Name='Test Account' ;
		insert testAccount;
		
		Contact cont = new Contact();
		cont.FirstName='Test';
		cont.LastName='Test';
        cont.Salutation='Mr.';
		cont.Accountid= testAccount.id;
		insert cont;
		
		Test.StartTest(); 
			//LG_ManuallySyncDataFromDWH obj = new LG_ManuallySyncDataFromDWH();
			List<Account> lstAcc = LG_ManuallySyncDataFromDWH.createacc();
			
		Test.StopTest();
	
	}


}