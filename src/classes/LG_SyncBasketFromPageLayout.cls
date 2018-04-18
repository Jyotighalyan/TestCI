global class LG_SyncBasketFromPageLayout 
{
	webservice static string SynchronizeBasket(string ProductBasketId)
	{
		
		ProductBasketId = (string) (Id) ProductBasketId;
		system.debug('****ProductBasketId=' + ProductBasketId);

		cscfga__Product_Basket__c CurrentBasket = [select Id, csordtelcoa__Synchronised_with_Opportunity__c, cscfga__Opportunity__c
			from cscfga__Product_Basket__c where Id=:ProductBasketId][0];
		
		system.debug('****CurrentBasket before update=' + CurrentBasket);
		
		//de-sync first and then synce again
		if (CurrentBasket.csordtelcoa__Synchronised_with_Opportunity__c)
		{
			CurrentBasket.csordtelcoa__Synchronised_with_Opportunity__c=false;
			update CurrentBasket;
		}
		
		CurrentBasket.csordtelcoa__Synchronised_with_Opportunity__c=true;
		update CurrentBasket;
		
		system.debug('****CurrentBasket after update=' + CurrentBasket);
				
		
		
		/*
		list<Pricebook2> lstPriceBook = [select Id, IsActive, IsStandard from Pricebook2 where IsStandard=true];
		system.debug('****lstPriceBook=' + lstPriceBook);
		
		
		map<string,string> mapProductBasketIdPriceBookId = new map<string,string>();
		mapProductBasketIdPriceBookId.put(ProductBasketId,lstPriceBook[0].Id);
		system.debug('****mapProductBasketIdPriceBookId=' + mapProductBasketIdPriceBookId);
		
		LG_ProductUtility.DeleteOLIs(mapProductBasketIdPriceBookId.keySet());
		LG_ProductUtility.CreateOLIs(mapProductBasketIdPriceBookId);
		
		cscfga__Product_Basket__c CurrentBasket = [select Id, csordtelcoa__Synchronised_with_Opportunity__c, cscfga__Opportunity__c
			from cscfga__Product_Basket__c where Id=:ProductBasketId][0];
		
		
		
		system.debug('****CurrentBasket before update=' + CurrentBasket);
		
		CurrentBasket.csordtelcoa__Synchronised_with_Opportunity__c=true;
		update CurrentBasket;
		system.debug('****CurrentBasket after update=' + CurrentBasket);
		
		LG_ProductDetailsUtility.DeleteProductDetails(mapProductBasketIdPriceBookId.keySet());
		LG_ProductDetailsUtility.CreateProductDetails(mapProductBasketIdPriceBookId.keySet());
		*/
		
		return CurrentBasket.cscfga__Opportunity__c;
	}
}