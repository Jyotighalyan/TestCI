@isTest
public class LG_TelephonePortingControllerTest
{
	static cscfga__Product_Basket__c BuildProductBasketForOpportunity(Opportunity tmpOpportunity,  Contact tmpContact)
	{
		
		cscfga__Product_Basket__c tmpProductBasket = LG_GeneralTest.createProductBasket('Test Basket',null,null,tmpOpportunity);
		if (tmpContact!=null)
			tmpProductBasket.LG_AdminContactPicklist__c=string.valueOf(tmpContact.Id);
		
		
		tmpProductBasket.LG_AdminContactDateofBirth__c=date.newinstance(1960, 2, 17);
		tmpProductBasket.LG_AdminContactEmail__c='davor.dubokovic@cloudsense.com.test';
		tmpProductBasket.LG_AdminContactFirstName__c='Davor';
		tmpProductBasket.LG_AdminContactLastName__c='Dubokovic';
		tmpProductBasket.LG_AdminContactMiddleName__c='';
		tmpProductBasket.LG_AdminContactMobile__c='0299 654647';
		tmpProductBasket.LG_AdminContactPhone__c='0299 654648';
		
		tmpProductBasket.LG_AdminContactSalutation__c='Mr.';
		tmpProductBasket.LG_BankAccountName__c='MR DD';
		tmpProductBasket.LG_BankNumber__c='NL10zlam2503800483';
		tmpProductBasket.LG_BillingCity__c='MONNICKENDAM';
		tmpProductBasket.LG_BillingCountry__c='Netherlands';
		tmpProductBasket.LG_BillingHouseNumber__c='24';
		tmpProductBasket.LG_BillingHouseNumberExtension__c='A';
		tmpProductBasket.LG_BillingPostalCode__c='1141 KG';
		tmpProductBasket.LG_BillingSameAsInstallationAddress__c=false;
		tmpProductBasket.LG_BillingStreet__c='Boing';
		tmpProductBasket.LG_COAXConnectionLocation__c='';
		tmpProductBasket.LG_CreatedFrom__c='Tablet';
		tmpProductBasket.LG_CustomerReference__c='ABC123';
		tmpProductBasket.LG_InstallationCity__c='Amsterdam';
		tmpProductBasket.LG_InstallationCountry__c='Netherlands';
		tmpProductBasket.LG_InstallationHouseNumber__c='1';
		tmpProductBasket.LG_InstallationHouseNumberExtension__c='A';
		tmpProductBasket.LG_InstallationPostalCode__c='1141 GV';
		tmpProductBasket.LG_InstallationStreet__c='Boing';
		tmpProductBasket.LG_InstallValidationResult__c='Valid';
		tmpProductBasket.LG_MainReasonLost__c='Delivery';
		tmpProductBasket.LG_PaymentType__c='Bank Transfer';
		tmpProductBasket.LG_PostalCity__c='Amsterdam';
		tmpProductBasket.LG_PostalCountry__c='Netherlands';
		tmpProductBasket.LG_PostalHouseNumber__c='1';
		tmpProductBasket.LG_PostalHouseNumberExtension__c='A';
		tmpProductBasket.LG_PostalPostalCode__c='1141 GV';
		tmpProductBasket.LG_PostalSameAsInstallationAddress__c=false;
		tmpProductBasket.LG_PostalStreet__c='Boing';
		tmpProductBasket.LG_PreferredInstallationDate__c=date.newinstance(2020, 2, 17);
		tmpProductBasket.LG_PreferredInstallationTime__c='18.00 - 21.00';
		tmpProductBasket.LG_ResultofVisit__c='Quote Requested';
		tmpProductBasket.LG_SameAsAdminContact__c=false;
		tmpProductBasket.LG_SBTelephonyId__c='';
		tmpProductBasket.LG_SharedOfficeBuilding__c=false;
		tmpProductBasket.LG_TechContactSameasBillingContact__c=false;
		tmpProductBasket.LG_TechnicalContactDateofBirth__c=date.newinstance(1990, 2, 17);
		tmpProductBasket.LG_TechnicalContactEmail__c='davor.dubokovic@cloudsense.com.test';
		tmpProductBasket.LG_TechnicalContactFirstName__c='John 1';
		tmpProductBasket.LG_TechnicalContactLastName__c='De Vries 2';
		tmpProductBasket.LG_TechnicalContactMiddleName__c='';
		tmpProductBasket.LG_TechnicalContactMobile__c='0299 654647';
		tmpProductBasket.LG_TechnicalContactPhone__c='0299 654642';
		tmpProductBasket.LG_TechnicalContactPicklist__c='(new Contact)';
		tmpProductBasket.LG_TechnicalContactSalutation__c='Mr.';
		tmpProductBasket.LG_ValidationDate__c=date.today();
		tmpProductBasket.LG_VisitDescription__c='All OK';
		
		update tmpProductBasket;
		
		return tmpProductBasket;
	}
	
	
	
	static testMethod void TestTelephonePortingController()
    {
    	
    	No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = false;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
  
        //generate Account
        Account tmpAccount = LG_GeneralTest.CreateAccount('Stichting Statenkliniek','Customer','SoHo',5,'Qualified','070-3220919','55107192','Ziggo','Frankenslag','357',
        	'A','2582 HP','MONNICKENDAM','Netherlands');
        
        
        Opportunity Opp=LG_GeneralTest.CreateOpportunity(tmpAccount,true);
        
        Contact tmpContact = LG_GeneralTest.CreateContact(tmpAccount,'Johan','De Vries','Mr.','06-55932220','','johan.devries@test.com','Business User',
        	date.newinstance(1960, 2, 17),'MONNICKENDAM','Netherlands','1141 AZ','HAVEN 14');
        
        OpportunityContactRole optcntrole = new OpportunityContactRole();
        optcntrole.ContactId=tmpContact.Id;
        optcntrole.IsPrimary=true;
        optcntrole.OpportunityId=Opp.Id;
        optcntrole.Role='Business User';
        insert optcntrole;
        

		//generate Discounts
		LG_Discount__c tmpDiscountClosingDeal = LG_GeneralTest.createDiscount(30,'SOHO','Discount Reduced Value',24,'ABC123',
			'8 maanden €30 ipv 5 maanden €30 voor pakket.','Closing Deal',8);
		
		LG_Discount__c tmpDiscountPromotionalAction = LG_GeneralTest.createDiscount(30,'SOHO','Discount Reduced Value',24,'ABC123',
			'8 maanden €30 ipv 5 maanden €30 voor pakket.','Promotional Action',8);

		LG_Discount__c tmpDiscount = LG_GeneralTest.createDiscount(30,'SOHO','Discount Reduced Value',24,'ABC123',
			'8 maanden €30 ipv 5 maanden €30 voor pakket.','Discount',8);

		cscfga__Product_Category__c prodCategory = LG_GeneralTest.createProductCategory('Test Category', true);

		//generate Product Definition
		cscfga__Product_Definition__c tmpProductDefinition = LG_GeneralTest.createProductDefinition('ZZP Internet', false);
        tmpProductDefinition.cscfga__Product_Category__c = prodCategory.Id;
        insert tmpProductDefinition;
		
		//generate Attribute Definitions
		//string name, cscfga__Product_Definition__c productDef, string AttribType, string DataType,
    	//string OPTKey, string OLIType, string ProductDetailType
		
		
		cscfga__Attribute_Definition__c attdefTotalBasicPrice = LG_GeneralTest.createAttributeDefinition('Total Basic Price',tmpProductDefinition, 'Calculation',
			'Decimal','','Main OLI','');
		
		cscfga__Attribute_Definition__c attdefAdditionalDiscount = LG_GeneralTest.createAttributeDefinition('Additional Discount',tmpProductDefinition, 'Lookup',
			'String','','Promotional Action','');
			
		cscfga__Attribute_Definition__c attdefClosingDealDiscount = LG_GeneralTest.createAttributeDefinition('Closing Deal Discount',tmpProductDefinition, 'Lookup',
			'String','','Closing Deal','');

		cscfga__Attribute_Definition__c attdefDiscount = LG_GeneralTest.createAttributeDefinition('Discount',tmpProductDefinition, 'Lookup',
			'String','','Promotional Discount','');	

		cscfga__Attribute_Definition__c attdefUploadSpeed = LG_GeneralTest.createAttributeDefinition('UP Speed',tmpProductDefinition, 'Calculation',
			'Integer','Upload Speed','','Order Detail');

		cscfga__Attribute_Definition__c attdefContractTerm = LG_GeneralTest.createAttributeDefinition('Contract Term',tmpProductDefinition, 'Select List',
			'Integer','','','Contract Term');

		cscfga__Attribute_Definition__c attdefInternetSpeed = LG_GeneralTest.createAttributeDefinition('Internet Speed',tmpProductDefinition, 'Calculation',
			'String','Internet','','Bundle Detail');

		cscfga__Attribute_Definition__c attdefPortingJSON = LG_GeneralTest.createAttributeDefinition('Porting JSON',tmpProductDefinition, 'User Input',
			'String','','','JSON Porting Mobile Telephony');

		cscfga__Attribute_Definition__c attdefPortingJSON2 = LG_GeneralTest.createAttributeDefinition('Porting JSON2',tmpProductDefinition, 'User Input',
			'String','','','JSON Porting SOHO Telephony');

		
		cscfga__Product_Basket__c tmpProductBasket = BuildProductBasketForOpportunity(Opp,tmpContact);
		tmpProductBasket.LG_ResultofVisit__c='Customer Approved';
		tmpProductBasket.cscfga__Opportunity__c=Opp.Id;
		update tmpProductBasket;
		

		cscfga__Product_Configuration__c pcInternet = LG_GeneralTest.createProductConfiguration('ZZP Internet', 24, tmpProductBasket, tmpProductDefinition);
        
        cscfga__Attribute__c attTotalBasicPrice = LG_GeneralTest.createAttribute('Total Basic Price',attdefTotalBasicPrice,true,0,pcInternet,false,
        	string.valueof(tmpDiscountPromotionalAction.Id),false);
        	
        cscfga__Attribute__c attAdditionalDiscount = LG_GeneralTest.createAttribute('Additional Discount',attdefAdditionalDiscount,false,0,pcInternet,false,'',false);
        
        cscfga__Attribute__c attClosingDealDiscount = LG_GeneralTest.createAttribute('Closing Deal Discount',attdefClosingDealDiscount,false,0,pcInternet,false,'',false);

        cscfga__Attribute__c attDiscount = LG_GeneralTest.createAttribute('Discount',attdefDiscount,true,0,pcInternet,false,string.valueof(tmpDiscount.Id),false);

		cscfga__Attribute__c attUploadSpeed = LG_GeneralTest.createAttribute('UP Speed',attdefUploadSpeed,false,0,pcInternet,false,'30',false);
		
		cscfga__Attribute__c attContractTerm = LG_GeneralTest.createAttribute('Contract Term',attdefContractTerm,false,0,pcInternet,false,'24',false);
        
        cscfga__Attribute__c attInternetSpeed = LG_GeneralTest.createAttribute('Internet Speed',attdefInternetSpeed,false,0,pcInternet,false,'130 / 30 MBit / s Internet',false);
        
        string JSONPortingValue = '[{"simType":"port number","contractType":"zakelijk","currentNumber":"0123456789","currentProvider":"AH Mobile","simNumber":"123","dateOfPorting":"2015-07-01","template":"","sectionId":"appendDiv1","sectionName":"Zakelijk Voldoende"}]';
        
        cscfga__Attribute__c attPortingJSON = LG_GeneralTest.createAttribute('Porting JSON',attdefPortingJSON,false,0,pcInternet,false,JSONPortingValue,false);
        
        string JSONPortingValue2 = '{"Existing_Phone_Numbers_0":true,"Telephone_Number_0":"0123456789","In_The_Name_Of_0":"Test","Telephone_Provider_0":"12CO","Listing_In_The_Directory_0":"als tel","Extra_Line_Porting_Number_0":"","Extra_Line_Telephone_Number_0":"","Extra_Line_In_The_Name_Of_0":"","Extra_Line_Telephone_Provider_0":"","Extra_Line_Listing_In_The_Directory_0":""}';
        
        cscfga__Attribute__c attPortingJSON2 = LG_GeneralTest.createAttribute('Porting JSON2',attdefPortingJSON2,false,0,pcInternet,false,JSONPortingValue2,false);
        
        list<cscfga__Attribute__c> lstAtt = new list<cscfga__Attribute__c>();
        lstAtt.add(attTotalBasicPrice);
        lstAtt.add(attAdditionalDiscount);
        lstAtt.add(attClosingDealDiscount);
        lstAtt.add(attDiscount);
        lstAtt.add(attUploadSpeed);
        lstAtt.add(attContractTerm);
        lstAtt.add(attInternetSpeed);
        lstAtt.add(attPortingJSON);
        lstAtt.add(attPortingJSON2);
        
        insert lstAtt;
        
        system.debug('*****start testing');
        tmpProductBasket.csordtelcoa__Synchronised_with_Opportunity__c=true;
        update tmpProductBasket;
        
        system.debug('***tmpProductBasket=' + tmpProductBasket);
        system.debug('***attUploadSpeed=' + attUploadSpeed);
        system.debug('***pcInternet=' + pcInternet);
        
        
    	
    	Test.startTest();
    	PageReference tpcPage = new PageReference('/apex/LG_TelephonePorting?PCId=' + pcInternet.Id);
    	Test.setCurrentPage(tpcPage);
    	
    	LG_TelephonePortingController tpc = new LG_TelephonePortingController();
    	tpc.fileName='Tel test';
    	string filecsv='Wensdatum portering,Hoofdnummer,Operator (telecomprovider),Enkelvoudige nummers,(of),Nummerblokken (reeks/blok van 10 /100 /1000 nummers):,,nummer\n';
    	filecsv+='24.05.2015,12334454,KNL,,,34343430,t/m,34343439';
    	filecsv+='25.05.2015,1233445,KNL,123434343,,,t/m,';
    	filecsv+='25.05.2015,12334489,XYZ,,,678999990,t/m,678999999';
    	filecsv+='27.05.2015,767676,ABC,7676767676,,,t/m,';
    	
    	tpc.fileBody=Blob.valueof(filecsv);
    	
    	tpc.UploadValidateFile();
    	//Boolean Btn = tpc.getDiscardButtonVisible();
    	tpc.InsertRecords();
    	tpc.DiscardUploadedRecords();
    	
    	
    	
    	
    	Test.stopTest();
    }
}