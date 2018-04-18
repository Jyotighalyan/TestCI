/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanAddress for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanAddress extends KenanObject {
	
	public KenanAddress() {
		this.serviceExternalIdType = 2;
	}

	/**
	* @description The Salesforce recordId for the Service this Item is to be attached
	*/
	public String serviceExternalId { get; set; }
	
	/**
	* @description The Id Type for the Salesforce recordId for the Service this Item is to be attached. The defualt value is 2
	*/
	public Integer serviceExternalIdType { get; set; }

	/**
	* @description The first address line
	*/
	public String cAddress1 { get; set; }
	
	/**
	* @description The second address line
	*/
	public String cAddress2 { get; set; }
	
	/**
	* @description The third address line
	*/
	public String cAddress3 { get; set; }
	
	/**
	* @description The fourth address line
	*/
	public String cAddress4 { get; set; }

	/**
	* @description The id of the address type
	*/
	public String cAddressTypeId { get; set; }
	
	/**
	* @description The change date
	*/
	public DateTime cChangeDt { get; set; } 
	
	/**
	* @description Who changed the address
	*/
	public String cChangeWho { get; set; }
	
	/**
	* @description The address city
	*/
	public String cCity { get; set; }

	/**
	* @description The address country code
	*/
	public String cCountryCode { get; set; }

	/**
	* @description The address county
	*/
	public String cCounty { get; set; }

	/**
	* @description The extended postal code
	*/
	public String cExtendedPostalCode { get; set; }

	/**
	* @description The external address id
	*/
	public String cExternalAddressId { get; set; }

	/**
	* @description The franchise tax code
	*/
	public Integer cFranchiseTaxCode { get; set; }

	/**
	* @description 
	*/
	public String cFxGeocode { get; set; }

	/**
	* @description The address house number
	*/
	public String cHouseNumber { get; set; }

	/**
	* @description The address house number suffix
	*/
	public String cHouseNumberSuffix { get; set; }

	/**
	* @description Whether or not the address is active
	*/
	public Boolean cIsActive { get; set; }

	/**
	* @description The key map
	*/
	public Map<String, Object> cKey { get; set; }

	/**
	* @description The key line code
	*/
	public String cKeyLineCode { get; set; }	

	/**
	* @description The nearest cross street
	*/
	public String cNearestCrossStreet { get; set; }	

	/**
	* @description The optional endorsement line
	*/
	public String cOptionalEndorsementLine { get; set; }

	/**
	* @description The postal code
	*/
	public String cPostalCode { get; set; }

	/**
	* @description The postfix directions
	*/
	public String cPostfixDirectional { get; set; }

	/**
	* @description The postnet address block barcode
	*/
	public String cPostnetAddressBlockBarcode { get; set; }

	/**
	* @description The postnet barcode
	*/
	public String cPostnetBarcode { get; set; }

	/**
	* @description The prefix directional
	*/
	public String cPrefixDirectional { get; set; }

	/**
	* @description The state
	*/
	public String cState { get; set; }

	/**
	* @description The streetname
	*/
	public String cStreetName { get; set; }

	/**
	* @description The street suffix
	*/
	public String cStreetSuffix { get; set; }

	/**
	* @description The unit number
	*/
	public String cUnitNo { get; set; }

	/**
	* @description The unit type
	*/
	public String cUnitType { get; set; }

	/**
	* @description The vertex geocode
	*/
	public String cVertexGeocode { get; set; }

	/**
	* @description 
	*/
	public String address1 { get; set; }

	/**
	* @description
	*/
	public String address2 { get; set; }

	/**
	* @description
	*/
	public String address3 { get; set; }

	/**
	* @description
	*/
	public String address4 { get; set; }

	/**
	* @description
	*/
	public Integer addressId { get; set; }

	/**
	* @description
	*/
	public String addressTypeId { get; set; }

	/**
	* @description
	*/
	public String changeDt { get; set; }

	/**
	* @description
	*/
	public String changeWho { get; set; }

	/**
	* @description
	*/
	public String city { get; set; }

	/**
	* @description
	*/
	public String countryCode { get; set; }

	/**
	* @description
	*/
	public String county { get; set; }

	/**
	* @description
	*/
	public Object extendedData { get; set; }

	/**
	* @description
	*/
	public String extendedPostalCode { get; set; }

	/**
	* @description
	*/
	public String externalAddressId { get; set; }

	/**
	* @description
	*/
	public Integer franchiseTaxCode { get; set; }

	/**
	* @description
	*/
	public String fxGeocode { get; set; }

	/**
	* @description
	*/
	public String houseNumber { get; set; }

	/**
	* @description
	*/
	public String houseNumberSuffix { get; set; }

	/**
	* @description
	*/
	public Boolean isActive { get; set; }

	/**
	* @description
	*/
	public Map<String, Object> key { get; set; }

	/**
	* @description
	*/
	public String keyLineCode { get; set; }

	/**
	* @description
	*/	
	public String nearestCrossstreet { get; set; }

	/**
	* @description
	*/
	public String optionalEndorsementLine { get; set; }

	/**
	* @description
	*/
	public String postalCode { get; set; }

	/**
	* @description
	*/
	public String postfixDirectional { get; set; }

	/**
	* @description
	*/
	public String postnetAddressBlockBarcode { get; set; }

	/**
	* @description
	*/
	public String postnetBarcode { get; set; }

	/**
	* @description
	*/
	public String prefixDirectional { get; set; }

	/**
	* @description
	*/
	public Boolean setAddress1 { get; set; }

	/**
	* @description
	*/
	public Boolean setAddress2 { get; set; }

	/**
	* @description
	*/
	public Boolean setAddress3 { get; set; }

	/**
	* @description
	*/
	public Boolean setAddress4 { get; set; }

	/**
	* @description
	*/
	public Boolean setAddressId { get; set; }

	/**
	* @description
	*/
	public Boolean setAddressTypeId { get; set; }

	/**
	* @description
	*/
	public Boolean setChangeDt { get; set; }

	/**
	* @description
	*/
	public Boolean setChangeWho { get; set; }

	/**
	* @description
	*/
	public Boolean setCity { get; set; }

	/**
	* @description
	*/
	public Boolean setCountryCode { get; set; }

	/**
	* @description
	*/
	public Boolean setCounty { get; set; }

	/**
	* @description
	*/
	public Boolean setExtendedPostalCode { get; set; }

	/**
	* @description
	*/
	public Boolean setExternalAddressId { get; set; }

	/**
	* @description
	*/
	public Boolean setFranchiseTaxCode { get; set; }

	/**
	* @description
	*/
	public Boolean setFxGeocode { get; set; }

	/**
	* @description
	*/
	public Boolean setHouseNumber { get; set; }

	/**
	* @description
	*/
	public Boolean setHouseNumberSuffix { get; set; }

	/**
	* @description
	*/
	public Boolean setIsActive { get; set; }

	/**
	* @description
	*/
	public Boolean setKeyLineCode { get; set; }

	/**
	* @description
	*/
	public Boolean setNearestCrossstreet { get; set; }

	/**
	* @description
	*/
	public Boolean setOptionalEndorsementLine { get; set; }

	/**
	* @description
	*/
	public Boolean setPostalCode { get; set; }

	/**
	* @description
	*/
	public Boolean setPostfixDirectional { get; set; }

	/**
	* @description
	*/
	public Boolean setPostnetAddressBlockBarcode { get; set; }

	/**
	* @description
	*/
	public Boolean setPostnetBarcode { get; set; }

	/**
	* @description
	*/
	public Boolean setPrefixDirectional { get; set; }

	/**
	* @description
	*/
	public Boolean setState { get; set; }

	/**
	* @description
	*/
	public Boolean setStreetName { get; set; }

	/**
	* @description
	*/
	public Boolean setStreetSuffix { get; set; }

	/**
	* @description
	*/
	public Boolean setUnitNo { get; set; }

	/**
	* @description
	*/
	public Boolean setUnitType { get; set; }

	/**
	* @description
	*/
	public Boolean setVertexGeocode { get; set; }

	/**
	* @description
	*/
	public String state { get; set; }

	/**
	* @description
	*/
	public String streetName { get; set; }

	/**
	* @description
	*/
	public String streetSuffix { get; set; }

	/**
	* @description
	*/
	public String unitNo { get; set; }

	/**
	* @description
	*/
	public String unitType { get; set; }

	/**
	* @description
	*/
	public String vertexGeocode { get; set; }

}