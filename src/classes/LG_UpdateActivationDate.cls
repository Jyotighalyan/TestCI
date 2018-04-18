global class LG_UpdateActivationDate implements CSPOFA.ExecutionHandler {
    
    public List<sObject> process(List<SObject> data)
    {
        List<sObject> result = new List<sObject>();
        
        List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;
        
        Set<Id> processesIds = new Set<Id>();
        for (CSPOFA__Orchestration_Step__c step : stepList) {
            processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }
        
        // Call method
        updateFlow(processesIds);
          
          for (CSPOFA__Orchestration_Step__c step : stepList) {
            //mark step Status, Completed Date
            step.CSPOFA__Status__c         = 'Complete';
            step.CSPOFA__Completed_Date__c = Date.today();
            result.add(step);
        }
        
        return result;
    }
    
    @TestVisible
    private void updateFlow(Set<Id> processesIds) {
        
        // default setting the flow to manual 
        Map<Id,csord__Solution__c> subordersMap = new Map<Id,csord__Solution__c>();
        List<csord__service__c> servicesToUpdate  = new List<csord__service__c>();
                
        // Get all data
        for (CSPOFA__Orchestration_Process__c process : [SELECT Id,
                                                         LG_Solution__c,LG_Solution__r.id                                                         
                                                         FROM CSPOFA__Orchestration_Process__c
                                                         WHERE Id IN :processesIds AND LG_Solution__c != null]) 
        {
            if(process.LG_Solution__c != null)
                subordersMap.put(process.LG_Solution__c, process.LG_Solution__r);
        }
        system.debug('current Solutions:' + subordersMap);
        
        // If not empty, continue
        if (!subordersMap.isEmpty()) {
            
            for(csord__service__c srv: [SELECT Id,Name,LG_Suborder__c,csordtelcoa__Replaced_Service__r.csord__Activation_Date__c,csord__Status__c,LG_ServiceStatus__c FROM csord__Service__c 
                                        WHERE LG_Suborder__c IN :subordersMap.keySet()])
            {
                if(srv.csordtelcoa__Replaced_Service__c !=null && srv.csordtelcoa__Replaced_Service__r.csord__Activation_Date__c!=null)
                    srv.csord__Activation_Date__c=srv.csordtelcoa__Replaced_Service__r.csord__Activation_Date__c;
                    srv.csord__Status__c='Activation Completed';
                    srv.LG_ServiceStatus__c='Activation Completed';
                    servicesToUpdate .add(srv);
            }
            
        }
        if(!servicesToUpdate .isEmpty())
        update servicesToUpdate ;
        
    }
}