/**
 * Main invoice item search service class
 */
public class KenanInvoiceSearchService implements KenanInvoiceSearch {
	public static final String KEYWORD_WHERE = ' WHERE ';
	public static final String KEYWORD_AND = ' AND ';

	/**
	 * Searches invoices based on certain search criteria 
	 * @param request the request containing the criteria to search
	 * @return a response containing matched invoice items
	 */
	public KenanInvoiceSearchResponse searchInvoices(KenanInvoiceSearchRequest request) {
		KenanInvoiceSearchResponse response = new KenanInvoiceSearchResponse();

		String fieldStr = buildFieldStr(request.invoiceFields);
		String whereClause = buildWhereClause(request);

		String query = 'SELECT InvoiceHeader__c, ' +
						String.escapeSingleQuotes(fieldStr) +
						' FROM InvoiceItem__x' +
						whereClause;
		System.debug(LoggingLevel.WARN, 'QUERY --> ' + query);
		try {
			List<sObject> searchResults;

			// Because we cannot test insert external objects
			if (!Test.isRunningTest()) {
				searchResults = Database.query(query);
			} else {
				searchResults = KenanSampleCode.createSoqlMockedInvoices();
			}
			
			response = buildInvoiceSearchResponse(searchResults);	
		} catch (Exception e) {
			response.success = false;
			response.error = e.getMessage();
		}

		return response;
	}

	/**
	 * Build a comma separated list of field names
	 * @param fields the list of fields to query
	 * @return String
	 */
	private String buildFieldStr(List<String> fields) {
		return String.join(fields, ', ');
	}

	/**
	 * Build a SOSL where clause that contains the object to query and the field filters
	 * @param request the request object containing filter criteria
	 * @return String
	 */
	private String buildWhereClause(KenanInvoiceSearchRequest request) {
		if (String.isEmpty(request.billingAccount) && String.isEmpty(request.invoiceService) && 
			request.fromDate == null && request.toDate == null && 
			request.lowAmount == null && request.highAmount == null &&
			request.billRefNo == null) {
			return '';
		}

		List<String> fieldValues = new List<String>();

		/* 
		 * Once we know where the service is coming from, we can include the search option in the query
		 * Also need to pass in serviceExternalIdType
		 */

		/* 
		if (!String.isEmpty(request.invoiceService)) {
			fieldValues.add('serviceExternalId__c = \'' + String.escapeSingleQuotes(request.invoiceService) + '\'');
		}
		*/

		/*
		 * Once we know where billing account is coming from, we can include the search option in the query
		 * Also need to pass in acctExternalIdType
		 */
		/* 
		if (!String.isEmpty(request.billingAccount)) {
			fieldValues.add('accountExternalId__c = \'' + String.escapeSingleQuotes(request.billingAccount) + '\'');
		}
		*/

		if (!String.isEmpty(request.billRefNo)) {
			fieldValues.add('billRefNo__c = ' + request.billRefNo);
		}

		if (request.fromDate != null) {
			fieldValues.add('fromDate__c = ' + String.escapeSingleQuotes(Datetime.newInstance(request.fromDate.year(),request.fromDate.month(),request.fromDate.day()).format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')));
		}

		if (request.toDate != null) {
			fieldValues.add('toDate__c = ' + String.escapeSingleQuotes(Datetime.newInstance(request.toDate.year(),request.toDate.month(),request.toDate.day()).format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')));
		}
		
		if (!String.isEmpty(request.lowAmount)) {
			fieldValues.add('amount__c >= ' + request.lowAmount);
		}
		
		if (!String.isEmpty(request.highAmount)) {
			fieldValues.add('amount__c <= ' + request.highAmount);
		}

		String whereClause = KEYWORD_WHERE + String.join(fieldValues, KEYWORD_AND);

		return whereClause;
	}

	/**
	 * Build the response containing the results of the SOSL query
	 * @param searchResults the list of objects and records as the result of SOSL query
	 * @return KenanInvoiceSearchResponse
	 */
	private KenanInvoiceSearchResponse buildInvoiceSearchResponse(List<sObject> searchResults) {
		KenanInvoiceSearchResponse response = new KenanInvoiceSearchResponse();

		response.invoiceItems = (List<InvoiceItem__x>) searchResults;

		return response;
	}
}