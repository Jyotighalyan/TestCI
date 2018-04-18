public with sharing class UM_PortingProcessTriggerHandler {

	public static void updatePortingProcessCountOnService(list<UM_PortingProcess__c> lstPortProcesses, map<Id, UM_PortingProcess__c> oldPortProcessMap, Boolean isDeleted){
		system.debug('updatePortingProcessCountOnService');
		list<csord__Service__c> lstServiceToBeUpdated=new list<csord__Service__c>();
		set<Id> set_portProcessId=new set<Id>();
		map<Id,List<UM_PortingProcess__c>> map_ServicePortingProcesses= new map<Id,List<UM_PortingProcess__c>>();
		set<Id> set_deletedPortProcessId=new set<Id>();
		map<Id,Integer> map_ServicePortingProcessCount=new map<Id,Integer>();

		for(UM_PortingProcess__c portProcess: lstPortProcesses){
			if((oldPortProcessMap==null && portProcess.UM_Status__c=='Open' )|| (oldPortProcessMap!=null && oldPortProcessMap.get(portProcess.Id).UM_Status__c!=portProcess.UM_Status__c) && (!isDeleted) ){
				set_portProcessId.add(portProcess.UM_VoiceService__c);
			}
			if(isDeleted && portProcess.UM_Status__c=='Open'){
				set_deletedPortProcessId.add(portProcess.UM_VoiceService__c);
			}
		}
		if(!set_portProcessId.isEmpty()){
			list<UM_PortingProcess__c> queriedPortProcesses=[select Id, UM_VoiceService__c, UM_VoiceService__r.UM_NumberOfOpenPortingProcesses__c from UM_PortingProcess__c where UM_Status__c='Open' and UM_VoiceService__c IN: set_portProcessId ];
			if(!queriedPortProcesses.isEmpty()){
				for(UM_PortingProcess__c objPortProcess:queriedPortProcesses){
					if(map_ServicePortingProcesses.containsKey(objPortProcess.UM_VoiceService__c)){
			   			map_ServicePortingProcesses.get(objPortProcess.UM_VoiceService__c).add(objPortProcess);
			   		}
			   		else{
			   			map_ServicePortingProcesses.put(objPortProcess.UM_VoiceService__c, new list<UM_PortingProcess__c>{objPortProcess});
			   		}
				}

			}
		}
		set_portProcessId.addAll(set_deletedPortProcessId);
		lstServiceToBeUpdated=[select id,UM_NumberOfOpenPortingProcesses__c from csord__Service__c where id IN:set_portProcessId ];
		if(!lstServiceToBeUpdated.isEmpty()){
			for(csord__Service__c servc:lstServiceToBeUpdated){
				if(map_ServicePortingProcesses.containsKey(servc.Id) && servc.UM_NumberOfOpenPortingProcesses__c!=map_ServicePortingProcesses.get(servc.Id).size() && map_ServicePortingProcesses.get(servc.Id).size()>=0){
					servc.UM_NumberOfOpenPortingProcesses__c=map_ServicePortingProcesses.get(servc.Id).size();
				}
				else if(!map_ServicePortingProcesses.containsKey(servc.Id) && set_deletedPortProcessId.contains(servc.Id) && servc.UM_NumberOfOpenPortingProcesses__c!=0){
					servc.UM_NumberOfOpenPortingProcesses__c=servc.UM_NumberOfOpenPortingProcesses__c-1;
				}
				else if(!map_ServicePortingProcesses.containsKey(servc.Id) && servc.UM_NumberOfOpenPortingProcesses__c!=0){
					servc.UM_NumberOfOpenPortingProcesses__c=servc.UM_NumberOfOpenPortingProcesses__c-1;
				}
			}
			update lstServiceToBeUpdated;
		}
	}

    public static void createKenanIDs(list<UM_PortingProcess__c> newRecords, map<Id, UM_PortingProcess__c> oldRecords){
        set<id> numberBlockServices = new set<id>() ;
        list<csord__Service__c> records;
        System.debug('*** newRecords: '+newRecords + ' and oldRecords: '+ oldRecords);
        string query = 'select id, UM_NumberRangeService__c , UM_NumberRangeService__r.csord__Service__c,'+
                        	' UM_CDRIDNumber__c,UM_NumberRangeService__r.csord__Service__r.csord__Activation_Date__c ' +  
                        ' from UM_NumberBlock__c where UM_NumberRangeService__c in :records';

        for(UM_PortingProcess__c process : newRecords){
            if(process.Type__c=='Port-In' &&
               (process.UM_Status__c=='Closed') &&
               (process.UM_Stage__c=='Closed') &&
               (process.UM_SubStage__c =='Confirmed') &&
               (oldRecords.get(process.id).UM_Status__c!='Closed' ||
                oldRecords.get(process.id).UM_Stage__c!='Closed' ||
                oldRecords.get(process.id).UM_SubStage__c!='Confirmed')
              ){
                numberBlockServices.add(process.UM_NumberRangeService__c); //process.UM_NumberRangeService__c
            }
        }

        records = [select id from csord__Service__c where id in :numberBlockServices];

        System.debug('*** numberBlockServices: '+numberBlockServices);

        if(records!=null && !records.isEmpty())
			Database.executeBatch(new UM_KenanSyncBatch(records, query , 'UM_KenanIDCreator'), 5);
    }

}