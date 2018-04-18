@isTest
public class LG_LeadUpdateTriggerTest {
    
    // Lead with (Product Family, Postal code) And Lead Assignee Table with (Lead Assigee, Product Family & Postal code)
    static testmethod void testTrigger1(){
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        User usr = new User(LastName = 'testUser',
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
        insert usr; 
        
        //List<Group> smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        //ID queueID = Queue_Name__c.getInstance('QueueName').QueueID__c;
        
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = '00G58000002n2wS');
        insert cs;
        
        Lead_Assignment_Table__c LAT = new Lead_Assignment_Table__c();
        LAT.Product_Family__c = 'Company Internet';
        LAT.Postal_Code__c = 'BW-720';
        LAT.Lead_Assignee__c = usr.Id; //'00558000001m361';
        insert LAT;
        
        Lead lead = new Lead();
        lead.OwnerId = cs.QueueID__c;//smeQueueID[0].Id;	//'00G58000002n2wS';
        lead.UM_Legal_Name__c = 'testAcc';
        lead.Status = 'New';
        lead.LG_LegalEntityType__c = 'AG';
        lead.LastName = 'testLead';
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
        insert lead;
    }
    
    // Lead with (Product Family, Postal code) And Lead Assignee Table with (Assign to Queue, Product Family & Postal code)
    static testmethod void testTrigger2(){ 
        
        //List<Group> smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = '00G58000002n2wS');
        insert cs;
        
        Lead_Assignment_Table__c LAT = new Lead_Assignment_Table__c();
        LAT.Product_Family__c = 'Company Internet';
        LAT.Postal_Code__c = 'BW-720';
        LAT.Assign_to_Queue__c = cs.QueueID__c;//smeQueueID[0].id;//'00558000001m361';
        insert LAT;
        
        Lead lead = new Lead();
        lead.OwnerId = cs.QueueID__c;//smeQueueID[0].id;//'00G58000002n2wS';
        lead.UM_Legal_Name__c = 'testAcc';
        lead.Status = 'New';
        lead.LG_LegalEntityType__c = 'AG';
        lead.LastName = 'testLead';
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
        insert lead;
    }
    
    // Lead with (Postal code only, no Product Family) And Lead Assignee Table with (Lead Assigee & Postal code)
    static testmethod void testTrigger3(){
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        User usr = new User(LastName = 'testUser',
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
        insert usr; 
        
        //List<Group> smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = '00G58000002n2wS');
        insert cs;
        
        Lead_Assignment_Table__c LAT = new Lead_Assignment_Table__c();
        //LAT.Product_Family__c = 'Company Internet';
        LAT.Postal_Code__c = 'BW-720';
        LAT.Lead_Assignee__c = usr.Id; //'00558000001m361';
        insert LAT;
        
        Lead lead = new Lead();
        lead.OwnerId = cs.QueueID__c;//smeQueueID[0].id;//'00G58000002n2wS';
        lead.UM_Legal_Name__c = 'testAcc';
        lead.Status = 'New';
        lead.LG_LegalEntityType__c = 'AG';
        lead.LastName = 'testLead';
        lead.Email = 'test@test.com';
        lead.Phone = '0711111111';
        lead.LG_VisitPostalCode__c = 'BW-720';
        //lead.UM_Product__c = 'Company Internet';
        lead.UM_IndustryClassification__c = 'F BAUGEWERBE';
        lead.LG_Segment__c  = 'SME';
        lead.LG_ContractualOrganization__c = 'Baden-Württemberg (BAW)';
        lead.UM_VisitStateProvince__c = 'BW';
        lead.LG_VisitCountry__c = 'Germany';
        lead.Company = 'testComapny';
        insert lead;
    }
    
	// Lead with (Postal code only, no Product Family) And Lead Assignee Table with (Assign to Queue & Postal code)
    static testmethod void testTrigger4(){
        
        //List<Group> smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = '00G58000002n2wS');
        insert cs;
        
        Lead_Assignment_Table__c LAT = new Lead_Assignment_Table__c();
        //LAT.Product_Family__c = 'Company Internet';
        LAT.Postal_Code__c = 'BW-720';
        LAT.Assign_to_Queue__c = cs.QueueID__c;//smeQueueID[0].id; //'00558000001m361';
        insert LAT;

        Lead lead = new Lead();
        lead.OwnerId = cs.QueueID__c;//smeQueueID[0].id;//'00G58000002n2wS';
        lead.UM_Legal_Name__c = 'testAcc';
        lead.Status = 'New';
        lead.LG_LegalEntityType__c = 'AG';
        lead.LastName = 'testLead';
        lead.Email = 'test@test.com';
        lead.Phone = '0711111111';
        lead.LG_VisitPostalCode__c = 'BW-720';
        //lead.UM_Product__c = 'Company Internet';
        lead.UM_IndustryClassification__c = 'F BAUGEWERBE';
        lead.LG_Segment__c  = 'SME';
        lead.LG_ContractualOrganization__c = 'Baden-Württemberg (BAW)';
        lead.UM_VisitStateProvince__c = 'BW';
        lead.LG_VisitCountry__c = 'Germany';
        lead.Company = 'testComapny';
        insert lead;
    }
    
    // lead with existing account
    static testmethod void testTrigger5(){
        
        //List<Group> smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
		Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = '00G58000002n2wS');
        insert cs;
        
        Account acc = new Account(Name='testAccount');
        insert acc;
        
        Lead lead = new Lead();
        lead.OwnerId = cs.QueueID__c;//smeQueueID[0].id;//'00G58000002n2wS';
        lead.UM_Legal_Name__c = 'testAcc';
        lead.Status = 'New';
        lead.LG_LegalEntityType__c = 'AG';
        lead.LastName = 'testLead';
        lead.Email = 'test@test.com';
        lead.Phone = '0711111111';
        lead.LG_VisitPostalCode__c = 'BW-720';
        //lead.UM_Product__c = 'Company Internet';
        lead.UM_IndustryClassification__c = 'F BAUGEWERBE';
        lead.LG_Segment__c  = 'SME';
        lead.LG_ContractualOrganization__c = 'Baden-Württemberg (BAW)';
        lead.UM_VisitStateProvince__c = 'BW';
        lead.LG_VisitCountry__c = 'Germany';
        lead.Company = 'testComapny';
        lead.LG_MatchingAccount__c = acc.id;
        insert lead;
    }
    
    // Lead with (miltiple same Product Family, Postal code) And Lead Assignee Table with (Lead Assigee, Product Family & Postal code)
    static testmethod void testTrigger6(){
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        User usr = new User(LastName = 'testUser',
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
        insert usr; 
        
        //List<Group> smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = '00G58000002n2wS');
        insert cs;
        
        List<Lead_Assignment_Table__c> latList = new List<Lead_Assignment_Table__c>();
        Lead_Assignment_Table__c LAT = new Lead_Assignment_Table__c();
        LAT.Product_Family__c = 'Company Internet';
        LAT.Postal_Code__c = 'BW-720';
        LAT.Lead_Assignee__c = usr.Id; //'00558000001m361';
        latList.add(LAT);
        Lead_Assignment_Table__c LAT2 = new Lead_Assignment_Table__c();
        LAT2.Product_Family__c = 'Company Internet';
        LAT2.Postal_Code__c = 'BW-721';
        LAT2.Lead_Assignee__c = usr.Id;
        latList.add(LAT2);
        insert latList;
        
        Lead lead = new Lead();
        lead.OwnerId = cs.QueueID__c;//smeQueueID[0].Id;	//'00G58000002n2wS';
        lead.UM_Legal_Name__c = 'testAcc';
        lead.Status = 'New';
        lead.LG_LegalEntityType__c = 'AG';
        lead.LastName = 'testLead';
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
        insert lead;
    }
    
    // Lead with (miltiple same Product Family, Postal code) And Lead Assignee Table with (Assign to Queue, Product Family & Postal code)
    static testmethod void testTrigger7(){
        
        //List<Group> smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = '00G58000002n2wS');
        insert cs;
        
        List<Lead_Assignment_Table__c> latList = new List<Lead_Assignment_Table__c>();
        Lead_Assignment_Table__c LAT = new Lead_Assignment_Table__c();
        LAT.Product_Family__c = 'Company Internet';
        LAT.Postal_Code__c = 'BW-720';
        LAT.Assign_to_Queue__c = cs.QueueID__c;//smeQueueID[0].Id; //'00558000001m361';
        latList.add(LAT);
        Lead_Assignment_Table__c LAT2 = new Lead_Assignment_Table__c();
        LAT2.Product_Family__c = 'Company Internet';
        LAT2.Postal_Code__c = 'BW-721';
        LAT2.Assign_to_Queue__c = cs.QueueID__c; //smeQueueID[0].Id;
        latList.add(LAT2);
        insert latList;
        
        Lead lead = new Lead();
        lead.OwnerId = cs.QueueID__c;//smeQueueID[0].Id;	//'00G58000002n2wS';
        lead.UM_Legal_Name__c = 'testAcc';
        lead.Status = 'New';
        lead.LG_LegalEntityType__c = 'AG';
        lead.LastName = 'testLead';
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
        insert lead;
    }
    
    // Lead with (NO Product Family, No Postal code) And Lead Assignee Table with (Lead Assigee, NO Product Family & No Postal code)
    static testmethod void testTrigger8(){
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        User usr = new User(LastName = 'testUser',
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
        insert usr; 
        
        //List<Group> smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        //ID queueID = Queue_Name__c.getInstance('QueueName').QueueID__c;
        
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = '00G58000002n2wS');
        insert cs;
        
        Lead_Assignment_Table__c LAT = new Lead_Assignment_Table__c();
        //LAT.Product_Family__c = 'Company Internet';
        //LAT.Postal_Code__c = 'BW-720';
        LAT.Lead_Assignee__c = usr.Id; //'00558000001m361';
        insert LAT;
        
        Lead lead = new Lead();
        lead.OwnerId = cs.QueueID__c;//smeQueueID[0].Id;	//'00G58000002n2wS';
        lead.UM_Legal_Name__c = 'testAcc';
        lead.Status = 'New';
        lead.LG_LegalEntityType__c = 'AG';
        lead.LastName = 'testLead';
        lead.Email = 'test@test.com';
        lead.Phone = '0711111111';
        //lead.LG_VisitPostalCode__c = 'BW-720';
        //lead.UM_Product__c = 'Company Internet';
        lead.UM_IndustryClassification__c = 'F BAUGEWERBE';
        lead.LG_Segment__c  = 'SME';
        lead.LG_ContractualOrganization__c = 'Baden-Württemberg (BAW)';
        lead.UM_VisitStateProvince__c = 'BW';
        lead.LG_VisitCountry__c = 'Germany';
        lead.Company = 'testComapny';
        insert lead;
    }
    
// Lead with (NO Product Family, No Postal code) And Lead Assignee Table with (Assign to Queue, NO Product Family & No Postal code)
    static testmethod void testTrigger9(){
                
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = '00G58000002n2wS');
        insert cs;
        
        Lead_Assignment_Table__c LAT = new Lead_Assignment_Table__c();
        //LAT.Product_Family__c = 'Company Internet';
        //LAT.Postal_Code__c = 'BW-720';
        LAT.Assign_to_Queue__c = cs.QueueID__c; //'00558000001m361';
        insert LAT;
        
        Lead lead = new Lead();
        lead.OwnerId = cs.QueueID__c;//smeQueueID[0].Id;	//'00G58000002n2wS';
        lead.UM_Legal_Name__c = 'testAcc';
        lead.Status = 'New';
        lead.LG_LegalEntityType__c = 'AG';
        lead.LastName = 'testLead';
        lead.Email = 'test@test.com';
        lead.Phone = '0711111111';
        //lead.LG_VisitPostalCode__c = 'BW-720';
        //lead.UM_Product__c = 'Company Internet';
        lead.UM_IndustryClassification__c = 'F BAUGEWERBE';
        lead.LG_Segment__c  = 'SME';
        lead.LG_ContractualOrganization__c = 'Baden-Württemberg (BAW)';
        lead.UM_VisitStateProvince__c = 'BW';
        lead.LG_VisitCountry__c = 'Germany';
        lead.Company = 'testComapny';
        insert lead;
    }
}