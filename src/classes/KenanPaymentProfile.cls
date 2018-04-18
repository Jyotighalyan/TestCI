/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Payment Profile Data structure for use in Salesforce Kenan Connection Service
*/
public class KenanPaymentProfile extends KenanObject {

	public KenanPaymentProfile() {
		this.accountExternalIdType = 2;
	}

	/** 
	* @description 
	*/
	public String accountExternalId { get; set; }

	/** 
	* @description 
	*/
	public Integer accountExternalIdType { get; set; }

	/** 
	* @description 
	*/
	public Integer accountInternalId { get; set; }

	/** 
	* @description 
	*/
	public String altBankAccNum { get; set; }
	
	/** 
	* @description 
	*/
	public Integer avsAddressId { get; set; }
	
	/** 
	* @description 
	*/
	public String avsResponseCode { get; set; }
	
	/** 
	* @description 
	*/
	public Integer bankAccountType { get; set; }
	
	/** 
	* @description 
	*/
	public String bankAgencyCode { get; set; }
	
	/** 
	* @description 
	*/
	public String bankAgencyName { get; set; }
	
	/** 
	* @description 
	*/
	public String bankCode { get; set; }
	
	/** 
	* @description 
	*/
	public Long billCompanyTaxId { get; set; }
	
	/** 
	* @description 
	*/
	public String branchCode { get; set; }
	
	/** 
	* @description 
	*/
	public String branchName { get; set; }

	/** 
	* @description 
	*/
	public String cardAccount { get; set; }

	/** 
	* @description 
	*/
	public String cardCarrier { get; set; }

	/** 
	* @description 
	*/
	public String cardExpire { get; set; }

	/** 
	* @description 
	*/
	public String clearingHouseId { get; set; }

	/** 
	* @description 
	*/
	public String custBankAccNum { get; set; }

	/** 
	* @description 
	*/
	public String custBankAccOwner { get; set; }

	/** 
	* @description 
	*/
	public String custBankAcctType { get; set; }
	
	/** 
	* @description 
	*/
	public String custBankBic { get; set; }

	/** 
	* @description 
	*/
	public String custBankBicHist { get; set; }

	/** 
	* @description 
	*/
	public String custBankIban { get; set; }

	/** 
	* @description 
	*/
	public String custBankIbanHist { get; set; }

	/** 
	* @description 
	*/
	public String custBankSortCode { get; set; }

	/** 
	* @description 
	*/
	public String custBillAddress { get; set; }

	/** 
	* @description 
	*/
	public String custBillCity { get; set; }

	/** 
	* @description 
	*/
	public Integer custBillCountryCode { get; set; }

	/** 
	* @description 
	*/
	public String custBillState { get; set; }

	/** 
	* @description 
	*/
	public String custBillZip { get; set; }

	/** 
	* @description 
	*/
	public String custCompanyName { get; set; }

	/** 
	* @description 
	*/
	public String custEmail { get; set; }

	/** 
	* @description 
	*/
	public String custPhone { get; set; }

	/** 
	* @description 
	*/
	public Boolean cyclicalBillUsed { get; set; }

	/** 
	* @description 
	*/
	public String diffAcctOwnFlag { get; set; }

	/** 
	* @description 
	*/
	public String driverLicenseNum { get; set; }

	/** 
	* @description 
	*/
	public String driverLicenseState { get; set; }

	/** 
	* @description 
	*/
	public String epgSubscriptionId { get; set; }

	/** 
	* @description 
	*/
	public Boolean isDefault { get; set; }

	/** 
	* @description 
	*/
	public Boolean isTemporary { get; set; }

	/** 
	* @description 
	*/
	public String mandateId { get; set; }

	/** 
	* @description 
	*/
	public String mandateReset { get; set; }

	/** 
	* @description 
	*/
	public DateTime mandateSignDate { get; set; }

	/** 
	* @description 
	*/
	public String mandateStatus { get; set; }

	/** 
	* @description 
	*/
	public String newCustBankSortCode { get; set; }

	/** 
	* @description 
	*/
	public Boolean nonRealtimeOnly { get; set; }

	/** 
	* @description 
	*/
	public String ownrFname { get; set; }

	/** 
	* @description 
	*/
	public String ownrLname { get; set; }

	/** 
	* @description 
	*/
	public Integer paymentMerchantId { get; set; }

	/** 
	* @description 
	*/
	public String payMethod { get; set; }

	/** 
	* @description 
	*/
	public DateTime profileCreationTime { get; set; }

	/** 
	* @description 
	*/
	public String referenceNumber { get; set; }

	/** 
	* @description 
	*/
	public String sequenceType { get; set; }
	
	/** 
	* @description 
	*/
	public Integer status { get; set; }

	/** 
	* @description 
	*/
	public String transactionUuid { get; set; }

	/** 
	* @description 
	*/
	public String transFlag { get; set; }

}