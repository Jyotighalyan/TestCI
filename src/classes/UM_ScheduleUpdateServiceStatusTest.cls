@isTest
public class UM_ScheduleUpdateServiceStatusTest {
    public static testMethod void testschedule(){
        Test.startTest();
        UM_ScheduleUpdateServiceStatus testsche=new UM_ScheduleUpdateServiceStatus();
        String sch='0 0 23 * * ?';
        System.schedule('test Status Check',sch,testsche);
        Test.stopTest();
        
    }
}