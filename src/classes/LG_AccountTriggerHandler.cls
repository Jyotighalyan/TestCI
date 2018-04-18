public with sharing class LG_AccountTriggerHandler {

    public static void updateBillingAccount(list<Account> lstNewAccount, map<Id,Account> mapOldAccount){
    	set<Id> set_AccountId= new set<Id>();
    	list<csconta__Billing_Account__c> lstBillAccountToBeUpdated=new list<csconta__Billing_Account__c>();
    	for(Account acc:lstNewAccount){
    		if(mapOldAccount.containsKey(acc.Id) && (mapOldAccount.get(acc.Id).Name!=acc.Name || mapOldAccount.get(acc.Id).LG_VIP__c!=acc.LG_VIP__c || mapOldAccount.get(acc.Id).LG_Segment__c!=acc.LG_Segment__c) ){
    			set_AccountId.add(acc.Id);
    		}
    	}
    	
    	 if(!set_AccountId.isEmpty()){
    		lstBillAccountToBeUpdated=[select id,csconta__Account__c, UM_IsAccountSynced__c from csconta__Billing_Account__c  where csconta__Account__c IN:set_AccountId];
    		if(!lstBillAccountToBeUpdated.isEmpty()){
    			for(csconta__Billing_Account__c ba:lstBillAccountToBeUpdated){
    				ba.UM_IsAccountSynced__c=true;
    			}
    			update lstBillAccountToBeUpdated;
    		}
    	}
    	 
    }
}