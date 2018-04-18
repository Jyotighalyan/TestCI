
public class LG_Util
{
    /*
     * Standard GUID regex pattern, used by Configurator for temoporary IDs
    */
    private static string GUID {
        get {
            return '([a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-4[a-zA-Z0-9]{3}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12})';
        }
    }

    /*IsValidId
     * Validate standard GUID field
    */
    public static Boolean ValidateGUID(string input) {

        input = checkNull(input);

        return Pattern.matches(GUID, input);
    }

    public static List<String> getAdminEmailAddresses()
    {
        List<String> toAddresses = new List<String>();
        LG_EnvironmentVariables__c EnvSettings = LG_EnvironmentVariables__c.getInstance(UserInfo.getUserId());

        if (EnvSettings==null)
        {
            toAddresses.add('davor.dubokovic@cloudsensesolutions.com');
        }
        else
        {
            if (EnvSettings.LG_Admin_Emails__c=='' || EnvSettings.LG_Admin_Emails__c==null)
            {
                toAddresses.add('davor.dubokovic@cloudsensesolutions.com');
            }
            else
            {
                toAddresses = EnvSettings.LG_Admin_Emails__c.split(',');
            }
        }

        return toAddresses;

    }


    public static void SendAdminEmail(Exception ex, string Place)
    {
        string ErrorMessage='Line Number: ' + ex.getLineNumber() + ' Message: ' + ex.getMessage() +'\n';

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setToAddresses(getAdminEmailAddresses());
        string Subject=Place + ' - Exception!!!';

        mail.setSubject(Subject);
        mail.setPlainTextBody(ErrorMessage);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    public static String getVisualForceBaseUrl()
    {
        String baseUrl = '';

        LG_EnvironmentVariables__c envVariables = LG_EnvironmentVariables__c.getOrgDefaults();
        if (UserInfo.getUserType() == 'Standard')
        {
            if (envVariables != null && String.isNotBlank(envVariables.LG_VisualForceBaseURL__c))
            {
                baseUrl = envVariables.LG_VisualForceBaseURL__c;
            }
        }
         else if (UserInfo.getUserType() == 'PowerPartner')
        {
            if (envVariables != null && String.isNotBlank(envVariables.LG_VisualForcePartnerBaseURL__c))
            {
                baseUrl = envVariables.LG_VisualForcePartnerBaseURL__c;
            }
        }
        return baseUrl;
    }

    public static String getSalesforceBaseUrl()
    {
        String baseUrl = '';

        LG_EnvironmentVariables__c envVariables = LG_EnvironmentVariables__c.getOrgDefaults();

        if (UserInfo.getUserType() == 'Standard')
        {
            if (envVariables != null && String.isNotBlank(envVariables.LG_SalesforceBaseURL__c))
            {
                baseUrl = envVariables.LG_SalesforceBaseURL__c;
            }
        }
        else if (UserInfo.getUserType() == 'PowerPartner')
        {
            if (envVariables != null && String.isNotBlank(envVariables.LG_SalesforcePartnerBaseURL__c))
            {
                baseUrl = envVariables.LG_SalesforcePartnerBaseURL__c;
            }
        }
        return baseUrl;
    }

    public static String getSubscriptionRequestDeactivateStatus()
    {
        String subscriptionDeactivateStatus = '';

        csordtelcoa__Orders_Subscriptions_Options__c osOptions = csordtelcoa__Orders_Subscriptions_Options__c.getOrgDefaults();
        if (osOptions != null && String.isNotBlank(osOptions.LG_SubscriptionRequestDeactivateStatus__c))
        {
            subscriptionDeactivateStatus = osOptions.LG_SubscriptionRequestDeactivateStatus__c;
        }

        return subscriptionDeactivateStatus;
    }

    public static String getServiceRequestDeactivateStatus()
    {
        String serviceDeactivateStatus = '';

        csordtelcoa__Orders_Subscriptions_Options__c osOptions = csordtelcoa__Orders_Subscriptions_Options__c.getOrgDefaults();
        if (osOptions != null && String.isNotBlank(osOptions.LG_ServiceRequestDeactivateStatus__c))
        {
            serviceDeactivateStatus = osOptions.LG_ServiceRequestDeactivateStatus__c;
        }

        return serviceDeactivateStatus;
    }

    public static String getServiceDeactivatedStatus()
    {
        String serviceDeactivatedStatus = '';

        csordtelcoa__Orders_Subscriptions_Options__c osOptions = csordtelcoa__Orders_Subscriptions_Options__c.getOrgDefaults();
        if (osOptions != null && String.isNotBlank(osOptions.LG_ServiceDeactivatedStatus__c))
        {
            serviceDeactivatedStatus = osOptions.LG_ServiceDeactivatedStatus__c;
        }

        return serviceDeactivatedStatus;
    }

    //Returns the List of Statuses not Allowing a Change of the Subscription
    //Read from the Orders & Subscriptions Options custom settings
    public static List<String> getOSStatusesNotAllowingChange()
    {
        List<String> statusesNotAllowingChange = new List<String>();

        csordtelcoa__Orders_Subscriptions_Options__c osOptions = csordtelcoa__Orders_Subscriptions_Options__c.getOrgDefaults();
        if (osOptions != null && String.isNotBlank(osOptions.csordtelcoa__Statuses_Not_Allowing_Change__c))
        {
            for(String status : osOptions.csordtelcoa__Statuses_Not_Allowing_Change__c.split(','))
            {
                statusesNotAllowingChange.add(status);
            }
        }

        return statusesNotAllowingChange;
    }

    //Returns the loookup field Id from the 'New' page of some object.
    //Lookup field Id used for 'Url hacks' to prepopulate a lookup field on the new object
    //page.
    //param page - PageReference object of the new object page
    //param objectPrefix - prefix of the object related to the lookup field we want to populate
    public static String getLookupFieldReferenceId(PageReference page, String objectPrefix)
    {

        //used in unit test
        String testPageContent = '<input type="hidden" id="testId_lktp" value="'+objectPrefix+'"/></tr>';

        String referenceId = 'noId';
        String pageContent = Test.IsRunningTest() ? testPageContent : page.getContent().toString();

        Pattern p = Pattern.compile('<input.+value="' + objectPrefix + '".*/>');


        for (String line : pageContent.split('/tr>'))
        {
            Matcher pm = p.matcher(line);

            if (pm.find())
            {
                for(String str : pm.group(0).split('/>'))
                {
                    if (str.contains('value="' + objectPrefix + '"') && str.contains('_lktp'))
                    {
                        p = Pattern.compile('id=".+_lktp"');
                        pm = p.matcher(str);
                        if (pm.find())
                        {
                            referenceId = pm.group(0).replace('id="', '').replace('_lktp"', '');
                        }
                    }

                }
            }
        }

        return referenceId;
    }

    public static String getSandboxInstanceName()
    {
        String instanceName = '';

        LG_EnvironmentVariables__c envVariables = LG_EnvironmentVariables__c.getOrgDefaults();
        if (envVariables != null && String.isNotBlank(envVariables.LG_SandboxInstance__c))
        {
            instanceName = envVariables.LG_SandboxInstance__c;
        }

        return instanceName;
    }

    /*
     * Validate SalesForce ID or Configurator ID
    */
    public static Boolean IsValidId(String strId) {

        return ((strId InstanceOf ID) || ValidateGUID(strId));
    }

    /*
     * Validate SalesForce ID
    */
    public static Boolean IsValidSFId(String strId) {

        strId = checkNull(strId);

        return ((strId InstanceOf ID) || ValidateGUID(strId));
    }

    /*
     * Validate Configurator ID
    */
    public static Boolean IsValidConfiguratorId(String strId) {

        strId = checkNull(strId);

        return ValidateGUID(strId);
    }

    /*
     * Return empty string if string is null
    */
    public static string checkNull(string input) {
        return String.isBlank(input) ? '' : input;
    }

    /*
     * Return check for null or empty and return padded value (added sufix, prefix)
    */
    public static string checkNullPadded(string input, string prefix, string sufix) {

        string temp = prefix == null ? '' : prefix;
        temp += checkNull(input);
        temp += sufix == null ? '' : sufix;

        if (String.isEmpty(temp)) {
            temp = ' ';
        }

        return temp;
    }

    /*
     * Return empty string if string is null. If not return 15 digit ID
    */
    public static string checkIdNull(string input) {
        return String.isBlank(input) ? '' : input.substring(0, 15);
    }

    /*
     * Return formated address
    */
    public static string getFormattedAddress(string street, string houseNumber, string houseNumberExt, string postcode, string city) {

        // If everything is blank or null return empty string
        if (String.isBlank(street) && String.isBlank(houseNumber) && String.isBlank(houseNumberExt) && String.isBlank(postcode)  && String.isBlank(city)) {
            return '';
        }
        else {

            string first = (checkNull(street) + checkNullPadded(houseNumber, ' ', ' ') + checkNull(houseNumberExt)).trim();
            string second = checkNull(postcode) + checkNullPadded(city, ' ', null);

            return (!String.isBlank(first) && !String.isBlank(second)) ? first + ', ' + second : first + second;
        }
    }

    /*
     * Create new Premisse (Address)
     *
     * Params: cscfga__Product_Basket__c pb
    */
    public static cscrm__Address__c createNewPremise(cscfga__Product_Basket__c pb) {

        cscrm__Address__c a = new cscrm__Address__c();

        a.cscrm__City__c = pb.LG_InstallationCity__c;
        a.cscrm__Country__c = pb.LG_InstallationCountry__c;
        a.LG_HouseNumber__c = pb.LG_InstallationHouseNumber__c;
        a.cscrm__Street__c = pb.LG_InstallationStreet__c;
        a.cscrm__Zip_Postal_Code__c = pb.LG_InstallationPostalCode__c;
        a.LG_HouseNumberExtension__c = pb.LG_InstallationHouseNumberExtension__c;
        a.cscrm__Account__c = pb.csbb__Account__c;
        a.LG_SharedOfficeBuilding__c = pb.LG_SharedOfficeBuilding__c;
        a.LG_COAXConnectionLocation__c = pb.LG_COAXConnectionLocation__c;

        return a;
    }

    /*
     * Create new Premisse (Address)
     *
     * Params: cscfga__Product_Basket__c tmpPB, Opportunity tmpOpportunity
    */
    public static cscrm__Address__c createNewPremise(cscfga__Product_Basket__c pb, Opportunity tmpOpportunity) {

        cscrm__Address__c a = new cscrm__Address__c();

        a.cscrm__City__c = pb.LG_InstallationCity__c;
        a.cscrm__Country__c = pb.LG_InstallationCountry__c;
        a.LG_HouseNumber__c = pb.LG_InstallationHouseNumber__c;
        a.cscrm__Street__c = pb.LG_InstallationStreet__c;
        a.cscrm__Zip_Postal_Code__c = pb.LG_InstallationPostalCode__c;
        a.LG_HouseNumberExtension__c = pb.LG_InstallationHouseNumberExtension__c;
        a.cscrm__Account__c = tmpOpportunity.AccountID;
        a.LG_SharedOfficeBuilding__c = pb.LG_SharedOfficeBuilding__c;
        a.LG_COAXConnectionLocation__c = pb.LG_COAXConnectionLocation__c;

        return a;
    }

    /*
     * Resolves Premisse (Address) data and upserts. Insert where it is a new record or updates if it is an old one
    */
    public static void resolveAndUpsertPremiseDuplicates(List<cscrm__Address__c> addresses) {

        if (!addresses.isEmpty()) {

            Set<String> uniqueKeys = new Set<String>();

            // Generate unique keyset
            for (cscrm__Address__c a :addresses) {
                uniqueKeys.add(LG_Util.checkIdNull(a.cscrm__Account__c) + LG_Util.checkNull(a.cscrm__Zip_Postal_Code__c) + LG_Util.checkNull(a.LG_HouseNumber__c) + LG_Util.checkNull(a.LG_HouseNumberExtension__c));
            }

            // Retrieve addresses by uniqueKeys
            List<cscrm__Address__c> addressesByUnique = [SELECT Id, LG_Uniquekey__c, LG_UniqueKeyForm__c FROM cscrm__Address__c WHERE LG_UniqueKeyForm__c IN :uniqueKeys];

            for (cscrm__Address__c a :addresses) {

                string unique = LG_Util.checkIdNull(a.cscrm__Account__c) + LG_Util.checkNull(a.cscrm__Zip_Postal_Code__c) + LG_Util.checkNull(a.LG_HouseNumber__c) + LG_Util.checkNull(a.LG_HouseNumberExtension__c);

                // If there is a match update ID field on addresses list
                for (cscrm__Address__c au :addressesByUnique) {
                    if (au.LG_Uniquekey__c == unique || au.LG_UniqueKeyForm__c == unique) {
                        a.Id = au.Id;
                    }
                }
            }

            upsert addresses;
        }
    }

    /*
     * Returns the count of Active Batch Jobs for the supplied className.
    */
    public static Integer activeBatchJobs(string className)
    {
        ApexClass[] jobClasses =
                [ SELECT Id, Name
                  FROM ApexClass
                  WHERE Name = :className];
        ApexClass jobClass;
        if (!jobClasses.isEmpty())
        {
            jobClass = jobClasses[0];
        }
        else
        {
            return -1;
        }

        Integer jobCount =
                [ SELECT COUNT()
                  FROM AsyncApexJob
                  WHERE Status NOT IN ('Aborted', 'Completed', 'Failed')
                  AND ApexClassId = :jobClass.Id ];
        return jobCount;
    }

    /*
    * Returns true if a change type has Valid Related Products set to true
    *
    * @param  String changeTypeName
    * @author Tomislav Blazek
    * @since  21/9/2016
    */
    public static boolean shouldValidRelProductsByChangeType(String changeTypeName)
    {
        boolean shouldValidate = false;

        for (csordtelcoa__Change_Types__c changeType : csordtelcoa__Change_Types__c.getAll().values())
        {
            if (changeType.Name == changeTypeName && changeType.ValidRelatedProducts__c)
            {
                shouldValidate = true;
                break;
            }
        }

        return shouldValidate;
    }

    /*
    * Inserts and returns the Macd Opportunity
    *
    * @param  String changeTypeName
    * @param  Account account (must have a name queried)
    * @author Tomislav Blazek
    * @since  21/9/2016
    */
    public static Opportunity createMacdOpportunity(String changeTypeName, Account account)
    {
        csordtelcoa__Orders_Subscriptions_Options__c osOptions = csordtelcoa__Orders_Subscriptions_Options__c.getInstance(UserInfo.getUserId());

        String oppInitialStage = '';

        if (osOptions != null && String.isNotBlank(osOptions.csordtelcoa__Initial_Mac_Opportunity_Stage__c))
        {
            oppInitialStage = osOptions.csordtelcoa__Initial_Mac_Opportunity_Stage__c;
        }

        Opportunity opp = new Opportunity();
        opp.AccountId = account.Id;
        opp.csordtelcoa__Change_Type__c = changeTypeName;
        opp.CloseDate = Date.today();
        opp.StageName = oppInitialStage;
        opp.Name = account.Name + ' - ' + opp.CloseDate.month() + '/' + opp.CloseDate.year();
        insert opp;

        return opp;
    }

    public static String getSubscriptionClosedReplacedStatus() {
        String subscriptionClosedReplacedStatus = '';

        csordtelcoa__Orders_Subscriptions_Options__c osOptions = csordtelcoa__Orders_Subscriptions_Options__c.getOrgDefaults();
        if (osOptions != null && String.isNotBlank(osOptions.csordtelcoa__Subscription_Closed_Replaced_State__c)) {
            subscriptionClosedReplacedStatus = osOptions.csordtelcoa__Subscription_Closed_Replaced_State__c;
        }

        return subscriptionClosedReplacedStatus;
    }

    /*
     * Create new Billign Account
     *
     * Params: cscfga__Product_Basket__c tmpPB, Opportunity tmpOpportunity
    */
    public static csconta__Billing_Account__c createNewBillingAccount(cscfga__Product_Basket__c tmpPB, Opportunity tmpOpportunity) {

        csconta__Billing_Account__c a = new csconta__Billing_Account__c();

        a.csconta__City__c = tmpPB.LG_BillingSameAsInstallationAddress__c ? tmpPB.LG_InstallationCity__c : tmpPB.LG_BillingCity__c;
        a.csconta__Country__c = tmpPB.LG_BillingSameAsInstallationAddress__c ? tmpPB.LG_InstallationCountry__c : tmpPB.LG_BillingCountry__c;
        a.LG_HouseNumber__c = tmpPB.LG_BillingSameAsInstallationAddress__c ? tmpPB.LG_InstallationHouseNumber__c : tmpPB.LG_BillingHouseNumber__c;
        a.csconta__Street__c = tmpPB.LG_BillingSameAsInstallationAddress__c ? tmpPB.LG_InstallationStreet__c : tmpPB.LG_BillingStreet__c;
        a.csconta__PostCode__c = tmpPB.LG_BillingSameAsInstallationAddress__c ? tmpPB.LG_InstallationPostalCode__c : tmpPB.LG_BillingPostalCode__c;
        a.LG_HouseNumberExtension__c = tmpPB.LG_BillingSameAsInstallationAddress__c ? tmpPB.LG_InstallationHouseNumberExtension__c : tmpPB.LG_BillingHouseNumberExtension__c;
        a.csconta__Account__c = tmpOpportunity.AccountID;
        a.LG_CustomerReference__c = tmpPB.LG_CustomerReference__c;
        a.LG_PaymentType__c = tmpPB.LG_PaymentType__c;
        a.LG_BankAccountHolder__c = tmpPB.LG_BankAccountName__c;
        a.LG_BankAccountNumberIBAN__c = tmpPB.LG_BankNumber__c;

        if (String.isNotBlank(tmpPB.LG_BillingEmailAddress__c)) {
            a.LG_BillingEmailAddress__c = tmpPB.LG_BillingEmailAddress__c;
        } else {
            a.LG_BillingEmailAddress__c = tmpPB.LG_AdminContactEmail__c;
        }

        return a;
    }

    /*
     * Resolves Premisse (Address) data and insert. Insert where it is a new record
    */
    public static void resolveAndInsertPremiseDuplicates(List<cscrm__Address__c> addresses) {

        if (!addresses.isEmpty()) {

            List<cscrm__Address__c> newAddresses = new List<cscrm__Address__c>();

            Set<String> uniqueKeys = new Set<String>();

            // Generate unique keyset
            for (cscrm__Address__c a : addresses) {
                uniqueKeys.add(LG_Util.checkIdNull(a.cscrm__Account__c) + LG_Util.checkNull(a.cscrm__Zip_Postal_Code__c) + LG_Util.checkNull(a.LG_HouseNumber__c) + LG_Util.checkNull(a.LG_HouseNumberExtension__c));
            }

            // Retrieve addresses by uniqueKeys
            List<cscrm__Address__c> addressesByUnique = [SELECT Id, LG_Uniquekey__c, LG_UniqueKeyForm__c FROM cscrm__Address__c WHERE LG_UniqueKeyForm__c IN :uniqueKeys];

            for (cscrm__Address__c a : addresses) {

                string unique = LG_Util.checkIdNull(a.cscrm__Account__c) + LG_Util.checkNull(a.cscrm__Zip_Postal_Code__c) + LG_Util.checkNull(a.LG_HouseNumber__c) + LG_Util.checkNull(a.LG_HouseNumberExtension__c);

                // If there is a match update ID field on addresses list
                for (cscrm__Address__c au : addressesByUnique) {
                    if (au.LG_Uniquekey__c == unique || au.LG_UniqueKeyForm__c == unique) {
                        a.Id = au.Id;
                        break;
                    }
                }

                // After all uniques are checked and there is no Id we have a new record
                if (String.isBlank(a.Id)) {
                    newAddresses.add(a);
                }
            }

            if (!newAddresses.isEmpty()) {
                insert newAddresses;
            }
        }
    }

    /*
     * Create Task with insert option
     *
     * @param subject
     * @param taskType
     * @param result
     * @param ownerId
     * @param taskDate
     * @param status
     * @param priority
     * @param whatId
     * @param insertImmediately
     *
     * @author Petar Miletic
     * @ticket SFDT-902
    */
    public static Task createTask(string subject, string taskType, string result, Id ownerId, Date taskDate, string status, string priority, Id whatId, Boolean insertImmediately) {

        Task t = new Task();

        t.Subject = subject;
        t.Type = taskType;
        t.LG_Result__c = result;
        t.OwnerId = ownerId;
        t.ActivityDate = taskDate == null ? date.today() : taskDate;
        t.Status = status;
        t.Priority = priority;
        t.WhatId = whatId;

        if (insertImmediately) {
            insert t;
        }

        return t;
    }

    /*
     * Generate random number string
    */
    public static String generateRandomNumberString(Integer len) {

        final String chars = '012345678998746546849684984356367598435131321654987';
        String randString = '';

        while (randString.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randString += chars.substring(idx, idx + 1);
        }

        return randString;
    }

     /*
     * Generates GUID string
    */
    public static String generateGUID() {

        String newGUID = String.format('{0}-{1}-4{2}-{3}-{4}', new List<String> {
                                    LG_Util.generateRandomCharacterString(8),
                                    LG_Util.generateRandomCharacterString(4),
                                    LG_Util.generateRandomCharacterString(3),
                                    LG_Util.generateRandomCharacterString(4),
                                    LG_Util.generateRandomCharacterString(12)
                                    });

        if (!ValidateGUID(newGUID)) {
            throw new LG_Exception('Invalid GUID generation)');
        }

        return newGUID;
    }
       /*
     * Generate random character string
    */
    public static String generateRandomCharacterString(Integer len) {

        final String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        String randString = '';

        while (randString.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randString += chars.substring(idx, idx + 1);
        }

        return randString;
    }


    /**
     * Returns the Logged In User Sales Channel
     */
    public static String getCurrentUserSalesChannel()
    {
        Id currentUserId = UserInfo.getUserId();

        User currentUser = [SELECT Id, LG_SalesChannel__c
                            FROM User WHERE Id = :currentUserId];

        return currentUser.LG_SalesChannel__c;
    }

    /**
     * Returns a list of Sales Channels eligible for initiating
     * the Terminate MACD process
     */
    public static List<String> getSalesChannelsForTerminate()
    {
        List<String> salesChannelList = new List<String>();

        LG_MACDSpecificVariables__c macdSpecifics = LG_MACDSpecificVariables__c.getInstance(UserInfo.getUserId());

        if (macdSpecifics != null && String.isNotBlank(macdSpecifics.LG_SalesChannelsAllowedForTerminate__c))
        {
            for (String salesChannel : macdSpecifics.LG_SalesChannelsAllowedForTerminate__c.split(','))
            {
                salesChannelList.add(salesChannel);
            }
        }

        return salesChannelList;
    }

     // formats the date in the dd-mm-yyyy format
    public static String getFormattedDate(Date value)
    {
        String formattedDate = '';

        if (value != null)
        {
            formattedDate = value.day() + '-' + value.month() + '-' + value.year();
        }

        return formattedDate;
    }

    public static String trimAll(String inputString) {

        if (inputString == null) {
            return '';
        }

        return inputString.replaceAll( '\\s+', '');
    }

    /*
    Returns a set of values from a comma separated list.
    Used to extract values from custom settings
    */
    public static Set<String> commaSeparatedStringToSet(String commaSeparatedString)
    {
        Set<String> retSet = new Set<String>();
        if (String.isNotBlank(commaSeparatedString))
        {
            for (String str : commaSeparatedString.split(','))
            {
                retSet.add(str);
            }
        }
        return retSet;
    }

    /*
    Returns a set of values from a semicolon separated list.
    */
    public static Set<String> semicolonSeparatedStringToSet(String semicolonSeparatedString)
    {
        Set<String> retSet = new Set<String>();
        if (String.isNotBlank(semicolonSeparatedString))
        {
            for (String str : semicolonSeparatedString.split(';'))
            {
                retSet.add(str);
            }
        }
        return retSet;
    }

    /**
     * Build screen flow name
     *
     * @param caseRecordType - case record type
     * @param productDefinitionName - product definition name
     *
     * @author Petar Miletic
     * @story SFOM-412
     * @since 15/02/2017
    */
    public static String getScreenFlowFullName(String caseRecordType, String productDefinitionName) {

        // If either is empty just return
        if (String.isEmpty(caseRecordType) || String.isEmpty(productDefinitionName)) {
            return '';
        }

        return '&returl=/apex/c__LG_SconsoleCloseTab&ScreenFlowName=' + caseRecordType + ' - ' + productDefinitionName;
    }

    /**
     * Sort list of objects by values matched in the query
     *
     * @param objects - list of objects
     * @param keyValueDictionary - attribute name, value used for matching
     * @param descending - in reverse or not
     *
     * @author Petar Miletic
     * @story SFOM-623
     * @since 20/04/2017
    */
    public static List<sObject> sortObjectList(List<sObject> objects, Map<String, String> keyValueDictionary, Boolean descending) {

        Map<Integer, List<sObject>> tmpMap = new Map<Integer, List<sObject>>();

        for (sObject obj :objects) {

            Integer weight = 0;

            // Calculate weight
            for (String key :keyValueDictionary.keySet()) {


                String keyString = '' + String.valueOf(obj.get(key)) + '';
                String valueString = '' + keyValueDictionary.get(key) + '';

                if (obj.get(key) == keyValueDictionary.get(key) || keyString.containsIgnoreCase(valueString)) {
                    weight += 5;
                }
            }

            List<sObject> objs = null;

            // Add to sorted list
            if (tmpMap.containsKey(weight)) {

                objs = tmpMap.get(weight);
                objs.add(obj);
            } else {

                objs = new List<sObject>();
                objs.add(obj);

                tmpMap.put(weight, objs);
            }
        }

        Set<Integer> keys = tmpMap.keySet();
        List<Integer> sortedKeys = new List<Integer>(keys);
        sortedKeys.sort();

        List<sObject> completedAndSorted = new List<sObject>();

        if (descending) {

            for (Integer i = sortedKeys.size() - 1; i >= 0; i--) {

                completedAndSorted.addAll(tmpMap.get(sortedKeys[i]));
            }

        } else {

            for (Integer i = 0; i < sortedKeys.size(); i++) {

                completedAndSorted.addAll(tmpMap.get(sortedKeys[i]));
            }
        }

        return completedAndSorted;
    }

    public static Set<String> getMigrateVarietyChangeTypes() {
    	Set<String> migrateVarieties = new Set<String>();

    	for (csordtelcoa__Change_Types__c changeType : csordtelcoa__Change_Types__c.getAll().values()) {
    		if (changeType.LG_MigrateVariety__c) {
    			migrateVarieties.add(changeType.Name);
    		}
    	}

    	return migrateVarieties;
    }
    //BHP-16
    //Return List of subscriptions valid for terminate MACD for Virtual Phone Products
    public static Map<Id,List<csord__Subscription__c>> getRelatedEntryServicesForVPKundensetupAccount(Set<Id> VPkundenSetupIdSet) {
        UM_VMStagingDAO dao=new UM_VMStagingDAO();
        List<csord__Subscription__c> kundenSetupVP= [SELECT Id, Name, csord__Account__c                                                   
                                                 FROM csord__Subscription__c
                                                 WHERE Id IN : VPkundenSetupIdSet
                                                 AND csord__Status__c NOT IN :LG_Util.getOSStatusesNotAllowingChange()
                                                                           AND csordtelcoa__Closed_Replaced__c = false
                                                                                                                 AND LG_Address__c != null];
                                                                                                                 
        
        Map<Id,List<csord__Subscription__c>> accountIdEntryLevelsubsVPMap=new Map<Id,List<csord__Subscription__c>>();
        Set<ID> accountIdSet=new Set<ID>();
        if(!kundenSetupVP.isEmpty() || kundenSetupVP!=null){
            for(csord__Subscription__c subs : kundenSetupVP)
                accountIdSet.add(subs.csord__Account__c);
        }
        system.debug('shubha'+accountIdSet);
        if(!accountIdSet.isEmpty() || accountIdSet!=null){
            List<csord__Subscription__c> allVPRelatedSubs=[SELECT Id, Name, csord__Account__c,
                                                  (SELECT Id,
                                                     Name, csord__Service__c, csord__Service__r.LG_ProvisioningSystem__c,csordtelcoa__Service_Number__c,csord__Subscription__c,
                                                     LG_MarketSegment__c,LG_ProvisioningSystem__c,
                                                      csordtelcoa__Product_Configuration__c,
                                                     csordtelcoa__Product_Configuration__r.LG_InstallationWishDate__c,
                                                  csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__c,
                                                  csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.LG_Discontinued__c
                                                  FROM csord__Services__r)
                                                 FROM csord__Subscription__c
                                                 WHERE csord__Account__c IN : accountIdSet
                                                 AND Name ='Virtual Phone Dienste'
                                                 AND csord__Status__c  = 'Active'
                                                                           AND csordtelcoa__Closed_Replaced__c = false
                                                                           AND LG_Address__c != null
                                                                           ORDER BY CreatedDate DESC];
             System.debug('shubha'+allVPRelatedSubs);
             for(csord__Subscription__c subVp : allVPRelatedSubs)  
             {
                 if(!subVp.csord__Services__r.isEmpty())
                 {
                     for(csord__Service__c service : subVp.csord__Services__r)
                     {
                       if(service.LG_MarketSegment__c != 'Soho' && ( service.csordtelcoa__Product_Configuration__c != null && service.csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__c != null))
                       {
                        if(accountIdEntryLevelsubsVPMap.containsKey(subVp.csord__Account__c)){
                            list<csord__Subscription__c > subList= accountIdEntryLevelsubsVPMap.get(subVp.csord__Account__c);
                            subList.add(subVp);
                            accountIdEntryLevelsubsVPMap.put(subVp.csord__Account__c,subList);
                        }
                        else{
                                list<csord__Subscription__c > subList=new list<csord__Subscription__c >();
                                subList.add(subVp);
                                accountIdEntryLevelsubsVPMap.put(subVp.csord__Account__c,subList);
                            } 
                        }
                      }
                   }
              }                                                         
        }
        system.debug('shubha'+accountIdEntryLevelsubsVPMap);
    return accountIdEntryLevelsubsVPMap;                                                                                                         
    }
}
