@isTest
public class LG_ScheduleAppComponentControllerTest {
    @testSetup
    static void createTestData(){
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        csord__Solution__c sol = new csord__Solution__c();
        sol.name='test Sol';
        sol.csord__Identification__c='123';
        insert sol;   
        csord__Subscription__c subs = new csord__Subscription__c();
        subs.name='Sub 1';
        subs.csord__Identification__c ='iden';
        insert subs;
        csord__Service__c serv = new csord__Service__c();
        serv.name = 'Service 1';
        serv.LG_Suborder__c = sol.id;
        serv.csord__Subscription__c=subs.id;
        serv.csord__Identification__c ='iden';
        serv.UM_DownloadSpeed__c = 100;
        insert serv;
        csord__Service_Line_Item__c sl = new csord__Service_Line_Item__c();
        sl.name ='Sl1';
        sl.csord__Service__c= serv.id;
        sl.csord__Identification__c ='iden';
        sl.name='sl1';
        insert sl;
        //csord__Service_Line_Item__c slInserted = [SELECT id,name FROM csord__Service_Line_Item__c where name='sl1'];
        //system.assertEquals(sl.name, slInserted.name);
        
        noTriggers.Flag__c = False;
        upsert noTriggers;
    }
    static testmethod void testController(){
        csord__Solution__c sol = [SELECT id,name FROm csord__Solution__c WHERE name='test Sol'];
         system.assertequals('test Sol',sol.name);
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        LG_ScheduleAppComponentController cont = new LG_ScheduleAppComponentController();
        cont.solId = sol.Id;
        cont.attribName = 'Name';
        cont.getserviceLineItems();
        cont.getProdConfDetails();
         }
    }
    
}