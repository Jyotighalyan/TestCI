/**
 * Test for LG_FollowOnOrder Custom step
 *
 * @author Petar Miletic
 * @ticket SFOM-408
 * @since  08/02/2017
*/
@IsTest
public class LG_FollowOnOrderTest {

    @testSetup
    private static void setupTestData() {

        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        Profile defaultProfile = [SELECT Name, Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User defaultUser = new User();
        defaultUser.LastName = 'Test user';
        defaultUser.Alias = 'tuser';
        defaultUser.Email = 'testmail@testemail.com';
        defaultUser.Username = 'testmail@testemail.com';
        defaultUser.CommunityNickname = 'Test User';
        defaultUser.ProfileId = defaultProfile.Id;
        defaultUser.TimeZoneSidKey = 'Asia/Kolkata';
        defaultUser.LocaleSidKey = 'en_IN';
        defaultUser.EmailEncodingKey = 'UTF-8';
        defaultUser.LanguageLocaleKey = 'en_US';
        defaultUser.CompanyName = 'Test';
        insert defaultUser;

        List<RecordType> recordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND RecordType.Name IN ('Care', 'Follow-On Order') ORDER BY RecordType.Name ASC];

		// Insert two Orders
		List<csord__Order__c> orders = new List<csord__Order__c>();

		orders.add(new csord__Order__c(Name = 'Test Order First', csord__Status2__c = 'New', csord__Identification__c = '1234567891', OwnerId = thisUser.Id));
        orders.add(new csord__Order__c(Name = 'Test Order Second', csord__Status2__c = 'Follow Up', csord__Identification__c = '1234567892', OwnerId = thisUser.Id));
		orders.add(new csord__Order__c(Name = 'Test Order Third', csord__Status2__c = 'On Hold', csord__Identification__c = '1234567893', OwnerId = thisUser.Id));

		insert orders;

		List<Case> cases = new List<Case>();

        cases.add(new Case(LG_Order__c = orders[0].Id, Status = 'New', RecordTypeId = recordTypes[0].Id, OwnerId = defaultUser.Id));
        cases.add(new Case(LG_Order__c = orders[1].Id, Status = 'Follow Up', RecordTypeId = recordTypes[0].Id, OwnerId = defaultUser.Id));
		cases.add(new Case(LG_Order__c = orders[2].Id, Status = 'On Hold', RecordTypeId = recordTypes[0].Id, OwnerId = defaultUser.Id));

		insert cases;

        // Orcestrator stuff
		CSPOFA__Orchestration_Process_Template__c orcTemplate = new CSPOFA__Orchestration_Process_Template__c();
		insert orcTemplate;

        // Process first Solution, first Order
		CSPOFA__Orchestration_Process__c process = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id, LG_Order__c = orders[0].Id);
		insert process;

		CSPOFA__Orchestration_Step__c step = new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = process.Id);
		insert step;

        // Process second Solution, second Order
        CSPOFA__Orchestration_Process__c process2 = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id, LG_Order__c = orders[1].Id);
		insert process2;

		CSPOFA__Orchestration_Step__c step2 = new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = process2.Id);
		insert step2;

        // Process second Solution, third Order
        CSPOFA__Orchestration_Process__c process3 = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id, LG_Order__c = orders[2].Id);
		insert process3;

		CSPOFA__Orchestration_Step__c step3 = new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = process3.Id);
		insert step3;

        noTriggers.Flag__c = false;
        upsert noTriggers;
    }

    @isTest
    private static void processTest() {

		List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c];

		for (SObject obj : steps) {

			CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
			System.assertNotEquals('Complete', step.CSPOFA__Status__c, 'Status should not be complete');
		}

		Test.startTest();

		LG_FollowOnOrder followUp = new LG_FollowOnOrder();
		steps = followUp.process(steps);

		Test.stopTest();

		for (SObject obj : steps) {

			CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
			System.assertEquals('Complete', step.CSPOFA__Status__c, 'Status should be complete');
		}
	}

    @IsTest
    public static void notifyOrderProcessTest() {

        Map<Id, CSPOFA__Orchestration_Process__c> processMap = new Map<Id, CSPOFA__Orchestration_Process__c>([SELECT Id FROM CSPOFA__Orchestration_Process__c]);

        Case first = [SELECT Id, RecordType.Name, OwnerId, Status, LG_Order__r.Name, LG_Order__r.OwnerId, LG_Order__r.csord__Status2__c FROM Case WHERE LG_Order__r.Name = 'Test Order First' LIMIT 1];
        Case second = [SELECT Id, RecordType.Name, OwnerId, Status, LG_Order__r.Name, LG_Order__r.OwnerId, LG_Order__r.csord__Status2__c FROM Case WHERE LG_Order__r.Name = 'Test Order Second' LIMIT 1];
        Case third = [SELECT Id, RecordType.Name, OwnerId, Status, LG_Order__r.Name, LG_Order__r.OwnerId, LG_Order__r.csord__Status2__c FROM Case WHERE LG_Order__r.Name = 'Test Order Third' LIMIT 1];

        Test.startTest();

		LG_FollowOnOrder followUp = new LG_FollowOnOrder();
		followUp.updateFollowOnOrders(processMap.keySet());

		Test.stopTest();

		// Assert before
		System.assertEquals('New', first.Status, 'Invalid data');
        System.assertEquals('Follow Up', second.Status, 'Invalid data');
		System.assertEquals('On Hold', third.Status, 'Invalid data');

		System.assertEquals('New', first.LG_Order__r.csord__Status2__c, 'Invalid data');
        System.assertEquals('Follow Up', second.LG_Order__r.csord__Status2__c, 'Invalid data');
		System.assertEquals('On Hold', third.LG_Order__r.csord__Status2__c, 'Invalid data');

		System.assertNotEquals(first.OwnerId, first.LG_Order__r.OwnerId, 'Invalid data');
		System.assertNotEquals(second.OwnerId, second.LG_Order__r.OwnerId, 'Invalid data');
		System.assertNotEquals(third.OwnerId, third.LG_Order__r.OwnerId, 'Invalid data');

		// Reload data
        first = [SELECT Id, RecordType.Name, OwnerId, Status, LG_Order__r.Name, LG_Order__r.OwnerId, LG_Order__r.csord__Status2__c FROM Case WHERE LG_Order__r.Name = 'Test Order First' LIMIT 1];
        second = [SELECT Id, RecordType.Name, OwnerId, Status, LG_Order__r.Name, LG_Order__r.OwnerId, LG_Order__r.csord__Status2__c FROM Case WHERE LG_Order__r.Name = 'Test Order Second' LIMIT 1];
        third = [SELECT Id, RecordType.Name, OwnerId, Status, LG_Order__r.Name, LG_Order__r.OwnerId, LG_Order__r.csord__Status2__c FROM Case WHERE LG_Order__r.Name = 'Test Order Third' LIMIT 1];

		// Assert after; Not equal becouse of Case status
		System.assertEquals('New', first.Status, 'Invalid data');
		System.assertNotEquals(first.OwnerId, first.LG_Order__r.OwnerId, 'Invalid data');

		// Assert after; Must be equal
		System.assertEquals('Follow Up', second.Status, 'Invalid data');
        System.assertNotEquals(second.OwnerId, second.LG_Order__r.OwnerId, 'Invalid data');

		// Assert after; Not equal becouse of Case record type
        System.assertEquals('Follow Up', third.Status, 'Invalid data');
        //There will be a change in Follow-on order - Hereafter opportunity owner will be assigned to the Case owner
        //Check Marian's comment in SFOM-803
        //System.assertNotEquals(third.OwnerId, third.LG_Order__r.OwnerId, 'Invalid data');
    }
}