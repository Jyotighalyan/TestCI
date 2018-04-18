/**
* Test class for LG_SConsoleInstallDetailsExtension
* 
* @author Godson Davidson Shanthini   
* @story SFOM-94
* @since  ??/12/2016
*/

@isTest
public class LG_SConsoleInstallDetailsTest {
	
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
        pc.LG_InstallValid__c = 'Yes';
        insert pc;
        
        // Subscripton 
		csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '6465467986');
		insert sub; 
        
        //Address
        cscrm__Address__c address = new cscrm__Address__c();
        address.Name = 'Address Name';
        address.LG_HouseNumberExtension__c = '2nd floor';
        address.LG_HouseNumber__c = '35';
        address.cscrm__Street__c = 'street';
        address.cscrm__City__c = 'city';
        address.cscrm__Country__c = 'country';
        address.cscrm__Zip_Postal_Code__c = 'T1234';
        address.Delivery_Type__c = 'FTTP';
        insert address;
        
        //Address
        cscrm__Address__c serviceAddress = new cscrm__Address__c(Name = 'Address Name1',LG_HouseNumberExtension__c = '3rd floor', LG_HouseNumber__c = '35', cscrm__Street__c = 'street1', cscrm__City__c = 'city1', cscrm__Country__c = 'country', cscrm__Zip_Postal_Code__c = 'T1234');
        insert serviceAddress;
        
        
        
        //Solution
        csord__Solution__c solution = new csord__Solution__c(Name = 'test solution',csord__Identification__c = '6465467986',csord__Order__c=order.Id,LG_JeopardyExplanation__c='');
        solution.LG_Address__c = address.Id;
        insert solution;
        
        // Service 
		csord__Service__c service = new csord__Service__c(csordtelcoa__Product_Configuration__c=pc.Id,Name='TestService',csord__Subscription__c=sub.Id,csord__Identification__c='6465467986',csord__Order__c=order.Id,csord__Activation_Date__c=Date.today(),LG_Effectivedate__c=Date.today(), LG_ServiceStatus__C = 'Provisioned' ) ;
        service.csord__Solution__c = solution.Id;
        service.LG_Address__c = serviceAddress.Id;
        service.LG_ServiceStatus__c = 'Ready for Billing';
        service.LG_Product_Category__c = 'ProductCategory';
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
        
        
        
                
        LG_ScheduleAppointment__c scheduleAppointment = new LG_ScheduleAppointment__c();
        scheduleAppointment.Name = 'Appointment 1';
        scheduleAppointment.LG_Solution__C = solution.id;
        scheduleAppointment.LG_AgreedInstallDate__c = Date.today() + 10;
        scheduleAppointment.LG_Slot__c = 'Afternoon Slot';
        scheduleAppointment.LG_JobReference__c = 'JBR-1';
        scheduleAppointment.LG_InstallationComments__c = 'test';
        insert scheduleAppointment;
               
        //Case
        Case c = new Case(LG_Service__c = service.Id,LG_Solution__c = solution.Id,Status = 'New');
        c.RecordTypeId = [Select Id,SobjectType,Name From RecordType where Name ='Install' 
                          and SobjectType ='Case'  limit 1].Id;
        insert c;
        
        noTriggers.Flag__c = False;
        upsert noTriggers;                
    }
    
    public static testMethod void TestLG_SConsoleInstallDetails(){
        Case c = [select Id,LG_Service__c,LG_Solution__c,recordTypeId, Status from Case LIMIT 1];
        csord__Solution__c s = [select Id,Name,csord__Order__c,LG_JeopardyExplanation__c, LG_Address__c, 
                                LG_Address__r.Name, LG_Address__r.Delivery_Type__c from csord__Solution__c where id = :c.LG_Solution__C LIMIT 1];
        List<csord__Service__c> service = [select Id, csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name,
                                           LG_Address__c,
                                           LG_Address__r.Name,
                                           LG_Address__r.LG_HouseNumber__c,
                                           LG_Address__r.cscrm__Street__c,
                                           LG_Address__r.cscrm__City__c,
                                           LG_Address__r.cscrm__Zip_Postal_Code__c,
                                           LG_Address__r.cscrm__Country__c,
                                           LG_Product_Category__c,
                                           LG_Install_Valid__c,
                                           LG_EffectiveDate__c,
                                           LG_ServiceStatus__c from csord__Service__c where csord__Solution__c=:s.Id];
        //List<csord__Service_Line_Item__c> sli = [Select Id, Name,csord__Service__c from csord__Service_Line_Item__c where csord__Service__c=:service.get(0).Id];  
        Attachment attachment;
        
        //provisioningDetails
        //provisioningDetails
        Test.startTest();
        PageReference pageRef = Page.LG_SConsoleInstallDetails;
        Test.setCurrentPage(pageRef);
    	pageRef.getParameters().put('id',c.id);
        LG_SConsoleInstallDetailsExtension controller = new LG_SConsoleInstallDetailsExtension(new ApexPages.StandardController(c));
        //apexpages.currentpage().getparameters().put('id' , c.id);
        List<Id> prodConfIdList = new List<Id>();
        prodConfIdList.add(service[0].csordtelcoa__Product_Configuration__c);
        LG_ProductConfigurationUtil utils = new LG_ProductConfigurationUtil(prodConfIdList);
        LG_SConsoleInstallDetailsExtension.ProvisioningDetails  provisioningDetails = new LG_SConsoleInstallDetailsExtension.ProvisioningDetails(controller.getRecordType(), service[0]);
        provisioningDetails.service = service[0];
        provisioningDetails.serviceLineItem = null;
        //provisioningDetails.
        provisioningDetails.keyAttribute = '';
        //provisioningDetails.screenSection = '';
        List<LG_SConsoleInstallDetailsExtension.ProvisioningDetails> provisioningList = new List<LG_SConsoleInstallDetailsExtension.ProvisioningDetails>();
        provisioningList.add(provisioningDetails);
        controller.siteAttCheck = false;
        controller.jeoExpMsg = false;
        controller.jeopardy = false;
        controller.appDetailErrMsg = false;
        controller.errorMsg = '';
        controller.evidenceAttCheck = false;
        controller.provStatus = false;
        controller.caseClosed = false;
        controller.attachmentId = '';
        controller.util = utils;
        controller.attachment = attachment;
        controller.attachment.Name = 'Unit Test Attachment';
        controller.attachment.Body = Blob.valueOf('Unit Test Attachment Body');
        controller.getSolution();
        controller.getService();
        //set service obj
        controller.serviceList = service;
        //controller.getServiceLineItems();
        //controller.getProvisioningDetails();
        controller.getAppointment();
        controller.getSiteAttachment();
        controller.getEvidenceAttachment();
        controller.editStatus();
        controller.getSlot();
        controller.PageRefresh();
        controller.getInstallation();
        controller.edit();
        controller.provisioningDetails = provisioningList;
        controller.save();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
         system.debug('sss1' +msgs);
       for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Saved Successfully')) b = true;
        }
        
		//SFOM-579
        
        controller.servicelist[0].lg_effectivedate__c = NULL;
        controller.save();
		List<Apexpages.Message> msgs2 = ApexPages.getMessages();
        b = false;
        for(Apexpages.Message msg:msgs2){
            if (msg.getDetail().contains('Enter a valid effective date')) b = true;
        }
  	    system.assert(b);   
        
        controller.jeopardy = true;
        controller.servicelist[0].lg_effectivedate__c = Date.today();
        controller.save();
        controller.upload();
       	controller.uploadTestEvidence();
        controller.cancel();
        //controller.FrameAddressInFormat();
        Attachment attach = new Attachment(Name='TestAttachment');
        LG_SConsoleInstallDetailsExtension.deleteAttachment(''+attach.Id);
        system.assertEquals(service.size(), controller.getService().size());
        system.assertEquals(s.Id, controller.getSolution().Id);
        
        //SFOM-662
        system.assertequals(true, controller.getFTTPWarning());
		System.assertequals(null,controller.getOrgVal());
        
        Test.stopTest();
    }
}