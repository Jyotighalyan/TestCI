public class LG_AttributeTriggerHandler {

    public static void AfterUpdateHandle(List<cscfga__Attribute__c> lstAttributeNew, map<id,cscfga__Attribute__c> attributeOldMap) {

        if (LG_CheckRecursive.runPBOnceInsert()) {
            UnSyncProductBasketAfterAttributeInsertUpdate(lstAttributeNew, attributeOldMap.values());
        }
      }

    public static void AfterInsertHandle(List<cscfga__Attribute__c> lstAttributeNew) {

        if (LG_CheckRecursive.runPBOnceDelete()) {
            UnSyncProductBasketAfterAttributeInsertUpdate(lstAttributeNew, null);
        }

        SyncProdutBasketsFromTabletAfterInsert(lstAttributeNew);
      }

    private static void StartCongaWFAfterInsertFromTablet(List<cscfga__Attribute__c> lstAttributeNew) {
        //System.debug('***lstAttributeNew=' + lstAttributeNew);

        Set<string> setPCId = new Set<string>();

        for (integer i = 0; i < lstAttributeNew.size(); ++i) {
            setPCId.add(lstAttributeNew[i].cscfga__Product_Configuration__c);
        }

        //System.debug('***setPCId=' + setPCId);

        if (setPCId.size() > 0) {
            List<cscfga__Product_Configuration__c> lstPC = [SELECT cscfga__Product_Basket__c, cscfga__Product_Basket__r.LG_CreatedFrom__c, Id,
                                                   cscfga__Product_Basket__r.cscfga__Opportunity__c
                                                   FROM cscfga__Product_Configuration__c
                                                   WHERE cscfga__Product_Basket__r.LG_CreatedFrom__c = 'Tablet' and Id in : setPCId];

            //System.debug('***lstPC=' + lstPC);

            if (lstPC.size() > 0) {
                Set<string> setOppId = new Set<string>();
                for (cscfga__Product_Configuration__c tmpPC : lstPC) {
                    setOppId.add(tmpPC.cscfga__Product_Basket__r.cscfga__Opportunity__c);
                }

                //System.debug('***setOppId=' + setOppId);

                if (setOppId.size() > 0) {
                    List<Opportunity> lstOpportunity = [SELECT Id, LG_AutomatedQuoteDelivery__c, StageName FROM Opportunity WHERE Id in : setOppId];

                    List<Opportunity> lstOpportunityUpdate = new List<Opportunity>();

                    for (Opportunity tmpOpportunity : lstOpportunity) {
                        if (tmpOpportunity.StageName == 'Awareness of interest') {
                            tmpOpportunity.LG_AutomatedQuoteDelivery__c = 'Quote Requested';
                            lstOpportunityUpdate.add(tmpOpportunity);
                        }
                    }

                    if (lstOpportunityUpdate.size() > 0) update lstOpportunityUpdate;

                }
            }
        }
    }

    private static void SyncProdutBasketsFromTabletAfterInsert(List<cscfga__Attribute__c> lstAttributeNew) {
        Set<string> setPCId = new Set<string>();

        for (integer i = 0; i < lstAttributeNew.size(); ++i) {
            setPCId.add(lstAttributeNew[i].cscfga__Product_Configuration__c);
        }

        //System.debug('***setPCId=' + setPCId);

        if (setPCId.size() > 0) {
            List<cscfga__Product_Configuration__c> lstPC = [SELECT cscfga__Product_Basket__c, cscfga__Product_Basket__r.LG_CreatedFrom__c, Id
                    FROM cscfga__Product_Configuration__c
                    WHERE cscfga__Product_Basket__r.LG_CreatedFrom__c = 'Tablet' and Id in : setPCId];

            //System.debug('***lstPC=' + lstPC);

            Set<string> setPBId = new Set<string>();

            for (cscfga__Product_Configuration__c tmpPC : lstPC) {
                setPBId.add(tmpPC.cscfga__Product_Basket__c);
            }

            //System.debug('***setPBId=' + setPBId);

            if (setPBId.size() > 0) {
                List<cscfga__Product_Basket__c> lstPB = [SELECT Id, csordtelcoa__Synchronised_with_Opportunity__c, Lead__c, csbb__Account__c, cfgoffline__Account__c, cscfga__Opportunity__c
                                                        FROM cscfga__Product_Basket__c
                                                        WHERE Id in : setPBId];

                //System.debug('***before lstPB=' + lstPB);

                //map <string,string> mapLeadIdPBId = new map <string,string>();
                Map<Id, Id> mapLeadIdPBId = new Map<Id, Id>();
                Map<string, string> mapPBIdAccountId = new Map<string, string>();

                for (cscfga__Product_Basket__c tmpPB : lstPB) {

                    if ((tmpPB.Lead__c != null) && (tmpPB.cscfga__Opportunity__c == null)) {
                        mapLeadIdPBId.put(tmpPB.Lead__c, tmpPB.Id);
                    } else if ((tmpPB.csbb__Account__c != null) && (tmpPB.cscfga__Opportunity__c == null)) {
                        mapPBIdAccountId.put(tmpPB.Id, tmpPB.csbb__Account__c);
                    } else if ((tmpPB.cfgoffline__Account__c != null) && (tmpPB.cscfga__Opportunity__c == null)) {
                        mapPBIdAccountId.put(tmpPB.Id, tmpPB.cfgoffline__Account__c);
                    }
                }

                //System.debug('***mapLeadIdPBId=' + mapLeadIdPBId);
                //System.debug('***mapPBIdAccountId=' + mapPBIdAccountId);

                //if (mapLeadIdPBId.size()>0)
                //  LeadConversionFromLeadProductBasket(mapLeadIdPBId);
                if (mapLeadIdPBId.size() > 0) {
                    createOppsFromBasketForLead(mapLeadIdPBId, lstAttributeNew);
                }

                if (mapPBIdAccountId.size() > 0) {
                    CreateOpportunitiesFromAccountProductBasket(mapPBIdAccountId, lstAttributeNew);
                }


                Set<Id> basketfutureIds = new Set<Id>();

                for (cscfga__Product_Basket__c tmpPB : lstPB) {
                    tmpPB.csordtelcoa__Synchronised_with_Opportunity__c = true;
                    tmpPB.csbb__Synchronised_With_Opportunity__c = true;
                    basketfutureIds.add(tmpPB.Id);
                }

                update lstPB;

                //System.debug('***after lstPB=' + lstPB);

                //call the unsync/sync basket future method
                if (!System.isFuture() && !System.isBatch())
                {
                    futureUnsyncSync(basketfutureIds);
                }
            }

        }
    }

    //Had to unsync-sync the baskets so that the CreateOLIs method would be called
    //from the Basket Trigger - and to avoid 101 soql limits
    @future
    private static void futureUnsyncSync(Set<Id> basketfutureIds)
    {
        List<cscfga__Product_Basket__c> baskets = [SELECT Id, cscfga__Basket_Status__c,
                                                  csordtelcoa__Synchronised_with_Opportunity__c,
                                                  csbb__Synchronised_With_Opportunity__c,
                                                  cscfga__Opportunity__r.Id
                                                  FROM cscfga__Product_Basket__c
                                                  WHERE Id IN :basketfutureIds];

        for(cscfga__Product_Basket__c basket : baskets)
        {
            //de-sync first and then synce again
            if (basket.csordtelcoa__Synchronised_with_Opportunity__c
                || basket.csbb__Synchronised_With_Opportunity__c)
            {
                basket.csordtelcoa__Synchronised_with_Opportunity__c = false;
                basket.csbb__Synchronised_With_Opportunity__c = false;
            }
        }

        update baskets;

        for(cscfga__Product_Basket__c basket : baskets)
        {
            basket.csordtelcoa__Synchronised_with_Opportunity__c = true;
            basket.csbb__Synchronised_With_Opportunity__c = true;
        }

        update baskets;
    }

    private static void UnSyncProductBasketAfterAttributeInsertUpdate(List<cscfga__Attribute__c> lstAttributeNew, List<cscfga__Attribute__c> lstAttributeOld) {
        //System.debug('*****lstAttributeNew=' + lstAttributeNew);
        //System.debug('*****lstAttributeOld=' + lstAttributeOld);

        Set<string> setPCId = new Set<string>();
        Set<string> setAttribDefinitionId = new Set<string>();
        Set<string> setAttributeId = new Set<string>();

        Boolean Pass;

        for (integer i = 0; i < lstAttributeNew.size(); ++i) {
            Pass = false;
            if (lstAttributeOld == null) {
                Pass = true;
            } else {

                if ((lstAttributeNew[i].cscfga__Value__c != lstAttributeOld[i].cscfga__Value__c) ||
                        (lstAttributeNew[i].cscfga__Price__c != lstAttributeOld[i].cscfga__Price__c) ||
                        (lstAttributeNew[i].cscfga__Is_Line_Item__c != lstAttributeOld[i].cscfga__Is_Line_Item__c) ||
                        (lstAttributeNew[i].cscfga__Line_Item_Description__c != lstAttributeOld[i].cscfga__Line_Item_Description__c)) {

                    Pass = true;

                    // SFDT-698 - Product basket uploaded in D2D app is not synced with opportunity
                    if (lstAttributeNew[i].cscfga__Product_Configuration__c != null &&
                            lstAttributeNew[i].cscfga__Product_Configuration__r.cscfga__Parent_Configuration__c == null &&
                            LG_Util.IsValidId(lstAttributeNew[i].cscfga__Value__c)) {
                        Pass = false;
                    }
                }
            }

            if (Pass) {
                setPCId.add(lstAttributeNew[i].cscfga__Product_Configuration__c);
                setAttribDefinitionId.add(lstAttributeNew[i].cscfga__Attribute_Definition__c);
                setAttributeId.add(lstAttributeNew[i].Id);
            }
        }

        system.debug('--+ setPCId: '+setPCId);

        if (setPCId.size() > 0) {
            Map<Id, cscfga__Product_Configuration__c> mapPC = new Map<Id, cscfga__Product_Configuration__c>([SELECT Id, cscfga__Product_Basket__c,
                    cscfga__Product_Basket__r.cscfga__Opportunity__c, cscfga__Product_Basket__r.csordtelcoa__Synchronised_with_Opportunity__c
                    FROM cscfga__Product_Configuration__c WHERE Id in : setPCId]);

            //System.debug('*****mapPC=' + mapPC);

            Map<Id, cscfga__Attribute_Definition__c> mapAttribDef = new Map<Id, cscfga__Attribute_Definition__c>([SELECT Id, cscfga__is_significant__c
                    FROM cscfga__Attribute_Definition__c
                    WHERE Id in : setAttribDefinitionId]);

            System.debug('*****mapAttribDef=' + mapAttribDef);

            Set<string> setProductBasketId = new Set<string>();

            for (integer i = 0; i < lstAttributeNew.size(); ++i) {
                if (setAttributeId.contains(lstAttributeNew[i].Id)) {
                    string tmpAttribDefinitionId = lstAttributeNew[i].cscfga__Attribute_Definition__c;
                    Boolean tmpDeSync = mapAttribDef.get(tmpAttribDefinitionId).cscfga__is_significant__c;

                    string tmpPCId = lstAttributeNew[i].cscfga__Product_Configuration__c;
                    Boolean tmpPBSynced =  mapPC.get(tmpPCId).cscfga__Product_Basket__r.csordtelcoa__Synchronised_with_Opportunity__c;
                    string tmpPBId = mapPC.get(tmpPCId).cscfga__Product_Basket__c;

                    if (tmpPBSynced) {
                        setProductBasketId.add(tmpPBId);
                    }
                }
            }

            if (setProductBasketId.size() > 0) {
                List<cscfga__Product_Basket__c> lstProductBasket = [SELECT Id, csordtelcoa__Synchronised_with_Opportunity__c
                        FROM cscfga__Product_Basket__c WHERE Id in : setProductBasketId];

                for (cscfga__Product_Basket__c tmpProductBasket : lstProductBasket) {
                    tmpProductBasket.csordtelcoa__Synchronised_with_Opportunity__c = false;
                }

                update lstProductBasket;
            }
        }
    }

    private static void CreateOpportunitiesFromAccountProductBasket(map <string, string> mapPBIdAccountId , List<cscfga__Attribute__c> lstAttributeNew) {
        Map<Id, cscfga__Product_Basket__c> mapProductBasket = new Map<Id, cscfga__Product_Basket__c>([SELECT Id,
                LG_InstallationCity__c, LG_InstallationCountry__c, LG_InstallationHouseNumber__c, LG_InstallationHouseNumberExtension__c,
                LG_InstallationPostalCode__c, LG_InstallationStreet__c, LG_InstallationStateProvince__c, 
                LG_ResultofVisit__c,
                LG_PostalCity__c, LG_PostalCountry__c, LG_PostalHouseNumber__c, LG_PostalHouseNumberExtension__c,
                LG_PostalPostalCode__c, LG_PostalStreet__c,
                LG_VisitDescription__c,
                LG_MainReasonLost__c,
                LG_BillingCity__c, LG_BillingCountry__c, LG_BillingHouseNumber__c, LG_BillingHouseNumberExtension__c,
                LG_BillingPostalCode__c, LG_BillingStreet__c, LG_BillingSameAsInstallationAddress__c, LG_BillingStateProvince__c,
                LG_PaymentType__c, LG_BankAccountName__c, LG_BankNumber__c, LG_CustomerReference__c,
                LG_PreferredInstallationDate__c, LG_PreferredInstallationTime__c, LG_SharedOfficeBuilding__c, LG_COAXConnectionLocation__c,
                LG_AdminContactDateofBirth__c, LG_AdminContactEmail__c, LG_AdminContactFirstName__c, LG_AdminContactId__c, LG_AdminContactLastName__c,
                LG_AdminContactMiddleName__c, LG_AdminContactMobile__c, LG_AdminContactPhone__c, LG_AdminContactSalutation__c, LG_AdminContactPicklist__c,
                LG_TechnicalContactDateofBirth__c, LG_TechnicalContactEmail__c, LG_TechnicalContactFirstName__c, LG_TechnicalContactId__c, LG_TechnicalContactLastName__c,
                LG_TechnicalContactMiddleName__c, LG_TechnicalContactMobile__c, LG_TechnicalContactPhone__c, LG_TechnicalContactSalutation__c,
                LG_TechContactSameasBillingContact__c, LG_TechnicalContactPicklist__c,
                cfgoffline__Account__c, cscfga__Opportunity__c, csordtelcoa__Synchronised_with_Opportunity__c, LG_CreatedFrom__c,
                LG_ClientNumber__c, LG_ExistingSubscription__c, LG_DTV__c, LG_IPAddress__c, LG_Telephony__c, csordtelcoa__Account__c, csbb__Account__c,
                UM_BankName__c, UM_BankAccountNumberBic__c
                FROM cscfga__Product_Basket__c WHERE Id in : mapPBIdAccountId.keyset()]);

        Map<Id, Account> mapAccount = new Map<Id, Account>([select Id, LG_VisitCity__c, LG_VisitCountry__c,
                LG_VisitHouseNumber__c,
                LG_VisitHouseNumberExtension__c, LG_VisitPostalCode__c, LG_VisitStreet__c,
                LG_AccountLeadStatus__c, Name
                from Account
                where Id in : mapPBIdAccountId.values()]);

        Map<Id, Opportunity> lstOpportunityInsert = new Map<Id, Opportunity>();

        //System.debug('***mapProductBasket=' + mapProductBasket);
        //System.debug('***mapAccount=' + mapAccount);
        //System.debug('***mapPBIdAccountId=' + mapPBIdAccountId);

        Set<string> setContactId = new Set<string>();

        for (cscfga__Product_Basket__c tmpPB : mapProductBasket.values()) {
            if ((tmpPB.LG_AdminContactPicklist__c != '0') && (tmpPB.LG_AdminContactPicklist__c != null) && (tmpPB.LG_AdminContactPicklist__c != '')  && (tmpPB.LG_AdminContactPicklist__c != '(new Contact)')) {
                setContactId.add(tmpPB.LG_AdminContactPicklist__c);
            }

            if ((tmpPB.LG_TechnicalContactPicklist__c != '0') && (tmpPB.LG_TechnicalContactPicklist__c != null) && (tmpPB.LG_TechnicalContactPicklist__c != '')  && (tmpPB.LG_TechnicalContactPicklist__c != '(new Contact)')) {
                setContactId.add(tmpPB.LG_TechnicalContactPicklist__c);
            }
        }

        Map<Id, Contact> mapContact = new Map<Id, Contact>();

        if (setContactId.size() > 0) {
            mapContact = new Map<Id, Contact>([SELECT Id, AccountId, Birthdate, Email, FirstName, LastName, MobilePhone, Phone, Salutation FROM Contact WHERE Id in : setContactId]);
        }

        Map<Id, Contact> mapContactUpdate = new Map<Id, Contact>();
        List<Contact> lstContactInsert = new List<Contact>();
        List<cOpportunityContactRole> lstitemOpportunityContactRole = new List<cOpportunityContactRole>();
        Map<Id, Account> mapAccountUpdate = new Map<Id, Account>();
        List<cscrm__Address__c> listNewPremise = new List<cscrm__Address__c>();
        List<csconta__Billing_Account__c> listNewBillingAccount = new List<csconta__Billing_Account__c>();
        Account accountForUpdate = new Account();

        for (string tmpPBId : mapPBIdAccountId.keyset()) {
            Opportunity tmpOpportunity = new Opportunity();
            Account tmpAccount = mapAccount.get(mapPBIdAccountId.get(tmpPBId));

            Contact tmpAdminContact;
            Contact tmpTechnicalContact;

            tmpOpportunity.AccountId = tmpAccount.Id;

            //when Account gets its Opportunity make its Lead Status field to Qualified
            tmpAccount.LG_AccountLeadStatus__c = 'Qualified';
            mapAccountUpdate.put(tmpAccount.Id, tmpAccount);

            cscfga__Product_Basket__c tmpPB = mapProductBasket.get(tmpPBId);

            listNewPremise.add(LG_Util.createNewPremise(tmpPB, tmpOpportunity));

            setStageName(tmpPB, tmpOpportunity);

            tmpOpportunity.Probability = LG_OpportunityStageCache.DefaultProbability(tmpOpportunity.StageName);

            tmpOpportunity.Description = tmpPB.LG_VisitDescription__c;

            if (String.isNotBlank(tmpPB.LG_BankNumber__c) || String.isNotBlank(tmpPB.LG_BankAccountName__c) || tmpPB.LG_PaymentType__c != null)
            {
                listNewBillingAccount.add(createNewBillingAccount(tmpPB, tmpOpportunity));
            }

            //Postal Address update on the Account
            accountForUpdate = createPostalAccount(tmpPB, tmpOpportunity);

            tmpOpportunity.LG_PreferredInstallationDate__c = tmpPB.LG_PreferredInstallationDate__c;
            tmpOpportunity.LG_PreferredInstallationTime__c = tmpPB.LG_PreferredInstallationTime__c;
            tmpOpportunity.LG_OriginatingProductBasketId__c = tmpPBId;
            tmpOpportunity.Name = tmpAccount.Name + ' - ' + string.valueOf(system.today().month()) + '/' + string.valueOf(system.today().year());
            tmpOpportunity.CloseDate = system.today();

            tmpAdminContact = null;

            //System.debug('***tmpPB.LG_AdminContactId__c=' + tmpPB.LG_AdminContactId__c);
            //System.debug('***tmpPB.LG_AdminContactId__c=' + tmpPB.LG_AdminContactId__c);

            if (tmpPB.LG_AdminContactPicklist__c != '(new Contact)') {
                //so this is existing Contact
                if (mapContact.containsKey(tmpPB.LG_AdminContactPicklist__c)) {
                    tmpAdminContact = mapContact.get(tmpPB.LG_AdminContactPicklist__c);
                    classContact cContact = new classContact(tmpPB, 'Admin');
                    Boolean Changed = CopyContactDetailsToContact(tmpAdminContact, cContact, false);

                    //System.debug('***Changed Admin=' + Changed);

                    if (Changed) {
                        mapContactUpdate.put(tmpAdminContact.Id, tmpAdminContact);
                    }
                }
            } else if (tmpPB.LG_AdminContactPicklist__c == '(new Contact)') {

                tmpAdminContact = new Contact();
                classContact cContact = new classContact(tmpPB, 'Admin');
                boolean Valid = CopyContactDetailsToContact(tmpAdminContact, cContact, true);

                if (Valid) {
                    tmpAdminContact.AccountId = tmpAccount.Id;
                    lstContactInsert.add(tmpAdminContact);
                } else {
                    tmpAdminContact = null;
                }

                //System.debug('***Valid Admin=' + Valid);
            }

            //System.debug('***tmpPB.LG_TechnicalContactId__c=' + tmpPB.LG_TechnicalContactPicklist__c);
            //System.debug('***tmpPB.LG_TechContactSameasBillingContact__c=' + tmpPB.LG_TechContactSameasBillingContact__c);

            tmpTechnicalContact = null;
            if ((tmpPB.LG_TechContactSameasBillingContact__c) || ContactsIdentical(tmpPB)) {
                tmpTechnicalContact = tmpAdminContact;
            } else if ((tmpPB.LG_TechnicalContactPicklist__c != '(new Contact)') && (tmpPB.LG_TechnicalContactPicklist__c != '') && (tmpPB.LG_TechnicalContactPicklist__c != null)) {
                if (tmpPB.LG_TechnicalContactPicklist__c == tmpPB.LG_AdminContactPicklist__c) {
                    tmpTechnicalContact = tmpAdminContact;
                } else {
                    if (mapContact.containsKey(tmpPB.LG_TechnicalContactPicklist__c)) {

                        tmpTechnicalContact = mapContact.get(tmpPB.LG_TechnicalContactPicklist__c);
                        classContact cContact = new classContact(tmpPB, 'Technical');
                        Boolean Changed = CopyContactDetailsToContact(tmpTechnicalContact, cContact, false);

                        if (Changed) {
                            mapContactUpdate.put(tmpTechnicalContact.Id, tmpTechnicalContact);
                        }

                        //System.debug('***Changed Technical=' + Changed);
                    }
                }
            } else if (tmpPB.LG_TechnicalContactPicklist__c == '(new Contact)') {

                tmpTechnicalContact = new Contact();
                classContact cContact = new classContact(tmpPB, 'Technical');
                boolean Valid = CopyContactDetailsToContact(tmpTechnicalContact, cContact, true);

                if (Valid) {
                    tmpTechnicalContact.AccountId = tmpAccount.Id;
                    lstContactInsert.add(tmpTechnicalContact);
                } else {
                    tmpTechnicalContact = null;
                }

                //System.debug('***Valid Technical=' + Valid);
            }

            //System.debug('***tmpAdminContact=' + tmpAdminContact);
            //System.debug('***tmpTechnicalContact=' + tmpTechnicalContact);

            // SFDT-418 - Residential or Soho migration
            setResidentalOrSohoMigrationData(tmpPB, tmpOpportunity);

            lstOpportunityInsert.put(tmpOpportunity.Id, tmpOpportunity);
            cOpportunityContactRole itemOpportunityContactRole = new cOpportunityContactRole();
            itemOpportunityContactRole.Opp = tmpOpportunity;
            itemOpportunityContactRole.AdminContact = tmpAdminContact;
            itemOpportunityContactRole.TechnicalContact = tmpTechnicalContact;

            if ((tmpAdminContact != null) || (tmpTechnicalContact != null)) {
                lstitemOpportunityContactRole.add(itemOpportunityContactRole);
            }

            //System.debug('***itemOpportunityContactRole=' + itemOpportunityContactRole);
            //System.debug('*****lstitemOpportunityContactRole=' + lstitemOpportunityContactRole);
        }

        //System.debug('***lstOpportunityInsert=' + lstOpportunityInsert.values());
        //System.debug('***final lstitemOpportunityContactRole=' + lstitemOpportunityContactRole);

        if (lstOpportunityInsert.values().size() > 0) {

            insert lstOpportunityInsert.values();

            /**
             * Technical contact assignment not happening to site in D2D app
             *
             * @author Petar Miletic
             * @ticket SFDT-709
             * @since  20/04/2016
            */
            // resolvePremiseDuplicates(listNewPremise);
            LG_Util.resolveAndUpsertPremiseDuplicates(listNewPremise);

            upsert listNewBillingAccount;
            update accountForUpdate;

            //System.debug('***lstContactInsert=' + lstContactInsert);

            if (lstContactInsert.size() > 0) {
                insert lstContactInsert;
            }

            /**
             * Technical contact assignment not happening to site in D2D app
             *
             * @author Petar Miletic
             * @ticket SFDT-709
             * @since  20/04/2016
            */
            updateTehnicalContact(listNewPremise, lstitemOpportunityContactRole);

            createTasksForOpportunities(lstOpportunityInsert);

            //System.debug('***after insert lstContactInsert=' + lstContactInsert);

            //System.debug('***mapContactUpdate=' + mapContactUpdate);
            if (mapContactUpdate.size() > 0) {
                update mapContactUpdate.values();
            }

            //System.debug('***mapAccountUpdate=' + mapAccountUpdate);
            if (mapAccountUpdate.size() > 0) {
                update mapAccountUpdate.values();
            }

            createOpportunityContactRoles(lstitemOpportunityContactRole, null);

            List<cscfga__Product_Basket__c> lstProductBasketUpdate = new List<cscfga__Product_Basket__c>();

            for (Opportunity tmpOpportunity : lstOpportunityInsert.values()) {
                string tmpPBId = tmpOpportunity.LG_OriginatingProductBasketId__c;

                if (mapProductBasket.containsKey(tmpPBId)) {
                    cscfga__Product_Basket__c tmpProductBasket = mapProductBasket.get(tmpPBId);
                    tmpProductBasket.cscfga__Opportunity__c = tmpOpportunity.Id;
                    tmpProductBasket.cfgoffline__Account__c = null;

                    lstProductBasketUpdate.add(tmpProductBasket);
                }
            }

            //System.debug('***lstProductBasketUpdate=' + lstProductBasketUpdate);

            if (lstProductBasketUpdate.size() > 0) {
                update lstProductBasketUpdate;
            }
        }
    }

    private static void createOppsFromBasketForLead(Map<Id, Id> leadToBaskets, List<cscfga__Attribute__c> lstAttributeNew) {
        //baskets to Opportunities
        Map<Id, Opportunity> basketToOpps = new Map<Id, Opportunity>();
        Map<Id, Id> basketToContact = new Map<Id, Id>();
        Set<Id> setConvertedContactId = new Set<Id>();
        Set<Id> oppIds = new Set<Id>();

        //if there are leads, convert those
        if (leadToBaskets != null && !leadToBaskets.isEmpty()) {
            Map<Id, Id> oppIdsToBaskets = new Map<Id, Id>();
            //Set<Id> oppIds = new Set<Id>();

            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
            List<Database.LeadConvert> lstLeadsToConvert = new List<Database.LeadConvert>();

            for (string tmpLeadId : leadToBaskets.keySet()) {
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(tmpLeadId);
                lc.setConvertedStatus(convertStatus.MasterLabel);
                lstLeadsToConvert.add(lc);
            }

            List<Database.LeadConvertResult> lstLeadConvertResult;

            try {
                lstLeadConvertResult = Database.convertLead(lstLeadsToConvert, true);
            } catch (Exception ex) {
                //System.debug('***ex.getMessage()=' + ex.getMessage());
                throw new LG_Exception(ex.getMessage());
            }

            //populate bakset to opportunity Ids
            for (Database.LeadConvertResult convResult : lstLeadConvertResult) {
                if (leadToBaskets.containsKey(convResult.getLeadId())) {
                    oppIdsToBaskets.put(convResult.getOpportunityId(), leadToBaskets.get(convResult.getLeadId()));
                    oppIds.add(convResult.getOpportunityId());
                    basketToContact.put(leadToBaskets.get(convResult.getLeadId()), convResult.getContactId());
                    setConvertedContactId.add(convResult.getContactId());
                }
            }

            //collect opportunities
            string oppSoql = 'SELECT ' + getFieldListAsCSV(Opportunity.getSobjectType()) + ' FROM Opportunity where Id in :oppIds';
            List<Opportunity> convertedOpps = Database.query(oppSoql);

            //map opportunities to baskets
            for (Opportunity opp : convertedOpps) {
                if (oppIdsToBaskets.containsKey(opp.Id)) {
                    basketToOpps.put(oppIdsToBaskets.get(opp.Id), opp);
                }
            }
        }

        //end of convesion process
        //TO DO: create opportunities
        //get all baskets
        Set<Id> basketIds = basketToOpps.keySet();
        string basketSoql = 'SELECT ' + getFieldListAsCSV(cscfga__Product_Basket__c.getSobjectType()) + ' FROM cscfga__Product_Basket__c WHERE Id IN :basketIds';
        Map<Id, cscfga__Product_Basket__c> basketMap = new Map<Id, cscfga__Product_Basket__c>((List<cscfga__Product_Basket__c>) Database.query(basketSoql));

        System.debug('PP basketList: ' + string.valueOf(basketMap));

        //get all contacts
        Map<Id, Contact> mapContact = new Map<Id, Contact>();

        if (setConvertedContactId.size() > 0) {
            mapContact = new Map<Id, Contact>([SELECT Id, AccountId, Birthdate, Email, FirstName, LastName, MobilePhone, Phone, Salutation
                                               FROM Contact
                                               WHERE Id in : setConvertedContactId]);
        }

        cscfga__Product_Basket__c tmpPB;
        Opportunity tmpOpportunity;

        Contact tmpAdminContact;
        Contact tmpTechnicalContact;
        Id tmpContactId;

        Map<Id, Contact> mapContactUpdate = new Map<Id, Contact>();
        List<Contact> lstContactInsert = new List<Contact>();
        List<Contact> lstContactUpdate = new List<Contact>();
        List<cOpportunityContactRole> lstitemOpportunityContactRole = new List<cOpportunityContactRole>();
        List<cscrm__Address__c> listNewPremise = new List<cscrm__Address__c>();
        List<csconta__Billing_Account__c> listNewBillingAccount = new List<csconta__Billing_Account__c>();
        Account accountForUpdate = new Account();

        //map fields to opportunity
        for (Id tmpBasketId : basketToOpps.keySet()) {
            //Account tmpAccount = mapAccount.get(mapPBIdAccountId.get(tmpPBId));
            tmpOpportunity = basketToOpps.get(tmpBasketId);

            tmpPB = basketMap.get(tmpBasketId);

            // SFDT-418 - Residential or Soho migration
            setResidentalOrSohoMigrationData(tmpPB, tmpOpportunity);

            listNewPremise.add(LG_Util.createNewPremise(tmpPB, tmpOpportunity));

            setStageName(tmpPB, tmpOpportunity);

            tmpOpportunity.Probability = LG_OpportunityStageCache.DefaultProbability(tmpOpportunity.StageName);

            tmpOpportunity.Description = tmpPB.LG_VisitDescription__c;

            if (String.isNotBlank(tmpPB.LG_BankNumber__c) || String.isNotBlank(tmpPB.LG_BankAccountName__c) || tmpPB.LG_PaymentType__c != null)
            {
                listNewBillingAccount.add(createNewBillingAccount(tmpPB, tmpOpportunity));
            }

            //Postal Address update on the Account
			//Visit Address update because it is used for validation: UMR-1296 (Toni Banic 2017-02-08)
            accountForUpdate = new Account(ID = tmpOpportunity.AccountID,
                                           LG_PostalCity__c = ReplaceEmptyForInstall(tmpPB.LG_PostalCity__c, tmpPB.LG_InstallationCity__c),
                                           LG_PostalPostalCode__c = ReplaceEmptyForInstall(tmpPB.LG_PostalPostalCode__c, tmpPB.LG_InstallationPostalCode__c),
                                           LG_PostalCountry__c = ReplaceEmptyForInstall(tmpPB.LG_PostalCountry__c, tmpPB.LG_InstallationCountry__c),
                                           LG_PostalHouseNumber__c = ReplaceEmptyForInstall(tmpPB.LG_PostalHouseNumber__c, tmpPB.LG_InstallationHouseNumber__c),
                                           LG_PostalStreet__c = ReplaceEmptyForInstall(tmpPB.LG_PostalStreet__c, tmpPB.LG_InstallationStreet__c),
                                           LG_PostalHouseNumberExtension__c = ReplaceEmptyForInstall(tmpPB.LG_PostalHouseNumberExtension__c, tmpPB.LG_InstallationHouseNumberExtension__c),
                                           LG_VisitStreet__c = tmpPB.LG_InstallationStreet__c,
                                           LG_VisitHouseNumber__c = tmpPB.LG_InstallationHouseNumber__c,
                                           LG_VisitHouseNumberExtension__c = tmpPB.LG_InstallationHouseNumberExtension__c,
                                           LG_VisitPostalCode__c = tmpPB.LG_InstallationPostalCode__c,
                                           LG_VisitCity__c = tmpPB.LG_InstallationCity__c,
                                           LG_VisitCountry__c = tmpPB.LG_InstallationCountry__c,
                                           LG_VisitAddressID__c = tmpPB.LG_VisitAddressID__c
                                          );

            tmpOpportunity.LG_PreferredInstallationDate__c = tmpPB.LG_PreferredInstallationDate__c;
            tmpOpportunity.LG_PreferredInstallationTime__c = tmpPB.LG_PreferredInstallationTime__c;
            tmpOpportunity.LG_OriginatingProductBasketId__c = tmpBasketId;
            tmpOpportunity.CloseDate = system.today();

            tmpAdminContact = null;

            if (tmpPB.LG_AdminContactPicklist__c == '(new Contact)') {
                //this is new Contact which needs to be inserted

                tmpAdminContact = new Contact();
                classContact cContact = new classContact(tmpPB, 'Admin');
                boolean Valid = CopyContactDetailsToContact(tmpAdminContact, cContact, true);

                if (Valid) {
                    tmpAdminContact.AccountId = tmpOpportunity.AccountId;
                    lstContactInsert.add(tmpAdminContact);
                } else {
                    tmpAdminContact = null;
                }

                //System.debug('***Valid Admin=' + Valid);

            } else if (tmpPB.LG_AdminContactPicklist__c != '(new Contact)' && basketToContact.get(tmpBasketId) != null) {
                //this is Contact which is already created and now needs to be only updated
                tmpContactId = basketToContact.get(tmpBasketId);
                tmpAdminContact = mapContact.get(tmpContactId);
                classContact cContact = new classContact(tmpPB, 'Admin');
                Boolean Changed = CopyContactDetailsToContact(tmpAdminContact, cContact, false);

                //System.debug('***Changed Admin=' + Changed);

                if (Changed) {
                    mapContactUpdate.put(tmpAdminContact.Id, tmpAdminContact);
                }
            }

            tmpTechnicalContact = null;

            if ((tmpPB.LG_TechContactSameasBillingContact__c) || ContactsIdentical(tmpPB)) {
                tmpTechnicalContact = tmpAdminContact;
            } else if (tmpPB.LG_TechnicalContactPicklist__c == '(new Contact)') {
                tmpTechnicalContact = new Contact();
                classContact cContact = new classContact(tmpPB, 'Technical');
                boolean Valid = CopyContactDetailsToContact(tmpTechnicalContact, cContact, true);

                if (Valid) {
                    tmpTechnicalContact.AccountId = tmpOpportunity.AccountId;
                    lstContactInsert.add(tmpTechnicalContact);
                } else {
                    tmpTechnicalContact = null;
                }

                //System.debug('***Valid Technical=' + Valid);
            } else if ((tmpPB.LG_TechnicalContactPicklist__c != '(new Contact)') && (tmpPB.LG_TechnicalContactPicklist__c != '') && (tmpPB.LG_TechnicalContactPicklist__c != null)) {
                tmpContactId = basketToContact.get(tmpBasketId);
                tmpTechnicalContact = mapContact.get(tmpContactId);
                classContact cContact = new classContact(tmpPB, 'Technical');
                Boolean Changed = CopyContactDetailsToContact(tmpTechnicalContact, cContact, false);

                if (Changed) {
                    mapContactUpdate.put(tmpTechnicalContact.Id, tmpTechnicalContact);
                }

                //System.debug('***Changed Technical=' + Changed);
            }

            //System.debug('***tmpAdminContact=' + tmpAdminContact);
            //System.debug('***tmpTechnicalContact=' + tmpTechnicalContact);

            cOpportunityContactRole itemOpportunityContactRole = new cOpportunityContactRole();
            itemOpportunityContactRole.Opp = tmpOpportunity;
            itemOpportunityContactRole.AdminContact = tmpAdminContact;
            itemOpportunityContactRole.TechnicalContact = tmpTechnicalContact;

            if ((tmpAdminContact != null) || (tmpTechnicalContact != null)) {
                lstitemOpportunityContactRole.add(itemOpportunityContactRole);
            }
        }

        //System.debug('***basketToOpps=' + basketToOpps);

        if (!basketToOpps.isEmpty()) {

            update basketToOpps.values();

            /**
             * Technical contact assignment not happening to site in D2D app
             *
             * @author Petar Miletic
             * @ticket SFDT-709
             * @since  20/04/2016
            */
            // resolvePremiseDuplicates(listNewPremise);
            LG_Util.resolveAndUpsertPremiseDuplicates(listNewPremise);

            upsert listNewBillingAccount;
            /*Apoorva Kokate 24-2-2017 Starts*/
            for(Opportunity tempOpp: basketToOpps.values())
            {
                for(csconta__Billing_Account__c tempBillAcc : listNewBillingAccount)
                {
                    if(tempOpp.AccountId == tempBillAcc.csconta__Account__c)
                    {
                        tempOpp.LG_BillingAccountNumber__c = tempBillAcc.Id;
                    }
                }
            }
            update basketToOpps.values();
            /*Apoorva Kokate 24-2-2017 Ends*/
            update accountForUpdate;

            //System.debug('***lstContactInsert=' + lstContactInsert);

            if (lstContactInsert.size() > 0) {
                insert lstContactInsert;
            }

            /**
             * Technical contact assignment not happening to site in D2D app
             *
             * @author Petar Miletic
             * @ticket SFDT-09
             * @since  20/04/2016
            */
            updateTehnicalContact(listNewPremise, lstitemOpportunityContactRole);

            createTasksForOpportunities(basketToOpps);

            //System.debug('***mapContactUpdate=' + mapContactUpdate);

            if (mapContactUpdate.size() > 0) {
                update mapContactUpdate.values();
            }

            createOpportunityContactRoles(lstitemOpportunityContactRole, oppIds);

            List<cscfga__Product_Basket__c> lstProductBasketUpdate = new List<cscfga__Product_Basket__c>();

            //System.debug('***basketMap=' + basketMap);

            Id tmpPBId;
            for (Opportunity tmpOpp : basketToOpps.values()) {
                tmpPBId = tmpOpp.LG_OriginatingProductBasketId__c;

                if (basketMap.containsKey(tmpPBId)) {

                    cscfga__Product_Basket__c tmpProductBasket = basketMap.get(tmpPBId);
                    tmpProductBasket.cscfga__Opportunity__c = tmpOpportunity.Id;
                    tmpProductBasket.csordtelcoa__Account__c = null;

                    /**
                     * D2D basket does not have account field set up on the basket after upload
                     *
                     * @author Petar Miletic
                     * @ticket SFDT-711
                     * @since  15/04/2016
                    */
                    if (tmpProductBasket.csbb__Account__c == null && tmpOpportunity.AccountId != null) {
                        tmpProductBasket.csbb__Account__c = tmpOpportunity.AccountId;
                    }

                    lstProductBasketUpdate.add(tmpProductBasket);
                }
            }

            if (lstProductBasketUpdate.size() > 0)  {
                update lstProductBasketUpdate;
            }
        }
    }

    /**
     * Technical contact assignment not happening to site in D2D app
     *
     * @author Petar Miletic
     * @ticket SFDT-709
     * @since  20/04/2016
    */
    private static void updateTehnicalContact(List<cscrm__Address__c> listNewPremise, List<cOpportunityContactRole> contactRoles) {

        List<Id> contactIDs = new List<Id>();

        // Take first tehnical contact
        for (cOpportunityContactRole r : contactRoles) {
            if (r.TechnicalContact != null) {
                contactIDs.add(r.TechnicalContact.Id);
                break;
            }
        }

        // Call future method
        if (!contactIDs.isEmpty() && !listNewPremise.isEmpty()) {
            updateTehnicalContactFuture(listNewPremise[0].Id, contactIDs);
        }
    }

    /*
     * Future method. Updates LG_Address__c field
    */
    @future
    private static void updateTehnicalContactFuture(Id addressID, List<Id> contactIDs) {
        cscrm__Address__c address = [SELECT Id, LG_TechnicalContact__c FROM cscrm__Address__c WHERE Id = :addressID];
        address.LG_TechnicalContact__c = contactIDs[0];
        update address;
    }

    /* Utility methods */

    private static csconta__Billing_Account__c createNewBillingAccount(cscfga__Product_Basket__c tmpPB, Opportunity tmpOpportunity) {

        csconta__Billing_Account__c a = new csconta__Billing_Account__c();

        a.csconta__City__c = tmpPB.LG_BillingSameAsInstallationAddress__c ? tmpPB.LG_InstallationCity__c : tmpPB.LG_BillingCity__c;
        a.csconta__Country__c = tmpPB.LG_BillingSameAsInstallationAddress__c ? tmpPB.LG_InstallationCountry__c : tmpPB.LG_BillingCountry__c;
        a.LG_HouseNumber__c = tmpPB.LG_BillingSameAsInstallationAddress__c ? tmpPB.LG_InstallationHouseNumber__c : tmpPB.LG_BillingHouseNumber__c;
        a.csconta__Street__c = tmpPB.LG_BillingSameAsInstallationAddress__c ? tmpPB.LG_InstallationStreet__c : tmpPB.LG_BillingStreet__c;
        a.csconta__PostCode__c = tmpPB.LG_BillingSameAsInstallationAddress__c ? tmpPB.LG_InstallationPostalCode__c : tmpPB.LG_BillingPostalCode__c;
        a.UM_Billing_State_Province__c = tmpPB.LG_BillingSameAsInstallationAddress__c ? tmpPB.LG_InstallationStateProvince__c : tmpPB.LG_BillingStateProvince__c; 
        a.LG_HouseNumberExtension__c = tmpPB.LG_BillingSameAsInstallationAddress__c ? tmpPB.LG_InstallationHouseNumberExtension__c : tmpPB.LG_BillingHouseNumberExtension__c;
	a.csconta__Account__c = tmpOpportunity.AccountID;
        a.LG_CustomerReference__c = tmpPB.LG_CustomerReference__c;
        a.LG_PaymentType__c = tmpPB.LG_PaymentType__c;
        a.LG_BankAccountHolder__c = tmpPB.LG_BankAccountName__c;
        a.LG_BankAccountNumberIBAN__c = tmpPB.LG_BankNumber__c;
        a.LG_BillingEmailAddress__c = tmpPB.LG_AdminContactEmail__c;
        // SFSLS-119 (2017-02-01)
        a.UM_BankAccountNumberBic__c = tmpPB.UM_BankAccountNumberBic__c;
        a.UM_BankName__c = tmpPB.UM_BankName__c;

        return a;
    }

    private static Account createPostalAccount(cscfga__Product_Basket__c tmpPB, Opportunity tmpOpportunity) {

        Account a =  new Account();

        a.ID = tmpOpportunity.AccountID;
        a.LG_PostalCity__c = ReplaceEmptyForInstall(tmpPB.LG_PostalCity__c, tmpPB.LG_InstallationCity__c);
        a.LG_PostalPostalCode__c = ReplaceEmptyForInstall(tmpPB.LG_PostalPostalCode__c, tmpPB.LG_InstallationPostalCode__c);
        a.LG_PostalCountry__c = ReplaceEmptyForInstall(tmpPB.LG_PostalCountry__c, tmpPB.LG_InstallationCountry__c);
        a.LG_PostalHouseNumber__c = ReplaceEmptyForInstall(tmpPB.LG_PostalHouseNumber__c, tmpPB.LG_InstallationHouseNumber__c);
        a.LG_PostalStreet__c = ReplaceEmptyForInstall(tmpPB.LG_PostalStreet__c, tmpPB.LG_InstallationStreet__c);
        a.LG_PostalHouseNumberExtension__c = ReplaceEmptyForInstall(tmpPB.LG_PostalHouseNumberExtension__c, tmpPB.LG_InstallationHouseNumberExtension__c);

        return a;
    }

    public static void createTasksForOpportunities(Map<Id, Opportunity> opps) {

        List<Task> lstOppTask = new List<Task>();

        for (Opportunity tmpOpp : opps.values()) {
            Task tmpOppTask = new Task();
            tmpOppTask.Type = 'Result of D2D Visit';
            tmpOppTask.Subject = 'Visit';

            if (tmpOpp.StageName == 'Negotiation/Review') {
                tmpOppTask.LG_Result__c = 'Quote';
            } else if (tmpOpp.StageName == 'Customer Approved') {
                tmpOppTask.LG_Result__c = 'Sales';
            } else {
                tmpOppTask.LG_Result__c = 'Not interested';
            }

            tmpOppTask.ActivityDate = date.today();
            tmpOppTask.Status = 'Completed';
            tmpOppTask.WhatId = tmpOpp.Id;

            lstOppTask.add(tmpOppTask);
        }

        //System.debug('***lstOppTask=' + lstOppTask);

        if (lstOppTask.size() > 0) {
            insert lstOppTask;
        }
    }

    private static void setResidentalOrSohoMigrationData(cscfga__Product_Basket__c tmpPB, Opportunity tmpOpportunity) {

        // SFDT-418 - Residential or Soho migration
        tmpOpportunity.LG_ClientNumber__c = tmpPB.LG_ClientNumber__c;
        tmpOpportunity.LG_ExistingSubscription__c = tmpPB.LG_ExistingSubscription__c;
        tmpOpportunity.LG_DTV__c = tmpPB.LG_DTV__c;
        tmpOpportunity.LG_IPAddress__c = tmpPB.LG_IPAddress__c;
        tmpOpportunity.LG_Telephony__c = tmpPB.LG_Telephony__c;
    }

    private static void setStageName(cscfga__Product_Basket__c tmpPB, Opportunity tmpOpportunity) {

        if (tmpPB.LG_ResultofVisit__c == 'Quote Requested') {
            tmpOpportunity.StageName = 'Awareness of interest';
        } else if (tmpPB.LG_ResultofVisit__c == 'Customer Approved') {
            tmpOpportunity.StageName = 'Customer Approved';
        } else if (tmpPB.LG_ResultofVisit__c == 'Customer Rejected') {
            tmpOpportunity.StageName = 'Closed Lost';
            tmpOpportunity.LG_MainReasonLost__c = tmpPB.LG_MainReasonLost__c;
        }
    }

    private static void createOpportunityContactRoles(List<cOpportunityContactRole> lstitemOpportunityContactRole, Set<Id> oppIds) {

        List<OpportunityContactRole> lstOppCntRole = new List<OpportunityContactRole>();

        for (cOpportunityContactRole itemOpportunityContactRole : lstitemOpportunityContactRole) {
            if (itemOpportunityContactRole.AdminContact != null) {
                OpportunityContactRole tmpOpportunityContactRole = new OpportunityContactRole();

                tmpOpportunityContactRole.ContactId = itemOpportunityContactRole.AdminContact.Id;
                tmpOpportunityContactRole.IsPrimary = true;
                tmpOpportunityContactRole.OpportunityId = itemOpportunityContactRole.Opp.Id;
                tmpOpportunityContactRole.Role = 'Administrative Contact';

                lstOppCntRole.add(tmpOpportunityContactRole);
            }

            if (itemOpportunityContactRole.TechnicalContact != null) {
                OpportunityContactRole tmpOpportunityContactRole = new OpportunityContactRole();

                tmpOpportunityContactRole.ContactId = itemOpportunityContactRole.TechnicalContact.Id;
                tmpOpportunityContactRole.IsPrimary = false;
                tmpOpportunityContactRole.OpportunityId = itemOpportunityContactRole.Opp.Id;
                tmpOpportunityContactRole.Role = 'Technical Contact';

                lstOppCntRole.add(tmpOpportunityContactRole);
            }
        }

        if (lstOppCntRole.size() > 0) {
            insert lstOppCntRole;
        }

        if (oppIds != null && oppIds.size() > 0) {
            List<OpportunityContactRole> lstOppCntRoleDelete = [select Id, Role from OpportunityContactRole WHERE OpportunityId in : oppIds and (Role = null or Role = '')];

            if (lstOppCntRoleDelete.size() > 0)  {
                delete lstOppCntRoleDelete;
            }
        }
    }

    private static string ReplaceEmptyForInstall(string ProductBasketAddressPart, string ProductBasketInstallPart) {
        if (ProductBasketAddressPart == '' || ProductBasketAddressPart == null) {
            return ProductBasketInstallPart;
        } else {
            return ProductBasketAddressPart;
        }
    }

    private static Map<sObjectType, Map<String, Schema.SObjectField>> mapFieldsToObject = new Map<sObjectType, Map<String, Schema.SObjectField>>();

    public static String getFieldListAsCSV(sObjectType sobject_type) {
        Map<String, Schema.SObjectField> field_map = getObjectFields(sobject_type);
        return String.join(new List<String>(field_map.keySet()), ',');
    }

    public static Map<String, Schema.SObjectField> getObjectFields(sObjectType sobject_type) {
        Map<String, Schema.SObjectField> field_map;
        if (!mapFieldsToObject.containsKey(sobject_type)) {
            //describe the sobject
            DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
            //get a map of fields for the passed sobject
            field_map = sobject_describe.fields.getMap();
            mapFieldsToObject.put(sobject_type, field_map);
        }

        field_map = mapFieldsToObject.get(sobject_type); //get a map of fields for the passed sobject
        return field_map;
    }

    /**** Petar's code end ****/

    private static Boolean CopyContactDetailsToContact(Contact tmpContact, classContact pContact, Boolean ModeInsert) {
        Boolean Change = false;

        if (ModeInsert) {
            tmpContact.Birthdate = pContact.Birthdate;
            tmpContact.Email = pContact.Email;
            tmpContact.FirstName = pContact.FirstName;
            tmpContact.LastName = pContact.LastName;
            tmpContact.MobilePhone = pContact.MobilePhone;
            tmpContact.Phone = pContact.Phone;
            tmpContact.Salutation = pContact.Salutation;

            if ((pContact.FirstName != '') && (pContact.FirstName != null) &&
                    (pContact.LastName != '') && (pContact.LastName != null) &&
                    (pContact.Email != '') && (pContact.Email != null)) {
                Change = true;
                //so it is valid Contact
            }



        } else {
            if (pContact.Birthdate != null) {
                if (tmpContact.Birthdate != pContact.Birthdate) {
                    tmpContact.Birthdate = pContact.Birthdate;
                    Change = true;
                }
            }

            if (pContact.Email != null) {
                if (tmpContact.Email != pContact.Email) {
                    tmpContact.Email = pContact.Email;
                    Change = true;
                }
            }


            if (pContact.FirstName != null) {
                if (tmpContact.FirstName != pContact.FirstName) {
                    tmpContact.FirstName = pContact.FirstName;
                    Change = true;
                }
            }

            if (pContact.LastName != null) {
                if (tmpContact.LastName != pContact.LastName) {
                    tmpContact.LastName = pContact.LastName;
                    Change = true;
                }
            }

            if (pContact.MobilePhone != null) {
                if (tmpContact.MobilePhone != pContact.MobilePhone) {
                    tmpContact.MobilePhone = pContact.MobilePhone;
                    Change = true;
                }
            }

            if (pContact.Phone != null) {
                if (tmpContact.Phone != pContact.Phone) {
                    tmpContact.Phone = pContact.Phone;
                    Change = true;
                }
            }

            if (pContact.Salutation != null) {
                if (tmpContact.Salutation != pContact.Salutation) {
                    tmpContact.Salutation = pContact.Salutation;
                    Change = true;
                }
            }


        }
        return Change;
    }

    private static Boolean ContactsIdentical(cscfga__Product_Basket__c pProductBasket) {
        Boolean result = false;

        if ((pProductBasket.LG_AdminContactEmail__c == pProductBasket.LG_TechnicalContactEmail__c) &&
                (pProductBasket.LG_AdminContactFirstName__c == pProductBasket.LG_TechnicalContactFirstName__c) &&
                (pProductBasket.LG_AdminContactLastName__c == pProductBasket.LG_TechnicalContactLastName__c) &&
                (pProductBasket.LG_AdminContactMiddleName__c == pProductBasket.LG_TechnicalContactMiddleName__c) &&
                (pProductBasket.LG_AdminContactMobile__c == pProductBasket.LG_TechnicalContactMobile__c) &&
                (pProductBasket.LG_AdminContactPhone__c == pProductBasket.LG_TechnicalContactPhone__c) &&
                (pProductBasket.LG_AdminContactPicklist__c == pProductBasket.LG_TechnicalContactPicklist__c) &&
                (pProductBasket.LG_AdminContactSalutation__c == pProductBasket.LG_TechnicalContactSalutation__c))
            result = true;

        return result;
    }

   //added as part of omdev migration sfom 616

     /**
   * If Configuration Id Attribute is being insert with blank value,
   * set related Config Id on it.
   *
   * @param  List<cscfga__Attribute__c> attributes - Trigger.new list
   * @author Tomislav Blazek
   * @ticket SFOM-106
   * @since  18/12/2016
   */
  public static void updateConfigId(List<cscfga__Attribute__c> attributes) {
    for (cscfga__Attribute__c attribute : attributes) {
      if (attribute.Name == 'Configuration Id' && String.isBlank(attribute.cscfga__Value__c)) {
        attribute.cscfga__Value__c = attribute.cscfga__Product_Configuration__c;
      }
    }
  }
  public static void updateConnectionAttribute(List<cscfga__Attribute__c> attributes) {
      String bdsSiteShadow,bdsSiteDisplayValue;
      String vpnNetworkShadow,vpnNetworkDisplayValue;
      for (cscfga__Attribute__c attribute : attributes) {
          if (attribute.Name == 'BDS Site') {
              bdsSiteDisplayValue = attribute.cscfga__Value__c;
          } else if (attribute.Name == 'Site Configuration Shadow') {
              bdsSiteShadow = attribute.cscfga__Value__c;
          } else if (attribute.Name == 'VPN Network') {
              vpnNetworkDisplayValue = attribute.cscfga__Value__c;
          } else if (attribute.Name == 'VPN Configuration Shadow') {
              vpnNetworkShadow = attribute.cscfga__Value__c;
          }
      }      
      for (cscfga__Attribute__c attribute : attributes) {         
          if (attribute.Name == 'Multiple BDS Site' && attribute.cscfga__Value__c == null) {
              attribute.cscfga__Value__c = bdsSiteShadow;
              attribute.cscfga__Display_Value__c = bdsSiteDisplayValue;
          } else if (attribute.Name == 'Multiple VPN Network' && attribute.cscfga__Value__c == null) {
              attribute.cscfga__Value__c = vpnNetworkShadow;
              attribute.cscfga__Display_Value__c = vpnNetworkDisplayValue;
          }
      }
  }

    private class cOpportunityContactRole {
        public Opportunity Opp {get; set;}
        public Contact AdminContact {get; set;}
        public Contact TechnicalContact {get; set;}
    }

    private class classContact {
        public date Birthdate {get; set;}
        public string Email {get; set;}
        public string FirstName {get; set;}
        public string LastName  {get; set;}
        public string MobilePhone {get; set;}
        public string Phone  {get; set;}
        public string Salutation {get; set;}

        public cscfga__Product_Basket__c ProductBasket {get; set;}

        public classContact(cscfga__Product_Basket__c pProductBasket, string ContactType) {
            ProductBasket = pProductBasket;

            if (ContactType == 'Admin') {
                Birthdate = ProductBasket.LG_AdminContactDateofBirth__c;
                Email = ProductBasket.LG_AdminContactEmail__c;
                FirstName = ProductBasket.LG_AdminContactFirstName__c;
                LastName = ProductBasket.LG_AdminContactLastName__c;
                MobilePhone = ProductBasket.LG_AdminContactMobile__c;
                Phone = ProductBasket.LG_AdminContactPhone__c;
                Salutation = ProductBasket.LG_AdminContactSalutation__c;
            } else if (ContactType == 'Technical') {
                Birthdate = ProductBasket.LG_TechnicalContactDateofBirth__c;
                Email = ProductBasket.LG_TechnicalContactEmail__c;
                FirstName = ProductBasket.LG_TechnicalContactFirstName__c;
                LastName = ProductBasket.LG_TechnicalContactLastName__c;
                MobilePhone = ProductBasket.LG_TechnicalContactMobile__c;
                Phone = ProductBasket.LG_TechnicalContactPhone__c;
                Salutation = ProductBasket.LG_TechnicalContactSalutation__c;
            }
        }
    }

    /**
	 * When Number Range JSON attribute was changed/inserted, relevant number
	 * block assets and phone number assets should be created
	 *
	 * @param  List<cscfga__Attribute__c> atts
	 * @param  Map<Id, cscfga__Attribute__c> oldMap
	 * @author Tomislav Blazek
	 * @ticket SFOM-1036
	 * @since  26/6/2017
	 **/
	public static void createNumberAssets(List<cscfga__Attribute__c> atts, Map<Id,cscfga__Attribute__c> oldMap){
		List<cscfga__Attribute__c> eligibleAtts = new List<cscfga__Attribute__c>();
		for (cscfga__Attribute__c att : atts) {
			//check only Numberblock_RequestJson attribute and ignore the ones that are being inserted at the creation of the offer
            if (att.Name != 'Numberblock_RequestJson' || String.isBlank(att.LG_ProductBasket__c)) {
                continue;
            }
			cscfga__Attribute__c oldAtt = oldMap != null ? oldMap.get(att.Id) : null;
			if (att.Name == 'Numberblock_RequestJson' && (oldAtt == null || oldAtt.cscfga__Value__c != att.cscfga__Value__c)) {
				eligibleAtts.add(att);
			}
		}
		if (!eligibleAtts.isEmpty()) {
			generateNumberBlocksAssets(eligibleAtts);
		}
	}

	private static void generateNumberBlocksAssets(List<cscfga__Attribute__c> attsForNumbers){
		List<cscfga__Attribute__c> atts = [SELECT Id, cscfga__Product_Configuration__c, cscfga__Product_Configuration__r.cscfga__Parent_Configuration__c,
										   cscfga__Product_Configuration__r.cscfga__Product_Basket__r.csbb__Account__c, LG_ConfigurationChangeType__c,
										   cscfga__Product_Configuration__r.cscfga__Product_Basket__r.csordtelcoa__Account__c,
										   cscfga__Product_Configuration__r.cscfga__Product_Basket__r.cfgoffline__Account__c, cscfga__Value__c
										   FROM cscfga__Attribute__c
										   WHERE Id IN :attsForNumbers
										   AND cscfga__Product_Configuration__r.cscfga__Product_Basket__r.csordtelcoa__Change_Type__c != 'Clone'];

		if (Test.isRunningTest() || Trigger.isUpdate) {
			Set<Id> prodConfIds = new Set<Id>();
			for (cscfga__Attribute__c att : atts) {
				prodConfIds.add(att.cscfga__Product_Configuration__c);
			}

			List<Asset> assetsToDelete = [SELECT Id FROM Asset WHERE LG_NumberRangeProductConfiguration__c IN :prodConfIds];
			if (!assetsToDelete.isEmpty()) {
				delete assetsToDelete;
			}
		}

		Id numberBlockRTId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Number Block').getRecordTypeId();
		Boolean notDefined = false;
		List<Asset> numberBlocksToInsert = new List<Asset>();
		for (cscfga__Attribute__c att : atts) {
			if (String.isBlank(att.cscfga__Value__c) || String.isNotBlank(att.LG_ConfigurationChangeType__c)) continue;

            //if multiple number blocks in json - iterate over
            for (Object nmbrBlock : (List<Object>)JSON.deserializeUntyped(att.cscfga__Value__c)){

                Map<String, Object> numberBlockFields = (Map<String, Object>)nmbrBlock;

                notDefined = numberBlockFields.containsKey('notDefined') && ((String)numberBlockFields.get('notDefined')) == 'true';
                Integer numberRangeSize = Integer.valueOf(numberBlockFields.get('LG_NumberRangeSize__c'));
                String numberRangeType  = (String) numberBlockFields.get('LG_NumberRangeType__c');
                Id accountId            = att.cscfga__Product_Configuration__r.cscfga__Product_Basket__r.csbb__Account__c != null ? att.cscfga__Product_Configuration__r.cscfga__Product_Basket__r.csbb__Account__c
                                          : att.cscfga__Product_Configuration__r.cscfga__Product_Basket__r.csordtelcoa__Account__c != null ? att.cscfga__Product_Configuration__r.cscfga__Product_Basket__r.csordtelcoa__Account__c
                                          : att.cscfga__Product_Configuration__r.cscfga__Product_Basket__r.cfgoffline__Account__c != null ? att.cscfga__Product_Configuration__r.cscfga__Product_Basket__r.cfgoffline__Account__c : null;

                Asset numberBlockAsset = new Asset();
                numberBlockAsset.AccountId                             = accountId;
                numberBlockAsset.RecordTypeId                          = numberBlockRTId;
                numberBlockAsset.LG_TelephonyProductConfiguration__c   = att.cscfga__Product_Configuration__r.cscfga__Parent_Configuration__c;
                numberBlockAsset.LG_NumberRangeProductConfiguration__c = att.cscfga__Product_Configuration__r.Id;
                String nmbrBlockName = notDefined ? Label.LG_NumberBlockPlaceholder.replace('{numberRangeType}', numberRangeType).replace('{numberRangeSize}', numberRangeSize.format()) : (String) numberBlockFields.get('LG_NumberRange__c');
                numberBlockAsset.Name                  = nmbrBlockName;
                numberBlockAsset.LG_NumberRange__c     = nmbrBlockName;
                numberBlockAsset.LG_NumberRangeSize__c = numberRangeSize;
                numberBlockAsset.LG_NumberRangeType__c = numberRangeType;
                numberBlockAsset.Status                = 'In Quoting';
                for (String fieldName : numberBlockFields.keySet()) {
                    if (fieldName == 'notDefined' || fieldName == 'LG_NumberRangeType__c' || fieldName == 'LG_NumberRangeSize__c') continue;
                    numberBlockAsset.put(fieldName, numberBlockFields.get(fieldName));
                }
                numberBlocksToInsert.add(numberBlockAsset);
            }
		}

		insert numberBlocksToInsert;

		List<Asset> numbersToInsert = new List<Asset>();
		for (Asset blockAsset : numberBlocksToInsert) {
			if (notDefined) {
				for (Integer i = 0; i < Integer.valueOf(blockAsset.LG_NumberRangeSize__c); i++) {
					numbersToInsert.add(getPhoneNumberObj(blockAsset, Label.LG_NotDefined));
				}
			} else {
				Decimal startNumber = Decimal.valueOf(blockAsset.LG_StartNumber__c);
				Decimal endNumber   = Decimal.valueOf(blockAsset.LG_EndNumber__c);

				for (Decimal phoneNumber = startNumber; phoneNumber <= endNumber; phoneNumber++) {
					numbersToInsert.add(getPhoneNumberObj(blockAsset, String.valueOf(phoneNumber)));
				}
			}
		}

		insert numbersToInsert;
	}

	private static Asset getPhoneNumberObj(Asset nbAsset, String phoneNumber){
		Id phoneNumberRTId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Phone Number').getRecordTypeId();
		return new Asset(Status = nbAsset.Status, AccountId = nbAsset.AccountId, Name = phoneNumber, LG_PhoneNumber__c = phoneNumber,
						 LG_Asset__c = nbAsset.Id, RecordTypeId = phoneNumberRTId, LG_NumberRangeType__c = nbAsset.LG_NumberRangeType__c,
						 LG_TelephonyProductConfiguration__c = nbAsset.LG_TelephonyProductConfiguration__c,
						 LG_NumberRangeProductConfiguration__c = nbAsset.LG_NumberRangeProductConfiguration__c);
	}
    /**
     * If VPN Name/site address attributes changed update same on respective connection product and fields
     *
     * @param  Map<Id,cscfga__Attribute__c> mapAttrNew
     * @param  Map<Id, cscfga__Attribute__c> mapAttrOld
     *
     **/
    public static void AfterVPNSITEUpdateHandler(Map<id, cscfga__Attribute__c> mapAttrNew, Map<id, cscfga__Attribute__c> mapAttrOld) {
 
        Map<id, String> NameChangeToUpdate = new Map<id, String>();
        Map<id, String> VPnIDChangeToUpdate = new Map<id, String>();
        Map<String,String>  VPNpersistentIdPcNameMap = new Map<String,String>();
        Map<String,String>  SitepersistentIdPcNameMap = new Map<String,String>();
        Map<cscfga__Attribute__c, id> AttrPC = new Map<cscfga__Attribute__c, Id>();
        
        List<cscfga__Product_Configuration__c> pcNameTobeUpdated = new List<cscfga__Product_Configuration__c>();
        List<cscfga__Product_Configuration__c> vpnPCIDTobeUpdated = new List<cscfga__Product_Configuration__c>();
        
        String basketId;
    
        for(cscfga__Attribute__c attr : mapAttrNew.Values()){
            
            if(attr.name == 'VPN Name' && ( attr.cscfga__Value__c != mapAttrOld.get(attr.id).cscfga__Value__c )){
                
                AttrPC.put(attr, attr.cscfga__Product_Configuration__c);
            }
            else if((attr.name == 'Configuration Id') && ( attr.cscfga__Value__c != mapAttrOld.get(attr.id).cscfga__Value__c)){
                
                 AttrPC.put(attr, attr.cscfga__Product_Configuration__c);
            }
            else if((attr.Name == 'MLESiteAddress') && ( attr.cscfga__Value__c != mapAttrOld.get(attr.id).cscfga__Value__c )){
                
                AttrPC.put(attr, attr.cscfga__Product_Configuration__c);
            }
            
        }
        
        Map<id, cscfga__Product_Configuration__c> PCMap = new Map<id, cscfga__Product_Configuration__c>([select id,LG_ChangeType__c,LG_Persistent_Id__c , LG_ProductDefinitionName__c,cscfga__Product_Basket__r.Id from cscfga__Product_Configuration__c where id in :AttrPC.Values() ]);
        
        for(cscfga__Attribute__c attr : AttrPC.keySet()){
        
            if(attr.name == 'VPN Name' && (PCMap.get(attr.cscfga__Product_Configuration__c).LG_ProductDefinitionName__c == Label.VPN_services)){
                
                System.debug('Inside VPN Name change');
                NameChangeToUpdate.put( PCMap.get(attr.cscfga__Product_Configuration__c).id ,attr.cscfga__Value__c);
                basketId =PCMap.get(attr.cscfga__Product_Configuration__c).cscfga__Product_Basket__r.Id;
                VPNpersistentIdPcNameMap.put(PCMap.get(attr.cscfga__Product_Configuration__c).LG_Persistent_Id__c,attr.cscfga__Value__c);
            }
            else if( (PCMap.get(attr.cscfga__Product_Configuration__c).LG_ChangeType__c =='Move') && (PCMap.get(attr.cscfga__Product_Configuration__c).LG_ProductDefinitionName__c == Label.VPN_services) && (attr.name == 'Configuration Id') ){
                
                System.debug('Inside VPN Id change');
                VPnIDChangeToUpdate.put(PCMap.get(attr.cscfga__Product_Configuration__c).id ,attr.cscfga__Value__c);
            
            }
            else if( (PCMap.get(attr.cscfga__Product_Configuration__c).LG_ChangeType__c =='Move') && (PCMap.get(attr.cscfga__Product_Configuration__c).LG_ProductDefinitionName__c == Label.BDS_Site) && (attr.Name == 'MLESiteAddress')){
                
                System.debug('Inside site change');
                NameChangeToUpdate.put(PCMap.get(attr.cscfga__Product_Configuration__c).id ,attr.cscfga__Value__c);
                basketId = PCMap.get(attr.cscfga__Product_Configuration__c).cscfga__Product_Basket__r.Id;
                SitepersistentIdPcNameMap.put(PCMap.get(attr.cscfga__Product_Configuration__c).LG_Persistent_Id__c,attr.cscfga__Value__c);
            }
        
        }
         System.debug('NameChangeToUpdate ' +NameChangeToUpdate);
         System.debug('VPnIDChangeToUpdate ' +VPnIDChangeToUpdate);
         System.debug('SitepersistentIdPcNameMap ' +SitepersistentIdPcNameMap);
         
        if(!NameChangeToUpdate.isEmpty()){
        
            pcNameTobeUpdated.addAll([select id,Name,LG_CustomProductName__c,cscfga__Product_Definition__r.Name, LG_From_Configuration__c,LG_To_Configuration__c from cscfga__Product_Configuration__c where id in :NameChangeToUpdate.keySet() OR 
            (cscfga__Product_Definition__r.Name =:Label.Company_VPN_Connection AND cscfga__Product_Basket__c =:basketId AND (LG_From_Configuration__c In:VPNpersistentIdPcNameMap.keySet() OR LG_To_Configuration__c In:SitepersistentIdPcNameMap.keySet()))]);
            
            system.debug('A&A pcNameTobeUpdated' +pcNameTobeUpdated );
            for(cscfga__Product_Configuration__c pc: pcNameTobeUpdated){
                
                if ((pc.cscfga__Product_Definition__r.Name == Label.VPN_services) || (pc.cscfga__Product_Definition__r.Name == Label.BDS_Site)) {
                    pc.LG_CustomProductName__c = NameChangeToUpdate.get(pc.id);
                }
                else if (pc.cscfga__Product_Definition__r.Name == Label.Company_VPN_Connection) {
                    system.debug('A&A inside connection');
                    if( SitepersistentIdPcNameMap.get(pc.LG_To_Configuration__c)!=null){
                    
                        pc.name = SitepersistentIdPcNameMap.get(pc.LG_To_Configuration__c) + '-->'+ pc.name.substringAfter('-->');
                        pc.cscfga__Description__c = pc.name;
                        pc.cscfga__Configuration_Status__c = 'Valid'; system.debug('name' + pc.name+'::'+   pc.cscfga__Description__c);
                    }
                    else if(VPNpersistentIdPcNameMap.get(pc.LG_From_Configuration__c)!=null){
                    
                        pc.name =  pc.name.substringBeforeLast('-->') + '-->'+ VPNpersistentIdPcNameMap.get(pc.LG_From_Configuration__c);
                        pc.cscfga__Description__c = pc.name;
                        pc.Product_Group__c = VPNpersistentIdPcNameMap.get(pc.LG_From_Configuration__c);
                    
                    }
                    
                }
            
            }
            Database.update(pcNameTobeUpdated);
        
        }
        
        if(!VPnIDChangeToUpdate.isEmpty()){
        
            vpnPCIDTobeUpdated.addAll([select id,LG_From_Configuration__c from cscfga__Product_Configuration__c where id in :VPnIDChangeToUpdate.keySet()]);
            
            for(cscfga__Product_Configuration__c pc: vpnPCIDTobeUpdated){
            
                pc.LG_From_Configuration__c = pc.Id;
                
            }
            
            Database.update(vpnPCIDTobeUpdated);
            
        }   
     
     }
}