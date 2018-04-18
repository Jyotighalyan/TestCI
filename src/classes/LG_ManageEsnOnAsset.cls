/**
  * Custom step to manage ESN on asset
 *
 * @author Alisha
 * @ticket SFOM-2660
 * @since  14/02/2018
*/
global class LG_ManageEsnOnAsset implements CSPOFA.ExecutionHandler {

  public List<sObject> process(List<SObject> data)
  {
    List<sObject> result = new List<sObject>();

     List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;
        
    Set<Id> processesIds = new Set<Id>();
    for (CSPOFA__Orchestration_Step__c step : stepList)
    {
      processesIds.add(step.CSPOFA__Orchestration_Process__c);
    }
    system.debug('processesIds=='+processesIds);
    // Call method
    updateEsnOnAsset(processesIds);
    
    for (CSPOFA__Orchestration_Step__c step : stepList)
    {
      //mark step Status, Completed Date
      step.CSPOFA__Status__c = 'Complete';
      step.CSPOFA__Completed_Date__c = Date.today();
      result.add(step);
    }

    return result;
  }
  
  /*
     * Search for Assets in services related to Order
     * For any such case
     * 
     * @author Alisha
     * @ticket SFOM-2660
     * @since  14/02/2018
  */
  @TestVisible
  private void updateEsnOnAsset(Set<id> processesIds) {
      
        Set<Id> orderIds = new Set<Id>();

    // Get all data
    for (CSPOFA__Orchestration_Process__c process : [SELECT Id, 
                                                            LG_Order__c,lg_order__r.LG_Asset_without_ESN__c FROM CSPOFA__Orchestration_Process__c
                             WHERE Id IN :processesIds AND LG_Order__c != null]) {
                                 
            if (!String.isBlank(process.LG_Order__c)) {
              // Populate orders
              orderIds.add(process.LG_Order__c);
      }    
    }
    //list of all assets related to services (related to Orderids)
    List<Asset> assetList=[select id ,LG_MACAddress__c,name,csord__Service__r.LG_RootOrder__c,csord__Service__c,csord__Service__r.LG_RootOrder__r.LG_Asset_without_ESN__c from asset where LG_MACAddress__c=null AND csord__Service__c 
                              IN (select id from csord__service__c where LG_RootOrder__c IN :orderIds) ];
    system.debug('a:assetList======='+assetList);

    Map<id,csord__Order__c> ordMap=new Map<id,csord__Order__c> ();
    List<csord__Order__c> oList=new List<csord__Order__c> ();

    if(!assetList.isEmpty()){
    for(Asset a:assetList){
        ordMap.put(a.id,a.csord__Service__r.LG_RootOrder__r );

    }

    for(csord__order__c o:ordMap.values()){
            o.LG_Asset_without_ESN__c=true;        
            oList.add(o);
        }
     }
       
    try{
        update oList;  
        system.debug('oList======='+oList);
     }
    catch(Exception e){
        system.debug(e);
    }
     }
}