public class UM_ContactTriggerHandler {

    public static void executeAfterUpdate(list<Contact> newContacts, map<Id,Contact> oldContacts){
        set<id> updatedContacts = new set<id>();
        for(contact c : newContacts){
        	if((c.FirstName!= oldContacts.get(c.id).Firstname) || (c.LastName!= oldContacts.get(c.id).Lastname))    
            	updatedContacts.add(c.id);	
        }
        updateBillingAccountFlag(newContacts);
    }
    
    private static void updateBillingAccountFlag(list<Contact> contacts){
        list<csconta__Billing_Account__c> billingAccounts = [select id,UM_IsAccountSynced__c from csconta__Billing_Account__c
                                                            	where Billing_Contact__c in :contacts];
        for(csconta__Billing_Account__c ba : billingAccounts)
            ba.UM_IsAccountSynced__c=true;
        
        update billingAccounts;
        
    }
}