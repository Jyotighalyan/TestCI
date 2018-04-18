/**
* Custom Install Extension controller for Install details Case record type
*
* @author Godson Davidson Shanthini
* @story SFOM-94
* @since  28/12/2016
*/
global with sharing class LG_SConsoleInstallDetailsExtension extends LG_ServiceConsoleBase {
    @TestVisible
    private final Case cs { get; set; }

    public String caseRecordType { get; set; }
    public String errorMessage {get; set; }

    @TestVisible
    private csord__Solution__c solutionObject { get; set; }

    public csord__Solution__c getSolution() {

        if (this.solutionObject == null) {
            this.solutionObject = getSolutionRecord();
        }

        return this.solutionObject;
    }

    @TestVisible
    private List<csord__Service__c> serviceList { get; set; }

    public List<csord__Service__c> getService() {

        if (this.serviceList == null) {
            this.serviceList = getServiceRecords();
        }

        return this.serviceList;
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
    private List<ProvisioningDetails> provisioningDetails {get; set;}

    public List<ProvisioningDetails> getProvisioningDetails() {

        if (this.provisioningDetails == null) {
            this.provisioningDetails = getProvisioningDetailsRecords();
        }

        return this.provisioningDetails;
    }

    public boolean jeopardy { get; set; }
    public boolean jeoExpMsg { get; set; }
    public boolean appDetailErrMsg { get; set; }
    public String errorMsg { get; set; }
    public boolean siteAttCheck { get; set; }
    public boolean evidenceAttCheck { get; set; }
    public boolean provStatus { get; set; }
    public boolean caseClosed { get; set; }
    public String attachmentId {get; set;}

    @TestVisible
    private LG_ScheduleAppointment__c scheduleAppointment { get; set; }

    public LG_ScheduleAppointment__c getAppointment() {

        if (this.scheduleAppointment == null) {
            this.scheduleAppointment = getAppointmentRecord();
        }

        return this.scheduleAppointment;
    }

    public Attachment attachment {
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }

    @TestVisible
    private List<Attachment> siteAttachment { get; set; }

    public List<Attachment> getSiteAttachment() {

        if (this.siteAttachment == null) {
            this.siteAttachment = getsiteAttachmentRecord();
        }

        return this.siteAttachment;
    }

    @TestVisible
    private List<Attachment> evidenceAttachment { get; set; }

    public List<Attachment> getEvidenceAttachment() {

        if (this.evidenceAttachment == null) {
            this.evidenceAttachment = getevidenceAttachmentRecord();
        }

        return this.evidenceAttachment;
    }

    @TestVisible
    private LG_ProductConfigurationUtil util {get; set;}
    @TestVisible
    private LG_ConsoleSectionUtil consoleUtil {get; set;}

    public LG_SConsoleInstallDetailsExtension (ApexPages.StandardController stdController) {
        if (!Test.isRunningTest()) {
            List<String> defaultFields = new List<String>();

            defaultFields.add('LG_Service__c');
            defaultFields.add('LG_Solution__c');
            defaultFields.add('LG_Order__c');
            defaultFields.add('Status');
            defaultFields.add('RecordType.Name');

            stdController.addFields(defaultFields);
            this.cs = (Case)stdController.getRecord();

            System.debug('Case: ' + this.cs);
        } else {
            this.cs = [select LG_Service__c, LG_Solution__c, LG_Order__c, RecordType.Name, Status from Case LIMIT 1];
        }
        //getServices
        getService();
        getSolution();
        //getServiceLineItems();
        getsiteAttachment();
        getevidenceAttachment();

        if (this.cs.Status == 'Closed') {
            caseClosed = true;
        } else {
            Edit();
        }

        this.caseRecordType = getRecordType();
    }


    /*
     *
     */
    private csord__Solution__c getSolutionRecord() {
        this.jeopardy = false;
        csord__Solution__c solution;
        Id solId = this.cs.LG_Solution__c;
        if (solId != null) {
            solution = [SELECT Id, Name, LG_ProvisioningWorkOrder__c, LG_Jeopardy__c,
                        LG_Address__c, LG_Address__r.Name,
                        //LG_Address__r.LG_TechnicalContact__c, //blocked On behalf of SFOM-488
                        //LG_Address__r.LG_TechnicalContact__r.phone, // blocked On behalf of SFOM-488
                        LG_Address__r.LG_FullAddressDetails__c,
                        LG_Address__r.Delivery_Type__c, //SFOM-662
                        LG_Address__r.VM_ONUNumber__c, //SFOM-662
                        LG_JeopardyExplanation__c,
                   csord__Order__r.csord__Account__r.Name, csord__Order__r.Name, csord__Order__r.csord__Order_Type__c,
                   LG_PlanningRequired__c, Jeopardy_Reason__c FROM csord__Solution__c WHERE Id = :solId];
            if (solution.LG_Jeopardy__c == true) {
                this.jeopardy = true;
            }
        } else {
            solution = new csord__Solution__c();
        }

        System.debug('solution' + solution);

        return solution;
    }


    /*
     *
     *
     */
    private LG_ScheduleAppointment__c getAppointmentRecord() {
        LG_ScheduleAppointment__c scheduleAppointment = new LG_ScheduleAppointment__c();
        Id solId = this.cs.LG_Solution__c;
        if (solId != null) {
            List<LG_ScheduleAppointment__c> scheduleAppointmentList = [SELECT Id, Name, LG_AgreedInstallDate__c, LG_Slot__c,
                                            LG_JobReference__c, LG_InstallationComments__c,
                                            LG_InstallationContact__c, LG_InstallationContact__r.phone //SFOM-488
                                                                       from LG_ScheduleAppointment__c WHERE LG_Solution__c = :solId];
            if (scheduleAppointmentList.size() > 0) {
                scheduleAppointment = scheduleAppointmentList[0];
            }
        }

        return scheduleAppointment;
    }

    /**
     * New field added to the query for serviceList(csordtelcoa__Delta_Status__c)
     *
     * @author Ankur Gupta
     * @story SFOM-647
     * @since 20/04/2017
    */
    public List<csord__Service__c> getServiceRecords() {
        List<csord__Service__c> serviceList;
        if (this.cs.LG_Solution__c != null) {
            serviceList = [SELECT Id, Name,
                          LG_ProvisioningCode__c,
                          LG_Address__c,
                          LG_Address__r.Name,
                          LG_Address__r.LG_HouseNumber__c,
                          LG_Address__r.cscrm__Street__c,
                          LG_Address__r.cscrm__City__c,
                          LG_Address__r.cscrm__Zip_Postal_Code__c,
                          LG_Address__r.cscrm__Country__c,
                          LG_Address__r.LG_FullAddressDetails__c,
                          csordtelcoa__Product_Configuration__c,
                          csord__Status__c,
                          LG_InstallDate__c,
                          LG_FailureReason__c,
                          LG_Comments__c,
                          csord__Activation_Date__c,
                          LG_TestResult__c,
                          LG_ServiceStatus__c,
                          LG_EffectiveDate__C,
                          csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name,
                          LG_Product_Category__c,
                          LG_Install_Valid__c, //SFOM-356
                          csordtelcoa__Delta_Status__c // SFOM-647
                          FROM csord__Service__c
                          WHERE LG_Suborder__c = :this.cs.LG_Solution__c];

        } else {
            serviceList = new List<csord__Service__c>();
        }

        System.debug('serviceList' + serviceList);

        return serviceList;
    }

    public List<ProvisioningDetails> getProvisioningDetailsRecords() {
        List<ProvisioningDetails> provisionList;
        List<ProvisioningDetails> provisionLineItemList;
        List<Id> prodConfIdList = new List<Id>();
        //system.debug('serviceList.size()' + serviceList.size());
        if (serviceList.size() > 0) {
            provisionList = new List<ProvisioningDetails>();
            for (csord__Service__c serviceRecord : serviceList) {
                if (serviceRecord.csordtelcoa__Product_Configuration__c != null) {
                    prodConfIdList.add(serviceRecord.csordtelcoa__Product_Configuration__c);
                }


            }
            system.debug('prodConfIdList = ' + prodConfIdList.size());
            util = new LG_ProductConfigurationUtil(prodConfIdList);
            //LG_ScreenSectionUtil utilSc = new LG_ScreenSectionUtil();

            for (csord__Service__c serviceRecord : serviceList) {
                ProvisioningDetails provisioningDetails = new ProvisioningDetails(this.caseRecordType, serviceRecord);
               if(serviceRecord.LG_Install_Valid__c == 'Yes'){
                    provisioningDetails.provisionFlag = 'Green.png';
                }else{
                    provisioningDetails.provisionFlag = 'Red.png';
               }
                String address = serviceRecord.LG_Address__r.LG_FullAddressDetails__c;
                provisioningDetails.address = ', ' + address;

                if (serviceRecord.csordtelcoa__Product_Configuration__c != null) {
                    String keyAttributes = util.getKeyAttributesPerProdConf(serviceRecord.csordtelcoa__Product_Configuration__c);
                    //system.debug('keyAttributes-->' + keyAttributes);
                    if (keyAttributes != '') {
                        provisioningDetails.keyAttribute = '(' + keyAttributes + ')';
                    }

                }

                consoleUtil = new LG_ConsoleSectionUtil();
                //Service status list
                provisioningDetails.selectList = consoleUtil.getSelectOptionValues(serviceRecord.LG_ServiceStatus__c, this.caseRecordType);


                //system.debug('sss'+provisioningDetails.selectList);
                //provisioningDetails.screenSection = utilSc.getRelatedScreenFlowId(serviceRecord.Id, LG_ScreenSectionUtil.screenFlow.PROVISION);
                /* provisionLineItemList = new List<ProvisioningDetails>();
                 for(csord__Service_Line_Item__c serviceLineItem: serviceLineObject){
                     if(serviceRecord.Id == serviceLineItem.csord__Service__c){
                         ProvisioningDetails provisioningSLIDetails = new ProvisioningDetails();
                         provisioningSLIDetails.serviceLineItem = serviceLineItem;
                         provisionLineItemList.add(provisioningSLIDetails);
                     }

                 }*/

                provisionList.add(provisioningDetails);
                //provisionList.addAll(provisionLineItemList);
            }
        }
        return provisionList;
    }

    /*public List<csord__Service_Line_Item__c> getServiceLineItemRecords() {
        List<csord__Service_Line_Item__c>  serviceLineItemList = new List<csord__Service_Line_Item__c>();
        for (csord__Service__c serviceRecord : serviceList) {
            List<csord__Service_Line_Item__c>  lineItems = [SELECT Id, Name, csord__Service__c FROM csord__Service_Line_Item__c WHERE csord__Service__c = :serviceRecord.Id];
            serviceLineItemList.addAll(lineItems);
        }
        return serviceLineItemList;
    }*/

    public List<Attachment> getsiteAttachmentRecord() {
        List<Attachment> attachmentList = new List<Attachment>();
        attachmentList = [SELECT Id, Name, ParentId, OwnerId, LastModifiedDate FROM Attachment WHERE ParentId = :this.cs.LG_Solution__c];
        if (attachmentList.size() > 0) {
            siteAttCheck = true;
        }
        return attachmentList;
    }

    public List<Attachment> getevidenceAttachmentRecord() {
        List<Attachment> attachmentList = new List<Attachment>();
        attachmentList = [SELECT Id, Name, ParentId, OwnerId, LastModifiedDate FROM Attachment WHERE ParentId = :this.cs.Id];
        if (attachmentList.size() > 0) {
            evidenceAttCheck = true;
        }
        return attachmentList;
    }

    public List<SelectOption> getSlot() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = csord__Solution__c.LG_PlanningRequired__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for ( Schema.PicklistEntry f : ple)
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        return options;

    }

    public PageReference editStatus() {
        provStatus = true;
        setMode(DisplayMode.edit);
        return null;
    }

    public String getRecordType() {
        return this.cs.RecordType.Name;
    }

    public Boolean getInstallation() {
        return this.cs.RecordType.Name == 'Install';
    }

    /*
    * Page methods
    */
    public PageReference edit() {

        setMode(DisplayMode.edit);
        return null;
    }

    public PageReference save() {
        Savepoint sp = Database.setSavepoint();
        try {
            jeoExpMsg = false;
            System.debug('this.solutionObject.LG_JeopardyExplanation__c=' + this.solutionObject.LG_JeopardyExplanation__c);
            this.solutionObject.LG_JeopardyRaisedBy__c = UserInfo.getUserId();
            if (jeopardy == true) {
                this.solutionObject.LG_Jeopardy__c = true;
            } else {
                this.solutionObject.LG_Jeopardy__c = false;
                this.solutionObject.LG_JeopardyExplanation__c = '';
            }
            if (this.solutionObject.LG_Jeopardy__c == true && (this.solutionObject.LG_JeopardyExplanation__c == '' || this.solutionObject.LG_JeopardyExplanation__c == null)) {
                jeoExpMsg = true;
                setMode(DisplayMode.edit);
                return null;
            } else {
                update this.solutionObject;
            }
            System.debug('Schedule appointment: ' + this.scheduleAppointment);
            update this.scheduleAppointment;


            for (ProvisioningDetails provdata : this.provisioningDetails) {
                //csord__Service__c serviceRecord = new csord__Service__c();
                //serviceRecord = provdata
                //SFOM-579 Starts
                if(provdata.service.lg_effectivedate__c == null && jeopardy == False){
                    errorMessage = System.Label.LG_ErrorValidEffectiveDate;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, errorMessage));
                    return null;                  //SFOM-579 ends
                }else{
                if (provdata.selectList != null && provdata.selectList.size() > 0) {
                    provdata.service.csord__Status__c = provdata.service.LG_ServiceStatus__c;
                    update provdata.service;
                } else {
                    update provdata.service;
                }
                }

            }


        } catch (Exception e) {
            Database.rollback(sp);
            ApexPages.addMessages(e);
            setMode(DisplayMode.edit);
            return null;

        }

        errorMessage = System.Label.LG_MessageSavedSuccessfully;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, errorMessage));
        setMode(DisplayMode.detail);
        return null;
    }

    @RemoteAction
    global static boolean deleteAttachment(String attachmentId) {
        Attachment attachedFile = new Attachment();
        try {
            attachedFile = [SELECT Id, Name from Attachment WHERE Id = :attachmentId];
            delete attachedFile;
            return true;

        } catch (Exception e) {
            ApexPages.addMessages(e);
            return false;
        }

    }

    /*public PageReference saveAppointment() {

        appDetailErrMsg = false;
        try{
            update this.scheduleAppointment;
        }catch(Exception e){
            appDetailErrMsg = true;
            errorMsg = e.getMessage();
        }
        setMode(DisplayMode.detail);
        return null;
    }*/

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
            address = address + country + ', ';
        }

        return address;
    }


    public PageReference upload() {

        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = this.cs.LG_Solution__c;
        attachment.IsPrivate = true;

        try {
            insert attachment;
        } catch (DMLException e) {
            errorMessage = System.Label.LG_ErrorUploadingAttachment;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
            return null;
        } finally {
            attachment = new Attachment();
        }
        errorMessage = System.Label.LG_MessageAttachmentUploaded;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, errorMessage));

        return PageRefresh();
    }

    public PageReference uploadTestEvidence() {

        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = this.cs.Id;
        attachment.IsPrivate = true;

        try {
            insert attachment;
        } catch (DMLException e) {
            errorMessage = System.Label.LG_ErrorUploadingAttachment;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
            return null;
        } finally {
            attachment = new Attachment();
        }
        errorMessage = System.Label.LG_MessageAttachmentUploaded;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, errorMessage));

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

    //SFOM-662
    public boolean getFTTPWarning(){
        if(solutionObject.LG_Address__r.Delivery_Type__c == 'FTTP'){
            return true;
        }else{
            return false;
        }
    }

    //SFOM-662 - Reusing Submit order getOrg_name method to fetch Org Name
    public String getOrgVal(){
        //Organization orgDetails = [SELECT Id, NamespacePrefix , Name FROM Organization WHERE Id = :UserInfo.getOrganizationId()];
        String orgVal = LG_SubmitOrder.getOrg_name();
        return orgVal;
    }

    @TestVisible
    public class ProvisioningDetails {

        public csord__Service__c service {get; set;}
        public csord__Service_Line_Item__c serviceLineItem {get; set;}
        public List<SelectOption> selectList {get; set;}
        public String address {get; set;}
        public String keyAttribute {get; set;}
        public String provisionFlag {get; set;}
        //public String screenSection {get;set;}

        private String getScreenFlowUri { get; private set; }
        private String getProductConfigurationId { get; private set; }

        public String screenFlowPath {
            get {
                return '/apex/cscfga__ConfigureProduct?configId=' + getProductConfigurationId + this.getScreenFlowUri;
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
}