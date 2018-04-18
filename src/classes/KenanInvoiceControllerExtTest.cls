/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanInvoiceControllerExt Unit Tests
*/
@isTest
private class KenanInvoiceControllerExtTest {
    private static String accDefBillingName = 'AccWithOneDef';
    private static String accUpdateName = 'AccWithTwoDef';
    @testSetup
    static void setup() {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        List<Account> accounts = new List<Account>();
        Account accDefBilling = LG_GeneralTest.CreateAccount(accDefBillingName, '12345678', 'Ziggo', false);
        accounts.add(accDefBilling);
        insert accounts;    
        
        Contact tmpContact = new Contact();
        tmpContact.AccountId=accDefBilling.Id;
        tmpContact.Firstname='Firstname';
        tmpContact.LastName='LastName';
        tmpContact.Salutation='Mr.';
        insert tmpContact;
        
        List<csconta__Billing_Account__c> billAccounts = new List<csconta__Billing_Account__c>();
        csconta__Billing_Account__c billAccount = LG_GeneralTest.createBillingAccount('SFDT-59 Bill1', accDefBilling.Id, true, false);
        billAccounts.add(billAccount);
        insert billAccounts;
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
        
        Account acct = new Account();
        acct.Name = 'Test Account Name';
        insert acct;
        
        //TODO: Uncomment after Deployment
        
        
        UM_InvoiceHeader__c invoiceHeader = new UM_InvoiceHeader__c();
        invoiceHeader.UM_Customer_SF_ID__c = acct.Id;
        invoiceHeader.UM_Invoice_Date__c = Date.today().addDays(-5);
        invoiceHeader.UM_InvoiceNumber__c = '1.0';
        invoiceHeader.UM_Invoice_Amount_Gross_Currency__c = 100.00;
        invoiceHeader.UM_Invoice_Amount_Net_Currency__c = 75.00;
        invoiceHeader.UM_Invoice_Amount_Gross__c = 100;
        invoiceHeader.UM_Invoice_Amount_Net__c = 75;
        invoiceHeader.UM_Payment_Due_Date__c = Date.today().addDays(30);
        //TODO: Uncomment after deployment
        invoiceHeader.UM_Billing_Location__c = billAccount.Id;
        
        insert invoiceHeader;
    }
    
    private static List<UM_InvoiceHeader__c> getInvoiceHeaders() {
        return [
            SELECT 
            UM_Customer_SF_ID__c, 
            UM_Invoice_Date__c,
            UM_InvoiceNumber__c,
            UM_Invoice_Amount_Gross_Currency__c,
            UM_Invoice_Amount_Net_Currency__c,
            UM_Invoice_Amount_Gross__c,
            UM_Invoice_Amount_Net__c,
            UM_Payment_Due_Date__c,
            UM_Billing_Location__c
            
            FROM
            UM_InvoiceHeader__c
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
    
    private static Set<String> getFields(List<Schema.FieldSetMember> fieldSetMembers) {
        Set<String> fields = new Set<String>();
        
        for (Schema.FieldSetMember fieldSetMember: fieldSetMembers) {
            fields.add(fieldSetMember.getFieldPath());
        }
        
        return fields;
    }
    
    @isTest
    static void testConstructor() {
        List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
        
        Test.startTest();
        ApexPages.StandardController stdCon = new ApexPages.StandardController(invoiceHeaders.get(0));
        KenanInvoiceControllerExt extCon = new KenanInvoiceControllerExt(stdCon);
        Test.stopTest();
        
        System.assertNotEquals(null, extCon);
    }
    
    @isTest
    static void testGetInvoiceHeader() {
        List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
        UM_InvoiceHeader__c invoiceHeader = invoiceHeaders.get(0);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(invoiceHeaders.get(0));
        KenanInvoiceControllerExt extCon = new KenanInvoiceControllerExt(stdCon);
        
        Test.startTest();
        UM_InvoiceHeader__c retrievedInvoiceHeader = extCon.getInvoiceHeader();
        Test.stopTest();
        
        System.assertNotEquals(null, retrievedInvoiceHeader);
        System.assertEquals(invoiceHeader.UM_Customer_SF_ID__c, retrievedInvoiceHeader.UM_Customer_SF_ID__c);
        System.assertEquals(invoiceHeader.UM_Invoice_Date__c, retrievedInvoiceHeader.UM_Invoice_Date__c);
        System.assertEquals(invoiceHeader.UM_InvoiceNumber__c, retrievedInvoiceHeader.UM_InvoiceNumber__c);
        System.assertEquals(invoiceHeader.UM_Invoice_Amount_Gross_Currency__c, retrievedInvoiceHeader.UM_Invoice_Amount_Gross_Currency__c);
        System.assertEquals(invoiceHeader.UM_Invoice_Amount_Gross__c, retrievedInvoiceHeader.UM_Invoice_Amount_Gross__c);
        System.assertEquals(invoiceHeader.UM_Invoice_Amount_Net__c, retrievedInvoiceHeader.UM_Invoice_Amount_Net__c);
        System.assertEquals(invoiceHeader.UM_Payment_Due_Date__c, retrievedInvoiceHeader.UM_Payment_Due_Date__c);
    }
    
    @isTest
    static void testKenanInvoiceAccountFieldSet() {
        List<Schema.FieldSetMember> expectedFieldSetMembers = SObjectType.InvoiceItem__x.FieldSets.Kenan_Invoice_Account.getFields();
        Set<String> fields = getFields(expectedFieldSetMembers);
        
        List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
        ApexPages.StandardController stdCon = new ApexPages.StandardController(invoiceHeaders.get(0));
        KenanInvoiceControllerExt extCon = new KenanInvoiceControllerExt(stdCon);
        
        Test.startTest();
        List<Schema.FieldSetMember> fieldSetMembers = extCon.getAccountFields();
        Test.stopTest();
        
        System.assertEquals(expectedFieldSetMembers.size(), fieldSetMembers.size());
        
        for (Schema.FieldSetMember fieldSetMember: fieldSetMembers) {
            System.assert(fields.contains(fieldSetMember.getFieldPath()));
        }
    }
    
    @isTest
    static void testKenanInvoicePaymentFieldSet() {
        List<Schema.FieldSetMember> expectedFieldSetMembers = SObjectType.InvoiceItem__x.FieldSets.Kenan_Invoice_Payment.getFields();
        Set<String> fields = getFields(expectedFieldSetMembers);
        
        List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
        ApexPages.StandardController stdCon = new ApexPages.StandardController(invoiceHeaders.get(0));
        KenanInvoiceControllerExt extCon = new KenanInvoiceControllerExt(stdCon);
        
        Test.startTest();
        List<Schema.FieldSetMember> fieldSetMembers = extCon.getPaymentFields();
        Test.stopTest();
        
        System.assertEquals(expectedFieldSetMembers.size(), fieldSetMembers.size());
        
        for (Schema.FieldSetMember fieldSetMember: fieldSetMembers) {
            System.assert(fields.contains(fieldSetMember.getFieldPath()));
        }
    }
    
    @isTest
    static void testKenanInvoiceServiceFieldSet() {
        List<Schema.FieldSetMember> expectedFieldSetMembers = SObjectType.InvoiceItem__x.FieldSets.Kenan_Invoice_Service.getFields();
        Set<String> fields = getFields(expectedFieldSetMembers);
        
        List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
        ApexPages.StandardController stdCon = new ApexPages.StandardController(invoiceHeaders.get(0));
        KenanInvoiceControllerExt extCon = new KenanInvoiceControllerExt(stdCon);
        
        Test.startTest();
        List<Schema.FieldSetMember> fieldSetMembers = extCon.getServiceFields();
        Test.stopTest();
        
        System.assertEquals(expectedFieldSetMembers.size(), fieldSetMembers.size());
        
        for (Schema.FieldSetMember fieldSetMember: fieldSetMembers) {
            System.assert(fields.contains(fieldSetMember.getFieldPath()));
        }
    }
    
    @isTest
    static void testGetInvoiceItems() {
        List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
        UM_InvoiceHeader__c invoiceHeader = invoiceHeaders.get(0);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(invoiceHeaders.get(0));
        KenanInvoiceControllerExt extCon = new KenanInvoiceControllerExt(stdCon);
        
        Test.startTest();
        List<InvoiceItem__x> retrievedInvoiceItems = extCon.getInvoiceItems();
        Test.stopTest();
        
        System.assertNotEquals(null, retrievedInvoiceItems);
        System.assert(retrievedInvoiceItems.isEmpty());
    }
    
    @isTest
    static void testCancel() {
        List<Account> accounts = getAccounts();
        Account acct = accounts.get(0);
        List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
        UM_InvoiceHeader__c invoiceHeader = invoiceHeaders.get(0);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(invoiceHeaders.get(0));
        KenanInvoiceControllerExt extCon = new KenanInvoiceControllerExt(stdCon);
        
        Test.startTest();
        PageReference pageRef = extCon.cancel();
        Test.stopTest();
        
        //System.assert(pageRef.getUrl().contains(acct.Id));
    }
    
    @isTest
    static void testGetAccountLevelInvoiceItems() {
        List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
        UM_InvoiceHeader__c invoiceHeader = invoiceHeaders.get(0);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(invoiceHeaders.get(0));
        KenanInvoiceControllerExt extCon = new KenanInvoiceControllerExt(stdCon);
        
        Test.startTest();
        List<InvoiceItem__x> accountLevelItems = extCon.getAccountLevelInvoiceItems();
        Test.stopTest();
        
        System.assertEquals(0, accountLevelItems.size());
    }
    
    @isTest
    static void testGetPaymentItems() {
        List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
        UM_InvoiceHeader__c invoiceHeader = invoiceHeaders.get(0);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(invoiceHeaders.get(0));
        KenanInvoiceControllerExt extCon = new KenanInvoiceControllerExt(stdCon);
        
        Test.startTest();
        List<InvoiceItem__x> paymentItems = extCon.getPaymentInvoiceItems();
        Test.stopTest();
        
        //System.assert(!paymentItems.isEmpty());
    }
    
     @isTest
    static void getInvoiceTotalItemsTest() {
        List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
        UM_InvoiceHeader__c invoiceHeader = invoiceHeaders.get(0);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(invoiceHeaders.get(0));
        KenanInvoiceControllerExt extCon = new KenanInvoiceControllerExt(stdCon);
        
        Test.startTest();
        List<InvoiceItem__x> retrievedInvoiceItems = extCon.getInvoiceTotalItems();
        Test.stopTest();
        
        System.assertNotEquals(null, retrievedInvoiceItems);
        System.assert(retrievedInvoiceItems.isEmpty());
    }
     @isTest
    static void getAdjustmentItemsTest() {
        List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
        UM_InvoiceHeader__c invoiceHeader = invoiceHeaders.get(0);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(invoiceHeaders.get(0));
        KenanInvoiceControllerExt extCon = new KenanInvoiceControllerExt(stdCon);
        
        Test.startTest();
        List<InvoiceItem__x> retrievedInvoiceItems = extCon.getAdjustmentItems();
        Test.stopTest();
        
        System.assertNotEquals(null, retrievedInvoiceItems);
        System.assert(retrievedInvoiceItems.isEmpty());
    }
    
    @isTest
    static void KenanServiceInvoiceItemWrapperTest() {
        List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
        UM_InvoiceHeader__c invoiceHeader = invoiceHeaders.get(0);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(invoiceHeaders.get(0));
        KenanInvoiceControllerExt extCon = new KenanInvoiceControllerExt(stdCon);
        
        Test.startTest();
        List<KenanInvoiceControllerExt.KenanServiceInvoiceItemWrapper> wrappers = extCon.getServiceWrappers();
        Test.stopTest();
        
       
    }
    
    @isTest
    static void testGetAccountLevelTotal() {
        List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
        UM_InvoiceHeader__c invoiceHeader = invoiceHeaders.get(0);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(invoiceHeaders.get(0));
        KenanInvoiceControllerExt extCon = new KenanInvoiceControllerExt(stdCon);
        
        Test.startTest();
        Decimal accountTotal = extCon.getAccountLevelTotal();
        Test.stopTest();
        
        System.assertNotEquals(null, accountTotal);
    }
    
    @isTest
    static void testgetInvoiceTotal() {
        List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
        UM_InvoiceHeader__c invoiceHeader = invoiceHeaders.get(0);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(invoiceHeaders.get(0));
        KenanInvoiceControllerExt extCon = new KenanInvoiceControllerExt(stdCon);
        
        Test.startTest();
        Decimal accountTotal = extCon.getInvoiceTotal();
        Test.stopTest();
        
        System.assertNotEquals(null, accountTotal);
    }
    @isTest
    static void testgetNewInvoiceTotal() {
        List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
        UM_InvoiceHeader__c invoiceHeader = invoiceHeaders.get(0);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(invoiceHeaders.get(0));
        KenanInvoiceControllerExt extCon = new KenanInvoiceControllerExt(stdCon);
        
        Test.startTest();
        Decimal accountTotal = extCon.getNewInvoiceTotal();
        Test.stopTest();
        
        System.assertNotEquals(null, accountTotal);
    }
    
    
    @isTest
    static void testGetPaymentTotal() {
        List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
        UM_InvoiceHeader__c invoiceHeader = invoiceHeaders.get(0);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(invoiceHeaders.get(0));
        KenanInvoiceControllerExt extCon = new KenanInvoiceControllerExt(stdCon);
        
        Test.startTest();
        Decimal paymentTotal = extCon.getPaymentTotal();
        Test.stopTest();
        
        System.assertNotEquals(null, paymentTotal);
    }
    
    @isTest
    static void testGetServiceTotal() {
        List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders();
        UM_InvoiceHeader__c invoiceHeader = invoiceHeaders.get(0);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(invoiceHeaders.get(0));
        KenanInvoiceControllerExt extCon = new KenanInvoiceControllerExt(stdCon);
        
        Test.startTest();
        Decimal serviceTotal = extCon.getServiceTotal();
        Test.stopTest();
        
        System.assertNotEquals(null, serviceTotal);
    }
    
    @isTest
    static void testPageref() {
        
        List<UM_InvoiceHeader__c> invoiceHeaders = getInvoiceHeaders(); 
        UM_InvoiceHeader__c invoice1 = invoiceHeaders.get(0);
        ApexPages.StandardController sc = new ApexPages.standardController(invoiceHeaders.get(0));
        KenanInvoiceControllerExt  controller = new KenanInvoiceControllerExt(sc);
        test.startTest();
        PageReference pageRef = new PageReference('/500/e?retURL=%2F500%2Fo&ent=Case');
        Id RType = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.Care_B2B_RecordType_Billing_Query).getRecordTypeId();
        pageRef.getParameters().put('id',invoice1.id);
        
        Test.setCurrentPage(pageRef); 
        
        
        PageReference pageRef2 =controller.case();
        
        //System.assertNotEquals(null,PageRef2);
        system.assertNotEquals(null, pageRef2);
        
        test.stopTest();
        
    }  
    
 
    
    
}