@isTest
global class MockHttpResponseGeneratorConga implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('GET', req.getMethod());
        HttpResponse res = new HttpResponse();
        opportunity opp=[Select id,name from Opportunity LIMIT 1];
        String pdfContent = 'This is a test string';
        Attachment attachmentPDF = new Attachment();
        attachmentPdf.parentId = opp.id;
        attachmentPdf.name = opp.name + '.pdf';
        attachmentPdf.body = blob.toPDF(pdfContent);
        insert attachmentPDF;
        System.debug('attachment'+attachmentPDF.id+'--'+opp.id);
        res.setHeader('Content-Type', 'application/pdf'); 
        res.setBody(attachmentPDF.id);
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}