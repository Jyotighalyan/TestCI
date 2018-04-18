/************************************************************************************************************************************
*        Class: LG_Care_CreateEntitlementRecord
*     Program : B2B CARE CATALYST PROGRAM
*  Description: It will take the entitlement process id from the org and create an entitlement record against it.
*    Author(s): Jagannath behera (Infosys Limited)
* Created Date: 08-AUG-2017
*   Test Class: LG_Care_CreateEntitlementRecord_Test 
*************************************************************************************************************************************/
Public class LG_Care_CreateEntitlementRecord{
    
    public void linkServiceTypeToEntitlement(Set<Id> serviceIds){
    try {   
        Map<Id, Set<String>> serviceMap = new Map<Id, Set<String>>();

        for(csord__Service__c service : [SELECT LG_SLA__c, csord__Subscription__r.csord__Account__c
                                        from csord__Service__c 
                                        where id in: serviceIds and LG_SLA__c != null]){
            
            
            if(serviceMap.containsKey(service.csord__Subscription__r.csord__Account__c)){
                Set<String> serviceTypeList = serviceMap.get(service.csord__Subscription__r.csord__Account__c);
                serviceTypeList.add(service.LG_SLA__c);
                serviceMap.put(service.csord__Subscription__r.csord__Account__c, serviceTypeList);
            }
            else{
                if(service.LG_SLA__c != null){
                    serviceMap.put(service.csord__Subscription__r.csord__Account__c, new Set<String>{service.LG_SLA__c, 'Admin Change', 'Service Change'});
                }
                else{                    
                    serviceMap.put(service.csord__Subscription__r.csord__Account__c, new Set<String>{'Admin Change', 'Service Change'});
                }
            }
            
            
        }
               
       Map<Id, Set<String>> entitlementMap = new Map<Id, Set<String>>();
        for(Entitlement entitlement : [SELECT AccountId, Name from Entitlement where AccountId in: serviceMap.keySet()]){
            if(entitlementMap.containsKey(entitlement.AccountId)){
                Set<String> serviceTypeList = entitlementMap.get(entitlement.AccountId);
                serviceTypeList.add(entitlement.Name);
                entitlementMap.put(entitlement.AccountId, serviceTypeList);
            }
            else{
                entitlementMap.put(entitlement.AccountId, new Set<String>{entitlement.Name});
            }
        }

        Map<Id,Set<String>> newEntitlementMap = new Map<Id,Set<String>>();
        for(Id accountId : serviceMap.keySet()){
            for(String serviceSla : serviceMap.get(accountId)){
                Integer count = 0;
                
                if(!entitlementMap.isEmpty() && entitlementMap.get(accountId) != null ){
                    for(String entitlementSla : entitlementMap.get(accountId)){
                        if(entitlementSla.contains(serviceSla)){
                            count++;
                        }
                    }
                }
                if(count == 0){
                    if(newEntitlementMap.containsKey(accountId)){
                        Set<String> serviceTypeList = serviceMap.get(accountId);
                        serviceTypeList.add(serviceSla);
                        newEntitlementMap.put(accountId, serviceTypeList);
                    }
                    else{
                        newEntitlementMap.put(accountId, new Set<String>{serviceSla});
                    }
                }
                
            }
        }
        
       
        Map<String, EntitlementProcessId__c> entitlementProcessMap = EntitlementProcessId__c.getAll();
        List<Entitlement> newEntitlements = new List<Entitlement>();
        for(Id accountId : newEntitlementMap.keySet()){
            for(String sla : newEntitlementMap.get(accountId)){
                Entitlement ent = new Entitlement();
                ent.Name = sla;
                ent.AccountId = accountId;
                ent.StartDate = Date.Today();
                ent.SlaProcessId = entitlementProcessMap.get(sla).Process_Id__c;
                //ent.BusinessHoursId = '01m6E00000001W5';
                
                newEntitlements.add(ent);
            }
        }
        
        if(newEntitlements.size() > 0){
           
                insert newEntitlements;
                system.debug('Created Entitlement Records');
            }
            }
            Catch(Exception e) {}
        
    }
}