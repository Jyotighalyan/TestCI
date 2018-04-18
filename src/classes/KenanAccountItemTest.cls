/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanAccountItemTest for use in Salesforce Kenan Connection Service
*/
@isTest
public class KenanAccountItemTest {

	@isTest
	static void testCreateKenanAccountItem() {

		Test.startTest();
		KenanAccountItem kenanAccountItem = new KenanAccountItem();
		Test.stopTest();

		System.assertNotEquals(null, kenanAccountItem);
		System.assertEquals(2, kenanAccountItem.serviceExternalIdType);
	}

	@isTest
	static void testKenanAccountItemFields() {
		KenanAccountItem kenanAccountItem = new KenanAccountItem();

		Integer serviceExternalIdType = 3;
		String serviceExternalId = '1';
		Date today = Date.today();
		String annotation = 'annotation';
		String annotation2 = 'annotation2';
		String currencyCode = 'EUR';
		Date yearFromToday = Date.today().addYears(1);
		String instanceId = 'instanceId';
		String salesforceId = 'salesforceId';
		Integer itemId = 1;
		Integer itemType = 2;
		Integer rate = 10;
		Integer units = 1;
		String unitsType = 'unitsType';
		String nrcParentRcInstanceId = 'nrcParentRcInstanceId';
		Decimal discountAmount = 10;
		Decimal discountPercent = 10;
		Decimal unitCreditUnitsFree = 10;
		Decimal unitCreditAmountFree = 10;
		Integer contractLevel = 1;
		Integer serviceItemExternalIdType = 2;

		Test.startTest();
		kenanAccountItem.serviceExternalIdType = serviceExternalIdType;
		kenanAccountItem.serviceExternalId = serviceExternalId;
		kenanAccountItem.activeDate = today; 
		kenanAccountItem.annotation = annotation;
		kenanAccountItem.annotation2 = annotation2;
		kenanAccountItem.currencyCode = currencyCode; 
		kenanAccountItem.inactiveDate = yearFromToday; 
		kenanAccountItem.instanceId = instanceId;
		kenanAccountItem.itemId = itemId;
		kenanAccountItem.itemType = itemType;
		kenanAccountItem.rate = rate;
		kenanAccountItem.salesforceId = salesforceId;
		kenanAccountItem.units = units;
		kenanAccountItem.unitsType = unitsType;
		kenanAccountItem.nrcParentRcInstanceId = nrcParentRcInstanceId;
		kenanAccountItem.discountAmount = discountAmount; 
		kenanAccountItem.discountPercent = discountPercent; 
		kenanAccountItem.unitCreditUnitsFree = unitCreditUnitsFree;
		kenanAccountItem.unitCreditAmountFree = unitCreditAmountFree;
		kenanAccountItem.contractLevel = contractLevel;
		kenanAccountItem.rcAssociatedNrc = new KenanServiceItem(); 
		Test.stopTest();

		System.assertEquals(serviceExternalIdType, kenanAccountItem.serviceExternalIdType);
		System.assertEquals(serviceExternalId, kenanAccountItem.serviceExternalId);
		System.assertEquals(today, kenanAccountItem.activeDate);
		System.assertEquals(annotation, kenanAccountItem.annotation);
		System.assertEquals(annotation2, kenanAccountItem.annotation2);
		System.assertEquals(currencyCode, kenanAccountItem.currencyCode);
		System.assertEquals(yearFromToday, kenanAccountItem.inactiveDate);
		System.assertEquals(instanceId, kenanAccountItem.instanceId);
		System.assertEquals(itemId, kenanAccountItem.itemId);
		System.assertEquals(itemType, kenanAccountItem.itemType);
		System.assertEquals(rate, kenanAccountItem.rate);
		System.assertEquals(salesforceId, kenanAccountItem.salesforceId);
		System.assertEquals(units, kenanAccountItem.units);
		System.assertEquals(unitsType, kenanAccountItem.unitsType);
		System.assertEquals(nrcParentRcInstanceId, kenanAccountItem.nrcParentRcInstanceId);
		System.assertEquals(discountAmount, kenanAccountItem.discountAmount);
		System.assertEquals(discountPercent, kenanAccountItem.discountPercent);
		System.assertEquals(unitCreditUnitsFree, kenanAccountItem.unitCreditUnitsFree);
		System.assertEquals(unitCreditAmountFree, kenanAccountItem.unitCreditAmountFree);
		System.assertEquals(contractLevel, kenanAccountItem.contractLevel);
		System.assertNotEquals(null, kenanAccountItem.rcAssociatedNrc);
	}
}