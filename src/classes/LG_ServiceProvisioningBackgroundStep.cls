/***custom step to call place order in background mode**/
/*`New Version:
* @author Ankur Gupta
* @ticket SFOM-2296
* @since  13/12/2017
*/
global class LG_ServiceProvisioningBackgroundStep implements CSPOFA.ExecutionHandler , CSPOFA.Calloutable 
{
    Set<Id> processesIds;
    
    List<Note> errorNotes;
    private List<Object> calloutResults;
    List<csord__Solution__c> updatedSol;
    List<Database.SaveResult> saveResults;
    Map<Id,csord__Solution__c> currentSolutions;

    Map<id, String> solResult;
    Map<Id,List<Database.Error>> errorMap;
    
    Boolean calloutsPerformed = false;
    String transactionId='';
    
    public Boolean performCallouts(List<SObject> data) 
    {
        errorNotes   = new List<Note>();
        updatedSol   = new List<csord__Solution__c>();
        solResult    = new  Map<id, String>();
        errorMap     = new Map<Id,List<Database.Error>>();
        processesIds = new Set<Id>();
        currentSolutions = new Map<Id,csord__Solution__c>();
        
        List<CSPOFA__Orchestration_Step__c> stepList =  (List<CSPOFA__Orchestration_Step__c>)data;
        System.debug('perform: stepList='+stepList);
        
        //collect the data for all steps passed in, if needed
        for (CSPOFA__Orchestration_Step__c step : stepList) {
            processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }
        System.debug('processesIds=='+processesIds);
        
        // Get all data
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
                currentSolutions.put(process.LG_Solution__c, process.LG_Solution__r);
        }
        System.debug(' currentSolutions: ' + currentSolutions);
        
        if (!currentSolutions.isEmpty()) 
        {            
            for(csord__Solution__c cs : currentSolutions.values())
            {
                UM_PlaceOrderBackground bg = new UM_PlaceOrderBackground();
                transactionId     = bg.createOrder(cs);
                calloutsPerformed = true;
                solResult.put(cs.id, transactionId);
                System.debug('in perform call:transactionId='+ transactionId);
            }
        }   
        return calloutsPerformed;
    }
    
    public List<SObject> process(List<SObject> data) 
    {
        List<sObject> result = new List<sObject>();
        
        try
        {
            Set<Id> updatedSolId = solResult.keySet();
            List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;
            
            System.debug('proceS:stepList='+stepList);
            System.debug('process: calloutsPerformed='+calloutsPerformed);
            
            List<csord__Solution__c> updatedSolutions = [SELECT id,LG_Jeopardy__c,LG_Provisioning_External_Id__c,LG_Integration_Description__c ,
                                                         LG_Integration_Status__c,Jeopardy_Reason__c,LG_JeopardyExplanation__c,
                                                         UM_No_of_Tries__c FROM csord__solution__c WHERE id IN : updatedSolId];
            
            System.debug('updatedSolution==' + updatedSolutions);
            
            for(csord__Solution__c solution: updatedSolutions)
            {
                String transactId = solResult.get(solution.id);
                if (String.isNotBlank(transactId) && transactId.isNumeric())
                {
                    solution.LG_Integration_Status__c = 'Request Acknowledged';
                    solution.LG_Integration_Description__c = 'Success ';
                    solution.LG_Provisioning_External_Id__c = transactId;
                }
                else if(String.isNotBlank(transactId) && !transactId.isNumeric())
                {
                    solution.LG_Integration_Status__c = 'SFDC failure';
                    solution.Jeopardy_Reason__c = 'SFDC failure';
                    solution.LG_Jeopardy__c = true;
                    if(transactId.length() < 255){
                        solution.LG_Integration_Description__c = Label.LG_JiraExceptionMsg + ' ' + transactId;
                        solution.LG_JeopardyExplanation__c = solution.LG_Integration_Description__c;
                    }
                    else{
                        solution.LG_Integration_Description__c = Label.LG_JiraJeopardyError;
                        solution.LG_JeopardyExplanation__c = solution.LG_Integration_Description__c;
                        createErrorNotes(solution.id, solution.LG_Integration_Status__c, transactId);
                    }
                }
                else
                {
                    system.debug('in else loop it has exceeded no. of retries' + solution.UM_No_of_Tries__c);
                    solution.LG_Integration_Status__c      = 'Timeout';
                    solution.LG_Integration_Description__c ='Middleware Timeout';
                    solution.LG_Jeopardy__c = true;
                    solution.Jeopardy_Reason__c = 'MiddleWare Timeout';
                    solution.LG_JeopardyExplanation__c = Label.LG_Orch_Retries_Error;
                    solution.UM_No_of_Tries__c = 3;
                }
                updatedSol.add(solution);
            }
            
            if(!updatedSol.isEmpty())
            {
                saveResults = Database.update(updatedSol,false);
                for(Integer i=0; i<saveResults.size(); i++)
                {
                    if(!saveResults.get(i).isSuccess())
                    {
                        List<Database.Error> errors = saveResults.get(i).getErrors();
                        csord__solution__c solution = currentSolutions.get(updatedSol.get(i).Id);
                        createErrorNotes(solution.Id, solution.LG_ProvisioningWorkOrder__c + ' : ' + 'Error occured during record updation' , Label.LG_JiraExceptionMsg + ' ' + errors);
                    }
                }
            }
            
            if(!errorNotes.isEmpty())
            {
                saveResults = Database.insert(errorNotes,false);
                for(Database.SaveResult sr : saveResults)
                {
                    if(!sr.isSuccess())
                        System.debug('errors # ' + sr.getId() + '-->' + sr.getErrors() );
                }
            }    
            System.debug('updatedSolution==' + updatedSol);
            
            for (CSPOFA__Orchestration_Step__c step : stepList) 
            {
                step.CSPOFA__Status__c         = 'Complete';
                step.CSPOFA__Completed_Date__c = Date.today();
                result.add(step);
            }
            
            System.debug('result='+result);
        }
        catch(Exception e)
        {
            System.debug('exception in serviceprovisioning==' + e.getMessage()); 
        }
        return result;
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
}