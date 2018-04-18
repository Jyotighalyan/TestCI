/**
* Used as a controller for LG_SeparateInvoices VF page.
* 
* @author Tomislav Blazek
* @ticket SFDT-58
* @since  13/01/2016
*/
public with sharing class LG_SeparateInvoicesControllerTK {
    
    private Id basketId;
    private Account account;
    private map<id,decimal> productConfigOneOffTotal;
    private	map<id,decimal> productConfigRecurringTotal;
    private list<id> addressIds;
    
    public List<LIWrap> liwrappers {get;set;}
    public list<AddressWrap> liAddWrappers {get;set;}
    /*public List<LIWrap> allLineItems {
        get{
            if(addressLineItems!=null)
                return addressLineItems.values();
            else
                return null; 
        }
    }*/
    public Id selectedAddressId {get;set;}
    public map<String,list<LIWrap>> addressLineItems {get;set;}
    public set<string> allAddresses{
        get{
            if(addressLineItems!=null)
                return addressLineItems.keySet();
            else
                return null;
        }
    }
    
    
    public PageReference createNewBillAccount() {
        //As required in SFDT-143 - implicit save when clicking on the 'New Billing Account' button.
        save();
        
        PageReference createNewBillPage = new PageReference('/' + csconta__Billing_Account__c.sObjectType.getDescribe().getKeyPrefix() + '/e');
        
        String accFieledReference = LG_Util.getLookupFieldReferenceId(createNewBillPage,
                                                                      Account.getSObjectType().getDescribe().getKeyPrefix());
        createNewBillPage.getParameters().put('saveURL', '/apex/LG_SeparateInvoices?basketId='+basketId);
        createNewBillPage.getParameters().put(accFieledReference, account.Name);
        createNewBillPage.getParameters().put(accFieledReference + '_lkid', account.Id);
        createNewBillPage.getParameters().put('retURL','/apex/LG_SeparateInvoices?basketId='+basketId);
        
        return createNewBillPage;
    } 
    
    public LG_SeparateInvoicesControllerTK() {
        basketId = ApexPages.currentPage().getParameters().get('basketId');
        productConfigOneOffTotal = new map<id,decimal>();
        productConfigRecurringTotal = new map<id,decimal>();
        addressLineItems = new map<String,list<LIWrap>>();
        
        if (basketId != null)
        {
           // allLineItems = new List<LIWrap>();
            liAddWrappers = new list<AddressWrap>();
            addressIds = new list<id>();
            
            cscfga__Product_Basket__c basket = [SELECT Id, csbb__Account__r.Name, csbb__Account__r.Id
                                                FROM cscfga__Product_Basket__c
                                                WHERE Id = :basketId];
            
            account = basket.csbb__Account__r;
            
            for(AggregateResult argResult : [SELECT cscfga__Product_Configuration__c,sum(cscfga__Product_Configuration__r.cscfga__One_Off_Charge__c) oneOff      
                                             FROM cscfga__Attribute__c 
                                             WHERE cscfga__Is_Line_Item__c = true
                                             AND cscfga__Recurring__c = false
                                             AND cscfga__Product_Configuration__c IN 
                                             (SELECT Id FROM cscfga__Product_Configuration__c WHERE cscfga__Product_Basket__c =: basketId )
                                             group by cscfga__Product_Configuration__c]){
                                                 productConfigOneOffTotal.put((Id)argResult.get('cscfga__Product_Configuration__c'),(decimal)argResult.get('oneOff'));      
                                             }
            
            for(AggregateResult argResult : [SELECT cscfga__Product_Configuration__c,sum(cscfga__Product_Configuration__r.cscfga__Recurring_Charge__c) recurringTotal      
                                             FROM cscfga__Attribute__c 
                                             WHERE cscfga__Is_Line_Item__c = true
                                             AND cscfga__Recurring__c = true
                                             AND cscfga__Product_Configuration__c IN 
                                             (SELECT Id FROM cscfga__Product_Configuration__c WHERE cscfga__Product_Basket__c =: basketId )
                                             group by cscfga__Product_Configuration__c]){
                                                 productConfigRecurringTotal.put((Id)argResult.get('cscfga__Product_Configuration__c'),(decimal)argResult.get('recurringTotal'));      
                                             }
            
            
            getLI();
        }
    }
    
    //Populate the select list with the Billing Account associated to the Customer account of the opportunity
    public List<SelectOption> getItems() {
        
        List<SelectOption> options = new List<SelectOption>();
        
        List<csconta__Billing_Account__c> billingAccounts = [SELECT Id, LG_BillingAccountIdentifier__c 
                                                             FROM csconta__Billing_Account__c 
                                                             WHERE csconta__Account__c = :account.Id];
        
        options.add(new SelectOption('', 'Select'));
        
        for(csconta__Billing_Account__c billingAcc : billingAccounts)
        {
            options.add(new SelectOption(billingAcc.Id, billingAcc.LG_BillingAccountIdentifier__c));
        }
        
        return options;
    }
    
    /**
* Sets the Billing Account (selected in the Dropdown) on the individual line items.
*                                   	 
* @author Tomislav Blazek
* @ticket SFDT-58
* @since  2016-01-12
*/
    public PageReference save() 
    {
        List<cscfga__Attribute_Field__c> fieldsToUpsert = new List<cscfga__Attribute_Field__c>();
        
        for(LIWrap wp : liwrappers)
        {
            Id fieldId = wp.billingAccountField != null ? wp.billingAccountField.Id : null;
            String selectedBillAccId = String.isBlank(wp.selValBill) ? null : wp.selValBill;
            
            fieldsToUpsert.add(new cscfga__Attribute_Field__c(Id = fieldId,
                                                              cscfga__Attribute__c = wp.att.Id,
                                                              Name = 'BillingAccount',
                                                              cscfga__Value__c = selectedBillAccId));
        }
        
        upsert fieldsToUpsert;
        
        return redirectToBasket();
    }
    
    //retreive the line items (need to have a wrapper class so each line get their own billing account)
    public void getLI() {
        map<id,id> productConfigAttributes = new map<id,id>();
        List<LIWrap> lineItems;
        String addressId;
        decimal oneOffTotal = 0;
        decimal recurringTotal = 0;
        liwrappers = new List<LIWrap>();
        integer iCount = 0;
        
        string queryStr = 'SELECT Id, Name,cscfga__Product_Configuration__c, cscfga__Product_Configuration__r.name, cscfga__Line_Item_Description__c, cscfga__Price__c, cscfga__Recurring__c,'+
            'cscfga__Product_Configuration__r.LG_Address__r.cscrm__Address_Details__c,'+
            'cscfga__Product_Configuration__r.cscfga__Recurring_Charge__c,'+
            'cscfga__Product_Configuration__r.cscfga__One_Off_Charge__c, '+
            'cscfga__Product_Configuration__r.LG_Address__c,'+
            '(SELECT Id, Name, cscfga__Value__c FROM cscfga__Attribute_Fields__r WHERE Name = \'BillingAccount\')'+
            'FROM cscfga__Attribute__c '+
            'WHERE cscfga__Is_Line_Item__c = true '+
            'AND cscfga__Product_Configuration__c IN '+
            '(SELECT Id FROM cscfga__Product_Configuration__c WHERE cscfga__Product_Basket__c = :basketId)';
        if(selectedAddressId!= null)
            queryStr +=  ' AND cscfga__Product_Configuration__r.LG_Address__c=:selectedAddressId';
        
        queryStr += ' ORDER BY cscfga__Product_Configuration__r.LG_Address__r.cscrm__Address_Details__c,'+
            'cscfga__Line_Item_Sequence__c';
        
        list<cscfga__Attribute__c> attributeList = Database.query(queryStr);
        lineItems= new List<LIWrap>(); 
        for(cscfga__Attribute__c attribute : attributeList)
        {
            System.debug('attribute: '+attribute + ' addressId: '+addressId + ' and address = '+attribute.cscfga__Product_Configuration__r.LG_Address__r.cscrm__Address_Details__c);
            iCount++;
            if(addressId!=attribute.cscfga__Product_Configuration__r.LG_Address__r.cscrm__Address_Details__c){
                if(!String.isBlank(addressId)){
                    System.debug('lineItems: '+ lineItems);
                    addressLineItems.put(addressId,lineItems);
                }
                addressId = attribute.cscfga__Product_Configuration__r.LG_Address__r.cscrm__Address_Details__c;
                lineItems= new List<LIWrap>();  
                System.debug('addressLineItems: '+addressLineItems);
            }
            else{
                if(productConfigAttributes.get(attribute.cscfga__Product_Configuration__c)==null){
                    
                    lineItems.add(new LIWrap(attribute,productConfigOneOffTotal,productConfigRecurringTotal));
                    liwrappers.add(new LIWrap(attribute,productConfigOneOffTotal,productConfigRecurringTotal));
                    productConfigAttributes.put(attribute.cscfga__Product_Configuration__c,attribute.cscfga__Product_Configuration__c);
                    if(iCount>=attributeList.size())
                        addressLineItems.put(addressId,lineItems);
                }  
            }
            /*addressIds.add(attribute.cscfga__Product_Configuration__r.LG_Address__c);
if(productConfigAttributes.get(attribute.cscfga__Product_Configuration__c)==null){
liwrappers.add(new LIWrap(attribute,productConfigOneOffTotal,productConfigRecurringTotal));
productConfigAttributes.put(attribute.cscfga__Product_Configuration__c,attribute.cscfga__Product_Configuration__c);
}     
allLineItems.add(new LIWrap(attribute,productConfigOneOffTotal,productConfigRecurringTotal));*/
        }
        
        System.debug('Final addressLineItems: '+addressLineItems);
    }
    
    public class AddressWrap {
        public id addressId {get;set;}
        public cscrm__Address__c address {get;set;}
        public list<LIWrap> liwrappers {get;set;}
        
        public AddressWrap(cscrm__Address__c address,list<LIWrap> lineWrapList){
            this.liwrappers = new list<LIWrap>();
            this.liWrappers.addAll(lineWrapList);
            this.addressId = address.id;
            this.address = address;
        }
    }
    
    public class LIWrap {
        
        public cscfga__Attribute__c att {get;set;}
        public String selValBill {get;set;}
        private cscfga__Attribute_Field__c billingAccountField {get; set;}
        public Boolean selected {get;set;}
        public decimal oneOffPrice {get;set;}
        public decimal recurringPrice {get;set;}
        
        
        public LIWrap(cscfga__Attribute__c att,map<id,Decimal> oneOffTotalMap,map<id,Decimal> recurringTotalMap ) {
            
            this.att = att;
            this.selected = false;
            this.oneOffPrice = oneOffTotalMap.get(att.cscfga__Product_Configuration__c);
            this.recurringPrice = recurringTotalMap.get(att.cscfga__Product_Configuration__c);
            this.att.cscfga__Price__c = this.oneOffPrice;
            this.att.cscfga__List_Price__c =  this.recurringPrice;
            for(cscfga__Attribute_Field__c field : att.cscfga__Attribute_Fields__r)
            {
                this.selValBill = field.cscfga__Value__c;
                this.billingAccountField = field;   
            }
        }
    }
    
    //back to basket
    public PageReference redirectToBasket() {
        PageReference newocp = new PageReference(LG_Util.getVisualForceBaseUrl() + '/apex/BasketbuilderApp?Id=' + basketId);
        
        return newocp;
    }
    
    public list<SelectOption> getSites(){
        list<SelectOption> sites = new list <SelectOption>();
        sites.add(new selectOption('','Select'));
        for(cscrm__Address__c  address : [select id,cscrm__Address_Details__c from cscrm__Address__c where id in :addressIds]){
            sites.add(new selectOption(address.id,address.cscrm__Address_Details__c) );
        }
        
        return sites;
    }
}