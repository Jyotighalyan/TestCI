public with sharing class UM_BillingAccountController {

    public String recordID {get;set;}
    public String returnURL {get;set;}
    public String aId {get;set;}
    public Boolean validateIbanNumber {get;set;}

    public csconta__Billing_Account__c billingAccount {
        get{
            if(billingAccount == null){
                billingAccount = new csconta__Billing_Account__c();
            }

            return billingAccount;
        }
        set;
    }

    public UM_BillingAccountController() {        
		validateIbanNumber=false;
        returnURL = ApexPages.currentPage().getParameters().get('retURL');
        recordID = ApexPages.currentPage().getParameters().get('id');
        aId = ApexPages.currentPage().getParameters().get('aId');

        //system.debug('--+ returnUrl: '+returnURL);
        //system.debug('--+ required IBAN: '+validateIbanNumber);        

        if(String.isNotEmpty(recordID)) {

            billingAccount = [SELECT Id, Name, LG_Default__c, LG_BillingEmailAddress__c, LG_BankAccountHolder__c, LG_BankAccountNumberIBAN__c, LG_BillingAccountIdentifier__c, LG_PaymentType__c, UM_Billing_State_Province__c,
                                    UM_BankAccountType__c, LG_DeliveryMethod__c, LG_DirectDebitMandate__c, csconta__Billing_Channel__c, csconta__Status__c, csconta__Account__c, Billing_Contact__c,
                                    LG_CustomerReference__c, csconta__Financial_Account_Number__c, csconta__Payment_Terms__c, LG_MandateStartDate__c, LG_MandateEndDate__c,
                                    csconta__Street__c, LG_HouseNumber__c, LG_HouseNumberExtension__c, csconta__Postcode__c, csconta__City__c, csconta__Country__c, UM_Collection_Hold_Reason__c,
                                    UM_Collection_Hold_Remaining_Days__c, UM_Collection_Reason_Change_Date__c, Picklist_request__c, LG_ContractualOrganization__c, UM_BillFormatOptions__c, Comments__c,
                                    UM_BankAccountNumberBic__c
                                FROM csconta__Billing_Account__c 
                                    WHERE Id=:recordID];
            //system.debug('--+ ba: '+billingAccount);
        }

        if(String.isNotEmpty(aId)) {

            billingAccount.csconta__Account__c = aId;
        }
    }

    public PageReference save() {

        if(validateIbanNumber == true) {

            // list of records to check
            List<sObject> recordsToCheck = new List<sObject>();
            recordsToCheck.add( billingAccount );

            // execute Iban validation 
            UM_ValidateIban.IBAN_Validation validateIban = new UM_ValidateIban.IBAN_Validation( recordsToCheck );       

            // check results and updsert records
            if(validateIban.validatedObjects[0].get('UM_IBANValidated__c') == true) {

                try {

                    //if(validateIban.bic != null) { 
                        //validateIban.validatedObjects[0].put( 'Bank_account_BIC_code__c',validateIban.bic ); 
                    //}
        
                    upsert validateIban.validatedObjects[0];

                    // redirect to previous page if redirection URL
                    // has been specified
                    if(String.isNotEmpty(returnURL)) {

                        return goToPreviousPage(returnURL);
                    }

                } catch(DmlException e) {
                    ApexPages.addMessages(e);
                }


            } else {

                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, validateIban.listOfErrors.get( billingAccount.Id ) ) );
            }
        } else {

            try {

                upsert billingAccount;

                if(String.isNotEmpty(returnURL)) {

                    return goToPreviousPage(returnURL);
                }

            } catch(DmlException e) {

                ApexPages.addMessages(e);
            }           
        }

        return null;
    }

    public PageReference goToPreviousPage(String rURL){
        
        PageReference pr = new PageReference( rURL );
        pr.setRedirect(true);

        return pr;
    }

    public PageReference cancel() {
    
        return new PageReference(returnURL);
    }

}