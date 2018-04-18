/**
 * Controller for feature widget component
 */
global class FeatureWidgetController {

	/**
	 * Returns all available features for some price item
	 * @param Id priceItem
	 * @param String category  name of feature custom setting
	 * @return String  JSON of all features
	 */
	@RemoteAction
	global static String getAvaialbleFeatures(Id priceItem, String category) {
		String retVal = '';
		try {
			List<cspmb__Price_Item_Feature_Association__c> featureAssociations = [
				select Id, cspmb__Feature__c, cspmb__Price_Item__c
				from cspmb__Price_Item_Feature_Association__c
				where cspmb__Price_Item__c = :priceItem
			];
			if (!featureAssociations.isEmpty()) {
				Set<Id> featureIds = new Set<Id>();
				List<Object> retList = new List<Object>();
				for (cspmb__Price_Item_Feature_Association__c featureAssoc : featureAssociations) {
					featureIds.add(featureAssoc.cspmb__Feature__c);
				}
				String queryString = 'select ';
				Feature_Widget_Settings__c settings = Feature_Widget_Settings__c.getValues(category);

				if (settings != null && settings.Feature_Fields__c != null) {
					queryString += 'Id, Name,';
					queryString += settings.Feature_Fields__c;
				} else {
					queryString += 'Id, Name, cspmb__Feature_Description__c';
				}
				queryString += ' from cspmb__Feature__c';
				queryString += ' where Id in :featureIds';
				List<cspmb__Feature__c> features = Database.query(queryString);
				for (cspmb__Feature__c feature : features) {
					Map<String, String> featureValues = new Map<String, String>();
					if (settings != null && settings.Feature_Fields__c != null) {
						List<String> flds = settings.Feature_Fields__c.split(',');
						for (String fld : flds) {
							String label = cspmb__Feature__c.SObjectType.getDescribe().fields.getMap().get(fld).getDescribe().getLabel();
							String value = feature.get(fld) != null ? String.valueOf(feature.get(fld)) : '';
							featureValues.put(label, value);
						}
					}
					featureValues.put('Name', feature.Name);
					featureValues.put('Id', feature.Id);
					retList.add(featureValues);
				}
				retVal = JSON.serialize(retList);
			}
		} catch(Exception e) {
			retVal = 'Error - ' + e.getMessage();
		}
		return retVal;
	}

	/**
	 * Deletes assciated features
	 * @param Id configId
	 * @param String featureCategory
	 */
	@RemoteAction
	global static void deletefeatures(Id configId, String featureCategory) {
		try {
			if (featureCategory != null && featureCategory != '') {
				Feature_Widget_Settings__c settings = Feature_Widget_Settings__c.getValues(featureCategory);
				if (settings != null && settings.Custom_Object__c != null && settings.Custom_Object__c != '') {
					String objName = settings.Custom_Object__c;
					List<sObject> objList = Database.query('select id from ' + objName + ' where Product_Configuration__c = :configId');
					if (!objList.isEmpty()) {
						delete objList;
					}
				}
			}
		} catch(Exception e) {
			system.debug(Logginglevel.Error, e.getMessage());
		}
	}

	/**
	 * Saves features in a related list on configuration
	 * @param Id configId
	 * @param List<Id> featureIds
	 * @param Strong category
	 * @return String  error or success
	 */
	@RemoteAction
	global static String saveFeatures(Id configId, List<Id> featureIds, String category) {
		List<Id> newObjects = new List<Id>();
		String retVal = '';
		try {
			String queryString = 'select ';
			List<String> objectFields = new List<String>();
			Feature_Widget_Settings__c settings = Feature_Widget_Settings__c.getValues(category);
			if (settings != null && settings.Feature_Fields__c != null) {
				queryString += 'Name,';
				queryString += settings.Feature_Fields__c;
			} else {
				queryString += 'Name,cspmb__Feature_Description__c';
			}
			objectFields.add('name');
			if (settings != null && settings.Custom_Object_Fields__c != null) {
				for (String fld : settings.Custom_Object_Fields__c.split(',')) {
					objectFields.add(fld.toLowerCase());
				}
			}
			queryString += ' from cspmb__Feature__c';
			queryString += ' where Id in :featureIds';
			List<cspmb__Feature__c> features = Database.query(queryString);
			if (settings != null && settings.Custom_Object__c != null) {
				List<sObject> featureObjects = new List<sObject>();
				for (cspmb__Feature__c feature : features) {
					Schema.SObjectType targetType = Schema.getGlobalDescribe().get(settings.Custom_Object__c);
					sObject so = targetType.newSObject();
					Set<String> sObjectFields = Schema.SObjectType.cspmb__Feature__c.fields.getMap().keySet();
					so.put('Product_Configuration__c', configId);
					for (String fieldName : objectFields) {
						if (sObjectFields.contains(fieldName)) {
							so.put(fieldName, feature.get(fieldName));
						} else if (sObjectFields.contains('cspmb__' + fieldName)) {
							so.put(fieldName, feature.get('cspmb__' + fieldName));
						}
					}
					featureObjects.add(so);
				}
				if (!featureObjects.isEmpty()) {
					insert featureObjects;
					for (sObject so : featureObjects) {
						newObjects.add(so.Id);
					}
				}
			}
			retVal = JSON.serialize(newObjects);
		} catch(Exception e) {
			system.debug('Error - ' + e.getMessage());
			retval = e.getMessage();
		}
		return retVal;
	}
}