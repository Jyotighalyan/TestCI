/******** Test class for LG_AppointmentAlertScheduler****
***** Author: Alisha,Preetha N **********
*********SFOM - 2578***********
*****************************************************************/
@isTest
public class LG_AppointmentAlertSchedulerTest {

static testmethod void testSchedule()
{

      Folder folder = [SELECt id FROM folder where DeveloperName='LG_Appointments'];
        EmailTemplate template = new EmailTemplate (developerName = 'test', FolderId = UserInfo.getUserId(), TemplateType= 'Text', Name = 'test',body ='{!LG_ScheduleAppointment__c.Name}'); // plus any other fields that you want to set
        insert template; 
        User adminUser = [SELECT id FROM user WHERE Profile.Name ='System Administrator' and isActive=true LIMIT 1];
        Test.startTest();
        system.runAs(adminUser){
            
        account account = new account();
        account.Name = 'Test';
        account.LG_Segment__c = 'SME';
        insert account;
        
        contact con = new Contact(AccountId=account.id);
        con.firstname = 'First';
        con.LastName = 'Last';
        con.Salutation='Mr.';
        con.Email='abcd@gmail.com';
        con.Phone='07123456789';
        con.LG_PreferredCommunication__c='Email';
        insert con;
        
        //Opportunity
        Opportunity Oppty= new Opportunity();
        Oppty.Name='Nps Opportunity';
        Oppty.Accountid=account.id;
        Oppty.LG_PrimaryContact__c=con.id;
        Oppty.Type='New';
        Oppty.StageName='Qualified';
        Oppty.CloseDate=system.today()+7;
        Oppty.csordtelcoa__Change_Type__c = 'New';
        Insert Oppty;
        
        //Order
        csord__Order__c order = new csord__Order__c(Name='Test Order',csord__Identification__c = '6465467986',csord__Account__c = account.Id, csordtelcoa__Opportunity__c=Oppty.Id);
        insert order;
        
        
        cscrm__Address__c address=new cscrm__Address__c();
        address.name='1234';
        address.cscrm__Account__c = account.id;
        address.LG_TechnicalContact__c=con.id;
        insert address;
        
        csord__solution__c sol=new  csord__solution__c();
        sol.csord__Identification__c='abc';
        sol.LG_Address__c=address.id;
        sol.csord__Order__c=order.Id;
        sol.OwnerId=userinfo.getUserId();
        insert sol;
        
        csord__Subscription__c subs = new csord__Subscription__c();
        subs.name='Sub 1';
        subs.csord__Identification__c ='iden';
        insert subs;
       
        csord__Service__c serv = new csord__Service__c();
        serv.name = 'Company Fiber';
        serv.LG_Suborder__c = sol.id;
        serv.csord__Subscription__c=subs.id;
        serv.csord__Order__c = order.id;
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
            
        Appointment_Reminder__c reminder1 = new Appointment_Reminder__c();
        reminder1.name= 'LG_AppointmentReminder_NF';
        reminder1.Days_Before_First_Email_Notification__c = 5;
        reminder1.Days_Before_Second_Email_Notification__c= 1;
        reminder1.EmailTemplateId__c = template.id;
        reminder1.location__c= 'VMB';
        reminder1.Category__c = '1';
        insert reminder1;
        
        Appointment_Reminder__c reminder2 = new Appointment_Reminder__c();
        reminder2.name= 'LG_AppointmentReminder_NS';
        reminder2.Days_Before_First_Email_Notification__c = 5;
        reminder2.Days_Before_Second_Email_Notification__c= 1;
        reminder2.EmailTemplateId__c = template.id;
        reminder2.location__c= 'VMB';
        reminder2.Category__c = '1';
        insert reminder2;
            
        LG_ScheduleAppointment__c scheduleobj = new LG_ScheduleAppointment__c();
        scheduleobj.name='Test Sch';
        scheduleobj.LG_AgreedInstallDate__c = system.today().addDays(4);
        scheduleobj.LG_InstallationContact__c=con.id;
        scheduleobj.lg_slot__c = 'Morning Slot';
        scheduleobj.LG_Solution__c=sol.id;
        //scheduleobj.LG_DateofFirstEmailNotification__c=system.today();
        insert scheduleobj;
        
        List<LG_ScheduleAppointment__c> l1=new List<LG_ScheduleAppointment__c>();
        l1.add(scheduleobj);
        SYSTEM.DEBUG('lIST'+l1);
        
        scheduleobj.LG_DateofFirstEmailNotification__c=system.today();
        update scheduleobj;
        
        LG_ScheduleAppointment__c schInserted = [SELECT id,name,LG_DateofFirstEmailNotification__c FROM LG_ScheduleAppointment__c where name ='Test Sch'];
        SYSTEM.DEBUG('SCHEDULE APPNT'+schInserted);
        system.assertEquals(schInserted.name, scheduleobj.name);
        LG_AppointmentAlertScheduler sh1 = new LG_AppointmentAlertScheduler();
        String sch = '0 0 23 * * ?'; system.schedule('Test AppointmentAlert', sch, sh1);
        }
       
        
        Test.stopTest(); 
}
}