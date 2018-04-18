@isTest
public class KenanInvoiceSearchServiceTest {

	@isTest
	static void testSearchInvoices_NoCriteria() {

		KenanInvoiceSearchService service = new KenanInvoiceSearchService();

		KenanInvoiceSearchRequest request = new KenanInvoiceSearchRequest();
		request.invoiceFields = new List<String>{
			'descriptionText__c',
			'fromDate__c',
			'toDate__c',
			'amount__c'
		};

		Test.startTest();
		KenanInvoiceSearchResponse response = service.searchInvoices(request);
		Test.stopTest();

		System.assertNotEquals(null, response);
		System.assert(response.success);
		System.assert(!response.invoiceItems.isEmpty());
	}

	@isTest
	static void testSearchInvoices_HasCriteria() {

		KenanInvoiceSearchService service = new KenanInvoiceSearchService();

		KenanInvoiceSearchRequest request = new KenanInvoiceSearchRequest();
		request.invoiceFields = new List<String>{
			'descriptionText__c',
			'fromDate__c',
			'toDate__c',
			'amount__c'
		};

		request.billingAccount = 'Test Billing Account';
		request.billRefNo = '1.0';
		request.invoiceService = 'Test Service';
		request.fromDate = Date.newInstance(2016, 7, 1);
		request.toDate = Date.newInstance(2016, 8, 1);
		request.lowAmount = '1.00';
		request.highAmount = '1000.00';

		Test.startTest();
		KenanInvoiceSearchResponse response = service.searchInvoices(request);
		Test.stopTest();

		List<sObject> mockedInvoiceItems = KenanSampleCode.createSoqlMockedInvoices();
		Integer invoiceNum = mockedInvoiceItems.size();

		System.assertNotEquals(null, response);
		System.assert(response.success);
		System.assert(!response.invoiceItems.isEmpty());
		System.assertEquals(invoiceNum, response.invoiceItems.size());
	}
    public static testmethod void kenaninvoice(){
        test.startTest();
        
        DateTime myDateTime = DateTime.newInstance(1997, 1, 31, 7, 8, 16);

DateTime expected = DateTime.newInstance(1997, 1, 31, 10, 8, 16);
      
        List<String> invoiceFields=new List<String>();
        invoiceFields.add('value');
        KenanInvoiceSearchRequest request =new KenanInvoiceSearchRequest('billingAccount','invoiceService','billRefNo',myDateTime,expected,'lowAmount','highAmount',invoiceFields);
        test.stopTest();
        
    }
}