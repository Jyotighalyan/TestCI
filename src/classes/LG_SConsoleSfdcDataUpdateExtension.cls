public class LG_SConsoleSfdcDataUpdateExtension extends LG_ServiceConsoleBase {

    @TestVisible
    private final Case cs { get; set; }

    @TestVisible
    private csord__Solution__c solutionObject { get; set; }



    public String caseRecordType { get; set; }
    public boolean caseClosed {get;set;}
    public String errorMessage {get;set;}

    public csord__Solution__c getSolution() {

        if (this.solutionObject == null) {
            this.solutionObject = getSolutionRecord();
        }

        return this.solutionObject;
    }

    @TestVisible
    private List<csord__Service__c> serviceObject { get; set; }

    public List<csord__Service__c> getService() {

        if (this.serviceObject == null) {
            this.serviceObject = getServiceRecords();
        }

        return this.serviceObject;
    }

    @TestVisible
    private List<BillingDetails> billingDetails { get; set; }

    public List<BillingDetails> getBillingDetails() {

        if (this.billingDetails == null) {
            this.billingDetails = getBillingDetailRecords();
        }

        return this.billingDetails;
    }

    @TestVisible
    private List<ProvisioningDetails> provisioningDetails { get; set; }

    public List<ProvisioningDetails> getProvisioningDetails() {

        if (this.provisioningDetails == null) {
            this.provisioningDetails = getProvisioningDetailsRecords();
        }

        return this.provisioningDetails;
    }

    @TestVisible
    private LG_ProductConfigurationUtil util { get; set; }


    public LG_SConsoleSfdcDataUpdateExtension (ApexPages.StandardController stdController) {
        if (!Test.isRunningTest()) {
            List<String> defaultFields = new List<String>();

            defaultFields.add('LG_Service__c');
            defaultFields.add('LG_Solution__c');
            defaultFields.add('LG_Order__c');
            defaultFields.add('Status');
            defaultFields.add('RecordType.Name');
            defaultFields.add('Type');
            stdController.addFields(defaultFields);
            this.cs = (Case)stdController.getRecord();

        } else {
            this.cs = [select LG_Service__c, LG_Solution__c, LG_Order__c, Status,type, RecordType.Name from Case];
        }
        System.debug('Case' + this.cs);
        this.caseRecordType = getRecordType();
        getService();
        caseClosed = false;
        /*SFOM-1570 - Added by Ankur Gupta
         * To show the detail page for Update CustomerType case for CaMa before/after closing the case
         */
        if(getCamaCustomerType() || this.cs.Status == 'Closed') {
            caseClosed = True;
        } else {
            edit();
        }
    }


    private csord__Solution__c getSolutionRecord() {
        csord__Solution__c solution;
        List<csord__Solution__c> solutionList = new List<csord__Solution__c>();
        Id solId = this.cs.LG_Solution__c;
        if (solId != null) {
            solutionList = [SELECT Id, Name,LG_Solution_Name__c, LG_Integration_Status__c, LG_Address__c, csord__Account__c, csord__Order__c,
                            csord__Status__c, csordtelcoa__Product_Configuration__c,LG_ProvisioningAccountNo__c,
                            LG_ProvisioningWorkOrder__c, csord__Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c,
                            CreatedById, OwnerId, csord__Identification__c, csord__Order_Request__c,
                            csord__Order__r.csordtelcoa__Opportunity__c, csord__Order__r.csord__Account__c,
                            LG_Address__r.LG_Icomms_Premise_ID__c, LG_Address__r.LG_Icomms_Site_ID__c
                            FROM csord__Solution__c WHERE Id = :this.cs.LG_Solution__c];
        }

        if(solutionList.size() > 0){
            solution = solutionList[0];
        }else {
            solution = new csord__Solution__c();
        }
        return solution;
    }

    public List<csord__Service__c> getServiceRecords() {
        List<csord__Service__c> serviceRecordList;
        if (this.cs.LG_Solution__c != null) {
            serviceRecordList = [SELECT Id, Name,
                                 LG_ProvisioningCode__c,
                                 LG_Address__c,
                                 LG_Suborder__c,
                                 LG_Address__r.LG_FullAddressDetails__c,
                                 LG_Address__r.Name,
                                 LG_ServiceStatus__c,
                                 csord__Status__c,
                                 LG_ProvisioningAccountNo__c,
                                 LG_Provision_Valid__c,
                                 csordtelcoa__Product_Configuration__c,
                                 csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name,
                                 csordtelcoa__Product_Basket__r.LG_BillingAccount__r.LG_ExternalId__c,
                                 LG_Product_Category__c,
                                 csordtelcoa__Delta_Status__c,
                                 LG_Action__c
                                 FROM csord__Service__c
                                 WHERE LG_Suborder__c = :this.cs.LG_Solution__c];
        } else {
            serviceRecordList = new List<csord__Service__c>();
        }

        return serviceRecordList;
    }

    public List<ProvisioningDetails> getProvisioningDetailsRecords() {

        List<ProvisioningDetails> provisionList;
        List<Id> prodConfIdList = new List<Id>();

        if (serviceObject.size() > 0) {

            provisionList = new List<ProvisioningDetails>();
            // Get Product Configuration IDs from service record
            for (csord__Service__c serviceRecord : serviceObject) {
                prodConfIdList.add(serviceRecord.csordtelcoa__Product_Configuration__c);
            }

            // Instantiate Product Configuration Util
            util = new LG_ProductConfigurationUtil(prodConfIdList);
            for (csord__Service__c serviceRecord : serviceObject) {
                ProvisioningDetails provisioningDetails = new ProvisioningDetails(this.caseRecordType, serviceRecord);
                provisioningDetails.address = ', '+serviceRecord.LG_Address__r.LG_FullAddressDetails__c;
                if (serviceRecord.csordtelcoa__Product_Configuration__c != null) {
                    String keyAttributes = util.getKeyAttributesPerProdConf(serviceRecord.csordtelcoa__Product_Configuration__c);
                    if (keyAttributes != '') {
                        provisioningDetails.keyAttribute = '(' + keyAttributes + ')';
                    }
                }
                provisionList.add(provisioningDetails);
            }
        }
        return provisionList;
    }


    public List<BillingDetails> getBillingDetailRecords(){
        List<BillingDetails> billingDetailList;
        if (serviceObject.size() > 0) {
            billingDetailList = new List<BillingDetails>();
            Map<String, List<csord__Service_Line_Item__c>> serviceLineItemMap;
            serviceLineItemMap = getServiceLineItemRecords();
            for (csord__Service__c serviceRecord : serviceObject) {
                BillingDetails billing = new BillingDetails();
                billing.serviceName = serviceRecord.Name;
                billing.parent = true;
                billingDetailList.add(billing);
                if(serviceLineItemMap.containsKey(serviceRecord.Id)) {
                    List<csord__Service_Line_Item__c> serviceLineItemList = serviceLineItemMap.get(serviceRecord.Id);
                    for(csord__Service_Line_Item__c serviceLineItem : serviceLineItemList){
                        BillingDetails billingLineItem = new BillingDetails();
                        billingLineItem.serviceLineItem = serviceLineItem;
                        billingDetailList.add(billingLineItem);
                    }
                }

            }
        }
        return billingDetailList;
    }

    public Map<String,List<csord__Service_Line_Item__c>> getServiceLineItemRecords() {
        Map<String, List<csord__Service_Line_Item__c>> serviceLineItemMap = new Map<String, List<csord__Service_Line_Item__c>>();
        List<csord__Service_Line_Item__c>  serviceLineItemList = new List<csord__Service_Line_Item__c>();
        serviceLineItemList = [SELECT Id, Name, csord__Line_Description__c, csord__Total_Price__c, LG_BillingProductId__c, LG_BillingAccount__c, LG_BillingAccount__r.Name, LG_BillingAccount__r.LG_ExternalId__c, csord__Service__c,csordtelcoa__Delta_Status__c, LG_Action__c  FROM csord__Service_Line_Item__c WHERE csord__Service__c IN :serviceObject];
        for (csord__Service_Line_Item__c serviceLineItems : serviceLineItemList) {

            if(serviceLineItemMap.containsKey(serviceLineItems.csord__Service__c)) {
                List<csord__Service_Line_Item__c>  serviceLineItemRecords = serviceLineItemMap.get(serviceLineItems.csord__Service__c);
                serviceLineItemRecords.add(serviceLineItems);
                serviceLineItemMap.put(serviceLineItems.csord__Service__c, serviceLineItemRecords);
            }else{
                serviceLineItemMap.put(serviceLineItems.csord__Service__c, new List<csord__Service_Line_Item__c>{serviceLineItems});
            }

        }
        return serviceLineItemMap;
    }

    public String getRecordType() {
        return this.cs.RecordType.Name;
    }

    public Boolean getProvisioning() {
    return this.cs.RecordType.Name == 'Legacy Fulfilment';
    }

    //added for sfom-1486
    public Boolean getCama() {
    return this.cs.RecordType.Name == 'Cama PendingOrder';
    }

    public Boolean getCamaCustomerType() {
    return this.cs.RecordType.Name == 'Cama Customer Type';
    }
    public PageReference edit() {
        setMode(DisplayMode.edit);
        return null;
    }

    public PageReference save() {
            //added for sfom-1486
           map<id,csord__Service__c> serviceToUpdate =new map<id,csord__Service__c>();

           if(serviceObject.size()>0 && this.cs.RecordType.Name == 'Cama PendingOrder')
           {
             for (csord__Service__c serviceRec : serviceObject)
             {   system.debug('**serviceRec'+serviceRec.id);
                 serviceRec.LG_ProvisioningAccountNo__c=this.solutionObject.LG_ProvisioningAccountNo__c;
                 serviceToUpdate.put(serviceRec.id,serviceRec);
             }
           }



        try{
            this.solutionObject.LG_Integration_Status__c='Work Order Created';
            //SFOM-1507 change
            if (this.solutionObject.csord__Status__c == 'In Progress') {
               this.solutionObject.csord__Status__c = 'In Provisioning';
            }
            update this.solutionObject;
             //added for sfom-1486
            if(serviceToUpdate.values()!=null)
            {
                Update serviceToUpdate.values();
            }


        }catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Some error occured ' + e.getMessage()));
            setMode(DisplayMode.edit);
            return null;
        }
        errorMessage = System.Label.LG_MessageSavedSuccessfully;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, errorMessage));
        setMode(DisplayMode.detail);
        return null;
    }

    public PageReference cancel() {
        setMode(DisplayMode.detail);
        return PageRefresh();
    }

    public PageReference PageRefresh() {
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }


    @TestVisible
    public class ProvisioningDetails {

        public csord__Service__c service {get; set;}
        public String address {get; set;}
        public String keyAttribute {get; set;}

        public ProvisioningDetails(String cRecordType, csord__Service__c obj) {
            this.service = obj;
            String productDefinition = obj.csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name;
        }
    }

    @TestVisible
    public class BillingDetails {
        public String serviceName {get; set;}
        public csord__Service_Line_Item__c serviceLineItem {get; set;}
        public boolean parent {get; set;}
    }

}