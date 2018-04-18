@isTest
public class LG_InflightConfigurationControllerTest {
@testSetup
    static void setup() {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        //Order
        csord__Order__c order = new csord__Order__c(Name='Test Order',csord__Identification__c = '6465467986');
        insert order;
        
        //product definition
        cscfga__Product_Definition__c prdConf = new cscfga__Product_Definition__c(Name='TestProductDefinition',cscfga__Description__c='Description of TestProductDefinition');
        insert prdConf;
        
        //product configuration
        cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c(cscfga__Attribute_Name__c='testAttribute',Name='TestProductConfiguration',cscfga__Product_Definition__c = prdConf.Id);
        insert pc;
        
        //Screenflow
        cscfga__Screen_Flow__c screenflow = new cscfga__Screen_Flow__c(Name='Inflight Configuration - TestProductDefinition');
        screenflow.cscfga__Template_Reference__c = 'Template_Reference';
        insert screenflow;
        
        // Subscripton 
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '6465467986');
        insert sub; 
        
        // Service 
        csord__Service__c service = new csord__Service__c(csordtelcoa__Product_Configuration__c=pc.Id,Name='TestService',csord__Subscription__c=sub.Id,csord__Identification__c='6465467986',LG_RootOrder__c=order.Id,csord__Activation_Date__c=Date.today());
        insert service;
        
        //Attribute
        cscfga__Attribute__c a = new cscfga__Attribute__c(cscfga__Product_Configuration__c = pc.Id,Name='TestAttribute',cscfga__Value__c='15',cscfga__Display_value__c='TestDisplayValue');
        insert a; 
        //Solution
        csord__Solution__c solution = new csord__Solution__c(Name = 'test solution',csord__Identification__c = '6465467986',csord__Order__c=order.Id);
        insert solution;
        //Case
        Case c = new Case(LG_Service__c = service.Id,LG_Solution__c = solution.Id);
        c.RecordTypeId = [Select Id,SobjectType,Name From RecordType where Name ='Inflight Configuration' 
                          and SobjectType ='Case'  limit 1].Id;
        insert c;
        
     
        service.LG_Suborder__c = solution.Id;
        service.csord__Solution__c = solution.Id;
        update service;
        
        
        
    }
    public static testMethod void TestLG_InflightConfigurationController(){
        
        Case c = [select Id,LG_Service__c from Case LIMIT 1];
        csord__Solution__c s = [select Id,Name,csord__Identification__c,csord__Order__c from csord__Solution__c limit 1];
        List<csord__Service__c> services = [Select Id from csord__Service__c where Id=:c.LG_Service__c];
        
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        LG_InflightConfigurationController controller = new LG_InflightConfigurationController(sc);
        
        System.assertEquals(c.Id, controller.caseRecord.Id);
        System.assertEquals(s.Id, controller.getRelatedSolution().Id);
        System.assertEquals(services.size(), controller.getRelatedServices().size());
       // controller.getCaseRecordType();
        Test.stopTest();
         }
    }
}