/* -----------------------------------------------------------------------------------------------------------------------
   Name: LG_SeparateInvoicesController 
   Description: Used as a controller for LG_SeparateInvoices VF page.

  Date            Version         Author          Summary of Changes 
-----------  ------- --------------  ----------------------------------------------------------------------------------
 Jan 2016           1.0           Tomislav Blazek        Initial version 
 Jul 2016           1.1           Madhu Sudhan           UMR-284 - Billing account assignment is changed to product level 
------------------------------------------------------------------------------------------------------------------------ */

public with sharing class LG_SeparateInvoicesController{
 
    private Id basketId;
    private Account account;
    //SFOM-1204
    private Opportunity opportunity;
    //Modified for BU-59- start
    public string accList {get;set;}
    Set <string> billAccounts= new Set<string>();
    public Set<boolean> isRedirect =new Set<boolean>();
    
    public boolean isValid{get;set;}
    
    //Modified for BU-59- end
    
    //public List<LIWrap> liwrappers {get;set;}
    public List<PCWrap> pcwrappers {get;set;}
     
    public PageReference createNewBillAccount() {
        //As required in SFDT-143 - implicit save when clicking on the 'New Billing Account' button.
        save();
        
        //PageReference createNewBillPage = new PageReference('/' + csconta__Billing_Account__c.sObjectType.getDescribe().getKeyPrefix() + '/e');
        PageReference createNewBillPage = new PageReference('/apex/UM_BillingAccount');

        String accFieledReference = LG_Util.getLookupFieldReferenceId(createNewBillPage,
                                        Account.getSObjectType().getDescribe().getKeyPrefix());
        createNewBillPage.getParameters().put('saveURL', '/apex/LG_SeparateInvoices?basketId='+basketId);
        createNewBillPage.getParameters().put(accFieledReference, account.Name);
        createNewBillPage.getParameters().put('aId', account.Id);
        //SFOM-1204
        createNewBillPage.getParameters().put('oppId', opportunity.Id);
        createNewBillPage.getParameters().put('retURL','/apex/LG_SeparateInvoices?basketId='+basketId);

        return createNewBillPage;
    } 

    public LG_SeparateInvoicesController() {
        basketId = ApexPages.currentPage().getParameters().get('basketId');
        isValid = true;
        if (basketId != null)
        {
            cscfga__Product_Basket__c basket = [SELECT Id, csbb__Account__r.Name, csbb__Account__r.Id,
                                                cscfga__Opportunity__r.Name, cscfga__Opportunity__r.Id //SFOM-1205
                                                FROM cscfga__Product_Basket__c
                                                WHERE Id = :basketId];           
            account = basket.csbb__Account__r;
            //SFOM-1204
            opportunity = basket.cscfga__Opportunity__r;
            getProductsList();
        }
    }
    
    //Populate the select list with the Billing Account associated to the Customer account of the opportunity
    public List<SelectOption> getItems() {
        
        List<SelectOption> options = new List<SelectOption>();
        
        List<csconta__Billing_Account__c> billingAccounts = [SELECT Id, LG_BillingAccountIdentifier__c, LG_BillingAccountNumber__c, UM_Billing_Account_withPaymentInfo__c,csconta__Status__c 
                                                             FROM csconta__Billing_Account__c 
                                                             WHERE csconta__Account__c = :account.Id AND (csconta__Status__c != 'Inactive' AND csconta__Status__c != 'Deactivation Requested' AND csconta__Status__c != 'Deactivation Pending')];
        
        options.add(new SelectOption('', Label.UM_Select));
        
        for(csconta__Billing_Account__c billingAcc : billingAccounts)
        {
            //options.add(new SelectOption(billingAcc.Id, billingAcc.LG_BillingAccountIdentifier__c));
            // added by sabeena as part of UMR-2065
            options.add(new SelectOption(billingAcc.Id, billingAcc.UM_Billing_Account_withPaymentInfo__c));
        }
        
        return options;
    }
    
    

/* Param:account id
* Return:  boolean 
* Description: Return false flag for billing account without required details
* High Level Process : check if the selected billing account have values in required fields
* Summary of Changes :BU-59/CATGOV-239 */

    Public boolean CheckBillingAccount(string accountId)
        
        
    {
        //boolean isValid;
        
        List <csconta__Billing_Account__c> accReqUpdation  =[SELECT Id, LG_BillingAccountNumber__c FROM csconta__Billing_Account__c where (csconta__City__c = null
                                                                                                                     OR  csconta__Country__c = null 
                                                                                                                     OR csconta__Street__c= null 
                                                                                                                     
                                                                                                                     OR csconta__Payment_Terms__c= null 
                                                                                                                     OR LG_HouseNumber__c= null 
                                                                                                                     OR csconta__Billing_Channel__c= null  
                                                                                                                     OR LG_ContractualOrganization__c= null 
                                                                                                                     OR csconta__Status__c= null
                                                                                                                     OR csconta__Postcode__c= null 
                                                                                                                     OR UM_BillFormatOptions__c= null) 
                                                             and id= :accountId];
        
        if((accReqUpdation!=null)&& (accReqUpdation.size()>0))
        {
            system.debug('inside false');
            isValid=false;
            
            if(!billAccounts.Contains(accReqUpdation[0].LG_BillingAccountNumber__c))
            {
                billAccounts.add(accReqUpdation[0].LG_BillingAccountNumber__c);
            }
            accList=String.Join(new List<String>(billAccounts), ',');
            
        }
        else {
            isValid=true;
        }
        return isValid;
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
        /*List<cscfga__Attribute_Field__c> fieldsToUpsert = new List<cscfga__Attribute_Field__c>();
        
        for(LIWrap wp : liwrappers)
        {
            Id fieldId = wp.billingAccountField != null ? wp.billingAccountField.Id : null;
            String selectedBillAccId = String.isBlank(wp.selValBill) ? null : wp.selValBill;
            
            fieldsToUpsert.add(new cscfga__Attribute_Field__c(Id = fieldId,
                                                            cscfga__Attribute__c = wp.att.Id,
                                                            Name = 'BillingAccount',
                                                            cscfga__Value__c = selectedBillAccId));
        }

        upsert fieldsToUpsert;*/
        List<cscfga__Product_Configuration__c> updateBillingAccountToProductsList = new List<cscfga__Product_Configuration__c>();
        List<cscfga__Attribute__c> usertAttributeList = new List<cscfga__Attribute__c>();
        
        for(PCWrap wp : pcwrappers )
        {
            cscfga__Product_Configuration__c pcObj=wp.lineItem;
            
            //Modified for BU-59
            if(wp.selValBill!=null && wp.selValBill!='Select')
            {
                isValid=  CheckBillingAccount(wp.selValBill);
                system.debug('wp.selValBill'+wp.selValBill);
                
            }
            if (isValid== true)
            {
                pcObj.LG_Billing_Account__c=wp.selValBill;
                isRedirect.add(true);
                
                
            }else{
                if (isValid== false)
                {
                    isRedirect.add(false);
                    pcObj.LG_Billing_Account__c=null;
                }
            }
            
            updateBillingAccountToProductsList.add(pcObj);
        }
        if(updateBillingAccountToProductsList!=null && updateBillingAccountToProductsList.size()>0){
            update updateBillingAccountToProductsList;
        }
        // Update BillingAccont Attribute field on line item attributes 
        updateAttributeLineitesBillingAccount(updateBillingAccountToProductsList,basketId);
        
        //Modified for BU-59    
        if(isRedirect.contains(false))   
        {  
            isValid=false;
            return null; 
        }
        
        else
        {
            return redirectToBasket();
        }
    }
    
    //retreive the line items (need to have a wrapper class so each line get their own billing account)
   /* void getLI() {
        
        liwrappers = new List<LIWrap>();
        
        for(cscfga__Attribute__c attribute : [SELECT Id, Name, cscfga__Line_Item_Description__c, cscfga__Price__c, cscfga__Recurring__c,
                                                cscfga__Product_Configuration__r.LG_Address__r.cscrm__Address_Details__c,
                                                (SELECT Id, Name, cscfga__Value__c FROM cscfga__Attribute_Fields__r WHERE Name = 'BillingAccount')
                                                FROM cscfga__Attribute__c 
                                                WHERE cscfga__Is_Line_Item__c = true
                                                AND cscfga__Product_Configuration__c IN 
                                                (SELECT Id FROM cscfga__Product_Configuration__c WHERE cscfga__Product_Basket__c = :basketId)
                                                ORDER BY cscfga__Product_Configuration__r.LG_Address__r.cscrm__Address_Details__c,
                                                            cscfga__Line_Item_Sequence__c])
        {
            liwrappers.add(new LIWrap(attribute));
        }
    }*/
    /**********************************************************************************************************************
    * author: Madhu  
    * Date: july 2016
    * Param:
    * Return:  void 
    * Description: Retreive the Product config items (need to have a wrapper class so each product config to get their own billing account)    
    * High Level Process : retive the products from product configuration for billing account assignment 
    * Summary of Changes : 
    **********************************************************************************************************************/
    void getProductsList() {
    
        List<SelectOption> billAcc=getItems();
        pcwrappers = new List<PCWrap>();
        csbb__Product_Configuration_Request__c objPCR=new csbb__Product_Configuration_Request__c();
        List<cscfga__Product_Configuration__c> productConfigList=[Select id,name,LG_Address__r.cscrm__Address_Details__c,cscfga__Total_Price__c,LG_Billing_Account__c,
                                                                  cscfga__One_Off_Charge__c,Billing_Account_Number__c,cscfga__Recurring_Charge__c,/*CRQ000000726027 */csordtelcoa__Replaced_Service__r.csordtelcoa__Service_Number__c /*CRQ000000726027 */ 
                                                                   
                                                                  from cscfga__Product_Configuration__c
                                                                  where cscfga__Product_Basket__c=:basketId and cscfga__Parent_Configuration__c=null 
                                                                  order by LG_Address__r.cscrm__Address_Details__c];
        set<id> pcIds=new set<id>();
        List<csbb__Product_Configuration_Request__c> pcr = new List<csbb__Product_Configuration_Request__c>();
      /* list<cscfga__Product_Configuration__c> billAccNumberList=[Select Billing_Account_Number__c                                                     
                                                                  from cscfga__Product_Configuration__c
                                                                  where cscfga__Product_Basket__c=:basketId and cscfga__Parent_Configuration__c=null  
                                      
                                                                 
                                                                  order by LG_Address__r.cscrm__Address_Details__c]; new change */  
       
      
        if(productConfigList!=null && productConfigList.size()>0){
            for(cscfga__Product_Configuration__c objPC: productConfigList)
            {   
                
                pcr =[Select Id, csbb__Total_MRC__c, csbb__Total_OC__c from csbb__Product_Configuration_Request__c where csbb__Product_Configuration__c=:objPC.Id];
                if (!pcr.isEmpty()) { 
                    objPCR = pcr[0];
                    pcIds.add(objPC.id);
                    String selValBill=null;
                    if(objPC.LG_Billing_Account__c == null){
                            selValBill='Select';
                        }else{
                            selValBill= objPC.LG_Billing_Account__c;
                    }
                    pcwrappers.add(new PCWrap(objPC,billAcc,selValBill,objPCR));
                }
            }
        }
    }
    
   /* public class LIWrap {
        
        public cscfga__Attribute__c att {get;set;}
        public String selValBill {get;set;}
        private cscfga__Attribute_Field__c billingAccountField {get; set;}
        public Boolean selected {get;set;}
        
        public LIWrap(cscfga__Attribute__c att) {
            this.att = att;
            this.selected = false;
            
            for(cscfga__Attribute_Field__c field : att.cscfga__Attribute_Fields__r)
            {
                this.selValBill = field.cscfga__Value__c;
                this.billingAccountField = field;
            }
        }
    }*/
    Public Class PCWrap{
        public cscfga__Product_Configuration__c  lineItem{get; set;}
        public csbb__Product_Configuration_Request__c objPCR{get;set;}
        public String selValBill{get; set;}
        public List<SelectOption> billAcc {get; set;}
        public Boolean selected {get;set;}
        
        public PCWrap(cscfga__Product_Configuration__c  lineItem, List<SelectOption> billAcc,String selValBill,csbb__Product_Configuration_Request__c PCR) {
            this.selValBill= selValBill;
            this.lineItem = lineItem;
            this.billAcc = billAcc;
            this.selected = false;
            this.objPCR=PCR;
        } 

    }
    /**********************************************************************************************************************
    * author: Madhu  
    * Date: July 2016
    * Param:List<cscfga__Product_Configuration__c> & basketid
    * Return:  void
    * Description: This method will take the Billingaccount from product configuration and sets the BillingAccount attribute field at lineitems level  
    * Summary of Changes : 
    **********************************************************************************************************************/
    public void updateAttributeLineitesBillingAccount(List<cscfga__Product_Configuration__c> updateBillingAccountToProductsList,string basketId ){
        //retreive the line items (so each line get their own billing account)
        List<cscfga__Attribute__c> attributesList=[SELECT Id, Name, cscfga__Line_Item_Description__c, cscfga__Price__c, cscfga__Recurring__c,cscfga__Product_Configuration__r.cscfga__Parent_Configuration__c,
                                                cscfga__Product_Configuration__r.LG_Address__r.cscrm__Address_Details__c,cscfga__Product_Configuration__c,
                                                (SELECT Id, Name, cscfga__Value__c FROM cscfga__Attribute_Fields__r WHERE Name = 'BillingAccount')
                                                FROM cscfga__Attribute__c  WHERE cscfga__Is_Line_Item__c = true
                                                AND cscfga__Product_Configuration__c IN 
                                                (SELECT Id FROM cscfga__Product_Configuration__c WHERE cscfga__Product_Basket__c = :basketId)
                                                ORDER BY cscfga__Product_Configuration__r.LG_Address__r.cscrm__Address_Details__c,
                                                            cscfga__Line_Item_Sequence__c];

        // Map of product config and lineites attributes 
        MAP<id,List<cscfga__Attribute__c>> productConfigLineItemsAttMap=new MAP<id,List<cscfga__Attribute__c>>();

        for(cscfga__Attribute__c obj:attributesList){
            if(productConfigLineItemsAttMap.get(obj.cscfga__Product_Configuration__c)==null){
                productConfigLineItemsAttMap.put(obj.cscfga__Product_Configuration__c,new List<cscfga__Attribute__c>());
            }
            productConfigLineItemsAttMap.get(obj.cscfga__Product_Configuration__c).add(obj);
        }
        List<cscfga__Attribute_Field__c> fieldsToUpsert = new List<cscfga__Attribute_Field__c>();
    
        for(cscfga__Product_Configuration__c pcObj: updateBillingAccountToProductsList){
            //Attribute lineitems for each configuration 
            List<cscfga__Attribute__c> attList=productConfigLineItemsAttMap.get(pcObj.id);
            if(attList!=null && attList.size()>0){
                for(cscfga__Attribute__c liattObj:attList){
                    //get the billing account attribute fields if does not exist create
                    List<cscfga__Attribute_Field__c> attFields=liattObj.cscfga__Attribute_Fields__r; //ideally this should return only one or no billing account attribute field
                    if(attFields!=null && attFields.size()>0){
                        cscfga__Attribute_Field__c attFieldobj=attFields.get(0);
                        attFieldobj.cscfga__Value__c=pcObj.LG_Billing_Account__c;
                        fieldsToUpsert.add(attFieldobj);
                    }else{
                        cscfga__Attribute_Field__c newAttField=new cscfga__Attribute_Field__c();
                        newAttField.cscfga__Attribute__c=liattObj.id;
                        newAttField.cscfga__Value__c=pcObj.LG_Billing_Account__c;
                        newAttField.name='BillingAccount';
                        fieldsToUpsert.add(newAttField);
                    }
                }
            }
    
        }
        if(fieldsToUpsert !=null & fieldsToUpsert.size()>0){
            upsert fieldsToUpsert ;
        }

    }
    //back to basket
    public PageReference redirectToBasket() {
        PageReference newocp = new PageReference(LG_Util.getSalesforceBaseUrl() + '/' + basketId);
 
        return newocp;
    }
}