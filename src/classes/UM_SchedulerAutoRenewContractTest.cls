@isTest
public class UM_SchedulerAutoRenewContractTest {
    
    Public static testmethod void AutoRenewtest(){
        test.startTest();
        
        UM_SchedulerAutoRenewContract sh1 = new UM_SchedulerAutoRenewContract();
		String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1); 
        
        test.stoptest();
        
        
    }

}