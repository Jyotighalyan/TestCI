/**
 * Used as a custom orchestator step.
 *
 * @author Alisha
 * @story SFOM-672
 * @since  17/6/2017
 */
global class LG_ServiceProvisioningStep implements CSPOFA.ExecutionHandler {
    String Msg;
    Integer counter;
    Map<Id, csord__Order__c> orders   = new Map<Id, csord__Order__c>();
    List<csord__Solution__c> currentSolutions = new List<csord__Solution__c>();
    List<csord__Solution__c> updatedSolutions = new List<csord__Solution__c>();
    public static List<CSPOFA__Orchestration_Step__c> stepList ;
     //custom setting to store the limit value
    UM_MinervaConnection__c  connection = UM_MinervaConnection__c.getInstance();

    public  List<sObject> process(List<SObject> data) {
    
        List<sObject> result = new List<sObject>();
        //collect the data for all steps passed in
        stepList = (List<CSPOFA__Orchestration_Step__c>)data;

        Set<Id> processesIds = new Set<Id>();
        Set<Id> stepListIds= new Set<Id>();

        system.debug('data=='+data);

        for (CSPOFA__Orchestration_Step__c step : stepList) {
              stepListIds.add(step.id);
              processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }
        
        List<CSPOFA__Orchestration_Process__c> orchProcessList  = [SELECT id,name,LG_Solution__r.LG_Integration_Status__c,LG_Solution__r.LG_Integration_Description__c from CSPOFA__Orchestration_Process__c where id IN :processesIds ];
        
        if(!orchProcessList.isEmpty())
        {
            for(CSPOFA__Orchestration_Process__c orchProcess : orchProcessList ){
               if(orchProcess.LG_Solution__r.LG_Integration_Status__c != 'Request Acknowledged' && orchProcess.LG_Solution__r.LG_Integration_Status__c != 'Middleware Request Failed' && orchProcess.LG_Solution__r.LG_Integration_Status__c != 'Pending Work Order Created'
                && orchProcess.LG_Solution__r.LG_Integration_Status__c != 'Order Creation Failed' && orchProcess.LG_Solution__r.LG_Integration_Status__c != 'Work Order Created'  ){
                    UM_PlaceOrder.checkServices(processesIds,stepListIds);    
                }
            }    
        }
        system.debug('processesIds=='+processesIds+'==stepListIds=='+stepListIds);
        return result;
    }
    
}