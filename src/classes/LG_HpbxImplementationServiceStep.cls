/**
 * Used as a custom orchestator step.
 * Scans the Service records related
 * to the solution being processed.
 * Update the service status to Provisioned
 * so that further conditions in the process can use it.
 *
 * @author Ravi Choudhary
 * @ticket SFOM-1237
 * @since  23/7/2017
 */
global class LG_HpbxImplementationServiceStep implements CSPOFA.ExecutionHandler
{
    public List<sObject> process(List<SObject> data)
    {
        List<sObject> result = new List<sObject>();
        //collect the data for all steps passed in, if needed
        //process steps
        List<CSPOFA__Orchestration_Step__c> stepList =
            (List<CSPOFA__Orchestration_Step__c>)data;
        
        Set<Id> processesIds = new Set<Id>();
        for (CSPOFA__Orchestration_Step__c step : stepList) {
            processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }
        
        updateServices(processesIds);
        
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
   * being executed/processed and update the 
   * service status to Provisioned 
   *
   * @param  Set<Id> processesIds
   * @author Ravi Choudhary
   * @ticket SFOM-1237
   * @since  23/7/2017
   */
  @TestVisible
    private void updateServices(Set<Id> processesIds)
    {
        Set<Id> solutionsIds = new Set<Id>();
        for (CSPOFA__Orchestration_Process__c process : [SELECT LG_Solution__c
            FROM CSPOFA__Orchestration_Process__c
            WHERE Id IN :processesIds
            AND LG_Solution__c != null]) {
                solutionsIds.add(process.LG_Solution__c);
        }

        Map<Id, csord__Service__c> servicesToUpdate = new Map<Id, csord__Service__c>();
        Map<Id, cscfga__Product_Configuration__c> pcToUpdate = new Map<Id, cscfga__Product_Configuration__c>();

        Set<Id> productConfids= new Set<Id>();

        system.debug('Solution ids' + solutionsIds);
        for (csord__Service__c services : [SELECT Id,
            LG_ServiceStatus__c,
            csordtelcoa__Product_Configuration__c
            FROM csord__Service__c
            WHERE LG_Suborder__c IN :solutionsIds ]) {
                servicesToUpdate.put(services.Id,
                        new csord__Service__c(Id = services.Id,
                                   LG_ServiceStatus__c = Label.Service_Staus));
                productConfids.add(services.csordtelcoa__Product_Configuration__c);
        }


        
         for (cscfga__Product_Configuration__c productConfs : [SELECT Id, LG_ActivateValid__c
                         FROM cscfga__Product_Configuration__c
                         WHERE Id IN :productConfids]) {                         
                      pcToUpdate.put(productConfs.Id,
                        new cscfga__Product_Configuration__c(Id = productConfs.Id,
                               LG_ActivateValid__c= 'Yes'));
      
        }
        
        system.debug('services to Update:' + servicesToUpdate);
        if (!servicesToUpdate.isEmpty()) {
            update servicesToUpdate.values();
        }
        system.debug('configurations to update:' + pcToUpdate);
        if (!pcToUpdate.isEmpty()) {
          update pcToUpdate.values();
        }
    }
}