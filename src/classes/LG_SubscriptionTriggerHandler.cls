public class LG_SubscriptionTriggerHandler {

	/**
	 * If MACD Move scenario, Subscription,Service and Service 
	 * Line Item will have new number instead old one
	 * 
	 * @param  List<csord__Subscription__c> services
	 * @author Petar Miletic
	 * @ticket SFDT-447
	 * @since  15/03/2016
    */
    public static void updateSubscriptionNumber(List<csord__Subscription__c> subscriptions) {
        
        Set<Id> subscriptionIds = new Set<Id>();
        List<csord__Subscription__c> subscriptionsUpdate = new List<csord__Subscription__c>();
        
        // Applicable for following change types
        Set<string> changeTypes = new Set<string> { 'Move', 'Migrate' };
        
        for (csord__Subscription__c c :subscriptions) {
            subscriptionIds.add(c.Id);
        }
        
        csordtelcoa__Orders_Subscriptions_Options__c osOptions = csordtelcoa__Orders_Subscriptions_Options__c.getOrgDefaults();
        
        List<csord__Subscription__c> subs = [SELECT Id, Name, csordtelcoa__Change_Type__c, csordtelcoa__Subscription_Number__c, csordtelcoa__Subscription_Number_Sequence__c FROM csord__Subscription__c WHERE Id IN :subscriptionIds];
        
        for (csord__Subscription__c s :subs) {
            
            if (changeTypes.contains(s.csordtelcoa__Change_Type__c) && s.csordtelcoa__Subscription_Number_Sequence__c != null) {
                
                s.csordtelcoa__Subscription_Number__c = osOptions.csordtelcoa__Subscription_Number_Prefix__c + s.csordtelcoa__Subscription_Number_Sequence__c;
                subscriptionsUpdate.add(s);
            }
        }

        if (subscriptionsUpdate.size() > 0) {
            update subscriptionsUpdate;
        }
    }
}