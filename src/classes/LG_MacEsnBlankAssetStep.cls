global class LG_MacEsnBlankAssetStep implements CSPOFA.ExecutionHandler {
    public List<sObject> process(List<SObject> data)
    {
        List<sObject> result = new List<sObject>();

        List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;

        Set<Id> processesIds = new Set<Id>();
        for (CSPOFA__Orchestration_Step__c step : stepList) {
            processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }
     system.debug('stepList=='+stepList);
        // Call method
        MacEsnNumberBlank(processesIds);
     system.debug('after compare=='+stepList);

        for (CSPOFA__Orchestration_Step__c step : stepList) {
            //mark step Status, Completed Date
            step.CSPOFA__Status__c         = 'Complete';
            step.CSPOFA__Completed_Date__c = Date.today();
            result.add(step);
        }
             system.debug('result=='+result);

        //update result;
        return result;
    }
   /**
   * Scans the Service records related to the processes/solutions
   * being executed/processed and will making MAC Address is Blank
   *on BDS Site service for Asset object
   *   * @param  Set<Id> processesIds
   * @author Raju 
   * @ticket SFOM-2789
   * @since  12/03/2017
   */
    @TestVisible
    private void MacEsnNumberBlank(Set<Id> processesIds){
        List<csord__Service__c> serviceList = new List<csord__Service__c>();
        List<csord__Solution__c> solutionList;
        try{
            solutionList = [SELECT Id,name, csord__Order__c,LG_OldESNNumber__c , (SELECT Id, LG_ServiceStatus__c, csord__Service__c, LG_Suborder__c, csord__Order__c, 
                                                                                  csordtelcoa__Replaced_Service__r.UM_ESN__c, csordtelcoa__Replaced_Service__c,UM_ESN__c  
                                                                        		FROM Services__r WHERE csordtelcoa__Replaced_Service__c  != null 
                                                                                and csord__Service__r.LG_RootOrder__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c != 'New' 
                                                                                and LG_IsExistingHardware__c != true)
                      FROM csord__Solution__c
                      WHERE Id IN (SELECT LG_Solution__c FROM CSPOFA__Orchestration_Process__c WHERE Id IN :processesIds)];
            system.debug('solutionList =='+solutionList+'=============sdgsg=='+solutionList[0].Services__r);
            Integer i=0;
            for(csord__Solution__c solution:solutionList){
                i++;
                         System.debug('i=='+i+'sfsd='+solution.Services__r);
                if (!solution.Services__r.isEmpty()){
                    for ( csord__Service__c s:solution.Services__r){
                        System.debug(': : no of Solutions'+i);                                  
                        Asset Asst;
                        Asst = [SELECT LG_MACAddress__c FROM Asset where csord__Service__c = : s.Id];    
                        Asst.LG_MACAddress__c='';
                        update Asst;
                        System.debug(': : no of Solutions Updated'+i);
                    }
                }
            }
        }catch(Exception e){
        System.debug('DEBUG : ERROR : '+ e.getMessage());
        }
    }
}