/**
 * Class representing a request for searching invoice items
 */
public class KenanInvoiceSearchRequest {
	
	/**
	 * Invoice Billing account
	 */
	public String billingAccount { get; set; }

	/**
	 * Invoice service
	 */
	public String invoiceService { get; set; }

	/**
	 * Invoice bill reference number
	 */
	public String billRefNo { get; set; }

	/**
	 * Invoice From Date
	 */
	public Date fromDate { get; set; }

	/**
	 * Invoice To Date
	 */
	public Date toDate { get; set; }

	/**
	 * Invoice low amount
	 */
	public String lowAmount { get; set; }

	/**
	 * Invoice high amount
	 */
	public String highAmount { get; set; }

	/**
	 * Fields to return in search
	 */
	public List<String> invoiceFields { get; set; }

	public KenanInvoiceSearchRequest() {}

	public KenanInvoiceSearchRequest(
		String billingAccount, 
		String invoiceService, 
		String billRefNo,
		Datetime fromDate, 
		Datetime toDate, 
		String lowAmount,
		String highAmount,
		List<String> invoiceFields) { 
		this.billingAccount = billingAccount;
		this.invoiceService = invoiceService;
		this.billRefNo = billRefNo;
		this.fromDate = (fromDate != null) ? Date.newInstance(fromDate.year(), fromDate.month(), fromDate.day()): null;
		this.toDate = (toDate != null) ? Date.newInstance(toDate.year(), toDate.month(), toDate.day()): null;
		this.lowAmount = lowAmount;
		this.highAmount = highAmount;
		this.invoiceFields = invoiceFields;
	}
}