/**
* This class is to place a request in JIRA system by sending the JIRA form
* created via UM_JiraCreateIssue class.
* 
* @author Ankur Gupta
* @ticket SFOM-2143
* @since  08/11/2017
*/
global class LG_JiraProvisioningStep implements CSPOFA.ExecutionHandler, CSPOFA.Calloutable
{     
    Set<Id> processesIds;
    Set<String> jiraIssueTypeIds;
    
    List<sObject> results;
    List<Note> errorNotes;
    List<Database.SaveResult> saveResults;
    List<csord__service__c> servicesToUpdate;
    List<csord__solution__c> subordersToUpdate;
    List<CSPOFA__Orchestration_Step__c> stepList;
    
    Boolean timeoutFlag = false;
    Boolean calloutsPerformed = false;
    
    Integer triesCount = 0;
    
    Map<Id,csord__solution__c> subordersMap;
    Map<Id,csord__solution__c> serviceErrorMap;
    Map<Id,csord__service__c> mainServicesMap;
    Map<String,JiraAttributesMapping__mdt> attrMap;
    Map<Id,List<csord__service__c>> allServicesMap;
    
    public Boolean performCallouts(List<SObject> data) 
    {
        processesIds     = new Set<Id>();
        jiraIssueTypeIds = new Set<String>();
        
        results     = new List<sObject>();
        errorNotes  = new List<Note>();
        saveResults = new List<Database.SaveResult>();
        
        servicesToUpdate  = new List<csord__Service__c>();
        subordersToUpdate = new List<csord__solution__c>();
        
        subordersMap    = new Map<Id,csord__solution__c>();
        mainServicesMap = new Map<Id,csord__service__c>();
        attrMap         = new Map<String,JiraAttributesMapping__mdt>();
        allServicesMap  = new Map<Id,List<csord__service__c>>();

        stepList = (List<CSPOFA__Orchestration_Step__c>)data;        

        Jira_Credentials__c credentials = Jira_Credentials__c.getInstance();
        
        String connectionUrl = credentials.Connection_URL__c;
        Blob headerValue = Blob.valueOf(credentials.Username__c + ':' + credentials.Authentication_Token__c);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        for (CSPOFA__Orchestration_Step__c step : stepList) {
            processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }
        
        System.debug('processesIds: ' + processesIds);
        
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
        
        System.debug('suborders: ' + subordersMap);
        
        if(!subordersMap.isEmpty())
        {
            for(csord__service__c service :  [SELECT Id,UM_JiraIssueTypeId__c,csord__service__c,LG_Suborder__c,LG_Suborder__r.LG_Integration_Description__c, 
                                              LG_Suborder__r.LG_Integration_Status__c FROM csord__Service__c WHERE LG_Suborder__c IN :subordersMap.keySet()])
            {
                if(service.UM_JiraIssueTypeId__c != null)
                {
                    mainServicesMap.put(service.LG_Suborder__c, service);
                    jiraIssueTypeIds.add(service.UM_JiraIssueTypeId__c);
                }
                
                if(!allServicesMap.containsKey(service.LG_Suborder__c))
                    allServicesMap.put(service.LG_Suborder__c, new List<csord__Service__c>{service} );
                else{
                    allServicesMap.get(service.LG_Suborder__c).add(service);
                }
            }
            
            for(JiraAttributesMapping__mdt attr : [SELECT id, Attribute_Name__c, Constant_Value__c, Form_Name__c, SF_Field__c 
                                                   FROM JiraAttributesMapping__mdt WHERE Form_Name__c IN :jiraIssueTypeIds 
                                                   AND Attribute_Name__c = 'project'])
            {
                attrMap.put(attr.Form_Name__c, attr);
            }
            
            for(csord__solution__c currentSuborder : subordersMap.values())
            {
                triesCount = 1;
                jiraCallout(currentSuborder,authorizationHeader,connectionUrl, mainServicesMap.get(currentSuborder.Id), allServicesMap.get(currentSuborder.Id));
                
                if(timeoutFlag){
                    for(Integer count = 1 ; count < 4 ; count++)
                    {
                        if(timeoutFlag){
                            triesCount = triesCount + 1;
                            jiraCallout(currentSuborder,authorizationHeader,connectionUrl, mainServicesMap.get(currentSuborder.Id), allServicesMap.get(currentSuborder.Id));
                        }
                        else
                            break;
                    }
                }
                if (triesCount < 4)
                    calloutsPerformed = true;
            }
        }
        return calloutsPerformed;
    }
    
    public List<SObject> process(List<SObject> data) 
    { 
        if(!servicesToUpdate.isEmpty()){
            saveResults = Database.update(servicesToUpdate,false);
            for(Integer i=0; i<saveResults.size(); i++)
            {
                if(!saveResults.get(i).isSuccess())
                {
                    List<Database.Error> errors = saveResults.get(i).getErrors();
                    csord__solution__c suborder = subordersMap.get(servicesToUpdate.get(i).LG_Suborder__c);
                    suborder.LG_Integration_Status__c = 'SFDC Failure';
                    suborder.LG_Integration_Description__c = getErrorDescription(suborder.Id, suborder.LG_Integration_Status__c, Label.LG_JiraExceptionMsg + ' ' + errors); 
                    subordersToUpdate.add(suborder);
                }
            }
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
        
        if(!errorNotes.isEmpty())
        {
            saveResults = Database.insert(errorNotes,false);
            for(Database.SaveResult sr : saveResults)
            {
                if(!sr.isSuccess())
                    System.debug('errors # ' + sr.getErrors());
            }
        }            
        
        for (CSPOFA__Orchestration_Step__c step : stepList) 
        {
            step.CSPOFA__Status__c         = 'Complete';
            step.CSPOFA__Completed_Date__c = Date.today();
            results.add(step);
        }
        
        return results;
    }
    
    
    public void jiraCallout(csord__solution__c currentSuborder, String authorizationHeader, String connectionUrl, 
                            csord__service__c mainService, List<csord__service__c> srvList)
    {
        timeoutFlag = false;
        ResponseWrapper response;
        
        try
        {            
            System.debug('currentSuborder: ' + currentSuborder);
            String reqBody  = UM_JiraCreateIssue.createJiraOrder(currentSuborder);
            
            HttpRequest req = new HttpRequest();
            //  req.setEndpoint(connectionUrl +  attrMap.get(mainService.UM_JiraIssueTypeId__c).Constant_Value__c + '/' + mainService.UM_JiraIssueTypeId__c);
            req.setEndpoint(connectionUrl + '/' + mainService.UM_JiraIssueTypeId__c);
            req.setMethod('PUT');
            req.setHeader('Authorization', authorizationHeader);
            req.setBody(reqBody);
            req.setTimeout(12000);
            
            Http http        = new Http();
            HTTPResponse res = http.send(req);
            System.debug('response: ' + res);
            if(res.getStatusCode() == 200)
                response = (ResponseWrapper)JSON.deserialize(res.getBody(), ResponseWrapper.class);
            else
                response = new ResponseWrapper(null, res.getBody());
            
            currentSuborder.UM_No_of_Tries__c = triesCount;
            
            if(!String.isBlank(response.key))
            {
                currentSuborder.LG_Integration_Status__c      = 'JIRA Work Order Created';
                currentSuborder.LG_ProvisioningWorkOrder__c   = response.key;
                currentSuborder.LG_Integration_Description__c = 'Success';
                currentSuborder.LG_JeopardyExplanation__c = '';
                currentSuborder.Jeopardy_Reason__c = '';
                
                for(csord__service__c srvc : srvList){
                    srvc.LG_ServiceStatus__c = 'Provisioned';
                    servicesToUpdate.add(srvc);
                }
            }
            //check for timeout
            else if(res.getStatusCode() == 408)
            {
                if(triesCount < 4){
                    timeoutFlag = true;
                    return;
                }
                else{
                    currentSuborder.LG_Integration_Status__c = 'Middleware Request Failed';
                    currentSuborder.Jeopardy_Reason__c = 'MiddleWare Timeout';
                    currentSuborder.LG_Jeopardy__c = true;
                    currentSuborder.LG_Integration_Description__c = 'MiddleWare Timeout';
                    currentSuborder.LG_JeopardyExplanation__c =  Label.LG_Orch_Retries_Error;
                }
            }
            else if(!String.isBlank(response.error) || res.getStatusCode() != 200)
            {
                currentSuborder.LG_Integration_Status__c = 'JIRA Order Creation Failed';
                currentSuborder.Jeopardy_Reason__c = 'JIRA Order Creation Failed';
                currentSuborder.LG_Jeopardy__c  = true;
                currentSuborder.LG_Integration_Description__c = getErrorDescription(currentSuborder.Id, currentSuborder.LG_Integration_Status__c, response.error);
                currentSuborder.LG_JeopardyExplanation__c = currentSuborder.LG_Integration_Description__c;
            }
            else{
                currentSuborder.LG_Integration_Status__c = 'JIRA Order Creation Failed';
                currentSuborder.Jeopardy_Reason__c = 'JIRA Order Creation Failed';
                currentSuborder.LG_Jeopardy__c  = true;
                currentSuborder.LG_JeopardyExplanation__c = 'No response received from Jira';
                currentSuborder.LG_Integration_Description__c = 'No response received from Jira';
            }

            subordersToUpdate.add(currentSuborder);
            
            System.debug('checkResponse# ' + response);
            
        } catch(CalloutException e)
        {
            currentSuborder.LG_Integration_Status__c = 'JIRA Order Creation Failed';
            currentSuborder.Jeopardy_Reason__c = 'JIRA Order Creation Failed';
            currentSuborder.LG_Jeopardy__c  = true;
            currentSuborder.LG_Integration_Description__c = getErrorDescription(currentSuborder.Id, currentSuborder.LG_Integration_Status__c, Label.LG_JiraExceptionMsg + ' ' + e.getMessage());
            currentSuborder.LG_JeopardyExplanation__c = currentSuborder.LG_Integration_Description__c;
            
            subordersToUpdate.add(currentSuborder);
        }
        catch(Exception e)
        {
            currentSuborder.LG_Integration_Status__c = 'SFDC failure';
            currentSuborder.Jeopardy_Reason__c = 'SFDC failure';
            currentSuborder.LG_Jeopardy__c  = true;
            currentSuborder.LG_Integration_Description__c = getErrorDescription(currentSuborder.Id, currentSuborder.LG_Integration_Status__c, Label.LG_JiraExceptionMsg + ' ' + e.getMessage());
            currentSuborder.LG_JeopardyExplanation__c = currentSuborder.LG_Integration_Description__c;
           
            subordersToUpdate.add(currentSuborder);
        } 
    }
    
    @TestVisible
    private String getErrorDescription(Id suborderId, String subject, String errors)
    {
        if(errors.length() < 255)
            return errors;
        else
        {
            createErrorNotes(suborderId,  subject , errors);
            return Label.LG_JiraJeopardyError;
        }
    }
    
    @TestVisible
    private void createErrorNotes(Id suborderId, String subject, String description)
    {
        Note note = new Note();
        note.Body = description;
        note.ParentId = suborderId;
        note.Title = Datetime.now() + ' - ' + subject;
        errorNotes.add(note);
    }
    
    public Class ResponseWrapper
    {
        public String key;
        public String error;
        
        public ResponseWrapper(String key, String error)
        {
            this.key = key;
            this.error = error;
        }
    }
}