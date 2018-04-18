global class RateCardWidgetController {

	@RemoteAction
	global static String getAvailableRateCards(Id configId, Id priceItem, Id accountId, String option) {
		String retVal = '';
		try {
			Rate_Card_Widget_Settings__c settings;
			if (option != null && option != '') {
				settings = Rate_Card_Widget_Settings__c.getValues(option);
			}

			//Fetching rate card associations so we can fetch rate cards
			List<cspmb__Price_Item_Rate_Card_Association__c> rateCardAssociations = [
				select Id, cspmb__Rate_Card__c, cspmb__Price_Item__c
				from cspmb__Price_Item_Rate_Card_Association__c
				where cspmb__Price_Item__c = :priceItem
			];
			if (!rateCardAssociations.isEmpty()) {

				//Collecting ids from related rate cards
				List<Id> rateCardIds = new List<Id>();
				for (cspmb__Price_Item_Rate_Card_Association__c rca : rateCardAssociations) {
					rateCardIds.add(rca.cspmb__Rate_Card__c);
				}

				//Building query to fetch rate cards
				String queryString = 'select Id, Name, Product_Configuration__c, cspmb__Account__c, Price_Item__c';
				if (settings != null && settings.Rate_Card_Fields__c != null) {
					queryString += ', ';
					queryString += settings.Rate_Card_Fields__c;
				}
				queryString += ' from cspmb__Rate_Card__c';
				queryString += ' where id in :rateCardIds';

				if (accountId != null) {
					queryString += ' or (cspmb__Account__c = :accountId and Price_Item__c = :priceItem)';
				}

				//If saving format is not JSON then fetch related custom rate card records
				if (!settings.Save_as_JSON__c) {
					queryString += ' or (Product_Configuration__c = :configId and Price_Item__c = :priceItem)';
				}

				List<cspmb__Rate_Card__c> rateCards = Database.query(queryString);
				Set<Id> queriedRateCardsIds = new Map<Id, cspmb__Rate_Card__c>(rateCards).keySet();
				System.debug('Fetched rateCards: ' + rateCards);
				Map<Id, cspmb__Rate_Card__c> rateCardMap = new Map<Id, cspmb__Rate_Card__c>(rateCards);
				queryString = 'select Id, Name, cspmb__Rate_Card__c';
				if (settings != null && settings.Rate_Card_Line_Fields__c != null) {
					queryString += ',';
					queryString += settings.Rate_Card_Line_Fields__c;
				}
				queryString += ' from cspmb__Rate_Card_Line__c';
				queryString += ' where cspmb__Rate_Card__c in :queriedRateCardsIds';
				List<cspmb__Rate_Card_Line__c> rateCardLines = Database.query(queryString);
				Map<cspmb__Rate_Card__c, List<cspmb__Rate_Card_Line__c>> rateCardLineMap = new Map<cspmb__Rate_Card__c, List<cspmb__Rate_Card_Line__c>>();
				for (cspmb__Rate_Card_Line__c rcl : rateCardLines) {
					if (rateCardLineMap.get(rateCardMap.get(rcl.cspmb__Rate_Card__c)) == null) {
						rateCardLineMap.put(rateCardMap.get(rcl.cspmb__Rate_Card__c), new List<cspmb__Rate_Card_Line__c>());
					}
					rateCardLineMap.get(rateCardMap.get(rcl.cspmb__Rate_Card__c)).add(rcl);
				}
				List<Object> retList = new List<Object>();
				for (cspmb__Rate_Card__c rc : rateCardLineMap.keySet()) {
					Map<String, Object> rateCardValues = new Map<String, Object>();
					List<Map<String,String>> rcLinevalues = new List<Map<String,String>>();
					rateCardValues.put('Name', String.valueOf(rc.Name));
					rateCardValues.put('Id', String.valueOf(rc.Id));
					if (rc.Product_Configuration__c != null) {
						rateCardValues.put('Custom', 'config');
					} else if(rc.cspmb__Account__c != null){
						rateCardValues.put('Custom', 'account');
					} else {
						rateCardValues.put('Custom', 'false');
					}
					if (settings != null) {
						if(settings.Rate_Card_Fields__c != null) {
							List<String> rcFields = settings.Rate_Card_Fields__c.split(',');
							for (String fld : rcFields) {
								String label = cspmb__Rate_Card__c.SObjectType.getDescribe().fields.getMap().get(fld).getDescribe().getLabel();
								String value = rc.get(fld) != null ? String.valueOf(rc.get(fld)) : '';
								rateCardValues.put(label, value);
							}
						}
						if(settings.Editable_Rate_Card_Line_Fields__c != null) {
							List<String> editableRclFieldAPIs = settings.Editable_Rate_Card_Line_Fields__c.split(',');
							List<String> editableRclFieldLabels = new List<String>();
							for (String editableAPI : editableRclFieldAPIs) {
								editableRclFieldLabels.add(cspmb__Rate_Card_Line__c.SObjectType.getDescribe().fields.getMap().get(editableAPI).getDescribe().getLabel());
							}
							String editableLabels = String.join(editableRclFieldLabels, ',');
							rateCardValues.put('Editable', editableLabels);
						}
					}
					if (rateCardLineMap.get(rc) != null) {
						for (cspmb__Rate_Card_Line__c rcl : rateCardLineMap.get(rc)) {
							Map<String, String> rclVal = new Map<String, String>();
							if (settings != null && settings.Rate_Card_Line_Fields__c != null) {
								List<String> rclFields = settings.Rate_Card_Line_Fields__c.split(',');
								for (String rclFld : rclFields) {
									String label = cspmb__Rate_Card_Line__c.SObjectType.getDescribe().fields.getMap().get(rclFld).getDescribe().getLabel();
									String value = rcl.get(rclFld) != null ? String.valueOf(rcl.get(rclFld)) : '';
									rclVal.put(label, value);
								}
							}
							rclVal.put('Name', String.valueOf(rcl.Name));
							rclVal.put('Id', String.valueOf(rcl.Id));
							rcLinevalues.add(rclVal);
						}
					}
					rateCardValues.put('rateCardLines', rcLinevalues);
					retList.add(rateCardValues);
				}
				retVal = JSON.serialize(retList);

				if (settings.Save_as_JSON__c) {
					List<Attachment> customRateCards = [SELECT Id, Name, Body, ParentId FROM Attachment WHERE ParentId = :configId];
					for(Attachment customRateCard : customRateCards) {
						String jsonObject = '{\"Id\":\"' + customRateCard.Id + '\",' + customRateCard.Body.toString().removeStart('{');
						retVal = retval.removeEnd(']') + ',' + jsonObject + ']';
					}
				}
			}
		} catch(Exception e) {
			retVal = 'Error - ' + e.getMessage();
		}

		return retVal;
	}

	@RemoteAction
	global static String cloneRateCard(Id configId, Id priceItem, Id accountId, String option, String rateCardJSON) {
		try {
			Rate_Card_Widget_Settings__c settings = Rate_Card_Widget_Settings__c.getValues(option);
			if(settings.Save_as_JSON__c) {
				return cloneRateCardAsJSON(configId, rateCardJSON);
			} else {
				return cloneRateCardAsRateCardObject(configId, priceItem, accountId, rateCardJSON);
			}
		} catch (Exception e) {
			return e.getCause() + ': ' + e.getMessage() + ': ' + e.getStackTraceString();
		}
	}

	private static String cloneRateCardAsJSON(Id configId, String rateCardJSON) {
		Map<String, Object> rateCardMap = (Map<String, Object>) ((List<Object>) JSON.deserializeUntyped(rateCardJSON)).get(0);
		String jsonObject = rateCardJSON.removeStart('[').removeEnd(']');
		Attachment customRateCard = new Attachment(Name = (String) rateCardMap.get('Name'), Body = Blob.valueOf(jsonObject), ParentId = configId);
		insert customRateCard;

		return customRateCard.Id;
	}

	private static String cloneRateCardAsRateCardObject(Id configId, Id priceItem, Id accountId, String rateCardJSON) {
		//Fill variables above by parsing JSON
		ParsedRateCardWrapper parsedRateCard = customRateCardJSONParser(rateCardJSON);

		parsedRateCard.rateCard.Product_Configuration__c = configId;
		parsedRateCard.rateCard.Price_Item__c = priceItem;
		parsedRateCard.rateCard.cspmb__Account__c = accountId;

		insert parsedRateCard.rateCard;

		if(!parsedRateCard.rateCardLines.isEmpty()) {
			for(cspmb__Rate_Card_Line__c customRateCardLine : parsedRateCard.rateCardLines) {
				customRateCardLine.cspmb__Rate_Card__c = parsedRateCard.rateCard.Id;
			}

			insert parsedRateCard.rateCardLines;
		}

		return parsedRateCard.rateCard.Id;
	}

	@RemoteAction
	global static String editRateCard(Id configId, Id priceItem, Id accountId, String option, String rateCardJSON) {
		try {
			Rate_Card_Widget_Settings__c settings = Rate_Card_Widget_Settings__c.getValues(option);
			if(settings.Save_as_JSON__c) {
				return editRateCardAsJSON(rateCardJSON);
			} else {
				return editRateCardAsRateCardObject(rateCardJSON);
			}
		} catch (Exception e) {
			return e.getCause() + ': ' + e.getMessage() + ': ' + e.getStackTraceString();
		}
	}

	private static String editRateCardAsJSON(String rateCardJSON) {
		Map<String, Object> rateCardMap = (Map<String, Object>) ((List<Object>) JSON.deserializeUntyped(rateCardJSON)).get(0);
		String jsonObject = rateCardJSON.removeStart('[').removeEnd(']');
		Attachment customRateCard = [SELECT Id, Name FROM Attachment WHERE Id = :(String) rateCardMap.get('Id')];
		customRateCard.Body = Blob.valueOf(jsonObject);
		update customRateCard;

		return customRateCard.Id;
	}

	private static String editRateCardAsRateCardObject(String rateCardJSON) {
		//Fill variables above by parsing JSON
		ParsedRateCardWrapper parsedRateCard = customRateCardJSONParser(rateCardJSON);

		delete [SELECT Id FROM cspmb__Rate_Card_Line__c WHERE cspmb__Rate_Card__c = :parsedRateCard.rateCardId];

		if(!parsedRateCard.rateCardLines.isEmpty()) {
			for(cspmb__Rate_Card_Line__c customRateCardLine : parsedRateCard.rateCardLines) {
				customRateCardLine.cspmb__Rate_Card__c = parsedRateCard.rateCardId;
			}

			insert parsedRateCard.rateCardLines;
		}

		return parsedRateCard.rateCardId;
	}

	@TestVisible
	private class ParsedRateCardWrapper {
		@TestVisible Id rateCardId { get; set; }
		@TestVisible cspmb__Rate_Card__c rateCard { get; set; }
		@TestVisible List<cspmb__Rate_Card_Line__c> rateCardLines { get; set; }
	}

	private static ParsedRateCardWrapper customRateCardJSONParser(String rateCardJSON) {
		ParsedRateCardWrapper parsedRateCard = new ParsedRateCardWrapper();

		Map<String, Object> rateCardMap = (Map<String, Object>) ((List<Object>) JSON.deserializeUntyped(rateCardJSON)).get(0);

		//Map which maps Rate Card Line's Label --> Api
		Map<String, String> mapRclLabelToApi = new Map<String, String>();

		//Map which maps Rate Card Line's Api --> Type
		Map<String, Schema.DisplayType> mapRclApiToType = new Map<String, Schema.DisplayType>();

		//Populate maps above
		Map<String, Schema.SObjectField> rclFields = Schema.SObjectType.cspmb__Rate_Card_Line__c.fields.getMap();
		for(String api : rclFields.keySet()) {
		    mapRclLabelToApi.put(rclFields.get(api).getDescribe().getLabel(), api);
		    mapRclApiToType.put(api, rclFields.get(api).getDescribe().getType());
		}

		//Create new custom rate card from JSON
		parsedRateCard.rateCard = new cspmb__Rate_Card__c(Name = (String) rateCardMap.get('Name'));

		//For editing add Id
		if(rateCardMap.containsKey('Id')) {
			parsedRateCard.rateCardId = (Id) rateCardMap.get('Id');
		}

		parsedRateCard.rateCardLines = new List<cspmb__Rate_Card_Line__c>();

		for(Object rateCardLineMap : (List<Object>) rateCardMap.get('rateCardLines')) {
		    sObject customRateCardLine = new cspmb__Rate_Card_Line__c();

		    //Going though fields which can be populated
		    for(String label : ((Map<String, Object>)rateCardLineMap).keySet()) {
				String key = label == 'Name' ? 'name' : mapRclLabelToApi.get(label);
		        String value = (String) ((Map<String, Object>)rateCardLineMap).get(label);

		        //Checking field type of field
		        if(mapRclApiToType.get(key) == Schema.DisplayType.Double) {
		            customRateCardLine.put(key, Decimal.valueOf(value));
		        } else {
		            customRateCardLine.put(key, value);
		        }
		    }
		    parsedRateCard.rateCardLines.add((cspmb__Rate_Card_Line__c) customRateCardLine);
		}

		return parsedRateCard;
	}

	@RemoteAction
	global static String deleteRateCard(String option, Id rateCardId) {
		try {
			Rate_Card_Widget_Settings__c settings = Rate_Card_Widget_Settings__c.getValues(option);
			if(settings.Save_as_JSON__c) {
				return deleteRateCardAsJSON(rateCardId);
			} else {
				return deleteRateCardAsRateCardObject(rateCardId);
			}
		} catch (Exception e) {
			return e.getCause() + ': ' + e.getMessage() + ': ' + e.getStackTraceString();
		}
	}

	private static String deleteRateCardAsJSON(Id rateCardId) {
		Attachment rateCard = [SELECT Id FROM Attachment WHERE Id = :rateCardId LIMIT 1];
		delete rateCard;

		return 'Success';
	}

	private static String deleteRateCardAsRateCardObject(Id rateCardId) {
		cspmb__Rate_Card__c rateCard = [SELECT Id FROM cspmb__Rate_Card__c WHERE Id = :rateCardId LIMIT 1];
		List<cspmb__Rate_Card_Line__c> rateCardLines = [SELECT Id FROM cspmb__Rate_Card_Line__c WHERE cspmb__Rate_Card__c = :rateCardId];

		delete rateCard;

		if(!rateCardLines.isEmpty()) {
			delete rateCardLines;
		}
		return 'Success';
	}

}