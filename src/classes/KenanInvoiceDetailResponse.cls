/**
 * Class representing a response from querying kenan from invoice details
 */
public class KenanInvoiceDetailResponse {

	/**
	 * Successful flag
	 */
	public Boolean success { get; set; }

	/** 
	 * Invoice items at the account level 
	 */
	public List<InvoiceItem__x> accountLevelInvoiceItems { get; set; }

	/** 
	 * Map of service to invoice items for that service
	 */
	public Map<String, List<InvoiceItem__x>> serviceToInvoiceItems { get; set; }

	/** 
	 * Map of service to its summary invoice item 
	 */
	public Map<String, InvoiceItem__x> serviceToSummaryItem { get; set; }

	/**
	 * List of payments
	 */
	public List<InvoiceItem__x> paymentInvoiceItems { get; set; }

	/**
	 * List of Invoice Total items
	 */
	public List<InvoiceItem__x> invoiceTotalItems { get; set; }

	/**
	 * List of Adjustment items
	 */
	public List<InvoiceItem__x> adjustmentItems { get; set; }

	/**
	 * Account level total
	 */
	public Decimal accountLevelTotal { get; set; }

	/**
	 * Payment total
	 */
	public Decimal paymentTotal { get; set; }

	/**
	 * Service total
	 */
	public Decimal serviceTotal { get; set; }

	/**
	 * Invoice Total
	 */
	public Decimal invoiceTotal { get; set; }

	/**
	 * Invoice Total
	 */
	public Decimal newInvoiceTotal { get; set; }

	/**
	 * Adjustment Total
	 */
	public Decimal adjustmentTotal { get; set; }

	public KenanInvoiceDetailResponse() {
		this.success = true;
		this.accountLevelInvoiceItems = new List<InvoiceItem__x>();
		this.serviceToInvoiceItems = new Map<String, List<InvoiceItem__x>>();
		this.serviceToSummaryItem = new Map<String, InvoiceItem__x>();
		this.paymentInvoiceItems = new List<InvoiceItem__x>();
		this.invoiceTotalItems = new List<InvoiceItem__x>();
		this.adjustmentItems = new List<InvoiceItem__x>();
		this.accountLevelTotal = 0;
		this.paymentTotal = 0;
		this.serviceTotal = 0;
		this.invoiceTotal = 0;
		this.newInvoiceTotal = 0;
		this.adjustmentTotal = 0;
	}
}