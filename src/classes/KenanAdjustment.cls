/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanAdjustment for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanAdjustment extends KenanObject {
	
	public KenanAdjustment() {
		
	}
		
	public String accountExternalId { get; set; }
	public Integer accountExternalIdType { get; set; }
	public Integer accountInternalId { get; set; }
	public String adjReasonCode { get; set; }
	public Decimal billRefNo { get; set; }
	public Decimal billRefResets { get; set; }
	public String currencyCode { get; set; }
	public DateTime effectiveDate { get; set; }
	public String fraudIndicator { get; set; }
	//public String invoice { get; set; }
	public String invoiceItem { get; set; }
	public String origType { get; set; }
	public String openItemId { get; set; }
	public String primaryUnits { get; set; }
	public String primaryUnitsType { get; set; }
	public String requestStatus { get; set; }
	public String revRcvCostCtr { get; set; }
	public Decimal totalAmt { get; set; }
	public String trackingId { get; set; }
	public String trackingIdServ { get; set; }
	public String approvedBy { get; set; }
	public String approvalStatus { get; set; }

}