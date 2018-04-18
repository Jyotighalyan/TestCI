///
/// Product Configuration trigger handler
///
public class LG_ProdConfRequestTriggerHandler {

    /**
     * Updates the rollup summary fields on the related Product Baskets
     * (we cannot use standard rollup summary fields, as product basket is
     * a lookup field, not a master-detail relationship)
     * Currently, only LG_TotalOneOff__c and LG_TotalRecurringCharge__c fields
     * are being updated whenever a product configuration request has a change
     * in a csbb__Total_OC__c and/or csbb__Total_MRC__c field values.
     *
     * @param  List<csbb__Product_Configuration_Request__c> prodReqs
     * @param  Map<Id, csbb__Product_Configuration_Request__c> oldMap
     * @author Tomislav Blazek
     * @ticket SFDT-134
     * @since  25/01/2016
     */
    public static void updateRollUpFieldsOnProductBasket(List<csbb__Product_Configuration_Request__c> prodReqs,
            Map<Id, csbb__Product_Configuration_Request__c> oldMap) {
        //holds a set of Product Basket Ids applicable for updates
        Set<Id> basketIds = new Set<Id>();

        /*
        * Decide which baskets should be processed:
        * - only baskets related to the product configuration requests that have had a value change
        *   in the cscfga__One_Off_Charge__c and/or cscfga__Recurring_Charge__c fields
        *   or are totally new product configuration requests / or undeleted records
        */
        //Had to add the if isDelete, as Trigger.new is not available in delete triggers.
        if (Trigger.isDelete) {
            prodReqs = Trigger.old;
        }

        for (csbb__Product_Configuration_Request__c newProdReq : prodReqs) {
            csbb__Product_Configuration_Request__c oldProdReq = oldMap == null ? null : oldMap.get(newProdReq.Id);

            if (Trigger.isDelete || Trigger.isUndelete || oldProdReq == null
                    || (oldProdReq.csbb__Total_OC__c != newProdReq.csbb__Total_OC__c)
                    || (oldProdReq.csbb__Total_MRC__c != newProdReq.csbb__Total_MRC__c)) {
                basketIds.add(newProdReq.csbb__Product_Basket__c);
            }
        }

        if  (!basketIds.isEmpty()) {
            List<cscfga__Product_Basket__c> baskets = [SELECT Id, LG_TotalRecurringCharge__c, LG_TotalOneOff__c,
                                            (SELECT Id, csbb__Total_OC__c, csbb__Total_MRC__c
                                             FROM csbb__Product_Configuration_Requests__r)
                                            FROM cscfga__Product_Basket__c
                                            WHERE Id IN :basketIds];

            for (cscfga__Product_Basket__c basket : baskets) {
                basket.LG_TotalOneOff__c = 0;
                basket.LG_TotalRecurringCharge__c = 0;

                for (csbb__Product_Configuration_Request__c prodReq : basket.csbb__Product_Configuration_Requests__r) {
                    basket.LG_TotalOneOff__c += prodReq.csbb__Total_OC__c == null ? 0 : prodReq.csbb__Total_OC__c;
                    basket.LG_TotalRecurringCharge__c += prodReq.csbb__Total_MRC__c == null ? 0 : prodReq.csbb__Total_MRC__c;
                }
            }

            update baskets;
        }
    }
    
    /**
     * Sets the csbb__Optionals__c based on the Product Configuration LG_Address__c field.
     *
     * @param  List<csbb__Product_Configuration_Request__c> prodReqs
     * @author Tomislav Blazek
     * @ticket SFDT-366
     * @since  07/03/2016
     */
    public static void setTheOptionalsField(List<csbb__Product_Configuration_Request__c> prodReqs,
                                            Map<Id, csbb__Product_Configuration_Request__c> oldMap) {
        //populate the eligible prodConfIds and prodConfReqIds
        List<csbb__Product_Configuration_Request__c> prodConfReqs = new List<csbb__Product_Configuration_Request__c>();
        Set<Id> prodConfIds = new Set<Id>();
        
        /*
        * Decide which prodConfReqs should be processed:
        * - product configuration requests that are being inserted
        * - product configuration requests that are being updated 
        * - only those that are having prod conf changed 
        */
        for (csbb__Product_Configuration_Request__c prodReq : prodReqs)
        {
            csbb__Product_Configuration_Request__c oldReq = oldMap == null ? null : oldMap.get(prodReq.Id);

            if ((oldReq == null && prodReq.csbb__Product_Configuration__c != null) //inserted with related prod conf
                || (oldReq != null //update
                    && oldReq.csbb__Product_Configuration__c != prodReq.csbb__Product_Configuration__c)) // there was a change in prod conf
            {
                prodConfReqs.add(prodReq);
                if (prodReq.csbb__Product_Configuration__c != null)
                {
                    prodConfIds.add(prodReq.csbb__Product_Configuration__c);
                }
            }
        }
        
        if (!prodConfReqs.isEmpty())
        {
            Map<Id, cscfga__Product_Configuration__c> moveProdConfs = new Map<Id, cscfga__Product_Configuration__c>(
                [SELECT Id, LG_Address__c, LG_Address__r.Id, LG_Address__r.cscrm__City__c,
                 LG_Address__r.cscrm__Zip_Postal_Code__c, LG_Address__r.LG_HouseNumberExtension__c,
                 LG_Address__r.LG_HouseNumber__c, LG_Address__r.cscrm__Street__c,LG_Address__r.cscrm__Geolocation__latitude__s,
                 LG_Address__r.cscrm__Geolocation__longitude__s,LG_Address__r.LG_AddressID__c, LG_Address__r.cscrm__State_Province__c
                 FROM cscfga__Product_Configuration__c
                 WHERE ID IN :prodConfIds]);
                 
            for (csbb__Product_Configuration_Request__c prodReq : prodConfReqs)
            {
                if (prodReq.csbb__Product_Configuration__c != null
                    && moveProdConfs.get(prodReq.csbb__Product_Configuration__c) != null
                    && moveProdConfs.get(prodReq.csbb__Product_Configuration__c).LG_Address__c != null)
                {
                    prodReq.csbb__Optionals__c = JSON.serialize(new LG_AddressResponse.OptionalsJson(moveProdConfs.get(prodReq.csbb__Product_Configuration__c).LG_Address__r));
                }
                else
                {
          prodReq.csbb__Optionals__c = '{}'; //Optionals needs to have at least an emtpy JSON
                }
            }
        }
    }

    /**
     * If there was a change in the Optionals field (or it is a new record),
     * upsert the related Premise records (cscrm__Address__c)
     * Also if this is an update and there was a change in the prod Conf field,
     * update the Premise Id attribute.
     *
     * @param  List<csbb__Product_Configuration_Request__c> prodReqs
     * @param  Map<Id, csbb__Product_Configuration_Request__c> oldMap
     * @author Tomislav Blazek
     * @ticket SFDT-386
     * @since  07/03/2016
     */
    public static void upsertThePremisesRecords(List<csbb__Product_Configuration_Request__c> prodReqs, Map<Id, csbb__Product_Configuration_Request__c> oldMap) {
        String recordCountry;
        //eligible Prod Conf Requests are those that are new or are having a change in the Optionals field
        Set<Id> eligibleProdConfReqIds = new Set<Id>();
        Map<Id, Id> prodConfReqAccIds = new Map<Id, Id>();
        Map<Id, Id> accIdsProdConfReq = new Map<Id, Id>();

        //Hold a set of Product configuration Requests for which the product configuration has been changed
        Set<Id> prodConfReqsConfChanged = new Set<Id>();

        for (csbb__Product_Configuration_Request__c newProdReq : prodReqs) {
            
            csbb__Product_Configuration_Request__c oldProdReq = oldMap == null ? null : oldMap.get(newProdReq.Id);

            // Optionals is not null, is insert or Optionals has changed
      if (newProdReq.csbb__Optionals__c != null  && newProdReq.csbb__Optionals__c != '{}' 
        && (oldProdReq == null || (oldProdReq.csbb__Optionals__c != newProdReq.csbb__Optionals__c)))
      { 
                eligibleProdConfReqIds.add(newProdReq.Id);
            }

            if (!eligibleProdConfReqIds.contains(newProdReq.Id)//don't add if it was already picked up by the optionals check
                    && newProdReq.csbb__Product_Configuration__c != null //csbb__Product_Configuration__c is not null
                    && oldProdReq != null //is update
                    && newProdReq.csbb__Optionals__c != null //Optionals is not null
          && newProdReq.csbb__Optionals__c != '{}' //Optionals is not blank
                    && (oldProdReq.csbb__Product_Configuration__c != newProdReq.csbb__Product_Configuration__c)) { //csbb__Product_Configuration__c has changed
                eligibleProdConfReqIds.add(newProdReq.Id);
                prodConfReqsConfChanged.add(newProdReq.Id);
            }
        }
        
        //requery the prod conf requests to fetch the account Id values
        List<csbb__Product_Configuration_Request__c> eligibleProdConfReqs = [SELECT Id, csbb__Optionals__c, csbb__Product_Basket__r.csbb__Account__c,
                                                                                 csbb__Product_Configuration__c
                                                                                 FROM csbb__Product_Configuration_Request__c
                                                                                 WHERE Id IN :eligibleProdConfReqIds
                                                                                 AND csbb__Product_Basket__c != null];
             
        if (!eligibleProdConfReqs.isEmpty()) {
            for(csbb__Product_Configuration_Request__c prodConfReq : eligibleProdConfReqs) {
            
                Id accountId = prodConfReq.csbb__Product_Basket__r.csbb__Account__c;
                String accId = LG_Util.checkIdNull(accountId);
                accIdsProdConfReq.put(prodConfReq.Id,accountId);
                //AccIds.add(accId);
            
            }
            
            Map<Id, LG_AddressResponse.OptionalsJson> AccountAddress = new Map<Id, LG_AddressResponse.OptionalsJson>();
            
            List<Account> accounts = [select Id, LG_VisitAddressID__c, LG_VisitAddress__c, LG_VisitCity__c, LG_VisitCountry__c, LG_VisitHouseNumber__c, LG_VisitHouseNumberExtension__c, UM_VisitStateProvince__c, LG_VisitStreet__c, LG_VisitPostalCode__c, UM_VisitGeolocation__latitude__s,UM_VisitGeolocation__longitude__s FROM Account
             where Id IN :accIdsProdConfReq.values()];
            
            for(Account acc: accounts){
                
                cscrm__Address__c address = new cscrm__Address__c();
                    
                    address.cscrm__City__c = acc.LG_VisitCity__c;
                    address.cscrm__State_Province__c = acc.UM_VisitStateProvince__c;
                    address.cscrm__Zip_Postal_Code__c = acc.LG_VisitPostalCode__c ;
                    address.LG_HouseNumberExtension__c = acc.LG_VisitHouseNumberExtension__c;
                    address.LG_HouseNumber__c = acc.LG_VisitHouseNumber__c;
                    address.cscrm__Geolocation__latitude__s = acc.UM_VisitGeolocation__latitude__s;
                    address.cscrm__Geolocation__longitude__s = acc.UM_VisitGeolocation__longitude__s;
                    address.cscrm__Street__c = acc.LG_VisitStreet__c;
                    address.LG_AddressID__c = acc.LG_VisitAddressID__c;
                
                AccountAddress.put(acc.id, new LG_AddressResponse.OptionalsJson(address));
            
            }
            Map<Id, LG_AddressResponse.OptionalsJson> prodConfReqAddress = new Map<Id, LG_AddressResponse.OptionalsJson>();
            Map<Id, String> prodConfToAddressUniqueKey = new Map<Id, String>();
            Set<String> externalAddressIds = new Set<String>();

            for (csbb__Product_Configuration_Request__c prodConfReq : eligibleProdConfReqs) {
                
                System.debug('*** optionals: '+prodConfReq.csbb__Optionals__c);
                LG_AddressResponse.OptionalsJson address = (LG_AddressResponse.OptionalsJson)JSON.deserialize(prodConfReq.csbb__Optionals__c, LG_AddressResponse.OptionalsJson.class);
                
                if((address.addressId == null) && (address.houseNumber == null) && (address.houseNumberExt ==null) && (address.postCode ==null)){
                
                    address = AccountAddress.get(accIdsProdConfReq.get(prodConfReq.Id));

                }
                
                if(address != null){ //* Changes to resolve null pointerexception in test class by Dada in 3rd Nov.             
                externalAddressIds.add(address.addressId);
                
                Id accountId = prodConfReq.csbb__Product_Basket__r.csbb__Account__c;
                String accId = LG_Util.checkIdNull(accountId);
            
                prodConfReqAddress.put(prodConfReq.Id, address);
                prodConfReqAccIds.put(prodConfReq.Id, accountId);
                prodConfToAddressUniqueKey.put(prodConfReq.Id, LG_Util.checkNull(accId) + LG_Util.checkNull(address.postCode) + LG_Util.checkNull(address.houseNumber) + LG_Util.checkNull(address.houseNumberExt));
                } // End change
            }

            //query for the existing addresses
            List<cscrm__Address__c> addresses = [SELECT Id, cscrm__Account__c, LG_AddressID__c, cscrm__Address_Details__c,
                                                 cscrm__City__c, cscrm__Country__c, LG_HouseNumber__c, LG_HouseNumberExtension__c,
                                                 cscrm__State_Province__c, cscrm__Street__c, cscrm__Zip_Postal_Code__c, LG_UniquekeyForm__c,
                                                 cscrm__Geolocation__latitude__s,cscrm__Geolocation__longitude__s
                                                 FROM cscrm__Address__c
                                                 WHERE cscrm__Account__c IN :prodConfReqAccIds.values() AND
                                                 (LG_AddressID__c IN :externalAddressIds OR LG_UniquekeyForm__c IN :prodConfToAddressUniqueKey.values())];

            //populate the address map with accountId#addressId key pairs
            Map<String, cscrm__Address__c> accIdAddressIdToAddress = new Map<String, cscrm__Address__c>();
            
            //populate the address map with LG_UniquekeyForm__c key pairs
            Map<String, cscrm__Address__c> uniqueKeyToAddress = new Map<String, cscrm__Address__c>();
            
            for (cscrm__Address__c address : addresses) {
                
                String accId = LG_Util.checkIdNull(address.cscrm__Account__c);
                accIdAddressIdToAddress.put(accId + '#' + address.LG_AddressID__c, address);
                uniqueKeyToAddress.put(address.LG_UniquekeyForm__c, address);
            }

            Map<String, cscrm__Address__c> addressesToUpsert = new Map<String, cscrm__Address__c>();

            for (csbb__Product_Configuration_Request__c prodConfReq : eligibleProdConfReqs) {
                
                //skip the configuration request that has a change in product configuration, we will update it later.
                if (prodConfReqsConfChanged.contains(prodConfReq.Id)) {
                    continue;
                }

                LG_AddressResponse.OptionalsJson reqAddress = prodConfReqAddress.get(prodConfReq.Id);

                String accId = LG_Util.checkIdNull(prodConfReq.csbb__Product_Basket__r.csbb__Account__c);

                if(reqAddress != null){
                //get the existing address record by using the accountId#addressId key
                cscrm__Address__c queriedAddress = accIdAddressIdToAddress.get(accId + '#' + reqAddress.addressId);
                
                //if accountId#addressId returned blank, maybe the address doesnt have addressId populated, so try with the LG_UniquekeyForm__c
                if (queriedAddress == null) {
                    queriedAddress = uniqueKeyToAddress.get(accId + LG_Util.checkNull(reqAddress.postCode) + LG_Util.checkNull(reqAddress.houseNumber) + LG_Util.checkNull(reqAddress.houseNumberExt));
                }

                //if there is an existing address that relates to the product configuration request account Id and address Id (or LG_UniquekeyForm__c)
                //check if there is a need for upserting that address
                if (queriedAddress != null) {
                    boolean shouldUpsert = false;

                    if (queriedAddress.cscrm__City__c != reqAddress.city) {
                        queriedAddress.cscrm__City__c = reqAddress.city;
                        shouldUpsert = true;
                    }
                    if (queriedAddress.LG_HouseNumber__c != reqAddress.houseNumber) {
                        queriedAddress.LG_HouseNumber__c = reqAddress.houseNumber;
                        shouldUpsert = true;
                    }
                    if (queriedAddress.LG_HouseNumberExtension__c != reqAddress.houseNumberExt) {
                        queriedAddress.LG_HouseNumberExtension__c = reqAddress.houseNumberExt;
                        shouldUpsert = true;
                    }
                    if (queriedAddress.cscrm__Street__c != reqAddress.street) {
                        queriedAddress.cscrm__Street__c = reqAddress.street;
                        shouldUpsert = true;
                    }
                    if (queriedAddress.cscrm__Zip_Postal_Code__c != reqAddress.postCode) {
                        queriedAddress.cscrm__Zip_Postal_Code__c = reqAddress.postCode;
                        shouldUpsert = true;
                    }
                    system.debug('reqAddress.latitude is:'+reqAddress.latitude+'queriedAddress.cscrm__Geolocation__latitude__s is:'+queriedAddress.cscrm__Geolocation__latitude__s);
                    if (String.isNotBlank(reqAddress.latitude) && queriedAddress.cscrm__Geolocation__latitude__s!=null && queriedAddress.cscrm__Geolocation__latitude__s != decimal.valueOf((reqAddress.latitude).replace(',', '.'))) {
                        queriedAddress.cscrm__Geolocation__latitude__s =decimal.valueOf((reqAddress.latitude).replace(',', '.'));
                        shouldUpsert = true;
                    }
                    if (String.isNotBlank(reqAddress.longitude) && queriedAddress.cscrm__Geolocation__longitude__s!=null && queriedAddress.cscrm__Geolocation__longitude__s != decimal.valueOf((reqAddress.longitude).replace(',', '.'))) {
                        queriedAddress.cscrm__Geolocation__longitude__s = decimal.valueOf((reqAddress.longitude).replace(',', '.'));
                        shouldUpsert = true;
                    }
                    if (queriedAddress.LG_AddressID__c != reqAddress.addressId) {
                        queriedAddress.LG_AddressID__c = reqAddress.addressId;
                        shouldUpsert = true;
                    }
                    if (shouldUpsert) {
                        
                        string key = generateUniqueKey(queriedAddress.cscrm__Account__c, queriedAddress.LG_AddressID__c, queriedAddress.cscrm__Zip_Postal_Code__c, queriedAddress.LG_HouseNumber__c, queriedAddress.LG_HouseNumberExtension__c,queriedAddress.cscrm__Geolocation__latitude__s, queriedAddress.cscrm__Geolocation__longitude__s);
                        
                        addressesToUpsert.put(key, queriedAddress);
                    }
                }
                //else, a new premise record should be created
                else {
                    cscrm__Address__c address = new cscrm__Address__c();

                    address.cscrm__Account__c = prodConfReq.csbb__Product_Basket__r.csbb__Account__c;
                    address.LG_AddressID__c = reqAddress.addressId;
                    address.cscrm__City__c = reqAddress.city;
                    address.cscrm__State_Province__c = reqAddress.stateOrProvince;
                    LG_EnvironmentVariables__c enviornmentSettings = LG_EnvironmentVariables__c.getInstance();
                    recordCountry = enviornmentSettings.IdField_BillingCountry__c;
                    //address.cscrm__Country__c = 'Netherlands';
                    address.cscrm__Country__c = recordCountry;
                    
                    address.LG_HouseNumber__c = reqAddress.houseNumber;
                    address.LG_HouseNumberExtension__c = reqAddress.houseNumberExt;
                    if(!String.isBlank(reqAddress.latitude))
                        address.cscrm__Geolocation__latitude__s = decimal.valueOf(reqAddress.latitude);
                    
                    if(!String.isBlank(reqAddress.longitude))                        
                        address.cscrm__Geolocation__longitude__s = decimal.valueOf(reqAddress.longitude);
                    address.cscrm__Street__c = reqAddress.street;
                    address.cscrm__Zip_Postal_Code__c = reqAddress.postCode;

                    string key = generateUniqueKey(address.cscrm__Account__c, address.LG_AddressID__c, address.cscrm__Zip_Postal_Code__c, address.LG_HouseNumber__c, address.LG_HouseNumberExtension__c,address.cscrm__Geolocation__latitude__s, address.cscrm__Geolocation__longitude__s);
                    
                    addressesToUpsert.put(key, address);
                }
            }
            
            }
            /**
             * Upsert of Addresses fails
             *
             * @param  List<cscrm__Address__c> adrr
             * @author Petra Miletic
             * @ticket SFDT-817
             * @since  29/04/2016
             */
            LG_Util.resolveAndUpsertPremiseDuplicates(addressesToUpsert.values());
            
            //Update the Premise Id Attribute on the related Product Configurations
            Map<Id, Id> prodConfIdToAddressId = new Map<Id, Id>();

            if (!addressesToUpsert.isEmpty()) {

                for (csbb__Product_Configuration_Request__c prodConfReq : eligibleProdConfReqs) {
                    
                    if (prodConfReq.csbb__Product_Configuration__c != null) {
                        
                        LG_AddressResponse.OptionalsJson optionalsAddress = prodConfReqAddress.get(prodConfReq.Id);

                        if (optionalsAddress != null) {
                            
                            string key = generateUniqueKey(prodConfReqAccIds.get(prodConfReq.Id), optionalsAddress.addressId, optionalsAddress.postCode, optionalsAddress.houseNumber, optionalsAddress.houseNumberExt,decimal.valueOf((optionalsAddress.latitude).replace(',', '.')), decimal.valueOf((optionalsAddress.longitude).replace(',', '.')) );
                            
                            cscrm__Address__c address = addressesToUpsert.get(key);
                            
                            if (address != null) {
                                prodConfIdToAddressId.put(prodConfReq.csbb__Product_Configuration__c, address.Id);
                            }
                        }
                    }
                }
            }

            if (!prodConfReqsConfChanged.isEmpty()) {
                
                for (csbb__Product_Configuration_Request__c prodConfReq : eligibleProdConfReqs) {
                    
                    //skip if not eligible
                    if (!prodConfReqsConfChanged.contains(prodConfReq.Id)) {
                        continue;
                    }
                    
                    LG_AddressResponse.OptionalsJson optionalsAddress = prodConfReqAddress.get(prodConfReq.Id);

                    String accId = LG_Util.checkIdNull(prodConfReqAccIds.get(prodConfReq.Id));
                    
                    if (optionalsAddress != null) {
                        cscrm__Address__c address = accIdAddressIdToAddress.get(accId + '#' + optionalsAddress.addressId);
                        
                        //if accountId#addressId returned blank, maybe the address doesnt have addressId populated, so try with the LG_UniquekeyForm__c
                        if (address == null) {
                            address = uniqueKeyToAddress.get(accId + LG_Util.checkNull(optionalsAddress.postCode) + LG_Util.checkNull(optionalsAddress.houseNumber) + LG_Util.checkNull(optionalsAddress.houseNumberExt));
                        }
                        if (address != null) {
                            prodConfIdToAddressId.put(prodConfReq.csbb__Product_Configuration__c, address.Id);
                        }
                    }
                }
            }
            /* DGT -389 fix*/
            List<cscfga__Attribute__c> attListToUpdate = new List<cscfga__Attribute__c>();

            if (!prodConfIdToAddressId.isEmpty()) {
                List<cscfga__Attribute__c> attributes = [SELECT Name, cscfga__Value__c, cscfga__Product_Configuration__c
                                                        FROM cscfga__Attribute__c
                                                        WHERE Name = 'Premise Id' 
                                                        AND cscfga__Product_Configuration__c IN :prodConfIdToAddressId.keySet()];
                if (!attributes.isEmpty()) {
                    for (cscfga__Attribute__c attribute : attributes) {
                        if( attribute.cscfga__Value__c != prodConfIdToAddressId.get(attribute.cscfga__Product_Configuration__c) ){ 
                        attribute.cscfga__Value__c = prodConfIdToAddressId.get(attribute.cscfga__Product_Configuration__c);
                            attListToUpdate.add(attribute);
                    }
                    }
                    if(!attListToUpdate.isEmpty()){
                        update attListToUpdate;
                }
            }
        }
    }
    }
    private static string generateUniqueKey(string accountId, string addressId, string postCode, string houseNumber, string houseNumberExt, decimal latitude, decimal longitude) {
        return LG_Util.checkIdNull(accountId) + '#' + LG_Util.checkNull(addressId) + '#' + LG_Util.checkNull(postCode) + LG_Util.checkNull(houseNumber) + LG_Util.checkNull(houseNumberExt)+LG_Util.checkNull(string.valueOf(latitude))+LG_Util.checkNull(string.valueOf(longitude));
    }
}