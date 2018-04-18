/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Unit Test for use in Salesforce Kenan Connection Service
*/
@isTest
private class KenanAddressMapperTest {
	
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
	static void getEnumeratedValuesTest() {
		KenanAddress address = new KenanAddress();
		       
        address.serviceExternalId = 'serviceExternalId';
        address.cAddress1 = '123 Test St.';
        address.cAddress2 = '';
        address.cAddress3 = '';
        address.cAddress4 = '';
        address.cAddressTypeId = 'Not Free-form';
        address.cChangeDt = Datetime.newInstance(2016, 7, 6, 0, 0, 0);
        address.cChangeWho = 'testPerson';
        address.cCity = 'Testville';
        address.cCountryCode = 'Reserved - No Country';
        address.cCounty = '';
        address.cExtendedPostalCode = '2222';
        address.cExternalAddressId = '';
        address.cFranchiseTaxCode = 1;
        address.cFxGeocode = '';
        address.cHouseNumber = '123';
        address.cHouseNumberSuffix = '';
        address.cIsActive = true;
        address.cKey = new Map<String, Object>{
        	'AddressId' => 1,
        	'addressId' => 0,
        	'setAddressId' => true
        };

        address.cKeyLineCode = '';
        address.cNearestCrossStreet = '';
        address.cOptionalEndorsementLine = '';
        address.cPostalCode = '11111';
        address.cPostfixDirectional = '';
        address.cPostnetAddressBlockBarcode = '';
        address.cPostnetBarcode = '';
        address.cPrefixDirectional = '';
        address.cState = 'TX';
        address.cStreetName = 'Test';
        address.cStreetSuffix = 'St.';
        address.cUnitNo = '';
        address.cUnitType = '';
        address.cVertexGeocode = '';
        address.address1 = '';
        address.address2 = '';
        address.address3 = '';
        address.address4 = '';
        address.addressTypeId = 'Not Free-form';
        address.changeDt = Datetime.newInstance(2016, 7, 6, 0, 0, 0).format('yyyy-mm-dd\'T\'HH:mm:ss');
        address.changeWho = 'testPerson';
        address.city = 'Testville';
        address.countryCode = 'Reserved - No Country';
        address.county = '';
        address.extendedPostalCode = '2222';
        address.externalAddressId = '';
        address.franchiseTaxCode = 1;
        address.fxGeocode = '';
        address.houseNumber = '123';
        address.houseNumberSuffix = '';
        address.isActive = true;
        address.key = new Map<String, Object>{
        	'AddressId' => 1,
        	'addressId' => 0,
        	'setAddressId' => true
        };

        address.keyLineCode = '';
        address.nearestCrossStreet = '';
        address.optionalEndorsementLine = '';
        address.postalCode = '11111';
        address.postfixDirectional = '';
        address.postnetAddressBlockBarcode = '';
        address.postnetBarcode = '';
        address.prefixDirectional = '';
        address.setAddress1 = true;
        address.setAddress2 = true;
        address.setAddress3 = true;
        address.setAddress4 = true;
        address.setAddressTypeId = true;
        address.setChangeDt = true;
        address.setChangeWho = true;
        address.setCity = true;
        address.setCountryCode = true;
        address.setCounty = true;
        address.setExtendedPostalCode = true;
        address.setExternalAddressId = true;
        address.setFranchiseTaxCode = true;
        address.setFxGeocode = true;
        address.setHouseNumber = true;
        address.setHouseNumberSuffix = true;
        address.setIsActive = true;
        address.setKeyLineCode = true;
        address.setNearestCrossstreet = true;
        address.setOptionalEndorsementLine = true;
        address.setPostalCode = true;
        address.setPostfixDirectional = true;
        address.setPostnetAddressBlockBarcode = true;
        address.setPostnetBarcode = true;
        address.setPrefixDirectional = true;
        address.setState = true;
        address.setStreetName = true;
        address.setStreetSuffix = true;
        address.setUnitNo = true;
        address.setUnitType = true;
        address.setVertexGeocode = true;
        address.state = 'TX';
        address.streetName = 'Test';
        address.streetSuffix = 'St.';
        address.unitNo = '';
        address.unitType = '';
        address.vertexGeocode = '';
        
        Test.startTest();
		KenanAddressMapper mapper = new KenanAddressMapper();
		Map<String,Object> objectMap = mapper.getEnumeratedValues(address);
		Test.stopTest();
				
		System.assertEquals(objectMap.get('Address1'), address.cAddress1);
		System.assertEquals(objectMap.get('Address2'), address.cAddress2);
		System.assertEquals(objectMap.get('Address3'), address.cAddress3);
		System.assertEquals(objectMap.get('Address4'), address.cAddress4);
		System.assertEquals(objectMap.get('AddressTypeId'), '1');
		System.assertEquals(objectMap.get('ChangeDt'), address.cChangeDt);
		System.assertEquals(objectMap.get('ChangeWho'), address.cChangeWho);
		System.assertEquals(objectMap.get('City'), address.cCity);
		System.assertEquals(objectMap.get('CountryCode'), '0');
		System.assertEquals(objectMap.get('County'), address.cCounty);
		System.assertEquals(objectMap.get('ExtendedPostalCode'), address.cExtendedPostalCode);
		System.assertEquals(objectMap.get('ExternalAddressId'), address.cExternalAddressId);
		System.assertEquals(objectMap.get('FranchiseTaxCode'), address.cFranchiseTaxCode);
		System.assertEquals(objectMap.get('FxGeocode'), address.cFxGeocode);
		System.assertEquals(objectMap.get('HouseNumber'), address.cHouseNumber);
		System.assertEquals(objectMap.get('HouseNumberSuffix'), address.cHouseNumberSuffix);
		System.assertEquals(objectMap.get('IsActive'), address.cIsActive);
		System.assertEquals(objectMap.get('Key'), address.cKey);
		System.assertEquals(objectMap.get('KeyLineCode'), address.cKeyLineCode);
		System.assertEquals(objectMap.get('NearestCrossstreet'), address.cNearestCrossstreet);
		System.assertEquals(objectMap.get('OptionalEndorsementLine'), address.cOptionalEndorsementLine);
		System.assertEquals(objectMap.get('PostalCode'), address.cPostalCode);
		System.assertEquals(objectMap.get('PostfixDirectional'), address.cPostfixDirectional);
		System.assertEquals(objectMap.get('PostnetAddressBlockBarcode'), address.cPostnetAddressBlockBarcode);
		System.assertEquals(objectMap.get('PostnetBarcode'), address.cPostnetBarcode);
		System.assertEquals(objectMap.get('PrefixDirectional'), address.cPrefixDirectional);
		System.assertEquals(objectMap.get('State'), address.cState);
		System.assertEquals(objectMap.get('StreetName'), address.cStreetName);
		System.assertEquals(objectMap.get('StreetSuffix'), address.cStreetSuffix);
		System.assertEquals(objectMap.get('UnitNo'), address.cUnitNo);
		System.assertEquals(objectMap.get('UnitType'), address.cUnitType);
		System.assertEquals(objectMap.get('VertexGeocode'), address.cVertexGeocode);
		System.assertEquals(objectMap.get('address1'), address.address1);
		System.assertEquals(objectMap.get('address2'), address.address2);
		System.assertEquals(objectMap.get('address3'), address.address3);
		System.assertEquals(objectMap.get('address4'), address.address4);
		System.assertEquals(objectMap.get('addressTypeId'), '1');
		System.assertEquals(objectMap.get('changeDt'), address.changeDt);
		System.assertEquals(objectMap.get('changeWho'), address.changeWho);
		System.assertEquals(objectMap.get('city'), address.city);
		System.assertEquals(objectMap.get('countryCode'), '0');
		System.assertEquals(objectMap.get('county'), address.county);
		System.assertEquals(objectMap.get('extendedPostalCode'), address.extendedPostalCode);
		System.assertEquals(objectMap.get('externalAddressId'), address.externalAddressId);
		System.assertEquals(objectMap.get('franchiseTaxCode'), address.franchiseTaxCode);
		System.assertEquals(objectMap.get('fxGeocode'), address.fxGeocode);
		System.assertEquals(objectMap.get('houseNumber'), address.houseNumber);
		System.assertEquals(objectMap.get('houseNumberSuffix'), address.houseNumberSuffix);
		System.assertEquals(objectMap.get('isActive'), address.isActive);
		System.assertEquals(objectMap.get('key'), address.key);
		System.assertEquals(objectMap.get('keyLineCode'), address.keyLineCode);
		System.assertEquals(objectMap.get('nearestCrossstreet'), address.nearestCrossstreet);
		System.assertEquals(objectMap.get('optionalEndorsementLine'), address.optionalEndorsementLine);
		System.assertEquals(objectMap.get('postalCode'), address.postalCode);
		System.assertEquals(objectMap.get('postfixDirectional'), address.postfixDirectional);
		System.assertEquals(objectMap.get('postnetAddressBlockBarcode'), address.postnetAddressBlockBarcode);
		System.assertEquals(objectMap.get('postnetBarcode'), address.postnetBarcode);
		System.assertEquals(objectMap.get('prefixDirectional'), address.prefixDirectional);

		System.assert((Boolean)objectMap.get('setAddress1'));
		System.assert((Boolean)objectMap.get('setAddress2'));
		System.assert((Boolean)objectMap.get('setAddress3'));
		System.assert((Boolean)objectMap.get('setAddress4'));
		System.assert((Boolean)objectMap.get('setAddressTypeId'));
		System.assert((Boolean)objectMap.get('setChangeDt'));
		System.assert((Boolean)objectMap.get('setChangeWho'));
		System.assert((Boolean)objectMap.get('setCity'));
		System.assert((Boolean)objectMap.get('setCountryCode'));
		System.assert((Boolean)objectMap.get('setCounty'));
		System.assert((Boolean)objectMap.get('setExtendedPostalCode'));
		System.assert((Boolean)objectMap.get('setExternalAddressId'));
		System.assert((Boolean)objectMap.get('setFranchiseTaxCode'));
		System.assert((Boolean)objectMap.get('setFxGeocode'));
		System.assert((Boolean)objectMap.get('setHouseNumber'));
		System.assert((Boolean)objectMap.get('setHouseNumberSuffix'));
		System.assert((Boolean)objectMap.get('setIsActive'));
		System.assert((Boolean)objectMap.get('setKeyLineCode'));
		System.assert((Boolean)objectMap.get('setNearestCrossstreet'));
		System.assert((Boolean)objectMap.get('setOptionalEndorsementLine'));
		System.assert((Boolean)objectMap.get('setPostalCode'));
		System.assert((Boolean)objectMap.get('setPostfixDirectional'));
		System.assert((Boolean)objectMap.get('setPostnetAddressBlockBarcode'));
		System.assert((Boolean)objectMap.get('setPostnetBarcode'));
		System.assert((Boolean)objectMap.get('setPrefixDirectional'));
		System.assert((Boolean)objectMap.get('setState'));
		System.assert((Boolean)objectMap.get('setStreetName'));
		System.assert((Boolean)objectMap.get('setStreetSuffix'));
		System.assert((Boolean)objectMap.get('setUnitNo'));
		System.assert((Boolean)objectMap.get('setUnitType'));
		System.assert((Boolean)objectMap.get('setVertexGeocode'));

		System.assertEquals(objectMap.get('state'), address.state);
		System.assertEquals(objectMap.get('streetName'), address.streetName);
		System.assertEquals(objectMap.get('streetSuffix'), address.streetSuffix);
		System.assertEquals(objectMap.get('unitNo'), address.unitNo);
		System.assertEquals(objectMap.get('unitType'), address.unitType);
		System.assertEquals(objectMap.get('vertexGeocode'), address.vertexGeocode);
	}

	@isTest
	static void getDisplayValuesTest() {
		Map<String, Object> objectMap = new Map<String, Object>();
        
        Map<String, Object> keys = new Map<String, Object>{
        	'AddressId' => 0,
        	'addressId' => 0,
        	'setAddressId' => true
        };

		objectMap.put('Address1', 'Address1');
		objectMap.put('Address2', 'Address2');
		objectMap.put('Address3', 'Address3');
		objectMap.put('Address4', 'Address4');
		objectMap.put('AddressTypeId', '1');
		objectMap.put('ChangeDt', Datetime.newInstance(2016, 7, 6, 0, 0, 0));
		objectMap.put('ChangeWho', 'ChangeWho');
		objectMap.put('City', 'City');
		objectMap.put('CountryCode', '0');
		objectMap.put('County', 'County');
		objectMap.put('ExtendedPostalCode', 'ExtendedPostalCode');
		objectMap.put('ExternalAddressId', 'ExternalAddressId');
		objectMap.put('FranchiseTaxCode', 1);
		objectMap.put('FxGeocode', 'FxGeocode');
		objectMap.put('HouseNumber', 'HouseNumber');
		objectMap.put('HouseNumberSuffix', 'HouseNumberSuffix');
		objectMap.put('IsActive', true);
		objectMap.put('Key', keys);
		objectMap.put('KeyLineCode', 'KeyLineCode');
		objectMap.put('NearestCrossstreet', 'NearestCrossstreet');
		objectMap.put('OptionalEndorsementLine', 'OptionalEndorsementLine');
		objectMap.put('PostalCode', 'PostalCode');
		objectMap.put('PostfixDirectional', 'PostfixDirectional');
		objectMap.put('PostnetAddressBlockBarcode', 'PostnetAddressBlockBarcode');
		objectMap.put('PostnetBarcode', 'PostnetBarcode');
		objectMap.put('PrefixDirectional', 'PrefixDirectional');
		objectMap.put('State', 'State');
		objectMap.put('StreetName', 'StreetName');
		objectMap.put('StreetSuffix', 'StreetSuffix');
		objectMap.put('UnitNo', 'UnitNo');
		objectMap.put('UnitType', 'UnitType');
		objectMap.put('VertexGeocode', 'VertexGeocode');
        objectMap.put('address1', 'address1'); 
        objectMap.put('address2', 'address2');
        objectMap.put('address3', 'address3');
        objectMap.put('address4', 'address4');
        objectMap.put('addressTypeId', '1');
		objectMap.put('changeDt', 'changeDt');
		objectMap.put('changeWho', 'changeWho');
		objectMap.put('city', 'city');
		objectMap.put('countryCode', '0');
		objectMap.put('county', 'county');
		objectMap.put('extendedPostalCode', 'extendedPostalCode');
		objectMap.put('externalAddressId', 'externalAddressId');
		objectMap.put('franchiseTaxCode', 1);
		objectMap.put('fxGeocode', 'fxGeocode');
		objectMap.put('houseNumber', 'houseNumber');
		objectMap.put('houseNumberSuffix', 'houseNumberSuffix');
		objectMap.put('isActive', true);
		objectMap.put('key', keys);
		objectMap.put('keyLineCode', 'keyLineCode');
		objectMap.put('nearestCrossstreet', 'nearestCrossstreet');
		objectMap.put('optionalEndorsementLine', 'optionalEndorsementLine');
		objectMap.put('postalCode', 'postalCode');
		objectMap.put('postfixDirectional', 'postfixDirectional');
		objectMap.put('postnetAddressBlockBarcode', 'postnetAddressBlockBarcode');
		objectMap.put('postnetBarcode', 'postnetBarcode');
		objectMap.put('prefixDirectional', 'prefixDirectional');
		objectMap.put('setAddress1', true); 
        objectMap.put('setAddress2', true); 
        objectMap.put('setAddress3', true); 
        objectMap.put('setAddress4', true); 
        objectMap.put('setAddressTypeId', true); 
        objectMap.put('setChangeDt', true); 
        objectMap.put('setChangeWho', true);
        objectMap.put('setCity', true);
        objectMap.put('setCountryCode', true);
        objectMap.put('setCounty', true);
        objectMap.put('setExtendedPostalCode', true);
        objectMap.put('setExternalAddressId', true);
        objectMap.put('setFranchiseTaxCode', true);
        objectMap.put('setFxGeocode', true);
        objectMap.put('setHouseNumber', true);
        objectMap.put('setHouseNumberSuffix', true);
        objectMap.put('setIsActive', true);
        objectMap.put('setKeyLineCode', true);
        objectMap.put('setNearestCrossstreet', true);
        objectMap.put('setOptionalEndorsementLine', true);
        objectMap.put('setPostalCode', true);
        objectMap.put('setPostfixDirectional', true);
        objectMap.put('setPostnetAddressBlockBarcode', true);
        objectMap.put('setPostnetBarcode', true);
        objectMap.put('setPrefixDirectional', true);
        objectMap.put('setState', true);
        objectMap.put('setStreetName', true);
        objectMap.put('setStreetSuffix', true);
        objectMap.put('setUnitNo', true);
        objectMap.put('setUnitType', true);
        objectMap.put('setVertexGeocode', true);
		objectMap.put('state', 'state');
		objectMap.put('streetName', 'streetName');
		objectMap.put('streetSuffix', 'streetSuffix');
		objectMap.put('unitNo', 'unitNo');
		objectMap.put('unitType', 'unitType');
		objectMap.put('vertexGeocode', 'vertexGeocode');

        Test.startTest();
        KenanAddressMapper mapper = new KenanAddressMapper();
        KenanAddress address = mapper.getDisplayValues(objectMap);
        Test.stopTest();

        System.assertEquals(address.cAddress1, 'Address1');
		System.assertEquals(address.cAddress2, 'Address2');
		System.assertEquals(address.cAddress3, 'Address3');
		System.assertEquals(address.cAddress4, 'Address4');
		System.assertEquals(address.cAddressTypeId, '1');
		System.assertEquals(address.cChangeDt, Datetime.newInstance(2016, 7, 6, 0, 0, 0));
		System.assertEquals(address.cChangeWho, 'ChangeWho');
		System.assertEquals(address.cCity, 'City');
		System.assertEquals(address.cCountryCode, '0');
		System.assertEquals(address.cCounty, 'County');
		System.assertEquals(address.cExtendedPostalCode, 'ExtendedPostalCode');
		System.assertEquals(address.cExternalAddressId, 'ExternalAddressId');
		System.assertEquals(address.cFranchiseTaxCode, 1);
		System.assertEquals(address.cFxGeocode, 'FxGeocode');
		System.assertEquals(address.cHouseNumber, 'HouseNumber');
		System.assertEquals(address.cHouseNumberSuffix, 'HouseNumberSuffix');
		System.assertEquals(address.cIsActive, true);
		System.assertEquals(address.cKey, keys);
		System.assertEquals(address.cKeyLineCode, 'KeyLineCode');
		System.assertEquals(address.cNearestCrossstreet, 'NearestCrossstreet');
		System.assertEquals(address.cOptionalEndorsementLine, 'OptionalEndorsementLine');
		System.assertEquals(address.cPostalCode, 'PostalCode');
		System.assertEquals(address.cPostfixDirectional, 'PostfixDirectional');
		System.assertEquals(address.cPostnetAddressBlockBarcode, 'PostnetAddressBlockBarcode');
		System.assertEquals(address.cPostnetBarcode, 'PostnetBarcode');
		System.assertEquals(address.cPrefixDirectional, 'PrefixDirectional');
		System.assertEquals(address.cState, 'State');
		System.assertEquals(address.cStreetName, 'StreetName');
		System.assertEquals(address.cStreetSuffix, 'StreetSuffix');
		System.assertEquals(address.cUnitNo, 'UnitNo');
		System.assertEquals(address.cUnitType, 'UnitType');
		System.assertEquals(address.cVertexGeocode, 'VertexGeocode');
		System.assertEquals(address.address1, 'address1');
		System.assertEquals(address.address2, 'address2');
		System.assertEquals(address.address3, 'address3');
		System.assertEquals(address.address4, 'address4');
		System.assertEquals(address.addressTypeId, '1');
		System.assertEquals(address.changeDt, 'changeDt');
		System.assertEquals(address.changeWho, 'changeWho');
		System.assertEquals(address.city, 'city');
		System.assertEquals(address.countryCode, '0');
		System.assertEquals(address.county, 'county');
		System.assertEquals(address.extendedPostalCode, 'extendedPostalCode');
		System.assertEquals(address.externalAddressId, 'externalAddressId');
		System.assertEquals(address.franchiseTaxCode, 1);
		System.assertEquals(address.fxGeocode, 'fxGeocode');
		System.assertEquals(address.houseNumber, 'houseNumber');
		System.assertEquals(address.houseNumberSuffix, 'houseNumberSuffix');
		System.assertEquals(address.isActive, true);
		System.assertEquals(address.key, keys);
		System.assertEquals(address.keyLineCode, 'keyLineCode');
		System.assertEquals(address.nearestCrossstreet, 'nearestCrossstreet');
		System.assertEquals(address.optionalEndorsementLine, 'optionalEndorsementLine');
		System.assertEquals(address.postalCode, 'postalCode');
		System.assertEquals(address.postfixDirectional, 'postfixDirectional');
		System.assertEquals(address.postnetAddressBlockBarcode, 'postnetAddressBlockBarcode');
		System.assertEquals(address.postnetBarcode, 'postnetBarcode');
		System.assertEquals(address.prefixDirectional, 'prefixDirectional');

		System.assert(address.setAddress1);
		System.assert(address.setAddress2);
		System.assert(address.setAddress3);
		System.assert(address.setAddress4);
		System.assert(address.setAddressTypeId);
		System.assert(address.setChangeDt);
		System.assert(address.setChangeWho);
		System.assert(address.setCity);
		System.assert(address.setCountryCode);
		System.assert(address.setCounty);
		System.assert(address.setExtendedPostalCode);
		System.assert(address.setExternalAddressId);
		System.assert(address.setFranchiseTaxCode);
		System.assert(address.setFxGeocode);
		System.assert(address.setHouseNumber);
		System.assert(address.setHouseNumberSuffix);
		System.assert(address.setIsActive);
		System.assert(address.setKeyLineCode);
		System.assert(address.setNearestCrossstreet);
		System.assert(address.setOptionalEndorsementLine);
		System.assert(address.setPostalCode);
		System.assert(address.setPostfixDirectional);
		System.assert(address.setPostnetAddressBlockBarcode);
		System.assert(address.setPostnetBarcode);
		System.assert(address.setPrefixDirectional);
		System.assert(address.setState);
		System.assert(address.setStreetName);
		System.assert(address.setStreetSuffix);
		System.assert(address.setUnitNo);
		System.assert(address.setUnitType);
		System.assert(address.setVertexGeocode);

		System.assertEquals(address.state, 'state');
		System.assertEquals(address.streetName, 'streetName');
		System.assertEquals(address.streetSuffix, 'streetSuffix');
		System.assertEquals(address.unitNo, 'unitNo');
		System.assertEquals(address.unitType, 'unitType');
		System.assertEquals(address.vertexGeocode, 'vertexGeocode');
	}
}