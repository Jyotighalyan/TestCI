public class LG_BillingAccountTriggerHandler 
{
	public static void beforeInsertHandler(List<csconta__Billing_Account__c> newBillAccounts)
    {
        setDefaultBillingAccount(newBillAccounts, null);
	/* New */
		setDefaultPaymentTerms(newBillAccounts);
    }
    
    public static void beforeUpdateHandler(List<csconta__Billing_Account__c> updatedBillAccounts,
                                            Map<Id, csconta__Billing_Account__c> oldMap)
    {
        setDefaultBillingAccount(updatedBillAccounts, oldMap);
        setCreatePaymentProfileFlag(updatedBillAccounts,oldMap);
    }

    public static void afterInsertHandler(List<csconta__Billing_Account__c> newBillAccounts)
    {
        List<Id> accIds = new List<Id>();
        for(csconta__Billing_Account__c ba : newBillAccounts) {
            accIds.add( ba.csconta__Account__c );
        }

        if(accIds.size() > 0) {
          // updateBillingContact(accIds);
        }
    }

      /* New: Default Payment Terms */
	private static void setDefaultPaymentTerms(List<csconta__Billing_Account__c> newBillAccounts){
		set<id> accIdList = new set<id>();

		for(csconta__Billing_Account__c ba : newBillAccounts)
			accIdList.add(ba.csconta__Account__c);

		map<id,account> newAccounts = new map<id,account>([select id,LG_PaymentType__c,LG_BankAccountNumberIBAN__c,LG_BankAccountHolder__c from account where id in :accIdList]);
		for(csconta__Billing_Account__c ba : newBillAccounts){
			account a = newAccounts.get(ba.csconta__Account__c);
			if((a.LG_PaymentType__c=='Direct Debit'
				&& !String.isBlank(a.LG_BankAccountNumberIBAN__c)
				&& !String.isBlank(a.LG_BankAccountHolder__c)) || (a.LG_PaymentType__c=='Self-payer')){
					ba.csconta__Payment_Terms__c = 'Monthly 1st - 30 days payment term';
			}
		}
	}

    /**
     * Future method to update billing with related (to account)
     * contact - Billing Contact field
     * @param accIds List of account Ids
     */
  /*  @future
    private static void updateBillingContact(List<Id> accIds) {

        if(accIds.size() > 0) {

            //system.debug('--+ accIds: '+accIds);

            List<csconta__Billing_Account__c> newBillingAccounts = [SELECT id, csconta__Account__c, Billing_Contact__c FROM csconta__Billing_Account__c WHERE csconta__Account__c IN:accIds];
            List<Contact> newContacts = [SELECT Id, AccountId FROM Contact WHERE AccountId IN: accIds ORDER BY CreatedDate LIMIT: accIds.size()];

            //system.debug('--+ Billing Accounts: '+newBillingAccounts);
            //system.debug('--+ Contacts: '+newContacts);            

            List<csconta__Billing_Account__c> toUpdate = new List<csconta__Billing_Account__c>();
            if(!newContacts.isEmpty()) {

                for(csconta__Billing_Account__c ba : newBillingAccounts) {

                    if(ba.Billing_Contact__c == NULL) {
                        for(Contact cnt : newContacts) {

                            if(cnt.AccountId == ba.csconta__Account__c) {

                                ba.Billing_Contact__c = cnt.Id;
                                toUpdate.add( ba );
                            }
                        }
                    }
                }

                update toUpdate;
            }
        }

    }    */
    
    /**
     * For all the new/updated Billing Accounts that have a LG_Default__c set to true,
     * related Billing Accounts that belong to the same Account, must have the LG_Default__c
     * set to false - as we only allow one default Billing Account per Account
     * 
     * @param  List<csconta__Billing_Account__c> billAccounts
     * @param  Map<Id, csconta__Billing_Account__c> oldMap
     * @author Tomislav Blazek
     * @ticket SFDT-59
     * @since  15/01/2016
     */
    private static void setDefaultBillingAccount(List<csconta__Billing_Account__c> billAccounts,
                                                    Map<Id, csconta__Billing_Account__c> oldMap)
    {
        //holds a set of Billing Accounts applicable for processing
        Set<csconta__Billing_Account__c> applicableBillingAccs = new Set<csconta__Billing_Account__c>();

        /*
        * Decide which accounts should be processed:
        * - only the accounts that are having a value change in the LG_Default__c, set to true
        */
        for (csconta__Billing_Account__c newBillAcc : billAccounts)
        {
            csconta__Billing_Account__c oldBillAcc = oldMap == null ? null : oldMap.get(newBillAcc.Id);

            boolean isDefault = newBillAcc.LG_Default__c //default flag set to true
                                            && (oldBillAcc == null //is insert
                                                || 
                                                //was updated to true
                                                oldBillAcc.LG_Default__c != newBillAcc.LG_Default__c);
            
            if (isDefault)
            {
                applicableBillingAccs.add(newBillAcc);
            }
        }
 
        //Billing_Contact__c
        if  (!applicableBillingAccs.isEmpty())
        {
            //Holds the AccountId to Default Billing Account map
            Map<Id, csconta__Billing_Account__c> accountToDefAccount = new Map<Id, csconta__Billing_Account__c>();
			//Holds the updated bill account ids
			Set<Id> updatedBillAccIds = new Set<Id>();
			
            for (csconta__Billing_Account__c billAcc : applicableBillingAccs)
            {
                accountToDefAccount.put(billAcc.csconta__Account__c, billAcc);
				if (billAcc.Id != null)
				{
					updatedBillAccIds.add(billAcc.Id);
				}
            }
            
            //Set Default flag to False for all currently default billing accounts that are not
            //in the trigger context, but relate to the Accounts of the applicable billing accounts
            //from the trigger
            List<csconta__Billing_Account__c> billAccsToUpdate = [SELECT LG_Default__c FROM csconta__Billing_Account__c 
                                                                    WHERE csconta__Account__c IN :accountToDefAccount.keySet() 
                                                                    AND Id NOT IN :updatedBillAccIds
                                                                    AND LG_Default__c = true];
                                                                    
            for(csconta__Billing_Account__c billAcc : billAccsToUpdate)
            {
                billAcc.LG_Default__c = false;
            }
            
            if (!billAccsToUpdate.isEmpty())
            {
                update billAccsToUpdate;
            }
			
            //Undefault all the billing accounts that relate to the same Account, but are in the trigger context.
            //So at the end we are left with only one Default billing account
            for (csconta__Billing_Account__c billAcc : applicableBillingAccs)
            {
                if (accountToDefAccount.get(billAcc.csconta__Account__c) != billAcc)
                {
                    billAcc.LG_Default__c = false;
                }
            }
        }
    }
    
    public static void setIsSyncOnBillAccountToFalse(list<csconta__Billing_Account__c> lstNewBA, map<Id,csconta__Billing_Account__c> mapOldBA){
    	for(csconta__Billing_Account__c BA:lstNewBA){
    		if(BA.UM_LastSyncedwithBilling__c!=null && mapOldBA.get(ba.Id).UM_LastSyncedwithBilling__c!=BA.UM_LastSyncedwithBilling__c){
    			BA.UM_IsAccountSynced__c=false;
    		}
    	}    	
    }
    
    //Method to remove white space from the IBAN no before insert or update.
    public static void removeWhiteSpaceFromIBAN(List<csconta__Billing_Account__c> lstBA){
    	for(csconta__Billing_Account__c BA:lstBA){
    		if(BA.LG_BankAccountNumberIBAN__c!=null){
    			BA.LG_BankAccountNumberIBAN__c=BA.LG_BankAccountNumberIBAN__c.replaceAll( '\\s+', '');
    		}
    	}
    }
    
    
    // Sets a flag to true on Billing Account which drives the creation of Payment Profile on Kenan Billing system
    // whe following criteria are met:
    // 		- Payment Type is changed e.g. Self-payer to Direct Debit 
    // 		- Bank Account Holder name is changed
    // 		- IBAN number is changed
    // 		- BIC is changed
    // 		- Payment Terms have changed
    // 		- Mandate Start Date or Mandate Reference number has changed.
 				
    private static void setCreatePaymentProfileFlag(list<csconta__Billing_Account__c> newBA, map<id,csconta__Billing_Account__c> oldBA){
        for(csconta__Billing_Account__c ba : newBA){
            if((ba.LG_PaymentType__c 			!= oldBA.get(ba.id).LG_PaymentType__c) 				||
               (ba.csconta__Payment_Terms__c	!= oldBa.get(ba.id).csconta__Payment_Terms__c) 		||               
               (ba.LG_BankAccountHolder__c 		!= oldBA.get(ba.id).LG_BankAccountHolder__c)		||
               (ba.LG_BankAccountNumberIBAN__c 	!= oldBA.get(ba.id).LG_BankAccountNumberIBAN__c)	||
               (ba.UM_BankAccountNumberBic__c 	!= oldBA.get(ba.id).UM_BankAccountNumberBic__c) 	||               
               (ba.LG_MandateStartDate__c		!= oldBa.get(ba.id).LG_MandateStartDate__c) 		||
               (ba.UM_MandateReferenceNumber__c != oldBa.get(ba.id).UM_MandateReferenceNumber__c)
              ) {
                ba.UM_Create_Payment_Profile_in_Billing__c=true; 	            
            }
        }
    }
}