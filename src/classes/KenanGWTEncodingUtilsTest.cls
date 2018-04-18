@isTest
private class KenanGWTEncodingUtilsTest {
		
	@isTest static void testUrlEncode() {
		System.assertEquals(null, KenanGWTEncodingUtils.urlEncode(null));
		System.assertEquals('1234', KenanGWTEncodingUtils.urlEncode('1234'));
		System.assertEquals('12%2034', KenanGWTEncodingUtils.urlEncode('12 34'));
		System.assertEquals('12%2534', KenanGWTEncodingUtils.urlEncode('12%34'));
	}
	
	@isTest static void testCharAt() {
		System.assertEquals(null, KenanGWTEncodingUtils.charAt(null, 0));
		System.assertEquals('', KenanGWTEncodingUtils.charAt('', 0));
		System.assertEquals(null, KenanGWTEncodingUtils.charAt(' ', -1));
		System.assertEquals(null, KenanGWTEncodingUtils.charAt(' ', 4));
		System.assertEquals('t', KenanGWTEncodingUtils.charAt('test string', 3));
	}
}