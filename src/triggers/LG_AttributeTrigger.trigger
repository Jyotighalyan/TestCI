trigger LG_AttributeTrigger on cscfga__Attribute__c (after delete, after insert, after update,
before delete, before insert, before update)
{

    No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());

    if (notriggers == null || !notriggers.Flag__c)
    {
        if ((trigger.isInsert) && (trigger.IsAfter))
        {
            LG_AttributeTriggerHandler.AfterInsertHandle(trigger.new);

            for (integer i=0;i<trigger.new.size();++i)
            {
                system.debug('*** after insert trigger.new[' + i + ']=' + trigger.new[i].Name);
            }
        }

        if ((trigger.isUpdate) && (trigger.IsAfter))
        {
            LG_AttributeTriggerHandler.AfterUpdateHandle(trigger.new, trigger.oldMap);

            LG_AttributeTriggerHandler.AfterVPNSITEUpdateHandler(Trigger.newMap, Trigger.oldMap);
            for (integer i=0;i<trigger.new.size();++i)
            {
                system.debug('*** after update trigger.new[' + i + ']=' + trigger.new[i].Name);
            }

        }

		 //added as part of omdev migration
		if (trigger.isInsert && trigger.isBefore) {
            LG_AttributeTriggerHandler.updateConfigId(Trigger.new);
            LG_AttributeTriggerHandler.updateConnectionAttribute(Trigger.new);
        }

        if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
            LG_AttributeTriggerHandler.createNumberAssets(Trigger.new, Trigger.oldMap);
        }
    }

}