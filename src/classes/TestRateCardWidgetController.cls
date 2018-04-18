@isTest
public class TestRateCardWidgetController {

	static testmethod void testRateCardMethods() {
		cspmb__Rate_Card__c rc = new cspmb__Rate_Card__c(
			Name = 'Test'
		);
		insert rc;

		cspmb__Rate_Card_Line__c rcl = new cspmb__Rate_Card_Line__c(
			Name = 'Test',
			cspmb__Off_Peak__c = 10,
			cspmb__Rate_Card__c = rc.Id
		);
		insert rcl;

		cspmb__Price_Item__c priceItem = new cspmb__Price_Item__c(
			Name = 'Test'
		);
		insert priceItem;

		cspmb__Price_Item_Rate_Card_Association__c rcAssoc = new cspmb__Price_Item_Rate_Card_Association__c(
			cspmb__Price_Item__c = priceItem.Id,
			cspmb__Rate_Card__c = rc.Id
		);
		insert rcAssoc;

		Rate_Card_Widget_Settings__c rcSettings = new Rate_Card_Widget_Settings__c(
			Name = 'Test',
			Rate_Card_Fields__c = 'cspmb__Is_Active__c',
			Rate_Card_Line_Fields__c = 'cspmb__Rate_Card_Line_Unit__c,cspmb__Weekend__c,cspmb__Off_Peak__c,cspmb__Peak__c',
			Editable_Rate_Card_Line_Fields__c = 'cspmb__Rate_Card_Line_Unit__c,cspmb__Weekend__c,cspmb__Off_Peak__c,cspmb__Peak__c'
		);
		insert rcSettings;

		Rate_Card_Widget_Settings__c rcSettings1 = new Rate_Card_Widget_Settings__c(
			Name = 'Test1',
			Rate_Card_Line_Fields__c = 'cspmb__Rate_Card_Line_Unit__c,cspmb__Weekend__c,cspmb__Off_Peak__c,cspmb__Peak__c',
			Editable_Rate_Card_Line_Fields__c = 'cspmb__Rate_Card_Line_Unit__c,cspmb__Weekend__c,cspmb__Off_Peak__c,cspmb__Peak__c',
			Save_as_JSON__c = true
		);
		insert rcSettings1;

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

		Map<String, Object> rcMap = new Map<String, Object>();
		rcMap.put('Name', 'Test');
		rcMap.put('rateCardLines', JSON.serialize(rcl));

		List<Object> objList = new List<Object>{rcMap};

		Test.startTest();

		RateCardWidgetController.ParsedRateCardWrapper rcWrapper = new RateCardWidgetController.ParsedRateCardWrapper();
		rcWrapper.rateCardId = rc.Id;
		rcWrapper.rateCard = rc;
		rcWrapper.rateCardLines = new List<cspmb__Rate_Card_Line__c>{rcl};

		// test rc get method
		String rateCards = RateCardWidgetController.getAvailableRateCards(null, priceItem.Id, null, 'Test');

		// test cloning
		String cloneResult = RateCardWidgetController.cloneRateCard(pc.Id, priceItem.Id, null, 'Test', JSON.serialize(objList));
		String cloneResult2 = RateCardWidgetController.cloneRateCard(pc.Id, priceItem.Id, null, 'Test1', JSON.serialize(objList));

		// test edit
		String editResult = RateCardWidgetController.editRateCard(pc.Id, priceItem.Id, null, 'Test', JSON.serialize(objList));
		String editResult2 = RateCardWidgetController.editRateCard(pc.Id, priceItem.Id, null, 'Test1', JSON.serialize(objList));

		// test delete
		String deleteResult = RateCardWidgetController.deleteRateCard('Test', rc.Id);
		String deleteResult2 = RateCardWidgetController.deleteRateCard('Test1', rc.Id);

		Test.stopTest();

	}

}