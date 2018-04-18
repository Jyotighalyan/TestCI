public class LG_SConsoleProvisionDetailsExtension extends LG_ServiceConsoleBase {
    @TestVisible
    private final Case cs { get; set; }
    Boolean flag=false;

    @TestVisible
    private csord__Solution__c solutionObject { get; set; }

    public String caseRecordType { get; set; }
    public boolean caseClosed {get;set;}
    //Changes Start for DGT-381
    Public  List<csord__Service__c> listOfFilteredBDSServices{get;set;}
    public List<csord__Service__c> listOfFilteredBDSServicesPrimary;

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
    public List<Asset> getassetValues() 
    {
        List<Asset> assetValues ;

        if (this.serviceObject!= null) 
        {
            assetValues = [SELECT Id,csord__Service__c,LG_Logistics_Reference_Number__c,LG_Logistics_Supplier_Name__c  FROM Asset WHERE csord__Service__c IN :serviceObject LIMIT 1];
        }
        
        if(!assetValues.isEmpty())
        {
            return assetValues;
        }
        else
        {
        	return null;
        }
    }

    /*@TestVisible
    private List<csord__Service_Line_Item__c> serviceLineObject { get; set; }

    public List<csord__Service_Line_Item__c> getServiceLineItems() {

        if (this.serviceLineObject == null) {
            this.serviceLineObject = getServiceLineItemRecords();
        }

        return this.serviceLineObject;
    }*/
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

    //SFOM-245
    @TestVisible
    private LG_ConsoleSectionUtil consoleUtil {get; set;}

    public List<ProvisioningDetails> getProvisioningDetails() {

        if (this.provisioningDetails == null) {
            this.provisioningDetails = getProvisioningDetailsRecords();
        }

        return this.provisioningDetails;
    }

    @TestVisible
    private LG_ProductConfigurationUtil util { get; set; }

    @TestVisible
    //private LG_ScreenSectionUtil screenUtil { get; set; }
    public boolean jeopardy { get; set; }
    public boolean jeoExpMsg { get; set; }

    public LG_SConsoleProvisionDetailsExtension (ApexPages.StandardController stdController) {
        if (!Test.isRunningTest()) {
            List<String> defaultFields = new List<String>{'LG_Service__c','LG_Solution__c','LG_Order__c','Status','RecordType.Name','Type'};
            stdController.addFields(defaultFields);
            this.cs = (Case)stdController.getRecord();

        } else {
            this.cs = [select LG_Service__c,Type,LG_Solution__c, LG_Order__c, Status, RecordType.Name from Case];
        }
        System.debug('Case' + this.cs);
        this.caseRecordType = getRecordType();
        getService();
       // getlistOfBDSServicePrimary();
         //changes starts for SFOM-2768
        getassetValues();
        //changes end for SFOM-2768
		if(this.cs.Status == 'Closed')
        {
           caseClosed = True;
        } else {
            //Removed as a part of SFOM-1822
            //edit();
        }
    }

	private csord__Solution__c getSolutionRecord() {
        csord__Solution__c solution;
        List<csord__Solution__c> solutionList = new List<csord__Solution__c>();
        Id solId = this.cs.LG_Solution__c;
        if (solId != null) {
            solutionList = [SELECT Id, Name, LG_Solution_Name__c, LG_Address__c, LG_Address__r.LG_FullAddressDetails__c, csord__Account__c, csord__Order__c,
                   csord__Status__c, LG_Jeopardy__c, csordtelcoa__Product_Configuration__c, LG_JeopardyExplanation__c,
                   LG_ProvisioningWorkOrder__c, LG_TargetDate__c, LG_EarliestInstallDate__c,
                   CreatedById, OwnerId, csord__Identification__c, csord__Order_Request__c, Jeopardy_Reason__c,
                   csord__Order__r.csordtelcoa__Opportunity__c, csord__Order__r.csord__Account__c, csord__Order__r.csord__Account__r.LG_Huawei_Tenant_ID__c,
                   LG_Address__r.LG_Icomms_Premise_ID__c, LG_Address__r.LG_Icomms_Site_ID__c
                   FROM csord__Solution__c WHERE Id = :this.cs.LG_Solution__c];
        }

        if(solutionList.size() > 0){
            solution = solutionList[0];
            if (solution.LG_Jeopardy__c == true) {
                this.jeopardy = true;
            }
        }else {
            solution = new csord__Solution__c();
        }

        System.debug('Solution:' + solution);

        return solution;
    }

    public List<csord__Service__c> getServiceRecords() {
        List<csord__Service__c> serviceRecordList;
        if (this.cs.LG_Solution__c != null) {
            serviceRecordList = [SELECT Id, Name,
                          LG_ProvisioningCode__c,
                          LG_Address__c,
                          LG_Address__r.Name,
                          LG_Address__r.LG_HouseNumber__c,
                          LG_Address__r.cscrm__Street__c,
                          LG_Address__r.cscrm__City__c,
                          LG_Address__r.cscrm__Zip_Postal_Code__c,
                          LG_Address__r.cscrm__Country__c,
                          LG_Address__r.LG_FullAddressDetails__c,
                          LG_ServiceStatus__c,  //SFOM-245
                          csord__Status__c,  //SFOM-245
                          LG_Provision_Valid__c,//SFOM-356
                          csordtelcoa__Product_Configuration__c,
                          csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name,
                          LG_Product_Category__c,
                          csordtelcoa__Delta_Status__c, // SFOM-647
                          UM_ProvisioningServiceExternalId__c //SFOM-1822 - Temporary provisioning for BDS site
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
            //screenUtil = new LG_ScreenSectionUtil();

            for (csord__Service__c serviceRecord : serviceObject) {
                ProvisioningDetails provisioningDetails = new ProvisioningDetails(this.caseRecordType, serviceRecord);
                //Blocking if else condition as a part of SFOM-1822 - Changes will be reverted back once provisioning is automated
                //if(serviceRecord.LG_Provision_Valid__c == 'Yes'){
                  provisioningDetails.provisionFlag = 'Green.png';
               //}else{
                  //provisioningDetails.provisionFlag = 'Red.png';
               //}

                String address = serviceRecord.LG_Address__r.LG_FullAddressDetails__c;

                provisioningDetails.address = ', '+address;
                if (serviceRecord.csordtelcoa__Product_Configuration__c != null) {
                    String keyAttributes = util.getKeyAttributesPerProdConf(serviceRecord.csordtelcoa__Product_Configuration__c);
                    if (keyAttributes != '') {
                        provisioningDetails.keyAttribute = '(' + keyAttributes + ')';
                    }
                }

                //provisioningDetails.screenSection = screenUtil.getRelatedScreenFlowId(serviceRecord.Id, LG_ScreenSectionUtil.screenFlow.PROVISION);

                consoleUtil = new LG_ConsoleSectionUtil();  //SFOM-245
                provisioningDetails.selectList = consoleUtil.getSelectOptionValues(serviceRecord.LG_ServiceStatus__c, this.caseRecordType);

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

    /*public List<csord__Service_Line_Item__c> getServiceLineItemRecords() {
        List<csord__Service_Line_Item__c>  serviceLineItemList = new List<csord__Service_Line_Item__c>();
        for (csord__Service__c serviceRecord : serviceObject) {
            List<csord__Service_Line_Item__c>  lineItems = [SELECT Id, Name, csord__Line_Description__c, csord__Total_Price__c, LG_BillingProductId__c, LG_BillingAccount__c, LG_BillingAccount__r.Name, LG_BillingAccount__r.LG_ExternalId__c FROM csord__Service_Line_Item__c WHERE csord__Service__c = :serviceRecord.Id];
            serviceLineItemList.addAll(lineItems);
        }
        return serviceLineItemList;
    }*/

    public Map<String,List<csord__Service_Line_Item__c>> getServiceLineItemRecords() {
        Map<String, List<csord__Service_Line_Item__c>> serviceLineItemMap = new Map<String, List<csord__Service_Line_Item__c>>();
        List<csord__Service_Line_Item__c>  serviceLineItemList = new List<csord__Service_Line_Item__c>();
        serviceLineItemList = [SELECT Id, Name, csord__Line_Description__c, csord__Total_Price__c, LG_BillingProductId__c, LG_BillingAccount__c, LG_BillingAccount__r.Name, LG_BillingAccount__r.LG_ExternalId__c, csord__Service__c FROM csord__Service_Line_Item__c WHERE csord__Service__c IN :serviceObject];
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
        return this.cs.RecordType.Name == 'Provision';
    }

    /*
    * Page methods
    */
    public PageReference edit() {

        setMode(DisplayMode.edit);
        return null;
    }

    public PageReference save() {
        try {
            jeoExpMsg = false;
            this.solutionObject.LG_JeopardyRaisedBy__c = UserInfo.getUserId();
            if (jeopardy == true) {
                this.solutionObject.LG_Jeopardy__c = true;
            } else {
                this.solutionObject.LG_Jeopardy__c = false;
            }
            if (this.solutionObject.LG_Jeopardy__c == true && (this.solutionObject.LG_JeopardyExplanation__c == null || this.solutionObject.LG_JeopardyExplanation__c == '')) {
                jeoExpMsg = true;
                setMode(DisplayMode.edit);
                return null;
            } else {
                update this.solutionObject;
    //            update this.solutionObject.LG_Address__r;

                //SFOM-245
                List<csord__Service__c> serviceListUpdate = new List<csord__Service__c>();
                for (ProvisioningDetails provdata : this.provisioningDetails) {
                    if (provdata.selectList != null && provdata.selectList.size() > 0) {
                        provdata.service.csord__Status__c = provdata.service.LG_ServiceStatus__c;
                    }
                    serviceListUpdate.add(provdata.service);
                }
                update serviceListUpdate;
            }
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            setMode(DisplayMode.edit);
            return null;

        }

        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Saved Successfully.'));
        setMode(DisplayMode.detail);
        return null;
    }

    public PageReference cancel() {

        setMode(DisplayMode.detail);
        return null;
    }

    public PageReference PageRefresh() {
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }

    @TestVisible
    private String FrameAddressInFormat(String hsNo, String street, String city, String country, String postalCode) {
        String address = '';

        if (hsNo != null && hsNo != '') {
            address = address + hsNo + ', ';
        }
        if (street != null && street != '') {
            address = address + street + ', ';
        }
        if (city != null && city != '') {
            address = address + city + ', ';
        }

        if (postalCode != null && postalCode != '') {
            address = address + postalCode + ', ';
        }

        if (country != null && country != '') {
            address = address + country;
        }

        return address;
    }

    @TestVisible
    public class ProvisioningDetails {

        public csord__Service__c service {get; set;}
        public List<SelectOption> selectList {get; set;}  //SFOM-245
        public String address {get; set;}
        public String keyAttribute {get; set;}
        public String provisionFlag { get; set; }
        //public String screenSection {get; set;}

        private String getScreenFlowUri { get; private set; }
        private String getProductConfigurationId { get; private set; }

        public String screenFlowPath {
            get {
                return '/apex/cscfga__ConfigureProduct?retUrl=/apex/c__LG_SConsoleCloseTab&configId=' + getProductConfigurationId + this.getScreenFlowUri;
            }
        }

        /*
         * Class Constructor
        */
        public ProvisioningDetails(String cRecordType, csord__Service__c obj) {

            this.service = obj;

            // Get product definiton
            String productDefinition = obj.csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name;

            // Retrieve screen flow uri
            this.getScreenFlowUri = LG_Util.getScreenFlowFullName(cRecordType, productDefinition);
            this.getProductConfigurationId = obj.csordtelcoa__Product_Configuration__c;
        }
    }

    @TestVisible
    public class BillingDetails {
        public String serviceName {get; set;}
        public csord__Service_Line_Item__c serviceLineItem {get; set;}
        public boolean parent {get; set;}
    }
    /**
* 
*Fetching all the BDS services
* @author Preetha N
* @story DGT-381
* @since 07/03/2018
*/ 

    Public List<csord__Service__c> getAllBdsServices()
    {
        List<csord__Service__c> listOfBdsServices=new List<csord__Service__c>();
        getSolution();
        listOfBdsServices=[SELECT csord__Status__c ,LG_Address__r.LG_FullAddressDetails__c,UM_ProvisioningServiceExternalId__c ,LG_Action__c,csord__Activation_Date__c,LG_Address__r.cscrm__Street__c,LG_ServiceStatus__c,LG_Address__r.LG_HouseNumber__c,LG_Address__r.cscrm__Country__c,LG_Address__r.cscrm__Zip_Postal_Code__c,LG_Address__r.cscrm__City__c,csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name,csordtelcoa__Product_Configuration__c,name,ID,csord__Order__c,csord__Deactivation_Date__c,UM_DependsOnProductConfiguration__c,LG_SecondaryProductConfiguration__c,UM_DependsOnService__c,UM_DependsOnService__r.name,LG_DependsOnSecondaryService__c,LG_DependsOnSecondaryService__r.name,csord__Order__r.name from csord__Service__c WHERE LG_Suborder__c=:this.solutionObject.id  AND LG_Suborder__r.LG_DecompositionCriteria__c='Set 20 - BDS Site Process'];    
        system.debug('<<<<<<<<BDS Services'+listOfBdsServices);
        return listOfBdsServices;
    }
/**
* 
*Differenciating Primary and secondary Services based on case type
* @author Preetha N
* @story DGT-381
* @since 07/03/2018


    public  List<csord__Service__c> getlistOfBDSServicePrimary()
    {
        listOfFilteredBDSServices	=	new List<csord__Service__c>();
        listOfFilteredBDSServicesPrimary=new List<csord__Service__c>();
        List<csord__Service__c> listOfFilteredBDSServicesSeconadry=new List<csord__Service__c>();
        List<csord__Service__c> listOfBdsServices = getAllBdsServices();
        system.debug('<<<<case type'+cs.Type+''+cs.id);
        system.debug('<<<<case Record  type'+cs.RecordType.Name);
        for (csord__Service__c service:listOfBdsServices) 
        {
            if(cs.Type.containsIgnoreCase('Primary')&& cs.RecordType.Name.containsIgnoreCase('Provision'))
            {
                flag=true;
                if(service.LG_DependsOnSecondaryService__c!=null && service.UM_DependsOnService__c==null)
                {
                    listOfFilteredBDSServicesSeconadry.add(service);
                }
                else
                {
                    listOfFilteredBDSServicesPrimary.add(service);
                }
            }
        }
        if(flag)
        {
            listOfFilteredBDSServices=listOfFilteredBDSServicesPrimary;
        }
        else
        {
            listOfFilteredBDSServices=serviceObject;
        }
        system.debug('<<<<<<<<<Filtered List primary'+listOfFilteredBDSServicesPrimary);
        system.debug('<<<<<<<<<Filtered List'+listOfFilteredBDSServicesSeconadry);
        return listOfFilteredBDSServices;
    }*/

}