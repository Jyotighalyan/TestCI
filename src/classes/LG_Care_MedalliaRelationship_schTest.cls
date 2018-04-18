@isTest
public class LG_Care_MedalliaRelationship_schTest {

    static testmethod void batchTest() {
        LG_Care_Medallia_Settings__c medallia = new LG_Care_Medallia_Settings__c();
        medallia.LG_Care_Contact_Role__c = 'Business User';
        medallia.LG_Care_Last_rNPS_Send_Date__c = 1;
        medallia.LG_Care_Contact_Created_Date__c = 10;
        medallia.name = 'Default';
        medallia.LG_Care_Max_Number_of_Contacts__c = 100;
        insert medallia;
        Test.startTest();
        LG_Care_MedalliaRelationshipSurvey_sch sch = new LG_Care_MedalliaRelationshipSurvey_sch();
        String schTime = '0 0 0 * * ? *';
        String jobId = System.schedule('testBasicScheduledApex',schTime, sch);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(schTime,ct.CronExpression);
        Test.stopTest();
    }
}