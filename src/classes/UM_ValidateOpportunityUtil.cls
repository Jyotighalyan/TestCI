/**
* 
* Class is used implement UM related opportunity validations part of SFOM-669
    *One synchronized Product Basket is required.
    *The required fields for the related Account: Segment
    *The required fields for all related Contacts: Mobile or Phone Number
    *The required fields for related Technical Contacts: Email, Salutation, FirstName, LastName
   *@author Alisha
* @since  1/05/2017
*
*/

public class UM_ValidateOpportunityUtil extends LG_ValidateOpportunityUtil{
 public boolean DDmandateMandatory{get;set;}
 public String paymentType{get;set;}
 public String quoteStatus{get;set;}

 public override Boolean ValidateOpportunityUtil(Opportunity OppObj) {
     Boolean isValidOpp = true;
     Boolean isValidDDMandate= true;
     Boolean isValidEmailCheck = true;
     Boolean hasPrimaryContact= true;
     
     LG_Submit_Order_Validations_On_Off__c  submittingUser = LG_Submit_Order_Validations_On_Off__c.getInstance(UserInfo.getUserId());
        if(submittingUser.Method_Name__c.contains('ValidateOpportunity')&& submittingUser.Flag__c){
           isValidOpp = ValidateOpportunity(OppObj);
           }
        if(submittingUser.Method_Name__c.contains('DDmandateCheck')&& submittingUser.Flag__c){
            String dm=DDmandateCheck(OppObj);
            if(dm=='Pass')
            isValidDDMandate =true;
           }
        if(submittingUser.Method_Name__c.contains('checkSendViaEmail')&& submittingUser.Flag__c){
            isValidEmailCheck = checkSendViaEmail(OppObj);
           }
         if(submittingUser.Method_Name__c.contains('validatePrimaryContact')&& submittingUser.Flag__c){
            hasPrimaryContact = validatePrimaryContact(OppObj);
           }
           
     return isValidOpp && isValidDDMandate && isValidEmailCheck && hasPrimaryContact;
    }

    public override Integer servicecasecheck(Id recId){
        Integer sccheck=0;
        return sccheck;
    }
    
    Public override Integer SCCategorycheck(Id recId){
        Integer sccatecheck=0;
        return sccatecheck;}
    
    public override list<case> getSCCase(Id recId){
        list<case> sclist=new list<case>();return sclist;}
    
    public  Boolean checkSendViaEmail(Opportunity OppObj ){
        List<csconta__Billing_Account__c>  billAccList = [SELECT id,LG_PaymentType__c,LG_BillingEmailAddress__c ,           LG_PaperDDMandate__c,LG_DeliveryMethod__c from csconta__Billing_Account__c where Opportunity__c =:OppObj.id ];
        for(csconta__Billing_Account__c b: billAccList){
            if(b.LG_DeliveryMethod__c=='Email' && b.LG_BillingEmailAddress__c==null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Email address is mandatory as Send invoice is via email '));
                return false;
            }
        }
        return true;
    }
    
    
    //Method to check Quote status flag
   
    
   public override Integer checkProductBasket(Id recId){
       Integer prodBasketCount=1; 
       prodBasketCount=[select count() from cscfga__Product_Basket__c where cscfga__Opportunity__c=:recId ];
       
       
      
       return prodBasketCount;

    }

    public override  String DDmandateCheck(Opportunity OppObj){
    
        //added for omb-601
        List<cscfga__Product_Configuration__c> prodConfList = new  List<cscfga__Product_Configuration__c>();
        set<id> billingAcctId=new set<id>();
        
        prodConfList =[SELECT Id,name, LG_Address__r.LG_TechnicalContact__c,LG_BillingAccount__c,LG_Billing_Account__c, LG_Address__r.LG_TechnicalContact__r.Name FROM cscfga__Product_Configuration__c 
                          WHERE cscfga__Product_Basket__r.cscfga__Opportunity__c =:OppObj.id];
        
        if(prodConfList.size()>0)
        {
            for(cscfga__Product_Configuration__c pc: prodConfList )
            {system.debug('**pcname'+pc.name);
                billingAcctId.add(pc.LG_Billing_Account__c);
        
            }   
        }
        system.debug('**billingAcctId'+billingAcctId); 
        
        List <csconta__Billing_Account__c> baList= [SELECT id,Name ,LG_PaymentType__c, UM_IBANValidated__c, (SELECT customer_signature__c FROM Mandates__r) FROM csconta__Billing_Account__c where id in :billingAcctId ];
        Integer count=0;
        system.debug('balist=='+baList);
        List<String> payList=new List<String>();
         for(csconta__Billing_Account__c a:baList){
             if( a.LG_PaymentType__c=='Direct Debit'){
                payList.add(a.LG_PaymentType__c);
           }
            }
            system.debug('payList=='+payList);
        if(!baList.isEmpty()){ 
            for(csconta__Billing_Account__c a:baList){
                if(!payList.isEmpty()){
                if(  a.LG_PaymentType__c=='Direct Debit'){
                    if(a.mandates__r.size()==0){
                    paymentType='Fail';
                        }else{
                            paymentType= a.UM_IBANValidated__c == true ? 'Pass':'Fail';
                }  
                        //Removed as a part of OMB-867
                        /*else if(a.mandates__r.size()!=0)
                         {         
                                           for(mandate__c m:a.mandates__r)
                            {
                                if(m.customer_signature__c==false)
                        {
                                             paymentType='Fail';

                            }
                            else
                             paymentType='Pass';

                        }
                                    }*/
                     }
                    
          }
                   else{
                      paymentType='N/A';
                       }

             }  
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please add a billing account record' ));
        }
        system.debug('count=='+count);  
        return paymentType;  
    }
 
    public Boolean ValidateOpportunity( Opportunity OppObj) {
        
        String errorTemplate = '�{0}';
        String errorMsg='';
        Boolean isValidOpp = true;
        // Group Contacts per Opportunity Id
        Map<Id, ValidationHelper> opportunityContacts = new Map<Id, ValidationHelper>();
        Map<Id, Opportunity> relevantOpportunities    = new Map<Id, Opportunity>();
        Set<Id> noTechicalContact                     = new Set<Id>();
        
        Set<Id> accountIds = new Set<Id>();
        
        relevantOpportunities.put(OppObj.Id, oppObj);
        accountIds.add(oppObj.AccountId);
        
        system.debug('initial queries'+Limits.getQueries());
        if (relevantOpportunities.size() > 0) {
            
            // Get all attributes for Billing Account validation
            List<cscfga__Attribute_Field__c> attributeFields = [SELECT Id, Name, cscfga__Attribute__c, cscfga__Attribute__r.cscfga__Product_Configuration__r.cscfga__Product_Basket__c, cscfga__Value__c,
                                                                cscfga__Attribute__r.cscfga__Product_Configuration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c
                                                                FROM cscfga__Attribute_Field__c
                                                                WHERE Name = 'BillingAccount' AND
                                                                cscfga__Attribute__r.cscfga__Product_Configuration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c =:oppObj.id
                                                                AND cscfga__Attribute__r.cscfga__Is_Line_Item__c = true
                                                                AND cscfga__Attribute__r.cscfga__Product_Configuration__r.cscfga__Product_Basket__r.csordtelcoa__Synchronised_with_Opportunity__c = true];
            // AND cscfga__Attribute__r.cscfga__Product_Configuration__r.cscfga__Parent_Configuration__c = NULL
            
            
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
                                                                                                           WHERE cscfga__Product_Basket__r.cscfga__Opportunity__c =:oppObj.id AND
                                                                                                           cscfga__Product_Basket__r.csordtelcoa__Synchronised_with_Opportunity__c = true]);
            
            // One Opportunities had one ValidatiorHelper class. If one of PC is invalid then the entire Opportunity is invalid
            // For multiple Product Configurations update validator values by calling CompareAndUpdate method
            for (cscfga__Product_Configuration__c pc :pcs.values()) {
                
                ValidationHelper temp;
                
                // Check if opportunity exists. If so append data to already existing ID set
                if (opportunityContacts.containsKey(pc.cscfga__Product_Basket__r.cscfga__Opportunity__c)) {
                    
                    temp = opportunityContacts.get(pc.cscfga__Product_Basket__r.cscfga__Opportunity__c);
                    temp.CompareAndUpdate(pc);
                } else {
                    
                    temp = new ValidationHelper(pc);
                    opportunityContacts.put(pc.cscfga__Product_Basket__r.cscfga__Opportunity__c, temp);
                }
                
                technicalContactIDs.addAll(temp.GetTechnicalContactIDs());
            }
            
            Map<Id, Contact> contacts = new Map<Id, Contact>([SELECT Id, Name, Phone, MobilePhone, Email, FirstName, LastName, Salutation, cscrm__Address__c, LG_Role__c FROM Contact WHERE Id IN:technicalContactIDs]);
            String errorMessage='';
            
            for (Opportunity o :relevantOpportunities.values()) {
                
                ValidationHelper validator = opportunityContacts.get(o.Id);
                if (validator == null) {
                    // o.addError(String.format(errorTemplate, new List<string> { 'Product Configurations are missing' }), false);
                    //errorMsg=String.format(errorTemplate, new List<string> { 'Product Configurations are missing' });
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Product Configurations are missing' ));
                    isValidOpp = false;
                }
                
                // Check if Opportunity is synced
                else {
                    if (!validator.ValidateSync()) {
                        errorMsg=Label.LG_SynchronizedProductBasketNeeded;
                        o.addError(Label.LG_SynchronizedProductBasketNeeded);
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, errorMsg));
                        isValidOpp = false;
                    }
                    
                    else if (!CheckBillingAccount(o.Id, attributeFields)) {
                        // o.addError(String.format(errorTemplate, new List<string> { 'Billing Account has not been assigned to the Line Items' }), false);
                        // errorMsg=String.format(errorTemplate, new List<string> { 'Billing Account has not been assigned to the Line Items' });
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Billing Account has not been assigned to the Line Items'));
                        isValidOpp = false;
                    }
                    
                    // SFDT-648 - Not needed
                    // if (!validator.ValidateInstallationPlannedDate()) {
                    //    errorMessage += String.format(errorTemplate, new List<string> { 'Some Product Configurations have invalid installation date' });
                    //}
                    
                    if (!validator.ValidateInstallationWishDate()) {
                       // errorMessage += String.format(errorTemplate, new List<string> { 'Some Product Configurations are missing the preferred wish date });
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Some Product Configurations are missing the preferred wish date'));
                        isValidOpp = false;
                    }
                    
                    
                    /**
                    * technical contacts validations 
                    *as part of sfom-669
                    *they are  part of UM validations
                    **/
                    // Check if technical contact exists
                    if (!validator.ValidateTechnicalContacts()) {
                        //errorMessage += String.format(errorTemplate, new List<string> { 'Some Premisses have undefined Technical Contact' });
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Some Premisses have undefined Technical Contact'));
                        isValidOpp = false;
                    }
                    
                    /*if (errorMessage.length() > 0) {
                        o.addError(errorMessage, false);
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, errorMessage));
                        isValidOpp = false;
                        break;
                    }*/
                    
                    // For each contact that belongs to current opportunity
                    for (ID contactId :validator.GetTechnicalContactIDs()) {
                        
                        Contact c = contacts.get(contactId);
                        
                        if (c == null) {
                            continue;
                        }
                        
                        if (c.MobilePhone == null && c.Phone == null) {
                            errorMessage += String.format(errorTemplate, new List<string> { String.format(Label.LG_MissingContactInformation, new List<String> {Schema.sObjectType.Contact.fields.MobilePhone.getLabel() + ' or ' + Schema.sObjectType.Contact.fields.Phone.getLabel(), 'Technical Contact'})});
                        }
                        
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
                            system.debug('errorMessage=='+errorMessage);
                            isValidOpp = false;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, errorMessage));
                            
                        }
                    }
                    
                }
            }
        }
        return isValidOpp;
    }

  /**
   * Check Billing Account for Opportunity Sync Basket
   *
   * @author Petar Miletic
   * @ticket SFDT-958
   * @since 18/05/2016
   */
  private  Boolean CheckBillingAccount(Id opportunityId, List<cscfga__Attribute_Field__c> attributeFields) {

    Boolean valExist = true;
    Boolean oppExist = false;

    for (cscfga__Attribute_Field__c a :attributeFields) {

      if (a.cscfga__Attribute__r.cscfga__Product_Configuration__r.cscfga__Product_Basket__r.cscfga__Opportunity__c == opportunityId) {

        oppExist = true;

        if (String.isBlank(a.cscfga__Value__c)) {
          valExist = false;
        }
      }
    }

    // Both conditions need to verify in order to validate
    return oppExist && valExist;
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
      this.IsOpportunitySynced       = false;
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

      /*
       * If Address exists and Installation is needed populate
       * Technical Contact and Installation Wish Date
       * If not required field can be omitted
       */
      if (pc.LG_Address__c != null && pc.LG_InstallationNeeded__c) {

        if (pc.LG_Address__r.LG_TechnicalContact__c != null) {
          this.TechnicalContactIDs.add(pc.LG_Address__r.LG_TechnicalContact__c);
          
        } else if (pc.LG_Address__r.LG_TechnicalContact__c == null)   {
          this.AreTechnicalContactsValid = false;
        }

       if (pc.LG_InstallationWishDate__c == null) {
          this.AreInstallationWishDateSet = false;
        }
      }
    }
  }
  
  public  override Boolean ValidateAdminContact(Opportunity OppObj){
  return null;
  }
    
  public override Boolean validatePrimaryContact(Opportunity OppObj){
  
      List<OpportunityContactRole> ocr = [SELECT id, contactid, Opportunityid, role, isprimary, createddate FROM OpportunityContactRole WHERE opportunityid = :OppObj.id AND isprimary = true];
       system.debug('ocr=='+ocr);
       if (ocr.isEmpty()) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please add a primary contact' ));
             return false;
       } else {
        system.debug('it has primary contact');
        return true;
                }
  }
    
}