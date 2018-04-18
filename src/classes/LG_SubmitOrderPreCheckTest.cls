/**
 * Test Class for LG_SubmitOrderPreCheck and LG_SubmitOrderCOmp CLass
 *part of SFOM-81 
 * @author Alisha
 * @since  27/02/2017
 */


@isTest
public class LG_SubmitOrderPreCheckTest{
 public static Opportunity testOpportunity ;
 public static     csord__Order__c orderId ;
    @testSetup
   public static  void testData(){
       
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        LG_ValidateOpportunity__c val = LG_ValidateOpportunity__c.getInstance(UserInfo.getUserId());
        LG_ValidateOpportunityUtil validatorClass=null;
        val.SetupOwnerId = UserInfo.getOrganizationId();
        val.class_name__c='UM_ValidateOpportunityUtil';
        val.org_name__c='UM';
        upsert val;
        
        Account testAccount   = new Account(Name='testAccount',BillingStreet='TestStreet', BillingCity='Test City', BillingPostalCode='1134 KL', BillingCountry='Netherlands');
        insert testAccount;
        
        cscrm__Address__c qs = new cscrm__Address__c();
        qs.cscrm__Account__c = testAccount.id;
        qs.LG_HouseNumber__c='12';
        qs.cscrm__Zip_Postal_Code__c='13124';
        qs.LG_UPRN__c='123456';
        insert qs;
        
        Contact testContact = new Contact(FirstName = 'TestName', LastName = 'TestName', Salutation ='Mr.', email = 'test@test.com',AccountId=testAccount.id);
        insert testContact;
        
        testOpportunity = new Opportunity(LG_Order_Summary_Accepted__c=true,LG_Credit_Check_Condition__c=null,CloseDate = system.today(), Name = 'TestOpp', StageName = 'Qualified', AccountId =testAccount.id );
        insert testOpportunity;
        
        cscfga__Product_Basket__c ProdBskt = new cscfga__Product_Basket__c(SPT_Quote_Status__c ='Active',Quote_Stage__c ='Quoting',Name='Test BSKT', csbb__Account__c=testAccount.Id,csordtelcoa__Synchronised_with_Opportunity__c =true, cscfga__Opportunity__c =testOpportunity.Id,csbb__Synchronised_With_Opportunity__c=true);
        insert ProdBskt;
        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert coreq;

        orderId = new csord__Order__c ();
        orderId.csordtelcoa__Opportunity__c =testOpportunity.id;
        orderId.name='test order';
        orderId.csord__Identification__c='123';
        orderId.LG_Address__c=qs.id;
        orderId.csord__Account__c = testAccount.Id;
        orderId.csord__Status2__c = 'Order Submitted';
        orderId.csord__Order_Request__c = coreq.Id;
        insert orderId;
        system.debug('orderId=='+orderId);
        
         csord__Solution__c sol = new csord__Solution__c();
        sol.name='test Sol';
        sol.csord__Identification__c='123';
        insert sol;   
        csord__Subscription__c subs = new csord__Subscription__c();
        subs.name='Sub 1';
        subs.csord__Identification__c ='iden';
        insert subs;
        
        csord__Service__c serv = new csord__Service__c();
        serv.name = 'Service 1';
        serv.csord__Solution__c = sol.id;
        serv.csord__Subscription__c=subs.id;
        serv.csord__Identification__c ='iden';
        serv.LG_Address__c=qs.id;
        serv.LG_RootOrder__c =orderId.id;
        
        insert serv;
        
        csconta__Billing_Account__c billAcc=new csconta__Billing_Account__c();
        billAcc.LG_PaymentType__c='Direct Debit';
        billAcc.Opportunity__c=testOpportunity.id;
        billAcc.LG_BillingEmailAddress__c='aaa@test.com';
        billAcc.LG_BankAccountNumberIBAN__c ='NL91ABNA0417164300';
        billAcc.LG_BankAccountHolder__c='test bank acc';
        billAcc.UM_BankAccountNumberBic__c = '123';

        insert billAcc;
        csconta__Billing_Account__c billAccount = [SELECT id,LG_PaymentType__c  from csconta__Billing_Account__c where Opportunity__c =:testOpportunity .id limit 1];
        csord__Service__c serviceList=[SELECT id,name,LG_RootOrder__c ,LG_RootOrder__r.csordtelcoa__Opportunity__c ,LG_Address__r.cscrm__Address_Details__c,LG_Address__r.LG_HouseNumber__c from csord__Service__c where name='Service 1' limit 1];
        system.debug('serviceList='+serviceList);
        System.assertEquals(billAccount.id, billAcc.id);

        noTriggers.Flag__c = False;
        upsert noTriggers;
        }
        
        static testmethod void testController(){
            User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){ 
         testData();
        csconta__Billing_Account__c billAccount = [SELECT id,LG_PaymentType__c  from csconta__Billing_Account__c where Opportunity__c =:testOpportunity.id limit 1];
         system.assertnotequals(null,billAccount );
        List<csord__Service__c> serviceList=[SELECT id,name, LG_Address__r.cscrm__Address_Details__c,LG_Address__r.LG_HouseNumber__c from csord__Service__c where  LG_RootOrder__c=:orderID.id ];
  
        LG_SubmitOrderComp cont = new LG_SubmitOrderComp();
        cont.getbillAccount();
        
        cont.getserviceList();
        Integer cntOrder=LG_SubmitOrderPreCheck.countOrder(testOpportunity.id);
        //Integer cntAttach=LG_SubmitOrderPreCheck.ddAttachPresent(testOpportunity.id);
        Integer cntProdBasket=LG_SubmitOrderPreCheck.prodBaksetPresent(testOpportunity.id);
         }

    }
    
}