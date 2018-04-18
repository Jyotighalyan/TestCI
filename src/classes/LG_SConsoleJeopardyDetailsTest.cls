/**
* Test class for LG_SConsoleJeopardyDetailsExtension
* 
* @author Godson DS   
* @story SFOM-133
* @since  12/1/2017
*/

@isTest
public class LG_SConsoleJeopardyDetailsTest {
    @testSetup
    static void setup() {
    
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        
        //Order
        csord__Order__c order = new csord__Order__c(Name='Test Order',csord__Identification__c = '6465467986');
        insert order;
        
        //product configuration
        cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c(cscfga__Attribute_Name__c='testAttribute',Name='TestName');
        insert pc;
        
        // Subscripton 
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '6465467986');
        insert sub; 
        
        //Address
        cscrm__Address__c address = new cscrm__Address__c();
        address.LG_HouseNumberExtension__c = '2nd floor';
        address.LG_HouseNumber__c = '35';
        address.cscrm__Street__c = 'street';
        address.cscrm__City__c = 'city';
        address.cscrm__Country__c = 'country';
        address.cscrm__Zip_Postal_Code__c = 'T1234';
        insert address;
        
        //Solution
        csord__Solution__c solution = new csord__Solution__c(Name = 'test solution',csord__Identification__c = '6465467986',csord__Order__c=order.Id,LG_JeopardyExplanation__c='');
        solution.LG_Address__c = address.Id;
        //solution.LG_OrderChanged__c = false;
        //solution.LG_OrderCancelled__c = false;
        insert solution;
        
        // Service 
        csord__Service__c service = new csord__Service__c(csordtelcoa__Product_Configuration__c=pc.Id,Name='TestService',csord__Subscription__c=sub.Id,csord__Identification__c='6465467986',LG_RootOrder__c=order.Id,csord__Activation_Date__c=Date.today(),LG_Effectivedate__c=Date.today(), csord__Status__c = 'Cancelled' ) ;
        service.LG_Suborder__c = solution.Id;
        insert service;        
        
        //Attribute
        cscfga__Attribute__c a = new cscfga__Attribute__c(cscfga__Product_Configuration__c = pc.Id,Name='TestAttribute',cscfga__Value__c='15',cscfga__Display_value__c='TestDisplayValue');
        insert a;
        
        //Attribute Field
        cscfga__Attribute_Field__c af = new cscfga__Attribute_Field__c(cscfga__Attribute__c = a.Id,Name='TestAttributeFieldName',cscfga__Value__c='Hello');
        insert af;
        
        //Service Line Item
        csord__Service_Line_Item__c serviceLineItem1 = new csord__Service_Line_Item__c(Name='test Line item 1',csord__Service__c = service.Id,csord__Identification__c = '6465467986');
        //insert serviceLineItem1;
        
         //Service Line Item
        csord__Service_Line_Item__c serviceLineItem2 = new csord__Service_Line_Item__c(Name='test Line item 2',csord__Service__c = service.Id,csord__Identification__c = '6465467986');
        //insert serviceLineItem2;
        
        //Service Line Item
        csord__Service_Line_Item__c serviceLineItem3 = new csord__Service_Line_Item__c(Name='test Line item 3',csord__Service__c = service.Id,csord__Identification__c = '6465467986');
        //insert serviceLineItem3;
        
                

        Contact con = new Contact(FirstName='Test',LastName='Contact',Phone='09876543210', Salutation ='Mr');
        insert con;
        
        //Case
        Case c = new Case(LG_Service__c = service.Id,LG_Solution__c = solution.Id, Type = 'Cost',ContactId = con.Id, Status = 'New');
        c.RecordTypeId = [Select Id,SobjectType,Name From RecordType where Name ='Jeopardy' 
                          and SobjectType ='Case'  limit 1].Id;
        insert c;
        
        CSPOFA__Orchestration_Process_Template__c processTemplate = new CSPOFA__Orchestration_Process_Template__c(Name = 'Test Orchestration');
        insert processTemplate;
        
        CSPOFA__Orchestration_Process__c processIds = new CSPOFA__Orchestration_Process__c(Name = 'Test Orchestration',LG_Solution__c = solution.Id,CSPOFA__Orchestration_Process_Template__c = processTemplate.id);
        insert processIds;
        
        CSPOFA__Orchestration_Step__c OrchStep = new CSPOFA__Orchestration_Step__c(Name='Orch Step', CSPOFA__Status__c = 'In Progress');
        OrchStep.CSPOFA__Step_Order__c= 67;
        OrchStep.CSPOFA__Orchestration_Process__c = processIds.Id;
        insert OrchStep; 

        LG_InflightChangeStep__c inflightSetting = new LG_InflightChangeStep__c(Name= 'Test', LG_OrchestrationProcess__c = processTemplate.id, LG_InstallLoop__c=55, LG_NumberPortLoop__c=38,LG_PortingWindow__c=7, LG_ProvisionLoop__c=27,LG_RetryInstall__c=37,LG_RetryNumberPort__c=34,LG_RetryProvision__c=21,LG_Access_Planningloop__c=13);
        insert inflightSetting;
        
        //Populating service with solution Id
        service.csord__Solution__c = solution.Id;
        update service;
        
    }
    
    
    public static testMethod void TestController(){
        Case c = [select Id,LG_Service__c,LG_Solution__c,Type,Contact.Id, recordTypeId from Case LIMIT 1];
        system.assertnotequals(null,c);
        Contact contactDetail = [SELECT Id,Name, Phone FROM Contact LIMIT 1];
        csord__Solution__c s = [select Id,Name,csord__Order__c,LG_JeopardyExplanation__c, LG_Address__c, LG_Address__r.LG_HouseNumberExtension__c, 
                   LG_Address__r.LG_HouseNumber__c, LG_Address__r.cscrm__Street__c, LG_Address__r.cscrm__City__c, LG_Address__r.cscrm__Country__c,
                                //LG_OrderChanged__c, LG_OrderCancelled__c, 
                   LG_Address__r.cscrm__Zip_Postal_Code__c from csord__Solution__c LIMIT 1];
        List<csord__Service__c> service = [select Id,Name,csord__Status__c from csord__Service__c where csord__Solution__c=:s.Id];
        List<csord__Service_Line_Item__c> sli = [Select Id from csord__Service_Line_Item__c where csord__Service__c=:service.get(0).Id];  
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
        PageReference pageRef = Page.LG_SConsoleJeopardyDetails;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',c.id);
        LG_SConsoleJeopardyDetailsExtension controller = new LG_SConsoleJeopardyDetailsExtension(new ApexPages.StandardController(c));
   //     controller.getCaseAccountDetails();
        controller.getSolution();
        controller.getService();
        controller.getServiceLineItems();
        controller.InflightAppointment();
        controller.InflightNumber();
        controller.InflightConfiguration();
        
        
        //null case
        //controller.getSolution();
        //controller.getService();
        c.LG_Solution__c = null;
        controller.serviceObject = service;
        controller.getProvisioningDetails();
        controller.getJeopardy();
        controller.getRelatedSolutions();
        controller.edit();
        controller.save();
        controller.complexChange();
        controller.requestCancel();
        controller.FollowOrder();
        controller.closeJeopardy();
        controller.InflightAppointment();
        
        //Making solution obj as null to test exception
        controller.solutionObject = null;
        controller.save();
        controller.cancel();
        controller.complexChange();
        controller.requestCancel();        
        
        controller.cs.LG_Solution__c = null;
        controller.getService();
        
        
        Test.stopTest();
         }
    }
    
    public static testMethod void TestReturnValues(){
        Case case1 = [select Id,LG_Service__c,LG_Solution__c,Type,Contact.Id, recordTypeId from Case LIMIT 1];
        case1.Type = 'Install & Activate';
        update case1;
        Contact contactDetail = [SELECT Id,Name, Phone FROM Contact LIMIT 1];
        csord__Solution__c solDetails = [select Id,Name,csord__Order__c,LG_JeopardyExplanation__c, LG_Address__c, LG_Address__r.LG_HouseNumberExtension__c, 
                                        LG_Address__r.LG_HouseNumber__c, LG_Address__r.cscrm__Street__c, LG_Address__r.cscrm__City__c, LG_Address__r.cscrm__Country__c,
                                         //LG_OrderChanged__c, LG_OrderCancelled__c, 
                                        LG_Address__r.cscrm__Zip_Postal_Code__c from csord__Solution__c LIMIT 1];
        List<csord__Service__c> service = [select Id,Name,csord__Status__c from csord__Service__c where csord__Solution__c=:solDetails.Id];
        List<csord__Service_Line_Item__c> sli = [Select Id from csord__Service_Line_Item__c where csord__Service__c=:service.get(0).Id];  
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
        PageReference pageRef = Page.LG_SConsoleJeopardyDetails;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',case1.id);
        LG_SConsoleJeopardyDetailsExtension controller = new LG_SConsoleJeopardyDetailsExtension(new ApexPages.StandardController(case1));
     //   System.assertEquals(contactDetail.Id, controller.getCaseAccountDetails().contact.Id);
        System.assertEquals(solDetails.Id, controller.getSolution().Id);
        System.assertEquals(service.size(), controller.getService().size());
        Test.stopTest();
         }
    }
    
    /*Sfom -564 */
    
    public static testMethod void testApplyExtraCharges(){
        Case c = [select Id,LG_Service__c,LG_Solution__c,Type,Contact.Id, recordTypeId from Case LIMIT 1];
          User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
   
        LG_SConsoleJeopardyDetailsExtension controller = new LG_SConsoleJeopardyDetailsExtension(new ApexPages.StandardController(c));
        controller.applyExtraCharges();
        System.assertEquals(false, controller.validStage);
        
        controller.isCaseClosed = true;
        update c;
        
        controller.validStage =true;
        controller.applyExtraCharges();
        System.assertEquals(false, controller.validStage);
         }
    }
}