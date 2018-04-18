/**
 * Check if secondary dependent service exists and accordingly
 * update the field on solution object
 * 
 * @param  Set<Id> processesIds
 * @author Navneet Sanotra
 * @ticket SFOM-2766
 * @since  12/03/2018
 */
global class LG_checkSecondaryDependentService implements CSPOFA.ExecutionHandler {

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
     * Check if secondary dependent service exists for the solution and accordingly
     * update the field(LG_DependsOnSecondary__c) on solution object
     *
     * @param  Set<Id> processesIds
     * @author Navneet Sanotra
     * @ticket SFOM-2766
     * @since  12/03/2018
     */
    @TestVisible
    private void scanDependentServices(Set<Id> processesIds) {
       
        Boolean updateSol = false;
        List<csord__Solution__c> solutionsToUpdate= new List<csord__Solution__c>();
        List<csord__Solution__c> secondarySolutionsToUpdate= new List<csord__Solution__c>();
        List <Id> secondaryDependentSolutions= new List<Id>();
        List<csord__Service__c> secondaryDependentServices = new List<csord__Service__c>();
    
        List<Id> solutionIds = new List<Id>();
        List<Id> serviceIds = new List<Id>();
        List<csord__Service__c> linebackupServiceList= new List<csord__Service__c>();
        List<csord__Service__c> changedServicesList= new List<csord__Service__c>();

        // Get all data
        for (CSPOFA__Orchestration_Process__c process : [SELECT Id,
                                                         LG_Solution__c                                                         
                                                         FROM CSPOFA__Orchestration_Process__c
                                                         WHERE Id IN :processesIds AND LG_Solution__c != null]) {
            solutionIds.add(process.LG_Solution__c);
        }
        system.debug('current Solutions:' + solutionIds);
        
        
        if (!solutionIds.isEmpty()) {
            for (csord__Service__c services : [SELECT Id, Name  from csord__Service__c WHERE LG_Suborder__c IN :solutionIds]){
                serviceIds.add(services.Id);
            }
        }

        System.debug('all Services' + serviceIds);
        secondaryDependentServices = [Select Id, LG_Suborder__c, LG_Suborder__r.csord__Status__c from csord__Service__c where ID IN :serviceIds AND LG_DependsOnSecondaryService__c != null];
        System.debug('filtered Services' + secondaryDependentServices);
        for (csord__Service__c secondaryDependentService:secondaryDependentServices) {
            if (secondaryDependentService.LG_Suborder__r.csord__Status__c == 'In Progress') {
                secondaryDependentSolutions.add(secondaryDependentService.LG_Suborder__c);
            }
        }
        system.debug('secondaryDependentSolutions to check' + secondaryDependentSolutions);
        for (csord__Solution__c sols: [Select Id,LG_dependsOnSecondary__c from csord__Solution__c where Id IN:secondaryDependentSolutions]) {
            sols.LG_DependsOnSecondary__c = True;
            solutionsToUpdate.add(sols);
        }
                   //as part of DGT-118 starts
               
          if (!solutionIds.isEmpty()) {
            for (csord__Service__c services : [SELECT Id, Name, LG_Suborder__c, UM_DependsOnService__c, UM_DependsOnService__r.LG_ServiceStatus__c, UM_DependsOnService__r.LG_ProvisioningAccountNo__c,
                                                 LG_DependsOnSecondaryService__c, LG_DependsOnSecondaryService__r.LG_ServiceStatus__c, LG_DependsOnSecondaryService__r.LG_ProvisioningAccountNo__c,LG_Action__c,
                                                 csordtelcoa__Replaced_Service__r.LG_DependsOnSecondaryService__c,
                                                 csordtelcoa__Replaced_Service__r.LG_Suborder__c from csord__Service__c
                                                 WHERE LG_Suborder__c IN :solutionIds AND (UM_DependsOnService__c != null OR LG_DependsOnSecondaryService__c != null)]){
        
        
            if(services.LG_Action__c=='Change' && services.csordtelcoa__Replaced_Service__r.LG_DependsOnSecondaryService__c!=null && services.LG_DependsOnSecondaryService__c==null){
                
                system.debug('services='+services.name+' id:'+services.id);
                changedServicesList.add(services.csordtelcoa__Replaced_Service__r);
                }  
               }
            }
            if(!changedServicesList.isEmpty()){
                           system.debug('changedServicesList'+changedServicesList);

            for(csord__Service__c s:[select id, name,LG_Suborder__c,csordtelcoa__Replacement_Service__r.LG_Suborder__c,csord__service__r.csordtelcoa__Replacement_Service__r.LG_Suborder__c from csord__Service__c where csord__Service__c in :changedServicesList]){
             
                if(s.name=='Line Backup Service'){     
                        system.debug('assiging old line backup under new suborder=='+s.csord__service__r.csordtelcoa__Replacement_Service__r.LG_Suborder__c);
                        s.LG_Suborder__c=s.csord__service__r.csordtelcoa__Replacement_Service__r.LG_Suborder__c;
                        linebackupServiceList.add(s);
                    }
                 }
            }           //as part of DGT-118 ends
            
               //as part of DGT-118 starts
         
        if (!linebackupServiceList.isEmpty()) {
            system.debug('linebackupServiceList:' + linebackupServiceList);
            update linebackupServiceList;
        }  
          //as part of DGT-118 ends
         
        
        system.debug('solutionsToUpdate:' + solutionsToUpdate);
        system.debug('secondarySolutionsToUpdate:' + secondarySolutionsToUpdate);
        if (!solutionsToUpdate.isEmpty()) {
            update solutionsToUpdate;
        }      
       
    }
}