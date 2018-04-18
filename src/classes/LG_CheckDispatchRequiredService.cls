/**
 * Check Access Type of the dependent service, change type of opportunity, isExistingHardWare field = false  and accordingly
 * update the field on solution object
 * 
 * @param  Set<Id> processesIds
 * @author Navneet Sanotra
 * @ticket SFOM-2765
 * @since  06/03/2018
 */
global class LG_CheckDispatchRequiredService implements CSPOFA.ExecutionHandler {

    public List<sObject> process(List<SObject> data)
    {
        List<sObject> result = new List<sObject>();

        List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;

        Set<Id> processesIds = new Set<Id>();
        for (CSPOFA__Orchestration_Step__c step : stepList) {
            processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }

        // Call method
        checkDependentServiceType(processesIds);

        for (CSPOFA__Orchestration_Step__c step : stepList) {
            //mark step Status, Completed Date
            step.CSPOFA__Status__c         = 'Complete';
            step.CSPOFA__Completed_Date__c = Date.today();
            result.add(step);
        }

        return result;
    }

    /**
     * Check the Access type of dependent service and accordingly
     * update the field(LG_LogisticsDispatchNeeded__c) on solution object
     *
     * @param  Set<Id> processesIds
     * @author Navneet Sanotra
     * @ticket SFOM-2765
     * @since  06/03/2018
     */
    @TestVisible
    private void checkDependentServiceType(Set<Id> processesIds) {
       
        Boolean updateSol = false;
        List<csord__Solution__c> solutionsToUpdate= new List<csord__Solution__c>();
        List <Id> solutionList= new List<Id>();
        List<csord__Service__c> services = new List<csord__Service__c>();
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
        system.debug('Solutions to be evaluated:' + solutionIds);
        
        if (!solutionIds.isEmpty()) {
            for (csord__Service__c service : [SELECT Id, Name from csord__Service__c WHERE LG_Suborder__c IN :solutionIds]){
                serviceIds.add(service.Id);
            }
        }
        System.debug('all Services' + serviceIds);
        services = [Select Id, LG_Suborder__c,UM_DependsOnService__r.csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c, LG_IsExistingHardware__c, LG_Suborder__r.csord__Status__c,UM_DependsOnService__c,UM_DependsOnService__r.LG_Primary_Check__c,UM_DependsOnService__r.LG_Primary_Access_Type__c,
        			LG_RootOrder__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c from csord__Service__c
        			where ID IN :serviceIds AND csord__Service__c = null];
        System.debug('Services having dependent service' +services);
        
         for (csord__Service__c service:services) {
            if (service.LG_Suborder__r.csord__Status__c == 'In Progress' && service.UM_DependsOnService__c != null) {
                System.debug('dependent service ID' +service.UM_DependsOnService__c);
	                  if ((service.LG_IsExistingHardware__c == false)
	                      && (((service.UM_DependsOnService__r.LG_Primary_Access_Type__c == 'Offnet' || service.UM_DependsOnService__r.csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c.equals(Label.CCC_Offnet)) 
	                      || service.UM_DependsOnService__r.csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c.equals(Label.Company_Cloud_Connect))
	                      || (service.LG_RootOrder__r.csordtelcoa__Opportunity__r.csordtelcoa__Change_Type__c == 'Change'))) {
	                        solutionList.add(service.LG_Suborder__c);
	                      updateSol = true;
	                      System.debug('Logistics dispatch reqd for the service:' +service);
	                      }
                      }
        } 
      
        system.debug('solutionLists to check' + solutionList);
        for (csord__Solution__c sols: [Select Id,LG_LogisticsDispatchNeeded__c from csord__Solution__c where Id IN:solutionList]) {
            sols.LG_LogisticsDispatchNeeded__c = true;
            solutionsToUpdate.add(sols);
        }
        
        system.debug('solutionsToUpdate:' + solutionsToUpdate);
        if (!solutionsToUpdate.isEmpty() && updateSol) {
            update solutionsToUpdate;
        }      
    }
}
