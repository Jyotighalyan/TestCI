/**
* Test class for LG_SconsoleDisplayOldBdsSiteExtension
* 
* @author ALISHA
* @since  22/12/2017
*/

@isTest
public class LG_SconsoleDisplayOldBdsSiteExtTest{
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
        csord__Solution__c solution = new csord__Solution__c(Name = 'test solution',csord__Identification__c = '6465467986',csord__Order__c=order.Id);
        solution.LG_Address__c = address.Id;
        insert solution;
        
        // Service 
        csord__Service__c service = new csord__Service__c(csordtelcoa__Product_Configuration__c=pc.Id,Name='TestService',csord__Subscription__c=sub.Id,csord__Identification__c='6465467986',LG_RootOrder__c=order.Id,csord__Activation_Date__c=Date.today(),LG_Effectivedate__c=Date.today(), LG_ServiceStatus__C = 'Provisioned' ) ;
        service.csord__Solution__c = solution.Id;
        service.LG_Address__c = serviceAddress.Id;
        service.LG_ServiceStatus__c = 'Activation Completed';
        service.LG_Product_Category__c = 'ProductCategory';
        insert service;
       //Case
        Case c = new Case(LG_Service__c = service.Id,LG_Solution__c = solution.Id,Status = 'New');
        c.RecordTypeId = [Select Id,SobjectType,Name From RecordType where Name ='Terminate' 
                          and SobjectType ='Case'  limit 1].Id;
        insert c;
         
         
        noTriggers.Flag__c = False;
        upsert noTriggers;    
    }
    public static testMethod void LG_SconsoleDisplayOldBdsSiteExtension(){
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
        PageReference pageRef = Page.LG_SconsoleDisplayOldBdsSite;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',c.id);
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        LG_SconsoleDisplayOldBdsSiteExtension controller = new LG_SconsoleDisplayOldBdsSiteExtension(sc);
        controller.getSolution();
        controller.getRecordType();
        controller.getProvisioning();
        controller.PageRefresh();
        
        List<Id> prodConfIdList = new List<Id>();
        prodConfIdList.add(service[0].csordtelcoa__Product_Configuration__c);
        LG_ProductConfigurationUtil utils = new LG_ProductConfigurationUtil(prodConfIdList);
       
       LG_SconsoleDisplayOldBdsSiteExtension.ProvisioningDetails  provisioningDetails = new LG_SconsoleDisplayOldBdsSiteExtension.ProvisioningDetails(controller.getRecordType(), service[0]);
       
        provisioningDetails.service = service[0];
        //provisioningDetails.
        provisioningDetails.keyAttribute = '';

        List<LG_SconsoleDisplayOldBdsSiteExtension.ProvisioningDetails> provisioningList = new List<LG_SconsoleDisplayOldBdsSiteExtension.ProvisioningDetails>();
        provisioningList.add(provisioningDetails);
        controller.provisioningDetails = provisioningList;
        controller.jeopardy = true;
        system.assertEquals(s.Id, controller.getSolution().Id);
        Test.stopTest();
    }

    
    
  
}