/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description Kenan Object is the base class for all Kenan Objects used in Salesforce Kenan Connection Service
*/
public virtual class KenanObject {

	/*
	Salesforce Org Id
	*/
	public String salesforceOrgId { get; set; }
	public String salesforceObjectId { get; set; }
	public Map<String, Object> extData { get; set; }
	
}