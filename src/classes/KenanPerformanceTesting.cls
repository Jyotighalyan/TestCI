/**
* TODO: ApexDoc.
*/
public class KenanPerformanceTesting {

    public static Account createSFDCAccount(String accountName){
        Account a = new Account();
        a.Name = accountName;
        insert a;
        return a;
    }

    @Future(callout=true)
    public static void createKenanAccount(String accountId){
        System.debug('createKenanAccount Start');
        KenanConnectorService service = new KenanConnectorService();
        KenanAccount kaccount = createSampleInsertKenanAccount(accountId);
        kaccount = service.accountCreate(kaccount);
        System.debug('createKenanAccount End');
        System.debug('KenanAccount: ' + kaccount);
    }

    @Future(callout=true)
    public static void createSampleOrder(Id accountId, Integer numberOfServices, Boolean includeNRC, Boolean nrcItemsOnly){
        System.debug('createSampleOrder Start [' + accountId + ']');
        KenanConnectorService connector = new KenanConnectorService();
        DateTime timeStamp = DateTime.now();
        List<KenanService> services = new List<KenanService>();
        
        for (Integer i = 0; i <= numberOfServices; i++) {
            KenanService service = new KenanService();
            service.sfdcAccountId = accountId;
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
        System.debug(newServices);
        System.debug('createSampleOrder End');
    }

    private static KenanAccount createSampleInsertKenanAccount(String AccountId){
        KenanAccount ka = new KenanAccount();
        
        ka.salesforceOrgId = UserInfo.getOrganizationId();
        ka.salesforceObjectId = AccountId;
        ka.accountCategory = 'SME';             //Required
        ka.billAddress1 = '612 Hamilton';               //Required
        ka.billCity = 'Mertztown';                  //Required
        ka.billCompany = 'Trifecta '    + String.valueOf(Datetime.now());               //Required
        ka.billCountryCode = 840;
        ka.billFname = 'Jack';
        ka.billFranchiseTaxCode = 1;
        ka.billLname = 'Sparrow';                   //Required
        ka.billState = 'PA';                    //Required
        ka.billZip = '18101';                   //Required
        ka.currencyCode  = 'EUR';               //Required
        ka.mktCode  = 'MASTER ACCOUNT';                 //Required
        ka.paymentProfile = createSamplePaymentProfile();

        KenanServiceConnection__c setting = KenanServiceConnection__c.getInstance();
        ka.extIdList = new List<Map<String, String>>();
        Map<String, String> extMap = new Map<String, String>();
        extMap.put('value', AccountId);
        extMap.put('type', setting.Default_Account_External_IdType__c);

        ka.extIdList.add(extMap);
        
        ka.extData = new Map<String, Object>();
        ka.extData.put('1', '2');
        ka.extData.put('14', 'testCompanyNamesCMFEXTDATA');
        
        return ka;
    }

    private static KenanPaymentProfile createSamplePaymentProfile(){
        KenanPaymentProfile pro = new KenanPaymentProfile();
        pro.payMethod = '1';
        return pro;
    }


}