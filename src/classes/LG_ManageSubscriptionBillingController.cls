public class LG_ManageSubscriptionBillingController {

    public Case caseRecord {get ; set;}
    private RecordType recordType {get ; set;}
    private csord__Solution__c solution {get ; set ;}
    private csord__Order__c order {get;set;}
    private csord__Solution__c subOrder {get;set;}
    private List<csord__Service__c> services {get;set;}
    private csord__Service__c service {get;set;}
    private List<csord__Service_Line_Item__c> serviceLineItems {get;set;}
    private csconta__Billing_Account__c billingAccounts {get;set;}
    private List<DisplayValues> displayValues {get;set;}
    private List<SLIDisplay> sliDisplay {get;set;}
    private LG_ProductConfigurationUtil util {get;set;}

    public csord__Solution__c getRelatedSolution(){

        if(this.solution == null){
            populateRelatedSolution();
        }

        return this.solution;

    }

    public void populateRelatedSolution(){

        if(caseRecord.LG_Solution__c!=null){
            this.solution = [select Id,
                             Name,
                             csord__Order__c,
                             LG_ProvisioningWorkOrder__c
                             from csord__Solution__c where Id=:caseRecord.LG_Solution__c LIMIT 1];
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
        this.recordType = [select Id,
                           Name,
                           Description from RecordType where Id=:this.caseRecord.RecordTypeId];
        }

    }

    public csord__Order__c getRelatedOrder(){

        if(this.order==null){
            populateRelatedOrder();
        }


        return this.order;
    }
    public void populateRelatedOrder(){

        if(this.service.LG_RootOrder__c != null){
        this.order = [select Id,Name from csord__Order__c where Id=:service.LG_RootOrder__c];
        }

    }

    public csord__Solution__c getRelatedSubOrder(){

        if(this.subOrder==null){
            populateRelatedSubOrder();
        }

        return this.subOrder;
    }

    public void populateRelatedSubOrder(){

        if(this.service.LG_SubOrder__c!=null){
        subOrder = [select Id,
                    Name from csord__Solution__c where Id=:this.service.LG_SubOrder__c];
        }

    }


    public List<DisplayValues> getRelatedServices(){

        if(this.displayValues==null){
            populateRelatedServices();
        }

        return displayValues;
    }

    /**
     * Updated DisplayValues Class field delta Status
     *
     * @author Ankur Gupta
     * @story SFOM-647
     * @since 20/04/2017
    */
    public void populateRelatedServices(){

        List<Id> prodConfigIds = new List<Id>();
        displayValues = new List<displayValues>();
        if(this.services!=null){
        for(csord__Service__c s : this.services){
            prodConfigIds.add(s.csordtelcoa__Product_Configuration__c);
            system.debug(s.csordtelcoa__Product_Configuration__c);
        }

        util = new LG_ProductConfigurationUtil(prodConfigIds);
        for(csord__Service__c s : this.services){
            String address = s.LG_Address__r.LG_FullAddressDetails__c;
            DisplayValues d = new DisplayValues();
            d.service = s;
            d.keyAttribute = util.getKeyAttributesPerProdConf(s.csordtelcoa__Product_Configuration__c);
            d.status = s.LG_ServiceStatus__c ;
            d.address = address;
            d.startDate = s.csord__Activation_Date__c;
            d.deltaStatus = s.csordtelcoa__Delta_Status__c; // SFOM-647
            displayValues.add(d);
        }
        }

    }

    public List<SLIDisplay> getRelatedServiceLineItems(){

        if(this.sliDisplay == null){
            populateRelatedServiceLineItems();
        }

        return this.sliDisplay;
    }

    /**
     * New field added to the query lineitems and services (csordtelcoa__Delta_Status__c)
     *
     * @author Ankur Gupta
     * @story SFOM-647
     * @since 20/04/2017
    */
    public void populateRelatedServiceLineItems(){

        sliDisplay = new List<SLIDisplay>();
        if(this.services!=null){
        List<Id> serviceWithStartDate = new List<Id>();
        for(csord__Service__c s : this.services){
            if(s.csord__Activation_Date__c!=null){
                serviceWithStartDate.add(s.Id);
            }
        }
        List<csord__Service_Line_Item__c> lineItems = [select Id,
                                                       Name,
                                                       csord__External_Identifier__c,
                                                       csord__Total_Price__c,
                                                       LG_BillingAccount__c,
                                                       csordtelcoa__Delta_Status__c, //SFOM-647
                                                       csord__Service__c from csord__Service_Line_Item__c where csord__Service__c=:serviceWithStartDate];

        for(csord__Service_Line_Item__c s : lineItems){
            SLIDisplay sli = new SLIDisplay();
            sli.service = [select Id,
                           Name,
                           csord__Order__c,
                           LG_RootOrder__c,
                           LG_Suborder__c,
                           csordtelcoa__Product_Configuration__c,
                           csord__Status__c,
                           csord__Activation_Date__c,
                           csordtelcoa__Delta_Status__c, //SFOM -647
                           LG_Servicestatus__C from csord__Service__c where Id=:s.csord__Service__c];

            sli.lineItem = s;
            if(s.LG_BillingAccount__c!=null){
            sli.billingAccount = [select Id,
                                  Name,
                                  csconta__Account__c,
                                  LG_ExternalId__c from csconta__Billing_Account__c where Id=:s.LG_BillingAccount__c];
            }
            sliDisplay.add(sli);
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
     * New field added to the query (csordtelcoa__Delta_Status__c)
     *
     * @author Ankur Gupta
     * @story SFOM-647
     * @since 20/04/2017
    */
    public LG_ManageSubscriptionBillingController(ApexPages.StandardController stdcontroller){

        if (!Test.isRunningTest()) {
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

        }

        else{
            this.caseRecord = [select Id,
                               LG_Service__c,
                               LG_Solution__c,
                               LG_Order__c,
                               CaseNumber,
                               ContactId,
                               AccountId,
                               RecordTypeId,
                               Type,
                               Status,
                               LG_AccountId__c from Case where Id=:stdcontroller.getRecord().Id];
        }



        if(this.caseRecord.LG_Service__c!=null){
        service = [select Id,
                   Name,
                   csord__Order__c,
                   LG_RootOrder__c,
                   LG_Suborder__c,
                   csordtelcoa__Product_Configuration__c,
                   csord__Status__c,LG_ServiceStatus__c,
                   csord__Activation_Date__c from csord__Service__c where LG_Suborder__c=:this.caseRecord.LG_Solution__c];
        }

        this.solution = getRelatedSolution();

        if(this.solution!=null){
        services = [select Id,
                    Name,
                    csord__Order__c,
                    LG_RootOrder__c,
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
                    csord__Status__c,
                    csordtelcoa__Delta_Status__c, //SFOM -647
                    csord__Activation_Date__c from csord__Service__c where LG_Suborder__c=:solution.Id];
        }


    }

    public PageReference close(){
            PageReference returnPage = new PageReference('/' + service.Id);
            returnPage.setRedirect(true);
            return returnPage;
        }

    /**
     * New field added to the Class (deltaStatus)
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
        public Date startDate {get;set;}
        public String deltaStatus{get;set;}   //SFOM-647
    }

    public class SLIDisplay{
        public csord__Service__c service{get;set;}
        public csord__Service_Line_Item__c lineItem{get;set;}
        public csconta__Billing_Account__c billingAccount{get;set;}

    }
}