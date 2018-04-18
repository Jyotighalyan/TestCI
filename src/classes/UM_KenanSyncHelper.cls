public with sharing class UM_KenanSyncHelper {
    
    /**
	  * Method that is used to prepare the data for the MPI Webservice via Spider
	  * @future (callout=true) is used because this method is called from a trigger
	  *
	  * @param accountId		Saleforce ID of the Account/Billing Account Record to be created/updated in Kenan
	  * @param isBillingAccount	Boolean, true if the Account is a Billing Account.
	  */
    
    @future (callout=true)
    public static void syncKenanAccount(String accountId, Boolean isBillingAccount){
        UM_KenanAccountSyncCtrl kenanController = new UM_KenanAccountSyncCtrl(accountId,isBillingAccount);
        kenanController.syncKenanAccount();
    }
    
    
    /**
	  * Method that is used to prepare the data for the MPI Webservice via Spider
	  * @future (callout=true) is used because this method is called from a trigger
	  *
	  * @param subscriptionId		Saleforce ID of the Subscription Record linked with Service to be created in Kenan
	  */
    public static void syncKenanService(String accountId,String subId){
        UM_KenanAccountSyncCtrl kenanController = new UM_KenanAccountSyncCtrl(accountId,true);
        kenanController.syncKenanAccount();        
        UM_KenanSubscriptionSyncCtrl.createService(subId);
        
    }

}