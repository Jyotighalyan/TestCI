@isTest
public class UM_DeactivateBA_BatchTest{
@testSetup

static void setup() {

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
        
//insert Cilling contact:
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
}

static testmethod void test_UM_DeactivateBillAccBatch(){
 //setup();

 
  System.debug('BillingAccount---->..'+[SELECT Id, Name FROM csconta__Billing_Account__c]);
System.debug('BillingAccount123---->..'+[SELECT Id, Name FROM csconta__Billing_Account__c WHERE csconta__Status__c = 'Deactivation Requested']);


Test.startTest();
UM_DeactivateBA_Batch deactba = new UM_DeactivateBA_Batch();
        Database.executeBatch(deactba);
Test.stopTest();

List<csconta__Billing_Account__c> billAccList=[SELECT id,csconta__Status__c 
                                                    FROM csconta__Billing_Account__c 
                                                     LIMIT 1];
                                                     
 for(csconta__Billing_Account__c billing_Obj :billAccList){
     
     //System.assertEquals('Deactivation Pending', billing_Obj .csconta__Status__c);
     //System.assertEquals('Active',billing_Obj .csconta__Status__c);
     System.assertEquals('New',billing_Obj .csconta__Status__c);
 }

}

/*** Schedule timings: *****/
static testmethod void  test_scheduled_Deactivation(){
         Test.StartTest();
        /* UM_DeactivateBA_Schedule bSchedule = new UM_DeactivateBA_Schedule();     
         String schedule = '0 0 0 * * ?';
         system.schedule('Test', schedule, bSchedule);
         List<csconta__Billing_Account__c> billingobjList = new List<csconta__Billing_Account__c>(); */
         
         UM_DeactivateBA_ScheduleBatch beSchedule = new UM_DeactivateBA_ScheduleBatch();
         
        Test.stopTest();

}
}