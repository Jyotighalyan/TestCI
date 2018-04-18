@isTest
public class TriggerOpportunityContactRole_Test {
	static testMethod void Opcontactrole() {
        
        Group smeQueueID = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'SME_Queue'];
        
        Queue_Name__c cs = new Queue_Name__c(Name = 'QueueName', QueueID__c = smeQueueID.id);
        insert cs;
        
		// creating a test Lead
		lead l = new lead (Salutation='Mr', lastname = 'leadtest', status = 'Not contracted', Company = 'Accenture', LG_VisitCountry__c = 'Netherlands',
		                   LG_ChamberOfCommerceNumber__c = '02938493');
        Account DummyAccount=LG_GeneralTest.createPartnerAccount();
        l.UM_PartnerAccount__c=DummyAccount.Id;
		insert l ;

		// creating test account
		Account a = new Account(name = 'Test1', LG_VisitCountry__c = 'Netherlands', LG_ChamberOfCommerceNumber__c = '03438493', LG_Footprint__c = 'UPC');
		insert a;

		// creating  test contacts
		Contact c1 = new Contact(firstname = 'Ram', lastname = 'Reddy', Salutation='Mr.');
		Contact c2 = new Contact(firstname = 'Indra', lastname = 'G', Salutation='Mr.');
		Contact c3 = new Contact(firstname = 'san', lastname = 'mateo', Salutation='Mr.');
		Contact[] cont = new Contact[] {c1, c2, c3};
		insert cont;

		// creating test opp
		Opportunity opp = new Opportunity(name = 'test Opp', closedate = system.today(), stagename = 'Prospect', AccountId = a.Id);
      
		insert opp;

		// test 1: no OCRs == null
		opp = [select LG_PrimaryContact__c from opportunity where id = :opp.id];
		opp.description = 'First test';
		update opp;
		system.assert(opp.LG_PrimaryContact__c == null);

		// test 2: 1 OCR, not Primary == null
		OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid = opp.id, contactid = c1.id, role = 'Administrative Contact');
		insert ocr1;
		ocr1 = [select createddate, opportunityid, contactid, role, isprimary from opportunitycontactrole where id = :ocr1.id];

		opp.description = 'test';
		update opp;
		opp = [select LG_PrimaryContact__c from opportunity where id = :opp.id];
		system.assert(opp.LG_PrimaryContact__c == null);

		// test 3: 1 OCR, Primary == c1
		ocr1.isprimary = true;
		update ocr1;
		opp.description = 'test2';
		update opp;
		opp = [select LG_PrimaryContact__c from opportunity where id = :opp.id];
		system.assert(opp.LG_PrimaryContact__c  == c1.id);
	}
}