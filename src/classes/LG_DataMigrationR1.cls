global class LG_DataMigrationR1 implements Database.Batchable<sObject>
{
    global final String Query;
    global LG_DataMigrationR1(String whereCond)
    {
        Query='Select LG_PostalStreet__c,LG_PostalCode__c,LG_PostalHouseNumberExtension__c,LG_PostalHouseNumber__c,LG_PostalCountry__c,LG_PostalCity__c,AccountID,LG_InstallationCity__c,LG_COAXConnectionLocation__c,LG_InstallationCountry__c,'+
        'LG_InstallationHouseNumber__c,LG_InstallationHouseNumberExtension__c,LG_SharedOfficeBuilding__c,LG_InstallationStreet__c,'+
        'LG_BillingPostalCode__c,LG_BankAccountName__c,LG_BankNumber__c,LG_BillingCity__c,LG_BillingCountry__c,'+
        'LG_BillingStreet__c,LG_CustomerReference__c,'+
        'LG_PaymentType__c,LG_PreferredInstallationDate__c, (Select Name from OpportunityLineItems),'+
        '(SELECT Contact.Email FROM OpportunityContactRoles WHERE Role = \'Administrative Contact\' AND Contact.Email != null limit 1),'+
        'csordtelcoa__Change_Type__c,LG_InstallationPostalCode__c  from Opportunity' + ' where ID = \'00624000008UzROAA0\'' + whereCond;
    }
 
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC,List<Sobject> scope)
    {
        /* Code to migrate all the information related to Billing Account, Premise, and Premise information from Opportunity to related object
            Mapping information available in JIRA - 
        */

        List <Account> listAccount4Update = new list<Account>();
        //List <cscrm__Address__c> listAddress4Update = new list<cscrm__Address__c>();
        List <csconta__Billing_Account__c> listBillingAccount4Update = new list<csconta__Billing_Account__c>();
        List <Opportunity> listOpportunity4Update = new list<Opportunity>();
        Set <String> setAddressUniqueKey = new Set<String>();
        Set <String> setBillingUniqueKey = new Set<String>();
        Map <ID, Account> mapAccountPostAdd = new Map <ID, Account>();
        Map <ID, cscrm__Address__c> mapOppIDPremiseID = new Map<ID, cscrm__Address__c>();
        cscrm__Address__c tempAdd = new cscrm__Address__c();
        Account newPostAdd;



        for(Sobject loopVar : scope)
        {
            if(!setAddressUniqueKey.contains((String)loopVar.get('AccountID') + (String)loopVar.get('LG_InstallationPostalCode__c')+(String)loopVar.get('LG_InstallationHouseNumber__c')+(String)loopVar.get('LG_InstallationHouseNumberExtension__c'))) {
                tempAdd = new cscrm__Address__c(
                cscrm__Account__c = (ID)loopVar.get('AccountID'),
                cscrm__City__c = (String)loopVar.get('LG_InstallationCity__c'),
                LG_COAXConnectionLocation__c = (String)loopVar.get('LG_COAXConnectionLocation__c'),
                cscrm__Country__c = (String)loopVar.get('LG_InstallationCountry__c'),
                LG_HouseNumber__c = (String)loopVar.get('LG_InstallationHouseNumber__c'),
                LG_HouseNumberExtension__c = (String)loopVar.get('LG_InstallationHouseNumberExtension__c'),
                LG_SharedOfficeBuilding__c = (Boolean)loopVar.get('LG_SharedOfficeBuilding__c'),
                cscrm__Street__c = (String)loopVar.get('LG_InstallationStreet__c'),
                cscrm__Zip_Postal_Code__c = (String)loopVar.get('LG_InstallationPostalCode__c'));

                setAddressUniqueKey.add((String)loopVar.get('AccountID') +(String)loopVar.get('LG_InstallationPostalCode__c')+(String)loopVar.get('LG_InstallationHouseNumber__c')+(String)loopVar.get('LG_InstallationHouseNumberExtension__c'));
                //listAddress4Update.add(tempAdd);
                mapOppIDPremiseID.put(loopVar.ID,tempAdd);
            }
            

            if(!setBillingUniqueKey.contains((String)loopVar.get('AccountID') + (String)loopVar.get('LG_BankAccountName__c'))) {
                listBillingAccount4Update.add(new csconta__Billing_Account__c(
                csconta__Account__c = (ID)loopVar.get('AccountID'),
                LG_BankAccountHolder__c = (String)loopVar.get('LG_BankAccountName__c'),
                LG_BankAccountNumberIBAN__c = (String)loopVar.get('LG_BankNumber__c'),
                csconta__City__c = (String)loopVar.get('LG_BillingCity__c'),
                csconta__Country__c = (String)loopVar.get('LG_BillingCountry__c'),
                csconta__Postcode__c = (String)loopVar.get('LG_BillingPostalCode__c'),
                csconta__Street__c = (String)loopVar.get('LG_BillingStreet__c'),
                LG_CustomerReference__c = (String)loopVar.get('LG_CustomerReference__c'),
                LG_HouseNumber__c = (String)loopVar.get('LG_InstallationHouseNumber__c'),
                LG_HouseNumberExtension__c = (String)loopVar.get('LG_InstallationHouseNumberExtension__c'),
                LG_BillingEmailAddress__c= ((Opportunity)loopVar).OpportunityContactRoles.size() > 0 ?((Opportunity)loopVar).OpportunityContactRoles[0].Contact.email : '',
                LG_PaymentType__c = (String)loopVar.get('LG_PaymentType__c')));
                setAddressUniqueKey.add((String)loopVar.get('AccountID') + (String)loopVar.get('LG_BankAccountName__c'));
            }

            newPostAdd = new Account( ID = (ID)loopVar.get('AccountID'),
                LG_PostalCity__c = (String)loopVar.get('LG_PostalCity__c'),
                LG_PostalCountry__c = (String)loopVar.get('LG_PostalCountry__c'),
                LG_PostalHouseNumber__c = (String)loopVar.get('LG_PostalHouseNumber__c'),
                LG_PostalHouseNumberExtension__c = (String)loopVar.get('LG_PostalHouseNumberExtension__c'),
                LG_PostalPostalCode__c = (String)loopVar.get('LG_PostalCode__c'),
                LG_PostalStreet__c = (String)loopVar.get('LG_PostalStreet__c')
                );

            if(!mapAccountPostAdd.keyset().contains((ID)loopVar.get('AccountID'))) {
                mapAccountPostAdd.put((ID)loopVar.get('AccountID'),  newPostAdd);
            }
        }
        
        if((mapOppIDPremiseID.values()).size() > 0)
            Database.insert(mapOppIDPremiseID.values() , false);
            //Database.insert(listAddress4Update , true);
        if(listBillingAccount4Update.size() >0)
            Database.insert(listBillingAccount4Update , false);
        if(mapAccountPostAdd.values().size() > 0)
            Database.update(mapAccountPostAdd.values() , false);

        

        /* Updating Opportunities related to SOHO opportunities */

        set<ID> setOppID = new set<ID>();

        for(sObject loopVar : scope) {
            for(OpportunityLineItem loopVarOLI: ((Opportunity)loopVar).OpportunityLineItems) {
                if(loopVarOLI.Name.contains('ZZP'))
                    setOppID.add(loopVar.ID);
            }
        }

        Set<ID> baskedIDs = new Set<ID>();
        Set<ID> productConfigurationIDs = new Set<ID>();
        
        List<csbb__Product_Configuration_Request__c> newPCRs = new List<csbb__Product_Configuration_Request__c>();


        
        Map<Id, cscfga__Product_Configuration__c> pclMap = new Map<Id, cscfga__Product_Configuration__c>([SELECT Id, Name, cscfga__Product_Basket__c,cscfga__Product_Basket__r.cscfga__Opportunity__c , cscfga__Product_Basket__r.LG_CreatedFrom__c, cscfga__Product_Definition__r.cscfga__Product_Category__c FROM cscfga__Product_Configuration__c WHERE cscfga__Product_Basket__r.cscfga__Opportunity__c IN :setOppID AND cscfga__Parent_Configuration__c = NULL]);
        Map<Id, csbb__Product_Configuration_Request__c> pcrMap = new Map<Id, csbb__Product_Configuration_Request__c>([SELECT Id, Name, csbb__Product_Basket__c, csbb__Product_Configuration__c FROM csbb__Product_Configuration_Request__c WHERE csbb__Product_Basket__r.cscfga__Opportunity__c IN :setOppID AND csbb__Product_Configuration__c IN :pclMap.keySet()]);

        // Create set of current Product Configurations that have PCR's
        for (csbb__Product_Configuration_Request__c pcr :pcrMap.values()) {
            productConfigurationIDs.add(pcr.csbb__Product_Configuration__c);
        }

        
        System.debug('+++plcMap: ' + pclMap.size() + ', pcrMap: ' + pcrMap.size());

        // Check if Product Configuration Request exists for Product Configuration
        if (pclMap.size() != pcrMap.size() && pcrMap.size() == 0) {

            for (ID i :baskedIDs) {

                // Get subsets of data
                List<cscfga__Product_Configuration__c> pcByBasket = getProductConfigurationByBasketID(i, pclMap);

                for (cscfga__Product_Configuration__c productConfig :pcByBasket) {

                    /*if (productConfig.cscfga__Product_Basket__r.LG_CreatedFrom__c != 'Tablet') {
                        continue;
                    }*/

                    if (!productConfigurationIDs.contains(productConfig.Id)) {
                        
                        // Create list of Product Configurations that do not have Product Configuration Request
                        csbb__Product_Configuration_Request__c r = new csbb__Product_Configuration_Request__c();
                        
                        r.csbb__Product_Basket__c = i;
                        r.csbb__Product_Configuration__c = productConfig.Id;
                        r.csbb__Product_Category__c = productConfig.cscfga__Product_Definition__r.cscfga__Product_Category__c;
                        // csbb__Status__c
                        
                        // Method is not Global and currently there is no scheduled date to make it 
                        // Global or move it in another package. Idea is to move it from CSTELCOBB to CSBB
                        // cstelcobb.BasketBuilderApi.calculatePCRCharges(r, pcByBasket);
                        LG_ProductConfigurationTriggerHandler.calculatePCRCharges(r, pcByBasket);

                        newPCRs.add(r);
                    }
                }
            }

            if (newPCRs.size() > 0) {
                insert newPCRs; 
            }

        // Map data to relevant field

        }


        for(cscfga__Product_Configuration__c loopVar : pclMap.values()) {
            try{
                loopVar.LG_Address__c = (mapOppIDPremiseID.get(loopVar.cscfga__Product_Basket__r.cscfga__Opportunity__c)).ID;
            } catch(Exception e) {
            }
        }

        if(pclMap.values().size() > 0) {
            List<Database.SaveResult> SR = Database.update(pclMap.values() , false);
            system.debug('Save Result is ' + SR);
        }
         
    }

    private static List<cscfga__Product_Configuration__c> getProductConfigurationByBasketID(ID basketID, Map<Id, cscfga__Product_Configuration__c> productConfigurations) {
        
        List<cscfga__Product_Configuration__c> tmp = new List<cscfga__Product_Configuration__c>();
        
        for (cscfga__Product_Configuration__c pc :productConfigurations.values()) {
            
            if (pc.cscfga__Product_Basket__c == basketID) {
                tmp.add(pc);
            }
        }
        
        return tmp;
    }
 
    global void finish(Database.BatchableContext BC)
    {
        //Send an email to the User after your batch completes
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'vishal.kashyap@accenture.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Apex Batch Job is done');
        mail.setPlainTextBody('The batch Apex job processed ');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}