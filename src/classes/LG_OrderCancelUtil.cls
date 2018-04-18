/**
* Utillity class for Order Cancel
*
* @author Ganesh Subbiah
* @ticket SFOM-562
* @since  21/03/2017
*/
global with sharing  class LG_OrderCancelUtil {
    
    private static String CONFIRM_CANCEL = 'Cancel Confirmed';
    private static String CANCEL_REQSTD = 'Cancel Requested';
    private static String CANCEL_REQSTD_MSG = 'There is already a cancellation request in progress for this order: Case ';
    private static String CONFIRM_CANCEL_MSG = 'The order was already cancelled.';
    private static String CLOSED_ORDER_MSG = 'The order is already closed.';
    private static String ORDER_CLOSED = 'Closed';
    
    /**
* New Case record will be created, case record type: Order Cancel Request
*/
    webservice static String cancelOrder(Id orderId) {
        
        try {
            return getExistingOrNewCase(orderId, 'Order Cancel Request', 'Order Cancellation raised by order manager');
            
        } catch (DmlException e) {
            return e.getMessage();
        }
    }
    
    /*
* New Case record will be created, case record type: Follow-on Order
*/
    webservice static String followOnOrder (Id orderId) {
        
        try {
            return getExistingOrNewCase(orderId, 'Follow-On Order', 'Follow-on order created by order manager');
            
        } catch (DmlException e) {
            return e.getMessage();
        }
    }
    
    private static Id getExistingOrNewCase(Id orderId, String recordTypeName, string caseSubject) {
        
        // Get Cases
        List<Case> cases = [SELECT Id,
                            ContactId, 
                            Type, 
                            Description, 
                            Subject, 
                            LG_Solution__c,
                            RecordType.Name,
                            LG_Order__c,
                            Status
                            FROM Case
                            WHERE LG_Order__c   = :orderId AND RecordType.Name = :recordTypeName AND Status NOT IN ('Cancelled', 'Closed')
                            ORDER BY CreatedDate DESC];
        
        // If Cases exist
        if (cases.size() > 0) {
            
            return cases[0].Id;
            
        } else {
            
            // Get record type
            RecordType caseRecordType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND RecordType.Name = :recordTypeName LIMIT 1];
            
            // Create new case
            Case obj = new Case();
            obj.LG_Order__c = orderId;
            obj.RecordTypeId = caseRecordType.Id;
            obj.subject = caseSubject;
            obj.Status = 'New';
            insert obj;
            
            // Return Id
            return obj.Id;
            
        }
    }
    /**
* Method to validate the status of Order
* SFOM-495
**/
    webservice static String checkOrderStatus(Id orderId, String status){
        
        String checkStatus = '';
        List<Case> caseList = new List<Case>();
        if(CANCEL_REQSTD == status){
            caseList = [Select Id, CaseNumber, Status FROM Case WHERE LG_Order__c=:orderId AND Status NOT IN ('Cancelled', 'Closed')
                        ORDER BY CreatedDate DESC];
            
            if(caseList.size() > 0){
                checkStatus =  CANCEL_REQSTD_MSG + caseList[0].CaseNumber+'.';
            }
        }
        
        if(CONFIRM_CANCEL == status){
            checkStatus = CONFIRM_CANCEL_MSG;
        }
        if (ORDER_CLOSED == status) {
            checkStatus = CLOSED_ORDER_MSG;
        }
        return checkStatus;
    }
    
    /**
* Method to Check the Order Cancel is already exists or not.
* @author Godson DS
* @ticket SFOM-528 
* @since 27-03-2017
**/
    webservice static String validateSubOrderStatus(Id orderId){
        String checkStatus = '';
        String status = '';
        List<csord__Order__c> orderList = [SELECT Id, Name, csord__Status2__c FROM csord__Order__c 
                                           WHERE Id=:orderId];
        if(orderList.size() > 0){
            status = orderList[0].csord__Status2__c;
        }
        checkStatus = checkOrderStatus(orderId, status);
        return checkStatus;
    }
    
    /**
* Method to pause or resume an orchestration process related to a sub-order
* @author Godson DS
* @ticket SFOM-528 
* @since 27-03-2017
**/
    webservice static String updateOrchProcess(Id subOrderId, String action){
        String status = 'No Orchestration Process found.';
        List<CSPOFA__Orchestration_Process__c> updateList = new List<CSPOFA__Orchestration_Process__c>();
        List<CSPOFA__Orchestration_Process__c> orchProcessList = new List<CSPOFA__Orchestration_Process__c>();
        try{
            orchProcessList = [SELECT Id, Name, CSPOFA__Process_On_Hold__c FROM CSPOFA__Orchestration_Process__c WHERE LG_Solution__c =:subOrderId];
            if(null != orchProcessList && !orchProcessList.isempty())
            {    
                for(CSPOFA__Orchestration_Process__c orchProcess:orchProcessList ){
                if(action == 'pause'){
                    orchProcess.CSPOFA__Process_On_Hold__c = true;
                    status = 'Process Paused.';
                }else{
                    orchProcess.CSPOFA__Process_On_Hold__c = false;
                    status = 'Process Resumed.';
                }
                updateList.add(orchProcess);
            }
             update updateList;
            }
        }catch(Exception e){
            status = e.getMessage();
        }
        return status;
    }
    }