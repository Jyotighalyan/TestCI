@isTest
private class KenanInvoiceServiceTest {

    @testSetup
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
    }
    
    @isTest
    static void testQuery() {
        KenanInvoiceService service = new KenanInvoiceService();

        List<DataSource.ColumnSelection> csels = new List<DataSource.ColumnSelection>();
        DataSource.ColumnSelection csel = new DataSource.ColumnSelection();
        csel.aggregation = DataSource.QueryAggregation.NONE;
        csel.columnName = 'descriptionCode';
        csel.tableName = 'test';
        csels.add(csel);
               
        DataSource.TableSelection sel = new DataSource.TableSelection();
        sel.columnsSelected = csels;
        sel.tableSelected = 'test';
        sel.filter = new DataSource.Filter();
        sel.filter.columnName = null;
        sel.filter.columnValue = null;
        sel.filter.subfilters = new List<DataSource.Filter>();

        DataSource.Filter fil1 = new DataSource.Filter();
        fil1.columnName = 'accountExternalId';
        fil1.columnValue = 'accountExtId';
        fil1.tableName = 'InvoiceItem';
        fil1.type = DataSource.FilterType.EQUALS;
        sel.filter.subfilters.add(fil1);

        DataSource.Filter fil2 = new DataSource.Filter();
        fil2.columnName = 'accountExternalIdType';
        fil2.columnValue = '2';
        fil2.tableName = 'InvoiceItem';
        fil2.type = DataSource.FilterType.EQUALS;
        sel.filter.subfilters.add(fil2);

        DataSource.Filter fil3 = new DataSource.Filter();
        fil3.columnName = 'ExternalId';
        fil3.columnValue = 'INV1.0';
        fil3.tableName = 'test';
        fil3.type = DataSource.FilterType.EQUALS;
        sel.filter.subfilters.add(fil3);

        DataSource.QueryContext context = new DataSource.QueryContext();
        context.tableSelection = sel;

        KenanInvoiceServiceMock serviceMock = new KenanInvoiceServiceMock();
        serviceMock.numberOfRecords = 1;
        Test.setMock(HttpCalloutMock.class, serviceMock);

        Test.startTest();
        DataSource.TableResult result = service.query(context);
        Test.stopTest();

        System.assertNotEquals(null, result);
       // System.assert(result.rows.size() > 0);
    }

    @isTest
    static void testUpsertRow(){
        setup();
        KenanAdjustment adj = new KenanAdjustment();
        Test.startTest();
        KenanInvoiceService service = new KenanInvoiceService();
        KenanAdjustment adj2 = (KenanAdjustment) service.updateRow(adj, 'PUT', 'COOL');
        System.assertEquals(null, adj2);
    }

    @isTest
    static void testInsertRow(){
        setup();
        KenanAdjustment adj = new KenanAdjustment();
        Test.startTest();
        KenanInvoiceService service = new KenanInvoiceService();
        KenanAdjustment adj2 = (KenanAdjustment) service.insertRow(adj, 'POST', 'COOL');
        System.assertEquals(null, adj2);
    }

    @isTest
    static void testDeleteRow(){
        setup();
        KenanAdjustment adj = new KenanAdjustment();
        Test.startTest();
        KenanInvoiceService service = new KenanInvoiceService();
        Boolean result = service.deleteRow(adj);
        System.assertEquals(false, result);
    }

    @isTest
    static void testUpsertRows(){
        setup();
        Test.setMock(HttpCalloutMock.class, new KenanInvoiceServiceMock());
        Test.startTest();
        DataSource.UpsertContext context = new DataSource.UpsertContext();
        context.TableSelected = 'Invoice';
        List<Map<String, Object>> rows = new List<Map<String, Object>>();
        context.rows = rows;
        KenanInvoiceService service = new KenanInvoiceService();
        List<DataSource.UpsertResult> results = service.upsertRows(context);
        Test.stopTest();
        System.assertEquals(null, results);
    }

    @isTest
    static void testDeleteRows(){
        setup();
        Test.setMock(HttpCalloutMock.class, new KenanInvoiceServiceMock());
        Test.startTest();
        DataSource.DeleteContext context = new DataSource.DeleteContext();
        context.TableSelected = 'Invoice';
        context.ExternalIds = new List<String>();
        KenanInvoiceService service = new KenanInvoiceService();
        List<DataSource.DeleteResult> results = service.deleteRows(context);
        Test.stopTest();
        System.assertEquals(null, results);
    }

    @isTest
    static void testSearch(){
        setup();
        Test.setMock(HttpCalloutMock.class, new KenanInvoiceServiceMock());
        Test.startTest();
        DataSource.TableSelection context = new DataSource.TableSelection();
        context.TableSelected = 'Invoice';
        String searchPhrase = '';
        KenanInvoiceService service = new KenanInvoiceService();
        DataSource.TableResult results = service.search(context, searchPhrase);
        Test.stopTest();
        System.assertEquals(null, results);
    }
}