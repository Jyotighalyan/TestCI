/******** Scheduler class for sending Appointment Reminder****
***** Author:Preetha N **********
*********SFOM-2578***********
* 
*****************************************************************/
global class LG_AppointmentAlertScheduler implements Schedulable {

//Sending an Email prior to five days from Appointment date to the contact
global void execute(SchedulableContext SC){
try{
    List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();
    boolean flag=false;
    List<LG_ScheduleAppointment__c> appointmentsList = [SELECt id,LG_Solution__r.LG_Address__r.LG_TechnicalContact__r.Email,LG_Solution__r.LG_Address__r.LG_TechnicalContact__r.LG_PreferredCommunication__c,Owner.Email,LG_AgreedInstallDate__c,LG_DateofFirstEmailNotification__c,LG_DateofSecondEmailNotification__c,LG_Solution__c,LG_Solution__r.OwnerId,LG_Address__r.Name,LG_Solution__r.Name 
    FROM LG_ScheduleAppointment__c 
    WHERE LG_DateofFirstEmailNotification__c=TODAY];
    
    for(LG_ScheduleAppointment__c Appointment:appointmentsList){
        if(Appointment.LG_Solution__r.LG_Address__r.LG_TechnicalContact__r.LG_PreferredCommunication__c=='Email'){
            Map<Id, List<csord__Service__c>> serviceMap = getServiceMap(appointmentsList);
            List<csord__Service__c> serviceDetail = new List<csord__Service__c>();
            map<String,Appointment_Reminder__c> appRemMap = Appointment_Reminder__c.getall();
            String templateId = '';
            if(!appointmentsList.isEmpty())
                {
                    OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where DisplayName = 'Unitymedia Business' limit 1];
                    if(serviceMap.containsKey(Appointment.LG_Solution__c)){
                        serviceDetail = serviceMap.get(Appointment.LG_Solution__c);
                    }
                    for(csord__Service__c Eachservice:serviceDetail){
                        if((Eachservice.name.containsIgnoreCase('BGP') ||Eachservice.name.containsIgnoreCase('Access')||Eachservice.name.containsIgnoreCase('Company Cloud Fiber')&& Eachservice.csord__Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c.containsIgnoreCase('New'))){
                            templateId = appRemMap.get('LG_AppointmentReminder_NS').EmailTemplateId__c;
                        }
                        if(Eachservice.name.containsIgnoreCase('Company Fiber') && Eachservice.csord__Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c.containsIgnoreCase('New')){
                            templateId = appRemMap.get('LG_AppointmentReminder_NF').EmailTemplateId__c;
                        }
                        if(Appointment.LG_Solution__r.LG_Address__r.LG_TechnicalContact__r.LG_PreferredCommunication__c != null && !String.isempty(templateId))
                        {
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setTargetObjectId(Appointment.LG_Solution__r.LG_Address__r.LG_TechnicalContact__c);
                            mail.setTreatTargetObjectAsRecipient(false);
                            mail.setWhatId(Appointment.Id);
                            mail.setTemplateId(templateId);
                            mail.setToAddresses(new String[]{Appointment.LG_Solution__r.LG_Address__r.LG_TechnicalContact__r.Email});
                            mail.setBccAddresses(new String[]{Appointment.Owner.Email});
                            mail.setOrgWideEmailAddressId(owa.id);
                            mail.saveAsActivity = false;
                            mailsToSend.add(mail);
                        }
                }
            }
        }
    }
    if(mailsToSend.size() > 0)
    {
    Messaging.sendEmail(mailsToSend);       
    }
}
catch(Exception e)
{
    List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    User adminUser = [SELECT id, email FROM USer WHERE Profile.name='System Administrator' LIMIT 1];
    mail.setTargetObjectId(adminUser.Id);
    mail.setSubject('Exception encountered in class LG_AppointmentAlert_Scheduler');
    mail.setHtmlBody('Hi, There is an exception occured in class. Please refer debug logs');
    mail.saveAsActivity = false;
    mailsToSend.add(mail);
    if(mailsToSend.size() > 0)
    {
        Messaging.sendEmail(mailsToSend);       
    }
}
}

//Getting List Of services for the scheduled appointment
public Map<Id, List<csord__Service__c>> getServiceMap(List<LG_ScheduleAppointment__c> appointmentList){
    List<id> solutionList = new List<id>();
    map<Id, List<csord__Service__c>> serviceMap = new  map<Id, List<csord__Service__c>>();
    for(LG_ScheduleAppointment__c appointmentDetail:appointmentList){
        solutionList.add(appointmentDetail.LG_Solution__c);
        }
        if(solutionList.size() > 0 ){
            List<csord__Service__c> serviceList =[select name,csord__Order__r.csordtelcoa__Opportunity__r.name,LG_Suborder__c,csord__Order__c,csord__Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c from csord__Service__c where LG_Suborder__c in :solutionList];
            for(csord__Service__c serviceDetail:serviceList){
                if(serviceMap.containsKey(serviceDetail.LG_Suborder__c)){
                    serviceMap.get(serviceDetail.LG_Suborder__c).add(serviceDetail);
                }else{
                    serviceMap.put(serviceDetail.LG_Suborder__c, new List<csord__Service__c>{serviceDetail});
                }
            }
    }
    return serviceMap;
    }
}