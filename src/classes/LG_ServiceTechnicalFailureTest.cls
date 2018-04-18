@isTest
public class LG_ServiceTechnicalFailureTest {
    @isTest static void method1() {
    try{
     User careAgent=LG_Care_TestRunAsUser.testRunAs();
            System.runAs(careAgent) {
    Account paccM3 = new Account();
    Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
    paccM3.RecordTypeId=RecordTypeIdAccount;
    paccM3.Name='TestPartnerAccountUP';
    insert paccM3;

Account NPSAcc = New Account();
NPSAcc.Name='NPS Test Account';
NPSAcc.Partner_lookup__c=paccM3.Id;
NPSAcc.LG_Segment__c='SME';
NPSAcc.UM_IndustryClassification__c='I_GASTGEWERBE';
NPSAcc.LG_ChamberOfCommerceNumber__c = '12345678';
Insert NPSAcc;
        
Contact NPSCon= New Contact();
NPSCon.LastName='NPS Test Contact';
NPSCon.Email='rishi.kapoor@infosys.com';
Insert NPSCon;

csord__Subscription__c NPSSubs = new csord__Subscription__c();
NPSSubs.Name='NPS Subs';
NPSSubs.csord__Identification__c='101';
Insert NPSSubs;
csord__Service__c NPSService = New  csord__Service__c();
NPSService.Name='NPS Service';
NPSService.LG_ProductFamily__c='internet';
NPSService.UM_ProductDescription__c='High Speed Internet';
NPSService.csord__Subscription__c=NPSSubs.id;
NPSService.csord__Identification__c='102';
Insert NPSService;

Opportunity Oppty2= new Opportunity();
Oppty2.Name='Nps Opportunity';
Oppty2.Accountid=NPSAcc.id;
Oppty2.LG_PrimaryContact__c=NPSCon.id;
Oppty2.Type='New Business';
Oppty2.UM_QuotingDate__c=System.today();
Oppty2.StageName='Awarness of interest';
Oppty2.Probability__c='10';
Oppty2.CloseDate=system.today()+7;
//Oppty2.UM_PartnerAccount__c=paccM3.id;
Insert Oppty2;       
LG_ServiceTechnicalFailure.createCalloutFailureResult(Oppty2.id,null,NPSAcc.id,NPSService.Name,'e','test','g','h');
  }
  }
    
    Catch(exception e)
    {}
    }
}