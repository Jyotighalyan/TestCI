/**
 * Check the status of dependent service or secondary service and accordingly
 * update the field on solution object
 * 
 * @param  Set<Id> processesIds
 * @author Ravi Choudhary
 * @ticket OMB-1567
 * @since  08/01/2018
 */
global class LG_checkDependentServiceStatus implements CSPOFA.ExecutionHandler {

    public List<sObject> process(List<SObject> data)
    {
        List<sObject> result = new List<sObject>();

        List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;

        Set<Id> processesIds = new Set<Id>();
        for (CSPOFA__Orchestration_Step__c step : stepList) {
            processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }

        // Call method
        scanDependentServices(processesIds);

        for (CSPOFA__Orchestration_Step__c step : stepList) {
            //mark step Status, Completed Date
            step.CSPOFA__Status__c         = 'Complete';
            step.CSPOFA__Completed_Date__c = Date.today();
            result.add(step);
        }

        return result;
    }

    /**
     * Check the status of solution of dependent services or secondary dependent service and accordingly
     * update the field(LG_AccessAvailable__c) or (LG_SecondaryAccessAvailable__c) on solution object
     *
     * @param  Set<Id> processesIds
     * @author Ravi Choudhary
     * @ticket OMB-1567
     * @since  08/01/2018
     */
    @TestVisible
    private void scanDependentServices(Set<Id> processesIds) {
       
        Boolean updateSol = false;
        List<csord__Solution__c> solutionsToUpdate= new List<csord__Solution__c>();
        List<csord__Solution__c> secondarySolutionsToUpdate= new List<csord__Solution__c>();
        List<csord__Solution__c> childSolutionsToUpdate= new List<csord__Solution__c>();
        List <Id> dependentSolutions= new List<Id>();
        List<csord__Service__c> dependentOrSecondaryDependentServices = new List<csord__Service__c>();
        List <Id> secondaryDependentSolutions= new List<Id>();
        List <Id> childSolutions= new List<Id>();
        List<Id> serviceIds = new List<Id>();
        List<Id> solutionIds = new List<Id>();
        List<Id> addresses = new List<Id>();

        // Get all data
        for (CSPOFA__Orchestration_Process__c process : [SELECT Id,
                                                         LG_Solution__c                                                         
                                                         FROM CSPOFA__Orchestration_Process__c
                                                         WHERE Id IN :processesIds AND LG_Solution__c != null]) {
            solutionIds.add(process.LG_Solution__c);
        }
        system.debug('current Solutions:' + solutionIds);
        
        
        if (!solutionIds.isEmpty()) {
            for (csord__Service__c services : [SELECT Id, Name, LG_Address__c from csord__Service__c WHERE LG_Suborder__c IN :solutionIds]){
                serviceIds.add(services.Id);
                addresses.add(services.LG_Address__c);
            }
        }
        System.debug('all Services' + serviceIds);
        dependentOrSecondaryDependentServices = [Select Id, LG_Suborder__c, LG_Suborder__r.csord__Status__c, UM_DependsOnService__c, LG_DependsOnSecondaryService__c, csord__Service__c from csord__Service__c where UM_DependsOnService__c IN :serviceIds OR LG_DependsOnSecondaryService__c IN :serviceIds OR csord__Service__c IN :serviceIds];
        System.debug('filtered dependent or secondary dependent Services' + dependentOrSecondaryDependentServices);//DGT-381 & SFOM-2766 @author-navneet_sanotra Added changes for considering SecondaryDependentServices too
    	
    	if (!dependentOrSecondaryDependentServices.isEmpty()) {
    		
	    	for (csord__Service__c dependentorSecondaryDepService:dependentOrSecondaryDependentServices) {
	                
        	for (ID service: serviceIds) {
	                		
		                		if ((service == dependentorSecondaryDepService.UM_DependsOnService__c) && dependentorSecondaryDepService.LG_Suborder__r.csord__Status__c == 'In Progress') {
		            			System.debug('filtered dependent Services' + dependentorSecondaryDepService);
		               			dependentSolutions.add(dependentorSecondaryDepService.LG_Suborder__c);
		            			}
		            
					            if ((service == dependentorSecondaryDepService.LG_DependsOnSecondaryService__c) && dependentorSecondaryDepService.LG_Suborder__r.csord__Status__c == 'In Progress') {
					            	System.debug('filtered secondary dependent Services' + dependentorSecondaryDepService);
					                secondaryDependentSolutions.add(dependentorSecondaryDepService.LG_Suborder__c);
					            }
	                		
                                //SFOM-2753
                                if ((service == dependentorSecondaryDepService.csord__Service__c) && dependentorSecondaryDepService.LG_Suborder__r.csord__Status__c == 'In Progress') {
                                    System.debug('filtered Parent Services' + dependentorSecondaryDepService);
                                    childSolutions.add(dependentorSecondaryDepService.LG_Suborder__c);
                                }
                            
	                	}
	            
	        }
    		
   		}
        
        system.debug('dependentSolutions to check' + dependentSolutions);
        system.debug('secondaryDependentSolutions to check' + secondaryDependentSolutions);
        
        
        	for (csord__Solution__c sols: [Select Id,LG_AccessAvailable__c,LG_Address__c from csord__Solution__c where Id IN:dependentSolutions OR LG_Address__c IN:addresses]) {
            sols.LG_AccessAvailable__c = True;
            system.debug('--sols' + sols);
            solutionsToUpdate.add(sols);
        	}
        	
       
       if (!secondaryDependentSolutions.isEmpty()) {
       	for (csord__Solution__c sols: [Select Id,LG_SecondaryAccessAvailable__c from csord__Solution__c where Id IN:secondaryDependentSolutions]) {
            sols.LG_SecondaryAccessAvailable__c = True;
            secondarySolutionsToUpdate.add(sols);
        }
        
       }
       
       //SFOM-2753
       if (!childSolutions.isEmpty()) {
        for (csord__Solution__c sols: [Select Id,LG_AccessAvailable__c from csord__Solution__c where Id IN:childSolutions]) {
            sols.LG_AccessAvailable__c = True;
            childSolutionsToUpdate.add(sols);
        }
       	
       }
       
       
        system.debug('solutionsToUpdate:' + solutionsToUpdate);
        if (!solutionsToUpdate.isEmpty()) {
            update solutionsToUpdate;
        } 
       
        
        system.debug('secondarySolutionsToUpdate:' + secondarySolutionsToUpdate);
        if (!secondarySolutionsToUpdate.isEmpty()) {
            update secondarySolutionsToUpdate;
        }
        
        //SFOM-2753
        system.debug('childSolutionsToUpdate:' + childSolutionsToUpdate);
        if (!childSolutionsToUpdate.isEmpty()) {
            update childSolutionsToUpdate;
        }
    }
}