@isTest
private class KenanAdjustmentProcessBuilderTest {
    
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


        UM_InvoiceHeader__c invoiceHeader = new UM_InvoiceHeader__c();
        invoiceHeader.UM_Customer_SF_ID__c = acct.Id;
        invoiceHeader.UM_Invoice_Date__c = Date.today().addDays(-5);
        invoiceHeader.UM_InvoiceNumber__c = '1.0';
        invoiceHeader.UM_Invoice_Amount_Gross_Currency__c = 100.00;
        invoiceHeader.UM_Invoice_Amount_Net_Currency__c = 75.00;
        invoiceHeader.UM_Invoice_Amount_Gross__c = 100;
        invoiceHeader.UM_Invoice_Amount_Net__c = 75;
        invoiceHeader.UM_Payment_Due_Date__c = Date.today().addDays(30);
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

    @isTest
    static void testUpdateAdjustment() {
        List<Kenan_Adjustment__c> adjustments = new List<Kenan_Adjustment__c>([SELECT Id, trackingId__c, trackingIdServ__c FROM Kenan_Adjustment__c]);
        Exception ke;
        Test.startTest();
        try {
            KenanAdjustmentProcessBuilder.updateAdjustment(adjustments);    
        }
        catch (Exception e){
            ke = e;
        }
        
        Test.stopTest();
        System.assertEquals(null, ke);
    }

    @isTest
    static void testUpdateAdjustmentCallout() {
        Kenan_Adjustment__c adjustment = [SELECT Id, trackingId__c, trackingIdServ__c FROM Kenan_Adjustment__c LIMIT 1];
        Exception ke;
        Test.startTest();
        try {
            KenanAdjustmentProcessBuilder.updateAdjustmentCallout(adjustment.Id);
        }
        catch (Exception e){
            ke = e;
        }

        Test.stopTest();
        System.assertEquals(null, ke);
    }

    @isTest
    static void testUpdateAdjustmentCalloutError() {
        Kenan_Adjustment__c adjustment = [SELECT Id, trackingId__c, trackingIdServ__c FROM Kenan_Adjustment__c LIMIT 1];
        Exception ke;
        Test.startTest();
        try {
            KenanAdjustmentProcessBuilder.updateAdjustmentCallout(adjustment.Id);
        }
        catch (Exception e){
            ke = e;
        }
        Test.stopTest();
        System.assertEquals(null, ke);
    }

    @isTest
    static void testSendEmailNotification() {
        Kenan_Adjustment__c adjustment = [SELECT Id, trackingId__c, trackingIdServ__c FROM Kenan_Adjustment__c LIMIT 1];
        KenanException ke = new KenanException();
        Test.startTest();
        KenanAdjustmentProcessBuilder.sendEmailNotification(adjustment, ke);
        Test.stopTest();
    }
    
}