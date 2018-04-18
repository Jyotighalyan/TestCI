@isTest
private class KenanServiceExternalIdMapperTest {
	
	
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
		
		KenanServiceExternalId externalId = new KenanServiceExternalId();
		Datetime curDate = Datetime.now();
		       
        externalId.activeDate = curDate;
        externalId.createDt = curDate;
        externalId.inactiveDate = curDate;
        externalId.intendedViewEffectiveDt = curDate;
        externalId.isCurrent = true;
        externalId.isFromInventory = true;
        externalId.prevViewId = 3;
        externalId.serviceExternalId = 'serviceExternalId';
        externalId.serviceExternalIdType = 2;
        externalId.oldServiceExternalId = 'oldId';
        externalId.oldServiceExternalIdType = 3;
        externalId.serviceInternalId = 30;
        externalId.serviceInternalIdResets = 0;
        externalId.viewId = 4;
        externalId.viewStatus = 5;

		Test.startTest();
		KenanServiceExternalIdMapper mapper = new KenanServiceExternalIdMapper();
		Map<String,Object> objectMap = mapper.getEnumeratedValues(externalId);
		Test.stopTest();
				
		System.assertEquals(objectMap.get('activeDate'), curDate, '');
		System.assertEquals(objectMap.get('createDt'), curDate, '');
		System.assertEquals(objectMap.get('inactiveDate'), curDate, '');
		System.assertEquals(objectMap.get('intendedViewEffectiveDt'), curDate, '');
		System.assertEquals(objectMap.get('isCurrent'), true, '');
		System.assertEquals(objectMap.get('isFromInventory'), true, '');
		System.assertEquals(objectMap.get('prevViewId'), 3, '');
		System.assertEquals(objectMap.get('serviceExternalId'), 'serviceExternalId', '');
		System.assertEquals(objectMap.get('serviceExternalIdType'), 2, '');
		//System.assertEquals(objectMap.get('oldServiceExternalId'), 'oldId', '');
		//System.assertEquals(objectMap.get('oldServiceExternalIdType'), 3, '');
		System.assertEquals(objectMap.get('serviceInternalId'), 30, '');
		System.assertEquals(objectMap.get('serviceInternalIdResets'), 0, '');
		System.assertEquals(objectMap.get('viewId'), 4, '');
		System.assertEquals(objectMap.get('viewStatus'), 5, '');
	}
	
	@isTest
	static void getDisplayValuesTest(){
		
		Map<String,Object> objectMap = new Map<String,Object>();
        Datetime curDate = Datetime.now();
		String curDateString = curDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS');

        objectMap.put('activeDate', curDateString);
		objectMap.put('createDt', curDateString);
		objectMap.put('inactiveDate', curDateString);
		objectMap.put('intendedViewEffectiveDt', curDateString);
		objectMap.put('isCurrent', true);
		objectMap.put('isFromInventory', true);
		objectMap.put('prevViewId', 3);
		objectMap.put('serviceExternalId', 'serviceExternalId');
		objectMap.put('serviceExternalIdType', 2);
		objectMap.put('oldServiceExternalId', 'oldId');
		objectMap.put('oldServiceExternalIdType', 3);
		objectMap.put('serviceInternalId', 30);
		objectMap.put('serviceInternalIdResets', 0);
		objectMap.put('viewId', 4);
		objectMap.put('viewStatus', 5);

        Test.startTest();
        KenanServiceExternalIdMapper mapper = new KenanServiceExternalIdMapper();
        KenanServiceExternalId externalId = mapper.getDisplayValues(objectMap);
        Test.stopTest();

		System.assertEquals(externalId.activeDate, curDate, '');
        System.assertEquals(externalId.createDt, curDate, '');
        System.assertEquals(externalId.inactiveDate, curDate, '');
        System.assertEquals(externalId.intendedViewEffectiveDt, curDate, '');
        System.assertEquals(externalId.isCurrent, true, '');
        System.assertEquals(externalId.isFromInventory, true, '');
        System.assertEquals(externalId.prevViewId, 3, '');
        System.assertEquals(externalId.serviceExternalId, 'serviceExternalId', '');
        System.assertEquals(externalId.serviceExternalIdType, 2, '');
        //System.assertEquals(externalId.oldServiceExternalId, 'oldId', '');
        //System.assertEquals(externalId.oldServiceExternalIdType, 3, '');
        System.assertEquals(externalId.serviceInternalId, 30, '');
        System.assertEquals(externalId.serviceInternalIdResets, 0, '');
        System.assertEquals(externalId.viewId, 4, '');
        System.assertEquals(externalId.viewStatus, 5, '');
	}
}