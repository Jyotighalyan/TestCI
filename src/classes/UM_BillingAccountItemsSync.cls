public with sharing class UM_BillingAccountItemsSync implements UM_KenanSyncBatch.IServiceConnect {

	public void execute(list<sObject> itemsList){
		list<UM_BillingAccountItem__c> billingAccItems = (list<UM_BillingAccountItem__c>)itemsList;
		KenanConnectorService service = new KenanConnectorService();

		for(UM_BillingAccountItem__c item : billingAccItems){
			KenanAccountItem accItem = UM_KenanAccountSyncCtrl.createKenanAccountItemForCreate(item);
            try{
			list<KenanAccountItem> retAccItems = service.accountItemCreate(accItem);
                    System.debug('*** retAccItems='+retAccItems);
			if(retAccItems!=null && !retAccItems.isEmpty())
                    {
                        item.UM_External_Id__c = retAccItems[0].instanceId;
                        item.UM_Last_Synced_with_Billing__c = System.now();
                        item.UM_Kenan_Sync_Message__c = 'Kenan Synced successfully. Kenan Id:'+retAccItems[0].instanceId;
                    }
                }catch(exception e){
                    System.debug('*** Error ='+e.getMessage());
                    item.UM_Last_Synced_with_Billing__c = System.now();
                    item.UM_Kenan_Sync_Message__c = 'Kenan Sync Failed:'+e.getMessage();
                }

        }
		update billingAccItems;
	}
}