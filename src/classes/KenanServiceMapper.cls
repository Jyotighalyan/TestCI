/**
* TODO: ApexDoc.
*/
public with sharing class KenanServiceMapper implements KenanObjectMapper{

    private KenanServiceItemMapper serviceItemMapper;
    private KenanServiceConnection__c kenanSettings;

	public KenanServiceMapper() {
		serviceItemMapper = new KenanServiceItemMapper();
        kenanSettings = KenanServiceConnection__c.getInstance();
	}

	public Map<String,Object> getEnumeratedValues(KenanObject kObject){
        KenanService service = (KenanService) kObject;
    
        Map<String,Object> objectMap = new Map<String,Object>();
		if (service.disconnectDate != null) objectMap.put('disconnectDate', service.disconnectDate);
		if (service.disconnectReason != null) objectMap.put('disconnectReason', service.disconnectReason);
    	if (service.activeDt != null) objectMap.put('activeDt', service.activeDt);
        if (service.address1 != null) objectMap.put('address1', service.address1); 
        if (service.address2 != null) objectMap.put('address2', service.address2);
        if (service.address3 != null) objectMap.put('address3', service.address3);
        if (service.address4 != null) objectMap.put('address4', service.address4);
        if (service.addressLocation != null) objectMap.put('addressLocation', service.addressLocation);
        if (service.addressTypeId != null) objectMap.put('addressTypeId', service.addressTypeId);
        if (service.bendAddressId != null) objectMap.put('bendAddressId', service.bendAddressId);
        if (service.bserviceCompany != null) objectMap.put('bserviceCompany', service.bserviceCompany);
        if (service.bserviceFname != null) objectMap.put('bserviceFname', service.bserviceFname);
		if (service.bserviceFranchiseTaxCode != null) objectMap.put('bserviceFranchiseTaxCode',service.bserviceFranchiseTaxCode);
        if (service.bserviceGeocode != null) objectMap.put('bserviceGeocode', service.bserviceGeocode);
        if (service.bserviceLname != null) objectMap.put('bserviceLname', service.bserviceLname);
        if (service.bserviceMinit != null) objectMap.put('bserviceMinit', service.bserviceMinit);
        if (service.bservicePhone != null) objectMap.put('bservicePhone', service.bservicePhone);
        if (service.bservicePhone2 != null) objectMap.put('bservicePhone2', service.bservicePhone2);
        if (service.changeDt != null) objectMap.put('changeDt', (Datetime) service.changeDt);
    	if (service.changeWho != null) objectMap.put('changeWho', service.changeWho);
    	if (service.chgDt != null) objectMap.put('chgDt', (DateTime) service.chgDt);
    	if (service.chgWho != null) objectMap.put('chgWho', service.chgWho);     
        if (service.city != null) objectMap.put('city', service.city);
        if (service.codeword != null) objectMap.put('codeword', service.codeword);
		if (service.converted != null) objectMap.put('converted', service.converted);
        if (service.countryCode != null) objectMap.put('countryCode', service.countryCode);
        if (service.county != null) objectMap.put('county', service.county);
		if (service.createDt != null) objectMap.put('createDt', (DateTime) service.createDt);
        if (service.currencyCode != null) objectMap.put('currencyCode', service.currencyCode);
        if (service.displayAddressId != null) objectMap.put('displayAddressId', service.displayAddressId);
        if (service.displayCiemViewId != null) objectMap.put('displayCiemViewId', service.displayCiemViewId);
        if (service.displayExternalIdType != null) objectMap.put('displayExternalIdType', service.displayExternalIdType);
		if (service.eligKey1 != null) objectMap.put('eligKey1', service.eligKey1);
		if (service.eligKey2 != null) objectMap.put('eligKey2', service.eligKey2);
		if (service.eligKey3 != null) objectMap.put('eligKey3', service.eligKey3);
        if (service.emfConfigId != null) objectMap.put('emfConfigId', service.emfConfigId);

        //TODO: Enumeration ?
        if (service.exrateClass != null) objectMap.put('exrateClass', service.exrateClass);
        if (service.extendedPostalCode != null) objectMap.put('extendedPostalCode', service.extendedPostalCode);
        if (service.externalAddressId != null) objectMap.put('externalAddressId', service.externalAddressId);
  		if (service.franchiseTaxCode != null) objectMap.put('franchiseTaxCode', service.franchiseTaxCode);      
        if (service.fxGeocode != null) objectMap.put('fxGeocode', service.fxGeocode);
        if (service.houseNumber != null) objectMap.put('houseNumber', service.houseNumber);
        if (service.houseNumberSuffix != null) objectMap.put('houseNumberSuffix', service.houseNumberSuffix);
        if (service.intendedViewEffectiveDt != null) objectMap.put('intendedViewEffectiveDt', (DateTIme) service.intendedViewEffectiveDt);
		if (service.isActive != null) objectMap.put('isActive', service.isActive);
        if (service.isPrepaid != null) objectMap.put('isPrepaid', service.isPrepaid);
        if (service.ixcProviderId != null) objectMap.put('ixcProviderId', service.ixcProviderId);
        if (service.keyLineCode != null) objectMap.put('keyLineCode', service.keyLineCode);
        if (service.lecProviderId != null) objectMap.put('lecProviderId', service.lecProviderId);
        if (service.nearestCrossstreet != null) objectMap.put('nearestCrossstreet', service.nearestCrossstreet);
        if (service.noBill != null) objectMap.put('noBill', service.noBill);
        if (service.nonpubNonlist != null) objectMap.put('nonpubNonlist', service.nonpubNonlist);
        if (service.optionalEndorsementLine != null) objectMap.put('optionalEndorsementLine', service.optionalEndorsementLine);
        if (service.parentAccountInternalId != null) objectMap.put('parentAccountInternalId', service.parentAccountInternalId);
		if (service.picDateActive != null) objectMap.put('picDateActive', (DateTime) service.picDateActive);        
        if (service.popUnits != null) objectMap.put('popUnits', service.popUnits);
        if (service.postalCode != null) objectMap.put('postalCode', service.postalCode);
        if (service.postfixDirectional != null) objectMap.put('postfixDirectional', service.postfixDirectional);
        if (service.postnetAddressBlockBarcode != null) objectMap.put('postnetAddressBlockBarcode', service.postnetAddressBlockBarcode);
        if (service.postnetBarcode != null) objectMap.put('postnetBarcode', service.postnetBarcode);
        if (service.prefixDirectional != null) objectMap.put('prefixDirectional', service.prefixDirectional);
		if (service.prevViewId != null) objectMap.put('prevViewId', service.prevViewId);
        if (service.privacyLevel != null) objectMap.put('privacyLevel', service.privacyLevel);

        //TODO: Enumeration ?
        if (service.rateClass != null) objectMap.put('rateClass', service.rateClass);
        if (service.restrictedPic != null) objectMap.put('restrictedPic', service.restrictedPic);
        if (service.revRcvCostCtr != null) objectMap.put('revRcvCostCtr', service.revRcvCostCtr);
        if (service.salesChannelId != null) objectMap.put('salesChannelId', service.salesChannelId);
        if (service.serviceActiveDt != null) objectMap.put('serviceActiveDt', (DateTime) service.serviceActiveDt);
        if (service.serviceCompany != null) objectMap.put('serviceCompany', service.serviceCompany);
        if (service.serviceFname != null) objectMap.put('serviceFname', service.serviceFname);
        if (service.serviceFranchiseTaxCode != null) objectMap.put('serviceFranchiseTaxCode', service.serviceFranchiseTaxCode);
        if (service.serviceGeocode != null) objectMap.put('serviceGeocode', service.serviceGeocode);
        if (service.serviceInactiveDt != null) objectMap.put('serviceInactiveDt', (DateTime) service.serviceInactiveDt);
        if (service.serviceInternalId != null) objectMap.put('serviceInternalId', service.serviceInternalId);
        if (service.serviceInternalIdResets != null) objectMap.put('serviceInternalIdResets', service.serviceInternalIdResets);
        if (service.serviceLname != null) objectMap.put('serviceLname', service.serviceLname);
        if (service.serviceMinit != null) objectMap.put('serviceMinit', service.serviceMinit);
        if (service.serviceNameGeneration != null) objectMap.put('serviceNameGeneration', service.serviceNameGeneration);
        if (service.serviceNamePre != null) objectMap.put('serviceNamePre', service.serviceNamePre);
        if (service.servicePhone != null) objectMap.put('servicePhone', service.servicePhone);
        if (service.servicePhone2 != null) objectMap.put('servicePhone2', service.servicePhone2);
        if (service.simSerialNumber != null) objectMap.put('simSerialNumber', service.simSerialNumber);
        if (service.state != null) objectMap.put('state', service.state);
		
        //TODO: Enumeration ? maybe StatusBean but also need StatusTypeId
        if (service.statusId != null) objectMap.put('statusId', service.statusId);

        //TODO: Enumeration ? StatusReasonMapBean with statusId
        if (service.statusReasonId != null) objectMap.put('statusReasonId', service.statusReasonId);

        if (service.streetName != null) objectMap.put('streetName', service.streetName);
        if (service.streetSuffix != null) objectMap.put('streetSuffix', service.streetSuffix);
        if (service.switchId != null) objectMap.put('switchId', service.switchId);

        //TODO: Enumeration TimezoneBean
        if (service.timezone != null) objectMap.put('timezone', service.timezone);
        if (service.unitNo != null) objectMap.put('unitNo', service.unitNo);
        if (service.unitType != null) objectMap.put('unitType', service.unitType);
        if (service.vertexGeocode != null) objectMap.put('vertexGeocode', service.vertexGeocode);
        if (service.viewCreatedDt != null) objectMap.put('viewCreatedDt', (DateTime) service.viewCreatedDt);
		if (service.viewEffectiveDt != null) objectMap.put('viewEffectiveDt', (DateTime) service.viewEffectiveDt);
		if (service.viewId != null) objectMap.put('viewId', service.viewId);
		if (service.viewStatus != null) objectMap.put('viewStatus', service.viewStatus);

        if (service.waiveInstallmentNrc != null) objectMap.put('waiveInstallmentNrc', service.waiveInstallmentNrc);
        if (service.waiveUnbilledNrc != null) objectMap.put('waiveUnbilledNrc', service.waiveUnbilledNrc);
        if (service.waiveTerminationObligation != null) objectMap.put('waiveTerminationObligation', service.waiveTerminationObligation);
        if (service.waiveUnmetObligation != null) objectMap.put('waiveUnmetObligation', service.waiveUnmetObligation);
        if (service.waiveRefinanceNrc != null) objectMap.put('waiveRefinanceNrc', service.waiveRefinanceNrc);
	
		if (service.extIdList != null && service.extIdList.size() > 0){
			objectMap.put('extIdList', service.extIdList);
		} 
		
		if (service.extData != null) objectMap.put('extData', service.extData);

        mapEnumeratedValues(objectMap);
		
        return objectMap;
    }

    public KenanService getDisplayValues(Map<String, Object> objectMap){

        mapDisplayValues(objectMap);
        KenanService service = convertToKenanObject(objectMap);
        
        return service;
    }


    private void mapEnumeratedValues(Map<String, Object> record){
        
        if (record.get('disconnectDate') != null) record.put('disconnectDate', record.get('disconnectDate'));
        if (record.get('disconnectReason') != null) record.put('disconnectReason', KenanEnumerationHelper.getEnumKeyValue('DiscReasonBean__mdt', 'DisconnectReason__c', record.get('disconnectReason'), kenanSettings.Stored_Language_Code__c,'DisplayValue__c'));
        
        if (record.get('activeDt') != null) record.put('activeDt', record.get('activeDt'));
        if (record.get('address1') != null) record.put('address1', record.get('address1')); 
        if (record.get('address2') != null) record.put('address2', record.get('address2'));
        if (record.get('address3') != null) record.put('address3', record.get('address3'));
        if (record.get('address4') != null) record.put('address4', record.get('address4'));
        if (record.get('addressLocation') != null) record.put('addressLocation', record.get('addressLocation'));
        if (record.get('addressTypeId') != null) record.put('addressTypeId', KenanEnumerationHelper.getEnumKeyValue('AddressTypeBean__mdt', 'addressTypeId__c', record.get('addressTypeId'), kenanSettings.Stored_Language_Code__c,'DisplayValue__c'));
        if (record.get('bendAddressId') != null) record.put('bendAddressId', record.get('bendAddressId'));
        if (record.get('bserviceCompany') != null) record.put('bserviceCompany', record.get('bserviceCompany'));
        if (record.get('bserviceFname') != null) record.put('bserviceFname', record.get('bserviceFname'));
        if (record.get('bserviceFranchiseTaxCode') != null) record.put('bserviceFranchiseTaxCode',record.get('bserviceFranchiseTaxCode'));   //
        if (record.get('bserviceGeocode') != null) record.put('bserviceGeocode', record.get('bserviceGeocode'));
        if (record.get('bserviceLname') != null) record.put('bserviceLname', record.get('bserviceLname'));
        if (record.get('bserviceMinit') != null) record.put('bserviceMinit', record.get('bserviceMinit'));
        if (record.get('bservicePhone') != null) record.put('bservicePhone', record.get('bservicePhone'));
        if (record.get('bservicePhone2') != null) record.put('bservicePhone2', record.get('bservicePhone2'));
        if (record.get('changeDt') != null) record.put('changeDt', (Datetime) record.get('changeDt'));
        if (record.get('changeWho') != null) record.put('changeWho', record.get('changeWho'));
        if (record.get('chgDt') != null) record.put('chgDt', (DateTime) record.get('chgDt'));
        if (record.get('chgWho') != null) record.put('chgWho', record.get('chgWho'));     
        if (record.get('city') != null) record.put('city', record.get('city'));
        if (record.get('codeword') != null) record.put('codeword', record.get('codeword'));
        if (record.get('converted') != null) record.put('converted', record.get('converted'));
        if (record.get('countryCode') != null) record.put('countryCode', KenanEnumerationHelper.getEnumKeyValue('CountryCodeBean__mdt', 'countryCode__c', record.get('countryCode'), kenanSettings.Stored_Language_Code__c,'DisplayValue__c'));
        if (record.get('county') != null) record.put('county', record.get('county'));
        if (record.get('createDt') != null) record.put('createDt', (DateTime) record.get('createDt'));
        if (record.get('currencyCode') != null) record.put('currencyCode', KenanEnumerationHelper.getEnumKeyValue('RateCurrencyBean__mdt', 'currencyCode__c', record.get('currencyCode'), kenanSettings.Stored_Language_Code__c,'ShortDisplay__c'));
        if (record.get('displayAddressId') != null) record.put('displayAddressId', record.get('displayAddressId'));
        if (record.get('displayCiemViewId') != null) record.put('displayCiemViewId', record.get('displayCiemViewId'));
        if (record.get('displayExternalIdType') != null) record.put('displayExternalIdType', record.get('displayExternalIdType'));
        if (record.get('eligKey1') != null) record.put('eligKey1', record.get('eligKey1'));
        if (record.get('eligKey2') != null) record.put('eligKey2', record.get('eligKey2'));
        if (record.get('eligKey3') != null) record.put('eligKey3', record.get('eligKey3'));
        if (record.get('emfConfigId') != null) record.put('emfConfigId', record.get('emfConfigId'));

        //TODO: Enumeration ?
        if (record.get('exrateClass') != null) record.put('exrateClass', record.get('exrateClass'));
        if (record.get('extendedPostalCode') != null) record.put('extendedPostalCode', record.get('extendedPostalCode'));
        if (record.get('externalAddressId') != null) record.put('externalAddressId', record.get('externalAddressId'));
        if (record.get('franchiseTaxCode') != null) record.put('franchiseTaxCode', record.get('franchiseTaxCode'));      
        if (record.get('fxGeocode') != null) record.put('fxGeocode', record.get('fxGeocode'));
        if (record.get('houseNumber') != null) record.put('houseNumber', record.get('houseNumber'));
        if (record.get('houseNumberSuffix') != null) record.put('houseNumberSuffix', record.get('houseNumberSuffix'));
        if (record.get('intendedViewEffectiveDt') != null) record.put('intendedViewEffectiveDt', (DateTIme) record.get('intendedViewEffectiveDt'));
        if (record.get('isActive') != null) record.put('isActive', record.get('isActive'));
        if (record.get('isPrepaid') != null) record.put('isPrepaid', record.get('isPrepaid'));
        if (record.get('ixcProviderId') != null) record.put('ixcProviderId', record.get('ixcProviderId'));
        if (record.get('keyLineCode') != null) record.put('keyLineCode', record.get('keyLineCode'));
        if (record.get('lecProviderId') != null) record.put('lecProviderId', record.get('lecProviderId'));
        if (record.get('nearestCrossstreet') != null) record.put('nearestCrossstreet', record.get('nearestCrossstreet'));
        if (record.get('noBill') != null) record.put('noBill', record.get('noBill'));
        if (record.get('nonpubNonlist') != null) record.put('nonpubNonlist', record.get('nonpubNonlist'));
        if (record.get('optionalEndorsementLine') != null) record.put('optionalEndorsementLine', record.get('optionalEndorsementLine'));
        if (record.get('parentAccountInternalId') != null) record.put('parentAccountInternalId', record.get('parentAccountInternalId'));
        if (record.get('picDateActive') != null) record.put('picDateActive', (DateTime) record.get('picDateActive'));        
        if (record.get('popUnits') != null) record.put('popUnits', record.get('popUnits'));
        if (record.get('postalCode') != null) record.put('postalCode', record.get('postalCode'));
        if (record.get('postfixDirectional') != null) record.put('postfixDirectional', record.get('postfixDirectional'));
        if (record.get('postnetAddressBlockBarcode') != null) record.put('postnetAddressBlockBarcode', record.get('postnetAddressBlockBarcode'));
        if (record.get('postnetBarcode') != null) record.put('postnetBarcode', record.get('postnetBarcode'));
        if (record.get('prefixDirectional') != null) record.put('prefixDirectional', record.get('prefixDirectional'));
        if (record.get('prevViewId') != null) record.put('prevViewId', record.get('prevViewId'));
        if (record.get('privacyLevel') != null) record.put('privacyLevel', KenanEnumerationHelper.getEnumKeyValue('PrivacyLevelBean__mdt', 'Level__c', record.get('privacyLevel'), kenanSettings.Stored_Language_Code__c,'DisplayValue__c'));

        //TODO: Enumeration ?
        if (record.get('rateClass') != null) record.put('rateClass', record.get('rateClass'));
        if (record.get('restrictedPic') != null) record.put('restrictedPic', record.get('restrictedPic'));
        if (record.get('revRcvCostCtr') != null) record.put('revRcvCostCtr', record.get('revRcvCostCtr'));
        if (record.get('salesChannelId') != null) record.put('salesChannelId', KenanEnumerationHelper.getEnumKeyValue('SalesChannelBean__mdt', 'SalesChannelId__c', record.get('salesChannelId'), kenanSettings.Stored_Language_Code__c,'DisplayValue__c'));
        if (record.get('serviceActiveDt') != null) record.put('serviceActiveDt', (DateTime) record.get('serviceActiveDt'));
        if (record.get('serviceCompany') != null) record.put('serviceCompany', record.get('serviceCompany'));
        if (record.get('serviceFname') != null) record.put('serviceFname', record.get('serviceFname'));
        if (record.get('serviceFranchiseTaxCode') != null) record.put('serviceFranchiseTaxCode', record.get('serviceFranchiseTaxCode'));
        if (record.get('serviceGeocode') != null) record.put('serviceGeocode', record.get('serviceGeocode'));
        if (record.get('serviceInactiveDt') != null) record.put('serviceInactiveDt', (DateTime) record.get('serviceInactiveDt'));
        if (record.get('serviceInternalId') != null) record.put('serviceInternalId', record.get('serviceInternalId'));
        if (record.get('serviceInternalIdResets') != null) record.put('serviceInternalIdResets', record.get('serviceInternalIdResets'));
        if (record.get('serviceLname') != null) record.put('serviceLname', record.get('serviceLname'));
        if (record.get('serviceMinit') != null) record.put('serviceMinit', record.get('serviceMinit'));
        if (record.get('serviceNameGeneration') != null) record.put('serviceNameGeneration', record.get('serviceNameGeneration'));
        if (record.get('serviceNamePre') != null) record.put('serviceNamePre', record.get('serviceNamePre'));
        if (record.get('servicePhone') != null) record.put('servicePhone', record.get('servicePhone'));
        if (record.get('servicePhone2') != null) record.put('servicePhone2', record.get('servicePhone2'));
        if (record.get('simSerialNumber') != null) record.put('simSerialNumber', record.get('simSerialNumber'));
        if (record.get('state') != null) record.put('state', record.get('state'));
        
        //TODO: Enumeration ? maybe StatusBean but also need StatusTypeId
        if (record.get('statusId') != null) record.put('statusId', record.get('statusId'));

        //TODO: Enumeration ? StatusReasonMapBean with statusId
        if (record.get('statusReasonId') != null) record.put('statusReasonId', record.get('statusReasonId'));

        if (record.get('streetName') != null) record.put('streetName', record.get('streetName'));
        if (record.get('streetSuffix') != null) record.put('streetSuffix', record.get('streetSuffix'));
        if (record.get('switchId') != null) record.put('switchId', record.get('switchId'));

        //TODO: Enumeration TimezoneBean
        if (record.get('timezone') != null) record.put('timezone', KenanEnumerationHelper.getEnumKeyValue('TimezoneBean__mdt', 'TimezoneCode__c', record.get('timezone'), kenanSettings.Stored_Language_Code__c,'DisplayValue__c'));
        if (record.get('unitNo') != null) record.put('unitNo', record.get('unitNo'));
        if (record.get('unitType') != null) record.put('unitType', record.get('unitType'));
        if (record.get('vertexGeocode') != null) record.put('vertexGeocode', record.get('vertexGeocode'));
        if (record.get('viewCreatedDt') != null) record.put('viewCreatedDt', (DateTime) record.get('viewCreatedDt'));
        if (record.get('viewEffectiveDt') != null) record.put('viewEffectiveDt', (DateTime) record.get('viewEffectiveDt'));
        if (record.get('viewId') != null) record.put('viewId', record.get('viewId'));
        if (record.get('viewStatus') != null) record.put('viewStatus', record.get('viewStatus'));
        
        if (record.get('waiveInstallmentNrc') != null) record.put('waiveInstallmentNrc', KenanEnumerationHelper.getEnumKeyValue('WaiveInstallmentNrcOption__mdt', 'waiveInstallmentNrc__c', record.get('waiveInstallmentNrc'), kenanSettings.Stored_Language_Code__c, 'MasterLabel'));
        if (record.get('waiveUnbilledNrc') != null) record.put('waiveUnbilledNrc', KenanEnumerationHelper.getEnumKeyValue('WaiveUnbilledNrcOption__mdt', 'waiveUnbilledNrc__c', record.get('waiveUnbilledNrc'), kenanSettings.Stored_Language_Code__c, 'MasterLabel'));
        if (record.get('waiveTerminationObligation') != null) record.put('waiveTerminationObligation', KenanEnumerationHelper.getEnumKeyValue('WaiveTerminationObligationOption__mdt', 'waiveTerminationObligation__c', record.get('waiveTerminationObligation'), kenanSettings.Stored_Language_Code__c, 'MasterLabel'));
        if (record.get('waiveUnmetObligation') != null) record.put('waiveUnmetObligation', KenanEnumerationHelper.getEnumKeyValue('WaiveUnmetObligationOption__mdt', 'waiveUnmetObligation__c', record.get('waiveUnmetObligation'), kenanSettings.Stored_Language_Code__c, 'MasterLabel'));
        if (record.get('waiveRefinanceNrc') != null) record.put('waiveRefinanceNrc', KenanEnumerationHelper.getEnumKeyValue('WaiveRefinanceNrcOption__mdt', 'waiveRefinanceNrc__c', record.get('waiveRefinanceNrc'), kenanSettings.Stored_Language_Code__c, 'MasterLabel'));

        if (record.get('extIdList') != null){
            record.put('extIdList', record.get('extIdList'));
        } 
        
        if (record.get('extData') != null) record.put('extData', record.get('extData'));
        
    }

    private void mapDisplayValues(Map<String, Object> record){

        if (record.get('disconnectDate') != null) record.put('disconnectDate', KenanUtils.fixDateTime(record.get('disconnectDate')));
        if (record.get('disconnectReason') != null) record.put('disconnectReason', KenanEnumerationHelper.getEnumDisplayValue('DiscReasonBean__mdt', 'DisconnectReason__c', record.get('disconnectReason'), kenanSettings.Stored_Language_Code__c,'DisplayValue__c'));
                
        if (record.get('activeDt') != null) record.put('activeDt', KenanUtils.fixDateTime(record.get('activeDt')));
        if (record.get('address1') != null) record.put('address1', String.valueOf(record.get('address1'))); 
        if (record.get('address2') != null) record.put('address2', String.valueOf(record.get('address2')));
        if (record.get('address3') != null) record.put('address3', String.valueOf(record.get('address3')));
        if (record.get('address4') != null) record.put('address4', String.valueOf(record.get('address4')));
        if (record.get('addressLocation') != null) record.put('addressLocation', Integer.valueOf(record.get('addressLocation')));
        if (record.get('addressTypeId') != null) record.put('addressTypeId', KenanEnumerationHelper.getEnumDisplayValue('AddressTypeBean__mdt', 'addressTypeId__c', record.get('addressTypeId'), kenanSettings.Stored_Language_Code__c,'DisplayValue__c'));
        if (record.get('bendAddressId') != null) record.put('bendAddressId', Integer.valueOf(record.get('bendAddressId')));
        if (record.get('bserviceCompany') != null) record.put('bserviceCompany', String.valueOf(record.get('bserviceCompany')));
        if (record.get('bserviceFname') != null) record.put('bserviceFname', String.valueOf(record.get('bserviceFname')));
        if (record.get('bserviceFranchiseTaxCode') != null) record.put('bserviceFranchiseTaxCode', Integer.valueOf(record.get('bserviceFranchiseTaxCode')));
        if (record.get('bserviceGeocode') != null) record.put('bserviceGeocode', String.valueOf(record.get('bserviceGeocode')));
        if (record.get('bserviceLname') != null) record.put('bserviceLname', String.valueOf(record.get('bserviceLname')));
        if (record.get('bserviceMinit') != null) record.put('bserviceMinit', String.valueOf(record.get('bserviceMinit')));
        if (record.get('bservicePhone') != null) record.put('bservicePhone', String.valueOf(record.get('bservicePhone')));
        if (record.get('bservicePhone2') != null) record.put('bservicePhone2', String.valueOf(record.get('bservicePhone2')));
        if (record.get('changeDt') != null) record.put('changeDt', KenanUtils.fixDateTime(record.get('changeDt')));
        if (record.get('changeWho') != null) record.put('changeWho', String.valueOf(record.get('changeWho')));
        if (record.get('chgDt') != null) record.put('chgDt', KenanUtils.fixDateTime(record.get('chgDt')));
        if (record.get('chgWho') != null) record.put('chgWho', String.valueOf(record.get('chgWho')));     
        if (record.get('city') != null) record.put('city', String.valueOf(record.get('city')));
        if (record.get('codeword') != null) record.put('codeword', String.valueOf(record.get('codeword')));
        if (record.get('converted') != null) record.put('converted', Integer.valueOf(record.get('converted')));
        if (record.get('countryCode') != null) record.put('countryCode', KenanEnumerationHelper.getEnumDisplayValue('CountryCodeBean__mdt', 'countryCode__c', record.get('countryCode'), kenanSettings.Stored_Language_Code__c,'DisplayValue__c'));
        if (record.get('county') != null) record.put('county', String.valueOf(record.get('county')));
        if (record.get('createDt') != null) record.put('createDt', KenanUtils.fixDateTime(record.get('createDt')));
        if (record.get('currencyCode') != null) record.put('currencyCode', KenanEnumerationHelper.getEnumDisplayValue('RateCurrencyBean__mdt', 'currencyCode__c', record.get('currencyCode'), kenanSettings.Stored_Language_Code__c,'ShortDisplay__c'));
        if (record.get('displayAddressId') != null) record.put('displayAddressId', Integer.valueOf(record.get('displayAddressId')));
        if (record.get('displayCiemViewId') != null) record.put('displayCiemViewId', Integer.valueOf(record.get('displayCiemViewId')));
        if (record.get('displayExternalIdType') != null) record.put('displayExternalIdType', Integer.valueOf(record.get('displayExternalIdType')));
        if (record.get('eligKey1') != null) record.put('eligKey1', Integer.valueOf(record.get('eligKey1')));
        if (record.get('eligKey2') != null) record.put('eligKey2', Integer.valueOf(record.get('eligKey2')));
        if (record.get('eligKey3') != null) record.put('eligKey3', Integer.valueOf(record.get('eligKey3')));
        if (record.get('emfConfigId') != null) record.put('emfConfigId', Integer.valueOf(record.get('emfConfigId')));

        //TODO: Enumeration ?
        if (record.get('exrateClass') != null) record.put('exrateClass', Integer.valueOf(record.get('exrateClass')));
        if (record.get('extendedPostalCode') != null) record.put('extendedPostalCode', String.valueOf(record.get('extendedPostalCode')));
        if (record.get('externalAddressId') != null) record.put('externalAddressId', String.valueOf(record.get('externalAddressId')));
        if (record.get('franchiseTaxCode') != null) record.put('franchiseTaxCode', Integer.valueOf(record.get('franchiseTaxCode')));
        if (record.get('fxGeocode') != null) record.put('fxGeocode', String.valueOf(record.get('fxGeocode')));
        if (record.get('houseNumber') != null) record.put('houseNumber', String.valueOf(record.get('houseNumber')));
        if (record.get('houseNumberSuffix') != null) record.put('houseNumberSuffix', String.valueOf(record.get('houseNumberSuffix')));
        if (record.get('intendedViewEffectiveDt') != null) record.put('intendedViewEffectiveDt', KenanUtils.fixDateTime(record.get('intendedViewEffectiveDt')));
        if (record.get('isActive') != null) record.put('isActive', Boolean.valueOf(record.get('isActive')));
        if (record.get('isPrepaid') != null) record.put('isPrepaid', Boolean.valueOf(record.get('isPrepaid')));
        if (record.get('ixcProviderId') != null) record.put('ixcProviderId', Integer.valueOf(record.get('ixcProviderId')));
        if (record.get('keyLineCode') != null) record.put('keyLineCode', String.valueOf(record.get('keyLineCode')));
        if (record.get('lecProviderId') != null) record.put('lecProviderId', Integer.valueOf(record.get('lecProviderId')));
        if (record.get('nearestCrossstreet') != null) record.put('nearestCrossstreet', String.valueOf(record.get('nearestCrossstreet')));
        if (record.get('noBill') != null) record.put('noBill', Boolean.valueOf(record.get('noBill')));
        if (record.get('nonpubNonlist') != null) record.put('nonpubNonlist', Integer.valueOf(record.get('nonpubNonlist')));
        if (record.get('optionalEndorsementLine') != null) record.put('optionalEndorsementLine', String.valueOf(record.get('optionalEndorsementLine')));
        if (record.get('parentAccountInternalId') != null) record.put('parentAccountInternalId', Integer.valueOf(record.get('parentAccountInternalId')));
        if (record.get('picDateActive') != null) record.put('picDateActive', KenanUtils.fixDateTime(record.get('picDateActive')));        
        if (record.get('popUnits') != null) record.put('popUnits', Integer.valueOf(record.get('popUnits')));
        if (record.get('postalCode') != null) record.put('postalCode', String.valueOf(record.get('postalCode')));
        if (record.get('postfixDirectional') != null) record.put('postfixDirectional', String.valueOf(record.get('postfixDirectional')));
        if (record.get('postnetAddressBlockBarcode') != null) record.put('postnetAddressBlockBarcode', String.valueOf(record.get('postnetAddressBlockBarcode')));
        if (record.get('postnetBarcode') != null) record.put('postnetBarcode', String.valueOf(record.get('postnetBarcode')));
        if (record.get('prefixDirectional') != null) record.put('prefixDirectional', String.valueOf(record.get('prefixDirectional')));
        if (record.get('prevViewId') != null) record.put('prevViewId', Integer.valueOf(record.get('prevViewId')));
        if (record.get('privacyLevel') != null) record.put('privacyLevel', KenanEnumerationHelper.getEnumDisplayValue('PrivacyLevelBean__mdt', 'Level__c', record.get('privacyLevel'), kenanSettings.Stored_Language_Code__c,'DisplayValue__c'));
    
        //TODO: Enumeration ?
        if (record.get('rateClass') != null) record.put('rateClass', Integer.valueOf(record.get('rateClass')));
        if (record.get('restrictedPic') != null) record.put('restrictedPic', Integer.valueOf(record.get('restrictedPic')));
        if (record.get('revRcvCostCtr') != null) record.put('revRcvCostCtr', Integer.valueOf(record.get('revRcvCostCtr')));
        if (record.get('salesChannelId') != null) record.put('salesChannelId', KenanEnumerationHelper.getEnumDisplayValue('SalesChannelBean__mdt', 'SalesChannelId__c', record.get('salesChannelId'), kenanSettings.Stored_Language_Code__c,'DisplayValue__c'));
        if (record.get('serviceActiveDt') != null) record.put('serviceActiveDt', KenanUtils.fixDateTime(record.get('serviceActiveDt')));
        if (record.get('serviceCompany') != null) record.put('serviceCompany', String.valueOf(record.get('serviceCompany')));
        if (record.get('serviceFname') != null) record.put('serviceFname', String.valueOf(record.get('serviceFname')));
        if (record.get('serviceFranchiseTaxCode') != null) record.put('serviceFranchiseTaxCode', Integer.valueOf(record.get('serviceFranchiseTaxCode')));
        if (record.get('serviceGeocode') != null) record.put('serviceGeocode', String.valueOf(record.get('serviceGeocode')));
        if (record.get('serviceInactiveDt') != null) record.put('serviceInactiveDt', KenanUtils.fixDateTime(record.get('serviceInactiveDt')));
        if (record.get('serviceInternalId') != null) record.put('serviceInternalId', Integer.valueOf(record.get('serviceInternalId')));
        if (record.get('serviceInternalIdResets') != null) record.put('serviceInternalIdResets', Integer.valueOf(record.get('serviceInternalIdResets')));
        if (record.get('serviceLname') != null) record.put('serviceLname', String.valueOf(record.get('serviceLname')));
        if (record.get('serviceMinit') != null) record.put('serviceMinit', String.valueOf(record.get('serviceMinit')));
        if (record.get('serviceNameGeneration') != null) record.put('serviceNameGeneration', String.valueOf(record.get('serviceNameGeneration')));
        if (record.get('serviceNamePre') != null) record.put('serviceNamePre', String.valueOf(record.get('serviceNamePre')));
        if (record.get('servicePhone') != null) record.put('servicePhone', String.valueOf(record.get('servicePhone')));
        if (record.get('servicePhone2') != null) record.put('servicePhone2', String.valueOf(record.get('servicePhone2')));
        if (record.get('simSerialNumber') != null) record.put('simSerialNumber', String.valueOf(record.get('simSerialNumber')));
        if (record.get('state') != null) record.put('state', String.valueOf(record.get('state')));

        //TODO: Enumeration ? maybe StatusBean but also need StatusTypeId
        if (record.get('statusId') != null) record.put('statusId', Integer.valueOf(record.get('statusId')));

        //TODO: Enumeration ? StatusReasonMapBean with statusId
        if (record.get('statusReasonId') != null) record.put('statusReasonId', Integer.valueOf(record.get('statusReasonId')));

        if (record.get('streetName') != null) record.put('streetName', String.valueOf(record.get('streetName')));
        if (record.get('streetSuffix') != null) record.put('streetSuffix', String.valueOf(record.get('streetSuffix')));
        if (record.get('switchId') != null) record.put('switchId', String.valueOf(record.get('switchId')));

        //TODO: Enumeration TimezoneBean
        if (record.get('timezone') != null) record.put('timezone', KenanEnumerationHelper.getEnumDisplayValue('TimezoneBean__mdt', 'TimezoneCode__c', record.get('timezone'), kenanSettings.Stored_Language_Code__c,'DisplayValue__c'));
        if (record.get('unitNo') != null) record.put('unitNo', String.valueOf(record.get('unitNo')));
        if (record.get('unitType') != null) record.put('unitType', String.valueOf(record.get('unitType')));
        if (record.get('vertexGeocode') != null) record.put('vertexGeocode', String.valueOf(record.get('vertexGeocode')));
        if (record.get('viewCreatedDt') != null) record.put('viewCreatedDt', KenanUtils.fixDateTime(record.get('viewCreatedDt')));
        if (record.get('viewEffectiveDt') != null) record.put('viewEffectiveDt', KenanUtils.fixDateTime(record.get('viewEffectiveDt')));
        if (record.get('viewId') != null) record.put('viewId', Integer.valueOf(record.get('viewId')));
        if (record.get('viewStatus') != null) record.put('viewStatus', Integer.valueOf(record.get('viewStatus')));
        
        //if (record.get('extIdList') != null) {
        //    record.put('extIdList', new List<Map<String,String>>());
        //    List<Object> extIdList = (List<Object>) record.get('extIdList');
        //    for(Object o : extIdList){
        //        Map<String,Object> idMap = (Map<String,Object>) o;
        //        Map<String, String> idMapString = new Map<String, String>();
        //        List<Map<String, String>> idList = new List<Map<String, String>>();
        //        for( String key : idMap.keySet()){
        //            idMapString.put(key, String.valueOf(idMap.get(key)));
        //            idList.add(idMapString);
        //        }

        //        record.put('extIdList', idList);
        //        if (idMapString.get('type') == '2'){
        //            record.put('salesforceObjectId', String.valueOf(idMap.get('value')));
        //        }
        //    }
        //}
        
        if (record.get('extData') != null) {
            Map<String, Object> extDataMap = (Map<String, Object>) record.get('extData');
            record.put('extData', KenanUtils.getExternalDataMap(extDataMap));
        }
        
        if (record.get('serviceItems') != null) {
            List<Object> serviceItems = (List<Object>) record.get('serviceItems');
            List<KenanServiceItem> items = new List<KenanServiceItem>();
            for (Object o: serviceItems) {
                Map<String, Object> serviceItem = (Map<String, Object>) o;
                KenanServiceItem item = serviceItemMapper.getDisplayValues(serviceItem);
                items.add(item);
            }   
            record.put('serviceItems', items);     
        }

    }  


    private KenanService convertToKenanObject(Map<String, Object> record){
        KenanService service = new KenanService();

        if (record.get('disconnectDate') != null) service.disconnectDate = KenanUtils.fixDateTime(record.get('disconnectDate'));
        if (record.get('disconnectReason') != null) service.disconnectReason = String.valueOf(record.get('disconnectReason'));
                
        if (record.get('activeDt') != null) service.activeDt = KenanUtils.fixDateTime(record.get('activeDt'));
        if (record.get('address1') != null) service.address1 = String.valueOf(record.get('address1')); 
        if (record.get('address2') != null) service.address2 = String.valueOf(record.get('address2'));
        if (record.get('address3') != null) service.address3 = String.valueOf(record.get('address3'));
        if (record.get('address4') != null) service.address4 = String.valueOf(record.get('address4'));
        if (record.get('addressLocation') != null) service.addressLocation = Integer.valueOf(record.get('addressLocation'));
        if (record.get('addressTypeId') != null) service.addressTypeId = String.valueOf(record.get('addressTypeId'));
        if (record.get('bendAddressId') != null) service.bendAddressId = Integer.valueOf(record.get('bendAddressId'));
        if (record.get('bserviceCompany') != null) service.bserviceCompany = String.valueOf(record.get('bserviceCompany'));
        if (record.get('bserviceFname') != null) service.bserviceFname = String.valueOf(record.get('bserviceFname'));
        if (record.get('bserviceFranchiseTaxCode') != null) service.bserviceFranchiseTaxCode = Integer.valueOf(record.get('bserviceFranchiseTaxCode'));
        if (record.get('bserviceGeocode') != null) service.bserviceGeocode = String.valueOf(record.get('bserviceGeocode'));
        if (record.get('bserviceLname') != null) service.bserviceLname = String.valueOf(record.get('bserviceLname'));
        if (record.get('bserviceMinit') != null) service.bserviceMinit = String.valueOf(record.get('bserviceMinit'));
        if (record.get('bservicePhone') != null) service.bservicePhone = String.valueOf(record.get('bservicePhone'));
        if (record.get('bservicePhone2') != null) service.bservicePhone2 = String.valueOf(record.get('bservicePhone2'));
        if (record.get('changeDt') != null) service.changeDt = KenanUtils.fixDateTime(record.get('changeDt'));
        if (record.get('changeWho') != null) service.changeWho = String.valueOf(record.get('changeWho'));
        if (record.get('chgDt') != null) service.chgDt = KenanUtils.fixDateTime(record.get('chgDt'));
        if (record.get('chgWho') != null) service.chgWho = String.valueOf(record.get('chgWho'));     
        if (record.get('city') != null) service.city = String.valueOf(record.get('city'));
        if (record.get('codeword') != null) service.codeword = String.valueOf(record.get('codeword'));
        if (record.get('converted') != null) service.converted = Integer.valueOf(record.get('converted'));
        if (record.get('countryCode') != null) service.countryCode = String.valueOf(record.get('countryCode'));
        if (record.get('county') != null) service.county = String.valueOf(record.get('county'));
        if (record.get('createDt') != null) service.createDt = KenanUtils.fixDateTime(record.get('createDt'));
        if (record.get('currencyCode') != null) service.currencyCode = String.valueOf(record.get('currencyCode'));
        if (record.get('displayAddressId') != null) service.displayAddressId = Integer.valueOf(record.get('displayAddressId'));
        if (record.get('displayCiemViewId') != null) service.displayCiemViewId = Integer.valueOf(record.get('displayCiemViewId'));
        if (record.get('displayExternalIdType') != null) service.displayExternalIdType = Integer.valueOf(record.get('displayExternalIdType'));
        if (record.get('eligKey1') != null) service.eligKey1 = Integer.valueOf(record.get('eligKey1'));
        if (record.get('eligKey2') != null) service.eligKey2 = Integer.valueOf(record.get('eligKey2'));
        if (record.get('eligKey3') != null) service.eligKey3 = Integer.valueOf(record.get('eligKey3'));
        if (record.get('emfConfigId') != null) service.emfConfigId = Integer.valueOf(record.get('emfConfigId'));

        //TODO: Enumeration ?
        if (record.get('exrateClass') != null) service.exrateClass = Integer.valueOf(record.get('exrateClass'));
        if (record.get('extendedPostalCode') != null) service.extendedPostalCode = String.valueOf(record.get('extendedPostalCode'));
        if (record.get('externalAddressId') != null) service.externalAddressId = String.valueOf(record.get('externalAddressId'));
        if (record.get('franchiseTaxCode') != null) service.franchiseTaxCode = Integer.valueOf(record.get('franchiseTaxCode'));
        if (record.get('fxGeocode') != null) service.fxGeocode = String.valueOf(record.get('fxGeocode'));
        if (record.get('houseNumber') != null) service.houseNumber = String.valueOf(record.get('houseNumber'));
        if (record.get('houseNumberSuffix') != null) service.houseNumberSuffix = String.valueOf(record.get('houseNumberSuffix'));
        if (record.get('intendedViewEffectiveDt') != null) service.intendedViewEffectiveDt = KenanUtils.fixDateTime(record.get('intendedViewEffectiveDt'));
        if (record.get('isActive') != null) service.isActive = Boolean.valueOf(record.get('isActive'));
        if (record.get('isPrepaid') != null) service.isPrepaid = Boolean.valueOf(record.get('isPrepaid'));
        if (record.get('ixcProviderId') != null) service.ixcProviderId = Integer.valueOf(record.get('ixcProviderId'));
        if (record.get('keyLineCode') != null) service.keyLineCode = String.valueOf(record.get('keyLineCode'));
        if (record.get('lecProviderId') != null) service.lecProviderId = Integer.valueOf(record.get('lecProviderId'));
        if (record.get('nearestCrossstreet') != null) service.nearestCrossstreet = String.valueOf(record.get('nearestCrossstreet'));
        if (record.get('noBill') != null) service.noBill = Boolean.valueOf(record.get('noBill'));
        if (record.get('nonpubNonlist') != null) service.nonpubNonlist = Integer.valueOf(record.get('nonpubNonlist'));
        if (record.get('optionalEndorsementLine') != null) service.optionalEndorsementLine = String.valueOf(record.get('optionalEndorsementLine'));
        if (record.get('parentAccountInternalId') != null) service.parentAccountInternalId = Integer.valueOf(record.get('parentAccountInternalId'));
        if (record.get('picDateActive') != null) service.picDateActive = KenanUtils.fixDateTime(record.get('picDateActive'));        
        if (record.get('popUnits') != null) service.popUnits = Integer.valueOf(record.get('popUnits'));
        if (record.get('postalCode') != null) service.postalCode = String.valueOf(record.get('postalCode'));
        if (record.get('postfixDirectional') != null) service.postfixDirectional = String.valueOf(record.get('postfixDirectional'));
        if (record.get('postnetAddressBlockBarcode') != null) service.postnetAddressBlockBarcode = String.valueOf(record.get('postnetAddressBlockBarcode'));
        if (record.get('postnetBarcode') != null) service.postnetBarcode = String.valueOf(record.get('postnetBarcode'));
        if (record.get('prefixDirectional') != null) service.prefixDirectional = String.valueOf(record.get('prefixDirectional'));
        if (record.get('prevViewId') != null) service.prevViewId = Integer.valueOf(record.get('prevViewId'));
        if (record.get('privacyLevel') != null) service.privacyLevel = String.valueOf(record.get('privacyLevel'));
    
        //TODO: Enumeration ?
        if (record.get('rateClass') != null) service.rateClass = Integer.valueOf(record.get('rateClass'));
        if (record.get('restrictedPic') != null) service.restrictedPic = Integer.valueOf(record.get('restrictedPic'));
        if (record.get('revRcvCostCtr') != null) service.revRcvCostCtr = Integer.valueOf(record.get('revRcvCostCtr'));
        if (record.get('salesChannelId') != null) service.salesChannelId = String.valueOf(record.get('salesChannelId'));
        if (record.get('serviceActiveDt') != null) service.serviceActiveDt = KenanUtils.fixDateTime(record.get('serviceActiveDt'));
        if (record.get('serviceCompany') != null) service.serviceCompany = String.valueOf(record.get('serviceCompany'));
        if (record.get('serviceFname') != null) service.serviceFname = String.valueOf(record.get('serviceFname'));
        if (record.get('serviceFranchiseTaxCode') != null) service.serviceFranchiseTaxCode = Integer.valueOf(record.get('serviceFranchiseTaxCode'));
        if (record.get('serviceGeocode') != null) service.serviceGeocode = String.valueOf(record.get('serviceGeocode'));
        if (record.get('serviceInactiveDt') != null) service.serviceInactiveDt = KenanUtils.fixDateTime(record.get('serviceInactiveDt'));
        if (record.get('serviceInternalId') != null) service.serviceInternalId = Integer.valueOf(record.get('serviceInternalId'));
        if (record.get('serviceInternalIdResets') != null) service.serviceInternalIdResets = Integer.valueOf(record.get('serviceInternalIdResets'));
        if (record.get('serviceLname') != null) service.serviceLname = String.valueOf(record.get('serviceLname'));
        if (record.get('serviceMinit') != null) service.serviceMinit = String.valueOf(record.get('serviceMinit'));
        if (record.get('serviceNameGeneration') != null) service.serviceNameGeneration = String.valueOf(record.get('serviceNameGeneration'));
        if (record.get('serviceNamePre') != null) service.serviceNamePre = String.valueOf(record.get('serviceNamePre'));
        if (record.get('servicePhone') != null) service.servicePhone = String.valueOf(record.get('servicePhone'));
        if (record.get('servicePhone2') != null) service.servicePhone2 = String.valueOf(record.get('servicePhone2'));
        if (record.get('simSerialNumber') != null) service.simSerialNumber = String.valueOf(record.get('simSerialNumber'));
        if (record.get('state') != null) service.state = String.valueOf(record.get('state'));

        //TODO: Enumeration ? maybe StatusBean but also need StatusTypeId
        if (record.get('statusId') != null) service.statusId = Integer.valueOf(record.get('statusId'));

        //TODO: Enumeration ? StatusReasonMapBean with statusId
        if (record.get('statusReasonId') != null) service.statusReasonId = Integer.valueOf(record.get('statusReasonId'));

        if (record.get('streetName') != null) service.streetName = String.valueOf(record.get('streetName'));
        if (record.get('streetSuffix') != null) service.streetSuffix = String.valueOf(record.get('streetSuffix'));
        if (record.get('switchId') != null) service.switchId = String.valueOf(record.get('switchId'));

        //TODO: Enumeration TimezoneBean
        if (record.get('timezone') != null) service.timezone = String.valueOf(record.get('timezone'));
        if (record.get('unitNo') != null) service.unitNo = String.valueOf(record.get('unitNo'));
        if (record.get('unitType') != null) service.unitType = String.valueOf(record.get('unitType'));
        if (record.get('vertexGeocode') != null) service.vertexGeocode = String.valueOf(record.get('vertexGeocode'));
        if (record.get('viewCreatedDt') != null) service.viewCreatedDt = KenanUtils.fixDateTime(record.get('viewCreatedDt'));
        if (record.get('viewEffectiveDt') != null) service.viewEffectiveDt = KenanUtils.fixDateTime(record.get('viewEffectiveDt'));
        if (record.get('viewId') != null) service.viewId = Integer.valueOf(record.get('viewId'));
        if (record.get('viewStatus') != null) service.viewStatus = Integer.valueOf(record.get('viewStatus'));
        
        if (record.get('extIdList') != null) service.extIdList = (List<Map<String,String>>)record.get('extIdList');
        
        if (record.get('extData') != null) {
            Map<String, Object> extDataMap = (Map<String, Object>) record.get('extData');
            service.extData = KenanUtils.getExternalDataMap(extDataMap);
        }
        
        if (record.get('serviceItems') != null) {
            List<Object> serviceItems = (List<Object>) record.get('serviceItems');
            for (Object o: serviceItems) {
                KenanServiceItem item = (KenanServiceItem) o;
                service.serviceItems.add(item);
            }        
        }

        return service; 
    }
}