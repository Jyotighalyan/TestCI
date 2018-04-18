/**
* Used for Opportunity validation
*
* @author Petar Miletic
* @ticket  & SFDT-271
* @since  14/03/2016
*/
public with sharing class LG_ValidateOppOrderTriggerHandler {

    public static void BeforeUpdateHandle(Map<Id, Opportunity> mapNew, Map<Id, Opportunity> mapOld) {

        ValidateTechicalContact(mapNew, mapOld);
        //ValidateAdminContact(mapNew, mapOld);
        CheckBillingAccountAssignment(mapNew,mapOld);
        
    }

    private static void ValidateAdminContact (Map<ID,Opportunity> mapNew, Map<ID, Opportunity> mapOld) {

        Map<Id, Opportunity> relevantOpportunities = new Map<Id, Opportunity>();
        for (Opportunity opp : mapNew.values()) {
            if (opp.StageName == 'Ready for Order' && mapOld.get(opp.Id).StageName != 'Ready for Order') {
                relevantOpportunities.put(opp.Id, opp);
            }
        }

        Map<ID, OpportunityContactRole> mapOppConRole = new Map<ID, OpportunityContactRole>();
        for(OpportunityContactRole loopVar : [Select OpportunityID, ContactID, Contact.Salutation,Contact.FirstName, Contact.Birthdate, Contact.Phone, Contact.MobilePhone, Contact.Email, Role from OpportunityContactRole where OpportunityID in : relevantOpportunities.keySet() and role = :Label.LG_AdministrativeContact]) {
            mapOppConRole.put(loopVar.OpportunityID, loopVar);
        }
        //Commented the following code as a part of US- UMR-169
       /* for(ID loopVar : relevantOpportunities.keySet()) {
            if(!mapOppConRole.keySet().contains(loopVar)) {
                relevantOpportunities.get(loopVar).addError(Label.LG_AdminContactMissing , false);
                break;
            } else if(mapOppConRole.get(loopVar).Contact.Salutation == null || mapOppConRole.get(loopVar).Contact.FirstName == null || mapOppConRole.get(loopVar).Contact.Birthdate == null || mapOppConRole.get(loopVar).Contact.Email == null || (mapOppConRole.get(loopVar).Contact.Phone == null && mapOppConRole.get(loopVar).Contact.MobilePhone == null) ) {
                relevantOpportunities.get(loopVar).addError(Label.LG_AdminContactIncomplete , false);
                break;
            }
        }*/
    }

    private static void ValidateTechicalContact(Map<Id, Opportunity> mapNew, Map<Id, Opportunity> mapOld) {

        String errorTemplate = '<p class="errorLine">â€¢&nbsp;{0}</p>';

        // Group Contacts per Opportunity Id
        Map<Id, ValidationHelper> opportunityContacts = new Map<Id, ValidationHelper>();
        Map<Id, Opportunity> relevantOpportunities = new Map<Id, Opportunity>();
        Set<Id> noTechicalContact = new Set<Id>();

        Set<Id> accountIds = new Set<Id>();

        // Create collection of relevant Opportunituies
        for (Opportunity opp : mapNew.values()) {

            if (opp.StageName == 'Ready for Order' && mapOld.get(opp.Id).StageName != 'Ready for Order') {
                relevantOpportunities.put(opp.Id, opp);
                accountIds.add(opp.AccountId);
            }
        }

        if (relevantOpportunities.size() > 0) {

            Set<Id> technicalContactIDs = new Set<Id>();

            Map<Id, cscfga__Product_Configuration__c> pcs = new Map<Id, cscfga__Product_Configuration__c>([SELECT
                                                                                                            Id,
                                                                                                            Name,
                                                                                                            cscfga__Product_Basket__c,
                                                                                                            LG_Address__r.Id,
                                                                                                            cscfga__Product_Basket__r.cscfga__Opportunity__c,
                                                                                                            cscfga__Product_Basket__r.csordtelcoa__Synchronised_with_Opportunity__c,
                                                                                                            LG_Address__r.LG_TechnicalContact__c,
                                                                                                            LG_InstallationWishDate__c,
                                                                                                            LG_InstallationPlannedDate__c,
                                                                                                            LG_InstallationNeeded__c
                                                                                                            FROM cscfga__Product_Configuration__c
                                                                                                            WHERE cscfga__Product_Basket__r.cscfga__Opportunity__c IN :relevantOpportunities.keySet()]);

            List<csconta__Billing_Account__c> billingAccounts = [SELECT Id, Name, csconta__Account__c FROM csconta__Billing_Account__c WHERE csconta__Account__c IN :accountIds];

            // One Opportunities had one ValidatiorHelper class. If one of PC is invalid then the entire Opportunity is invalid
            // For multiple Product Configurations update validator values by calling CompareAndUpdate method
            for (cscfga__Product_Configuration__c pc :pcs.values()) {

                ValidationHelper temp;

                // Check if opportunity exists. If so append data to already existing ID set
                if (opportunityContacts.containsKey(pc.cscfga__Product_Basket__r.cscfga__Opportunity__c)) {

                    temp = opportunityContacts.get(pc.cscfga__Product_Basket__r.cscfga__Opportunity__c);
                    temp.CompareAndUpdate(pc);
                }
                else {

                    temp = new ValidationHelper(pc);
                    opportunityContacts.put(pc.cscfga__Product_Basket__r.cscfga__Opportunity__c, temp);
                }

                technicalContactIDs.addAll(temp.GetTechnicalContactIDs());
            }

            Map<Id, Contact> contacts = new Map<Id, Contact>([SELECT Id, Name, MobilePhone, Email, FirstName, LastName, Salutation, cscrm__Address__c, LG_Role__c FROM Contact WHERE Id IN :technicalContactIDs]);

            for (Opportunity o :relevantOpportunities.values()) {

                if (!CheckBillingAccount(o.AccountId, billingAccounts)) {
                    o.addError(String.format(errorTemplate, new List<string> { Label.LG_NoBillingAccount }), false);
                    continue;
                }

                ValidationHelper validator = opportunityContacts.get(o.Id);

                if (validator == null) {
                    o.addError(String.format(errorTemplate, new List<string> { Label.LG_ProductConfMissing }), false);
                    continue;
                }

                // Check if Opportunity is synced
                System.debug('*** validator='+validator);
                if (!validator.ValidateSync()) {
                    o.addError(Label.LG_SynchronizedProductBasketNeeded);
                    continue;
                }

                string errorMessage = '';

                // SFDT-648 - Not needed
                // if (!validator.ValidateInstallationPlannedDate()) {
                //    errorMessage += String.format(errorTemplate, new List<string> { 'Some Product Configurations have invalid installation date' });
                //}

                if (!validator.ValidateInstallationWishDate()) {
                    errorMessage += String.format(errorTemplate, new List<string> { Label.LG_InvalidTimeSlot });
                }

                // Check if technical contact exists
                if (!validator.ValidateTechnicalContacts()) {
                    errorMessage += String.format(errorTemplate, new List<string> { Label.LG_UndefinedTechContact });
                }

                if (errorMessage.length() > 0) {
                    o.addError(errorMessage, false);
                    continue;
                }

                // For each contact that belongs to current opportunity
                for (ID contactId :validator.GetTechnicalContactIDs()) {

                    Contact c = contacts.get(contactId);

                    if (c == null) {
                        continue;
                    }

                   /* if (c.MobilePhone == null) {
                        errorMessage += String.format(errorTemplate, new List<string> { String.format(Label.LG_MissingContactInformation, new List<String> {Schema.sObjectType.Contact.fields.MobilePhone.getLabel(), 'Technical Contact'})});
                    }*/

                    if (c.Email == null) {
                        errorMessage += String.format(errorTemplate, new List<string> { String.format(Label.LG_MissingContactInformation, new List<String> {Schema.sObjectType.Contact.fields.Email.getLabel(), 'Technical Contact'})});
                    }

                    if (c.FirstName == null) {
                        errorMessage += String.format(errorTemplate, new List<string> { String.format(Label.LG_MissingContactInformation, new List<String> {Schema.sObjectType.Contact.fields.FirstName.getLabel(), 'Technical Contact'})});
                    }

                    // Last Name is required, no need for checking

                    if (c.Salutation == null) {
                        errorMessage += String.format(errorTemplate, new List<string> { String.format(Label.LG_MissingContactInformation, new List<String> {Schema.sObjectType.Contact.fields.Salutation.getLabel(), 'Technical Contact'})});
                    }

                    if (errorMessage.length() > 0) {
                        o.addError(errorMessage, false);
                        break;
                    }
                }
            }
        }
    }

    private static Boolean CheckBillingAccount(Id accountId, List<csconta__Billing_Account__c> billingAccounts) {

        Boolean retval = false;

        for (csconta__Billing_Account__c a :billingAccounts) {

            if (a.csconta__Account__c == accountId) {
                retval = true;
                break;
            }
        }

        return retval;
    }

    private static void CheckBillingAccountAssignment(Map<Id, Opportunity> mapNew , Map<id,Opportunity> mapOld){
        String errorTemplate = '<p class="errorLine">â€¢&nbsp;{0}</p>';
        set<id> changedOpportunities = new set<id>();

        for(Opportunity op : mapNew.values()){
            if(op.StageName == 'Ready for Order' && mapOld.get(op.id).StageName != 'Ready for Order')
                changedOpportunities.add(op.id);
        }
        
        if(!changedOpportunities.isEmpty()){
            list<cscfga__Product_Configuration__c> productConfigList = [select id, cscfga__Product_Basket__r.cscfga__Opportunity__c  from cscfga__Product_Configuration__c
                                                            where cscfga__Product_Basket__r.cscfga__Opportunity__c in :changedOpportunities
                                                            	AND LG_Billing_Account__c = null
                                                                AND cscfga__Parent_Configuration__c = null
                                                            	AND cscfga__Product_Basket__r.csbb__Synchronised_With_Opportunity__c = true
                                                            ];
            for(cscfga__Product_Configuration__c config : productConfigList){
                if((mapNew.get(config.cscfga__Product_Basket__r.cscfga__Opportunity__c).StageName == 'Ready for Order') &&
                   (mapOld.get(config.cscfga__Product_Basket__r.cscfga__Opportunity__c).StageName != 'Ready for Order')
                  )
                    mapNew.get(config.cscfga__Product_Basket__r.cscfga__Opportunity__c).addError(String.format(errorTemplate, new List<string> { Label.UM_Missing_BillingAccount}), false);
            }
        }
    }

    // Helper class for Opportunity validation
    // One ValidatiorHelper coresponds to one Opportunity
    //
    // ValidateHeper is used for every Product Configuration, on first iteration use
    // Constructor and for each subsequent one use CompareAndUpdate to test and set values
    private class ValidationHelper {

        // Private properties
        private Set<Id> TechnicalContactIDs = new Set<Id>();
        private Boolean AreTechnicalContactsValid { get; set; }
        private Boolean IsOpportunitySynced { get; set; }

        // SFDT-648 - Not needed
        //private Boolean AreInstallationPlannedDateSet { get; set; }

        private Boolean AreInstallationWishDateSet { get; set; }

        public Set<Id> GetTechnicalContactIDs() {
            return this.TechnicalContactIDs;
        }

        public Boolean ValidateTechnicalContacts() {
            return this.AreTechnicalContactsValid;
        }

        public Boolean ValidateSync() {
            return this.IsOpportunitySynced;
        }

        //private Boolean ValidateInstallationPlannedDate() {
        //    return this.AreInstallationPlannedDateSet;
        //}

        private Boolean ValidateInstallationWishDate() {
            return this.AreInstallationWishDateSet;
        }

        // Constructor
        public ValidationHelper(cscfga__Product_Configuration__c pc) {

            this.AreTechnicalContactsValid = true;
            this.IsOpportunitySynced = false;
            //this.AreInstallationPlannedDateSet = true;
            this.AreInstallationWishDateSet = true;

            SetUpData(pc);
        }

        // Compare and update current data (when looping trough Product Configuration List)
        public void CompareAndUpdate(cscfga__Product_Configuration__c pc) {

            SetUpData(pc);
        }

        private void SetUpData(cscfga__Product_Configuration__c pc) {

            // Mark Opportunity as synced
            if (pc.cscfga__Product_Basket__r.csordtelcoa__Synchronised_with_Opportunity__c == true) {
                IsOpportunitySynced = true;
            }

            if (pc.LG_Address__c != null) {

                if (pc.LG_Address__r.LG_TechnicalContact__c != null) {
                    this.TechnicalContactIDs.add(pc.LG_Address__r.LG_TechnicalContact__c);
                }
                else if (pc.LG_Address__r.LG_TechnicalContact__c == null) {
                    this.AreTechnicalContactsValid = false;
                }

                //if (pc.LG_InstallationNeeded__c && pc.LG_InstallationPlannedDate__c == null) {
                //    this.AreInstallationPlannedDateSet = false;
                //}

                if (pc.LG_InstallationNeeded__c && pc.LG_InstallationWishDate__c == null) {
                    this.AreInstallationWishDateSet = false;
                }
            }
        }
    }
}