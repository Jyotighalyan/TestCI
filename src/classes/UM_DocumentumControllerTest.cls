/**
  * Class that is used to test the UM_DocumentumController class
  *
  * @Author: Ferdinand Bondt
  * @Version: 1.0
  */
@isTest
private class UM_DocumentumControllerTest {
    
    @isTest static void testController() {
        
        UM_DocumentumResponseMock umdr = new UM_DocumentumResponseMock('DocumentList');
        Test.setMock(HttpCalloutMock.class, umdr);

		UM_DocumentumController umdc = new UM_DocumentumController();
		List<UM_DocumentumController.Document> documentList = umdc.documentList('test');

        System.assertEquals(documentList[0].documentId, '0901c4138de67958');
        System.assertEquals(documentList[0].documentType, 'pdf');
        System.assertEquals(documentList[0].documentNumber, '8849607');
        System.assertEquals(documentList[0].documentDate, '2010-02-05T00:00:00.000+01:00');
        System.assertEquals(documentList[0].documentTotal, '0.0');
    }
    @isTest static void testfetchInvoicesSuccess() {
        
        UM_DocumentumResponseMock umdr = new UM_DocumentumResponseMock('InvoiceSuccess');
        Test.setMock(HttpCalloutMock.class, umdr);

        UM_DocumentumController umdc = new UM_DocumentumController();
        ApexPages.currentPage().getParameters().put('invoiceno','106654');
        umdc.fetchInvoivesPDF();
        system.debug('url#'+umdc.getUrl());
        String decodedStr = (EncodingUtil.Base64Decode(umdc.getUrl())).toString();
        system.debug('de~'+decodedStr );
        System.assertEquals(decodedStr , 'test pdf');
        
    }
    @isTest static void testfetchCDRSuccess() {
        
        UM_DocumentumResponseMock umdr = new UM_DocumentumResponseMock('InvoiceSuccess');
        Test.setMock(HttpCalloutMock.class, umdr);

        UM_DocumentumController umdc = new UM_DocumentumController();
        ApexPages.currentPage().getParameters().put('invoiceno','106654');
        ApexPages.currentPage().getParameters().put('itemised_bill','1');
        umdc.fetchInvoivesPDF();
        system.debug('url#'+umdc.getUrl());
        String decodedStr = (EncodingUtil.Base64Decode(umdc.getUrl())).toString();
        system.debug('de~'+decodedStr );
        System.assertEquals(decodedStr , 'test pdf');
        
    }
    @isTest static void testfetchInvoicesFailure() {
        
        UM_DocumentumResponseMock umdr = new UM_DocumentumResponseMock('InvoiceFailure');
        Test.setMock(HttpCalloutMock.class, umdr);

        UM_DocumentumController umdc = new UM_DocumentumController();
        ApexPages.currentPage().getParameters().put('invoiceno','106654');
        umdc.fetchInvoivesPDF();

        System.assertEquals(umdc.getisError(),true);
        
    }
    @isTest static void testfetchInvoicesAuthorization() {
        
        UM_DocumentumResponseMock umdr = new UM_DocumentumResponseMock('InvoiceAuthorization');
        Test.setMock(HttpCalloutMock.class, umdr);

        UM_DocumentumController umdc = new UM_DocumentumController();
        ApexPages.currentPage().getParameters().put('invoiceno','106654');
        umdc.fetchInvoivesPDF();

        System.assertEquals(umdc.getisError(),true);
        
    }
}