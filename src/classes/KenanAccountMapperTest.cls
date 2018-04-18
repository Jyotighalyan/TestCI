/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanAccountMapper Unit Tests
*/
@isTest
private class KenanAccountMapperTest {

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
		Account a = new Account();
		a.Name = 'Sample Account';
		insert a ;

		DateTime curDateTime = Datetime.now();

		KenanAccount ka = new KenanAccount();
		ka.accountCategory = 'SME';
		ka.accountInternalId = 123456789;
		ka.accountType = 'billable';
		//ka.acctSegId = 'B';
		ka.altCompanyName = 'C';
		ka.altFname = 'D';
		ka.altLname = 'E';
		ka.billAddress1 = 'F';
		ka.billAddress2 = 'G';
		ka.billAddress3 = 'H';
		ka.billCity = 'I';
		ka.billCompany = 'J';
		ka.billCountryCode = 840;
		ka.billCounty = 'K';
		ka.billDispMeth = 'Paper';
		ka.billFmtOpt = 'Summary';
		ka.billFname = 'N';
		ka.billFranchiseTaxCode = 1;
		ka.billLname = 'O';
		ka.billMinit = 'P';
		ka.billNameGeneration = 'Q';
		ka.billNamePre = 'R';
		ka.billPeriod = 'Monthly 1st - 30 days payment term';
		ka.billState = 'T';
		ka.billTitle = 'U';
		ka.billZip = 'V';
		ka.codeword = 'W';
		ka.contact1Name = 'X';
		ka.contact1Phone = 'Y';
		ka.contact2Name = 'Z';
		ka.contact2Phone = 'AA';
		ka.currencyCode = 'KRW';
		ka.custAddress1 = 'BB';
		ka.custAddress2 = 'CC';
		ka.custAddress3 = 'DD';
		ka.custCity = 'EE';
		ka.custCountryCode = 840;
		ka.custCounty = 'FF';
		ka.custEmail = 'GG';
		ka.custFaxno = 'HH';
		ka.custPhone1 = 'II';
		ka.custPhone2 = 'JJ';
		ka.custState = 'KK';
		ka.custZip = 'LL';
		ka.dateActive = curDateTime;
		//ka.dateInactive != null) accountMap.put('dateInactive', (Datetime) ka.dateInactive);
		ka.dept = 'MM';
		ka.exrateClass = 1;
		ka.gender = 1;
		ka.mktCode = 'MASTER ACCOUNT';
		ka.parentAccountExternalId = 'OO';
		ka.parentAccountExternalIdType = 2;
		ka.rateClassDefault = 'Default product group';
		ka.rateClassSpecial = 1;
		ka.salesCode = 'QQ';
		ka.sicCode = 1;
		ka.ssn = 'RR';
		ka.statementToEmail = 'SS';
		ka.statementToFaxno = 'TT';
		ka.title = 'UU';
		ka.vipCode = 1;
	
		List<KenanAccountItem> kenanAccountItems = new List<KenanAccountItem>();
		KenanAccountItem kenanAccountItem = new KenanAccountItem();
		kenanAccountItem.itemId = 1302;
		kenanAccountItem.itemType = 1;
		kenanAccountItem.currencyCode = 'EUR';
		kenanAccountItems.add(kenanAccountItem);

		ka.accountItems = kenanAccountItems;

		Test.startTest();
		KenanAccountMapper mapper = new KenanAccountMapper();
		Map<String,Object> objectMap = mapper.getEnumeratedValues(ka);
		Test.stopTest();
		
		System.assertEquals(objectMap.get('accountCategory'), '1', '');
		System.assertEquals(objectMap.get('accountInternalId'), 123456789, '');
		System.assertEquals(objectMap.get('accountType'), '1', '');
		//System.assertEquals(objectMap.get('acctSegId'), 'B', '');
		System.assertEquals(objectMap.get('altCompanyName'), 'C', '');
		System.assertEquals(objectMap.get('altFname'), 'D', '');
		System.assertEquals(objectMap.get('altLname'), 'E', '');
		System.assertEquals(objectMap.get('billAddress1'), 'F', '');
		System.assertEquals(objectMap.get('billAddress2'), 'G', '');
		System.assertEquals(objectMap.get('billAddress3'), 'H', '');
		System.assertEquals(objectMap.get('billCity'), 'I', '');
		System.assertEquals(objectMap.get('billCompany'), 'J', '');
		System.assertEquals(objectMap.get('billCountryCode'), 840, '');
		System.assertEquals(objectMap.get('billCounty'), 'K', '');
		System.assertEquals(objectMap.get('billDispMeth'), '1', '');
		System.assertEquals(objectMap.get('billFmtOpt'), '1', '');
		System.assertEquals(objectMap.get('billFname'), 'N', '');
		System.assertEquals(objectMap.get('billFranchiseTaxCode'), 1, '');
		System.assertEquals(objectMap.get('billLname'), 'O', '');
		System.assertEquals(objectMap.get('billMinit'), 'P', '');
		System.assertEquals(objectMap.get('billNameGeneration'), 'Q', '');
		System.assertEquals(objectMap.get('billNamePre'), 'R', '');
		System.assertEquals(objectMap.get('billPeriod'), 'M01', '');
		System.assertEquals(objectMap.get('billState'), 'T', '');
		System.assertEquals(objectMap.get('billTitle'), 'U', '');
		System.assertEquals(objectMap.get('billZip'), 'V', '');
		System.assertEquals(objectMap.get('codeword'), 'W', '');
		System.assertEquals(objectMap.get('contact1Name'), 'X', '');
		System.assertEquals(objectMap.get('contact1Phone'), 'Y', '');
		System.assertEquals(objectMap.get('contact2Name'), 'Z', '');
		System.assertEquals(objectMap.get('contact2Phone'), 'AA', '');
		System.assertEquals(objectMap.get('currencyCode'), '10', '');
		System.assertEquals(objectMap.get('custAddress1'), 'BB', '');
		System.assertEquals(objectMap.get('custAddress2'), 'CC', '');
		System.assertEquals(objectMap.get('custAddress3'), 'DD', '');
		System.assertEquals(objectMap.get('custCity'), 'EE', '');
		System.assertEquals(objectMap.get('custCountryCode'), 840, '');
		System.assertEquals(objectMap.get('custCounty'), 'FF', '');
		System.assertEquals(objectMap.get('custEmail'), 'GG', '');
		System.assertEquals(objectMap.get('custFaxno'), 'HH', '');
		System.assertEquals(objectMap.get('custPhone1'), 'II', '');
		System.assertEquals(objectMap.get('custPhone2'), 'JJ', '');
		System.assertEquals(objectMap.get('custState'), 'KK', '');
		System.assertEquals(objectMap.get('custZip'), 'LL', '');
		System.assertEquals(objectMap.get('dateActive'), curDateTime, '');
		System.assertEquals(objectMap.get('dept'), 'MM', '');
		System.assertEquals(objectMap.get('exrateClass'), 1, '');
		System.assertEquals(objectMap.get('gender'), 1, '');
		System.assertEquals(objectMap.get('mktCode'), '1', '');
		System.assertEquals(objectMap.get('parentAccountExternalId'), 'OO', '');
		System.assertEquals(objectMap.get('parentAccountExternalIdType'), 2, '');
		System.assertEquals(objectMap.get('rateClassDefault'), '1', '');
		System.assertEquals(objectMap.get('rateClassSpecial'), 1, '');
		System.assertEquals(objectMap.get('salesCode'), 'QQ', '');
		System.assertEquals(objectMap.get('sicCode'), 1, '');
		System.assertEquals(objectMap.get('ssn'), 'RR', '');
		System.assertEquals(objectMap.get('statementToEmail'), 'SS', '');
		System.assertEquals(objectMap.get('statementToFaxno'), 'TT', '');
		System.assertEquals(objectMap.get('title'), 'UU', '');
		System.assertEquals(objectMap.get('vipCode'), 1, '');

		System.assertNotEquals(null, objectMap.get('accountItems'));

		List<Map<String, Object>> accountItems = (List<Map<String, Object>>) objectMap.get('accountItems');

		for (Map<String, Object> accountItemMap: accountItems) {
			System.assertEquals(1302, (Integer) accountItemMap.get('itemId'));
			System.assertEquals(1, (Integer) accountItemMap.get('itemType'));
			System.assertNotEquals('EUR', (String) accountItemMap.get('currencyCode'));
		}
		
	}	

	@isTest
	static void getDisplayValuesTest(){
		Datetime curDateTime = Datetime.now();

		Map<String,Object> objectMap = new Map<String,Object>(); 
		objectMap.put('accountCategory','1');
		objectMap.put('accountInternalId',123456789);
		objectMap.put('accountType','1');
		//objectMap.put('acctSegId','B');
		objectMap.put('altCompanyName','C');
		objectMap.put('altFname','D');
		objectMap.put('altLname','E');
		objectMap.put('billAddress1','F');
		objectMap.put('billAddress2','G');
		objectMap.put('billAddress3','H');
		objectMap.put('billCity','I');
		objectMap.put('billCompany','J');
		objectMap.put('billCountryCode',840);
		objectMap.put('billCounty','K');
		objectMap.put('billDispMeth','1');
		objectMap.put('billFmtOpt','1');
		objectMap.put('billFname','N');
		objectMap.put('billFranchiseTaxCode',1);
		objectMap.put('billLname','O');
		objectMap.put('billMinit','P');
		objectMap.put('billNameGeneration','Q');
		objectMap.put('billNamePre','R');
		objectMap.put('billPeriod','M01');
		objectMap.put('billState','T');
		objectMap.put('billTitle','U');
		objectMap.put('billZip','V');
		objectMap.put('codeword','W');
		objectMap.put('contact1Name','X');
		objectMap.put('contact1Phone','Y');
		objectMap.put('contact2Name','Z');
		objectMap.put('contact2Phone','AA');
		objectMap.put('currencyCode','10');
		objectMap.put('custAddress1','BB');
		objectMap.put('custAddress2','CC');
		objectMap.put('custAddress3','DD');
		objectMap.put('custCity','EE');
		objectMap.put('custCountryCode',840);
		objectMap.put('custCounty','FF');
		objectMap.put('custEmail','GG');
		objectMap.put('custFaxno','HH');
		objectMap.put('custPhone1','II');
		objectMap.put('custPhone2','JJ');
		objectMap.put('custState','KK');
		objectMap.put('custZip','LL');
		//objectMap.put('dateActive',curDateTime);
		objectMap.put('dept','MM');
		objectMap.put('exrateClass',1);
		objectMap.put('gender',1);
		objectMap.put('mktCode','1');
		objectMap.put('parentAccountExternalId','OO');
		objectMap.put('parentAccountExternalIdType',2);
		objectMap.put('rateClassDefault','1');
		objectMap.put('rateClassSpecial',1);
		objectMap.put('salesCode','QQ');
		objectMap.put('sicCode',1);
		objectMap.put('ssn','RR');
		objectMap.put('statementToEmail','SS');
		objectMap.put('statementToFaxno','TT');
		objectMap.put('title','UU');
		objectMap.put('vipCode',1);

		List<Object> accountItems = new List<Object>();

		for (Integer i = 0; i < 3; i++) {
			Map<String, Object> item = new Map<String, Object>();

			item.put('itemId', i);
			item.put('itemType', i);
			item.put('salesforceId', 'salesforceId' + i);

			accountItems.add(item);
		}

		objectMap.put('accountItems', accountItems);
		
		Test.startTest();
		KenanAccountMapper mapper = new KenanAccountMapper();
		KenanAccount ka = mapper.getDisplayValues(objectMap);
		Test.stopTest();
		
		System.assertEquals(ka.accountCategory, 'SME', '');
		System.assertEquals(ka.accountInternalId, 123456789, '');
		System.assertEquals(ka.accountType, 'billable', '');
		//System.assertEquals(ka.acctSegId, 'B', '');
		System.assertEquals(ka.altCompanyName, 'C', '');
		System.assertEquals(ka.altFname, 'D', '');
		System.assertEquals(ka.altLname, 'E', '');
		System.assertEquals(ka.billAddress1, 'F', '');
		System.assertEquals(ka.billAddress2, 'G', '');
		System.assertEquals(ka.billAddress3, 'H', '');
		System.assertEquals(ka.billCity, 'I', '');
		System.assertEquals(ka.billCompany, 'J', '');
		System.assertEquals(ka.billCountryCode, 840, '');
		System.assertEquals(ka.billCounty, 'K', '');
		System.assertEquals(ka.billDispMeth, 'Paper', '');
		System.assertEquals(ka.billFmtOpt, 'Summary', '');
		System.assertEquals(ka.billFname, 'N', '');
		System.assertEquals(ka.billFranchiseTaxCode, 1, '');
		System.assertEquals(ka.billLname, 'O', '');
		System.assertEquals(ka.billMinit, 'P', '');
		System.assertEquals(ka.billNameGeneration, 'Q', '');
		System.assertEquals(ka.billNamePre, 'R', '');
		System.assertEquals(ka.billPeriod, 'Monthly 1st - 30 days payment term', '');
		System.assertEquals(ka.billState, 'T', '');
		System.assertEquals(ka.billTitle, 'U', '');
		System.assertEquals(ka.billZip, 'V', '');
		System.assertEquals(ka.codeword, 'W', '');
		System.assertEquals(ka.contact1Name, 'X', '');
		System.assertEquals(ka.contact1Phone, 'Y', '');
		System.assertEquals(ka.contact2Name, 'Z', '');
		System.assertEquals(ka.contact2Phone, 'AA', '');
		System.assertEquals(ka.currencyCode, 'KRW', '');
		System.assertEquals(ka.custAddress1, 'BB', '');
		System.assertEquals(ka.custAddress2, 'CC', '');
		System.assertEquals(ka.custAddress3, 'DD', '');
		System.assertEquals(ka.custCity, 'EE', '');
		System.assertEquals(ka.custCountryCode, 840, '');
		System.assertEquals(ka.custCounty, 'FF', '');
		System.assertEquals(ka.custEmail, 'GG', '');
		System.assertEquals(ka.custFaxno, 'HH', '');
		System.assertEquals(ka.custPhone1, 'II', '');
		System.assertEquals(ka.custPhone2, 'JJ', '');
		System.assertEquals(ka.custState, 'KK', '');
		System.assertEquals(ka.custZip, 'LL', '');
		//System.assertEquals(ka.dateActive, curDateTime, '');
		//System.assertEquals(ka.dateInactive != null) accountMap.put('dateInactive', (Datetime) System.assertEquals(ka.dateInactive), '');
		System.assertEquals(ka.dept, 'MM', '');
		System.assertEquals(ka.exrateClass, 1, '');
		System.assertEquals(ka.gender, 1, '');
		System.assertEquals(ka.mktCode, 'MASTER ACCOUNT', '');
		System.assertEquals(ka.parentAccountExternalId, 'OO', '');
		System.assertEquals(ka.parentAccountExternalIdType, 2, '');
		System.assertEquals(ka.rateClassDefault, 'Default product group', '');
		System.assertEquals(ka.rateClassSpecial, 1, '');
		System.assertEquals(ka.salesCode, 'QQ', '');
		System.assertEquals(ka.sicCode, 1, '');
		System.assertEquals(ka.ssn, 'RR', '');
		System.assertEquals(ka.statementToEmail, 'SS', '');
		System.assertEquals(ka.statementToFaxno, 'TT', '');
		System.assertEquals(ka.title, 'UU', '');
		System.assertEquals(ka.vipCode, 1, '');
		System.assert(!ka.accountItems.isEmpty());
	}
}