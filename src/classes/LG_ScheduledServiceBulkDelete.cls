/**
* Remove Orders and Line Items for Soho and Mobile
* 
* @author Petar Miletic
* @ticket SFDT-581 - Remove Orders and Line Items for Soho and Mobile
* @since  30/03/2016
*/
global class LG_ScheduledServiceBulkDelete implements Database.Batchable<sObject>, Schedulable {

    // Constructor
    global LG_ScheduledServiceBulkDelete () {
        
    }

    // Schedulable interface method
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new LG_ScheduledServiceBulkDelete(), 200);
    }

    // Database.Batchable methods
    global Database.QueryLocator start(Database.BatchableContext batchableContext) {
        
        Set<string> deleteName = new Set<string> { 'Mobile' };
        Set<string> deleteStatus = new Set<string> { 'Service In Delivery' };
        Set<string> deleteSegment = new Set<string> { 'SoHo' };
        Set<string> toBeDeleted = new Set<string> { 'SoHo - To Be Deleted' };
        
        String query = 'SELECT Id, Name, csord__Subscription__c, csord__Order__c, LG_RootOrder__c, csord__Status__c, LG_MarketSegment__c FROM csord__Service__c WHERE (csord__Subscription__r.csord__Status__c IN :toBeDeleted) OR ((Name IN :deleteName AND LG_MarketSegment__c IN :deleteSegment) OR (Name IN :deleteName AND LG_MarketSegment__c NOT IN :deleteSegment AND csord__Status__c IN :deleteStatus))';
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext batchableContext, List<csord__Service__c> scope) {

        Set<Id> orderIds = new Set<Id>();
        Set<Id> subscriptionIds = new Set<Id>();
        
        for (csord__Service__c s :scope) {
            
            if (s.LG_RootOrder__c != null) {
                orderIds.add(s.LG_RootOrder__c);
            }
            
            if (s.csord__Subscription__c != null) {
                subscriptionIds.add(s.csord__Subscription__c);
            }
        }

        delete scope;
        
        // Data Cleanup
        DeleteEmptySubscriptions(subscriptionIds);
        DeleteEmptyOrders(orderIds);
    }

    global void finish(Database.BatchableContext batchableContext) {
        
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :batchableContext.getJobId()];

        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Service Bulk Delete, status: ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    /*
     * Delete empty Subscriptions, that is Subscriptions with zero children
    */
    private void DeleteEmptySubscriptions(Set<Id> subscriptionIds) {
        
        Set<Id> currentSubscriptionIds = new Set<Id>();
        for (csord__Service__c s : [SELECT Id, csord__Subscription__c FROM csord__Service__c WHERE csord__Subscription__c IN :subscriptionIds]){
            currentSubscriptionIds.add(s.csord__Subscription__c);
        }

        // Remove Ids that are in use, Subscriptions that still have children
        subscriptionIds.removeAll(currentSubscriptionIds);

        if (subscriptionIds.size() > 0) {
            
            List<csord__Subscription__c> subscriptions = [SELECT Id, Name FROM csord__Subscription__c WHERE Id IN :subscriptionIds];
            
            delete subscriptions;
        }
    }
    
    /*
     * Delete empty Orders, that is Orders with zero children
    */
    private void DeleteEmptyOrders(Set<Id> orderIds) {
        
        Set<Id> currentOrderIds = new Set<Id>();
        for (csord__Subscription__c s : [SELECT Id, csord__Order__c FROM csord__Subscription__c WHERE csord__Order__c IN :orderIds]){
            currentOrderIds.add(s.csord__Order__c);
        }

        // Remove Ids that are in use, Orders that still have children
        orderIds.removeAll(currentOrderIds);

        // Check if ordre is used in Services
        currentOrderIds.clear();
        for (csord__Service__c se : [SELECT Id, csord__Order__c, LG_RootOrder__c FROM csord__Service__c WHERE LG_RootOrder__c IN :orderIds]){
            currentOrderIds.add(se.LG_RootOrder__c);
        }

        // Remove the ones that are still in use
        orderIds.removeAll(currentOrderIds);

        // Delete the rest
        if (orderIds.size() > 0) {
            
            List<csord__Order__c> orders = [SELECT Id, Name FROM csord__Order__c WHERE Id IN :orderIds];
            
            delete orders;
        }
    }
}