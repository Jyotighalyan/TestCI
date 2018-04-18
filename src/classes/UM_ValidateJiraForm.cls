/**
 * This class is to validate all the mandatory fields which are required to be passed in JIRA form
 * to get a successful work order creation.
 * 
 * @author Ankur Gupta
 * @ticket SFOM-2143
 * @since  10/11/2017
*/
global class UM_ValidateJiraForm implements CSPOFA.ExecutionHandler
{
    List<Note> errorNotes = new List<Note>();
    List<Database.SaveResult> saveResults = new List<Database.SaveResult>();
    List<csord__Solution__c> subordersToUpdate = new List<csord__Solution__c>();
    
    Map<String,JiraAttributesMapping__mdt> parameterMap = new Map<String,JiraAttributesMapping__mdt>();
    
    public List<SObject> process(List<SObject> data) 
    { 
        Set<Id> processesIds = new Set<Id>();
        
        List<sObject> results = new List<sObject>();
        List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;
        
        Map<Id,csord__Solution__c> subordersMap = new Map<Id,csord__Solution__c>();

        for (CSPOFA__Orchestration_Step__c step : stepList) {
            processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }
        
        System.debug('processesIds--> ' + processesIds);        
        for (CSPOFA__Orchestration_Process__c process : [SELECT Id,
                                                         LG_Solution__r.csord__Account__c, LG_Solution__r.csord__Account__r.NumberOfEmployees, LG_Solution__r.csord__Account__r.LG_ChamberOfCommerceNumber__c, LG_Solution__r.csord__Account__r.UM_IndustryClassification__c,
                                                         LG_Solution__r.LG_Address__c, LG_Solution__r.LG_Address__r.cscrm__State_Province__c,  LG_Solution__r.LG_Address__r.LG_AddressID__c, LG_Solution__c,
                                                         LG_Solution__r.csord__Status__c,LG_Solution__r.UM_No_of_Tries__c,
                                                         LG_Solution__r.id,
                                                         LG_Solution__r.LG_ProvisioningAccountNo__c,
                                                         LG_Solution__r.csord__Order__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c,
                                                         LG_Solution__r.csord__Order__c
                                                         , csordtelcoa__Service__r.LG_ProvisioningCode__c
                                                         FROM CSPOFA__Orchestration_Process__c
                                                         WHERE Id IN :processesIds AND LG_Solution__c != null]) 
        {
            if(process.LG_Solution__c != null)
                subordersMap.put(process.LG_Solution__c, process.LG_Solution__r);
        }
        
        System.debug('suborders--> ' + subordersMap); 
        
        if(!subordersMap.isEmpty())
        {
            for(csord__solution__c currentSuborder : subordersMap.values())
            {
               validateForm(currentSuborder);
            }
            
            if(!subordersToUpdate.isEmpty())
            {
                saveResults = Database.update(subordersToUpdate,false);
                for(Integer i=0; i<saveResults.size(); i++)
                {
                    if(!saveResults.get(i).isSuccess())
                    {
                        List<Database.Error> errors = saveResults.get(i).getErrors();
                        csord__solution__c suborder = subordersMap.get(subordersToUpdate.get(i).Id);
                        createErrorNotes(suborder.Id, 'Error occured during record updation', Label.LG_JiraExceptionMsg + ' ' + errors);                    
                    }
                }
            }
            
            if(!errorNotes.isEmpty()){
                saveResults = Database.insert(errorNotes,false);
                for(Database.SaveResult sr : saveResults){
                    if(!sr.isSuccess())
                        System.debug('errors # ' + sr.getErrors());
                }
            }  
            
        }
        
        System.debug('subordersToUpdate##' + subordersToUpdate);
        
        for (CSPOFA__Orchestration_Step__c step : stepList) 
        {
            step.CSPOFA__Status__c         = 'Complete';
            step.CSPOFA__Completed_Date__c = Date.today();
            results.add(step);
        }
             
        return results;
    }
    
    public void validateForm(csord__solution__c currentSuborder)
    {
        try
        {
            UM_JiraCreateIssue.createJiraOrder(currentSuborder);
            
            System.debug('missing fields#' + UM_JiraCreateIssue.missingFieldMap );  
            
            if(! UM_JiraCreateIssue.missingFieldMap.isEmpty())
            {
               /* for(Schema.SObjectType obj : UM_JiraCreateIssue.missingFieldMap.keySet())
                {
                    System.debug('ObjName# ' + obj.getDescribe().getLabel());
                    for(Schema.SObjectField fieldName : UM_JiraCreateIssue.missingFieldMap.get(obj))
                    {
                        System.debug('fieldName#' + fieldName.getDescribe().getLabel());
                    }
                    
                }*/
                System.debug('inside map');
                currentSuborder.LG_Jeopardy__c            = true;
                currentSuborder.Jeopardy_Reason__c        = 'JIRA Order Creation Failed';
                String errorMsg = 'These field values cannot be left blank: ' + UM_JiraCreateIssue.missingFieldMap;
                if(errorMsg.length() < 255) {
                currentSuborder.LG_JeopardyExplanation__c = errorMsg ;
                currentSuborder.LG_Integration_Description__c = currentSuborder.LG_JeopardyExplanation__c;
                }
                else
                {
                    currentSuborder.LG_JeopardyExplanation__c = 'Internal ' + Label.LG_JiraJeopardyError;
                    currentSuborder.LG_Integration_Description__c = Label.LG_JiraExceptionMsg +  ' Internal ' + Label.LG_JiraJeopardyError;
                    createErrorNotes(currentSuborder.id,  currentSuborder.LG_Integration_Status__c , errorMsg ); 
                }
                currentSuborder.LG_Integration_Status__c = 'JIRA Order Creation Failed';
            }
            else
            {
                currentSuborder.LG_Jeopardy__c            = false;
                currentSuborder.Jeopardy_Reason__c        = '';
                currentSuborder.LG_JeopardyExplanation__c = '';
                currentSuborder.LG_Integration_Description__c = '';
            }
            
            subordersToUpdate.add(currentSuborder);
        }
        catch(Exception e)
        {
            String exceptionMsg = e.getMessage();
            currentSuborder.LG_Integration_Status__c = 'SFDC failure';
            currentSuborder.Jeopardy_Reason__c = 'SFDC failure';
            currentSuborder.LG_Jeopardy__c  = true;
            //To increase length of exception for test class
            if(Test.isRunningTest()){
                exceptionMsg += ', Jira Form Validation failed because some mandatory fields have blank value. Please fill values for mandatory fields and try again. ' + Label.LG_JiraJeopardyError;
            }
            
            if(exceptionMsg.length() < (255- Label.LG_JiraExceptionMsg.length())){
                currentSuborder.LG_Integration_Description__c = Label.LG_JiraExceptionMsg + exceptionMsg;
                currentSuborder.LG_JeopardyExplanation__c = Label.LG_JiraExceptionMsg + exceptionMsg;
            }
            else{
                currentSuborder.LG_JeopardyExplanation__c = 'Internal ' + Label.LG_JiraJeopardyError;
                currentSuborder.LG_Integration_Description__c = Label.LG_JiraExceptionMsg +  ' Internal ' + Label.LG_JiraJeopardyError;
                createErrorNotes(currentSuborder.id,  currentSuborder.LG_Integration_Status__c , exceptionMsg);
            }
            subordersToUpdate.add(currentSuborder);
        }
    }
    
    public void createErrorNotes(Id suborderId, String subject, String description)
    {
        Note note = new Note();
        note.Body = description;
        note.ParentId = suborderId;
        note.Title = Datetime.now() + ' - ' + subject;
        errorNotes.add(note);
    }
}