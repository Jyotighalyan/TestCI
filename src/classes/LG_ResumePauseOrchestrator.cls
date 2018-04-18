/**
 * Orchestrator changes (OMB-125 Complex change)
 *
 * @author Minhaj Alam
 * @ticket SFOM-376
 * @since  20/03/2017
 */
public class LG_ResumePauseOrchestrator {

    /**
     * Complex change OMB-125	 
     *
     * Resume previously paused orchestration process
     * @param  Id recordId opportunity id of new version
     * @author Minhaj Alam
     * @ticket SFOM-376
     * @since  20/03/2017
     */
    public static void cancelComplexChange(Id recordId) {
       
        Opportunity oppObj = [SELECT Id, LG_OlderVersion__c
							 FROM Opportunity
							 WHERE Id = :recordId LIMIT 1];

        if (oppObj.LG_OlderVersion__c != null) {
            csord__Order__c orderObj = [SELECT Id 
										FROM csord__Order__c
										WHERE csordtelcoa__Opportunity__c = :oppObj.LG_OlderVersion__c LIMIT 1];
			resumeOrchestrationProcess(orderObj.Id);
        }        
    }
    
     /**
     * Complex change OMB-125	 
     *
     * Resume previously paused orchestration process
     * @param  Id recordId order id
     * @author Minhaj Alam
     * @ticket SFOM-376
     * @since  20/03/2017
     */
	public static void resumeOrchestrationProcess(Id orderId) {
		
		List<csord__Solution__c> solutions = new List<csord__Solution__c>();        
		solutions = [SELECT Id FROM csord__Solution__c WHERE csord__Order__c = :orderId];
		if (solutions != null) {
			List<CSPOFA__Orchestration_Process__c> orchProcessList = new List<CSPOFA__Orchestration_Process__c>();

			for(CSPOFA__Orchestration_Process__c process : [SELECT Id, CSPOFA__Process_On_Hold__c
															FROM CSPOFA__Orchestration_Process__c
															WHERE LG_Solution__c IN :solutions])
			{
				process.CSPOFA__Process_On_Hold__c = false;
				orchProcessList.add(process);
			}
            
			update orchProcessList;
		}
	}
}