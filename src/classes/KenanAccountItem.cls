/**
* @author Copyright(c) Amdocs Development Limited 2016. All rights reserved.
* @date 2016
* @description KenanAccountItem for use in Salesforce Kenan Connection Service
*/
public with sharing class KenanAccountItem extends KenanObject {
	
	public KenanAccountItem() {
		this.serviceExternalIdType = 2;
	}
	
	/**
	* @description The Salesforce recordId for the Service this Item is to be attached
	*/
	public String serviceExternalId { get; set; }
	
	/**
	* @description The Id Type for the Salesforce recordId for the Service this Item is to be attached. The defualt value is 2
	*/
	public Integer serviceExternalIdType { get; set; }
	
	/**
	* @description
	*/
	public DateTime activeDate { get; set; } //(string, optional),
	
	/**
	* @description
	*/
	public String annotation { get; set; } //(string, optional),
	
	/**
	* @description
	*/
	public String annotation2 { get; set; } //(string, optional),
	
	/**
	* @description Currency Code for this record
	* RateCurrencyBean__mdt
	*/ 
	public String currencyCode { get; set; } //(integer, optional),
	
	/**
	* @description
	*/
	public DateTime inactiveDate { get; set; } //(string, optional),
	
	/**
	* @description
	*/
	public String instanceId { get; set; } //(string, optional),
	
	/**
	* @description
	*/
	public Integer itemId { get; set; } //(integer, optional),
	
	/**
	* @description
	*/
	public Integer itemType { get; set; } //(integer, optional),
	
	/**
	* @description rate for the Service Item. This value will be multiplied or divided by 100 by the connector
	*/
	public Decimal rate { get; set; } //(integer, optional),
	
	/**
	* @description
	*/
	public String salesforceId { get; set; } //(string, optional)

	/**
	* @description
	*/
	public Integer units { get; set; } //(integer, optional)

	/**
	* @description Unit Type for units based items. Valid Values are stored in UnitsTypeBean__mdt Custom Metadata Type
	*/
	public String unitsType { get; set; } //(integer, optional)

	/**
	* @description
	*/
	public String nrcParentRcInstanceId { get; set; }

	/**
	* @description
	*/
	public Decimal discountAmount { get; set; }
    
    /**
	* @description
	*/
    public Decimal discountPercent { get; set; }
    
    /**
	* @description
	*/
    public Decimal unitCreditUnitsFree { get; set; }
    
    /**
	* @description
	*/
    public Decimal unitCreditAmountFree { get; set; }
    
    /**
	* @description
	*/
    public Integer contractLevel { get; set; }

	
	/**
	* @description
	*/
	public KenanServiceItem rcAssociatedNrc { get; set; }
	
	public Map<String, Object> getAttributes() {
		return (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(this));
	}
}