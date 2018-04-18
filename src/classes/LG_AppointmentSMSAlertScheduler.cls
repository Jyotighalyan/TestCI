/******** Scheduler class for sending SMS appointment Reminder****
 ***** Author: Neha Arora **********
*********SFOM - 211***********
*****************************************************************/
global class LG_AppointmentSMSAlertScheduler implements Schedulable{
	global void execute(SchedulableContext SC){
    	Set<Id> solIdSet = new Set<id>();
        try{
            List<LG_ScheduleAppointment__c> appointmentsList = [SELECt id,LG_AgreedInstallDate__c,LG_DateofFirstSMSNotification__c,LG_InstallationContact__c,
                                                                LG_InstallationContact__r.Name,LG_Solution__c,LG_Solution__r.OwnerId,LG_Address__r.Name,LG_Solution__r.Name 
                                                                FROM LG_ScheduleAppointment__c 
                                                                WHERE LG_DateofFirstSMSNotification__c=TODAY]; 
            if(!appointmentsList.isEmpty())
            {
                for(LG_ScheduleAppointment__c sch:appointmentsList)
                {
                    solIdSet.add(sch.LG_Solution__c);   
                }
            }
            if(!appointmentsList.isEmpty())
            {
                map<String,Appointment_Reminder__c> appRemMap = Appointment_Reminder__c.getall();
                String templateId = appRemMap.get('LG_AppointmentReminder').SMSTemplateId__c;
                EmailTemplate template = [SELECT id,Body,Subject FROM EmailTemplate WHERE id=:templateId];
                String tempBody='';
                if(template!=null)
                {
                     tempBody = template.body;
                }
                for(LG_ScheduleAppointment__c sch:appointmentsList)
                {
                    String messageContent = LG_SMSTemplateUtil.renderTemplate(sch.Id,tempBody);
                    system.debug('mesage#'+messageContent);
                    //to do - Invoke LG_SMSGateway class
                    /*LG_SMSGateway gateway = LG_SMSGateway.getInstance();
                    gateway.send(messageContent);*/
                }
            }
        }
        catch(Exception e)
        {
            system.debug('Exception occured'+e);
        }
    }
}