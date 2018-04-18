@isTest
public class UM_Deactivate_Billing_Account_Test{

  @testsetup
   private static void setupTestData()
   {
        KenanServiceConnection__c ksc = new KenanServiceConnection__c();
        ksc.Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=';
        ksc.Session_Timeout__c = '120000';
        ksc.Connection_URL__c = 'https://dev-aws-oag-pe.upc.biz';
        ksc.REST_Application_Base__c = '/kenan-salesforce-api/rest';
        ksc.Stored_Language_Code__c = '1';
        insert ksc; 
        
//Insert Account:
        Account mAccount = new Account(Name='Test Account');
        mAccount.LG_BillingEmailAddress__c='ra.su@infy.com';
        mAccount.LG_PostalStreet__c = 'Aachener Str.';
        mAccount.LG_PostalCity__c = 'Köln';
        mAccount.UM_VisitStateProvince__c = 'NRW';
        mAccount.LG_PostalPostalCode__c = '50933';
        mAccount.LG_PostalHouseNumber__c = '746';
        mAccount.LG_PostalHouseNumberExtension__c = '-750';
        mAccount.LG_Segment__c='SME';
        mAccount.LG_ChamberOfCommerceNumber__c = 'C12685333';
        mAccount.LG_VIP__c=false;
        mAccount.UM_Legal_Name__c='abc';
        insert mAccount;
        
//insert Billing contact:
        Contact billingContact = new Contact(FirstName = 'First', LastName = 'Last', AccountId = mAccount.id, Salutation='Mr.');
        insert billingContact;
        
//Insert BA:
        csconta__Billing_Account__c billingAccount = new csconta__Billing_Account__c (csconta__Account__c = mAccount.id);
        billingAccount.csconta__Status__c = 'Deactivation Requested'; 
        billingAccount.csconta__Billing_Channel__c = 'Paper'; 
        billingAccount.UM_BillFormatOptions__c = 'Summary';
        billingAccount.Billing_Contact__c = billingContact.id; 
        billingAccount.LG_PaymentType__c = 'Direct debit';
        billingAccount.LG_BankAccountNumberIBAN__c = 'DE85604500500002819471';
        billingAccount.LG_BankAccountHolder__c='Test BA';
        billingAccount.csconta__Payment_Terms__c = 'M02 - Test'; 
        billingAccount.csconta__Street__c='Aachener Str.'; 
        billingAccount.LG_HouseNumber__c='746';
        billingAccount.LG_HouseNumberExtension__c ='-750'; 
        billingAccount.csconta__City__c= 'Köln'; 
        billingAccount.csconta__Country__c= 'Germany'; 
        billingAccount.UM_Billing_State_Province__c= 'NRW'; 
        billingAccount.csconta__Postcode__c = '50933';
        insert billingAccount;
    
        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'TestM', csord__Module_Version__c = '1.0');
            insert coreq;
        
    csord__Subscription__c sub = new csord__Subscription__c(csord__Account__c=mAccount.id,csord__Identification__c = 'TestIdentM',csord__Status__c='Active', csord__Order_Request__c = coreq.Id, csconta__Billing_Account__c=billingAccount.Id);
    insert sub;
    
    cscrm__Address__c add= new cscrm__Address__c(cscrm__Street__c = 'TestStreetM');
    insert add;
    csord__Service__c intService = new csord__Service__c(csord__Identification__c = 'TestIdentSubM', csord__Order_Request__c = coreq.Id,csord__Status__c='Inactive',
                              csord__Subscription__c = sub.Id, csord__Deactivation_Date__c=Date.Today()-1, LG_Address__c = add.Id, LG_ProductFamily__c = 'Internet');
    insert intService;
    
    /** --Second Records--**/
    //Insert BA:
        csconta__Billing_Account__c billingAccount2 = new csconta__Billing_Account__c (csconta__Account__c = mAccount.id);
        billingAccount2.csconta__Status__c = 'New'; 
        billingAccount2.csconta__Billing_Channel__c = 'Paper'; 
        billingAccount2.UM_BillFormatOptions__c = 'Summary';
        billingAccount2.Billing_Contact__c = billingContact.id; 
        billingAccount2.LG_PaymentType__c = 'Direct debit';
        billingAccount2.LG_BankAccountNumberIBAN__c = 'DE85604500500002819471';
        billingAccount2.LG_BankAccountHolder__c='Test BA';
        billingAccount2.csconta__Payment_Terms__c = 'M02 - Test'; 
        billingAccount2.csconta__Street__c='Aachener Str.'; 
        billingAccount2.LG_HouseNumber__c='746';
        billingAccount2.LG_HouseNumberExtension__c ='-750'; 
        billingAccount2.csconta__City__c= 'Köln'; 
        billingAccount2.csconta__Country__c= 'Germany'; 
        billingAccount2.UM_Billing_State_Province__c= 'NRW'; 
        billingAccount2.csconta__Postcode__c = '50933';
        insert billingAccount2;
    
        csord__Order_Request__c coreq2 = new csord__Order_Request__c(csord__Module_Name__c = 'TestM', csord__Module_Version__c = '1.0');
            insert coreq2;
        
    csord__Subscription__c sub2 = new csord__Subscription__c(csord__Account__c=mAccount.id,csord__Identification__c = 'TestIdentM',csord__Status__c='Active', csord__Order_Request__c = coreq2.Id, csconta__Billing_Account__c=billingAccount2.Id);
    insert sub2;
    
    csord__Service__c intService2 = new csord__Service__c(csord__Identification__c = 'TestIdentSubM', csord__Order_Request__c = coreq2.Id,csord__Status__c='Inactive',
                              csord__Subscription__c = sub2.Id, csord__Deactivation_Date__c=Date.Today(), LG_Address__c = add.Id, LG_ProductFamily__c = 'Internet');
    insert intService2;
    
    /** --Third Records--**/
    //Insert BA:
        csconta__Billing_Account__c billingAccount3 = new csconta__Billing_Account__c (csconta__Account__c = mAccount.id);
        billingAccount3.csconta__Status__c = 'New'; 
        billingAccount3.csconta__Billing_Channel__c = 'Paper'; 
        billingAccount3.UM_BillFormatOptions__c = 'Summary';
        billingAccount3.Billing_Contact__c = billingContact.id; 
        billingAccount3.LG_PaymentType__c = 'Direct debit';
        billingAccount3.LG_BankAccountNumberIBAN__c = 'DE85604500500002819471';
        billingAccount3.LG_BankAccountHolder__c='Test BA';
        billingAccount3.csconta__Payment_Terms__c = 'M02 - Test'; 
        billingAccount3.csconta__Street__c='Aachener Str.'; 
        billingAccount3.LG_HouseNumber__c='746';
        billingAccount3.LG_HouseNumberExtension__c ='-750'; 
        billingAccount3.csconta__City__c= 'Köln'; 
        billingAccount3.csconta__Country__c= 'Germany'; 
        billingAccount3.UM_Billing_State_Province__c= 'NRW'; 
        billingAccount3.csconta__Postcode__c = '50944';
        insert billingAccount3;
       
           
    /** --Fourth Records--**/
    //Insert BA:
        csconta__Billing_Account__c billingAccount4 = new csconta__Billing_Account__c (csconta__Account__c = mAccount.id);
        billingAccount4.csconta__Status__c = 'New'; 
        billingAccount4.csconta__Billing_Channel__c = 'Paper'; 
        billingAccount4.UM_BillFormatOptions__c = 'Summary';
        billingAccount4.Billing_Contact__c = billingContact.id; 
        billingAccount4.LG_PaymentType__c = 'Direct debit';
        billingAccount4.LG_BankAccountNumberIBAN__c = 'DE85604500500002819471';
        billingAccount4.LG_BankAccountHolder__c='Test BA';
        billingAccount4.csconta__Payment_Terms__c = 'M02 - Test'; 
        billingAccount4.csconta__Street__c='Aachener Str.'; 
        billingAccount4.LG_HouseNumber__c='746';
        billingAccount4.LG_HouseNumberExtension__c ='-750'; 
        billingAccount4.csconta__City__c= 'Köln'; 
        billingAccount4.csconta__Country__c= 'Germany'; 
        billingAccount4.UM_Billing_State_Province__c= 'NRW'; 
        billingAccount4.csconta__Postcode__c = '00001';
        insert billingAccount4;
}
   
   /**This will test the method deactiavteBA if Service Deactivate Date is less than Today's date**/
   static testMethod void testDeactivateBATrue ()
   {
     csconta__Billing_Account__c  billAcc =[SELECT id,csconta__Status__c FROM csconta__Billing_Account__c 
                                                     WHERE csconta__Status__c ='Deactivation Requested' LIMIT 1];
     String BillingId = billAcc.Id;
     Test.startTest();
     UM_Deactivate_Billing_Account.deactivateBA(BillingId);
     billAcc.csconta__Status__c = 'New';
     update billAcc;
     UM_Deactivate_Billing_Account.deactivateBA(BillingId);
     test.stopTest();
     
   }
 
   /**This will test the method deactiavteBA if Service Deactivate Date is equal or greater than Today's date**/
   static testMethod void testDeactivateBAForGreaterDate ()
   {
     csconta__Billing_Account__c  billAcc =[SELECT id,csconta__Status__c FROM csconta__Billing_Account__c 
                                                     WHERE csconta__Status__c ='New' LIMIT 1];
     String BillingId = billAcc.Id;
     Test.startTest();
     UM_Deactivate_Billing_Account.deactivateBA(BillingId);
     test.stopTest();
     
   }
   
   /**This will test the method deactiavteBA if No Service is attached with the BA **/
   static testMethod void testDeactivateBANoService()
   {
    csconta__Billing_Account__c  billAcc =[SELECT id,csconta__Status__c FROM csconta__Billing_Account__c 
                                                     WHERE csconta__Status__c ='Deactivation Requested' LIMIT 1];
     String BillingId = billAcc.Id;
     Test.startTest();
    // UM_Deactivate_Billing_Account.deactivateBA(BillingId);
     billAcc.csconta__Status__c = 'Deactivation Pending';
     update billAcc;
     UM_Deactivate_Billing_Account.deactivateBA(BillingId);
     test.stopTest();
     
   }
    
     /**This will test the method deactiavteBA if Associated Services does not meet the criteria **/
   static testMethod void testDeactivateBANoFilteredService()
   {
     csconta__Billing_Account__c  billingAccount3 =[SELECT id,csconta__Status__c FROM csconta__Billing_Account__c 
                                                     WHERE csconta__Postcode__c ='50944' LIMIT 1];
     String BillingId = billingAccount3.Id;
    
       Account mAccount = [Select id FROM Account where UM_Legal_Name__c = 'abc'];
       csord__Order_Request__c coreq3 = new csord__Order_Request__c(csord__Module_Name__c = 'TestM', csord__Module_Version__c = '1.0');
            insert coreq3;
        
    csord__Subscription__c sub3 = new csord__Subscription__c(csord__Account__c=mAccount.id,csord__Identification__c = 'TestIdentM',csord__Status__c='Active', csord__Order_Request__c = coreq3.Id, csconta__Billing_Account__c=billingAccount3.Id);
    insert sub3;
     cscrm__Address__c add= new cscrm__Address__c(cscrm__Street__c = 'TestStreetM');
    insert add;
    csord__Service__c intService3 = new csord__Service__c(csord__Identification__c = 'TestIdentSubM', csord__Order_Request__c = coreq3.Id,csord__Status__c='Active',
                              csord__Subscription__c = sub3.Id, csord__Deactivation_Date__c=Date.Today()-1, LG_Address__c = add.Id, LG_ProductFamily__c = 'Internet');
    insert intService3;
       
     Test.startTest();
     UM_Deactivate_Billing_Account.deactivateBA(BillingId);
     test.stopTest();
     
   }
    
    /**This will test the method deactiavteBA and will check BA status**/
   static testMethod void testDeactivateBAStatus()
   {
     csconta__Billing_Account__c  billAcc =[SELECT id,csconta__Status__c FROM csconta__Billing_Account__c 
                                                     WHERE csconta__Status__c ='Deactivation Requested' LIMIT 1];
     String BillingId = billAcc.Id;
     Test.startTest();
     billAcc.csconta__Status__c = 'Deactivation Pending';
     update billAcc;
     UM_Deactivate_Billing_Account.deactivateBA(BillingId);
     billAcc.csconta__Status__c = 'Inactive';
     update billAcc;
     UM_Deactivate_Billing_Account.deactivateBA(BillingId);
     test.stopTest();
     
   }
  
}