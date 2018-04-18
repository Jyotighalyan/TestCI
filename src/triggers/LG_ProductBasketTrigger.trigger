trigger LG_ProductBasketTrigger on cscfga__Product_Basket__c (after delete, after insert, after update, 
before delete, before insert, before update) 
{

    No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    
    if (notriggers == null || !notriggers.Flag__c)
    {
        
        if ((trigger.isInsert) && (trigger.IsBefore))
        {
            LG_ProductBasketTriggerHandler.BeforeInsertHandle(trigger.new);
        }
        
        if ((trigger.isInsert) && (trigger.IsAfter))
        {
        //added as part of code merging activity for UM and OMDEV 

        LG_ProductBasketTriggerHandler.updateOppPenaltyTotals(Trigger.new, Trigger.oldMap);

            LG_ProductBasketTriggerHandler.AfterInsertHandle(trigger.new);
            
            for (integer i=0;i<trigger.new.size();++i)
            {
                system.debug('*** after insert trigger.new[' + i + ']=' + trigger.new[i].Name);
            }
        }
        
        if ((trigger.isUpdate) && (trigger.IsAfter))
        {
        //added as part of code merging activity for UM and OMDEV 

            LG_ProductBasketTriggerHandler.updateOppPenaltyTotals(Trigger.new, Trigger.oldMap);
        if (!Test.isRunningTest())
            LG_ProductBasketTriggerHandler.AfterUpdateHandle(trigger.new, trigger.old);

            for (integer i=0;i<trigger.new.size();++i)
            {
                system.debug('*** after update trigger.new[' + i + ']=' + trigger.new[i].Name);
            }

        }
        
    }



}