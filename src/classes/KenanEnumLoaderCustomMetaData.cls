/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Enumeration Loader will translate specific Kenan Enumerations into Salesforce Custom Metadata Types.
*/
public class KenanEnumLoaderCustomMetaData implements KenanEnumerationLoader {

	private String sessionId;
	
	public KenanEnumLoaderCustomMetaData(){

	}

	public KenanEnumLoaderCustomMetaData(String userSessionId) {
		this.sessionId = userSessionId;
	}

	public void executeLoad(String userSession, KenanEnumeration enumeration,  Boolean loadData){
		this.sessionId = userSession;
		Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
		
		if (loadData){
			KenanEnumerationHelper.deleteCustomMetadata(enumeration, this.sessionId);
			KenanEnumerationHelper.transformToCustomMetadataAndCreate(enumeration, this.sessionId);
		} 
		else {
			Map<String, String> enumFieldMap = enumeration.getFieldNames();
			String enumName = enumeration.enumName;
			String settingName = enumName + '__mdt';
			system.debug('settingName: ' + settingName);
			Schema.SObjectType sot = globalDescribe.get(settingName);
			system.debug('enumFieldMap:' + enumFieldMap);
			if (sot == null){
				KenanEnumerationHelper.createCustomSetting(enumName, this.sessionId);
				KenanEnumerationHelper.addCustomFields(enumFieldMap, enumName, this.sessionId);
			} 
			else {
				KenanEnumerationHelper.addCustomFields(enumFieldMap, enumName, this.sessionId);
			}
		}
	}

}