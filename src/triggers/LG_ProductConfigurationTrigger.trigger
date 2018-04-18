trigger LG_ProductConfigurationTrigger on cscfga__Product_Configuration__c (after delete, after insert, after update, 
before delete, before insert, before update) 
{
    No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    
    if (notriggers == null || !notriggers.Flag__c)
    {
        if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
        {
            LG_ProductConfigurationTriggerHandler.setStatusToValidForChange(Trigger.new);
            LG_ProductConfigurationTriggerHandler.setStatusForChildToValid(Trigger.new);
                        LG_ProductConfigurationTriggerHandler.setStatusForPhoneDienste(Trigger.new);
        }
        
        if (Trigger.isBefore && Trigger.isInsert) {
            LG_ProductConfigurationTriggerHandler.BeforeInsertHandle(Trigger.new);
        }
        
        if ((trigger.isInsert) && (trigger.IsAfter))
        {
            LG_ProductConfigurationTriggerHandler.AfterInsertHandle(trigger.new);
            
            for (integer i=0;i<trigger.new.size();++i)
            {
                system.debug('*** PC after insert trigger.new[' + i + ']=' + trigger.new[i].Name);
            }
            
            // Phone Numbers product definition not used on UM (TBanic 2017-01-31, to resolve too many soqls during the D2D basket upload)
            //LG_ProductConfigurationTriggerHandler.updatePubliclyListedNumbers(Trigger.new);
        }
        
        if ((trigger.isUpdate) && (trigger.IsAfter))
        {
            LG_ProductConfigurationTriggerHandler.AfterUpdateHandle(trigger.new, trigger.oldMap);
            LG_ProductConfigurationTriggerHandler.afterUpdateVpnProds(trigger.newMap, trigger.oldMap);

            for (integer i=0;i<trigger.new.size();++i)
            {
                system.debug('*** PC after update trigger.new[' + i + ']=' + trigger.new[i].Name);
            }
            // Phone Numbers product definition not used on UM (2017-01-31, to resolve too many soqls during the D2D basket upload)
            //LG_ProductConfigurationTriggerHandler.updatePubliclyListedNumbers(Trigger.new);
            //UMR-284 
            LG_ProductConfigurationTriggerHandler.updateSubscriptionBillingAccount(trigger.new, trigger.oldMap);
        }
        
        if ((trigger.isDelete) && (trigger.IsAfter)) {
            
            LG_ProductConfigurationTriggerHandler.AfterDeleteHandle(trigger.old);
        }
        
        if ((trigger.isDelete) && (trigger.IsBefore)) {
            LG_ProductConfigurationTriggerHandler.deleteNumberAssets(Trigger.old);
            LG_ProductConfigurationTriggerHandler.BeforeDeleteHandle(trigger.old);
        }
        
    }
}