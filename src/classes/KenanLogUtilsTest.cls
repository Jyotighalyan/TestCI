/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Data structure for use in Salesforce Kenan Connection Service
*/
@isTest
private class KenanLogUtilsTest {
	
	@isTest 
	static void testLogInfoMessage() {
		Test.startTest();
		KenanLogUtils.logInfo('testLogInfoMessage', 'test message');
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogErrorMessage() {
		Test.startTest();
		KenanLogUtils.logError('testLogErrorMessage', 'test message');
		Test.stopTest();

		System.assert(true, 'Should get here');
	}
	
	@isTest 
	static void testLogParameters1() {
		Test.startTest();
		KenanLogUtils.log(LoggingLevel.DEBUG, 'testLogParameters1', 'paramName', 'paramValue');
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogErrorParameters1() {
		Test.startTest();
		KenanLogUtils.logError('testLogErrorParameters1', 'paramName1', 'paramValue1');
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParameters1() {
		Test.startTest();
		KenanLogUtils.logInfo('testLogInfoParameters1', 'paramName1', 'paramValue1');
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogParameters2() {
		Test.startTest();
		KenanLogUtils.log(LoggingLevel.DEBUG, 'testLogParameters2', 'paramName1', 'paramValue1', 'paramName2', 'paramValue2');
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogErrorParameters2() {
		Test.startTest();
		KenanLogUtils.logError('testLogErrorParameters2', 'paramName1', 'paramValue1', 'paramName2', 'paramValue2');
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParameters2() {
		Test.startTest();
		KenanLogUtils.logInfo('testLogInfoParameters2', 'paramName1', 'paramValue1', 'paramName2', 'paramValue2');
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogParameters3() {
		Test.startTest();
		KenanLogUtils.log(LoggingLevel.DEBUG, 'testLogParameters3', 'paramName1', 'paramValue1', 'paramName2', 'paramValue2', 'paramName3', 'paramValue3');
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogErrorParameters3() {
		Test.startTest();
		KenanLogUtils.logError('testLogErrorParameters3', 'paramName1', 'paramValue1', 'paramName2', 'paramValue2', 'paramName3', 'paramValue3');
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParameters3() {
		Test.startTest();
		KenanLogUtils.logInfo('testLogInfoParameters3', 'paramName1', 'paramValue1', 'paramName2', 'paramValue2', 'paramName3', 'paramValue3');
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogParameters4() {
		Test.startTest();
		KenanLogUtils.log(LoggingLevel.DEBUG, 'testLogParameters4', 'paramName1', 'paramValue1', 'paramName2', 'paramValue2', 'paramName3', 'paramValue3', 'paramName4', 'paramValue4');
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogErrorParameters4() {
		Test.startTest();
		KenanLogUtils.logError('testLogErrorParameters4', 'paramName1', 'paramValue1', 'paramName2', 'paramValue2', 'paramName3', 'paramValue3', 'paramName4', 'paramValue4');
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParameters4() {
		Test.startTest();
		KenanLogUtils.logInfo('testLogInfoParameters4', 'paramName1', 'paramValue1', 'paramName2', 'paramValue2', 'paramName3', 'paramValue3', 'paramName4', 'paramValue4');
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogParameters5() {
		Test.startTest();
		KenanLogUtils.log(LoggingLevel.DEBUG, 'testLogParameters5', 'paramName1', 'paramValue1', 'paramName2', 'paramValue2', 'paramName3', 'paramValue3', 'paramName4', 'paramValue4', 'paramName5', 'paramValue5');
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogErrorParameters5() {
		Test.startTest();
		KenanLogUtils.logError('testLogErrorParameters5', 'paramName1', 'paramValue1', 'paramName2', 'paramValue2', 'paramName3', 'paramValue3', 'paramName4', 'paramValue4', 'paramName5', 'paramValue5');
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParameters5() {
		Test.startTest();
		KenanLogUtils.logInfo('testLogInfoParameters5', 'paramName1', 'paramValue1', 'paramName2', 'paramValue2', 'paramName3', 'paramValue3', 'paramName4', 'paramValue4', 'paramName5', 'paramValue5');
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogErrorParametersMap() {
		Map<String, Object> params = new Map<String, Object>{ 'paramName1' => 'paramValue1', 'paramName2' => 'paramValue2', 'paramName3' => 'paramValue3', 'paramName4' => 'paramValue4', 'paramName5' => 'paramValue5', 'paramName6' => 'paramValue6', 'paramName7' => 'paramValue7', 'paramName8' => 'paramValue8' };
		Test.startTest();
		KenanLogUtils.logError('testLogErrorParametersMap', params);
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParametersMap() {
		Map<String, Object> params = new Map<String, Object>{ 'paramName1' => 'paramValue1', 'paramName2' => 'paramValue2', 'paramName3' => 'paramValue3', 'paramName4' => 'paramValue4', 'paramName5' => 'paramValue5', 'paramName6' => 'paramValue6', 'paramName7' => 'paramValue7', 'paramName8' => 'paramValue8' };
		Test.startTest();
		KenanLogUtils.logInfo('testLogInfoParametersMap', params);
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParametersMapWithLists() {
		Map<String, Object> params = new Map<String, Object>{ 'paramName1' => 'paramValue1', 'paramName2' => new List<String>{ 'item1', 'item2', 'item3' }, 'paramName3' => 'paramValue3', 'paramName4' => 'paramValue4', 'paramName5' => new List<Integer>{ 5, 6, null }, 'paramName6' => 'paramValue6', 'paramName7' => 'paramValue7', 'paramName8' => 'paramName8' };
		Test.startTest();
		KenanLogUtils.log(LoggingLevel.DEBUG, 'testLogInfoParametersMapWithLists', params);
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParametersMapWithSets() {
		Map<String, Object> params = new Map<String, Object>{ 'paramName1' => 'paramValue1', 'paramName2' => new Set<String>{ 'item5', 'item6', 'item7' }, 'paramName3' => 'paramValue3', 'paramName4' => 'paramValue4', 'paramName5' => new Set<Integer>{ 9, 8, 7 }, 'paramName6' => 'paramValue6', 'paramName7' => 'paramValue7', 'paramName8' => 'paramValue8' };
		Test.startTest();
		KenanLogUtils.log(LoggingLevel.DEBUG, 'testLogInfoParametersMapWithSets', params);
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParametersMapWithMaps() {
		Map<String, Object> params = new Map<String, Object>{ 'paramName1' => 'paramValue1', 'paramName2' => new Map<String, Object>{ 'a' => 'item1', 'b' => 'item2', 'c' => 'item3' }, 'paramName3' => 'paramValue3', 'paramName4' => 'paramValue4', 'paramName5' => new Map<String, Object>{ 'a' => 5, 'b' => 6, 'c' => 7 }, 'paramName6' => 'paramValue6', 'paramName7' => 'paramValue7', 'paramName8' => new Map<String, Object>{ 'a' => 'item1', 'b' => 'item2', 'c' => null } };
		Test.startTest();
		KenanLogUtils.log(LoggingLevel.DEBUG, 'testLogInfoParametersMapWithMaps', params);
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParametersWithNulls1() {
		Test.startTest();
		KenanLogUtils.logInfo('testLogInfoParametersWithNulls', null, null);
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParametersWithNulls2() {
		Test.startTest();
		KenanLogUtils.logInfo('testLogInfoParametersWithNulls', null, null, null, null);
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParametersWithNulls3() {
		Test.startTest();
		KenanLogUtils.logInfo('testLogInfoParametersWithNulls', null, null, null, null, null, null);
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParametersWithNulls4() {
		Test.startTest();
		KenanLogUtils.logInfo('testLogInfoParametersWithNulls', null, null, null, null, null, null, null, null);
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParametersWithNulls5() {
		Test.startTest();
		KenanLogUtils.logInfo('testLogInfoParametersWithNulls', null, null, null, null, null, null, null, null, null, null);
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParametersWithStringValueNull1() {
		Test.startTest();
		KenanLogUtils.logInfo('testLogInfoParametersWithStringValueNull1', 'param1', null);
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParametersWithStringValueNull2() {
		Test.startTest();
		KenanLogUtils.logInfo('testLogInfoParametersWithStringValueNull2', 'param1', null, 'param2', null);
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParametersWithStringValueNull3() {
		Test.startTest();
		KenanLogUtils.logInfo('testLogInfoParametersWithStringValueNull3', 'param1', null, 'param2', null, 'param3', null);
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParametersWithStringValueNull4() {
		Test.startTest();
		KenanLogUtils.logInfo('testLogInfoParametersWithStringValueNull4', 'param1', null, 'param2', null, 'param3', null, 'param4', null);
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogInfoParametersWithStringValueNull5() {
		Test.startTest();
		KenanLogUtils.logInfo('testLogInfoParametersWithStringValueNull5', 'param1', null, 'param2', null, 'param3', null, 'param4', null, 'param5', null);
		Test.stopTest();

		System.assert(true, 'Should get here');
	}

	@isTest 
	static void testLogException() {
		Test.startTest();
		Account act = new Account();
		Map<String, Object> exMap = new Map<String, Object>();

		try {
			insert act;
		} 
		catch (DmlException e){
			exMap.put('testLogException', e);
			KenanLogUtils.log(LoggingLevel.DEBUG, 'testLogException', exMap);
		}
		
		Test.stopTest();

		System.assert(true, 'Should get here');
	}
	
}