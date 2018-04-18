/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Account Mapper for mapping enumerated values
*/
public class KenanAccountMapper implements KenanObjectMapper {

	private KenanAccountItemMapper accountItemMapper;
	private KenanServiceConnection__c kenanSettings;

	public KenanAccountMapper(){
		accountItemMapper = new KenanAccountItemMapper();
		kenanSettings = KenanServiceConnection__c.getInstance();
	}

	public Map<String,Object> getEnumeratedValues(KenanObject kObject){
		KenanAccount ka = (KenanAccount) kObject;
		
		Map<String,Object> accountMap = new Map<String,Object>();

        if (ka.accountCategory != null) accountMap.put('accountCategory', ka.accountCategory);
		if (ka.accountInternalId != null) accountMap.put('accountInternalId', ka.accountInternalId);
		if (ka.accountType != null) accountMap.put('accountType', ka.accountType);
		if (ka.acctSegId != null) accountMap.put('acctSegId', ka.acctSegId);
		if (ka.altCompanyName != null) accountMap.put('altCompanyName', ka.altCompanyName);
		if (ka.altFname != null) accountMap.put('altFname', ka.altFname);
		if (ka.altLname != null) accountMap.put('altLname', ka.altLname);
		if (ka.billAddress1 != null) accountMap.put('billAddress1', ka.billAddress1);
		if (ka.billAddress2 != null) accountMap.put('billAddress2', ka.billAddress2);
		if (ka.billAddress3 != null) accountMap.put('billAddress3', ka.billAddress3);
		if (ka.billCity != null) accountMap.put('billCity', ka.billCity);
		if (ka.billCompany != null) accountMap.put('billCompany', ka.billCompany);
		if (ka.billCountryCode != null) accountMap.put('billCountryCode', ka.billCountryCode);
		if (ka.billCounty != null) accountMap.put('billCounty', ka.billCounty);
		if (ka.billDispMeth != null) accountMap.put('billDispMeth', ka.billDispMeth);
		if (ka.billFmtOpt != null) accountMap.put('billFmtOpt', ka.billFmtOpt);
		if (ka.billFname != null) accountMap.put('billFname', ka.billFname);
		if (ka.billFranchiseTaxCode != null) accountMap.put('billFranchiseTaxCode', ka.billFranchiseTaxCode);
		if (ka.billLname != null) accountMap.put('billLname', ka.billLname);
		if (ka.billMinit != null) accountMap.put('billMinit', ka.billMinit);
		if (ka.billNameGeneration != null) accountMap.put('billNameGeneration', ka.billNameGeneration);
		if (ka.billNamePre != null) accountMap.put('billNamePre', ka.billNamePre);
		if (ka.billPeriod != null) accountMap.put('billPeriod', ka.billPeriod);
		if (ka.billState != null) accountMap.put('billState', ka.billState);
		if (ka.billTitle != null) accountMap.put('billTitle', ka.billTitle);
		if (ka.billZip != null) accountMap.put('billZip', ka.billZip);
		if (ka.codeword != null) accountMap.put('codeword', ka.codeword);
		if (ka.contact1Name != null) accountMap.put('contact1Name', ka.contact1Name);
		if (ka.contact1Phone != null) accountMap.put('contact1Phone', ka.contact1Phone);
		if (ka.contact2Name != null) accountMap.put('contact2Name', ka.contact2Name);
		if (ka.contact2Phone != null) accountMap.put('contact2Phone', ka.contact2Phone);
		if (ka.currencyCode != null) accountMap.put('currencyCode', ka.currencyCode);
		if (ka.custAddress1 != null) accountMap.put('custAddress1', ka.custAddress1);
		if (ka.custAddress2 != null) accountMap.put('custAddress2', ka.custAddress2);
		if (ka.custAddress3 != null) accountMap.put('custAddress3', ka.custAddress3);
		if (ka.custCity != null) accountMap.put('custCity', ka.custCity);
		if (ka.custCountryCode != null) accountMap.put('custCountryCode', ka.custCountryCode);
		if (ka.custCounty != null) accountMap.put('custCounty', ka.custCounty);
		if (ka.custEmail != null) accountMap.put('custEmail', ka.custEmail);
		if (ka.custFaxno != null) accountMap.put('custFaxno', ka.custFaxno);
		if (ka.custPhone1 != null) accountMap.put('custPhone1', ka.custPhone1);
		if (ka.custPhone2 != null) accountMap.put('custPhone2', ka.custPhone2);
		if (ka.custState != null) accountMap.put('custState', ka.custState);
		if (ka.custZip != null) accountMap.put('custZip', ka.custZip);
		if (ka.dateActive != null) accountMap.put('dateActive', (Datetime) ka.dateActive);
		//if (ka.dateInactive != null) accountMap.put('dateInactive', (Datetime) ka.dateInactive);
		if (ka.dept != null) accountMap.put('dept', ka.dept);
		if (ka.exrateClass != null) accountMap.put('exrateClass', ka.exrateClass);
		if (ka.gender != null) accountMap.put('gender', ka.gender);
		if (ka.mktCode != null) accountMap.put('mktCode', ka.mktCode);
		if (ka.parentAccountExternalId != null) accountMap.put('parentAccountExternalId', ka.parentAccountExternalId);
		if (ka.parentAccountExternalIdType != null) accountMap.put('parentAccountExternalIdType', ka.parentAccountExternalIdType);
		if (ka.rateClassDefault != null) accountMap.put('rateClassDefault', ka.rateClassDefault);
		if (ka.rateClassSpecial != null) accountMap.put('rateClassSpecial', ka.rateClassSpecial);
		if (ka.salesCode != null) accountMap.put('salesCode', ka.salesCode);
		if (ka.sicCode != null) accountMap.put('sicCode', ka.sicCode);
		if (ka.ssn != null) accountMap.put('ssn', ka.ssn);
		if (ka.statementToEmail != null) accountMap.put('statementToEmail', ka.statementToEmail);
		if (ka.statementToFaxno != null) accountMap.put('statementToFaxno', ka.statementToFaxno);
		if (ka.title != null) accountMap.put('title', ka.title);
		if (ka.vipCode != null) accountMap.put('vipCode', ka.vipCode);
		if (ka.extData != null) accountMap.put('extData', ka.extData);
		if (ka.extIdList != null && ka.extIdList.size() > 0){
			accountMap.put('extIdList', ka.extIdList);
		} else {
			accountMap.put('extIdList', '[ null ]');
		}
        if (ka.accountItems != null) {
			accountMap.put('accountItems', ka.accountItems);
		}

		mapEnumeratedValues(accountMap);
		return accountMap;
	}

	public KenanAccount getDisplayValues(Map<String, Object> accountMap){
		KenanServiceConnection__c kenanSettings = KenanServiceConnection__c.getInstance();
		mapDisplayValues(accountMap);
		KenanAccount ka = convertToKenanObject(accountMap);
		return ka;
	}


	private void mapEnumeratedValues(Map<String, Object> record){

		if (record.get('accountCategory') != null) record.put('accountCategory', KenanEnumerationHelper.getEnumKeyValue('AccountCategoryBean__mdt', 'AccountCategory__c', record.get('accountCategory'), kenanSettings.Stored_Language_Code__c, 'DisplayValue__c'));
		if (record.get('accountInternalId') != null) record.put('accountInternalId', record.get('accountInternalId'));
		if (record.get('accountType') != null) record.put('accountType', KenanEnumerationHelper.getEnumKeyValue('AccountType__mdt', 'Key__c', record.get('accountType'), 'MasterLabel'));
		if (record.get('acctSegId') != null) record.put('acctSegId', KenanEnumerationHelper.getEnumKeyValue('AccountSegmentMapBean__mdt', 'AcctSegId__c', record.get('acctSegId'), kenanSettings.Stored_Language_Code__c, 'DisplayValue__c'));
		if (record.get('altCompanyName') != null) record.put('altCompanyName', record.get('altCompanyName'));
		if (record.get('altFname') != null) record.put('altFname', record.get('altFname'));
		if (record.get('altLname') != null) record.put('altLname', record.get('altLname'));
		if (record.get('billAddress1') != null) record.put('billAddress1', record.get('billAddress1'));
		if (record.get('billAddress2') != null) record.put('billAddress2', record.get('billAddress2'));
		if (record.get('billAddress3') != null) record.put('billAddress3', record.get('billAddress3'));
		if (record.get('billCity') != null) record.put('billCity', record.get('billCity'));
		if (record.get('billCompany') != null) record.put('billCompany', record.get('billCompany'));
		if (record.get('billCountryCode') != null) record.put('billCountryCode', record.get('billCountryCode'));
		if (record.get('billCounty') != null) record.put('billCounty', record.get('billCounty'));
		if (record.get('billDispMeth') != null) record.put('billDispMeth', KenanEnumerationHelper.getEnumKeyValue('BillDispatchMethodBean__mdt', 'BillDispMeth__c', String.valueOf(record.get('billDispMeth')), kenanSettings.Stored_Language_Code__c, 'DisplayValue__c'));
		if (record.get('billFmtOpt') != null) record.put('billFmtOpt', KenanEnumerationHelper.getEnumKeyValue('BillFmtOptBean__mdt', 'BillFmtOpt__c', record.get('billFmtOpt'), kenanSettings.Stored_Language_Code__c, 'DisplayValue__c'));
		if (record.get('billFname') != null) record.put('billFname', record.get('billFname'));
		if (record.get('billFranchiseTaxCode') != null) record.put('billFranchiseTaxCode', record.get('billFranchiseTaxCode'));
		if (record.get('billLname') != null) record.put('billLname', record.get('billLname'));
		if (record.get('billMinit') != null) record.put('billMinit', record.get('billMinit'));
		if (record.get('billNameGeneration') != null) record.put('billNameGeneration', record.get('billNameGeneration'));
		if (record.get('billNamePre') != null) record.put('billNamePre', record.get('billNamePre'));
		if (record.get('billPeriod') != null) record.put('billPeriod', KenanEnumerationHelper.getEnumKeyValue('BillPeriodBean__mdt', 'BillPeriod__c', record.get('billPeriod'), kenanSettings.Stored_Language_Code__c, 'DisplayValue__c'));
		if (record.get('billState') != null) record.put('billState', record.get('billState'));
		if (record.get('billTitle') != null) record.put('billTitle', record.get('billTitle'));
		if (record.get('billZip') != null) record.put('billZip', record.get('billZip'));
		if (record.get('codeword') != null) record.put('codeword', record.get('codeword'));
		if (record.get('contact1Name') != null) record.put('contact1Name', record.get('contact1Name'));
		if (record.get('contact1Phone') != null) record.put('contact1Phone', record.get('contact1Phone'));
		if (record.get('contact2Name') != null) record.put('contact2Name', record.get('contact2Name'));
		if (record.get('contact2Phone') != null) record.put('contact2Phone', record.get('contact2Phone'));
		if (record.get('currencyCode') != null) record.put('currencyCode', KenanEnumerationHelper.getEnumKeyValue('RateCurrencyBean__mdt', 'CurrencyCode__c', record.get('currencyCode'), kenanSettings.Stored_Language_Code__c, 'ShortDisplay__c'));
		if (record.get('custAddress1') != null) record.put('custAddress1', record.get('custAddress1'));
		if (record.get('custAddress2') != null) record.put('custAddress2', record.get('custAddress2'));
		if (record.get('custAddress3') != null) record.put('custAddress3', record.get('custAddress3'));
		if (record.get('custCity') != null) record.put('custCity', record.get('custCity'));
		if (record.get('custCountryCode') != null) record.put('custCountryCode', record.get('custCountryCode'));
		if (record.get('custCounty') != null) record.put('custCounty', record.get('custCounty'));
		if (record.get('custEmail') != null) record.put('custEmail', record.get('custEmail'));
		if (record.get('custFaxno') != null) record.put('custFaxno', record.get('custFaxno'));
		if (record.get('custPhone1') != null) record.put('custPhone1', record.get('custPhone1'));
		if (record.get('custPhone2') != null) record.put('custPhone2', record.get('custPhone2'));
		if (record.get('custState') != null) record.put('custState', record.get('custState'));
		if (record.get('custZip') != null) record.put('custZip', record.get('custZip'));
		if (record.get('dateActive') != null) record.put('dateActive', (Datetime) record.get('dateActive'));
		//if (record.get('dateInactive') != null) record.put('dateInactive', (Datetime) record.get('dateInactive'));
		if (record.get('dept') != null) record.put('dept', record.get('dept'));
		if (record.get('exrateClass') != null) record.put('exrateClass', record.get('exrateClass'));
		if (record.get('gender') != null) record.put('gender', record.get('gender'));
		if (record.get('mktCode') != null) record.put('mktCode', KenanEnumerationHelper.getEnumKeyValue('MktCodeBean__mdt', 'MktCode__c', record.get('mktCode'), kenanSettings.Stored_Language_Code__c, 'DisplayValue__c'));
		if (record.get('parentAccountExternalId') != null) record.put('parentAccountExternalId', record.get('parentAccountExternalId'));
		if (record.get('parentAccountExternalIdType') != null) record.put('parentAccountExternalIdType', record.get('parentAccountExternalIdType'));
		if (record.get('rateClassDefault') != null) record.put('rateClassDefault', KenanEnumerationHelper.getEnumKeyValue('RateClassDescrBean__mdt', 'RateClass__c', record.get('rateClassDefault'), kenanSettings.Stored_Language_Code__c, 'DescriptionText__c'));
		if (record.get('rateClassSpecial') != null) record.put('rateClassSpecial', record.get('rateClassSpecial'));
		if (record.get('salesCode') != null) record.put('salesCode', record.get('salesCode'));
		if (record.get('sicCode') != null) record.put('sicCode', record.get('sicCode'));
		if (record.get('ssn') != null) record.put('ssn', record.get('ssn'));
		if (record.get('statementToEmail') != null) record.put('statementToEmail', record.get('statementToEmail'));
		if (record.get('statementToFaxno') != null) record.put('statementToFaxno', record.get('statementToFaxno'));
		if (record.get('title') != null) record.put('title', record.get('title'));
		if (record.get('vipCode') != null) record.put('vipCode', record.get('vipCode'));
		if (record.get('extData') != null) record.put('extData', record.get('extData'));
		if (record.get('extIdList') != null){
			record.put('extIdList', record.get('extIdList'));
		} else {
			record.put('extIdList', '[ null ]');
		}        

		if (record.get('accountItems') != null) {
			List<Map<String, Object>> accountItemsMap = new List<Map<String, Object>>();
			List<KenanAccountItem> accountItems = (List<KenanAccountItem>) record.get('accountItems');
			for (KenanAccountItem accountItem: accountItems) {
				accountItemsMap.add((Map<String, Object>) accountItemMapper.getEnumeratedValues(accountItem));
			}
			record.put('accountItems', accountItemsMap);
		}
    }

    private void mapDisplayValues(Map<String, Object> record){

    	if (record.get('accountCategory') != null) record.put('accountCategory', KenanEnumerationHelper.getEnumDisplayValue('AccountCategoryBean__mdt', 'AccountCategory__c', record.get('accountCategory'), kenanSettings.Stored_Language_Code__c, 'DisplayValue__c'));
		if (record.get('accountInternalId') != null) record.put('accountInternalId', Integer.valueOf(record.get('accountInternalId')));
		if (record.get('accountType') != null) record.put('accountType', KenanEnumerationHelper.getEnumDisplayValue('AccountType__mdt', 'Key__c', record.get('accountType'), 'MasterLabel'));
		//if (record.get('acctSegId') != null) record.put('acctSegId', KenanEnumerationHelper.getEnumDisplayValue('AccountSegmentMapBean__mdt', 'AcctSegId__c', String.valueOf(record.get('acctSegId')), 'DisplayValue__c');
		if (record.get('acctSegId') != null) record.put('acctSegId', String.valueOf(record.get('acctSegId')));
		if (record.get('altCompanyName') != null) record.put('altCompanyName', String.valueOf(record.get('altCompanyName')));
		if (record.get('altFname') != null) record.put('altFname', String.valueOf(record.get('altFname')));
		if (record.get('altLname') != null) record.put('altLname', String.valueOf(record.get('altLname')));
		if (record.get('billAddress1') != null) record.put('billAddress1', String.valueOf(record.get('billAddress1')));
		if (record.get('billAddress2') != null) record.put('billAddress2', String.valueOf(record.get('billAddress2')));
		if (record.get('billAddress3') != null) record.put('billAddress3', String.valueOf(record.get('billAddress3')));
		if (record.get('billCity') != null) record.put('billCity', String.valueOf(record.get('billCity')));
		if (record.get('billCompany') != null) record.put('billCompany', String.valueOf(record.get('billCompany')));
		if (record.get('billCountryCode') != null) record.put('billCountryCode', Integer.valueOf(record.get('billCountryCode')));
		if (record.get('billCounty') != null) record.put('billCounty', String.valueOf(record.get('billCounty')));
		if (record.get('billDispMeth') != null) record.put('billDispMeth', KenanEnumerationHelper.getEnumDisplayValue('BillDispatchMethodBean__mdt', 'BillDispMeth__c', record.get('billDispMeth'), kenanSettings.Stored_Language_Code__c, 'DisplayValue__c'));
		if (record.get('billFmtOpt') != null) record.put('billFmtOpt', KenanEnumerationHelper.getEnumDisplayValue('BillFmtOptBean__mdt', 'BillFmtOpt__c', record.get('billFmtOpt'), kenanSettings.Stored_Language_Code__c, 'DisplayValue__c'));
		if (record.get('billFname') != null) record.put('billFname', String.valueOf(record.get('billFname')));
		if (record.get('billFranchiseTaxCode') != null) record.put('billFranchiseTaxCode', Integer.valueOf(record.get('billFranchiseTaxCode')));
		if (record.get('billLname') != null) record.put('billLname', String.valueOf(record.get('billLname')));
		if (record.get('billMinit') != null) record.put('billMinit', String.valueOf(record.get('billMinit')));
		if (record.get('billNameGeneration') != null) record.put('billNameGeneration', String.valueOf(record.get('billNameGeneration')));
		if (record.get('billNamePre') != null) record.put('billNamePre', String.valueOf(record.get('billNamePre')));
		if (record.get('billPeriod') != null) record.put('billPeriod', KenanEnumerationHelper.getEnumDisplayValue('BillPeriodBean__mdt', 'BillPeriod__c', record.get('billPeriod'), kenanSettings.Stored_Language_Code__c, 'DisplayValue__c'));
		if (record.get('billState') != null) record.put('billState', String.valueOf(record.get('billState')));
		if (record.get('billTitle') != null) record.put('billTitle', String.valueOf(record.get('billTitle')));
		if (record.get('billZip') != null) record.put('billZip', String.valueOf(record.get('billZip')));
		
		if (record.get('codeword') != null) record.put('codeword', String.valueOf(record.get('codeword')));
		
		if (record.get('contact1Name') != null) record.put('contact1Name', String.valueOf(record.get('contact1Name')));
		if (record.get('contact1Phone') != null) record.put('contact1Phone', String.valueOf(record.get('contact1Phone')));
		if (record.get('contact2Name') != null) record.put('contact2Name', String.valueOf(record.get('contact2Name')));
		if (record.get('contact2Phone') != null) record.put('contact2Phone', String.valueOf(record.get('contact2Phone')));
		if (record.get('currencyCode') != null) record.put('currencyCode', KenanEnumerationHelper.getEnumDisplayValue('RateCurrencyBean__mdt', 'CurrencyCode__c', record.get('currencyCode'), kenanSettings.Stored_Language_Code__c, 'ShortDisplay__c'));
		if (record.get('custAddress1') != null) record.put('custAddress1', String.valueOf(record.get('custAddress1')));
		if (record.get('custAddress2') != null) record.put('custAddress2', String.valueOf(record.get('custAddress2')));
		if (record.get('custAddress3') != null) record.put('custAddress3', String.valueOf(record.get('custAddress3')));
		if (record.get('custCity') != null) record.put('custCity', String.valueOf(record.get('custCity')));
		if (record.get('custCountryCode') != null) record.put('custCountryCode', Integer.valueOf(record.get('custCountryCode')));
		if (record.get('custCounty') != null) record.put('custCounty', String.valueOf(record.get('custCounty')));
		if (record.get('custEmail') != null) record.put('custEmail', String.valueOf(record.get('custEmail')));
		if (record.get('custFaxno') != null) record.put('custFaxno', String.valueOf(record.get('custFaxno')));
		if (record.get('custPhone1') != null) record.put('custPhone1', String.valueOf(record.get('custPhone1')));
		if (record.get('custPhone2') != null) record.put('custPhone2', String.valueOf(record.get('custPhone2')));
		if (record.get('custState') != null) record.put('custState', String.valueOf(record.get('custState')));
		if (record.get('custZip') != null) record.put('custZip', String.valueOf(record.get('custZip')));
		if (record.get('dateActive') != null) record.put('dateActive', KenanUtils.fixDateTime(record.get('dateActive')));
		if (record.get('dateInactive') != null) record.put('dateInactive', KenanUtils.fixDateTime(record.get('dateInactive')));
		if (record.get('dept') != null) record.put('dept', String.valueOf(record.get('dept')));
		if (record.get('exrateClass') != null) record.put('exrateClass', Integer.valueOf(record.get('exrateClass')));
		if (record.get('gender') != null) record.put('gender', Integer.valueOf(record.get('gender')));
		if (record.get('mktCode') != null) record.put('mktCode', KenanEnumerationHelper.getEnumDisplayValue('MktCodeBean__mdt', 'MktCode__c', record.get('mktCode'), kenanSettings.Stored_Language_Code__c, 'DisplayValue__c'));
		if (record.get('parentAccountExternalId') != null) record.put('parentAccountExternalId', String.valueOf(record.get('parentAccountExternalId')));
		if (record.get('parentAccountExternalIdType') != null) record.put('parentAccountExternalIdType', Integer.valueOf(record.get('parentAccountExternalIdType')));
		if (record.get('rateClassDefault') != null) record.put('rateClassDefault', KenanEnumerationHelper.getEnumDisplayValue('RateClassDescrBean__mdt', 'RateClass__c', record.get('rateClassDefault'), kenanSettings.Stored_Language_Code__c, 'DescriptionText__c'));
		if (record.get('rateClassSpecial') != null) record.put('rateClassSpecial', Integer.valueOf(record.get('rateClassSpecial')));
		if (record.get('salesCode') != null) record.put('salesCode', String.valueOf(record.get('salesCode')));
		if (record.get('sicCode') != null) record.put('sicCode', Integer.valueOf(record.get('sicCode')));
		if (record.get('ssn') != null) record.put('ssn', String.valueOf(record.get('ssn')));
		if (record.get('statementToEmail') != null) record.put('statementToEmail', String.valueOf(record.get('statementToEmail')));
		if (record.get('statementToFaxno') != null) record.put('statementToFaxno', String.valueOf(record.get('statementToFaxno')));
		if (record.get('title') != null) record.put('title', String.valueOf(record.get('title')));
		if (record.get('vipCode') != null) record.put('vipCode', Integer.valueOf(record.get('vipCode')));
		
		if (record.get('extIdList') != null) {
			List<Object> extIdList = (List<Object>) record.get('extIdList');
			
			for (Object o : extIdList){
				Map<String,Object> idMap = (Map<String,Object>) o;
				Map<String, String> idMapString = new Map<String, String>();
				List<Map<String, String>> idList = new List<Map<String, String>>();
				for ( String key : idMap.keySet()){
					idMapString.put(key, String.valueOf(idMap.get(key)));
					idList.add(idMapString);
				}

				record.put('extIdList', idList);
				if (idMapString.get('type') == '2'){
					record.put('salesforceObjectId', String.valueOf(idMap.get('value')));
				}
			}
		}
		
		if (record.get('extData') != null) {
			Map<String, Object> extDataMap = (Map<String, Object>) record.get('extData');
			record.put('extData', KenanUtils.getExternalDataMap(extDataMap));
		}

		if (record.get('accountItems') != null) {
            List<Object> accountItems = (List<Object>) record.get('accountItems');
            List<KenanAccountItem> items = new List<KenanAccountItem>();
            for (Object o: accountItems) {
                Map<String, Object> accountItem = (Map<String, Object>) o;
                KenanAccountItem item = accountItemMapper.getDisplayValues(accountItem);
                items.add(item);
            }   
            record.put('accountItems', items);     
        }
    }    

    private KenanAccount convertToKenanObject(Map<String, Object> accountMap){
    	KenanAccount ka = new KenanAccount();

        if (accountMap.get('accountCategory') != null) ka.accountCategory = String.valueOf(accountMap.get('accountCategory'));
		if (accountMap.get('accountInternalId') != null) ka.accountInternalId = Integer.valueOf(accountMap.get('accountInternalId'));
		if (accountMap.get('accountType') != null) ka.accountType = String.valueOf(accountMap.get('accountType'));
		//if (accountMap.get('acctSegId') != null) ka.acctSegId = KenanEnumerationHelper.getEnumDisplayValue('AccountSegmentMapBean__mdt', 'AcctSegId__c', String.valueOf(accountMap.get('acctSegId')), 'DisplayValue__c');
		if (accountMap.get('acctSegId') != null) ka.acctSegId = String.valueOf(accountMap.get('acctSegId'));
		if (accountMap.get('altCompanyName') != null) ka.altCompanyName = String.valueOf(accountMap.get('altCompanyName'));
		if (accountMap.get('altFname') != null) ka.altFname = String.valueOf(accountMap.get('altFname'));
		if (accountMap.get('altLname') != null) ka.altLname = String.valueOf(accountMap.get('altLname'));
		if (accountMap.get('billAddress1') != null) ka.billAddress1 = String.valueOf(accountMap.get('billAddress1'));
		if (accountMap.get('billAddress2') != null) ka.billAddress2 = String.valueOf(accountMap.get('billAddress2'));
		if (accountMap.get('billAddress3') != null) ka.billAddress3 = String.valueOf(accountMap.get('billAddress3'));
		if (accountMap.get('billCity') != null) ka.billCity = String.valueOf(accountMap.get('billCity'));
		if (accountMap.get('billCompany') != null) ka.billCompany = String.valueOf(accountMap.get('billCompany'));
		if (accountMap.get('billCountryCode') != null) ka.billCountryCode = Integer.valueOf(accountMap.get('billCountryCode'));
		if (accountMap.get('billCounty') != null) ka.billCounty = String.valueOf(accountMap.get('billCounty'));
		if (accountMap.get('billDispMeth') != null) ka.billDispMeth = String.valueOf(accountMap.get('billDispMeth'));
		if (accountMap.get('billFmtOpt') != null) ka.billFmtOpt = String.valueOf(accountMap.get('billFmtOpt'));
		if (accountMap.get('billFname') != null) ka.billFname = String.valueOf(accountMap.get('billFname'));
		if (accountMap.get('billFranchiseTaxCode') != null) ka.billFranchiseTaxCode = Integer.valueOf(accountMap.get('billFranchiseTaxCode'));
		if (accountMap.get('billLname') != null) ka.billLname = String.valueOf(accountMap.get('billLname'));
		if (accountMap.get('billMinit') != null) ka.billMinit = String.valueOf(accountMap.get('billMinit'));
		if (accountMap.get('billNameGeneration') != null) ka.billNameGeneration = String.valueOf(accountMap.get('billNameGeneration'));
		if (accountMap.get('billNamePre') != null) ka.billNamePre = String.valueOf(accountMap.get('billNamePre'));
		if (accountMap.get('billPeriod') != null) ka.billPeriod = String.valueOf(accountMap.get('billPeriod'));
		if (accountMap.get('billState') != null) ka.billState = String.valueOf(accountMap.get('billState'));
		if (accountMap.get('billTitle') != null) ka.billTitle = String.valueOf(accountMap.get('billTitle'));
		if (accountMap.get('billZip') != null) ka.billZip = String.valueOf(accountMap.get('billZip'));
		if (accountMap.get('codeword') != null) ka.codeword = String.valueOf(accountMap.get('codeword'));
		if (accountMap.get('contact1Name') != null) ka.contact1Name = String.valueOf(accountMap.get('contact1Name'));
		if (accountMap.get('contact1Phone') != null) ka.contact1Phone = String.valueOf(accountMap.get('contact1Phone'));
		if (accountMap.get('contact2Name') != null) ka.contact2Name = String.valueOf(accountMap.get('contact2Name'));
		if (accountMap.get('contact2Phone') != null) ka.contact2Phone = String.valueOf(accountMap.get('contact2Phone'));
		if (accountMap.get('currencyCode') != null) ka.currencyCode = String.valueOf(accountMap.get('currencyCode'));
		if (accountMap.get('custAddress1') != null) ka.custAddress1 = String.valueOf(accountMap.get('custAddress1'));
		if (accountMap.get('custAddress2') != null) ka.custAddress2 = String.valueOf(accountMap.get('custAddress2'));
		if (accountMap.get('custAddress3') != null) ka.custAddress3 = String.valueOf(accountMap.get('custAddress3'));
		if (accountMap.get('custCity') != null) ka.custCity = String.valueOf(accountMap.get('custCity'));
		if (accountMap.get('custCountryCode') != null) ka.custCountryCode = Integer.valueOf(accountMap.get('custCountryCode'));
		if (accountMap.get('custCounty') != null) ka.custCounty = String.valueOf(accountMap.get('custCounty'));
		if (accountMap.get('custEmail') != null) ka.custEmail = String.valueOf(accountMap.get('custEmail'));
		if (accountMap.get('custFaxno') != null) ka.custFaxno = String.valueOf(accountMap.get('custFaxno'));
		if (accountMap.get('custPhone1') != null) ka.custPhone1 = String.valueOf(accountMap.get('custPhone1'));
		if (accountMap.get('custPhone2') != null) ka.custPhone2 = String.valueOf(accountMap.get('custPhone2'));
		if (accountMap.get('custState') != null) ka.custState = String.valueOf(accountMap.get('custState'));
		if (accountMap.get('custZip') != null) ka.custZip = String.valueOf(accountMap.get('custZip'));
		if (accountMap.get('dateActive') != null) ka.dateActive = KenanUtils.fixDateTime(accountMap.get('dateActive'));
		if (accountMap.get('dateInactive') != null) ka.dateInactive = KenanUtils.fixDateTime(accountMap.get('dateInactive'));
		if (accountMap.get('dept') != null) ka.dept = String.valueOf(accountMap.get('dept'));
		if (accountMap.get('exrateClass') != null) ka.exrateClass = Integer.valueOf(accountMap.get('exrateClass'));
		if (accountMap.get('gender') != null) ka.gender = Integer.valueOf(accountMap.get('gender'));
		if (accountMap.get('mktCode') != null) ka.mktCode = String.valueOf(accountMap.get('mktCode'));
		if (accountMap.get('parentAccountExternalId') != null) ka.parentAccountExternalId = String.valueOf(accountMap.get('parentAccountExternalId'));
		if (accountMap.get('parentAccountExternalIdType') != null) ka.parentAccountExternalIdType = Integer.valueOf(accountMap.get('parentAccountExternalIdType'));
		if (accountMap.get('rateClassDefault') != null) ka.rateClassDefault = String.valueOf(accountMap.get('rateClassDefault'));
		if (accountMap.get('rateClassSpecial') != null) ka.rateClassSpecial = Integer.valueOf(accountMap.get('rateClassSpecial'));
		if (accountMap.get('revRcvCostCtr') != null) ka.revRcvCostCtr = Integer.valueOf(accountMap.get('revRcvCostCtr'));
		if (accountMap.get('salesCode') != null) ka.salesCode = String.valueOf(accountMap.get('salesCode'));
		if (accountMap.get('sicCode') != null) ka.sicCode = Integer.valueOf(accountMap.get('sicCode'));
		if (accountMap.get('ssn') != null) ka.ssn = String.valueOf(accountMap.get('ssn'));
		if (accountMap.get('statementToEmail') != null) ka.statementToEmail = String.valueOf(accountMap.get('statementToEmail'));
		if (accountMap.get('statementToFaxno') != null) ka.statementToFaxno = String.valueOf(accountMap.get('statementToFaxno'));
		if (accountMap.get('title') != null) ka.title = String.valueOf(accountMap.get('title'));
		if (accountMap.get('vipCode') != null) ka.vipCode = Integer.valueOf(accountMap.get('vipCode'));
		if (accountMap.get('salesforceObjectId') != null) ka.salesforceObjectId = String.valueOf(accountMap.get('salesforceObjectId'));
		
		//if (accountMap.get('extIdList') != null) ka.extIdList = (List<Map<String,String>>)accountMap.get('extIdList');		
		ka.extIdList = getExtList(accountMap.get('extIdList'));
		
		if (accountMap.get('extData') != null) {
			Map<String, Object> extDataMap = (Map<String, Object>) accountMap.get('extData');
			ka.extData = KenanUtils.getExternalDataMap(extDataMap);
		}

		if (accountMap.get('accountItems') != null) {
			ka.accountItems = (List<KenanAccountItem>) accountMap.get('accountItems');
		}

		return ka;
    }

    private List<Map<String, String>> getExtList(Object extList){
    	List<Map<String, String>> extIdList = new List<Map<String, String>>();
    	if (extList != null){
    		List<Object> objectList = (List<Object>) extList;
    		for (Object extMap : objectList){
    			Map<String, String> objectMap = (Map<String, String>) extMap;
    			if (objectMap != null) extIdList.add(objectMap);
    		}
    	}

    	if (extIdList.isEmpty()){
    		return null;
    	}

    	return extIdList;
		//if (extList!= null) ka.extIdList = (List<Map<String,String>>)accountMap.get('extIdList');

    }


}