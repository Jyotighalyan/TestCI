/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanInvoiceSearchController Controller Extension used with KenanInvoiceSearch VF Page
*/

public with sharing class KenanInvoiceSearchController {

	private List<InvoiceItem__x> searchResults;
	private final String EQUALS = ' = ';
	private final String ANDVALUE = ' AND ';
	private KenanServiceConnection__c settings;
	private ApexPages.StandardController con;

	public InvoiceItem__x invoiceSearchParams { get; set; }

	public String billRefNo { get; set;}
	public String billRefResets { get; set;}
	

	public KenanInvoiceSearchController(ApexPages.StandardController controller) {
		this.con = controller;
		this.invoiceSearchParams = (InvoiceItem__x) controller.getRecord();
		this.settings = KenanServiceConnection__c.getInstance();

    }

	/**
	 * Retrieve the list of invoice items
	 * @return List<InvoiceItem__x>
	 */
	public List<InvoiceItem__x> getInvoiceSearchResults() {
		return this.searchResults;
	}

	public InvoiceItem__x getSearchParams(){
		return this.invoiceSearchParams;
	}

	public PageReference viewInvoice(){
		PageReference pr;
		system.debug('viewInvoice:' + billRefNo + ':' + billRefResets);
		String invoiceNumber = billRefNo + settings.BillRefNo_BillRefResets_delimiter__c + billRefResets;
		List<UM_InvoiceHeader__c> invoices = [Select Id FROM UM_InvoiceHeader__c WHERE UM_InvoiceNumber__c = :invoiceNumber];
		if (!invoices.isEmpty()){
			pr = new ApexPages.StandardController(invoices[0]).view();

			pr.setRedirect(true);
		}
		else{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, System.Label.KenanInvoiceNotFound));
		}
		return pr;
	}

    /**
     * Search for invoice item detail records given the input parameters
     * @return PageReference
     */
	public void searchInvoices() {
		if ((invoiceSearchParams.get('fromDate__c') == null || invoiceSearchParams.get('toDate__c') == null)
			&& invoiceSearchParams.get('acctExternalId__c') == null && invoiceSearchParams.get('Service__c') == null) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,
				'At least From and To date, Account, or Service must be populated to run a search.'));
			return;
		}
		
		String soqlQuery = buildSOQLQuery();
		System.debug('soqlQuery:' + soqlQuery);
		try {
			this.searchResults = (List<InvoiceItem__x>) Database.query(soqlQuery);
			System.debug('searchInvoices searchResults:' + searchResults);			
		} catch (Exception e){
			System.debug('searchInvoices exception:' + e);
			if (e instanceOf KenanException){
				KenanException ke = (KenanException) e;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ke.friendlyErrorMessage + '\n' + ke.message));	
			}
			
		}
	}

	/**
     * Clears the search options input fields and the search results list
     * @return PageReference
     */
	public PageReference clearOptions() {
		initializeSearchOptionsAndResults();
		return null;
	}


	/**
	 * Re-initializes the search option input fields and search results list
	 * @return none
	 */
	private void initializeSearchOptionsAndResults() {
		this.invoiceSearchParams = new InvoiceItem__x();
		this.searchResults = new List<InvoiceItem__x>();
		billRefNo = '';
		billRefResets = '';
	}

	private String buildSOQLQuery(){
		String soqlQuery = 'SELECT ';
		List<FieldSetMember> resultMembers = SObjectType.InvoiceItem__x.FieldSets.KenanInvoiceSearchResults.getFields();
		
		for (FieldSetMember resultMember : resultMembers){
			soqlQuery = soqlQuery + resultMember.getFieldPath() + ',';
		}
		
		soqlQuery = soqlQuery.removeEnd(',');
		soqlQuery = soqlQuery + ' FROM InvoiceItem__x ';

		List<FieldSetMember> searchMembers = SObjectType.InvoiceItem__x.FieldSets.kenan_invoice_search.getFields();
		Map<String, Object> params = new Map<String, Object>();
		for (FieldSetMember searchMember : searchMembers){
			if (invoiceSearchParams.get(searchMember.getFieldPath()) != null){
				
				if (searchMember.getType() == Schema.DisplayType.Date){
						String[] dateArray = String.valueOf(invoiceSearchParams.get(searchMember.getFieldPath())).split(' ');
						params.put(searchMember.getFieldPath(), + dateArray[0]);	
				}
				else if (searchMember.getType() == Schema.DisplayType.DateTime){
					//String[] dateArray = String.valueOf(invoiceSearchParams.get(searchMember.getFieldPath())).split(' ');
					String dateformated = DateTime.valueOf(invoiceSearchParams.get(searchMember.getFieldPath())).format('yyyy-MM-dd\'T \'HH:mm:ss.SSSZ').remove(' ');
					params.put(searchMember.getFieldPath(), + dateformated);	
				}
				else if (searchMember.getType() == Schema.DisplayType.Reference){
					System.debug('Setting Reference Field:' + searchMember.getFieldPath());
					if (searchMember.getFieldPath() == 'acctExternalId__c') {
						params.put('accountExternalId__c', '\'' + invoiceSearchParams.get(searchMember.getFieldPath()) + '\'');
						params.put('accountExternalIdType__c', settings.Default_Account_External_IdType__c);

					}

					if (searchMember.getFieldPath() == 'Service__c') {
						params.put('serviceExternalId__c', '\'' + invoiceSearchParams.get(searchMember.getFieldPath()) + '\'');
						params.put('serviceExternalIdType__c', settings.Default_Service_External_IdType__c);
					}
				}
				else if (searchMember.getFieldPath() == 'typeCode__c'){
					if (invoiceSearchParams.get(searchMember.getFieldPath()) != null && invoiceSearchParams.get(searchMember.getFieldPath()) != '--None--'){
						params.put('typeCode__c', '\'' + invoiceSearchParams.get(searchMember.getFieldPath()) + '\'');
					}
				}
				else {
					params.put(searchMember.getFieldPath(), invoiceSearchParams.get(searchMember.getFieldPath()));	
				}
			}	
		}

		String whereClause = 'WHERE ';
		if (!params.isEmpty()){
			for (String key : params.keySet()){
				whereClause = whereClause + key + EQUALS + params.get(key) + ANDVALUE;
			}
			whereClause = whereClause.removeEnd(ANDVALUE);
		}
		System.debug('buildSOQLQuery:' + soqlQuery + whereClause);
		return soqlQuery + whereClause;	
	}

	public List<SelectOption> getTypeCodes(){
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('--None--', '--None--'));
		List<InvoiceTypeCode__mdt> typeCodes = [SELECT MasterLabel, Id FROM InvoiceTypeCode__mdt];
		for (InvoiceTypeCode__mdt typeCode : typeCodes){
			SelectOption item = new SelectOption(typeCode.MasterLabel, typeCode.MasterLabel);
			options.add(item);
		}
		return options;
	}
}