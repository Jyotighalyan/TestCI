trigger LG_LeadUpdateTrigger on Lead (before insert, before update) {
    //Lead newLeadData = Trigger.new[0]; // commented this line and added the for loop to bulkify the trigger
    for(Lead newLeadData: Trigger.new){
        if(Trigger.isInsert){
            newLeadData.LG_Last_Lead_Status_Change_Date__c = Date.today();
            newLeadData.Assigned_Date__c = Date.today();   // added as a part of CATGOV-490 
        } 
        else{
            //Lead oldLeadData = Trigger.old[0];
            //if((oldLeadData.Status != newLeadData.Status) && (oldLeadData.LG_Last_Lead_Status_Change_Date__c != Date.today())) {
            if((trigger.oldMap.get(newLeadData.ID).Status != newLeadData.Status)&&(trigger.oldMap.get(newLeadData.ID).LG_Last_Lead_Status_Change_Date__c != Date.today())){
                newLeadData.LG_Last_Lead_Status_Change_Date__c = Date.today();
            }
            // added as a part of CATGOV-490 
            if(trigger.oldMap.get(newLeadData.ID).OwnerId != newLeadData.OwnerId){
                newLeadData.Assigned_Date__c = Date.today();
            }
            // End
        }
    }
    
    /*********************      Start: CATGOV-490       *******************************/
    
    LG_LeadUpdateTriggerHandler handler = new LG_LeadUpdateTriggerHandler();
    handler.createLeadAssignmentMap(Trigger.new);
    handler.automaticLeadAssign(Trigger.new);
    
    /*********************      End: CATGOV-490         ******************************/
    
    //Deb-- 14 Mar, serviceability check
    if(Trigger.isUpdate && Trigger.isBefore){
        system.debug('calling lead handler');
        handler.validateLeadChanges(Trigger.oldMap,Trigger.newMap);
    }
    //end
    
}