/**
 *Extension for VF page LG_SconsoleDisplayOldBdsSite
 * @author Alisha
 * @ticket OMB-1746
 * @since  18/12/2017
 */
public class LG_SconsoleDisplayOldBdsSiteExtension extends LG_ServiceConsoleBase {
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
    private List<ProvisioningDetails> provisioningDetails { get; set; }
    @TestVisible
    private LG_ConsoleSectionUtil consoleUtil {get; set;}



    @TestVisible
    private LG_ProductConfigurationUtil util { get; set; }

    @TestVisible
    //private LG_ScreenSectionUtil screenUtil { get; set; }
    public boolean jeopardy { get; set; }

    public LG_SconsoleDisplayOldBdsSiteExtension (ApexPages.StandardController stdController) {
        if (!Test.isRunningTest()) {
            List<String> defaultFields = new List<String>{'LG_Service__c','LG_Solution__c','LG_Order__c','Status','RecordType.Name'};
            stdController.addFields(defaultFields);
            this.cs = (Case)stdController.getRecord();

        } else {
            this.cs = [select LG_Service__c, LG_Solution__c, LG_Order__c, Status, RecordType.Name from Case];
        }
        System.debug('Case' + this.cs);
        this.caseRecordType = getRecordType();
    if(this.cs.Status == 'Closed')
        {
           caseClosed = True;
        } 
    }

    @TestVisible

    private csord__Solution__c getSolutionRecord() {
        csord__Solution__c solution;
        List<csord__Solution__c> solutionList = new List<csord__Solution__c>();
        Id solId = this.cs.LG_Solution__c;
        if (solId != null) {
            solutionList = [SELECT Id, Name, LG_Address__c, csord__Account__c, csord__Order__c,LG_OldESNNumber__c,
                   csord__Order__r.csordtelcoa__Opportunity__c, csord__Order__r.csord__Account__c,LG_Jeopardy__c 
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


    public String getRecordType() {
        return this.cs.RecordType.Name;
    }

    public Boolean getProvisioning() {
        return this.cs.RecordType.Name == 'Terminate';
    }

    public PageReference PageRefresh() {
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
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


}