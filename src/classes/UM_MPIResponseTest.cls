/**
  * Class that is used to test the UM_MPIResponse class
  *
  * @Author: Ferdinand Bondt
  * @Version: 1.0
  */
@isTest
private class UM_MPIResponseTest {
	
	@isTest static void testMPICallout() {
		// Set mock callout class 
		Test.setMock(HttpCalloutMock.class, new UM_MPIResponseMock());

		// Call method to test
		String boundary = 'test';
		Blob bodyBlob = EncodingUtil.base64Decode(boundary);
		HttpResponse res = UM_MPIResponse.sendData(boundary, bodyBlob);

		// Verify response received contains fake values
		String contentType = res.getHeader('Content-Type');
		System.assert(contentType == 'application/json');
		String actualValue = res.getBody();
		String expectedValue = 'It is delivered';
		System.assertEquals(actualValue, expectedValue);
		System.assertEquals(200, res.getStatusCode());
	}
}