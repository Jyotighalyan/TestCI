/**
* Used to receive response from spider on placed order and store in solution
* @author Sathya.b
* @ticket SFOM-929
* @since  16/6/2017
*
*`New Version:
* @author Ankur Gupta
* @ticket SFOM-2296
* @since  13/12/2017
*/

@RestResource(urlMapping='/UM_UpdateSolutions/')
global with sharing class UM_UpdateSolutionsfromSpiderResponse
{   
    static Map<Id,String> errMap = new Map<Id,String>();
    static List<Note> errorNotes = new List<Note>();
    static String exceptionMsg = null;
    
    @HttpPost
    global static void updateCamaWODetails(String transactionId, String status, String customerAccountNumber, String workOrderNumber , String pendingOrderNumber, String errors)
    {
        System.debug('--transactionId#  ' + transactionId);
        System.debug('--status# ' + status);
        System.debug('--customerAccountNumber# ' + customerAccountNumber);
        System.debug('--workOrderNumber# ' + workOrderNumber);
        System.debug('--pendingOrderNumber# ' + pendingOrderNumber);
        System.debug('--errors# ' + errors);
        
        csord__solution__c suborder;
        List<csord__service__c> servicesToUpdate = new List<csord__service__c>();
        List<csord__solution__c> solutionResult  = new List<csord__solution__c>();
        
        if(!String.isBlank(transactionId))
        {
            try
            {
                solutionResult = [SELECT Id, Name, LastModifiedbyId, LastModifiedby.ProfileId , LastModifiedby.LanguageLocaleKey, 
                                  LastModifiedby.LocaleSidKey, LG_Provisioning_External_Id__c, LG_Jeopardy__c , Jeopardy_Reason__c,
                                  LG_JeopardyExplanation__c, LG_Integration_Status__c, LG_ProvisioningWorkOrder__c, LG_ProvisioningAccountNo__c,
                                  LG_Integration_Description__c,csord__Status__c FROM csord__Solution__c WHERE LG_Provisioning_External_Id__c = :transactionId];
                
                if(!solutionResult.isEmpty())
                    suborder = solutionResult[0];
                
                system.debug('--solutionResult'+ suborder);
                
                if(suborder != null)
                { 
                    System.debug('User language locale# ' +  suborder.LastModifiedby.LanguageLocaleKey);
                    if(!String.isBlank(errors) && suborder.LastModifiedby.LanguageLocaleKey.equalsIgnoreCase('de')) 
                        errors = germanErrorTranslator(errors);
                    
                    // Success Reponse
                    if(!String.isBlank(status) && status == 'Success')
                    {   
                        //SFOM-1507 change
                        if (suborder.csord__Status__c == 'In Progress') 
                            suborder.csord__Status__c = 'In Provisioning';
                        
                        if(workOrderNumber != '0' && !String.isBlank(workOrderNumber))
                        {
                            suborder.LG_ProvisioningWorkOrder__c   = workOrderNumber;
                            suborder.LG_Integration_Status__c      = 'Work Order Created';
                            suborder.LG_Integration_Description__c = 'Success';
                            
                            if(customerAccountNumber != '0' && !String.isBlank(customerAccountNumber) && String.isBlank(suborder.LG_ProvisioningAccountNo__c))
                                suborder.LG_ProvisioningAccountNo__c = customerAccountNumber;
                            
                            for (csord__service__c service : [SELECT Id, Name, LG_ProvisioningAccountNo__c, LG_ServiceStatus__c 
                                                              FROM csord__service__c WHERE LG_Suborder__c = :suborder.Id])
                            {
                                service.LG_ProvisioningAccountNo__c = suborder.LG_ProvisioningAccountNo__c;
                                service.LG_ServiceStatus__c = 'Provisioned';
                                servicesToUpdate.add(service);
                            }
                        }
                        
                        else if((workOrderNumber == '0' || String.isBlank(workOrderNumber)) && pendingOrderNumber != '0' 
                                && !String.isBlank(pendingOrderNumber))
                        {      
                            suborder.LG_Integration_Status__c      = 'Pending Work Order Created';
                            suborder.LG_ProvisioningWorkOrder__c   = pendingOrderNumber;
                            suborder.LG_Integration_Description__c = getErrorDescription(suborder.Id, transactionId + ' : ' + suborder.LG_Integration_Status__c, 'Pending Order: ' + errors);
                        }
                        
                        else if(workOrderNumber == '0' && pendingOrderNumber == '0')
                        {
                            suborder.LG_Integration_Status__c      = 'Pending Work Order Created';
                            suborder.LG_Integration_Description__c = getErrorDescription( suborder.Id, transactionId + ' : ' + suborder.LG_Integration_Status__c, 'Pending Order: ' + errors);
                        }
                    }
                    
                    // Failure Reponse
                    else if(!String.isBlank(status) && status == 'Failure')
                    {
                        System.debug('--Inside failure status');
                        
                        suborder.LG_Jeopardy__c = true;
                        suborder.LG_Integration_Status__c = 'Order Creation Failed';
                        suborder.Jeopardy_Reason__c = 'Provisioning WO Creation Failed';
                        suborder.LG_Integration_Description__c = getErrorDescription(suborder.Id, transactionId + ' : ' + suborder.LG_Integration_Status__c, errors);
                        suborder.LG_JeopardyExplanation__c = suborder.LG_Integration_Description__c;
                    }    
                    
                    System.debug('suborderWithNewValues# ' + suborder);
                    
                    //Update Solutions and services
                    if(!servicesToUpdate.isEmpty())
                    {
                        update servicesToUpdate;
                    }
                    
                    update suborder;
                }
            }
            catch(DMLException e){
                exceptionMsg = e.getMessage();
                suborder.LG_Integration_Status__c = 'SFDC failure';
                suborder.LG_Integration_Description__c = getErrorDescription(suborder.Id, transactionId + ' : ' + suborder.LG_Integration_Status__c , Label.LG_JiraExceptionMsg + ' ' + exceptionMsg);
                if(!exceptionMsg.contains(suborder.id))
                    update suborder;
            }
            catch(Exception e){
                exceptionMsg = e.getMessage();
                suborder.LG_Integration_Status__c = 'SFDC failure';
                suborder.LG_Integration_Description__c = getErrorDescription(suborder.Id , transactionId + ' : ' + suborder.LG_Integration_Status__c, Label.LG_JiraExceptionMsg + ' ' + exceptionMsg );
                if(!exceptionMsg.contains(suborder.id))
                    update suborder;
            }
            
            if(!errorNotes.isEmpty())
                insert errorNotes;
            
            if(exceptionMsg != null)
            {
                System.debug('Failure');
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize( new ResponseWrapper('Failure', 'Not successfully updated in SFDC Error: '+ exceptionMsg)));
                return;
            }
            else
            {
                System.debug('Success');
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize( new ResponseWrapper('Success', 'Success')));
                return;
            }
        }
        else
        {
            System.debug('Transaction Id Missing in request');
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize( new ResponseWrapper('Failure', 'No Transaction Id found')));
            return;
        }
    }
    
    @TestVisible
    private static String germanErrorTranslator(String errors)
    {
        Map<String,String> errorTranslationMap = new Map<String,String>();
        
        for(Integration_Errors_Translation__c error : [SELECT name, errorInGerman__c, error__c FROM Integration_Errors_Translation__c])
        {
            errorTranslationMap.put(error.error__c, error.errorInGerman__c);
        }
        
        System.debug('error before translation: ' + errors);
        
        for(String key : errorTranslationMap.keySet())
        {
            if(errors.contains(key))
                errors = errors.replace(key, errorTranslationMap.get(key));
        }
        
        System.debug('error after translation: ' + errors);
        
        return errors;
    }
    
    @TestVisible
    private static String getErrorDescription(Id suborderId, String subject, String errors)
    {
        if(errors.length() < 255)
            return errors;
        else
        {
            createErrorNotes(suborderId,  subject , errors);
            if(exceptionMsg != null)
                return Label.LG_JiraExceptionMsg +  ' Internal ' + Label.LG_JiraJeopardyError;
            else
                return Label.LG_JiraJeopardyError;
        }
    }
    
    @TestVisible
    private static void createErrorNotes(Id suborderId, String subject, String description)
    {
        Note note = new Note();
        note.Body = description;
        note.ParentId = suborderId;
        note.Title = Datetime.now() + ' - ' + subject;
        System.debug('Notes# ' + note);
        errorNotes.add(note);
    }
    
    public class ResponseWrapper{
        
        public String status;
        public String statusMessage;
        
        public ResponseWrapper (String status, String statusMessage)
        {
            this.status = status;
            this.statusMessage = statusMessage;
        }
    }
}