trigger UM_ContactTrigger on Contact (after insert, after update, before insert, before update) {
    
    // Assisted Care Code Start
    LG_Care_ContactTriggerHandler careObj = new LG_Care_ContactTriggerHandler();
    if(trigger.isBefore) {
        if(trigger.isUpdate) {
            careObj.generateActivationCode(trigger.new);
        }
    }
    
    // Assisted Care Code End
    
    
    if(trigger.isAfter){
        if(trigger.isUpdate){
            UM_ContactTriggerHandler.executeAfterUpdate(trigger.New, trigger.oldMap);
            
            // Assisted Care Code Start
            careObj.sendMail_to_Contact(trigger.new, trigger.oldMap);
            // Assisted Care Code End
        }
    }
    
}