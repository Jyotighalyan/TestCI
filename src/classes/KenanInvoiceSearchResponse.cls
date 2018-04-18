/**
 * Class representing a response for invoice item search
 */
public class KenanInvoiceSearchResponse {
	
	/**
	 * Successful flag
	 */
	public Boolean success { get; set; }

	/**
	 * Error message
	 */
	public String error { get; set; }

	/**
	 * List of invoice item results
	 */
	public List<InvoiceItem__x> invoiceItems { get; set; }


	public KenanInvoiceSearchResponse() { 
		this.success = true;
	}
}