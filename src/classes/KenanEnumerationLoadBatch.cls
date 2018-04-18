/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Enumeration Batch Job to load Enumerations from Kenan into SFDC
*/
global class KenanEnumerationLoadBatch implements Database.Batchable<KenanEnumeration>, Database.AllowsCallouts {
	
	global String sessionId;
	global Boolean loadData;
	global String objectExtension = '__mdt';
	global String fieldExtension = '__c';


	global KenanEnumerationLoadBatch(String currentSessionId, Boolean doDataLoad){
		system.debug('LoadEnumerations constructor:' + currentSessionId + ' : ' + doDataLoad);
		this.sessionId = currentSessionId;
		this.loadData = doDataLoad;
	}
		
	global KenanEnumerationLoadBatch() {
		
	}
	
	global List<KenanEnumeration> start(Database.BatchableContext BC) {
		List<KenanEnumeration> importItems = new List<KenanEnumeration>();
		Map<String, String> enumNames = getEnumsToLoad();
		for (String enumName : enumNames.keySet()){
			try {
				KenanEnumeration enumeration = KenanEnumerationService.getEnumeration(enumName);
				importItems.add(enumeration);
			} catch (Exception e){
					throw e;
			}
		}		

		return importItems;
	}
	

   	global void execute(Database.BatchableContext BC, List<KenanEnumeration> scope) {
		Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
		for (KenanEnumeration enumeration : scope){
			Map<String, String> enumsToLoad = getEnumsToLoad();
			String enumClassName = enumsToLoad.get(enumeration.enumName);
			KenanEnumerationLoader enumLoader = (KenanEnumerationLoader) Type.forName(enumClassName).newInstance();
			enumLoader.executeLoad(sessionId, enumeration, this.loadData);
		}
	}
	
	global void finish(Database.BatchableContext BC) {
		if (this.loadData == false){
			KenanEnumerationLoadBatch batch = new KenanEnumerationLoadBatch(this.sessionId, true);
			if (!Test.isRunningTest()) {
				Database.executeBatch(batch, 1);
			}
		}
	}

	private Map<String, String> getEnumsToLoad(){
		//Map of Enumeration Name to be loaded and the class use to process the Enumeration
		List<Enumeration_List__mdt> enumerations = [SELECT DeveloperName, Enumeration_Type__c FROM Enumeration_List__mdt];
		Map<String, String> enumMap = new Map<String, String>();
		for (Enumeration_List__mdt enumeration : enumerations){
			enumMap.put(enumeration.DeveloperName, enumeration.Enumeration_Type__c);
		}

		return enumMap;
	}
	
}