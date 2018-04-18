@isTest
private class LG_ConsoleSectionUtilTest {

	@testSetup 
    static void setup() {
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
    }
    
    public static testMethod void TestCodeCoverage() {
        Test.startTest();
        LG_ConsoleSectionUtil util = new LG_ConsoleSectionUtil();
        List<String> recordTypes = new List<String>{'Provision', 'Activate Service', 'Install', 'Provision One Step'};
        List<String> statusList = new List<String>{'Requested', 'Provisioned', 'Provisioned', 'Requested'};
        List<String> validStatusList = new List<String>{'Provisioned', 'Activation Completed', 'Ready for Billing', 'Ready for Billing'};
        List<String> validFailedStatusList = new List<String>{'Provisioning Failed', 'Activation Failed', 'Installation Failed', 'Provisioning Failed'};
        
        for(Integer i=0; i< recordTypes.size(); i++){
            util.getSelectOptionValues(recordTypes[i], statusList[i]);
            System.assertEquals(true, util.validateServiceStatus(validStatusList[i], recordTypes[i]));
            System.assertEquals(true, util.checkServiceFailed(validFailedStatusList[i], recordTypes[i]));
        }
        
        test.stopTest();
        
    }

}