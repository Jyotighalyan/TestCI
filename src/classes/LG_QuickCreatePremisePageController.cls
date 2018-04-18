public class LG_QuickCreatePremisePageController {
	public string recId;
	public string lookupId; 
    public string prodDef;
    public LG_QuickCreatePremisePageController(){
        lookupId=ApexPages.currentPage().getParameters().get('lookupId');
        prodDef=ApexPages.currentPage().getParameters().get('productDefinitionId');
        string attributeVal=ApexPages.currentPage().getParameters().get('attributeValues');
        if(attributeVal!=null && attributeVal.contains('001'))
       		recId= attributeVal.substring(attributeVal.indexOf('=')+1);
    }
    
    public pageReference createNewPremise(){
        cscrm__Address__c objPremise=new cscrm__Address__c(Name='To be deleted');
        insert objPremise;
        string retURL='/apex/cscfga__Lookup?lookupId='+lookupId+'&productDefinitionId='+prodDef+'&attributeValues=AccountId='+recId+'&excludeIds=';
		string Country=LG_EnvironmentVariables__c.getOrgDefaults().IdField_BillingCountry__c;
		Pagereference pr=new PageReference('/apex/UM_ValidateAddress?id='+objPremise.Id+'&lookupId='+lookupId+'&isQuickCreatePremise=true&country=' + Country +'&accId='+ recId+'&returnURL=' + retURL);
		pr.setRedirect(true);
		pr.getParameters().put('productDefinitionId',prodDef);
        return pr;
    }
}