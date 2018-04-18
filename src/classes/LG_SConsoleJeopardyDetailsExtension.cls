public class LG_SConsoleJeopardyDetailsExtension extends LG_ServiceConsoleBase {
    @TestVisible
    private final Case cs { get; set; }

    public boolean TypeCost {get; set;}
    public boolean TypeInstActive {get; set;}
    public String currencyType {get; set;}
    public String caseURL{get;set;}
    public String caseNumber{get;set;}
    public boolean isCaseClosed{get;set;}
    public boolean cancelRequested {get;set;}
    public String errorMessage {get;set;}
    private static String CONFIRM_CANCEL = 'Cancel Confirmed';
    private static String CANCEL_REQSTD = 'Cancel Requested';

    @TestVisible
    private csord__Solution__c solutionObject { get; set; }

    public csord__Solution__c getSolution() {

        if (this.solutionObject == null) {
            this.solutionObject = getSolutionRecord();
        }

        return this.solutionObject;
    }

    @TestVisible
    private List<csord__Solution__c> relatedSolutionsObject { get; set; }

    public List<csord__Solution__c> getRelatedSolutions() {

        if (this.relatedSolutionsObject == null) {
            this.relatedSolutionsObject = getrelatedSolutionsRecord();
        }

        return this.relatedSolutionsObject;
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
    private List<ProvisioningDetails> provisioningDetails {get; set;}

    public List<ProvisioningDetails> getProvisioningDetails() {

        if (this.provisioningDetails == null) {
            this.provisioningDetails = getProvisioningDetailsRecords();
        }

        return this.provisioningDetails;
    }

    /*private List<CaseComment> caseComment { get; set; }

    public List<CaseComment> getCaseComment() {

        if (this.caseComment == null) {
            this.caseComment = getCaseCommentRecords();
        }

        return this.caseComment;
    }*/


    public LG_SConsoleJeopardyDetailsExtension (ApexPages.StandardController stdController) {
        if (!Test.isRunningTest()) {
            List<String> defaultFields = new List<String>();

            defaultFields.add('LG_Solution__c');
            defaultFields.add('Contact');
            defaultFields.add('Type');
            defaultFields.add('RecordType.Name');
            defaultFields.add('LG_Order__c');
             defaultFields.add('Status');
            stdController.addFields(defaultFields);
            this.cs = (Case)stdController.getRecord();

            System.debug('Case==>' + this.cs);
        } else {
            this.cs = [select LG_Service__c, LG_Solution__c, Type, ContactId, LG_Order__c, RecordType.Name, Status from Case LIMIT 1];
        }
        getSolution();
        getService();
        //Edit();
        if (this.cs.Type == 'Cost') {
            TypeCost = true;
        } else if (this.cs.Type == 'Install & Activate') {
            TypeInstActive = true;
        }

        isCaseClosed = false;
        if(this.cs.Status == 'Closed') {
            isCaseClosed = true;
        }

        //SFOM-602 fix
        checkOrderStatus();

        currencyType = getCurrencySymbol(UserInfo.getDefaultCurrency());
    }

    private csord__Solution__c getSolutionRecord() {
        csord__Solution__c solution;
        Id solId = this.cs.LG_Solution__c;
        if (solId != null) {
            solution = [SELECT Id, Name, LG_Solution_Name__c, OwnerId, LG_Jeopardy__c, LG_JeopardyExplanation__c,
                        //LG_OrderChanged__c, LG_OrderCancelled__c, Removed as SFOM-546 is removed from scope
                       LG_TriggerPartialBilling__c, Jeopardy_Reason__c,
                   LG_JeopardyRaisedBy__c, LG_ApproverComments__c, csord__Order__c,
                   csord__Order__r.csordtelcoa__Opportunity__c, //Sfom-1637
                   csord__Order__r.csord__Account__r.Name, csord__Order__r.csord__Account__r.Phone, LG_Address__c,
                   //added as a part of SFOM-512
                   LG_Address__r.LG_FullAddressDetails__c, LG_Address__r.LG_TechnicalContact__r.phone, LG_Address__r.LG_TechnicalContact__r.Name
                   FROM csord__Solution__c WHERE Id = :solId];

        } else {
            solution = new csord__Solution__c();
        }

        return solution;
    }

    public List<csord__Solution__c> getrelatedSolutionsRecord() {
        List<csord__Solution__c> solutions = new List<csord__Solution__c>();
        if (solutionObject.csord__Order__c != null) {
            solutions = [SELECT Id, Name, LG_Solution_Name__c FROM csord__Solution__c WHERE csord__Order__c = :solutionObject.csord__Order__c AND Id != :this.cs.LG_Solution__c];
        }

        return solutions;
    }

    /**
     * New field added to the query (csordtelcoa__Delta_Status__c)
     *
     * @author Ankur Gupta
     * @story SFOM-647
     * @since 20/04/2017
    */
    public List<csord__Service__c> getServiceRecords() {
        List<csord__Service__c> serviceList;
        if (this.cs.LG_Solution__c != null) {
            serviceList = [SELECT Id, Name, csord__Status__c,csordtelcoa__Delta_Status__c FROM csord__Service__c
                          WHERE LG_Suborder__c = :this.cs.LG_Solution__c];
        } else {
            serviceList = new List<csord__Service__c>();
        }

        System.debug('serviceList' + serviceList);

        return serviceList;
    }

	/**
     * New field added to the query for lineItems (csordtelcoa__Delta_Status__c)
     *
     * @author Ankur Gupta
     * @story SFOM-647
     * @since 20/04/2017
    */
    @TestVisible
    private List<csord__Service_Line_Item__c> getServiceLineItemRecords() {
        List<csord__Service_Line_Item__c>  serviceLineItemList = new List<csord__Service_Line_Item__c>();
        for (csord__Service__c serviceRecord : serviceObject) {
            List<csord__Service_Line_Item__c>  lineItems = [SELECT Id, Name, csord__Service__c, csord__Service__r.csord__Status__c,
                                               csord__Service__r.LG_EffectiveDate__c, csord__Line_Description__c, csord__Total_Price__c,
                                                            csordtelcoa__Delta_Status__c, //SFOM-647
                                               LG_BillingAccount__c, LG_BillingAccount__r.LG_BillingAccountName__c, LG_BillingAccount__r.LG_ExternalId__c, LG_BillingAccount__r.Name
                                               FROM csord__Service_Line_Item__c WHERE csord__Service__c = :serviceRecord.Id];
            serviceLineItemList.addAll(lineItems);
        }
        return serviceLineItemList;
    }

    public List<ProvisioningDetails> getProvisioningDetailsRecords() {
        List<ProvisioningDetails> provisionList;
        List<csord__Service_Line_Item__c> serviceLineObject;
        if (serviceObject.size() > 0) {
            provisionList = new List<ProvisioningDetails>();
            serviceLineObject = getServiceLineItemRecords();

            for (csord__Service__c serviceRecord : serviceObject) {
                ProvisioningDetails provisioningDetails = new ProvisioningDetails();
                provisioningDetails.name = serviceRecord.Name;
                provisioningDetails.serviceLineItems = null;
                provisioningDetails.child = false;
                provisionList.add(provisioningDetails);
                for (csord__Service_Line_Item__c serviceLineItem : serviceLineObject) {
                    //fetch service line items of the associated service
                    if (serviceRecord.Id == serviceLineItem.csord__Service__c) {
                        ProvisioningDetails provisioningSLDetails = new ProvisioningDetails();
                        provisioningSLDetails.child = true;
                        provisioningSLDetails.serviceLineItems = serviceLineItem;
                        provisionList.add(provisioningSLDetails);

                    }

                }

            }
        }
        return provisionList;
    }

    public String getCurrencySymbol(String currencyISOCode) {
        String currencySymbol = '';
        if (currencyISOCode == 'EUR') {
            currencySymbol = '€';
        } else if (currencyISOCode == 'GBP') {
            currencySymbol = '£';
        } else if (currencyISOCode == 'USD') {
            currencySymbol = '$';
        }

        return currencySymbol;
    }



    public Boolean getJeopardy() {
        return this.cs.RecordType.Name == 'Jeopardy';
    }

    /*
    * Page methods
    */
    public PageReference edit() {

        setMode(DisplayMode.edit);
        return null;
    }


    /**
	 * close - Jeopardy
	 *
	 * @author Minhaj Alam
	 * @ticket - SFOM-504
	 * @since  15/3/2017
	 */

    public PageReference closeJeopardy() {
        /*try {
            this.cs.Status = 'Closed';
            update cs;
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            setMode(DisplayMode.detail);
            return null;
        }   */ //SFOM-589
        List<Id> caseRecord = new List<id>();
        caseRecord.add(this.cs.id);
        String errorMsg = LG_Closecaseutill.closeCase(caseRecord);
        if(errormsg == 'Success'){
            errorMessage = System.Label.LG_MessageCaseClosed;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, Label.LG_MessageCaseClosed));
        }
        else
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
        setMode(DisplayMode.detail);
        return null;
    }

    /**
	 * request - Cancel
	 *
	 * @author Minhaj Alam
	 * @ticket - SFOM-504
	 * @since  15/3/2017
	 */
    public PageReference requestCancel() {
        try {
           List<csord__Order__c> orderDetail = [SELECT Id, csord__Status2__c FROM csord__Order__c WHERE Id = :solutionObject.csord__Order__c LIMIT 1];
            if(orderDetail.size() > 0){
                orderDetail[0].csord__Status2__c = 'Cancel Requested';
                update orderDetail;
            } else {
                errorMessage = System.Label.LG_ErrorNoOrderDetailFound;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));

            	return null;
            }
            //Create Cancel Order
             CancelOrder();

            //SFOM-602 fix
        	checkOrderStatus();
            errorMessage = System.Label.LG_MessageCancelOrderPlaced;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, errorMessage));

        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            return null;
        }

        return null;
    }

    /**
	 * Inflight - Appointment
	 *
	 * @author Minhaj Alam
	 * @ticket - SFOM-504
	 * @since  15/3/2017
	 */
    public PageReference InflightAppointment(){
        Id solutionId = this.cs.LG_Solution__c;
		try {
			if(solutionId != null){
				Id recordId =  LG_InflightChangeUtil.reSchedule(solutionId);
				handleCaseResult(recordId);
            }
		}catch(Exception e){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error Ocurred :'+e.getMessage()));

		}
		return null;
    }

    /**
	 * Inflight - Number
	 *
	 * @author Minhaj Alam
	 * @ticket - SFOM-504
	 * @since  15/3/2017
	 */
    public PageReference InflightNumber(){
        Id solutionId = this.cs.LG_Solution__c;
        try {
			if(solutionId != null){
				Id recordId =  LG_InflightChangeUtil.correctNumbers(solutionId);
				handleCaseResult(recordId);
            }
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error Ocurred :'+e.getMessage()));
		}

        return null;
    }

    /**
	 * Inflight - Configuration
	 *
	 * @author Minhaj Alam
	 * @ticket - SFOM-504
	 * @since  15/3/2017
	 */
    public PageReference InflightConfiguration(){
        Id solutionId = this.cs.LG_Solution__c;
        try {
			if(solutionId != null){
				Id recordId =  LG_InflightChangeUtil.configure(solutionId);
				handleCaseResult(recordId);
            }
		}catch(Exception e){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error Ocurred :'+e.getMessage()));

		}

        return null;
    }

    /**
	 * ComplexChange
	 *
	 * @author Minhaj Alam
	 * @ticket - SFOM-504
	 * @since  15/3/2017
	 */
    public PageReference complexChange(){
        Id caseId = this.cs.Id;
        try {
	        if(caseId != null){
	            LG_ComplexChangeUtil.ComplexChange(caseId);
	        }
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));

            return null;
        }
        errorMessage = System.Label.LG_MessageComplexChangeRequested;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, errorMessage));
        return null;
    }



    public PageReference save() {
        try {
            update solutionObject;

        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            setMode(DisplayMode.edit);
            return null;
        }
        errorMessage = System.Label.LG_MessageSavedSuccessfully;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, errorMessage));
        setMode(DisplayMode.detail);
        return null;
    }

    public PageReference cancel() {
        setMode(DisplayMode.detail);
        return null;
    }


    /**
	 * create Order Cancellation case
	 *
	 * @author Minhaj Alam
	 * @ticket - SFOM-504
	 * @since  15/3/2017
	 */
    public void CancelOrder()
    {
       Id orderId = solutionObject.csord__Order__c;
       try
       {
           if (orderId != null) {
                Id recordId =  LG_OrderCancelUtil.cancelOrder(orderId);
				handleCaseResult(recordId);
            } else {
                errorMessage = System.Label.LG_ErrorNoOrderExists;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error Ocurred : '+errorMessage));
            }
       } catch(Exception e){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error Ocurred :'+e.getMessage()));
        }

    }

   /**
     * create Follow on  case
     *
     * @author Minhaj Alam
     * @ticket - SFOM-504
     * @since  7/4/2017
     */
    public PageReference FollowOrder()
    {
        Id orderId = solutionObject.csord__Order__c;
       try
       {
           if(orderId != null) {
                Id recordId =  LG_OrderCancelUtil.followOnOrder(orderId);
				handleCaseResult(recordId);
            } else {
                errorMessage = System.Label.LG_ErrorNoOrderExists;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error Ocurred : '+errorMessage));

            	return null;
            }
       } catch(Exception e) {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error Ocurred :'+e.getMessage()));
        }

        return null;
    }

       /**
     * create Follow on  case
     *
     * @author Minhaj Alam
     * @ticket - SFOM-504
     * @since  7/4/2017
     */
    public void handleCaseResult(Id recordId)
    {
		system.debug(recordId);
		String objectType = String.valueOf(recordId.getSobjectType());
		if (objectType == 'Case') {
		    list<case> cases = [SELECT Id, CaseNumber FROM Case WHERE Id = :recordId];
		    if (cases.size()>0) {
		        caseURL = '/'+recordId;
		        caseNumber = cases[0].CaseNumber;
		    }
		} else {
		     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, recordId));
		}
    }


    @TestVisible
    public class ProvisioningDetails {
        public csord__Service_Line_Item__c serviceLineItems {get;set;}
        public String name {get; set;}
        public boolean child {get; set;}
    }

	/**
     *
     *
     */
    public void checkOrderStatus(){
        try {
            List<csord__Order__c> orderDetail = [SELECT Id, csord__Status2__c FROM csord__Order__c WHERE Id = :solutionObject.csord__Order__c LIMIT 1];
            if(orderDetail.size() > 0){
                if(CONFIRM_CANCEL == orderDetail[0].csord__Status2__c || CANCEL_REQSTD == orderDetail[0].csord__Status2__c){
                    cancelRequested = true;
                }
            }


        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
        }
    }

    /* Enable or Disable Extra Charges button based on Case and Service Status
     *
     * @author - Ankur Gupta
     * @Story - SFOM - 564
     */
    public boolean validStage{get; set;}
    public void applyExtraCharges(){
        validStage = true;
        Set<String> serviceStages = new Set<String>{'READY FOR BILLING', 'ACTIVE', 'CANCELLED' ,'INACTIVE', 'CLOSED REPLACED'};

                List<csord__service__c> serviceList = getServiceRecords();

        if(isCaseClosed) {
            validStage = false;
        }
        else if( !serviceList.isEmpty() ) {
            for(csord__service__c service: serviceList){
                if(serviceStages.contains(service.csord__status__c.toUpperCase())){
                    validStage = false;
                }
            }
        }
    }

}