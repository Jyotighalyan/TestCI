@isTest
private class LG_RfsCheckUtilityTest {
	
	private static testmethod void testGetCommonRfsJsonFormatAllAvailable()
	{
		String rfsCommon = LG_RfsCheckUtility.getCommonRfsJsonFormat(LG_RfsCheckUtility.buildRfsResponse(true, true, true, true, true, true));
		System.assertEquals(true, rfsCommon.contains('"down":"500"'));
		System.assertEquals(true, rfsCommon.contains('"qos":"Voice"'));
		System.assertEquals(true, rfsCommon.contains('"capability":"TV"'));
		System.assertEquals(true, rfsCommon.contains('"technology":"Mobile"'));
		System.assertEquals(true, rfsCommon.contains('"addressId":"11532544"'));
		System.assertEquals(true, rfsCommon.contains('"country":"Netherlands"'));
	}
	
	private static testmethod void testGetCommonRfsJsonFormatFp500NotAvailable()
	{
		String rfsCommon = LG_RfsCheckUtility.getCommonRfsJsonFormat(LG_RfsCheckUtility.buildRfsResponse(true, true, false, true, true, true));

		System.assertEquals(false, rfsCommon.contains('"down":"500"'));
		System.assertEquals(true, rfsCommon.contains('"down":"300"'));
		System.assertEquals(true, rfsCommon.contains('"qos":"Voice"'));
		System.assertEquals(true, rfsCommon.contains('"capability":"TV"'));
		System.assertEquals(true, rfsCommon.contains('"technology":"Mobile"'));
		System.assertEquals(true, rfsCommon.contains('"addressId":"11532544"'));
		System.assertEquals(true, rfsCommon.contains('"country":"Netherlands"'));
	}
	
	private static testmethod void testGetCommonRfsJsonFormatFp200NotAvailable()
	{
		String rfsCommon = LG_RfsCheckUtility.getCommonRfsJsonFormat(LG_RfsCheckUtility.buildRfsResponse(true, false, false, true, true, true));

		System.assertEquals(false, rfsCommon.contains('"down":"500"'));
		System.assertEquals(false, rfsCommon.contains('"down":"300"'));
		System.assertEquals(true, rfsCommon.contains('"down":"130"'));
		System.assertEquals(true, rfsCommon.contains('"qos":"Voice"'));
		System.assertEquals(true, rfsCommon.contains('"capability":"TV"'));
		System.assertEquals(true, rfsCommon.contains('"technology":"Mobile"'));
		System.assertEquals(true, rfsCommon.contains('"addressId":"11532544"'));
		System.assertEquals(true, rfsCommon.contains('"country":"Netherlands"'));	
	}
	
	private static testmethod void testGetProductFamilyLimitsForInternet()
	{
		String rfsCommon = LG_RfsCheckUtility.getCommonRfsJsonFormat(LG_RfsCheckUtility.buildRfsResponse(true, true, true, true, true, true));
		
		Map<String, String> limitsValues = LG_RfsCheckUtility.getProductFamilyLimits(rfsCommon, 'Internet');
		
		System.assertEquals('500', limitsValues.get('down'), 'Max Download should be 500');
		System.assertEquals('40', limitsValues.get('up'), 'Max Upload should be 40');
		System.assertEquals('Voice', limitsValues.get('qos'), 'QoS should be Voice');
	}
}