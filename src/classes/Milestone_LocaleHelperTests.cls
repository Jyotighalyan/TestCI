@IsTest
public with sharing class Milestone_LocaleHelperTests {

	@IsTest
	static void testGetCurrencySymbolHtmlEntity() {
        System.assertEquals('&#163;', Milestone_LocaleHelper.getCurrencySymbolHtmlEntity('GBP'));
    }
}