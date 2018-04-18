trigger LG_TaskMatchRelatedRecordTrigger on Task (before insert, before update) {
    // Initialize list of relevant Tasks and related External IDs.
    List<Task> relevantTasks = new List<Task>();
    List<String> relatedExternalIDs = new List<String>();
    for (Task t : Trigger.new) {
        if (t.LG_RelatedExternalID__c != null) {
            relevantTasks.add(t);
            relatedExternalIDs.add(t.LG_RelatedExternalID__c);
        }
    }
    // Load Accounts by External IDs.
    List<Account> accounts = [select a.Id, a.LG_ExternalID__c from Account a where a.LG_ExternalID__c in :relatedExternalIDs];
    // Load Leads by External IDs.
    List<Lead> leads = [select l.Id, l.LG_ExternalID__c from Lead l where l.LG_ExternalID__c in :relatedExternalIDs];
    // Populate mappings of External IDs to SFDC IDs.
    Map<String, Id> accountMap = new Map<String, Id>();
    Map<String, Id> leadMap = new Map<String, Id>();
    for (Account a : accounts) {
        accountMap.put(a.LG_ExternalID__c, a.Id);
    }
    for (Lead l : leads) {
        leadMap.put(l.LG_ExternalID__c, l.Id);
    }
    // Set the WhatId/WhoId field on the Task according to the LG_RelatedExternalID__c field.
    // Set error if no related record were found.
    for (Task t : relevantTasks) {
        if (accountMap.containsKey(t.LG_RelatedExternalID__c)) {
            t.WhatId = accountMap.get(t.LG_RelatedExternalID__c);
            t.WhoId = null;
        } else if (leadMap.containsKey(t.LG_RelatedExternalID__c)) {
            t.WhoId = leadMap.get(t.LG_RelatedExternalID__c);
            t.WhatId = null;
        } else {
            t.LG_RelatedExternalID__c.addError(Label.LG_NoMatchingLeadAccount);
        }
    }
}