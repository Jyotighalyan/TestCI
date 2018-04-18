Global with sharing class UM_KenanAccountSyncCtrl {
    private csconta__Billing_Account__c billingAccountRecord;
    private Account masterAccountRecord;
    public Id billingAccId;
    public Id accId;
    private csconta__Billing_Account__c mBillingAccount;
    private Account mAccount;
    //BU-234
    private static csconta__Billing_Account__c billingAcc;
    private map<string,UM_Kenan_Mappings__c> kenanFieldMap;
    private map<string,UM_Kenan_Master_Account__c> kenanMasterAccFieldMap;
    private Map<String, Object> billingFieldsValue;
    private map<string,UM_Kenan_Mappings__c> kenanAccFieldMap;
    private Map<String, Object> accountFieldsValue;
    private map<id,Account> accountMap;
    public list<UM_BillingAccountItem__c> accountItemList;
    public list<sObject> accList;
    private Date accountActivationDate;
    public String errorMessage='';
    //added below variables for BHP-21
    private static Id discountRecordTypeId = Schema.SObjectType.UM_BillingAccountItem__c.getRecordTypeInfosByName().get('Discount').getRecordTypeId();
    private static Id adjustmentRecordTypeId = Schema.SObjectType.UM_BillingAccountItem__c.getRecordTypeInfosByName().get('Adjustment').getRecordTypeId(); 
    private static final String APPROVALSTATUS_APPROVED = 'Approved'; 
    private csconta__Billing_Account__c BillingAccount{
        get{
            if(mBillingAccount==null){
                list<csconta__Billing_Account__c> billingAccounts = getBillingAccount();
                if(billingAccounts!=null && !billingAccounts.isEmpty())
                    mBillingAccount = billingAccounts[0];
            }
            return mBillingAccount;
        }
    }

    private list<csconta__Billing_Account__c> getBillingAccount(){
        String query = 'SELECT ';
        String accId = billingAccountRecord.id;
        for(Schema.FieldSetMember f : SObjectType.csconta__Billing_Account__c.FieldSets.BillingAccount.getFields()){
            query += f.getFieldPath() + ', ';
        }
        query += 'Id,csconta__Account__r.Name,csconta__Account__r.UM_Legal_Name__c,csconta__Account__r.LG_Segment__c,Billing_Contact__r.FirstName, Billing_Contact__r.LastName FROM csconta__Billing_Account__c where id=:accId LIMIT 1';

        return Database.query(query);
    }

    private Account MasterAccount{
        get{
            if(mAccount==null){
                list<Account> masterAccounts = getMasterAccount();
                if(masterAccounts!=null && !masterAccounts.isEmpty())
                    mAccount = masterAccounts[0];
            }
            return mAccount;
        }
    }

    private list<Account> getMasterAccount(){
        String query = 'SELECT ';
        //String accId = masterAccountRecord.id;
        for(Schema.FieldSetMember f : SObjectType.Account.FieldSets.MasterAccount.getFields()){
            query += f.getFieldPath() + ', ';
        }
        query += 'Id FROM Account where id=:accId';

        return Database.query(query);
    }

    public UM_KenanAccountSyncCtrl(){
        billingAccId = ApexPages.currentPage().getParameters().get('BillingId');
        accId = ApexPages.currentPage().getParameters().get('Id');
        accountItemList = new list<UM_BillingAccountItem__c>();
//      accountStructure = new map<id,Account>();
        accList = new list<sObject>();
        accountMap = new map<id,Account>();
        kenanMasterAccFieldMap = UM_Kenan_Master_Account__c.getAll();
        kenanFieldMap = UM_Kenan_Mappings__c.getAll();

        if(billingAccId!=null){
            billingAccountRecord = [select id,Name,LG_BillingAccountNumber__c,Cable_master_ID__c, LG_BankAccountNumberIBAN__c, UM_Kenan_Sync_Message__c,
                                    csconta__Account__c,LG_PaymentType__c,csconta__Account__r.LG_VIP__c,
                                    csconta__Account__r.LG_Segment__c,csconta__Account__r.LG_ExternalID__c,
                                    csconta__Account__r.Name,csconta__Account__r.UM_Legal_Name__c,
                                    LG_ExternalID__c,Billing_Contact__r.FirstName, csconta__Account__r.LG_AccountNumber__c,csconta__Account__r.UM_Kenan_Sync_Message__c,
                                    Billing_Contact__r.LastName,LG_HouseNumber__c ,LG_HouseNumberExtension__c,
                                    LG_BankAccountHolder__c,UM_MandateReferenceNumber__c ,LG_MandateStartDate__c,
                                     LG_ContractualOrganization__c, UM_BankAccountNumberBic__c,
                                    UM_Create_Payment_Profile_in_Billing__c,UM_Print_TVO_Info__c,Subscription_PO_Number__c
                                   from
                                    csconta__Billing_Account__c
                                   where id=:billingAccId];

            if(billingAccountRecord!=null && billingAccountRecord.csconta__Account__c!=null && billingAccountRecord.csconta__Account__r.LG_ExternalId__c==null){
                accId = billingAccountRecord.csconta__Account__c;
                accountFieldsValue = MasterAccount.getPopulatedFieldsAsMap();
            }

            if(BillingAccount!=null)
                billingFieldsValue = BillingAccount.getPopulatedFieldsAsMap();
            
            accountActivationDate = getAccountActivationDate(billingAccId);
            //changed below query for BHP-21
            accountItemList = [SELECT id,Name,UM_BillingAccount__c,UM_BillingCode__c,UM_Percentage__c,
                                UM_StartDate__c,UM_EndDate__c,UM_NumberofMonths__c,UM_Approval_Status__c,RecordTypeId,
                                UM_Total_Amount__c,UM_Description__c,UM_NRC_Reason__c
                                FROM UM_BillingAccountItem__c 
                                WHERE UM_BillingAccount__c = :billingAccId AND UM_External_Id__c=null AND UM_Received_from_Billing_System__c=false 
                                AND ((UM_Is_Future_Dated__c=false and RecordTypeId = :discountRecordTypeId ) OR (UM_Is_Future_Dated__c=false and UM_Approval_Status__c=:APPROVALSTATUS_APPROVED AND RecordTypeId= :adjustmentRecordTypeId) )];
        }
        else if(accId!=null){
            masterAccountRecord = [select id,Name,UM_Legal_Name__c, LG_AccountNumber__c,LG_ExternalID__c,UM_Kenan_Sync_Message__c from Account where id=:accId];
            if(MasterAccount!=null)
                accountFieldsValue = MasterAccount.getPopulatedFieldsAsMap();
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Id');
           // //ApexPages.addMessage(myMsg);
            System.debug('Error: Invalid Id');
        }
        System.debug(' ***  Billing Fields: '+billingFieldsValue);
    }

    public UM_KenanAccountSyncCtrl(String accountId, boolean isBillingAccount){
        if(isBillingAccount)
            billingAccId = accountId;
        else
            accId = accountId;
        accList = new list<sObject>();
//      accountStructure = new map<id,Account>();
        accountMap = new map<id,Account>();
        kenanMasterAccFieldMap = UM_Kenan_Master_Account__c.getAll();
        kenanFieldMap = UM_Kenan_Mappings__c.getAll();

        if(billingAccId!=null){
            billingAccountRecord = [select id,Name,LG_BillingAccountNumber__c,Cable_master_ID__c,LG_BankAccountNumberIBAN__c,UM_Kenan_Sync_Message__c,
                                    csconta__Account__c,LG_PaymentType__c,csconta__Account__r.LG_VIP__c,
                                    csconta__Account__r.LG_Segment__c,csconta__Account__r.LG_ExternalID__c,
                                    csconta__Account__r.Name,csconta__Account__r.UM_Legal_Name__c,
                                    LG_ExternalID__c,Billing_Contact__r.FirstName,csconta__Account__r.LG_AccountNumber__c,csconta__Account__r.UM_Kenan_Sync_Message__c,
                                    Billing_Contact__r.LastName,LG_HouseNumber__c ,LG_HouseNumberExtension__c,
                                    LG_BankAccountHolder__c,UM_MandateReferenceNumber__c ,LG_MandateStartDate__c,
                                     LG_ContractualOrganization__c, UM_BankAccountNumberBic__c,
                                    UM_Create_Payment_Profile_in_Billing__c, UM_Print_TVO_Info__c,Subscription_PO_Number__c
                                   from
                                    csconta__Billing_Account__c
                                   where id=:billingAccId];

            if(billingAccountRecord!=null && billingAccountRecord.csconta__Account__c!=null && billingAccountRecord.csconta__Account__r.LG_ExternalId__c==null){
                accId = billingAccountRecord.csconta__Account__c;
                accountFieldsValue = MasterAccount.getPopulatedFieldsAsMap();
            }

            if(BillingAccount!=null)
                billingFieldsValue = BillingAccount.getPopulatedFieldsAsMap();

            accountActivationDate = getAccountActivationDate(billingAccId);
            //changed below query for BHP-21
            accountItemList = [SELECT id,Name,UM_BillingAccount__c,UM_BillingCode__c,UM_Percentage__c,
                                UM_StartDate__c,UM_EndDate__c,UM_NumberofMonths__c,UM_Approval_Status__c,RecordTypeId,
                                UM_Total_Amount__c,UM_Description__c,UM_NRC_Reason__c
                                FROM UM_BillingAccountItem__c 
                                WHERE UM_BillingAccount__c = :billingAccId AND UM_External_Id__c=null AND UM_Received_from_Billing_System__c=false
                                AND ((UM_Is_Future_Dated__c=false and RecordTypeId = :discountRecordTypeId ) OR (UM_Is_Future_Dated__c=false and UM_Approval_Status__c= :APPROVALSTATUS_APPROVED AND RecordTypeId= :adjustmentRecordTypeId) )];
        }
        else if(accId!=null){
            masterAccountRecord = [select id,Name,UM_Legal_Name__c, LG_AccountNumber__c,LG_ExternalID__c,UM_Kenan_Sync_Message__c  from Account where id=:accId];
            if(MasterAccount!=null)
                accountFieldsValue = MasterAccount.getPopulatedFieldsAsMap();
            system.debug('Master Account '+accountFieldsValue);
        }
        else{
            if(!System.isQueueable())
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Id');
                ApexPages.addMessage(myMsg);
                System.debug('Error: Invalid Id');
            }
            else
                errorMessage+='*** Invalid Id';
        }
        System.debug(' ***  Billing Fields: '+billingFieldsValue);
    }
    
    public void intiateAutoSync(){
    list<sObject> accountsToUpdate = syncKenanAccount();
        //List<Account> accountsToUpdateWithErrorMessage=[Select id,UM_Kenan_Sync_Message__c from Account Where id in: accountsToUpdate ];
        
        if(accountsToUpdate!=null && !accountsToUpdate.isEmpty()){
           system.debug('***'+accountsToUpdate);
            update accountsToUpdate;
            if(accountItemList!=null && !accountItemList.isEmpty())
                update accountItemList; 
        }
        System.debug(' ***  Billing Fields: '+billingFieldsValue);
    }

    public pageReference initiateSync(){
        list<sObject> accountsToUpdate = syncKenanAccountForPage();
        if(accountsToUpdate!=null && !accountsToUpdate.isEmpty()){
            update accountsToUpdate;
            update accountItemList;
        }

        return null;
    }

    public list<sObject> syncKenanAccountForPage(){
        KenanAccount kBillingAct;
        KenanAccount kMasterAct;
        string accountId;
        string kenanId = '';
        list<KenanAccount> kAccBack;
        boolean updateMasterAccount=false;
        try{
            if(billingAccId!=null){
                accountId = billingAccountRecord.csconta__Account__c;
                masterAccountRecord = [select id,Name,LG_ExternalID__c,UM_Legal_Name__c,LG_AccountNumber__c,UM_Kenan_Sync_Message__c from Account where id=:accountId];
                if(billingAccountRecord!=null && billingAccountRecord.LG_ExternalID__c==null){
                    if(masterAccountRecord!=null && masterAccountRecord.LG_ExternalID__c==null){
                        kAccBack = sendKenanAccountHierarchy(accountId);
                        for(KenanAccount k : kAccBack){
                            accountMap.get(k.salesforceObjectId).LG_ExternalId__c = String.valueOf(k.accountInternalId);
                            accountMap.get(k.salesforceObjectId).UM_LastSyncedwithBilling__c = DateTime.now();

                            if(!String.isBlank(kenanId))
                                kenanId += ' ,';
                            kenanId += String.valueOf(k.accountInternalId) ;
                        }
                        accList.addAll((list<sObject>)accountMap.values());
                    }
                    kBillingAct = sendBillingAccountCreate();
                    if(!String.isBlank(kenanId))
                        kenanId += ' ,';
                    kenanId += String.valueOf(kBillingAct.accountInternalId);
                }
                else{
                    if(isAccountOutOfDate(billingAccId)){
                        kBillingAct = sendAccountModify(true);
                        if(masterAccountRecord!=null && masterAccountRecord.LG_ExternalID__c!=null){
                            if(isAccountOutOfDate(masterAccountRecord.id)){
                                kMasterAct = sendAccountModify(false);
                                updateMasterAccount = true;
                            }
                        }
                    }
                    kenanId = billingAccountRecord.LG_ExternalID__c;
                }
            }else if(accId!=null){
                accountId = accId;
                if(masterAccountRecord!=null && masterAccountRecord.LG_ExternalID__c!=null) {
                    kenanId = masterAccountRecord.LG_ExternalID__c;
                    if(isAccountOutOfDate(accountId)){
                        kMasterAct = sendAccountModify(false);
                        updateMasterAccount = true;
                    }
                }/*else{
                    kAct = sendAccountCreate();
                    kenanId = String.valueOf(kAct.accountInternalId);
                }*/
            }
            System.debug('*** KenanId: '+ KenanId);
            if(String.isBlank(kenanId)){
                kAccBack = sendKenanAccountHierarchy(accountId);

                System.debug('*** accountMap (Before): '+ accountMap);
                for(KenanAccount k : kAccBack){
                    System.debug('*** k: '+k);
                    accountMap.get(k.salesforceObjectId).LG_ExternalId__c = String.valueOf(k.accountInternalId);
                    accountMap.get(k.salesforceObjectId).UM_LastSyncedwithBilling__c = DateTime.now();

                    if(!String.isBlank(kenanId))
                        kenanId += ' ,';

                    kenanId += String.valueOf(k.accountInternalId) ;
                }
                accList.addAll((list<sObject>)accountMap.values());
                //update accountMap.values();
            }
            System.debug('*** kAccBack:'+kAccBack);
            System.debug('*** accountMap (After): '+ accountMap);

            //kAct = sendAccountCease();
            //createSampleHeirarchy();
        }catch (Kenanexception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.errorMessage);
            ApexPages.addMessage(myMsg);
            errorMessage+=' *** MESSAGE *** '+e.errorMessage;
            //return null;
        }
        catch(exception e){
            System.debug('Error: '+e.getMessage() + 'stack trace:'+ e.getStackTraceString());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
            errorMessage+=' *** MESSAGE *** '+e.getMessage();
            //return null;
        }
        System.debug('*** kBillingAct: '+kBillingAct + ' kMasterAct: '+kMasterAct);
        if((kMasterAct!=null && kMasterAct.accountInternalId!=null) ||
           (kBillingAct!=null && kBillingAct.accountInternalId!=null)){
               /*if(kBillingAct!=null && kBillingAct.accountInternalId!=null)
                   kenanId = String.valueOf(kBillingAct.accountInternalId);
               else if(kMasterAct!=null && kMasterAct.accountInternalId!=null)
                   kenanId = String.valueOf(kMasterAct.accountInternalId);*/

            if(billingAccId!=null){
                billingAccountRecord.LG_ExternalID__c=String.valueOf(kBillingAct.accountInternalId);
                billingAccountRecord.UM_LastSyncedwithBilling__c = DateTime.now();

                if(billingAccountRecord.UM_Create_Payment_Profile_in_Billing__c )
                   billingAccountRecord.UM_Create_Payment_Profile_in_Billing__c=false;

                if(updateMasterAccount){
                    masterAccountRecord.UM_LastSyncedwithBilling__c = DateTime.now();
                    accList.add(masterAccountRecord);
                }
                accList.add(billingAccountRecord);
                //update billingAccountRecord;

                System.debug('*** accountMap (Before): '+ accountMap);

            }else if(accid!=null){
                masterAccountRecord.LG_ExternalID__c=String.valueOf(kMasterAct.accountInternalId);
                masterAccountRecord.UM_LastSyncedwithBilling__c = DateTime.now();
                accList.add(masterAccountRecord);
                //update masterAccountRecord;
		
            }
        }
        if(!String.isBlank(kenanId)){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.UM_KenanAccountSync + kenanId);
            ApexPages.addMessage(myMsg);
            errorMessage+=' '+Label.UM_KenanAccountSync + kenanId;
        }
        if(accid!=null)
        {
            masterAccountRecord.UM_Kenan_Sync_Message__c=errorMessage;
            //accList.add(masterAccountRecord);
            }
        if(billingAccId!=null)
        {
            billingAccountRecord.UM_Kenan_Sync_Message__c=errorMessage;
            //accList.add(billingAccountRecord);
        }
        System.debug('*** accList: '+accList);

        return accList;
    }

    public list<sObject> syncKenanAccount(){
        KenanAccount kBillingAct;
        KenanAccount kMasterAct;
        string accountId;
        string kenanId = '';
        list<KenanAccount> kAccBack;
        boolean updateMasterAccount=false;
        try{
            if(billingAccId!=null){
                accountId = billingAccountRecord.csconta__Account__c;
                masterAccountRecord = [select id,Name,LG_ExternalID__c,UM_Legal_Name__c,LG_AccountNumber__c,UM_Kenan_Sync_Message__c from Account where id=:accountId];
                if(billingAccountRecord!=null && billingAccountRecord.LG_ExternalID__c==null){
                    if(masterAccountRecord!=null && masterAccountRecord.LG_ExternalID__c==null){
                        kAccBack = sendKenanAccountHierarchy(accountId);
                        for(KenanAccount k : kAccBack){
                            accountMap.get(k.salesforceObjectId).LG_ExternalId__c = String.valueOf(k.accountInternalId);
                            accountMap.get(k.salesforceObjectId).UM_LastSyncedwithBilling__c = DateTime.now();
                            if(!String.isBlank(kenanId))
                                kenanId += ' ,';
                            kenanId += String.valueOf(k.accountInternalId) ;
                        }
                        accList.addAll((list<sObject>)accountMap.values());
                    }
                    /*else{
                        if(masterAccountRecord!=null && masterAccountRecord.LG_ExternalID__c!=null){
                            if(isAccountOutOfDate(masterAccountRecord.id)){
                                kMasterAct = sendAccountModify(false);
                                updateMasterAccount = true;
                            }
                        }
                    }*/
                    kBillingAct = sendBillingAccountCreate();
                    if(!String.isBlank(kenanId))
                        kenanId += ' ,';
                    kenanId += String.valueOf(kBillingAct.accountInternalId);
                }
                else{
                    if(isAccountOutOfDate(billingAccId)){
                        kBillingAct = sendAccountModify(true);
                        if(masterAccountRecord!=null && masterAccountRecord.LG_ExternalID__c==null){
                            if(isAccountOutOfDate(masterAccountRecord.id)){
                                kMasterAct = sendAccountModify(false);
                                updateMasterAccount = true;
                            }
                        }
                    }
                    kenanId = billingAccountRecord.LG_ExternalID__c;
                }
            }else if(accId!=null){
                accountId = accId;
                if(masterAccountRecord!=null && masterAccountRecord.LG_ExternalID__c!=null) {
                    kenanId = masterAccountRecord.LG_ExternalID__c;
                    if(isAccountOutOfDate(accountId)){
                        kMasterAct = sendAccountModify(false);
                        updateMasterAccount = true;
                    }
                }
            }

            if(String.isBlank(kenanId)){
                kAccBack = sendKenanAccountHierarchy(accountId);

                for(KenanAccount k : kAccBack){
                    accountMap.get(k.salesforceObjectId).LG_ExternalId__c = String.valueOf(k.accountInternalId);
                    accountMap.get(k.salesforceObjectId).UM_LastSyncedwithBilling__c = DateTime.now();

                    if(!String.isBlank(kenanId))
                        kenanId += ' ,';

                    kenanId += String.valueOf(k.accountInternalId) ;
                }
                accList.addAll((list<sObject>)accountMap.values());
            }
        }catch (Kenanexception e){
            System.debug('Error: '+e.getMessage() + 'stack trace:'+ e.getStackTraceString());
            errorMessage+=' *** MESSAGE *** '+e.errorMessage;
        }
        catch(exception e){
            System.debug('Error: '+e.getMessage() + 'stack trace:'+ e.getStackTraceString());
            errorMessage+=' *** MESSAGE *** '+e.getMessage();
        }
        System.debug('*** kBillingAct: '+kBillingAct + ' kMasterAct: '+kMasterAct);
        if((kMasterAct!=null && kMasterAct.accountInternalId!=null) ||
           (kBillingAct!=null && kBillingAct.accountInternalId!=null)){
               if(kBillingAct!=null && kBillingAct.accountInternalId!=null)
                   kenanId = String.valueOf(kBillingAct.accountInternalId);
               else if(kMasterAct!=null && kMasterAct.accountInternalId!=null)
                   kenanId = String.valueOf(kMasterAct.accountInternalId);

            if(billingAccId!=null){
                if(kBillingAct!=null && kBillingAct.accountInternalId!=null){
                    billingAccountRecord.LG_ExternalID__c=String.valueOf(kBillingAct.accountInternalId);

                    billingAccountRecord.UM_LastSyncedwithBilling__c = DateTime.now();
                    if(billingAccountRecord.UM_Create_Payment_Profile_in_Billing__c )
                        billingAccountRecord.UM_Create_Payment_Profile_in_Billing__c=false;

                    if(updateMasterAccount){
                        masterAccountRecord.UM_LastSyncedwithBilling__c = DateTime.now();
                        accList.add(masterAccountRecord);
                    }
                    accList.add(billingAccountRecord);
                }
            }else if(accid!=null){
                masterAccountRecord.LG_ExternalID__c=String.valueOf(kMasterAct.accountInternalId);
                masterAccountRecord.UM_LastSyncedwithBilling__c = DateTime.now();
                
                accList.add(masterAccountRecord);
            }
        }
        if(!String.isBlank(kenanId)){
            errorMessage+=' *** MESSAGE ***'+Label.UM_KenanAccountSync + kenanId;
        }
        if(accid!=null)
        {
            masterAccountRecord.UM_Kenan_Sync_Message__c=errorMessage;
            //accList.add(masterAccountRecord);
        }
        if(billingAccId!=null)
        {
            billingAccountRecord.UM_Kenan_Sync_Message__c=errorMessage;
            //accList.add(billingAccountRecord);
        }

        System.debug('*** accList: '+accList);
        return accList;
    }

    public KenanAccount sendAccountCreate(){
        String accountId;
        KenanAccount act;

        KenanConnectorService service = new KenanConnectorService();

        if(masterAccountRecord!=null){
            accountId = masterAccountRecord.id;
            act = createKenanAccount(accountId,accountFieldsValue,masterAccountRecord.LG_AccountNumber__c);
        }

        System.debug('*** kenanAcc: '+act);
        KenanAccount actBack = service.accountCreate(act);
        System.debug('actBack:' + actBack);
        return actBack;

    }

    public KenanAccount sendBillingAccountCreate(){
        String accountId;
        KenanAccount act;
        list<KenanAccountItem> accountItems = new list<KenanAccountItem>();
        KenanConnectorService service = new KenanConnectorService();

        if(billingAccountRecord!=null){
            accountId = billingAccountRecord.id;
            act = createKenanBillingAccount(accountId,billingFieldsValue);
            System.debug('*** billing account='+act);
        }

        KenanAccount actBack = service.accountCreate(act);

        if(actBack!=null){
            for(UM_BillingAccountItem__c item : accountItemList){
                KenanAccountItem accItem = createKenanAccountItemForCreate(item);
                try{
                    list<KenanAccountItem> retAccItems = service.accountItemCreate(accItem);
                    System.debug('*** retAccItems='+retAccItems);
                    if(retAccItems!=null && !retAccItems.isEmpty())
                    {
                        item.UM_External_Id__c = retAccItems[0].instanceId;
                        item.UM_Last_Synced_with_Billing__c = System.now();
                        item.UM_Kenan_Sync_Message__c = 'Kenan Synced successfully. Kenan Id:'+retAccItems[0].instanceId;
                    }
                }catch(exception e){
                    System.debug('*** Error ='+e.getMessage());
                    item.UM_Last_Synced_with_Billing__c = System.now();
                    item.UM_Kenan_Sync_Message__c = 'Kenan Sync Failed:'+e.getMessage();
                }
            }
        }
        System.debug('actBack:' + actBack);
        return actBack;

    }

    public KenanAccount sendAccountModify(boolean updateBillingAccount){
        String accountId;
        KenanAccount act;
        KenanPaymentProfile p;
        KenanConnectorService service = new KenanConnectorService();
        if(updateBillingAccount && billingAccountRecord!=null){
            accountId = billingAccountRecord.id;
             act = createKenanBillingAccountForUpdate(accountId);
            System.debug('*** act: '+act);
            if(billingAccountRecord.UM_Create_Payment_Profile_in_Billing__c)
                p = service.paymentProfileCreate(act.paymentProfile);
            System.debug('*** profile: '+ p);
        }
        else if(!updateBillingAccount && masterAccountRecord!=null){
            accountId = masterAccountRecord.id;
             act = createKenanAccountForUpdate(accountId);
        }
        KenanAccount actBack = service.accountUpdate(act);
        if(updateBillingAccount && billingAccountRecord!=null && actBack!=null){
            for(UM_BillingAccountItem__c item : accountItemList){
                try{
                    KenanAccountItem accItem = createKenanAccountItemForCreate(item);
                    system.debug('ItemJsonString#'+json.serialize(accItem) );
                    list<KenanAccountItem> retAccItems = service.accountItemCreate(accItem);
                    if(retAccItems!=null && !retAccItems.isEmpty())
                    {
                        item.UM_External_Id__c = retAccItems[0].instanceId;
                        item.UM_Last_Synced_with_Billing__c = System.now();
                        item.UM_Kenan_Sync_Message__c = 'Kenan Synced successfully. Kenan Id:'+retAccItems[0].instanceId;
                    }
                    System.debug('*** retAccItems='+retAccItems);
                }catch(exception e){
                    System.debug('*** Error ='+e.getMessage());
                    item.UM_Last_Synced_with_Billing__c = System.now();
                    item.UM_Kenan_Sync_Message__c = 'Kenan Sync failed'+ e.getMessage();
                }
            }
            //update accountItemList;
        }
        System.debug('actBack:' + actBack);

        return actBack;
    }

    public KenanAccount createKenanBillingAccount(String accountId,Map<String, Object> fieldsValue){
        string houseNumber='';
        string houseNumberExt = '';
        string address1 = '';
        //list<KenanAccountItem> accountItems = new list<KenanAccountItem>();
        KenanAccount ka = new KenanAccount();
        System.debug('*** fieldsValue: '+fieldsValue + '  and accountId: '+accountId);

        ka.salesforceOrgId = UserInfo.getOrganizationId();
        ka.salesforceObjectId = accountId;
        ka.parentAccountExternalId = billingAccountRecord.csconta__Account__c;
        ka.parentAccountExternalIdType = 2;
        ka.accountType = 'billable';
        ka.exrateClass = 1;
        ka.dateActive = accountActivationDate;

        //ka.rateClassDefault = '9';
        //ka.dateActive
        boolean isVip = billingAccountRecord.csconta__Account__r.LG_VIP__c;
        if(isVip)
            ka.vipCode = 2;
        else
            ka.vipCode = 1;

        if(fieldsValue!=null && !fieldsValue.isEmpty()){

            if(fieldsValue.get(kenanFieldMap.get('billAddress1').Field_Name__c)!=null)
                address1= (string) fieldsValue.get(kenanFieldMap.get('billAddress1').Field_Name__c);

            if(fieldsValue.get(kenanFieldMap.get('houseNumber').Field_Name__c)!=null)
                houseNumber = (String) fieldsValue.get(kenanFieldMap.get('houseNumber').Field_Name__c);

            if(fieldsValue.get(kenanFieldMap.get('houseNumberExt').Field_Name__c)!=null)
                houseNumberExt= (String) fieldsValue.get(kenanFieldMap.get('houseNumberExt').Field_Name__c);

            ka.billAddress1 = address1 + ' ' +
                              houseNumber +
                              houseNumberExt;

            ka.billCity = (String) fieldsValue.get(kenanFieldMap.get('billCity').Field_Name__c);                    //Required
            ka.billState = (String) fieldsValue.get(kenanFieldMap.get('billState').Field_Name__c);                  //Required
            ka.billZip = (String) fieldsValue.get(kenanFieldMap.get('billZip').Field_Name__c);                  //Required
            // Start - Setting Company/Account Name
            String companyName = billingAccountRecord.csconta__Account__r.Name;
            ka.billCompany = companyName.substring(0,companyName.length()<56?companyName.length():56); //'bill_company'; // //Required
            ka.extData = new Map<String, Object>();
            ka.extData.put('14', billingAccountRecord.csconta__Account__r.Name);
            if(!String.isBlank(billingAccountRecord.csconta__Account__r.UM_Legal_Name__c))
                ka.extData.put('18', billingAccountRecord.csconta__Account__r.UM_Legal_Name__c);

            // TVO info - added by Omkar
            if(billingAccountRecord.UM_Print_TVO_Info__c)
                ka.extData.put('22', 1); // TVO info - added by Omkar
            else
                ka.extData.put('22', 0);
                
             //BU-191
             if(billingAccountRecord.Subscription_PO_Number__c != null)
                ka.extData.put('27', billingAccountRecord.Subscription_PO_Number__c);

            //END - Setting Company/Account Name


            ka.accountCategory = billingAccountRecord.csconta__Account__r.LG_Segment__c;
                        ka.mktCode  = (String) fieldsValue.get(kenanFieldMap.get('mktCode').Field_Name__c);                     //Required
            ka.billFmtOpt = (String) fieldsValue.get(kenanFieldMap.get('billFmtOpt').Field_Name__c);
            ka.billDispMeth = (String) fieldsValue.get(kenanFieldMap.get('billDispMeth').Field_Name__c);
            ka.billPeriod = (String) fieldsValue.get(kenanFieldMap.get('billPeriod').Field_Name__c);

            Contact billContact = (Contact)fieldsValue.get(kenanFieldMap.get('billFname').Field_Name__c);
            if(billContact!=null){
                ka.billFname = billContact.FirstName;
                ka.billLname = billContact.LastName;
            }
        }
        /*for(UM_BillingAccountItem__c item : accountItemList){
            KenanAccountItem accItem = createKenanAccountItemForCreate(item);
            accountItems.add(accItem);
        }*/
        //ka.accountItems = accountItems;
        ka.currencyCode  = UserInfo.getDefaultCurrency();               //Required
        ka.paymentProfile = createPaymentProfileForBilling();

        ka.extIdList = new List<Map<String, String>>();
        Map<String, String> extMap = new Map<String, String>();
        //extMap.put('value', accountId);
        extMap.put('value',billingAccountRecord.Id); // changed to Billing Account Id as OMB-810 was raised
        extMap.put('type', '2');


        Map<String, String> extAccIdMap = new Map<String, String>();
        extAccIdMap.put('value',billingAccountRecord.LG_BillingAccountNumber__c);
        extAccIdMap.put('type','4');

        Map<String, String> extAccIdMap2 = new Map<String, String>();
        extAccIdMap2.put('value',billingAccountRecord.csconta__Account__r.LG_AccountNumber__c);
        extAccIdMap2.put('type','15');

        if(billingAccountRecord.Cable_master_ID__c!=null){
            Map<String, String> extIdCableMasterMap = new Map<String, String>();
            extIdCableMasterMap.put('value',String.valueOf(billingAccountRecord.Cable_master_ID__c));
            extIdCableMasterMap.put('type','3');
            ka.extIdList.add(extIdCableMasterMap);
        }

        ka.extIdList.add(extMap);
        ka.extIdList.add(extAccIdMap);
        ka.extIdList.add(extAccIdMap2);

        return ka;
    }

    public KenanAccount createKenanAccount(String accountId,Map<String, Object> fieldsValue,String accountNumber){
        string houseNumber='';
        string houseNumberExt = '';
        string address1 = '';

        KenanAccount ka = new KenanAccount();
        System.debug('*** fieldsValue: '+fieldsValue + '  and accountId: '+accountId);

        ka.salesforceOrgId = UserInfo.getOrganizationId();
        ka.salesforceObjectId = accountId;
        ka.accountType = 'unbillable';
        ka.vipCode = 1;
        ka.exrateClass = 1;
        if(accountActivationDate==null)
            accountActivationDate= Date.today();
        else
            ka.dateActive = accountActivationDate;
        //ka.rateClassDefault = '9';

        if(fieldsValue!=null && !fieldsValue.isEmpty()){
            boolean isVip = (boolean) fieldsValue.get(kenanMasterAccFieldMap.get('vipCode').Field_Name__c);
            if(isVip)
                ka.vipCode = 2;
            else
                ka.vipCode = 1;
            ka.accountCategory = fieldsValue.get(kenanMasterAccFieldMap.get('accountCategory').Field_Name__c)!=null?String.valueOf(fieldsValue.get(kenanMasterAccFieldMap.get('accountCategory').Field_Name__c)):null;

            if(fieldsValue.get(kenanMasterAccFieldMap.get('billAddress1').Field_Name__c)!=null)
                address1= (string) fieldsValue.get(kenanMasterAccFieldMap.get('billAddress1').Field_Name__c);

            if(fieldsValue.get(kenanMasterAccFieldMap.get('houseNumber').Field_Name__c)!=null)
                houseNumber = (String) fieldsValue.get(kenanMasterAccFieldMap.get('houseNumber').Field_Name__c);

            if(fieldsValue.get(kenanMasterAccFieldMap.get('houseNumberExt').Field_Name__c)!=null)
                houseNumberExt= (String) fieldsValue.get(kenanMasterAccFieldMap.get('houseNumberExt').Field_Name__c);

            System.debug('*** address1: '+address1+' houseNumber: '+houseNumber+' houseNumberExt:'+houseNumberExt);

            ka.billAddress1 = address1 + ' ' +
                              houseNumber +
                              houseNumberExt;

            System.debug('*** ka.billAddress1: '+ka.billAddress1);

            ka.billCity = fieldsValue.get(kenanMasterAccFieldMap.get('billCity').Field_Name__c)!=null?String.valueOf(fieldsValue.get(kenanMasterAccFieldMap.get('billCity').Field_Name__c)):null;                   //Required
            ka.billState = fieldsValue.get(kenanMasterAccFieldMap.get('billState').Field_Name__c)!=null?String.valueOf(fieldsValue.get(kenanMasterAccFieldMap.get('billState').Field_Name__c)):null;                    //Required
            ka.billZip = fieldsValue.get(kenanMasterAccFieldMap.get('billZip').Field_Name__c)!=null?String.valueOf(fieldsValue.get(kenanMasterAccFieldMap.get('billZip').Field_Name__c)):null;                  //Required
            //Start - Set Company/Account Name
            String companyName = (String) fieldsValue.get(kenanMasterAccFieldMap.get('billCompany').Field_Name__c);
            ka.billCompany =  companyName.substring(0,companyName.length()<56?companyName.length():56) ;//'bill_company'; //Required
            ka.extData = new Map<String, Object>();
            ka.extData.put('14', companyName);
            ka.extData.put('12',0);
            ka.extData.put('22',0);
            if(!String.isBlank(masterAccountRecord.UM_Legal_Name__c))
                ka.extData.put('18', masterAccountRecord.UM_Legal_Name__c);

            //End - Set Company/Account Name
        }
        ka.mktCode  = 'MASTER ACCOUNT';                 //Required
        ka.currencyCode  = UserInfo.getDefaultCurrency();               //Required
        ka.paymentProfile = createPaymentProfileForMaster();
       /* ka.extData = new Map<String, Object>();
        ka.extData.put('1', '1'); */
        ka.extIdList = new List<Map<String, String>>();
        Map<String, String> extMap = new Map<String, String>();
        extMap.put('value', accountId);
        extMap.put('type', '2');

        map<string,string> extAccIdMap = new map<string,string>();
        extAccIdMap.put('value',accountNumber);
        extAccIdMap.put('type','4');

        ka.extIdList.add(extMap);
        ka.extIdList.add(extAccIdMap);
        System.debug('*** createKenanAccount: '+ka);

        return ka;
    }

    public KenanPaymentProfile createPaymentProfileForBilling(){
        KenanPaymentProfile pro = new KenanPaymentProfile();
        //if(isUpdate){
            pro.accountExternalId = billingAccountRecord.id;
            pro.accountExternalIdType = 2;
        //}
        if(billingAccountRecord.LG_PaymentType__c =='Direct Debit'){
            pro.payMethod = '3';
            if(billingAccountRecord.LG_ContractualOrganization__c=='Nordrhein-Westfalen (NRW)')
                pro.clearingHouseId = 'NRW';
            else if(billingAccountRecord.LG_ContractualOrganization__c=='Baden-Württemberg (BAW)')
                pro.clearingHouseId = 'BAW';
            else if(billingAccountRecord.LG_ContractualOrganization__c=='Hessen (HSN)')
                pro.clearingHouseId = 'HSN';
            //pro.clearingHouseId = billingAccountRecord.LG_ContractualOrganization__c;
            pro.custBankIban = billingAccountRecord.LG_BankAccountNumberIBAN__c;
            pro.custBankBic = billingAccountRecord.UM_BankAccountNumberBic__c;
            pro.custBankAccOwner = billingAccountRecord.LG_BankAccountHolder__c;
            pro.mandateId = billingAccountRecord.UM_MandateReferenceNumber__c;
            pro.mandateSignDate = billingAccountRecord.LG_MandateStartDate__c;
            pro.mandateStatus = 'Active';
            pro.ownrFname = billingAccountRecord.Billing_Contact__r.FirstName;
            pro.ownrLname = billingAccountRecord.Billing_Contact__r.LastName;
            pro.sequenceType ='FRST';
            pro.mandateReset = 'N';
        }
        else
           pro.payMethod = '1';
        return pro;
    }

    public KenanPaymentProfile createPaymentProfileForMaster(){
        KenanPaymentProfile pro = new KenanPaymentProfile();
        pro.payMethod = '1';
        return pro;
    }

    public KenanAccount createKenanBillingAccountForUpdate(String accountId){
        string houseNumber='';
        string houseNumberExt = '';
        string address1 = '';

        KenanAccount ka = new KenanAccount();
        ka.salesforceOrgId = UserInfo.getOrganizationId();
        ka.salesforceObjectId = accountId;
        ka.accountCategory = billingAccountRecord.csconta__Account__r.LG_Segment__c;
        ka.accountType = 'billable';
        ka.exrateClass = 1;
        ka.parentAccountExternalId = billingAccountRecord.csconta__Account__c;
        ka.parentAccountExternalIdType = 2;
        //ka.rateClassDefault = '9';

        if(billingFieldsValue!=null && !billingFieldsValue.isEmpty()){
            boolean isVip = billingAccountRecord.csconta__Account__r.LG_VIP__c;
            if(isVip)
                ka.vipCode = 2;
            else
                ka.vipCode = 1;

            if(billingFieldsValue.get(kenanFieldMap.get('billAddress1').Field_Name__c)!=null)
                address1= (string) billingFieldsValue.get(kenanFieldMap.get('billAddress1').Field_Name__c);

            if(billingFieldsValue.get(kenanFieldMap.get('houseNumber').Field_Name__c)!=null)
                houseNumber = (String) billingFieldsValue.get(kenanFieldMap.get('houseNumber').Field_Name__c);

            if(billingFieldsValue.get(kenanFieldMap.get('houseNumberExt').Field_Name__c)!=null)
                houseNumberExt= (String) billingFieldsValue.get(kenanFieldMap.get('houseNumberExt').Field_Name__c);

            ka.billAddress1 = address1 + ' ' +
                              houseNumber +
                              houseNumberExt;

            ka.billCity = (String) billingFieldsValue.get(kenanFieldMap.get('billCity').Field_Name__c);                 //Required
            ka.billState = (String) billingFieldsValue.get(kenanFieldMap.get('billState').Field_Name__c);                   //Required
            ka.billZip = (String) billingFieldsValue.get(kenanFieldMap.get('billZip').Field_Name__c);                   //Required
            // Start - Setting Company/Account Name
                                                String companyName = billingAccountRecord.csconta__Account__r.Name;
            ka.billCompany = companyName.substring(0,companyName.length()<56?companyName.length():56); //'bill_company'; // //Required
            ka.extData = new Map<String, Object>();
            ka.extData.put('14', billingAccountRecord.csconta__Account__r.Name);
            if(!String.isBlank(billingAccountRecord.csconta__Account__r.UM_Legal_Name__c))
                ka.extData.put('18', billingAccountRecord.csconta__Account__r.UM_Legal_Name__c);

            if(billingAccountRecord.UM_Print_TVO_Info__c)
                ka.extData.put('22', 1); // TVO info - added by Omkar
            else
                ka.extData.put('22', 0);
                
             //BU-191:
             if(billingAccountRecord.Subscription_PO_Number__c != null)
                ka.extData.put('27', billingAccountRecord.Subscription_PO_Number__c);

            //END - Setting Company/Account Name            ka.mktCode  = (String) billingFieldsValue.get(kenanFieldMap.get('mktCode').Field_Name__c);                      //Required
            ka.billFmtOpt = (String) billingFieldsValue.get(kenanFieldMap.get('billFmtOpt').Field_Name__c);
            ka.billDispMeth = (String) billingFieldsValue.get(kenanFieldMap.get('billDispMeth').Field_Name__c);
            ka.billPeriod = (String) billingFieldsValue.get(kenanFieldMap.get('billPeriod').Field_Name__c);

            Contact billContact = (Contact)billingFieldsValue.get(kenanFieldMap.get('billFname').Field_Name__c);
            if(billContact!=null){
                ka.billFname = billContact.FirstName;
                ka.billLname = billContact.LastName;
            }
        }
        if(billingAccountRecord.UM_Create_Payment_Profile_in_Billing__c )
            ka.paymentProfile = createPaymentProfileForBilling();

        ka.extIdList = new List<Map<String, String>>();
        Map<String, String> extMap = new Map<String, String>();
        //extMap.put('value', billingAccountRecord.csconta__Account__c);
        extMap.put('value', billingAccountRecord.Id); // changed to Billing Account Id as OMB-810 was raised
        extMap.put('type', '2');

        ka.extIdList.add(extMap);
        return ka;
    }

    public KenanAccount createKenanAccountForUpdate(String accountId){
        string houseNumber='';
        string houseNumberExt = '';
        string address1 = '';

        KenanAccount ka = new KenanAccount();
        ka.salesforceOrgId = UserInfo.getOrganizationId();
        ka.salesforceObjectId = accountId;
        ka.accountType = 'unbillable';
        ka.exrateClass = 1;
        //ka.rateClassDefault = '9';

        if(accountFieldsValue!=null && !accountFieldsValue.isEmpty()){
            boolean isVip = (boolean) accountFieldsValue.get(kenanMasterAccFieldMap.get('vipCode').Field_Name__c);
            if(isVip)
                ka.vipCode = 2;
            else
                ka.vipCode = 1;

            ka.accountCategory = (String) accountFieldsValue.get(kenanMasterAccFieldMap.get('accountCategory').Field_Name__c);

            if(accountFieldsValue.get(kenanMasterAccFieldMap.get('billAddress1').Field_Name__c)!=null)
                address1= (string) accountFieldsValue.get(kenanMasterAccFieldMap.get('billAddress1').Field_Name__c);

            if(accountFieldsValue.get(kenanMasterAccFieldMap.get('houseNumber').Field_Name__c)!=null)
                houseNumber = (String) accountFieldsValue.get(kenanMasterAccFieldMap.get('houseNumber').Field_Name__c);

            if(accountFieldsValue.get(kenanMasterAccFieldMap.get('houseNumberExt').Field_Name__c)!=null)
                houseNumberExt= (String) accountFieldsValue.get(kenanMasterAccFieldMap.get('houseNumberExt').Field_Name__c);

            ka.billAddress1 = address1 + ' ' +
                              houseNumber +
                              houseNumberExt;

            ka.billCity = (String) accountFieldsValue.get(kenanMasterAccFieldMap.get('billCity').Field_Name__c);                    //Required
            ka.billState = (String) accountFieldsValue.get(kenanMasterAccFieldMap.get('billState').Field_Name__c);                  //Required
            ka.billZip = (String) accountFieldsValue.get(kenanMasterAccFieldMap.get('billZip').Field_Name__c);                  //Required
            //Start - Set Company/Account Name
            String companyName = (String) accountFieldsValue.get(kenanMasterAccFieldMap.get('billCompany').Field_Name__c);
            ka.billCompany =  companyName.substring(0,companyName.length()<56?companyName.length():56) ;//'bill_company'; //Required
            ka.extData = new Map<String, Object>();
            ka.extData.put('14', companyName);
            if(!String.isBlank(masterAccountRecord.UM_Legal_Name__c))
                ka.extData.put('18', masterAccountRecord.UM_Legal_Name__c);
            //End - Set Company/Account Name
        }

        ka.mktCode  = 'MASTER ACCOUNT';                 //Required
        ka.extIdList = new List<Map<String, String>>();
        Map<String, String> extMap = new Map<String, String>();
        extMap.put('value', accountId);
        extMap.put('type', '2');

        ka.extIdList.add(extMap);
        return ka;
    }

    public list<KenanAccount> sendKenanAccountHierarchy(String accountId){
        set<string> accountIds = new set<string>();
        list<KenanAccount> kenanAccounts = new list<KenanAccount>();
        List<KenanAccount> accListBack = new List<KenanAccount>();
        KenanConnectorService service = new KenanConnectorService();


        accountIds = getAccountHierarchyList(accountId);
        System.debug('*** accountIds: '+ accountIds);
        if(!accountIds.isEmpty()){
            accountMap = getAccountStructure(accountIds);
            System.debug('*** accountMap: '+ accountMap);
            if(!accountMap.isEmpty()){
                kenanAccounts = getKenanAccountStructure(accountMap);
                System.debug('*** kenanAccountStructure: '+ kenanAccounts);
                if(!kenanAccounts.isEmpty()){
                    accListBack = service.accountHierarchyCreate(kenanAccounts);
                    System.debug('***accListBack: '+accListBack);
                }
            }
        }
        return accListBack;
    }

    private list<KenanAccount> getKenanAccountStructure(map<id,Account> accStructure){
        list<KenanAccount> kenanAccList = new list<KenanAccount>();
        Map<String, Object> fieldsValue;
        Id prevAccountId;

        for(Account acc : accStructure.values()){
            if(acc.LG_ExternalID__c==null){

                fieldsValue = acc.getPopulatedFieldsAsMap();
                KenanAccount kAcc = createKenanAccount(acc.id,fieldsValue,acc.LG_AccountNumber__c);
                if(prevAccountId != null){
                    kAcc.parentAccountExternalId = prevAccountId;
                    kAcc.parentAccountExternalIdType = 2;
                }
                kenanAccList.add(kAcc);
                prevAccountId = acc.id;
            }
            else
                continue;
        }
        return kenanAccList;
    }

    private map<id,Account> getAccountStructure(set<string> accountIds){
        map<id,Account> accMap = new map<id,Account>();

        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.Account.FieldSets.MasterAccount.getFields()){
            query += f.getFieldPath() + ', ';
        }
        query += 'Id,LG_ExternalID__c,LG_AccountNumber__c,UM_Kenan_Sync_Message__c FROM Account where id in :accountIds';

        for(Account acc : Database.query(query)){
            accMap.put(acc.id,acc);
        }
        return accMap;
    }

    private set<string> getAccountHierarchyList(String accountId){
        set<string> accounts = new set<string>();
        String currAcctId;
        boolean isTopLevelAccount=false;
        Account acct;
        accounts.add(accountId);
        currAcctId = accountId;
        while (!isTopLevelAccount) {
            acct = [select Id, Name,
                                     ParentId,
                                     Parent.ParentId,
                                     Parent.Parent.ParentId,
                                     Parent.Parent.Parent.ParentId,
                                     Parent.Parent.Parent.Parent.ParentId From Account where Id = :currAcctId ];

            if (acct.Parent.Parent.Parent.Parent.ParentId != null) {
                accounts.add(acct.ParentId);
                accounts.add(acct.Parent.ParentId);
                accounts.add(acct.Parent.Parent.ParentId);
                accounts.add(acct.Parent.Parent.Parent.ParentId);
                currAcctId = acct.Parent.Parent.Parent.Parent.ParentId;
                accounts.add(currAcctId);
            } else if(acct.Parent.Parent.Parent.ParentId != null){
                accounts.add(acct.ParentId);
                accounts.add(acct.Parent.ParentId);
                accounts.add(acct.Parent.Parent.ParentId);
                currAcctId = acct.Parent.Parent.Parent.ParentId;
                accounts.add(currAcctId);
            } else if(acct.Parent.Parent.ParentId != null){
                accounts.add(acct.ParentId);
                accounts.add(acct.Parent.ParentId);
                currAcctId = acct.Parent.Parent.ParentId;
                accounts.add(currAcctId);
            } else if (acct.Parent.ParentId != null){
                accounts.add(acct.ParentId);
                currAcctId = acct.Parent.ParentId;
                accounts.add(currAcctId);
            } else if (acct.ParentId != null){
                currAcctId = acct.ParentId;
                accounts.add(currAcctId);
            }
            else {
                isTopLevelAccount = true;
            }
        }
        return accounts;
    }

    /**
     * Method to see if an Account or a Billing account is out of date. i.e. LastModifieddate is greater than LastSyncedWithBilling date.
     * Returns true if the account/Billing Account was last modified after the Sync to Kenan.
     * Parameter: Takes AccountId/ BillingAccount Id as parameter
     * @return boolean result
     */

     public  static Boolean isAccountOutOfDate(Id accId){
        String sObjName;
        Boolean result=false;
        if(accId!=null){
            sObjName = accId.getSObjectType().getDescribe().getName();
        }
        Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(sObjName);
        Sobject sObj = sObjType.newSObject();

        if(sObjName!=null){
            string query='select id, UM_LastSyncedwithBilling__c, lastmodifieddate from '+ sObjName+' where Id= \''+accId +'\'  Limit 1 ';
            sObj=Database.query(query);
            if(sObj!=null){
                if((DateTime)sObj.get('lastmodifieddate')> (DateTime)sObj.get('UM_LastSyncedwithBilling__c') || ((DateTime)sObj.get('UM_LastSyncedwithBilling__c')==null)){
                    result=true;
                }
            }
        }
        return result;
     }

    private Date getAccountActivationDate(Id accountId){
        Date activationDate;

        list<csord__Service__c> serviceList = [select id, csord__Activation_Date__c
                                               from csord__service__c
                                               where csord__Subscription__r.csconta__Billing_Account__c =:accountId
                                               and (csord__Status__c = 'Requested' or csord__Status__c='Ready for Billing') and csord__Activation_Date__c!=null
                                               order by csord__Activation_Date__c asc];
        if(serviceList!=null && !serviceList.isEmpty()){
            activationDate = serviceList[0].csord__Activation_Date__c;
        }

        if (activationDate==null || activationDate>Date.today())
            activationDate = Date.Today();
        return activationDate;
    }
    //changed below method as part of BHP-21, bifurcated logic for record types
    public static KenanAccountItem createKenanAccountItemForCreate(UM_BillingAccountItem__c billAccountItem){
        KenanAccountItem item = new KenanAccountItem();
        if(billAccountItem.recordTypeId == discountRecordTypeId )
            item= createDiscountItem(billAccountItem) ; 
        else if(billAccountItem.recordTypeId ==adjustmentRecordTypeId )
            item= createAdjustmentItem(billAccountItem);
        
        return item;
    }
    //added new method for setting values in KenanItem for Discount record type
    private static KenanAccountItem createDiscountItem(UM_BillingAccountItem__c billAccountItem)
    {
        KenanAccountItem item = new KenanAccountItem();

        item.serviceExternalId = billAccountItem.UM_BillingAccount__c;
        item.serviceExternalIdType = 2;

        if(billAccountItem.UM_BillingCode__c!=null)
            item.itemId = Integer.valueOf(billAccountItem.UM_BillingCode__c);
        item.itemType = 2;
        item.discountPercent = billAccountItem.UM_Percentage__c;
        item.currencyCode = UserInfo.getDefaultCurrency();
        item.activeDate = billAccountItem.UM_StartDate__c;
        if(billAccountItem.UM_EndDate__c!=null)
            item.inactiveDate = billAccountItem.UM_EndDate__c;
        else if(billAccountItem.UM_NumberofMonths__c!=null){
            date startDate = billAccountItem.UM_StartDate__c;
            integer noOfMonths = Integer.valueOf(billAccountItem.UM_NumberofMonths__c);
            date endDate = startDate.addMonths(noOfMonths);
            item.inactiveDate = endDate;
        }
        // Add one day and deduct 1 second to get end date with 23:59:59 timestamp.
        item.inactiveDate = item.inactiveDate.addDays(1);
        item.inactiveDate = item.inactiveDate.addSeconds(-1);

        item.extData = new Map<String, String>();
        item.extData.put('17', billAccountItem.name);
        System.debug('*** BillingAccountItem='+item);
        return item;
    }
    //added new method for setting values in KenanItem for Adjustment record type
    private static KenanAccountItem createAdjustmentItem(UM_BillingAccountItem__c billAccountItem)
    {
        system.debug('inside setValues#');
        KenanAccountItem item = new KenanAccountItem();
        item.serviceExternalId = billAccountItem.UM_BillingAccount__c;
        item.serviceExternalIdType = 2;
        item.salesforceId= billAccountItem.id;
        if(billAccountItem.UM_BillingCode__c!=null)
            item.itemId = Integer.valueOf(billAccountItem.UM_BillingCode__c);
        item.itemType = 1;
        item.currencyCode = UserInfo.getDefaultCurrency();
        item.activeDate = billAccountItem.UM_StartDate__c;
        if(billAccountItem.UM_Total_Amount__c < 0)
            item.rate = billAccountItem.UM_Total_Amount__c * -100;
        else     
            item.rate = billAccountItem.UM_Total_Amount__c*100 ;
        system.debug('rate#'+item.rate);
        item.extData = new Map<String,Object>();
        if(billAccountItem.UM_description__c != null )
        {
            String des = billAccountItem.UM_description__c;
            if(billAccountItem.UM_description__c.length()>50)
                des = billAccountItem.UM_description__c.substring(0,50);
            
            item.extData.put('15', des );
        }
        else 
           item.extData.put('15',billAccountItem.UM_NRC_Reason__c );
           
        System.debug('*** AdjustBillingAccountItem='+json.serialize(item));  
          
        return item;
        
    }
    
     /**BU-234**/
     //@InvocableMethod(label='BADeactivationReqToKenan' )
     public static Boolean createCeaseKenanBillinAcc(Id BillingId)
     {
        System.debug('InsideSynMethod1@@'); 
        KenanAccount ka = new KenanAccount();      
        ka.salesforceObjectId = BillingId;
        ka.dateInactive = Date.Today();
        
        system.debug ('Date -->' +(Date.Today()));
        Boolean deacRes;
        try
        {
            billingAcc = [SELECT id, csconta__Status__c, Deactivation_Kenan_response__c, UM_IsDecativateSynced__c FROM csconta__Billing_Account__c
                                                   WHERE Id =: BillingId];
            KenanConnectorService service = new KenanConnectorService();
            deacRes = service.accountCease(ka);
            System.debug('Inside3@@'+deacRes);
            
            if(deacRes == true)
            {
              System.debug('InsideSynMethodIf@@');
            //  billingAcc.UM_IsDecativateSynced__c = true;
              billingAcc.csconta__Status__c ='Deactivation Pending';
              billingAcc.Deactivation_Kenan_response__c = 'Request has been successfully sent to Kenan for Deactivation';
            }
          /*  else{
            System.debug('InsideSynMethodelse@@');
             billingAcc.UM_IsDecativateSynced__c = false;
             billingAcc.Deactivation_Kenan_response__c = 'Request to Kenan failed';
            } */
            update billingAcc; 
            System.debug('end@@@@@');           
        }
       
         catch(exception e)
         {
            System.debug('Error: '+e.getMessage() + 'stack trace:'+ e.getStackTraceString());
           // errorMessage+=' *** MESSAGE *** '+e.getMessage();
            System.debug('Exception@@');
            
            if(billingAcc.Id != Null){
                csconta__Billing_Account__c objBillingAcc = billingAcc;
                objBillingAcc.Deactivation_Kenan_response__c = 'Request to Kenan failed'; 
                update objBillingAcc; 
            }
            
        }
      
        
        return deacRes;
    } 
    
    /**BU-234**/
    webservice static void invokeACAPI(String billingId){
        createCeaseKenanBillinAcc(billingId);
    }
    
    
}