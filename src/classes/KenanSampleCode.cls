/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Sample Code
*/

//@isTest
public class KenanSampleCode {

    public static void sendAccountCreate(){
        KenanConnectorService service = new KenanConnectorService();
        Account a = new Account();
        a.Name = 'Sample Account ' + String.valueOf(Datetime.now());
        insert a;
        createAccount(a.Id);
    }

    public static KenanAccount sendAccountModify(){
        KenanConnectorService service = new KenanConnectorService();
        KenanAccount act = createSampleUpdateKenanAccount();
        KenanAccount actBack = service.accountUpdate(act);
        return actBack;
    }

    public static Boolean sendAccountCease(){
        KenanConnectorService service = new KenanConnectorService();
        KenanAccount act = createSampleCeaseKenanAccount();
        Boolean actBack = service.accountCease(act);
        return actBack;
    }

    public static void createSampleHeirarchy(){
        List<Account> accounts = new List<Account>();
        Set<String> accountIds = new Set<String>();
        for (Integer i = 0; i < 3; i++) {
            Account a = new Account();
            a.Name = 'Sample Account num' + i + ' = ' + String.valueOf(Datetime.now().addDays(i));
            accounts.add(a);
        }
        insert accounts;
        for(Account a : accounts){
            accountIds.add(a.Id);
        }
        createHierarchy(accountIds);
    }
    
    public static void createSampleService(){
        /*
        Item Types
        1= NRC
        0=Product
        
        NRC: 
        1200 - 1221
        1300 - 1302
        2069 - 2152
        
        Products: 
        1000 - 1056
        2000 - 2068
        2153
        
        Contracts
        1901
        
        */
        KenanConnectorService connector = new KenanConnectorService();
        DateTime timeStamp = DateTime.now();
        KenanServiceConnection__c setting = KenanServiceConnection__c.getInstance();
        KenanService service = new KenanService();
        Account a = [Select Id from Account WHERE Name like 'Sample Account%' Limit 1];

        service.sfdcAccountId = a.id;
        service.activeDt = timeStamp;
        service.address1 = '612 Hamilton Street';
        service.addressLocation = 1;
        service.addressTypeId = 'Not Free-form';
        service.city = 'Allentown';
        service.countryCode = 'United States';
        service.emfConfigId = 1;
        service.postalCode = '18101';
        service.privacyLevel = 'No mask';
        service.revRcvCostCtr = 1;
        service.state = 'PA';
        
        service.extIdList = new List<Map<String, String>>();
        Map<String, String> extMap = new Map<String, String>();
        DateTime curDate = DateTime.now();
        Long unixDate = curDate.getTime();
        extMap.put('value', String.valueOf(unixDate)); // replace the unixDate with the Service Record Id Value
        extMap.put('type', setting.Default_Service_External_IdType__c);
        service.extIdList.add(extMap);
        
        service.extData = new Map<String, Object>();
        service.extData.put('4', '1901');
        service.extData.put('5', DateTime.now());
        service.extData.put('7', DateTime.now());
        service.extData.put('8', DateTime.now().addYears(2));
        service.extData.put('10', '1');
        
        List<KenanServiceItem> items = new List<KenanServiceItem>();
        KenanServiceItem item = new KenanServiceItem();
        item.itemId = 1200;
        item.itemType = 1;
        item.rate = 1000;
        item.currencyCode = 'KRW';
        items.add(item);
        
        item = new KenanServiceItem();
        item.itemId = 1901;
        item.itemType = 2;
        item.rate = 10000;
        item.currencyCode = 'KRW';
        items.add(item);
        
        item = new KenanServiceItem();
        item.itemId = 1000;
        item.itemType = 0;
        item.rate = 2000;
        item.currencyCode = 'KRW';
        items.add(item);        
        service.serviceItems = items;
        
        connector.serviceCreate(service);
    }
    
    public static void modifySampleService(String serviceExternalId){
        KenanConnectorService connector = new KenanConnectorService();
        DateTime timeStamp = DateTime.now();
        KenanService service = new KenanService();
        service.salesforceObjectId = serviceExternalId;
        service.activeDt = timeStamp.addDays(365);
        service.emfConfigId = 1;
        service.privacyLevel = 'No mask';
        service.revRcvCostCtr = 1;
                    
        service.extData = new Map<String, Object>();
        service.extData.put('4', '1901');
        service.extData.put('5', Datetime.now());
        service.extData.put('7', Datetime.now());
        service.extData.put('8', Datetime.now().addYears(1));
        service.extData.put('10', '1');
                
        KenanService service2 = connector.serviceModify(service);
    }
    
    public static void ceaseSampleService(String serviceExternalId){
        KenanConnectorService connector = new KenanConnectorService();
        DateTime timeStamp = DateTime.now().addDays(30);
        KenanService service = new KenanService();
        service.salesforceObjectId = serviceExternalId;
        service.disconnectReason = 'Customer request';
        service.disconnectDate = timeStamp;
        connector.serviceCease(service);
    }
    
    public static void createSampleOrder(Integer numberOfOrders, Boolean includeNRC, Boolean nrcItemsOnly){
        KenanConnectorService connector = new KenanConnectorService();
        DateTime timeStamp = DateTime.now();
        List<KenanService> services = new List<KenanService>();
        
        Account a = [Select Id from Account WHERE Name like 'Sample Account%' Limit 1];
        for (Integer i = 0; i <= numberOfOrders; i++) {
            KenanService service = new KenanService();
            service.sfdcAccountId = a.id;
            service.activeDt = timeStamp;
            service.address1 = '612 Hamilton Street';
            service.addressLocation = 1;
            service.addressTypeId = 'Not Free-form';
            service.city = 'Allentown';
            service.countryCode = 'United States';
            service.emfConfigId = 1;
            service.postalCode = '18101';
            service.privacyLevel = 'No mask';
            service.revRcvCostCtr = 1;
            service.state = 'PA';
            
            service.extIdList = new List<Map<String, String>>();
            Map<String, String> extMap = new Map<String, String>();
            DateTime curDate = DateTime.now();
            Long unixDate = curDate.getTime();
            extMap.put('value', String.valueOf(unixDate));
            extMap.put('type', '2');
            service.extIdList.add(extMap);
            
            service.extData = new Map<String, Object>();
            service.extData.put('4', '1901');
            service.extData.put('5', DateTime.now());
            service.extData.put('7', DateTime.now());
            service.extData.put('8', DateTime.now().addYears(2));
            service.extData.put('10', '1');
            
            List<KenanServiceItem> items = new List<KenanServiceItem>();
            KenanServiceItem item = new KenanServiceItem();
            if (includeNRC){
                item.itemId = 1200;
                item.itemType = 1;
                item.rate = 1000;
                item.currencyCode = 'EUR';
                items.add(item);
            }

            if (!nrcItemsOnly) {
                item = new KenanServiceItem();
                item.itemId = 1901;
                item.itemType = 2;
                item.rate = 10000;
                item.currencyCode = 'EUR';
                items.add(item);
                
                item = new KenanServiceItem();
                item.itemId = 1000;
                item.itemType = 0;
                item.rate = 2000;
                item.currencyCode = 'EUR';
                items.add(item);        
            }
            service.serviceItems = items;
            services.add(service);
        }
        
        List<KenanService> newServices = connector.orderCreate(services);
        system.debug(newServices);
    }
    
    public static KenanServiceItem createSampleServiceItem(String serviceExternalId, Integer serviceExternalIdType){
        KenanServiceItem item = new KenanServiceItem();
        item.serviceExternalId = serviceExternalId;
        item.serviceExternalIdType = serviceExternalIdType;
        item.itemId = 1000;
        item.itemType = 0;
        // Rate is not necessary
        item.rate = 20.00;
        item.currencyCode = 'KRW';
        KenanConnectorService connector = new KenanConnectorService();
        return connector.serviceItemCreate(item).get(0);
    }

    public static KenanAccount createSampleInsertKenanAccount(String AccountId){
        KenanAccount ka = new KenanAccount();
        
        ka.salesforceOrgId = UserInfo.getOrganizationId();
        ka.salesforceObjectId = AccountId;
        ka.accountCategory = 'SME';             //Required
        //ka.accountExternalId = '';
        //ka.accountExternalIdType = 1;
        //ka.accountInternalId = 11;
        //ka.accountProcessFlag = 1;            //Required
        //ka.accountStatus = 1;
        //ka.accountStatusDt = Datetime.now();
        //ka.accountType = 'billable';
        //ka.acctSegId = 0;
        //ka.activeDate = Datetime.now();
        //ka.altCompanyName = '';
        //ka.altFname = '';
        //ka.altLname = '';
        //ka.autoWriteoffStatus = 0;
        ka.billAddress1 = '612 Hamilton';               //Required
        //ka.billAddress2 = '';
        //ka.billAddress3 = '';
        ka.billCity = 'Mertztown';                  //Required
        ka.billCompany = 'Trifecta '    + String.valueOf(Datetime.now());               //Required
        ka.billCountryCode = 840;
        //ka.billCounty = '';
        //ka.billDispMeth = 0;
        //ka.billFmtOpt = 1;
        ka.billFname = 'Jack';
        ka.billFranchiseTaxCode = 1;
        //ka.billGeocode = '';
        //ka.billHoldCode = 0;
        ka.billLname = 'Hobert';                    //Required
        //ka.billMinit = '';
        //ka.billNameGeneration = '';
        //ka.billNamePre = '';
        //ka.billPeriod = '';
        //ka.billSequenceNum = 0;
        ka.billState = 'PA';                    //Required
        //ka.billTitle = '';
        ka.billZip = '18101';                   //Required
        //ka.billingFrequency = 1;
        //ka.chargeThreshold = 900;
        //ka.chgDate = Datetime.now();
        //ka.chgWho = '';
        //ka.childCount = 0;
        //ka.codeword  = '';
        //ka.collectionHistory  = '';
        //ka.collectionIndicator  = 0;
        //ka.collectionStatus  = 0;
        //ka.contact1Name  = '';
        //ka.contact1Phone  = '';
        //ka.contact2Name  = '';
        //ka.contact2Phone  = '';
        //ka.converted  = 0;
        //ka.creditRating  = 0;
        //ka.creditThresh  = 0;
        //ka.credStatus  = 0;
        ka.currencyCode  = 'KRW';               //Required
        //ka.custAddress1  = '';
        //ka.custAddress2  = '';
        //ka.custAddress3  = '';
        //ka.custCity  = '';
        //ka.custCountryCode  = 2;
        //ka.custCounty  = '';
        //ka.custEmail  = '';
        //ka.custFaxno  = '';
        //ka.custFranchiseTaxCode  = 0;
        //ka.custGeocode  = '';
        //ka.customerLifetimeId  = 0;
        //ka.customerLifetimeId2  = 0;
        //ka.custPhone1  = '';
        //ka.custPhone2  = '';
        //ka.custState  = '';
        //ka.custZip  = '';
        //ka.cyclicalThreshold  = 0;
        //ka.dateActive  = Datetime.now();  //Required
        //ka.dateCreated  = Datetime.now();
        //ka.dateInactive  = null;
        //ka.dept  = '';
        //ka.disconnectReason  = 0;
        //ka.discRcvOpt  = 0;
        //ka.distrChan  = '';
        //ka.exrateClass  = 0;
        //ka.gender  = 0;
        //ka.globalContractStatus  = 0;
        //ka.hierarchyAccountExternalId  = '';
        //ka.hierarchyAccountExternalIdType  = 0;
        //ka.hierarchyId  = 0;
        //ka.inactiveDate  = null;
        //ka.insertGrpId  = 0;
        //ka.inUse  = '';
        //ka.languageCode  = 0;
        ka.mktCode  = 'Nordrhein-Westfalen (NRW)';                 //Required
        //ka.msgGrpId  = 0;
        //ka.nextBillDate = Datetime.now().addMonths(1);
        //ka.noBill  = false;
        //ka.owningCostCtr  = 0;
        //ka.parentAccountExternalId  = '';
        //ka.parentAccountExternalIdType  = 0;
        //ka.parentId  = null;
        //ka.paymentProfileId  = 0;
        //ka.planIdCredit  = 0;
        //ka.planIdDiscount  = 0;
        //ka.prevBalanceRefno  = 1;
        //ka.prevBalanceRefResets  = 0;
        //ka.prevBillDate  = Datetime.now().addMonths(-1);
        //ka.prevBillRefno  = 0;
        //ka.prevBillRefResets  = 0;
        //ka.prevCutoffDate  = Datetime.now().addMonths(-1);
        //ka.purchaseOrder  = '';
        //ka.rateClassDefault  = 0;
        //ka.rateClassSpecial  = 0;
        //ka.regulatoryId  = 0;
        //ka.remark  = '';
        //ka.revRcvCostCtr  = 0;
        //ka.salesCode  = '';
        //ka.sdAgencyId  = 'default';           //Required
        //ka.serverId  = -1;                    
        //ka.sicCode  = 0;
        //ka.ssn  = '';
        //ka.statementToEmail  = '';
        //ka.statementToFaxno  = '';
        //ka.threshold  = 0;
        //ka.threshRef  = 0;
        //ka.tieCode  = 0;
        //ka.title  = '';
        //ka.usgAmtLimit  = 0;
        //ka.usgUnitsLimit  = 0;
        //ka.vipCode  = 0;
        ka.paymentProfile = createSamplePaymentProfile();

        ka.extData = new Map<String, String>();
        ka.extData.put('14', 'some Kenan Account Company');
        ka.extData.put('1', '1');
        ka.extData.put('12', 'true');
        
        KenanServiceConnection__c setting = KenanServiceConnection__c.getInstance();
        ka.extIdList = new List<Map<String, String>>();
        Map<String, String> extMap = new Map<String, String>();
        extMap.put('value', AccountId);
        extMap.put('type', setting.Default_Account_External_IdType__c);

        ka.extIdList.add(extMap);
        return ka;
    }

    public static KenanAccount createSampleUpdateKenanAccount(){
        KenanAccount ka = new KenanAccount();
        Account act = [Select Id from Account WHERE Name like 'Sample Account%' LIMIT 1];

        ka.salesforceOrgId = UserInfo.getOrganizationId();
        ka.salesforceObjectId = act.Id;
        ka.accountCategory = 'SME';             //Required
        //ka.accountExternalId = '';
        //ka.accountExternalIdType = 1;
        //ka.accountInternalId = 11;
        //ka.accountProcessFlag = 1;            //Required
        //ka.accountStatus = 1;
        //ka.accountStatusDt = Datetime.now();
        //ka.accountType = 0;
        //ka.acctSegId = 0;
        //ka.altCompanyName = '';
        //ka.altFname = '';
        //ka.altLname = '';
        //ka.autoWriteoffStatus = 0;
        ka.billAddress1 = '612 Hamilton';               //Required
        //ka.billAddress2 = '';
        //ka.billAddress3 = '';
        ka.billCity = 'Mertztown';                  //Required
        ka.billCompany = 'Trifecta ' + String.valueOf(Datetime.now());              //Required
        ka.billCountryCode = 840;
        //ka.billCounty = '';
        //ka.billDispMeth = 0;
        //ka.billFmtOpt = 1;
        ka.billFname = 'Jack';
        ka.billFranchiseTaxCode = 1;
        //ka.billGeocode = '';
        //ka.billHoldCode = 0;
        ka.billLname = 'Hobert';                    //Required
        //ka.billMinit = '';
        //ka.billNameGeneration = '';
        //ka.billNamePre = '';
        //ka.billPeriod = '';
        //ka.billSequenceNum = 0;
        ka.billState = 'PA';                    //Required
        //ka.billTitle = '';
        ka.billZip = '18101';                   //Required
        //ka.billingFrequency = 1;
        //ka.chargeThreshold = 900;
        //ka.chgDate = Datetime.now();
        //ka.chgWho = '';
        //ka.childCount = 0;
        //ka.codeword  = '';
        //ka.collectionHistory  = '';
        //ka.collectionIndicator  = 0;
        //ka.collectionStatus  = 0;
        //ka.contact1Name  = '';
        //ka.contact1Phone  = '';
        //ka.contact2Name  = '';
        //ka.contact2Phone  = '';
        //ka.converted  = 0;
        //ka.creditRating  = 0;
        //ka.creditThresh  = 0;
        //ka.credStatus  = 0;
        //ka.custAddress1  = '';
        //ka.custAddress2  = '';
        //ka.custAddress3  = '';
        //ka.custCity  = '';
        //ka.custCountryCode  = 2;
        //ka.custCounty  = '';
        //ka.custEmail  = '';
        //ka.custFaxno  = '';
        //ka.custFranchiseTaxCode  = 0;
        //ka.custGeocode  = '';
        //ka.customerLifetimeId  = 0;
        //ka.customerLifetimeId2  = 0;
        //ka.custPhone1  = '';
        //ka.custPhone2  = '';
        //ka.custState  = '';
        //ka.custZip  = '';
        //ka.cyclicalThreshold  = 0;
        //ka.dateActive  = Datetime.now();  //Required
        //ka.dateInactive  = null;
        //ka.dept  = '';
        //ka.disconnectReason  = 0;
        //ka.discRcvOpt  = 0;
        //ka.distrChan  = '';
        //ka.exrateClass  = 0;
        //ka.gender  = 0;
        //ka.globalContractStatus  = 0;
        //ka.hierarchyAccountExternalId  = '';
        //ka.hierarchyAccountExternalIdType  = 0;
        //ka.hierarchyId  = 0;
        //ka.insertGrpId  = 0;
        //ka.inUse  = '';
        //ka.languageCode  = 0;
        ka.mktCode  = 'Nordrhein-Westfalen (NRW)';                 //Required
        //ka.msgGrpId  = 0;
        //ka.nextBillDate = Datetime.now().addMonths(1);
        //ka.noBill  = false;
        //ka.owningCostCtr  = 0;
        //ka.parentAccountExternalId  = '';
        //ka.parentAccountExternalIdType  = 0;
        //ka.parentId  = null;
        //ka.paymentProfileId  = 0;
        //ka.planIdCredit  = 0;
        //ka.planIdDiscount  = 0;
        //ka.prevBalanceRefno  = 1;
        //ka.prevBalanceRefResets  = 0;
        //ka.prevBillDate  = Datetime.now().addMonths(-1);
        //ka.prevBillRefno  = 0;
        //ka.prevBillRefResets  = 0;
        //ka.prevCutoffDate  = Datetime.now().addMonths(-1);
        //ka.purchaseOrder  = '';
        //ka.rateClassDefault  = 0;
        //ka.rateClassSpecial  = 0;
        //ka.regulatoryId  = 0;
        //ka.remark  = '';
        //ka.revRcvCostCtr  = 0;
        //ka.salesCode  = '';
        //ka.sdAgencyId  = 'default';           //Required
        //ka.serverId  = -1;                    //Required
        //ka.sicCode  = 0;
        //ka.ssn  = '';
        //ka.statementToEmail  = '';
        //ka.statementToFaxno  = '';
        //ka.threshold  = 0;
        //ka.threshRef  = 0;
        //ka.tieCode  = 0;
        //ka.title  = '';
        //ka.usgAmtLimit  = 0;
        //ka.usgUnitsLimit  = 0;
        //ka.vipCode  = 0;

        //ka.extData = new Map<Integer, String>();
        //ka.extData.put(1, 'value');

        KenanServiceConnection__c setting = KenanServiceConnection__c.getInstance();
        ka.extIdList = new List<Map<String, String>>();
        Map<String, String> extMap = new Map<String, String>();
        extMap.put('value', act.Id);
        extMap.put('type', setting.Default_Account_External_IdType__c);

        ka.extIdList.add(extMap);
        return ka;
    }

    public static KenanAccount createSampleCeaseKenanAccount(){
        KenanAccount ka = new KenanAccount();
        Account act = [Select Id from Account WHERE Name like 'Sample Account%' LIMIT 1];
        system.debug('Account.Id:' + act.Id);
        ka.salesforceOrgId = UserInfo.getOrganizationId();
        ka.salesforceObjectId = act.Id;
        ka.dateInactive = Date.today().addDays(21);
        KenanServiceConnection__c setting = KenanServiceConnection__c.getInstance();
        ka.extIdList = new List<Map<String, String>>();
        Map<String, String> extMap = new Map<String, String>();
        extMap.put('value', act.Id);
        extMap.put('type', setting.Default_Account_External_IdType__c);

        ka.extIdList.add(extMap);
        return ka;
    }

    public static KenanPaymentProfile createSamplePaymentProfile(){
        KenanPaymentProfile pro = new KenanPaymentProfile();
        pro.payMethod = '1';
        return pro;
    }

    @Future(callout=true)
    public static void createAccount(String accountId){
        KenanConnectorService service = new KenanConnectorService();
        KenanAccount kaccount = createSampleInsertKenanAccount(accountId);
        KenanAccount actBack = service.accountCreate(kaccount);
        System.debug('actBack:' + actBack);
    }

    @Future(callout=true)
    public static void createHierarchy(Set<String> accountIds){
        KenanConnectorService service = new KenanConnectorService();
        List<KenanAccount> accounts = new List<KenanAccount>();
        Id prevAccountId;
        for(String accountId : accountIds){
            KenanAccount kaccount = createSampleInsertKenanAccount(accountId);
            if(prevAccountId != null){
                kaccount.parentAccountExternalId = prevAccountId;
                kaccount.parentAccountExternalIdType = 2;
            }
            accounts.add(kaccount);
            prevAccountId = accountId;
        }
        
        service.accountHierarchyCreate(accounts);
    }


    public static KenanService createSampleInsertKenanService(Id accountId) {
        KenanService service = new KenanService();

        Datetime today = Datetime.now();

        service.sfdcAccountId = String.valueOf(accountId);
        service.activeDt = today;
        service.address1 = '123 Test St.';
        service.address2 = '';
        service.address3 = '';
        service.address4 = '';
        service.addressLocation = 1;
        service.addressTypeId = 'Not Free-form';
        service.bendAddressId = 0;
        service.brevRcvCostCtr = 0;
        service.bserviceCompany = 'Test Company Name';
        service.bserviceFname = 'Test First Name';
        service.bserviceFranchiseTaxCode = 0;
        service.bserviceGeocode = '';
        service.bserviceLname = 'Test Last Name';
        service.bserviceMinit = '';
        service.bservicePhone = '555-1212';
        service.bservicePhone2 = '';
        service.changeDt = today.addDays(90);
        service.changeWho = '';
        service.chgDt = null;
        service.chgWho = '';
        service.city = '';
        service.codeword = '';
        service.converted = 0;
        service.countryCode = null;
        service.county = '';
        service.createDt = today;
        service.currencyCode = 'KRW';
        service.displayAddressId = 0;
        service.displayCiemViewId = 0;
        service.displayExternalIdType = 0;
        service.eligKey1 = 0;
        service.eligKey2 = 0;
        service.eligKey3 = 0;
        service.emfConfigId = 0;
        service.exrateClass = 0;
        service.extendedPostalCode = '55555-555';
        service.externalAddressId = '0';
        service.franchiseTaxCode = 0;
        service.fxGeocode = '';
        service.houseNumber = '';
        service.houseNumberSuffix = '';
        service.intendedViewEffectiveDt = null;
        service.isActive = true;
        service.isPrepaid = true;
        service.ixcProviderId = 0;
        service.keyLineCode = '';
        service.lecProviderId = 0;
        service.nearestCrossstreet = '';
        service.noBill = false;
        service.nonpubNonlist = null;
        service.optionalEndorsementLine = '';
        service.parentAccountInternalId = null;
        service.picDateActive = null;
        service.popUnits = 0;
        service.postalCode = '55555';
        service.postfixDirectional = '';
        service.postnetAddressBlockBarcode = '';
        service.postnetBarcode = '';
        service.prefixDirectional = '';
        service.prevViewId = 0;
        service.privacyLevel = null;
        service.rateClass = 1;
        service.restrictedPic = 0;
        service.revRcvCostCtr = 0;
        service.salesChannelId = null;
        service.serviceActiveDt = today;
        service.serviceCompany = 'Test Service Company';
        service.serviceFname = 'Test Service First Name';
        service.serviceFranchiseTaxCode = 0;
        service.serviceGeocode = '';
        service.serviceInactiveDt = null;
        service.serviceInternalId = 1;
        service.serviceInternalIdResets = 0;
        service.serviceLname = 'Test Service Last Name';
        service.serviceMinit = '';
        service.serviceNameGeneration = '';
        service.serviceNamePre = '';
        service.servicePhone = '555-1212';
        service.servicePhone2 = null;
        service.simSerialNumber = null;
        service.state = 'TX';
        service.statusId = 0;
        service.statusReasonId = 0;
        service.streetName = '123 Main St.';
        service.streetSuffix = '';
        service.switchId = '';
        service.timezone = null;
        service.unitNo = '';
        service.unitType = '';
        service.viewCreatedDt = null;
        service.viewEffectiveDt = null;
        service.viewId = 0;
        service.viewStatus = 0;
        service.vertexGeocode = '';

        service.serviceItems.add(createSampleKenanServiceItem('1', 1));

        return service;
    }

    public static KenanService createSampleCeaseKenanService(Id accountId) {
        KenanService service = createSampleInsertKenanService(accountId);

        service.disconnectReason = 'Customer request';
        service.disconnectDate = Date.today();

        return service;
    }

    public static KenanServiceItem createSampleKenanServiceItem(String serviceExternalId, Integer serviceExternalIdType) {
        KenanServiceItem ksi = new KenanServiceItem();

        Datetime today = Datetime.now();

        ksi.serviceExternalId = serviceExternalId;
        ksi.serviceExternalIdType = serviceExternalIdType;
        ksi.activeDate = today;
        ksi.annotation = 'Test Annotation';
        ksi.annotation2 = 'Test Annotation 2';
        ksi.currencyCode = 'KRW';
        ksi.inactiveDate = today.addDays(180);
        ksi.instanceId = '0001';
        ksi.itemId = 1;
        ksi.itemType = 1;
        ksi.rate = 1.0;
        ksi.salesforceId = '1';

        return ksi;
    }

    public static KenanServiceExternalId createSampleKenanServiceExternalId(String serviceExternalId, String externalId) {
        KenanServiceExternalId ksei = new KenanServiceExternalId();
        KenanServiceConnection__c setting = KenanServiceConnection__c.getInstance();
        Datetime today = Datetime.now();
        ksei.salesforceObjectId = serviceExternalId;
        ksei.activeDate = today.date();
        ksei.serviceExternalId = externalId;
        ksei.serviceExternalIdType = Integer.valueOf(setting.Default_Account_External_IdType__c);
        KenanConnectorService connector = new KenanConnectorService();
        KenanServiceExternalId returnItem = connector.serviceIdCreate(ksei);

        return returnItem;
    }

    public static KenanServiceExternalId swapSampleKenanServiceExternalId(String serviceExternalId, String newExternalId, String oldExternalId) {
        KenanServiceExternalId ksei = new KenanServiceExternalId();
        KenanServiceConnection__c setting = KenanServiceConnection__c.getInstance();
        Datetime today = Datetime.now();
        ksei.salesforceObjectId = serviceExternalId;
        ksei.activeDate = today.date();
        ksei.serviceExternalId = newExternalId; // new External Id
        ksei.serviceExternalIdType = Integer.valueOf(setting.Default_Service_External_IdType__c);       // new External Id Type
        ksei.oldServiceExternalId = oldExternalId; // old External Id
        ksei.oldServiceExternalIdType = Integer.valueOf(setting.Default_Service_External_IdType__c);    // old External Id Type
        KenanConnectorService connector = new KenanConnectorService();
        KenanServiceExternalId returnItem = connector.serviceIdSwap(ksei);

        return returnItem;
    }

    public static Boolean ceaseSampleKenanServiceExternalId(String serviceExternalId, String externalId) {
        KenanServiceExternalId ksei = new KenanServiceExternalId();
        KenanServiceConnection__c setting = KenanServiceConnection__c.getInstance();
        Datetime today = Datetime.now();
        ksei.salesforceObjectId = serviceExternalId;
        ksei.inactiveDate = today.addDays(1);
        ksei.serviceExternalId = externalId;    // External Id to cease
        ksei.serviceExternalIdType = Integer.valueOf(setting.Default_Service_External_IdType__c);       // External Id Type to cease
        KenanConnectorService connector = new KenanConnectorService();
        Boolean returnItem = connector.serviceIdCease(ksei);

        return returnItem;
    }

    public static List<sObject> createSampleInvoiceItems() {
        List<sObject> invoiceItems = new List<sObject>();

        /* Create sample account level invoice item */
        InvoiceItem__x accountLevelItem = new InvoiceItem__x(
            serviceExternalId__c = 'Service 1',
            serviceInternalId__c = 0,
            subtypeCode__c = '-1',
            typeCode__c = '5',
            descriptionText__c = 'Account level invoice item',
            amount__c = 100.00
        );

        invoiceItems.add(accountLevelItem);

        /* Create sample payment invoice item */
        InvoiceItem__x paymentItem = new InvoiceItem__x(
            serviceExternalId__c = 'Service 1',
            serviceInternalId__c = 910,
            subtypeCode__c = '2054',
            typeCode__c = '1',
            descriptionText__c = 'Payment invoice item',
            amount__c = 100.00
        );

        invoiceItems.add(paymentItem);

        /* Create sample service level invoice item */
        InvoiceItem__x serviceItem1 = new InvoiceItem__x(
            serviceExternalId__c = 'Service 1',
            serviceInternalId__c = 910,
            subtypeCode__c = '1040',
            typeCode__c = '2',
            descriptionText__c = 'Service invoice item 1',
            amount__c = 50.00
        );

        invoiceItems.add(serviceItem1);

        InvoiceItem__x serviceItem2 = new InvoiceItem__x(
            serviceExternalId__c = 'Service 1',
            serviceInternalId__c = 910,
            subtypeCode__c = '1060',
            typeCode__c = '3',
            descriptionText__c = 'Service invoice item 2',
            amount__c = 50.00
        );

        invoiceItems.add(serviceItem2);

        /* Create sample summary item for service 1 */
        InvoiceItem__x serviceItem1Summary = new InvoiceItem__x(
            serviceExternalId__c = 'Service 1',
            serviceInternalId__c = 910,
            subtypeCode__c = '-1',
            typeCode__c = '5',
            descriptionText__c = 'Service invoice item 1 Summary',
            amount__c = 100.00
        );

        invoiceItems.add(serviceItem1Summary);

        InvoiceItem__x serviceItem3 = new InvoiceItem__x(
            serviceExternalId__c = 'Service 2',
            serviceInternalId__c = 907,
            subtypeCode__c = '2040',
            typeCode__c = '2',
            descriptionText__c = 'Service invoice item 1',
            amount__c = 150.00
        );

        invoiceItems.add(serviceItem3);

        InvoiceItem__x serviceItem4 = new InvoiceItem__x(
            serviceExternalId__c = 'Service 2',
            serviceInternalId__c = 907,
            subtypeCode__c = '2060',
            typeCode__c = '3',
            descriptionText__c = 'Service invoice item 2',
            amount__c = 50.00
        );

        invoiceItems.add(serviceItem4);

        /* Create sample summary item for service 1 */
        InvoiceItem__x serviceItem2Summary = new InvoiceItem__x(
            serviceExternalId__c = 'Service 2',
            serviceInternalId__c = 907,
            subtypeCode__c = '-1',
            typeCode__c = '5',
            descriptionText__c = 'Service invoice item 2 Summary',
            amount__c = 200.00
        );

        invoiceItems.add(serviceItem2Summary);

        return invoiceItems;
    }

    public static List<sObject> createSoqlMockedInvoices() {
        return createMockedInvoiceItems();
    }

    public static List<sObject> createMockedInvoiceItems() {
        List<sObject> invoiceItems = new List<sObject>();

        for (Integer i = 0; i < 5; i++) {
            InvoiceItem__x invoiceItem = new InvoiceItem__x();
            invoiceItem.ExternalId = 'Test ExternalId: ' + i;
            invoiceItem.Invoice__c = KenanUtils.getFakeId(UM_InvoiceHeader__c.SObjectType);
            invoiceItem.descriptionText__c = 'Test description text: ' + i;
            invoiceItem.fromDate__c = Datetime.newInstance(2016, 7, 1, 0, 0, 0);
            invoiceItem.toDate__c = Datetime.newInstance(2016, 8, 1, 0, 0, 0);
            invoiceItem.amount__c = 150 + i;
            invoiceItems.add(invoiceItem);
        }

        return invoiceItems;
    }

    public static KenanAddress createSampleKenanAddress() {
        KenanAddress address = new KenanAddress();

        address.cAddress1 = '123 Test St.';
        address.cChangeDt = Datetime.newInstance(2016, 7, 6, 0, 0, 0);
        address.cCity = 'Testville';
        address.cState = 'TX';
        address.cPostalCode = '11111';

        return address;
    }

    public static KenanAccountItem createSampleKenanAccountItemForCease(String accountExternalId, Integer accountExternalIdType, String instanceId, Integer itemType, Datetime inactiveDate){
        KenanAccountItem item = new KenanAccountItem();

        item.serviceExternalId = accountExternalId;
        item.serviceExternalIdType = accountExternalIdType;
        item.itemType = itemType;
        item.inactiveDate = inactiveDate;
        item.instanceId = instanceId;

        return item;
    }

    public static KenanAccountItem createSampleKenanAccountItemForCreate(String serviceExternalId, Integer serviceExternalIdType, Integer itemId, Integer itemType){
        KenanAccountItem item = new KenanAccountItem();

        item.serviceExternalId = serviceExternalId;
        item.serviceExternalIdType = serviceExternalIdType;
        item.itemId = itemId;
        item.itemType = itemType;
        // item.rate = 0.00;
        item.currencyCode = 'EUR';
        item.annotation = 'annotation';
        item.annotation2 = 'annotation2';
        item.activeDate = Datetime.now().addDays(-280);
        item.inactiveDate = Datetime.now().addYears(1);
        item.instanceId = null;
        item.salesforceId = null;
        // item.units = 1;

        // item.unitsType = 'Event';
        item.nrcParentRcInstanceId = null;
        // item.discountAmount = 0;
        item.discountPercent = 44; // implied decimal of 2 - even if 0 when provisioning from CC GUI
        // item.unitCreditUnitsFree = 1;
        // item.unitCreditAmountFree = 1;
        item.contractLevel = 1;

        item.extData = new Map<String, String>();
        item.extData.put('17', 'Test Contract extended data');
        return item;
    }

    public static KenanAccount createSampleKenanAccount(String accountId, List<Map<String, Integer>> accountItemsMap){
        KenanAccount ka = new KenanAccount();
        
        ka.salesforceOrgId = UserInfo.getOrganizationId();
        ka.salesforceObjectId = accountId;
        ka.accountCategory = 'SME';             
        ka.billAddress1 = '612 Hamilton';               
        ka.billCity = 'Mertztown';                  
        ka.billCompany = 'Trifecta ' + String.valueOf(Datetime.now());          
        ka.billCountryCode = 840;
        ka.billFname = 'Jack';
        ka.billFranchiseTaxCode = 1;
        ka.billLname = 'Hobert';                    
        ka.billState = 'PA';                    
        ka.billZip = '18101';                   
        ka.currencyCode  = 'EUR';               
        ka.mktCode  = 'Nordrhein-Westfalen (NRW)';                 
        ka.paymentProfile = createSamplePaymentProfile();
        ka.dateActive = Datetime.now().addMonths(-6);

        ka.extData = new Map<String, Object>();
        ka.extData.put('1', '1');
        ka.extData.put('12', 'true');
        ka.extData.put('14', 'companyName');

        List<KenanAccountItem> accountItems = new List<KenanAccountItem>();

        if (accountItemsMap != null) {
            for (Map<String, Integer> accountItem: accountItemsMap) {
                accountItems.add(createSampleKenanAccountItemForCreate(
                    null,
                    null,
                    (Integer) accountItem.get('itemId'), 
                    (Integer) accountItem.get('itemType')
                ));
            }
        }
        ka.accountItems = accountItems;

        KenanServiceConnection__c setting = KenanServiceConnection__c.getInstance();
        ka.extIdList = new List<Map<String, String>>();
        Map<String, String> extMap = new Map<String, String>();
        extMap.put('value', accountId);
        extMap.put('type', setting.Default_Account_External_IdType__c);

        ka.extIdList.add(extMap);


        return ka;
    }

    public static List<KenanAccount> createSampleAccountHierarchyCreate(Set<String> accountIds) {
        List<KenanAccount> accounts = new List<KenanAccount>();
        
        Id prevAccountId;
        
        for(String accountId :accountIds){
            KenanAccount kaccount = createSampleKenanAccount(accountId, null);
            
            if (prevAccountId != null){
                kaccount.parentAccountExternalId = prevAccountId;
                kaccount.parentAccountExternalIdType = 2;
            }

            accounts.add(kaccount);

            prevAccountId = accountId;
        }
        
        KenanConnectorService service = new KenanConnectorService();

        return service.accountHierarchyCreate(accounts);
    }

    /**
     * Create account with account items
     * Sample invocation:
     *
     *  List<Map<String, Integer>> accountItemsMap = new List<Map<String, Integer>>{
     *      new Map<String, Integer>{
     *          'itemId' => 1302,
     *          'itemType' => 1
     *      },
     *      new Map<String, Integer>{
     *          'itemId' => 1905,
     *          'itemType' => 2
     *      },
     *      new Map<String, Integer>{
     *          'itemId' => 2186,
     *          'itemType' => 0
     *      }
     *  };
     *
     *  String accountId = 'sometest-b5';
     *
     *  KenanAccount kenanAccount = KenanSampleCode.createSampleAccountCreate(accountId, accountItemsMap);
     *
     * @param accountId the account id
     * @param accountItemsMap list of account items with itemId and itemType specified
     * @return KenanAccount
     */
    public static KenanAccount createSampleAccountCreate(String accountId, List<Map<String, Integer>> accountItemsMap) {
        KenanAccount kenanAccount = createSampleKenanAccount(accountId, accountItemsMap);

        KenanConnectorService service = new KenanConnectorService();

        return service.accountCreate(kenanAccount);
    }

    /**
     * Create account hierarchy with account items
     * Sample invocation:
     *
     *  Map<String, List<Map<String, Integer>>> accountIdToaccountItemsMap = new Map<String, List<Map<String, Integer>>>{
     *      'sometest-b6' => new List<Map<String, Integer>>{
     *          new Map<String, Integer>{
     *              'itemId' => 1302,
     *              'itemType' => 1
     *          },
     *          new Map<String, Integer>{
     *              'itemId' => 1905,
     *              'itemType' => 2
     *          },
     *          new Map<String, Integer>{
     *              'itemId' => 2186,
     *              'itemType' => 0  
     *          }
     *      },
     *      'sometest-b7' => new List<Map<String, Integer>>{
     *          new Map<String, Integer>{
     *              'itemId' => 1302,
     *              'itemType' => 1
     *          },
     *          new Map<String, Integer>{
     *              'itemId' => 1905,
     *              'itemType' => 2
     *          },
     *          new Map<String, Integer>{
     *              'itemId' => 2186,
     *              'itemType' => 0  
     *          }
     *      }
     *  };
     *
     *  List<KenanAccount> kenanAccounts = KenanSampleCode.createSampleAccountHierarchyCreate(accountIdToaccountItemsMap);
     *
     * @param accountIdToaccountItemsMap the map of account id to list of account items with item id and item type specified
     * @return List<KenanAccount>
     */
    public static List<KenanAccount> createSampleAccountHierarchyCreate(Map<String, List<Map<String, Integer>>> accountIdToaccountItemsMap) {
        List<KenanAccount> accounts = new List<KenanAccount>();

        String prevAccountId;
            
        for (String accountId: accountIdToaccountItemsMap.keySet()) {
            List<Map<String, Integer>> accountItemsMap = accountIdToaccountItemsMap.get(accountId);

            KenanAccount kaccount = createSampleKenanAccount(accountId, accountItemsMap);

            if (prevAccountId != null){
                kaccount.parentAccountExternalId = prevAccountId;
                kaccount.parentAccountExternalIdType = 2;
            }

            accounts.add(kaccount);

            prevAccountId = accountId;
        }

        KenanConnectorService service = new KenanConnectorService();

        return service.accountHierarchyCreate(accounts);
    }

    /**
     * Create account item
     * Sample invocation:
     *  
     *  String serviceExternalId = 'sometest-b5';
     *  Integer serviceExternalIdType = 2;
     *  Integer itemId = 1302;
     *  Integer itemType = 1;
     *
     *  KenanAccountItem kenanAccountItem = KenanSampleCode.createSampleAccountItemCreate(
     *      serviceExternalId, 
     *      serviceExternalIdType, 
     *      itemId, 
     *      itemType
     *  );
     *
     * @param serviceExternalId the external id
     * @param serviceExternalIdType the external id type
     * @param itemId the item id
     * @param itemType the item type
     * @return KenanAccountItem
     */
     
    public static KenanAccountItem createSampleAccountItemCreate(String serviceExternalId, Integer serviceExternalIdType, Integer itemId, Integer itemType) {
        KenanAccountItem kenanAccountItem = createSampleKenanAccountItemForCreate(serviceExternalId, serviceExternalIdType, itemId, itemType);

        KenanConnectorService service = new KenanConnectorService();

        return service.accountItemCreate(kenanAccountItem).get(0);
    }

    /**
     * Cease account item
     * Sample invocation:
     *
     *  String instanceId = '8472:3';
     *  Integer itemType = 1;
     *  Datetime inactiveDate = Datetime.now();
     *
     *  Boolean ceaseSuccess = KenanSampleCode.createSampleAccountItemCease(instanceId, itemType, inactiveDate);
     *
     * @param instanceId the instance id
     * @param itemType the item type
     * @param inactiveDate the date the account item becomes inactive
     * @return Boolean
     */
    public static Boolean createSampleAccountItemCease(String accountExternalId, Integer accountExternalIdType, String instanceId, Integer itemType, Datetime inactiveDate) {

    system.debug('Ceasing with inactiveDate=' + inactiveDate);
    KenanAccountItem kenanAccountItem = createSampleKenanAccountItemForCease(accountExternalId, accountExternalIdType, instanceId, itemType, inactiveDate);

        KenanConnectorService service = new KenanConnectorService();

        return service.accountItemCease(kenanAccountItem);
    }
    
    public static void JD_sendAccountCreate(){
        KenanConnectorService service = new KenanConnectorService();
        Account a = new Account();
        a.Name = 'Sample Account ' + String.valueOf(Datetime.now());
        insert a;
        // createAccount(a.Id);
        System.debug('JD a.Id == ' + a.Id);
        JD_createSampleAccountCreate_Caller(a.Id);

    }
    
     /*  KenanAccount kenanAccount = KenanSampleCode.JD_createSampleAccountCreate_Caller(accountId);
     *
     * @param accountId the account id
     * @return KenanAccount
     */
    @Future(callout=true)
    public static void JD_createSampleAccountCreate_Caller(String accountId) {
        KenanAccount kenanAccount = JD_createSampleKenanAccountwAccountItems(accountId, null, 1);

        KenanConnectorService service = new KenanConnectorService();

        KenanAccount actBack = service.accountCreate(kenanAccount);
        System.debug('JD_createSampleAccountCreate_Caller actBack:' + actBack);

    }

    public static KenanAccount JD_createSampleKenanAccountwAccountItems(String accountId, Id prevAccountId, Integer isCreateBillableOnlyWithNoParent){
        KenanAccount ka = new KenanAccount();
        
        ka.salesforceOrgId = UserInfo.getOrganizationId();
        ka.salesforceObjectId = accountId;
        ka.accountCategory = 'SME';             
        ka.billAddress1 = '612 Hamilton';               
        ka.billCity = 'Mertztown';                  
        ka.billCompany = 'Trifecta ' + String.valueOf(Datetime.now());          
        ka.billCountryCode = 840;
        ka.billFname = 'Jack';
        ka.billFranchiseTaxCode = 1;
        ka.billLname = 'Hobert';                    
        ka.billState = 'PA';                    
        ka.billZip = '18101';                   
        ka.currencyCode  = 'EUR';               
        ka.mktCode  = 'Nordrhein-Westfalen (NRW)';                 
        ka.paymentProfile = createSamplePaymentProfile();
        ka.dateActive = Datetime.now().addMonths(-6);

        ka.extData = new Map<String, Object>();
        ka.extData.put('1', '1');
        ka.extData.put('12', 'true');
        ka.extData.put('14', 'companyName');

        List<KenanAccountItem> accountItems = new List<KenanAccountItem>();

        // if (accountItemsMap != null) {
        //    for (Map<String, Integer> accountItem: accountItemsMap) {
        //        accountItems.add(createSampleKenanAccountItemForCreate(
        //            null,
        //            null,
        //            (Integer) accountItem.get('itemId'), 
        //            (Integer) accountItem.get('itemType')
        //        ));
        //    }
        // }
        
        if (isCreateBillableOnlyWithNoParent == 2) {
        
                // create as billable w/ acc lvl items AND set parent account
                ka.parentAccountExternalId = prevAccountId;
                ka.parentAccountExternalIdType = 2;
                ka.mktCode  = 'Nordrhein-Westfalen (NRW)';                 
                ka.accountType = 'billable';

                // **** add account level NRC, RC and discount % contract ********************
                accountItems.add(JD_createSampleKenanAccountItemForCreate_NRC(null, null, 1302, 1 ));
                accountItems.add(JD_createSampleKenanAccountItemForCreate_RC(null, null, 2186, 0 ));
                accountItems.add(JD_createSampleKenanAccountItemForCreate_Contract(null, null, 1905, 2 ));
        
                ka.accountItems = accountItems;

        }
        else if (isCreateBillableOnlyWithNoParent == 1) 
        {
                // create as billable w/ acc lvl items BUT DO NOT set parent account
                ka.parentAccountExternalId = null;
                ka.parentAccountExternalIdType = null;
                ka.mktCode  = 'Nordrhein-Westfalen (NRW)';                 
                ka.accountType = 'billable';

                // **** add account level NRC, RC and discount % contract ********************
                accountItems.add(JD_createSampleKenanAccountItemForCreate_NRC(null, null, 1302, 1 ));
                accountItems.add(JD_createSampleKenanAccountItemForCreate_RC(null, null, 2186, 0 ));
                accountItems.add(JD_createSampleKenanAccountItemForCreate_Contract(null, null, 1905, 2 ));
        
                ka.accountItems = accountItems;

        }
        else
        {       
                // create as master unbillable w/o acc lvl items or parent acc
                ka.parentAccountExternalId = null;
                ka.parentAccountExternalIdType = null;
                ka.mktCode  = 'MASTER ACCOUNT';
                ka.accountType = 'unbillable';
        }

        KenanServiceConnection__c setting = KenanServiceConnection__c.getInstance();

        ka.extIdList = new List<Map<String, String>>();
        Map<String, String> extMap = new Map<String, String>();
        extMap.put('value', accountId);
        extMap.put('type', setting.Default_Account_External_IdType__c);

        ka.extIdList.add(extMap);


        return ka;
    }
    
    // ************** Acc level Contract - James D
    public static KenanAccountItem JD_createSampleKenanAccountItemForCreate_Contract(String serviceExternalId, Integer serviceExternalIdType, Integer itemId, Integer itemType){
        KenanAccountItem item = new KenanAccountItem();

        item.serviceExternalId = serviceExternalId;
        item.serviceExternalIdType = serviceExternalIdType;
        item.itemId = itemId;
        item.itemType = itemType;
        // item.rate = 0.00;
        item.currencyCode = 'EUR';
        item.annotation = 'annotation';
        item.annotation2 = 'annotation2';
        // item.activeDate = Datetime.now().addDays(-280);
        item.activeDate = Datetime.now().addDays(-10);
        item.inactiveDate = Datetime.now().addYears(1);
        item.instanceId = null;
        item.salesforceId = null;
        // item.units = 1;

        // item.unitsType = 'Event';
        item.nrcParentRcInstanceId = null;
        // item.discountAmount = 0;
        item.discountPercent = 89; // implied decimal of 2 - even if 0 when provisioning from CC GUI
        // item.unitCreditUnitsFree = 1;
        // item.unitCreditAmountFree = 1;
        item.contractLevel = 1;

        item.extData = new Map<String, String>();
        item.extData.put('17', 'Test Contract extended data');
        return item;
    }
    
    // ************** Acc level RC - James D

        public static KenanAccountItem JD_createSampleKenanAccountItemForCreate_RC(String serviceExternalId, Integer serviceExternalIdType, Integer itemId, Integer itemType){
        KenanAccountItem item = new KenanAccountItem();

        item.serviceExternalId = serviceExternalId;
        item.serviceExternalIdType = serviceExternalIdType;
        item.itemId = itemId; // ----> 2186 acc lvl RC
        item.itemType = itemType; // ----> 0 for RC
        item.rate = 6789;
        item.currencyCode = 'EUR';
        item.annotation = 'annotation';
        item.annotation2 = 'annotation2';
        // item.activeDate = Datetime.now().addDays(-280);
        item.activeDate = Datetime.now().addDays(-10);
        item.inactiveDate = Datetime.now().addYears(1);
        item.instanceId = null;
        item.salesforceId = null;
        // item.units = 1;

        // item.unitsType = 'Event';
     
        item.extData = new Map<String, String>();
        item.extData.put('16', 'james test ACC level RC ext data 16 desc');
        return item;
    }
    
    // ************** Acc level NRC - James D
            public static KenanAccountItem JD_createSampleKenanAccountItemForCreate_NRC(String serviceExternalId, Integer serviceExternalIdType, Integer itemId, Integer itemType){
        KenanAccountItem item = new KenanAccountItem();

        item.serviceExternalId = serviceExternalId;
        item.serviceExternalIdType = serviceExternalIdType;
        item.itemId = itemId; // ----> 1302 acc lvl NRC
        item.itemType = itemType; // ----> 1 for NRC
        item.rate = 1111;
        item.currencyCode = 'EUR';
        item.annotation = 'annotation';
        item.annotation2 = 'annotation2';
        // item.activeDate = Datetime.now().addDays(-280);
        item.activeDate = Datetime.now().addDays(-30);
        item.inactiveDate = Datetime.now().addYears(1);
        item.instanceId = null;
        item.salesforceId = null;
        // item.units = 1;

        // item.unitsType = 'Event';
     
        item.extData = new Map<String, String>();
        item.extData.put('15', 'james test ACC level NRC ext data 15 desc');
        
        return item;
    }
    
    public static void JD_sendHeirarchyCreate(){
        List<Account> accounts = new List<Account>();
        Set<String> accountIds = new Set<String>();
        for (Integer i = 0; i < 3; i++) {
            Account a = new Account();
            a.Name = 'Sample Account num' + i + ' = ' + String.valueOf(Datetime.now().addDays(i));
            accounts.add(a);
        }
        insert accounts;
        for(Account a : accounts){
            accountIds.add(a.Id);
        }
        JD_createHierarchy(accountIds);
    }
    
    @Future(callout=true)
    public static void JD_createHierarchy(Set<String> accountIds){
        KenanConnectorService service = new KenanConnectorService();
        List<KenanAccount> accounts = new List<KenanAccount>();
        Id prevAccountId = null;
        for(String accountId : accountIds){
            KenanAccount kaccount = JD_createSampleKenanAccountwAccountItems(accountId, prevAccountId, 2);
                
            accounts.add(kaccount);
            prevAccountId = accountId;
        }
        
        List<KenanAccount> accountsBack = service.accountHierarchyCreate(accounts);
        
        for(KenanAccount accountOneBack : accountsBack){
            System.debug('accountOneBack' + accountOneBack);
        }
    }
    
    public static void JD_createMulitleSampleAccountItem(String accExternalId, Integer accExternalIdType) {

        KenanConnectorService service = new KenanConnectorService();
        
        KenanAccountItem accItemBack;
                
        KenanAccountItem kenanAccountItem = JD_createSampleKenanAccountItemForCreate_RC(accExternalId, accExternalIdType, 2186, 0);
        accItemBack = service.accountItemCreate(kenanAccountItem).get(0);
        System.debug('RC :: accItemBack=' + accItemBack);
        
        kenanAccountItem = JD_createSampleKenanAccountItemForCreate_NRC(accExternalId, accExternalIdType, 1302, 1);
        accItemBack = service.accountItemCreate(kenanAccountItem).get(0);
        System.debug('NRC :: accItemBack=' + accItemBack);

        kenanAccountItem = JD_createSampleKenanAccountItemForCreate_Contract(accExternalId, accExternalIdType, 1905, 2);
        accItemBack = service.accountItemCreate(kenanAccountItem).get(0);
        System.debug('Contract :: accItemBack=' + accItemBack);

    }

}