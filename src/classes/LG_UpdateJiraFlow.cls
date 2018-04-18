/**
* 
* Update Jira flow manual/Automated on the suborder for company fibre product
*
*
* @param  Set<Id> processesIds
* @author Ravi Choudhary
* @ticket SFOM-556
* @since  03/01/2018
*/
global class LG_UpdateJiraFlow implements CSPOFA.ExecutionHandler {
    
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
    
    /**
* 
* Scan all services of given Solution, update the jira flow field on solution based on below condition
* CF + BGP -> Auto
* CF + IA -> Auto
* CF + more than 1 service -> Manual
* CF + CCF -> Manual
*
* @param  Set<Id> processesIds
* @author RC
* @ticket SFOM-2220
* @since  03/01/2018
*/
    @TestVisible
    private void updateFlow(Set<Id> processesIds) {
        
        // default setting the flow to manual 
        Map<Id,csord__Solution__c> subordersMap = new Map<Id,csord__Solution__c>();
        Map<Id, List<csord__service__c>> solServiceMap = new Map<Id, List<csord__service__c>>();
        Boolean isWlan = false;
        
        // Get all data
        for (CSPOFA__Orchestration_Process__c process : [SELECT Id,
                                                         LG_Solution__c,LG_Solution__r.Jira_Flow__c, LG_Solution__r.id                                                         
                                                         FROM CSPOFA__Orchestration_Process__c
                                                         WHERE Id IN :processesIds AND LG_Solution__c != null]) 
        {
            if(process.LG_Solution__c != null)
                subordersMap.put(process.LG_Solution__c, process.LG_Solution__r);
        }
        system.debug('current Solutions:' + subordersMap);
        
        // If not empty, continue
        if (!subordersMap.isEmpty()) {
            
            for(csord__service__c srv: [SELECT Id,Name,UM_ProductDescription__c,csord__Service__c,LG_Suborder__c  FROM csord__Service__c WHERE LG_Suborder__c IN :subordersMap.keySet()])
            {
                if(!solServiceMap.containsKey(srv.LG_Suborder__c))
                    solServiceMap.put(srv.LG_Suborder__c, new List<csord__service__c>{srv});
                else
                    solServiceMap.get(srv.LG_Suborder__c).add(srv);
                
                if(srv.name.containsIgnoreCase('WLAN'))
                    isWLAN = true;                    
            }
            
            for(Id solId : solServiceMap.keySet())
            {
                if(solServiceMap.get(solId).size() > 1 && !isWLAN)
                    subordersMap.get(solId).Jira_Flow__c = 'Manual';
                else
                    subordersMap.get(solId).Jira_Flow__c = 'Automated';
            }
            
            update subordersMap.values();      
        }
    }
}