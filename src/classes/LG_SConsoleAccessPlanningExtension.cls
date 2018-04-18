public class LG_SConsoleAccessPlanningExtension {
    @TestVisible
  private final Case cs { get; set; }
    //public Id caseId {get;set;}
    @TestVisible
  private csord__Solution__c solutionObject { get; set; }
    @TestVisible
    private List<csord__Service__c> serviceObject { get; set; }
    @TestVisible
    private List<Site_Survey__c> siteSurveyObject {get; set; }
    public boolean day{get;set;}
    public boolean isClosed{get;set;}
    @TestVisible
    private Id suborderAddress{get;set;}


    public List<csord__Service__c> getService() {

        if (this.serviceObject == null) {
            this.serviceObject = getServiceRecords();
        }

        return this.serviceObject;
    }
    public csord__Solution__c getSolution() {

        if (this.solutionObject == null) {
            this.solutionObject = getSolutionRecord();
        }

        return this.solutionObject;
    }
    public List<Site_Survey__c> getSiteSurvey(){
        if(this.siteSurveyObject == null){
            this.siteSurveyObject= getSiteSurveyRecords();
        }
    return  this.siteSurveyObject;
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


    public LG_SConsoleAccessPlanningExtension(ApexPages.StandardController stdController){
        if (!Test.isRunningTest()) {
            List<String> defaultFields = new List<String>();
      defaultFields.add('Id');
            defaultFields.add('LG_Service__c');
            defaultFields.add('LG_Solution__c');
            defaultFields.add('LG_Order__c');
            defaultFields.add('Status');
            defaultFields.add('RecordType.Name');

            stdController.addFields(defaultFields);
            this.cs = (Case)stdController.getRecord();
      //caseId=ApexPages.currentPage().getParameters().get('tsid');
        } else {
            this.cs = [select LG_Service__c, LG_Solution__c, LG_Order__c, Status, RecordType.Name from Case];
        }

        if(this.cs.Status == 'Closed'){
            isClosed = true;
        }else{
            isClosed = false;
        }

        //To load service list
        getService();
    }

    @TestVisible
    private csord__Solution__c getSolutionRecord() {
        csord__Solution__c solution = new csord__Solution__c();
        Id solId = this.cs.LG_Solution__c;
        System.debug(solId);
        if (solId != null) {
            solution = [SELECT Id, Name,LG_Jeopardy__c, LG_JeopardyExplanation__c,
                        LG_TargetDate__c,LG_Address__c,LG_Address__r.LG_FullAddressDetails__c,
                        LG_Address__r.LG_TechnicalContact__r.Name,
                        csord__Order__c,  csord__Account__c,
                        csord__Order__r.csordtelcoa__Opportunity__c,
                        csord__Order__r.csord__Account__c
                        FROM csord__Solution__c WHERE Id = :solId];
            suborderAddress=solution.LG_Address__c;
        }

        return solution;
    }
    public List<csord__Service__c> getServiceRecords() {
        List<csord__Service__c> serviceList = new List<csord__Service__c>();
        if (this.cs.LG_Solution__c != null) {
            serviceList = [SELECT Id, Name, csord__Status__c,csordtelcoa__Delta_Status__c,LG_Access_Technology__c,
                           LG_Action__c, LG_Address__r.LG_FullAddressDetails__c, csordtelcoa__Product_Configuration__c
                           FROM csord__Service__c
                           WHERE LG_Suborder__c = :this.cs.LG_Solution__c];
        }
        System.debug('serviceList' + serviceList);

        return serviceList;
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
                ProvisioningDetails provisioningDetails = new ProvisioningDetails();
                provisioningDetails.service = serviceRecord;
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

    public List<Site_Survey__c> getSiteSurveyRecords(){
        List<Site_Survey__c> siteSurveyList = new List<Site_Survey__c>();
        day=true;
        if(suborderAddress!=null){
           siteSurveyList = [SELECT Id,Name,Date__c,Access_Technology__c FROM Site_Survey__c WHERE Address__c= :suborderAddress ORDER BY Date__c Desc];
           if(siteSurveyList.size()==0 || siteSurveyList[0].Date__c<=Date.today().addDays(-2) || siteSurveyList[0].Date__c==null){
                day=false;
            }
        }
        return siteSurveyList;
    }
    public PageReference SaveSOrder(){
        try{
        	if(this.solutionObject.LG_Jeopardy__c == true){
                this.solutionObject.LG_JeopardyRaisedBy__c = UserInfo.getUserId();
            }
        update this.solutionObject;
        }
        catch(DMLException e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.LG_ErrorUpdatingSubOrder));
            return null;
        }
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.LG_SuborderUpdated));
        return ApexPages.CurrentPage();
    }
    public PageReference Cancel(){
        return null;
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
    }
}