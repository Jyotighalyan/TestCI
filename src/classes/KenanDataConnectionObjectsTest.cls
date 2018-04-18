/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Adjustment Service Test
*/
@isTest
private class KenanDataConnectionObjectsTest {
	
	@isTest static void testGetTables() {
		List<DataSource.Table> kenanTables = KenanDataConnectionObjects.getTables();
		System.assertEquals(2, kenanTables.size());

		DataSource.Table invoiceDetailTable = kenanTables.get(0);
		System.assertEquals('InvoiceItem', invoiceDetailTable.name);
		System.assertEquals('Invoice Items', invoiceDetailTable.labelPlural);
		System.assertEquals('Invoice Item', invoiceDetailTable.labelSingular);
		System.assertEquals('ExternalId', invoiceDetailTable.nameColumn);
		System.assertEquals(73, invoiceDetailTable.columns.size());

		DataSource.Table adjustmentTable = kenanTables.get(1);
		System.assertEquals('Adjustment', adjustmentTable.name);
		System.assertEquals('Adjustments', adjustmentTable.labelPlural);
		System.assertEquals('Adjustment', adjustmentTable.labelSingular);
		System.assertEquals('ExternalId', adjustmentTable.nameColumn);
		System.assertEquals(15, adjustmentTable.columns.size());

	}
}