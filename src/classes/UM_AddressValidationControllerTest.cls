@isTest
public class UM_AddressValidationControllerTest {

    @isTest static void testFindAddress() {

 		Account testAcc = LG_GeneralTest.CreateAccount(
 			'Recaro', 'Customer', 'SoHo', 5, 'Qualified', '049-3220919', '55107192', 'UnityMedia', 'Flughafen Allee', '25', '', '28199', 'Bremen', 'Germany'
 		);

 		UM_WebserviceCredentials__c setting = new UM_WebserviceCredentials__c();
		setting.Name = 'UM_TopasWS';
		setting.Login__c = 'tLogin';
		setting.Password__c = 'tPassword';
		insert setting;

		PageReference pageRef = Page.UM_ValidateAddress;
    	pageRef.getParameters().put('id', testAcc.Id);
    	pageRef.getParameters().put('country', testAcc.LG_VisitCountry__c);
    	pageRef.getParameters().put('returnUrl', '/'+testAcc.Id);

  		Test.setCurrentPageReference(pageRef);

 		Test.startTest();

        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new UM_AddressResponseMock());
        UM_AddressResponseMock.resmth = 'searchext';

        UM_AddressValidationController c = new  UM_AddressValidationController();

        System.assertEquals('Flughafen Allee', c.addressResponse.addressExt.get(0).street);
        System.assertEquals('25', c.addressResponse.addressExt.get(0).streetNo);
        System.assertEquals('28199', c.addressResponse.addressExt.get(0).zip);

        String bid = c.addressResponse.addressExt.get(0).buildingId;
        System.assertEquals('123654', bid);
        
        // actual activation positive test
        c.outsideAddressValidationpage = false;
        c.selectedAddressID = bid;
        c.setAddress();

        //List<Account> checkAdd = [SELECT id, LG_AddressValidated__c FROM Account WHERE id=: testAcc.Id];
        System.assertEquals(true, [SELECT id, LG_AddressValidated__c FROM Account WHERE id=: testAcc.Id].get(0).LG_AddressValidated__c);

        // test cancel btn
        PageReference actPr = c.cancel();
        PageReference pr = new PageReference('/'+testAcc.Id);
        System.assertEquals(pr.getUrl(), c.cancel().getUrl());

        Test.stopTest();
    }

    @isTest static void testFindAddressNoCountry() {

 		Account testAcc = LG_GeneralTest.CreateAccount(
 			'Recaro', 'Customer', 'SoHo', 5, 'Qualified', '049-3220919', '55107192', 'UnityMedia', 'Flughafen Allee', '25', '', '28199', 'Bremen', 'Germany'
 		);

 		UM_WebserviceCredentials__c setting = new UM_WebserviceCredentials__c();
		setting.Name = 'UM_TopasWS';
		setting.Login__c = 'tLogin';
		setting.Password__c = 'tPassword';
		insert setting;

		PageReference pageRef = Page.UM_ValidateAddress;
    	pageRef.getParameters().put('accountId', testAcc.Id);
        pageRef.getParameters().put('country', testAcc.LG_VisitCountry__c);        
    	pageRef.getParameters().put('returnUrl', '/'+testAcc.Id);

  		Test.setCurrentPageReference(pageRef);

 		Test.startTest();

        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new UM_AddressResponseMock());
        UM_AddressResponseMock.resmth = 'searchext';

        UM_AddressValidationController c = new  UM_AddressValidationController();
        system.debug('--+ c: '+c);

        Test.stopTest();
    }

    @isTest static void testFindAddressCountry() {

        Account testAcc = LG_GeneralTest.CreateAccount(
            'Recaro', 'Customer', 'SoHo', 5, 'Qualified', '049-3220919', '55107192', 'UnityMedia', 'Flughafen Allee', '25', '', '28199', 'Bremen', 'Germany'
        );

        UM_WebserviceCredentials__c setting = new UM_WebserviceCredentials__c();
        setting.Name = 'UM_TopasWS';
        setting.Login__c = 'tLogin';
        setting.Password__c = 'tPassword';
        insert setting;

        PageReference pageRef = Page.UM_ValidateAddress;
        pageRef.getParameters().put('accountid', testAcc.Id);
        pageRef.getParameters().put('returnUrl', '/'+testAcc.Id);

        Test.setCurrentPageReference(pageRef);

        Test.startTest();

        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new UM_AddressResponseMock());
        UM_AddressResponseMock.resmth = 'searchext';

        UM_AddressValidationController c = new  UM_AddressValidationController();
        system.debug('--+ c: '+c);

        Test.stopTest();
    }

    @isTest static void testInvalidSetting() {

        Account testAcc = LG_GeneralTest.CreateAccount(
            'Recaro', 'Customer', 'SoHo', 5, 'Qualified', '049-3220919', '55107192', 'UnityMedia', 'Flughafen Allee', '25', '', '28199', 'Bremen', 'Germany'
        );
        cscrm__Address__c testAddr = LG_GeneralTest.crateAddress(
            'New address', 'Flughafen Allee', 'Bremen', '25', '', '28199', 'Germany', testAcc, true
        );

        PageReference pageRef = Page.UM_ValidateAddress;
        pageRef.getParameters().put('id', testAddr.Id);
        pageRef.getParameters().put('isQuickCreatePremise', 'true');
        Test.setCurrentPageReference(pageRef);

        Test.startTest();

        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new UM_AddressResponseMock());
        UM_AddressResponseMock.resmth = 'searchext';
        
        UM_AddressValidationController c = new  UM_AddressValidationController();

        System.assertEquals(true, c.invalidSetting, 'Invalid setting');
        Test.stopTest();
    } 

    @isTest static void testQuickCreatePremise() {

 		Account testAcc = LG_GeneralTest.CreateAccount(
 			'Recaro', 'Customer', 'SoHo', 5, 'Qualified', '049-3220919', '55107192', 'UnityMedia', 'Flughafen Allee', '25', '', '28199', 'Bremen', 'Germany'
 		);
        cscrm__Address__c testAddr = LG_GeneralTest.crateAddress(
            'New address', 'Flughafen Allee', 'Bremen', '25', '', '28199', 'Germany', testAcc, true
        );

        UM_WebserviceCredentials__c setting = new UM_WebserviceCredentials__c();
        setting.Name = 'UM_TopasWS';
        setting.Login__c = 'tLogin';
        setting.Password__c = 'tPassword';
        insert setting;

		PageReference pageRef = Page.UM_ValidateAddress;
    	pageRef.getParameters().put('id', testAddr.Id);
        pageRef.getParameters().put('country', testAcc.LG_VisitCountry__c);
        pageRef.getParameters().put('isQuickCreatePremise', 'true');
        pageRef.getParameters().put('returnUrl', '/'+testAcc.Id);
  		Test.setCurrentPageReference(pageRef);

 		Test.startTest();

        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new UM_AddressResponseMock());
        UM_AddressResponseMock.resmth = 'searchext';
        
        UM_AddressValidationController c = new  UM_AddressValidationController();
        
        // actual activation positive test
        c.outsideAddressValidationpage = false;
        c.selectedAddressID = '123456';

        testAddr.LG_AddressID__c = '123456';
        upsert testAddr;

        c.setAddress();

        Test.stopTest();
    } 

}