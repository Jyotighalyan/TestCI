/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanAdjustmentControllerExt Controller Extension used with KenanAdjustment VF Page
*/

public with sharing class KenanAdjustmentControllerExt {

    public static final String KENAN_INVOICE_FIELD_SET = 'Kenan_Adjustment';
    public static final String KENAN_INVOICE_DETAIL_FIELD_SET = 'Kenan_Adjustment';
    public static final String KENAN_ADJUSTMENT_FIELD_SET = 'Kenan_Adjustment';
    public static final String KENAN_ADJUSTMENTITEM_FIELD_SET = 'Kenan_AdjustmentItem';
    
    public static final String KENAN_ADJUSTMENT_TYPE_MISC = 'miscellaneous adjustment';
    public static final String KENAN_ADJUSTMENT_TYPE_RC = 'adjustment against recurring charge';
    public static final String KENAN_ADJUSTMENT_TYPE_NRC = 'adjustment against non-recurring charge';
    public static final String KENAN_ADJUSTMENT_TYPE_ADJ = 'adjustment against an adjustment';
    public static final String KENAN_ADJUSTMENT_TYPE_TAX = 'adjustment against nondistributed taxes';
    public static final String KENAN_ADJUSTMENT_TYPE_USE = 'adjustment against usage charge';

    private static Map<String, String> adjustmentTypeMap = new Map<String, String>{
        '1' => null,
        '2' => KENAN_ADJUSTMENT_TYPE_RC,
        '3' => KENAN_ADJUSTMENT_TYPE_NRC,
        '4' => null,
        '5' => null,
        '6' => null,
        '7' => KENAN_ADJUSTMENT_TYPE_USE
    };

    
    private ApexPages.StandardController controller;
    private UM_InvoiceHeader__c kenanInvoiceHeader;
    private InvoiceItem__x kenanInvoiceItem;
    private Kenan_Adjustment__c adjustment;
    private List<FieldSetMember> fieldSetInvoice;
    private List<FieldSetMember> fieldSetInvoiceItem;
    private List<FieldSetMember> fieldSetAdjustment;
    private List<FieldSetMember> fieldSetItemAdjustment;
    private KenanServiceConnection__c settings = KenanServiceConnection__c.getInstance();
    private Invoice__x invoiceHeader;
    private Account__x externalAccount;

    @TestVisible
    private KenanInvoiceDetailService invoiceDetailService;
    private KenanAdjustmentService adjustmentService;

    public KenanAdjustmentControllerExt(ApexPages.StandardController controller) {
        this.adjustment = (Kenan_Adjustment__c) controller.getRecord();
        setupControllerExt();
    }

    private void setupControllerExt() {
        this.invoiceDetailService = new KenanInvoiceDetailService();
        this.adjustmentService = new KenanAdjustmentService();
        getFieldSetNames();
               
        if (this.adjustment.Invoice_Item__c != null){
            system.debug('adjustment.Invoice_Item__c != null');
            getInvoiceDetailItem(this.adjustment.Invoice_Item__c);
        } 
        else if (ApexPages.currentPage().getParameters().get('itemId') != null){
            String invoiceItemId = ApexPages.currentPage().getParameters().get('itemId');
            system.debug('using querystring param:' + invoiceItemId);
            getInvoiceDetailItem(invoiceItemId);
            this.adjustment.Invoice_Item__c = this.kenanInvoiceItem.ExternalId;
            getInvoiceHeader(kenanInvoiceItem.billRefNo__c, kenanInvoiceItem.billRefResets__c);    
        }

        String headerId;
        if (this.adjustment.Invoice_Header__c != null){
            headerId = this.adjustment.Invoice_Header__c;
        } else if (ApexPages.currentPage().getParameters().get('invoiceId') != null) {
            headerId = ApexPages.currentPage().getParameters().get('invoiceId');

        }

        this.kenanInvoiceHeader = invoiceDetailService.getInvoiceHeader(headerId);
        
        String invNumber = kenanInvoiceHeader.UM_InvoiceNumber__c;
        String[] invNumbers;
        if(invNumber.contains('-')){
            invNumbers = invNumber.split('-');
        } else {
            invNumbers = invNumber.split('\\.');
        }
        
        adjustment.billRefNo__c =  invNumbers[0];
        adjustment.billRefResets__c = invNumbers[1];
        this.adjustment.Invoice_Header__c = kenanInvoiceHeader.Id;
        getExternalHeader(adjustment.billRefNo__c, adjustment.billRefResets__c);
        String adjustmentType = getAdjustmentType(this.kenanInvoiceItem);
        if (adjustmentType != null) {
            this.adjustment.Adjustment_Type__c = adjustmentType;
        }
    }

    @TestVisible
    private static String getAdjustmentType(InvoiceItem__x invoiceItem) {
        String adjustmentType = null;
        if (invoiceItem == null) {
            adjustmentType = KENAN_ADJUSTMENT_TYPE_MISC;
        } else if (adjustmentTypeMap.get(invoiceItem.typeCode__c) != null) {
            adjustmentType = adjustmentTypeMap.get(invoiceItem.typeCode__c);
        }
        return adjustmentType;
    }

     /**
    * Cancels the page operation and returns to the account detail page
    * @return PageReference
    */
    public PageReference cancel() {
        return new PageReference('/' + this.kenanInvoiceHeader.UM_Customer_SF_ID__c);
    }

    public PageReference saveAdjustment(){
        PageReference pr;
        System.debug('Save clicked:');
        adjustment.primaryUnitsType__c = '403';
        adjustment.primaryUnits__c = '0';
        adjustment.fraudIndicator__c = '0';

        Kenan_Adjustment__c tempAdj = adjustment.clone();

        KenanAdjustment adj = new KenanAdjustment();
        adj.adjReasonCode = adjustment.Adjustment_Reason__c;
        adj.billRefNo = Integer.valueOf(adjustment.billRefNo__c);
        adj.billRefResets = Integer.valueOf(adjustment.billRefResets__c);
        adj.effectiveDate = adjustment.Effective_Date__c;
        adj.primaryUnitsType = adjustment.primaryUnitsType__c;
        adj.primaryUnits = adjustment.primaryUnits__c;
        adj.fraudIndicator = adjustment.fraudIndicator__c;
        adj.origType = adjustment.Adjustment_Type__c;
        adj.requestStatus = adjustment.requestStatus__c;
        adj.totalAmt = adjustment.Total_Amount__c;
        adj.invoiceItem = adjustment.Invoice_Item__c;
        adj.openItemId = adjustment.Open_Item__c;
        adj.accountExternalId = adjustment.accountExternalId__c;
        adj.accountExternalIdType = Integer.valueOf(adjustment.accountExternalIdType__c);
        adj.revRcvCostCtr = adjustment.revRcvCostCtr__c;

        if (kenanInvoiceItem != null){
            adj.currencyCode = kenanInvoiceItem.currencyCode__c;    
        } 
        else {
            adj.currencyCode = getCurrencyDisplayValue(invoiceHeader.currencyCode__c);
        }
        System.debug('adj.revRcvCostCtr:' + adj.revRcvCostCtr);

        adjustment = null;
        try {
            KenanAdjustmentService service = new KenanAdjustmentService();
            adj = (KenanAdjustment) service.insertRow(adj, 'POST', '');    
            system.debug('KenanAdjustment:' + adj);
            tempAdj.trackingId__c = String.valueOf(adj.trackingId);
            tempAdj.trackingIdServ__c = String.valueOf(adj.trackingIdServ);
            tempAdj.Adjustment_Type__c = adj.origType;
            insert tempAdj;
            pr = new ApexPages.StandardController(tempAdj).view();
            pr.setRedirect(true);

        } catch (KenanException e){
            System.debug('Caught an error, setting it on the page: ' + e.message);

            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.friendlyErrorMessage + '\n' + e.message));
            adjustment = tempAdj;
        }
        
        return pr;
    }

    public Kenan_Adjustment__c getAdjustment(){
        return this.adjustment;
    }
    
    /**
    * Retrieve the field set fields to display on kenan invoice page
    * @return List<FieldSetMember>
    */
    private void getFieldSetNames() {
        // Get Invoice Header Fieldsets
        Map<String, Schema.FieldSet> fsMap = UM_InvoiceHeader__c.SObjectType.getDescribe().fieldSets.getMap();
        for (Schema.FieldSet fs: fsMap.values()) {
            if (fs.getName() == KENAN_INVOICE_FIELD_SET) {
                fieldSetInvoice = fs.getFields();
            }
        }

        // Get Invoice Item Fieldset
        fsMap = InvoiceItem__x.SObjectType.getDescribe().fieldSets.getMap();
        for (Schema.FieldSet fs: fsMap.values()) {
            if (fs.getName() == KENAN_INVOICE_DETAIL_FIELD_SET) {
                fieldSetInvoiceItem = fs.getFields();
            }
        }

        // Get Invoice Item Fieldset
        fsMap = Kenan_Adjustment__c.SObjectType.getDescribe().fieldSets.getMap();
        system.debug('this.adjustment.Invoice_Item__c:' + this.adjustment.Invoice_Item__c);
        for (Schema.FieldSet fs: fsMap.values()) {
            if (fs.getName() == KENAN_ADJUSTMENT_FIELD_SET) {
                fieldSetAdjustment = fs.getFields();
            } 
            else if (fs.getName() == KENAN_ADJUSTMENTITEM_FIELD_SET) {
                fieldSetItemAdjustment = fs.getFields();
            }
        }
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
    * @return InvoiceItem__x
    */
    public InvoiceItem__x getInvoiceItem() {
        return this.kenanInvoiceItem;
    }

    ///**
    //* Retrieve the list of invoice item records associated with the header
    //* @return Adjustment__x
    //*/
    //public Adjustment__x getAdjustmentItem() {
    //    return this.adjustment;
    //}

    /**
    * Method used to pass the List of Invoice fields to be rendered on the Visualforce Page.
    * @return List<FieldSetMember>
    */
    public List<FieldSetMember> getInvoiceFields(){
        return this.fieldSetInvoice; 
    }

    /**
    * Method used to pass the List of Invoice Detail fields to be rendered on the Visualforce Page.
    * @return List<FieldSetMember>
    */
    public List<FieldSetMember> getInvoiceItemFields(){
        return this.fieldSetInvoiceItem; 
    }

    /**
    * Method used to pass the List of Adjustment fields to be rendered on the Visualforce Page.
    * @return List<FieldSetMember>
    */
    public List<FieldSetMember> getAdjustmentFields(){
        if (adjustment.Invoice_Item__c == null){
            return this.fieldSetAdjustment;     
        }
        else {
            return this.fieldSetItemAdjustment; 
        }
        
    }

    /**
    * Retrieve invoice detail item for the given adjustment.
    * @return List<InvoiceItem__x>
    */
    private void getInvoiceDetailItem(String itemId) {
        if (itemId != null){
            List<String> fieldList = new List<String>();

            for (FieldSetMember field: this.fieldSetInvoiceItem) {
                fieldList.add(field.getFieldPath());
            }

            if (!fieldList.isEmpty()) {
                fieldList.add('billRefNo__c');
                fieldList.add('billRefResets__c');
                fieldList.add('typeCode__c');
                String fieldStr = String.join(fieldList, ', ');
                if (Test.isRunningTest()){
                    kenanInvoiceItem = new InvoiceItem__x();
                    kenanInvoiceItem.billRefNo__c = '1401';
                    kenanInvoiceItem.billRefResets__c = '0';
                }
                else {
                    this.kenanInvoiceItem = invoiceDetailService.queryInvoiceItem(fieldStr, itemId);    
                }
                
            }
        }
    }

    private void getInvoiceHeader(String billRefNo, String billRefResets){
        String invExtId = billRefNo + settings.BillRefNo_BillRefResets_delimiter__c + billRefResets;
        this.kenanInvoiceHeader = [SELECT Id, Name FROM UM_InvoiceHeader__c WHERE UM_InvoiceNumber__c = :invExtId LIMIT 1];
        this.adjustment.Invoice_Header__c = this.kenanInvoiceHeader.Id;
        this.adjustment.billRefNo__c = String.valueOf(billRefNo);
        this.adjustment.billRefResets__c = String.valueOf(billRefResets);

    }

    private void getExternalHeader(String billRefNo, String billRefResets){
        System.debug('getExternalHeader:' + billRefNo + ':' + billRefResets);
        String invExtId = String.valueOf(billRefNo) + settings.BillRefNo_BillRefResets_delimiter__c + String.valueOf(billRefResets);
        
        if (Test.isRunningTest()){
            invoiceHeader = new Invoice__x();
            invoiceHeader.currencyCode__c = '7';
            invoiceHeader.accountInternalId__c = '1';
        }
        else {
            this.invoiceHeader = [SELECT currencyCode__c, accountInternalId__c FROM Invoice__x WHERE ExternalId = :invExtId LIMIT 1];    
        }

        this.adjustment.currencyCode__c = getCurrencyDisplayValue(invoiceHeader.currencyCode__c);
        this.adjustment.accountExternalId__c = invoiceHeader.accountInternalId__c;
        this.adjustment.accountExternalIdType__c = '1';
        getExternalAccount(invoiceHeader.accountInternalId__c);
    }

    private void getExternalAccount(String accountInternalId){
        if(Test.isRunningTest()){
            externalAccount = new Account__x();
            externalAccount.revRcvCostCtr__c = '101';
        }
        else {
            externalAccount = [SELECT revRcvCostCtr__c FROM Account__x WHERE ExternalId = :accountInternalId LIMIT 1];
        }
        System.debug('externalAccount:' + externalAccount);
        this.adjustment.revRcvCostCtr__c = externalAccount.revRcvCostCtr__c;
    }

    public List<SelectOption> getReasonCodes(){
        List<AdjustmentReasonBean__mdt> items = [SELECT AdjReasonCode__c, DisplayValue__c FROM AdjustmentReasonBean__mdt];
        List<SelectOption> options = new List<SelectOption>();
        for (AdjustmentReasonBean__mdt item : items){
            options.add(new SelectOption(item.DisplayValue__c, item.DisplayValue__c));
        }
        return options;
    }

    public List<SelectOption> getAdjustmentTypes(){
        List<SelectOption> options = new List<SelectOption>();
        List<AdjustmentOrigType__mdt> items = [SELECT MasterLabel, OrigType__c FROM AdjustmentOrigType__mdt];
        for (AdjustmentOrigType__mdt item : items){
            options.add(new SelectOption(item.MasterLabel, item.MasterLabel));
        }
        return options;
    }

    public List<SelectOption> getAdjustmentStatuses(){
        List<SelectOption> options = new List<SelectOption>();
        List<AdjustmentStatus__mdt> items = [SELECT MasterLabel, requestStatus__c FROM AdjustmentStatus__mdt];
        for (AdjustmentStatus__mdt item : items){
            options.add(new SelectOption(item.MasterLabel, item.MasterLabel));
        }
        return options;
    }

    private String getCurrencyDisplayValue(String currencyCode){
        return KenanEnumerationHelper.getEnumDisplayValue('RateCurrencyBean__mdt', 'CurrencyCode__c', currencyCode, settings.Stored_Language_Code__c, 'ShortDisplay__c');
    }
}