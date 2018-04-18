/**
 * Check the status of depends On service OR secondaryDependsOnService and accordingly
 * update the field on solution object
 * 
 * @param  Set<Id> processesIds
 * @author Ravi Choudhary
 * @ticket OMB-1567
 * @since  18/01/2018
 */
global class LG_checkDependsOnServiceStatus implements CSPOFA.ExecutionHandler {

    public List<sObject> process(List<SObject> data)
    {
        List<sObject> result = new List<sObject>();

        List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;

        Set<Id> processesIds = new Set<Id>();
        for (CSPOFA__Orchestration_Step__c step : stepList) {
            processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }

        // Call method
        scanDependsOnService(processesIds);

        for (CSPOFA__Orchestration_Step__c step : stepList) {
            //mark step Status, Completed Date
            step.CSPOFA__Status__c         = 'Complete';
            step.CSPOFA__Completed_Date__c = Date.today();
            result.add(step);
        }

        return result;
    }

    /**
     * Check the status of solution of DependsOnService or secondaryDependsOnService and accordingly
     * update the field(LG_AccessAvailable__c) on solution object
     *
     * @param  Set<Id> processesIds
     * @author Ravi Choudhary
     * @ticket OMB-1567
     * @since  18/01/2018
     * 
     * modified: 2-3-2017
     * @ticket SFOM-2753
     * @modification: Modified the code to handle child Services along with the existing Primary & Secondary dependent Services
     */
    @TestVisible
    private void scanDependsOnService(Set<Id> processesIds) {
       
        Boolean updateSol = false;
        List<csord__Solution__c> solutionsToUpdate= new List<csord__Solution__c>();
        List<csord__Solution__c> secondarySolutionsToUpdate= new List<csord__Solution__c>();
        List<csord__Solution__c> parentSolutionsToUpdate= new List<csord__Solution__c>();
        List<Id> dependsOnSolutions= new List<Id>();
        List<Id> secondaryDependsOnSolutions= new List<Id>();
        List<Id> parentSolutions= new List<Id>();
        List<Id> solutionIds = new List<Id>();
        Set<String> serviceStatus = new Set<String>{'Activation Completed', 'Ready for Billing', 'Active'}; 

        // Get all data
        for (CSPOFA__Orchestration_Process__c process : [SELECT Id,
                                                         LG_Solution__c                                                         
                                                         FROM CSPOFA__Orchestration_Process__c
                                                         WHERE Id IN :processesIds AND LG_Solution__c != null]) {
            solutionIds.add(process.LG_Solution__c);
        }
        system.debug('current Solutions:' + solutionIds);
        
        
        if (!solutionIds.isEmpty()) {
            for (csord__Service__c services : [SELECT Id, Name, LG_Suborder__c, UM_DependsOnService__c, UM_DependsOnService__r.LG_ServiceStatus__c, UM_DependsOnService__r.LG_ProvisioningAccountNo__c,
                                                 LG_DependsOnSecondaryService__c, LG_DependsOnSecondaryService__r.LG_ServiceStatus__c, LG_DependsOnSecondaryService__r.LG_ProvisioningAccountNo__c,LG_Action__c,
                                                 csordtelcoa__Replaced_Service__r.LG_DependsOnSecondaryService__c,
                                                 csordtelcoa__Replaced_Service__r.LG_Suborder__c, csord__Service__c, csord__Service__r.LG_ServiceStatus__c, csord__Service__r.LG_ProvisioningAccountNo__c from csord__Service__c
                                                 WHERE LG_Suborder__c IN :solutionIds AND (UM_DependsOnService__c != null OR LG_DependsOnSecondaryService__c != null OR (csord__Service__c != null AND LG_ProductDefinitionName__c != 'Hardware'))]){
               
                if (services.UM_DependsOnService__c != null && (serviceStatus.contains(services.UM_DependsOnService__r.LG_ServiceStatus__c) || services.UM_DependsOnService__r.LG_ProvisioningAccountNo__c != null )) {
                    system.debug('service has UM_DependsOnService__c:' +services.UM_DependsOnService__c);
                    dependsOnSolutions.add(services.LG_Suborder__c);
                }
                
                if (services.LG_DependsOnSecondaryService__c != null && (serviceStatus.contains(services.LG_DependsOnSecondaryService__r.LG_ServiceStatus__c) || services.LG_DependsOnSecondaryService__r.LG_ProvisioningAccountNo__c != null)) {
                    system.debug('service has LG_DependsOnSecondaryService__c:' + services.LG_DependsOnSecondaryService__c);
                    secondaryDependsOnSolutions.add(services.LG_Suborder__c);
                }
                
                //SFOM-2753
                if (services.csord__Service__c != null && (serviceStatus.contains(services.csord__Service__r.LG_ServiceStatus__c) || services.csord__Service__r.LG_ProvisioningAccountNo__c != null)) {
                    system.debug('service has Parent Service :' + services.csord__Service__c);
                    parentSolutions.add(services.LG_Suborder__c);
                }
                   
               }
            }
        
         
        if (!dependsOnSolutions.isEmpty()) {
            
            system.debug('inside dependsOnSolutions:' + dependsOnSolutions);
            for (csord__Solution__c sols: [Select Id,LG_AccessAvailable__c from csord__Solution__c where Id IN:dependsOnSolutions]) {
            sols.LG_AccessAvailable__c = true;
            solutionsToUpdate.add(sols);
             }
        }
        
        if (!secondaryDependsOnSolutions.isEmpty()) {
            system.debug('inside secondaryDependsOnSolutions:' + secondaryDependsOnSolutions);
            for (csord__Solution__c sols: [Select Id,LG_SecondaryAccessAvailable__c from csord__Solution__c where Id IN:secondaryDependsOnSolutions]) {
            sols.LG_SecondaryAccessAvailable__c = true;
            secondarySolutionsToUpdate.add(sols);
             }
        }
        
        //SFOM-2753
        if(!parentSolutions.isEmpty()){
            system.debug('inside parentSolutions:' + parentSolutions);
            for (csord__Solution__c sols: [Select Id,LG_SecondaryAccessAvailable__c from csord__Solution__c where Id IN:parentSolutions]) {
                sols.LG_AccessAvailable__c = true;
                parentSolutionsToUpdate.add(sols);
            }
        }
        
    
        system.debug('solutionsToUpdate:' + solutionsToUpdate);
        system.debug('secondarySolutionsToUpdate:' + secondarySolutionsToUpdate);
        system.debug('parentSolutionsToUpdate:' + parentSolutionsToUpdate);
        
        if (!solutionsToUpdate.isEmpty()) {
            update solutionsToUpdate;
        }  
        
        if (!secondarySolutionsToUpdate.isEmpty()) {
            update secondarySolutionsToUpdate;
        }  
         
        //SFOM-2753
        if (!parentSolutionsToUpdate.isEmpty()) {
            update parentSolutionsToUpdate;
        }
         
    }
}