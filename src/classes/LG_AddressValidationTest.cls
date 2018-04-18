@isTest
public class LG_AddressValidationTest {
    @testSetup static void methodName() {
        Profile objProfile = [Select Id, Name from Profile where Name =: 'LG_NL Sales Management User' limit 1];

        User standard = new User(alias = 'standt', 
        email='tester@testingcorp.com', 
        emailencodingkey='UTF-8', 
        lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', 
        profileid = objProfile.ID, 
        timezonesidkey='America/Los_Angeles', 
        username='tester@testingcorp.com',
        CompanyName='Testing Corporation');
        insert standard;    
        
        list<sObject> accList = Test.loadData(Account.sObjectType, 'LG_AccountTestData');
        List<Account> accList1 = (List<Account>)accList;
        for(Account loopVar : accList1){
            loopVar.OwnerID = standard.ID;
        }
        update acclist1;
        Add_ToBeDel__c tempAddSugg = new Add_ToBeDel__c(Name='1183NW',Address_ID__c='464564', City__c='Eindhoven', Country__C='Netherlands', Post_Code__c='5611LV', Street__c='Correct Street'); 
        insert tempAddSugg;
    }
    
    static testmethod void addressValidationTest() {
        Profile objProfile = [Select Id, Name from Profile where Name =: 'LG_NL Sales Management User' limit 1];

        User standard = [Select ID from user limit 1];
        Account testAcc = [Select ID,Name,LG_ChamberOfCommerceNumber__c,LG_Footprint__c,LG_VisitCountry__c,LG_VisitPostalCode__c,LG_VisitHouseNumber__c,LG_VisitCity__c,LG_VisitStreet__c from Account limit 1];
        List<Add_ToBeDel__c> tempAddSugg = [Select Name,Address_ID__c,House_Number__C, Extension__c, City__c, Country__C, Post_Code__c, Street__c from Add_ToBeDel__c];
        
        //.runas(standard) {
      
            //List<Add_ToBeDel__c> tempAddSugg = [Select Name,Address_ID__c,House_Number__C, Extension__c, City__c, Country__C, Post_Code__c, Street__c from Add_ToBeDel__c];
            //Account testAcc = [Select ID,Name,LG_ChamberOfCommerceNumber__c,LG_Footprint__c,LG_VisitCountry__c,LG_VisitPostalCode__c,LG_VisitHouseNumber__c,LG_VisitCity__c,LG_VisitStreet__c from Account limit 1];
            System.currentPageReference().getParameters().put('id', testAcc.ID);
            System.currentPageReference().getParameters().put('country', testAcc.LG_VisitCountry__c);
            System.currentPageReference().getParameters().put('returnURL', '/'+testAcc.ID);
            
            LG_AddressValidationController controller = new LG_AddressValidationController();
            controller.outsideAddressValidationpage = false;
            controller.findAddress();
            controller.selectedAddressID = tempAddSugg[0].Address_ID__c;
            pagereference saveRed = controller.setAddress();
            
            //Evaluation of the exception part of the setAddress() method
            controller.validationRecord.put('ID','');
            saveRed = controller.setAddress();
            
            //Evaluation of custom validations
            controller.validationRecord.put('LG_ChamberOfCommerceNumber__c','543');
            saveRed = controller.setAddress();
                        
            Account updatedAcc = [Select LG_AddressValidated__c from Account Where ID = :testAcc.ID];
            system.assertNotequals(updatedAcc.LG_addressValidated__C, true);
            
            ApexPages.StandardController  stdController = new ApexPages.StandardController (testAcc);
            controller = new LG_AddressValidationController(stdController );
           // controller.findAddress();
            //controller.selectedAddressID = tempAddSugg[0].Address_ID__c;
           // controller.setAddress();
           
           
            System.currentPageReference().getParameters().put('id', '00*8E000007g6kTQAQ');
            System.currentPageReference().getParameters().put('country', testAcc.LG_VisitCountry__c);
            controller = new LG_AddressValidationController(stdController );
            controller = new LG_AddressValidationController();
            controller.cancel();
        //}
        
    }
}