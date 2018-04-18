@isTest
public class TestBasketEditorController {

	static testmethod void controllerTest() {
		cscfga__Product_Definition__c pd = new cscfga__Product_Definition__c(
			Name = 'Test',
			cscfga__Description__c = 'Test',
			Add_On__c = 'Test',
			Feature__c = 'Test',
			Rate_Card__c = 'Test',
			Price_Item_Attribute__c = 'Test'
		);
		insert pd;

		Add_On_Widget_Settings__c addOnSettings = new Add_On_Widget_Settings__c(
			Parent_Attribute__c = 'Parent',
			Add_On_Attribute__c = 'AddOn',
			Name = 'Test'
		);
		insert addOnSettings;

		// Test constructor
		ApexPages.StandardController sc = new ApexPages.StandardController(pd);
		BasketEditorController ctrl = new BasketEditorController();
		ctrl = new BasketEditorController(sc);

		// Category and Price Item data retrieval
		String str = BasketEditorController.getCategoriesAndPriceItemAttributeName(pd.Id);
	}
}