/**
 *Test Class for LG_RequiresInstallationOrActivation
 * 
 * @author Preetha N
 * @since  24/10/2017
*/
@isTest
public class LG_RequiresInstallationOrActivationTest {
    public static testmethod void activationtest(){
      
		CSPOFA__Orchestration_Process_Template__c TEMP=NEW CSPOFA__Orchestration_Process_Template__c();
        TEMP.NAME='template';
        insert TEMP;
        
          csord__Order_Request__c req = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert req;

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = req.Id);
        insert sub;

        cscrm__Address__c address = new cscrm__Address__c(cscrm__Street__c = 'TestStreet');
        insert address;

        System.assertEquals(null, sub.LG_Address__c, 'Address is null by default');

        Test.startTest();
          csord__Order__c order = new csord__Order__c(Name='Test Order',csord__Identification__c = '6465467986');
        insert order;
        
        csord__Solution__c solution = new csord__Solution__c(Name = 'test solution',csord__Identification__c = '6465467986',csord__Order__c=order.Id);
       solution.LG_ActivationNeeded__c=true;
        insert solution;
        
         //product configuration
        cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c(cscfga__Attribute_Name__c='testAttribute',Name='TestName');
        pc.LG_InstallationNeeded__c=true;
        insert pc;
        csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestIdentSub', csord__Order_Request__c = req.Id,
                csord__Subscription__c = sub.Id);
        service.LG_Suborder__c=solution.id;
        service.csordtelcoa__Product_Configuration__c=pc.id;
        insert service;
      
        
        LG_ScheduleAppointment__c appnt=new LG_ScheduleAppointment__c();
        appnt.name='appointment';
        appnt.LG_Solution__c=solution.id;
        insert appnt;
        CSPOFA__Orchestration_Process__c process=new CSPOFA__Orchestration_Process__c();
        process.name='orchestration process';
        process.CSPOFA__Orchestration_Process_Template__c=TEMP.ID;
       process.LG_Solution__c=solution.id;
        process.csordtelcoa__Service__c=service.id;
       	insert process;
        CSPOFA__Orchestration_Step__c step=new CSPOFA__Orchestration_Step__c();
        step.CSPOFA__Orchestration_Process__c=process.ID;
        step.name='orchestration';
        insert step;
    
    
        LG_RequiresInstallationOrActivation instact=new LG_RequiresInstallationOrActivation();
        List<SObject> data=new List<SObject>();
        data.add(step);
        instact.process(data);
        test.stopTest();
    
    }
    public static testmethod void instact(){
        test.startTest();
        	CSPOFA__Orchestration_Process_Template__c TEMP=NEW CSPOFA__Orchestration_Process_Template__c();
        TEMP.NAME='template';
        insert TEMP;
        
          csord__Order_Request__c req = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert req;

        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = req.Id);
        insert sub;

        cscrm__Address__c address = new cscrm__Address__c(cscrm__Street__c = 'TestStreet');
        insert address;

        System.assertEquals(null, sub.LG_Address__c, 'Address is null by default');

       
          csord__Order__c order = new csord__Order__c(Name='Test Order',csord__Identification__c = '6465467986');
        insert order;
        
        csord__Solution__c solution = new csord__Solution__c(Name = 'test solution',csord__Identification__c = '6465467986',csord__Order__c=order.Id);
    
        insert solution;
        
         //product configuration
        cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c(cscfga__Attribute_Name__c='testAttribute',Name='TestName');
     
        insert pc;
        csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestIdentSub', csord__Order_Request__c = req.Id,
                csord__Subscription__c = sub.Id);
        service.LG_Suborder__c=solution.id;
        service.csordtelcoa__Product_Configuration__c=pc.id;
        insert service;
      
        
        LG_ScheduleAppointment__c appnt=new LG_ScheduleAppointment__c();
        appnt.name='appointment';
        insert appnt;
        CSPOFA__Orchestration_Process__c process=new CSPOFA__Orchestration_Process__c();
        process.name='orchestration process';
        process.CSPOFA__Orchestration_Process_Template__c=TEMP.ID;
       process.LG_Solution__c=solution.id;
        process.csordtelcoa__Service__c=service.id;
       	insert process;
        CSPOFA__Orchestration_Step__c step=new CSPOFA__Orchestration_Step__c();
        step.CSPOFA__Orchestration_Process__c=process.ID;
        step.name='orchestration';
        insert step;
           LG_RequiresInstallationOrActivation instact=new LG_RequiresInstallationOrActivation();
        List<SObject> data=new List<SObject>();
        data.add(step);
        instact.process(data);
        
        test.stopTest();
        
        
    }

}