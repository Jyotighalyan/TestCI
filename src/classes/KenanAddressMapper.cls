/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanAddressMapper for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanAddressMapper implements KenanObjectMapper {
	
	private KenanServiceConnection__c kenanSettings;

	public KenanAddressMapper() {
		kenanSettings = KenanServiceConnection__c.getInstance();
	}

	public Map<String,Object> getEnumeratedValues(KenanObject kObject){
		KenanAddress item = (KenanAddress) kObject;

		Map<String, Object> itemMap = new Map<String, Object>();

		if (item.cAddress1 != null) itemMap.put('Address1', item.cAddress1);
		if (item.cAddress2 != null) itemMap.put('Address2', item.cAddress2);
		if (item.cAddress3 != null) itemMap.put('Address3', item.cAddress3);
		if (item.cAddress4 != null) itemMap.put('Address4', item.cAddress4);
		if (item.cAddressTypeId != null) itemMap.put('AddressTypeId', item.cAddressTypeId);
		if (item.cChangeDt != null) itemMap.put('ChangeDt', item.cChangeDt);
		if (item.cChangeWho != null) itemMap.put('ChangeWho', item.cChangeWho);
		if (item.cCity != null) itemMap.put('City', item.cCity);
		if (item.cCountryCode != null) itemMap.put('CountryCode', item.cCountryCode);
		if (item.cCounty != null) itemMap.put('County', item.cCounty);
		if (item.cExtendedPostalCode != null) itemMap.put('ExtendedPostalCode', item.cExtendedPostalCode);
		if (item.cExternalAddressId != null) itemMap.put('ExternalAddressId', item.cExternalAddressId);
		if (item.cFranchiseTaxCode != null) itemMap.put('FranchiseTaxCode', item.cFranchiseTaxCode);
		if (item.cFxGeocode != null) itemMap.put('FxGeocode', item.cFxGeocode);
		if (item.cHouseNumber != null) itemMap.put('HouseNumber', item.cHouseNumber);
  		if (item.cHouseNumberSuffix != null) itemMap.put('HouseNumberSuffix', item.cHouseNumberSuffix);
  		if (item.cIsActive != null) itemMap.put('IsActive', (Boolean) item.cIsActive);
		if (item.cKey != null){
			itemMap.put('Key', (Map<String, Object>) item.cKey);
		} 

		if (item.cKeyLineCode != null) itemMap.put('KeyLineCode', item.cKeyLineCode);
		if (item.cNearestCrossStreet != null) itemMap.put('NearestCrossstreet', item.cNearestCrossStreet);
		if (item.cOptionalEndorsementLine != null) itemMap.put('OptionalEndorsementLine', item.cOptionalEndorsementLine);
		if (item.cPostalCode != null) itemMap.put('PostalCode', item.cPostalCode);
		if (item.cPostfixDirectional != null) itemMap.put('PostfixDirectional', item.cPostfixDirectional);
		if (item.cPostnetAddressBlockBarcode != null) itemMap.put('PostnetAddressBlockBarcode', item.cPostnetAddressBlockBarcode);
		if (item.cPostnetBarcode != null) itemMap.put('PostnetBarcode', item.cPostnetBarcode);
		if (item.cPrefixDirectional != null) itemMap.put('PrefixDirectional', item.cPrefixDirectional);
		if (item.cState != null) itemMap.put('State', item.cState);
		if (item.cStreetName != null) itemMap.put('StreetName', item.cStreetName);
		if (item.cStreetSuffix != null) itemMap.put('StreetSuffix', item.cStreetSuffix);
		if (item.cUnitNo != null) itemMap.put('UnitNo', item.cUnitNo);
		if (item.cUnitType != null) itemMap.put('UnitType', item.cUnitType);
		if (item.cVertexGeocode != null) itemMap.put('VertexGeocode', item.cVertexGeocode);

		if (item.address1 != null) itemMap.put('address1', item.address1);
		if (item.address2 != null) itemMap.put('address2', item.address2);
		if (item.address3 != null) itemMap.put('address3', item.address3);
		if (item.address4 != null) itemMap.put('address4', item.address4);
		if (item.addressTypeId != null) itemMap.put('addressTypeId', item.addressTypeId);
		if (item.changeDt != null) itemMap.put('changeDt', item.changeDt);
		if (item.changeWho != null) itemMap.put('changeWho', item.changeWho);
		if (item.city != null) itemMap.put('city', item.city);
		if (item.countryCode != null) itemMap.put('countryCode', item.countryCode);
		if (item.county != null) itemMap.put('county', item.county);
		if (item.extendedPostalCode != null) itemMap.put('extendedPostalCode', item.extendedPostalCode);
		if (item.externalAddressId != null) itemMap.put('externalAddressId', item.externalAddressId);
		if (item.franchiseTaxCode != null) itemMap.put('franchiseTaxCode', item.franchiseTaxCode);
		if (item.fxGeocode != null) itemMap.put('fxGeocode', item.fxGeocode);
		if (item.houseNumber != null) itemMap.put('houseNumber', item.houseNumber);
  		if (item.houseNumberSuffix != null) itemMap.put('houseNumberSuffix', item.houseNumberSuffix);
  		if (item.isActive != null) itemMap.put('isActive', (Boolean) item.isActive);
		if (item.key != null){
			itemMap.put('key', (Map<String, Object>) item.key);
		} 

		if (item.keyLineCode != null) itemMap.put('keyLineCode', item.keyLineCode);
		if (item.nearestCrossStreet != null) itemMap.put('nearestCrossstreet', item.nearestCrossStreet);
		if (item.optionalEndorsementLine != null) itemMap.put('optionalEndorsementLine', item.optionalEndorsementLine);
		if (item.postalCode != null) itemMap.put('postalCode', item.postalCode);
		if (item.postfixDirectional != null) itemMap.put('postfixDirectional', item.postfixDirectional);
		if (item.postnetAddressBlockBarcode != null) itemMap.put('postnetAddressBlockBarcode', item.postnetAddressBlockBarcode);
		if (item.postnetBarcode != null) itemMap.put('postnetBarcode', item.postnetBarcode);
		if (item.prefixDirectional != null) itemMap.put('prefixDirectional', item.prefixDirectional);
		if (item.setAddress1 != null) itemMap.put('setAddress1', (Boolean) item.setAddress1);
		if (item.setAddress2 != null) itemMap.put('setAddress2', (Boolean) item.setAddress2);
		if (item.setAddress3 != null) itemMap.put('setAddress3', (Boolean) item.setAddress3);
		if (item.setAddress4 != null) itemMap.put('setAddress4', (Boolean) item.setAddress4);
		if (item.setAddressId != null) itemMap.put('setAddressId', (Boolean) item.setAddressId);
		if (item.setAddressTypeId != null) itemMap.put('setAddressTypeId', (Boolean) item.setAddressTypeId);
		if (item.setChangeDt != null) itemMap.put('setChangeDt', (Boolean) item.setChangeDt);
		if (item.setChangeDt != null) itemMap.put('setChangeDt', (Boolean) item.setChangeDt);
		if (item.setChangeWho != null) itemMap.put('setChangeWho', (Boolean) item.setChangeWho);
		if (item.setCity != null) itemMap.put('setCity', (Boolean) item.setCity);
		if (item.setCountryCode != null) itemMap.put('setCountryCode', (Boolean) item.setCountryCode);
		if (item.setCounty != null) itemMap.put('setCounty', (Boolean) item.setCounty);
		if (item.setExtendedPostalCode != null) itemMap.put('setExtendedPostalCode', (Boolean) item.setExtendedPostalCode);
		if (item.setExternalAddressId != null) itemMap.put('setExternalAddressId', (Boolean) item.setExternalAddressId);
		if (item.setFranchiseTaxCode != null) itemMap.put('setFranchiseTaxCode', (Boolean) item.setFranchiseTaxCode);
		if (item.setFxGeocode != null) itemMap.put('setFxGeocode', (Boolean) item.setFxGeocode);
		if (item.setHouseNumber != null) itemMap.put('setHouseNumber', (Boolean) item.setHouseNumber);
		if (item.setHouseNumberSuffix != null) itemMap.put('setHouseNumberSuffix', (Boolean) item.setHouseNumberSuffix);
		if (item.setIsActive != null) itemMap.put('setIsActive', (Boolean) item.setIsActive);
		if (item.setKeyLineCode != null) itemMap.put('setKeyLineCode', (Boolean) item.setKeyLineCode);
		if (item.setNearestCrossstreet != null) itemMap.put('setNearestCrossstreet', (Boolean) item.setNearestCrossstreet);
		if (item.setOptionalEndorsementLine != null) itemMap.put('setOptionalEndorsementLine', (Boolean) item.setOptionalEndorsementLine);
		if (item.setPostalCode != null) itemMap.put('setPostalCode', (Boolean) item.setPostalCode);
		if (item.setPostfixDirectional != null) itemMap.put('setPostfixDirectional', (Boolean) item.setPostfixDirectional);
		if (item.setPostnetAddressBlockBarcode != null) itemMap.put('setPostnetAddressBlockBarcode', (Boolean) item.setPostnetAddressBlockBarcode);
		if (item.setPostnetBarcode != null) itemMap.put('setPostnetBarcode', (Boolean) item.setPostnetBarcode);
		if (item.setPrefixDirectional != null) itemMap.put('setPrefixDirectional', (Boolean) item.setPrefixDirectional);
		if (item.setState != null) itemMap.put('setState', (Boolean) item.setState);
		if (item.setStreetName != null) itemMap.put('setStreetName', (Boolean) item.setStreetName);
		if (item.setStreetSuffix != null) itemMap.put('setStreetSuffix', (Boolean) item.setStreetSuffix);
		if (item.setUnitNo != null) itemMap.put('setUnitNo', (Boolean) item.setUnitNo);
		if (item.setUnitType != null) itemMap.put('setUnitType', (Boolean) item.setUnitType);
		if (item.setVertexGeocode != null) itemMap.put('setVertexGeocode', (Boolean) item.setVertexGeocode);
		if (item.state != null) itemMap.put('state', item.state);
		if (item.streetName != null) itemMap.put('streetName', item.streetName);
		if (item.streetSuffix != null) itemMap.put('streetSuffix', item.streetSuffix);
		if (item.unitNo != null) itemMap.put('unitNo', item.unitNo);
		if (item.unitType != null) itemMap.put('unitType', item.unitType);
		if (item.vertexGeocode != null) itemMap.put('vertexGeocode', item.vertexGeocode);

		mapEnumeratedValues(itemMap);

		return itemMap;
	}
	
	private void mapEnumeratedValues(Map<String, Object> record) {
		if (record.get('Address1') != null) record.put('Address1', record.get('Address1'));
		if (record.get('Address2') != null) record.put('Address2', record.get('Address2'));
		if (record.get('Address3') != null) record.put('Address3', record.get('Address3'));
		if (record.get('Address4') != null) record.put('Address4', record.get('Address4'));
		if (record.get('AddressTypeId') != null) record.put('AddressTypeId', KenanEnumerationHelper.getEnumKeyValue('AddressTypeBean__mdt', 'addressTypeId__c', record.get('AddressTypeId'), kenanSettings.Stored_Language_Code__c,'DisplayValue__c'));
        if (record.get('ChangeDt') != null) record.put('ChangeDt', record.get('ChangeDt'));
        if (record.get('ChangeWho') != null) record.put('ChangeWho', record.get('ChangeWho'));
        if (record.get('City') != null) record.put('City', record.get('City'));
        if (record.get('ChangeWho') != null) record.put('ChangeWho', record.get('ChangeWho'));
        if (record.get('CountryCode') != null) record.put('CountryCode', KenanEnumerationHelper.getEnumKeyValue('CountryCodeBean__mdt', 'countryCode__c', record.get('CountryCode'), kenanSettings.Stored_Language_Code__c,'DisplayValue__c'));
        if (record.get('County') != null) record.put('County', record.get('County'));
        if (record.get('ExtendedPostalCode') != null) record.put('ExtendedPostalCode', record.get('ExtendedPostalCode'));
        if (record.get('ExternalAddressId') != null) record.put('ExternalAddressId', record.get('ExternalAddressId'));
        if (record.get('FranchiseTaxCode') != null) record.put('FranchiseTaxCode', record.get('FranchiseTaxCode'));
        if (record.get('FxGeocode') != null) record.put('FxGeocode', record.get('FxGeocode'));
        if (record.get('HouseNumber') != null) record.put('HouseNumber', record.get('HouseNumber'));
        if (record.get('HouseNumberSuffix') != null) record.put('HouseNumberSuffix', record.get('HouseNumberSuffix'));
        if (record.get('IsActive') != null) record.put('IsActive', record.get('IsActive'));
        if (record.get('Key') != null) record.put('Key', record.get('Key'));
        if (record.get('KeyLineCode') != null) record.put('KeyLineCode', record.get('KeyLineCode'));
        if (record.get('NearestCrossstreet') != null) record.put('NearestCrossstreet', record.get('NearestCrossstreet'));
        if (record.get('OptionalEndorsementLine') != null) record.put('OptionalEndorsementLine', record.get('OptionalEndorsementLine'));
        if (record.get('PostalCode') != null) record.put('PostalCode', record.get('PostalCode'));
        if (record.get('PostfixDirectional') != null) record.put('PostfixDirectional', record.get('PostfixDirectional'));
        if (record.get('State') != null) record.put('State', record.get('State'));
        if (record.get('StreetName') != null) record.put('StreetName', record.get('StreetName'));
        if (record.get('StreetSuffix') != null) record.put('StreetSuffix', record.get('StreetSuffix'));
        if (record.get('UnitNo') != null) record.put('UnitNo', record.get('UnitNo'));
        if (record.get('UnitType') != null) record.put('UnitType', record.get('UnitType'));
        if (record.get('VertexGeocode') != null) record.put('VertexGeocode', record.get('VertexGeocode'));
        if (record.get('address1') != null) record.put('address1', record.get('address1'));
		if (record.get('address2') != null) record.put('address2', record.get('address2'));
		if (record.get('address3') != null) record.put('address3', record.get('address3'));
		if (record.get('address4') != null) record.put('address4', record.get('address4'));
		if (record.get('addressTypeId') != null) record.put('addressTypeId', KenanEnumerationHelper.getEnumKeyValue('AddressTypeBean__mdt', 'addressTypeId__c', record.get('addressTypeId'), kenanSettings.Stored_Language_Code__c,'DisplayValue__c'));
        if (record.get('changeDt') != null) record.put('changeDt', record.get('changeDt'));
        if (record.get('changeWho') != null) record.put('changeWho', record.get('changeWho'));
        if (record.get('city') != null) record.put('city', record.get('city'));
        if (record.get('changeWho') != null) record.put('changeWho', record.get('changeWho'));
        if (record.get('countryCode') != null) record.put('countryCode', KenanEnumerationHelper.getEnumKeyValue('CountryCodeBean__mdt', 'countryCode__c', record.get('countryCode'), kenanSettings.Stored_Language_Code__c,'DisplayValue__c'));
        if (record.get('county') != null) record.put('county', record.get('county'));
        if (record.get('extendedPostalCode') != null) record.put('extendedPostalCode', record.get('extendedPostalCode'));
        if (record.get('externalAddressId') != null) record.put('externalAddressId', record.get('externalAddressId'));
        if (record.get('franchiseTaxCode') != null) record.put('franchiseTaxCode', record.get('franchiseTaxCode'));
        if (record.get('fxGeocode') != null) record.put('fxGeocode', record.get('fxGeocode'));
        if (record.get('houseNumber') != null) record.put('houseNumber', record.get('houseNumber'));
        if (record.get('houseNumberSuffix') != null) record.put('houseNumberSuffix', record.get('houseNumberSuffix'));
        if (record.get('isActive') != null) record.put('isActive', record.get('isActive'));
        if (record.get('key') != null) record.put('key', record.get('key'));
        if (record.get('keyLineCode') != null) record.put('keyLineCode', record.get('keyLineCode'));
        if (record.get('nearestCrossstreet') != null) record.put('nearestCrossstreet', record.get('nearestCrossstreet'));
        if (record.get('optionalEndorsementLine') != null) record.put('optionalEndorsementLine', record.get('optionalEndorsementLine'));
        if (record.get('postalCode') != null) record.put('postalCode', record.get('postalCode'));
        if (record.get('postfixDirectional') != null) record.put('postfixDirectional', record.get('postfixDirectional'));
        if (record.get('setAddress1') != null) record.put('setAddress1', record.get('setAddress1'));
        if (record.get('setAddress2') != null) record.put('setAddress2', record.get('setAddress2'));
        if (record.get('setAddress3') != null) record.put('setAddress3', record.get('setAddress3'));
        if (record.get('setAddress4') != null) record.put('setAddress4', record.get('setAddress4'));
        if (record.get('setAddressTypeId') != null) record.put('setAddressTypeId', record.get('setAddressTypeId'));
        if (record.get('setChangeDt') != null) record.put('setChangeDt', record.get('setChangeDt'));
        if (record.get('setChangeWho') != null) record.put('setChangeWho', record.get('setChangeWho'));
        if (record.get('setCity') != null) record.put('setCity', record.get('setCity'));
        if (record.get('setCountryCode') != null) record.put('setCountryCode', record.get('setCountryCode'));
        if (record.get('setCounty') != null) record.put('setCounty', record.get('setCounty'));
        if (record.get('setExtendedPostalCode') != null) record.put('setExtendedPostalCode', record.get('setExtendedPostalCode'));
        if (record.get('setExternalAddressId') != null) record.put('setExternalAddressId', record.get('setExternalAddressId'));
        if (record.get('setFranchiseTaxCode') != null) record.put('setFranchiseTaxCode', record.get('setFranchiseTaxCode'));
        if (record.get('setFxGeocode') != null) record.put('setFxGeocode', record.get('setFxGeocode'));
        if (record.get('setHouseNumber') != null) record.put('setHouseNumber', record.get('setHouseNumber'));
        if (record.get('setHouseNumberSuffix') != null) record.put('setHouseNumberSuffix', record.get('setHouseNumberSuffix'));
        if (record.get('setIsActive') != null) record.put('setIsActive', record.get('setIsActive'));
        if (record.get('setKeyLineCode') != null) record.put('setKeyLineCode', record.get('setKeyLineCode'));
        if (record.get('setNearestCrossstreet') != null) record.put('setNearestCrossstreet', record.get('setNearestCrossstreet'));
        if (record.get('setOptionalEndorsementLine') != null) record.put('setOptionalEndorsementLine', record.get('setOptionalEndorsementLine'));
        if (record.get('setPostalCode') != null) record.put('setPostalCode', record.get('setPostalCode'));
        if (record.get('setPostfixDirectional') != null) record.put('setPostfixDirectional', record.get('setPostfixDirectional'));
        if (record.get('setPostnetAddressBlockBarcode') != null) record.put('setPostnetAddressBlockBarcode', record.get('setPostnetAddressBlockBarcode'));
        if (record.get('setPostnetBarcode') != null) record.put('setPostnetBarcode', record.get('setPostnetBarcode'));
        if (record.get('setPrefixDirectional') != null) record.put('setPrefixDirectional', record.get('setPrefixDirectional'));
        if (record.get('setState') != null) record.put('setState', record.get('setState'));
        if (record.get('setStreetName') != null) record.put('setStreetName', record.get('setStreetName'));
        if (record.get('setStreetSuffix') != null) record.put('setStreetSuffix', record.get('setStreetSuffix'));
        if (record.get('setUnitNo') != null) record.put('setUnitNo', record.get('setUnitNo'));
        if (record.get('setUnitType') != null) record.put('setUnitType', record.get('setUnitType'));
        if (record.get('setVertexGeocode') != null) record.put('setVertexGeocode', record.get('setVertexGeocode'));
        if (record.get('state') != null) record.put('state', record.get('state'));
        if (record.get('streetName') != null) record.put('streetName', record.get('streetName'));
        if (record.get('streetSuffix') != null) record.put('streetSuffix', record.get('streetSuffix'));
        if (record.get('unitNo') != null) record.put('unitNo', record.get('unitNo'));
        if (record.get('unitType') != null) record.put('unitType', record.get('unitType'));
        if (record.get('vertexGeocode') != null) record.put('vertexGeocode', record.get('vertexGeocode'));
	}

	public KenanAddress getDisplayValues(Map<String, Object> objectMap){
		KenanAddress item = new KenanAddress();

		if (objectMap.get('Address1') != null) item.cAddress1 = String.valueOf(objectMap.get('Address1'));
		if (objectMap.get('Address2') != null) item.cAddress2 = String.valueOf(objectMap.get('Address2'));
		if (objectMap.get('Address3') != null) item.cAddress3 = String.valueOf(objectMap.get('Address3'));
		if (objectMap.get('Address4') != null) item.cAddress4 = String.valueOf(objectMap.get('Address4'));
		if (objectMap.get('AddressTypeId') != null) item.cAddressTypeId = String.valueOf(objectMap.get('AddressTypeId'));
		if (objectMap.get('ChangeDt') != null) item.cChangeDt = KenanUtils.fixDateTime(objectMap.get('ChangeDt'));
		if (objectMap.get('ChangeWho') != null) item.cChangeWho = String.valueOf(objectMap.get('ChangeWho'));
		if (objectMap.get('City') != null) item.cCity = String.valueOf(objectMap.get('City'));
		if (objectMap.get('CountryCode') != null) item.cCountryCode = String.valueOf(objectMap.get('CountryCode'));
		if (objectMap.get('County') != null) item.cCounty = String.valueOf(objectMap.get('County'));
		if (objectMap.get('ExtendedPostalCode') != null) item.cExtendedPostalCode = String.valueOf(objectMap.get('ExtendedPostalCode'));
		if (objectMap.get('ExternalAddressId') != null) item.cExternalAddressId = String.valueOf(objectMap.get('ExternalAddressId'));
		if (objectMap.get('FranchiseTaxCode') != null) item.cFranchiseTaxCode = Integer.valueOf(objectMap.get('FranchiseTaxCode'));
		if (objectMap.get('FxGeocode') != null) item.cFxGeocode = String.valueOf(objectMap.get('FxGeocode'));
		if (objectMap.get('HouseNumber') != null) item.cHouseNumber = String.valueOf(objectMap.get('HouseNumber'));
		if (objectMap.get('HouseNumberSuffix') != null) item.cHouseNumberSuffix = String.valueOf(objectMap.get('HouseNumberSuffix'));
		if (objectMap.get('IsActive') != null) item.cIsActive = Boolean.valueOf(objectMap.get('IsActive'));
		if (objectMap.get('Key') != null) item.cKey = (Map<String, Object>) objectMap.get('Key');
		if (objectMap.get('KeyLineCode') != null) item.cKeyLineCode = String.valueOf(objectMap.get('KeyLineCode'));
		if (objectMap.get('NearestCrossstreet') != null) item.cNearestCrossstreet = String.valueOf(objectMap.get('NearestCrossstreet'));
		if (objectMap.get('OptionalEndorsementLine') != null) item.cOptionalEndorsementLine = String.valueOf(objectMap.get('OptionalEndorsementLine'));
		if (objectMap.get('PostalCode') != null) item.cPostalCode = String.valueOf(objectMap.get('PostalCode'));
		if (objectMap.get('PostfixDirectional') != null) item.cPostfixDirectional = String.valueOf(objectMap.get('PostfixDirectional'));
		if (objectMap.get('PostnetAddressBlockBarcode') != null) item.cPostnetAddressBlockBarcode = String.valueOf(objectMap.get('PostnetAddressBlockBarcode'));
		if (objectMap.get('PostnetBarcode') != null) item.cPostnetBarcode = String.valueOf(objectMap.get('PostnetBarcode'));
		if (objectMap.get('PrefixDirectional') != null) item.cPrefixDirectional = String.valueOf(objectMap.get('PrefixDirectional'));
		if (objectMap.get('State') != null) item.cState = String.valueOf(objectMap.get('State'));
		if (objectMap.get('StreetName') != null) item.cStreetName = String.valueOf(objectMap.get('StreetName'));
		if (objectMap.get('StreetSuffix') != null) item.cStreetSuffix = String.valueOf(objectMap.get('StreetSuffix'));
		if (objectMap.get('UnitNo') != null) item.cUnitNo = String.valueOf(objectMap.get('UnitNo'));
		if (objectMap.get('UnitType') != null) item.cUnitType = String.valueOf(objectMap.get('UnitType'));
		if (objectMap.get('VertexGeocode') != null) item.cVertexGeocode = String.valueOf(objectMap.get('VertexGeocode'));
		if (objectMap.get('address1') != null) item.address1 = String.valueOf(objectMap.get('address1'));
		if (objectMap.get('address2') != null) item.address2 = String.valueOf(objectMap.get('address2'));
		if (objectMap.get('address3') != null) item.address3 = String.valueOf(objectMap.get('address3'));
		if (objectMap.get('address4') != null) item.address4 = String.valueOf(objectMap.get('address4'));
		if (objectMap.get('addressTypeId') != null) item.addressTypeId = String.valueOf(objectMap.get('addressTypeId'));
		if (objectMap.get('changeDt') != null) item.changeDt = String.valueOf(objectMap.get('changeDt'));
		if (objectMap.get('changeWho') != null) item.changeWho = String.valueOf(objectMap.get('changeWho'));
		if (objectMap.get('city') != null) item.city = String.valueOf(objectMap.get('city'));
		if (objectMap.get('countryCode') != null) item.countryCode = String.valueOf(objectMap.get('countryCode'));
		if (objectMap.get('county') != null) item.county = String.valueOf(objectMap.get('county'));
		if (objectMap.get('extendedPostalCode') != null) item.extendedPostalCode = String.valueOf(objectMap.get('extendedPostalCode'));
		if (objectMap.get('externalAddressId') != null) item.externalAddressId = String.valueOf(objectMap.get('externalAddressId'));
		if (objectMap.get('franchiseTaxCode') != null) item.franchiseTaxCode = Integer.valueOf(objectMap.get('franchiseTaxCode'));
		if (objectMap.get('fxGeocode') != null) item.fxGeocode = String.valueOf(objectMap.get('fxGeocode'));
		if (objectMap.get('houseNumber') != null) item.houseNumber = String.valueOf(objectMap.get('houseNumber'));
		if (objectMap.get('houseNumberSuffix') != null) item.houseNumberSuffix = String.valueOf(objectMap.get('houseNumberSuffix'));
		if (objectMap.get('isActive') != null) item.isActive = Boolean.valueOf(objectMap.get('isActive'));
		if (objectMap.get('key') != null) item.key = (Map<String, Object>) objectMap.get('key');
		if (objectMap.get('keyLineCode') != null) item.keyLineCode = String.valueOf(objectMap.get('keyLineCode'));
		if (objectMap.get('nearestCrossstreet') != null) item.nearestCrossstreet = String.valueOf(objectMap.get('nearestCrossstreet'));
		if (objectMap.get('optionalEndorsementLine') != null) item.optionalEndorsementLine = String.valueOf(objectMap.get('optionalEndorsementLine'));
		if (objectMap.get('postalCode') != null) item.postalCode = String.valueOf(objectMap.get('postalCode'));
		if (objectMap.get('postfixDirectional') != null) item.postfixDirectional = String.valueOf(objectMap.get('postfixDirectional'));
		if (objectMap.get('postnetAddressBlockBarcode') != null) item.postnetAddressBlockBarcode = String.valueOf(objectMap.get('postnetAddressBlockBarcode'));
		if (objectMap.get('postnetBarcode') != null) item.postnetBarcode = String.valueOf(objectMap.get('postnetBarcode'));
		if (objectMap.get('prefixDirectional') != null) item.prefixDirectional = String.valueOf(objectMap.get('prefixDirectional'));
		if (objectMap.get('setAddress1') != null) item.setAddress1 = Boolean.valueOf(objectMap.get('setAddress1'));
		if (objectMap.get('setAddress2') != null) item.setAddress2 = Boolean.valueOf(objectMap.get('setAddress2'));
		if (objectMap.get('setAddress3') != null) item.setAddress3 = Boolean.valueOf(objectMap.get('setAddress3'));
		if (objectMap.get('setAddress4') != null) item.setAddress4 = Boolean.valueOf(objectMap.get('setAddress4'));
		if (objectMap.get('setAddressId') != null) item.setAddressId = Boolean.valueOf(objectMap.get('setAddressId'));
		if (objectMap.get('setAddressTypeId') != null) item.setAddressTypeId = Boolean.valueOf(objectMap.get('setAddressTypeId'));
		if (objectMap.get('setChangeDt') != null) item.setChangeDt = Boolean.valueOf(objectMap.get('setChangeDt'));
		if (objectMap.get('setChangeWho') != null) item.setChangeWho = Boolean.valueOf(objectMap.get('setChangeWho'));
		if (objectMap.get('setCity') != null) item.setCity = Boolean.valueOf(objectMap.get('setCity'));
		if (objectMap.get('setCountryCode') != null) item.setCountryCode = Boolean.valueOf(objectMap.get('setCountryCode'));
		if (objectMap.get('setCounty') != null) item.setCounty = Boolean.valueOf(objectMap.get('setCounty'));
		if (objectMap.get('setExtendedPostalCode') != null) item.setExtendedPostalCode = Boolean.valueOf(objectMap.get('setExtendedPostalCode'));
		if (objectMap.get('setExternalAddressId') != null) item.setExternalAddressId = Boolean.valueOf(objectMap.get('setExternalAddressId'));
		if (objectMap.get('setFranchiseTaxCode') != null) item.setFranchiseTaxCode = Boolean.valueOf(objectMap.get('setFranchiseTaxCode'));
		if (objectMap.get('setFxGeocode') != null) item.setFxGeocode = Boolean.valueOf(objectMap.get('setFxGeocode'));
		if (objectMap.get('setHouseNumber') != null) item.setHouseNumber = Boolean.valueOf(objectMap.get('setHouseNumber'));
		if (objectMap.get('setHouseNumberSuffix') != null) item.setHouseNumberSuffix = Boolean.valueOf(objectMap.get('setHouseNumberSuffix'));
		if (objectMap.get('setIsActive') != null) item.setIsActive = Boolean.valueOf(objectMap.get('setIsActive'));
		if (objectMap.get('setKeyLineCode') != null) item.setKeyLineCode = Boolean.valueOf(objectMap.get('setKeyLineCode'));
		if (objectMap.get('setNearestCrossstreet') != null) item.setNearestCrossstreet = Boolean.valueOf(objectMap.get('setNearestCrossstreet'));
		if (objectMap.get('setOptionalEndorsementLine') != null) item.setOptionalEndorsementLine = Boolean.valueOf(objectMap.get('setOptionalEndorsementLine'));
		if (objectMap.get('setPostalCode') != null) item.setPostalCode = Boolean.valueOf(objectMap.get('setPostalCode'));
		if (objectMap.get('setPostfixDirectional') != null) item.setPostfixDirectional = Boolean.valueOf(objectMap.get('setPostfixDirectional'));
		if (objectMap.get('setPostnetAddressBlockBarcode') != null) item.setPostnetAddressBlockBarcode = Boolean.valueOf(objectMap.get('setPostnetAddressBlockBarcode'));
		if (objectMap.get('setPostnetBarcode') != null) item.setPostnetBarcode = Boolean.valueOf(objectMap.get('setPostnetBarcode'));
		if (objectMap.get('setPrefixDirectional') != null) item.setPrefixDirectional = Boolean.valueOf(objectMap.get('setPrefixDirectional'));
		if (objectMap.get('setState') != null) item.setState = Boolean.valueOf(objectMap.get('setState'));
		if (objectMap.get('setStreetName') != null) item.setStreetName = Boolean.valueOf(objectMap.get('setStreetName'));
		if (objectMap.get('setStreetSuffix') != null) item.setStreetSuffix = Boolean.valueOf(objectMap.get('setStreetSuffix'));
		if (objectMap.get('setUnitNo') != null) item.setUnitNo = Boolean.valueOf(objectMap.get('setUnitNo'));
		if (objectMap.get('setUnitType') != null) item.setUnitType = Boolean.valueOf(objectMap.get('setUnitType'));
		if (objectMap.get('setVertexGeocode') != null) item.setVertexGeocode = Boolean.valueOf(objectMap.get('setVertexGeocode'));
		if (objectMap.get('state') != null) item.state = String.valueOf(objectMap.get('state'));
		if (objectMap.get('streetName') != null) item.streetName = String.valueOf(objectMap.get('streetName'));
		if (objectMap.get('streetSuffix') != null) item.streetSuffix = String.valueOf(objectMap.get('streetSuffix'));
		if (objectMap.get('unitNo') != null) item.unitNo = String.valueOf(objectMap.get('unitNo'));
		if (objectMap.get('unitType') != null) item.unitType = String.valueOf(objectMap.get('unitType'));
		if (objectMap.get('vertexGeocode') != null) item.vertexGeocode = String.valueOf(objectMap.get('vertexGeocode'));

		return item;
	}
}