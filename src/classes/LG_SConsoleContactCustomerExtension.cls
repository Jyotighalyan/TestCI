/**
* Custom Extension controller for Contact Customer Case record type
*
* @author Ganesh Subbiah
* @story SFOM-335
* @since  31/01/2017
*/
public class LG_SConsoleContactCustomerExtension extends LG_ServiceConsoleBase {

    public boolean typecourtesy { get; set; }
    public boolean typeweeklycall { get; set; }
    public String caseRecordType { get; set; }
    private string orderNumber;
    private string contactid;
    public boolean caseClosed {get;set;}

    @TestVisible
    private final Case cs { get; set; }
    @TestVisible
    private LG_ProductConfigurationUtil util {get; set;}

    @TestVisible
    private csord__Solution__c solutionObject { get; set; }
    public csord__Solution__c getSolution() {
        if (this.solutionObject == null) {
            this.solutionObject = getSolutionRecord();
        }
        return this.solutionObject;
    }

    @TestVisible
    private List<csord__Service__c> serviceObject { get; set; }
    public List<csord__Service__c> getService() {
        if (this.serviceObject == null) {
            this.serviceObject = getServiceRecords();
        }
        return this.serviceObject;
    }

    @TestVisible
    private List<csord__Service_Line_Item__c> serviceLineObject { get; set; }
    public List<csord__Service_Line_Item__c> getServiceLineItems() {
        if (this.serviceLineObject == null) {
            this.serviceLineObject = getServiceLineItemRecords();
        }
        return this.serviceLineObject;
    }

    @TestVisible
    private List<Contact> contactList { get; set; }
    public List<Contact> getContactList() {
        if (this.contactList == null) {
            this.contactList = getContactRecords();
        }
        return this.contactList;
    }
    @TestVisible
    private List<ProvisioningDetails> provisioningDetails {get; set;}
    public List<ProvisioningDetails> getProvisioningDetails() {
        if (this.provisioningDetails == null) {
            this.provisioningDetails = getProvisioningDetailsRecords();
        }
        return this.provisioningDetails;
    }
    public String MailURLPath {
            get {
                //return 'https://composer.congamerge.com?TemplateId=a2k6E0000004CuN&sessionId='+UserInfo.getSessionId();
                return '/_ui/core/email/author/EmailAuthor?retURL='+
                    EncodingUtil.urlEncode('/apex/LG_SConsoleContactCustomer?id='+this.cs.Id, 'UTF-8')+
                    '&p3_lkid='+this.cs.LG_Solution__c;
                }
    }
    public String CongaURLPath {
            get {
                return 'https://composer.congamerge.com?';

                }
    }

    public String AccountId{get; set;}
    //Standard Controller
    public LG_SConsoleContactCustomerExtension (ApexPages.StandardController stdController) {
        if (!Test.isRunningTest()) {
            List<String> defaultFields = new List<String>();

            defaultFields.add('LG_Service__c');
            defaultFields.add('LG_Solution__c');
            defaultFields.add('LG_Order__c');
            defaultFields.add('Type');
            defaultFields.add('Status');
            defaultFields.add('RecordType.Name');


            stdController.addFields(defaultFields);
            this.cs = (Case)stdController.getRecord();

            System.debug('Case: ' + this.cs);
        } else {
            this.cs = [select LG_Service__c, LG_Solution__c, Type, LG_Order__c, RecordType.Name, Status from Case LIMIT 1];
        }
        System.debug('Case==>' + this.cs.Type);
        if (this.cs.Type == 'Courtesy Call') {
            typecourtesy = true;
        } else if (this.cs.Type == 'Keep Customer Informed') {
            typeweeklycall = true;
        }
		if(this.cs.Status == 'Closed')
        {
           caseClosed = True;
        }
        getService();
        getServiceLineItems();

        this.caseRecordType = getRecordType();

    }
    private csord__Solution__c getSolutionRecord() {
        csord__Solution__c solObj = new csord__Solution__c();
        Id solId = this.cs.LG_Solution__c;
        if (solId != null) {
            List<csord__Solution__c> solList = [SELECT Id, Name, LG_Address__c, LG_Address__r.Name, LG_ProvisioningWorkOrder__c, LG_Jeopardy__c, LG_JeopardyExplanation__c,
                   csord__Order__r.csord__Account__r.Name, csord__Order__r.Name, csord__Order__r.csord__Order_Type__c,csord__Order__r.csord__Order_Number__c ,csord__Order__r.csord__Account__c,
                   LG_PlanningRequired__c, Jeopardy_Reason__c, Ownerid, csord__Order__r.csordtelcoa__Opportunity__c, LG_Targetdate__c, LG_Address__r.LG_TechnicalContact__c,LG_Address__r.LG_FullAddressDetails__c FROM csord__Solution__c WHERE Id = :solId];

            System.debug('obj' + solObj);
            if(!solList.isEmpty())
            {
                solObj = solList[0];
            }
        }
        return solObj;
    }

    public List<csord__Service__c> getServiceRecords() {
        List<csord__Service__c> serviceObjList;
        if (this.cs.LG_Solution__c != null) {
            serviceObjList = [SELECT Id, Name,
                          LG_ProvisioningCode__c,
                          LG_Address__c,
                          LG_Address__r.Name,
                          LG_Address__r.LG_HouseNumber__c,
                          LG_Address__r.cscrm__Street__c,
                          LG_Address__r.cscrm__City__c,
                          LG_Address__r.cscrm__Zip_Postal_Code__c,
                          LG_Address__r.cscrm__Country__c,
                          csordtelcoa__Product_Configuration__c,
                          csord__Status__c,
                          LG_InstallDate__c,
                          LG_FailureReason__c,
                          LG_Comments__c,
                          csord__Activation_Date__c,
                          LG_TestResult__c,
                          LG_ServiceStatus__c,
                          LG_EffectiveDate__C,
                          csordtelcoa__Delta_Status__c, //SFOM-567
                          csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.Name
                          FROM csord__Service__c
                          WHERE LG_Suborder__c = :this.cs.LG_Solution__c];
        } else {
            serviceObjList = new List<csord__Service__c>();
        }

        System.debug('serviceObjList' + serviceObjList);

        return serviceObjList;
    }

    public List<Contact> getContactRecords(){
        List<Contact> contactListDetails = new List<Contact>();
        List<OpportunityContactRole> primarycontactList = new list<OpportunityContactRole>();
        csord__Solution__c obj;

        Id accId = null;
        id oppid = null;

        //Fetching Acount Id assosiated with the solution object
        if(solutionObject != null){
            accId = solutionObject.csord__Order__r.csord__Account__c;
            oppid = solutionObject.csord__Order__r.csordtelcoa__Opportunity__c;
        }else{
            obj = [SELECT Id, csord__Order__r.csord__Account__c,csord__Order__r.csordtelcoa__Opportunity__c FROM csord__Solution__c WHERE Id = :this.cs.LG_Solution__c];
            accId = obj.csord__Order__r.csord__Account__c;
            oppid = obj.csord__Order__r.csordtelcoa__Opportunity__c;
        }
        //Fetching the contact list related to the Account Obj
        if(oppid != null && accid!= null){
            contactListDetails = [SELECT Id, FirstName, LastName, Phone, Email FROM Contact WHERE Accountid=:accid];
            AccountId = accId;
       //     primarycontactList = [SELECT Id FROM Contact WHERE AccountId=:accId and LG_DecisionMaker__c = True ];
            primarycontactList = [select ContactID from OpportunityContactRole where IsPrimary = true and OpportunityId = :oppid];
            if(!primarycontactList.isEmpty())
                contactid = primarycontactList[0].ContactID;
        }
       return contactListDetails;
    }

    public List<ProvisioningDetails> getProvisioningDetailsRecords() {
        List<ProvisioningDetails> provisionList;
        List<ProvisioningDetails> provisionLineItemList;
        List<Id> prodConfIdList = new List<Id>();
        system.debug('serviceObject.size()' + serviceObject.size());
        if (serviceObject.size() > 0) {
            provisionList = new List<ProvisioningDetails>();
            for (csord__Service__c serviceRecord : serviceObject) {
                if (serviceRecord.csordtelcoa__Product_Configuration__c != null) {
                    prodConfIdList.add(serviceRecord.csordtelcoa__Product_Configuration__c);
                }
            }
            system.debug('prodConfIdList = ' + prodConfIdList.size());
            util = new LG_ProductConfigurationUtil(prodConfIdList);
            for (csord__Service__c serviceRecord : serviceObject) {
                ProvisioningDetails provisioningDetails = new ProvisioningDetails(this.caseRecordType, serviceRecord);
                String address = serviceRecord.LG_Address__r.LG_HouseNumber__c + ', ' + serviceRecord.LG_Address__r.cscrm__Street__c + ', ' + serviceRecord.LG_Address__r.cscrm__City__c + ', ' +
                                 serviceRecord.LG_Address__r.cscrm__Zip_Postal_Code__c + ', ' + serviceRecord.LG_Address__r.cscrm__Country__c;
                if(address != null)
                {
                    address = address.replaceAll('null,', '');
                    address = address.replaceAll('null', '');
                    address = address.replaceAll(',,', ',');
                    provisioningDetails.address = ', ' + address;
                }
                system.debug('xxxxxx-->' + serviceRecord.csordtelcoa__Product_Configuration__c);

                if (serviceRecord.csordtelcoa__Product_Configuration__c != null) {
                    String keyAttributes = util.getKeyAttributesPerProdConf(serviceRecord.csordtelcoa__Product_Configuration__c);
                    system.debug('keyAttributes-->' + keyAttributes);
                    if (keyAttributes != '') {
                        provisioningDetails.keyAttribute = '(' + keyAttributes + ')';
                    }
                }
                provisionList.add(provisioningDetails);
            }
        }
        return provisionList;
    }

    public List<csord__Service_Line_Item__c> getServiceLineItemRecords() {
        List<csord__Service_Line_Item__c>  serviceLineItemList = new List<csord__Service_Line_Item__c>();
        Set<id> idSet = new Set<id>();
        for (csord__Service__c serviceRecord : serviceObject) {
            idSet.add(serviceRecord.id);
        }
        List<csord__Service_Line_Item__c>  lineItems = [SELECT Id, Name, csord__Service__c FROM csord__Service_Line_Item__c WHERE csord__Service__c in :idSet];
        serviceLineItemList.addAll(lineItems);
        return serviceLineItemList;
    }

    public PageReference sendEmail() {
        PageReference pageRef = new PageReference(MailURLPath);//MailURLPath
        pageRef.setRedirect(true);
        return pageRef;
    }

    public String getRecordType() {
        return this.cs.RecordType.Name;
    }

    public Boolean getCaseType() {
        return this.cs.RecordType.Name == 'Contact Customer';
    }

    public string getRelatedOrder(){
        if(this.orderNumber==null){
            populateOrderNumber();
        }
        return orderNumber;
    }
    public void populateOrderNumber(){
        this.OrderNumber = getSolution().csord__Order__r.csord__Order_Number__c;
    }

    public string getrelatedcontact(){
        return contactid;
    }

    @TestVisible
    public class ProvisioningDetails {

        public csord__Service__c service {get; set;}
        public csord__Service_Line_Item__c serviceLineItem {get; set;}
        public String address {get; set;}
        public String keyAttribute {get; set;}

        private String getScreenFlowUri { get; private set; }
        private String getProductConfigurationId { get; private set; }

    /*  public String screenFlowPath {
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
    //      this.getScreenFlowUri = LG_Util.getScreenFlowAsParam(cRecordType, productDefinition);
        //  this.getProductConfigurationId = obj.csordtelcoa__Product_Configuration__c;
        }
    }
}