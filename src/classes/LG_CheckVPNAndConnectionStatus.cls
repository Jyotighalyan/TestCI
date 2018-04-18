global class LG_CheckVPNAndConnectionStatus implements CSPOFA.ExecutionHandler {
    
    public List<sObject> process(List<SObject> data)
    {
        List<sObject> result = new List<sObject>();

        List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;

        Set<Id> processesIds = new Set<Id>();
        for (CSPOFA__Orchestration_Step__c step : stepList) {
            processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }

        // Call method
        checkVPNAndConnectionStatus(processesIds);

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
   * being executed/processed and checks the status of VPN and Connection
   * service records.
   * 
   * 
   *
   * @param  Set<Id> processesIds
   * @author Akhil Goel
   * @ticket SFOM-2207
   * @since  28/11/2017
   */
    @TestVisible
  public void checkVPNAndConnectionStatus(Set<Id> processesIds)
  {
   set<Id> configIds = new Set<Id>();
   Map<Id, csord__service__c> connectionServiceMap = new Map<id, csord__service__c>();
   csord__service__c vpnSrvToUpdate;
   List<csord__service__c> serviceToUpdate = new List<csord__service__c>();
   Set<Id> orderIds = new Set<Id>();
try{
for (csord__solution__c sol : [SELECT Id,csord__Order__c, (SELECT Id FROM Solutions__r), (SELECT Id,csord__Status__c,LG_ServiceStatus__c,LG_From_Service__c,LG_To_Service__c,Persistent_Id__c FROM Services__r) FROM csord__Solution__c
                      WHERE Id IN (SELECT LG_Solution__c
                             FROM CSPOFA__Orchestration_Process__c
                             WHERE Id IN :processesIds)] ){
  System.debug('check# ' + sol.services__r);
//Iterating the Services related to the suborder
for(csord__service__c srv : sol.services__r){
    //Condition to check for connection service
    if(srv.LG_To_Service__c !=null){//  connection service
        connectionServiceMap.put(srv.LG_To_Service__c, srv); 
    }
    //Condition to Identify the VPN service
    if(srv.LG_To_Service__c ==null && srv.LG_From_Service__c ==null){ //vpn service
        vpnSrvToUpdate = srv;
        System.debug('vpn service is' + vpnSrvToUpdate);
    }
}// suborder map
System.debug('map# ' + connectionServiceMap);
orderIds.add(sol.csord__Order__c);
                System.debug('>>>>'+sol.csord__Order__c);
}//orch process map
                //Added field in the query for sfom-2455
                List<csord__Service__c> srvcbds = [SELECT Id, Name ,LG_ServiceStatus__c,Persistent_Id__c,csord__Activation_Date__c,csord__Deactivation_Date__c from csord__Service__c where Persistent_Id__c in :connectionServiceMap.keySet() AND csordtelcoa__Replaced_Service__c = null];
System.debug('srvcbds# ' + srvcbds);
Integer activeServicecount=0;
Integer inProgressServicecount=0;
                Map<Id, csord__service__c> bdsSiteDiscoMap = new Map<Id, csord__service__c>();
// removed  || srv.LG_ServiceStatus__c =='Provisioned' from below
for(csord__Service__c srv: srvcbds){
                    system.debug ('BDS Service is' +srv);
                    if(srv.csord__Deactivation_Date__c != null){ // Added this if condition for sfom-2455
                        if(srv.LG_ServiceStatus__c =='Inactive' || srv.LG_ServiceStatus__c =='Ready for Billing' || srv.LG_ServiceStatus__c =='Activation Completed'){
                            bdsSiteDiscoMap.put(srv.Persistent_Id__c, srv);
                        }                   
                    } else {
if(srv.LG_ServiceStatus__c =='Active' || srv.LG_ServiceStatus__c =='Ready for Billing' || srv.LG_ServiceStatus__c =='Activation Completed'){
   activeServicecount++;
  }
else
   inProgressServicecount++;
                        
                    }
 }  

        
System.debug('BDSActiveService# ' + activeServicecount);
System.debug('InProgressService# ' + inProgressServicecount);
//removed  || vpnSrvToUpdate.LG_ServiceStatus__c !='Provisioned' from below
                if (vpnSrvToUpdate != null && activeServicecount>=1 && (vpnSrvToUpdate.LG_ServiceStatus__c !='Active' && vpnSrvToUpdate.LG_ServiceStatus__c !='Ready for Billing' && vpnSrvToUpdate.LG_ServiceStatus__c !='Activation Completed')){
System.debug('VPN service getting updated is ' + vpnSrvToUpdate);
                    vpnSrvToUpdate.LG_ServiceStatus__c ='Activation Completed';
     vpnSrvToUpdate.csord__Status__c ='Activation Completed';
     vpnSrvToUpdate.csord__Activation_Date__c = Date.today(); 
     update vpnSrvToUpdate;
     }
for(csord__Service__c srv: srvcbds){
                    System.debug('LG Service status is ' +srv.LG_ServiceStatus__c +  ' -- ' + srv.Name);
                    csord__service__c srvToUpdate = connectionServiceMap.get(srv.Persistent_Id__c);

                    if((srv.LG_ServiceStatus__c =='Active' || srv.LG_ServiceStatus__c =='Ready for Billing' || srv.LG_ServiceStatus__c =='Activation Completed') && (activeServicecount>1 || inProgressServicecount==0) && (srvToUpdate.LG_ServiceStatus__c !='Active' && srvToUpdate.LG_ServiceStatus__c !='Ready for Billing' && srvToUpdate.LG_ServiceStatus__c !='Activation Completed')) {
    //                    csord__service__c srvToUpdate = connectionServiceMap.get(srv.Persistent_Id__c);
                        srvToUpdate.LG_ServiceStatus__c = 'Activation Completed';
   srvToUpdate.csord__Status__c = 'Activation Completed';
    if(srv.csord__Activation_Date__c == null || srv.csord__Activation_Date__c < Date.today()){
       srvToUpdate.csord__Activation_Date__c = Date.today();
       
                        } else {
    srvToUpdate.csord__Activation_Date__c = srv.csord__Activation_Date__c;
    }
    serviceToUpdate.add(srvToUpdate);
     }
}

System.debug('check# ' + serviceToUpdate);
                //Added for SFOM-2455
                for(Id bdsSiteId : bdsSiteDiscoMap.keySet()){
                    if(connectionServiceMap.get(bdsSiteId) != null){
                        csord__Service__c connService = connectionServiceMap.get(bdsSiteId);
                        connService.LG_ServiceStatus__c = 'Activation Completed';
                        connService.csord__Deactivation_Date__c = bdsSiteDiscoMap.get(bdsSiteId).csord__Deactivation_Date__c;
                        serviceToUpdate.add(connService);
                    }
                }
update serviceToUpdate;

}//try
catch(Exception e){
    System.debug('Exception: ' + e.getMessage());
}
}
}