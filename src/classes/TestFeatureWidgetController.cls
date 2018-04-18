@isTest
public class TestFeatureWidgetController {

	static testmethod void testFeatureMethods() {
		cspmb__Feature__c feature = new cspmb__Feature__c(
			Name = 'Test',
			cspmb__Feature_Description__c = 'Test'
		);
		insert feature;

		cspmb__Price_Item__c priceItem = new cspmb__Price_Item__c(
			Name = 'Test'
		);
		insert priceItem;

		cspmb__Price_Item_Feature_Association__c featureAssoc = new cspmb__Price_Item_Feature_Association__c(
			cspmb__Price_Item__c = priceItem.Id,
			cspmb__Feature__c = feature.Id
		);
		insert featureAssoc;

		Feature_Widget_Settings__c featureSettings = new Feature_Widget_Settings__c(
			Name = 'Test',
			Feature_Fields__c = 'cspmb__Feature_Description__c',
			Custom_Object__c = 'cspmb__Feature__c'
		);
		insert featureSettings;

		cscfga__Product_Definition__c pd = new cscfga__Product_Definition__c(
			Name = 'Test',
			cscfga__Description__c = 'Test',
			Add_On__c = 'Test',
			Feature__c = 'Test',
			Rate_Card__c = 'Test',
			Price_Item_Attribute__c = 'Test'
		);
		insert pd;

		cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c(
			cscfga__Product_Definition__c = pd.Id,
			Name = 'Test'
		);
		insert pc;

		// test feature retrieval
		String features = FeatureWidgetController.getAvaialbleFeatures(priceItem.Id, 'Test');

		// test delete -> cannot test properly due to missing relationship
		FeatureWidgetController.deletefeatures(pc.Id, 'Test');

		// test save -> cannot test properly due to missing relationship
		FeatureWidgetController.saveFeatures(pc.Id, new List<Id>{feature.Id}, 'Test');


	}

}