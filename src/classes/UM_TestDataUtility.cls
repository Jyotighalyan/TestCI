@isTest
public class UM_TestDataUtility {

    public static Account acc=new Account();
    public static Contact cont=new Contact ();
    public static Opportunity opp= new Opportunity ();
    
    public static Account createAccount()
    {
        //Partner Account test data
        Account prtacc= new Account();
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        prtacc.RecordTypeId=RecordTypeIdAccount;
        prtacc.Name='Dummy Partner';
        insert prtacc;
        acc.Name='infosys';
        acc.LG_Segment__c='SoHo';
        acc.UM_IndustryClassification__c='Q_GESUNDHEITS_UND_SOZIALWESEN';
        acc.Partner_lookup__c=prtacc.Id; 
        //acc.UM_DetailedIndustryClassification__c='45 Handel mit Kraftfahrzeugen, Instandhaltung und Reparatur von Kraftfahrzeugen';
        insert acc;
        
        List<Account> acc1=[SELECT Id,Name,LG_Segment__c,UM_DetailedIndustryClassification__c FROM Account WHERE Name='infosys' LIMIT 1];
        System.debug('acc1-->'+acc1);
        return acc1[0];
    }  
      
    public static Opportunity createOpportunityFromUnitymedia_NRW_GmbH()
    {
        opp=new Opportunity();
        opp.Name='Ananda';
        //acc=createAccount();
        opp.AccountId=acc.Id;
        opp.Type='New Bussiness';
        //String QuotingDate = '01/01/2017';
        opp.UM_QuotingDate__c=System.Today();    
        //String ClosingDate = '12/01/2017';
        opp.CloseDate=System.Today()+1;
        opp.StageName='Customer Approved';
        opp.LG_QuoteExpirationDays__c=28;
        opp.LG_PrimaryContact__c=cont.Id;
        opp.OwnerId=createOppOwnerFromUnitymedia_NRW_GmbH().Id;
        insert opp;
        System.debug('opp-->'+opp.Name);
        Opportunity opp1=[SELECT Id,Name,Type,UM_QuotingDate__c,CloseDate,StageName,LG_QuoteExpirationDays__c FROM Opportunity LIMIT 1];
        return opp1;
    }
        
    public static Opportunity createOpportunityFromUnitymedia_Hessen_GmbH_Co_KG()
    {
        opp=new Opportunity();
        opp.Name='Ananda';
        //acc=createAccount();
        opp.AccountId=acc.Id;
        opp.Type='New Bussiness';
        //String QuotingDate = '01/01/2017';
        opp.UM_QuotingDate__c=System.Today();    
        //String ClosingDate = '12/01/2017';
        opp.CloseDate=System.Today()+1;
        opp.StageName='Customer Approved';
        opp.LG_QuoteExpirationDays__c=28;
        opp.LG_PrimaryContact__c=cont.Id;
        opp.OwnerId=createOppOwnerFromUnitymedia_Hessen_GmbH_Co_KG().Id;
        insert opp;
        System.debug('opp-->'+opp.Name);
        Opportunity opp1=[SELECT Id,Name,Type,UM_QuotingDate__c,CloseDate,StageName,LG_QuoteExpirationDays__c FROM Opportunity LIMIT 1];
        return opp1;
    }
    
    public static Opportunity createOpportunityFromUnitymedia_BW_GmbH()
    {
        opp=new Opportunity();
        opp.Name='Ananda';
        //acc=createAccount();
        //opp.Account=acc;
        opp.AccountId=acc.Id;
        opp.Type='New Bussiness';
        //String QuotingDate = '01/01/2017';
        opp.UM_QuotingDate__c=System.Today();    
        //String ClosingDate = '12/01/2017';
        opp.CloseDate=System.Today()+1;
        opp.StageName='Customer Approved';
        opp.LG_QuoteExpirationDays__c=28;
        opp.LG_PrimaryContact__c=cont.Id;
        opp.OwnerId=createOppOwnerFromUnitymedia_BW_GmbH().Id;
        insert opp;
        System.debug('opp-->'+opp.Name);
        Opportunity opp1=[SELECT Id,Name,Type,UM_QuotingDate__c,CloseDate,StageName,LG_QuoteExpirationDays__c FROM Opportunity LIMIT 1];
        return opp1;
    }
    public static Opportunity createOpportunityFromOtherCompnany()
    {
        opp=new Opportunity();
        opp.Name='Ananda';
        //acc=createAccount();
        opp.AccountId=acc.Id;
        opp.Type='New Bussiness';
        //String QuotingDate = '01/01/2017';
        opp.UM_QuotingDate__c=System.Today();    
        //String ClosingDate = '12/01/2017';
        opp.CloseDate=System.Today()+1;
        opp.StageName='Customer Approved';
        opp.LG_QuoteExpirationDays__c=28;
        opp.LG_PrimaryContact__c=cont.Id;
        opp.OwnerId=createOppOwnerFromOtherCompnany().Id;
        insert opp;
        System.debug('opp-->'+opp.Name);
        Opportunity opp1=[SELECT Id,Name,Type,UM_QuotingDate__c,CloseDate,StageName,LG_QuoteExpirationDays__c FROM Opportunity LIMIT 1];
        return opp1;
    }
      
    public static Contact createContact()
    {
        cont.LastName='Ghosh';
        acc=createAccount();
        cont.Account=acc;
        cont.Email='suvadip_ghosh01@infosys.com';
        cont.Phone='0245123578';
        cont.Salutation='Mr';
        insert cont;
        
        Contact cont1=[SELECT Id,Email,Phone FROM Contact WHERE LastName='Ghosh'];
        return cont1;
    }
    
    public static CSCAP__Customer_Approval__c createCustApprovalFromUnitymedia_NRW_GmbH(){
        CSCAP__Customer_Approval__c ca = new CSCAP__Customer_Approval__c();
        
        //acc=createAccount();
        ca.CSCAP__Account__c=acc.Id;           
        
        cont=createContact();
        ca.CSCAP__Contact__c=cont.Id;
        
        opp=createOpportunityFromUnitymedia_NRW_GmbH();
        ca.CSCAP__Opportunity__c=opp.Id;
        date myDate =date.today();
        date ordDate = myDate.addDays(-20);
        ca.order_date__c=ordDate;
        insert ca;
        
        CSCAP__Customer_Approval__c ca1=[SELECT Id,CSCAP__Account__c,order_date__c,CSCAP__Contact__c,CSCAP__Opportunity__c FROM CSCAP__Customer_Approval__c LIMIT 1];
        System.debug('*** Cust Approval'+ca1.order_date__c);
        return ca1;
        
    }
    public static CSCAP__Customer_Approval__c createCustApprovalFromUnitymedia_Hessen_GmbH_Co_KG()
    {
        CSCAP__Customer_Approval__c ca = new CSCAP__Customer_Approval__c();
        
        //acc=createAccount();
        ca.CSCAP__Account__c=acc.Id;           
        
        cont=createContact();
        ca.CSCAP__Contact__c=cont.Id;
        
        opp=createOpportunityFromUnitymedia_Hessen_GmbH_Co_KG();
        ca.CSCAP__Opportunity__c=opp.Id;
        date myDate =date.today();
        date ordDate = myDate.addDays(-20);
        ca.order_date__c=ordDate;
        insert ca;
        
        CSCAP__Customer_Approval__c ca1=[SELECT Id,CSCAP__Account__c,order_date__c,CSCAP__Contact__c,CSCAP__Opportunity__c FROM CSCAP__Customer_Approval__c LIMIT 1];
        System.debug('*** Cust Approval'+ca1.order_date__c);
        return ca1;
        
    }
    
    public static CSCAP__Customer_Approval__c createCustApprovalFromUnitymedia_BW_GmbH()
    {
        CSCAP__Customer_Approval__c ca = new CSCAP__Customer_Approval__c();
        
        //acc=createAccount();
        ca.CSCAP__Account__c=acc.Id;           
        
        cont=createContact();
        ca.CSCAP__Contact__c=cont.Id;
        
        opp=createOpportunityFromUnitymedia_BW_GmbH();
        ca.CSCAP__Opportunity__c=opp.Id;
        date myDate =date.today();
        date ordDate = myDate.addDays(-20);
        ca.order_date__c=ordDate;
        insert ca;
        
        CSCAP__Customer_Approval__c ca1=[SELECT Id,CSCAP__Account__c,order_date__c,CSCAP__Contact__c,CSCAP__Opportunity__c FROM CSCAP__Customer_Approval__c LIMIT 1];
        System.debug('*** Cust Approval'+ca1.order_date__c);
        return ca1;
        
    }
    
    public static CSCAP__Customer_Approval__c createCustApprovalFromOtherCompnany()
    {
        CSCAP__Customer_Approval__c ca = new CSCAP__Customer_Approval__c();
        
        //acc=createAccount();
        ca.CSCAP__Account__c=acc.Id;           
        
        cont=createContact();
        ca.CSCAP__Contact__c=cont.Id;
        
        opp=createOpportunityFromOtherCompnany();
        ca.CSCAP__Opportunity__c=opp.Id;
        date myDate =date.today();
        date ordDate = myDate.addDays(-20);
        ca.order_date__c=ordDate;
        insert ca;
        
        CSCAP__Customer_Approval__c ca1=[SELECT Id,CSCAP__Account__c,order_date__c,CSCAP__Contact__c,CSCAP__Opportunity__c FROM CSCAP__Customer_Approval__c LIMIT 1];
        System.debug('*** Cust Approval'+ca1.order_date__c);
        return ca1;
        
    }
    public static cscfga__Product_Basket__c createProductBasket()
    {
        cscfga__Product_Basket__c prodBasket = new cscfga__Product_Basket__c();
        //opp=createOpportunity(); 
        prodBasket .cscfga__Opportunity__c=opp.Id;
        insert prodBasket;
        cscfga__Product_Basket__c prodBasket1=[SELECT Id,cscfga__Opportunity__c FROM cscfga__Product_Basket__c WHERE cscfga__Opportunity__c=:opp.Id LIMIT 1];
        return prodBasket1;
        
    }
    public static cscfga__Product_Configuration__c createProductConfiguration()
    {
        cscfga__Product_Configuration__c prodConfig= new cscfga__Product_Configuration__c();
        
        prodConfig.Name='Sample Product Configuration';
        prodConfig.cscfga__Description__c='Sample Description';
        prodConfig.cscfga__Total_Price__c=500;
        cscfga__Product_Basket__c prodBasket=createProductBasket();
        prodConfig.cscfga__Product_Basket__c= prodBasket.Id;
        insert prodConfig;
        
        cscfga__Product_Configuration__c prodConfig1=[SELECT Id,Name,cscfga__Description__c,cscfga__Total_Price__c,cscfga__Product_Basket__c FROM cscfga__Product_Configuration__c WHERE cscfga__Product_Basket__c=:prodBasket.Id LIMIT 1];
        return prodConfig1;
    }
    
    public static User createOppOwnerFromUnitymedia_NRW_GmbH()
    {
        /*UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;*/

        Profile prof=[SELECT Id From Profile Where Name='System Administrator'];
        User u=new User();
        u.LastName='Test Owner';
        u.Email = 'puser000@gmail.com';
        u.Username='puser000@gmail.com.un';
        u.CompanyName='Unitymedia NRW GmbH';
        u.ProfileId=prof.Id;
        u.Title = 'title';
        u.Alias = 'alias';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        insert u;
        User u1=[SELECT Id,Name,CompanyName FROM User WHERE LastName='Test Owner' LIMIT 1];
        return u1;
        
    }
    public static User createOppOwnerFromUnitymedia_Hessen_GmbH_Co_KG ()
    {
        /*UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;*/

        Profile prof=[SELECT Id From Profile Where Name='System Administrator'];
        User u=new User();
        u.LastName='Test Owner';
        u.Email = 'puser000@gmail.com';
        u.Username='puser000@gmail.com.un';
        u.CompanyName='Unitymedia Hessen GmbH & Co. KG';
        u.ProfileId=prof.Id;
        u.Title = 'title';
        u.Alias = 'alias';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        insert u;
        User u1=[SELECT Id,Name,CompanyName FROM User WHERE LastName='Test Owner' LIMIT 1];
        return u1;
        
    }
    public static User createOppOwnerFromUnitymedia_BW_GmbH ()
    {
        /*UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;*/

        Profile prof=[SELECT Id From Profile Where Name='System Administrator'];
        User u=new User();
        u.LastName='Test Owner';
        u.Email = 'puser000@gmail.com';
        u.Username='puser000@gmail.com.un';
        u.CompanyName='Unitymedia BW GmbH';
        u.ProfileId=prof.Id;
        u.Title = 'title';
        u.Alias = 'alias';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        insert u;
        User u1=[SELECT Id,Name,CompanyName FROM User WHERE LastName='Test Owner' LIMIT 1];
        return u1;
        
    }
    public static User createOppOwnerFromOtherCompnany ()
    {
        /*UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;*/

        Profile prof=[SELECT Id From Profile Where Name='System Administrator'];
        User u=new User();
        u.LastName='Test Owner';
        u.Email = 'puser000@gmail.com';
        u.Username='puser000@gmail.com.un';
        u.CompanyName='Infosys';
        u.ProfileId=prof.Id;
        u.Title = 'title';
        u.Alias = 'alias';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        insert u;
        User u1=[SELECT Id,Name,CompanyName FROM User WHERE LastName='Test Owner' LIMIT 1];
        return u1;
        
    }
    public static User createUser()
    {
        //UserRole r = new UserRole(DeveloperName = 'UM_GlobalSystemAdministration', Name = 'UM Global System Administration');
        //insert r;
        Profile prof=[SELECT Id From Profile Where Name='System Administrator'];
        User u=new User();
        u.LastName='Test Owner';
        u.Email = 'puser000@gmail.com';
        u.Username='puser000@gmail.com.un';
        u.CompanyName='Infosys';
        u.ProfileId=prof.Id;
        u.Title = 'title';
        u.Alias = 'alias';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.UserRoleId=[SELECT Id FROM UserRole WHERE DeveloperName='UM_GlobalSystemAdministration'].Id;
        insert u;
        
        Account acc1=new Account();
        acc1.Name='infosys';
        acc1.LG_Segment__c='SoHo';
        acc1.UM_IndustryClassification__c='Q_GESUNDHEITS_UND_SOZIALWESEN';
        //acc1.UM_DetailedIndustryClassification__c='Erzbergbau';
        acc1.OwnerId=u.Id;
        insert acc1;
        Contact cont1=new Contact();
        cont1.LastName='Ghosh';
        cont1.Account=acc1;
        cont1.Email='suvadip_ghosh01@infosys.com';
        cont1.Phone='0245123578';
        insert cont1;
        Id p = [select id from profile where name='Partner Community User'].id;
        
        User u1=new User();
        u1.LastName='Test Owner';
        u1.Email = 'puser000@gmail.com';
        u1.Username='puser000@gmail.com.un';
        u1.CompanyName='Infosys';
        u1.ProfileId=p;
        u1.ContactId=cont1.Id;
        u1.IsActive=true;
        u1.Title = 'title';
        u1.Alias = 'alias';
        u1.TimeZoneSidKey = 'America/Los_Angeles';
        u1.EmailEncodingKey = 'UTF-8';
        u1.LanguageLocaleKey = 'en_US';
        u1.LocaleSidKey = 'en_US';
        
        insert u1;
        
        return u1;

    }
}