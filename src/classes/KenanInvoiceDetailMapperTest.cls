/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanInvoiceDetailMapper Unit Tests
*/

@isTest
private class KenanInvoiceDetailMapperTest {
	
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
	static void KenanInvoiceDetailMapperTest() {
		
		Test.startTest();
		KenanInvoiceDetailMapper mapper = new KenanInvoiceDetailMapper();
		Test.stopTest();
		System.assertNotEquals(null, mapper);

	}
	
	@isTest
	static void getEnumeratedValuesTest() {
		KenanService service = new KenanService();
		Test.startTest();
		try {
			KenanInvoiceDetailMapper mapper = new KenanInvoiceDetailMapper();
			mapper.getEnumeratedValues(service);
		} 
		catch (KenanException ke){
				system.assertEquals(ke.errorName, 'getEnumeratedValues Method has not been implemented');
        		system.assertEquals(ke.errorMessage, 'getEnumeratedValues Method has not been implemented');
		}
		Test.stopTest();
	}

	@isTest
	static void getDisplayValuesTest() {
		List<Map<String, Object>> rows = new List<Map<String, Object>>();
		Test.startTest();
		try {
			KenanInvoiceDetailMapper mapper = new KenanInvoiceDetailMapper();
			mapper.getDisplayValues(rows);
		} 
		catch (KenanException ke){
				system.assertEquals(ke.errorName, 'getDisplayValues Method has not been implemented');
        		system.assertEquals(ke.errorMessage, 'getDisplayValues Method has not been implemented');
		}
		Test.stopTest();
	}

	@isTest
	static void getDisplayValuesRowTest() {
		Map<String, Object> row = new Map<String, Object>();
		Test.startTest();
		try {
			KenanInvoiceDetailMapper mapper = new KenanInvoiceDetailMapper();
			mapper.getDisplayValues(row);
		} 
		catch (KenanException ke){
				system.assertEquals(ke.errorName, 'getDisplayValues Method has not been implemented');
        		system.assertEquals(ke.errorMessage, 'getDisplayValues Method has not been implemented');
		}
		Test.stopTest();
	}

	@isTest
	static void getEnumeratedValuesMapTest() {
		List<Map<String, Object>> rows = new List<Map<String, Object>>();
		Map<String, Object> row = new Map<String, Object>();
		Datetime curDatetime = Datetime.now();

		row.put('billClass', '1'); //1
		row.put('ratePeriod', 'Christmas');	//67
		row.put('zoneClass', 'No Value'); // No Value
		row.put('currencyCode', 'KRW');
		row.put('amount', 100); 
        row.put('federalTax', 200);
        row.put('countyTax', 300);
        row.put('cityTax', 400);
        row.put('otherTax', 500);
        row.put('ratedAmount', 600);
        rows.add(row);
		Test.startTest();
		KenanInvoiceDetailMapper mapper = new KenanInvoiceDetailMapper();
		mapper.getEnumeratedValues(rows);
		Test.stopTest();
		system.assertEquals(row.get('billClass'), '1');
		system.assertEquals(row.get('ratePeriod'), '67');
		//system.assertEquals(row.get('zoneClass'), 0);

		system.assertEquals(row.get('amount'), 10000); 
        system.assertEquals(row.get('federalTax'), 20000);
        system.assertEquals(row.get('countyTax'), 30000);
        system.assertEquals(row.get('cityTax'), 40000);
        system.assertEquals(row.get('otherTax'), 50000);
        system.assertEquals(row.get('ratedAmount'), 60000);
	}

	@isTest
	static void getEnumeratedValuesMapTestsubType7() {
		List<Map<String, Object>> rows = new List<Map<String, Object>>();
		Map<String, Object> row = new Map<String, Object>();
		Datetime curDatetime = Datetime.now();

		row.put('billClass', '1'); //1
		row.put('ratePeriod', 'Christmas');	//67
		//row.put('zoneClass', 'No Value'); // No Value
		row.put('typeCode', 'Usage Charge');
		row.put('subtypeCode', 7);
		row.put('currencyCode', 'KRW');
		row.put('amount', 100); 
        row.put('federalTax', 200);
        row.put('countyTax', 300);
        row.put('cityTax', 400);
        row.put('otherTax', 500);
        row.put('ratedAmount', 600);
        rows.add(row);
		Test.startTest();
		KenanInvoiceDetailMapper mapper = new KenanInvoiceDetailMapper();
		mapper.getEnumeratedValues(rows);
		Test.stopTest();
		system.assertEquals(row.get('billClass'), '1');
		system.assertEquals(row.get('ratePeriod'), '67');
		//system.assertEquals(row.get('zoneClass'), 0);

		system.assertEquals(row.get('amount'), 10000); 
        system.assertEquals(row.get('federalTax'), 20000);
        system.assertEquals(row.get('countyTax'), 30000);
        system.assertEquals(row.get('cityTax'), 40000);
        system.assertEquals(row.get('otherTax'), 50000);
        system.assertEquals(row.get('ratedAmount'), 60000);
        system.assertEquals(row.get('typeCode'), '7');
	}

	@isTest
	static void getDisplayValuesMapTest() {
		List<Map<String, Object>> rows = new List<Map<String, Object>>();
		Map<String, Object> row = new Map<String, Object>();
		Datetime curDatetime = Datetime.now();

		row.put('billClass', '1'); //1
		row.put('ratePeriod', '67');	//67
		//row.put('zoneClass', 'No Value'); // No Value
		row.put('typeCode', '7');
		row.put('subtypeCode', 7);
		row.put('currencyCode', '10');
		row.put('fromDate', curDatetime);
		row.put('pcmActiveDt', curDatetime);
		row.put('statementDate', curDatetime);
		row.put('toDate', curDatetime);
		row.put('transDate', curDatetime);

		row.put('amount', '10000'); 
        row.put('federalTax', '20000');
        row.put('countyTax', '30000');
        row.put('cityTax', '40000');
        row.put('otherTax', '50000');
        row.put('ratedAmount', '60000');
		rows.add(row);
		Test.startTest();
		KenanInvoiceDetailMapper mapper = new KenanInvoiceDetailMapper();
		mapper.getDisplayValues(rows);
		Test.stopTest();
		system.assertEquals(row.get('billClass'), '1');
		system.assertEquals(row.get('ratePeriod'), 'Christmas');
		system.assertEquals(row.get('zoneClass'), null);

		system.assertEquals(row.get('fromDate'), curDatetime);
		system.assertEquals(row.get('pcmActiveDt'), curDatetime);
		system.assertEquals(row.get('statementDate'), curDatetime);
		system.assertEquals(row.get('toDate'), curDatetime);
		system.assertEquals(row.get('transDate'), curDatetime);

		system.assertEquals(row.get('amount'), 100); 
        system.assertEquals(row.get('federalTax'), 200);
        system.assertEquals(row.get('countyTax'), 300);
        system.assertEquals(row.get('cityTax'), 400);
        system.assertEquals(row.get('otherTax'), 500);
        system.assertEquals(row.get('ratedAmount'), 600);

        system.assertEquals(row.get('typeCode'), 'Usage Charge');
	}
}