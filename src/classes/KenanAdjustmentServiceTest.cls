/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanAdjustmentService Unit Tests
*/
@isTest
private class KenanAdjustmentServiceTest {
    
    @testSetup
    static void setup() {
        KenanServiceConnection__c ksc = new KenanServiceConnection__c();
        ksc.Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=';
        ksc.Session_Timeout__c = '120000';
        ksc.Connection_URL__c = 'https://dev-aws-oag-pe.upc.biz';
        ksc.REST_Application_Base__c = '/kenan-salesforce-api/rest';
        ksc.Stored_Language_Code__c = '1';
        insert ksc;

        //Account acct = new Account();
        //acct.Name = 'Test Account Name';
        //insert acct;

        //UM_InvoiceHeader__c invoiceHeader = new UM_InvoiceHeader__c();
        //invoiceHeader.UM_Customer_SF_ID__c = acct.Id;
        //invoiceHeader.UM_Invoice_Date__c = Date.today().addDays(-5);
        //invoiceHeader.UM_InvoiceNumber__c = '1.0';
        //invoiceHeader.UM_Invoice_Amount_Gross_Currency__c = 100.00;
        //invoiceHeader.UM_Invoice_Amount_Net_Currency__c = 75.00;
        //invoiceHeader.UM_Invoice_Amount_Gross__c = 100;
        //invoiceHeader.UM_Invoice_Amount_Net__c = 75;
        //invoiceHeader.UM_Payment_Due_Date__c = Date.today().addDays(30);
        //insert invoiceHeader;

        //Kenan_Adjustment__c adj = new Kenan_Adjustment__c();
        //adj.Adjustment_Reason__c = 'Incorrect or unapplied charges';
  //    adj.Adjustment_Type__c = 'miscellaneous adjustment';
  //    adj.requestStatus__c = 'requested';
        //adj.Total_Amount__c = 25;
        //adj.Invoice_Header__c = invoiceHeader.Id;

        //insert adj;
    }

    @isTest
    static void testQuery() {
        KenanAdjustmentService service = new KenanAdjustmentService();

        Test.startTest();
        try {
            DataSource.TableResult result = service.query(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAdjustmentService.query has not been implemented', ke.errorName);
            System.assertEquals('KenanAdjustmentService.query has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testSearch() {
        KenanAdjustmentService service = new KenanAdjustmentService();

        Test.startTest();
        try {
            DataSource.TableResult result = service.search(null, 'Search Phrase');
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAdjustmentService.search has not been implemented', ke.errorName);
            System.assertEquals('KenanAdjustmentService.search has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void testDeleteRows() {
        KenanAdjustmentService service = new KenanAdjustmentService();

        Test.startTest();
        try {
            List<DataSource.DeleteResult> result = service.deleteRows(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAdjustmentService.deleteRows has not been implemented', ke.errorName);
            System.assertEquals('KenanAdjustmentService.deleteRows has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest 
    static void testInsertRow() {
        KenanAdjustmentService service = new KenanAdjustmentService();

        KenanAdjustmentCalloutMock adjustmentMock = new KenanAdjustmentCalloutMock();
        adjustmentMock.numberOfRecords = 1;
        Test.setMock (HttpCalloutMock.class, adjustmentMock);

        Test.startTest();
        KenanAdjustment adjustment = new KenanAdjustment();
        Date curDate = Date.today();
        Decimal amt = 300;
               
        adjustment.accountExternalId = 'accountExternalId';
        adjustment.accountExternalIdType = 1;
        adjustment.accountInternalId = 2;
        adjustment.adjReasonCode = 'Goodwill credited disorder';
        adjustment.billRefNo = 13.0;
        adjustment.billRefResets = 14.0;
        adjustment.currencyCode = 'KRW';
        adjustment.effectiveDate = curDate;
        adjustment.invoiceItem = 'invoiceItem.123.023';
        adjustment.fraudIndicator = 'anotherFraud';
        adjustment.trackingId = 'trackingId';
        adjustment.trackingIdServ = 'trackingIdServ';
        adjustment.totalAmt = amt;
        adjustment.approvedBy = 'Me';
        adjustment.approvalStatus = 'approved';

        KenanObject ko = service.insertRow(adjustment, 'POST', 'CREATE');
        Test.stopTest();

        KenanAdjustment kaInserted = (KenanAdjustment)ko;
        System.assertEquals('extId', kaInserted.accountExternalId);
        System.assertEquals('fraudIndicator', kaInserted.fraudIndicator);
        System.assertEquals('trackingId', kaInserted.trackingId);
        System.assertEquals('trackingIdServ', kaInserted.trackingIdServ);
    }

    @isTest 
    static void testInsertRowDashes() {
        KenanServiceConnection__c settings = KenanServiceConnection__c.getInstance();
        KenanAdjustmentService service = new KenanAdjustmentService();

        KenanAdjustmentCalloutMock adjustmentMock = new KenanAdjustmentCalloutMock();
        adjustmentMock.numberOfRecords = 1;
        Test.setMock (HttpCalloutMock.class, adjustmentMock);

        Test.startTest();
        KenanAdjustment adjustment = new KenanAdjustment();
        Date curDate = Date.today();
        Decimal amt = 300;
               
        adjustment.accountExternalId = 'accountExternalId';
        adjustment.accountExternalIdType = 1;
        adjustment.accountInternalId = 2;
        adjustment.adjReasonCode = 'Goodwill credited disorder';
        adjustment.billRefNo = 13.0;
        adjustment.billRefResets = 14.0;
        adjustment.currencyCode = 'KRW';
        adjustment.effectiveDate = curDate;
        adjustment.invoiceItem = 'invoiceItem' + settings.BillRefNo_BillRefResets_delimiter__c + '123' + settings.BillRefNo_BillRefResets_delimiter__c + '023';
        adjustment.fraudIndicator = 'anotherFraud';
        adjustment.trackingId = 'trackingId';
        adjustment.trackingIdServ = 'trackingIdServ';
        adjustment.totalAmt = amt;
        adjustment.approvedBy = 'Me';
        adjustment.approvalStatus = 'approved';

        KenanObject ko = service.insertRow(adjustment, 'POST', 'CREATE');
        Test.stopTest();

        KenanAdjustment kaInserted = (KenanAdjustment)ko;
        System.assertEquals('extId', kaInserted.accountExternalId);
        System.assertEquals('fraudIndicator', kaInserted.fraudIndicator);
        System.assertEquals('trackingId', kaInserted.trackingId);
        System.assertEquals('trackingIdServ', kaInserted.trackingIdServ);
    }

    @isTest 
    static void testInsertRowError() {
        KenanAdjustmentService service = new KenanAdjustmentService();

        KenanAdjustmentCalloutMockError adjustmentMock = new KenanAdjustmentCalloutMockError();
        Test.setMock (HttpCalloutMock.class, adjustmentMock);

        KenanAdjustment adjustment = new KenanAdjustment();
        Date curDate = Date.today();
        Decimal amt = 300;
               
        adjustment.accountExternalId = 'accountExternalId';
        adjustment.accountExternalIdType = 1;
        adjustment.accountInternalId = 2;
        adjustment.adjReasonCode = 'Goodwill credited disorder';
        adjustment.billRefNo = 13.0;
        adjustment.billRefResets = 14.0;
        adjustment.currencyCode = 'KRW';
        adjustment.effectiveDate = curDate;
        adjustment.fraudIndicator = 'anotherFraud';
        adjustment.trackingId = 'trackingId';
        adjustment.trackingIdServ = 'trackingIdServ';
        adjustment.totalAmt = amt;
        adjustment.approvedBy = 'Me';
        adjustment.approvalStatus = 'approved';


        Test.startTest();
        try {
            KenanObject ko = service.insertRow(adjustment, 'POST', 'CREATE');
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
        }
        Test.stopTest();
    }

    @isTest 
    static void testUpdateRow() {
        KenanAdjustmentService service = new KenanAdjustmentService();

        KenanAdjustmentCalloutMock adjustmentMock = new KenanAdjustmentCalloutMock();
        adjustmentMock.numberOfRecords = 1;
        Test.setMock (HttpCalloutMock.class, adjustmentMock);

        Test.startTest();
        KenanAdjustment adjustment = new KenanAdjustment();
        Date curDate = Date.today();
               
        adjustment.accountExternalId = 'accountExternalId';
        adjustment.accountExternalIdType = 1;
        adjustment.accountInternalId = 2;
        adjustment.adjReasonCode = 'Goodwill credited disorder';
        adjustment.billRefNo = 13.0;
        adjustment.billRefResets = 14.0;
        adjustment.currencyCode = 'KRW';
        adjustment.effectiveDate = curDate;
        adjustment.fraudIndicator = 'anotherFraud';
        adjustment.trackingId = 'trackingId';
        adjustment.trackingIdServ = 'trackingIdServ';
        adjustment.approvedBy = 'Me';
        adjustment.approvalStatus = 'approved';

        KenanObject ko = service.updateRow(adjustment, 'PUT', 'MODIFY');
        Test.stopTest();

        KenanAdjustment kaUpserted = (KenanAdjustment)ko;
        System.assertEquals('accountExternalId', kaUpserted.accountExternalId);
        System.assertEquals('anotherFraud', kaUpserted.fraudIndicator);
        System.assertEquals('trackingId', kaUpserted.trackingId);
        System.assertEquals('trackingIdServ', kaUpserted.trackingIdServ);
    }

    @isTest 
    static void testUpdateRowError() {
        KenanAdjustmentService service = new KenanAdjustmentService();

        KenanAdjustmentCalloutMockError adjustmentMock = new KenanAdjustmentCalloutMockError();
        Test.setMock (HttpCalloutMock.class, adjustmentMock);

        KenanAdjustment adjustment = new KenanAdjustment();
        Date curDate = Date.today();
               
        adjustment.accountExternalId = 'accountExternalId';
        adjustment.accountExternalIdType = 1;
        adjustment.accountInternalId = 2;
        adjustment.adjReasonCode = 'Goodwill credited disorder';
        adjustment.billRefNo = 13.0;
        adjustment.billRefResets = 14.0;
        adjustment.currencyCode = 'KRW';
        adjustment.effectiveDate = curDate;
        adjustment.fraudIndicator = 'anotherFraud';
        adjustment.trackingId = 'trackingId';
        adjustment.trackingIdServ = 'trackingIdServ';
        adjustment.approvedBy = 'Me';
        adjustment.approvalStatus = 'approved';

        Test.startTest();
        try {
            KenanObject ko = service.updateRow(adjustment, 'PUT', 'MODIFY');
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
        }
        Test.stopTest();
    }


    @isTest
    static void testDeleteRow() {
        KenanAdjustmentService service = new KenanAdjustmentService();

        Test.startTest();
        try {
            Boolean result = service.deleteRow(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (KenanException ke) {
            System.assert(true, 'Exception was thrown and caught');
            System.assertEquals('KenanAdjustmentService.deleteRow has not been implemented', ke.errorName);
            System.assertEquals('KenanAdjustmentService.deleteRow has not been implemented', ke.errorMessage);
        }
        Test.stopTest();
    }

    @isTest 
    static void testUpsertRows() {
        KenanAdjustmentService service = new KenanAdjustmentService();

        KenanAdjustmentCalloutMock adjustmentMock = new KenanAdjustmentCalloutMock();
        adjustmentMock.numberOfRecords = 1;
        Test.setMock (HttpCalloutMock.class, adjustmentMock);
        
        DataSource.UpsertContext context = new DataSource.UpsertContext();
        List<Map<String,Object>> valuesList = new List<Map<String,Object>>();
        Map<String,Object> objectMap = new Map<String,Object>();
        Date curDate = Date.today();
        Decimal amt = 300;

        objectMap.put('accountExternalId', 'accountExternalId');
        objectMap.put('accountExternalIdType', 1);
        objectMap.put('accountInternalId', 2);
        objectMap.put('adjReasonCode', 'Goodwill credited disorder');
        objectMap.put('billRefNo', 3.0);
        objectMap.put('billRefResets', 4.0);
        objectMap.put('currencyCode', 'KRW');
        objectMap.put('effectiveDate', curDate);
        objectMap.put('fraudIndicator', 'fraudIndicator');
        objectMap.put('invoiceItem', 'invoiceItem.123.023');
        objectMap.put('origType', 'adjustment against an adjustment');
        objectMap.put('openItemId', 'Invoice total');
        objectMap.put('primaryUnits', 'primaryUnits');
        objectMap.put('requestStatus', 'approved');
        objectMap.put('revRcvCostCtr', 'revRcvCostCtr');
        objectMap.put('totalAmt', amt);
        objectMap.put('trackingId', 'trackingId');
        objectMap.put('trackingIdServ', 'trackingIdServ');

        valuesList.add(objectMap);
        Map<String,Object> objectMap2 = new Map<String,Object>();
        objectMap2.put('invoiceItem', 'invoiceItem.134.023');
        valuesList.add(objectMap2);

        context.rows = valuesList;

        Test.startTest();
        List<DataSource.UpsertResult> upsertResult = service.upsertRows(context);
        Test.stopTest();

        System.assertNotEquals(null, upsertResult);
    }

    @isTest 
    static void testUpsertRowsError() {
        KenanAdjustmentService service = new KenanAdjustmentService();

        KenanAdjustmentCalloutMockError adjustmentMock = new KenanAdjustmentCalloutMockError();
        Test.setMock (HttpCalloutMock.class, adjustmentMock);
        
        DataSource.UpsertContext context = new DataSource.UpsertContext();
        List<Map<String,Object>> valuesList = new List<Map<String,Object>>();
        Map<String,Object> objectMap = new Map<String,Object>();
        Date curDate = Date.today();
        Decimal amt = 300;

        objectMap.put('accountExternalId', 'accountExternalId');
        objectMap.put('accountExternalIdType', 1);
        objectMap.put('accountInternalId', 2);
        objectMap.put('adjReasonCode', 'Goodwill credited disorder');
        objectMap.put('billRefNo', 3.0);
        objectMap.put('billRefResets', 4.0);
        objectMap.put('currencyCode', 'KRW');
        objectMap.put('effectiveDate', curDate);
        objectMap.put('fraudIndicator', 'fraudIndicator');
        objectMap.put('invoiceItem', '000000000000000');
        objectMap.put('origType', 'adjustment against an adjustment');
        objectMap.put('openItemId', 'Invoice total');
        objectMap.put('primaryUnits', 'primaryUnits');
        objectMap.put('requestStatus', 'approved');
        objectMap.put('revRcvCostCtr', 'revRcvCostCtr');
        objectMap.put('totalAmt', amt);
        objectMap.put('trackingId', 'trackingId');
        objectMap.put('trackingIdServ', 'trackingIdServ');

        valuesList.add(objectMap);
        Map<String,Object> objectMap2 = new Map<String,Object>();
        objectMap2.put('invoiceItem', 'invoiceItem.134.023');
        valuesList.add(objectMap2);

        context.rows = valuesList;

        Test.startTest();
        List<DataSource.UpsertResult> upsertResult = service.upsertRows(context);
        Test.stopTest();

        System.assertNotEquals(null, upsertResult);
    }
    
}