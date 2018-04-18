/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Service is the defined data structur for a Kenan Service.
*/
public class KenanService extends KenanObject{
	
	private KenanServiceConnection__c settings;

	public KenanService(){
		settings = KenanServiceConnection__c.getInstance();
		serviceItems = new List<KenanServiceItem>();
		setDefaultValues();
	}
	
	/** 
	* @description Salesforce Account Id for this service
	* 
	*/
	public String sfdcAccountId { get; set; } //"string",
	
	/** 
	* @description Reason the Service is being ceased.
	* DiscReasonBean__mdt will contain valid enumerations
	*/
	public String disconnectReason { get; set; }
	
	/** 
	* @description Datetime the Service will be ceased
	* 
	*/
	public Datetime disconnectDate { get; set; }
	

	/** 
	* @description 
	* 
	*/
	public DateTime activeDt { get; set; } 
	
	/** 
	* @description First line of address
	* 
	*/
	public String address1 { get; set; } //"string",
	
	/** 
	* @description Second line of address
	* 
	*/
	public String address2 { get; set; } //"string",
	
	/** 
	* @description Third line of address
	* 
	*/
	public String address3 { get; set; } //"string",
	
	/** 
	* @description Fourth line of address
	* 
	*/
	public String address4 { get; set; } //"string",
	
	/** 
	* @description Identifies the address as a master address or local address:
	* 1 = master address
	* 2 = local address
	* 
	*/
	public Integer addressLocation { get; set; } //0,
	
	/** 
	* @description Identifies the AddressType associated with the Service.
	* AddressTypeBean__mdt
	*/
	public String addressTypeId { get; set; } //0,
	
	/** 
	* @description B-end address’s ID.
	* 
	*/
	public Integer bendAddressId { get; set; } //0,
	
	/** 
	* @description 
	* 
	*/
	public Integer brevRcvCostCtr { get; set; } //0,
	
	/** 
	* @description B-end service address’s company name.
	* 
	*/
	public String bserviceCompany { get; set; } //"string",
	
	/** 
	* @description B-end address’s first name.
	* 
	*/
	public String bserviceFname { get; set; } //"string",
	
	/** 
	* @description B-end address’s franchise tax code. See FranchiseCode.
	* 
	*/
	public Integer bserviceFranchiseTaxCode { get; set; } //0,
	
	/** 
	* @description 
	* 
	*/
	public String bserviceGeocode { get; set; } //"string",
	
	/** 
	* @description B-end address’s last name.
	* 
	*/
	public String bserviceLname { get; set; } //"string",
	
	/** 
	* @description B-end address’s middle initial.
	* 
	*/
	public String bserviceMinit { get; set; } //"string",
	
	/** 
	* @description B-end address’s daytime phone number.
	* 
	*/
	public String bservicePhone { get; set; } //"string",
	
	/** 
	* @description B-end address’s evening phone number.
	* 
	*/
	public String bservicePhone2 { get; set; } //"string",
	
	/** 
	* @description 
	* 
	*/
	public DateTime changeDt { get; set; } // (string, optional),
	
	/** 
	* @description 
	* 
	*/
	public String changeWho { get; set;} //(string, optional),
	
	/** 
	* @description 
	* 
	*/
	public DateTime chgDt{ get; set; } //(string, optional),
	
	/** 
	* @description 
	* 
	*/
	public String chgWho { get; set; } //(string, optional),
	
	/** 
	* @description Required on Create. City or community of the address associated with this Service.
	* 
	*/
	public String city { get; set; } //"string",
	
	/** 
	* @description Customer-selected codeword used to validate customer identity.
	* 
	*/
	public String codeword { get; set; } //"string",
	
	/** 
	* @description 
	* 
	*/
	public Integer converted { get; set; } //0,
	
	/** 
	* @description Required on Create. CountryCode of the address associated with this Service.
	* CountryCodeBean__mdt
	*/
	public String countryCode { get; set; } //0,
	
	/** 
	* @description County of the address associated with this Service.
	* 
	*/
	public String county { get; set; } //"string",
	
	/** 
	* @description 
	* 
	*/
	public DateTime createDt { get; set; } //"2016-06-27T12:55:44.966Z",
	
	/** 
	* @description Identifies the preferred RateCurrency for this Service. This is used only for currency conversion.
	* RateCurrencyBean__mdt
	*/
	public String currencyCode { get; set; } //0,
	
	/** 
	* @description The address identifier displayed on the Invoice for this Service.
	* 
	*/
	public Integer displayAddressId { get; set; } //0,
	
	/** 
	* @description ViewId for the CustomerIdEquipMap that matches this Service to a default CustomerIdEquipMap on ServiceExternalIdType. Data in this field is controlled by database triggers.
	* 
	*/
	public Integer displayCiemViewId { get; set; } //0,
	
	/** 
	* @description Required on Create. The ServiceExternalIdType displayed on the Invoice for this Service. Do not set this field on Create. If ServiceExternalIdType is set for this object, this field is automatically set to that value; otherwise, this field is set to DefaultExternalIdType for the ServicePricingPlan identified by EmfConfigId.
	* 
	*/
	public Integer displayExternalIdType { get; set; } //0,
	
	/** 
	* @description 
	* 
	*/
	public Integer eligKey1 { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public Integer eligKey2 { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public Integer eligKey3 { get; set; } // 0,
	
	/** 
	* @description Required on Create. Identifies the EmfConfiguration for this Service.
	* 
	*/
	public Integer emfConfigId { get; set; } // 0,
	
	/** 
	* @description Controls the currency rate selected for this customer during currency conversion.
	* 
	*/
	public Integer exrateClass { get; set; } // 0,
	
	/** 
	* @description ZIP code or postal code extension.
	* 
	*/
	public String extendedPostalCode { get; set; } // 0,
	
	/** 
	* @description External address ID.
	* 
	*/
	public String externalAddressId { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public Integer franchiseTaxCode { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public String fxGeocode { get; set; } // 0,
	
	/** 
	* @description House Number
	* 
	*/
	public String houseNumber { get; set; } // 0,
	
	/** 
	* @description Designator that follows house number. (Example: “-B” in 222-B.)
	* 
	*/
	public String houseNumberSuffix { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public DateTime intendedViewEffectiveDt { get; set; } //"2016-06-27T12:55:44.966Z",
	
	/** 
	* @description 
	* 
	*/
	public Boolean isActive { get; set; } //true,
	
	/** 
	* @description 
	* 
	*/
	public Boolean isPrepaid { get; set; } //true,
	
	/** 
	* @description Identifies the IXC (interexchange carrier) for this Service. Used for wireline services.
	* 
	*/
	public Integer ixcProviderId { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public String keyLineCode { get; set; } // 0,
	
	/** 
	* @description Identifies the LEC (local exchange carrier) for this Service. Used for wireline services.
	* 
	*/
	public Integer lecProviderId { get; set; } // 0,
	
	/** 
	* @description Cross street nearest to the address.
	* 
	*/
	public String nearestCrossstreet { get; set; } // 0,
	
	/** 
	* @description
	* 
	*/
	public Boolean noBill { get; set; }
	
	/** 
	* @description Flag indicating whether or not this Service is to be published. Used for wireline services.
	* 
	*/
	public Integer nonpubNonlist { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public String optionalEndorsementLine { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public Integer parentAccountInternalId { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public DateTime picDateActive { get; set; } //"2016-06-27T12:55:44.966Z",
	
	/** 
	* @description Number of units for this Service. Used in RC rating, for example, for a leased line.
	* 
	*/
	public Integer popUnits { get; set; } // 0,
	
	/** 
	* @description Address Postal Code
	* 
	*/
	public String postalCode { get; set; } // 0,
	
	/** 
	* @description Directional indicator (north, south, and so on) that follows the street address
	* 
	*/
	public String postfixDirectional { get; set; } // 0,
	
	/** 
	* @description United States Postal Service address block barcode. This field was created to provide all the fields possible for a US-based address, but Kenan BP does not use the field itself for any specific purpose. You can use the field for any purpose and put any data in this field as long as the data is the correct type.
	* 
	*/
	public String postnetAddressBlockBarcode { get; set; } // 0,
	
	/** 
	* @description United States Postal Service barcode, placed outside of an address block. This field was created to provide all the fields possible for a US based address, but Kenan BP does not use the field itself for any specific purpose. You can use the field for any purpose and put any data in this field as long as the data is the correct type."
	* 
	*/
	public String postnetBarcode { get; set; } // 0,
	
	/** 
	* @description Directional indicator (north, south, and so on) that precedes the street address.
	* 
	*/
	public String prefixDirectional { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public Integer prevViewId { get; set; } // 0,
	
	/** 
	* @description Required on Create. (D: 0) (R: >= -1) Number of digits to truncate from the end of target numbers for usage events from this Service. Controls the masking of dialed numbers on the Invoice. -1 indicates total truncation.
	* PrivacyLevelBean__mdt
	*/
	public String privacyLevel { get; set; } // 0,
	
	/** 
	* @description Used as eligibility/rating key for charges on the Service. Default value derived from the EmfConfiguration identified by EmfConfigId
	* 
	*/
	public Integer rateClass { get; set; } // 0,
	
	/** 
	* @description Flag indicating if the PIC for the service is restricted. Used for wireline services.
	* 
	*/
	public Integer restrictedPic { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public Integer revRcvCostCtr { get; set; } // 0,
	
	/** 
	* @description 
	* SalesChannelBean__mdt
	*/
	public String salesChannelId { get; set; } // 0,
	
	///** 
	//* @description 
	//* 
	//*/
	//public Integer serverId { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public DateTime serviceActiveDt { get; set; } //"2016-06-27T12:55:44.966Z",
	
	/** 
	* @description 
	* 
	*/
	public String serviceCompany { get; set; } // 0,
	
	/** 
	* @description Service address’s first name.
	* 
	*/
	public String serviceFname { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public Integer serviceFranchiseTaxCode { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public String serviceGeocode { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public DateTime serviceInactiveDt { get; set; } //"2016-06-27T12:55:44.966Z",
	
	/** 
	* @description 
	* 
	*/
	public Integer serviceInternalId { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public Integer serviceInternalIdResets { get; set; } // 0,
	
	/** 
	* @description Service address’s last name.
	* 
	*/
	public String serviceLname { get; set; } // 0,
	
	/** 
	* @description Service address’s middle initial.
	* 
	*/
	public String serviceMinit { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public String serviceNameGeneration { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public String serviceNamePre { get; set; } // 0,
	
	/** 
	* @description Service address’s daytime phone number.
	* 
	*/
	public String servicePhone { get; set; } // 0,
	
	/** 
	* @description Service address’s evening phone number
	* 
	*/
	public String servicePhone2 { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public String simSerialNumber { get; set; } // 0,
	
	/** 
	* @description Service address’s state or province.
	* 
	*/
	public String state { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public Integer statusId { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public Integer statusReasonId { get; set; } // 0,
	
	/** 
	* @description Service address’s street name.
	* 
	*/
	public String streetName { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public String streetSuffix { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public String switchId { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public String timezone { get; set; } // 0,
	
	/** 
	* @description Unit number, such as apartment number or suite number.
	* 
	*/
	public String unitNo { get; set; } // 0,
	
	/** 
	* @description Dwelling type, such as “Apt” (apartment).
	* 
	*/
	public String unitType { get; set; } // 0,
	
	/** 
	* @description 
	* 
	*/
	public DateTime viewCreatedDt { get; set; } //(string, optional),
	
	/** 
	* @description 
	* 
	*/
	public Datetime viewEffectiveDt { get; set; } //(string, optional),
	
	/** 
	* @description 
	* 
	*/
	public Integer viewId { get; set; } //(integer, optional),
	
	/** 
	* @description 
	* 
	*/
	public Integer viewStatus { get; set; } //(integer, optional)
	
	/** 
	* @description 
	* 
	*/
	public String vertexGeocode { get; set; } // 0,
	
	/** 
	* @description Indicates how to handle outstanding installments of an installment Nrc: 0 = bill them as they are -- 1 = waive them -- 2 = bill them immediately (as of InactiveDt)
	* Connector will provide correct enumeration values based on Pick List Value provided. Provided Value must match MasterLabel Field of Custom Metadata Type WaiveInstallmentNRCOption__mdt
	* Value will be replaced with waiveInstallmentNrc__c value
	*/
	public String waiveInstallmentNrc { get; set; } 
	
	/** 
	* @description Indicates how to handle unbilled Nrcs: 0 = bill them as they are -- 1 = waive them -- 2 = bill them immediately (as of InactiveDt)
	* Connector will provide correct enumeration values based on Pick List Value provided. Provided Value must match MasterLabel Field of Custom Metadata Type WaiveUnBilledNRCOption__mdt
	* Value will be replaced with waiveUnbilledNrc__c value
	*/
	public String waiveUnbilledNrc { get; set; } 

	/** 
	* @description Indicates how to handle termination Nrcs: 0 = bill them as they are -- 1 = waive them -- 2 = bill them immediately (as of InactiveDt)
	* Connector will provide correct enumeration values based on Pick List Value provided. Provided Value must match MasterLabel Field of Custom Metadata Type WaiveTerminationObligationOption__mdt
	* Value will be replaced with waiveTerminationObligation__c value
	*/
	public String waiveTerminationObligation { get; set; } 

	/** 
	* @description Indicates how to handle unmet obligation Nrcs: 0 = bill them as they are -- 1 = waive them -- 2 = bill them immediately (as of InactiveDt)
	* Connector will provide correct enumeration values based on Pick List Value provided. Provided Value must match MasterLabel Field of Custom Metadata Type WaiveUnmetObligationOption__mdt
	* Value will be replaced with waiveUnmetObligation__c value
	*/
	public String waiveUnmetObligation { get; set; } 

	/** 
	* @description Indicates how to handle outstanding refinance Nrcs: 0 = bill them as they are -- 2 = bill them immediately (as of InactiveDt)
	* Connector will provide correct enumeration values based on Pick List Value provided. Provided Value must match MasterLabel Field of Custom Metadata Type WaiveRefinanceNRCOption__mdt
	* Value will be replaced with waiveRefinanceNRC__c value
	*/
	public String waiveRefinanceNrc { get; set; } 


	/**
	* @description List of Items to be created with the Service
	*
	*/
	public List<KenanServiceItem> serviceItems { get; set; }
	
	public List<Map<String, String>> extIdList { get; set; }


	private void setDefaultValues(){
		this.waiveInstallmentNrc = KenanEnumerationHelper.getDefaultEnumDisplayValue('WaiveInstallmentNRCOption__mdt', settings.Stored_Language_Code__c, 'MasterLabel');
		this.waiveUnbilledNrc = KenanEnumerationHelper.getDefaultEnumDisplayValue('WaiveUnBilledNRCOption__mdt', settings.Stored_Language_Code__c, 'MasterLabel');
		this.waiveTerminationObligation = KenanEnumerationHelper.getDefaultEnumDisplayValue('WaiveTerminationObligationOption__mdt', settings.Stored_Language_Code__c, 'MasterLabel');
		this.waiveUnmetObligation = KenanEnumerationHelper.getDefaultEnumDisplayValue('WaiveUnmetObligationOption__mdt', settings.Stored_Language_Code__c, 'MasterLabel');
		this.waiveRefinanceNrc = KenanEnumerationHelper.getDefaultEnumDisplayValue('WaiveRefinanceNRCOption__mdt', settings.Stored_Language_Code__c, 'MasterLabel');
	}

/*
sample response
{
  //"state": "PA",
  //"chgWho": "aruba",
  //"serviceInternalId": 2,
  //"serviceInternalIdResets": 0,
  //"parentAccountInternalId": 2,
  //"activeDt": 1467165115000,
  //"viewId": 1003,
  //"viewStatus": 1,
  //"createDt": 1467165115000,
  //"emfConfigId": 1,
  //"intendedViewEffectiveDt": 1467165115000,
  //"serviceActiveDt": 1467165115000,
  //"displayExternalIdType": 10,
  //"privacyLevel": 0,
  //"revRcvCostCtr": 1,
  //"city": "Allentown",
  //"postalCode": "18101",
  //"converted": 0,
  //"noBill": false,
  //"chgDt": 1467165115000,
  //"viewCreatedDt": 1467165115000,
  //"viewEffectiveDt": 1467165115000,
  //"countryCode": 840,
  //"franchiseTaxCode": 1,
  //"displayAddressId": 1003,
  //"fxGeocode": "840001000000000",
  //"addressTypeId": 1,
  //"addressLocation": 2,
  //"address1": "    ",
  //"address2": "Allentown PA",
  //"address3": "United States 18101",
  //"isActive": true,
  //"changeWho": "aruba",
  //"changeDt": 1467165115000,
  //"isPrepaid": false,
  //"statusId": 1,
  //"statusReasonId": 1
}

*/

	
}