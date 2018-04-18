/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanAccountExternalId for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanAccountExternalId extends KenanObject {
	
	public KenanAccountExternalId() {
		
	}

	/*
	* @description External Id to be added or modified to an existing account specified by the salesforceObjectId
	*/
	public String accountExternalId { get; set;}
  	
	/*
	* @description External Id Type to be added or modified to an existing account specified by the salesforceObjectId
	*/
	public Integer accountExternalIdType { get; set;}

	/*
	* @description External Id to be added or modified to an existing account specified by the salesforceObjectId
	*/
	public String oldAccountExternalId { get; set;}
  	
	/*
	* @description External Id Type to be added or modified to an existing account specified by the salesforceObjectId
	*/
	public Integer oldAccountExternalIdType { get; set;}

	/*
	* @description
	*/
	public Integer accountInternalId { get; set;}
  	
	/*
	* @description DateTime the serviceExternalId will become active
	*/
	public DateTime activeDate { get; set;}
	
	/*
	* @description DateTime the serviceExternalId will become inactive when used with ceaseId. If using swapId, this is the DateTime the olsServiceExternalId will become inactive.
	*/
	public DateTime inactiveDate { get; set;}

	/*
	* @description
	*/
	public Boolean isCurrent { get; set;}
  	
}