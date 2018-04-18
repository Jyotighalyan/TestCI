/**
* This class is to check if HPBX servcies are Cancellable daily or Monthly
* 
* @author Alisha
* @ticket SFOM-2566
* @since  21/2/2018
*/
global class LG_ServiceCancellableTypeStep implements CSPOFA.ExecutionHandler{    

    public  List<sObject> process(List<SObject> data) {
       List<sObject> result = new List<sObject>();
       
        //collect the data for all steps passed in, if needed process steps
        List<CSPOFA__Orchestration_Step__c> stepList =  (List<CSPOFA__Orchestration_Step__c>)data;
    
        Set<Id> processesIds = new Set<Id>();
        for (CSPOFA__Orchestration_Step__c step : stepList) {
          processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }

    updateCancellableType(processesIds);

    for (CSPOFA__Orchestration_Step__c step : stepList) {
      step.CSPOFA__Status__c         = 'Complete';
      step.CSPOFA__Completed_Date__c = Date.today();
      result.add(step);
    }

    return result;
    }
    
    /**
   * Scans the Service records related to the processes/solutions
   * being executed/processed and check if HPBX servcies are Cancellable daily or Monthly or Both
   * @param  Set<Id> processesIds
   * @author Alisha
   * @ticket SFOM-2566
   * @since  21/2/2018
   */
  
  @TestVisible
  public void updateCancellableType(Set<Id> processesIds){
        List<csord__Service__c> servicesToUpdate = new List<csord__Service__c>();
        list<csord__Solution__c> solutionListToUpdate = new list<csord__Solution__c>();
        list<csord__Solution__c> solutionList = new list<csord__Solution__c>();
       	Set<String> setOfService=new Set<String>();
       	String Daily='';
       	String Monthly='';
        solutionList = [SELECT Id,LG_type_Of_Services__c,
                      (SELECT Id,csord__Status__c,csord__Activation_Date__c,UM_Cancellation__c,LG_DecompositionCriteria__c FROM Services__r
                      )
                      FROM csord__Solution__c
                      WHERE Id IN (SELECT LG_Solution__c
                             FROM CSPOFA__Orchestration_Process__c
                             WHERE Id IN :processesIds)];                      
   if(solutionList.size()>0)
        {
          for (csord__Solution__c sol : solutionList )
          {
            if (sol.Services__r.size() > 0)
            {
                for (csord__Service__c service : sol.Services__r)
                {
                    if(service.LG_DecompositionCriteria__c!=null){
                        setOfService.add(service.LG_DecompositionCriteria__c);
                    }
                    if(service.UM_Cancellation__c!=null && service.UM_Cancellation__c=='Daily'){
                       Daily='Daily';
                      
                    }      
                    else if(service.UM_Cancellation__c!=null && service.UM_Cancellation__c=='Monthly'){
                       Monthly='Monthly';
                    }
                }
            }
                for(String s:setOfService)
                 {
                     if(sol.LG_type_Of_Services__c==null){
                     	sol.LG_type_Of_Services__c ='['+s+']'+',';
                     }
                     else{
                         sol.LG_type_Of_Services__c +='['+s+']'+',';
                     }
                 }
                if(!String.isBlank(daily))
                {
                     	sol.LG_type_Of_Services__c+=daily+',';   
                }
                if(!String.isBlank(Monthly))
                {
                     sol.LG_type_Of_Services__c+=Monthly+',';   
                }
                sol.LG_type_Of_Services__c=sol.LG_type_Of_Services__c.removeEnd(',');
                solutionListToUpdate.add(sol);
            }
        }
    if (solutionListToUpdate.size() > 0) {
            Update solutionListToUpdate;
        }
    }
    
}