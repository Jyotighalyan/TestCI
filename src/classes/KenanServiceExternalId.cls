/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanServiceExternalId for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanServiceExternalId extends KenanObject {
	
	public KenanServiceExternalId() {
		
	}
		
	/*
	* @description DateTime the serviceExternalId will become active
	*/
	public DateTime activeDate { get; set;}
	
	/*
	* @description
	*/
	public DateTime createDt { get; set;}
	
	/*
	* @description DateTime the serviceExternalId will become inactive when used with ceaseId. If using swapId, this is the DateTime the olsServiceExternalId will become inactive.
	*/
	public DateTime inactiveDate { get; set;}
  	
	/*
	* @description
	*/
	public DateTime intendedViewEffectiveDt { get; set;}
  	
	/*
	* @description
	*/
	public Boolean isCurrent { get; set;}
  	
	/*
	* @description
	*/
	public Boolean isFromInventory { get; set;}
  	
	/*
	* @description
	*/
	public Integer prevViewId { get; set;}
  	
	/*
	* @description External Id to be added or modified to an existing service specified by the salesforceObjectId
	*/
	public String serviceExternalId { get; set;}
  	
	/*
	* @description External Id Type to be added or modified to an existing service specified by the salesforceObjectId
	*/
	public Integer serviceExternalIdType { get; set;}
	
	/*
	* @description External Id to be removed from an existing service specified by the salesforceObjectId. This will only be used for swapId
	*/
	public String oldServiceExternalId { get; set;}
  	
	/*
	* @description External Id Type to be removed from an existing service specified by the salesforceObjectId. This will only be used for swapId
	*/
	public Integer oldServiceExternalIdType { get; set;}
  	
	/*
	* @description
	*/
	public Integer serviceInternalId { get; set;}
  	
	/*
	* @description
	*/
	public Integer serviceInternalIdResets { get; set;}
  	
	///*
	//* @description
	//*/
	//public DateTime viewCreatedDt { get; set;}
  	
	///*
	//* @description
	//*/
	//public DateTime viewEffectiveDt { get; set;}
  	
	/*
	* @description
	*/
	public Integer viewId { get; set;}
  	
	/*
	* @description
	*/
	public Integer viewStatus { get; set;}
			
}