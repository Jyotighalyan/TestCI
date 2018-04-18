@isTest
private class KenanAccountExternalIdMapperTest {
	
	@testSetup
	static void setup() {
		KenanServiceConnection__c settings = new KenanServiceConnection__c(
			Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=',
			Session_Timeout__c = '120000',
			Connection_URL__c = 'https://kenan-dev-pubelb-amdocs-1924041402.eu-central-1.elb.amazonaws.com',
			REST_Application_Base__c = '/kenan-salesforce-api/rest',
			Stored_Language_Code__c = '1'
		);

		insert settings;
	}
	
	@isTest
	static void getEnumeratedValuesTest(){
		
		KenanAccountExternalId externalId = new KenanAccountExternalId();
		Datetime curDate = Datetime.now();
		       
        externalId.activeDate = curDate;
        externalId.inactiveDate = curDate;
        externalId.isCurrent = true;
        externalId.accountExternalId = 'accountExternalId';
        externalId.accountExternalIdType = 2;
        externalId.oldAccountExternalId = 'oldId';
        externalId.oldAccountExternalIdType = 3;
        externalId.accountInternalId = 30;

		Test.startTest();
		KenanAccountExternalIdMapper mapper = new KenanAccountExternalIdMapper();
		Map<String,Object> objectMap = mapper.getEnumeratedValues(externalId);
		Test.stopTest();
				
		System.assertEquals(objectMap.get('activeDate'), curDate, '');
		System.assertEquals(objectMap.get('inactiveDate'), curDate, '');
		System.assertEquals(objectMap.get('isCurrent'), true, '');
		System.assertEquals(objectMap.get('accountExternalId'), 'accountExternalId', '');
		System.assertEquals(objectMap.get('accountExternalIdType'), 2, '');
		System.assertEquals(objectMap.get('accountInternalId'), 30, '');
	}
	
	@isTest
	static void getDisplayValuesTest(){
		
		Map<String,Object> objectMap = new Map<String,Object>();
        Datetime curDate = Datetime.now();
		String curDateString = curDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS');

        objectMap.put('activeDate', curDateString);
		objectMap.put('inactiveDate', curDateString);
		objectMap.put('isCurrent', true);
		objectMap.put('accountExternalId', 'accountExternalId');
		objectMap.put('accountExternalIdType', 2);
		objectMap.put('accountInternalId', 30);

        Test.startTest();
        KenanAccountExternalIdMapper mapper = new KenanAccountExternalIdMapper();
        KenanAccountExternalId externalId = mapper.getDisplayValues(objectMap);
        Test.stopTest();

		System.assertEquals(externalId.activeDate, curDate, '');
        System.assertEquals(externalId.inactiveDate, curDate, '');
        System.assertEquals(externalId.isCurrent, true, '');
        System.assertEquals(externalId.accountExternalId, 'accountExternalId', '');
        System.assertEquals(externalId.accountExternalIdType, 2, '');
        System.assertEquals(externalId.accountInternalId, 30, '');
	}
}