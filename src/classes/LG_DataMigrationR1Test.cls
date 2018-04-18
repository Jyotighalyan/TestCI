@isTest
public class LG_DataMigrationR1Test {

    private static TestMethod void initiatebatchTest () {
        Account account = LG_GeneralTest.CreateAccount('Account', '12345678', 'Ziggo', true);
    
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, false);
        insert opp;
        
        Id batchJobId = Database.executeBatch(new   LG_DataMigrationR1(''), 200);
    }
}