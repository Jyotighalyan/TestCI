/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Unit Test for use in Salesforce Kenan Connection Service
*/
@isTest
private class KenanServiceExternalIdTest {
	
	@isTest
	static void constructorTest(){
		Test.startTest();
		KenanServiceExternalId extId = new KenanServiceExternalId();
		Test.stopTest();
		System.assertNotEquals(null, extId, 'KenanServiceExternalId constructor failed');
	}

	
	@isTest
	static void propertyTest(){
		Test.startTest();
		KenanServiceExternalId extId = new KenanServiceExternalId();
		DateTime curDate = DateTime.now();
		extId.createDt = curDate;
	 	extId.inactiveDate = curDate;
  	 	extId.intendedViewEffectiveDt = curDate;
 	 	extId.isCurrent = true;
 		extId.isFromInventory  = true;
 	 	extId.prevViewId  = 12345;
 	 	extId.serviceExternalId = '54321';
  		extId.serviceExternalIdType = 2;
		extId.serviceInternalId = 435;
  		extId.serviceInternalIdResets = 0;
  		//extId.viewCreatedDt = curDate;
  		//extId.viewEffectiveDt = curDate;
  		extId.viewId = 1;
  		extId.viewStatus = 1;		
		Test.stopTest();
		System.assertNotEquals(null, extId, 'KenanServiceExternalId constructor failed');
  	 	System.assertEquals(extId.intendedViewEffectiveDt, curDate, 'KenanServiceExternalId intendedViewEffectiveDt failed'); 
 	 	System.assertEquals(extId.isCurrent, true, 'KenanServiceExternalId isCurrent failed');
 		System.assertEquals(extId.isFromInventory , true, 'KenanServiceExternalId isFromInventory failed');
 	 	System.assertEquals(extId.prevViewId , 12345, 'KenanServiceExternalId prevViewId failed');
 	 	System.assertEquals(extId.serviceExternalId, '54321', 'KenanServiceExternalId serviceExternalId failed');
  		System.assertEquals(extId.serviceExternalIdType, 2, 'KenanServiceExternalId serviceExternalIdType failed');
		System.assertEquals(extId.serviceInternalId, 435, 'KenanServiceExternalId serviceInternalId failed');
  		System.assertEquals(extId.serviceInternalIdResets, 0, 'KenanServiceExternalId serviceInternalIdResets failed');
  		System.assertEquals(extId.viewId, 1, 'KenanServiceExternalId viewId failed');
  		System.assertEquals(extId.viewStatus, 1, 'KenanServiceExternalId viewStatus failed');
  		
	}
}