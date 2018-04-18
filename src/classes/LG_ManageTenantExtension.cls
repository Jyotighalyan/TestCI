public class LG_ManageTenantExtension {
    private final Case cs { get; set; }
	public Account tenantAccount {get; set;}
	public Contact tenantContact {get; set;}
    //public csord__Solution__c solutionObject { get; set; }
    public csord__Order__c orderObject { get; set; } 
    public Boolean isClosed {get; set;}
    public Boolean isEditMode {get; set;}
    
    public LG_ManageTenantExtension (ApexPages.StandardController stdController) {
    	isEditMode = false;
    	List<String> defaultFields = new List<String>();
        if(!Test.isRunningTest())
        {
            stdController.addFields(getFieldList());
        }
        this.cs = (Case)stdController.getRecord();
        orderObject = retriveOrderRecord();

        if(orderObject.csord__Account__c != null){
        	tenantAccount = 
        	[
        		SELECT Id, Name, LG_PostalStreet__c, LG_PostalHouseNumber__c, LG_PostalHouseNumberExtension__c, LG_PostalPostalCode__c, LG_PostalCity__c, LG_Huawei_Tenant_ID__c
        		FROM Account 
        		WHERE Id =: orderObject.csord__Account__c
        	];
        }
        if(orderObject.csordtelcoa__Opportunity__r.LG_PrimaryContact__c != null){
        	tenantContact = 
        	[
        		SELECT Id, LG_UserName__c, LG_Password__c, Name, Email,	MobilePhone, Phone
        		FROM Contact 
        		WHERE Id =: orderObject.csordtelcoa__Opportunity__r.LG_PrimaryContact__c
        	];
        }
        
        if(cs.status == 'Closed'){
        	isClosed = true;
        }
        
    }
	
	private csord__Order__c retriveOrderRecord(){
		csord__Order__c order = new csord__Order__c();
		if(this.cs.LG_Order__c != null){
			order = 
        	[
	        	SELECT Id, Name, Ownerid, csord__Status__c, csord__Account__c, csord__Account__r.Name, csordtelcoa__Opportunity__r.LG_PrimaryContact__c
	        	FROM csord__Order__c 
	        	WHERE Id = :this.cs.LG_Order__c
	        ];
		}
		return order;
	}
	
	/**
    private csord__Solution__c retrieveSolutionObject() {
   		csord__Solution__c solution = new csord__Solution__c();
        if (this.cs.LG_Solution__c != null) {
        	solution = 
        	[
	        	SELECT Id, Name, Ownerid, csord__Status__c, csord__Account__c, csord__Account__r.Name, LG_Address__r.LG_TechnicalContact__c,
	        		LG_Address__r.LG_TechnicalContact__r.Name, LG_Address__r.LG_TechnicalContact__r.Email, LG_Address__r.LG_TechnicalContact__r.MobilePhone, 
	        		LG_Address__r.LG_TechnicalContact__r.Phone, LG_Address__r.cscrm__Street_Name__c, LG_Address__r.LG_HouseNumber__c, 
	        		LG_Address__r.cscrm__State_Province__c, LG_Address__r.cscrm__Zip_Postal_Code__c, LG_Address__r.cscrm__City__c
	        	FROM csord__Solution__c 
	        	WHERE Id = :this.cs.LG_Solution__c
	        ];
        }
        return solution;
    }
    **/
    
    public void updateTenantDetails(){
    	if(tenantAccount != null)
    	update tenantAccount;
    	if(tenantContact != null)
    	update tenantContact;
    	isEditMode = false;
    }
 	
 	public void setEditMode(){
 		isEditMode = true;
 	}
 	
    public String getRecordType() {
        return this.cs.RecordType.Name;
    }
    
    public List<String> getFieldList(){
    	List<String> defaultFields = new List<String>();
        defaultFields.add('LG_Order__c');
        defaultFields.add('LG_Solution__c');
        defaultFields.add('RecordType.Name');
        defaultFields.add('Status');
        return defaultFields;
    }
    
}