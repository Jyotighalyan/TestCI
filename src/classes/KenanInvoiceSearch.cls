/**
 * Interface that defines methods for searching for invoice items.
 */
public interface KenanInvoiceSearch {
	
	/**
	 * Searches invoices based on certain search criteria 
	 * @param request the request containing the criteria to search
	 * @return a response containing matched invoice items
	 */
	KenanInvoiceSearchResponse searchInvoices(KenanInvoiceSearchRequest request);
}