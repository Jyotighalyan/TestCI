@isTest
public class LG_ReSendWelcomePackEmailTest {
    @testSetup 
    static void setup() {
        account account = new account();
        account.Name = 'Test';
        account.LG_Segment__c = 'SME';
        insert account;
        
        contact con = new Contact(AccountId=account.id);
        con.firstname = 'First';
        con.LastName = 'Last';
        con.LG_PreferredCommunication__c='Call';
        con.Salutation='Mr.';
        con.Email='abcd@gmail.com';
        con.Phone='1234567890';
        insert con;
        
        //Opportunity
        Opportunity Oppty= new Opportunity();
        Oppty.Name='Nps Opportunity';
        Oppty.Accountid=account.id;
        Oppty.LG_PrimaryContact__c=con.id;
        Oppty.Type='New Business';
        Oppty.UM_QuotingDate__c=System.today();
        Oppty.StageName='Awarness of interest';
        Oppty.Probability__c='10';
        Oppty.CloseDate=system.today()+7;
        //Oppty2.UM_PartnerAccount__c=paccM3.id;
        Insert Oppty;   

        //Order
        csord__Order__c order = new csord__Order__c(Name='Test Order',csord__Identification__c = '6465467986',csord__Account__c = account.Id);
        insert order;
        
        //Order2
        csord__Order__c order2 = new csord__Order__c(Name='Test Order2',csord__Identification__c = '6465467986',csord__Account__c = account.Id, csordtelcoa__Opportunity__c=Oppty.Id);
        insert order2;
        
        //Solution
        csord__Solution__c solution = new csord__Solution__c(Name = 'test solution', LG_Termination__c = false, LG_Suppress_Welcome_Pack__c = false, csord__Identification__c = '6465467986',csord__Order__c=order.Id, csord__Status__c='Complete');
        insert solution;
        
        //Solution2
        csord__Solution__c solution2 = new csord__Solution__c(Name = 'test solution2', LG_Termination__c = false, LG_Suppress_Welcome_Pack__c = false, csord__Identification__c = '6465467986',csord__Order__c=order2.Id, csord__Status__c='Complete');
        insert solution2;

        //Subscription
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'IdentSub');
        insert sub;
        
        
        //Subscription
        csord__Subscription__c sub2 = new csord__Subscription__c(csord__Identification__c = 'IdentSub2');
        insert sub2;
        
        //Address
        cscrm__Address__c address = new cscrm__Address__c(cscrm__Street__c = 'TestStreet');
        insert address;
        
        //Address2
        cscrm__Address__c address2 = new cscrm__Address__c(cscrm__Street__c = 'TestStreet2');
        insert address2;
        
        //Service
        csord__Service__c service2 = new csord__Service__c(csord__Identification__c = 'TestService2', Name='Company Internet', csord__Subscription__c = sub.Id, LG_RootOrder__c = order.Id, csord__Solution__c=solution.Id, LG_Suborder__c=solution.Id);
        service2.LG_Address__c = address.Id;
        insert service2;
        
        //Service2
        csord__Service__c service3 = new csord__Service__c(csord__Identification__c = 'TestService3', Name='Company Internet', csord__Subscription__c = sub2.Id, LG_RootOrder__c = order2.Id, csord__Solution__c=solution2.Id, LG_Suborder__c=solution2.Id);
        service3.LG_Address__c = address2.Id;
        insert service3;
       
        //Asset
        Asset asst=new Asset();
        asst.Name='Test Asset';
        asst.csord__Service__c=service2.Id;
        asst.accountId=account.id;
        asst.LG_MACAddress__c='123';
        asst.LG_IPAddress__c='456';
        asst.Quantity=2;
        asst.Status = 'Active';
        asst.csord__Asset_Value__c = 'Test Val';
        insert asst;
        
        //Asset2
        Asset asst2=new Asset();
        asst2.Name='Test Asset2';
        asst2.csord__Service__c=service3.Id;
        asst2.accountId=account.id;
        asst2.LG_MACAddress__c='123';
        asst2.LG_IPAddress__c='456';
        asst2.Quantity=2;
        asst2.Status = 'Active';
        asst2.csord__Asset_Value__c = 'Test Val';
        insert asst2;
        
    }
    
    public static testmethod void TestSendEmail(){
        csord__Solution__c s = [select Id, csord__Order__c, csord__Order__r.Name,LG_Termination__c from csord__Solution__c where name = 'test solution' limit 1];
        csord__Service__c service = [SELECT Id,Name, csord__Status__c FROM csord__Service__c WHERE csord__Identification__c = 'TestService2' AND csord__Service__c = NULL AND LG_Suborder__c = :s.id];
        Asset astObj= [SELECT Id,Name, LG_MACAddress__c, LG_IPAddress__c  FROM Asset WHERE csord__Service__r.Id =:service.Id];
        System.assertNotEquals(null, astObj.Id, 'Asset ID should be available.');
        System.assertNotEquals(null, service.Id, 'Service ID should be available.');
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
        PageReference pRef = Page.LG_ResendWelcomePackEmail;
        pRef.getParameters().put('id', s.Id);
        Test.setCurrentPage(pRef);
        astObj.LG_IPAddress__c='999';
        astObj.LG_MACAddress__c='888';
        update astObj;
        update service;
        update s;
        LG_ReSendWelcomePackEmail classobj = new LG_ReSendWelcomePackEmail();
        classobj.macAddress='555';
        classobj.ipAddress ='666';
        update Classobj.ast;
        classobj.sendEmail();
        //System.assertEquals(astObj.LG_MACAddress__c, classobj.macAddress , 'check for mac address');
        System.assertEquals(classobj.solId, s.Id, 'ID\'s should match');
        System.assertEquals(true, classobj.serviceAvailable, 'ID\'s should match');
        //System.assertEquals(classobj.cService, s.csord__Service__c, 'ID\'s should match');
        Test.stopTest();
         }
    }
    
    public static testmethod void TestValidationProfile(){
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // TestUser
        Profile p = [SELECT Id FROM Profile WHERE Name='UM_API_User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                      LocaleSidKey='en_US', ProfileId = p.Id,CompanyName='Infosys',
                      TimeZoneSidKey='America/Los_Angeles',
                      UserName=uniqueUserName);
        insert u;
        csord__Solution__c s = [select Id, csord__Order__c, csord__Order__r.Name,LG_Termination__c from csord__Solution__c where name = 'test solution' limit 1];
        csord__Service__c service = [SELECT Id,Name, csord__Status__c FROM csord__Service__c WHERE csord__Identification__c = 'TestService2' AND csord__Service__c = NULL AND LG_Suborder__c = :s.id];
        Asset astObj= [SELECT Id,Name, LG_MACAddress__c, LG_IPAddress__c  FROM Asset WHERE csord__Service__r.Id =:service.Id];
        Test.startTest();
        system.runAs(u)
        {      
            PageReference pRef = Page.LG_ResendWelcomePackEmail;
            pRef.getParameters().put('id', s.Id);
            Test.setCurrentPage(pRef);
            LG_ReSendWelcomePackEmail classobj = new LG_ReSendWelcomePackEmail();
            classobj.validateScenario();
            System.assertEquals(false, classobj.validationStatus, 'False');
        }
 
    } 
    
    public static testmethod void TestValidationAssetNull(){
        csord__Solution__c s = [select Id, csord__Order__c, csord__Order__r.Name,LG_Termination__c from csord__Solution__c where name = 'test solution' limit 1];
        csord__Service__c service = [SELECT Id,Name, csord__Status__c FROM csord__Service__c WHERE csord__Identification__c = 'TestService2' AND csord__Service__c = NULL AND LG_Suborder__c = :s.id];
        Asset astObj= [SELECT Id,Name, LG_MACAddress__c, LG_IPAddress__c  FROM Asset WHERE csord__Service__r.Id =:service.Id];
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
        PageReference pRef = Page.LG_ResendWelcomePackEmail;
        pRef.getParameters().put('id', s.Id);
        Test.setCurrentPage(pRef);
        System.assertNotEquals(null, astObj.LG_MACAddress__c, 'Asset ID should be available.');
        service.Name='Company Internet';
        update service;
        LG_ReSendWelcomePackEmail classobj = new LG_ReSendWelcomePackEmail();
        astObj.LG_IPAddress__c='999';
        astObj.LG_MACAddress__c='888';
        update astObj;
        update s;
        classobj.validateScenario();
        classobj.sendEmail();
        System.assertEquals(true, classobj.validationStatus, 'False');
         }
    }
    
    public static testmethod void TestValidationKundensetup(){
        csord__Solution__c s = [select Id, csord__Order__c, csord__Order__r.Name,LG_Termination__c from csord__Solution__c where name = 'test solution' limit 1];
        csord__Service__c service = [SELECT Id,Name, csord__Status__c FROM csord__Service__c WHERE csord__Identification__c = 'TestService2' AND csord__Service__c = NULL AND LG_Suborder__c = :s.id];
        Asset astObj= [SELECT Id,Name, LG_MACAddress__c, LG_IPAddress__c  FROM Asset WHERE csord__Service__r.Id =:service.Id];
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
        PageReference pRef = Page.LG_ResendWelcomePackEmail;
        pRef.getParameters().put('id', s.Id);
        Test.setCurrentPage(pRef);
        service.Name='Virtual Voice Kundensetup';
        update service;
        LG_ReSendWelcomePackEmail classobj = new LG_ReSendWelcomePackEmail();
        classobj.validateScenario();
        classobj.sendEmail();
        System.assertEquals(true, classobj.validationStatus, 'False');
         }
    }
    public static testmethod void TestValidationStatus(){
        csord__Solution__c s = [select Id, csord__Order__c, csord__Order__r.Name,LG_Termination__c from csord__Solution__c where name = 'test solution' limit 1];
        csord__Service__c service = [SELECT Id,Name, csord__Status__c FROM csord__Service__c WHERE csord__Identification__c = 'TestService2' AND csord__Service__c = NULL AND LG_Suborder__c = :s.id];
        Asset astObj= [SELECT Id,Name, LG_MACAddress__c, LG_IPAddress__c  FROM Asset WHERE csord__Service__r.Id =:service.Id];
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
        PageReference pRef = Page.LG_ResendWelcomePackEmail;
        pRef.getParameters().put('id', s.Id);
        Test.setCurrentPage(pRef);
        s.csord__Status__c='Inprogress';
        update s;
        LG_ReSendWelcomePackEmail classobj = new LG_ReSendWelcomePackEmail();
        classobj.validateScenario();
        classobj.sendEmail();
        System.assertEquals(false, classobj.validationStatus, 'False');
         }   
    }
    
    public static testmethod void TestValidationName(){
        csord__Solution__c s = [select Id, csord__Order__c, csord__Order__r.Name,LG_Termination__c from csord__Solution__c where name = 'test solution' limit 1];
        csord__Service__c service = [SELECT Id,Name, csord__Status__c FROM csord__Service__c WHERE csord__Identification__c = 'TestService2' AND csord__Service__c = NULL AND LG_Suborder__c = :s.id];
        Asset astObj= [SELECT Id,Name, LG_MACAddress__c, LG_IPAddress__c  FROM Asset WHERE csord__Service__r.Id =:service.Id];
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
        PageReference pRef = Page.LG_ResendWelcomePackEmail;
        pRef.getParameters().put('id', s.Id);
        Test.setCurrentPage(pRef);
        service.Name='Company Fiber';
        update service;
        LG_ReSendWelcomePackEmail classobj = new LG_ReSendWelcomePackEmail();
        classobj.validateScenario();
        //classobj.sendEmail();
        System.assertEquals(false, classobj.validationStatus, 'False');
         }
    }  
    /*public static testmethod void TestValidationSuppressCheck(){
        csord__Solution__c s = [select Id, csord__Order__c, csord__Order__r.Name,LG_Termination__c from csord__Solution__c where name = 'test solution' limit 1];
        csord__Service__c service = [SELECT Id,Name, csord__Status__c FROM csord__Service__c WHERE csord__Identification__c = 'TestService2' AND csord__Service__c = NULL AND LG_Suborder__c = :s.id];
        Asset astObj= [SELECT Id,Name, LG_MACAddress__c, LG_IPAddress__c  FROM Asset WHERE csord__Service__r.Id =:service.Id];
		   User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){       
		Test.startTest();
        PageReference pRef = Page.LG_ResendWelcomePackEmail;
        pRef.getParameters().put('id', s.Id);
        Test.setCurrentPage(pRef);
        s.LG_Suppress_Welcome_Pack__c = True;
        update s;
        LG_ReSendWelcomePackEmail classobj = new LG_ReSendWelcomePackEmail();
        classobj.validateScenario();
        classobj.sendEmail();
        System.assertEquals(false, classobj.validationStatus, 'False');
}        
    }*/
     
    public static testmethod void TestValidationTermination(){
        csord__Solution__c s = [select Id, csord__Order__c, csord__Order__r.Name,LG_Termination__c from csord__Solution__c where name = 'test solution' limit 1];
        csord__Service__c service = [SELECT Id,Name, csord__Status__c FROM csord__Service__c WHERE csord__Identification__c = 'TestService2' AND csord__Service__c = NULL AND LG_Suborder__c = :s.id];
        Asset astObj= [SELECT Id,Name, LG_MACAddress__c, LG_IPAddress__c  FROM Asset WHERE csord__Service__r.Id =:service.Id];
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
        PageReference pRef = Page.LG_ResendWelcomePackEmail;
        pRef.getParameters().put('id', s.Id);
        Test.setCurrentPage(pRef);
        s.LG_Termination__c =True;
        update s;
        LG_ReSendWelcomePackEmail classobj = new LG_ReSendWelcomePackEmail();
        classobj.validateScenario();
        classobj.sendEmail();
         }
      //  System.assertEquals(false, classobj.validationStatus, 'True');
        
    } 
    
     public static testmethod void TestValidationPreferredCommunication(){
        csord__Solution__c s = [select Id, csord__Order__c, csord__Order__r.Name,LG_Termination__c, csord__Order__r.csordtelcoa__Opportunity__r.LG_PrimaryContact__r.LG_PreferredCommunication__c from csord__Solution__c where name = 'test solution2' limit 1];
        csord__Service__c service = [SELECT Id,Name, csord__Status__c FROM csord__Service__c WHERE csord__Identification__c = 'TestService3' AND csord__Service__c = NULL AND LG_Suborder__c = :s.id];
        Asset astObj= [SELECT Id,Name, LG_MACAddress__c, LG_IPAddress__c  FROM Asset WHERE csord__Service__r.Id =:service.Id];
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
         Test.startTest();
        PageReference pRef = Page.LG_ResendWelcomePackEmail;
        pRef.getParameters().put('id', s.Id);
        Test.setCurrentPage(pRef);
        //service.Name='Virtual Voice Kundensetup';
        //update service;
        LG_ReSendWelcomePackEmail classobj = new LG_ReSendWelcomePackEmail();
        classobj.validateScenario();
         
        //classobj.sendEmail();
        //System.assertEquals(false, classobj.validationStatus, 'False');
         }
    }
    
     public static testmethod void TestSaveAsset(){
        csord__Solution__c s = [select Id, csord__Order__c, csord__Order__r.Name,LG_Termination__c, csord__Order__r.csordtelcoa__Opportunity__r.LG_PrimaryContact__r.LG_PreferredCommunication__c from csord__Solution__c where name = 'test solution2' limit 1];
        csord__Service__c service = [SELECT Id,Name, csord__Status__c FROM csord__Service__c WHERE csord__Identification__c = 'TestService3' AND csord__Service__c = NULL AND LG_Suborder__c = :s.id];
        Asset astObj= [SELECT Id,Name, LG_MACAddress__c, LG_IPAddress__c  FROM Asset WHERE csord__Service__r.Id =:service.Id];
        Test.startTest();
        PageReference pRef = Page.LG_ResendWelcomePackEmail;
        pRef.getParameters().put('id', s.Id);
        Test.setCurrentPage(pRef);
        LG_ReSendWelcomePackEmail classobj = new LG_ReSendWelcomePackEmail();
        classobj.SaveAsset();
        
        
    }


        
}