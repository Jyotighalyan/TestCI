global class LG_NotifySiteStatus implements CSPOFA.ExecutionHandler {
    
    public List<sObject> process(List<SObject> data)
    {
        List<sObject> result = new List<sObject>();

        List<CSPOFA__Orchestration_Step__c> stepList = (List<CSPOFA__Orchestration_Step__c>)data;

        Set<Id> processesIds = new Set<Id>();
        for (CSPOFA__Orchestration_Step__c step : stepList) {
            processesIds.add(step.CSPOFA__Orchestration_Process__c);
        }

        // Call method
        checkServiceStatustoNotify(processesIds);

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
	 * being executed/processed and checks whether any of the Service records
	 * have the Wait for Access is not NULL.
	 * If that's the case, flag 'Wait for Access' on the related solution
	 * will be set to true.
	 *
	 * @param  Set<Id> processesIds
	 * @author Godson
	 * @ticket SFOM-2201
	 * @since  21/11/2017
	 */
    @TestVisible
	private void checkServiceStatustoNotify(Set<Id> processesIds)
	{
		List<csord__Solution__c> solutionsToUpdate = new List<csord__Solution__c>();
		List<csord__Service__c> serviceList = new List<csord__Service__c>();
		Map<Id, List<csord__Service__c>> solutionToServiceMap = new Map<Id, List<csord__Service__c>>();
		Map<Id, List<csord__Service__c>> orderToServicesMap;
		Map<Id, List<csord__Solution__c>> orderToSolutionsMap;
		Set<Id> orderIds = new Set<Id>();
		
		try{

		List<csord__Solution__c> solutionList = [SELECT Id, csord__Order__c, (SELECT Id, LG_ServiceStatus__c, csord__Service__c, LG_Suborder__c, csord__Order__c, LG_RootOrder__c,
												UM_DependsOnService__c,UM_DependsOnService__r.id, UM_DependsOnService__r.LG_DecompositionCriteria__c,UM_DependsOnService__r.LG_ServiceStatus__c,
												UM_DependsOnService__r.LG_RootOrder__c, UM_DependsOnService__r.csord__Activation_Date__c, csord__Activation_Date__c, Persistent_Id__c, LG_From_Service__c, LG_To_Service__c, csord__Deactivation_Date__c, UM_DependsOnService__r.csord__Deactivation_Date__c FROM Services__r WHERE UM_DependsOnService__c != null)
											FROM csord__Solution__c WHERE Id IN (SELECT LG_Solution__c FROM CSPOFA__Orchestration_Process__c WHERE Id IN :processesIds)];
											
		for(csord__Solution__c solution:solutionList){
		    solutionToServiceMap.put(solution.Id,solution.Services__r);
		    orderIds.add(solution.csord__Order__c);
		}
		
		orderToServicesMap = getServicesFromOrder(orderIds);
		orderToSolutionsMap = getSolutionsFromOrder(orderIds);
		
		//List<csord__Service__c> serviceListAll = [SELECT Id, LG_From_Service__c, LG_To_Service__c FROM csord__Service__c WHERE LG_To_Service__c IN (SELECT LG_To_Service__c FROM csord__Service__c WHERE LG_From_Service__c IN :serviceList)];
		
		for(csord__Solution__c solution:solutionList){
		    List<csord__Service__c> relatedServiceList = solutionToServiceMap.get(solution.Id);
		    //boolean siteActivated = false;
		    String servicePersistentId;
		    String rootOrderId;
		    system.debug('DEBUG:relatedServiceLists for solution'+relatedServiceList);
		    //To check all the service Belongs to the solution are Activated or Read for Billing
		    for(csord__Service__c service : relatedServiceList){
		        //if(service.LG_ServiceStatus__c == 'Activation Completed' || service.LG_ServiceStatus__c == 'Ready for Billing'){
		            //siteActivated = true;
		         //SFOM-2557     
		            if(service.UM_DependsOnService__c != null && service.UM_DependsOnService__r.LG_DecompositionCriteria__c == 'Set 23 - CCC Offnet Process'
		            	&& service.UM_DependsOnService__r.LG_RootOrder__c == service.LG_RootOrder__c){
	                    
	                    service.UM_DependsOnService__r.LG_ServiceStatus__c = 'Activation Completed';
	                    service.UM_DependsOnService__r.csord__Activation_Date__c = service.csord__Activation_Date__c;
	                    // code change for sfom-2678/DGT-121
                      	if (service.csord__Deactivation_Date__c != null) {
                      		service.UM_DependsOnService__r.csord__Deactivation_Date__c = service.csord__Deactivation_Date__c;
                      	}
	                    System.debug('DEBUG : LOG : Dependent Service'+service.UM_DependsOnService__c);
	                    System.debug('DEBUG : LOG : Dependent Service status'+service.UM_DependsOnService__r.LG_ServiceStatus__c);
	                
	                    update service.UM_DependsOnService__r;
	                }
		            
		            if(service.csord__Service__c == null){
		                servicePersistentId = service.Persistent_Id__c;
		            }
		       /*}else{
		            siteActivated = false;
		        }*/
		    }
		    
		    //System.debug('DEBUG : LOG : siteActivated = '+siteActivated);
		    System.debug('DEBUG : LOG : servicePersistentId = '+servicePersistentId);
		    
		    //If all the service under the Solution is Activated.
		    if(servicePersistentId != null){
		        List<csord__Service__c> orderRelatedServices = new List<csord__Service__c>();
		        List<csord__Solution__c> orderRelatedSolutions = new List<csord__Solution__c>();
		        if(orderToServicesMap.containsKey(solution.csord__Order__c)){
		            orderRelatedServices = orderToServicesMap.get(solution.csord__Order__c);
		        }
		         
		        if(orderToSolutionsMap.containsKey(solution.csord__Order__c)){
		            orderRelatedSolutions = orderToSolutionsMap.get(solution.csord__Order__c);
		        }
		        
		        String VPNservicePersistentId;
		        System.debug('Check1'+orderRelatedServices);
		         for(csord__Service__c servieDetails:orderRelatedServices){
		             if(servicePersistentId.equalsIgnoreCase(servieDetails.LG_To_Service__c)){
		                 VPNservicePersistentId = servieDetails.LG_From_Service__c;
		                 break;
		             }
		         }
		         
		         System.debug('DEBUG : LOG : VPNservicePersistentId = '+VPNservicePersistentId);
		        
		         
		         if(VPNservicePersistentId != null){
		             for(csord__Service__c servieDetails:orderRelatedServices){
		                 if(VPNservicePersistentId.equalsIgnoreCase(servieDetails.Persistent_Id__c)){
		                     for(csord__Solution__c solutionDetails: orderRelatedSolutions){
		                         if(solutionDetails.Id == servieDetails.LG_Suborder__c){
		                             solutionDetails.LG_Activated_New_Site__c = 'True';
		                             solutionsToUpdate.add(solutionDetails);
		                         }
		                     }
		                 }
		             }
		             
		         }else{
		             System.debug('DEBUG : LOG : Terminate Scenario');
		             List<csord__Service__c> connectServiceSolution = [SELECT Id, Name , LG_Suborder__c, LG_Suborder__r.LG_Activated_New_Site__c from csord__Service__c where LG_To_Service__c = :servicePersistentId AND csordtelcoa__Replaced_Service__c = null];
		             for(csord__Service__c serviceDetails: connectServiceSolution){
		                 serviceDetails.LG_Suborder__r.LG_Activated_New_Site__c = 'True';
		                 solutionsToUpdate.add(serviceDetails.LG_Suborder__r);
		             }
		         }
		         
		        
		    }
		    
		    
		    
		}

		if (!solutionsToUpdate.isEmpty()) {
			update solutionsToUpdate;
		}
		
		}catch(Exception e){
		    System.debug('DEBUG : ERROR : '+ e.getMessage());
		}
	}
	
	
	private Map<Id, List<csord__Service__c>> getServicesFromOrder(Set<Id> orderIds){
	    Map<Id, List<csord__Service__c>> orderToServicesMap = new Map<Id, List<csord__Service__c>>();
	    
	    List<csord__Service__c> orderRelatedServices = [SELECT Id, LG_RootOrder__c, LG_ServiceStatus__c, LG_Suborder__c,csord__Order__c, csord__Service__c, Persistent_Id__c, LG_From_Service__c, LG_To_Service__c FROM csord__Service__c WHERE LG_RootOrder__c IN :orderIds AND csordtelcoa__Replaced_Service__c = null];
	    for(csord__Service__c service:orderRelatedServices){
	        if(orderToServicesMap.containsKey(service.LG_RootOrder__c)){
	            List<csord__Service__c> serviceList = orderToServicesMap.get(service.LG_RootOrder__c);
	  
                serviceList.add(service);
                orderToServicesMap.put(service.LG_RootOrder__c, serviceList);
	        }else{
	            orderToServicesMap.put(service.LG_RootOrder__c, new List<csord__Service__c>{service});
	        }
	        
	    }
	    return orderToServicesMap;
	}
	
	private Map<Id, List<csord__Solution__c>> getSolutionsFromOrder(Set<Id> orderIds){
	    Map<Id, List<csord__Solution__c>> orderToSolutionsMap = new Map<Id, List<csord__Solution__c>>();
	    
	    List<csord__Solution__c> orderRelatedSolutions = [SELECT Id, LG_Activated_New_Site__c, csord__Order__c FROM csord__Solution__c WHERE csord__Order__c IN :orderIds];
	    for(csord__Solution__c solution:orderRelatedSolutions){
	        if(orderToSolutionsMap.containsKey(solution.csord__Order__c)){
	            List<csord__Solution__c> solutionList = orderToSolutionsMap.get(solution.csord__Order__c);
                solutionList.add(solution);
                orderToSolutionsMap.put(solution.csord__Order__c, solutionList);
	        }else{
	            orderToSolutionsMap.put(solution.csord__Order__c, new List<csord__Solution__c>{solution});
	        }
	        
	    }
	    return orderToSolutionsMap;
	    
	}

}