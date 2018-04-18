@isTest
private class KenanAdjustmentMapperTest {
	
	
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
		
		KenanAdjustment adjustment = new KenanAdjustment();
		Date curDate = Date.today();
        Decimal amt = 300;
		       
        adjustment.accountExternalId = 'accountExternalId';
        adjustment.accountExternalIdType = 1;
        adjustment.accountInternalId = 2;
        adjustment.adjReasonCode = 'Goodwill credited disorder';
        adjustment.billRefNo = 3.0;
        adjustment.billRefResets = 4.0;
        adjustment.currencyCode = 'KRW';
        adjustment.effectiveDate = curDate;
        adjustment.fraudIndicator = 'fraudIndicator';
        //adjustment.invoice = 'invoice';
        adjustment.invoiceItem = 'invoiceItem';
        adjustment.origType = 'adjustment against an adjustment';
        adjustment.openItemId = 'Invoice total';
        adjustment.primaryUnits = 'primaryUnits';
        adjustment.primaryUnitsType = 'primaryUnitsType';
        adjustment.requestStatus = 'approved';
        adjustment.revRcvCostCtr = 'revRcvCostCtr';
        adjustment.totalAmt = amt;
        adjustment.trackingId = 'trackingId';
        adjustment.trackingIdServ = 'trackingIdServ';
        adjustment.approvedBy = 'Me';
        adjustment.approvalStatus = 'approved';

		Test.startTest();
		KenanAdjustmentMapper mapper = new KenanAdjustmentMapper();
		Map<String,Object> objectMap = mapper.getEnumeratedValues(adjustment);
		Test.stopTest();
				
		System.assertEquals(objectMap.get('accountExternalId'), 'accountExternalId', '');
		System.assertEquals(objectMap.get('accountExternalIdType'), 1, '');
		System.assertEquals(objectMap.get('accountInternalId'), 2, '');
		System.assertEquals(objectMap.get('adjReasonCode'), '11', '');
		System.assertEquals(objectMap.get('billRefNo'), 3.0, '');
		System.assertEquals(objectMap.get('billRefResets'), 4.0, '');
		System.assertEquals(objectMap.get('currencyCode'), '10', '');
		System.assertEquals(objectMap.get('effectiveDate'), curDate, '');
		System.assertEquals(objectMap.get('fraudIndicator'), 'fraudIndicator', '');
		System.assertEquals(objectMap.get('invoiceItem'), 'invoiceItem', '');
		System.assertEquals(objectMap.get('origType'), '4', '');
		System.assertEquals(objectMap.get('openItemId'), '101', '');
		System.assertEquals(objectMap.get('primaryUnits'), 'primaryUnits', '');
		System.assertEquals(objectMap.get('requestStatus'), '1', '');
		System.assertEquals(objectMap.get('revRcvCostCtr'), 'revRcvCostCtr', '');
		System.assertEquals(objectMap.get('totalAmt'), amt * 100, '');
		System.assertEquals(objectMap.get('trackingId'), 'trackingId', '');
		System.assertEquals(objectMap.get('trackingIdServ'), 'trackingIdServ', '');
	}
	
	@isTest
	static void getDisplayValuesTest(){
		
		Map<String,Object> objectMap = new Map<String,Object>();
        Date curDate = Date.today();
        Decimal amt = 300;

        objectMap.put('accountExternalId', 'accountExternalId');
		objectMap.put('accountExternalIdType', 1);
		objectMap.put('accountInternalId', 2);
		objectMap.put('adjReasonCode', '11');
		objectMap.put('billRefNo', 3.0);
		objectMap.put('billRefResets', 4.0);
		objectMap.put('currencyCode', '10');
		objectMap.put('effectiveDate', curDate);
		objectMap.put('fraudIndicator', 'fraudIndicator');
		objectMap.put('invoiceItem', 'invoiceItem');
		objectMap.put('origType', '4');
		objectMap.put('openItemId', '101');
		objectMap.put('primaryUnits', 'primaryUnits');
		objectMap.put('requestStatus', '1');
		objectMap.put('revRcvCostCtr', 'revRcvCostCtr');
		objectMap.put('totalAmt', amt);
		objectMap.put('trackingId', 'trackingId');
		objectMap.put('trackingIdServ', 'trackingIdServ');

        Test.startTest();
        KenanAdjustmentMapper mapper = new KenanAdjustmentMapper();
        KenanAdjustment adjustment = (KenanAdjustment) mapper.getDisplayValues(objectMap);
        Test.stopTest();

		System.assertEquals(adjustment.accountExternalId, 'accountExternalId', '');
		System.assertEquals(adjustment.accountExternalIdType, 1, '');
		System.assertEquals(adjustment.accountInternalId, 2, '');
		System.assertEquals(adjustment.adjReasonCode, 'Goodwill credited disorder', '');
		System.assertEquals(adjustment.billRefNo, 3.0, '');
		System.assertEquals(adjustment.billRefResets, 4.0, '');
		System.assertEquals(adjustment.currencyCode, 'KRW', '');
		System.assertEquals(adjustment.effectiveDate, KenanUtils.fixDateTime(curDate).date(), '');
		System.assertEquals(adjustment.fraudIndicator, 'fraudIndicator', '');
		System.assertEquals(adjustment.invoiceItem, 'invoiceItem', '');
		System.assertEquals(adjustment.origType, 'adjustment against an adjustment', '');
		System.assertEquals(adjustment.openItemId, 'Invoice total', '');
		System.assertEquals(adjustment.primaryUnits, 'primaryUnits', '');
		System.assertEquals(adjustment.requestStatus, 'approved', '');
		System.assertEquals(adjustment.revRcvCostCtr, 'revRcvCostCtr', '');
		System.assertEquals(adjustment.totalAmt, amt / 100, '');
		System.assertEquals(adjustment.trackingId, 'trackingId', '');
		System.assertEquals(adjustment.trackingIdServ, 'trackingIdServ', '');
	}

	@isTest
	static void getEnumeratedValuesTestAsGerman() {
		User germanUser = generateGermanUser();
		System.runAs(germanUser) {
			KenanAdjustment adjustment = new KenanAdjustment();
			Date curDate = Date.today();
	        Decimal amt = 3.23;
			       
	        adjustment.accountExternalId = 'accountExternalId';
	        adjustment.accountExternalIdType = 1;
	        adjustment.accountInternalId = 2;
	        adjustment.adjReasonCode = 'Goodwill credited disorder';
	        adjustment.billRefNo = 3.0;
	        adjustment.billRefResets = 4.0;
	        adjustment.currencyCode = 'KRW';
	        adjustment.effectiveDate = curDate;
	        adjustment.fraudIndicator = 'fraudIndicator';
	        adjustment.invoiceItem = 'invoiceItem';
	        adjustment.origType = 'adjustment against an adjustment';
	        adjustment.openItemId = 'Invoice total';
	        adjustment.primaryUnits = 'primaryUnits';
	        adjustment.primaryUnitsType = 'primaryUnitsType';
	        adjustment.requestStatus = 'approved';
	        adjustment.revRcvCostCtr = 'revRcvCostCtr';
	        adjustment.totalAmt = amt;
	        adjustment.trackingId = 'trackingId';
	        adjustment.trackingIdServ = 'trackingIdServ';
	        adjustment.approvedBy = 'Me';
	        adjustment.approvalStatus = 'approved';

			Test.startTest();
			KenanAdjustmentMapper mapper = new KenanAdjustmentMapper();
			Map<String,Object> objectMap = mapper.getEnumeratedValues(adjustment);
			Test.stopTest();
					
			System.assertEquals(objectMap.get('accountExternalId'), 'accountExternalId', '');
			System.assertEquals(objectMap.get('accountExternalIdType'), 1, '');
			System.assertEquals(objectMap.get('accountInternalId'), 2, '');
			System.assertEquals(objectMap.get('adjReasonCode'), '11', '');
			System.assertEquals(objectMap.get('billRefNo'), 3.0, '');
			System.assertEquals(objectMap.get('billRefResets'), 4.0, '');
			System.assertEquals(objectMap.get('currencyCode'), '10', '');
			System.assertEquals(objectMap.get('effectiveDate'), curDate, '');
			System.assertEquals(objectMap.get('fraudIndicator'), 'fraudIndicator', '');
			System.assertEquals(objectMap.get('invoiceItem'), 'invoiceItem', '');
			System.assertEquals(objectMap.get('origType'), '4', '');
			System.assertEquals(objectMap.get('openItemId'), '101', '');
			System.assertEquals(objectMap.get('primaryUnits'), 'primaryUnits', '');
			System.assertEquals(objectMap.get('requestStatus'), '1', '');
			System.assertEquals(objectMap.get('revRcvCostCtr'), 'revRcvCostCtr', '');
			System.assertEquals(objectMap.get('totalAmt'), amt * 100, '');
			System.assertEquals(objectMap.get('trackingId'), 'trackingId', '');
			System.assertEquals(objectMap.get('trackingIdServ'), 'trackingIdServ', '');
		}
	}

	@isTest
	static void getDisplayValuesTestAsGerman() {
		User germanUser = generateGermanUser();
		System.runAs(germanUser) {
			
			Map<String,Object> objectMap = new Map<String,Object>();
	        Date curDate = Date.today();
	        Decimal amt = 3.45;

	        objectMap.put('accountExternalId', 'accountExternalId');
			objectMap.put('accountExternalIdType', 1);
			objectMap.put('accountInternalId', 2);
			objectMap.put('adjReasonCode', '11');
			objectMap.put('billRefNo', 3.0);
			objectMap.put('billRefResets', 4.0);
			objectMap.put('currencyCode', '10');
			objectMap.put('effectiveDate', curDate);
			objectMap.put('fraudIndicator', 'fraudIndicator');
			objectMap.put('invoiceItem', 'invoiceItem');
			objectMap.put('origType', '4');
			objectMap.put('openItemId', '101');
			objectMap.put('primaryUnits', 'primaryUnits');
			objectMap.put('requestStatus', '1');
			objectMap.put('revRcvCostCtr', 'revRcvCostCtr');
			objectMap.put('totalAmt', amt);
			objectMap.put('trackingId', 'trackingId');
			objectMap.put('trackingIdServ', 'trackingIdServ');

	        Test.startTest();
	        KenanAdjustmentMapper mapper = new KenanAdjustmentMapper();
	        KenanAdjustment adjustment = (KenanAdjustment) mapper.getDisplayValues(objectMap);
	        Test.stopTest();

			System.assertEquals(adjustment.accountExternalId, 'accountExternalId', '');
			System.assertEquals(adjustment.accountExternalIdType, 1, '');
			System.assertEquals(adjustment.accountInternalId, 2, '');
			System.assertEquals(adjustment.adjReasonCode, 'Goodwill credited disorder', '');
			System.assertEquals(adjustment.billRefNo, 3.0, '');
			System.assertEquals(adjustment.billRefResets, 4.0, '');
			System.assertEquals(adjustment.currencyCode, 'KRW', '');
			System.assertEquals(adjustment.effectiveDate, KenanUtils.fixDateTime(curDate).date(), '');
			System.assertEquals(adjustment.fraudIndicator, 'fraudIndicator', '');
			System.assertEquals(adjustment.invoiceItem, 'invoiceItem', '');
			System.assertEquals(adjustment.origType, 'adjustment against an adjustment', '');
			System.assertEquals(adjustment.openItemId, 'Invoice total', '');
			System.assertEquals(adjustment.primaryUnits, 'primaryUnits', '');
			System.assertEquals(adjustment.requestStatus, 'approved', '');
			System.assertEquals(adjustment.revRcvCostCtr, 'revRcvCostCtr', '');
			System.assertEquals(adjustment.totalAmt, amt / 100, '');
			System.assertEquals(adjustment.trackingId, 'trackingId', '');
			System.assertEquals(adjustment.trackingIdServ, 'trackingIdServ', '');
		}
	}

	@isTest
	static void getDisplayValuesInvalidTestAsGerman() {
		User germanUser = generateGermanUser();
		System.runAs(germanUser) {
			
			Map<String,Object> objectMap = new Map<String,Object>();
	        Date curDate = Date.today();
	        Decimal amt = 3.4547;

	        objectMap.put('accountExternalId', 'accountExternalId');
			objectMap.put('accountExternalIdType', 1);
			objectMap.put('accountInternalId', 2);
			objectMap.put('adjReasonCode', '11');
			objectMap.put('billRefNo', 3.0);
			objectMap.put('billRefResets', 4.0);
			objectMap.put('currencyCode', '10');
			objectMap.put('effectiveDate', curDate);
			objectMap.put('fraudIndicator', 'fraudIndicator');
			objectMap.put('invoiceItem', 'invoiceItem');
			objectMap.put('origType', '4');
			objectMap.put('openItemId', '101');
			objectMap.put('primaryUnits', 'primaryUnits');
			objectMap.put('requestStatus', '1');
			objectMap.put('revRcvCostCtr', 'revRcvCostCtr');
			objectMap.put('totalAmt', amt);
			objectMap.put('trackingId', 'trackingId');
			objectMap.put('trackingIdServ', 'trackingIdServ');

	        Test.startTest();
	        KenanAdjustmentMapper mapper = new KenanAdjustmentMapper();
	        KenanAdjustment adjustment = (KenanAdjustment) mapper.getDisplayValues(objectMap);
	        Test.stopTest();

			System.assertEquals(adjustment.accountExternalId, 'accountExternalId', '');
			System.assertEquals(adjustment.accountExternalIdType, 1, '');
			System.assertEquals(adjustment.accountInternalId, 2, '');
			System.assertEquals(adjustment.adjReasonCode, 'Goodwill credited disorder', '');
			System.assertEquals(adjustment.billRefNo, 3.0, '');
			System.assertEquals(adjustment.billRefResets, 4.0, '');
			System.assertEquals(adjustment.currencyCode, 'KRW', '');
			System.assertEquals(adjustment.effectiveDate, KenanUtils.fixDateTime(curDate).date(), '');
			System.assertEquals(adjustment.fraudIndicator, 'fraudIndicator', '');
			System.assertEquals(adjustment.invoiceItem, 'invoiceItem', '');
			System.assertEquals(adjustment.origType, 'adjustment against an adjustment', '');
			System.assertEquals(adjustment.openItemId, 'Invoice total', '');
			System.assertEquals(adjustment.primaryUnits, 'primaryUnits', '');
			System.assertEquals(adjustment.requestStatus, 'approved', '');
			System.assertEquals(adjustment.revRcvCostCtr, 'revRcvCostCtr', '');
			System.assertEquals(adjustment.totalAmt, amt / 100, '');
			System.assertEquals(adjustment.trackingId, 'trackingId', '');
			System.assertEquals(adjustment.trackingIdServ, 'trackingIdServ', '');
		}
	}

	@isTest
	static void getDisplayValuesLargeTestAsGerman() {
		User germanUser = generateGermanUser();
		System.runAs(germanUser) {
			
			Map<String,Object> objectMap = new Map<String,Object>();
	        Date curDate = Date.today();
	        Decimal amt = 300.4547;

	        objectMap.put('accountExternalId', 'accountExternalId');
			objectMap.put('accountExternalIdType', 1);
			objectMap.put('accountInternalId', 2);
			objectMap.put('adjReasonCode', '11');
			objectMap.put('billRefNo', 3.0);
			objectMap.put('billRefResets', 4.0);
			objectMap.put('currencyCode', '10');
			objectMap.put('effectiveDate', curDate);
			objectMap.put('fraudIndicator', 'fraudIndicator');
			objectMap.put('invoiceItem', 'invoiceItem');
			objectMap.put('origType', '4');
			objectMap.put('openItemId', '101');
			objectMap.put('primaryUnits', 'primaryUnits');
			objectMap.put('requestStatus', '1');
			objectMap.put('revRcvCostCtr', 'revRcvCostCtr');
			objectMap.put('totalAmt', amt);
			objectMap.put('trackingId', 'trackingId');
			objectMap.put('trackingIdServ', 'trackingIdServ');

	        Test.startTest();
	        KenanAdjustmentMapper mapper = new KenanAdjustmentMapper();
	        KenanAdjustment adjustment = (KenanAdjustment) mapper.getDisplayValues(objectMap);
	        Test.stopTest();

			System.assertEquals(adjustment.accountExternalId, 'accountExternalId', '');
			System.assertEquals(adjustment.accountExternalIdType, 1, '');
			System.assertEquals(adjustment.accountInternalId, 2, '');
			System.assertEquals(adjustment.adjReasonCode, 'Goodwill credited disorder', '');
			System.assertEquals(adjustment.billRefNo, 3.0, '');
			System.assertEquals(adjustment.billRefResets, 4.0, '');
			System.assertEquals(adjustment.currencyCode, 'KRW', '');
			System.assertEquals(adjustment.effectiveDate, KenanUtils.fixDateTime(curDate).date(), '');
			System.assertEquals(adjustment.fraudIndicator, 'fraudIndicator', '');
			System.assertEquals(adjustment.invoiceItem, 'invoiceItem', '');
			System.assertEquals(adjustment.origType, 'adjustment against an adjustment', '');
			System.assertEquals(adjustment.openItemId, 'Invoice total', '');
			System.assertEquals(adjustment.primaryUnits, 'primaryUnits', '');
			System.assertEquals(adjustment.requestStatus, 'approved', '');
			System.assertEquals(adjustment.revRcvCostCtr, 'revRcvCostCtr', '');
			System.assertEquals(adjustment.totalAmt, amt / 100, '');
			System.assertEquals(adjustment.trackingId, 'trackingId', '');
			System.assertEquals(adjustment.trackingIdServ, 'trackingIdServ', '');
		}
	}

	@isTest
	static void getEnumeratedValuesListTest(){
		List<Map<String,Object>> valuesList = new List<Map<String,Object>>();
		Map<String,Object> objectMap = new Map<String,Object>();
        Date curDate = Date.today();
        Decimal amt = 300;

        objectMap.put('accountExternalId', 'accountExternalId');
		objectMap.put('accountExternalIdType', 1);
		objectMap.put('accountInternalId', 2);
		objectMap.put('adjReasonCode', 'Goodwill credited disorder');
		objectMap.put('billRefNo', 3.0);
		objectMap.put('billRefResets', 4.0);
		objectMap.put('currencyCode', 'KRW');
		objectMap.put('effectiveDate', curDate);
		objectMap.put('fraudIndicator', 'fraudIndicator');
		objectMap.put('invoiceItem', 'invoiceItem');
		objectMap.put('origType', 'adjustment against an adjustment');
		objectMap.put('openItemId', 'Invoice total');
		objectMap.put('primaryUnits', 'primaryUnits');
		objectMap.put('requestStatus', 'approved');
		objectMap.put('revRcvCostCtr', 'revRcvCostCtr');
		objectMap.put('totalAmt', amt);
		objectMap.put('trackingId', 'trackingId');
		objectMap.put('trackingIdServ', 'trackingIdServ');

		valuesList.add(objectMap);
		Map<String,Object> objectMap2 = new Map<String,Object>();
		valuesList.add(objectMap2);

        Test.startTest();
        KenanAdjustmentMapper mapper = new KenanAdjustmentMapper();
        mapper.getEnumeratedValues(valuesList);
        Test.stopTest();

		System.assertEquals(objectMap.get('accountExternalId'), 'accountExternalId', '');
		System.assertEquals(objectMap.get('accountExternalIdType'), 1, '');
		System.assertEquals(objectMap.get('accountInternalId'), 2, '');
		System.assertEquals(objectMap.get('adjReasonCode'), '11', '');
		System.assertEquals(objectMap.get('billRefNo'), 3.0, '');
		System.assertEquals(objectMap.get('billRefResets'), 4.0, '');
		System.assertEquals(objectMap.get('currencyCode'), '10', '');
		System.assertEquals(objectMap.get('effectiveDate'), curDate, '');
		System.assertEquals(objectMap.get('fraudIndicator'), 'fraudIndicator', '');
		System.assertEquals(objectMap.get('invoiceItem'), 'invoiceItem', '');
		System.assertEquals(objectMap.get('origType'), '4', '');
		System.assertEquals(objectMap.get('openItemId'), '101', '');
		System.assertEquals(objectMap.get('primaryUnits'), 'primaryUnits', '');
		System.assertEquals(objectMap.get('requestStatus'), '1', '');
		System.assertEquals(objectMap.get('revRcvCostCtr'), 'revRcvCostCtr', '');
		System.assertEquals(objectMap.get('totalAmt'), amt * 100, '');
		System.assertEquals(objectMap.get('trackingId'), 'trackingId', '');
		System.assertEquals(objectMap.get('trackingIdServ'), 'trackingIdServ', '');
	}

	@isTest
	static void getDisplayValuesListTest(){
		List<Map<String,Object>> valuesList = new List<Map<String,Object>>();
		Map<String,Object> objectMap = new Map<String,Object>();
        Date curDate = Date.today();
        Decimal amt = 300;

        objectMap.put('accountExternalId', 'accountExternalId');
		objectMap.put('accountExternalIdType', 1);
		objectMap.put('accountInternalId', 2);
		objectMap.put('adjReasonCode', '11');
		objectMap.put('billRefNo', 3.0);
		objectMap.put('billRefResets', 4.0);
		objectMap.put('currencyCode', '10');
		objectMap.put('effectiveDate', curDate);
		objectMap.put('fraudIndicator', 'fraudIndicator');
		objectMap.put('invoiceItem', 'invoiceItem');
		objectMap.put('origType', '4');
		objectMap.put('openItemId', '101');
		objectMap.put('primaryUnits', 'primaryUnits');
		objectMap.put('requestStatus', '1');
		objectMap.put('revRcvCostCtr', 'revRcvCostCtr');
		objectMap.put('totalAmt', amt);
		objectMap.put('trackingId', 'trackingId');
		objectMap.put('trackingIdServ', 'trackingIdServ');

		valuesList.add(objectMap);
		Map<String,Object> objectMap2 = new Map<String,Object>();
		valuesList.add(objectMap2);

        Test.startTest();
        KenanAdjustmentMapper mapper = new KenanAdjustmentMapper();
        mapper.getDisplayValues(valuesList);
        Test.stopTest();

        System.assertEquals(objectMap.get('accountExternalId'), 'accountExternalId', '');
		System.assertEquals(objectMap.get('accountExternalIdType'), 1, '');
		System.assertEquals(objectMap.get('accountInternalId'), 2, '');
		System.assertEquals(objectMap.get('adjReasonCode'), 'Goodwill credited disorder', '');
		System.assertEquals(objectMap.get('billRefNo'), 3.0, '');
		System.assertEquals(objectMap.get('billRefResets'), 4.0, '');
		System.assertEquals(objectMap.get('currencyCode'), 'KRW', '');
		System.assertEquals(objectMap.get('effectiveDate'),  curDate, '');
		System.assertEquals(objectMap.get('fraudIndicator'), 'fraudIndicator', '');
		System.assertEquals(objectMap.get('invoiceItem'), 'invoiceItem', '');
		System.assertEquals(objectMap.get('origType'), 'adjustment against an adjustment', '');
		System.assertEquals(objectMap.get('openItemId'), 'Invoice total', '');
		System.assertEquals(objectMap.get('primaryUnits'), 'primaryUnits', '');
		System.assertEquals(objectMap.get('requestStatus'), 'approved', '');
		System.assertEquals(objectMap.get('revRcvCostCtr'), 'revRcvCostCtr', '');
		System.assertEquals(objectMap.get('totalAmt'), amt / 100, '');
		System.assertEquals(objectMap.get('trackingId'), 'trackingId', '');
		System.assertEquals(objectMap.get('trackingIdServ'), 'trackingIdServ', '');
	}

	public static User generateGermanUser() {
        User germanUser = new User(
            Alias = 'standt',
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            CompanyName='LGI',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='de_DE',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey='America/New_York',
            UserName='standardusertestertest@testorg.com'
        );
        Database.insert(germanUser);

        return germanUser;
    }
	
}