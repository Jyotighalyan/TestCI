@isTest
global class KenanHttpCalloutMockDelete implements HttpCalloutMock {
	global HttpResponse respond ( HTTPRequest req ) {
		HttpResponse res = new HttpResponse();
		res.setHeader ( 'Content-Type', 'application/json' );
		res.setBody ( '{\n' +
        '  "Result" : true\n' +
        '}');
		res.setStatusCode ( 200 );
		System.assertNotEquals ( null, res.getBody(), 'response body should not be null' );
		return res;
	}
}