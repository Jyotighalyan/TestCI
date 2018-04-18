/****************************************************************************************************************
* OwnershipChangeSchedulerTest
* 
* 2017/07/14 V 1.0 UMR-2093 Matthias Pfaff Test for OwnershipChangeScheduler
*
*
*****************************************************************************************************************/



@isTest
private class OwnershipChangeSchedulerTest{
    /*



static testMethod void TestOwnershipSchedulerPositive() 
{
User oldOwner;
User PAMuser;
User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
//System object creation has to split transactionally from normal object creation
//therefore the runAs workaround
System.runAs ( thisUser ) 
{
oldOwner = UM_TestDataUtility.createOppOwnerFromUnitymedia_NRW_GmbH();
PAMuser = new User();
Profile prof=[SELECT Id From Profile Where Name = 'System Administrator'];

PAMuser.Firstname = 'PAM';
PAMuser.Lastname = 'User';
PAMuser.Email = 'puser000@gmail.com';
PAMuser.Username='puser000@gmail.com.pamUser';
PAMuser.CompanyName='Unitymedia NRW GmbH';
PAMuser.ProfileId=prof.Id;
PAMuser.Title = 'title';
PAMuser.Alias = 'alias';
PAMuser.TimeZoneSidKey = 'America/Los_Angeles';
PAMuser.EmailEncodingKey = 'UTF-8';
PAMuser.LanguageLocaleKey = 'en_US';
PAMuser.LocaleSidKey = 'en_US';
insert PAMuser;

PAMuser = [Select id from User where Name = 'PAM User' limit 1];
oldowner = [Select id from User where LastName = 'Test Owner' limit 1];


System.assertNotEquals(null,oldowner);
System.assertNotEquals(null,PAMUser);
}

Account ipartner;
Contact con;
System.runAs(thisUser)
{
Id PrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
System.assertNotEquals(null, PrecordTypeId);         

//create indirect partner Account 
ipartner = new Account();
ipartner.Name = 'IPartner';
ipartner.LG_Segment__c = 'SME';
ipartner.RecordTypeId = PrecordTypeId;
ipartner.owner = oldowner;
ipartner.UM_IndustryClassification__c = 'A_LAND_UND_FORSTWIRTSCHAFT_FISCHEREI';
ipartner.UM_DetailedIndustryClassification__c = 'Forstwirtschaft_und_Holzeinschlag';
insert ipartner;
ipartner = [Select id, ownerid from Account where Name = 'IPartner' limit 1];

//create partner user for indirect partner account         
con = new Contact(FirstName='Partner', LastName = 'User', Salutation = 'Mr.', AccountId = ipartner.Id);
insert con;  
}

User PartnerUser;
System.runAs(thisUser) 
{
Id profile = [select id from profile where name='UM_Partner'].id;

// Contact con = [Select id from Contact where Name = 'Partner User'];
PartnerUser = new User();
PartnerUser.FirstName='Partner';
PartnerUser.LastName='User';
PartnerUser.Email = 'puser000@gmail.com';
PartnerUser.Username='puser000@gmail.com.partneruser';
PartnerUser.CompanyName='Infosys';
PartnerUser.ProfileId=profile;
PartnerUser.ContactId=con.Id;
PartnerUser.IsActive=true;
PartnerUser.Title = 'title';
PartnerUser.Alias = 'alias';
PartnerUser.TimeZoneSidKey = 'America/Los_Angeles';
PartnerUser.EmailEncodingKey = 'UTF-8';
PartnerUser.LanguageLocaleKey = 'en_US';
PartnerUser.LocaleSidKey = 'en_US';

insert PartnerUser;
PartnerUser = [Select id from User where Name = 'Partner User'];

}

//create direct Sales partner without partner user

Account testAccountI;
Account testAccountD;
Account Dpartner;

System.runAs(thisUser)
{
Dpartner= new Account();
Dpartner.Name='PAM User';
Dpartner.LG_Segment__c='SME';
Dpartner.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
Dpartner.UM_IndustryClassification__c = 'A_LAND_UND_FORSTWIRTSCHAFT_FISCHEREI';
Dpartner.UM_DetailedIndustryClassification__c = 'Forstwirtschaft_und_Holzeinschlag';
Dpartner.owner = oldowner;
insert Dpartner;
Dpartner = [Select id, ownerid from Account where Name = 'PAM User' limit 1];

// create accounts that should be assigned ownership
testAccountI = new Account();
testAccountI.Name = 'testAccountI';
testAccountI.LG_Segment__c = 'SME';
testAccountD = new Account();
testAccountD.Name = 'testAccountI';
testAccountD.LG_Segment__c = 'SME';
//Assign wrong ownership
testAccountI.OwnerId = oldOwner.Id;
testAccountD.OwnerId = oldOwner.Id;
//Assign direct and indirect sales Partners
testAccountI.Partner_lookup__c = ipartner.id;
testAccountD.Partner_lookup__c = dpartner.id;
insert testAccountI;
insert testAccountD;
}
// ready for Test!!! 

Test.startTest();
System.debug('*** OwnershipChangeSchedulerTest start');
OwnershipChangeScheduler job = new OwnershipChangeScheduler();
job.execute(null);
Test.stopTest();
System.debug('*** OwnershipChangeSchedulerTest stop');

testAccountI = [Select Id, Ownerid from Account where id = : testAccountI.Id];
testAccountD = [Select Id, Ownerid from Account where id = : testAccountD.Id];  
System.assertEquals(PartnerUser.Id,testAccountI.OwnerId,'Indirect Sales Partner Owner Id not matching');
// System.assertEquals(PamUser.Id,testAccountD.OwnerId,'Direct Sales Partner Owner Id not matching'); 
}

// do not change ownership for D2D Partner User
static testMethod void TestOwnershipSchedulerNegative()
{
User oldOwner;
User D2DPartnerUser;
User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
Account testAccountD2D1;
Account testAccountD2D2;
Account d2dpartneraccount;
Contact con;

//System object creation has to split transactionally from normal object creation
//therefore the runAs workaround
System.runAs ( thisUser ) 
{
Id PrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
System.assertNotEquals(null, PrecordTypeId);         

//create indirect partner Account 
d2dpartneraccount = new Account();
d2dpartneraccount.Name = 'D2DPartner';
d2dpartneraccount.LG_Segment__c = 'SoHo';
d2dpartneraccount.RecordTypeId = PrecordTypeId;
d2dpartneraccount.owner = oldowner;
d2dpartneraccount.UM_IndustryClassification__c = 'A_LAND_UND_FORSTWIRTSCHAFT_FISCHEREI';
d2dpartneraccount.UM_DetailedIndustryClassification__c = 'Forstwirtschaft_und_Holzeinschlag';
insert d2dpartneraccount;
d2dpartneraccount= [Select id, ownerid from Account where Name = 'D2DPartner' limit 1];

//create partner user for indirect partner account         
con = new Contact(FirstName='D2D', LastName = 'User', Salutation = 'Mr.', AccountId = d2dpartneraccount.Id);
insert con;  
}

System.runAs ( thisUser ) 
{
oldOwner = UM_TestDataUtility.createOppOwnerFromUnitymedia_NRW_GmbH();
D2DPartnerUser = new User();
Profile prof=[SELECT Id From Profile Where Name = 'UM Partner Sales User'];
D2DPartnerUser.Firstname = 'D2D';
D2DPartnerUser.Lastname = 'User';
D2DPartnerUser.Email = 'puser000@gmail.com';
D2DPartnerUser.Username='puser000@gmail.com.D2D';
D2DPartnerUser.CompanyName='Unitymedia NRW GmbH';
D2DPartnerUser.ProfileId=prof.Id;
D2DPartnerUser.ContactId=con.Id;
D2DPartnerUser.Title = 'title';
D2DPartnerUser.Alias = 'alias';
D2DPartnerUser.TimeZoneSidKey = 'America/Los_Angeles';
D2DPartnerUser.EmailEncodingKey = 'UTF-8';
D2DPartnerUser.LanguageLocaleKey = 'en_US';
D2DPartnerUser.LocaleSidKey = 'en_US';
insert D2DPartnerUser ;

D2DPartnerUser = [Select id from User where Name = 'D2D User' limit 1];
oldowner = [Select id from User where LastName = 'Test Owner' limit 1];

System.assertNotEquals(null,oldowner);
System.assertNotEquals(null,D2DPartnerUser);   
}

System.runAs(thisUser)
{
testAccountD2D1 = new Account();
testAccountD2D1.Name = 'testAccountI';
testAccountD2D1.LG_Segment__c = 'SoHo';
testAccountD2D2 = new Account();
testAccountD2D2.Name = 'testAccountI';
testAccountD2D2.LG_Segment__c = 'SME';
//Assign wrong ownership
testAccountD2D1.OwnerId = oldOwner.Id;
testAccountD2D2.OwnerId = oldOwner.Id;
//Assign direct and indirect sales Partners
testAccountD2D1.Partner_lookup__c = d2dpartneraccount.id;
testAccountD2D2.Partner_lookup__c = d2dpartneraccount.id;
insert testAccountD2D1;
insert testAccountD2D2;
}

Test.startTest();
System.debug('*** OwnershipChangeSchedulerTest start');
OwnershipChangeScheduler job = new OwnershipChangeScheduler();
job.execute(null);
Test.stopTest();
System.debug('*** OwnershipChangeSchedulerTest stop');

testAccountD2D1 = [Select Id, Ownerid from Account where id = : testAccountD2D1.Id];
testAccountD2D2 = [Select Id, Ownerid from Account where id = : testAccountD2D2.Id];  
System.assertEquals(oldOwner.Id,testAccountD2D1.OwnerId,'D2D Sales Account Owner was changed!');
System.assertEquals(oldOwner.Id,testAccountD2D2.OwnerId,'D2D Sales Account Owner was changed!'); 
}*/
    //added
    public static testMethod void Ownershiptest()
    {
        
        contact c1=new contact();
        c1.FirstName = 'xyzFirst';
        c1.LastName = 'XyZLast';
        //line changed - waveoc
        //AccountId = newAccount.Id,
        c1.Email = 'xyzmail@mail.com';
        c1.Salutation='Mr.';
        insert c1;
        /*  Profile prof=[SELECT Id From Profile Where Name='Standard Platform User'];
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
UserRole ur = new UserRole(Name = 'AB JitTest Partner User');
insert ur;
u.UserRoleId=ur.id;
insert u;*/
        
        //checking
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        // Insert account as current user
        System.runAs (thisUser) {
            Profile p = [SELECT Id FROM Profile WHERE Name='standard platform user'];
            UserRole r = [SELECT Id FROM UserRole WHERE Name='AB JitTest Partner User'];
            user  u = new User(alias = 'jsmith', email='jsmith@acme.com', 
                               emailencodingkey='UTF-8', lastname='Smith', 
                               languagelocalekey='en_US', 
                               localesidkey='en_US', profileid = p.Id,CompanyName='Infosys', userroleid = r.Id,
                               timezonesidkey='America/Los_Angeles', 
                               username='xyzabc1@acme.com');
            insert u;
            // system.runAs(u){
            test.startTest();
            //user u=ownershipchangeschedulertest.meth1();
            Account acc1=new Account();
            acc1.Name='Die Gefährten Partner Manager';
            acc1.LG_Segment__c='SoHo';
            acc1.UM_IndustryClassification__c='Q_GESUNDHEITS_UND_SOZIALWESEN';
            //acc1.UM_DetailedIndustryClassification__c='Erzbergbau';
            acc1.OwnerId=u.Id;
            Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
            system.debug(RecordTypeIdContact);
            
            acc1.RecordTypeId=RecordTypeIdContact;
            //id strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'partner'].Id;
            //Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('partner').getRecordTypeId();
            //system.debug(devRecordTypeId);
            // Recordtype rt=[select id from recordtype where name='partner'];
            //acc1.RecordTypeId=rt.id;
            system.debug(acc1);
            insert acc1;
            Contact cont1=new Contact();
            cont1.LastName='Ghosh';
            cont1.Account=acc1;
            cont1.Email='suvadip_ghosh01@infosys.com';
            cont1.Phone='0245123578';
            cont1.Salutation='Mr.';
            insert cont1;
            
            
            OwnershipChangeScheduler changeschedul=new OwnershipChangeScheduler();
            String sch = '0 0 23 * * ?';
            System.schedule('Test Territory Check', sch, changeschedul);
            test.stopTest();
        }
        
    }
    
}