@isTest
private class LG_PortingNumbersControllerTest {
    
    private static String vfBaseUrl = 'vforce.url';
    private static String sfdcBaseUrl = 'sfdc.url';
    
    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        LG_EnvironmentVariables__c envVariables = new LG_EnvironmentVariables__c();
        envVariables.LG_SalesforceBaseURL__c = sfdcBaseUrl;
        envVariables.LG_VisualForceBaseURL__c = vfBaseUrl;
        envVariables.LG_CloudSenceAnywhereIconID__c = 'csaID';
        envVariables.LG_ServiceAvailabilityIconID__c = 'saIconId';
        insert envVariables;
        
        Account account = LG_GeneralTest.CreateAccount('AccountSFDT-58', '12345678', 'Ziggo', true);
                
        Opportunity opp = LG_GeneralTest.CreateOpportunity(account, true);
        
        cscfga__Product_Basket__c basket = LG_GeneralTest.createProductBasket('BAsket58', account, null, opp, false);
        basket.csbb__Account__c = account.Id;
        insert basket;
        
        cscfga__Product_Definition__c prodDef = LG_GeneralTest.createProductDefinition('ProdDef58', true);
        
        cscfga__Product_Configuration__c prodConf = LG_GeneralTest.createProductConfiguration('ProdConf58', 3, basket, prodDef, false);
        prodConf.LG_PortIn__c = true;
        prodConf.LG_MaximumQuantity__c = 20;
        insert prodConf;
        
        LG_PortingNumber__c tmpPortingNumber = new LG_PortingNumber__c();
        tmpPortingNumber.LG_FirstPhoneNumber__c = '345';
        tmpPortingNumber.LG_LastPhoneNumber__c = '345';
        tmpPortingNumber.LG_Operator__c = 'KLN';
        tmpPortingNumber.LG_PhoneNumber__c = '345';
        tmpPortingNumber.LG_PortingDate__c = Date.today();
        tmpPortingNumber.LG_PrimaryNumber__c = '345';
        tmpPortingNumber.LG_Type__c = 'SB Telephony';
        tmpPortingNumber.LG_Opportunity__c = null;
        tmpPortingNumber.LG_ProductConfiguration__c = prodConf.Id;
        insert tmpPortingNumber;
        
        noTriggers.Flag__c = false;
        upsert noTriggers;
    }
    
    private static testmethod void testRedirectToBasket()
    {
        cscfga__Product_Basket__c basket = [SELECT Id FROM cscfga__Product_Basket__c WHERE Name = 'BAsket58'];
        
        PageReference pageRef = Page.LG_PortingNumbers;
        pageRef.getParameters().put('basketId', basket.Id);
        Test.setCurrentPageReference(pageRef);
        
        Test.startTest();
        
            LG_PortingNumbersController controller = new LG_PortingNumbersController();
            pageRef = controller.redirectToBasket();
            
        Test.stopTest();
        
        System.assertEquals(vfBaseUrl + '/apex/BasketbuilderApp?Id='+basket.Id, pageRef.getUrl(),
                            'Url should be ' + vfBaseUrl + '/apex/BasketbuilderApp?Id='+basket.Id); 
    }
    
    private static testmethod void testUploadButtonVisibility()
    {
        Test.startTest();
            LG_PortingNumbersController controller = new LG_PortingNumbersController();
                    
            System.assertEquals(true, controller.uploadButtonVisible, 'Upload Button should be visible by default');
            
            LG_PortingNmbrsSiteComponentController compController = new LG_PortingNmbrsSiteComponentController();
            compController.pageController = controller;
            compController.prodConfigId = 'dummyId';
            compController.resetData(true);
            
            LG_PortingNmbrsSiteComponentController.cImportFileRow importedRow = new LG_PortingNmbrsSiteComponentController.cImportFileRow();
            compController.lstImportFileRow.add(importedRow);
            
            controller.componentControllers.add(compController);
            
            System.assertEquals(false, controller.uploadButtonVisible, 'Upload Button should be hidden when there are some imported rows.');
        Test.stopTest();
    }
    
    private static testmethod void testInsertButtonVisibility()
    {
        Test.startTest();
        
            LG_PortingNumbersController controller = new LG_PortingNumbersController();
                    
            System.assertEquals(false, controller.insertButtonVisible, 'Insert Button should not be visible by default');
            
            LG_PortingNmbrsSiteComponentController compController = new LG_PortingNmbrsSiteComponentController();
            compController.pageController = controller;
            compController.prodConfigId = 'dummyId';
            compController.resetData(true);
            
            LG_PortingNmbrsSiteComponentController.cImportFileRow importedRow = new LG_PortingNmbrsSiteComponentController.cImportFileRow();
            compController.lstImportFileRow.add(importedRow);
            compController.fileIsValid = true;
            
            controller.componentControllers.add(compController);
            
            System.assertEquals(true, controller.insertButtonVisible, 'Insert Button should be visible when there are valid rows for insertion');
            
        Test.stopTest();
    }
    
    private static testmethod void testDiscardButtonVisibility()
    {
        Test.startTest();
        
            LG_PortingNumbersController controller = new LG_PortingNumbersController();
                    
            System.assertEquals(false, controller.discardButtonVisible, 'Discard Button should not be visible by default');
            
            LG_PortingNmbrsSiteComponentController compController = new LG_PortingNmbrsSiteComponentController();
            compController.pageController = controller;
            compController.prodConfigId = 'dummyId';
            compController.resetData(true);
            
            LG_PortingNmbrsSiteComponentController.cImportFileRow importedRow = new LG_PortingNmbrsSiteComponentController.cImportFileRow();
            compController.lstImportFileRow.add(importedRow);
            
            controller.componentControllers.add(compController);
            
            System.assertEquals(true, controller.discardButtonVisible, 'Discard Button should be visible when there are some imported rows');
            
        Test.stopTest();
    }
    
    private static testmethod void testGetPageController()
    {       
        LG_PortingNumbersController controller = new LG_PortingNumbersController();
                
        System.assertEquals(controller, controller.getPageController(), 'Method should return the controller instance');
    }
    
    private static testmethod void testUploadValidateFile()
    {
        Test.startTest();
        
            LG_PortingNumbersController controller = new LG_PortingNumbersController();
            
            LG_PortingNmbrsSiteComponentController compController = new LG_PortingNmbrsSiteComponentController();
            compController.pageController = controller;
            compController.prodConfigId = 'dummyId';
            compController.resetData(true);
            compController.fileName='Tel test';
            
            String filecsv = 'Wensdatum portering,Hoofdnummer,Operator (telecomprovider),Enkelvoudige nummers,(of),Nummerblokken (reeks/blok van 10 /100 /1000 nummers):,,nummer\n';
            filecsv += '24-05-2015,12334454,KNL,,,34343430,t/m,34343439';
            filecsv += '25-05-2015,1233445,KNL,123434343,,,t/m,';
            filecsv += '25-05-2015,12334489,XYZ,,,678999990,t/m,678999999';
            filecsv += '27-05-2015,767676,ABC,7676767676,,,t/m,';
            
            compController.fileBody = Blob.valueof(filecsv);            
            controller.componentControllers.add(compController);
            
            System.assertEquals(null, controller.uploadValidateFile(), 'PageReferenceReturned should be null');
            System.assertEquals(true, controller.discardButtonVisible, 'There should be some imported rows');
        
        Test.stopTest();
    }
    
    private static testmethod void testDiscardUploadedRecords()
    {       
        Test.startTest();
        
            LG_PortingNumbersController controller = new LG_PortingNumbersController();
            
            LG_PortingNmbrsSiteComponentController compController = new LG_PortingNmbrsSiteComponentController();
            compController.pageController = controller;
            compController.prodConfigId = 'dummyId';
            compController.resetData(true);
            compController.fileName='Tel test';
            
            String filecsv = 'Wensdatum portering,Hoofdnummer,Operator (telecomprovider),Enkelvoudige nummers,(of),Nummerblokken (reeks/blok van 10 /100 /1000 nummers):,,nummer\n';
            filecsv += '24-05-2015,12334454,KNL,,,34343430,t/m,34343439';
            filecsv += '25-05-2015,1233445,KNL,123434343,,,t/m,';
            filecsv += '25-05-2015,12334489,XYZ,,,678999990,t/m,678999999';
            filecsv += '27-05-2015,767676,ABC,7676767676,,,t/m,';
            
            compController.fileBody = Blob.valueof(filecsv);            
            controller.componentControllers.add(compController);
            
            System.assertEquals(null, controller.discardUploadedRecords(), 'PageReferenceReturned should be null');
            System.assertEquals(true, controller.uploadButtonVisible, 'There should not be any uploaded rows anymore, so upload button is visible');
            System.assertEquals(false, controller.discardButtonVisible, 'There should not be any uploaded rows anymore, so dicard button is not visible');
        
        Test.stopTest();
    }
    
    private static testmethod void testInsertRecords()
    {
        cscfga__Product_Configuration__c prodConf = [SELECT Id FROM cscfga__Product_Configuration__c WHERE Name = 'ProdConf58'];
        
        Test.startTest();
        
            LG_PortingNumbersController controller = new LG_PortingNumbersController();
            
            LG_PortingNmbrsSiteComponentController compController = new LG_PortingNmbrsSiteComponentController();
            compController.pageController = controller;
            compController.prodConfigId = prodConf.Id;
            compController.resetData(true);
            compController.fileIsValid = true;
            controller.componentControllers.add(compController);
            
        	String portingDate = System.today().format();
        
            LG_PortingNmbrsSiteComponentController.cImportFileRow importedRow = new LG_PortingNmbrsSiteComponentController.cImportFileRow();
            importedRow.firstPhoneNumber = '0123';
            importedRow.lastPhoneNumber = '0123';
            importedRow.operator = 'KLN';
            importedRow.phoneNumber = '0123';
            importedRow.portingDate = portingDate;
            importedRow.primaryNumber = '0234';
            
            LG_PortingNmbrsSiteComponentController.cImportFileRow importedRow2 = new LG_PortingNmbrsSiteComponentController.cImportFileRow();
            importedRow2.firstPhoneNumber = '01232';
            importedRow2.lastPhoneNumber = '01232';
            importedRow2.operator = 'KLN2';
            importedRow2.phoneNumber = '01232';
            importedRow2.portingDate = portingDate;
            importedRow2.primaryNumber = '02342';
            
            compController.lstImportFileRow.add(importedRow);
            compController.lstImportFileRow.add(importedRow2);
            
            controller.insertRecords();
        Test.stopTest();
        
        List<LG_PortingNumber__c> portingNumbers = [SELECT Id FROM LG_PortingNumber__c WHERE LG_ProductConfiguration__c = :prodConf.Id];
        
    }
}