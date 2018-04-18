/**
 * Utillity class for Cama order to block simple changes
 *
 * @author Ravi choudhary
 * @ticket SFOM-1133
 * @since  24/07/2017
*/
global with sharing  class LG_CamaOrderUtil
{

    /*
    * check the provisioning system and display the blocking message for simple change
    */
    webservice static String checkProvisioningSystem(Id solutionId)
    {
        try {
          String errorMsg = validateProvisioningSystem(solutionId);
          return errorMsg;                
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    /**
     * Cama Inflight changes/cancel 
     *
     * @author  Ravi choudhary
     * @ticket SFOM-1133 Code
    */
 
    private static String validateProvisioningSystem(Id solutionId)
    {
        List<csord__Service__c> services = [select Id, LG_ProvisioningSystem__c from csord__Service__c where LG_Suborder__c=: solutionId];
        List<csord__Solution__c> solutions = [Select LG_ProvisioningWorkOrder__c from csord__Solution__c where Id =:solutionId];
        String provisioningSytem;
        String workOrder;
        String message;        
        for (csord__Service__c service : services) {
            //SFOM-1577 - Null handler added
            if(service.LG_ProvisioningSystem__c != null){
                provisioningSytem = service.LG_ProvisioningSystem__c;
            }
        }       

        for (csord__Solution__c solution : solutions) {
            workOrder = solution.LG_ProvisioningWorkOrder__c;
        }
        system.debug('Provisioning System value:' + provisioningSytem);
        Set<String> provSystemVals = new Set<String> {'CAMA', 'JIRA', 'VoiceWorks'};
        Boolean valid = provSystemVals.contains(provisioningSytem);
        if(valid ){
            message = 'This suborder is covered by '+ workOrder +' in ' + provisioningSytem +'. Please request this change there.';
        } else {
            message = 'Success';
        }
        system.debug('message in class' + message);
        return message;
    }
}