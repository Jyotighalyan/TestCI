@isTest
public class LG_ViewAttributeDefenitionControllerTest {

    @testSetup 
    static void setup() {
        
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        //product configuration
        cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c(cscfga__Attribute_Name__c='testAttribute',Name='TestName');
        insert pc;
        
        // Subscripton 
		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '6465467986');
		insert sub; 
        
        // Service 
		csord__Service__c service = new csord__Service__c(csordtelcoa__Product_Configuration__c=pc.Id,Name='TestService',csord__Subscription__c=sub.Id,csord__Identification__c='6465467986');
		insert service;
        
        //Attribute
        cscfga__Attribute__c a = new cscfga__Attribute__c(cscfga__Product_Configuration__c = pc.Id,Name='TestAttribute',cscfga__Value__c='15',cscfga__Display_value__c='TestDisplayValue');
        insert a;
        
        //Attribute Field
        cscfga__Attribute_Field__c af = new cscfga__Attribute_Field__c(cscfga__Attribute__c = a.Id,Name='TestAttributeFieldName',cscfga__Value__c='Hello');
        insert af;
        
    }

    
    public static testMethod void TestLG_ViewAttributeDefenitionController(){
        Test.startTest();
 		
        List<csord__Service__c> services = [SELECT Id,Name,csordtelcoa__Product_Configuration__c FROM csord__Service__c LIMIT 1];
        
        PageReference tpcPage = new PageReference('/apex/LG_ViewAttributeDefenition?id='+services.get(0).Id);
    	Test.setCurrentPage(tpcPage);
       
        List<LG_ViewAttributeDefenitionController.ServiceConfig> serviceConfig = LG_ViewAttributeDefenitionController.getServiceProductConfigurationDetails(services.get(0).Id);
        
        //Validating only one record is fetched
        System.assertEquals(1, serviceConfig.size());
		
        //Validating the service id is same in sevice config
        System.assertEquals(services.get(0).Id, serviceConfig.get(0).service.Id);
        
        Test.stopTest();

    }
    
    //Testing if null is passed to controller, An excption is thrown
    public static testMethod void TestLG_ViewAttributeDefenitionControllerException(){
        Test.startTest();
 		
        try{
            LG_ViewAttributeDefenitionController.getServiceProductConfigurationDetails(null);
        }
        catch (LG_Exception e){
            System.assertEquals('Service Id is empty/Null', e.getMessage());
        }
        
        Test.stopTest();

    }
}