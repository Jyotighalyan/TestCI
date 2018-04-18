/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanInvoiceDetailService Unit Tests
*/
@isTest
private class KenanInvoiceDetailServiceTest {
	
	//@testSetup
	private static void setup() {
		KenanServiceConnection__c ksc = new KenanServiceConnection__c();
		ksc.Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=';
		ksc.Session_Timeout__c = '120000';
		ksc.Connection_URL__c = 'https://dev-aws-oag-pe.upc.biz';
		ksc.REST_Application_Base__c = '/kenan-salesforce-api/rest';
		insert ksc;

		Account acct = new Account();
		acct.Name = 'Test Account Name';
		insert acct;

		//TODO: Uncomment after Deployment
        //csconta__Billing_Account__c billAccount = new csconta__Billing_Account__c();
        //insert billAccount;

		UM_InvoiceHeader__c invoiceHeader = new UM_InvoiceHeader__c();
		invoiceHeader.UM_Customer_SF_ID__c = acct.Id;
		invoiceHeader.UM_Invoice_Date__c = Date.today().addDays(-5);
		invoiceHeader.UM_InvoiceNumber__c = '1.0';
		invoiceHeader.UM_Invoice_Amount_Gross_Currency__c = 100.00;
		invoiceHeader.UM_Invoice_Amount_Net_Currency__c = 75.00;
		invoiceHeader.UM_Invoice_Amount_Gross__c = 100;
		invoiceHeader.UM_Invoice_Amount_Net__c = 75;
		invoiceHeader.UM_Payment_Due_Date__c = Date.today().addDays(30);
		//TODO: Uncomment after deployment
		//invoiceHeader.UM_Billing_Location__c = billAccount.Id;
		insert invoiceHeader;

		Kenan_Adjustment__c adj = new Kenan_Adjustment__c();
		adj.Adjustment_Reason__c = 'Incorrect or unapplied charges';
    	adj.Adjustment_Type__c = 'miscellaneous adjustment';
    	adj.RequestStatus__c = 'requested';
		adj.Total_Amount__c = 25;
		adj.Invoice_Header__c = invoiceHeader.Id;

		insert adj;
	}

	private static List<UM_InvoiceHeader__c> getInvoiceHeaders() {
		return [
			SELECT
				UM_Customer_SF_ID__c,
				UM_Invoice_Date__c,
				UM_InvoiceNumber__c,
				UM_Invoice_Amount_Gross_Currency__c,
				UM_Invoice_Amount_Net_Currency__c,
				UM_Invoice_Amount_Gross__c,
				UM_Invoice_Amount_Net__c,
				UM_Payment_Due_Date__c,
                (
                    SELECT
                        Adjustment_Reason__c,
                        Adjustment_Type__c,
                        requestStatus__c,
                        Total_Amount__c
                    FROM
                        Adjustments__r
                )
			FROM
				UM_InvoiceHeader__c
		];
	}

	@isTest
	static void testGetInvoiceHeader() {
		setup();
		List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
		UM_InvoiceHeader__c invoiceHeader = invoiceHeaders.get(0);

		KenanInvoiceDetailService service = new KenanInvoiceDetailService();

		Test.startTest();
		UM_InvoiceHeader__c retrievedInvoiceHeader = service.getInvoiceHeader(invoiceHeader.Id);
		Test.stopTest();

		System.assertEquals(invoiceHeader.UM_Customer_SF_ID__c, retrievedInvoiceHeader.UM_Customer_SF_ID__c);
		System.assertEquals(invoiceHeader.UM_Invoice_Date__c, retrievedInvoiceHeader.UM_Invoice_Date__c);
		System.assertEquals(invoiceHeader.UM_InvoiceNumber__c, retrievedInvoiceHeader.UM_InvoiceNumber__c);
		System.assertEquals(invoiceHeader.UM_Invoice_Amount_Gross_Currency__c, retrievedInvoiceHeader.UM_Invoice_Amount_Gross_Currency__c);
		System.assertEquals(invoiceHeader.UM_Invoice_Amount_Gross__c, retrievedInvoiceHeader.UM_Invoice_Amount_Gross__c);
		System.assertEquals(invoiceHeader.UM_Invoice_Amount_Net__c, retrievedInvoiceHeader.UM_Invoice_Amount_Net__c);
		System.assertEquals(invoiceHeader.UM_Payment_Due_Date__c, retrievedInvoiceHeader.UM_Payment_Due_Date__c);

		System.assertEquals(1, retrievedInvoiceHeader.Adjustments__r.size());

		Kenan_Adjustment__c adj = (Kenan_Adjustment__c) invoiceHeader.Adjustments__r.get(0);
		Kenan_Adjustment__c retrievedAdjustment = retrievedInvoiceHeader.Adjustments__r.get(0);

		System.assertEquals(adj.Adjustment_Reason__c, retrievedAdjustment.Adjustment_Reason__c);
		System.assertEquals(adj.Adjustment_Type__c, retrievedAdjustment.Adjustment_Type__c);
		System.assertEquals(adj.requestStatus__c, retrievedAdjustment.requestStatus__c);
		System.assertEquals(adj.Total_Amount__c, retrievedAdjustment.Total_Amount__c);
	}

	@isTest
	static void testGetInvoiceHeaderFieldSet() {
		setup();
		List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
		UM_InvoiceHeader__c invoiceHeader = invoiceHeaders.get(0);

		KenanInvoiceDetailService service = new KenanInvoiceDetailService();

		Test.startTest();
		UM_InvoiceHeader__c retrievedInvoiceHeader = service.getInvoiceHeader(invoiceHeader.Id, 'InvoiceHeader');
		Test.stopTest();

		System.assertEquals(invoiceHeader.UM_Customer_SF_ID__c, retrievedInvoiceHeader.UM_Customer_SF_ID__c);
		System.assertEquals(invoiceHeader.UM_Invoice_Date__c, retrievedInvoiceHeader.UM_Invoice_Date__c);
		System.assertEquals(invoiceHeader.UM_InvoiceNumber__c, retrievedInvoiceHeader.UM_InvoiceNumber__c);
		System.assertEquals(invoiceHeader.UM_Invoice_Amount_Gross_Currency__c, retrievedInvoiceHeader.UM_Invoice_Amount_Gross_Currency__c);
		System.assertEquals(invoiceHeader.UM_Invoice_Amount_Gross__c, retrievedInvoiceHeader.UM_Invoice_Amount_Gross__c);
		System.assertEquals(invoiceHeader.UM_Invoice_Amount_Net__c, retrievedInvoiceHeader.UM_Invoice_Amount_Net__c);
		System.assertEquals(invoiceHeader.UM_Payment_Due_Date__c, retrievedInvoiceHeader.UM_Payment_Due_Date__c);

		System.assertEquals(1, retrievedInvoiceHeader.Adjustments__r.size());

		Kenan_Adjustment__c adj = (Kenan_Adjustment__c) invoiceHeader.Adjustments__r.get(0);
		Kenan_Adjustment__c retrievedAdjustment = retrievedInvoiceHeader.Adjustments__r.get(0);

		System.assertEquals(adj.Adjustment_Reason__c, retrievedAdjustment.Adjustment_Reason__c);
		System.assertEquals(adj.Adjustment_Type__c, retrievedAdjustment.Adjustment_Type__c);
		System.assertEquals(adj.requestStatus__c, retrievedAdjustment.requestStatus__c);
		System.assertEquals(adj.Total_Amount__c, retrievedAdjustment.Total_Amount__c);
	}


	@isTest
	static void testQueryInvoiceItems() {
		setup();
		KenanInvoiceDetailService service = new KenanInvoiceDetailService();

		Test.startTest();
		KenanInvoiceDetailResponse response = service.queryInvoiceItems('Field1, Field2, Field3', '1.0');
		Test.stopTest();

		System.assert(response.success);
		System.assert(response.accountLevelInvoiceItems.isEmpty());
		System.assert(response.serviceToInvoiceItems.isEmpty());
		//System.assert(!response.serviceToSummaryItem.isEmpty());
		//System.assert(!response.paymentInvoiceItems.isEmpty());
	}

	@isTest
	static void testQuery() {

		KenanServiceConnection__c ksc = new KenanServiceConnection__c();
		ksc.Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=';
		ksc.Session_Timeout__c = '120000';
		ksc.Connection_URL__c = 'https://dev-aws-oag-pe.upc.biz';
		ksc.REST_Application_Base__c = '/kenan-salesforce-api/rest';
		insert ksc;

		KenanInvoiceDetailService service = new KenanInvoiceDetailService();

		List<DataSource.ColumnSelection> csels = new List<DataSource.ColumnSelection>();
		DataSource.ColumnSelection csel = new DataSource.ColumnSelection();
		csel.aggregation = DataSource.QueryAggregation.NONE;
		csel.columnName = 'descriptionCode';
		csel.tableName = 'test';
		csels.add(csel);
		       
		DataSource.TableSelection sel = new DataSource.TableSelection();
		sel.columnsSelected = csels;
		sel.tableSelected = 'test';

		DataSource.Filter fil = new DataSource.Filter();
		fil.columnName = 'Invoice';
		fil.columnValue = 'INV1.0';
		fil.tableName = 'test';
		fil.type = DataSource.FilterType.EQUALS;
		sel.filter = fil;

		DataSource.QueryContext context = new DataSource.QueryContext();
		context.tableSelection = sel;

		KenanInvoiceDetailServiceMock serviceMock = new KenanInvoiceDetailServiceMock();
		Test.setMock(HttpCalloutMock.class, serviceMock);

		Test.startTest();
		DataSource.TableResult result = service.query(context);
		Test.stopTest();

		System.assertNotEquals(null, result);
		System.assert(result.rows.size() > 0);
	}

	@isTest
	static void testUpsertRow(){
		setup();
		KenanAdjustment adj = new KenanAdjustment();
		Test.startTest();
		KenanInvoiceDetailService service = new KenanInvoiceDetailService();
		KenanAdjustment adj2 = (KenanAdjustment) service.updateRow(adj, 'PUT', 'COOL');
		System.assertEquals(null, adj2);
	}

	@isTest
	static void testInsertRow(){
		setup();
		KenanAdjustment adj = new KenanAdjustment();
		Test.startTest();
		KenanInvoiceDetailService service = new KenanInvoiceDetailService();
		KenanAdjustment adj2 = (KenanAdjustment) service.insertRow(adj, 'POST', 'COOL');
		System.assertEquals(null, adj2);
	}

	@isTest
	static void testDeleteRow(){
		setup();
		KenanAdjustment adj = new KenanAdjustment();
		Test.startTest();
		KenanInvoiceDetailService service = new KenanInvoiceDetailService();
		Boolean result = service.deleteRow(adj);
		System.assertEquals(false, result);
	}

	@isTest
	static void testUpsertRows(){
		setup();
		Test.setMock(HttpCalloutMock.class, new KenanInvoiceDetailServiceMock());
		Test.startTest();
		DataSource.UpsertContext context = new DataSource.UpsertContext();
		context.TableSelected = 'InvoiceItem';
		List<Map<String, Object>> rows = new List<Map<String, Object>>();
		context.rows = rows;
		KenanInvoiceDetailService service = new KenanInvoiceDetailService();
		List<DataSource.UpsertResult> results = service.upsertRows(context);
		Test.stopTest();
		System.assertEquals(0, results.size());
	}

	@isTest
	static void testDeleteRows(){
		setup();
		Test.setMock(HttpCalloutMock.class, new KenanInvoiceDetailServiceMock());
		Test.startTest();
		DataSource.DeleteContext context = new DataSource.DeleteContext();
		context.TableSelected = 'InvoiceItem';
		context.ExternalIds = new List<String>();
		KenanInvoiceDetailService service = new KenanInvoiceDetailService();
		List<DataSource.DeleteResult> results = service.deleteRows(context);
		Test.stopTest();
		System.assertEquals(null, results);
	}

	@isTest
	static void testSearch(){
		setup();
		Test.setMock(HttpCalloutMock.class, new KenanInvoiceDetailServiceMock());
		Test.startTest();
		DataSource.TableSelection context = new DataSource.TableSelection();
		context.TableSelected = 'InvoiceItem';
		String searchPhrase = '';
		KenanInvoiceDetailService service = new KenanInvoiceDetailService();
		DataSource.TableResult results = service.search(context, searchPhrase);
		Test.stopTest();
		System.assertEquals(null, results);
	}

	@isTest
	static void testSetEndPoint() {
		KenanServiceConnection__c ksc = new KenanServiceConnection__c();
		ksc.BillRefNo_BillRefResets_delimiter__c = '-';
		insert ksc;

		KenanInvoiceDetailService service = new KenanInvoiceDetailService();
		DataSource.Filter filter = new DataSource.Filter();
		List<DataSource.Filter> subFilters = new List<DataSource.Filter>();
		DataSource.Filter subFilter = new DataSource.Filter();

		subFilter.columnName = 'Invoice';
		subFilter.columnValue = '5123.53';

		subFilters.add(subFilter);
		filter.subfilters = subFilters;

		service.setEndPoint(filter);
	}

	@isTest
	static void testSetEndPointMultiple() {
		KenanServiceConnection__c ksc = new KenanServiceConnection__c();
		ksc.BillRefNo_BillRefResets_delimiter__c = '-';
		insert ksc;

		KenanInvoiceDetailService service = new KenanInvoiceDetailService();
		DataSource.Filter filter = new DataSource.Filter();
		List<DataSource.Filter> subFilters = new List<DataSource.Filter>();
		DataSource.Filter subFilter = new DataSource.Filter();

		subFilter.columnName = 'otherVoice';
		subFilter.columnValue = '5123.53';

		subFilters.add(subFilter);
		filter.subfilters = subFilters;

		service.setEndPoint(filter);
	}

}