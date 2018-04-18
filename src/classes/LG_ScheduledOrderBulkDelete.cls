/**
* Remove Orders and Line Items for Soho and Mobile
* 
* @author Petar Miletic
* @ticket SFDT-581 - Remove Orders and Line Items for Soho and Mobile
* @since  30/03/2016
*/
global class LG_ScheduledOrderBulkDelete implements Database.Batchable<sObject>, Schedulable {

    // Constructor
    global LG_ScheduledOrderBulkDelete () {
        
    }

    // Schedulable interface method
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new LG_ScheduledOrderBulkDelete());
    }

    // Database.Batchable methods
    global Database.QueryLocator start(Database.BatchableContext batchableContext) {
        
        Set<string> markForDelete = new Set<string> { 'SoHo' };
        String query = 'SELECT Id, LG_MarketSegment__c, Name FROM csord__Order__c WHERE LG_MarketSegment__c IN :markForDelete';
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext batchableContext, List<csord__Order__c> scope) {
        
        // There is no need for this because there is Master Detail connection between Order and OLI's
        
        /*Set<Id> oliIds = new Set<Id>();
        for (Order o :scope) {
            oliIds.add(o.csord__Order__c)
        }
        
        List<csord__Order_Line_Item__c> olis = [SELECT Id FROM csord__Order_Line_Item__c WHERE csord__Order__c IN :oliIds];
        delete olis;*/

        delete scope;
    }

    global void finish(Database.BatchableContext batchableContext) {
     
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :batchableContext.getJobId()];

        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Order Bulk Delete, status: ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
}