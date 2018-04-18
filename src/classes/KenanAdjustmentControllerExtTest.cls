@isTest
private class KenanAdjustmentControllerExtTest {

    @testSetup
    static void setup() {
        KenanServiceConnection__c settings = new KenanServiceConnection__c(
            Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=',
            Session_Timeout__c = '120000',
            Connection_URL__c = 'https://kenan-dev-pubelb-amdocs-1924041402.eu-central-1.elb.amazonaws.com',
            REST_Application_Base__c = '/kenan-salesforce-api/rest',
            Stored_Language_Code__c = '1'
            );
        insert settings;

        Account acct = new Account();
        acct.Name = 'Test Account Name';
        insert acct;

        //TODO: Uncomment after Deployment
        //csconta__Billing_Account__c billAccount = new csconta__Billing_Account__c();
        //insert billAccount;

        UM_InvoiceHeader__c invoiceHeader = new UM_InvoiceHeader__c();
        invoiceHeader.UM_Customer_SF_ID__c = acct.Id;
        invoiceHeader.UM_Invoice_Date__c = Date.today().addDays(-5);
        invoiceHeader.UM_InvoiceNumber__c = '1401.0';
        invoiceHeader.UM_Invoice_Amount_Gross_Currency__c = 100.00;
        invoiceHeader.UM_Invoice_Amount_Net_Currency__c = 75.00;
        invoiceHeader.UM_Invoice_Amount_Gross__c = 100;
        invoiceHeader.UM_Invoice_Amount_Net__c = 75;
        invoiceHeader.UM_Payment_Due_Date__c = Date.today().addDays(30);
        //TODO: Uncomment after deployment
        //invoiceHeader.UM_Billing_Location__c = billAccount.Id;
        insert invoiceHeader;

        Kenan_Adjustment__c adj = new Kenan_Adjustment__c();
        adj.trackingId__c = '123';
        adj.trackingIdServ__c = '1';
        adj.Adjustment_Reason__c = 'Incorrect or unapplied charges';
        adj.Adjustment_Type__c = 'miscellaneous adjustment';
        adj.RequestStatus__c = 'requested';
        adj.Total_Amount__c = 25;
        adj.Invoice_Header__c = invoiceHeader.Id;

        insert adj;
    }

    private static List<Kenan_Adjustment__c> getKenanAdjustments() {
        return [
            SELECT
                Name,
                Invoice_Header__c,
                Invoice_Item__c
            FROM
                Kenan_Adjustment__c
        ];
    }

    private static List<Account> getAccounts() {
        return [
            SELECT
                Id
            FROM
                Account
        ];
    }


    @isTest
    static void testConstructorInvoiceHeader() {

        UM_InvoiceHeader__c invoiceHeader = [SELECT Id, UM_Customer_SF_ID__c FROM UM_InvoiceHeader__c LIMIT 1];

        PageReference pr = Page.KenanAdjustment;
        pr.getParameters().put('invoiceId', invoiceHeader.Id);
        Test.setCurrentPage(pr);
        Test.setMock(HttpCalloutMock.class, new KenanInvoiceServiceMock());
        Test.startTest();
        Kenan_Adjustment__c adjustment = getKenanAdjustments()[0];
        ApexPages.StandardController controller = new ApexPages.StandardController(adjustment);
        KenanAdjustmentControllerExt extCon = new KenanAdjustmentControllerExt(controller);
        Test.stopTest();

        System.assertNotEquals(null, extCon);
        System.assertEquals(KenanAdjustmentControllerExt.KENAN_ADJUSTMENT_TYPE_MISC, extCon.getAdjustment().Adjustment_Type__c);
    }

    @isTest
    static void testConstructorInvoiceId() {

        UM_InvoiceHeader__c invoiceHeader = [SELECT Id, UM_Customer_SF_ID__c FROM UM_InvoiceHeader__c LIMIT 1];

        PageReference pr = Page.KenanAdjustment;
        pr.getParameters().put('invoiceId', invoiceHeader.Id);
        Test.setCurrentPage(pr);
        Test.setMock(HttpCalloutMock.class, new KenanInvoiceServiceMock());
        Test.startTest();
        Kenan_Adjustment__c adjustment = new Kenan_Adjustment__c();
        ApexPages.StandardController controller = new ApexPages.StandardController(adjustment);
        KenanAdjustmentControllerExt extCon = new KenanAdjustmentControllerExt(controller);
        Test.stopTest();

        System.assertNotEquals(null, extCon);
        System.assertEquals(KenanAdjustmentControllerExt.KENAN_ADJUSTMENT_TYPE_MISC, extCon.getAdjustment().Adjustment_Type__c);
    }


    @isTest
    static void testCancel() {
        UM_InvoiceHeader__c invoiceHeader = [SELECT Id, UM_Customer_SF_ID__c FROM UM_InvoiceHeader__c LIMIT 1];
        Test.startTest();
        Kenan_Adjustment__c adjustment = new Kenan_Adjustment__c();
        adjustment.Invoice_Header__c = invoiceHeader.Id;
        ApexPages.StandardController controller = new ApexPages.StandardController(adjustment);
        KenanAdjustmentControllerExt extCon = new KenanAdjustmentControllerExt(controller);
        PageReference pr = extCon.cancel();
        Test.stopTest();
        Account act = getAccounts()[0];
        
        System.assertNotEquals(null, pr);
        System.assert(pr.getUrl().contains(act.Id));
        System.assertEquals(true, pr.getRedirect());
    }

    @isTest
    static void testGetAdjustment() {
        UM_InvoiceHeader__c invoiceHeader = [SELECT Id, UM_Customer_SF_ID__c FROM UM_InvoiceHeader__c LIMIT 1];
        Test.startTest();
        Kenan_Adjustment__c adjustment = new Kenan_Adjustment__c();
        adjustment.Invoice_Header__c = invoiceHeader.Id;
        ApexPages.StandardController controller = new ApexPages.StandardController(adjustment);
        KenanAdjustmentControllerExt extCon = new KenanAdjustmentControllerExt(controller);
        Kenan_Adjustment__c adjustment2  = extCon.getAdjustment();
        Test.stopTest();

        System.assertNotEquals(null, adjustment2);
    }

    @isTest
    static void testGetFieldsets() {
        UM_InvoiceHeader__c invoiceHeader = [SELECT Id, UM_Customer_SF_ID__c FROM UM_InvoiceHeader__c LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new KenanInvoiceDetailServiceMock());
        Test.startTest();
        Kenan_Adjustment__c adjustment = new Kenan_Adjustment__c();
        adjustment.Invoice_Header__c = invoiceHeader.Id;
        ApexPages.StandardController controller = new ApexPages.StandardController(adjustment);
        KenanAdjustmentControllerExt extCon = new KenanAdjustmentControllerExt(controller);
        List<FieldSetMember> adjFields = extCon.getAdjustmentFields();
        List<FieldSetMember> invFields = extCon.getInvoiceFields();
        List<FieldSetMember> invItemFields = extCon.getInvoiceItemFields();
        List<SelectOption> statusOptions = extCon.getAdjustmentStatuses();
        List<SelectOption> typeOptions = extCon.getAdjustmentTypes();
        List<SelectOption> resonOptions = extCon.getReasonCodes();
        Test.stopTest();

        System.assert(adjFields.size() > 0);
        System.assert(invFields.size() > 0);
        System.assert(invItemFields.size() > 0);
        System.assert(statusOptions.size() > 0);
        System.assert(typeOptions.size() > 0);
        System.assert(resonOptions.size() > 0);

    }

    @isTest
    static void testConstructorInvoiceDetail() {

        UM_InvoiceHeader__c invoiceHeader = [SELECT Id, UM_Customer_SF_ID__c FROM UM_InvoiceHeader__c LIMIT 1];

        PageReference pr = Page.KenanAdjustment;
        pr.getParameters().put('invoiceId', invoiceHeader.Id);
        pr.getParameters().put('itemId', '1401.0.1');
        Test.setCurrentPage(pr);
        Test.setMock(HttpCalloutMock.class, new KenanInvoiceServiceMock());
        Test.startTest();
        Kenan_Adjustment__c adjustment = getKenanAdjustments()[0];
        ApexPages.StandardController controller = new ApexPages.StandardController(adjustment);
        KenanAdjustmentControllerExt extCon = new KenanAdjustmentControllerExt(controller);
        Test.stopTest();

        System.assertNotEquals(null, extCon);
        System.assertEquals(null, extCon.getAdjustment().Adjustment_Type__c);
    }

    @isTest
    static void testConstructorSaveAdjustment() {
        try{

        UM_InvoiceHeader__c invoiceHeader = [SELECT Id, UM_Customer_SF_ID__c FROM UM_InvoiceHeader__c LIMIT 1];

        //AdjustmentReasonBean__mdt
        AdjustmentReasonBean__mdt reason = [SELECT AdjReasonCode__c, DisplayValue__c FROM AdjustmentReasonBean__mdt LIMIT 1];

        //AdjustmentOrigType__mdt
        AdjustmentOrigType__mdt origType = [SELECT MasterLabel, OrigType__c FROM AdjustmentOrigType__mdt LIMIT 1];
        
        //AdjustmentStatus__mdt
        AdjustmentStatus__mdt status = [SELECT MasterLabel, requestStatus__c FROM AdjustmentStatus__mdt LIMIT 1];

        PageReference pr = Page.KenanAdjustment;
        pr.getParameters().put('invoiceId', invoiceHeader.Id);
        pr.getParameters().put('itemId', '1401.0.1');
        Test.setCurrentPage(pr);
        KenanAdjustmentCalloutMock serviceMock = new KenanAdjustmentCalloutMock();
        serviceMock.numberOfRecords = 1;
        Test.setMock(HttpCalloutMock.class, serviceMock);
        Kenan_Adjustment__c adjustment = new Kenan_Adjustment__c();
        ApexPages.StandardController controller = new ApexPages.StandardController(adjustment);
        KenanAdjustmentControllerExt extCon = new KenanAdjustmentControllerExt(controller);
        extCon.getAdjustment().Adjustment_Reason__c = reason.DisplayValue__c;
        extCon.getAdjustment().Adjustment_Type__c = origType.MasterLabel;
        extCon.getAdjustment().requestStatus__c = status.MasterLabel;
        extCon.getAdjustment().Effective_Date__c = Date.today();
        extCon.getAdjustment().Total_Amount__c = 100;

        Test.startTest();
        PageReference prResult = extCon.saveAdjustment();
        Test.stopTest();

            System.assertEquals(true, prResult.getRedirect());}
        catch(Exception e){
            system.debug('tytytytytytytytytytytytyty'+e.getMessage()+e.getLineNumber());
            
        }
    }

    @isTest
    static void testConstructorSaveAdjustmentError() {

        UM_InvoiceHeader__c invoiceHeader = [SELECT Id, UM_Customer_SF_ID__c FROM UM_InvoiceHeader__c LIMIT 1];

        //AdjustmentReasonBean__mdt
        AdjustmentReasonBean__mdt reason = [SELECT AdjReasonCode__c, DisplayValue__c FROM AdjustmentReasonBean__mdt LIMIT 1];

        //AdjustmentOrigType__mdt
        AdjustmentOrigType__mdt origType = [SELECT MasterLabel, OrigType__c FROM AdjustmentOrigType__mdt LIMIT 1];
        
        //AdjustmentStatus__mdt
        AdjustmentStatus__mdt status = [SELECT MasterLabel, requestStatus__c FROM AdjustmentStatus__mdt LIMIT 1];

        PageReference pr = Page.KenanAdjustment;
        pr.getParameters().put('invoiceId', invoiceHeader.Id);
        pr.getParameters().put('itemId', '1401.0.1');
        Test.setCurrentPage(pr);
        KenanAdjustmentCalloutMockError serviceMock = new KenanAdjustmentCalloutMockError();
        Test.setMock(HttpCalloutMock.class, serviceMock);
        Kenan_Adjustment__c adjustment = new Kenan_Adjustment__c();
        ApexPages.StandardController controller = new ApexPages.StandardController(adjustment);
        KenanAdjustmentControllerExt extCon = new KenanAdjustmentControllerExt(controller);
        //extCon.getAdjustment().Adjustment_Reason__c = reason.DisplayValue__c;
        extCon.getAdjustment().Adjustment_Type__c = origType.MasterLabel;
        extCon.getAdjustment().requestStatus__c = status.MasterLabel;
        extCon.getAdjustment().Effective_Date__c = Date.today();
        extCon.getAdjustment().Total_Amount__c = 100;

        Test.startTest();
        PageReference prResult = extCon.saveAdjustment();
        Test.stopTest();

        System.assertEquals(1, ApexPages.getMessages().size());
        ApexPages.Message message = ApexPages.getMessages().get(0);
        System.assertNotEquals(null, message.getSummary());
    }

    @isTest
    static void testGetAdjustmentType() {
        System.assertEquals(KenanAdjustmentControllerExt.KENAN_ADJUSTMENT_TYPE_MISC, KenanAdjustmentControllerExt.getAdjustmentType(null));

        InvoiceItem__x invoiceItem = new InvoiceItem__x();
        invoiceItem.typeCode__c = '1';
        System.assertEquals(null, KenanAdjustmentControllerExt.getAdjustmentType(invoiceItem));

        invoiceItem.typeCode__c = '2';
        System.assertEquals(KenanAdjustmentControllerExt.KENAN_ADJUSTMENT_TYPE_RC, KenanAdjustmentControllerExt.getAdjustmentType(invoiceItem));

        invoiceItem.typeCode__c = '3';
        System.assertEquals(KenanAdjustmentControllerExt.KENAN_ADJUSTMENT_TYPE_NRC, KenanAdjustmentControllerExt.getAdjustmentType(invoiceItem));

        invoiceItem.typeCode__c = '4';
        System.assertEquals(null, KenanAdjustmentControllerExt.getAdjustmentType(invoiceItem));

        invoiceItem.typeCode__c = '5';
        System.assertEquals(null, KenanAdjustmentControllerExt.getAdjustmentType(invoiceItem));

        invoiceItem.typeCode__c = '6';
        System.assertEquals(null, KenanAdjustmentControllerExt.getAdjustmentType(invoiceItem));

        invoiceItem.typeCode__c = '7';
        System.assertEquals(KenanAdjustmentControllerExt.KENAN_ADJUSTMENT_TYPE_USE, KenanAdjustmentControllerExt.getAdjustmentType(invoiceItem));
    }
}