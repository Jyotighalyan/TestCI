public with sharing class LG_SconsoleSiteSurveyController {
    @TestVisible
    private final Id id{get;set;}
    @TestVisible
    private final Id sId{get;set;}
    @TestVisible
    private final Id csId{get;set;}
    //public Id caseId {get;set;}
    public boolean isEditNew{get;private set;}
    public boolean isEditDetails{get;private set;}
    public boolean siteAttachmentCheck {get; set;}
    //OMB-730
    public string siteAddress {get; set;}
    @TestVisible
    private Site_Survey__c siteSurveyObject {get;set;}
    public Site_Survey__c surveyObject {get;set;}
    Public Attachment myfile;
    Public Attachment getmyfile()
    {
        myfile = new Attachment();
        return myfile;
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

    public List<Attachment> getsiteAttachment() {

        if (this.siteAttachment == null) {
            this.siteAttachment = getSiteAttachmentRecord();
        }

        return this.siteAttachment;
    }
    public Site_Survey__c getSiteSurvey(){
        if(this.siteSurveyObject==null){
            this.siteSurveyObject=getSiteSurveyRecord();
        }
        return this.siteSurveyObject;
    }

    public LG_SconsoleSiteSurveyController(){

        this.id = ApexPages.currentPage().getParameters().get('id');
        this.sId = ApexPages.currentPage().getParameters().get('siteId');
        this.csId = ApexPages.currentPage().getParameters().get('caseId');

        getSiteSurvey();
        getSiteAttachmentRecord();
        if(this.id!=null){
            isEditNew = false;
            Case c =[SELECT id, status from Case where id = :csId];
            //attachments = [Select id,name from attachment where parentid = :this.id];

            if(c.status != 'Closed'){
                isEditDetails=true;
            }else{
                isEditDetails=false;
            }
        }else{
            isEditNew = true;
            this.siteSurveyObject = new Site_Survey__c();
            this.siteSurveyObject.Address__c=this.sId;
            //OMB-730 - Display Site as Text
            try{
                List<cscrm__Address__c> addressDetails = [SELECT Id,LG_FullAddressDetails__c FROM cscrm__Address__c WHERE Id=:this.sId];
                if(addressDetails.size() > 0 ){
                    siteAddress = addressDetails[0].LG_FullAddressDetails__c;
                }

            }catch(Exception e){
                System.debug('Exception:'+e.getMessage());
            }

        }

    }
    private Site_Survey__c getSiteSurveyRecord(){
        Id surveyId= this.id;
        Site_Survey__c survey;
        if(surveyId != null){
            survey=[SELECT Name,Address__c,Site__c,Date__c,civils_duct_m__c,civils_type__c,civils_duration_days__c,
                    civils_notice_days__c,civils_details__c,cabling_cable_m__c,cabling_type__c,
                    cabling_duration_days__c,cabling_notice_days__c,cabling_details__c,internal_cable_m__c,
                    internal_type__c,internal_duration__c,internal_notice_days__c,internal_details__c,
                    Project__c,Budget_Estimate__c,Wish_Date__c,Earliest_Comp__c,Jeopardy__c,total_details__c,Access_Technology__c,
                    civils_hand_hole__c, civils_man_holes__c, LG_CivilsCapex__c, LG_CivilsOpex__c, LG_CablingCapex__c, LG_CablingOpex__c,
                    LG_InternalCablingCapex__c, LG_InternalCablingOpex__c,
                    (SELECT Id,Name from Attachments order By LastModifiedDate DESC limit 1)
                    FROM Site_Survey__c WHERE Id=:surveyId];

        }
        return survey;
    }

    /*public PageReference UpdateSurvey(){
        Savepoint sp =Database.setSavepoint();
        try{
            update siteSurveyObject;
            if(fileName!=null && fileBody.size() !=0){
                Attachment attach = new Attachment(parentId = siteSurveyObject.Id, name=fileName, body = fileBody);
                upsert attach;
            }
            else if(fileName!=null && fileBody.size() == 0){
                fileName =null;
                fileBody = null;
                Database.rollback(sp);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Empty file cannot be attached'));
                return null;
            }
        }
        catch(DMLException e){
            Database.rollback(sp);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Error updating new Site Survey'));
            return null;
        }
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Site Survey Updated Successfully!'));
        return ApexPages.CurrentPage().setRedirect(true);

    }*/

    public PageReference saveSurvey(){
        Savepoint sp =Database.setSavepoint();
        try{
            upsert siteSurveyObject;
      // Commented as Attachment is not mandatory as part of OMB-779
      //if(isEditNew){
            if(siteSurveyObject.Id != null && myfile.name != null && myfile.body !=null){
                    Attachment attach = new Attachment(parentId = siteSurveyObject.Id, name=myfile.name, body = myfile.body);
                    insert attach;
            }
            // Commented as Attachment is not mandatory as part of OMB-779
            /*else{
                Database.rollback(sp);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Empty file cannot be attached'));
                return null;
              }
            }*/
        }
        catch(DMLException e){
            Database.rollback(sp);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Error creating new Site Survey'));
            System.debug('DMLException:'+e.getMessage());
            return null;
        }
        PageReference returnPage = new PageReference(ApexPages.currentPage().getURL());
        returnPage.getParameters().put('id',siteSurveyObject.Id);
        //SFOM-1169 - Passing caseId in parameter
        returnPage.getParameters().put('caseId',this.csId);
        returnPage.setRedirect(true);
        return returnPage;
    }

    public PageReference cancel() {
    PageReference pageRef = Page.c__LG_SConsoleCloseTab;
        pageRef.setRedirect(true);
        return pageRef;
    }

    public PageReference uploadAttachment() {
    attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = this.id;
        attachment.IsPrivate = true;

        try {
            insert attachment;
        } catch (DMLException e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LG_ErrorUploadingAttachment));
            return null;
        } finally {
            attachment = new Attachment();
        }
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, Label.LG_MessageAttachmentUploaded));

        return PageRefresh();
    }

    public PageReference PageRefresh() {
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }

    public List<Attachment> getSiteAttachmentRecord() {
        List<Attachment> attachmentList = new List<Attachment>();
        attachmentList = [SELECT Id, Name, ParentId, OwnerId, LastModifiedDate FROM Attachment WHERE ParentId = :this.id];
        if (attachmentList.size() > 0) {
            siteAttachmentCheck = true;
        }
        return attachmentList;
    }

    @RemoteAction
    public static boolean deleteAttachment(String attachmentId) {
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
}