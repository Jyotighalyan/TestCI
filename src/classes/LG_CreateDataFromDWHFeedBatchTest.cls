@isTest
public class LG_CreateDataFromDWHFeedBatchTest {
    static testMethod void testMethod1() 
    {
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0 ;i <1;i++)
        {
            Account acc = new Account();
            acc.Name ='Name'+i;
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        
        Test.startTest();

            LG_CreateDataFromDWHFeedBatch obj = new LG_CreateDataFromDWHFeedBatch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }

}