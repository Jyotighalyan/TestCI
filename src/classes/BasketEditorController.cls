global with sharing class BasketEditorController {

	public String params {get; set;}

	public BasketEditorController() {
		this.params = JSON.serialize(ApexPages.currentPage().getParameters());
	}

	public BasketEditorController(ApexPages.StandardController controller) {
		this.params = JSON.serialize(ApexPages.currentPage().getParameters());
	}

	@RemoteAction
	global static String getCategoriesAndPriceItemAttributeName(Id productDefinitionId) {
		cscfga__Product_Definition__c productDefinition = [
			select Add_On__c, Feature__c, Rate_Card__c, Price_Item_Attribute__c
			from cscfga__Product_Definition__c
			where Id = :productDefinitionId limit 1
		];

		/*
		String response = '{';
		response += '"AddOn":' + '"' + productDefinition.Add_On__c + '"';
		response += ',' + '"Feature":' + '"' +  productDefinition.Feature__c + '"';
		response += ',' + '"RateCard":' + '"' +  productDefinition.Rate_Card__c + '"';
		response += ',' + '"PriceItemAttribute":' + '"' +  productDefinition.Price_Item_Attribute__c + '"';
		response += '}';
		*/
		Map<String, Map<String, String>> attributeMap = new Map<String, Map<String, String>>();
		if (productDefinition.Add_On__c != null && productDefinition.Add_On__c != '') {
			List<String> categories = productDefinition.Add_On__c.split(',');
			for (String cat : categories) {
				if (attributeMap.get(cat) == null) {
					attributeMap.put(cat, new Map<String, String>());
				}
				Add_On_Widget_Settings__c settings = Add_On_Widget_Settings__c.getValues(cat);
				if (settings != null) {
					if (settings.Parent_Attribute__c != null && settings.Parent_Attribute__c != '') {
						attributeMap.get(cat).put('ParentAttribute', settings.Parent_Attribute__c);
					} else {
						attributeMap.get(cat).put('ParentAttribute', '');
					}
					if (settings.Add_On_Attribute__c != null && settings.Add_On_Attribute__c != '') {
						attributeMap.get(cat).put('AddOnAttribute', settings.Add_On_Attribute__c);
					} else {
						attributeMap.get(cat).put('AddOnAttribute', '');
					}
				}
			}
		}
		Map<String, Object> responseMap = new Map<String, Object>();
		responseMap.put('AddOn', attributeMap);
		responseMap.put('Feature', productDefinition.Feature__c);
		responseMap.put('RateCard', productDefinition.Rate_Card__c);
		if (productDefinition.Price_Item_Attribute__c != null && productDefinition.Price_Item_Attribute__c != '') {
			productDefinition.Price_Item_Attribute__c = productDefinition.Price_Item_Attribute__c.replaceAll(' ', '_');
		}
		responseMap.put('PriceItemAttribute', productDefinition.Price_Item_Attribute__c);


		String response = JSON.serialize(responseMap);
		return response;
	}
}