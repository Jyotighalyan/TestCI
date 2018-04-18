public with sharing class LG_SConsoleBillingAccDetailsExtension extends LG_ServiceConsoleBase {
    
    private final csconta__Billing_Account__c bilingAccount { get; set; }
    
    private csconta__Billing_Account__c billingAccountDetail { get; set; }
    
    public csconta__Billing_Account__c getbillingAccountDetail(){
        if (this.billingAccountDetail == null) {
            this.billingAccountDetail = getbillingAccountDetailRecords();
        }
        
        return this.billingAccountDetail;
    }
    
    
    
    public LG_SConsoleBillingAccDetailsExtension (ApexPages.StandardController Controller) {
        if(!Test.isRunningTest()){
            List<String> defaultFields = new List<String>();
            
            defaultFields.add('Name');
            defaultFields.add('LG_BillingAccountName__c');
            defaultFields.add('LG_PaymentType__c');
            defaultFields.add('LG_BillingContact__c');
            defaultFields.add('csconta__Address__c');
            defaultFields.add('LG_ExternalId__c');
            defaultFields.add('ADDTTURL__c');
            Controller.addFields(defaultFields);
            this.bilingAccount = (csconta__Billing_Account__c)Controller.getRecord();
            
            System.debug('testing');
            System.debug('order'+this.bilingAccount.Id);
            System.debug('getServiceRecord'+this.bilingAccount);
        }
        else{
            this.bilingAccount = [select Name,LG_BillingAccountName__c,LG_PaymentType__c,LG_BillingContact__c,csconta__Address__c,LG_ExternalId__c,ADDTTURL__c from csconta__Billing_Account__c LIMIT 1];
        }
    }
    
    public csconta__Billing_Account__c getbillingAccountDetailRecords(){
        csconta__Billing_Account__c billingDetail = [SELECT Id,Name,LG_BillingAccountName__c,LG_PaymentType__c, csconta__Override_Account_Address__c, 
                                                     LG_BillingContact__c,csconta__Address__c,LG_ExternalId__c,ADDTTURL__c, PaymentMethods__c,
                                                     csconta__Street__c, csconta__Postcode__c, csconta__City__c,  
                                                     csconta__Account__c,csconta__Account__r.Name,csconta__Account__r.BillingAddress,
                                                     csconta__Account__r.LG_CustomAccountNumber__c,
                                                     csconta__Account__r.BillingStreet, csconta__Account__r.BillingPostalCode, csconta__Account__r.BillingCity, 
                                                     LG_FirstName__c, LG_LastName__c, LG_Billing_Contact_FirstName__c, LG_Billing_Contact_LastName__c,
                                                     LG_Override_Billing_Contact__c, LG_ExternalSystem__c FROM csconta__Billing_Account__c 
                                                     where Id=:this.bilingAccount.Id];
        
        return billingDetail;
    }
    
    /*
* Page methods
*/
    public PageReference edit() {
        
        setMode(DisplayMode.edit);
        return null;
    }
    
    public PageReference save() {
        
        try{
            
            if((this.billingAccountDetail.LG_ExternalSystem__c == 'ICOMS' || this.billingAccountDetail.LG_ExternalSystem__c == 'RBM') && this.billingAccountDetail.LG_ExternalId__c == null)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'ICOMS Account number should be in [2 digits] - [9 digits] format and RBM Account number should contain numeric digits'));
                return null;                
            } else {
                update this.billingAccountDetail;
       		}
      
      
        } Catch (DMLException e)   {
       		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getDmlMessage(0)));
        }
        setMode(DisplayMode.detail);
        return null;
    }
    
    public PageReference cancel() {
        
        setMode(DisplayMode.detail);
        return null;
    }
    
    
}