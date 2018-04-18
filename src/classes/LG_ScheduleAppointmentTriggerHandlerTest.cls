/******** Test class for LG_ScheduleAppointmentTriggerHandler****
 ***** Author: Preetha N **********
*********SFOM - 2578***********
*****************************************************************/
@isTest
public class LG_ScheduleAppointmentTriggerHandlerTest {
    
    private static testMethod void testInsertScheduleApp()
    {
        EmailTemplate template = new EmailTemplate (developerName = 'test', FolderId = UserInfo.getUserId(), TemplateType= 'Text', Name = 'test'); // plus any other fields that you want to set
        insert template; 
        User adminUser = [SELECT id FROm user WHERE Profile.Name ='System Administrator' and isActive=true LIMIT 1];
        Test.startTest();
        //run as diferent user to avoid Mixed DML exception
        system.runAs(adminUser){
            csord__solution__c sol=new  csord__solution__c();
            sol.csord__Identification__c='abc';
            insert sol;
            csord__Subscription__c subs = new csord__Subscription__c();
            subs.name='Sub 1';
            subs.csord__Identification__c ='iden';
            insert subs;
            Contact con = new Contact(firstname='Test',lastname='User');
            con.LG_PreferredCommunication__c='Email';
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
            reminder.Days_Before_First_SMS_notification__c=1;
            reminder.EmailTemplateId__c = template.id;
            reminder.location__c= 'VMB';
            insert reminder;
            List<RecordType> caseRecordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND Name IN ('Install', 'Provision', 'Number Port', 'Activate Service', 'Access Planning')];
            Case cse = new case();
            cse.RecordTypeId = caseRecordTypes[0].Id; 
            insert cse;
            Appointment_Reminder__c remind=new Appointment_Reminder__c();
            remind.Name='abc';
            insert remind;
            LG_ScheduleAppointment__c scheduleobj = new LG_ScheduleAppointment__c();
            scheduleobj.LG_AgreedInstallDate__c = system.today()+1;
            scheduleobj.LG_slot__c = 'Morning Slot';
            scheduleobj.name='Test Sch';
            scheduleobj.LG_Status__c='Scheduled';
            scheduleobj.LG_Case__c = cse.id;
            scheduleobj.LG_InstallationContact__c=con.id;
            scheduleobj.LG_Solution__c=sol.id;
            insert scheduleobj;
            /*LG_ScheduleAppointment__c scheduleobj1 = new LG_ScheduleAppointment__c();
            scheduleobj1.LG_AgreedInstallDate__c = system.today().addDays(3);
            scheduleobj1.LG_slot__c = 'Morning Slot';
            scheduleobj1.name='Test Sch1';
            scheduleobj1.LG_Status__c='Scheduled';
            
            insert scheduleobj1;*/
            LG_ScheduleAppointment__c schInserted = [SELECT id,name FROM LG_ScheduleAppointment__c where name ='Test Sch'];
            system.assertEquals(schInserted.name, scheduleobj.name);
            schInserted.LG_Status__c= 'Cancelled';
            update schInserted;
            List<LG_ScheduleAppointment__c> appList=new List<LG_ScheduleAppointment__c>();
            appList.add(scheduleobj);
            
            map<Id,LG_ScheduleAppointment__c> mapScheduleAppNew=new map<Id,LG_ScheduleAppointment__c>();
            mapScheduleAppNew.put(scheduleobj.id,scheduleobj);
            //map<Id,LG_ScheduleAppointment__c> mapScheduleAppOld=new map<Id,LG_ScheduleAppointment__c>();
            //mapScheduleAppOld.put(scheduleobj1.id,scheduleobj1);
            
     
        }
    }
   
}