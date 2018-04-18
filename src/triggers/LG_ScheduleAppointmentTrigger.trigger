/******** Trigger for object Schedule Appointment****
 ***** Author: Neha Arora **********
*********SFOM - 122***********
*****************************************************************/
trigger LG_ScheduleAppointmentTrigger on LG_ScheduleAppointment__c (before insert, before update, after insert, after update) {
    if((trigger.isInsert || trigger.isUpdate) && trigger.isBefore)
    {
        LG_ScheduleAppointmentTriggerHandler handler = new LG_ScheduleAppointmentTriggerHandler();
        handler.calculateEmailNotificationDates(trigger.newMap,trigger.oldMap,trigger.new, trigger.isUpdate);
    }
    if(trigger.isUpdate  && trigger.isBefore)
    {
        LG_ScheduleAppointmentTriggerHandler handler = new LG_ScheduleAppointmentTriggerHandler();
       // handler.updateReminderDatesOnStatusChange(trigger.newMap,trigger.oldMap);
    }
    if((trigger.isUpdate || trigger.isInsert)  && trigger.isAfter)
    {
        LG_ScheduleAppointmentTriggerHandler handler = new LG_ScheduleAppointmentTriggerHandler();
        //handler.updateCaseStatus(trigger.newMap,trigger.oldMap, trigger.isUpdate);
    }
}