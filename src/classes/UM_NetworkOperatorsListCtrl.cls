public with sharing class UM_NetworkOperatorsListCtrl {
	public string region {get;set;}
	public map<string,wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier> networkOperators{get;set;}

	public UM_NetworkOperatorsListCtrl() {
		if(ApexPages.currentPage().getParameters().get('premiseId')!=null){
			Id premiseId = ApexPages.currentPage().getParameters().get('premiseId');
			if(premiseId!=null){
	       		cscrm__Address__c premiseaddress=[SELECT cscrm__Address_Details__c,cscrm__Zip_Postal_Code__c,cscrm__State_Province__c FROM cscrm__Address__c WHERE ID = :premiseId];
	        	region = premiseaddress.cscrm__State_Province__c;
			}
		}
	}

	public list<wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier> getNetworkOperatorsList(){
		list<wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier> operators = new list<wwwDialogikaDeWsdlInfportSchemasSf.tFnCarrier>();
		networkOperators = LG_NumberReservationUtil.fetchNetworkOperatorsList(region);

		if(networkOperators!=null && !networkOperators.isEmpty()){
			operators = networkOperators.values();
			operators.sort();
			return operators;
		}else{
			return null;
		}

	}
}