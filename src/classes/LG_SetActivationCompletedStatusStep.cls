/**
 * Used as a custom orchestator step.
 *
 * @author Tanmay
 * @story
 * @since  01/10/2017
 */
global class LG_SetActivationCompletedStatusStep implements CSPOFA.ExecutionHandler{

    public  List<sObject> process(List<SObject> data) {
       List<sObject> result = new List<sObject>();
        //collect the data for all steps passed in, if needed
        //process steps
        List<CSPOFA__Orchestration_Step__c> stepList =
            (List<CSPOFA__Orchestration_Step__c>)data;

        Set<Id> processesIds = new Set<Id>();
        for (CSPOFA__Orchestration_Step__c step : stepList) {
            processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }
        
        system.debug('processesIds # ' + processesIds );
        updateServiceStatus(processesIds);

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
     * being executed/processed and set the Status to Ready for Billing and
     * Set the Activation Date as today's i.e. Date.Today()
     *
     * @param  Set<Id> processesIds
     * @author Tanmay
     * @ticket
     * @since  01/10/2017
     */

    @TestVisible
    private void updateServiceStatus(Set<Id> processesIds){
            List<csord__Service__c> servicesToUpdate = new List<csord__Service__c>();
        list<csord__Solution__c> solutions = new list<csord__Solution__c>();

        solutions = [SELECT Id,
                                            (SELECT Id,csord__Status__c,csord__Activation_Date__c FROM Services__r
                                            )
                                            FROM csord__Solution__c
                                            WHERE Id IN (SELECT LG_Solution__c
                                                         FROM CSPOFA__Orchestration_Process__c
                                                         WHERE Id IN :processesIds)];
        system.debug('solutions# ' + solutions );
        
        for(csord__Solution__c solution : solutions){
            for(csord__service__c service : solution.Services__r ){
                servicesToUpdate.add(service);
            }
        }
        
         system.debug('servicesToUpdate# ' + servicesToUpdate);

        for (csord__Service__c service : servicesToUpdate) {
            service.csord__Status__c = 'Activation Completed';
            service.csord__Activation_Date__c = Date.today();
        }

        if (!servicesToUpdate.isEmpty()) {
            update servicesToUpdate;
        }
    }

}