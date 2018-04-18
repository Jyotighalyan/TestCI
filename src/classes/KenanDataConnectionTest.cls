@isTest
private class KenanDataConnectionTest {
	
	@testSetup
	static void setup() {
		KenanServiceConnection__c ksc = new KenanServiceConnection__c();
		ksc.Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=';
		ksc.Session_Timeout__c = '120000';
		ksc.Connection_URL__c = 'https://dev-aws-oag-pe.upc.biz';
		ksc.REST_Application_Base__c = '/kenan-salesforce-api/rest';
		insert ksc;
	}

	@isTest
	static void testsync() {
		Test.startTest();
		KenanDataConnection connection = new KenanDataConnection();
		List<DataSource.Table> tables = connection.sync();
		Test.stopTest();
		system.assert(tables.size() > 0);
	}

	@isTest
	static void testquery() {
		KenanInvoiceServiceMock serviceMock = new KenanInvoiceServiceMock();
		serviceMock.numberOfRecords = 1;
		Test.setMock(HttpCalloutMock.class, serviceMock);
		List<DataSource.ColumnSelection> csels = new List<DataSource.ColumnSelection>();
		DataSource.ColumnSelection csel = new DataSource.ColumnSelection();
		csel.aggregation = DataSource.QueryAggregation.NONE;
		csel.columnName = 'ExternalId';
		csel.tableName = 'Invoice';
		csels.add(csel);
		DataSource.TableSelection sel = new DataSource.TableSelection();
		sel.columnsSelected = csels;
		sel.tableSelected = 'Invoice';

		DataSource.Filter fil = new DataSource.Filter();
		fil.columnName = 'ExternalId';
		fil.columnValue = '1401.0';
		fil.tableName = 'Invoice';
		fil.type = DataSource.FilterType.EQUALS;
		sel.filter = fil;

		DataSource.QueryContext context = new DataSource.QueryContext();
		context.tableSelection = sel;
		Test.startTest();
		KenanDataConnection connection = new KenanDataConnection();
		DataSource.TableResult results = connection.query(context);

		Test.stopTest();
		System.assert(results.rows.size() > 0);
	}

	@isTest
	static void testsearch() {
		DataSource.SearchContext context = new DataSource.SearchContext();	
		List<DataSource.TableSelection> selections = new List<DataSource.TableSelection>();

		DataSource.TableSelection selection = new DataSource.TableSelection();
		selection.tableSelected = 'Invoice';
		selections.add(selection);
		context.tableSelections = selections;	
		Test.startTest();
		KenanDataConnection connection = new KenanDataConnection();
		List<DataSource.TableResult> results = connection.search(context);
		Test.stopTest();
		system.assertEquals(null, results[0]);
	}

	@isTest
	static void testupsertRows() {
		DataSource.UpsertContext context = new DataSource.UpsertContext();
		context.TableSelected = 'Invoice';
		List<Map<String, Object>> rows = new List<Map<String, Object>>();
		context.rows = rows;
		KenanInvoiceDetailService service = new KenanInvoiceDetailService();
		
		Test.startTest();
		KenanDataConnection connection = new KenanDataConnection();
		List<DataSource.UpsertResult> results = connection.upsertRows(context);
		Test.stopTest();
		system.assertEquals(null, results);
	}

	@isTest
	static void testdeleteRows() {
		DataSource.DeleteContext context = new DataSource.DeleteContext();
		context.TableSelected = 'Invoice';
		context.ExternalIds = new List<String>();

		Test.startTest();
		KenanDataConnection connection = new KenanDataConnection();
		List<DataSource.DeleteResult> results = connection.deleteRows(context);
		Test.stopTest();
		system.assertEquals(null, results);
	}	
}