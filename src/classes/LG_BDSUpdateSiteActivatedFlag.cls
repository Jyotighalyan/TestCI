global class LG_BDSUpdateSiteActivatedFlag implements CSPOFA.ExecutionHandler {
    
    public List<sObject> process(List<SObject> data)
    {
        List<sObject> result = new List<sObject>();

        List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;

        Set<Id> processesIds = new Set<Id>();
        for (CSPOFA__Orchestration_Step__c step : stepList) {
            processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }

        updateSiteActivatedFlag(processesIds);

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
   * being executed/processed and updates the flag
   * 
   * 
   *
   * @param  Set<Id> processesIds
   * @author Anthony Arockiam
   * @ticket SFOM-2455
   * @since  08/01/2017
   */
	@TestVisible
    public void updateSiteActivatedFlag(Set<Id> processesIds)
    {
    	List<csord__solution__c> solutionsToUpdate = new List<csord__solution__c>();
    	Set<String> bdsSiteIds = new Set<String>();
    	Map<String, csord__service__c> bdsSiteRecordMap = new Map<String, csord__service__c>();
    	List<csord__solution__c> solutionRecords = 
    	[
    		SELECT Id, csord__Order__c, 
    			(SELECT Id FROM Solutions__r), 
    			(SELECT Id, csord__Status__c, LG_ServiceStatus__c, LG_From_Service__c, LG_To_Service__c, Persistent_Id__c FROM Services__r) 
    		FROM csord__Solution__c
            WHERE Id IN (SELECT LG_Solution__c FROM CSPOFA__Orchestration_Process__c WHERE Id IN :processesIds)
        ];
        
        //Collect BDS site Ids
        for(csord__solution__c sol : solutionRecords){
        	for(csord__service__c serv : sol.Services__r){
        		if(serv.LG_To_Service__c != null){
        			bdsSiteIds.add(serv.LG_To_Service__c);
        		}
        	}
        }
        
        //Retrive BDS site records
        for(csord__service__c serv : 
        [
        	SELECT Id, csord__Status__c, LG_ServiceStatus__c, Persistent_Id__c, csord__Activation_Date__c, csord__Deactivation_Date__c
        	FROM csord__service__c
        	WHERE Persistent_Id__c IN: bdsSiteIds
        ]){
        	bdsSiteRecordMap.put(serv.Persistent_Id__c, serv);
        }
        
        //Check the condition to update the Site update flag
        for(csord__solution__c sol : solutionRecords){
        	Integer totalSiteCount = 0;
        	Integer sitesActiveStatusesCount = 0;
        	Integer sitesInActiveStatusesCount = 0;
        	for(csord__service__c serv : sol.Services__r){
        		if(bdsSiteRecordMap.get(serv.LG_To_Service__c) != null){
        			csord__service__c bdsService = bdsSiteRecordMap.get(serv.LG_To_Service__c);
        			totalSiteCount++;
        			if((bdsService.LG_ServiceStatus__c =='Active' || bdsService.LG_ServiceStatus__c =='Ready for Billing' || bdsService.LG_ServiceStatus__c =='Activation Completed') 
        				&& (bdsService.csord__Activation_Date__c != null && bdsService.csord__Deactivation_Date__c == null)){
        				sitesActiveStatusesCount++;
        			}
        			if((bdsService.LG_ServiceStatus__c =='Inactive' || bdsService.LG_ServiceStatus__c =='Ready for Billing' || bdsService.LG_ServiceStatus__c =='Activation Completed') 
        				&& bdsService.csord__Deactivation_Date__c != null ){
        				sitesInActiveStatusesCount++; 
        			}
        		}
        	}
        	if((totalSiteCount == 1 && sitesActiveStatusesCount == 1) || (totalSiteCount > 1 && sitesActiveStatusesCount > 1) || (sitesInActiveStatusesCount >= 1)){
        		sol.LG_Activated_New_Site__c = 'True';
        		solutionsToUpdate.add(sol);
        	} else {
            	sol.LG_Activated_New_Site__c = 'False';
            	solutionsToUpdate.add(sol);
          	}
        }
        
        update solutionsToUpdate;
    }
    	
}