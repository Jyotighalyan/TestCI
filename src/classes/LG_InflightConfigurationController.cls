global class LG_InflightConfigurationController {
    private final ApexPages.StandardController stdcontroller;
    public Case caseRecord {get ; set;}
    private RecordType recordType {get ; set;}
    private csord__Solution__c solution {get ; set ;}
    private List<csord__Service__c> services {get;set;}
    private csord__Service__c service {get;set;}
    private List<DisplayValues> displayValues {get;set;}
    private LG_ProductConfigurationUtil util {get;set;}

    private String getScreenFlowUri { get; private set; }
    private String getProductConfigurationId { get; private set; }

    public String productDefinition{get;set;}
    public id screenflowid {get;set;}

    public string cRecordType {get;set;}
    public String screenFlowPath {
       get {

       return '/apex/cscfga__ConfigureProduct?configId=' + getProductConfigurationId + this.getScreenFlowUri;


       }
    }


    public csord__Solution__c getRelatedSolution(){
        if(this.solution == null){
            populateRelatedSolution();
        }
        return this.solution;
    }
    public void populateRelatedSolution()
    {
        if(caseRecord.LG_Solution__c!=null){
            List<csord__Solution__c> solutionList= [select Id,
                             Name,
                             csord__Order__c,
                             LG_ProvisioningWorkOrder__c,
                             LG_Jeopardy__c,
                             LG_TargetDate__c,
                             LG_EarliestPortingWishDate__c,
                             LG_LatestPortingWishDate__c
                             from csord__Solution__c where Id=:caseRecord.LG_Solution__c LIMIT 1];
            if(!solutionList.isEmpty()){
                this.solution = solutionList.get(0);
            }
        }
    }

    public List<DisplayValues> getRelatedServices(){

        if(this.displayValues==null){
            populateRelatedServices();
        }system.debug('--top'+screenFlowPath );
        return displayValues;
    }

    /**
     * Updated field value of DisplayValues class (deltaStatus)
     *
     * @author Ankur Gupta
     * @story SFOM-647
     * @since 20/04/2017
    */
    public void populateRelatedServices(){
        List<Id> prodConfigIds = new List<Id>();
        displayValues = new List<displayValues>();
        if(this.services!=null)
        {
            for(csord__Service__c s : this.services){
                prodConfigIds.add(s.csordtelcoa__Product_Configuration__c);
                system.debug(s.csordtelcoa__Product_Configuration__c);
            }
            util = new LG_ProductConfigurationUtil(prodConfigIds);
            system.debug('Services '+ this.services);
            for(csord__Service__c s : this.services){

                String address = s.LG_Address__r.LG_FullAddressDetails__c;
                DisplayValues d = new DisplayValues();
                d.service = s;
                d.keyAttribute = util.getKeyAttributesPerProdConf(s.csordtelcoa__Product_Configuration__c);
                d.status = s.LG_ServiceStatus__c ;
                d.address = address;
                d.startDate = s.csord__Activation_Date__c;
                d.deltaStatus = s.csordtelcoa__Delta_Status__c;    //SFOM-647
                system.debug(s.csordtelcoa__Product_Configuration__c);
                productDefinition = s.csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name;

                RecordType CRT = getCaseRecordType();
                cRecordType = CRT.Name;//String.valueOf(CRT);
                this.getScreenFlowUri = LG_Util.getScreenFlowFullName(cRecordType, productDefinition);
                this.getProductConfigurationId = s.csordtelcoa__Product_Configuration__c;

                cscfga__Screen_Flow__c screen= [select id from cscfga__Screen_Flow__c where Name=:cRecordType+' - '+productDefinition limit 1];
                //d.screenFlowUri = this.screenFlowPath;

                d.screenFlowUri='/'+screen.id;
                displayValues.add(d);
            }
        }
    }

    public RecordType getCaseRecordType(){
        if(this.recordType == null){
            populateCaseRecordType();
        }
        return this.recordType;
    }
    public void populateCaseRecordType(){
        if(this.caseRecord.RecordTypeId!=null){
        List<RecordType> recordTypeList = [select Id,
                           Name,
                           Description from RecordType where Id=:this.caseRecord.RecordTypeId];
            if(!recordTypeList.isEmpty()){
                this.recordType = recordTypeList.get(0);
            }
        }
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

    /**
     * New field added to the query for services (csordtelcoa__Delta_Status__c)
     *
     * @author Ankur Gupta
     * @story SFOM-647
     * @since 20/04/2017
    */
    public LG_InflightConfigurationController(ApexPages.StandardController stdcontroller){
        this.stdcontroller = stdcontroller;
        if (!Test.isRunningTest())
        {
            List<String> defaultFields = new List<String>();
            defaultFields.add('LG_Service__c');
            defaultFields.add('LG_Solution__c');
            defaultFields.add('LG_Order__c');
            defaultFields.add('Id');
            defaultFields.add('CaseNumber');
            defaultFields.add('ContactId');
            defaultFields.add('AccountId');
            defaultFields.add('RecordTypeId');
            defaultFields.add('Type');
            defaultFields.add('Status');
            defaultFields.add('LG_AccountId__c');
            stdController.addFields(defaultFields);
            this.caseRecord = (Case)stdController.getRecord();
        } else{
            List<Case> caseList = [select Id,LG_Service__c,LG_Solution__c,LG_Order__c,CaseNumber,ContactId,AccountId,RecordTypeId,
                               Type,Status,LG_AccountId__c from Case where Id=:stdcontroller.getRecord().Id];
            if(!caseList.isEmpty()){
                this.caseRecord = caseList.get(0);
            }
        }
        if(this.caseRecord.LG_Service__c!=null)
        {
            List<csord__Service__c> serviceList = [select Id,
                                                Name,csord__Order__c,LG_Suborder__c,csordtelcoa__Product_Configuration__c,
                                                csord__Status__c,LG_ServiceStatus__c,csord__Activation_Date__c from csord__Service__c where LG_Suborder__c=:this.caseRecord.LG_Solution__c limit 1];
            if(!serviceList.isEmpty()){
                service = serviceList.get(0);
            }
        }
        this.solution = getRelatedSolution();
        //system.debug('Solution '+ this.solution.Id);
        if(this.solution!=null){
        this.services = [select Id,
                    Name,
                    csord__Order__c,
                    LG_Address__c,
                    LG_Address__r.Name,
                    LG_Address__r.LG_HouseNumber__c,
                    LG_Address__r.cscrm__Street__c,
                    LG_Address__r.cscrm__City__c,
                    LG_Address__r.cscrm__Zip_Postal_Code__c,
                    LG_Address__r.cscrm__Country__c,
                    LG_Address__r.LG_FullAddressDetails__c,
                    LG_Suborder__c,LG_ServiceStatus__c,
                    csordtelcoa__Product_Configuration__c,
                    csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name,
                    csord__Status__c,
                    csordtelcoa__Delta_Status__c,  // SFOM-647
                    csord__Activation_Date__c from csord__Service__c where LG_Suborder__c=:this.solution.Id];
        }
    }

    /**
     * New field added to the clas (deltaStatus)
     *
     * @author Ankur Gupta
     * @story SFOM-647
     * @since 20/04/2017
    */
    public class DisplayValues{
        public csord__Service__c service {get;set;}
        public String keyAttribute {get;set;}
        public String status {get;set;}
        public String address {get;set;}
        public String screenFlowUri {get;set;}
        public string screenFlowPath{get;set;}
        public String deltaStatus{get;set;}    //SFOM-647
        public Date startDate {get;set;}
    }
}