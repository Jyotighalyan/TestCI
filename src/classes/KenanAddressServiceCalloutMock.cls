/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
@isTest
global class KenanAddressServiceCalloutMock implements HttpCalloutMock {
	
	private String jsonService = '{"Address1":"123 Test St.","Address2":"string","Address3":"string","Address4":"string","AddressTypeId":0,"ChangeDt":"2016-07-28T11:36:44.681Z","ChangeWho":"string","City":"Allentown","CountryCode":0,"County":"string","ExtendedPostalCode":"string","ExternalAddressId":"string","FranchiseTaxCode":0,"FxGeocode":"string","HouseNumber":"string","HouseNumberSuffix":"string","IsActive":true,"Key":{"AddressId":0,"addressId":0,"setAddressId":true},"KeyLineCode":"string","NearestCrossstreet":"string","OptionalEndorsementLine":"string","PostalCode":"11111","PostfixDirectional":"string","PostnetAddressBlockBarcode":"string","PostnetBarcode":"string","PrefixDirectional":"string","State":"TX","StreetName":"string","StreetSuffix":"string","UnitNo":"string","UnitType":"string","VertexGeocode":"string","address1":"string","address2":"string","address3":"string","address4":"string","addressId":0,"addressTypeId":0,"changeDt":"2016-07-28T11:36:44.681Z","changeWho":"string","city":"string","countryCode":0,"county":"string","extendedData":{},"extendedPostalCode":"string","externalAddressId":"string","franchiseTaxCode":0,"fxGeocode":"string","houseNumber":"string","houseNumberSuffix":"string","isActive":true,"key":{"AddressId":0,"addressId":0,"setAddressId":true},"keyLineCode":"string","nearestCrossstreet":"string","optionalEndorsementLine":"string","postalCode":"string","postfixDirectional":"string","postnetAddressBlockBarcode":"string","postnetBarcode":"string","prefixDirectional":"string","setAddress1":true,"setAddress2":true,"setAddress3":true,"setAddress4":true,"setAddressId":true,"setAddressTypeId":true,"setChangeDt":true,"setChangeWho":true,"setCity":true,"setCountryCode":true,"setCounty":true,"setExtendedPostalCode":true,"setExternalAddressId":true,"setFranchiseTaxCode":true,"setFxGeocode":true,"setHouseNumber":true,"setHouseNumberSuffix":true,"setIsActive":true,"setKeyLineCode":true,"setNearestCrossstreet":true,"setOptionalEndorsementLine":true,"setPostalCode":true,"setPostfixDirectional":true,"setPostnetAddressBlockBarcode":true,"setPostnetBarcode":true,"setPrefixDirectional":true,"setState":true,"setStreetName":true,"setStreetSuffix":true,"setUnitNo":true,"setUnitType":true,"setVertexGeocode":true,"state":"string","streetName":"string","streetSuffix":"string","unitNo":"string","unitType":"string","vertexGeocode":"string"}';

	global Integer numberOfRecords { get; set; }
	
	global HttpResponse respond ( HTTPRequest req ) {
		List<String> jsonList = new List<String>();
		String jsonString = '';
		if (numberOfRecords == 1){
			jsonString = jsonService;
		} else {
			for (Integer i = 0; i < numberOfRecords; i++){
				jsonList.add('{"Address1":"123 Test St.","Address2":"string","Address3":"string","Address4":"string","AddressTypeId":0,"ChangeDt":"2016-07-28T11:36:44.681Z","ChangeWho":"string","City":"Allentown","CountryCode":0,"County":"string","ExtendedPostalCode":"string","ExternalAddressId":"string","FranchiseTaxCode":0,"FxGeocode":"string","HouseNumber":"string","HouseNumberSuffix":"string","IsActive":true,"Key":{"AddressId":0,"addressId":0,"setAddressId":true},"KeyLineCode":"string","NearestCrossstreet":"string","OptionalEndorsementLine":"string","PostalCode":"11111","PostfixDirectional":"string","PostnetAddressBlockBarcode":"string","PostnetBarcode":"string","PrefixDirectional":"string","State":"TX","StreetName":"string","StreetSuffix":"string","UnitNo":"string","UnitType":"string","VertexGeocode":"string","address1":"string","address2":"string","address3":"string","address4":"string","addressId":0,"addressTypeId":0,"changeDt":"2016-07-28T11:36:44.681Z","changeWho":"string","city":"string","countryCode":0,"county":"string","extendedData":{},"extendedPostalCode":"string","externalAddressId":"string","franchiseTaxCode":0,"fxGeocode":"string","houseNumber":"string","houseNumberSuffix":"string","isActive":true,"key":{"AddressId":0,"addressId":0,"setAddressId":true},"keyLineCode":"string","nearestCrossstreet":"string","optionalEndorsementLine":"string","postalCode":"string","postfixDirectional":"string","postnetAddressBlockBarcode":"string","postnetBarcode":"string","prefixDirectional":"string","setAddress1":true,"setAddress2":true,"setAddress3":true,"setAddress4":true,"setAddressId":true,"setAddressTypeId":true,"setChangeDt":true,"setChangeWho":true,"setCity":true,"setCountryCode":true,"setCounty":true,"setExtendedPostalCode":true,"setExternalAddressId":true,"setFranchiseTaxCode":true,"setFxGeocode":true,"setHouseNumber":true,"setHouseNumberSuffix":true,"setIsActive":true,"setKeyLineCode":true,"setNearestCrossstreet":true,"setOptionalEndorsementLine":true,"setPostalCode":true,"setPostfixDirectional":true,"setPostnetAddressBlockBarcode":true,"setPostnetBarcode":true,"setPrefixDirectional":true,"setState":true,"setStreetName":true,"setStreetSuffix":true,"setUnitNo":true,"setUnitType":true,"setVertexGeocode":true,"state":"string","streetName":"string","streetSuffix":"string","unitNo":"string","unitType":"string","vertexGeocode":"string"}');
			}
			jsonString = JSON.serialize(jsonList);
		}
		
		HttpResponse res = new HttpResponse();
		res.setHeader ('Content-Type', 'application/json');
		res.setBody (jsonString);
		res.setStatusCode ( 200 );
		System.assertNotEquals ( null, res.getBody(), 'response body should not be null' );
		return res;
	}
}