@isTest
public class UM_NetworkOperatorsListCtrlTest {

	@testSetup private static void setupData(){
		cscrm__Address__c address = new cscrm__Address__c();
		address.cscrm__City__c = 'Test';
		address.cscrm__Country__c= 'Test';
		address.cscrm__State_Province__c= 'Test';
		address.cscrm__Street__c= 'Test';
		address.cscrm__Zip_Postal_Code__c= 'Test';
		insert address;
		list<LG_PhoneNumbersIntegrationVariables__c> variables = new list<LG_PhoneNumbersIntegrationVariables__c>();

		LG_PhoneNumbersIntegrationVariables__c setting = new LG_PhoneNumbersIntegrationVariables__c();
		setting.name = 'LG_NumberStatusAvailable';
		setting.LG_Value__c = 'AVAILABLE';

		variables.add(setting);

		setting = new LG_PhoneNumbersIntegrationVariables__c();
		setting.name = 'LG_NumberStatusAllocated';
		setting.LG_Value__c = 'ALLOCATED';
		variables.add(setting);

		setting = new LG_PhoneNumbersIntegrationVariables__c();
		setting.name = 'LG_NumberOfShownNumbers';
		setting.LG_Value__c = '20';
		variables.add(setting);
		insert variables;

	}

	public static testMethod void testGetOperatorList() {
		cscrm__Address__c addr = [select id from cscrm__Address__c limit 1];
		ApexPages.currentPage().getParameters().put('premiseId',addr.id);
		UM_NetworkOperatorsListCtrl controller = new UM_NetworkOperatorsListCtrl();

		map<string,wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier> operators = new map<string,wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier> ();

		list<wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier> carriers = getOperatorData();
		operators.put(carriers[0].mainPortId,carriers[0]);

		controller.networkOperators = operators;

		System.assertEquals(carriers[0].mainPortId,controller.getNetworkOperatorsList()[0].mainPortId);
	}

	public static list<wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier> getOperatorData(){
		list<wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier> carriers = new list<wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier>();
		wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier carrier = new wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier();
		carrier.mainPortId = '123123';
		carrier.longName = 'Test Operator';
		carriers.add(carrier);
		return carriers;
	}


}