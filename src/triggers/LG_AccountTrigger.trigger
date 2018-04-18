trigger LG_AccountTrigger on Account (after insert, after update, before insert, before update) {
          
/*UMR-1837 Fix added for partner account syn on account and opp for CSR user*/
//Id profileId=userinfo.getProfileId();
//String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
//System.debug('ProfileName==>'+profileName);

Set<Id> accountIds = new Set<Id>();
Account theAcc = Trigger.new[0];
    if(theAcc.Partner_lookup__c!=null)
    accountIds.add(theAcc.Id);
    List<Opportunity> oppsToUpdate = new List<Opportunity>();

     for(Opportunity opp : [select id, StageName, UM_PartnerAccount__c from Opportunity where AccountId in: accountIds])
     {
     //if(opp.StageName!='Ready for Order' && profileName=='UM_CSR_Profile' )
     if((opp.StageName!='Ready for Order'||opp.StageName!='Closed Lost' ||opp.StageName!='Pre-Installation-Cancellation') && opp.UM_PartnerAccount__c==null)
         {
          opp.UM_PartnerAccount__c=theAcc.Partner_lookup__c;
          oppsToUpdate.add(opp);
         }
     }
     update oppsToUpdate;
/*UMR-1837 Fix added for partner account syn on account and opp for CSR user*/
  
    
    if(trigger.isAfter){
        if(trigger.isUpdate){
             
            LG_AccountTriggerHandler.updateBillingAccount(trigger.New, trigger.oldMap);

         
            
            
            
        }
    }
    
}