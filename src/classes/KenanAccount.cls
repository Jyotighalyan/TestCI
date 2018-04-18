/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanAccount extends KenanObject {

	public KenanAccount(){
		//this.noBill = false;
		this.accountItems = new List<KenanAccountItem>();
	}

	/** 
	* @description Provide Picklist Value, Connector will translate the value to the correct enumerated Kenan value.
	* Valid Values are stored in AccountCategoryBean__mdt
	*/
	public String accountCategory { get; set; }

	/** 
	* @description Kenan Account Unique Identifier
	* Conditionally required. If this value is not specified, it is generated automatically. Cannot be updated. ID of this Account object.
	*/
	public Integer accountInternalId { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer accountProcessFlag { get; set; }

	///** 
	//* @description These values are not configurable
	//* Pending : -3
	//* Dics_Done : -2
	//* New : -1
	//* Current : 0
	//* Disc_Req : 1
	//*/
	//public Integer accountStatus { get; set; }

	///** 
	//* @description Date and time when the AccountStatus field was last updated.
	//*/
	//public DateTime accountStatusDt { get; set; }

	/** 
	* @description Account type. If DEFAULT_ACCOUNT_TYPE system parameter (Kenan BP module csr) is set, this field defaults to that value. This field cannot be updated from billable to unbillable.
	* 1 = billable
	* 0 = unbillable.
	*/
	public String accountType { get; set; }

	/** 
	* @description Provide Picklist Value, Connector will translate the value to the correct enumerated Kenan value.
	* Identifies the AccountSegment to which this Account belongs, or zero for none.
	* If this Account’s parent Account has an AcctSegId, this Account’s AcctSegId must be the same.
	* Valid values are located in AccountSegmentMapBean__mdt
	*/
	public String acctSegId { get; set; }


	/** 
	* @description 
	*/
	public String altCompanyName { get; set; }

	/** 
	* @description 
	*/
	public String altFname { get; set; }

	/** 
	* @description 
	*/
	public String altLname { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer autoWriteoffStatus { get; set; }

	/** 
	* @description Billing Address Street Address Line 1
	*/
	public String billAddress1 { get; set; }

	/** 
	* @description Billing Address Street Address Line 2
	*/
	public String billAddress2 { get; set; }

	/** 
	* @description Billing Address Street Address Line 3
	*/
	public String billAddress3 { get; set; }

	/** 
	* @description Billing Address City
	*/
	public String billCity { get; set; }

	/** 
	* @description Billing Address Company Name
	*/
	public String billCompany { get; set; }

	/** 
	* @description Provide Picklist Value, Connector will translate the value to the correct enumerated Kenan value
	* Billing Address Counrty Code
	*/
	public Integer billCountryCode { get; set; }

	/** 
	* @description Billing Address County
	*/
	public String billCounty { get; set; }
	
	/** 
	* @description Identifies the BillDispatchMethod for this Account.
	* Valid values are stored in BillDispatchMethodBean__mdt
	*/
	public String billDispMeth { get; set; }

	/** 
	* @description Provide Picklist Value, Connector will translate the value to the correct enumerated Kenan value
	* Valid Values are stored in BillFmtOptBean__mdt
	*/ 
	public String billFmtOpt { get; set; }

	/** 
	* @description First Name of Billing Contact
	*/
	public String billFname { get; set; }

	/** 
	* @description Last Name of Billing Contact
	*/
	public String billLname { get; set; }

	/** 
	* @description 
	*/
	public Integer billFranchiseTaxCode { get; set; }

	///** 
	//* @description 
	//*/
	//public String billGeocode { get; set; }

	///** 
	//* @description Provide Picklist Value, Connector will translate the value to the correct enumerated Kenan value
	//*/
	//public Integer billHoldCode { get; set; }

	///** 
	//* @description Identifies the BillingFrequency for this Account. (Default: proper frequency for given BillPeriod) if AccountType = 1.
	//*/
	//public Integer billingFrequency { get; set; }


	/** 
	* @description Middle Initial of Billing Contact
	*/
	public String billMinit { get; set; }

	/** 
	* @description Billing Contact Generation Example: Sr., Jr., III
	*/
	public String billNameGeneration { get; set; }

	/** 
	* @description Billing Contact Prefix Example: Mr. Mrs. Ms. Dr.
	*/
	public String billNamePre { get; set; }

	/** 
	* @description Provide Picklist Value, Connector will translate the value to the correct enumerated Kenan value
	* Valid values are stored in BillPeriodBean__mdt
	*/ 
	public String billPeriod { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer billSequenceNum { get; set; }

	/** 
	* @description Billing Address State / Province
	*/
	public String billState { get; set; }

	/** 
	* @description 
	*/
	public String billTitle { get; set; }

	/** 
	* @description Billing Address Zip / Postal Code
	*/
	public String billZip { get; set; }

	///** 
	//* @description 
	//*/
	//public Long chargeThreshold { get; set; }

	///** 
	//* @description 
	//*/
	//public String chgWho { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer childCount { get; set; }

	/** 
	* @description Customer-selected code word used to validate customer identity.
	*/
	public String codeword { get; set; }

	///** 
	//* @description Collection status for last 12 bill periods. Zero is good, numbers greater than zero are increasingly bad.
	//*/
	//public String collectionHistory { get; set; }

	///** 
	//* @description (R: 0, 1) Indicates whether this Account is in collections. (0 = no, 1 = yes)
	//*/
	//public Integer collectionIndicator { get; set; }

	///** 
	//* @description (D: 0) If this Account is in collections, indicates the status of the collection event currently active.
	//*/
	//public Integer collectionStatus { get; set; }

	/** 
	* @description First Contact Name
	*/
	public String contact1Name { get; set; }

	/** 
	* @description Phone Number for First Contact
	*/
	public String contact1Phone { get; set; }

	/** 
	* @description Second Contact Name
	*/
	public String contact2Name { get; set; }

	/** 
	* @description Phone Number for Second Contact
	*/
	public String contact2Phone { get; set; }

	///** 
	//* @description (D: 0) (R: 0, 1, 2) Conversion flag for use during database upgrades:
	//* 0 = not converted
	//* 1 = modified since last conversion, if any
	//* 2 = converted
	//*/
	//public Integer converted { get; set; }

	///** 
	//* @description (D: 0) Customer's credit rating. Controls future collections activity.
	//*/
	//public Integer creditRating { get; set; }

	///** 
	//* @description 
	//*/
	//public Long creditThresh { get; set; }

	///** 
	//* @description Customer's credit status.
	//*/
	//public Integer credStatus { get; set; }

	/** 
	* @description (D: 1) Identifies customer's preferred RateCurrency.
	* RateCurrencyBean__mdt
	*/	
	public String currencyCode { get; set; }

	/** 
	* @description First line of customer’s alternate address.
	*/
	public String custAddress1 { get; set; }

	/** 
	* @description Second line of customer’s alternate address.
	*/
	public String custAddress2 { get; set; }

	/** 
	* @description Third line of customer’s alternate address.
	*/
	public String custAddress3 { get; set; }

	/** 
	* @description City of customer’s alternate address.
	*/
	public String custCity { get; set; }

	/** 
	* @description Country Code of customer’s alternate address. Connector will translate the value to the correct enumerated Kenan value
	*/
	public Integer custCountryCode { get; set; }

	/** 
	* @description County of customer’s alternate address.
	*/
	public String custCounty { get; set; }

	/** 
	* @description Customer's e-mail address.
	*/
	public String custEmail { get; set; }

	/** 
	* @description Customer's Fax Number
	*/
	public String custFaxno { get; set; }

	///** 
	//* @description Customer’s alternate franchise tax code.
	//*/
	//public Integer custFranchiseTaxCode { get; set; }

	///** 
	//* @description (D: geocode for customer address) Defines authorities at which customer will be taxed based on alternate address.
	//*/
	//public String custGeocode { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer customerLifetimeId { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer customerLifetimeId2 { get; set; }

	/** 
	* @description Customer's Phone Number
	*/
	public String custPhone1 { get; set; }

	/** 
	* @description Customer's Alternate Phone Number
	*/
	public String custPhone2 { get; set; }

	/** 
	* @description State of customer’s alternate address.
	*/
	public String custState { get; set; }

	/** 
	* @description Zip / Postal Code of customer’s alternate address.
	*/
	public String custZip { get; set; }

	///** 
	//* @description 
	//*/
	//public Long cyclicalThreshold { get; set; }

	/** 
	* @description DateTime the customer is active
	* dateActive can be in the past
	* dateActive must also be less than the dateInactive property
	*/
	public DateTime dateActive { get; set; }

	/** 
	* @description Date the Customer is inactive. 
	* dateInactive must be greater than dateActive
	* dateInactive can be in the future
	*/
	public DateTime dateInactive { get; set; }

	/** 
	* @description 
	*/
	public String dept { get; set; }

	///** 
	//* @description Connector will translate the value to the correct enumerated Kenan value
	//*/
	//public Integer disconnectReason { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer discRcvOpt { get; set; }

	///** 
	//* @description 
	//*/
	//public String distrChan { get; set; }

	/** 
	* @description 
	*/
	public Integer exrateClass { get; set; }

	/** 
	* @description Provide Picklist Value, Connector will translate the value to the correct enumerated Kenan value
	* 
	*/
	public Integer gender { get; set; }

	///** 
	//* @description Provide Picklist Value, Connector will translate the value to the correct enumerated Kenan value
	//*/
	//public Integer globalContractStatus { get; set; }

	///** 
	//* @description 
	//*/
	//public String hierarchyAccountExternalId { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer hierarchyAccountExternalIdType { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer hierarchyId { get; set; }

	
	///** 
	//* @description 
	//*/
	//public Integer insertGrpId { get; set; }

	///** 
	//* @description 
	//*/
	//public String inUse { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer languageCode { get; set; }

	/** 
	* @description Provide Picklist Value, Connector will translate the value to the correct enumerated Kenan value
	* Valid values are stored in MktCodeBean__mdt
	*/
	public String mktCode { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer msgGrpId { get; set; }

	///** 
	//* @description 
	//*/
	//public Boolean noBill { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer owningCostCtr { get; set; }

	/** 
	* @description 
	*/
	public String parentAccountExternalId { get; set; } //SFDC Id of Parent Account

	/** 
	* @description 
	*/
	public Integer parentAccountExternalIdType { get; set; } //Type = 2

	///** 
	//* @description 
	//*/
	//public Integer parentId { get; set; }

	///** 
	//* @description 
	//*/
	//public Long paymentProfileId { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer planIdCredit { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer planIdDiscount { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer prevBalanceRefno { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer prevBalanceRefResets { get; set; }

	//public DateTime prevBillDate { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer prevBillRefno { get; set; }

	//* 
	//* @description 
	
	//public Integer prevBillRefResets { get; set; }

	//public DateTime prevCutoffDate { get; set; }

	///** 
	//* @description 
	//*/
	//public String purchaseOrder { get; set; }

	/** 
	* @description Provide Picklist Value, Connector will translate the value to the correct enumerated Kenan value.
	* Valid values are stored in RateClassDescrBean__mdt
	*/
	public String rateClassDefault { get; set; }

	/** 
	* @description 
	*/
	public Integer rateClassSpecial { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer regulatoryId { get; set; }

	///** 
	//* @description 
	//*/
	//public String remark { get; set; }

	/** 
	* @description 
	*/
	public Integer revRcvCostCtr { get; set; }

	/** 
	* @description 
	*/
	public String salesCode { get; set; }

	///** 
	//* @description 
	//*/
	//public String sdAgencyId { get; set; }


	/** 
	* @description 
	*/
	public Integer sicCode { get; set; }

	/** 
	* @description 
	*/
	public String ssn { get; set; }

	/** 
	* @description 
	*/
	public String statementToEmail { get; set; }

	/** 
	* @description 
	*/
	public String statementToFaxno { get; set; }

	///** 
	//* @description 
	//*/
	//public Long threshold { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer threshRef { get; set; }

	///** 
	//* @description 
	//*/
	//public Integer tieCode { get; set; }

	/** 
	* @description 
	*/
	public String title { get; set; }

	///** 
	//* @description 
	//*/
	//public Long usgAmtLimit { get; set; }

	///** 
	//* @description 
	//*/
	//public Long usgUnitsLimit { get; set; }

	/** 
	*@description Connector will translate the value to the correct enumerated Kenan value
	*/
	public Integer vipCode { get; set; }

	/** 
	* @description 
	*/
	public KenanPaymentProfile paymentProfile { get; set; }

	/** 
	* @description 
	*/
	public List<Map<String, String>> extIdList { get; set; }

	/**
	* @description List of Items to be created with the Account
	*/
	public List<KenanAccountItem> accountItems { get; set; }

}