/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Sample Code
* version 1.2
*/

//@isTest
public class KenanSampleCodeAmdocsProjectTeamTest {


    public static Boolean sendAccountCease(String objectId, Datetime inactiveDate) {
        KenanAccount kenanAccount = createSampleKenanAccountForCease(objectId, inactiveDate);

        KenanConnectorService service = new KenanConnectorService();

        return service.accountCease(kenanAccount);
    }
    
    public static KenanAccount createSampleKenanAccountForCease(String objectId, Datetime inactiveDate){
        KenanAccount kenanAccount = new KenanAccount();

        kenanAccount.salesforceObjectId = objectId;
        kenanAccount.dateInactive = inactiveDate;

        return kenanAccount;
    }
    
    

    // **************************************************************************
    // *** Create 3 x account items ENRTY POINT
    // **************************************************************************
    public static void JD_sendMultipleAccountItemCreate(String accExternalId, Integer accExternalIdType) {

        KenanConnectorService service = new KenanConnectorService();
        
        KenanAccountItem accItemBack;
                
        // KenanAccountItem kenanAccountItem = JD_createSampleKenanAccountItemForCreate_RC(accExternalId, accExternalIdType, 2186, 0);
        // accItemBack = service.accountItemCreate(kenanAccountItem).get(0);
        // System.debug('RC :: accItemBack=' + accItemBack);
        
        KenanAccountItem  kenanAccountItem = JD_createSampleKenanAccountItemForCreate_NRC(accExternalId, accExternalIdType, 1302, 1);
        accItemBack = service.accountItemCreate(kenanAccountItem).get(0);
        System.debug('NRC :: accItemBack=' + accItemBack);

        kenanAccountItem = JD_createSampleKenanAccountItemForCreate_Contract(accExternalId, accExternalIdType, 1905, 2);
        accItemBack = service.accountItemCreate(kenanAccountItem).get(0);
        System.debug('Contract :: accItemBack=' + accItemBack);

       
    }

    // **************************************************************************
    // *** Cease single account item ENRTY POINT    
    // **************************************************************************
    public static Boolean JD_SendAccountItemCease(String accountExternalId, Integer accountExternalIdType, String instanceId, Integer itemType, Datetime inactiveDate) {

    system.debug('Ceasing with inactiveDate=' + inactiveDate);
    KenanAccountItem kenanAccountItem = createSampleKenanAccountItemForCease(accountExternalId, accountExternalIdType, instanceId, itemType, inactiveDate);

        KenanConnectorService service = new KenanConnectorService();

        return service.accountItemCease(kenanAccountItem);
    }
    
    // **************************************************************************
    // *** Create single billable account in Kenan w/ account-level NRC + RC + contract (+ account placeholder in SF) ENRTY POINT   
    // **************************************************************************

    public static void JD_sendAccountCreate(){
        KenanConnectorService service = new KenanConnectorService();
        Account a = new Account();
        a.Name = 'Sample Account ' + String.valueOf(Datetime.now());
        insert a;
        // createAccount(a.Id);
        System.debug('JD a.Id == ' + a.Id);
        JD_createSampleAccountCreate_Caller(a.Id);

    }

    // **************************************************************************
    // *** Create depth 2 hierarchy in Kenan. Top level master wiht billable child and grand chile.
    // *** Both billable accounts are created with acc level NRC + RC + contract 
    // *** (+ account placeholder in SF for each account) ENRTY POINT   
    // **************************************************************************
    public static void JD_sendHeirarchyCreate(){
        List<Account> accounts = new List<Account>();
        Set<String> accountIds = new Set<String>();
        for (Integer i = 0; i < 2; i++) {
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
    
    
    // *************************************************************
    // *************************************************************
    // *************************************************************

    public static KenanAccountItem createSampleKenanAccountItemForCease(String accountExternalId, Integer accountExternalIdType, String instanceId, Integer itemType, Datetime inactiveDate){
        KenanAccountItem item = new KenanAccountItem();

        item.serviceExternalId= accountExternalId;
        item.serviceExternalIdType= accountExternalIdType;
        item.itemType = itemType;
        item.inactiveDate = inactiveDate;
        item.instanceId = instanceId;

        return item;
    }
    
     /*  KenanAccount kenanAccount = KenanSampleCodeAmdocsProjectTeamTest.JD_createSampleAccountCreate_Caller(accountId);
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
        ka.billCountryCode = 276;
        ka.billFranchiseTaxCode = 1;
        // ka.custGeocode = '276001000000000';
        // ka.billGeoCode = '276001000000000';
        ka.exrateClass = 1;
        ka.rateClassSpecial = 1;
        ka.billFname = 'James';
        ka.billFranchiseTaxCode = 1;
        ka.billLname = 'Jones';                    
        ka.billState = 'PA';                    
        ka.billZip = '18101';                   
        ka.currencyCode  = 'EUR';               
        ka.mktCode  = 'Nordrhein-Westfalen (NRW)';                 
        ka.paymentProfile = createSamplePaymentProfile();
        ka.dateActive = Datetime.now().addMonths(-6);

        ka.billDispMeth = 'Paper';
        ka.billFmtOpt = 'Summary';
        
        ka.extData = new Map<String, Object>();
        ka.extData.put('1', '1');
        ka.extData.put('12', 'true');
        ka.extData.put('14', 'test company Name');
        ka.extData.put('18', 'test company Legal Name');
        ka.extData.put('22', 'true');

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
        
        if (isCreateBillableOnlyWithNoParent == 2 && prevAccountId != null) {
        
                // create as billable w/ acc lvl items AND set parent account
                ka.parentAccountExternalId = prevAccountId;
                ka.parentAccountExternalIdType = 2;
                ka.mktCode  = 'Nordrhein-Westfalen (NRW)';                 
                ka.accountType = 'billable';

                // **** add account level NRC, RC and discount % contract ********************
                // accountItems.add(JD_createSampleKenanAccountItemForCreate_NRC(null, null, 1302, 1 ));
                // accountItems.add(JD_createSampleKenanAccountItemForCreate_RC(null, null, 2186, 0 ));
                // accountItems.add(JD_createSampleKenanAccountItemForCreate_Contract(null, null, 1905, 2 ));
        
                // ka.accountItems = accountItems;

        }
        else if (isCreateBillableOnlyWithNoParent == 1) 
        {
                // create as billable w/ acc lvl items BUT DO NOT set parent account
                ka.parentAccountExternalId = null;
                ka.parentAccountExternalIdType = null;
                ka.mktCode  = 'Nordrhein-Westfalen (NRW)';                 
                ka.accountType = 'billable';

                // **** add account level NRC, RC and discount % contract ********************
                // accountItems.add(JD_createSampleKenanAccountItemForCreate_NRC(null, null, 1302, 1 ));
                // accountItems.add(JD_createSampleKenanAccountItemForCreate_RC(null, null, 2186, 0 ));
                // accountItems.add(JD_createSampleKenanAccountItemForCreate_Contract(null, null, 1905, 2 ));
        
                // ka.accountItems = accountItems;

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
        item.serviceExternalIdType= serviceExternalIdType;
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

        item.serviceExternalId= serviceExternalId;
        item.serviceExternalIdType= serviceExternalIdType;
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


    
    public static KenanPaymentProfile createSamplePaymentProfile(){
        KenanPaymentProfile pro = new KenanPaymentProfile();
        pro.payMethod = '1';
        return pro;
    }

    @Future(callout=true)
    public static void createSampleOrder(Id accountId, Integer numberOfServices,  Boolean includeRC, Boolean includeNRC, Boolean includeContract, Boolean includeCorridor, Date myActiveDate){
        System.debug('********************** createSampleOrder Start [' + accountId + ']');
        KenanConnectorService connector = new KenanConnectorService();
        DateTime timeStamp = myActiveDate; // DateTime.now();
        List<KenanService> services = new List<KenanService>();
        
        for (Integer i = 0; i < numberOfServices; i++) {
            KenanService service = new KenanService();
            service.sfdcAccountId = accountId;
            service.activeDt = timeStamp;
            service.serviceActiveDt = timeStamp; // this is the date that determines the actual service active date field in service view

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
            extMap.put('value', 'JJJservice_' + String.valueOf(unixDate));
            extMap.put('type', '2');
            service.extIdList.add(extMap);
            
            service.extData = new Map<String, Object>();
            service.extData.put('4', '1901');
            service.extData.put('5', DateTime.now());
            service.extData.put('7', DateTime.now());
            service.extData.put('8', DateTime.now().addYears(2));
            service.extData.put('10', '1');
            service.extData.put('23', '1');
            service.extData.put('24', DateTime.now());

            
            List<KenanServiceItem> items = new List<KenanServiceItem>();
            KenanServiceItem item = new KenanServiceItem();
            
            if (includeRC){

                item = new KenanServiceItem();
                item.itemId = 1000;
                item.itemType = 0;
                item.rate = 2222;
                item.currencyCode = 'EUR';
                items.add(item);        
            }
            
            if (includeNRC){

                item = new KenanServiceItem();
                item.itemId = 1200;
                item.itemType = 1;
                item.rate = 10777.88;
                item.currencyCode = 'EUR';
                items.add(item);
                
                item = new KenanServiceItem();
                item.itemId = 1200;
                item.itemType = 1;
                item.rate = 10888.99;
                item.currencyCode = 'EUR';
                items.add(item);
            }

            if (includeContract){
             
                // discount percent contract *******************
                KenanServiceItem item2 = new KenanServiceItem();
                item2.itemId = 12100;
                item2.itemType = 2;
                // item2.rate = 10000;
                item2.currencyCode = 'EUR';
                // item2.currencyCode = 'NONE';
                item2.discountPercent= 62;
                // item2.discountAmount = 1212.99;
                // item2.unitsType = 'Seconds';
                // item2.units = 0;
                items.add(item2);

                 
                // unit credit contract *******************
                item = new KenanServiceItem();
                item.itemId = 1950;
                item.itemType = 2;
                // item.rate = 10000;
                item.currencyCode = 'EUR';
                // item.currencyCode = 'NONE';
                item.unitCreditUnitsFree = 40000;
                // item.unitCreditAmountFree = 1234.56;
                // item.unitsType = 'Seconds';
                // item.units = 0;
                items.add(item);
             }
             
         

            service.serviceItems = items;
            services.add(service);
        }
        
        List<KenanService> newServices = connector.orderCreate(services);
        System.debug(newServices);
        System.debug('********************** createSampleOrder End');
    }
    

   


    
    // a2g5E0000000HEKQA2
  public static KenanAccount sendAccountModify(Id accountId){
        KenanConnectorService service = new KenanConnectorService();
        KenanAccount act = createSampleUpdateKenanAccount(accountId);
        KenanAccount actBack = service.accountUpdate(act);
        return actBack;
    }

      public static KenanAccount createSampleUpdateKenanAccount(Id accountId){
        KenanAccount ka = new KenanAccount();
        // Account act = [Select Id from Account WHERE Name like 'Sample Account%' LIMIT 1];

        ka.salesforceOrgId = UserInfo.getOrganizationId();
        ka.salesforceObjectId = accountId; // act.Id;
        // ka.accountCategory = 'SME';             //Required
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
        // ka.billAddress1 = '612 Hamilton';               //Required
        //ka.billAddress2 = '';
        //ka.billAddress3 = '';
        // ka.billCity = 'Mertztown';                  //Required
        // ka.billCompany = 'Trifecta ' + String.valueOf(Datetime.now());              //Required
        // ka.billCountryCode = 840;
        //ka.billCounty = '';
        //ka.billDispMeth = 0;
        //ka.billFmtOpt = 1;
        
        ka.billFname = 'FFFFFF';
        // ka.billFranchiseTaxCode = 1;
        //ka.billGeocode = '';
        //ka.billHoldCode = 0;
        
        ka.billLname = 'LLLL';                    //Required
        //ka.billMinit = '';
        //ka.billNameGeneration = '';
        //ka.billNamePre = '';
        //ka.billPeriod = '';
        //ka.billSequenceNum = 0;
        // ka.billState = 'PA';                    //Required
        //ka.billTitle = '';
        // ka.billZip = '18101';                   //Required
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
        // ka.mktCode  = 'MASTER ACCOUNT';                 //Required
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
        extMap.put('value', accountId);
        extMap.put('type', setting.Default_Account_External_IdType__c);

        ka.extIdList.add(extMap);
        return ka;
    }
    
    /**
     * Cease service 
     * Sample invocation:
     *
     *  String objectId = 'sometest-s1';
     *  Datetime inactiveDate = Datetime.now();
     *
     *  Boolean ceaseSuccess = KenanSampleCode.createSampleServiceCease(objectId, inactiveDate);
     *
     * @param objectId the instance id
     * @param inactiveDate the date the service becomes inactive
     * @return Boolean
     */
    public static Boolean createSampleServiceCease(String objectId, Datetime inactiveDate) {
        KenanService kenanService = createSampleKenanServiceForCease(objectId, inactiveDate);

        KenanConnectorService service = new KenanConnectorService();

        return service.serviceCease(kenanService);
    }
    
    public static KenanService createSampleKenanServiceForCease(String objectId, Datetime inactiveDate){
        KenanService kenanService = new KenanService();

        kenanService.salesforceObjectId = objectId;
        kenanService.disconnectDate = inactiveDate;
        kenanService.disconnectReason = 'Customer request';

        return kenanService;
    }

          /**
     * Cease service item
     * Sample invocation:
     *
     *  String instanceId = '8472:3';
     *  Integer itemType = 3;
     *  Datetime inactiveDate = Datetime.now();
     *
     *  Boolean ceaseSuccess = KenanSampleCode.createSampleServiceItemCeaseWithCorridorItem(instanceId, itemType, inactiveDate);
     *  Example
     *   createSampleServiceItemCeaseWithCorridorItem('sometest-jalfie4-service', '128:3', 3, Datetime.now());
     *
     * @param instanceId the instance id
     * @param itemType the item type
     * @param inactiveDate the date the account item becomes inactive
     * @return Boolean
     */
    public static Boolean createSampleServiceItemCease(String serviceExternalId, String instanceId, Integer itemType, Datetime inactiveDate) {
        KenanServiceItem kenanServiceItem = createSampleKenanServiceItemForCease(serviceExternalId, instanceId, itemType, inactiveDate);
        // kenanServiceItem.serviceExternalId = 'sometest-y1';
        
        KenanConnectorService service = new KenanConnectorService();

        return service.serviceItemCease(kenanServiceItem);
    }
    
    
        public static KenanServiceItem createSampleKenanServiceItemForCease(String serviceExternalId, String instanceId, Integer itemType, Datetime inactiveDate){
        KenanServiceItem item = new KenanServiceItem();

        item.serviceExternalId = serviceExternalId;
        item.serviceExternalIdType = 2;
        item.itemType = itemType;
        item.inactiveDate = inactiveDate;
        item.instanceId = instanceId;

        return item;
    }
    
}