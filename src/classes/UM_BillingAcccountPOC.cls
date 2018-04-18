public with sharing class UM_BillingAcccountPOC {

	public String recordID {get;set;}
	public String returnURL {get;set;}

	public csconta__Billing_Account__c billingAccount {
		get{
			if(billingAccount == null){
				billingAccount = new csconta__Billing_Account__c();
			}

			return billingAccount;
		}
		set;
	}

    public UM_BillingAcccountPOC() {	    

	    returnURL = ApexPages.currentPage().getParameters().get('returnURL');
	    recordID = ApexPages.currentPage().getParameters().get('id');

	    if(String.isNotEmpty(recordID)) {

		    billingAccount = [SELECT Id, LG_Default__c, LG_BillingEmailAddress__c, LG_BankAccountHolder__c, LG_BankAccountNumberIBAN__c, LG_BillingAccountIdentifier__c, 
			    					UM_BankAccountType__c, LG_DeliveryMethod__c, LG_DirectDebitMandate__c, csconta__Billing_Channel__c, csconta__Status__c,	csconta__Account__c, 
			    					LG_CustomerReference__c, csconta__Financial_Account_Number__c, csconta__Payment_Terms__c, LG_MandateStartDate__c, LG_MandateEndDate__c,
			    					csconta__Street__c, LG_HouseNumber__c, LG_HouseNumberExtension__c, csconta__Postcode__c, csconta__City__c, csconta__Country__c
		    					FROM csconta__Billing_Account__c 
		    						WHERE Id=:recordID];
		}
    }

    public PageReference save() {

    	system.debug('--+ BA: '+billingAccount);

    	// list of records to check
    	List<sObject> recordsToCheck = new List<sObject>();
    	recordsToCheck.add( billingAccount );
  
  		// execute Iban validation 
		UM_ValidateIban.IBAN_Validation validateIban = new UM_ValidateIban.IBAN_Validation( recordsToCheck );		

		// check results and updsert records
		if(validateIban.validatedObjects[0].get('UM_IBANValidated__c') == true) {

			upsert validateIban.validatedObjects[0];

			// redirect to previous page if redirection URL
			// has been specified
			if(String.isNotEmpty(returnURL)) {

				PageReference pr = new PageReference( returnURL );
				pr.setRedirect(true);

				return pr;
			}

		} else {

			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, validateIban.listOfErrors.get( billingAccount.Id ) ) );
		}

		return null;
    }

	public PageReference cancel() {
    
    	return new PageReference(returnURL);
    }

}