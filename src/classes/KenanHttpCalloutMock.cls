@isTest
global class KenanHttpCalloutMock implements HttpCalloutMock {
	global HttpResponse respond ( HTTPRequest req ) {
		HttpResponse res = new HttpResponse();
		res.setHeader ( 'Content-Type', 'application/json' );
		res.setBody ( '{\n' +
		        '  "billFname": "Smith",\n' +
		        '  "billAddress1": "123 Main St.",\n' +
		        '  "billCity": "Allentown",\n' +
		        '  "billState": "PA",\n' +
		        '  "billZip": "18101"\n' +
			'}');
		res.setStatusCode ( 200 );
		System.assertNotEquals ( null, res.getBody(), 'response body should not be null' );
		return res;
	}
}