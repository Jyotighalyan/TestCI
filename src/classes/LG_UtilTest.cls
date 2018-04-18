@isTest
private class LG_UtilTest {

	private static String vfBaseUrl = 'vforce.url';
	private static String sfdcBaseUrl = 'sfdc.url';

	@testsetup
	private static void setupTestData()
	{
		No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
		noTriggers.Flag__c = true;
		noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
		upsert noTriggers;

		LG_EnvironmentVariables__c envVariables = new LG_EnvironmentVariables__c();
		envVariables.LG_SalesforceBaseURL__c = sfdcBaseUrl;
		envVariables.LG_VisualForceBaseURL__c = vfBaseUrl;
		envVariables.LG_CloudSenceAnywhereIconID__c = 'csaID';
		envVariables.LG_ServiceAvailabilityIconID__c = 'saIconId';
		envVariables.LG_SandboxInstance__c = 'dev';
		insert envVariables;

		csordtelcoa__Orders_Subscriptions_Options__c osOptions = new csordtelcoa__Orders_Subscriptions_Options__c();
		osOptions.csordtelcoa__Statuses_Not_Allowing_Change__c = 'Change,Move,Terminate';
		osOptions.LG_ServiceRequestDeactivateStatus__c = 'Ready for Deactivation';
		osOptions.LG_SubscriptionRequestDeactivateStatus__c = 'Ready for Deactivation';
		osOptions.LG_ServiceDeactivatedStatus__c = 'Inactive';
		insert osOptions;

		csordtelcoa__Change_Types__c changeTypeNotValid = new csordtelcoa__Change_Types__c();
		changeTypeNotValid.Name = 'Not Valid';
		changeTypeNotValid.ValidRelatedProducts__c = false;
		insert changeTypeNotValid;

		csordtelcoa__Change_Types__c changeTypeValid = new csordtelcoa__Change_Types__c();
		changeTypeValid.Name = 'Valid';
		changeTypeValid.ValidRelatedProducts__c = true;
		insert changeTypeValid;

		csordtelcoa__Change_Types__c changeTypeDown = new csordtelcoa__Change_Types__c();
		changeTypeDown.csordtelcoa__Sort_Order__c = 0;
		changeTypeDown.Name                       = 'Downgrade';
		changeTypeDown.LG_MigrateVariety__c       = true;
		insert changeTypeDown;

		csordtelcoa__Change_Types__c changeTypeUp = new csordtelcoa__Change_Types__c();
		changeTypeUp.csordtelcoa__Sort_Order__c = 2;
		changeTypeUp.Name                       = 'Upgrade';
		changeTypeUp.LG_MigrateVariety__c       = true;
		insert changeTypeUp;

		csordtelcoa__Change_Types__c changeType = new csordtelcoa__Change_Types__c();
		changeType.csordtelcoa__Sort_Order__c = 1;
		changeType.Name                       = 'Change';
		changeType.LG_MigrateVariety__c       = false;
		insert changeType;

		noTriggers.Flag__c = false;
		upsert noTriggers;
	}

	private static testmethod void testGetVisualForceBaseURl()
	{
		System.assertEquals(vfBaseUrl, LG_Util.getVisualForceBaseUrl(),
							'VisualForce url base url should be ' + vfBaseUrl);
	}

	private static testmethod void testGetSalesforceBaseURl()
	{
		System.assertEquals(sfdcBaseUrl, LG_Util.getSalesforceBaseUrl(),
							'Salesforce url base url should be ' + sfdcBaseUrl);
	}

	private static testmethod void testGetOSStatusesNotAllowingChange()
	{
		List<String> statusesNotAllowingChange = LG_Util.getOSStatusesNotAllowingChange();
		System.assertEquals(3, statusesNotAllowingChange.size(), 'Three statuses should be in the Custom settings list');
	}

	private static testmethod void testGetSubscriptionRequestDeactivateStatus()
	{
		System.assertEquals('Ready for Deactivation', LG_Util.getSubscriptionRequestDeactivateStatus(), 'Status should be Ready for Deactivation');
	}

	private static testmethod void testGetServiceRequestDeactivateStatus()
	{
		System.assertEquals('Ready for Deactivation', LG_Util.getServiceRequestDeactivateStatus(), 'Status should be Ready for Deactivation');
	}

	private static testmethod void testGetServiceDeactivatedStatus()
	{
		System.assertEquals('Inactive', LG_Util.getServiceDeactivatedStatus(), 'Status should be Inactive');
	}

	private static testmethod void testGetLookupFieldReferenceId()
	{
		Test.startTest();
			String referenceId = LG_Util.getLookupFieldReferenceId(new PageReference('/' + Contact.getSObjectType().getDescribe().getKeyPrefix()),
																	Account.getSObjectType().getDescribe().getKeyPrefix());
		Test.stopTest();

		System.assertEquals('testId', referenceId, 'reference Id should be testId');
	}

	private static testmethod void testGetSandboxInstanceName()
	{
		System.assertEquals('dev', LG_Util.getSandboxInstanceName(), 'Instance should be dev');
	}

	@IsTest
    private static void ValidateIDsTest()
	{
	    Boolean BothIDs = false;
	    Boolean SFID = false;
	    Boolean GUID = false;

	    Test.startTest();

	    BothIDs = (LG_Util.IsValidId('00Q8E00000259dU') && LG_Util.IsValidId('gasfhdhd-xsw2-4r32-8e2h-df232454fs1a'));
	    SFID = LG_Util.IsValidSFId('00Q8E00000259dU');
	    GUID = LG_Util.IsValidConfiguratorId('gasfhdhd-xsw2-4r32-ye2h-df232454fs1a');

	    Test.stopTest();

		System.assertEquals(true, BothIDs, 'Invalid conversion');
		System.assertEquals(true, SFID, 'Invalid conversion');
		System.assertEquals(true, GUID, 'Invalid conversion');
	}

	private static testmethod void shouldValidRelProductsByChangeType()
	{
		System.assertEquals(false, LG_Util.shouldValidRelProductsByChangeType('Not Valid'), 'Not valid should be returned as false');
		System.assertEquals(true, LG_Util.shouldValidRelProductsByChangeType('Valid'), 'Valid should be returned as false');
	}
    public static testmethod void getAdminEmailAddressestest(){
        test.starttest();
        LG_EnvironmentVariables__c envvar=[select LG_SalesforceBaseURL__c,LG_CloudSenceAnywhereIconID__c,LG_ServiceAvailabilityIconID__c,LG_SandboxInstance__c from LG_EnvironmentVariables__c];

        LG_Util.getAdminEmailAddresses();
         LG_Util.checkNullPadded(null,null,null);
        LG_Util.checkIdNull('');
        LG_Util.getFormattedAddress('','','','','');

          String accWithBillAccName = 'SFDT-59 W-Def';
   String accWithoutBillAccName = 'SFDT-59 Wo-Def';

         List<Account> accounts=new List<Account>();
         Account accWithDefaultBill = LG_GeneralTest.CreateAccount(accWithBillAccName, '12345678', 'Ziggo', false);
    Account accWithoutDefaultBill = LG_GeneralTest.CreateAccount(accWithoutBillAccName, '12345679', 'Ziggo', false);
    accounts.add(accWithoutDefaultBill);
    accounts.add(accWithDefaultBill);
    insert accounts;

         List<Opportunity> opps = new List<Opportunity>();
    Opportunity oppWDefault = LG_GeneralTest.CreateOpportunity(accWithDefaultBill, false);
    Opportunity oppWoDefault = LG_GeneralTest.CreateOpportunity(accWithoutDefaultBill, false);
    opps.add(oppWDefault);
    opps.add(oppWoDefault);
    insert opps;

         cscfga__Product_Basket__c basketWithDefaultBillAcc = LG_GeneralTest.createProductBasket('WithBillAcc', accWithDefaultBill, null, oppWDefault, true);
        cscfga__Product_Basket__c basketWithDefaultBillAcc2 = LG_GeneralTest.createProductBasket('WithBillAcc', accWithDefaultBill, null, oppWDefault, False);
        basketWithDefaultBillAcc2.csordtelcoa__Synchronised_with_Opportunity__c=True;
        insert basketWithDefaultBillAcc2;
        LG_Util.createNewPremise(basketWithDefaultBillAcc2);
        LG_Util.createNewPremise(basketWithDefaultBillAcc2,oppWDefault);
          cscrm__Address__c premise=LG_GeneralTest.crateAddress('xyz', 'andal', 'ranchi', '21', '334', '620101', 'India', accWithDefaultBill, false);
        insert premise;
        List<cscrm__Address__c> addresses =new List<cscrm__Address__c>();
        addresses.add(premise);
        LG_Util.activeBatchJobs('abc');
        LG_Util.createMacdOpportunity('',accWithDefaultBill);
        LG_Util.resolveAndUpsertPremiseDuplicates(addresses);
       csordtelcoa__Orders_Subscriptions_Options__c optc=[ select csordtelcoa__Statuses_Not_Allowing_Change__c,LG_ServiceRequestDeactivateStatus__c,LG_SubscriptionRequestDeactivateStatus__c,LG_ServiceDeactivatedStatus__c from csordtelcoa__Orders_Subscriptions_Options__c];
        optc.csordtelcoa__Subscription_Closed_Replaced_State__c='Closed Replaced';
        update optc;
        LG_Util.getSubscriptionClosedReplacedStatus();
        LG_Util.createNewBillingAccount(basketWithDefaultBillAcc2,oppWDefault);
        LG_Util.resolveAndInsertPremiseDuplicates(addresses);
      //  LG_Util.createTask('subject', 'taskType', 'result','0054E000001mIzXQAU', null,'status', 'priority', null, true);
        LG_Util.generateRandomNumberString(12);
        LG_Util.generateGUID();
        LG_Util.getCurrentUserSalesChannel();
        LG_Util.getSalesChannelsForTerminate();
        date d1=system.today();
        LG_Util.getFormattedDate(d1);
        LG_Util.trimAll('');
        LG_Util.commaSeparatedStringToSet('abc,xyz');
        LG_Util.semicolonSeparatedStringToSet('abc:xyz');
        LG_Util.getScreenFlowFullName('','');



        test.stoptest();

    }

	private static testmethod void testGetMigrateVarietyChangeTypes() {
		System.assertEquals(true, LG_Util.getMigrateVarietyChangeTypes().contains('Downgrade'), 'Data invalid');
		System.assertEquals(true, LG_Util.getMigrateVarietyChangeTypes().contains('Upgrade'), 'Data invalid');
		System.assertEquals(false, LG_Util.getMigrateVarietyChangeTypes().contains('Change'), 'Data invalid');
	}
}