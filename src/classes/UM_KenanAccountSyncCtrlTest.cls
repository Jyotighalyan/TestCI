@isTest
public class UM_KenanAccountSyncCtrlTest {
    
    private static void createBillingAccountFieldsMapping(){
       list<UM_Kenan_Mappings__c> kenanSettings = new list<UM_Kenan_Mappings__c> ();
        UM_Kenan_Mappings__c kenanMapping = new UM_Kenan_Mappings__c();
        kenanMapping.Name = 'billAddress1';
        kenanMapping.Field_Name__c = 'csconta__Street__c';
        kenanSettings.add(kenanMapping);
        
        kenanMapping = new UM_Kenan_Mappings__c();
        kenanMapping.Name = 'billCity';
        kenanMapping.Field_Name__c = 'csconta__City__c';
        kenanSettings.add(kenanMapping);
        
        kenanMapping = new UM_Kenan_Mappings__c();
        kenanMapping.Name = 'billCompany';
        kenanMapping.Field_Name__c = 'Account_Name__c';
        kenanSettings.add(kenanMapping);
        
        kenanMapping = new UM_Kenan_Mappings__c();
        kenanMapping.Name = 'billFname';
        kenanMapping.Field_Name__c = 'Billing_Contact__r';
        kenanSettings.add(kenanMapping);                
        
        kenanMapping = new UM_Kenan_Mappings__c();
        kenanMapping.Name = 'billLname';
        kenanMapping.Field_Name__c = 'Billing_Contact__r';
        kenanSettings.add(kenanMapping);
        
        kenanMapping = new UM_Kenan_Mappings__c();
        kenanMapping.Name = 'billState';
        kenanMapping.Field_Name__c = 'UM_Billing_State_Province__c';
        kenanSettings.add(kenanMapping);
        
        kenanMapping = new UM_Kenan_Mappings__c();
        kenanMapping.Name = 'billZip';
        kenanMapping.Field_Name__c = 'csconta__Postcode__c';
        kenanSettings.add(kenanMapping);
        
        kenanMapping = new UM_Kenan_Mappings__c();
        kenanMapping.Name = 'houseNumber';
        kenanMapping.Field_Name__c = 'LG_HouseNumber__c';
        kenanSettings.add(kenanMapping);
        
        kenanMapping = new UM_Kenan_Mappings__c();
        kenanMapping.Name = 'houseNumberExt';
        kenanMapping.Field_Name__c = 'LG_HouseNumberExtension__c';
        kenanSettings.add(kenanMapping);
        
        
        kenanMapping = new UM_Kenan_Mappings__c();
        kenanMapping.Name = 'mktCode';
        kenanMapping.Field_Name__c = 'LG_ContractualOrganization__c';
        kenanSettings.add(kenanMapping);
        
        kenanMapping = new UM_Kenan_Mappings__c();
        kenanMapping.Name = 'billFmtOpt';
        kenanMapping.Field_Name__c = 'UM_BillFormatOptions__c';
        kenanSettings.add(kenanMapping);
        
        kenanMapping = new UM_Kenan_Mappings__c();
        kenanMapping.Name = 'billDispMeth';
        kenanMapping.Field_Name__c = 'csconta__Billing_Channel__c';
        kenanSettings.add(kenanMapping);
        
        kenanMapping = new UM_Kenan_Mappings__c();
        kenanMapping.Name = 'billPeriod';
        kenanMapping.Field_Name__c = 'csconta__Payment_Terms__c';
        kenanSettings.add(kenanMapping);
              
        insert kenanSettings; 
    }
    
    private static void createMasterAccountFieldsMapping(){
       list<UM_Kenan_Master_Account__c > kenanSettings = new list<UM_Kenan_Master_Account__c > ();
        UM_Kenan_Master_Account__c  kenanMapping = new UM_Kenan_Master_Account__c ();
        kenanMapping.Name = 'billAddress1';
        kenanMapping.Field_Name__c = 'LG_PostalStreet__c';
        kenanSettings.add(kenanMapping);
        
        kenanMapping = new UM_Kenan_Master_Account__c ();
        kenanMapping.Name = 'billCity';
        kenanMapping.Field_Name__c = 'LG_PostalCity__c';
        kenanSettings.add(kenanMapping);        
        
		kenanMapping = new UM_Kenan_Master_Account__c ();
        kenanMapping.Name = 'accountCategory';
        kenanMapping.Field_Name__c = 'LG_Segment__c';
        kenanSettings.add(kenanMapping);
	
		kenanMapping = new UM_Kenan_Master_Account__c ();
        kenanMapping.Name = 'vipCode';
        kenanMapping.Field_Name__c = 'LG_VIP__c';
        kenanSettings.add(kenanMapping);
	
        kenanMapping = new UM_Kenan_Master_Account__c ();
        kenanMapping.Name = 'billState';
        kenanMapping.Field_Name__c = 'UM_VisitStateProvince__c';
        kenanSettings.add(kenanMapping);
        
        kenanMapping = new UM_Kenan_Master_Account__c ();
        kenanMapping.Name = 'billZip';
        kenanMapping.Field_Name__c = 'LG_PostalPostalCode__c';
        kenanSettings.add(kenanMapping);
        
        kenanMapping = new UM_Kenan_Master_Account__c ();
        kenanMapping.Name = 'billCompany';
        kenanMapping.Field_Name__c = 'Name';
        kenanSettings.add(kenanMapping);
        
         kenanMapping = new UM_Kenan_Master_Account__c ();
        kenanMapping.Name = 'houseNumber';
        kenanMapping.Field_Name__c = 'LG_PostalHouseNumber__c';
        kenanSettings.add(kenanMapping);
        
         kenanMapping = new UM_Kenan_Master_Account__c ();
        kenanMapping.Name = 'houseNumberExt';
        kenanMapping.Field_Name__c = 'LG_PostalHouseNumberExtension__c';
        kenanSettings.add(kenanMapping);
        
       
        insert kenanSettings; 
    }
    private static void createNRCReasonSettings()
    {
        UM_Kenan_NRCReason_Mapping__c nrc = new UM_Kenan_NRCReason_Mapping__c();
        nrc.UM_Kenan_Code__c = '2632';
        nrc.UM_Kenan_NRC_Reason__c = 'Falscher Rechnungsbetrag';
        nrc.UM_Is_Active__c = true;
        nrc.name = '2632_FalscherRechnungsbetrag';
        insert nrc;
    }
    
    @testSetup static void setupData(){
        createBillingAccountFieldsMapping();
        createMasterAccountFieldsMapping();
        
        KenanServiceConnection__c ksc = new KenanServiceConnection__c();
        ksc.Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=';
        ksc.Session_Timeout__c = '120000';
        ksc.Connection_URL__c = 'https://dev-aws-oag-pe.upc.biz';
        ksc.REST_Application_Base__c = '/kenan-salesforce-api/rest';
        ksc.Stored_Language_Code__c = '1';
        insert ksc; 
        
        Account masterAccount = new Account(Name='Test Account');
        masterAccount.LG_PostalStreet__c = 'Aachener Str.';
        masterAccount.LG_PostalCity__c = 'K�ln';
        masterAccount.UM_VisitStateProvince__c = 'NRW';
        masterAccount.LG_PostalPostalCode__c = '50933';
        masterAccount.LG_PostalHouseNumber__c = '746';
        masterAccount.LG_PostalHouseNumberExtension__c = '-750';
        masterAccount.LG_Segment__c='SME';
        masterAccount.LG_ChamberOfCommerceNumber__c = 'C12132312';
        masterAccount.LG_VIP__c=false;
        masterAccount.UM_Legal_Name__c='abc';
        insert masterAccount;
        
        Contact billingContact = new Contact(FirstName = 'First', LastName = 'Last', AccountId = masterAccount.id, Salutation='Mr.');
        insert billingContact;
        
        csconta__Billing_Account__c billingAccount = new csconta__Billing_Account__c (csconta__Account__c = masterAccount.id);
        billingAccount.csconta__Street__c = 'Street 1';
        billingAccount.csconta__Postcode__c = 'Postcode 1';
        billingAccount.csconta__City__c = 'City 1';
        billingAccount.csconta__Country__c ='Germany';
        billingAccount.Billing_Contact__c = billingContact.id;
        insert billingAccount;  
        
        //inserting user
        String orgId = UserInfo.getOrganizationId();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u1 = new User(Alias = 'standt',CommunityNickname='test11', Email='testuser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id,companyName='UM', TimeZoneSidKey='Europe/Berlin',
             UserName='neha1@abc.com'+orgId);
        insert u1;
        User u2 = new User(Alias = 'test2',CommunityNickname='test22', Email='testuser2@testorg.com', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',EmailEncodingKey='UTF-8', LastName='Testing2', ProfileId = p.Id,companyName='UM',TimeZoneSidKey='Europe/Berlin', 
             UserName='testuser2@abc.com'+orgId,managerId= u1.id);
        insert u2;
        
        Id adjustmentRecordTypeId = Schema.SObjectType.UM_BillingAccountItem__c.getRecordTypeInfosByName().get('Adjustment').getRecordTypeId();
        //inserting Billing Item
         system.RunAs(u2)
        {
            UM_BillingAccountItem__c bItem = new UM_BillingAccountItem__c();
            bItem.UM_BillingAccount__c = billingAccount.id ;
            bItem.recordTypeId = adjustmentRecordTypeId ;
            bItem.UM_NRC_Reason__c = 'Falscher Rechnungsbetrag';
            bItem.UM_Total_Amount__c = 400;
            bItem.UM_StartDate__c = system.today(); 
            bItem.UM_Approval_status__c = 'Approved';
            insert bItem;
        }      
 
       /**BU-234 **/      
        
//Insert BA:
        csconta__Billing_Account__c billingAccount1 = new csconta__Billing_Account__c (csconta__Account__c = masterAccount.id);
        billingAccount1.csconta__Status__c = 'Deactivation Requested'; 
        billingAccount1.csconta__Billing_Channel__c = 'Paper'; 
        billingAccount1.UM_BillFormatOptions__c = 'Summary';
        billingAccount1.Billing_Contact__c = billingContact.id; 
        billingAccount1.LG_PaymentType__c = 'Direct debit';
        billingAccount1.LG_BankAccountNumberIBAN__c = 'DE85604500500002819471';
        billingAccount1.LG_BankAccountHolder__c='Test BA';
        billingAccount1.csconta__Payment_Terms__c = 'M02 - Test'; 
        billingAccount1.csconta__Street__c='Aachener Str.'; 
        billingAccount1.LG_HouseNumber__c='746';
        billingAccount1.LG_HouseNumberExtension__c ='-750'; 
        billingAccount1.csconta__City__c= 'Köln'; 
        billingAccount1.csconta__Country__c= 'Germany'; 
        billingAccount1.UM_Billing_State_Province__c= 'NRW'; 
        billingAccount1.csconta__Postcode__c = '50933';
        insert billingAccount1;
    
        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'TestM', csord__Module_Version__c = '1.0');
            insert coreq;
        
    csord__Subscription__c sub = new csord__Subscription__c(csord__Account__c=masterAccount.id,csord__Identification__c = 'TestIdentM',csord__Status__c='Active', csord__Order_Request__c = coreq.Id, csconta__Billing_Account__c=billingAccount1.Id);
    insert sub;
    
    cscrm__Address__c add= new cscrm__Address__c(cscrm__Street__c = 'TestStreetM');
    insert add;
    csord__Service__c intService = new csord__Service__c(csord__Identification__c = 'TestIdentSubM', csord__Order_Request__c = coreq.Id,csord__Status__c='Inactive',
                              csord__Subscription__c = sub.Id, csord__Deactivation_Date__c=Date.Today()-1, LG_Address__c = add.Id, LG_ProductFamily__c = 'Internet');
    insert intService;
    
        
    }
    
    // Test Billing Account Sync
    public static testMethod void testBillingAccountSyncForPage(){
        csconta__Billing_Account__c billingAcc = [select id from csconta__Billing_Account__c limit 1];
        PageReference pgRef = Page.UM_KenanAccountSync;
        Test.setCurrentPage(pgRef);
        ApexPages.currentPage().getParameters().put('BillingId',billingAcc.id);
        
        UM_KenanAccountSyncCtrl controller = new UM_KenanAccountSyncCtrl();
        test.startTest();
        //controller.syncKenanAccount();
        controller.initiateSync();

        test.stopTest();
        
        System.assertEquals(billingAcc.id, controller.billingAccId, 'Error: Invalid Billing Account Id Parameter.');
        
    }
    
    // Test Billing Account Sync
    public static testMethod void testBillingAccountItemSync(){
        csconta__Billing_Account__c billingAcc = [select id,csconta__Account__c from csconta__Billing_Account__c WHERE csconta__Postcode__c = 'Postcode 1' LIMIT 1];
        system.debug('billingAcc #'+billingAcc.csconta__Account__c );
        
          
        UM_KenanAccountCalloutMock accountMock1 = new UM_KenanAccountCalloutMock ();
        accountMock1.sfId= billingAcc.csconta__Account__c;
        accountMock1.billingAccountId = billingAcc.id;
        test.startTest();        
        UM_KenanAccountSyncCtrl controller = new UM_KenanAccountSyncCtrl(billingAcc.id,true);
        
        Test.setMock(HttpCalloutMock.class, accountMock1);
        //controller.syncKenanAccount();
        controller.intiateAutoSync();
        UM_BillingAccountItem__c bItem = [SELECT id,UM_External_id__c FROM UM_BillingAccountItem__c WHERE UM_BillingAccount__c = :billingAcc.id];
        test.stopTest();
        
        System.assertEquals(bItem.UM_External_id__c , '6789');
        
    }
    
    // Test Billing Account Update Sync
    public static testMethod void testBillingAccountUpdateCtrlSync(){
        csconta__Billing_Account__c billingAcc = [select id,LG_ExternalID__c from csconta__Billing_Account__c limit 1];
        billingAcc.LG_ExternalID__c = 'B123';
        update billingAcc;
        
        PageReference pgRef = Page.UM_KenanAccountSync;
        Test.setCurrentPage(pgRef);
        
        test.startTest();
        UM_KenanAccountSyncCtrl controller = new UM_KenanAccountSyncCtrl(billingAcc.id, true);
        test.stopTest();
        
        System.assertEquals(billingAcc.id, controller.billingAccId, 'Error: Invalid Billing Account Id Parameter.');
        
    }
    
    // Test Billing Account Update Sync
    public static testMethod void testBillingAccountUpdateSync(){
        csconta__Billing_Account__c billingAcc = [select id,LG_ExternalID__c from csconta__Billing_Account__c limit 1];
        billingAcc.LG_ExternalID__c = 'B123';
        update billingAcc;
        
        PageReference pgRef = Page.UM_KenanAccountSync;
        Test.setCurrentPage(pgRef);
        ApexPages.currentPage().getParameters().put('BillingId',billingAcc.id);
        
        test.startTest();
        UM_KenanAccountSyncCtrl controller = new UM_KenanAccountSyncCtrl();
        
        //controller.syncKenanAccount();
        controller.initiateSync();
         
        test.stopTest();
        
        System.assertEquals(billingAcc.id, controller.billingAccId, 'Error: Invalid Billing Account Id Parameter.');
        
    }

    // Test Master Account Sync
    public static testMethod void testMasterAccountSyncForPage(){
        Account acc = [select id from account limit 1];
        PageReference pgRef = Page.UM_KenanAccountSync;
        Test.setCurrentPage(pgRef);
        ApexPages.currentPage().getParameters().put('Id',acc.id);
        
        UM_KenanAccountSyncCtrl controller = new UM_KenanAccountSyncCtrl();
        test.startTest();
        //controller.syncKenanAccount();
        controller.initiateSync();

        test.stopTest();
        
        System.assertEquals(acc.id, controller.accId, 'Error: Invalid Account Id Parameter.');
        
                
    }
    
    // Test Master Account Sync
    public static testMethod void testMasterAccountSync(){
        Account acc = [select id from account limit 1];
        PageReference pgRef = Page.UM_KenanAccountSync;
        Test.setCurrentPage(pgRef);
        ApexPages.currentPage().getParameters().put('Id',acc.id);
        
        UM_KenanAccountSyncCtrl controller = new UM_KenanAccountSyncCtrl();
        test.startTest();

        controller.syncKenanAccount();

        test.stopTest();
        
        System.assertEquals(acc.id, controller.accId, 'Error: Invalid Account Id Parameter.');
        
                
    }
    
    // Test Master Account Updatet Sync
    public static testMethod void testMasterAccountUpdateSync(){
        Account acc = [select id,LG_ExternalID__c from account limit 1];
        acc.LG_ExternalID__c = '123';
        update acc;
        
        PageReference pgRef = Page.UM_KenanAccountSync;
        Test.setCurrentPage(pgRef);
        ApexPages.currentPage().getParameters().put('Id',acc.id);
        
        UM_KenanAccountSyncCtrl controller = new UM_KenanAccountSyncCtrl();
        test.startTest();
        //controller.syncKenanAccount();
        controller.initiateSync();
        test.stopTest();
        
        System.assertEquals(acc.id, controller.accId, 'Error: Invalid Account Id Parameter.');
        
                
    }
    
    // Test Billing Account Deactivation
    public static testMethod void testCreateCeaseKenanBillinAcc(){
        
        csconta__Billing_Account__c  billAcc =[SELECT id,csconta__Status__c FROM csconta__Billing_Account__c 
                                                     WHERE csconta__Status__c ='Deactivation Requested' LIMIT 1];
        UM_KenanAccountCalloutMock accountMock1 = new UM_KenanAccountCalloutMock ();
      //  accountMock1.sfId= billAcc.id;
        test.startTest();        
        UM_KenanAccountSyncCtrl.invokeACAPI(billAcc.Id);
        test.stopTest();   
    }

      public static testMethod void testCreateCeaseKenanBillinAccTrue(){
        
        csconta__Billing_Account__c  billAcc =[SELECT id,csconta__Status__c FROM csconta__Billing_Account__c 
                                                     WHERE csconta__Status__c ='Deactivation Requested' LIMIT 1];
       UM_KenanAccountCalloutMock accountMock = new UM_KenanAccountCalloutMock ();
       Test.setMock (HttpCalloutMock.class, accountMock);
       test.startTest();        
       UM_KenanAccountSyncCtrl.invokeACAPI(billAcc.Id);
       test.stopTest();   
      }
}