/**
*
* Case trigger 
* 
* @author Petar Miletic
* @ticket SFOM-317
* @since 30/01/2017
*/
trigger LG_CaseTrigger on Case (before insert, before update, after insert, after update) {
    
    No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    
    if (notriggers == null || !notriggers.Flag__c)
    {
        
        if((trigger.isInsert || trigger.isUpdate) && trigger.isBefore){
            
            LG_CaseTriggerHandler.MapNewContacttoAccount(trigger.new);
            
           /*
            Map<Id,String> rt_map = new Map<Id,String>();
            for(RecordType rt : [SELECT Id, DeveloperName FROM RecordType]){
                rt_map.put(rt.Id,rt.DeveloperName);
            }
             List<Contact> updatecon = new List<Contact>();
            System.debug('##$rtmap : '+rt_map);
            for(Case c: trigger.new){
                system.debug('c.ContactId'+c.ContactId);
                system.debug('##$rt dev name : '+rt_map.get(c.recordTypeID));
                if(rt_map.get(c.recordTypeID) == 'LG_B2B_Care_Admin_Change_Request_UM' || 
                rt_map.get(c.recordTypeID) == 'B2B_Care_Billing_Query_Request_UM' ||
                rt_map.get(c.recordTypeID) == 'LG_B2B_Care_Complaint_Request_UM' ||
                rt_map.get(c.recordTypeID) == 'LG_B2B_Care_General_Query_Request_UM' ||
                rt_map.get(c.recordTypeID) == 'LG_B2B_Care_Online_Billing_Request_UM' ||
                rt_map.get(c.recordTypeID) == 'LG_B2B_Care_SLA_Breach_Request_UM' ||
                rt_map.get(c.recordTypeID) == 'LG_B2B_Care_Service_Change_Request_UM' ||
                rt_map.get(c.recordTypeID) == 'LG_B2B_Care_Technical_Request_UM'){
                                            
                    for (Contact con: [Select Id, Salutation,AccountId from Contact where id= :c.ContactId]){    
                        
                    if( c.ContactId != null && con.AccountId == null ){
                        System.debug('##$Contact is created');
                                                
                        con.AccountId = c.AccountId;
                        con.Salutation = 'Mr.';
                        updatecon.add(con);
                        
                        }
                        
                    }
                }
            }
            if(updatecon != null && !updatecon .isEmpty())       
                       Database.Update(updatecon); */
        }
        
                
        if (trigger.isInsert && trigger.IsAfter)
        {
            LG_CaseTriggerHandler.updateSolutionJeopardyReason(trigger.new);
        }
        
        if (trigger.isUpdate && trigger.IsAfter)
        {
            LG_CaseTriggerHandler.updateSolutionJeopardyReason(trigger.new, trigger.oldMap);
            
            //SFOM-2164
            LG_CaseTriggerHandler.updateServiceStatusOnCaseClosure(trigger.new, trigger.oldMap);
        }
        
        //SFOM-356
        if (trigger.isUpdate && trigger.IsBefore)
        {
            LG_CaseTriggerHandler.validateCaseStatus(trigger.new);
        }
        
        
        //SFOM-427
        /*if (trigger.isUpdate && trigger.IsBefore)
        {
            LG_CaseTriggerHandler.validateAppointment(trigger.new);
        }*/
        
        //Assisted Care code start
        /*if ((trigger.isUpdate || trigger.isInsert) && trigger.IsBefore){
            
            String recTypeId = [SELECT Id from RecordType where sObjectType='Case' and developerName = 'LG_B2B_CaMa_Ticket_Request_UM' limit 1].Id;
            if(trigger.new[0].RecordTypeId == recTypeId){
                
                if(trigger.new[0].B2B_Order_Remarks__c != null && trigger.new[0].B2B_Order_Remarks__c.length() > 0){
                    trigger.new[0].B2B_Order_Remarks__c = LG_Care_MultiLineUtilClass.parseString(trigger.new[0].B2B_Order_Remarks__c, 35);
                }
                if(trigger.new[0].B2B_Order_Comment__c != null && trigger.new[0].B2B_Order_Comment__c.length() > 0){
                    
                    trigger.new[0].B2B_Order_Comment__c = LG_Care_MultiLineUtilClass.parseString(trigger.new[0].B2B_Order_Comment__c, 58);
                }
            }
        }*/
        //Assisted Care code end
    }    
}