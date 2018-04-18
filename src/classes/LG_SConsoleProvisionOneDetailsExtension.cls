public class LG_SConsoleProvisionOneDetailsExtension extends LG_ServiceConsoleBase {
     Public Asset assetBdsToUpdate{get;set;}
     Public Asset assetBds{get;set;}
     Public csord__Service__c bdsService{get;set;}
     
    
    @TestVisible
    private final Case cs { get; set; }

    @TestVisible
    private csord__Solution__c solutionObject { get; set; }

    public String caseRecordType { get; set; }
    public boolean caseClosed {get;set;}
    

    public csord__Solution__c getSolution() {
        if (this.solutionObject == null) {
            this.solutionObject = getSolutionRecord();
        }

        return this.solutionObject;
    }

    @TestVisible
    private List<csord__Service__c> serviceObject { get; set; }
    
    //SFOM-2250
    Public Asset ast {get;set;}
    //SFOM-2250
    public Asset getAsset() {

        if (this.ast== null) {
            this.ast= getAssetRecord();
        }

        return this.ast;
    }

    public List<csord__Service__c> getService() {

        if (this.serviceObject == null) {
            this.serviceObject = getServiceRecords();
        }

        return this.serviceObject;
    }

    /*@TestVisible
    private List<csord__Service_Line_Item__c> serviceLineObject { get; set; }

    public List<csord__Service_Line_Item__c> getServiceLineItems() {

        if (this.serviceLineObject == null) {
            this.serviceLineObject = getServiceLineItemRecords();
        }

        return this.serviceLineObject;
    }*/
    //@TestVisible
    /*private List<BillingDetails> billingDetails { get; set; }

    public List<BillingDetails> getBillingDetails() {

        if (this.billingDetails == null) {
            this.billingDetails = getBillingDetailRecords();
        }

        return this.billingDetails;
    }*/

    @TestVisible
    private List<ProvisioningDetails> provisioningDetails { get; set; }


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
    //Removed as a part of SFOM-1748
    //public boolean jeopardy { get; set; }
    //public boolean jeoExpMsg { get; set; }

    public LG_SConsoleProvisionOneDetailsExtension (ApexPages.StandardController stdController) {
        //getAttributes();
       
        assetBdsToUpdate=new asset();
        if (!Test.isRunningTest()) {
            List<String> defaultFields = new List<String>{'LG_Service__c', 'LG_Solution__c', 'LG_Order__c', 'Status', 'RecordType.Name','LG_Solution__r.LG_ServiceCancellableType__c','Type'};
            stdController.addFields(defaultFields);
            this.cs = (Case)stdController.getRecord();

        } else {
            this.cs = [select LG_Service__c, LG_Solution__c, LG_Order__c, Status, RecordType.Name,LG_Solution__r.LG_ServiceCancellableType__c, Type  from Case];
        }
        System.debug('Case' + this.cs);
        this.caseRecordType = getRecordType();
       getService();
        getProvisioningDetails();
         //defect fix 2465
        
        getcheckBDSservice();
    }

    @TestVisible
    private csord__Solution__c getSolutionRecord() {
        csord__Solution__c solution;
        List<csord__Solution__c> solutionList = new List<csord__Solution__c>();
         List<csord__Solution__c> solutionList1 = new List<csord__Solution__c>();
        Id solId = this.cs.LG_Solution__c;
        if (solId != null) {
            solutionList = [SELECT LG_Address__r.cscrm__State_Province__c,LG_Address__r.LG_TechnicalContact__r.Phone,Id, LG_OneStepCase_Provisioning_Account_No__c,Name,LG_Solution_Name__c, LG_Address__c, csord__Account__c, csord__Order__c,
                   csord__Status__c, LG_Jeopardy__c, csordtelcoa__Product_Configuration__c, LG_JeopardyExplanation__c,
                   LG_ProvisioningWorkOrder__c,LG_ProvisioningAccountNo__c, LG_TargetDate__c, LG_EarliestInstallDate__c,
                   CreatedById, OwnerId, csord__Identification__c, csord__Order_Request__c, Jeopardy_Reason__c,
                   csord__Order__r.csordtelcoa__Opportunity__c, csord__Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c, csord__Order__r.csord__Account__c,
                   LG_Address__r.cscrm__Country__c, LG_Address__r.LG_TechnicalContact__c,LG_Address__r.LG_FullAddressDetails__c,LG_Address__r.LG_Icomms_Premise_ID__c, LG_Address__r.LG_Icomms_Site_ID__c,
                   csord__Order__r.csord__Account__r.LG_Huawei_Tenant_ID__c,LG_ServiceCancellableType__c 
                   FROM csord__Solution__c WHERE Id = :this.cs.LG_Solution__c];
        }

        if(solutionList.size() > 0){
            solution = solutionList[0];
            //Removed as a part of SFOM-1748
            /*if (solution.LG_Jeopardy__c == true) {
                            this.jeopardy = true;
            }*/
        }else {
            solution = new csord__Solution__c();
         }
       return solution;
    }

    /**
     * New field added to the query (csordtelcoa__Delta_Status__c)
     *
     * @author Ankur Gupta
     * @story SFOM-647
     * @since 20/04/2017
    */
    public List<csord__Service__c> getServiceRecords() {
        List<csord__Service__c> serviceRecordList;
                        String query='SELECT Id, Name,LG_Primary_Access_Network__c,LG_Primary_Access_Type__c,LG_Primary_Check__c,UM_DownloadSpeed__c,'+
                'LG_Hardware__c, LG_Secondary_Access_Network__c, LG_Secondary_Access_Type__c, LG_Secondary_Value__c, LG_DecompositionCriteria__c,'+
                'UM_ESN__c, LG_ProvisioningCode__c, LG_Address__c, LG_Address__r.Name,UM_MACAddress__c, LG_Address__r.LG_HouseNumber__c, LG_Address__r.cscrm__Street__c,'+ 
                'LG_Address__r.cscrm__City__c, LG_Address__r.cscrm__Zip_Postal_Code__c, LG_Address__r.cscrm__Country__c, LG_Address__r.LG_FullAddressDetails__c,'+
                'LG_ServiceStatus__c,'+  //SFOM-245
                'csord__Status__c, '+ //SFOM-245
                'LG_Provision_Valid__c,'+//SFOM-356
                'csordtelcoa__Product_Configuration__c, csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name, LG_Product_Category__c,'+
                'csordtelcoa__Delta_Status__c,'+ // SFOM-647
                'LG_Action__c, LG_ProvisioningAccountNo__c,'+ //SFOM-1693
                'csord__Activation_Date__c, csord__Deactivation_Date__c,'+
                'LG_ContractTerm__c,csord__Service__r.LG_ProductFamily__c, UM_DependsOnService__c, LG_DependsOnSecondaryService__c,'+ 'UM_DependsOnService__r.LG_ProvisioningAccountNo__c, LG_ProvisioningSystem__c,csord__Service__r.csord__Activation_Date__c,'+
                'UM_HPBXExternalId__c,'+ //OMB-2465
                'B2B_Care_Billing_Account_Number__c,'+ //SFOM-1817
                'LG_ServiceExternalId__c,'+ //SFOM-1822
                'UM_Cancellation__c,'+//bhp-11
                'LG_ProductFamily__c,UM_LogisticsReference__c,csordtelcoa__Replaced_Service__r.Name,Persistent_Id__c,csord__Order__r.csord__Account__r.LG_Huawei_Tenant_ID__c,UM_Customer_Region__c,csordtelcoa__Main_Contact__r.Phone '+//added for SFOM-2324
                'FROM csord__Service__c';
           String casetype = this.cs.Type;
           system.debug('casetype is:' + casetype);     
        if (this.cs.LG_Solution__c != null || this.cs.Type != null){
            query= query + ' WHERE LG_Suborder__c =\''+ this.cs.LG_Solution__c+'\'';
            // sfom-2563 changes starts
            if(this.cs.Type == 'Hpbx-Provision Kundensetup') {
                query=query+' AND LG_DecompositionCriteria__c=\'Set 10 - SIPWISE\'';
            }
            if(this.cs.Type == 'Hpbx-Provision Entry Services') {
                query=query+' AND LG_DecompositionCriteria__c=\'Set 10 - SIPWISE Entry Services\'';
            }
            if(this.cs.Type == 'Hpbx-Manage phone numbers') {
                query=query+' AND LG_DecompositionCriteria__c=\'Set 10 - INFPORT\'';
            }
            // sfom-2563 changes ends
              if ( this.cs.type == 'Hpbx- Monthly cancellable') {
                query=query+' AND UM_Cancellation__c=\'Monthly\'';
                        }
            if (this.cs.type == 'Hpbx- daily cancellable') {
                query=query+' AND UM_Cancellation__c=\'Daily\'';
                        }
             if (this.cs.type == 'HPBX-Remove from Sipwise') {
               query=query+' AND UM_Cancellation__c=null';
             }                   
             system.debug('query='+query);
             serviceRecordList = Database.query(query);
        
        }
        else {
            serviceRecordList = new List<csord__Service__c>();
        }
     

        return serviceRecordList;
    }
   
    //SFOM-2250
    public Asset getAssetRecord() {
        if (serviceObject.size() > 0) {
            for (csord__Service__c serviceRecord : serviceObject) {
                if(serviceRecord.Name.containsIgnoreCase('Company Internet')||serviceRecord.Name.containsIgnoreCase('Company Cloud Connect HFC product')|| serviceRecord.Name.containsIgnoreCase('VDSL')||serviceRecord.Name.containsIgnoreCase('Company Cloud Connect'))
                {
                    if([select COUNT() from Asset where csord__Service__r.id =: serviceRecord.id]!=0)//Defect fix-OMB-2860
                    {
                     ast = [SELECT Id, LG_MACAddress__c, csord__Service__c 
                            FROM Asset 
                            WHERE csord__Service__r.id =: serviceRecord.id LIMIT 1];
                    }
                    
                    //system.debug(ast.LG_MACAddress__c);
                }
               
            }
        }
    return ast;
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
                //if(serviceRecord.LG_Provision_Valid__c == 'Yes'){
                  provisioningDetails.provisionFlag = 'Green.png';
               /*}else{
                  provisioningDetails.provisionFlag = 'Red.png';
               }*/

                String address = serviceRecord.LG_Address__r.LG_FullAddressDetails__c;

                provisioningDetails.address = ', '+address;
                if (serviceRecord.csordtelcoa__Product_Configuration__c != null) {
                    String keyAttributes = util.getKeyAttributesPerProdConf(serviceRecord.csordtelcoa__Product_Configuration__c);
                    if (keyAttributes != '') {
                        provisioningDetails.keyAttribute = '(' + keyAttributes + ')';
                    }
                }

                //provisioningDetails.screenSection = screenUtil.getRelatedScreenFlowId(serviceRecord.Id, LG_ScreenSectionUtil.screenFlow.PROVISION);
                //Removed as a part of SFOM-1693 - Start
                            //Removed as a part of SFOM-1748
                //consoleUtil = new LG_ConsoleSectionUtil();  //SFOM-245
    //serviceRecord.LG_ServiceStatus__c = 'Ready For Billing';
                //serviceRecord.LG_ServiceStatus__c = Label.Service_Staus;
                //provisioningDetails.selectList = consoleUtil.getSelectOptionValues(serviceRecord.LG_ServiceStatus__c, this.caseRecordType);
                //Removed as a part of SFOM-1693 - End

          if(serviceRecord.LG_Action__c == 'Delete'){
                    provisioningDetails.deactivationrequired = true;
                              //Removed as a part of SFOM-1748
                    /*List<SelectOption> modifiedList = provisioningDetails.selectList;
                    Integer j = 0;
                    while (j < modifiedList.size())
                    {
                      if(modifiedList.get(j).getLabel() == 'Ready for Billing' || modifiedList.get(j).getLabel() == 'Active'){
                        modifiedList.remove(j);
                      }else
                      {
                        j++;
                      }
                      provisioningDetails.selectList = modifiedList;
                              }*/
      }else{
                    provisioningDetails.deactivationrequired = false;
                            }

                provisionList.add(provisioningDetails);
  }
        }
        return provisionList;
    }

    /**
     * New field added to the query (csordtelcoa__Delta_Status__c)
     *
     * @author Ankur Gupta
     * @story SFOM-647
     * @since 20/04/2017
    */
    /*public Map<String,List<csord__Service_Line_Item__c>> getServiceLineItemRecords() {
        Map<String, List<csord__Service_Line_Item__c>> serviceLineItemMap = new Map<String, List<csord__Service_Line_Item__c>>();
        List<csord__Service_Line_Item__c>  serviceLineItemList = new List<csord__Service_Line_Item__c>();
        serviceLineItemList = [SELECT Id, Name, csord__Line_Description__c, csord__Total_Price__c, LG_BillingProductId__c, LG_BillingAccount__c, LG_BillingAccount__r.Name, LG_BillingAccount__r.LG_ExternalId__c, csord__Service__c,csordtelcoa__Delta_Status__c  FROM csord__Service_Line_Item__c WHERE csord__Service__c IN :serviceObject];
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
    }*/

    //SFOM-1693
    //Removed as a part of SFOM-1748
    /*public PageReference ChangeServiceStatusActive(){
         //You cant change status directly to Active, so changing it to RFB then Active
        ChangeServiceStatusRFB();

        List<csord__Service__c> serviceListUpdate = new List<csord__Service__c>();
        for (ProvisioningDetails provdata : this.provisioningDetails) {
            if(provdata.service.LG_Action__c == 'Delete'){
                provdata.service.LG_ServiceStatus__c = 'Inactive';
                provdata.service.csord__Deactivation_Date__c = Date.today();
            }else{
                provdata.service.LG_ServiceStatus__c = 'Active';
                provdata.service.csord__Activation_Date__c = Date.today();
            }
            serviceListUpdate.add(provdata.service);
        }

        try{
            update serviceListUpdate;
        }catch(Exception e){
            System.debug('Exception::'+e.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            return null;
        }
        return PageRefresh();
    }

     //SFOM-1693
    public PageReference ChangeServiceStatusRFB(){
        List<csord__Service__c> serviceListUpdate = new List<csord__Service__c>();
        for (ProvisioningDetails provdata : this.provisioningDetails) {
            provdata.service.csord__Activation_Date__c = Date.today();
            provdata.service.LG_ServiceStatus__c = 'Ready for Billing';
            serviceListUpdate.add(provdata.service);
        }

        try{
            update serviceListUpdate;
        }catch(Exception e){
            System.debug('Exception::'+e.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            return null;
        }
        return PageRefresh();
    }*/

      public String getRecordType() {
      return this.cs.RecordType.Name;
    }

    public Boolean getProvisioning() {
        return this.cs.RecordType.Name == 'Provision One Step';
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
	        	if(this.ast!=null)
	        	{
	            	update this.ast;
	            }
                  //Removed as a part of SFOM-1748
            /*jeoExpMsg = false;
            this.solutionObject.LG_JeopardyRaisedBy__c = UserInfo.getUserId();
            //SFOM-1507 change
            //this.solutionObject.csord__Status__c = 'In Provisioning';
            if (jeopardy == true) {
                this.solutionObject.LG_Jeopardy__c = true;
            } else {
                this.solutionObject.LG_Jeopardy__c = false;
            }
            if (this.solutionObject.LG_Jeopardy__c == true && (this.solutionObject.LG_JeopardyExplanation__c == null || this.solutionObject.LG_JeopardyExplanation__c == '')) {
                jeoExpMsg = true;
                setMode(DisplayMode.edit);
                return null;
            } else {*/
                                  update this.solutionObject;
    //            update this.solutionObject.LG_Address__r;

                //SFOM-245
                List<csord__Service__c> serviceListUpdate = new List<csord__Service__c>();
                Map<Id,Date> activationDates = new Map<Id,Date>();
                for (ProvisioningDetails provdata : this.provisioningDetails) {
                    activationDates.put(provdata.service.Id,provdata.service.csord__Activation_Date__c);
                    Date parentServiceActDate = null;
                    if (provdata.service.csord__Service__c != null) {
                        Id parentId = provdata.service.csord__Service__c;
                         parentServiceActDate = activationDates.get(parentId);
                    }
                    //if (provdata.selectList != null && provdata.selectList.size() > 0) {
                         //provdata.service.csord__Activation_Date__c = Date.today();
                        //provdata.service.csord__Status__c = provdata.service.LG_ServiceStatus__c;

                        //Service Status Validation
                          //Removed as a part of SFOM-1748
                        /*if(provdata.service.LG_ServiceStatus__c == 'Ready for Billing' && provdata.service.csord__Activation_Date__c == null){
                          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please populate Activation Date before setting Service Status to Ready for Billing.'));
                            setMode(DisplayMode.edit);
                            return null;
                        }else if(provdata.service.LG_ServiceStatus__c == 'Active' && provdata.service.csord__Activation_Date__c == null){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please populate Activation Date before setting Service Status to Active.'));
                            setMode(DisplayMode.edit);
                            return null;
                        }else if(provdata.service.LG_ServiceStatus__c == 'Inactive' && provdata.service.csord__Deactivation_Date__c == null){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please populate Deactivation Date before setting Service Status to Inactive.'));
                            setMode(DisplayMode.edit);
                            return null;
                        }else if(provdata.service.LG_ServiceStatus__c == 'Inactive' && provdata.service.csord__Activation_Date__c != null){
                             provdata.service.csord__Activation_Date__c = null;
                        }else if(provdata.service.LG_ServiceStatus__c != 'Inactive' && provdata.service.csord__Deactivation_Date__c != null){
                            provdata.service.csord__Deactivation_Date__c = null;
                                        }*/
                        //SFOM-1748
                        if(provdata.service.LG_Action__c == 'Delete' && provdata.service.csord__Deactivation_Date__c == null){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please populate Deactivation Date.'));
                            setMode(DisplayMode.edit);
                            return null;
                        }else if(provdata.service.LG_Action__c != 'Delete' && (provdata.service.csord__Activation_Date__c == null && (provdata.service.csord__Service__c!= null && parentServiceActDate==null))){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please populate Activation Date.'));
                            setMode(DisplayMode.edit);
                            return null;
                        }  else if (provdata.service.LG_ProvisioningSystem__c == 'CAMA' && solutionObject.LG_ProvisioningAccountNo__c ==null) {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please populate Provisioning account Number.'));
                            setMode(DisplayMode.edit);
                            return null;
                        }

                        //To remove data from not required fields
                       /*if(provdata.service.LG_Action__c == 'Delete'){
                            provdata.service.csord__Activation_Date__c = null;
                        }else{
                            provdata.service.csord__Deactivation_Date__c = null;
                        }*/

                        //provdata.service.LG_ServiceStatus__c = 'Ready for Billing';
                        if (provdata.service.csord__Activation_Date__c == null) {
                            provdata.service.csord__Activation_Date__c = parentServiceActDate;
                        }

                        //SFOM-1693
                        //OMB-1060
                        // added for omb-2465
                        if(solutionObject.LG_ProvisioningAccountNo__c !=null &&  provdata.service.LG_ProductFamily__c!='Virtual Voice'){
                            provdata.service.LG_ProvisioningAccountNo__c = solutionObject.LG_ProvisioningAccountNo__c;
                        }
                    	serviceListUpdate.add(provdata.service);
                    	if(serviceListUpdate!=null)
                     	{
                    		update serviceListUpdate;
                    	}   
                	}
                	//Changes for DGT-117 Starts
                try{
                     if(assetBds != null)
                    {
                        if(assetBds.LG_Logistics_Reference_Number__c!=null && assetBds.LG_Logistics_Supplier_Name__c!=null && assetBds.LG_MACAddress__c!=null)
                        {
                          update assetBds;    
                        }
                    }
                }
                //Changes for DGT-117 Ends
                catch(Exception e){
                    System.debug('Exception::'+e.getMessage());
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
                    setMode(DisplayMode.edit);
                    return null;
                }
            //}
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            setMode(DisplayMode.edit);
            return null;

        }

        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Saved Successfully.'));
        setMode(DisplayMode.detail);
        return PageRefresh();
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

    //@TestVisible
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
        public boolean deactivationrequired {get; set;}
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
    
/**
* 
*
* @author Preetha N
* @story DGT-117
* @since 08/02/2018
*/ 

public Boolean getcheckBDSservice(){
    Boolean flag=false;
    if(serviceObject.size() > 0){
        for(csord__Service__c eachService:serviceObject){
            system.debug('just a check');
            if(eachService.LG_DecompositionCriteria__c==LG_CheckBdsDecompositionCriteria__c.getValues('CCC Offnet').LG_Decomposition_Criteria__c|| 
                eachService.LG_DecompositionCriteria__c==LG_CheckBdsDecompositionCriteria__c.getValues('CCC VDSL').LG_Decomposition_Criteria__c||
                (eachService.LG_DecompositionCriteria__c==LG_CheckBdsDecompositionCriteria__c.getValues('CCC HFC').LG_Decomposition_Criteria__c)||
                (eachService.LG_Primary_Check__c==True || eachService.LG_Secondary_Value__c==True)) //added for DGT-234
                {
             // if(eachService.LG_DecompositionCriteria__c!=null){ 
                system.debug('checking the values');
                flag=true;
                break;
            }
       }
    }
    system.debug('flag'+flag);
    return flag;
}

    Public Asset getBDSServiceAsset(){
        List<csord__Service__c> serviceOfBDS=new List<csord__Service__c>();
         List<Asset> assetListValues=new List<Asset>();
        Set<ID> parentServices=new Set<ID>();
            if(serviceObject.size() > 0){
                for(csord__Service__c eachService:serviceObject){
                    if(eachService.LG_DecompositionCriteria__c!=null){
                        parentServices.add(eachService.id);
                    }
                }
                system.debug(parentServices);
                if (!parentServices.isEmpty()) {
         serviceOfBDS=[SELECT ID,UM_DependsOnService__c,LG_DependsOnSecondaryService__c from csord__Service__c WHERE UM_DependsOnService__c IN :parentServices  OR LG_DependsOnSecondaryService__c IN :parentServices LIMIT 1 ];
         if(!serviceOfBDS.isEmpty()){
        assetListValues = [SELECT csord__Asset_Value__c,Id,LG_MACAddress__c,csord__Service__c,LG_Logistics_Reference_Number__c,LG_Logistics_Supplier_Name__c FROM Asset WHERE csord__Service__c IN :serviceOfBDS LIMIT 1];
         }
           }
            }
            if(!assetListValues.isEmpty()){
          assetBds=assetListValues[0];
            }
        return assetBds;
    }
    
    
    Public csord__Service__c getLInkedBDSvalue(){
         bdsService=new csord__Service__c();
        for(csord__Service__c eachService:serviceObject){
            if(eachService.LG_DecompositionCriteria__c!=null){
                bdsService = eachService;
                break;
            }
            }
        return bdsService;
    }
}