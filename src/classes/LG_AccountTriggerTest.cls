@isTest
private class LG_AccountTriggerTest
{
public static testMethod void accountTriggerTest()
{
Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
Account pacc = new Account();
    
    pacc.RecordTypeId=RecordTypeIdContact;
    pacc.Name='TestPartnerAccountProd';
    insert pacc;

Account acc = new Account();
        acc.Name='TestAccProd';
        acc.Partner_lookup__c=pacc.Id;
        insert acc;
    
    Opportunity opp = new Opportunity ();
        opp.Name='TestOppProd';
        opp.AccountId=acc.Id;
        opp.StageName='Awareness of interest';
        opp.CloseDate= System.today() + 30;
        insert opp;
    
    opp.StageName='Closed Lost';
    update opp;
    
List<Opportunity> oppsToUpdate1 = new List<Opportunity>();    
   
    for(Opportunity opp1 : [select id, StageName, UM_PartnerAccount__c from Opportunity where AccountId=: acc.Id])
     {
     //if(opp.StageName!='Ready for Order' && profileName=='UM_CSR_Profile' )
     if((opp1.StageName!='Ready for Order'||opp1.StageName!='Closed Lost' || opp1.StageName!='Pre-Installation-Cancellation') && opp1.UM_PartnerAccount__c==null)
         {
          opp1.UM_PartnerAccount__c=acc.Partner_lookup__c;
             
          oppsToUpdate1.add(opp1);
         }
     }
   // opp.StageName='Closed Lost';
   //opp.UM_PartnerAccount__c=acc.Partner_lookup__c;
            Test.StartTest();
            update oppsToUpdate1;
    Test.StopTest(); 
    
}
      

}