/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Unit Test for use in Salesforce Kenan Connection Service
*/
@isTest
private class KenanServiceMapperTest {
	
	@testSetup
	static void setup() {
		KenanServiceConnection__c settings = new KenanServiceConnection__c(
			Authentication_Token__c = 'Basic YWRtaW46YWRtaW4=',
			Session_Timeout__c = '120000',
			Connection_URL__c = 'https://kenan-dev-pubelb-amdocs-1924041402.eu-central-1.elb.amazonaws.com',
			REST_Application_Base__c = '/kenan-salesforce-api/rest',
			Stored_Language_Code__c = '1'
		);

		insert settings;
	}
	
	@isTest
	static void getEnumeratedValuesTest(){
		KenanServiceConnection__c settings = KenanServiceConnection__c.getInstance();
		KenanService service = new KenanService();
		Datetime curDate = Datetime.now();
		       
        service.activeDt = curDate;
        service.address1 = 'address1'; 
        service.address2 = 'address2';
        service.address3 = 'address3';
        service.address4 = 'address4';
        service.addressLocation = 1;
        service.addressTypeId = 'Not Free-form'; 
        service.bendAddressId = 1;
        service.bserviceCompany = 'bserviceCompany';
        service.bserviceFname = 'bserviceFname';
		service.bserviceFranchiseTaxCode = 1;
        service.bserviceGeocode = 'bserviceGeocode';
        service.bserviceLname = 'bserviceLname';
        service.bserviceMinit = 'bserviceMinit';
        service.bservicePhone = 'bservicePhone';
        service.bservicePhone2 = 'bservicePhone2';
        service.changeDt = curDate; 
    	service.changeWho = 'changeWho';
    	service.chgDt = curDate; 
    	service.chgWho = 'chgWho';     
        service.city = 'city';
        service.codeword = 'codeword';
		service.converted = 1;
        service.countryCode = 'Reserved - No Country'; 
        service.county = 'county';
		service.createDt = curDate;
        service.currencyCode = 'KRW'; 
        service.displayAddressId = 1;
        service.displayCiemViewId = 1;
        service.displayExternalIdType = 1;
		service.eligKey1 = 1;
		service.eligKey2 = 1;
		service.eligKey3 = 1;
        service.emfConfigId = 1;
        service.exrateClass = 1;
        service.extendedPostalCode = 'extendedPostalCode';
        service.externalAddressId = 'externalAddressId';
  		service.franchiseTaxCode = 1;      
        service.fxGeocode = 'fxGeocode';
        service.houseNumber = 'houseNumber';
        service.houseNumberSuffix = 'houseNumberSuffix';
        service.intendedViewEffectiveDt = curDate;
		service.isActive = true;
        service.isPrepaid = true;
        service.ixcProviderId = 1;
        service.keyLineCode = 'keyLineCode';
        service.lecProviderId = 1;
        service.nearestCrossstreet = 'nearestCrossstreet';
        service.noBill = true;
        service.nonpubNonlist = 1;
        service.optionalEndorsementLine = 'optionalEndorsementLine';
        service.parentAccountInternalId = 123456;
		service.picDateActive = curDate;       
        service.popUnits = 2;
        service.postalCode = 'postalCode';
        service.postfixDirectional = 'postfixDirectional';
        service.postnetAddressBlockBarcode = 'postnetAddressBlockBarcode';
        service.postnetBarcode = 'postnetBarcode';
        service.prefixDirectional = 'prefixDirectional';
		service.prevViewId = 1;
        service.privacyLevel = 'No mask'; 
        service.rateClass = 1;
        service.restrictedPic = 1;
        service.revRcvCostCtr = 1;
        service.salesChannelId = 'Sales Channel 1'; 
        service.serviceActiveDt = curDate; 
        service.serviceCompany = 'serviceCompany';
        service.serviceFname = 'serviceFname'; 
        service.serviceFranchiseTaxCode = 1; 
        service.serviceGeocode = 'serviceGeocode'; 
        service.serviceInactiveDt = curDate;
        service.serviceInternalId = 987654; 
        service.serviceInternalIdResets = 1; 
        service.serviceLname = 'serviceLname'; 
        service.serviceMinit = 'serviceMinit'; 
        service.serviceNameGeneration = 'serviceNameGeneration'; 
        service.serviceNamePre = 'serviceNamePre';
        service.servicePhone = 'servicePhone'; 
        service.servicePhone2 = 'servicePhone2'; 
        service.simSerialNumber = 'simSerialNumber';
        service.state = 'state'; 
        service.statusId = 1; 
        service.statusReasonId = 1;
        service.streetName = 'streetName'; 
        service.streetSuffix = 'streetSuffix'; 
        service.switchId = 'switchId'; 
        service.timezone = 'UTC (GMT) Time Zone';
        service.unitNo = 'unitNo'; 
        service.unitType = 'unitType'; 
        service.vertexGeocode = 'vertexGeocode'; 
        service.viewCreatedDt = curDate; 
		service.viewEffectiveDt = curDate;
		service.viewId = 1;
		service.viewStatus = 1;

        service.waiveInstallmentNrc = KenanEnumerationHelper.getDefaultEnumDisplayValue('WaiveInstallmentNRCOption__mdt', settings.Stored_Language_Code__c, 'MasterLabel');
        service.waiveUnbilledNrc = KenanEnumerationHelper.getDefaultEnumDisplayValue('WaiveUnBilledNRCOption__mdt', settings.Stored_Language_Code__c, 'MasterLabel');
        service.waiveTerminationObligation = KenanEnumerationHelper.getDefaultEnumDisplayValue('WaiveTerminationObligationOption__mdt', settings.Stored_Language_Code__c, 'MasterLabel');
        service.waiveUnmetObligation = KenanEnumerationHelper.getDefaultEnumDisplayValue('WaiveUnmetObligationOption__mdt', settings.Stored_Language_Code__c, 'MasterLabel');
        service.waiveRefinanceNrc = KenanEnumerationHelper.getDefaultEnumDisplayValue('WaiveRefinanceNRCOption__mdt', settings.Stored_Language_Code__c, 'MasterLabel');

		service.extData = new Map<String, Object>();
        service.extData.put('1', 1);
        
        Map<String, String> extIdMap = new Map<String, String>();
        extIdMap.put('1', '1');

        service.extIdList = new List<Map<String, String>>();
        service.extIdList.add(extIdMap);

		Test.startTest();
		KenanServiceMapper mapper = new KenanServiceMapper();
		Map<String,Object> objectMap = mapper.getEnumeratedValues(service);
		Test.stopTest();
				
		System.assertEquals(objectMap.get('activeDt'), curDate, '');
        System.assertEquals(objectMap.get('address1'), 'address1', ''); 
        System.assertEquals(objectMap.get('address2'), 'address2', '');
        System.assertEquals(objectMap.get('address3'), 'address3', '');
        System.assertEquals(objectMap.get('address4'), 'address4', '');
        System.assertEquals(objectMap.get('addressLocation'), 1, '');
        System.assertEquals(objectMap.get('addressTypeId'), '1', '');
        System.assertEquals(objectMap.get('bendAddressId'), 1, '');
        System.assertEquals(objectMap.get('bserviceCompany'), 'bserviceCompany', '');
        System.assertEquals(objectMap.get('bserviceFname'), 'bserviceFname', '');
		System.assertEquals(objectMap.get('bserviceFranchiseTaxCode'), 1, '');
        System.assertEquals(objectMap.get('bserviceGeocode'), 'bserviceGeocode', '');
        System.assertEquals(objectMap.get('bserviceLname'), 'bserviceLname', '');
        System.assertEquals(objectMap.get('bserviceMinit'), 'bserviceMinit', '');
        System.assertEquals(objectMap.get('bservicePhone'), 'bservicePhone', '');
        System.assertEquals(objectMap.get('bservicePhone2'), 'bservicePhone2', '');
        System.assertEquals(objectMap.get('changeDt'), curDate, '');
    	System.assertEquals(objectMap.get('changeWho'), 'changeWho', '');
    	System.assertEquals(objectMap.get('chgDt'), curDate, '');
    	System.assertEquals(objectMap.get('chgWho'), 'chgWho', '');     
        System.assertEquals(objectMap.get('city'), 'city', '');
        System.assertEquals(objectMap.get('codeword'), 'codeword', '');
		System.assertEquals(objectMap.get('converted'), 1, '');
        System.assertEquals(objectMap.get('countryCode'), '0', '');
        System.assertEquals(objectMap.get('county'), 'county', '');
		System.assertEquals(objectMap.get('createDt'), curDate, '');
        System.assertEquals(objectMap.get('currencyCode'), '10', ''); 
        System.assertEquals(objectMap.get('displayAddressId'), 1, '');
        System.assertEquals(objectMap.get('displayCiemViewId'), 1, '');
        System.assertEquals(objectMap.get('displayExternalIdType'), 1, '');
		System.assertEquals(objectMap.get('eligKey1'), 1, '');
		System.assertEquals(objectMap.get('eligKey2'), 1, '');
		System.assertEquals(objectMap.get('eligKey3'), 1, '');
        System.assertEquals(objectMap.get('emfConfigId'), 1, '');
        System.assertEquals(objectMap.get('exrateClass'), 1, '');
        System.assertEquals(objectMap.get('extendedPostalCode'), 'extendedPostalCode', '');
        System.assertEquals(objectMap.get('externalAddressId'), 'externalAddressId', '');
  		System.assertEquals(objectMap.get('franchiseTaxCode'), 1, '');      
        System.assertEquals(objectMap.get('fxGeocode'), 'fxGeocode', '');
        System.assertEquals(objectMap.get('houseNumber'), 'houseNumber', '');
        System.assertEquals(objectMap.get('houseNumberSuffix'), 'houseNumberSuffix', '');
        System.assertEquals(objectMap.get('intendedViewEffectiveDt'), curDate, '');
		System.assertEquals(objectMap.get('isActive'), true, '');
        System.assertEquals(objectMap.get('isPrepaid'), true, '');
        System.assertEquals(objectMap.get('ixcProviderId'), 1, '');
        System.assertEquals(objectMap.get('keyLineCode'), 'keyLineCode', '');
        System.assertEquals(objectMap.get('lecProviderId'), 1, '');
        System.assertEquals(objectMap.get('nearestCrossstreet'), 'nearestCrossstreet', '');
        System.assertEquals(objectMap.get('noBill'), true, '');
        System.assertEquals(objectMap.get('nonpubNonlist'), 1, '');
        System.assertEquals(objectMap.get('optionalEndorsementLine'), 'optionalEndorsementLine', '');
        System.assertEquals(objectMap.get('parentAccountInternalId'), 123456, '');
		System.assertEquals(objectMap.get('picDateActive'), curDate, '');        
        System.assertEquals(objectMap.get('popUnits'), 2, '');
        System.assertEquals(objectMap.get('postalCode'), 'postalCode', '');
        System.assertEquals(objectMap.get('postfixDirectional'), 'postfixDirectional', '');
        System.assertEquals(objectMap.get('postnetAddressBlockBarcode'), 'postnetAddressBlockBarcode', '');
        System.assertEquals(objectMap.get('postnetBarcode'), 'postnetBarcode', '');
        System.assertEquals(objectMap.get('prefixDirectional'), 'prefixDirectional', '');
		System.assertEquals(objectMap.get('prevViewId'), 1, '');
        System.assertEquals(objectMap.get('privacyLevel'), '0', '');
        System.assertEquals(objectMap.get('rateClass'), 1, '');
        System.assertEquals(objectMap.get('restrictedPic'), 1, '');
        System.assertEquals(objectMap.get('revRcvCostCtr'), 1, '');
        System.assertEquals(objectMap.get('salesChannelId'), '1', '');
        System.assertEquals(objectMap.get('serviceActiveDt'), curDate, '');
        System.assertEquals(objectMap.get('serviceCompany'), 'serviceCompany', '');
        System.assertEquals(objectMap.get('serviceFname'), 'serviceFname', '');
        System.assertEquals(objectMap.get('serviceFranchiseTaxCode'), 1, '');
        System.assertEquals(objectMap.get('serviceGeocode'), 'serviceGeocode', '');
        System.assertEquals(objectMap.get('serviceInactiveDt'), curDate, '');
        System.assertEquals(objectMap.get('serviceInternalId'), 987654, '');
        System.assertEquals(objectMap.get('serviceInternalIdResets'), 1, '');
        System.assertEquals(objectMap.get('serviceLname'), 'serviceLname', '');
        System.assertEquals(objectMap.get('serviceMinit'), 'serviceMinit', '');
        System.assertEquals(objectMap.get('serviceNameGeneration'), 'serviceNameGeneration', '');
        System.assertEquals(objectMap.get('serviceNamePre'), 'serviceNamePre', '');
        System.assertEquals(objectMap.get('servicePhone'), 'servicePhone', '');
        System.assertEquals(objectMap.get('servicePhone2'), 'servicePhone2', '');
        System.assertEquals(objectMap.get('simSerialNumber'), 'simSerialNumber', '');
        System.assertEquals(objectMap.get('state'), 'state', '');
        System.assertEquals(objectMap.get('statusId'), 1, '');
        System.assertEquals(objectMap.get('statusReasonId'), 1, '');
        System.assertEquals(objectMap.get('streetName'), 'streetName', '');
        System.assertEquals(objectMap.get('streetSuffix'), 'streetSuffix', '');
        System.assertEquals(objectMap.get('switchId'), 'switchId', '');
        System.assertEquals(objectMap.get('timezone'), '0', '');
        System.assertEquals(objectMap.get('unitNo'), 'unitNo', '');
        System.assertEquals(objectMap.get('unitType'), 'unitType', '');
        System.assertEquals(objectMap.get('vertexGeocode'), 'vertexGeocode', '');
        System.assertEquals(objectMap.get('viewCreatedDt'), curDate, '');
		System.assertEquals(objectMap.get('viewEffectiveDt'), curDate, '');
		System.assertEquals(objectMap.get('viewId'), 1, '');
		System.assertEquals(objectMap.get('viewStatus'), 1, '');

        WaiveInstallmentNRCOption__mdt  waiveInstallmentNrc = [SELECT MasterLabel, waiveInstallmentNrc__c FROM WaiveInstallmentNRCOption__mdt WHERE IsDefault__c = 'true' LIMIT 1];
        WaiveUnBilledNRCOption__mdt  waiveUnbilledNrc = [SELECT MasterLabel, waiveUnbilledNrc__c FROM WaiveUnBilledNRCOption__mdt WHERE IsDefault__c = 'true' LIMIT 1];
        WaiveTerminationObligationOption__mdt  waiveTerminationObligation = [SELECT MasterLabel, waiveTerminationObligation__c FROM WaiveTerminationObligationOption__mdt WHERE IsDefault__c = 'true' LIMIT 1];
        WaiveUnmetObligationOption__mdt  waiveUnmetObligation = [SELECT MasterLabel, waiveUnmetObligation__c FROM WaiveUnmetObligationOption__mdt WHERE IsDefault__c = 'true' LIMIT 1];
        WaiveRefinanceNRCOption__mdt  waiveRefinanceNrc = [SELECT MasterLabel, waiveRefinanceNrc__c FROM WaiveRefinanceNRCOption__mdt WHERE IsDefault__c = 'true' LIMIT 1];
        
        System.assertEquals(objectMap.get('waiveInstallmentNrc'), waiveInstallmentNrc.waiveInstallmentNRC__c);
        System.assertEquals(objectMap.get('waiveUnbilledNrc'), waiveUnbilledNrc.waiveUnBilledNRC__c);
        System.assertEquals(objectMap.get('waiveTerminationObligation'), waiveTerminationObligation.waiveTerminationObligation__c);
        System.assertEquals(objectMap.get('waiveUnmetObligation'), waiveUnmetObligation.waiveUnmetObligation__c);
        System.assertEquals(objectMap.get('waiveRefinanceNrc'), waiveRefinanceNrc.waiveRefinanceNRC__c);

        Map<String, Object> extData = (Map<String, Object>) objectMap.get('extData');
        System.assertEquals(extData.get('1'), 1, '');
        

        List<Map<String, String>> extIdList = (List<Map<String, String>>) objectMap.get('extIdList');
        Map<String, String> extIdListMap = extIdList[0];
        System.assertEquals(extIdListMap.get('1'), '1', '');

	}
	
	
	@isTest
	static void getDisplayValuesTest(){
		
		Map<String,Object> objectMap = new Map<String,Object>();
        Datetime curDate = Datetime.now();
		String curDateString = curDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS');

        List<Object> serviceItems = new List<Object>();
        Map<String, Object> itemMap = new Map<String, Object>();
        itemMap.put('itemId', 1);
        itemMap.put('itemType', 1000);
        serviceItems.add(itemMap);

        objectMap.put('serviceItems', serviceItems);
		objectMap.put('activeDt', curDateString);
        objectMap.put('address1', 'address1'); 
        objectMap.put('address2', 'address2');
        objectMap.put('address3', 'address3');
        objectMap.put('address4', 'address4');
        objectMap.put('addressLocation', 1);
        objectMap.put('addressTypeId', '1');
        objectMap.put('bendAddressId', 1);
        objectMap.put('bserviceCompany', 'bserviceCompany');
        objectMap.put('bserviceFname', 'bserviceFname');
		objectMap.put('bserviceFranchiseTaxCode', 1);
        objectMap.put('bserviceGeocode', 'bserviceGeocode');
        objectMap.put('bserviceLname', 'bserviceLname');
        objectMap.put('bserviceMinit', 'bserviceMinit');
        objectMap.put('bservicePhone', 'bservicePhone');
        objectMap.put('bservicePhone2', 'bservicePhone2');
        objectMap.put('changeDt', curDateString);
    	objectMap.put('changeWho', 'changeWho');
    	objectMap.put('chgDt', curDateString);
    	objectMap.put('chgWho', 'chgWho');     
        objectMap.put('city', 'city');
        objectMap.put('codeword', 'codeword');
		objectMap.put('converted', 1);
        objectMap.put('countryCode', '0');
        objectMap.put('county', 'county');
		objectMap.put('createDt', curDateString);
        objectMap.put('currencyCode', '10'); 
        objectMap.put('displayAddressId', 1);
        objectMap.put('displayCiemViewId', 1);
        objectMap.put('displayExternalIdType', 1);
		objectMap.put('eligKey1', 1);
		objectMap.put('eligKey2', 1);
		objectMap.put('eligKey3', 1);
        objectMap.put('emfConfigId', 1);
        objectMap.put('exrateClass', 1);
        objectMap.put('extendedPostalCode', 'extendedPostalCode');
        objectMap.put('externalAddressId', 'externalAddressId');
  		objectMap.put('franchiseTaxCode', 1);      
        objectMap.put('fxGeocode', 'fxGeocode');
        objectMap.put('houseNumber', 'houseNumber');
        objectMap.put('houseNumberSuffix', 'houseNumberSuffix');
        objectMap.put('intendedViewEffectiveDt', curDateString);
		objectMap.put('isActive', true);
        objectMap.put('isPrepaid', true);
        objectMap.put('ixcProviderId', 1);
        objectMap.put('keyLineCode', 'keyLineCode');
        objectMap.put('lecProviderId', 1);
        objectMap.put('nearestCrossstreet', 'nearestCrossstreet');
        objectMap.put('noBill', true);
        objectMap.put('nonpubNonlist', 1);
        objectMap.put('optionalEndorsementLine', 'optionalEndorsementLine');
        objectMap.put('parentAccountInternalId', 123456);
		objectMap.put('picDateActive', curDateString);        
        objectMap.put('popUnits', 2);
        objectMap.put('postalCode', 'postalCode');
        objectMap.put('postfixDirectional', 'postfixDirectional');
        objectMap.put('postnetAddressBlockBarcode', 'postnetAddressBlockBarcode');
        objectMap.put('postnetBarcode', 'postnetBarcode');
        objectMap.put('prefixDirectional', 'prefixDirectional');
		objectMap.put('prevViewId', 1);
        objectMap.put('privacyLevel', '0');
        objectMap.put('rateClass', 1);
        objectMap.put('restrictedPic', 1);
        objectMap.put('revRcvCostCtr', 1);
        objectMap.put('salesChannelId', '1');
        objectMap.put('serviceActiveDt', curDateString);
        objectMap.put('serviceCompany', 'serviceCompany');
        objectMap.put('serviceFname', 'serviceFname');
        objectMap.put('serviceFranchiseTaxCode', 1);
        objectMap.put('serviceGeocode', 'serviceGeocode');
        objectMap.put('serviceInactiveDt', curDateString);
        objectMap.put('serviceInternalId', 987654);
        objectMap.put('serviceInternalIdResets', 1);
        objectMap.put('serviceLname', 'serviceLname');
        objectMap.put('serviceMinit', 'serviceMinit');
        objectMap.put('serviceNameGeneration', 'serviceNameGeneration');
        objectMap.put('serviceNamePre', 'serviceNamePre');
        objectMap.put('servicePhone', 'servicePhone');
        objectMap.put('servicePhone2', 'servicePhone2');
        objectMap.put('simSerialNumber', 'simSerialNumber');
        objectMap.put('state', 'state');
        objectMap.put('statusId', 1);
        objectMap.put('statusReasonId', 1);
        objectMap.put('streetName', 'streetName');
        objectMap.put('streetSuffix', 'streetSuffix');
        objectMap.put('switchId', 'switchId');
        objectMap.put('timezone', '0');
        objectMap.put('unitNo', 'unitNo');
        objectMap.put('unitType', 'unitType');
        objectMap.put('vertexGeocode', 'vertexGeocode');
        objectMap.put('viewCreatedDt', curDateString);
		objectMap.put('viewEffectiveDt', curDateString);
		objectMap.put('viewId', 1);
		objectMap.put('viewStatus', 1);

        Map<String, Object> extData = new Map<String, Object>();
        extData.put('1', 1);
        objectMap.put('extData', extData);

        Map<String, String> extIdMap = new Map<String, String>();
        List<Map<String, String>> extIdList = new List<Map<String, String>>();
        extIdMap.put('type', '2');
        extIdList.add(extIdMap);
        objectMap.put('extIdList', extIdList);
		
        Test.startTest();

        KenanServiceMapper mapper = new KenanServiceMapper();
        KenanService service = mapper.getDisplayValues(objectMap);
        Test.stopTest();

        System.assertEquals(service.activeDt, curDate, '');
        System.assertEquals(service.address1, 'address1', ''); 
        System.assertEquals(service.address2, 'address2', '');
        System.assertEquals(service.address3, 'address3', '');
        System.assertEquals(service.address4, 'address4', '');
        System.assertEquals(service.addressLocation, 1, '');
        System.assertEquals(service.addressTypeId, 'Not Free-form', ''); 
        System.assertEquals(service.bendAddressId, 1, '');
        System.assertEquals(service.bserviceCompany, 'bserviceCompany', '');
        System.assertEquals(service.bserviceFname, 'bserviceFname', '');
        System.assertEquals(service.bserviceFranchiseTaxCode, 1, '');
        System.assertEquals(service.bserviceGeocode, 'bserviceGeocode', '');
        System.assertEquals(service.bserviceLname, 'bserviceLname', '');
        System.assertEquals(service.bserviceMinit, 'bserviceMinit', '');
        System.assertEquals(service.bservicePhone, 'bservicePhone', '');
        System.assertEquals(service.bservicePhone2, 'bservicePhone2', '');
        System.assertEquals(service.changeDt, curDate, '');
        System.assertEquals(service.changeWho, 'changeWho', '');
        System.assertEquals(service.chgDt, curDate, '');
        System.assertEquals(service.chgWho, 'chgWho', '');     
        System.assertEquals(service.city, 'city', '');
        System.assertEquals(service.codeword, 'codeword', '');
        System.assertEquals(service.converted, 1, '');
        System.assertEquals(service.countryCode, 'Reserved - No Country', '');
        System.assertEquals(service.county, 'county', '');
        System.assertEquals(service.createDt, curDate, ''); 
        System.assertEquals(service.currencyCode, 'KRW', '');
        System.assertEquals(service.displayAddressId, 1, '');
        System.assertEquals(service.displayCiemViewId, 1, '');
        System.assertEquals(service.displayExternalIdType, 1, '');
        System.assertEquals(service.eligKey1, 1, '');
        System.assertEquals(service.eligKey2, 1, '');
        System.assertEquals(service.eligKey3, 1, '');
        System.assertEquals(service.emfConfigId, 1, '');
        System.assertEquals(service.exrateClass, 1, '');
        System.assertEquals(service.extendedPostalCode, 'extendedPostalCode', '');
        System.assertEquals(service.externalAddressId, 'externalAddressId', '');
        System.assertEquals(service.franchiseTaxCode, 1, '');      
        System.assertEquals(service.fxGeocode, 'fxGeocode', '');
        System.assertEquals(service.houseNumber, 'houseNumber', '');
        System.assertEquals(service.houseNumberSuffix, 'houseNumberSuffix', '');
        System.assertEquals(service.intendedViewEffectiveDt, curDate, ''); 
        System.assertEquals(service.isActive, true, '');
        System.assertEquals(service.isPrepaid, true, '');
        System.assertEquals(service.ixcProviderId, 1, '');
        System.assertEquals(service.keyLineCode, 'keyLineCode', '');
        System.assertEquals(service.lecProviderId, 1, '');
        System.assertEquals(service.nearestCrossstreet, 'nearestCrossstreet', '');
        System.assertEquals(service.noBill, true, '');
        System.assertEquals(service.nonpubNonlist, 1, '');
        System.assertEquals(service.optionalEndorsementLine, 'optionalEndorsementLine', '');
        System.assertEquals(service.parentAccountInternalId, 123456, '');
        System.assertEquals(service.picDateActive, curDate, ''); 
        System.assertEquals(service.popUnits, 2, '');
        System.assertEquals(service.postalCode, 'postalCode', '');
        System.assertEquals(service.postfixDirectional, 'postfixDirectional', '');
        System.assertEquals(service.postnetAddressBlockBarcode, 'postnetAddressBlockBarcode', '');
        System.assertEquals(service.postnetBarcode, 'postnetBarcode', '');
        System.assertEquals(service.prefixDirectional, 'prefixDirectional', '');
        System.assertEquals(service.prevViewId, 1, '');
        System.assertEquals(service.privacyLevel, 'No mask', ''); 
        System.assertEquals(service.rateClass, 1, '');
        System.assertEquals(service.restrictedPic, 1, '');
        System.assertEquals(service.revRcvCostCtr, 1, '');
        System.assertEquals(service.salesChannelId, 'Sales Channel 1', ''); 
        System.assertEquals(service.serviceActiveDt, curDate, ''); 
        System.assertEquals(service.serviceCompany, 'serviceCompany', ''); 
        System.assertEquals(service.serviceFname, 'serviceFname', ''); 
        System.assertEquals(service.serviceFranchiseTaxCode, 1, ''); 
        System.assertEquals(service.serviceGeocode, 'serviceGeocode', '');
        System.assertEquals(service.serviceInactiveDt, curDate, ''); 
        System.assertEquals(service.serviceInternalId, 987654, ''); 
        System.assertEquals(service.serviceInternalIdResets, 1, ''); 
        System.assertEquals(service.serviceLname, 'serviceLname', ''); 
        System.assertEquals(service.serviceMinit, 'serviceMinit', ''); 
        System.assertEquals(service.serviceNameGeneration, 'serviceNameGeneration', ''); 
        System.assertEquals(service.serviceNamePre, 'serviceNamePre', ''); 
        System.assertEquals(service.servicePhone, 'servicePhone', ''); 
        System.assertEquals(service.servicePhone2, 'servicePhone2', ''); 
        System.assertEquals(service.simSerialNumber, 'simSerialNumber', '');
        System.assertEquals(service.state, 'state', ''); 
        System.assertEquals(service.statusId, 1, '');
        System.assertEquals(service.statusReasonId, 1, '');
        System.assertEquals(service.streetName, 'streetName', ''); 
        System.assertEquals(service.streetSuffix, 'streetSuffix', ''); 
        System.assertEquals(service.switchId, 'switchId', ''); 
        System.assertEquals(service.timezone, 'UTC (GMT) Time Zone', ''); 
        System.assertEquals(service.unitNo, 'unitNo', '');
        System.assertEquals(service.unitType, 'unitType', '');
        System.assertEquals(service.vertexGeocode, 'vertexGeocode', '');
        System.assertEquals(service.viewCreatedDt, curDate, ''); 
        System.assertEquals(service.viewEffectiveDt, curDate, '');
        System.assertEquals(service.viewId, 1, '');
        System.assertEquals(service.viewStatus, 1, ''); 

        Map<String, Object> extDataService = service.extData;
        System.assertEquals( extDataService.get('1'), '1', '');
        
        List<Map<String, String>> extIdMapList = service.extIdList;
        System.assertEquals(extIdMapList.size(), 1, '');
        Map<String, String> extIdMapService = extIdMapList[0];
        System.assertEquals(extIdMapService.get('type'), '2', '');

        serviceItems = service.serviceItems;
        system.assertEquals(serviceItems.size(), 1, '');
        KenanServiceItem serviceItem = (KenanServiceItem) serviceItems[0];
        System.assertEquals(serviceItem.itemId, 1);
        System.assertEquals(serviceItem.itemType, 1000);

	}
}