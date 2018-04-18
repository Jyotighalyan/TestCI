@isTest
public Class UM_MedalliaNPSSurveyBuyTest{
    
@future
static void setup() {
	No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    noTriggers.Flag__c = true;
    noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
    upsert noTriggers;  
    
    UserRole role = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
    insert role;
    Profile prof = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    User usr = new User();
     usr.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
     usr.LastName = 'last';
     usr.Email = 'test@libertyglobal.com';
     usr.Username = 'buytest@libertyglobal.com' + System.currentTimeMillis();
     usr.CompanyName = 'TEST';
     usr.Title = 'title';
     usr.Alias = 'alias';
     usr.TimeZoneSidKey = 'America/Los_Angeles';
     usr.EmailEncodingKey = 'UTF-8';
     usr.LanguageLocaleKey = 'en_US';
     usr.LocaleSidKey = 'en_US';
     usr.UserRoleId = role.Id;
    insert usr;
}

@isTest Static void MedalliaCall(){ 

	List<id> Mid = New List<id>();
	
    User users = [SELECT Id FROM User LIMIT 1];
    
    Account MAcc = New Account();
    MAcc.Name='Medalia Account';
    MAcc.LG_VisitCountry__c ='Germany';

    Insert MAcc;
    system.debug('@002'+MAcc);
    
    Contact MCon = New Contact();
    MCon.LastName='NPS Test Contact';
    MCon.Salutation='Mr.';
    MCon.Email='godson_shanthini@infosys.com';
    MCon.Accountid = MAcc.id;
        
    Insert MCon;
    system.debug('@002'+MCon);
    
    csord__Subscription__c MSubs = new csord__Subscription__c();
    MSubs.Name='NPS Subs';
    MSubs.csord__Identification__c='101';
    MSubs.csord__Account__c = MAcc.id;
    Insert MSubs;
    system.debug('@002'+MSubs);
   
   cscrm__Address__c address = new cscrm__Address__c();
        address.cscrm__Zip_Postal_Code__c = '761104 abc 58';
        address.Name = 'Test Address';
        address.cscrm__Country__c='Germany';
        insert address;
    
    
	
	Opportunity opp = new Opportunity();
	opp.Name = 'Test Opportunity';
	opp.LG_PrimaryContact__c = MCon.Id;
	opp.AccountId = MAcc.Id;
	opp.LG_NEWSalesChannel__c = 'NEW Sales Channel';
    opp.StageName = 'Ready for Order';
    opp.CloseDate = Date.today() + 8;
    opp.OwnerId = users.Id;
	///opp.SF_Sales_Partner_ID_BW__c = 'BW12345';
	//opp.SF_Sales_Partner_ID_NRW_HSN__c = 'NRWHSN12345';
	insert opp;
    
    csord__Order__c order = new csord__Order__c();
    order.Name = 'TestOrder';
    order.csordtelcoa__Opportunity__c = opp.Id;
    order.csord__Identification__c = 'ID2';
    insert order;
    
    csord__Service__c MService= New  csord__Service__c();
    MService.Name='NPS Service';
    MService.LG_ProductFamily__c='internet';
    MService.UM_ProductDescription__c='High Speed Internet';
    MService.csord__Subscription__c=MSubs.id;
    MService.csord__Identification__c='102';
    MService.LG_Address__c=address.id;
    MService.LG_RootOrder__c = order.Id;
    Insert MService;
    
    
    
    B2B_Care_Ext_Connections__c MedalliaConnBrand = new B2B_Care_Ext_Connections__c();
        MedalliaConnBrand.Name = 'Germany';
        MedalliaConnBrand.Brand__c = 'Unitymedia Business';               
        insert MedalliaConnBrand;
    
    B2B_Care_Ext_Connections__c MedalliaConn = new B2B_Care_Ext_Connections__c();
        MedalliaConn.Name = 'Medallia External System Info';
        MedalliaConn.UM_No_of_Tries__c = 3;
        MedalliaConn.Connection_URL__c = 'https://libertyglobal.medallia.eu/libertyglobalb2b.feed?unitymediainvitation';       
        insert MedalliaConn;
    
	Mid.Add(opp.id);
    Test.StartTest();
    UM_MedalliaNPSSurveyBuy.Create_Medallia_NPS_JSON_Request(Mid);
    Test.StopTest();

 }
 }