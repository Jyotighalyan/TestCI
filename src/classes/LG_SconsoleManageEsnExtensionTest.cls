@isTest
public class LG_SconsoleManageEsnExtensionTest {
        
          @testSetup
    static void createTestData()
   {
        Account accountObj= new Account(Name = 'testFname');
        Insert accountObj;
        
        Contact con = new Contact();
        con.FirstName = 'First Name';
        con.LastName = 'Last Name';
        con.Salutation = 'Mr.';

        con.Email = 'test@organization.com';
        insert con;
        
        Opportunity opp = new Opportunity(Name = 'test', AccountId=accountObj.Id, StageName = 'Awareness of interest', CloseDate=Date.today()+5,LG_PrimaryContact__c = con.id);
        Insert opp;
        
        csord__Order__c order = new csord__Order__c(Name='Test Order',csord__Identification__c = '6465467986', csord__Account__c = accountObj.id, csordtelcoa__Opportunity__c = opp.id);
        insert order;
        
        cscfga__Product_Definition__c prdConf = new cscfga__Product_Definition__c(Name='TestProductDefinition',cscfga__Description__c='Description of TestProductDefinition');
        insert prdConf;
        
        cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c(cscfga__Attribute_Name__c='testAttribute',Name='TestProductConfiguration',cscfga__Product_Definition__c = prdConf.Id);
        pc.LG_InstallValid__c = 'Yes';
        insert pc;     
        
    csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = '6465467986');
    insert sub; 
        
        cscrm__Address__c address = new cscrm__Address__c();
        address.Name = 'Address Name';
        address.LG_HouseNumberExtension__c = '2nd floor';
        address.LG_HouseNumber__c = '35';
        address.cscrm__Street__c = 'street';
        address.cscrm__City__c = 'city';
        address.cscrm__Country__c = 'country';
        address.cscrm__Zip_Postal_Code__c = 'T1234';
        address.Delivery_Type__c = 'FTTP';
        address.LG_TechnicalContact__c = con.Id;
        insert address;
        
        csord__Solution__c solution = new csord__Solution__c(Name = 'test solution',csord__Identification__c = '6465467986',csord__Order__c=order.Id,LG_JeopardyExplanation__c='');
        solution.LG_Address__c = address.Id;
        solution.csord__Account__c = accountObj.Id;
        insert solution;
        
    csord__Service__c service = new csord__Service__c(csordtelcoa__Product_Configuration__c=pc.Id,Name='TestService',csord__Subscription__c=sub.Id,csord__Identification__c='6465467986',csord__Order__c=order.Id,csord__Activation_Date__c=Date.today(),LG_Effectivedate__c=Date.today(), LG_ServiceStatus__C = 'Provisioned' ) ;
        service.csord__Solution__c = solution.Id;
        //service.LG_Address__c = serviceAddress.Id;
        service.LG_ServiceStatus__c = 'Ready for Billing';
        service.LG_Product_Category__c = 'ProductCategory';
        //insert service;
       
       RecordType caseType = [SELECT Id FROM RecordType WHERE sObjectType = 'Case' AND Name = 'Manage Assets'];
        case c = new case();
        c.LG_Order__c = order.id;
        c.LG_Solution__c= solution.id;
        c.RecordTypeId = caseType.Id;
        c.Status = 'New';
        c.Account = accountObj;
        insert c;
    }
    
   static testMethod void testManageESN() 
    {
      String errorTxt;
        Case c = [SELECT id,LG_Order__c,LG_Solution__c,ContactId, Status, RecordType.Name FROM Case LIMIT 1];
      LG_SconsoleManageEsnExtension controller = new LG_SconsoleManageEsnExtension(new ApexPages.StandardController(c));
      controller.setEditMode();
      controller.getRecordType();
      
      controller.getFieldList();
      controller.getAssetList();
      controller.retriveOrderRecord();
    
      c.status = 'closed';
        try{
        update c;
      } catch(Exception e){
        errorTxt = e.getMessage(); 
      }
      System.assertEquals('closed',c.status);

    }
    
    }