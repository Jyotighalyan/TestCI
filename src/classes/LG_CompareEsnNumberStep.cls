global class LG_CompareEsnNumberStep implements CSPOFA.ExecutionHandler {
    
    public List<sObject> process(List<SObject> data)
    {
        List<sObject> result = new List<sObject>();

        List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;

        Set<Id> processesIds = new Set<Id>();
        for (CSPOFA__Orchestration_Step__c step : stepList) {
            processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }

        // Call method
        compareEsnNumber(processesIds);

        for (CSPOFA__Orchestration_Step__c step : stepList) {
            //mark step Status, Completed Date
            step.CSPOFA__Status__c         = 'Complete';
            step.CSPOFA__Completed_Date__c = Date.today();
            result.add(step);
        }

        return result;
    }
    
    
    /**
   * Scans the Service records related to the processes/solutions
   * being executed/processed and will compare the ESN number 
   *on BDS Site service under the current suborder 
   *   * @param  Set<Id> processesIds
   * @author Alisha
   * @ticket SFOM-2370
   * @since  17/12/2017
   */
    @TestVisible
  private void compareEsnNumber(Set<Id> processesIds)
  {
    List<csord__Solution__c> solutionsToUpdate = new List<csord__Solution__c>();
    List<csord__Service__c> serviceList = new List<csord__Service__c>();
    
    try{

    List<csord__Solution__c> solutionList = [SELECT Id, csord__Order__c,LG_OldESNNumber__c , (SELECT Id, LG_ServiceStatus__c, csord__Service__c, LG_Suborder__c, csord__Order__c, csordtelcoa__Replaced_Service__r.UM_ESN__c, csordtelcoa__Replaced_Service__c,UM_ESN__c  FROM Services__r WHERE csordtelcoa__Replaced_Service__c  != null)
                      FROM csord__Solution__c 
                      WHERE Id IN (SELECT LG_Solution__c FROM CSPOFA__Orchestration_Process__c WHERE Id IN :processesIds)];
       
   
     for(csord__Solution__c solution:solutionList){
                          if (!solution.Services__r.isEmpty()) {
                                for ( csord__Service__c s:solution.Services__r){
                                 if(!s.UM_ESN__c.equals(s.csordtelcoa__Replaced_Service__r.UM_ESN__c)){
                                 solution.LG_OldESNNumber__c  = s.csordtelcoa__Replaced_Service__r.UM_ESN__c;
                                }
                            }
                        solutionsToUpdate.add(solution);

                        }
                        else{
                                System.debug('DEBUG : ERROR : esn no is same');
                        }
                    
             }
             
            
          
    if (!solutionsToUpdate.isEmpty()) {
      update solutionsToUpdate;
    }
    }catch(Exception e){
        System.debug('DEBUG : ERROR : '+ e.getMessage());
    }
  }
  
 }