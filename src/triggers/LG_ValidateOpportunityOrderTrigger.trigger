/*
This trigger validates if the required related information
are populated before sending the Opportunity to OPT.

One synchronized Product Basket is required.
The required fields for the related Account:
    Segment
The required fields for all related Contacts:
    Mobile or Phone Number
The required fields for related Technical Contacts:
    Email, Salutation, FirstName, LastName
The required fields for related Administrative Contacts:
    Email, Salutation, FirstName, LastName, Birthdate
*/
trigger LG_ValidateOpportunityOrderTrigger on Opportunity (before update) {
    
    No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    
    if (notriggers == null || !notriggers.Flag__c)
    {
        if ((trigger.isUpdate) && (trigger.IsBefore))
        {
            // same code used in LG_OpportunityTrigger, should be checked
            LG_ValidateOppOrderTriggerHandler.BeforeUpdateHandle(trigger.newMap, trigger.oldMap);
        }
    }
}