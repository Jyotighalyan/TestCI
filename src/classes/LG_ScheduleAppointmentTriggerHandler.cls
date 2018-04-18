/******** Trigger Handler class for object Schedule Appointment****
***** Preetha N **********
*********SFOM-2578***********
*****************************************************************/

public class LG_ScheduleAppointmentTriggerHandler {
    
public LG_ScheduleAppointmentTriggerHandler(){}

//method to calculate Reminder dates 
public void calculateEmailNotificationDates(map<Id,LG_ScheduleAppointment__c> mapScheduleAppNew,Map<Id,LG_ScheduleAppointment__c> mapScheduleAppOld,List<LG_ScheduleAppointment__c> appList, boolean isUpdate)
{
    Decimal firstEmail,secondEmail,firstSMS;
    map<String,Appointment_Reminder__c> appRemMap = Appointment_Reminder__c.getall();
    Map<Id, csord__Service__c> serviceMap = getServiceMap(appList);
    csord__Service__c serviceDetail = new csord__Service__c();
    BusinessHours bh = [SELECT Id FROM BusinessHours WHERE Name = 'LG_BusinessHour'];
    if(appRemMap.Size()>0)
    {
        for(LG_ScheduleAppointment__c objLG_ScheduleAppointment : appList)
        {
            //OMB-2578
            if(serviceMap.containsKey(objLG_ScheduleAppointment.LG_Solution__c)){
                serviceDetail = serviceMap.get(objLG_ScheduleAppointment.LG_Solution__c);
            }
            
            if(serviceDetail.name.containsIgnoreCase('Company Fiber')){
                firstEmail = appRemMap.get('LG_AppointmentReminder_NF').Days_Before_First_Email_Notification__c;
            }
            else if(serviceDetail.name.containsIgnoreCase('BGP')||serviceDetail.name.containsIgnoreCase('Access')||serviceDetail.name.containsIgnoreCase('Company Cloud Fiber')){
                firstEmail = appRemMap.get('LG_AppointmentReminder_NS').Days_Before_First_Email_Notification__c;
            }
            else{
                firstEmail = appRemMap.get('LG_AppointmentReminder').Days_Before_First_Email_Notification__c;
            }
            
            
            IF(objLG_ScheduleAppointment.LG_AgreedInstallDate__c<>Null && objLG_ScheduleAppointment.LG_AgreedInstallDate__c >= System.Today() && objLG_ScheduleAppointment.LG_Status__c !='Cancelled'
            && ((isUpdate && mapScheduleAppNew.get(objLG_ScheduleAppointment.id).LG_AgreedInstallDate__c != mapScheduleAppOld.get(objLG_ScheduleAppointment.id).LG_AgreedInstallDate__c) || (!isUpdate)))
            {
                Datetime agreedInstallDtTime = datetime.newInstance(objLG_ScheduleAppointment.LG_AgreedInstallDate__c.year(), objLG_ScheduleAppointment.LG_AgreedInstallDate__c.month(),objLG_ScheduleAppointment.LG_AgreedInstallDate__c.day());
                //Taking 24hrs as the everyday business hrs, 8*3600000(1hr = 3600000 miliseconds)
                if(firstEmail!=null)
                {
                    Long durationFirstEmail = (Long)(-28800000 * firstEmail);
                    Datetime firstEmailDateTime = BusinessHours.add(bh.id, agreedInstallDtTime, durationFirstEmail);
                    objLG_ScheduleAppointment.LG_DateofFirstEmailNotification__c = firstEmailDateTime;
                }
            }                       
        }
    } 
}

/**
* To calculate reminder date from Scheduled Appointment
*
* @author Preetha N
* @story SFOM-2578
* @since 30/01/2018
*/
public Map<Id, csord__Service__c> getServiceMap(List<LG_ScheduleAppointment__c> appointmentList){
    set<id> solutionList = new set<id>();
    map<Id, csord__Service__c> serviceMap = new  map<Id, csord__Service__c>();
    for(LG_ScheduleAppointment__c appointmentDetail:appointmentList){
        solutionList.add(appointmentDetail.LG_Solution__c);
    }
    
    if(solutionList.size() > 0 ){
        List<csord__Service__c> serviceList =[select name,LG_Suborder__c, csord__Order__r.csord__Order_Type__c from csord__Service__c where LG_Suborder__c in :solutionList];
        for(csord__Service__c serviceDetail:serviceList){
            if(!serviceMap.containsKey(serviceDetail.LG_Suborder__c)){
                serviceMap.put(serviceDetail.LG_Suborder__c,serviceDetail);
            }
        }
    }
    return serviceMap;
    }

}