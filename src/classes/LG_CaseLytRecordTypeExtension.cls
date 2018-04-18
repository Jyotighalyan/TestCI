public class LG_CaseLytRecordTypeExtension {
    
    private Case cs { get; set; }
    private String NEWSTATUS = 'New';
    private String CLOSED = 'Closed';
    private String ONHOLD = 'On Hold';
    private String caseRecordType { get; set; }
    private String[] noPublicListing  = new String[]{'Inflight Configuration', 'Manage Subscriptions', 'Number Port','Schedule Appointment','Access Planning'};
    private String[] noCaseReason = new String[]{'Manage Subscriptions'};
    private String[] noManageNumber = new String[]{'Schedule Appointment','Access Planning'};
    //private String caseAssignOrderOwner = 'Assign Order Owner';
    private String caseFollowOnOrder = 'Follow-On Order';
    private String caseProvision = 'Provision';
    //SFOM-1447
    private String caseProvisionOneStep = 'Provision One Step';
    //SFOM-923
    private String caseOrderCancelReq = 'Order Cancel Request';
            
            public Case getCaseDetail(){
                return this.cs;
            }
    
    public LG_CaseLytRecordTypeExtension (ApexPages.StandardController controller){
        if (!Test.isRunningTest()) {
            controller.addFields(getFieldList());
            this.cs = (Case)controller.getRecord();
            
            System.debug('Case==>' + this.cs);
        }else {
            this.cs = [select Subject, Status, OwnerId, Reason, CaseNumber, LG_Service__c, LG_Solution__c, 
                       Type, ContactId, LG_Order__c, RecordType.Name from Case LIMIT 1];
        }
        
        caseRecordType = getRecordType();
        
    }
    
    public boolean getCaseClosed(){
        return this.cs.Status == CLOSED? true:false;
    }
    
    public boolean getCaseOnHold(){
        return this.cs.Status == ONHOLD? true:false;
    }
    public boolean getCaseNew(){
        return this.cs.Status == NEWSTATUS? true:false;
    }
    
    //Return true if case is "Assign Order Owner"
    /*public boolean getCaseAssignOrderOwner(){
        return caseRecordType == caseAssignOrderOwner? true:false;
    }*/
    
    //Return true if case is "Follow-On Order"
    public boolean getCaseFollowOnOrder(){
        return caseRecordType == caseFollowOnOrder? true:false;
    }
    
    //SFOM-923
    //Return true if case is "Order Cancel"
    public boolean getCaseOrderCancelReq(){
        return caseRecordType == caseOrderCancelReq? true:false;
    }
    //SFOM-1321
    // modified for SFOM-1447
    public boolean getCaseProvision(){
        return (caseRecordType == caseProvision || caseRecordType == caseProvisionOneStep)? true:false;
    }
    
    public boolean getNoPublicListing(){
        for(String record: noPublicListing){
            if(caseRecordType == record){
                return true;
            }
        }
        return false;
    }
    
    public boolean getNoCaseReason(){
        for(String record: noCaseReason){
            if(caseRecordType == record){
                return true;
            }
        }
        return false;
    }
    
    public boolean getNoManageNumber(){
        for(String record: noManageNumber){
            if(caseRecordType == record){
                return true;
            }
        }
        return false;
    }
    
    private String getRecordType() {
        return this.cs.RecordType.Name;
    }
    
    public void UpdateCase(){
        Savepoint sp = Database.setSavepoint();
        try{
            update cs;
        } catch (Exception e)
        {
            Database.rollback(sp);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getDmlMessage(0) ));
        }
        
    }
    public void CloseCase(){
        Savepoint sp = Database.setSavepoint();
        
        /*if(this.cs.Status != CLOSED){
            this.cs.Status = CLOSED;
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Case closed Successfully.'));
         }*/
       try{
            update cs;
        } catch (Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getDmlMessage(0) ));
        } 
        List<Id> caseRecord = new List<id>();
        caseRecord.add(this.cs.id);
        String errorMsg = LG_Closecaseutill.closeCase(caseRecord);
        if(errormsg == 'Success')
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, Label.LG_MessageCaseClosed));
        else
        {
            Database.rollback(sp);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errormsg));
        }
        
        
    }
    
    /**
     * @author - Godson D.S.
     * @Date - 14-06-2017
     * @user story - SFOM-936
     * @Method - Returns Number Management page URL
     **/
    public String getManageNumbers(){
        return '/apex/LG_NumberManagement?isdtp=vw&id='+cs.Id;
    }
    
    public PageReference PublicListing(){
        PageReference page = new PageReference('/apex/LG_PublicListing?id='+cs.Id);
        return page;
    }
    
    public PageReference ComplexChange(){
        Savepoint sp = Database.setSavepoint();
        String returnMsg = LG_ComplexChangeUtil.ComplexChange(this.cs.id);
        Pattern regexPattern = Pattern.compile('^[a-zA-Z0-9]{15,18}$');
		Matcher regexMatcher = regexPattern.matcher(returnMsg);
		
        if(regexMatcher.matches()){
            PageReference page = new PageReference('/'+returnMsg);
            return page;
        }else{
            Database.rollback(sp);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, returnMsg));
        }
        return null;
    }
    
    public List<String> getFieldList(){
    	List<String> defaultFields = new List<String>();
        defaultFields.add('LG_Solution__c');
        defaultFields.add('LG_Service__c');
        defaultFields.add('ContactId');
        defaultFields.add('AccountId');
        defaultFields.add('RecordTypeId');
        defaultFields.add('LG_AccountId__c');
        defaultFields.add('Type');
        defaultFields.add('RecordType.Name');
        defaultFields.add('LG_Order__c');
        defaultFields.add('Subject');
        defaultFields.add('Description');
        defaultFields.add('Owner');
        defaultFields.add('CaseNumber');
        defaultFields.add('Status');
        defaultFields.add('Reason');
        return defaultFields;
    }
    
    
}