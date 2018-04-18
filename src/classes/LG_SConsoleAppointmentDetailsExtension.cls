/**
* Custom Appointment Extension controller for Appointment record type
*
* @author Pankaj Sharma
* @story SFOM-107
* @since  12/12/2016
*/
public class LG_SConsoleAppointmentDetailsExtension extends LG_ServiceConsoleBase{

    public boolean displayPopup {get; set;}
    public boolean modifytype {get; set;}
    public boolean bengin {get; set;}
    public Attachment myAttachment{get;set;}
    public string fileName{get;set;}
    public Blob fileBody{get;set;}
    public String errorMessage{get;set;}
    @TestVisible
    private final Case cs { get; set; }

    public csord__Solution__c solutionObject { get; set; }

    public LG_ScheduleAppointment__c appointmentObject { get; set; }
    public List<LG_ScheduleAppointment__History> appointmentHistory { get; set; }

    public csord__Service__c serviceObject { get; set; }
    public boolean edit {get;set;}
    //@TestVisible
    public csord__Solution__c getSolution() {

        if (this.solutionObject == null) {
            this.solutionObject = getSolutionRecord();
        }

        return this.solutionObject;
    }

    public csord__Service__c getService() {

        if (this.serviceObject == null) {
            this.serviceObject = getServiceRecord();
        }

        return this.serviceObject;
    }

    //*********** service Item and service line item *******
    @TestVisible
    private List<csord__Service__c> serviceItems { get; set; }

    public List<csord__Service__c> getServiceItems() {

        if (this.serviceItems == null) {
            this.serviceItems = getServiceItemRecords();
        }

        return this.serviceItems;
    }

    @TestVisible
    private List<csord__Service_Line_Item__c> serviceLineItems { get; set; }

    public List<csord__Service_Line_Item__c> getServiceLineItems() {

        if (this.serviceLineItems == null) {
            this.serviceLineItems = getServiceLineItemRecords();
        }

        return this.serviceLineItems;
    }
    //**********end ***********

    public LG_SConsoleAppointmentDetailsExtension(ApexPages.StandardController stdController) {

        List<String> defaultFields = new List<String>();
        appointmentObject = new LG_ScheduleAppointment__c();
        if(!test.isRunningTest()){
            defaultFields.add('LG_Service__c');
            defaultFields.add('LG_Solution__c');
            defaultFields.add('RecordType.Name');
            defaultFields.add('Type');
            defaultFields.add('Status');
            stdController.addFields(defaultFields);
            this.cs = (Case)stdController.getRecord();
            getsolution();
            appointmentObject.LG_InstallationContact__c = solutionobject.LG_Address__r.LG_TechnicalContact__c;

        } else
            this.cs = [select LG_Service__c, LG_Solution__c, LG_Order__c, RecordType.Name, Status, Type,LG_Solution__r.LG_Address__r.LG_TechnicalContact__c from Case LIMIT 1];


        try{
            appointmentObject = [SELECT id,LG_AgreedInstallDate__c,
                                 LG_Solution__c,
                                 LG_Case__c,
                                 LG_Slot__c,
                                 LG_JobReference__c,
                                 LG_Reasons__c,
                                 LG_Status__c,
                                 LG_InstallationContact__c,
                                 LG_InstallationContact__r.Phone,
                                 LG_Remarks__c
                                 FROM LG_ScheduleAppointment__c
                                 WHERE LG_Solution__c = :this.cs.LG_Solution__C LIMIT 1];

            if(appointmentObject.id!=Null){
                appointmentHistory = [SELECT id,Field,
                                      OldValue,
                                      NewValue,
                                      CreatedById,
                                      CreatedDate
                                      from LG_ScheduleAppointment__History
                                      WHERE parentId  = :appointmentObject.ID ];
            }

        }catch(exception e){

            system.debug('in exception #');
        }
        //SFOM-427
        modifyType = False;
        bengin = False;

        If (this.cs.type == 'Modify'|| this.cs.type == 'Cancel'){
            modifytype = True;
        }
        if(this.cs.status =='Closed'){
            edit = false;
        } else {
            edit = true;
        }

    }
    public List<SelectOption> getstatusOptions(){
        List<SelectOption> statusOptions =  new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription = Schema.LG_ScheduleAppointment__c.LG_Status__c.getDescribe();
        // For each picklist value, create a new select option
        for (Schema.Picklistentry picklistEntry: statusFieldDescription.getPicklistValues())
        {
            //statusOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
            // obtain and assign default value
            //if (appointmentObject.LG_Status__c == null && picklistEntry.defaultValue){
            //    appointmentObject.LG_Status__c = pickListEntry.getValue();
            //}
            If (this.cs.type == 'Cancel'){
                statusOptions.add(new SelectOption('Cancelled','Cancelled') );
            }
            else statusOptions.add(new SelectOption('Scheduled','Scheduled') );
        }
        return statusOptions;
    }
    @TestVisible
    private csord__Solution__c getSolutionRecord() {
        csord__Solution__c solutionObject = new csord__Solution__c();
        List<csord__Solution__c> solList  = [SELECT id, Name,
                                             LG_TargetDate__c,
                                             LG_EarliestInstallDate__c,
                                             LG_Address__c,
                                             LG_Address__r.LG_FullAddressDetails__c,
                                             LG_ProvisioningWorkOrder__c,
                                             LG_EarliestPortingWishDate__c,
                                             LG_LatestPortingWishDate__c,
                                             LG_AnyNumbersToPort__c,
                                             LG_Address__r.LG_TechnicalContact__c,
                                             LG_Address__r.LG_TechnicalContact__r.phone,
                                             LG_Address__r.Delivery_Type__c, //SFOM-662
                                             csord__Order__c,
                                             csord__Order__r.csordtelcoa__Opportunity__c,
                                             csord__Order__r.csord__Account__c
                                             from csord__Solution__c WHERE Id = :this.cs.LG_Solution__c];
        if(!solList.isEmpty())
        {
            solutionObject = solList[0];
        }
        return solutionObject;
    }

    @TestVisible
    private csord__Service__c getServiceRecord() {
        system.debug('Start 8 getAppointment');
        csord__Service__c serviceObject = new csord__Service__c();
        List<csord__Service__c> servList = [SELECT Id, Name,
                                            csord__Activation_Date__c,
                                            LG_ServiceStatus__c,
                                            LG_InstallationWishDate__c
                                            FROM csord__Service__c
                                            WHERE Id = :this.cs.LG_Service__c];
        system.debug('END 8 getAppointment');
        if(!servList.isEmpty())
        {
            serviceObject = servList[0];
        }
        return serviceObject;

    }

    //*********Service item and line item******************

    /**
     * New field added to the query for objs (csordtelcoa__Delta_Status__c)
     *
     * @author Ankur Gupta
     * @story SFOM-647
     * @since 20/04/2017
    */
    @TestVisible
    private List<csord__Service__c> getServiceItemRecords() {

        List<csord__Service__c> objs = [SELECT Id, Name,
                                        LG_ServiceExternalId__c,
                                        LG_ServiceStatus__c,
                                        csord__Activation_Date__c ,
                                        LG_InstallationWishDate__c,
                                        csordtelcoa__Delta_Status__c,  //SFOM-647
                                        (SELECT Id, Name,
                                         csord__Start_Date__c,
                                         csord__End_Date__c
                                         FROM csord__Service_line_Items__r)
                                        FROM csord__Service__c WHERE LG_Suborder__c = :this.cs.LG_Solution__c];

        return objs;
    }
    @TestVisible
    private List<csord__Service_Line_Item__c> getServiceLineItemRecords() {

        List<csord__Service_Line_Item__c> objs = [SELECT Id, Name,
                                                  csord__Start_Date__c,
                                                  csord__End_Date__c
                                                  FROM csord__Service_Line_Item__c
                                                  WHERE csord__Service__r.LG_Suborder__c = :this.cs.LG_Solution__c];

        return objs;
    }
    //**************end****************

    /** View Attachment section***/
    List<Attachment> file;
    @TestVisible
    public List<Attachment> getfile(){

        file=[Select Id,Name,LastModifiedDate,Owner.Name from Attachment where ParentId=:this.cs.LG_Solution__c];
        return file;
    }
    /************************/

    public String getRecordType() {
        return this.cs.RecordType.Name;
    }


    /** Page methods **/
    public PageReference edit() {
        edit = true;
        setMode(DisplayMode.edit);
        return null;
    }

    public PageReference save() {
        system.debug('!!!'+solutionObject);

        LG_ValidateOpportunity__c val = LG_ValidateOpportunity__c.getInstance(UserInfo.getUserId());
		String OrgName = val.org_name__c;

        if(solutionObject.LG_LatestPortingWishDate__c!=Null){
            if (solutionObject.LG_LatestPortingWishDate__c + 7 > appointmentobject.LG_AgreedInstallDate__c  )
                bengin = True;
        }
        system.debug('bengin!!!'+bengin);

        try{
            if(solutionObject.LG_EarliestInstallDate__c > appointmentObject.LG_AgreedInstallDate__c)
            {
                errorMessage = System.Label.LG_ErrorAgreedInstallDateBefore;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,errorMessage));
                system.debug('inside if');
                return null;
            }
            else if(appointmentObject.LG_AgreedInstallDate__c < system.today())
            {
                errorMessage = System.Label.LG_ErrorAgreedInstallDatePast;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,errorMessage));
                system.debug('inside if');
                return null;
            }
            else if(appointmentobject.LG_Reasons__c == Null && this.cs.type == 'Modify')
            {
                errorMessage = System.Label.LG_ErrorMandatoryModifyAppointment;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,errorMessage));
                system.debug('inside if');
                return null;
            }
            else if(appointmentobject.LG_JobReference__c == Null && OrgName == 'VMB')
            {
                errorMessage = System.Label.LG_ErrorMandatoryScheduleAppointment;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,errorMessage));
                system.debug('inside if');
                return null;
            }
            else if(appointmentobject.LG_Reasons__c == Null && this.cs.type == 'Cancel')
            {
                errorMessage = System.Label.LG_ErrorMandatoryCancelAppointment;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,errorMessage));
                system.debug('inside if');
                return null;
            }
            else
            {
                appointmentObject.LG_Case__c = this.cs.Id;
                appointmentObject.LG_Address__c = solutionObject.LG_Address__c;

                appointmentObject.LG_Solution__c=this.cs.LG_Solution__c;
                upsert appointmentObject;

                solutionObject.LG_targetDate__c = appointmentobject.LG_AgreedInstallDate__c;
                update Solutionobject;


                Edit = false;
                errorMessage = System.Label.LG_MessageRecordSaved;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,errorMessage));
                return null;
            }
        }
        catch(Exception e)
        {
            system.debug('in exception'+e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }

        return null;
    }

    public PageReference cancel() {
        Edit = FALSE;
        setMode(DisplayMode.detail);
        return null;
    }

    public PageReference Refresh() {
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }


    public void showPopup()
    {
        displayPopup = true;
    }

    public void closePopup()
    {
        displayPopup = false;
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

    public PageReference UploadFile()
    {
        if(fileBody != Null)
        {
            id cid = ApexPages.currentPage().getParameters().get('Id');
            case c= [select id,LG_Solution__c from case where id =: cid limit 1];
            myAttachment  = new Attachment();
            myAttachment.Body = fileBody;
            myAttachment.Name = fileName ;
            myAttachment.ParentId = c.LG_Solution__c ;

            insert myAttachment;
            string url= '/apex/LG_SConsoleAppointmentDetails?id='+c.id;
            PageReference pageRef = new PageReference(url);
            pageRef.setRedirect(true);
            return pageRef;
        }
        return null;
    }

}