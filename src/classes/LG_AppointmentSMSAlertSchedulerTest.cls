@isTest
public class LG_AppointmentSMSAlertSchedulerTest {
	static testmethod void testSchedule()
    {
        Folder folder = [SELECt id FROM folder where DeveloperName='LG_Appointments'];
        EmailTemplate template = new EmailTemplate (developerName = 'test', FolderId = UserInfo.getUserId(), TemplateType= 'Text', Name = 'test',body ='{!LG_ScheduleAppointment__c.Name}'); // plus any other fields that you want to set
        insert template; 
        User adminUser = [SELECT id FROM user WHERE Profile.Name ='System Administrator' and isActive=true LIMIT 1];
        Test.startTest();
        system.runAs(adminUser){
            csord__solution__c sol=new  csord__solution__c();
            sol.csord__Identification__c='abc';
            insert sol;
            csord__Subscription__c subs = new csord__Subscription__c();
            subs.name='Sub 1';
            subs.csord__Identification__c ='iden';
            insert subs;
            Contact con = new Contact(firstname='Test',lastname='User');
            insert con;
            csord__Service__c serv = new csord__Service__c();
            serv.name = 'Service';
            serv.LG_Suborder__c = sol.id;
            serv.csord__Subscription__c=subs.id;
            serv.csord__Identification__c ='iden';
            serv.UM_DownloadSpeed__c = 100;
            insert serv;
            Appointment_Reminder__c reminder = new Appointment_Reminder__c();
            reminder.name= 'LG_AppointmentReminder';
            reminder.Days_Before_First_Email_Notification__c = 2;
            reminder.Days_Before_Second_Email_Notification__c= 1;
            reminder.Days_Before_First_SMS_Notification__c= 1;
            reminder.SMSTemplateId__c = template.id;
            reminder.location__c= 'VMB';
            insert reminder;
            LG_ScheduleAppointment__c scheduleobj = new LG_ScheduleAppointment__c();
            scheduleobj.name='Test Sch';
            scheduleobj.LG_AgreedInstallDate__c = system.today().addDays(1);
            scheduleobj.LG_InstallationContact__c=con.id;
            scheduleobj.lg_slot__c = 'Morning Slot';
            scheduleobj.LG_Solution__c=sol.id;
            insert scheduleobj;
            LG_ScheduleAppointment__c schInserted = [SELECT id,name FROM LG_ScheduleAppointment__c where name ='Test Sch'];
            system.assertEquals(schInserted.name, scheduleobj.name);
        }
        LG_AppointmentSMSAlertScheduler sh1 = new LG_AppointmentSMSAlertScheduler();
        String sch = '0 0 23 * * ?'; system.schedule('Test AppointmentAlert', sch, sh1);
        
        Test.stopTest(); 
    
    }
}