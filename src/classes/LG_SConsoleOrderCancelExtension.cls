public class LG_SConsoleOrderCancelExtension {
/**
* Custom Extension controller for "Order Cancel Request" Case record type
*
* @author Godson
* @story SFOM-358
* @since  21/02/2017
*/
    private final Case cs { get; set; }
	private csord__Order__c orderObject { get; set; }
    public String errorMessage { get; set; }
    public csord__Order__c getOrder() {
        if (this.orderObject == null) {
            this.orderObject = getOrderRecord();
        }
        return this.orderObject;
    }

    @TestVisible
    private List<csord__Solution__c> solutionObject { get; set; }
    public List<csord__Solution__c> getSolution() {
        if (this.solutionObject == null) {
            this.solutionObject = getSolutionRecord();
        }
        return this.solutionObject;
    }

    @TestVisible
    private List<OrderCancelDetails> orderCancelDetail{get; set;}
    public List<OrderCancelDetails> getOrderCancelDetail() {
        if (this.orderCancelDetail == null) {
            this.orderCancelDetail = getOrderCancelDetailRecord();
        }
        return this.orderCancelDetail;
    }

    /*public String MailURLPath {
            get {
                return '/_ui/core/email/author/EmailAuthor?retURL='+
                    EncodingUtil.urlEncode('/apex/LG_SConsoleOrderCancelDetails?id='+this.cs.Id, 'UTF-8')+
                    '&p3_lkid='+this.cs.LG_Order__c+'&p6=Test';
                }
    }*/

    public boolean caseNew { get; set; }
    public Integer rowVal {get; set;}
    private String ORD_CANCEL_CANCEL = 'CANCELLED';
    private String ORD_CANCEL_CONFIRM = 'CONFIRMED';
    private String CONFIRM_CANCEL = 'Cancel Confirmed';
    private String CANCEL_CANCEL = 'In Provisioning';
    private String ADDRESS = 'ADDRESS';
    private String RELPRODNAMES = 'RELPRODNAMES';
    private String ORDCANCELLED_TEMPLATE = 'Order Cancellation - Cancelled';
    private String ORDCONFIRMED_TEMPLATE = 'Order Cancellation - Confirmed';

    public LG_SConsoleOrderCancelExtension (ApexPages.StandardController stdController) {
        if(!Test.isRunningTest())
        {
            List<String> defaultFields = new List<String>{'LG_Order__c','LG_Solution__c','RecordType.Name','Reason','Status','CaseNumber'};
            stdController.addFields(defaultFields);
        }
        this.cs = (Case)stdController.getRecord();
        
        if (this.cs.Status == 'New') {
            caseNew = true;
        }
    }

    private csord__Order__c getOrderRecord() {
        csord__Order__c orderObj = new csord__Order__c();
        if (this.cs.LG_Order__c == null) {
            return new csord__Order__c();
        }
        List<csord__Order__c> orderList = [SELECT Id, Name, OwnerId, csord__Order_Type__c, csord__Status2__c, csord__Account__r.Name,
                                           csord__Account__r.LG_AccountNumber__c, csordtelcoa__Opportunity__r.Name, csordtelcoa__Opportunity__r.OwnerId, csordtelcoa__Opportunity__r.Owner.Email, csordtelcoa__Opportunity__r.StageName
                                           FROM csord__Order__c WHERE Id = :this.cs.LG_Order__c];
        if(!orderList.isEmpty())
        {
            orderObj = orderList[0];
        }
        return orderObj;
    }

    private List<csord__Solution__c> getSolutionRecord() {
        List<csord__Solution__c> solutions = new List<csord__Solution__c>();
        if (this.cs.LG_Order__c != null) {
            solutions = [SELECT Id, Name, Ownerid, Owner.Email, csord__Status__c, LG_Jeopardy__c, LG_JeopardyRaisedBy__c, Jeopardy_Reason__c
                         , LG_OrderCancelled__c, LG_OrderChanged__c, LG_ProvisioningWorkOrder__c, LG_Address__c
                         FROM csord__Solution__c WHERE csord__Order__c = :this.cs.LG_Order__c];
        }

        return solutions;
    }

    public List<OrderCancelDetails> getOrderCancelDetailRecord(){
        List<OrderCancelDetails> orderCancelDetailList = new List<OrderCancelDetails>();
        List<csord__Solution__c> solutionList = getSolution();
        if(solutionList.size() > 0){
            List<CSPOFA__Orchestration_Process__c> orchProcessList = [SELECT Id, Name, Owner.Email, CSPOFA__Process_On_Hold__c, CSPOFA__Status__c,
                                                                     LG_Solution__c, LG_Order__c, CSPOFA__jeopardy_created_flag__c
                                                                      FROM CSPOFA__Orchestration_Process__c WHERE LG_Solution__c IN :solutionList];
            for(csord__Solution__c solutionData:solutionList){
                OrderCancelDetails OrderCancelDetail = new OrderCancelDetails();
                OrderCancelDetail.solution = solutionData;
                for(CSPOFA__Orchestration_Process__c orchcProcess:orchProcessList){
                    if(orchcProcess.LG_Solution__c == solutionData.Id){
                        OrderCancelDetail.orchestrator = orchcProcess;
                        //OrderCancelDetail.orchStatus = orchcProcess.CSPOFA__Process_On_Hold__c;
                    }
                }
                orderCancelDetailList.add(OrderCancelDetail);
            }
        }
        return orderCancelDetailList;
    }

    public void changeOrchStatus(){
        try {

            if(this.orderCancelDetail != null && this.orderCancelDetail.size() > 0){
                CSPOFA__Orchestration_Process__c orchDetail = orderCancelDetail[rowVal].orchestrator;
                orchDetail.CSPOFA__Process_On_Hold__c = orchDetail.CSPOFA__Process_On_Hold__c ? false:true;
                update orchDetail;
            }
            }catch(Exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            }
    }

    //SFOM-510
    public PageReference cancelConfirmed(){
        Savepoint sp = Database.setSavepoint();
        List<CSPOFA__Orchestration_Process__c> orchProcessList = new List<CSPOFA__Orchestration_Process__c>();
        try{
            if(this.orderObject.id != null){
                orderObject.csord__Status2__c = CONFIRM_CANCEL;
                update orderObject;
                
                //Added as the orchestrator doesn't resume all the process automatically
                if(this.orderCancelDetail != null && this.orderCancelDetail.size() > 0){
                    for(OrderCancelDetails orchProcess : orderCancelDetail){
                        orchProcess.orchestrator.CSPOFA__Process_On_Hold__c = false;
                        orchProcessList.add(orchProcess.orchestrator);
                    }

                    update orchProcessList;
                }
                //Closing the case
                this.cs.Status = 'Closed';
            	update cs;
                caseNew = false;
                //Send mail to opp. owner and suborder owner
                if(!sendNotificationEmail(ORD_CANCEL_CONFIRM)){
                    Database.rollback(sp);
                   	return null;
            	}
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, ORD_CANCEL_CANCEL));
            }
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            Database.rollback(sp);
   			return null;
        }
		return null;
    }


    public PageReference cancelCancelled(){
        Savepoint sp = Database.setSavepoint();
        List<CSPOFA__Orchestration_Process__c> orchProcessList = new List<CSPOFA__Orchestration_Process__c>();
        try{
            if(this.orderObject.id != null){
                orderObject.csord__Status2__c = CANCEL_CANCEL;
                update orderObject;
                if(this.orderCancelDetail != null && this.orderCancelDetail.size() > 0){
                    for(OrderCancelDetails orchProcess : orderCancelDetail){
                        orchProcess.orchestrator.CSPOFA__Process_On_Hold__c = false;
                        orchProcessList.add(orchProcess.orchestrator);
                    }

                    update orchProcessList;
                }

            //this.cs.Reason = 'Cancelled Orders (customer cancelled)';
            this.cs.Status = 'Closed';
            update cs;
            caseNew = false;
			//Send mail to opp. owner and suborder owner
                if(!sendNotificationEmail(ORD_CANCEL_CANCEL)){
                    Database.rollback(sp);
                    return null;
                }
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, CONFIRM_CANCEL));
            }
        }catch(Exception e){
            Database.rollback(sp);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            return null;
        }
		return null;
    }

    
    /**
     * SFOM-510 
     * Send mail notification
     */
    @TestVisible
    private boolean sendNotificationEmail(String status){
        
        String templateName = '';
 
        try{
                
                Case caseDetail = [SELECT Id, OwnerId, Owner.Id, Owner.Name, Owner.LastName, Owner.Email FROM Case WHERE Id = :cs.Id LIMIT 1];
                
                // setWhatId requires Contact. Owner does not work
                Contact tmpContact = new Contact(email = caseDetail.Owner.Email, firstName = caseDetail.Owner.Name, lastName = caseDetail.Owner.LastName);
                insert tmpContact;
                
            Map<String,List<String>> addrAndOrderMap = getToAddressAndOrdNameList();
            List<String> toAddressList = addrAndOrderMap.get(ADDRESS);
                if (this.cs.Id != null) {
                    if(ORD_CANCEL_CANCEL == status){
                        templateName = ORDCANCELLED_TEMPLATE;
                    }else if(ORD_CANCEL_CONFIRM == status){ 
                        templateName = ORDCONFIRMED_TEMPLATE;
                    }
        			
                    EmailTemplate template = [SELECT Id, Name FROM EmailTemplate WHERE Name =:templateName LIMIT 1];

            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                //system.debug('toAddressList=='+toAddressList);
                
                
                message.setTargetObjectId(tmpContact.Id);
                message.setWhatId(this.cs.Id);
                message.setTemplateId(template.Id);
            message.setToAddresses(toAddressList);
                message.setSaveAsActivity(false);
            
                Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
                
                //Clean up Contact
                delete tmpContact;
                    
                if (results[0].success) {
                    errorMessage = System.Label.LG_MessageEmailSentOpportunity;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, errorMessage));
                    return true;
                } else {
                    errorMessage = System.Label.LG_ErrorFailedtoSentEmail;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage+results[0].errors[0].message));
                    return false;
            }
                }else{
                    return false;
        }
                
            } catch (Exception ex) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
                System.debug(ex.getMessage());
                return false;
            }
    }
@TestVisible
    private Map<String,List<String>> getToAddressAndOrdNameList(){
        Map<String,List<String>> addressOrderNameMap = new Map<String,List<String>>();
        List<String> toAddressList = new List<String>();
        List<String> subOrderName = new List<String>();
        if(this.orderObject != null){
            toAddressList.add(orderObject.csordtelcoa__Opportunity__r.Owner.Email);
        }

        for(OrderCancelDetails orderCancel: orderCancelDetail){
            csord__Solution__c solDetail = orderCancel.solution;
            System.debug('solDetail'+solDetail);
            if(solDetail != null && solDetail.Owner.Email != null){
                toAddressList.add(solDetail.Owner.Email);

            }
            //csord__Solution__c solution = orderCancel.solution;
            ///if(solution != null){
                //subOrderName.add(solution.name);
                //subOrderName.add(solution.name);
            //}

        }
        addressOrderNameMap.put(ADDRESS, toAddressList);
        //addressOrderNameMap.put(RELPRODNAMES, subOrderName);

        return addressOrderNameMap;
    }


    public String getRecordType() {
        return this.cs.RecordType.Name;
    }


    public class OrderCancelDetails{
        public csord__Solution__c solution{get; set;}
        public CSPOFA__Orchestration_Process__c orchestrator{get; set;}
        public boolean orchStatus{get; set;}
    }
}