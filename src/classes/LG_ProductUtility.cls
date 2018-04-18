public class LG_ProductUtility {

    private static Map<Schema.SObjectType, Map<String, Schema.DescribeFieldResult>> mapFieldDescribeToObject =
        new Map<Schema.sObjectType, Map<String, Schema.DescribeFieldResult>>();

    private static Map<Schema.SObjectType, Schema.DescribeSObjectResult> mapObjectDescribe =
        new Map<Schema.SObjectType, Schema.DescribeSObjectResult>();

    private static Map<sObjectType, Map<String, Schema.SObjectField>> mapFieldsToObject =
        new Map<sObjectType, Map<String, Schema.SObjectField>>();

    public static void CreateOLIs(Set<string> setProductBasketId) {
        /*
        --select all attributes which are line items
        --check if combinations of Product Family and Line Item Description exist in Product2
        --for the ones which do exist - get Product2.Id
        --for the others - insert and get Product2.Id

        --select standard price book

        --check if there is an existing combination of PriceBook and Product2 in PriceBookEntry
        --if it doesn't exist - create and get PriceBookEntry.Id
        --if it does exist - get PriceBookEntry.Id

        -- enter all PriceBookEntries into OLIs
        */

        Map<string, string> mapProductBasketIdPriceBookId = new LG_AssignnPriceBookToProductBasketImpl().AssignPriceBook(setProductBasketId);


        List<cscfga__Attribute__c> lstAttribute = [SELECT Id, cscfga__is_active__c, cscfga__Is_Line_Item__c, cscfga__Line_Item_Description__c, cscfga__Line_Item_Sequence__c,
                                   cscfga__Price__c, cscfga__List_Price__c, cscfga__Product_Configuration__c, cscfga__Product_Configuration__r.cscfga__Product_Basket__c,
                                   cscfga__Product_Configuration__r.cscfga__Product_Family__c, Name , cscfga__Recurring__c, cscfga__Attribute_Definition__r.cscfga__Line_Item_Sequence__c,
                                   cscfga__Attribute_Definition__r.LG_OLIType__c
                                   FROM cscfga__Attribute__c
                                   WHERE cscfga__Is_Line_Item__c = true AND cscfga__is_active__c = true AND
                                           cscfga__Product_Configuration__r.cscfga__Product_Basket__c in : mapProductBasketIdPriceBookId.keyset()];

        //System.debug('****lstAttribute=' + lstAttribute);

        //this is the map where the keys are: ProductFamily and ProductName (LineItemDescription)
        Map<string, Map<string, Product>> mapProductFamilymapProduct = CreateProducts2(lstAttribute);
        //System.debug('****mapProductFamilymapProduct=' + mapProductFamilymapProduct);

        //this is the map where the keys are: PriceBookId and Product2Id
        Map<string, Map<string, PBEntry>> mapPriceBookIdmapPBEntry = MakePriceBookPBEntriesMap(mapProductBasketIdPriceBookId, lstAttribute, mapProductFamilymapProduct);
        //System.debug('****MakePriceBookPBEntriesMap mapPriceBookIdmapPBEntry=' + mapPriceBookIdmapPBEntry);

        //this function is void because it just modifies mapPriceBookIdmapPBEntry, so no need for return
        CreatePriceBookEntries(mapPriceBookIdmapPBEntry);
        //System.debug('****CreatePriceBookEntries mapPriceBookIdmapPBEntry=' + mapPriceBookIdmapPBEntry);

        //this function takes all structures created before and generates OLIs
        CreateOLIs(mapProductBasketIdPriceBookId, lstAttribute, mapProductFamilymapProduct, mapPriceBookIdmapPBEntry);
    }

    private static void CreateOLIs(Map<string, string> mapProductBasketIdPriceBookId, List<cscfga__Attribute__c> lstAttribute, Map<string, Map<string, Product>> mapProductFamilymapProduct, Map<string, Map<string, PBEntry>> mapPriceBookIdmapPBEntry) {

        List<OpportunityLineItem> lstOLI = new List<OpportunityLineItem>();

        Set<Id> productConfigurationIds = new Set<Id>();
        Set<Id> attributeItemsIds = new Set<Id>();
        Set<string> setProductBasketId = new Set<string>();
        Set<string> segment = new Set<string> { 'small', 'soho' };
        Set<string> productDetail = new Set<string> { 'ProductDetail' };

        for (cscfga__Attribute__c tmpAttribute : lstAttribute) {
            setProductBasketId.add(tmpAttribute.cscfga__Product_Configuration__r.cscfga__Product_Basket__c);
            productConfigurationIds.add(tmpAttribute.cscfga__Product_Configuration__c);
        }

        // Get all Line Item Id's
        for (cscfga__Attribute__c a : lstAttribute) {

            if (a.cscfga__Is_Line_Item__c == true) {
                attributeItemsIds.add(a.Id);
            }
        }

        Set<string> attributeNames = new Set<string> { 'Segment', 'ProductDetail', 'Quantity', 'OLIType' };
        List<cscfga__Attribute_Field__c> attributeFields = [SELECT Id, Name, cscfga__Attribute__c, cscfga__Value__c FROM cscfga__Attribute_Field__c WHERE Name IN :attributeNames AND cscfga__Attribute__c IN :attributeItemsIds];

        Map<Id, cscfga__Product_Basket__c> mapProductBasket = new Map<Id, cscfga__Product_Basket__c>([SELECT Id, cscfga__Opportunity__c FROM cscfga__Product_Basket__c WHERE Id in : setProductBasketId]);

        Map<Id, cscfga__Product_Configuration__c> productConfigurations = new Map<Id, cscfga__Product_Configuration__c>([SELECT Id, LG_Address__c, cscfga__Root_Configuration__c, cscfga__Root_Configuration__r.LG_Address__c FROM cscfga__Product_Configuration__c WHERE Id IN :productConfigurationIds]);

        //System.debug('****mapProductBasket: ' + mapProductBasket);

        for (cscfga__Attribute__c tmpAttribute : lstAttribute) {

            Boolean MainOLI = false;
            string Type = null;

            if (tmpAttribute.cscfga__Attribute_Definition__r.LG_OLIType__c == 'Main OLI') {
                MainOLI = true;
            } else if ((tmpAttribute.cscfga__Attribute_Definition__r.LG_OLIType__c == 'Promotional Discount') || (tmpAttribute.cscfga__Attribute_Definition__r.LG_OLIType__c == 'Promotional Action') || (tmpAttribute.cscfga__Attribute_Definition__r.LG_OLIType__c == 'Closing Deal')) {
                Type = tmpAttribute.cscfga__Attribute_Definition__r.LG_OLIType__c;
            }

            string tmpProductFamily = tmpAttribute.cscfga__Product_Configuration__r.cscfga__Product_Family__c;
            //System.debug('****tmpProductFamily=' + tmpProductFamily);

            string tmpLineItemDescription = LG_ProductUtility.RemoveAmpresand(tmpAttribute.cscfga__Line_Item_Description__c);
            //System.debug('****tmpLineItemDescription=' + tmpLineItemDescription);

            string tmpProductBasketId = tmpAttribute.cscfga__Product_Configuration__r.cscfga__Product_Basket__c;
            //System.debug('****tmpProductBasketId=' + tmpProductBasketId);

            string tmpPriceBookId = mapProductBasketIdPriceBookId.get(tmpProductBasketId);
            //System.debug('****tmpPriceBookId=' + tmpPriceBookId);

            double tmpUnitPrice = tmpAttribute.cscfga__Price__c;
            //System.debug('****tmpUnitPrice=' + tmpUnitPrice);

            Map<string, Product> mapProduct = mapProductFamilymapProduct.get(tmpProductFamily);
            //System.debug('****mapProduct=' + mapProduct);

            Product tmpProduct = mapProduct.get(tmpLineItemDescription);
            //System.debug('****tmpProduct=' + tmpProduct);

            string tmpProduct2Id = tmpProduct.Prod2.Id;
            //System.debug('****tmpProduct2Id=' + tmpProduct2Id);

            Map<string, PBEntry> mapPBEntry = mapPriceBookIdmapPBEntry.get(tmpPriceBookId);
            //System.debug('****mapPBEntry=' + mapPBEntry);

            PBEntry tmpPBEntry = mapPBEntry.get(tmpProduct2Id);
            //System.debug('****tmpPBEntry=' + tmpPBEntry);

            string tmpPriceBookEntryId = tmpPBEntry.PBE.Id;
            //System.debug('****tmpPriceBookEntryId=' + tmpPriceBookEntryId);

            string tmpOpportunityId = mapProductBasket.get(tmpProductBasketId).cscfga__Opportunity__c;
            //System.debug('****tmpOpportunityId=' + tmpOpportunityId);

            OpportunityLineItem tmpOpportunityLineItem = new OpportunityLineItem();

            tmpOpportunityLineItem.cscfga__Attribute__c = tmpAttribute.Id;
            tmpOpportunityLineItem.OpportunityId = tmpOpportunityId;
            tmpOpportunityLineItem.PricebookEntryId = tmpPriceBookEntryId;
            tmpOpportunityLineItem.LG_MainOLI__c = MainOLI;
            tmpOpportunityLineItem.Quantity = 1;

            double UnitPrice;

            if (tmpAttribute.cscfga__Price__c == null) {
                UnitPrice = 0;
            } else {
                UnitPrice = tmpAttribute.cscfga__Price__c;
            }
            
            if (tmpAttribute.cscfga__Recurring__c) {

                tmpOpportunityLineItem.UnitPrice = UnitPrice;
                tmpOpportunityLineItem.LG_OneOffPrice__c = 0; //this is implementation specific

                if (Type == null) {
                    tmpOpportunityLineItem.LG_Type__c = 'Recurring'; //this is implementation specific
                } else {
                    tmpOpportunityLineItem.LG_Type__c = Type;
                }

            } else {

                tmpOpportunityLineItem.UnitPrice = 0;
                tmpOpportunityLineItem.LG_OneOffPrice__c = UnitPrice; //this is implementation specific

                if (Type == null) {
                    tmpOpportunityLineItem.LG_Type__c = 'One Off'; //this is implementation specific
                } else {
                    tmpOpportunityLineItem.LG_Type__c = Type;
                }
            }

            // If attribute is line item copy segment value from Attribute_Definition to OpportunityLineItem (Opportunity Product Detail) and ticket SFDT-608 - Implement mapping
            if (tmpAttribute.cscfga__Is_Line_Item__c == true) {

                // Set Sequence__c
                if (tmpAttribute.cscfga__Attribute_Definition__c != null && tmpAttribute.cscfga__Attribute_Definition__r.cscfga__Line_Item_Sequence__c != null) {
                    tmpOpportunityLineItem.Sequence__c = tmpAttribute.cscfga__Attribute_Definition__r.cscfga__Line_Item_Sequence__c;
                } else {
                    tmpOpportunityLineItem.Sequence__c = tmpAttribute.cscfga__Line_Item_Sequence__c;
                }

                // Set LG_Address__c from Product Configuration
                if (tmpAttribute.cscfga__Product_Configuration__c != null && productConfigurations.keySet().contains(tmpAttribute.cscfga__Product_Configuration__c)) {

                    cscfga__Product_Configuration__c pc = productConfigurations.get(tmpAttribute.cscfga__Product_Configuration__c);

                    if (pc.cscfga__Root_Configuration__c != null && pc.cscfga__Root_Configuration__r.LG_Address__c != null) {

                        tmpOpportunityLineItem.LG_Address__c = pc.cscfga__Root_Configuration__r.LG_Address__c;
                    } else if (pc.LG_Address__c != null) {
                        tmpOpportunityLineItem.LG_Address__c = pc.LG_Address__c;
                    }
                }

                // Set Segment, quantity and product details
                for (cscfga__Attribute_Field__c a : attributeFields) {

                    if (tmpAttribute.Id == a.cscfga__Attribute__c && String.isNotBlank(a.cscfga__Value__c) && segment.contains(a.cscfga__Value__c.tolowercase())) {

                        tmpOpportunityLineItem.LG_Segment__c = a.cscfga__Value__c;
                    }

                    if (tmpAttribute.Id == a.cscfga__Attribute__c && String.isNotBlank(a.cscfga__Value__c) && productDetail.contains(a.Name)) {

                        tmpOpportunityLineItem.LG_ProductDetail__c = a.cscfga__Value__c;
                    }
                    
                    if (tmpAttribute.Id == a.cscfga__Attribute__c && String.isNotBlank(a.cscfga__Value__c) && a.Name == 'Quantity') {

                        tmpOpportunityLineItem.Quantity = decimal.valueOf(a.cscfga__Value__c);
                        
                        // SFDT-692 - Total Recurring price is displayed wrongly in the opportunity overview
                        if (tmpAttribute.cscfga__Recurring__c && tmpOpportunityLineItem.Quantity != 0) {
                            tmpOpportunityLineItem.UnitPrice = tmpOpportunityLineItem.UnitPrice / tmpOpportunityLineItem.Quantity;
                        }
                    }
                    
                    if (tmpAttribute.Id == a.cscfga__Attribute__c && String.isNotBlank(a.cscfga__Value__c) && a.Name == 'OLIType') {

                        tmpOpportunityLineItem.LG_OLIType__c = a.cscfga__Value__c;
                    }
                }
            }

            lstOLI.add(tmpOpportunityLineItem);
        }

        //System.debug('****beforelstOLI=' + lstOLI);

        if (lstOLI.size() > 0) {
            insert lstOLI;
        }

        //System.debug('****lstOLI=' + lstOLI);
    }


    private static Map<string, Map<string, PBEntry>> MakePriceBookPBEntriesMap(Map<string, string> mapProductBasketIdPriceBookId, List<cscfga__Attribute__c> lstAttribute, Map<string, Map<string, Product>> mapProductFamilymapProduct) {

        List<PBEntry> lstPBEntry = new List<PBEntry>();
        Map<string, Map<string, PBEntry>> mapPriceBookIdmapPBEntry = new Map<string, Map<string, PBEntry>>();

        //System.debug('****mapProductBasketIdPriceBookId=' + mapProductBasketIdPriceBookId);

        for (cscfga__Attribute__c tmpAttribute : lstAttribute) {

            string tmpProductFamily = tmpAttribute.cscfga__Product_Configuration__r.cscfga__Product_Family__c;
            //System.debug('****tmpProductFamily=' + tmpProductFamily);

            string tmpLineItemDescription = LG_ProductUtility.RemoveAmpresand(tmpAttribute.cscfga__Line_Item_Description__c);
            //System.debug('****tmpLineItemDescription=' + tmpLineItemDescription);

            string tmpProductBasketId = tmpAttribute.cscfga__Product_Configuration__r.cscfga__Product_Basket__c;
            //System.debug('****tmpProductBasketId=' + tmpProductBasketId);

            if (mapProductFamilymapProduct.containsKey(tmpProductFamily)) {
                Map<string, Product> mapProduct = mapProductFamilymapProduct.get(tmpProductFamily);

                if (mapProduct.containsKey(tmpLineItemDescription)) {
                    Product tmpProduct = mapProduct.get(tmpLineItemDescription);
                    //System.debug('****tmpProduct=' + tmpProduct);

                    string tmpProduct2Id = tmpProduct.Prod2.Id;
                    //System.debug('****tmpProduct2Id=' + tmpProduct2Id);

                    string tmpPriceBookId = mapProductBasketIdPriceBookId.get(tmpProductBasketId);
                    //System.debug('****tmpPriceBookId=' + tmpPriceBookId);

                    PBEntry tmpPBEntry = new PBEntry();
                    tmpPBEntry.PriceBookId = tmpPriceBookId;
                    tmpPBEntry.Product2Id = tmpProduct2Id;

                    if (tmpAttribute.cscfga__Price__c == null) {
                        tmpPBEntry.UnitPrice = 0;
                    } else {
                        tmpPBEntry.UnitPrice = tmpAttribute.cscfga__Price__c;
                    }

                    tmpPBEntry.Name = tmpLineItemDescription;

                    if (mapPriceBookIdmapPBEntry.containsKey(tmpPriceBookId)) {

                        Map<string, PBEntry> mapPBEntry = mapPriceBookIdmapPBEntry.get(tmpPriceBookId);

                        if (!mapPBEntry.containsKey(tmpProduct2Id)) {
                            mapPBEntry.put(tmpProduct2Id, tmpPBEntry);
                        }

                    } else {

                        Map<string, PBEntry> mapPBEntry = new Map<string, PBEntry>();
                        mapPBEntry.put(tmpProduct2Id, tmpPBEntry);
                        mapPriceBookIdmapPBEntry.put(tmpPriceBookId, mapPBEntry);
                    }
                }
            }
        }

        //System.debug('****mapPriceBookIdmapPBEntry=' + mapPriceBookIdmapPBEntry);
        return mapPriceBookIdmapPBEntry;
    }

    private static void CreatePriceBookEntries(Map<string, Map<string, PBEntry>> mapPriceBookIdmapPBEntry) {

        //System.debug('***mapPriceBookIdmapPBEntry=' + mapPriceBookIdmapPBEntry);

        Set<string> setProduct2Id = new Set<string>();

        List<PricebookEntry> lstPricebookEntryInsert = new List<PricebookEntry>();

        for (Map<string, PBEntry> mapPBEntry : mapPriceBookIdmapPBEntry.values()) {

            for (PBEntry tmpPBEntry : mapPBEntry.values()) {
                setProduct2Id.add(tmpPBEntry.Product2Id);
            }
        }

        //System.debug('***setProduct2Id=' + setProduct2Id);

        if (setProduct2Id.size() > 0) {

            Map<Id, PricebookEntry> mapPricebookEntry = new Map<Id, PricebookEntry> ([SELECT Id, IsActive, Name, Pricebook2Id, Product2Id, UnitPrice FROM PricebookEntry WHERE Product2Id in : setProduct2Id]);

            //System.debug('***mapPricebookEntry=' + mapPricebookEntry);

            for (PricebookEntry tmpPricebookEntry : mapPricebookEntry.values()) {

                string tmpPricebook2Id = tmpPricebookEntry.Pricebook2Id;
                string tmpProduct2Id = tmpPricebookEntry.Product2Id;

                //System.debug('***tmpPricebook2Id=' + tmpPricebook2Id);
                //System.debug('***tmpProduct2Id=' + tmpProduct2Id);

                if (mapPriceBookIdmapPBEntry.containsKey(tmpPricebook2Id)) {

                    Map<string, PBEntry> mapPBEntry = mapPriceBookIdmapPBEntry.get(tmpPricebook2Id);

                    if (mapPBEntry.containsKey(tmpProduct2Id)) {
                        PBEntry tmpPBEntry = mapPBEntry.get(tmpProduct2Id);
                        tmpPBEntry.PBEntryId = tmpPricebookEntry.Id;
                    }
                }
            }

            for (Map<string, PBEntry> mapPBEntry : mapPriceBookIdmapPBEntry.values()) {

                for (PBEntry tmpPBEntry : mapPBEntry.values()) {

                    //System.debug('***tmpPBEntry=' + tmpPBEntry);

                    if ((tmpPBEntry.PBEntryId == '') || (tmpPBEntry.PBEntryId == null)) {
                        PricebookEntry tmpPricebookEntry = new PricebookEntry();
                        tmpPricebookEntry.IsActive = true;
                        //tmpPricebookEntry.Name=tmpPBEntry.Name;
                        tmpPricebookEntry.Pricebook2Id = tmpPBEntry.PriceBookId;
                        tmpPricebookEntry.Product2Id = tmpPBEntry.Product2Id;
                        tmpPricebookEntry.UnitPrice = tmpPBEntry.UnitPrice;

                        tmpPBEntry.PBE = tmpPricebookEntry;

                        lstPricebookEntryInsert.add(tmpPricebookEntry);

                    } else {

                        PricebookEntry tmpPricebookEntry = mapPricebookEntry.get(tmpPBEntry.PBEntryId);
                        tmpPBEntry.PBE = tmpPricebookEntry;
                    }
                }
            }
        }

        if (lstPricebookEntryInsert.size() > 0) {
            insert lstPricebookEntryInsert;
        }
    }

    private static string RemoveAmpresand(string pLineItemDescription) {
        //example: Connect ZZP Internet Start &amp; Play Start

        if (pLineItemDescription != null) {

            if (pLineItemDescription.contains('&amp;')) {
                pLineItemDescription = pLineItemDescription.replace('&amp;', '&');
            }
        } else {
            pLineItemDescription = '';
        }

        return pLineItemDescription;
    }

    private static Map<string, Map<string, Product>> CreateProducts2(List<cscfga__Attribute__c> lstAttribute) {

        //System.debug('***lstAttribute=' + lstAttribute);

        Map<string, Map<string, Product>> mapProductFamilymapProduct = new Map<string, Map<string, Product>>();

        for (cscfga__Attribute__c tmpAttribute : lstAttribute) {

            string tmpProductFamily = tmpAttribute.cscfga__Product_Configuration__r.cscfga__Product_Family__c;
            string tmpLineItemDescription = LG_ProductUtility.RemoveAmpresand(tmpAttribute.cscfga__Line_Item_Description__c);

            //System.debug('***tmpAttribute.cscfga__Line_Item_Description__c=' + tmpAttribute.cscfga__Line_Item_Description__c);
            //System.debug('***tmpProductFamily=' + tmpProductFamily);
            //System.debug('***tmpLineItemDescription=' + tmpLineItemDescription);

            if (mapProductFamilymapProduct.containsKey(tmpProductFamily)) {

                //System.debug('***contains tmpProductFamily=' + tmpProductFamily);
                Map<string, Product> mapProduct = mapProductFamilymapProduct.get(tmpProductFamily);
                //System.debug('***mapProduct=' + mapProduct);

                if (!mapProduct.containsKey(tmpLineItemDescription)) {

                    //System.debug('***does not contain tmpLineItemDescription=' + tmpLineItemDescription);
                    Product tmpProduct = new Product();
                    tmpProduct.ProductFamily = tmpProductFamily;
                    tmpProduct.LiniItemDescription = tmpLineItemDescription;
                    mapProduct.put(tmpLineItemDescription, tmpProduct);
                }

            } else {

                //System.debug('***does not contain tmpProductFamily=' + tmpProductFamily);
                Map<string, Product> mapProduct = new Map<string, Product>();
                Product tmpProduct = new Product();
                tmpProduct.ProductFamily = tmpProductFamily;
                tmpProduct.LiniItemDescription = tmpLineItemDescription;
                mapProduct.put(tmpLineItemDescription, tmpProduct);
                mapProductFamilymapProduct.put(tmpProductFamily, mapProduct);
            }
        }

        //System.debug('***mapProductFamilymapProduct=' + mapProductFamilymapProduct);

        if (mapProductFamilymapProduct.size() > 0) {

            Map<Id, Product2> mapProduct2 = new Map<Id, Product2>([SELECT Family, Id, IsActive, Name FROM Product2 WHERE IsActive = true and Family in : mapProductFamilymapProduct.keySet()]);

            //System.debug('Query: select Family, Id, IsActive, Name from Product2 where IsActive=true and Family in ' + mapProductFamilymapProduct.keySet());

            for (Product2 tmpProduct2 : mapProduct2.values()) {

                if (mapProductFamilymapProduct.containsKey(tmpProduct2.Family)) {
                    Map<string, Product> mapProduct = mapProductFamilymapProduct.get(tmpProduct2.Family);

                    if (mapProduct.containsKey(tmpProduct2.Name)) {
                        Product tmpProduct = mapProduct.get(tmpProduct2.Name);
                        tmpProduct.Product2Id = tmpProduct2.Id;
                    }
                }
            }

            List<Product2> lstProduct2Insert = new List<Product2>();

            for (string tmpProductFamily : mapProductFamilymapProduct.keySet()) {

                //System.debug('****tmpProductFamily=' + tmpProductFamily);

                Map<string, Product> mapProduct = mapProductFamilymapProduct.get(tmpProductFamily);

                //System.debug('****mapProduct=' + mapProduct);

                for (Product tmpProduct : mapProduct.values()) {

                    //System.debug('****tmpProduct=' + tmpProduct);

                    if ((tmpProduct.Product2Id == '') || (tmpProduct.Product2Id == null)) {
                        Product2 tmpProduct2 = new Product2();
                        tmpProduct2.Family = tmpProductFamily;
                        //DvtH11AUG2016 - If lineItem description is emty then fill in the product family since the product name may not be empty!
                        if (tmpProduct.LiniItemDescription==null || tmpProduct.LiniItemDescription=='') {
                        	tmpProduct2.Name = 'Product Family: ' + tmpProductFamily;
                        } else {
                        	tmpProduct2.Name = tmpProduct.LiniItemDescription;
                        }
                        tmpProduct.Prod2 = tmpProduct2;

                        lstProduct2Insert.add(tmpProduct2);

                    } else {

                        Product2 tmpProduct2 = mapProduct2.get(tmpProduct.Product2Id);
                        tmpProduct.Prod2 = tmpProduct2;
                    }
                }
            }

            //System.debug('****before lstProduct2Insert=' + lstProduct2Insert);

            if (lstProduct2Insert.size() > 0) {
                insert lstProduct2Insert;
            }

            //System.debug('****lstProduct2Insert=' + lstProduct2Insert);
        }

        //System.debug('****mapProductFamilymapProduct=' + mapProductFamilymapProduct);

        return mapProductFamilymapProduct;
    }

    /*
     * Deprecated
    */
    public static void DeleteHardOLIs(Set<string> setProductBasketId) {

        List<cscfga__Product_Basket__c> lstPB = [SELECT Id, cscfga__Opportunity__c FROM cscfga__Product_Basket__c WHERE Id in : setProductBasketId];

        Set<Id> setOpportunityId = new Set<Id>();

        for (cscfga__Product_Basket__c tmpPB : lstPB) {
            setOpportunityId.add(tmpPB.cscfga__Opportunity__c);
        }

        if (setOpportunityId.size() > 0) {

            List<OpportunityLineItem> lstOLI = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId in : setOpportunityId];

            if (lstOLI.size() > 0) {
                delete lstOLI;
            }
        }
    }
    
    /*
     * Deletes Opportunity Line Items for unsynced baskets
    */
    public static void DeleteHardOLIs(Set<string> setProductBasketId, List<cscfga__Product_Basket__c> lstNewPB) {

        Set<Id> setOpportunityId = new Set<Id>();
        
        for (cscfga__Product_Basket__c pb :lstNewPB) {
            if (setProductBasketId.contains(pb.Id)) {
                setOpportunityId.add(pb.cscfga__Opportunity__c);    
            }
        }

        if (setOpportunityId.size() > 0) {

            List<OpportunityLineItem> lstOLI = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId in : setOpportunityId];

            if (lstOLI.size() > 0) {
                delete lstOLI;
            }
        }
    }

    private class Product {
        public string ProductFamily {get; set;}
        public string LiniItemDescription {get; set;}
        public string Product2Id {get; set;}
        public Product2 Prod2 {get; set;}
    }

    private class PBEntry {
        public string PBEntryId {get; set;}
        public string PriceBookId {get; set;}
        public string Product2Id {get; set;}
        public double UnitPrice {get; set;}
        public string Name {get; set;}
        public PriceBookEntry PBE {get; set;}
    }

    /*******************************************************************************************************
    * @description Outmaps configuration attribute value (and attribute fields values - depending on selected Output Strategy) to configurable object(s) and field(s)
    * Used for batch quote generation and with/without cleaning of old quotes records
    * @param Product Basket Id
    * @param Cleaning Flag (true/false)
    * @return void
    */
    public static void MapProductConfigurationsToQuotesObject(Set<String> productBaskets, Boolean withCleaning){
        System.debug('productBaskets: '+productBaskets);
        List<cscfga__Product_Basket__c> pbList = [SELECT Id, Name, LG_UsedQuoteObjects__c FROM cscfga__Product_Basket__c WHERE Id =: productBaskets];
        // Delete existing records (if requested)
        if(withCleaning){
            List<SObject> usedQuoteObjectsRecords;
            // Get used quote objects from last run
            Set<String> usedQuoteObjectsSet = new Set<String>();
            List<String> usedQuoteObjectsList = new List<String>();
            for(cscfga__Product_Basket__c pb : pbList){
                if(String.isNotBlank(pb.LG_UsedQuoteObjects__c)){
                    List<String> tempList = pb.LG_UsedQuoteObjects__c.split(',');
                    for(String tempString : tempList){
                        usedQuoteObjectsSet.add(tempString);
                    }
                }
            }
            usedQuoteObjectsList.addAll(usedQuoteObjectsSet);
            System.debug('usedQuoteObjectsList: '+usedQuoteObjectsList);
            // Due to SF limits optimise and use up to 10 different types in one sObject - perform delete on all old quote records related to requeted baskets
            for(Integer i = 0 ; i < (usedQuoteObjectsList.size() / 10) + 1 ; i++){
                usedQuoteObjectsRecords = new List<SObject>();
                for(Integer j=(i*10);(j<(i*10)+10) && j<usedQuoteObjectsList.size(); j++){
                    usedQuoteObjectsRecords.addAll(Database.query('SELECT Id FROM '+usedQuoteObjectsList.get(j).replace('[','').replace(']','')+' WHERE LG_Product_Basket__c =:productBaskets' ));
                }
                delete usedQuoteObjectsRecords;
            }
        }
        // Select all required baskets and content
        List<cscfga__Product_Configuration__c> pcs =
        [
            SELECT cscfga__Product_Basket__c,cscfga__Product_Definition__c,cscfga__Product_Definition__r.LG_QuoteMappingObject__c,cscfga__Product_Definition__r.cscfga__Product_Category__c,cscfga__Product_Basket__r.cscfga__Opportunity__c,
                (SELECT cscfga__Key__c,cscfga__Product_Configuration__c,cscfga__Display_Value__c,cscfga__Price__c,CreatedDate,cscfga__Recurring__c,CreatedById,cscfga__is_active__c,cscfga__Line_Item_Description__c,LastModifiedDate,Id,cscfga__Billing_Price__c,cscfga__Cascade_value__c,IsDeleted,Name,cscfga__Value__c,cscfga__Hidden__c,SystemModstamp,LastModifiedById,cscfga__Is_Line_Item__c,cscfga__Annualised_Price__c,cscfga__Line_Item_Sequence__c,cscfga__Attribute_Definition__r.LG_QuoteMappingValueField__c, cscfga__Attribute_Definition__r.LG_QuoteMappingAttributeFields__c, cscfga__Attribute_Definition__r.cscfga__Type__c 
                FROM cscfga__Attributes__r 
                WHERE cscfga__Attribute_Definition__r.LG_QuoteMappingValueField__c != null),
                (SELECT Id 
                FROM cscfga__Related_Configurations__r)
            FROM cscfga__Product_Configuration__c
            WHERE cscfga__Product_Definition__r.LG_QuoteMappingObject__c != null 
            AND cscfga__Product_Basket__c IN :productBaskets 
            LIMIT 5000
        ];
        System.debug('Product Configurations: '+pcs);
        // Prepare attribute fields
        Set<Id> attributeSet = new Set<Id>();
        for(cscfga__Product_Basket__c pb : pbList){
            for(cscfga__Product_Configuration__c pc : pcs){
                if(!pc.cscfga__Attributes__r.IsEmpty()){
                    if(pb.Id == pc.cscfga__Product_Basket__c){
                        attributeSet.addAll(new Map<Id,cscfga__Attribute__c>(pc.cscfga__Attributes__r).keySet());
                    }
                }
            }
        }
        // Select all attribute fields
        List<cscfga__Attribute_Field__c> afList =
        [
            SELECT Id, Name, cscfga__Value__c, cscfga__Attribute__c
            FROM cscfga__Attribute_Field__c 
            WHERE cscfga__Attribute__c in :attributeSet
            LIMIT 5000
        ];
        System.debug('Attribute Fields: '+afList);
        // Output mapping
        for(cscfga__Product_Basket__c pb : pbList){
            pb.LG_UsedQuoteObjects__c = '';
            Set<String> usedQuoteObjectsSet = new Set<String>();
            for(cscfga__Product_Configuration__c pc : pcs){
                if(!pc.cscfga__Attributes__r.IsEmpty()){
                    if(pb.Id == pc.cscfga__Product_Basket__c){
                        String mappingObject = pc.cscfga__Product_Definition__r.LG_QuoteMappingObject__c;
                        System.debug('LG_QuoteMappingObject__c: '+mappingObject);
                        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(mappingObject);
                        if (targetType == null) {
                            // throw an exception
                        }
                        // Instantiate an sObject with the type passed in as an argument at run time
                        SObject so = targetType.newSObject();
                        List<SObject> soList = new List<SObject>();
                        DateTime dt = DateTime.now();
                        String formattedDt = dt.format('yyyyMMdd\'T\'hhmmss\'Z\'');
                        for(cscfga__Attribute__c att : pc.cscfga__Attributes__r){
                            String mappingField = att.cscfga__Attribute_Definition__r.LG_QuoteMappingValueField__c;
                            System.debug('LG_QuoteMappingValueField__c: '+mappingField);
                            // Check Output Mapping Strategy set on custom setting
                            if(Document_Manager_Settings__c.getInstance().Output_Strategy__c == 'Attribute')
                            {
                                so = targetType.newSObject();
                                so.put('Name','Quote: ' + formattedDt);
                                so.put('LG_Opportunity__c',pc.cscfga__Product_Basket__r.cscfga__Opportunity__c);
                                so.put('LG_Product_Basket__c',pb.Id);
                                so.put('LG_ProductConfiguration__c',pc.Id);
                                so.put('LG_ProductDefinitionLookup__c',pc.cscfga__Product_Definition__r.Id);
                                so.put('LG_ProductCategoryLookup__c',pc.cscfga__Product_Definition__r.cscfga__Product_Category__c);
                                so.put('LG_Attribute__c',att.Id);
                                //Get right object value
                                Object value = getCorrectType(targetType, mappingField, att.cscfga__Value__c);
                                so.put(mappingField, value);
                                if(String.isNotBlank(att.cscfga__Attribute_Definition__r.LG_QuoteMappingAttributeFields__c)){
                                    List<String> afOutmapList = att.cscfga__Attribute_Definition__r.LG_QuoteMappingAttributeFields__c.split(',');
                                    for(String afOutmap : afOutmapList){
                                        for(cscfga__Attribute_Field__c af : afList){
                                            if(afOutmap.replace('__c','') == af.Name && af.cscfga__Attribute__c == att.Id){
                                                //Get right object value
                                                Object attFieldValue = getCorrectType(targetType, afOutmap, af.cscfga__Value__c);
                                                so.put(afOutmap,attFieldValue);
                                            }
                                        }
                                    }
                                }
                                soList.add(so);
                            }
                            // Check Output Mapping Strategy set on custom setting
                            /* Uncheck because not needed for UM
                            else if(Document_Manager_Settings__c.getInstance().Output_Strategy__c == 'Product Configuration'){
                                so.put('Name','Quote: ' + formattedDt);
                                so.put('Opportunity__c',pc.cscfga__Product_Basket__r.cscfga__Opportunity__c);
                                so.put('Product_Basket__c',pb.Id);
                                so.put('Product_Configuration__c',pc.Id);
                                so.put('Product_Definition__c',pc.cscfga__Product_Definition__r.Id);
                                so.put('Product_Category__c',pc.cscfga__Product_Definition__r.cscfga__Product_Category__c);
                                so.put(mappingField, att.cscfga__Value__c);
                                so.put(mappingField, att.cscfga__Value__c);
                            }*/
                        }
                        System.debug('so: '+so);
                        System.debug('soList: '+soList);
                        // Check Output Mapping Strategy set on custom setting
                        if(Document_Manager_Settings__c.getInstance().Output_Strategy__c == 'Attribute')
                        {
                            insert soList;
                        }
                        // Check Output Mapping Strategy set on custom setting
                        /* Uncheck because not needed for UM
                        else if(Document_Manager_Settings__c.getInstance().Output_Strategy__c == 'Product Configuration'){
                            insert so;
                        }*/
                        usedQuoteObjectsSet.add(mappingObject);
                    }
                }
                
            }
            // Update used objects field on basket (so later it can be used for cleanup if required)
            for(String usedQuoteObject : usedQuoteObjectsSet){
                String mappingObjectPrepared = '['+usedQuoteObject+']';
                pb.LG_UsedQuoteObjects__c += (pb.LG_UsedQuoteObjects__c == '') ? mappingObjectPrepared : ','+mappingObjectPrepared;
            }
        }
        update pbList;
    }

    //--------------------------------------------------------------------------
    // Convert value to corresponding type
    //--------------------------------------------------------------------------
    public static object getCorrectType(sObjectType sobject_type, string fieldName, string fieldValue)
    {
        //get object describe
        Schema.DescribeSObjectResult sobject_describe = getObjectDescribe(sobject_type); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject

        //get field type
        system.debug('!!!fieldName:' + fieldName + ' - fieldValue:' + fieldValue);
        DisplayType fieldType = getFieldDescribe(sobject_type, fieldName).getType();
        system.debug('Petary:' + fieldType + ' - fieldName:' + fieldName + ' - fieldValue:' + fieldValue);
        //return correct type
        if(fieldType == DisplayType.Boolean)
        {
            if (fieldValue == null || fieldValue == '')
            {
                return false;
            }
            else if(fieldValue.toLowerCase() == 'no')
                return false;
            else if(fieldValue.toLowerCase() == 'yes')
                return true;
            return boolean.valueOf(fieldValue);
        }
        if(fieldType == DisplayType.Currency ||
        fieldType == DisplayType.Percent  ||
        fieldType == DisplayType.Double)
        {
            if (fieldValue == null || fieldValue == '')
            {
                return 0;
            }
            else return decimal.valueOf(fieldValue);
        }
        if(fieldType == DisplayType.Integer)
        {
            if (fieldValue == null || fieldValue == '')
            {
                return 0;
            }
            else return integer.valueOf(fieldValue);
        }
        if(fieldType == DisplayType.Date)
        {
            if (fieldValue == null || fieldValue == '')
            {
                return '';
            }
            else return Date.valueOf(fieldValue);
        }
        if(fieldType == DisplayType.DateTime)
        {
            if (fieldValue == null || fieldValue == '')
            {
                return '';
            }
            else return Datetime.valueOf(fieldValue);
        }
        return fieldValue;
    }

    //--------------------------------------------------------------------------
    // Convert value to string in configurator format
    //--------------------------------------------------------------------------
    public static String getAttributeValue(Object value)
    {
        if (value instanceof Date)
        {
            return string.valueOf((Date)value);
        }
        else if (value instanceof Boolean)
        {
            return ((Boolean)value) ? 'Yes' : 'No';
        }
        else
        {
            return String.valueOf(value);
        }
    }

    public static Schema.DescribeSObjectResult getObjectDescribe(sObjectType sobject_type)
    {
        Schema.DescribeSObjectResult retResult = mapObjectDescribe.get(sobject_type);
        if(retResult == null)
        {
            retResult = sobject_type.getDescribe();
            mapObjectDescribe.put(sobject_type, retResult);
        }
        return retResult;
    }

    public static DescribeFieldResult getFieldDescribe(sObjectType sobject_type, string fieldName)
    {
        Map<String, DescribeFieldResult> fieldDescribes = mapFieldDescribeToObject.get(sobject_type);
        if(fieldDescribes == null)
        {
            fieldDescribes = new Map<String, Schema.DescribeFieldResult>();
            mapFieldDescribeToObject.put(sobject_type,fieldDescribes);
        }

        DescribeFieldResult describeField = fieldDescribes.get(fieldName);
        if(describeField == null)
        {
            Map<String, SObjectField> field_map = getObjectFields(sobject_type);
            describeField = field_map.get(fieldName).getDescribe();
            fieldDescribes.put(fieldName, describeField);
            mapFieldDescribeToObject.put(sobject_type, fieldDescribes);

        }
        return describeField;
    }

    public static Map<String, Schema.SObjectField> getObjectFields(sObjectType sobject_type)
    {
        Map<String, Schema.SObjectField> field_map;
        if(!mapFieldsToObject.containsKey(sobject_type))
        {
            //describe the sobject
            DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
            //get a map of fields for the passed sobject
            field_map = sobject_describe.fields.getMap();
            mapFieldsToObject.put(sobject_type,field_map);
        }
        field_map = mapFieldsToObject.get(sobject_type); //get a map of fields for the passed sobject
        return field_map;
    }

    /*
     * There can be only one synced basket per opportunity. Therefore delete all opportunity reports for the opportunity. They will all be recreated on sync
    */
    public static void DeleteOpportunityReports(Set<string> setProductBasketId, List<cscfga__Product_Basket__c> lstNewPB)
    {
        Set<Id> opportunityIds = new Set<Id>();
        
        for (cscfga__Product_Basket__c pb :lstNewPB) {
            
            if (setProductBasketId.contains(pb.Id)) {
                opportunityIds.add(pb.cscfga__Opportunity__c);
            }
        }

        if (opportunityIds.size() > 0) 
        {
            List<LG_OpportunityReport__c> lstProductDetail = [SELECT Id FROM LG_OpportunityReport__c WHERE LG_Opportunity__c in : opportunityIds];
            
            if (lstProductDetail.size() > 0) {
                delete lstProductDetail;
            }
        }
    }    
}