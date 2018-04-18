@isTest
private class KenanDataProviderTest {
	
	@isTest
	static void testGetConnection() {
		
		DataSource.ConnectionParams connectionParams = new DataSource.ConnectionParams();
		Test.startTest();
		KenanDataProvider provider = new KenanDataProvider();
		DataSource.Connection connection = provider.getConnection(connectionParams);
		Test.stopTest();
		system.assert(connection instanceOf KenanDataConnection);
	}

	@isTest
	static void testgetAuthenticationCapabilities() {
		
		Test.startTest();
		KenanDataProvider provider = new KenanDataProvider();
		List<DataSource.AuthenticationCapability> authCaps = provider.getAuthenticationCapabilities();
		Test.stopTest();
		system.assertEquals(1, authCaps.size(), 'Invalid number of Authentication Capabilities were returned');
	}

	@isTest
	static void testgetCapabilities() {
		
		Test.startTest();
		KenanDataProvider provider = new KenanDataProvider();
		List<DataSource.Capability> caps = provider.getCapabilities();
		Test.stopTest();
		system.assertEquals(4, caps.size(), 'Invalid number of capabilities were returned');
	}
	
}