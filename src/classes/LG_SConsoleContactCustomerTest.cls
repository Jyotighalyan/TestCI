/**
* Test class for LG_SConsoleContactCustomerExtension
* 
* @author Ganesh Subbiah   
* @story SFOM-335
* @since  06/02/2017
*/
@IsTest
public class LG_SConsoleContactCustomerTest {
        
    @testSetup
    static void setup() {
    
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        //upsert noTriggers;
        
        //Accounts
        Account ACC = new account(Name ='TestAccount', Type = 'Prospect' );
        insert ACC;

        //Contacts
        Contact Con = new Contact(FirstName= 'Test', LastName = 'Contact',Salutation ='Mr', Email = 'Test@vm.co.uk', phone = '07770000111', AccountId = acc.Id,LG_DecisionMaker__c = true);
        insert con;
        
        //Address
        cscrm__Address__c address = new cscrm__Address__c();
        address.Name = 'Address Name';
        address.LG_HouseNumberExtension__c = '2nd floor';
        address.LG_HouseNumber__c = '35';
        address.cscrm__Street__c = 'street';
        address.cscrm__City__c = 'city';
        address.cscrm__Country__c = 'country';
        address.cscrm__Zip_Postal_Code__c = 'T1234';
        insert address;
        

        //Order
        csord__Order__c order = new csord__Order__c(Name='Test Order',csord__Identification__c = '6465467986', csord__Account__c = acc.id);
        insert order;
        
        //product definition
        cscfga__Product_Definition__c prdConf = new cscfga__Product_Definition__c(Name='TestProductDefinition',cscfga__Description__c='Description of TestProductDefinition');
        insert prdConf;
        
        //product configuration
        cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c(cscfga__Attribute_Name__c='testAttribute',Name='TestProductConfiguration',cscfga__Product_Definition__c = prdConf.Id);
        insert pc;
        
        // Subscripton 
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '6465467986');
        insert sub; 
        
        //Address
        cscrm__Address__c serviceAddress = new cscrm__Address__c(Name = 'Address Name1',LG_HouseNumberExtension__c = '3rd floor', cscrm__Street__c = 'street1', cscrm__City__c = 'city1', cscrm__Country__c = 'country', cscrm__Zip_Postal_Code__c = 'T1234');
        insert serviceAddress;
        
        //Solution
        csord__Solution__c solution = new csord__Solution__c(Name = 'test solution',csord__Identification__c = '6465467986',csord__Order__c=order.Id,LG_JeopardyExplanation__c='');
        solution.LG_Address__c = address.Id;
        insert solution;
        
        // Service 
        csord__Service__c service = new csord__Service__c(csordtelcoa__Product_Configuration__c=pc.Id,Name='TestService',csord__Subscription__c=sub.Id,csord__Identification__c='6465467986',LG_RootOrder__c=order.Id,csord__Activation_Date__c=Date.today(),LG_Effectivedate__c=Date.today(), LG_ServiceStatus__C = 'Provisioned' ) ;
        service.csord__Solution__c = solution.Id;
        service.LG_Address__c = serviceAddress.Id;
        service.LG_ServiceStatus__c = 'Provisioned';
        insert service;
        
        //Attribute Definition
        cscfga__Attribute_Definition__c attDef = LG_GeneralTest.createAttributeDefinition('AttDef', prdConf , 'User Input', 'String',
            null, null, null, true);
        
        //Attribute
        cscfga__Attribute__c a = new cscfga__Attribute__c(cscfga__Product_Configuration__c = pc.Id,Name='TestAttribute',cscfga__Value__c='15',cscfga__Display_value__c='TestDisplayValue',cscfga__Attribute_Definition__c= attDef.id);
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
        
        
        //Case
        Case c = new Case(LG_Service__c = service.Id,LG_Solution__c = solution.Id, type = 'Courtesy Call');
        c.RecordTypeId = [Select Id,SobjectType,Name From RecordType where Name ='Contact Customer' 
                          and SobjectType ='Case'  limit 1].Id;
        insert c;
                
    }
    
    public static testMethod void TestLG_SConsolecontactcustomer(){
        Case c = [select Id,status, LG_Service__c,LG_Solution__c,recordTypeId from Case LIMIT 1];
        csord__Solution__c s = [select Id,Name,csord__Order__c,LG_JeopardyExplanation__c, LG_Address__c, 
                                LG_Address__r.Name from csord__Solution__c LIMIT 1];
        //id accid = s.csord__Order__r.csord__Account__c;
        List<csord__Service__c> service = [select Id, csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name,
                                           LG_Address__c,
                                            LG_Address__r.Name,
                                            LG_Address__r.LG_HouseNumber__c,
                                            LG_Address__r.cscrm__Street__c,
                                            LG_Address__r.cscrm__City__c,
                                            LG_Address__r.cscrm__Zip_Postal_Code__c,
                                            LG_Address__r.cscrm__Country__c,
                                           LG_ServiceStatus__c from csord__Service__c where csord__Solution__c=:s.Id];
        List<csord__Service_Line_Item__c> sli = [Select Id, Name,csord__Service__c from csord__Service_Line_Item__c where csord__Service__c=:service.get(0).Id];  
        //List<Contact> contactList = [SELECT Id, FirstName, LastName, Phone, Email FROM Contact WHERE AccountId=:accid];
		  User thisUser=[select id from User where id=:UserInfo.getUserId()];
         System.runAs(thisUser){
        Test.startTest();
        PageReference pageRef = Page.LG_SConsoleContactCustomer;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',c.id);
        LG_SConsoleContactCustomerExtension controller = new LG_SConsoleContactCustomerExtension(new ApexPages.StandardController(c));
        List<Id> prodConfIdList = new List<Id>();
        prodConfIdList.add(service[0].csordtelcoa__Product_Configuration__c);
        LG_ProductConfigurationUtil utils = new LG_ProductConfigurationUtil(prodConfIdList);
        LG_SConsoleContactCustomerExtension.ProvisioningDetails  provisioningDetails = new LG_SConsoleContactCustomerExtension.ProvisioningDetails(controller.getRecordType(), service[0]);
        provisioningDetails.service = service[0];
        provisioningDetails.serviceLineItem = null;
        provisioningDetails.keyAttribute = '';
        List<LG_SConsoleContactCustomerExtension.ProvisioningDetails> provisioningList = new List<LG_SConsoleContactCustomerExtension.ProvisioningDetails>();
        provisioningList.add(provisioningDetails);
        controller.getSolution();
        controller.getService();
        controller.serviceObject = service;
        controller.getServiceLineItems();
        controller.getrelatedcontact();
        controller.getrelatedorder();
        controller.getProvisioningDetails();
        Controller.getcontactrecords();
        Controller.sendEmail();
        system.assertEquals('https://composer.congamerge.com?', controller.CongaURLPath);
        controller.provisioningDetails = provisioningList;


        Test.stopTest();
         }
    }
}