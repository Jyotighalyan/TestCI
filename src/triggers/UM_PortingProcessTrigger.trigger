trigger UM_PortingProcessTrigger on UM_PortingProcess__c (after delete, after insert, after update, before delete, before insert, before update) {
 	No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
 	
 	if (notriggers == null || !notriggers.Flag__c)
    {
 		if(trigger.isAfter){
 			if(trigger.isInsert){
 				UM_PortingProcessTriggerHandler.updatePortingProcessCountOnService(trigger.new,null,false);
 			}
 			if(trigger.isUpdate){
 				UM_PortingProcessTriggerHandler.updatePortingProcessCountOnService(trigger.new,trigger.oldMap,false);
                UM_PortingProcessTriggerHandler.createKenanIDs(trigger.new,trigger.oldmap);
 			}
 			if(trigger.isDelete){
 				UM_PortingProcessTriggerHandler.updatePortingProcessCountOnService(trigger.old,null,true);
 			}
 		}   	
    }   
}