/**
 * Check if there are any number to port
 *
 * Scans all numbers under this Solution. If there are any numbers that
 * still require porting, set the Any Numbers to Port to True and also update the
 * Earliest and Latest porting dates if needed.
 *
 * @param  Set<Id> processesIds
 * @author Petar Miletic
 * @ticket SFOM-193, replaces (SFOM-190, SFOM-194)
 * @since  03/02/2017
*/
@IsTest
public class LG_AnalyseNumberPortingTest {

	@testsetup
	private static void setupTestData() {

        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;

	    // Create record types
	    RecordType numberBlockRecordType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Asset' AND Name = 'Number Block'];
		RecordType phoneNumberRecordType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Asset' AND Name = 'Phone Number'];


		Account acc = new Account(Name = 'TestAcc');
		insert acc;

		// Solution
		csord__Solution__c sol = new csord__Solution__c(Name = 'Test Solution', LG_AnyNumbersToPort__c = false, csord__Identification__c = '6465467985');
		insert sol;

		// Subscripton
		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '6465467986');
		insert sub;

		// Service
		csord__Service__c service = new csord__Service__c(csord__Subscription__c = sub.Id, LG_Suborder__c = sol.Id, csord__Identification__c = '6465467987');
		insert service;

        List<Asset> assets = new List<Asset>();

        // Top level asset (number block)
        Asset topAssetFirst = new Asset(Name = 'Asset_0', AccountId = acc.Id, LG_NumberRangeType__c = 'Portin', RecordTypeId = numberBlockRecordType.Id, LG_TelephonyService__c = service.Id,
									    LG_StartNumber__c = '000', LG_EndNumber__c = '004', LG_PortInWishDate__c = Date.today().addDays(-5));
        insert topAssetFirst;
        
        Asset topAssetSecond = new Asset(Name = 'Asset_0', AccountId = acc.Id, LG_NumberRangeType__c = 'Portin', RecordTypeId = numberBlockRecordType.Id, LG_TelephonyService__c = service.Id,
									    LG_StartNumber__c = '000', LG_EndNumber__c = '004', LG_PortInWishDate__c = Date.today().addDays(4));
        insert topAssetSecond;
        
        for (Integer i = 1; i < 6; i++) {

            Asset obj = new Asset(Name = 'Asset_' + i, AccountId = acc.Id);

            obj.LG_NumberRangeType__c = 'Portin';
            obj.RecordTypeId = phoneNumberRecordType.Id;
            obj.LG_TelephonyService__c = service.Id;

            if (math.mod(i, 2) == 0) {
                obj.LG_Asset__c = topAssetSecond.Id;
            }
            else {
                obj.LG_Asset__c = topAssetFirst.Id;
            }

            assets.add(obj);
        }

        insert assets;

        // Insert process
        LG_PortingProcess__c pProcess = new LG_PortingProcess__c();
        pProcess.LG_Account__c = acc.Id;
        insert pProcess;
        
        LG_ProcessRequest__c request = new LG_ProcessRequest__c();
        request.LG_Process__c = pProcess.Id;
        request.LG_Response__c = 'Success';
        insert request;

        Datetime yesterday = Datetime.now().addDays(-1);
        Test.setCreatedDate(request.Id, yesterday);

        LG_ProcessRequest__c request2 = new LG_ProcessRequest__c();
        request2.LG_Process__c = pProcess.Id;
        request2.LG_Response__c = 'Rejected';
        insert request2;

        List<LG_AssetProcessAssociation__c> assetAssociations = new List<LG_AssetProcessAssociation__c>();

        for (Asset obj :assets) {

            assetAssociations.add(new LG_AssetProcessAssociation__c( LG_Asset__c = obj.Id, LG_Process__c = pProcess.Id));
        }

        assetAssociations.add(new LG_AssetProcessAssociation__c( LG_Asset__c = topAssetFirst.Id, LG_Process__c = pProcess.Id));
        assetAssociations.add(new LG_AssetProcessAssociation__c( LG_Asset__c = topAssetSecond.Id, LG_Process__c = pProcess.Id));

        insert assetAssociations;

        // Orcestrator stuff
		CSPOFA__Orchestration_Process_Template__c orcTemplate = new CSPOFA__Orchestration_Process_Template__c();
		insert orcTemplate;

		CSPOFA__Orchestration_Process__c process = new CSPOFA__Orchestration_Process__c(CSPOFA__Orchestration_Process_Template__c = orcTemplate.Id, csordtelcoa__Service__c = service.Id, LG_Solution__c = sol.Id);
		insert process;

		CSPOFA__Orchestration_Step__c step = new CSPOFA__Orchestration_Step__c(CSPOFA__Orchestration_Process__c = process.Id);
		insert step;

        noTriggers.Flag__c = false;
        upsert noTriggers;
	}

    @isTest
    private static void processTest() {

		List<SObject> steps = [SELECT Id, CSPOFA__Orchestration_Process__c, CSPOFA__Status__c FROM CSPOFA__Orchestration_Step__c];

		for(SObject obj : steps) {

			CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
			System.assertNotEquals('Complete', step.CSPOFA__Status__c, 'Status should not be complete');
		}

		Test.startTest();

		LG_AnalyseNumberPorting numberPorting = new LG_AnalyseNumberPorting();
		steps = numberPorting.process(steps);

		Test.stopTest();

		for(SObject obj : steps) {

			CSPOFA__Orchestration_Step__c step = (CSPOFA__Orchestration_Step__c) obj;
			System.assertEquals('Complete', step.CSPOFA__Status__c, 'Status should be complete');
		}
	}

    @isTest
	private static void checkNumberPortingFalseTest() {

		Map<Id, CSPOFA__Orchestration_Process__c> processMap = new Map<Id, CSPOFA__Orchestration_Process__c>([SELECT Id FROM CSPOFA__Orchestration_Process__c]);

        // Get solution object before
        csord__Solution__c solBefore = [SELECT ID, LG_AnyNumbersToPort__c, LG_EarliestPortingWishDate__c, LG_LatestPortingWishDate__c FROM csord__Solution__c WHERE Name = 'Test Solution' LIMIT 1];

		Test.startTest();

        LG_NumberPorting porting = new LG_NumberPorting();
		porting.checkNumberPorting(processMap.keySet());

		Test.stopTest();

        // Get solution object after
        csord__Solution__c solAfter = [SELECT ID, LG_AnyNumbersToPort__c, LG_EarliestPortingWishDate__c, LG_LatestPortingWishDate__c FROM csord__Solution__c WHERE Name = 'Test Solution' LIMIT 1];

        // Asert before state
        System.assertEquals(false, solBefore.LG_AnyNumbersToPort__c, 'Invalid Solution data (LG_AnyNumbersToPort__c)');
        System.assertEquals(null, solBefore.LG_EarliestPortingWishDate__c, 'Invalid Solution data (LG_EarliestPortingWishDate__c)');
        System.assertEquals(null, solBefore.LG_LatestPortingWishDate__c, 'Invalid Solution data (LG_LatestPortingWishDate__c)');

        // Asert after state
        System.assertEquals(true, solAfter.LG_AnyNumbersToPort__c, 'Invalid Solution data (LG_AnyNumbersToPort__c)');
        System.assertEquals(Date.today().addDays(-5), solAfter.LG_EarliestPortingWishDate__c, 'Invalid Solution data (LG_EarliestPortingWishDate__c)');
        System.assertEquals(Date.today().addDays(4), solAfter.LG_LatestPortingWishDate__c, 'Invalid Solution data (LG_LatestPortingWishDate__c)');
	}

	@isTest
	private static void checkNumberPortingTrueTest() {

		Map<Id, CSPOFA__Orchestration_Process__c> processMap = new Map<Id, CSPOFA__Orchestration_Process__c>([SELECT Id FROM CSPOFA__Orchestration_Process__c]);

        // Get solution object before
        csord__Solution__c solBefore = [SELECT ID, LG_AnyNumbersToPort__c, LG_EarliestPortingWishDate__c, LG_LatestPortingWishDate__c FROM csord__Solution__c WHERE Name = 'Test Solution' LIMIT 1];
        solBefore.LG_AnyNumbersToPort__c = true;
        update solBefore;

        LG_ProcessRequest__c req = [SELECT Id, LG_Response__c FROM LG_ProcessRequest__c WHERE LG_Response__c = 'Rejected' LIMIT 1];
        req.LG_Response__c = 'Success';
        update req;

		Test.startTest();

        LG_NumberPorting porting = new LG_NumberPorting();
		porting.checkNumberPorting(processMap.keySet());

		Test.stopTest();

        // Get solution object after
        csord__Solution__c solAfter = [SELECT ID, LG_AnyNumbersToPort__c, LG_EarliestPortingWishDate__c, LG_LatestPortingWishDate__c FROM csord__Solution__c WHERE Name = 'Test Solution' LIMIT 1];

        // Asert before state
        System.assertEquals(true, solBefore.LG_AnyNumbersToPort__c, 'Invalid Solution data (LG_AnyNumbersToPort__c)');
        System.assertEquals(null, solBefore.LG_EarliestPortingWishDate__c, 'Invalid Solution data (LG_EarliestPortingWishDate__c)');
        System.assertEquals(null, solBefore.LG_LatestPortingWishDate__c, 'Invalid Solution data (LG_LatestPortingWishDate__c)');

        // Asert after state
        System.assertEquals(false, solAfter.LG_AnyNumbersToPort__c, 'Invalid Solution data (LG_AnyNumbersToPort__c)');
	}
}