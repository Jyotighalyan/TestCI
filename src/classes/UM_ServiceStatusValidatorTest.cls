@isTest
public Class UM_ServiceStatusValidatorTest{
    
 @future
    static void setup() {
    
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
	
    
}

public static testMethod void TestServiceStatusValidator(){ 

	List<id> Mid = New List<id>();
	
    
    Account MAcc = New Account();
    MAcc.Name='Medalia Account';
    MAcc.LG_VisitCountry__c ='Germany';
    MAcc.LG_Segment__c = 'SOHO';

    Insert MAcc;
    system.debug('@002'+MAcc);
    
    Contact MCon = New Contact();
    MCon.LastName='NPS Test Contact';
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
    //opp.OwnerId = users.Id;
	///opp.SF_Sales_Partner_ID_BW__c = 'BW12345';
	//opp.SF_Sales_Partner_ID_NRW_HSN__c = 'NRWHSN12345';
	insert opp;
    
    csord__Order__c order = new csord__Order__c();
    order.Name = 'TestOrder';
    order.csordtelcoa__Opportunity__c = opp.Id;
    order.csord__Identification__c = 'ID2';
    order.csord__Account__c = MAcc.Id;
    insert order;
    
    //Solution
	csord__Solution__c solution = new csord__Solution__c(Name = 'test solution', csord__Identification__c = '6465467986', csord__Order__c = order.Id);
	insert solution;
    
    csord__Service__c MService= New  csord__Service__c();
    MService.Name='NPS Service';
    MService.LG_ProductFamily__c='internet';
    MService.UM_ProductDescription__c='High Speed Internet';
    MService.csord__Subscription__c=MSubs.id;
    MService.csord__Identification__c='102';
    MService.LG_Address__c=address.id;
    MService.LG_RootOrder__c = order.Id;
    MService.LG_ServiceStatus__c = 'Requested';
    MService.LG_Suborder__c = solution.Id;
    //MService.csord__Activation_Date__c = Date.today();
    Insert MService;
    
    
	Mid.Add(MService.id);
    Test.StartTest();
    //try{
        MService.LG_ServiceStatus__c = 'Ready for Billing';
        MService.csord__Activation_Date__c = Date.today();
        update MService;
    //}catch(Exception e){
        
    //}
    
    UM_ServiceStatusValidator.ValidateServiceStatus(Mid);
    Test.StopTest();

 }
 }