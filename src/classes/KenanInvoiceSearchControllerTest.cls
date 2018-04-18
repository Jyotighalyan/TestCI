@isTest
public class KenanInvoiceSearchControllerTest {
	
	static Set<String> getFieldNames() {
		List<FieldSetMember> fieldSetMembers = SObjectType.InvoiceItem__x.FieldSets.Kenan_Invoice_Search.getFields();

		Set<String> fields = new Set<String>();

		for (FieldSetMember fieldMember: fieldSetMembers) {
			fields.add(fieldMember.getFieldPath());
		}

		return fields;
	}

	@isTest
	static void testConstructor() {
		InvoiceItem__x item = new InvoiceItem__x();
		ApexPages.StandardController stdCon = new ApexPages.StandardController(item);
		Test.startTest();

		KenanInvoiceSearchController extension = new KenanInvoiceSearchController(stdCon);
		Test.stopTest();

		System.assertNotEquals(null, extension);
	}

	@isTest
	static void testClearOptions() {
		InvoiceItem__x item = new InvoiceItem__x();
		ApexPages.StandardController stdCon = new ApexPages.StandardController(item);
		KenanInvoiceSearchController controller = new KenanInvoiceSearchController(stdCon);
		Test.setMock(HttpCalloutMock.class, new KenanInvoiceDetailServiceMock());

		Test.startTest();
		InvoiceItem__x searchItem = (InvoiceItem__x) stdCon.getRecord();
		searchItem.fromDate__c = Datetime.now().addDays(-30);
		searchItem.toDate__c = Datetime.now();
        searchItem.Service__c=null;
            searchItem.acctExternalId__c=null;
		controller.searchInvoices();
		PageReference pageRef = controller.clearOptions();
		Test.stopTest();

		System.assertNotEquals(null, searchItem.fromDate__c);
        System.assertEquals(null, searchItem.acctExternalId__c);
		System.assertEquals(0, controller.getInvoiceSearchResults().size());
		
	}

	//@isTest
	//static void testGetInvoiceSearchResults() {
	//	InvoiceItem__x item = new InvoiceItem__x();
	//	ApexPages.StandardController stdCon = new ApexPages.StandardController(item);
	//	KenanInvoiceSearchController controller = new KenanInvoiceSearchController(stdCon);
	//	Test.setMock(HttpCalloutMock.class, new KenanInvoiceDetailServiceMock());

	//	Test.startTest();
	//	InvoiceItem__x searchItem = (InvoiceItem__x) stdCon.getRecord();
	//	searchItem.fromDate__c = Datetime.now().addDays(-30);
	//	searchItem.toDate__c = Datetime.now();
	//	List<InvoiceItem__x> invoiceItems = controller.getInvoiceSearchResults();
	//	Test.stopTest();

	//	System.assertNotEquals(null, invoiceItems);
	//	System.assert(invoiceItems.isEmpty());
	//}

	//@isTest
	//static void testSearchInvoices() {
	//	KenanInvoiceSearchController controller = new KenanInvoiceSearchController();
	//	controller.invoiceSearchService = new KenanInvoiceServiceMock();
	//	controller.invoiceSearchOptions.billingAccount = 'Test billing account';

	//	Test.startTest();
	//	PageReference pageRef = controller.searchInvoices();
	//	Test.stopTest();

	//	System.assertEquals(null, pageRef);

	//	List<InvoiceItem__x> invoiceResults = controller.getInvoiceSearchResults();

	//	System.assertNotEquals(null, invoiceResults);
	//	System.assert(!invoiceResults.isEmpty());
	//}

	
	
	//@isTest
	//static void testSearchInvoices_ToDateBeforeFromDate() {
	//	KenanInvoiceSearchController controller = new KenanInvoiceSearchController();
	//	controller.invoiceSearchService = new KenanInvoiceServiceMock();
	//	controller.invoiceSearchOptions.billingAccount = 'Test billing account';
	//	controller.invoiceSearchOptions.invoiceItem.fromDate__c = Datetime.newInstance(2016, 07, 06, 0, 0, 0);
	//	controller.invoiceSearchOptions.invoiceItem.toDate__c = Datetime.newInstance(2016, 07, 05, 0, 0, 0);

	//	Test.startTest();
	//	PageReference pageRef = controller.searchInvoices();
	//	Test.stopTest();
	
	//	System.assertEquals(null, pageRef);

	//	List<ApexPages.Message> messages = ApexPages.getMessages();

	//	System.assert(messages.size() > 0);
	//}

	//@isTest
	//static void testSearchInvoices_HighAmountLessThanLowAmount() {
	//	KenanInvoiceSearchController controller = new KenanInvoiceSearchController();
	//	controller.invoiceSearchService = new KenanInvoiceServiceMock();
	//	controller.invoiceSearchOptions.billingAccount = 'Test billing account';
	//	controller.invoiceSearchOptions.lowAmount = '1000';
	//	controller.invoiceSearchOptions.highAmount = '900';

	//	Test.startTest();
	//	PageReference pageRef = controller.searchInvoices();
	//	Test.stopTest();
	
	//	System.assertEquals(null, pageRef);

	//	List<ApexPages.Message> messages = ApexPages.getMessages();

	//	System.assert(messages.size() > 0);
	//}

	//private class KenanInvoiceServiceMock implements KenanInvoiceSearch {

	//	public KenanInvoiceSearchResponse searchInvoices(KenanInvoiceSearchRequest request) {
	//		KenanInvoiceSearchResponse response = new KenanInvoiceSearchResponse();

	//		response.invoiceItems = (List<InvoiceItem__x>) KenanSampleCode.createMockedInvoiceItems();

	//		return response;
	//	}
	//}

	//private class KenanInvoiceServiceErrorMock implements KenanInvoiceSearch {

	//	public KenanInvoiceSearchResponse searchInvoices(KenanInvoiceSearchRequest request) {
	//		KenanInvoiceSearchResponse response = new KenanInvoiceSearchResponse();
	//		response.success = false;
	//		response.error = 'There was an error trying to retrieve invoice items.';
	//		response.invoiceItems = new List<InvoiceItem__x>();

	//		return response;
	//	}
	//}
    public static testmethod void getInvoiceSearchResultstest(){
        test.startTest();
        InvoiceItem__x item = new InvoiceItem__x();
        UM_InvoiceHeader__c  head=new UM_InvoiceHeader__c ();
        head.UM_InvoiceNumber__c ='1000099806-0';
        insert head;
		ApexPages.StandardController stdCon = new ApexPages.StandardController(item);
		KenanInvoiceSearchController controller = new KenanInvoiceSearchController(stdCon);
        controller.getSearchParams();
        controller.viewInvoice();
        controller.getTypeCodes();
        test.stopTest();
        
    }
    public static testmethod void searchInvoicestest(){
        try{
        test.startTest();
               InvoiceItem__x item = new InvoiceItem__x();
        ApexPages.StandardController stdCon = new ApexPages.StandardController(item);
		KenanInvoiceSearchController controller = new KenanInvoiceSearchController(stdCon);
        controller.searchInvoices();
        test.stopTest();
        }
        catch(Exception e){
            
            
            
        }
        
    }
}