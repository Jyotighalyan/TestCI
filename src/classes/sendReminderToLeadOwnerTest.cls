@isTest
public class sendReminderToLeadOwnerTest {
    @testSetup 
    static void setup() {
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        List<User> userList = new List<User>();
        User usr = new User(LastName = 'testUser1',
                            FirstName='FirstName',
                            Alias = '242793',
                            Email = 'abc@asdf1.com',
                            Username = 'abc@asdf11.com',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US',
                            CompanyName = 'testComp'
                           );
        userList.add(usr);
        User usr1 = new User(LastName = 'testUser2',
                             FirstName='FirstName',
                             Alias = '2427932',
                             Email = 'abc2@asdf1.com',
                             Username = 'abc2@asdf11.com',
                             ProfileId = profileId.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US',
                             CompanyName = 'testComp2'
                            );
        userList.add(usr1);
        User usr2 = new User(LastName = 'testUser3',
                             FirstName='FirstName',
                             Alias = '2427933',
                             Email = 'abc3@asdf1.com',
                             Username = 'abc3@asdf11.com',
                             ProfileId = profileId.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US',
                             CompanyName = 'testComp3'
                            );
        userList.add(usr2);
        insert userList;
                
        List<Queue_Name__c> customSettingList = new List<Queue_Name__c>();
        
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = '00G58000002n2wS');
        customSettingList.add(cs);
        
        Queue_Name__c cs2 = new Queue_Name__c(Name = 'AdminEmailID', Admin_Email_ID__c = 'amit_senapati01@infosys.com');
        customSettingList.add(cs2);
        
        Queue_Name__c cs1 = new Queue_Name__c(Name = 'EmailBody', EmailBodyPartOne__c = 'test',EmailBodyPartTwo__c='test');
        customSettingList.add(cs1);
        
        insert customSettingList;
        
        List<Lead_Assignment_Table__c> LATList = new List<Lead_Assignment_Table__c>();
		        
        Lead_Assignment_Table__c LAT = new Lead_Assignment_Table__c();
        LAT.Product_Family__c = 'Company Internet';
        LAT.Postal_Code__c = 'BW-720';
        LAT.Lead_Assignee__c = usr.Id; //'00558000001m361';
        LATList.add(LAT);
        
        Lead_Assignment_Table__c LAT1 = new Lead_Assignment_Table__c();
        LAT1.Product_Family__c = 'Company Internet';
        LAT1.Postal_Code__c = 'BW-721';
        LAT1.Lead_Assignee__c = usr2.Id; //'00558000001m361';
        LATList.add(LAT1);
        
        Lead_Assignment_Table__c LAT2 = new Lead_Assignment_Table__c();
        LAT2.Product_Family__c = 'Company Internet';
        //LAT2.Postal_Code__c = 'BW-720';
        LAT2.Lead_Assignee__c = usr1.Id; //'00558000001m361';
        LATList.add(LAT2);
        
        Lead_Assignment_Table__c LAT3 = new Lead_Assignment_Table__c();
        //LAT3.Product_Family__c = 'Company Internet';
        LAT3.Postal_Code__c = 'BW-722';
        LAT3.Lead_Assignee__c = usr1.Id; //'00558000001m361';
        LATList.add(LAT3);
        
        Lead_Assignment_Table__c LAT4 = new Lead_Assignment_Table__c();
        //LAT4.Product_Family__c = 'Company Internet';
        //LAT4.Postal_Code__c = 'BW-722';
        LAT4.Lead_Assignee__c = usr.Id; //'00558000001m361';
        LATList.add(LAT4);
        
        Lead_Assignment_Table__c LAT5 = new Lead_Assignment_Table__c();
        LAT5.Product_Family__c = 'Company Fiber';
        //LAT4.Postal_Code__c = 'BW-722';
        LAT5.Lead_Assignee__c = usr2.Id; //'00558000001m361';
        LATList.add(LAT5);
        
        Lead_Assignment_Table__c LAT6 = new Lead_Assignment_Table__c();
        LAT6.Product_Family__c = 'Company Voice';
        LAT6.Postal_Code__c = 'BW-729';
        //LAT6.Lead_Assignee__c = usr2.Id; //'00558000001m361';
        LATList.add(LAT6);
        
        Lead_Assignment_Table__c LAT7 = new Lead_Assignment_Table__c();
        LAT7.Product_Family__c = 'Test PF';
        LAT7.Postal_Code__c = 'Test PC';
        LAT7.Lead_Assignee__c = usr2.Id; //'00558000001m361';
        LATList.add(LAT7);
        
        insert LATList;
        
        Date threeDaysBefore2 = Date.today().addDays(-7);
        Date beforeOneDay;
        Date beforeThreeDay;
        Date myDay = Date.today();
        Date refDate = Date.newInstance(1900, 1, 7);
        
        if(math.mod(refDate.daysBetween(myDay),7) == 1){
            beforeOneDay = Date.today().addDays(-3);
            beforeThreeDay = Date.today().addDays(-5);
        }
        else if(math.mod(refDate.daysBetween(myDay),7) == 2 || math.mod(refDate.daysBetween(myDay),7) == 3){
            beforeOneDay = Date.today().addDays(-1);
            beforeThreeDay = Date.today().addDays(-5);
        }
        else{ 
            beforeOneDay = Date.today().addDays(-1);
            beforeThreeDay = Date.today().addDays(-3);
        }
        
        List<Lead> leadList = new List<Lead>();
       
        Lead lead = new Lead();
        lead.OwnerId = usr.id;
        lead.UM_Legal_Name__c = 'testAcc';
        lead.Status = 'New';
        lead.LG_Last_Lead_Status_Change_Date__c = threeDaysBefore2;
        lead.Assigned_Date__c = beforeOneDay;
        lead.LG_LegalEntityType__c = 'AG';
        lead.LastName = 'Lead1';
        lead.Email = 'test@test.com';
        lead.Phone = '0711111111';
        lead.LG_VisitPostalCode__c = 'BW-720';
        lead.UM_Product__c = 'Company Internet';
        lead.UM_IndustryClassification__c = 'F BAUGEWERBE';
        lead.LG_Segment__c  = 'SME';
        lead.LG_ContractualOrganization__c = 'Baden-Württemberg (BAW)';
        lead.UM_VisitStateProvince__c = 'BW';
        lead.LG_VisitCountry__c = 'Germany';
        lead.Company = 'testComapny';
        leadList.add(lead);
        
        Lead lead1 = new Lead();
        lead1.OwnerId = usr.id;
        lead1.UM_Legal_Name__c = 'testAcc2';
        lead1.Status = 'New';
        lead1.LG_Last_Lead_Status_Change_Date__c = threeDaysBefore2;
        lead1.Assigned_Date__c = beforeThreeDay;
        lead1.LG_LegalEntityType__c = 'AG';
        lead1.LastName = 'Lead2';
        lead1.Email = 'test2@test.com';
        lead1.Phone = '0711111111';
        lead1.LG_VisitPostalCode__c = 'BW-721';
        lead1.UM_Product__c = 'Company Internet';
        lead1.UM_IndustryClassification__c = 'F BAUGEWERBE';
        lead1.LG_Segment__c  = 'SME';
        lead1.LG_ContractualOrganization__c = 'Baden-Württemberg (BAW)';
        lead1.UM_VisitStateProvince__c = 'BW';
        lead1.LG_VisitCountry__c = 'Germany';
        lead1.Company = 'testComapny2';
        leadList.add(lead1);
        
        Lead lead2 = new Lead();
        lead2.OwnerId = usr.id;
        lead2.UM_Legal_Name__c = 'testAcc3';
        lead2.Status = 'New';
        lead2.LG_Last_Lead_Status_Change_Date__c = threeDaysBefore2;
        lead2.Assigned_Date__c = beforeThreeDay;
        lead2.LG_LegalEntityType__c = 'AG';
        lead2.LastName = 'Lead3';
        lead2.Email = 'test3@test.com';
        lead2.Phone = '0711111111';
        lead2.LG_VisitPostalCode__c = 'BW-722';
        //lead2.UM_Product__c = 'Company Internet';
        lead2.UM_IndustryClassification__c = 'F BAUGEWERBE';
        lead2.LG_Segment__c  = 'SME';
        lead2.LG_ContractualOrganization__c = 'Baden-Württemberg (BAW)';
        lead2.UM_VisitStateProvince__c = 'BW';
        lead2.LG_VisitCountry__c = 'Germany';
        lead2.Company = 'testComapny3';
        leadList.add(lead2);
        
        Lead lead3 = new Lead();
        lead3.OwnerId = usr.id;
        lead3.UM_Legal_Name__c = 'testAcc4';
        lead3.Status = 'New';
        lead3.LG_Last_Lead_Status_Change_Date__c = threeDaysBefore2;
        lead3.Assigned_Date__c = beforeThreeDay;
        lead3.LG_LegalEntityType__c = 'AG';
        lead3.LastName = 'Lead4';
        lead3.Email = 'test4@test.com';
        lead3.Phone = '0711111111';
        //lead3.LG_VisitPostalCode__c = 'BW-722';
        //lead3.UM_Product__c = 'Company Internet';r
        lead3.UM_IndustryClassification__c = 'F BAUGEWERBE';
        lead3.LG_Segment__c  = 'SME';
        lead3.LG_ContractualOrganization__c = 'Baden-Württemberg (BAW)';
        lead3.UM_VisitStateProvince__c = 'BW';
        lead3.LG_VisitCountry__c = 'Germany';
        lead3.Company = 'testComapny4';
        leadList.add(lead3);        
        Lead lead4 = new Lead();
        lead4.OwnerId = usr.id;
        lead4.UM_Legal_Name__c = 'testAcc5';
        lead4.Status = 'New';
        lead4.LG_Last_Lead_Status_Change_Date__c = threeDaysBefore2;
        lead4.Assigned_Date__c = beforeThreeDay;
        lead4.LG_LegalEntityType__c = 'AG';
        lead4.LastName = 'Lead5';
        lead4.Email = 'test5@test.com';
        lead4.Phone = '0711111111';
        //lead3.LG_VisitPostalCode__c = 'BW-722';
        lead4.UM_Product__c = 'Company Fiber';
        lead4.UM_IndustryClassification__c = 'F BAUGEWERBE';
        lead4.LG_Segment__c  = 'SME';
        lead4.LG_ContractualOrganization__c = 'Baden-Württemberg (BAW)';
        lead4.UM_VisitStateProvince__c = 'BW';
        lead4.LG_VisitCountry__c = 'Germany';
        lead4.Company = 'testComapny5';
        leadList.add(lead4);
        
        Lead lead5 = new Lead();
        lead5.OwnerId = usr.id;
        lead5.UM_Legal_Name__c = 'testAcc5';
        lead5.Status = 'New';
        lead5.LG_Last_Lead_Status_Change_Date__c = threeDaysBefore2;
        lead5.Assigned_Date__c = beforeThreeDay;
        lead5.LG_LegalEntityType__c = 'AG';
        lead5.LastName = 'Lead5';
        lead5.Email = 'test5@test.com';
        lead5.Phone = '0711111111';
        //lead5.LG_VisitPostalCode__c = 'BW-720';
        lead5.UM_Product__c = 'Company Internet';
        lead5.UM_IndustryClassification__c = 'F BAUGEWERBE';
        lead5.LG_Segment__c  = 'SME';
        lead5.LG_ContractualOrganization__c = 'Baden-Württemberg (BAW)';
        lead5.UM_VisitStateProvince__c = 'BW';
        lead5.LG_VisitCountry__c = 'Germany';
        lead5.Company = 'testComapny5';
        leadList.add(lead5);
        
        Lead lead6 = new Lead();
        lead6.OwnerId = usr.id;
        lead6.UM_Legal_Name__c = 'testAcc6';
        lead6.Status = 'New';
        lead6.LG_Last_Lead_Status_Change_Date__c = threeDaysBefore2;
        lead6.Assigned_Date__c = beforeThreeDay;
        lead6.LG_LegalEntityType__c = 'AG';
        lead6.LastName = 'Lead6';
        lead6.Email = 'test6@test.com';
        lead6.Phone = '0711111111';
        lead6.LG_VisitPostalCode__c = 'BW-725';
        //lead2.UM_Product__c = 'Company Internet';
        lead6.UM_IndustryClassification__c = 'F BAUGEWERBE';
        lead6.LG_Segment__c  = 'SME';
        lead6.LG_ContractualOrganization__c = 'Baden-Württemberg (BAW)';
        lead6.UM_VisitStateProvince__c = 'BW';
        lead6.LG_VisitCountry__c = 'Germany';
        lead6.Company = 'testComapny6';
        leadList.add(lead6);
        
        Lead lead7 = new Lead();
        lead7.OwnerId = usr.id;
        lead7.UM_Legal_Name__c = 'testAcc7';
        lead7.Status = 'New';
        lead7.LG_Last_Lead_Status_Change_Date__c = threeDaysBefore2;
        lead7.Assigned_Date__c = beforeThreeDay;
        lead7.LG_LegalEntityType__c = 'AG';
        lead7.LastName = 'Lead7';
        lead7.Email = 'test7@test.com';
        lead7.Phone = '0711111111';
        lead7.LG_VisitPostalCode__c = 'BW-729';
        lead7.UM_Product__c = 'Company Voice';
        lead7.UM_IndustryClassification__c = 'F BAUGEWERBE';
        lead7.LG_Segment__c  = 'SME';
        lead7.LG_ContractualOrganization__c = 'Baden-Württemberg (BAW)';
        lead7.UM_VisitStateProvince__c = 'BW';
        lead7.LG_VisitCountry__c = 'Germany';
        lead7.Company = 'testComapny7';
        leadList.add(lead7);
        
        Lead lead8 = new Lead();
        lead8.OwnerId = usr.id;
        lead8.UM_Legal_Name__c = 'testAcc8';
        lead8.Status = 'New';
        lead8.LG_Last_Lead_Status_Change_Date__c = threeDaysBefore2;
        lead8.Assigned_Date__c = beforeThreeDay;
        lead8.LG_LegalEntityType__c = 'AG';
        lead8.LastName = 'Lead8';
        lead8.Email = 'test8@test.com';
        lead8.Phone = '0711111111';
        lead8.LG_VisitPostalCode__c = 'BW-729';
        lead8.UM_Product__c = 'Company Internet';
        lead8.UM_IndustryClassification__c = 'F BAUGEWERBE';
        lead8.LG_Segment__c  = 'SME';
        lead8.LG_ContractualOrganization__c = 'Baden-Württemberg (BAW)';
        lead8.UM_VisitStateProvince__c = 'BW';
        lead8.LG_VisitCountry__c = 'Germany';
        lead8.Company = 'testComapny8';
        leadList.add(lead8);
        
        Lead lead9 = new Lead();
        lead9.OwnerId = usr.id;
        lead9.UM_Legal_Name__c = 'testAcc';
        lead9.Status = 'New';
        lead9.LG_Last_Lead_Status_Change_Date__c = threeDaysBefore2;
        lead9.Assigned_Date__c = beforeOneDay;
        lead9.LG_LegalEntityType__c = 'AG';
        lead9.LastName = 'Lead9';
        lead9.Email = 'test9@test.com';
        lead9.Phone = '0711111111';
        lead9.LG_VisitPostalCode__c = 'BW-729';
        lead9.UM_Product__c = 'Company Voice';
        lead9.UM_IndustryClassification__c = 'F BAUGEWERBE';
        lead9.LG_Segment__c  = 'SME';
        lead9.LG_ContractualOrganization__c = 'Baden-Württemberg (BAW)';
        lead9.UM_VisitStateProvince__c = 'BW';
        lead9.LG_VisitCountry__c = 'Germany';
        lead9.Company = 'testComapny9';
        leadList.add(lead9);
       
        insert leadList;
    }
    
    static testmethod void test() {        
        Test.startTest();      
        sendReminderToLeadOwner scld = new sendReminderToLeadOwner();
        string sch = '0 0 * * 1-12 ? *';
        system.schedule('Process Trans 1', sch, scld);
        Test.stopTest();
    }
}