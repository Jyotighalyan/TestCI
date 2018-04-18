/* -----------------------------------------------------------------------------------------------------------------------
Name:       LG_ActivateServiceExtn .cls
Description:

Date            Version         Author            Summary of Changes
-----------  ------- --------------  ----------------------------------------------------------------------------------
Dec 2016       1.0           Alisha        Initial Release
------------------------------------------------------------------------------------------------------------------------ */


public class LG_ActivateServiceExtn extends LG_ServiceConsoleBase {
    @TestVisible
    private List<ProvisioningDetails> provisioningDetails {get; set;}
    @TestVisible
    private LG_ProductConfigurationUtil util {get; set;}
    public boolean jeopardy {get; set;}
    public boolean jeoExpMsg { get; set; }
    public List<csord__Service__c> serviceObject { get; set; }
    public List<csord__Service__c> serviceList { get; set; }
    public final Case cs { get; set; }
    public csord__Solution__c solutionObject { get; set; }
    public boolean ActServiceAndType{get; set;}
    public boolean caseClosed {get;set;}
    //private List<csord__Service_Line_Item__c> serviceLineObject { get; set; }
    //Changes Start for DGT-381
    Public  List<csord__Service__c> listOfFilteredBDSServices{get;set;}
    
    public String caseRecordType { get; set; }
    
    @TestVisible
    private LG_ConsoleSectionUtil consoleUtil {get; set;} // SFOM-245
    
	public List<LG_AssetProcessAssociation__c> assetAssociations { get; private set; }
    public List<LG_ProcessRequest__c> processRequests { get; private set; }

    public LG_ActivateServiceExtn(ApexPages.StandardController stdcontroller) {
        
        if (!Test.isRunningTest()) {
            
            List<String> defaultFields = new List<String>{'LG_Service__c','LG_Solution__c','LG_Solution__r.LG_DecompositionCriteria__c','LG_Order__c','RecordType.Name','Type','Status'};
            
            
            stdController.addFields(defaultFields);
            this.cs = (Case)stdController.getRecord();
            
            this.caseRecordType = getRecordType();
            
            System.debug('testing');
            System.debug('order' + this.cs.Id);
            System.debug('getServiceRecord' + this.cs);
            
        } else {
            this.cs = [select LG_Service__c, LG_Solution__c, LG_Order__c, Type, LG_Solution__r.LG_DecompositionCriteria__c,RecordType.name, Status from Case limit 1];
        }
        
        getService();
        getlistOfBDSServicePrimary();
        system.debug('Status-----'+this.cs.Status);
		if(this.cs.Status == 'Closed')
        {
           caseClosed = True;
        } else {
            edit();
        }
		Set<Id> processIds = new Set<Id>();
		
        /*
         * For every Asset Process Association extract data
        */
        this.assetAssociations = getAssetsAssociations();
        for (LG_AssetProcessAssociation__c obj : this.assetAssociations) {

            processIds.add(obj.LG_Process__c);            
        }
        // Match process requests
        List<LG_ProcessRequest__c> processRequests = getProcessRequests(processIds);
		if (processRequests == null) {
			processRequests = new List<LG_ProcessRequest__c>();
		}
    }
    
    public csord__Solution__c getSolution() {
        
        if (this.solutionObject == null) {
            this.solutionObject = getSolutionRecord();
        }
        
        return this.solutionObject;
    }
    
    
    public List<csord__Service__c> getService() {
        
        if (this.serviceObject == null) {
            this.serviceObject = getServiceRecords();
        }
        
        return this.serviceObject;
    }
    
    public csord__Solution__c getSolutionRecord() {
        csord__Solution__c obj;
        Id solId = this.cs.LG_Solution__c;
        this.jeopardy = False;
        if (solId != null) {
            obj = [SELECT Id, Name, LG_Solution_Name__c, LG_Address__c, LG_Address__r.LG_FullAddressDetails__c, csord__Account__c, csord__Order__c, LG_LatestPortingWishDate__c, LG_EarliestPortingWishDate__c,
                   csord__Status__c, LG_Jeopardy__c, csordtelcoa__Product_Configuration__c, LG_JeopardyExplanation__c,
                   LG_ProvisioningWorkOrder__c, LG_TargetDate__c, LG_EarliestInstallDate__c, LG_DecompositionCriteria__c, 
                   CreatedById, OwnerId, csord__Identification__c, csord__Order_Request__c, Jeopardy_Reason__C,
                   csord__Order__r.csordtelcoa__Opportunity__c, csord__Order__r.csord__Account__c, csord__Order__r.csord__Account__r.LG_Huawei_Tenant_ID__c
                   FROM csord__Solution__c WHERE Id = :this.cs.LG_Solution__c];
            if (obj.LG_Jeopardy__c == true) {
                this.jeopardy = true;
            }
            
        } else {
            obj = new csord__Solution__c();
        }
        
        System.debug('obj' + obj);
        
        return obj;
    }
    
    /**
     * New field added to the query (csordtelcoa__Delta_Status__c)
     *
     * @author Ankur Gupta
     * @story SFOM-647
     * @since 20/04/2017
    */
    public List<csord__Service__c> getServiceRecords() {
        getActServiceAndType();
        if (this.cs.LG_Solution__c != null && this.cs.LG_Solution__r.LG_DecompositionCriteria__c!='Set 21 - VPN Process') {
            serviceList = [SELECT Id, Name,
                           LG_ProvisioningCode__c,
                           csord__Status__c, LG_ServiceStatus__c  ,
                           csordtelcoa__Product_Configuration__c ,
                           csordtelcoa__Product_Basket__c,
                           LG_Address__r.LG_HouseNumber__c,
                           LG_Address__r.cscrm__Street__c,
                           LG_Address__r.cscrm__City__c,
                           LG_Address__r.cscrm__Zip_Postal_Code__c,
                           LG_Address__r.cscrm__Country__c,
            		   LG_Address__r.LG_FullAddressDetails__c,
                            //SFOM-245
                          LG_Provision_Valid__c,//SFOM-356
                           csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name,
                           LG_Product_Category__c, 
                           LG_Activate_Valid__c, //SFOM-356
                           csordtelcoa__Delta_Status__c, // SFOM-647
                          LG_Action__c, LG_ProvisioningAccountNo__c, //SFOM-1693
                          csord__Activation_Date__c, csord__Deactivation_Date__c,
                          LG_ContractTerm__c,
                          UM_DependsOnService__c,
                          UM_DependsOnService__r.LG_ProvisioningAccountNo__c,
                          LG_ProvisioningSystem__c,
                          csord__Service__r.csord__Activation_Date__c
                           FROM csord__Service__c
                           WHERE LG_Suborder__c     = :this.cs.LG_Solution__c];
        } 
        else if(this.cs.LG_Solution__c!=null && this.cs.LG_Solution__r.LG_DecompositionCriteria__c=='Set 21 - VPN Process'){
           serviceList = [SELECT Id, Name,
                           LG_ProvisioningCode__c,
                           csord__Status__c, LG_ServiceStatus__c  ,
                           csordtelcoa__Product_Configuration__c ,
                           csordtelcoa__Product_Basket__c,
                           LG_Address__r.LG_HouseNumber__c,
                           LG_Address__r.cscrm__Street__c,
                           LG_Address__r.cscrm__City__c,
                           LG_Address__r.cscrm__Zip_Postal_Code__c,
                           LG_Address__r.cscrm__Country__c,
                           LG_Address__r.LG_FullAddressDetails__c,
                            //SFOM-245
                          LG_Provision_Valid__c,//SFOM-356
                           csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name,
                           LG_Product_Category__c, 
                           LG_Activate_Valid__c, //SFOM-356
                           csordtelcoa__Delta_Status__c, // SFOM-647
                          LG_Action__c, LG_ProvisioningAccountNo__c, //SFOM-1693
                          csord__Activation_Date__c, csord__Deactivation_Date__c,
                          LG_ContractTerm__c,
                          UM_DependsOnService__c,
                          UM_DependsOnService__r.LG_ProvisioningAccountNo__c,
                          LG_ProvisioningSystem__c,
                          csord__Service__r.csord__Activation_Date__c
                           FROM csord__Service__c
                           WHERE csord__Status__c Not IN ('Ready For Billing', 'Activation Completed','Active','Inactive') AND LG_Suborder__c = :this.cs.LG_Solution__c ];
        }
        else {
            serviceList = new List<csord__Service__c>();
        }
        
        System.debug('serviceList' + serviceList);
        
        return serviceList;
    }
    public Boolean getActService() {
        return this.cs.RecordType.Name == 'Activate Service';
    }
    
    /** added as part of sfom 474**/
    public Boolean getActServiceAndType() {
           ActServiceAndType=(this.cs.RecordType.Name == 'Activate Service' && (this.cs.type=='Number Port' || this.cs.type=='Check')  );
    
            system.debug('getActServiceAndType=='+ActServiceAndType);
            
        return  ActServiceAndType;
        
        }
    
    
    
    /**
* Page methods
*/
    public PageReference edit() {
        
        setMode(DisplayMode.edit);
        return null;
    }
    
    public PageReference save() {
        try {
            //SFOM-1822 - Will be reverted back once the BDS activation is automated
            /*jeoExpMsg = false;
            this.solutionObject.LG_JeopardyRaisedBy__c = UserInfo.getUserId();
            if (jeopardy == true) {
                this.solutionObject.LG_Jeopardy__c = true;
            } else {
                this.solutionObject.LG_Jeopardy__c = false;
            }
            if (this.solutionObject.LG_Jeopardy__c == true && this.solutionObject.LG_JeopardyExplanation__c == '') {
                jeoExpMsg = true;
                setMode(DisplayMode.edit);
                return null;
            } else {
                update this.solutionObject;*/
                
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
                        if(provdata.service.LG_Action__c == 'Delete' && provdata.service.csord__Deactivation_Date__c == null){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please populate Deactivation Date.'));
                            setMode(DisplayMode.edit);
                            return null;
                        }else if(provdata.service.LG_Action__c != 'Delete' && (provdata.service.csord__Activation_Date__c == null && (provdata.service.csord__Service__c!= null && parentServiceActDate==null))){
                    
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please populate Activation Date.'));
                            setMode(DisplayMode.edit);
                            return null;
                }
                
                       
                    
                    serviceListUpdate.add(provdata.service);
                }
                try{
                    update serviceListUpdate;
                }catch(Exception e){
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
        return null;
    }
    
    
    public PageReference cancel() {
        
        setMode(DisplayMode.detail);
        return null;
    }
    
    public String getRecordType() {
        return this.cs.RecordType.Name;
    }
       public PageReference PageRefresh() {
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }
    public List<ProvisioningDetails> getProvisioningDetailsRecords() {
        List<ProvisioningDetails> provisionList;
        List<ProvisioningDetails> provisionLineItemList;
        List<Id> prodConfIdList = new List<Id>();
        // system.debug('serviceObject.size()'+serviceObject.size());
        if (listOfFilteredBDSServices.size() > 0) {
            provisionList = new List<ProvisioningDetails>();
             for (csord__Service__c serviceRecord : listOfFilteredBDSServices) {
                prodConfIdList.add(serviceRecord.csordtelcoa__Product_Configuration__c);
            }
            system.debug('prodConfIdList = ' + prodConfIdList.size());
            util = new LG_ProductConfigurationUtil(prodConfIdList);
            
            for (csord__Service__c serviceRecord : listOfFilteredBDSServices) {

                ProvisioningDetails provisioningDetails = new ProvisioningDetails(this.caseRecordType, serviceRecord, this.solutionObject);
                //SFOM-1822 - Reverted back once BDS activation is automated
                //if(serviceRecord.LG_Activate_Valid__c == 'Yes'){
                    
                    provisioningDetails.provisionFlag = 'Green.png';
                    
                /*}else{
                    
                    provisioningDetails.provisionFlag = 'Red.png';
                }*/
                
                String address = serviceRecord.LG_Address__r.LG_HouseNumber__c + ',' + serviceRecord.LG_Address__r.cscrm__Street__c + ',' + serviceRecord.LG_Address__r.cscrm__City__c + ',' +
                    serviceRecord.LG_Address__r.cscrm__Zip_Postal_Code__c + ',' + serviceRecord.LG_Address__r.cscrm__Country__c;
                
                if(address.length()>0){
                    address = address.replaceAll('null,', '');
                    address = address.replaceAll('null', '');
                    address = address.replaceAll(',,', ',');
                    provisioningDetails.address = ', ' + address;
                    
                }
                if (serviceRecord.csordtelcoa__Product_Configuration__c != null) {
                    String keyAttributes = util.getKeyAttributesPerProdConf(serviceRecord.csordtelcoa__Product_Configuration__c);
                    if (keyAttributes != '') {
                        provisioningDetails.keyAttribute = '(' + keyAttributes + ')';
                    }
                    
                }
                
                consoleUtil = new LG_ConsoleSectionUtil();  //SFOM-245
                provisioningDetails.selectList = consoleUtil.getSelectOptionValues(serviceRecord.LG_ServiceStatus__c, this.caseRecordType);
                
                
                if(serviceRecord.LG_Action__c == 'Delete'){
                    provisioningDetails.deactivationrequired = true;
                    //Removed as a part of SFOM-1748
                    }else{
                    provisioningDetails.deactivationrequired = false;
                    }

                provisionList.add(provisioningDetails);
            }
        }
        return provisionList;
    }
    
       
    
    public class ProvisioningDetails {
        
        private csord__Solution__c sol { get; set; }
        public csord__Service__c service {get; set;}
        public csord__Service_Line_Item__c serviceLineItem {get; set;}
        public List<SelectOption> selectList {get; set;}  //SFOM-245
        
        public String address {get; set;}
        public String keyAttribute {get; set;}
        public String provisionFlag {get; set;}
        private String getScreenFlowUri { get; private set; }
        private String getProductConfigurationId { get; private set; }
        public boolean deactivationrequired {get; set;}
        
        /**
         * If Activate happens before Target Date, and there is no Install step, 
         * users should set the Effective Date to future Target Date.
         *
         * @author Petar Miletic
         * @ticket SFOM-1035
         * @since  04/07/2017
        */
       /* public Boolean effectiveDateRequired {
            
            get {
                
                if (service.csord__Activation_Date__c > sol.LG_TargetDate__c) {
                    return true;
                }
                
                return false;
            }
        }*/
        
        public String screenFlowPath {
            get {
                return '/apex/cscfga__ConfigureProduct?configId=' + getProductConfigurationId + this.getScreenFlowUri;
            }
        }
        
        /*
* Class Constructor
*/
        public ProvisioningDetails(String cRecordType, csord__Service__c obj, csord__Solution__c solObj) {
            
            this.sol = solObj;
            this.service = obj;
            
            // Get product definiton
            String productDefinition = obj.csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name;
            
            // Retrieve screen flow uri
            this.getScreenFlowUri = LG_Util.getScreenFlowFullName(cRecordType, productDefinition);
            this.getProductConfigurationId = obj.csordtelcoa__Product_Configuration__c;
        }
    }
    
    public List<ProvisioningDetails> getProvisioningDetails() {
        
        if (this.provisioningDetails == null) {
            this.provisioningDetails = getProvisioningDetailsRecords();
        }
        
        return this.provisioningDetails;
    }
	
	/*
     * Load Asset Process Association object
    */
    @TestVisible
    private List<LG_AssetProcessAssociation__c> getAssetsAssociations() {
        if (this.serviceObject.isEmpty()) {
            return new List<LG_AssetProcessAssociation__c>();
        }

        List<LG_AssetProcessAssociation__c> objs = [SELECT Id, 
                                            LG_Process__c
                                            FROM LG_AssetProcessAssociation__c
                                            WHERE LG_Asset__r.LG_TelephonyService__c IN :this.serviceObject AND
                                                  LG_Asset__r.LG_NumberRangeType__c = 'Port-In'];

        return objs;
    }
    /*
     * Load process requests by process id
    */
    @TestVisible
    private List<LG_ProcessRequest__c> getProcessRequests(Set<Id> processIds) {

        return [SELECT Id,                
                LG_PortingAgreedDate__c                             
                FROM LG_ProcessRequest__c
                WHERE LG_Process__c IN :processIds
                ORDER BY LG_Process__c, CreatedDate DESC];
    }
       /**
* 
*
* @author Preetha N
* @story DGT-381
* @since 07/03/2018
*/ 

    Public List<csord__Service__c> getAllBdsServices()
    {
        List<csord__Service__c> listOfBdsServices=new List<csord__Service__c>();
        getSolution();
        listOfBdsServices=[SELECT csord__Service__c,csord__Status__c ,LG_Address__r.LG_FullAddressDetails__c,UM_ProvisioningServiceExternalId__c ,LG_Action__c,csord__Activation_Date__c,LG_Address__r.cscrm__Street__c,LG_ServiceStatus__c,LG_Address__r.LG_HouseNumber__c,LG_Address__r.cscrm__Country__c,LG_Address__r.cscrm__Zip_Postal_Code__c,LG_Address__r.cscrm__City__c,csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name,csordtelcoa__Product_Configuration__c,name,ID,csord__Order__c,csord__Deactivation_Date__c,UM_DependsOnProductConfiguration__c,LG_SecondaryProductConfiguration__c,UM_DependsOnService__c,UM_DependsOnService__r.name,LG_DependsOnSecondaryService__c,LG_DependsOnSecondaryService__r.name,csord__Order__r.name from csord__Service__c WHERE LG_Suborder__c=:this.solutionObject.id  AND LG_Suborder__r.LG_DecompositionCriteria__c='Set 20 - BDS Site Process'];    
        system.debug('<<<<<<<<BDS Services'+listOfBdsServices);
        return listOfBdsServices;
    }

    public List<csord__Service__c> getlistOfBDSServicePrimary()
    {
        listOfFilteredBDSServices	=	new List<csord__Service__c>();
        List<csord__Service__c> listOfFilteredBDSServicesPrimary=new List<csord__Service__c>();
        List<csord__Service__c> listOfFilteredBDSServicesSecondary=new List<csord__Service__c>();
        List<csord__Service__c> listOfBdsServices = getAllBdsServices();
        system.debug('<<<<case type'+cs.Type+''+cs.id);
        system.debug('<<<<case Record  type'+cs.RecordType.Name);
        for (csord__Service__c service:listOfBdsServices) {
            if(cs.Type.containsIgnoreCase('Primary')  && cs.RecordType.Name.containsIgnoreCase('Activate') && (service.UM_DependsOnService__c!=null  || (service.LG_DependsOnSecondaryService__c==null && service.UM_DependsOnService__c==null)))
            {
                listOfFilteredBDSServicesPrimary.add(service);
            }
            else if(cs.Type.containsIgnoreCase('Secondary')  && cs.RecordType.Name.containsIgnoreCase('Activate') && ((service.UM_DependsOnService__c==null  &&  service.LG_DependsOnSecondaryService__c!=null)))
            {
                listOfFilteredBDSServicesSecondary.add(service);
            }
        }
        if(cs.Type.containsIgnoreCase('Primary') && listOfFilteredBDSServicesPrimary.size()>0)
        {
            listOfFilteredBDSServices=listOfFilteredBDSServicesPrimary;
        }
        else if(cs.Type.containsIgnoreCase('Secondary') && listOfFilteredBDSServicesSecondary.size()>0)
        {
            listOfFilteredBDSServices=listOfFilteredBDSServicesSecondary;
        }
        else
        {
            listOfFilteredBDSServices=serviceObject;
        }
        system.debug('List of filtered bds services'+listOfFilteredBDSServices);
        return listOfFilteredBDSServices;
    }
}
    
