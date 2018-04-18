/**
  * Class that is used to test the UM_DocumentResponse class
  *
  * @Author: Ferdinand Bondt
  * @Version: 1.0
  */
@isTest
private class UM_DocumentumResponseTest {
    
    @isTest static void testDocumentumCallout() {
        string type='DocumentList';
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new UM_DocumentumResponseMock(type));

		// Call method to test
		String url = '';
		HttpResponse res = UM_DocumentumResponse.getData(url);

		// Verify response received contains fake values
		String contentType = res.getHeader('Content-Type');
		System.assert(contentType == 'application/json');
		String actualValue = res.getBody();
		String expectedValue = '<documents><document id="0901c4138de67958" content_type="pdf"><invoice><number>8849607</number><date>2010-02-05T00:00:00.000+01:00</date><total>0.0</total></invoice></document></documents>';
		System.assertEquals(actualValue, expectedValue);
		System.assertEquals(200, res.getStatusCode());
	}
}