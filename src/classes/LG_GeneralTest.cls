@isTest
public class LG_GeneralTest {

    public static void setupServiceRequestUrls() {

        LG_ServiceRequestUrl__c req = new LG_ServiceRequestUrl__c();
        
      req.LG_AddressCheck__c = 'LG_OracleAccessGateway/peal/api/b2b/addresses?cty=NL&chl=B2B_CATALYST_NL';
      req.LG_AvailabilityCheck__c = 'LG_OracleAccessGateway/peal/api/b2b/addresses/{addressId}/details?cty=NL&chl=B2B_CATALYST_NL';
      req.LG_LocalizationClass__c = 'ZG_EndpointResolver';
        
        insert req;
    }
    //create Account
    
    public static Account CreateAccount(String name, String chamberofCommerceNumber, String footprint, Boolean insertAccount)
    {
        Account account = new Account(Name = name, LG_ChamberOfCommerceNumber__c = chamberofCommerceNumber,
                                        LG_Footprint__c = footprint);
        
        if (insertAccount)
        {
            insert account;
        }
        
        return account;
    }
    
    public static Account CreateAccount(string AccountName, string Type, string Segment, integer NumberOfEmployees, 
        string LeadStatus, string Phone, string ChamberofCommerceNumber, string FootPrint, string VisitStreet, string VisitHouseNumber, 
        string VisitHouseNumberExtension, string VisitPostalCode, string VisitCity, string VisitCountry,  Boolean WithInsert)
    {
        Account tmpAccount = new Account(Name = AccountName);
        tmpAccount.Type=Type;
        tmpAccount.LG_Segment__c=Segment;
        tmpAccount.NumberOfEmployees=NumberOfEmployees;
        tmpAccount.LG_AccountLeadStatus__c=LeadStatus;
        tmpAccount.Phone=Phone;
        tmpAccount.LG_ChamberOfCommerceNumber__c=ChamberofCommerceNumber;
        tmpAccount.LG_Footprint__c=FootPrint;
        tmpAccount.LG_VisitStreet__c=VisitStreet;
        tmpAccount.LG_VisitHouseNumber__c=VisitHouseNumber;
        tmpAccount.LG_VisitHouseNumberExtension__c=VisitHouseNumberExtension;
        tmpAccount.LG_VisitPostalCode__c=VisitPostalCode;
        tmpAccount.LG_VisitCity__c=VisitCity;
        tmpAccount.LG_VisitCountry__c=VisitCountry;
        
        if (WithInsert) insert tmpAccount;
        
        return tmpAccount;
    }
    
    public static Account CreateAccount(string AccountName, string Type, string Segment, integer NumberOfEmployees, 
        string LeadStatus, string Phone, string ChamberofCommerceNumber, string FootPrint, string VisitStreet, string VisitHouseNumber, 
        string VisitHouseNumberExtension, string VisitPostalCode, string VisitCity, string VisitCountry)
    {
        return CreateAccount(AccountName, Type, Segment, NumberOfEmployees, 
        LeadStatus, Phone, ChamberofCommerceNumber, FootPrint, VisitStreet, VisitHouseNumber, 
        VisitHouseNumberExtension, VisitPostalCode, VisitCity, VisitCountry,true);
    }
    
    public static Lead CreateLead(string Company, string Email, string Salutation, string FirstName, string LastName, string MiddleName, 
        string Mobile, string Phone, string LeadStatus, string ChamberofCommerceNumber, string ReadyforService, Boolean EconomicallyActive, 
        Boolean CommerciallyActive, integer NumberofDesktops, integer NumberofLaptops, string CreditRisk, string VisitStreet, string VisitHouseNumber, 
        string VisitHouseNumberExtension, string VisitPostalCode, string VisitCity, string VisitCountry, Boolean WithInsert)
    { 
        Lead tmpLead=new Lead();
        Account DummyPartnerAccount=createPartnerAccount();
        tmpLead.Company=Company;
        tmpLead.Email=Email;
        tmpLead.Salutation=Salutation;
        tmpLead.FirstName=FirstName;
        tmpLead.MiddleName=MiddleName;
        tmpLead.LastName=LastName;
        tmpLead.MobilePhone=Mobile;
        tmpLead.Phone=Phone;
        tmpLead.Status=LeadStatus;
        tmpLead.LG_ChamberOfCommerceNumber__c=ChamberofCommerceNumber;
        tmpLead.LG_ReadyForService__c=ReadyforService;
        tmpLead.LG_EconomicallyActive__c=EconomicallyActive;
        tmpLead.LG_CommerciallyActive__c=CommerciallyActive;
        tmpLead.LG_NumberOfDesktops__c=NumberofDesktops;
        tmpLead.LG_NumberOfLaptops__c=NumberofLaptops;
        tmpLead.LG_CreditRisk__c=CreditRisk;
        tmpLead.LG_VisitStreet__c=VisitStreet;
        tmpLead.LG_VisitHouseNumber__c=VisitHouseNumber;
        tmpLead.LG_VisitHouseNumberExtension__c=VisitHouseNumberExtension;
        tmpLead.LG_VisitPostalCode__c=VisitPostalCode;
        tmpLead.LG_VisitCity__c=VisitCity;
        tmpLead.LG_VisitCountry__c=VisitCountry;
        tmpLead.UM_PartnerAccount__c=DummyPartnerAccount.Id;
    
             /*** Added mandatory lead adress fields to pass existing validation rule 
                on 17/2/2017 as part of test class fix
           ***/
        tmpLead.Street = VisitStreet;        
        tmpLead.City = VisitCity;
        tmpLead.Country = VisitCountry;
        tmpLead.PostalCode = VisitPostalCode; 
        
        
        if (WithInsert) insert tmpLead;
        
        return tmpLead;
    }


 public static Lead CreateLead(string Company, string Email, string Salutation, string FirstName, string LastName, string MiddleName, 
        string Mobile, string Phone, string LeadStatus, string ChamberofCommerceNumber, string ReadyforService, Boolean EconomicallyActive, 
        Boolean CommerciallyActive, integer NumberofDesktops, integer NumberofLaptops, string CreditRisk, string VisitStreet, string VisitHouseNumber, 
        string VisitHouseNumberExtension, string VisitPostalCode, string VisitCity, string VisitCountry)
 {
        
        return CreateLead(Company, Email, Salutation, FirstName, LastName, MiddleName, 
        Mobile, Phone, LeadStatus, ChamberofCommerceNumber, ReadyforService, EconomicallyActive, 
        CommerciallyActive, NumberofDesktops, NumberofLaptops, CreditRisk, VisitStreet, VisitHouseNumber, 
        VisitHouseNumberExtension, VisitPostalCode, VisitCity, VisitCountry,true);
 }

    
    //create Opportunity
    public static Opportunity CreateOpportunity(Account Acc, Boolean WithInsert)
    {
        Account DummyPartnerAccount=createPartnerAccount();
        Opportunity tmpOpportunity = new Opportunity(Name = 'Test', AccountId=Acc.Id, StageName = 'Awareness of interest', CloseDate=Date.today()+5);
       	tmpOpportunity.UM_PartnerAccount__c=DummyPartnerAccount.Id;
        
        if (WithInsert) insert tmpOpportunity;
        
        return tmpOpportunity;
    }
    
    public static Opportunity CreateOpportunity(Account Acc)
    {
        return CreateOpportunity(Acc,true);
    }
    
    
    //create Contact
    public static Contact CreateContact(Account Acc,string Firstname, string LastName, string Salutation, 
        string Phone, string MobilePhone, string Email, string Role, date BirthDate,string MailingCity, string MailingCountry, string MailingPostalCode, 
        string MailingStreet,Boolean WithInsert)
    {
        Contact tmpContact = new Contact();
        tmpContact.AccountId=Acc.Id;
        tmpContact.Firstname=Firstname;
        tmpContact.LastName=LastName;
        tmpContact.Salutation='Mr.';
        tmpContact.Salutation=Salutation;
        tmpContact.Phone=Phone;
        tmpContact.MobilePhone=MobilePhone;
        tmpContact.Email=Email;
        tmpContact.LG_Role__c=Role;
        tmpContact.BirthDate=BirthDate;
        tmpContact.MailingCity=MailingCity;
        tmpContact.MailingCountry=MailingCountry;
        tmpContact.MailingPostalCode=MailingPostalCode;
        tmpContact.MailingStreet=MailingStreet;
        
        if (WithInsert) insert tmpContact;
        
        return tmpContact;
        
    }
    
     public static Contact CreateContact(Account Acc,string Firstname, string LastName, string Salutation, 
        string Phone, string MobilePhone, string Email, string Role, date BirthDate,string MailingCity, string MailingCountry, string MailingPostalCode, string MailingStreet)
    {
        return CreateContact(Acc,Firstname, LastName, Salutation, Phone, MobilePhone, Email, Role, BirthDate,MailingCity, MailingCountry, MailingPostalCode, MailingStreet,true);
    }
    
    //create Product Definition
    public static cscfga__Product_Definition__c createProductDefinition(String Name, Boolean WithInsert) 
    {
        cscfga__Product_Definition__c prodDef = new cscfga__Product_Definition__c();
        prodDef.Name = Name;
        prodDef.cscfga__Description__c=Name; 
         
        if (WithInsert) insert prodDef;

        return prodDef;
    }   
    
    public static cscfga__Product_Definition__c createProductDefinition(String Name)
    {
        return createProductDefinition(Name,true);
    }
    
    //create Attribute Definition
    public static cscfga__Attribute_Definition__c createAttributeDefinition(string name, cscfga__Product_Definition__c productDef, string AttribType, string DataType,
        string OPTKey, string OLIType, string ProductDetailType, Boolean WithInsert) 
    {
        cscfga__Attribute_Definition__c attDef = new cscfga__Attribute_Definition__c();
            attDef.Name = name;
            attDef.cscfga__Type__c = AttribType;
            attDef.cscfga__Data_Type__c=DataType;
            attDef.LG_OPTKey__c=OPTKey;
            attDef.LG_OLIType__c=OLIType;
            attDef.LG_ProductDetailType__c=ProductDetailType;
            attDef.cscfga__Product_Definition__c = productDef.Id;
         
         if (WithInsert) insert attDef;

         return attDef;
    }
    
    public static cscfga__Attribute_Definition__c createAttributeDefinition(string name, cscfga__Product_Definition__c productDef, string AttribType, string DataType,
        string OPTKey, string OLIType, string ProductDetailType)
    {
        return createAttributeDefinition(name,productDef, AttribType,DataType, OPTKey, OLIType, ProductDetailType, true);
    }
    
    //create Attribute Field Definition
    public static cscfga__Attribute_Field_Definition__c createAttributeFieldDefinition(string name, string Value, cscfga__Attribute_Definition__c AttributeDefinition, 
        Boolean WithInsert)
    {
        cscfga__Attribute_Field_Definition__c attDefFieldDefinition = new cscfga__Attribute_Field_Definition__c(Name=name,cscfga__Default_Value__c=Value,
            cscfga__Attribute_Definition__c=AttributeDefinition.Id);
            
        if (WithInsert) insert attDefFieldDefinition;
        
        return attDefFieldDefinition;
    }
    
    public static cscfga__Attribute_Field_Definition__c createAttributeFieldDefinition(string name, string Value, cscfga__Attribute_Definition__c AttributeDefinition)
    {
        return createAttributeFieldDefinition(name,Value,AttributeDefinition,true);
    }


    //create Product Configuration
    public static cscfga__Product_Configuration__c createProductConfiguration(string Name, integer ContractTerm, cscfga__Product_Basket__c ProductBasket, 
        cscfga__Product_Definition__c ProductDefinition, Boolean WithInsert)
    {
        cscfga__Product_Configuration__c ProductConfiguration = new cscfga__Product_Configuration__c();
        ProductConfiguration.Name=Name;
        ProductConfiguration.cscfga__Contract_Term__c=ContractTerm;
        ProductConfiguration.cscfga__Product_Basket__c=ProductBasket.Id;
        ProductConfiguration.cscfga__Product_Definition__c=ProductDefinition.Id;
        ProductConfiguration.cscfga__Quantity__c=1;
        
        if (WithInsert) insert ProductConfiguration;
        
        return ProductConfiguration;
    }
    
    public static cscfga__Product_Configuration__c createProductConfiguration(string Name, integer ContractTerm, cscfga__Product_Basket__c ProductBasket, 
        cscfga__Product_Definition__c ProductDefinition)
    {
        return createProductConfiguration(Name, ContractTerm,Productbasket,ProductDefinition,true);
    }
    
    //create Attribute
    public static cscfga__Attribute__c createAttribute(string Name, cscfga__Attribute_Definition__c AttributeDefinition, Boolean IsLineItem, double Price, 
        cscfga__Product_Configuration__c ProductConfiguration, Boolean Recurring, string Value, Boolean WithInsert)
    {
        
        cscfga__Attribute__c Attribute = new cscfga__Attribute__c();
        Attribute.Name=Name;
        Attribute.cscfga__Attribute_Definition__c=AttributeDefinition.Id;
        Attribute.cscfga__Is_Line_Item__c=IsLineItem;
        Attribute.cscfga__Price__c=Price;
        Attribute.cscfga__Product_Configuration__c=ProductConfiguration.Id;
        Attribute.cscfga__Recurring__c=Recurring;
        Attribute.cscfga__Value__c=Value;
        Attribute.cscfga__Line_Item_Description__c=Name;
        
        if (WithInsert) insert Attribute;
        
        return Attribute;
    }
    
    public static cscfga__Attribute__c createAttribute(string Name, cscfga__Attribute_Definition__c AttributeDefinition, Boolean IsLineItem, double Price, 
        cscfga__Product_Configuration__c ProductConfiguration, Boolean Recurring, string Value)
    {
        return createAttribute(Name,AttributeDefinition,IsLineItem,Price, ProductConfiguration, Recurring,Value, true);
    }
    
    
    //create AttributeField
    public static cscfga__Attribute_Field__c createAttributeField(string Name,cscfga__Attribute__c Attribute, string Value, Boolean WithInsert)
    {
        cscfga__Attribute_Field__c AttributeField = new cscfga__Attribute_Field__c();
        AttributeField.Name=Name;
        AttributeField.cscfga__Attribute__c=Attribute.Id;
        AttributeField.cscfga__Value__c=Value;
        
        if (WithInsert) insert AttributeField;
        
        return AttributeField;
    }
    
    public static cscfga__Attribute_Field__c createAttributeField(string Name,cscfga__Attribute__c Attribute, string Value)
    {
        return createAttributeField(Name,Attribute,Value,true);
    }
    
    
    public static cscfga__Product_Basket__c createProductBasket(string Name, Account Acc, Lead pLead, Opportunity Opp, Boolean WithInsert)
    {
        cscfga__Product_Basket__c ProductBasket = new cscfga__Product_Basket__c();
        ProductBasket.Name=Name;
        //if (Acc!=null) ProductBasket.cfgoffline__Account__c=Acc.Id;
        if (pLead!=null) ProductBasket.Lead__c=pLead.Id;
        if (Opp!=null) ProductBasket.cscfga__Opportunity__c=Opp.Id;
        ProductBasket.cscfga__Basket_Status__c='Valid';
        if (WithInsert) insert ProductBasket;
        
        return ProductBasket;   
    }
    
    
    public static cscfga__Product_Basket__c createProductBasket(string Name, Account Acc, Lead pLead, Opportunity Opp)
    {
             
        return createProductBasket(Name, Acc, pLead, Opp, true);    
    }
    
    
    
    //create Discount
    public static LG_Discount__c createDiscount(double Amount, string Business, string CalculationType, integer ContractTerm, string DiscountCode, 
        string DiscountMessage, string DiscountType, integer Months, Boolean WithInsert)
    {
        LG_Discount__c tmpDiscount = new LG_Discount__c();
        tmpDiscount.LG_Active__c=true;
        tmpDiscount.LG_Amount__c=Amount;
        tmpDiscount.LG_Business__c = Business;
        tmpDiscount.LG_CalculationType__c= CalculationType;
        tmpDiscount.LG_ContractTerm__c= ContractTerm;
        tmpDiscount.LG_DiscountCode__c=DiscountCode;
        tmpDiscount.LG_DiscountMessage__c=DiscountMessage;
        tmpDiscount.LG_DiscountType__c=DiscountType;
        tmpDiscount.LG_Months__c=Months;
        
        if (WithInsert) insert tmpDiscount;
        
        return tmpDiscount;
    }
    
    public static LG_Discount__c createDiscount(double Amount, string Business, string CalculationType, integer ContractTerm, string DiscountCode, 
        string DiscountMessage, string DiscountType, integer Months)
    {
        return createDiscount(Amount, Business, CalculationType, ContractTerm, DiscountCode, DiscountMessage, DiscountType,Months, true);
    }
    
    
    public static Attachment createAttachment(Id ParentId, string Name)
    {
        Attachment attachment = new Attachment();
        attachment.ParentId = ParentId;
        attachment.Name = Name;
        attachment.Body = Blob.valueof('Some text');
        insert attachment;
        
        return Attachment;
    }
    
    //create billing accounts
    public static csconta__Billing_Account__c createBillingAccount(String finNumber, Id accountId, Boolean defaultBillingAccount, Boolean insertAccount)
    {
        csconta__Billing_Account__c billAcc = new csconta__Billing_Account__c(csconta__Financial_Account_Number__c = finNumber,
                                                                                csconta__Account__c = accountId, csconta__Billing_Channel__c = 'Paper bill',
                                                                                LG_PaymentType__c = 'Bank Transfer', LG_Default__c = defaultBillingAccount);
        
        if (insertAccount)
        {
            insert billAcc;
        }
        
        return billAcc;
    }
    
    //create product category
    public static cscfga__Product_Category__c createProductCategory(String name, Boolean insertCategory)
    {
        cscfga__Product_Category__c prodCategory = new cscfga__Product_Category__c(Name = String.isBlank(name) ? 'TestCategory' : name);
        
        if (insertCategory)
        {
            insert prodCategory;
        }
        
        return prodCategory;
    }
    
    //create product configuration request
    public static csbb__Product_Configuration_Request__c createProdConfigurationRequest(Id prodCategoryId, Id basketId, 
                                                                                        Double totalOc, Double totalMRC, Boolean insertRequest)
    {
        csbb__Product_Configuration_Request__c prodRequest = new csbb__Product_Configuration_Request__c(csbb__Product_Category__c = prodCategoryId, 
                                                                    csbb__Product_Basket__c = basketId, csbb__Total_OC__c = totalOc,
                                                                    csbb__Total_MRC__c = totalMRC);
        
        if (insertRequest)
        {
            insert prodRequest;
        }
        
        return prodRequest;
    }

    // Create cscrm__Address__c (Premise)
    public static cscrm__Address__c crateAddress(string addrName, string street, string city, string houseNumber, string houseNumberExtension, string zip, string country, Account acc, Boolean insertAddress) {
        
        cscrm__Address__c premise = new cscrm__Address__c();
        
        premise.Name = addrName;
        premise.cscrm__Street__c = street;
        premise.cscrm__City__c = city;
        premise.LG_HouseNumber__c = houseNumber;
        premise.LG_HouseNumberExtension__c = houseNumberExtension;
        premise.cscrm__Zip_Postal_Code__c = zip;
        premise.cscrm__Country__c = country;
        premise.cscrm__Account__c = acc.Id;
        
        if (insertAddress) {
            insert premise;
        }
        
        return premise;
    }     
    
    public static UM_ProductInterest__c createProductInterest(Lead objLead, string Product, Integer ContractTerm, Integer Quantity, Integer Capex, Integer Omex, Integer MRR,Integer OTC, Boolean withInsert){
    	UM_ProductInterest__c objPI=new UM_ProductInterest__c();
    	objPI.UM_Lead__c=objLead.Id;
    	objPI.UM_Product__c=product;
    	objPI.UM_ContractTerm__c=ContractTerm;
    	objPI.UM_Quantity__c=quantity;
    	objPI.UM_Capex__c=capex;
    	objPI.UM_Opex__c=omex;
    	objPI.UM_MRR__c=MRR;
    	objPI.UM_OTC__c=otc;
    	
    	if(withInsert){
    		insert objPI;
    	}
    	return objPI;
    }
	/*
     * Create Email Template
     *
     * @param templateName
     * @param subject
     * @param insertImmediately
     *
     * @author Petar Miletic
     * @ticket SFDT-902
    */
    public static EmailTemplate crateEmailTemplate(User u, string templateName, string subject, Boolean insertImmediately) {
        
        string HTMLBody = '<table height="400" width="550" cellpadding="5" border="0" cellspacing="5" >';
        HTMLBody += '<tr height="400" valign="top" >';
        HTMLBody += '<td style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;" tEditID="c1r1" locked="0" aEditID="c1r1" >';
        HTMLBody += '<![CDATA[test]]></td>';
        HTMLBody += '</tr>';
        HTMLBody += '</table>';

        EmailTemplate tmpEmailNameEmailTemplate = new EmailTemplate();
        tmpEmailNameEmailTemplate.Name = templateName;
        tmpEmailNameEmailTemplate.DeveloperName = 'Test' + templateName;
        tmpEmailNameEmailTemplate.Subject = subject;
        tmpEmailNameEmailTemplate.Body = 'Test Body';
        tmpEmailNameEmailTemplate.HtmlValue = HTMLBody;
        tmpEmailNameEmailTemplate.TemplateType = 'text';
        tmpEmailNameEmailTemplate.FolderId = u.Id;
        
        if (insertImmediately) {
            insert tmpEmailNameEmailTemplate;
        }
        
        return tmpEmailNameEmailTemplate;
    }
     /*
     * Create Order
     *
     * @param orderName
     * @param Account
     * @param orderStatus
     * @param csord__Order_Request__c
     * @param Opportunity
     * @param WithInsert
     *
     * @author Petar Miletic
     * @ticket SFDT-1261
    */
    public static csord__Order__c createOrder(string orderName, Account acc, string orderStatus, csord__Order_Request__c orderRequest, Opportunity opp, Boolean WithInsert) {
        
        csord__Order__c o = new csord__Order__c();
        
        o.Name = orderName;
        o.csord__Account__c = acc.Id;
        o.csord__Status2__c = orderStatus;
        o.csord__Order_Request__c = orderRequest.Id;
        o.csord__Identification__c = 'UnitTest_' + LG_Util.generateRandomNumberString(5);
        o.csordtelcoa__Opportunity__c = opp.Id;
        
        if (WithInsert) {
            insert o;    
        }
        
        return o;
    }
    public static UM_PortingProcess__c createPortingProcess(csord__Service__c  service, string Name, string status, Boolean withInsert){
    	UM_PortingProcess__c portProcess =new UM_PortingProcess__c(Name=Name, UM_VoiceService__c=service.Id, UM_Status__c=status); 
    	portProcess.UM_Stage__c='Internal Clarification';
    	portProcess.UM_SubStage__c='Internal Clarification';
    	if(withInsert){
    		insert portProcess;
    	}
    	return portProcess;
    }

    public static UM_InvoiceHeader__c createInvoiceHeader(Id accId, Date iDate, String iNumber, Decimal iCGross, Decimal iCNet, Decimal iAGross, Decimal iANet, Date paymentDueDate, Id billingAcc, Boolean withInsert) {

        UM_InvoiceHeader__c testIH = new UM_InvoiceHeader__c();
        testIH.UM_Customer_SF_ID__c = accId;
        testIH.UM_Invoice_Date__c = iDate;
        testIH.UM_InvoiceNumber__c = iNumber;
        testIH.UM_Invoice_Amount_Gross_Currency__c = iCGross;
        testIH.UM_Invoice_Amount_Net_Currency__c = iCNet;
        testIH.UM_Invoice_Amount_Gross__c = iAGross;
        testIH.UM_Invoice_Amount_Net__c = iANet;
        testIH.UM_Payment_Due_Date__c = paymentDueDate;
        testIH.UM_Billing_Location__c = billingAcc;

        if (withInsert) {
            insert testIH;
        }

        return testIH;
    }

    public static Kenan_Adjustment__c createKenanAdjustment(String trackingId, String trackingIdServ, String adjReason, String adjType, String adjStatus, Decimal adjAmount, Id ihID, Boolean withInsert) {
      
        Kenan_Adjustment__c testAdj = new Kenan_Adjustment__c();
        testAdj.trackingId__c = trackingId;
        testAdj.trackingIdServ__c = trackingIdServ;
        testAdj.Adjustment_Reason__c = adjReason;
        testAdj.Adjustment_Type__c = adjType;
        testAdj.RequestStatus__c = adjStatus;
        testAdj.Total_Amount__c = adjAmount;
        testAdj.Invoice_Header__c = ihId;
    
        if(withInsert) {        
            insert testAdj;
        }

        return testAdj;
    }
    //added for BHP-50
    public static Kenan_Adjustment__c createAdjustmentReceivedFromKenan(String trackingId, String trackingIdServ, String adjReason, String adjType, String adjStatus, Decimal adjAmount, Id ihID, Boolean withInsert, Boolean receivedFromBillingSystem, Boolean effectsBalance,Date effectiveDate) {

        Kenan_Adjustment__c testAdj = new Kenan_Adjustment__c();
        testAdj.trackingId__c = trackingId;
        testAdj.trackingIdServ__c = trackingIdServ;
        testAdj.Adjustment_Reason__c = adjReason;
        testAdj.Adjustment_Type__c = adjType;
        testAdj.RequestStatus__c = adjStatus;
        testAdj.Total_Amount__c = adjAmount;
        testAdj.Invoice_Header__c = ihId;
        testAdj.Effective_Date__c = effectiveDate;
        testAdj.UM_Received_from_Billing_System__c = receivedFromBillingSystem;
        testAdj.UM_Affects_Balance__c = effectsBalance;
        if(withInsert) {
            insert testAdj;
        }
        
        return testAdj;
    }
    public static Account createPartnerAccount(){
        Id partnerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Account DummyPartnerAccount=new Account();
        DummyPartnerAccount.Name='Dummy Partner';
        DummyPartnerAccount.RecordTypeId=partnerRecordTypeId;
        DummyPartnerAccount.UM_P_Partner_Level__c='Competence partner';
        DummyPartnerAccount.UM_P_Sales_ID_NRW_HSN__c='12345';
        DummyPartnerAccount.UM_P_Sales_ID_BW__c='54321';
        insert DummyPartnerAccount;
        return DummyPartnerAccount;
    }
}