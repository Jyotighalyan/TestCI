/**
 * Number portability standard controller extension
 *
 * @author Petar Miletic
 * @story SFOM-252
 * @since 13/01/2017
*/
public class LG_SConsoleNumberPortabilityExtension extends LG_ServiceConsoleBase {

    // Record type
    public String caseRecordType { get; set; }

    // Standard object (Case)
    private final Case cs { get; private set; }
    public boolean caseClosed {get;set;}

    public csord__Solution__c solutionObject { get; private set; }

    // List of services
    private Map<Id, csord__Service__c> services { get; private set; }

    // View Model used to display data on the Visual Force page
    public List<NumberPortabillityViewModel> viewModel { get; private set; }

    public List<LG_AssetProcessAssociation__c> assetAssociations { get; private set; }

    // Show hide editor
    public Boolean editor { get; private set; }
    
    public Boolean jeopardy { get; set; }

    public List<NumberPortabillityViewModel> activeViewModel { get; private set; }
    public LG_PortingProcess__c activeProcess { get; private set; }
    public LG_ProcessRequest__c activeRequest { get; private set; }
    
    
    /*
     * Class constructor
    */
    public LG_SConsoleNumberPortabilityExtension(ApexPages.StandardController stdController) {

        List<String> defaultFields = new List<String>();

        if (!Test.isRunningTest()) {

            defaultFields.add('LG_Service__c');
            defaultFields.add('LG_Solution__c');
            defaultFields.add('LG_Solution__r.LG_TargetDate__c');
            defaultFields.add('LG_Solution__r.LG_Jeopardy__c');
            defaultFields.add('LG_Solution__r.LG_JeopardyExplanation__c');
            defaultFields.add('LG_Solution__r.Jeopardy_Reason__c');
            defaultFields.add('LG_Order__c');
      defaultFields.add('Status');
            defaultFields.add('RecordType.Name');

            stdController.addFields(defaultFields);
        }

        this.cs = (Case)stdController.getRecord();

        if (!Test.isRunningTest()) {
            this.solutionObject = cs.LG_Solution__r;
        } else {
            this.solutionObject = new csord__Solution__c();
        }
    
        this.editor = false;
        this.jeopardy = true;
        this.caseRecordType = getRecordType(this.cs);

        // Load Services and set RecordType
        this.services = getServiceMap();

        // Build view model
        buildViewModel();
    if(this.cs.Status == 'Closed')
        {
           caseClosed = True;
        } else {
            edit();
        }
    }
    
    
    /*
     * Page methods
    */
    public PageReference edit() {

        setMode(DisplayMode.edit);
        return null;
    }
    
    public PageReference cancel() {

        setMode(DisplayMode.detail);
        toogleEdit();
        return null;
    }

    public PageReference save() {

        if (activeRequest.LG_Process__c == null) {
            
            activeRequest.LG_Process__c = this.activeProcess.Id;
        }

        upsert activeRequest;

        toogleEdit();

        buildViewModel();

        setMode(DisplayMode.detail);
        return null;
    }
    
    public PageReference editsolution() {
        
        this.jeopardy = !this.jeopardy;
        return null;
    }
    
    public PageReference savesolution() {
        
        update solutionObject;
        
        this.jeopardy = !this.jeopardy;
        return null;
    }
    
    public PageReference cancelsolution() {
        
        this.jeopardy = !this.jeopardy;
        return null;
    }

    public PageReference toggleEditor() {

        toogleEdit();

        return null;
    }

    /*
     * Mhetods section
    */

    /*
     * Get all services for given Solution
    */
    private Map<Id, csord__Service__c> getServiceMap() {

        if (this.cs.LG_Solution__c != null) {

            return new Map<Id, csord__Service__c>([SELECT Id
                                                   FROM csord__Service__c WHERE LG_Suborder__c = :this.cs.LG_Solution__c]);
                                                        } else {
            return new Map<Id, csord__Service__c>();
        }
    }

    /*
     * Build view model (encapsulate data)
    */
    private void buildViewModel() {

        //if (this.viewModel == null) {
        this.viewModel = new List<NumberPortabillityViewModel>();
        //}

        // Load Asset Process Association objects
        // List<LG_AssetProcessAssociation__c> objs = getAssetsAssociations();
        this.assetAssociations = getAssetsAssociations();

        Set<Id> processIds = new Set<Id>();

        /*
         * For every Asset Process Association extract data
        */
        for (LG_AssetProcessAssociation__c obj : this.assetAssociations) {

            processIds.add(obj.LG_Process__c);
            this.viewModel.add(new NumberPortabillityViewModel(obj));
        }

        // Match process requests
        List<LG_ProcessRequest__c> processRequests = getProcessRequests(processIds);

        // Sort them by Process Id
        Map<Id, List<LG_ProcessRequest__c>> processMap = new Map<Id, List<LG_ProcessRequest__c>>();

        for (LG_ProcessRequest__c req : processRequests) {

            List<LG_ProcessRequest__c> tmp;

            if (processMap.containsKey(req.LG_Process__c)) {

                tmp = processMap.get(req.LG_Process__c);
            } else {
                tmp = new List<LG_ProcessRequest__c>();
            }

            tmp.add(req);

            processMap.put(req.LG_Process__c, tmp);
        }

        // Resolve previous and next requests

        for (Id key : processMap.keySet()) {

            for (NumberPortabillityViewModel obj : this.viewModel) {

                if (obj.process.Id == key) {

                    List<LG_ProcessRequest__c> match = processMap.get(key);

                    if (match.size() > 1) {
                        obj.request = match[0];
                        obj.previousRequest = match[1];
                    } else if (match.size() > 0) {
                        obj.request = match[0];
                    }
                }
            }
        }
    }

    /*
     * Load process requests by process id
    */
    @TestVisible
    private List<LG_ProcessRequest__c> getProcessRequests(Set<Id> processIds) {

        return [SELECT Id,
                Name,
                LG_PortingAgreedDate__c,
                LG_Process__c,
                LG_RequestId__c,
                LG_Response__c
                FROM LG_ProcessRequest__c
                WHERE LG_Process__c IN :processIds
                ORDER BY LG_Process__c, CreatedDate DESC];
    }

    /*
     * Load Asset Process Association object
    */
    @TestVisible
    private List<LG_AssetProcessAssociation__c> getAssetsAssociations() {

        // If there are no services just return
        if (this.services.isEmpty()) {
            return new List<LG_AssetProcessAssociation__c>();
        }

        List<LG_AssetProcessAssociation__c> objs = [SELECT Id, Name, LG_Asset__c,
                                            LG_Asset__r.Name,
                                            LG_Asset__r.LG_PortInInitials__c,
                                            LG_Asset__r.LG_PortInName__c,
                                            LG_Asset__r.LG_PortInStreet__c,
                                            LG_Asset__r.LG_PortInHouseNumber__c,
                                            LG_Asset__r.LG_PortInHouseNumberExtension__c,
                                            LG_Asset__r.LG_PortInZipcode__c,
                                            LG_Asset__r.LG_PortInCity__c,
                                            LG_Asset__r.LG_PortInOperator__c,
                                            LG_Asset__r.LG_StartNumber__c,
                                            LG_Asset__r.LG_NumberRange__c,
                                            LG_Asset__r.LG_NumberRangeSize__c,
                                            LG_Asset__r.LG_NumberRangeType__c,
                                            LG_Asset__r.LG_PortInWishDate__c,
                                            LG_Asset__r.LG_PortInType__c,
                                            LG_Asset__r.RecordType.Name,
                                            LG_Process__c,
                                            LG_Process__r.LG_ChangeIndicator__c,
                                            LG_Process__r.LG_PortInWishDate__c,
                                            LG_Process__r.LG_PortOutDate__c,
                                            LG_Process__r.LG_Provider__c,
                                            LG_Process__r.LG_PostalStreet__c,
                                            LG_Process__r.LG_PostalPostalCode__c,
                                            LG_Process__r.LG_PostalHouseNumber__c,
                                            LG_Process__r.LG_PostalHouseNumberExtension__c,
                                            LG_Process__r.LG_PostalCity__c,
                                            LG_Process__r.LG_PostalCountry__c
                                            FROM LG_AssetProcessAssociation__c
                                            WHERE LG_Asset__r.LG_TelephonyService__c IN :this.services.keySet() AND
                                            LG_Asset__r.RecordType.Name = 'Number Block' AND
                                                    LG_Asset__r.LG_NumberRangeType__c = 'Portin'];

        return objs;
    }


    /*
     * Toogle editor interface
    */
    @TestVisible
    private void toogleEdit() {

        if (this.editor) {
            this.editor = false;
        } else {

            Id processId = (Id)System.currentPageReference().getParameters().get('processId');

            this.activeViewModel = retrieveViewSubset(processId);

            this.editor = true;
        }
    }

    @TestVisible
    private List<NumberPortabillityViewModel> retrieveViewSubset(Id processId) {

        List<NumberPortabillityViewModel> subsetList = new  List<NumberPortabillityViewModel>();
        
        // Reset active request
        this.activeRequest = new LG_ProcessRequest__c();
        
        /*
         * For every Asset Process Association extract data
        */
        for (NumberPortabillityViewModel obj : this.viewModel) {

            if (obj.process.Id == processId) {

                subsetList.add(obj);
            }
        }

        if (subsetList.size() > 0) {
            
            this.activeProcess = subsetList[0].process;

            // If there is a Request assigned but no Response then use that record
            if (subsetList[0].request != null && subsetList[0].request.LG_Response__c == null) {
                this.activeRequest = subsetList[0].request;
            }
        } else {
            this.activeProcess = new LG_PortingProcess__c();
        }

        return subsetList;
    }

    /*
     * Number portability view
     * model (used for displaying data on the page)
    */
    public class NumberPortabillityViewModel {

        public Asset assetRec { get; private set; }
        public LG_PortingProcess__c process { get; private set; }
        public LG_ProcessRequest__c request { get; private set; }
        public LG_ProcessRequest__c previousRequest { get; private set; }

        public NumberPortabillityViewModel(LG_AssetProcessAssociation__c obj) {

            this.assetRec = obj.LG_Asset__r;
            this.process = obj.LG_Process__r;
            this.request = new LG_ProcessRequest__c();
            this.previousRequest = new LG_ProcessRequest__c();
        }

        public String donorAccount {

            get {

                if (this.process == null) {
                    return '';
                }

                List<String> donor = new List<String>();

                this.addItem(donor, this.assetRec.LG_PortInInitials__c);
                this.addItem(donor, this.assetRec.LG_PortInName__c);
                this.addItem(donor, this.assetRec.LG_PortInStreet__c);
                this.addItem(donor, this.assetRec.LG_PortInHouseNumber__c);
                this.addItem(donor, this.assetRec.LG_PortInHouseNumberExtension__c);
                this.addItem(donor, this.assetRec.LG_PortInZipcode__c);
                this.addItem(donor, this.assetRec.LG_PortInCity__c);

                return String.join(donor, ', ');
                }
                }

        private void addItem(List<String> itemList, String item) {

            if (String.isNotBlank(item)) {
                itemList.add(item);
            }
        }
    }
}