@isTest
public class TestAddOnWidgetController {

	static testmethod void testFeatureMethods() {
		cspmb__Add_On_Price_Item__c api = new cspmb__Add_On_Price_Item__c(
			Name = 'Test'
		);
		insert api;

		cspmb__Price_Item__c priceItem = new cspmb__Price_Item__c(
			Name = 'Test'
		);
		insert priceItem;

		cspmb__Price_Item_Add_On_Price_Item_Association__c piAssoc = new cspmb__Price_Item_Add_On_Price_Item_Association__c(
			cspmb__Price_Item__c = priceItem.Id,
			cspmb__Add_On_Price_Item__c = api.Id
		);
		insert piAssoc;

		Add_On_Widget_Settings__c addOnSettings = new Add_On_Widget_Settings__c(
			Parent_Attribute__c = 'Test',
			Add_On_Attribute__c = 'Test',
			Add_On_Fields__c = 'cspmb__Add_On_Price_Item_Description__c,cspmb__One_Off_Charge__c',
			Add_On_Definition__c = 'AddOn',
			Name = 'Test'
		);
		insert addOnSettings;

		Add_On_Widget_Settings__c addOnSettings2 = new Add_On_Widget_Settings__c(
			Name = 'Test1'
		);
		insert addOnSettings2;

		cscfga__Product_Definition__c pd = new cscfga__Product_Definition__c(
			Name = 'Test',
			cscfga__Description__c = 'Test',
			Add_On__c = 'Test',
			Feature__c = 'Test',
			Rate_Card__c = 'Test',
			Price_Item_Attribute__c = 'Test',
			cscfga__Active__c = true
		);
		insert pd;

		cscfga__Attribute_Definition__c att = new cscfga__Attribute_Definition__c(
			Name = 'Test',
			cscfga__Product_Definition__c = pd.Id
		);
		insert att;

		cscfga__Product_Definition__c pd1 = new cscfga__Product_Definition__c(
			Name = 'AddOn',
			cscfga__Description__c = 'Test',
			Add_On__c = 'Test',
			Feature__c = 'Test',
			Rate_Card__c = 'Test',
			Price_Item_Attribute__c = 'Test',
			cscfga__Active__c = true
		);
		insert pd1;

		cscfga__Attribute_Definition__c att1 = new cscfga__Attribute_Definition__c(
			Name = 'Test',
			cscfga__Product_Definition__c = pd1.Id
		);
		insert att1;

		cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c(
			cscfga__Product_Definition__c = pd.Id,
			Name = 'Test'
		);
		insert pc;


		cscfga__Attribute__c att3 = new cscfga__Attribute__c(
			cscfga__Product_Configuration__c = pc.Id,
			Name = 'Test',
			cscfga__Attribute_Definition__c = att.Id
		);
		insert att3;

		// test feature retrieval
		String features = AddOnWidgetController.getAvaialbleAddOns(priceItem.Id, 'Test', null);
	}

}