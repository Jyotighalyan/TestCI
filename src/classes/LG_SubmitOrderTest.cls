/* -----------------------------------------------------------------------------------------------------------------------
Name:       LG_SubmitOrderTest.cls 
Description: Test class for LG_SubmitOrder class

Date            Version         Author            Summary of Changes         
-----------  ------- --------------  ----------------------------------------------------------------------------------
Dec 2016       1.0           Alisha        Initial Release
------------------------------------------------------------------------------------------------------------------------ */
@isTest
public class LG_SubmitOrderTest {
    
    public static Opportunity testOpportunity;
    public static Account testAccount ;
    public static Opportunity oppObj;
    public static  cscfga__Product_Basket__c ProdBskt ;
    public static   LG_Credit_Check__c  credtchek ;
    public static String OrgName = UserInfo.getOrganizationName();
    public static LG_ValidateOpportunity__c val;
    public static LG_DebtCredit_Check__c debitCheck;
    
    public static  void testData(){
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        val = LG_ValidateOpportunity__c.getInstance(UserInfo.getUserId());
        LG_ValidateOpportunityUtil validatorClass=null;
        val.SetupOwnerId = UserInfo.getOrganizationId();
        if(OrgName.containsIgnoreCase('Unity')){
            val.class_name__c='UM_ValidateOpportunityUtil';
            val.org_name__c='UM';
        }
        else{
        val.class_name__c='VM_ValidateOpportunityUtil';
        val.org_name__c='VMB';
        }
        upsert val;
        
        
        if(val.org_name__c == 'UM') {
            LG_Submit_Order_Validations_On_Off__c soVal = new   LG_Submit_Order_Validations_On_Off__c();
            soVal.Method_Name__c = 'checkSendViaEmail;DDmandateCheck;ValidateOpportunity;';
            soVal.Flag__c = true;
            insert soVal;
        }
        
        debitCheck = LG_DebtCredit_Check__c.getInstance(UserInfo.getUserId());
        debitCheck.LG_Customer_Balance_Validity__c = 10;
        insert debitCheck;
        
        testAccount   = new Account(Name='testAccount',BillingStreet='TestStreet', BillingCity='MONNICKENDAM', BillingPostalCode='1141 KG', BillingCountry='Netherlands');
        testAccount.LG_ChamberOfCommerceNumber__c =  'NAT1234';
        insert testAccount;
        
        cscrm__Address__c qs = new cscrm__Address__c();
        qs.cscrm__Account__c = testAccount.id;
        qs.LG_UPRN__c='123456';
        insert qs;
        
        Contact testContact = new Contact(FirstName = 'TestName', LastName = 'TestName', Salutation ='Mr.', email = 'test@test.com',AccountId=testAccount.id);
        insert testContact;
        
        testOpportunity = new Opportunity(LG_Order_Summary_Accepted__c=true,LG_Credit_Check_Condition__c=null,CloseDate = system.today(), Name = 'TestOpp', StageName = 'Qualified', AccountId =testAccount.id );
        insert testOpportunity;
        
        ProdBskt = new cscfga__Product_Basket__c(SPT_Quote_Status__c ='Active',Quote_Stage__c ='Quoting',Name='Test BSKT', csbb__Account__c=testAccount.Id,csordtelcoa__Synchronised_with_Opportunity__c =true, cscfga__Opportunity__c =testOpportunity.Id,csbb__Synchronised_With_Opportunity__c=true);
        insert ProdBskt;
        
        cscfga__Product_Configuration__c prodBsktLineMobile = new cscfga__Product_Configuration__c(Site_Id__c='123456',Name ='SIM Card Only 1GB',  cscfga__Product_Basket__c=ProdBskt.id,cscfga__Product_Family__c='Mobile',cscfga__total_recurring_charge__c=99.8,LG_PortIn__c=true,cscfga__total_one_off_charge__c =98766.00);
        insert prodBsktLineMobile;
        
        credtchek=new LG_Credit_Check__c();
        
        credtchek.LG_postcode__c ='test';
        credtchek.LG_Country__c='test';
        credtchek.LG_EquifaxOrganisationType__c='Co-operative';
        credtchek .LG_Equifax_Organisation_ID__c='11111';
        credtchek .LG_ApplicationID__c =testAccount.id;
        credtchek .LG_Total_Exposure_Value__c =1000.00;
        credtchek.LG_Credit_Limit__c=1000.00;
        credtchek .LG_Opportunity__c=testOpportunity.id;
        credtchek .LG_CreditCheck_ExecutionDate__c=date.today();
        credtchek .LG_Decision__c='Mitigation';
        credtchek.LG_ApplicationDate__c=date.today();
        insert credtchek ;
        
        
        LG_Credit_Check_Opportunity__c credoppobj = new LG_Credit_Check_Opportunity__c ();
        credoppobj.LG_Credit_check__c =credtchek .id;
        credoppobj.LG_Opportunity__c =testOpportunity.id;
        insert credoppobj ;
        
        
        LG_CustomerAccountBalance__c custbal = new LG_CustomerAccountBalance__c();
        custbal.LG_Account__c =testAccount.id;
        custbal.LG_Opportunity__c=testOpportunity.id;
        custbal.LG_TotalDebtBalance__c=100;
        custbal.LG_TotalPayableDebt__c=9;
        custbal.LG_TotalDepositAmount__c=1000;
        
        //List<LG_Debt_Check__c> dcList= [select id,LG_DebtBalance__c,LG_PayableDebt__c,createdDate from LG_Debt_Check__c where  LG_Opportunity__c=:OppId  and 
        
        insert custbal ;
        
        /*changes done by ankur gupta*/
        Contact admCon = LG_GeneralTest.CreateContact(testAccount, 'Adm', 'De Vries', 'Mr', '01316546541', '07216540711', 'adm.devries@bdm.com','Business User', date.newinstance(1960, 2, 17),'MONNICKENDAM','Netherlands','1141 AZ','HAVEN 14', true);
        opportunityContactRole ocr = new opportunityContactRole();
        ocr.OpportunityId = testOpportunity.Id;
        ocr.ContactId = admCon.Id;
        ocr.Role = 'Administrative Contact';
        insert ocr;
        
        csordtelcoa__Orders_Subscriptions_Options__c cs=new csordtelcoa__Orders_Subscriptions_Options__c();
        cs.csordtelcoa__Opportunity_Stages_creating_orders__c = 'Order Generated';
        insert cs;
        /*changes done by ankur gupta*/
        
        oppObj= new Opportunity();
        oppObj =[select ID,Planning_Detail_Status__c,stageName, LG_CreditCheckStatus__c, LG_DebitCheckStatus__c from Opportunity WHERE id =: testOpportunity.id   limit 1] ;
        oppObj.Planning_Detail_Status__c = 'Completed';
        oppObj.LG_CreditCheckStatus__c = 'Completed';
        oppObj.LG_DebitCheckStatus__c = 'Completed';
        //oppObj.stageName='Qualified';
        oppObj.StageName = 'Awareness of interest';
        
        update oppObj; 
        
        noTriggers.Flag__c = False;
        upsert noTriggers;
        
    }
    
    
    static testmethod void LG_SubmitOrderGreenFlagTest()
    {
        
        testData();
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;

        upsert noTriggers;
        
        Attachment attach = new Attachment();
        attach.Name='Wayleave_';
        Blob bodyBlob=Blob.valueOf('Unit Test Porting Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=oppObj.id;
        attach.Description='Wayleave';
        insert attach;
        
        Attachment att = new Attachment();
        att.Name='CPK_Porting_';
        Blob bodyBlob1=Blob.valueOf('Unit Test Porting Attachment Body');
        att.body=bodyBlob1;
        att.parentId=oppObj.id;
        att.Description='Porting';
        insert att;
        
        Attachment att2 = new Attachment();
        att2.Name='DDMandate_';
        Blob bodyBlob2=Blob.valueOf('Unit Test Mandate Attachment Body');
        att2.body=bodyBlob2;
        att2.parentId=oppObj.id;
        att2.Description='Mandate';
        insert att2;
        
        CSCAP__Customer_Approval__c ca= new CSCAP__Customer_Approval__c();
        ca.CSCAP__Account__c=OppObj.Account.ID;
        ca.CSCAP__Opportunity__c=OppObj.ID;
        ca.CSCAP__Physical_Signature_Attached__c=false;
        ca.CSCAP__Approved_By_Customer__c=true;
        insert ca; 
        
        csconta__Billing_Account__c billAcc=new csconta__Billing_Account__c();
        billAcc.LG_PaymentType__c='';
        billAcc.csconta__Account__c = OppObj.Account.Id;
        billAcc.Opportunity__c=oppObj.id;
        billAcc.LG_BillingEmailAddress__c='aaa@test.com';
        billAcc.LG_BankAccountNumberIBAN__c ='NL91ABNA0417164300';
        billAcc.LG_BankAccountHolder__c='test bank acc';
        billAcc.UM_BankAccountNumberBic__c = '123';
        billAcc.PaymentMethods__c = '';
        insert billAcc;
        
        
        Quantum_Site_Information__c  testSite = new Quantum_Site_Information__c (Quantum_Site_Information_Opportunity__c =oppObj.id);
        insert testSite ;
        
       noTriggers.Flag__c = False;
        upsert noTriggers;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testOpportunity);
        LG_SubmitOrder subOrd = new LG_SubmitOrder(sc);
        
        PageReference pageRef = Page.LG_SubmitOrder;
        pageRef.getParameters().put('id', String.valueOf(testOpportunity.Id));
        LG_DebtCredit_Check__c dcCheckObj=LG_DebtCredit_Check__c.getInstance();

        Test.StartTest();
        if(val.org_name__c == 'UM') {
            Test.setMock(HttpCalloutMock.class, new UM_MPIResponseMock());
        }
        Test.setCurrentPage(pageRef);
        subOrd.DDMandateChecked=true;
        subOrd.LLAuthChecked=true;
        subOrd.PortAuthChecked=true;
        subOrd.oppTermsNcondition=true;
        subOrd.oppQuoteStatusFlag = 'Red_Flag.png';
        //subOrd.dcChecked =true;
        //subOrd.ccChecked = true;
        //subOrd.contractChecked = true;
        //     subOrd.updateOrderSummary();
        //   subOrd.billingSelectedId=null;
        
        //   subOrd.getNumberOfDocuments(testOpportunity.id,testAccount.id,ProdBskt.id);
        LG_submitorder.getClass_name();
        //Removed as a part of SFOM-2069
        //subOrd.backToOpportunity();
        subOrd.contractStatus();
        subOrd.creditCheckAction();
        //  subOrd.debitCheckAction();
        //  subOrd.debitCheckStatus();
        subOrd.debitCheckStatusFlag();
        //subOrd.fraudCheckAction();
        subOrd.getQuoteStatus();
        //Removed as a part of SFOM-2069
        //subOrd.gotoAccount();
        subOrd.gotoBasket();
        subOrd.mandatoryDocsCheck();
        //subOrd.mitigationPaymentAction();
        subOrd.sendContract();
        //  subOrd.updateOrderSummary();
        subOrd.submitOrder();
        subOrd.validateOrder();
        
        subOrd.debitCheckFlag = 'Red_Flag.png';
        subOrd.creditCheckFlag = 'Red_Flag.png';
        subOrd.quoteFlag = 'Red_Flag.png';
        subOrd.contStatusFlag = 'Red_Flag.png';
        subOrd.submitOrder();
        
        //LG_SubmitOrder.getFraudCheckCodes(); 
        
        ca.CSCAP__Approved_By_Customer__c=false;
        ca.CSCAP__Rejected_By_Customer__c=true;
        update ca; 
        subOrd.contractStatus();
        
        
        Test.StopTest();
        
        //System.assertEquals('Order Generated', testOpportunity.StageName, 'Invalid opportunity status');
        
    }
    
    static testmethod void LG_SubmitOrderRedFlagsTest()
    {
        
        testData();
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        
        upsert noTriggers;
        
        ProdBskt = new cscfga__Product_Basket__c(SPT_Quote_Status__c ='Expired',Quote_Stage__c ='Synchronised',Name='Test BSKT', csbb__Account__c=testAccount.Id,csordtelcoa__Synchronised_with_Opportunity__c =true, cscfga__Opportunity__c =testOpportunity.Id,csbb__Synchronised_With_Opportunity__c=true);
        insert ProdBskt;
        
        //Opportunity oppObj  = new Opportunity();
        oppObj =[select ID,Planning_Detail_Status__c, LG_CreditCheckStatus__c, LG_DebitCheckStatus__c from Opportunity WHERE id =: testOpportunity.id   limit 1] ;
        oppObj.Planning_Detail_Status__c = 'Pending';
        oppObj.LG_CreditCheckStatus__c = 'Pending';
        oppObj.LG_DebitCheckStatus__c = 'Not Completed';
        
        csconta__Billing_Account__c billAcc=new csconta__Billing_Account__c();
        billAcc.LG_PaymentType__c='BACS';
        billAcc.Opportunity__c=oppObj.id;
        billAcc.LG_BillingEmailAddress__c='aaa@test.com';
        //billAcc.LG_BankAccountNumberIBAN__c ='NL91ABNA0417164300';
        //billAcc.LG_BankAccountHolder__c='test bank acc';
         billAcc.UM_BankAccountNumberBic__c = '123';

        insert billAcc;
        
        
        Attachment att = new Attachment();
        att.Name='CPK_Contract_';
        Blob bodyBlob1=Blob.valueOf('Unit Test Contract Attachment Body');
        att.body=bodyBlob1;
        att.parentId=oppObj.id;
        att.Description = 'Contract';
        insert att;
        
        Attachment fileAttached = new Attachment();
        fileAttached.Name = 'Attachment.txt';
        fileAttached.body = Blob.valueOf('Unit Test File Attachment Body');
        fileAttached.Description = '';
        
        
        credtchek.LG_ApplicationDate__c=date.today().addDays(-91);
        update credtchek;
        
        Quantum_Site_Information__c  testSite = new Quantum_Site_Information__c (Quantum_Site_Information_Opportunity__c =oppObj.id, WayLeave_Required_for_Landlord__C=true);
        insert testSite ;
       
          noTriggers.Flag__c = False;
        upsert noTriggers;
        
        Test.StartTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testOpportunity);
        LG_SubmitOrder subOrd = new LG_SubmitOrder(sc);
        
        
        PageReference pageRef = Page.LG_SubmitOrder;
        pageRef.getParameters().put('id', String.valueOf(testOpportunity.Id));
        Test.setCurrentPage(pageRef);
        
        
        subOrd.DDMandateChecked=false;
        subOrd.LLAuthChecked=false;
        subOrd.PortAuthChecked=false;
        subOrd.oppTermsNcondition=false; 
        //subOrd.dcChecked =false;
        //subOrd.ccChecked = false;
        //subOrd.contractChecked = false;
        LG_submitorder.getClass_name();
        
        //Removed as a part of SFOM-2069
        //subOrd.gotoAccount();
        subOrd.gotoBasket();
        //Removed as a part of SFOM-2069
        //subOrd.backToOpportunity();
        
        
        subOrd.Creditcheckflag();
        
        subOrd.fileName = fileAttached.Name;
        subOrd.fileBody = fileAttached.Body;
        
        subOrd.UploadContractFile();
        subOrd.UploadPortingFile();
        subOrd.UploadWayleaveFile();
        
        subOrd.submitOrder();
        subOrd.validateOrder();
        subOrd.contractStatus();
        
        testOpportunity.LG_Order_Summary_Accepted__c=false;
        
        update testOpportunity;
        
        
       subOrd.sendContract();
        if(val.org_name__c == 'UM') {
            Test.setMock(HttpCalloutMock.class, new UM_MPIResponseMock());
        }
        Test.StopTest();
        
        System.assertNotEquals('Order Generated', testOpportunity.StageName, 'Invalid opportunity status');
        
    }
    
    static testMethod void suborderRemappingTest(){
 
        testData();
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        upsert noTriggers;
         // Old Order
        csord__Order__c oldOrder = new csord__Order__c(Name='Test Order',csord__Identification__c = '6465467986',csordtelcoa__Opportunity__c = testOpportunity.id);
        insert oldOrder;
        
         // Old Solution
        csord__Solution__c oldSolution = new csord__Solution__c(Name = 'test solution',csord__Identification__c = '6465467986',csord__Order__c=oldOrder.Id,LG_JeopardyExplanation__c='');
        oldSolution.LG_OrderChanged__c = false;
        oldSolution.LG_OrderCancelled__c = false;
        oldSolution.LG_ProvisioningWorkOrder__c = 'PWO_123';
        insert oldSolution;
        
        //Schedule Appointment
        LG_ScheduleAppointment__c sa = new LG_ScheduleAppointment__c(Name='Eng. Visit', LG_AgreedInstallDate__c = System.today(), LG_Solution__c=oldSolution.id, LG_Slot__c='Morning Slot', LG_Status__c='Scheduled');
        insert sa;
        
        //New Opportunity Version
        Opportunity oppObjNew = new Opportunity(CloseDate = system.today(), Name = 'TestOpp',AccountId =testAccount.id);
        oppObjNew.CloseDate = system.today(); oppObjNew.Name = 'TestOpp';
        oppObjNew.Planning_Detail_Status__c = 'Completed';
        oppObjNew.LG_CreditCheckStatus__c = 'Completed';
        oppObjNew.LG_DebitCheckStatus__c = 'Completed';
        oppObjNew.StageName = 'Qualified';
        oppObjNew.LG_OlderVersion__c = testOpportunity.Id;
        insert oppObjNew; 
        
           ProdBskt.cscfga__Opportunity__c =oppObjNew.Id;
        update ProdBskt;
        
        cscfga__Product_Configuration__c prodBsktLineMobile = new cscfga__Product_Configuration__c(Site_Id__c='123456',Name ='SIM Card Only 1GB',  cscfga__Product_Basket__c=ProdBskt.id,cscfga__Product_Family__c='Mobile',cscfga__total_recurring_charge__c=99.8,LG_PortIn__c=true,cscfga__total_one_off_charge__c =98766.00);
        insert prodBsktLineMobile;
        
       
        credtchek .LG_Opportunity__c=oppObjNew.id;
        update credtchek ;

        LG_Credit_Check_Opportunity__c credoppobj = new LG_Credit_Check_Opportunity__c ();
        credoppobj.LG_Credit_check__c =credtchek .id;
        credoppobj.LG_Opportunity__c =oppObjNew.id;
        insert credoppobj ;
        
        
        LG_CustomerAccountBalance__c custbal = new LG_CustomerAccountBalance__c();
        custbal.LG_Account__c =testAccount.id;
        custbal.LG_Opportunity__c=oppObjNew.id;
        custbal.LG_TotalDebtBalance__c=100;
        custbal.LG_TotalPayableDebt__c=9;
        custbal.LG_TotalDepositAmount__c=1000;
        insert custbal ;

        Contact admCon = LG_GeneralTest.CreateContact(testAccount, 'Adm', 'De Vries', 'Mr', '01316546541', '07216540711', 'adm.devries@bdm.com','Business User', date.newinstance(1960, 2, 17),'MONNICKENDAM','Netherlands','1141 AZ','HAVEN 14', true);
        opportunityContactRole ocr = new opportunityContactRole();
        ocr.OpportunityId = oppObjNew.Id;
        ocr.ContactId = admCon.Id;
        ocr.Role = 'Administrative Contact';
        insert ocr;
        
       
        // New Order
        csord__Order__c newOrder = new csord__Order__c(Name='Test Order',csord__Identification__c = '6465467986',csordtelcoa__Opportunity__c = oppObjNew.id, LG_PreviousOrderVersion__c = oldOrder.id);
        insert newOrder;

            //update NewOrderVersion in old Order
        oldOrder.LG_NewOrderVersion__c = newOrder.id;
        update oldOrder;
        
         // New Solution
        csord__Solution__c newSolution = new csord__Solution__c(Name = 'test solution',csord__Identification__c = '6465467986',csord__Order__c=newOrder.Id,LG_JeopardyExplanation__c='');
        newSolution.LG_OrderChanged__c = false;
        newSolution.LG_OrderCancelled__c = false;
        newSolution.LG_OldSuborder__c = oldSolution.id;
        insert newSolution;
        
        Attachment attach = new Attachment();
        attach.Name='Wayleave_';
        Blob bodyBlob=Blob.valueOf('Unit Test Porting Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=oppObjNew.id;
        attach.Description='Wayleave';
        insert attach;
        
        Attachment att = new Attachment();
        att.Name='CPK_Porting_';
        Blob bodyBlob1=Blob.valueOf('Unit Test Porting Attachment Body');
        att.body=bodyBlob1;
        att.parentId=oppObjNew.id;
        att.Description='Porting';
        insert att;
        
        Attachment att2 = new Attachment();
        att2.Name='DDMandate_';
        Blob bodyBlob2=Blob.valueOf('Unit Test Mandate Attachment Body');
        att2.body=bodyBlob2;
        att2.parentId=oppObjNew.id;
        att2.Description='Mandate';
        insert att2;
        
        CSCAP__Customer_Approval__c ca= new CSCAP__Customer_Approval__c();
        ca.CSCAP__Account__c=oppObjNew.Account.ID;
        ca.CSCAP__Opportunity__c=oppObjNew.ID;
        ca.CSCAP__Physical_Signature_Attached__c=false;
        ca.CSCAP__Approved_By_Customer__c=true;
        insert ca; 
        
        csconta__Billing_Account__c billAcc=new csconta__Billing_Account__c();
        billAcc.LG_PaymentType__c='Direct Debit';
        billAcc.Opportunity__c=oppObjNew.id;
        billAcc.LG_BillingEmailAddress__c='aaa@test.com';
        billAcc.LG_BankAccountNumberIBAN__c ='NL91ABNA0417164300';
        billAcc.LG_BankAccountHolder__c='test bank acc';
        billAcc.UM_BankAccountNumberBic__c = '123';

        insert billAcc;
        
        
        Quantum_Site_Information__c  testSite = new Quantum_Site_Information__c (Quantum_Site_Information_Opportunity__c =oppObjNew.id);
        insert testSite ;
        
         noTriggers.Flag__c = False;
        upsert noTriggers;
        ApexPages.StandardController sc = new ApexPages.StandardController(oppObjNew);
        LG_SubmitOrder subOrd = new LG_SubmitOrder(sc);
        
        PageReference pageRef = Page.LG_SubmitOrder;
        pageRef.getParameters().put('id', String.valueOf(oppObjNew.Id));
        LG_DebtCredit_Check__c dcCheckObj=LG_DebtCredit_Check__c.getInstance();

        Test.StartTest();
        if(val.org_name__c == 'UM') {
            Test.setMock(HttpCalloutMock.class, new UM_MPIResponseMock());
        }
        Test.setCurrentPage(pageRef);
        subOrd.DDMandateChecked=true;
        subOrd.LLAuthChecked=true;
        subOrd.PortAuthChecked=true;
        subOrd.oppTermsNcondition=true;
        subOrd.oppQuoteStatusFlag = 'Red_Flag.png';
        //subOrd.dcChecked =true;
        //subOrd.ccChecked = true;
        //subOrd.contractChecked = true;
  
        LG_submitorder.getClass_name();
        //Removed as a part of SFOM-2069
        //subOrd.backToOpportunity();
        subOrd.contractStatus();
        subOrd.creditCheckAction();
        subOrd.debitCheckStatusFlag();
        subOrd.getQuoteStatus();
        //Removed as a part of SFOM-2069
        //subOrd.gotoAccount();
        subOrd.gotoBasket();
        subOrd.mandatoryDocsCheck();
        subOrd.sendContract();
        subOrd.submitOrder();
        subOrd.validateOrder();
        subOrd.suborderRemapping(oppObjNew.Id);
        
        Test.StopTest();
        
        System.assertEquals(newSolution.LG_ProvisioningWorkOrder__c, newSolution.LG_ProvisioningWorkOrder__c);
    }
}