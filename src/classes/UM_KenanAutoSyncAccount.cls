/*******************************************************************************************************************************************
* File Name     :  UM_KenanAutoSyncAccount
* Description   :  For Auto sync of Account and Billing Accounts with Kenan System.

* @author       :  Shubham Mittal    
* Modification Log
===================================================================================================
* Ver.    Date          Author              Modification
---------------------------------------------------------------------------------------------------
  -        -               -                    -
********************************************************************************************************************************************/

// Condtion for contact Change need to be added for which billing account send to kenan !!
public class UM_KenanAutoSyncAccount {
   @InvocableMethod(label='AccountAutoSyncToKenan' )
   public static void UM_KenanAutoSyncAccount (List<Id> accountIds)
   {
       Long currentDateTime = DateTime.now().getTime();
       List<Account> accountList=[SELECT id,name,UM_LastSyncedwithBilling__c,
                                             (SELECT id,csord__Account__c 
                                                   FROM csord__Subscriptions__r WHERE csord__Status__c='Active'),
                                             (SELECT id,Name,UM_LastSyncedwithBilling__c
                                                   FROM csconta__Billing_Accounts__r WHERE UM_IsAccountSynced__c=True AND UM_LastSyncedwithBilling__c!=null) 
                                   FROM Account 
                                   WHERE Id 
                                   IN : accountIds AND UM_LastSyncedwithBilling__c!=null];
       if(accountList!=null && !accountList.isEmpty())
       {
           for(Account act : accountList)
           {                 
               if(act.csord__Subscriptions__r!=null && !act.csord__Subscriptions__r.isEmpty())
               {
                   Long lastSyncedDateTime = act.UM_LastSyncedwithBilling__c.getTime();
                   Long milliseconds = currentDateTime - lastSyncedDateTime;
                   Long seconds = milliseconds / 1000;
                   system.debug('seconds--->'+seconds);
                   if(seconds > 5)
                       System.enqueueJob(new UM_QueueAutoSyncAccount (act.id,False));                 
               }
           }
       }
       else
       {
           List<csconta__Billing_Account__c> billAccount=[SELECT id,UM_LastSyncedwithBilling__c 
                                                               FROM csconta__Billing_Account__c 
                                                               WHERE id 
                                                               IN:accountIds AND UM_LastSyncedwithBilling__c!=null];
           for(csconta__Billing_Account__c billAcnt : billAccount)
           {
               Long lastSyncedDateTime = billAcnt.UM_LastSyncedwithBilling__c.getTime();
               Long milliseconds = currentDateTime - lastSyncedDateTime;
               Long seconds = milliseconds / 1000;
               system.debug('seconds--->'+seconds);
               if(seconds > 5)
                   System.enqueueJob(new UM_QueueAutoSyncAccount (billAcnt.id,true));
           }
        }
   }
   
   private class UM_QueueAutoSyncAccount implements System.Queueable,Database.AllowsCallouts{
       private  Id accountId;
       private  Boolean isBillingAccount;
       public  UM_QueueAutoSyncAccount(Id accountId,boolean isBillingAccount)
       {
           this.accountId=accountId;
           this.isBillingAccount=isBillingAccount;
       }
       public void execute(System.QueueableContext context)
       {            
                System.debug('***called');
                UM_KenanAccountSyncCtrl obj=new UM_KenanAccountSyncCtrl (accountId,isBillingAccount);
                obj.intiateAutoSync();
       }
    }  
    
}