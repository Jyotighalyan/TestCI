/**
 * check if the order is of existing CAMA MACD type
 *
 * Scan all services of given Solution, If any service has LG_ProvisioningAccountNo__c not null, Set Solution.LG_ExistingCama to Trueotherwise to False
 *
 *
 * @param  Set<Id> processesIds
 * @author Ravi Choudhary
 * @ticket SFOM-556
 * @since  25/08/2017
 */
global class LG_ScanCamaMacdOrder implements CSPOFA.ExecutionHandler {

    public List<sObject> process(List<SObject> data)
    {
        List<sObject> result = new List<sObject>();

        List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;

        Set<Id> processesIds = new Set<Id>();
        for (CSPOFA__Orchestration_Step__c step : stepList) {
            processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }

        // Call method
        scanCurrentSolution(processesIds);

        for (CSPOFA__Orchestration_Step__c step : stepList) {
            //mark step Status, Completed Date
            step.CSPOFA__Status__c         = 'Complete';
            step.CSPOFA__Completed_Date__c = Date.today();
            result.add(step);
        }

        return result;
    }

    /**
     * Once the all suborders are canceled, the process needs to notify the parent order process.
     *
     * Scan all services of given Solution, If any service has LG_ProvisioningAccountNo__c not null, Set Solution.LG_ExistingCama to True otherwise to False
     *
     * @param  Set<Id> processesIds
     * @author Petar Miletic
     * @ticket SFOM-556
     * @since  23/03/2017
     */
    @TestVisible
    private void scanCurrentSolution(Set<Id> processesIds) {

        csordtelcoa__Orders_Subscriptions_Options__c osOptions = csordtelcoa__Orders_Subscriptions_Options__c.getOrgDefaults();
        Boolean updateSol = false;
        List<csord__Solution__c> solutionsToUpdate= new List<csord__Solution__c>();
        List <Id> solutions= new List<Id>();
        List<csord__Service__c> services = new List<csord__Service__c>();
        List<Id> solutionIds = new List<Id>();

        // Get all data
        for (CSPOFA__Orchestration_Process__c process : [SELECT Id,
                                                         LG_Solution__c                                                         
                                                         FROM CSPOFA__Orchestration_Process__c
                                                         WHERE Id IN :processesIds AND LG_Solution__c != null]) {
            solutionIds.add(process.LG_Solution__c);
        }
        system.debug('current Solutions:' + solutionIds);
        
        
        // If not empty, continue
        if (!solutionIds.isEmpty()) {

            services  = [SELECT Id,LG_ProvisioningAccountNo__c, LG_Suborder__c, UM_DependsOnService__c, UM_DependsOnService__r.LG_ProvisioningAccountNo__c FROM csord__Service__c WHERE LG_Suborder__c IN :solutionIds];
            // All or partial
            for (csord__Service__c service: services) {
                if (service.LG_ProvisioningAccountNo__c != null ||(service.UM_DependsOnService__c != null && service.UM_DependsOnService__r.LG_ProvisioningAccountNo__c!=null)) {
                    updateSol = true;
                    solutions.add(service.LG_Suborder__c);
                    //break;
                }
            }
        }
        
        for (csord__Solution__c sols: [Select Id,LG_ExistingCama__c from csord__Solution__c where Id IN:solutions]) {
            if (updateSol) {
                sols.LG_ExistingCama__c = true;
            } else {
                sols.LG_ExistingCama__c = false;
            }
            solutionsToUpdate.add(sols);
        }
        
        if (!solutionsToUpdate.isEmpty()) {
            update solutionsToUpdate;
        }      
    }
}