/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanInvoiceControllerExt Controller Extension used with KenanInvoice VF Page
*/

public with sharing class KenanInvoiceControllerExt {
    public static final String KENAN_INVOICE_HEADER_FIELD_SET = 'InvoiceHeader';
    public static final String KENAN_INVOICE_ACCOUNT_FIELD_SET = 'Kenan_Invoice_Account';
    public static final String KENAN_INVOICE_ADJUSTMENT_FIELD_SET = 'Kenan_Invoice_Adjustment';
    public static final String KENAN_INVOICE_PAYMENT_FIELD_SET = 'Kenan_Invoice_Payment';
    public static final String KENAN_INVOICE_SERVICE_FIELD_SET = 'Kenan_Invoice_Service';
    string BillingAccount;
    String InvoiceNumber;
    String InvoiceAccount;
    string URL;
    string BillingAccountNm;
    string InvId;
    private UM_InvoiceHeader__c kenanInvoiceHeader;
    private List<InvoiceItem__x> kenanInvoiceItems;
    private List<FieldSetMember> accountFieldSetNames;
    private List<FieldSetMember> paymentFieldSetNames;
    private List<FieldSetMember> serviceFieldSetNames;
    private List<FieldSetMember> adjustmentFieldSetNames;
    private List<InvoiceItem__x> accountLevelInvoiceItems;
    private List<InvoiceItem__x> invoiceTotalItems;
    private List<InvoiceItem__x> adjustmentItems;
    private List<InvoiceItem__x> paymentInvoiceItems;
    private List<KenanServiceInvoiceItemWrapper> serviceWrappers;
    private Decimal accountLevelTotal;
    private Decimal paymentTotal;
    private Decimal serviceTotal;
    private Decimal invoiceTotal;
    private Decimal newInvoiceTotal;
    private Decimal adjustmentTotal;
    private KenanInvoiceDetailService kenanService;

    public KenanInvoiceControllerExt(ApexPages.StandardController stdController) {
        UM_InvoiceHeader__c invoiceHeader = (UM_InvoiceHeader__c) stdController.getRecord();
        this.kenanService = new KenanInvoiceDetailService();
        this.kenanInvoiceHeader = kenanService.getInvoiceHeader(invoiceHeader.Id, KENAN_INVOICE_HEADER_FIELD_SET);
        this.accountFieldSetNames = getFieldSetNames(KENAN_INVOICE_ACCOUNT_FIELD_SET);
        this.paymentFieldSetNames = getFieldSetNames(KENAN_INVOICE_PAYMENT_FIELD_SET);
        this.serviceFieldSetNames = getFieldSetNames(KENAN_INVOICE_SERVICE_FIELD_SET);
        this.adjustmentFieldSetNames = getFieldSetNames(KENAN_INVOICE_ADJUSTMENT_FIELD_SET);
        this.accountLevelInvoiceItems = new List<InvoiceItem__x>();
        this.invoiceTotalItems = new List<InvoiceItem__x>();
        this.adjustmentItems = new List<InvoiceItem__x>();
        this.paymentInvoiceItems = new List<InvoiceItem__x>();
        this.serviceWrappers = new List<KenanServiceInvoiceItemWrapper>();
        this.kenanInvoiceItems = getInvoiceDetailItems();
    }

    /**
    * Cancels the page operation and returns to the account detail page
    * @return PageReference
    */
    public PageReference cancel() {
        return new PageReference('/' + this.kenanInvoiceHeader.UM_Customer_SF_ID__c);
    }
    
    public PageReference Case(){
    
    List<FieldDefinition> fieldDefs=[SELECT DurableId,QualifiedApiName FROM FieldDefinition WHERE EntityDefinition.QualifiedApiName = 'Case' and QualifiedApiName in ('LG_Billing_Account__c','LG_Invoice_Header__c')]; 
    
    List<String> BillingId = fieldDefs[0].DurableId.Split('\\.'); 
    List<String> InvoiceHead = fieldDefs[1].DurableId.Split('\\.'); 
    Id RType = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.Care_B2B_RecordType_Billing_Query).getRecordTypeId();
    String InvoiceId= ApexPages.CurrentPage().getParameters().get('id');
        
    for(UM_InvoiceHeader__c Invoice:[Select id, UM_Billing_Location__r.Name,UM_Customer_SF_ID__c,UM_Billing_Location__c,UM_InvoiceNumber__c from UM_InvoiceHeader__c where id=:InvoiceId Limit 1])
    {
        InvoiceAccount=Invoice.UM_Customer_SF_ID__c;
        BillingAccount=Invoice.UM_Billing_Location__r.Name;
        InvId=Invoice.id;  
        InvoiceNumber=Invoice.UM_InvoiceNumber__c;
        
        URL='/500/e?retURL=%2F500%2Fo&cas4_lkid='+InvoiceAccount+'&CF'+BillingId[1]+'='+BillingAccount+'&CF'+InvoiceHead[1]+'='+InvoiceNumber+'&RecordType='+RType+'&ent=Case';
    }
    
    PageReference PageRef= new PageReference(URL);
    PageRef.SetRedirect(true);
    return PageRef;
   }
   

    /**
    * Retrieve the field set fields
    * @return List<FieldSetMember>
    */
    private List<FieldSetMember> getFieldSetNames(String fieldSetName) {
        Map<String, Schema.FieldSet> FsMap = InvoiceItem__x.SObjectType.getDescribe().fieldSets.getMap();
        FieldSet fSet;

        for (Schema.FieldSet fs: fsMap.values()) {
            if (fs.getName() == fieldSetName) {
                fSet = fs;
            }
        }

        if (fSet != null) {
            return fSet.getFields();
        }

        return null;
    }

    /**
    * Retrieve the invoice header record associated with the account
    * @return UM_InvoiceHeader__c
    */
    public UM_InvoiceHeader__c getInvoiceHeader() {
        return this.kenanInvoiceHeader;
    }

    /**
    * Retrieve the list of invoice item records associated with the header
    * @return List<InvoiceItem__x>
    */
    public List<InvoiceItem__x> getInvoiceItems() {
        return this.kenanInvoiceItems;
    }

    /**
    * Method used to pass the List of fields for the account level items
    * @return List<FieldSetMember>
    */
    public List<FieldSetMember> getAccountFields(){
        return this.accountFieldSetNames; 
    }

    /**
    * Method used to pass the List of fields for the adjustment items
    * @return List<FieldSetMember>
    */
    public List<FieldSetMember> getAdjustmentFields(){
        return this.adjustmentFieldSetNames; 
    }

    /**
    * Method used to pass the List of fields for the payment items
    * @return List<FieldSetMember>
    */
    public List<FieldSetMember> getPaymentFields(){
        return this.paymentFieldSetNames; 
    }

    /**
    * Method used to pass the List of fields for the service items
    * @return List<FieldSetMember>
    */
    public List<FieldSetMember> getServiceFields(){
        return this.serviceFieldSetNames; 
    }

    /**
    * Get the list of account level invoice items
    * @return List<InvoiceItem__x>
    */
    public List<InvoiceItem__x> getAccountLevelInvoiceItems() {
        KenanLogUtils.logInfo('getAccountLevelInvoiceItems', accountLevelInvoiceItems.size());
        return this.accountLevelInvoiceItems;
    }

    /**
    * Get the list of invoice total items
    * @return List<InvoiceItem__x>
    */
    public List<InvoiceItem__x> getInvoiceTotalItems() {
        KenanLogUtils.logInfo('getInvoiceTotalItems', invoiceTotalItems.size());
        return this.invoiceTotalItems;
    }

    /**
    * Get the list of adjustment items
    * @return List<InvoiceItem__x>
    */
    public List<InvoiceItem__x> getAdjustmentItems() {
        KenanLogUtils.logInfo('getAdjustmentItems', adjustmentItems.size());
        return this.adjustmentItems;
    }

    /**
    * Get the list of payments on the invoice.
    * @return List<InvoiceItem__x>
    */
    public List<InvoiceItem__x> getPaymentInvoiceItems() {
        KenanLogUtils.logInfo('getPaymentInvoiceItems', paymentInvoiceItems.size());
        return this.paymentInvoiceItems;
    } 

    /**
    * Get the list of services and their invoice items
    * @return List<KenanServiceInvoiceItemWrapper>
    */
    public List<KenanServiceInvoiceItemWrapper> getServiceWrappers() {
        return this.serviceWrappers;
    } 

    /**
    * Get the overall account level total amount
    */
    public Decimal getAccountLevelTotal() {
        return this.accountLevelTotal;
    }

    /**
    * Get the overall invoice total amount
    */
    public Decimal getInvoiceTotal() {
        return this.invoiceTotal;
    }

    /**
    * Get the overall invoice total amount
    */
    public Decimal getNewInvoiceTotal() {
        return this.newInvoiceTotal;
    }
    /**
    * Get the overall adjustment amount
    */
    public Decimal getAdjustmentTotal() {
        return this.adjustmentTotal;
    }

    /**
    * Get the overall payment total amount
    */
    public Decimal getPaymentTotal() {
        return this.paymentTotal;
    }

    /**
    * Get the overall service total amount
    */
    public Decimal getServiceTotal() {
        return this.serviceTotal;
    }

    /**
    * Retrieve invoice detail items for the given invoice header.
    * @return List<InvoiceItem__x>
    */
    private List<InvoiceItem__x> getInvoiceDetailItems() {
        List<InvoiceItem__x> kenanInvoiceItems = new List<InvoiceItem__x>();
        
        List<String> fieldList = getFieldSetFields();

        if (!fieldList.isEmpty()) {
            String fieldStr = String.join(fieldList, ', ');
            String invoiceNum = this.kenanInvoiceHeader.UM_InvoiceNumber__c;
            KenanInvoiceDetailResponse response = kenanService.queryInvoiceItems(fieldStr, invoiceNum);
            
            
            
            if (response.success) {
                this.accountLevelInvoiceItems = response.accountLevelInvoiceItems;
                this.invoiceTotalItems = response.invoiceTotalItems;
                this.adjustmentItems = response.adjustmentItems;
                this.paymentInvoiceItems = response.paymentInvoiceItems;
                this.accountLevelTotal = response.accountLevelTotal;
                this.invoiceTotal = response.invoiceTotal;
                this.newInvoiceTotal = response.newInvoiceTotal;
                this.adjustmentTotal = response.adjustmentTotal;
                this.paymentTotal = response.paymentTotal;
                this.serviceTotal = response.serviceTotal;

                for (String serviceName: response.serviceToInvoiceItems.keySet()) {
                    List<InvoiceItem__x> invoiceItems = response.serviceToInvoiceItems.get(serviceName);
                    InvoiceItem__x invoiceItem = 
                        (response.serviceToSummaryItem.containsKey(serviceName)) ? 
                            response.serviceToSummaryItem.get(serviceName): 
                            new InvoiceItem__x(amount__c = 0);

                    KenanServiceInvoiceItemWrapper serviceWrapper = new KenanServiceInvoiceItemWrapper(
                        serviceName,
                        invoiceItems,
                        invoiceItem
                    );

                    this.serviceWrappers.add(serviceWrapper);
                }
            }
        }

        return kenanInvoiceItems;
    }

    /**
     * Get all fields from field sets, but remove duplicates
     * @return List<String>
     */  
    private List<String> getFieldSetFields() {
        Set<String> fieldListSet = new Set<String>();

        fieldListSet.add('ExternalId');
        fieldListSet.add('billingLevel__c');
        fieldListSet.add('openItemId__c');
        
        for (FieldSetMember field: this.accountFieldSetNames) {
            fieldListSet.add(field.getFieldPath());
        }

        for (FieldSetMember field: this.paymentFieldSetNames) {
            fieldListSet.add(field.getFieldPath());
        }

        for (FieldSetMember field: this.serviceFieldSetNames) {
            fieldListSet.add(field.getFieldPath());
        }

        List<String> fieldList = new List<String>(fieldListSet);

        return fieldList;
    }

    /**
     * Wrapper for holding services, their invoice details, and summary invoice item
     */
    public class KenanServiceInvoiceItemWrapper {
        public String serviceName { get; set; }
        public List<InvoiceItem__x> invoiceItems { get; set; }
        public InvoiceItem__x summaryItem { get; set; }
        public String summaryLabel { get; set; }

        public KenanServiceInvoiceItemWrapper(String serviceName, List<InvoiceItem__x> invoiceItems, InvoiceItem__x summaryItem) {
            this.serviceName = serviceName;
            this.invoiceItems = invoiceItems;
            this.summaryItem = summaryItem;
            this.summaryLabel = String.format(System.Label.KenanInvoicePageSummaryTotalLabel, new List<String>{ serviceName });
            system.debug('invoiceItems:' + invoiceItems[0]);
        }
    }
}