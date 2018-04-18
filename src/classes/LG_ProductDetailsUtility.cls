public class LG_ProductDetailsUtility 
{
	public static void CreateProductDetails(Set<string> setProductBasketId)
	{
		List<cscfga__Attribute__c> lstAttribute = [SELECT Id, cscfga__is_active__c, cscfga__Line_Item_Sequence__c, 
                                        			cscfga__Product_Configuration__c, cscfga__Product_Configuration__r.cscfga__Product_Basket__c, 
                                        			cscfga__Product_Configuration__r.cscfga__Product_Family__c, cscfga__Value__c , cscfga__Attribute_Definition__r.LG_OPTKey__c, 
                                        			cscfga__Attribute_Definition__r.LG_ProductDetailType__c
                                        			FROM cscfga__Attribute__c
                                        			WHERE cscfga__is_active__c=true AND cscfga__Attribute_Definition__r.LG_OPTKey__c!=null 
                                        			AND	cscfga__Product_Configuration__r.cscfga__Product_Basket__c in : setProductBasketId];
		
		//System.debug('***lstAttribute=' + lstAttribute);
		
		Map<Id,cscfga__Product_Basket__c> mapBasket = new Map<Id,cscfga__Product_Basket__c>([select Id,	cscfga__Opportunity__c
			from cscfga__Product_Basket__c where Id=:setProductBasketId]);
			
		//System.debug('***mapBasket=' + mapBasket);
		
		List<LG_ProductDetail__c> lstProductDetail = new List<LG_ProductDetail__c>();
		
		
		//this logic suggests that Attribute can be either 'Order Detail' or 'Bundle Detail'
		//'Bundle Detail' will have Attribute Field (as there are only few)
		//'Order Detail' will not have attribute field
		//but both will have OPT Key field on Attribute NON null
		
		for (cscfga__Attribute__c tmpAttribute : lstAttribute)
		{
			//System.debug('***tmpAttribute=' + tmpAttribute.Id + ', ' + tmpAttribute);

			LG_ProductDetail__c tmpProductDetail = new LG_ProductDetail__c();
			
			tmpProductDetail.LG_Attribute__c=tmpAttribute.Id;
			tmpProductDetail.LG_Name__c=tmpAttribute.cscfga__Attribute_Definition__r.LG_OPTKey__c;
			tmpProductDetail.LG_Opportunity__c=mapBasket.get(tmpAttribute.cscfga__Product_Configuration__r.cscfga__Product_Basket__c).cscfga__Opportunity__c;
			tmpProductDetail.LG_Product__c=tmpAttribute.cscfga__Product_Configuration__r.cscfga__Product_Family__c;
			tmpProductDetail.LG_Sequence__c=tmpAttribute.cscfga__Line_Item_Sequence__c;
			
			if (tmpAttribute.cscfga__Attribute_Definition__r.LG_ProductDetailType__c=='' || tmpAttribute.cscfga__Attribute_Definition__r.LG_ProductDetailType__c==null) {
			    tmpProductDetail.LG_Type__c='Order Detail';
			}
			else {
				tmpProductDetail.LG_Type__c=tmpAttribute.cscfga__Attribute_Definition__r.LG_ProductDetailType__c;
			}

			tmpProductDetail.LG_Value__c=tmpAttribute.cscfga__Value__c;

			//System.debug('***tmpProductDetail=' + tmpProductDetail);

			lstProductDetail.add(tmpProductDetail);
		}
		
		//System.debug('***lstProductDetail=' + lstProductDetail);
		
		if (lstProductDetail.size()>0) insert lstProductDetail;
	}
	
	/*
	 * Deprecated
	 * 
     * There can be only one synced basket per opportunity. Therefore delete all product details for the opportunity. They will all be recreated on sync
	*/
	public static void DeleteProductDetails(Set<string> setProductBasketId)
	{
        List<cscfga__Product_Basket__c> pb = [SELECT Id, cscfga__Opportunity__c FROM cscfga__Product_Basket__c WHERE Id in : setProductBasketId];

		Set<Id> opportunityIds = new Set<Id>();

		for (cscfga__Product_Basket__c b : pb) {
			opportunityIds.add(b.cscfga__Opportunity__c);
		}

		List<LG_ProductDetail__c> lstProductDetail = [SELECT Id FROM LG_ProductDetail__c WHERE LG_Opportunity__c in : opportunityIds];
		
        if (lstProductDetail.size() > 0) {
            delete lstProductDetail;
        }
	}
	
	/*
     * There can be only one synced basket per opportunity. Therefore delete all product details for the opportunity. They will all be recreated on sync
	*/
	public static void DeleteProductDetails(Set<string> setProductBasketId, List<cscfga__Product_Basket__c> lstNewPB)
	{
	    Set<Id> opportunityIds = new Set<Id>();
	    
        for (cscfga__Product_Basket__c pb :lstNewPB) {
            
            if (setProductBasketId.contains(pb.Id)) {
                opportunityIds.add(pb.cscfga__Opportunity__c);
            }
        }

        if (opportunityIds.size() > 0) 
        {
    		List<LG_ProductDetail__c> lstProductDetail = [SELECT Id FROM LG_ProductDetail__c WHERE LG_Opportunity__c in : opportunityIds];
    		
    		system.debug('--+ lstProductDetail: '+lstProductDetail);

            if (lstProductDetail.size() > 0) {
                delete lstProductDetail;
            }
        }
	}
}