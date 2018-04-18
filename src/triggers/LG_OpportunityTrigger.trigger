trigger LG_OpportunityTrigger on Opportunity (before insert, before update, after insert, after update)
{
    No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    
    if (notriggers == null || !notriggers.Flag__c)
    {
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
        /*Comenting following code for INC INC000001518457 */
       /* if ((trigger.isUpdate) && (trigger.IsBefore))
        {
            LG_ValidateOppOrderTriggerHandler.BeforeUpdateHandle(trigger.newMap, trigger.oldMap);
            
            LG_OpportunityTriggerHandler.findAddressNotValidated(trigger.New, trigger.OldMap);
            LG_OpportunityTriggerHandler.replaceWFFieldUpdates(trigger.New, trigger.OldMap);
        }*/        /*Comented for INC INC000001518457 */ 
      
        if(trigger.isBefore && trigger.isInsert)
        {
            LG_OpportunityTriggerHandler.replaceWFFieldUpdates(trigger.New, null);
        }
        
        //added by Trupti
        if(trigger.isAfter && trigger.isInsert)
        {
         if (!Test.isRunningTest())
            LG_OpportunityTriggerHandler.upload(trigger.New);
        }
        //End
        
        //TriggerOpportunityHandler.handle(Trigger.new, Trigger.old); Theo ten Klooster 25-2-2016 removed trigger
        // Opportunity contact role
        /*if(trigger.isupdate && trigger.isAfter)
        {
           LG_OpportunityTriggerHandler.checkPartnerSalesId(trigger.New, trigger.OldMap);
        }*/
        if(trigger.isupdate && trigger.isbefore)
        {
            TriggerOpportunityContactRole.primaryContactUpdate(trigger.new);
            //LG_OpportunityTriggerHandler.checkPartnerSalesId(trigger.New, trigger.OldMap);
            //SFOM-1843 - Removing the Cancel order validation
            //LG_OpportunityTriggerHandler.restrictCancelOMOrders(trigger.NewMap, trigger.OldMap);
            
            //Deb-- 14 Mar, serviceability check
            TriggerOpportunityContactRole.validateOpportunityChanges(Trigger.oldMap,Trigger.newMap);
    
        }
        if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
        {
            LG_OpportunityTriggerHandler.deactivateSubscriptionServices(Trigger.new, Trigger.oldMap);
            LG_OpportunityTriggerHandler.deactivateSubscriptionServicesForTermination(Trigger.new, Trigger.oldMap);
        }
        //added as part of UMR-174 
        if(Trigger.isAfter && Trigger.isUpdate)
        {
          LG_OpportunityTriggerHandler.cancelReservationNumber(Trigger.new, Trigger.oldMap);
		  LG_OpportunityTriggerHandler.completeCancellationProcess(Trigger.new, Trigger.oldMap);//SFOM-2035
        }
    }
}