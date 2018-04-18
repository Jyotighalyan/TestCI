public class LG_SolutionTriggerHandler {
	/**
	 * If there is a change in the Solution/Suborder Jeopardy, Inflight Change or Order
	 * Changed fields - the orchestrator Evented Monitor field should be notified.
	 *
	 * @param  List<csord__Solution__c> suborders
	 * @param  Map<Id, csord__Solution__c> oldMap
	 * @author Tomislav Blazek
	 * @ticket SFOM-359
	 * @since  3/3/2017
	 */
	public static void notifyMonitorField(List<csord__Solution__c> suborders, Map<Id, csord__Solution__c> oldMap) {
		Set<Id> eligibleSuborderIds = new Set<Id>();

		/*
		 * Decide which solutions/suborders should be processed:
		 * - only suborders that had a change in the LG_Jeopardy__c, LG_InflightChange__c
		 * or LG_OrderChanged__c fields
		 */
		for (csord__Solution__c newSuborder : suborders) {
			csord__Solution__c oldSuborder = oldMap == null ? null : oldMap.get(newSuborder.Id);
           // added one more condition for adding solution status for defect OMB-827 in line 26
			if (oldSuborder != null &&
				(oldSuborder.LG_IsFirstDayofNextMonth__c != newSuborder.LG_IsFirstDayofNextMonth__c
				 || oldSuborder.LG_Jeopardy__c != newSuborder.LG_Jeopardy__c
				 || oldSuborder.LG_InflightChange__c != newSuborder.LG_InflightChange__c
                 || oldSuborder.LG_OrderChanged__c != newSuborder.LG_OrderChanged__c||oldSuborder.LG_Integration_Status__c!= newSuborder.LG_Integration_Status__c || oldSuborder.LG_AccessAvailable__c!= newSuborder.LG_AccessAvailable__c  
                 || oldSuborder.LG_Jira_Status__c != newSuborder.LG_Jira_Status__c
                 || oldSuborder.csord__Status__c!= newSuborder.csord__Status__c)) {
				eligibleSuborderIds.add(newSuborder.Id);
			}
		}

		if (!eligibleSuborderIds.isEmpty()) {
			CSPOFA.Events.emit('update', eligibleSuborderIds);
		}
	}
    
    /**
    public static void checkVPNAndConnectionStatus(List<csord__Solution__c> suborders, Map<Id, csord__Solution__c> oldMap) {
    	
        Set<Id> eligibleSuborderIds = new Set<Id>();

        for (csord__Solution__c newSuborder : suborders) {
        	csord__Solution__c oldSubOrder = oldMap.get(newSubOrder.Id);
            if(newSubOrder.LG_DecompositionCriteria__c == 'Set 21 - VPN Process' && oldSubOrder.LG_Activated_New_Site__c  != newSuborder.LG_Activated_New_Site__c && newSuborder.LG_Activated_New_Site__c == 'Check Services'){
                eligibleSuborderIds.add(newSuborder.Id);
            }
        }
        
        if(!eligibleSuborderIds.isEmpty()){
            set<Id> configIds = new Set<Id>();
            Map<Id, csord__service__c> connectionServiceMap = new Map<id, csord__service__c>();
            //   Map<Id, List<csord__service__c>> suborderServiceMap = new Map<Id, List<csord__service__c>>();
            //   Map<Id, List<csord__service__c>> vpnServiceMap = new Map<Id, List<csord__service__c>>();
            csord__service__c vpnSrvToUpdate;
            List<csord__service__c> serviceToUpdate = new List<csord__service__c>();
            Set<Id> orderIds = new Set<Id>();
            try{
                for (csord__solution__c sol : [SELECT Id,csord__Order__c, (SELECT Id FROM Solutions__r), (SELECT Id,csord__Status__c,LG_ServiceStatus__c,LG_From_Service__c,LG_To_Service__c,Persistent_Id__c FROM Services__r) FROM csord__Solution__c
                              WHERE Id IN :eligibleSuborderIds] ){
                    System.debug('check# ' + sol.services__r);
                    //  suborderServiceMap.put(sol.Id, sol.services__r);
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
                List<csord__Service__c> srvcbds = [SELECT Id, Name ,LG_ServiceStatus__c,Persistent_Id__c,csord__Activation_Date__c,csord__Deactivation_Date__c from csord__Service__c where Persistent_Id__c in :connectionServiceMap.keySet() AND csord__Order__c IN :orderIds AND csordtelcoa__Replaced_Service__c = null];
                System.debug('srvcbds# ' + srvcbds);
                Integer activeServicecount=0;
                Integer inProgressServicecount=0;
                Map<Id, csord__service__c> bdsSiteDiscoMap = new Map<Id, csord__service__c>();
                // removed  || srv.LG_ServiceStatus__c =='Provisioned' from below
                for(csord__Service__c srv: srvcbds){
                    system.debug ('BDS Service is' +srv);
                    if(srv.csord__Deactivation_Date__c != null){ // Added this if condition for sfom-2455
                        if(srv.LG_ServiceStatus__c =='inactive' || srv.LG_ServiceStatus__c =='Ready for Billing' || srv.LG_ServiceStatus__c =='Activation Completed'){
                            bdsSiteDiscoMap.put(srv.Id, srv);
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
	**/
    
}