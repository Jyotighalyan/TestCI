/************************************************************
* File Name     :  LG_BillingAccount
* Description   :  This class is used to count number of billing accounts.

* @author       :  Manmohan Singh | manmohan.singh1@cognizant.com
* Modification Log
=============================================================
* Ver.    Date          Author              Modification
-------------------------------------------------------------
* 1.0     06/05/2016    Manmohan Singh        File Created.
************************************************************/

public class LG_BillingAccount {
    
    
    Public String accId;
    Public String OppId;
    Public Integer totalBillingAccount;
    List<cscfga__Product_Configuration__c> productBasketLineItemsList = new List<cscfga__Product_Configuration__c>();
    Map<String,Map<String,Map<String,LG_BillingAccountDO>>> logicalBillingAccountMap;
    List<LG_ActualBillingAccount> actualBillingAccountList = new List<LG_ActualBillingAccount>();
    Map<string, PropositionProperties> PropositionPropertiesMap = new Map<string, PropositionProperties>();
    Map<string, List<string>> PropositionChildMap = new Map<string, List<string>>();
    Map<string, Set<String>> PropositionChildProducts = new Map<string, Set<String>>();
    
    public LG_BillingAccount(){
        //default constructor
    }
    
    public LG_BillingAccount(String OppId){
        this.OppId = OppId;
        if(oppId != null && oppId.length()>0){
            //LG_IsUnUsedBillingAccount__c
            
            List<cscfga__Product_Basket__c> productBasketList = [select id from cscfga__Product_Basket__c where csordtelcoa__Synchronised_with_Opportunity__c = TRUE and  cscfga__Opportunity__c =:oppId];
            List<cscfga__Product_Configuration__c> productBasketLineItemsListWithAll = new List<cscfga__Product_Configuration__c>();
            if(productBasketList!=null && !productBasketList.isEmpty())
                productBasketLineItemsListWithAll = [Select Id,cscfga__Parent_Configuration__c,LG_BillingAccount__c,Site_Name__c,cscfga__originating_offer__c,cscfga__originating_offer__r.Name,Product_Category__c,Site_Id__c,Site_Address__c,cscfga__Product_Family__c from cscfga__Product_Configuration__c where cscfga__Product_Basket__c = :productBasketList.get(0).id];
            if(!productBasketLineItemsListWithAll.isEmpty()){
                Map<string, List<PropositionProperties>> PropositionPropertiesMapWithAllChild = new Map<string, List<PropositionProperties>>();
                for(cscfga__Product_Configuration__c eachOppLineItem: productBasketLineItemsListWithAll){
                    String parentProduct = eachOppLineItem.cscfga__Parent_Configuration__c;
                    if(parentProduct != null && parentProduct.length()>0){
                        if(!PropositionPropertiesMapWithAllChild.containsKey(parentProduct))
                            PropositionPropertiesMapWithAllChild.put(parentProduct, new list<PropositionProperties>());
                        
                        list<PropositionProperties> propositionList = PropositionPropertiesMapWithAllChild.get(parentProduct);
                        propositionList.add(new PropositionProperties(eachOppLineItem.Product_Category__c,eachOppLineItem.cscfga__Product_Family__c));
                        PropositionPropertiesMapWithAllChild.put(parentProduct,propositionList);
                        // adding to chilmap
                        if(!PropositionChildMap.containsKey(parentProduct))
                            PropositionChildMap.put(parentProduct, new list<String>());
                        list<String> childList = PropositionChildMap.get(parentProduct);
                        childList.add(eachOppLineItem.id);
                        PropositionChildMap.put(parentProduct,childList);
                        
                    }else{
                        productBasketLineItemsList.add(eachOppLineItem);
                    }
                    
                }
                // make the generic map for proposition based on all childs.
                system.debug('Mannu PropositionPropertiesMapWithAllChild'+PropositionPropertiesMapWithAllChild);
                if(PropositionPropertiesMapWithAllChild.size()>0){
                    for(String eachProposition : PropositionPropertiesMapWithAllChild.keySet()){
                        list<PropositionProperties> propositionList = PropositionPropertiesMapWithAllChild.get(eachProposition);
                        String finalCategory = '';
                        String finalFamily = '';
                        Boolean isMIAProposition = false;
                        for(PropositionProperties eachPro : propositionList){
                            String tempCategory = eachPro.productCategory;
                            String tempFamily = eachPro.productFamily;
                            if(tempFamily.equalsIgnoreCase('MIA')){
                                isMIAProposition = true;
                                finalFamily = tempFamily;
                                finalCategory = 'Off-Net';
                            }else{
                                if(!isMIAProposition && tempFamily!=null && tempFamily.length()>0){
                                    // If there is any boradband parent should have higher precedence (Boradband,Voice,Voice Additional Elements, Mobile).
                                    if(tempFamily.equalsIgnoreCase('Business Broadband')){
                                        finalFamily = tempFamily;
                                        finalCategory = tempCategory;
                                    }
                                    if(finalFamily.equalsIgnoreCase('Business Broadband'))
                                        continue;
                                    if(tempFamily.equalsIgnoreCase('Voice')){
                                        finalFamily = tempFamily;
                                        finalCategory = tempCategory;
                                    }
                                    if(tempFamily.equalsIgnoreCase('Voice') && (finalFamily.equalsIgnoreCase('Voice Additional Elements') || finalFamily.equalsIgnoreCase('Inbound Services'))){
                                        finalFamily = tempFamily;
                                        finalCategory = tempCategory;
                                    }
                                    if((tempFamily.equalsIgnoreCase('Voice Additional Elements')|| finalFamily.equalsIgnoreCase('Inbound Services')) && !finalFamily.equalsIgnoreCase('Voice')){
                                        finalFamily = tempFamily;
                                        finalCategory = tempCategory;
                                    }
                                    if(tempFamily.equalsIgnoreCase('Mobile') && !finalFamily.equalsIgnoreCase('Voice') && !finalFamily.equalsIgnoreCase('Voice Additional Elements')){
                                        finalFamily = tempFamily;
                                        finalCategory = tempCategory;
                                    }
                                }
                            }
                            
                        }
                        PropositionPropertiesMap.put(eachProposition,new PropositionProperties(finalCategory,finalFamily));
                    }
                }
                system.debug('Mannu PropositionPropertiesMap'+PropositionPropertiesMap);
            }
        }
    }
    Public Integer totalBillingAccount(Id oppId,String b){
        return totalBillingAccount = countActualBillingAccounts();
    }
    public boolean isReadyForActualBillingAccountCreation(){
        if(productBasketLineItemsList!=null && !productBasketLineItemsList.isEmpty()){
            for(cscfga__Product_Configuration__c eachOppLineItem: productBasketLineItemsList){
                if(eachOppLineItem.LG_BillingAccount__c == null)return false;
            }
        }else{return false;}
        return true;
    }
    Public integer countDD(){
        integer ddCount =0;
        if(!isReadyForActualBillingAccountCreation()){
            // this will return that all the invoice can be paid by direct debit.
            return totalBillingAccount;
        }else{
            // product asiggnment is done and now direct debit assignment would be done based on actuals
            if(actualBillingAccountList.size()>0){
                Set<String> allLogicalBillingAccountIDs = new Set<String>();
                for(LG_ActualBillingAccount eachActualBA: actualBillingAccountList){
                    allLogicalBillingAccountIDs.add(eachActualBA.getBillingAccountId());
                }
                System.debug('Mannu allLogicalBillingAccountIDs :'+allLogicalBillingAccountIDs);
                if(allLogicalBillingAccountIDs.size()>0){
                    Map<Id,csconta__Billing_Account__c> ddCountList = new Map<id,csconta__Billing_Account__c>([select id from   csconta__Billing_Account__c where id=:allLogicalBillingAccountIDs and   PaymentMethods__c = 'Direct Debit']);
                    if(ddCountList.size()>0){
                        for(LG_ActualBillingAccount eachActualBA: actualBillingAccountList){
                            if(ddCountList.containsKey(eachActualBA.getBillingAccountId())){
                                ddCount++;
                            }
                        }
                    }
                    
                }
            }
        }
        return ddCount;
    }
    Public integer countActualBillingAccounts(){
        integer totalBillingAccount = 0;
        
        logicalBillingAccountMap = getLogicalBillingAccountMap();
        if(isReadyForActualBillingAccountCreation()){
            for(String eachKey : logicalBillingAccountMap.keySet()){
                Map<String,Map<String,LG_BillingAccountDO>> middleMap = logicalBillingAccountMap.get(eachKey); 
                for(String middleKey:middleMap.keySet()){
                    Map<String,LG_BillingAccountDO> innerMap = middleMap.get(middleKey);
                    List<String> allProductsWithSameBA = new List<String>();
                    List<LG_ActualBillingAccount> tempList = new List<LG_ActualBillingAccount>();
                    String UPRNAddress  ='';
                    for(String innerKey:innerMap.keySet()){
                        UPRNAddress = innerKey;
                        system.debug('Mannu innerKey : '+innerKey);
                        // check for each inner key if all the products are assigned to one single billing accout if not add them to counter.
                        LG_BillingAccountDO eacbDO = innerMap.get(innerKey);
                        allProductsWithSameBA.addAll(eacbDO.getProductBasketLineItemsIdsList());
                    }
                    if(UPRNAddress.endsWith('##BB')){
                        String[] arr = UPRNAddress.split('##BB');
                        UPRNAddress = arr[0];
                    } 
                    List<String> withBB = new List<String>();
                    List<String> withoutBB = new List<String>();
                    if(UPRNAddress.equalsIgnoreCase('RBM')){
                        for(String eachString : allProductsWithSameBA){
                            withoutBB.add(eachString);
                        } 
                    }else{
                        for(String eachString : allProductsWithSameBA){
                            if(eachString.endsWith('##BB')){
                                withBB.add(eachString);
                            }else{
                                withoutBB.add(eachString);
                            }
                        } 
                    }
                    // Now make a map here.
                    Map<String,Set<String>> eachwithoutBBMap = new Map<String,Set<String>>();
                    for(String eachwithoutBB :withoutBB){
                        String[] arr = eachwithoutBB.split('##');
                        if(!eachwithoutBBMap.containsKey(arr[1]))
                            eachwithoutBBMap.put(arr[1], new Set<String>{});
                        Set<String> eachList = eachwithoutBBMap.get(arr[1]);
                        eachList.add(arr[0]);
                        eachwithoutBBMap.put(arr[1], eachList);
                    }
                    
                    Map<String,Set<String>> eachwithBBMap = new Map<String,Set<String>>();
                    for(String eachwitBB :withBB){
                        String[] arr = eachwitBB.split('##');
                        if(!eachwithBBMap.containsKey(arr[1]))
                            eachwithBBMap.put(arr[1], new Set<String>{});
                        Set<String> eachList = eachwithBBMap.get(arr[1]);
                        eachList.add(arr[0]);
                        eachwithBBMap.put(arr[1], eachList);
                    }
                    system.debug('Mannu eachwithBBMap'+eachwithBBMap);
                    system.debug('Mannu eachwithoutBBMap'+eachwithoutBBMap);
                    // only for RBM Mobiles
                    // 
                    
                    for(String eachwith :eachwithBBMap.keySet()){
                        if(eachwithoutBBMap.containsKey(eachwith)){
                            //Add Product from eachwithoutBBMap the Billing Accounts
                            LG_ActualBillingAccount eachActualBillingAccount = new LG_ActualBillingAccount();
                            eachActualBillingAccount.setBillingAccountId(eachwith);
                            eachActualBillingAccount.setType(eachKey);
                            eachActualBillingAccount.setSiteAddress(UPRNAddress);
                            eachActualBillingAccount.setBillingAccountId(eachwith);
                            Set<String> eachList = eachwithoutBBMap.get(eachwith);
                            eachwithoutBBMap.remove(eachwith);
                            for(String eachStr: eachList){
                                eachActualBillingAccount.setProductBasketLineItemsIdsList(eachStr);
                            }
                            // Add only one product from BB list and other would be single billing accounts.
                            Set<String> eachList2 = eachwithBBMap.get(eachwith);
                            List<String> listStrings = new List<String>(eachList2);
                            if(listStrings.size()>0){
                                eachActualBillingAccount.setProductBasketLineItemsIdsList(listStrings.get(0));
                                listStrings.remove(0);
                            }
                            tempList.add(eachActualBillingAccount);
                            for(String singleBB : listStrings){
                                LG_ActualBillingAccount eachActualBillingAccount2 = new LG_ActualBillingAccount();
                                eachActualBillingAccount2.setBillingAccountId(eachwith);
                                eachActualBillingAccount2.setProductBasketLineItemsIdsList(singleBB);
                                tempList.add(eachActualBillingAccount2);
                            }
                        }else{
                            // every product would be a seperate billing accounts as these all are BB
                            Set<String> eachList = eachwithBBMap.get(eachwith);
                            for(String eachStr: eachList){
                                LG_ActualBillingAccount eachActualBillingAccount2 = new LG_ActualBillingAccount();
                                eachActualBillingAccount2.setType(eachKey);
                                eachActualBillingAccount2.setSiteAddress(UPRNAddress);
                                eachActualBillingAccount2.setBillingAccountId(eachwith);
                                eachActualBillingAccount2.setProductBasketLineItemsIdsList(eachStr);
                                tempList.add(eachActualBillingAccount2);
                            }
                            
                            
                        }
                    }
                    
                    for(String eachwith :eachwithoutBBMap.keySet()){
                        LG_ActualBillingAccount eachActualBillingAccount2 = new LG_ActualBillingAccount();
                        eachActualBillingAccount2.setBillingAccountId(eachwith);
                        eachActualBillingAccount2.setType(eachKey);
                        eachActualBillingAccount2.setSiteAddress(UPRNAddress);
                        Set<String> eachList = eachwithoutBBMap.get(eachwith);
                        for(String eachStr: eachList){
                            eachActualBillingAccount2.setProductBasketLineItemsIdsList(eachStr);
                        }
                        
                        tempList.add(eachActualBillingAccount2);
                    }
                    actualBillingAccountList.addAll(tempList);
                } 
                
            }
            system.debug('--------$actualBillingAccountList$-------'+actualBillingAccountList);
            totalBillingAccount = actualBillingAccountList.size();
        }else{
            for(String eachKey : logicalBillingAccountMap.keySet()){
                Map<String,Map<String,LG_BillingAccountDO>> middleMap = logicalBillingAccountMap.get(eachKey); 
                for(String middleKey:middleMap.keySet()){
                    Map<String,LG_BillingAccountDO> innerMap = middleMap.get(middleKey);
                    for(String innerKey:innerMap.keySet()){
                        totalBillingAccount++;
                        system.debug('--------$&&$-------');
                    }
                }
            }
        }
        system.debug('--------$totalBillingAccount$-------'+totalBillingAccount);
        return totalBillingAccount;
    }
    // this method will retun the map of all the products associated in the product basket based on logical billing account.
    // Map<String,Map<String,Map<String,LG_BillingAccountDO>>>
    // outer map with Key as RBM/RBM Mobile or ICOMS
    // middle map with Site Address for all the billing accounts (so for RBM & Mobile)- will have always one middle key
    // inner map with billing account will list of all the products associated with billing account. 
    public Map<String,Map<String,Map<String,LG_BillingAccountDO>>> getLogicalBillingAccountMap(){
        // Ourter Map is for type of product category ICOMS, RBM or RMB Mobile.
        // Inner Map is for Site/Address associated to that product category.
        // LG_BillingAccountDO is to hold all the product basket line items associated to that Inner Site/Address.
        
        Map<String,Map<String,Map<String,LG_BillingAccountDO>>> billingAccountMap = new Map<String,Map<String,Map<String,LG_BillingAccountDO>>>(); 
        try{
            if(productBasketLineItemsList!=null && !productBasketLineItemsList.isEmpty()){
                // Start processing records
                for(cscfga__Product_Configuration__c eachLineItem :productBasketLineItemsList){
                    if(
                        eachLineItem.cscfga__Product_Family__c == 'Propositions' ||
                        eachLineItem.cscfga__Product_Family__c == 'Business Broadband' ||
                        eachLineItem.cscfga__Product_Family__c == 'Mobile' ||
                        eachLineItem.cscfga__Product_Family__c == 'Voice Additional Elements' ||
                        eachLineItem.cscfga__Product_Family__c == 'Inbound Services' ||
                        eachLineItem.cscfga__Product_Family__c == 'Voice' ||
                        eachLineItem.cscfga__Product_Family__c == 'MIA'
                    ){
                        if(eachLineItem.cscfga__Product_Family__c == 'Propositions'){
                            PropositionProperties eachPropositionProperties = PropositionPropertiesMap.get(eachLineItem.id);
                            eachLineItem.cscfga__Product_Family__c = eachPropositionProperties.ProductFamily;
                            eachLineItem.Product_Category__c = eachPropositionProperties.productCategory;
                        }
                        // productCategory Empty = RBM Mobile
                        // On-net = ICOMS
                        // Off-net = RBM
                        String cate = eachLineItem.Product_Category__c;
                        if(eachLineItem.cscfga__Product_Family__c == 'Mobile'){ 
                            processLogicalBillingAccountProductCategory(billingAccountMap,'RBM Mobile',eachLineItem);
                        }else if(eachLineItem.cscfga__Product_Family__c == 'Voice Additional Elements' || eachLineItem.cscfga__Product_Family__c == 'Inbound Services'){
                            processLogicalBillingAccountProductCategory(billingAccountMap,'RBM',eachLineItem);
                        }else if(eachLineItem.cscfga__Product_Family__c == 'MIA'){
                            system.debug('--------$$$$------');
                            processLogicalBillingAccountProductCategory(billingAccountMap,'RBM',eachLineItem);
                        }else if(cate != null && cate.endsWithIgnoreCase('Off-Net')){
                            processLogicalBillingAccountProductCategory(billingAccountMap,'RBM',eachLineItem);
                        }else if(cate != null && cate.endsWithIgnoreCase('On-Net')){
                            processLogicalBillingAccountProductCategory(billingAccountMap,'ICOMS',eachLineItem);
                        }else{
                            system.debug('product reported outside valid range : record id '+eachLineItem.id);
                            system.debug('Product family : '+eachLineItem.cscfga__Product_Family__c+' : category : '+cate);
                        }
                        
                    }
                }
                
            }
        }catch(Exception ex){
            system.debug('LG_BillingAccount.getBillingAccounts exception : '+ex.getMessage());
        }
        return billingAccountMap;
    }
    public void processLogicalBillingAccountProductCategory(Map<String,Map<String,Map<String,LG_BillingAccountDO>>> outerMostMap, String SiteType,cscfga__Product_Configuration__c eachLineItem){
        String productFamily = eachLineItem.cscfga__Product_Family__c;
        if(productFamily!=null && productFamily.length()>0){
            
            String UPRN = '';
            if(productFamily == 'Mobile' ){
                UPRN = 'Mobile';
            }else if (eachLineItem.cscfga__Product_Family__c == 'Voice' ||eachLineItem.cscfga__Product_Family__c == 'Business Broadband'){
                UPRN = eachLineItem.Site_Id__c;
            }
            if(SiteType == 'RBM')
                UPRN = 'RBM';
            if(UPRN!=null && UPRN.length()>0){
                // check if outer map contains the siteype (ICOMS, RBM, RBM MOBILE)
                if(!outerMostMap.containsKey(SiteType)){
                    Map<String,LG_BillingAccountDO> innerMap = new Map<String,LG_BillingAccountDO>();
                    LG_BillingAccountDO eachBillingAcc = new LG_BillingAccountDO();
                    eachBillingAcc.setSiteAddress(eachLineItem.Site_Address__c);
                    eachBillingAcc.setSiteId(eachLineItem.Site_Id__c);
                    eachBillingAcc.setSiteName(eachLineItem.Site_Name__c);
                    eachBillingAcc.setProductCategory(eachLineItem.Product_Category__c);
                    eachBillingAcc.setProductFamily(eachLineItem.cscfga__Product_Family__c);
                    // for voice additional products add product category as offnet
                    if(eachLineItem.cscfga__Product_Family__c == 'Voice Additional Elements' || eachLineItem.cscfga__Product_Family__c == 'Inbound Services'){
                        eachBillingAcc.setProductCategory('Off-Net');
                    }else{
                        eachBillingAcc.setProductCategory(eachLineItem.Product_Category__c);
                    }
                    if(eachLineItem.cscfga__Product_Family__c == 'Business Broadband'){
                        eachBillingAcc.setProductBasketLineItemsIdsList(eachLineItem.Id+'##'+eachLineItem.LG_BillingAccount__c+'##BB');
                    }else{
                        eachBillingAcc.setProductBasketLineItemsIdsList(eachLineItem.Id+'##'+eachLineItem.LG_BillingAccount__c);
                    }
                    // Adding inner most Billing Account Data Object to Map
                    innerMap.put(UPRN, eachBillingAcc);
                    // Adding inner most map to middle Map
                    Map<String,Map<String,LG_BillingAccountDO>> middleMap = new Map<String,Map<String,LG_BillingAccountDO>>();
                    middleMap.put(UPRN, innerMap);
                    // Adding middle most map to outerMostMap
                    outerMostMap.put(SiteType,middleMap);
                }else{
                    Map<String,Map<String,LG_BillingAccountDO>> middleMap = new Map<String,Map<String,LG_BillingAccountDO>>();
                    //get the middle map
                    middleMap = outerMostMap.get(SiteType);
                    // get the billing account
                    if(middleMap.containsKey(UPRN)){
                        Map<String,LG_BillingAccountDO> innerMap = new Map<String,LG_BillingAccountDO>();
                        innerMap = middleMap.get(UPRN);
                        if(innerMap.containsKey(UPRN)){
                            LG_BillingAccountDO eachBillingAcc = innerMap.get(UPRN);
                            String currentproductFamily = eachBillingAcc.getProductFamily();
                            if(SiteType == 'ICOMS' && currentproductFamily == 'Business Broadband' &&  eachLineItem.cscfga__Product_Family__c == 'Business Broadband'){
                                
                                if(eachLineItem.cscfga__Product_Family__c == 'Business Broadband'){
                                    eachBillingAcc.setProductBasketLineItemsIdsList(eachLineItem.Id+'##'+eachLineItem.LG_BillingAccount__c+'##BB');
                                }else{
                                    eachBillingAcc.setProductBasketLineItemsIdsList(eachLineItem.Id+'##'+eachLineItem.LG_BillingAccount__c);
                                }
                                eachBillingAcc.setSiteAddress(UPRN);
                                eachBillingAcc.setSiteId(eachLineItem.Site_Id__c);
                                eachBillingAcc.setSiteName(eachLineItem.Site_Name__c);
                                eachBillingAcc.setProductCategory(eachLineItem.Product_Category__c);
                                eachBillingAcc.setProductFamily(eachLineItem.cscfga__Product_Family__c);
                                innerMap.put(UPRN+'##'+eachLineItem.ID, eachBillingAcc);
                                middleMap.put(UPRN, innerMap);
                                outerMostMap.put(SiteType, middleMap);
                            }else{
                                if(eachLineItem.cscfga__Product_Family__c == 'Business Broadband'){
                                    eachBillingAcc.setProductBasketLineItemsIdsList(eachLineItem.Id+'##'+eachLineItem.LG_BillingAccount__c+'##BB');
                                }else{
                                    eachBillingAcc.setProductBasketLineItemsIdsList(eachLineItem.Id+'##'+eachLineItem.LG_BillingAccount__c);
                                }
                                innerMap.put(UPRN, eachBillingAcc);
                                middleMap.put(UPRN, innerMap);
                                outerMostMap.put(SiteType, middleMap);
                            }
                        }
                    }else{
                        LG_BillingAccountDO eachBillingAcc = new LG_BillingAccountDO();
                        eachBillingAcc.setSiteAddress(eachLineItem.Site_Address__c);
                        eachBillingAcc.setSiteId(eachLineItem.Site_Id__c);
                        eachBillingAcc.setSiteName(eachLineItem.Site_Name__c);
                        eachBillingAcc.setProductCategory(eachLineItem.Product_Category__c);
                        eachBillingAcc.setProductFamily(eachLineItem.cscfga__Product_Family__c);
                        if(eachLineItem.cscfga__Product_Family__c == 'Business Broadband'){
                            eachBillingAcc.setProductBasketLineItemsIdsList(eachLineItem.Id+'##'+eachLineItem.LG_BillingAccount__c+'##BB');
                        }else{
                            eachBillingAcc.setProductBasketLineItemsIdsList(eachLineItem.Id+'##'+eachLineItem.LG_BillingAccount__c);
                        }
                        // Adding inner most Billing Account Data Object to Map
                        Map<String,LG_BillingAccountDO> innerMap = new Map<String,LG_BillingAccountDO>();
                        innerMap.put(UPRN, eachBillingAcc);
                        // Adding inner most map to middle Map
                        middleMap.put(UPRN, innerMap);
                        // Adding middle most map to outerMostMap
                        outerMostMap.put(SiteType,middleMap);
                    }
                }
            }
        }
    }
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' - Actual Billing Account Creation -'@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    
    //Step 1 get all the billing accounts Ids = by calling mehtod countActualBillingAccounts
    //Step 2 Query all logical billing account with clone fields and create a map<id,billing account>
    //
    //Setep 3 Creation of Actual Billing Account.
    //allLogicalBillingAccountIDs [ iterate this list for all the billing account ids]
    //             --> outside the loop :make one more list allocatedBAsList() this would be empty before.
    //             A) for each list value check if  allocatedBAsList contains key 
    //                  a) if yes (clone) get the billing account id from BillingAccMap and add this to clone list 
    //                  (update parent billing account id)
    //                  b) if not (use logical) use this existing billing accont id// add billing account id to allocatedBAsList
    //                  end of this loop (ceate the clone billing account list)
    //                  
    // Setep 4: Pre Prepration of Updaing right product with right billing account.
    //          a) iterate the already created clone billing accouts and make a map of key 
    //             (Parent billing Account and child as list of billing account id).
    //           b) iterate a map Step 2: and assign values into 4.a Map
    //           (this map will have key as logical billing account id and values as list of actual billing ids + logical ids)
    // 
    // Setep 5: allocation of the billing accout to products.
    //          a) iterate the Step 1 list
    //          b) check againt step 4 map and get all available billing accounts
    //          c) for each iteration, get all the products and assign this billing account
    //              c.1 make a product list for update.
    //          d) remove the allocated ID from map list
    //          
    //Step 6: update the product list with allocated billing accounts.  
    
    Public void start(Id accId){
        system.debug('*************  starts   **************');
        this.accId = accId;
        //Step 1 get all the billing accounts Ids = by calling mehtod countActualBillingAccounts
        if(actualBillingAccountList!=null && actualBillingAccountList.size()>0)
            actualBillingAccountList.clear();
        Integer allActualBillingAcc = countActualBillingAccounts();
        if(actualBillingAccountList.size()>0){
            Set<String> allLogicalBillingAccountIDs = new Set<String>();
            for(LG_ActualBillingAccount eachActualBA: actualBillingAccountList){
                allLogicalBillingAccountIDs.add(eachActualBA.getBillingAccountId());
            }
            //Step 2 Query all logical billing account with clone fields and create a map<id,billing account>
            if(allLogicalBillingAccountIDs.size()>0){
                Map<id,csconta__Billing_Account__c> existingLogicalBillingAccountMap = queryLogicalBillingAccounts(allLogicalBillingAccountIDs);
                //Setep 3 Creation of Actual Billing Account.
                //allLogicalBillingAccountIDs [ iterate this list for all the billing account ids]
                //             --> outside the loop :make one more list allocatedBAsList() this would be empty before.
                //             A) for each list value check if  allocatedBAsList contains key 
                //                  a) if yes (clone) get the billing account id from BillingAccMap and add this to clone list 
                //                  (update parent billing account id)
                //                  b) if not (use logical) use this existing billing accont id// add billing account id to allocatedBAsList
                //                  end of this loop (ceate the clone billing account list)
                Map<String,String> allocatedBAsMap = new Map<String,String>();
                List<csconta__Billing_Account__c> insetActualBillingAccountsList = new List<csconta__Billing_Account__c>();
                for(LG_ActualBillingAccount eachActualBA: actualBillingAccountList){
                    String eachBillingIds = eachActualBA.getBillingAccountId();
                    if(allocatedBAsMap.containsKey(eachBillingIds)){
                        csconta__Billing_Account__c actualBillingAccount = existingLogicalBillingAccountMap.get(eachBillingIds);
                        csconta__Billing_Account__c toBeCloned = actualBillingAccount.clone(false);
                        toBeCloned.LG_LogicalBillingAccount__c = actualBillingAccount.id;
                        //toBeCloned.LG_SiteAddress__c = eachActualBA.getSiteAddress();
                        toBeCloned.LG_Type__c = eachActualBA.getType();
                        insetActualBillingAccountsList.add(toBeCloned);
                    }else{
                        allocatedBAsMap.put(eachBillingIds, eachBillingIds);
                    }
                }
                Map<String,List<String>> allBillingAcc = new Map<String,List<String>>();
                if(insetActualBillingAccountsList.size()>0)
                    insert insetActualBillingAccountsList;
                if(insetActualBillingAccountsList.size()>0){
                    // Setep 4: Pre Prepration of Updaing right product with right billing account.
                    //          a) iterate the already created clone billing accouts and make a map of key 
                    //             (Parent billing Account and child as list of billing account id).
                    //           b) iterate a map Step 2: and assign values into 4.a Map
                    //           (this map will have key as logical billing account id and values as list of actual billing ids + logical ids)
                    
                    for(csconta__Billing_Account__c eachObj : insetActualBillingAccountsList){
                        if(!allBillingAcc.containsKey(eachObj.LG_LogicalBillingAccount__c))
                            allBillingAcc.put(eachObj.LG_LogicalBillingAccount__c, new List<String>{});
                        List<String> eachList = allBillingAcc.get(eachObj.LG_LogicalBillingAccount__c);
                        eachList.add(eachObj.id);
                        allBillingAcc.put(eachObj.LG_LogicalBillingAccount__c, eachList);
                    }
                    
                }
                //existingLogicalBillingAccountMap
                for(String str : existingLogicalBillingAccountMap.keySet()){
                    if(!allBillingAcc.containsKey(str))
                        allBillingAcc.put(str, new List<String>{});
                    List<String> eachList = allBillingAcc.get(str);
                    eachList.add(str);
                    allBillingAcc.put(str, eachList);
                }
                // Setep 5: allocation of the billing accout to products.
                //          a) iterate the Step 1 list
                //          b) check againt step 4 map and get all available billing accounts
                //          c) for each iteration, get all the products and assign this billing account
                //              c.1 make a product list for update.
                //          d) remove the allocated ID from map list
                List<cscfga__Product_Configuration__c> updateProductsWithRightBillingAccounts = new List<cscfga__Product_Configuration__c>();
                for(LG_ActualBillingAccount eachActualBA: actualBillingAccountList){
                    String eachBillingIds = eachActualBA.getBillingAccountId();
                    if(allBillingAcc.containsKey(eachBillingIds)){
                        
                        List<String> allAvailableBillingAccounts = allBillingAcc.get(eachBillingIds);
                        String currentBillingAccount = allAvailableBillingAccounts.get(0);
                        
                        Set<String> allProductsAssignedtoBillingAcc = eachActualBA.getProductBasketLineItemsIdsList();
                        for(String eachProd : allProductsAssignedtoBillingAcc){
                            cscfga__Product_Configuration__c updatePro = new cscfga__Product_Configuration__c();
                            updatePro.id = eachProd;
                            updatePro.LG_BillingAccount__c = currentBillingAccount;
                            updateProductsWithRightBillingAccounts.add(updatePro);
                            // update proposition child products to parent Billing Account.
                            if(PropositionChildMap.containsKey(eachProd)){
                                List<string> allChild = PropositionChildMap.get(eachProd);
                                for(string eachChildProd : allChild){
                                    cscfga__Product_Configuration__c updateChildPro = new cscfga__Product_Configuration__c();
                                    updateChildPro.id = eachChildProd;
                                    updateChildPro.LG_BillingAccount__c = currentBillingAccount;
                                    updateProductsWithRightBillingAccounts.add(updateChildPro);
                                }
                            }
                        }
                        allAvailableBillingAccounts.remove(0);
                        allBillingAcc.put(eachBillingIds, allAvailableBillingAccounts);
                    }
                }
                //Step 6: update the product list with allocated billing accounts.
                if(updateProductsWithRightBillingAccounts.size()>0)
                    update updateProductsWithRightBillingAccounts;
                
            }
        }
        // Step 7 : Update the SUNID based on Site ID
      //  populateICOMSSUNID();
    }
    /*void populateICOMSSUNID(){
        
        
        // Map(1) -->This map will hold product configuration id as key and address as value.
        Map<String, String> ProductIdAndSiteAddressMap = new Map<String, String>();
        List<cscfga__Product_Configuration__c> updateProductsWithRightBillingAccounts = new List<cscfga__Product_Configuration__c>();
        Set<id> alltheprodList = new set<id>();
        Set<String> SiteAddress = new Set<string>();
        for(cscfga__Product_Configuration__c eachProd : productBasketLineItemsList){
            ProductIdAndSiteAddressMap.put(eachProd.id,eachProd.Site_Id__c);
            alltheprodList.add(eachProd.id);
            if(eachProd.Site_Id__c !=null)
                SiteAddress.add(eachProd.Site_Id__c);
        }
        system.debug('SiteAddress : '+SiteAddress);
        system.debug('ProductIdAndSiteAddressMap : '+ProductIdAndSiteAddressMap);
        // Map (2)-->This map will hold site address as key and icoms site id as value.
        Map<String,String> SiteAddressAndSiteIdMap = new Map<String,String>();
        //LG_SiteIDType__c
        Set<String> SetEstimatedSites = new Set<String>();
        Map<String,String> uprnAddressMap = new Map<String,String>();
        if(!SiteAddress.isEmpty()){
            List<cscrm__Address__c> siteIdsList = [Select id,Estimated_ICOMS_ID__c,LG_SUNIDADDRESSMAP__c,LG_Icomms_Site_ID__c,LG_UPRN__c from cscrm__Address__c where LG_UPRN__c=:SiteAddress and cscrm__Account__c =:accId];
            system.debug('siteIdsList : '+siteIdsList);
            for(cscrm__Address__c eachSite : siteIdsList){
                // if the Icomms_Site_ID__c =0, program will take  Estimated ICOMS ID.
                if(eachSite.LG_Icomms_Site_ID__c == '0'){
                    SiteAddressAndSiteIdMap.put(eachSite.LG_UPRN__c,eachSite.Estimated_ICOMS_ID__c);
                    SetEstimatedSites.add(eachSite.LG_UPRN__c);  
                }else{
                    SiteAddressAndSiteIdMap.put(eachSite.LG_UPRN__c,eachSite.LG_Icomms_Site_ID__c);
                }
                
                uprnAddressMap.put(eachSite.LG_UPRN__c,eachSite.LG_SUNIDADDRESSMAP__c);
            }
        }
        system.debug('SiteAddressAndSiteIdMap : '+SiteAddressAndSiteIdMap);
        // Map (3) -->This map will hold site id as key and SUNID as value
        // (Assumption is that below query will not return more than 35 records so not adding any limit parameter)
        Map<String,LG_ICOMSSUNIDMapping__c> SiteIdAndSunIDMap = new Map<String,LG_ICOMSSUNIDMapping__c>();
        List<LG_ICOMSSUNIDMapping__c> SUNIDList = [Select id, name, LG_SiteId__c, PDF_DD_Reference__c from LG_ICOMSSUNIDMapping__c];
        if(!SUNIDList.isEmpty()){
            
            for(LG_ICOMSSUNIDMapping__c each : SUNIDList){
                SiteIdAndSunIDMap.put(each.LG_SiteId__c, each);
            }
        }
        system.debug('SiteIdAndSunIDMap : '+SiteIdAndSunIDMap);
        // Actual SunID update logic starts here.
        // 0. Create a billing Account List for update with SUNID.
        // 1. Iterate all the newly updated products which has most updated billing accounts.
        //          a) pass the product id and get the site address from Map (1)
        //          b) Pass the site address as key and get the Site ID from Map (2).
        //          b.1 ) if Address is blank, check product family as key and get the SUN ID from Map (3)
        //          c) Pass SITE Id as key and get the SUNID as value from Map (3).
        //  Watch ---> Create a temp SET<BillingAccountID> and add this billing account to this set next time any product 
        //          with same billing account, ignore that (all the products associated to one billing account will have same address). .
        //          Update Step 0 if not empty
        updateProductsWithRightBillingAccounts = [Select Id,LG_BillingAccount__c,Site_Name__c,cscfga__originating_offer__c,cscfga__originating_offer__r.Name,Product_Category__c,Site_Id__c,Site_Address__c,cscfga__Product_Family__c from cscfga__Product_Configuration__c where cscfga__Parent_Configuration__c='' and id=:alltheprodList];
        List<csconta__Billing_Account__c> updateSUNID = new List<csconta__Billing_Account__c>();
        List<csconta__Billing_Account__c> updateSUNIDMIA = new List<csconta__Billing_Account__c>();
        Set<ID> ProcessedTempSet = new Set<ID>();
        
        system.debug('updateProductsWithRightBillingAccounts : '+updateProductsWithRightBillingAccounts);
          Set<ID> BundleIds = new Set<ID>();
        for(cscfga__Product_Configuration__c eachProd : updateProductsWithRightBillingAccounts){
            if(eachProd.cscfga__Product_Family__c == 'Propositions') 
                BundleIds.add(eachProd.id);
            if(eachProd.LG_BillingAccount__c == null || eachProd.cscfga__Product_Family__c == 'Propositions')
                continue;
                if(!ProcessedTempSet.contains(eachProd.LG_BillingAccount__c)){
                    if(ProductIdAndSiteAddressMap.containsKey(eachProd.id)){
                        String siteAdd = ProductIdAndSiteAddressMap.get(eachProd.id);
                        // update the site address from product family = Mobile will not have site address
                        if((siteAdd == null || siteAdd.length()<=0) && (eachProd.cscfga__Product_Family__c == 'Mobile')){
                            siteAdd ='Mobile';
                        }else if(eachProd.cscfga__Product_Family__c == 'MIA' ||eachProd.cscfga__Product_Family__c == 'Voice Additional Elements' || eachProd.cscfga__Product_Family__c == 'Inbound Services'){
                            siteAdd ='IRB';
                            eachProd.Product_Category__c ='Off-Net';
                        }else{
                            String  cate = eachProd.Product_Category__c;
                            if(eachProd.cscfga__Product_Family__c != 'Propositions' && cate.equalsIgnoreCase('Off-Net'))
                                siteAdd ='IRB';
                        }
                        system.debug('siteAdd : '+siteAdd);
                        if(siteAdd =='Mobile' || siteAdd =='IRB' || SiteAddressAndSiteIdMap.containsKey(siteAdd)){
                            String siteId = SiteAddressAndSiteIdMap.get(siteAdd);
                            if(siteAdd =='Mobile') siteId = 'Mobile';
                            if(siteAdd =='IRB') siteId = 'IRB';
                            if(siteid !=null && siteid.length()>0){
                                if(SiteIdAndSunIDMap.containsKey(siteid)){
                                    String SunID = SiteIdAndSunIDMap.get(siteid).name;
                                    String DDReference = SiteIdAndSunIDMap.get(siteid).PDF_DD_Reference__c;
                                    csconta__Billing_Account__c eachBillAccWithSunId = new csconta__Billing_Account__c();
                                    eachBillAccWithSunId.id = eachProd.LG_BillingAccount__c;
                                    eachBillAccWithSunId.LG_SUNID__c = SunID;
                                    if(siteAdd !='Mobile' && siteAdd !='IRB'){
                                        eachBillAccWithSunId.LG_SiteID__c = siteid;
                                        eachBillAccWithSunId.LG_Type__c ='ICOMS';
                                        eachBillAccWithSunId.LG_UPRN__c = siteAdd;
                                        
                                        if(uprnAddressMap.containsKey(siteAdd))
                                            eachBillAccWithSunId.LG_SiteAddress__c = uprnAddressMap.get(siteAdd);
                                    }else{
                                        if(siteAdd =='Mobile'){
                                            eachBillAccWithSunId.LG_Type__c ='Mobile';
                                            eachBillAccWithSunId.LG_SiteAddress__c = 'Mobile';
                                        } else{
                                            eachBillAccWithSunId.LG_Type__c ='RBM';
                                            eachBillAccWithSunId.LG_SiteAddress__c = 'RBM';
                                            
                                        }
                                        
                                    }
                                    
                                    eachBillAccWithSunId.PDF_DD_Reference__c = DDReference;
                                    if(eachBillAccWithSunId.LG_UPRN__c !=null && SetEstimatedSites.contains(eachBillAccWithSunId.LG_UPRN__c)){
                                        eachBillAccWithSunId.LG_SiteIDType__c = 'Estimated';
                                    }else{
                                        eachBillAccWithSunId.LG_SiteIDType__c = 'Actual';
                                    }
                                    updateSUNID.add(eachBillAccWithSunId);
                                    system.debug('updateSUNID : '+updateSUNID);
                                    // update ICOMS, 
                                    ProcessedTempSet.add(eachProd.LG_BillingAccount__c);
                                }
                            }
                        }else{
                            system.debug('Site');
                        }
                    }
                }
        }
        if(!updateSUNID.isEmpty())
            update updateSUNID;
        system.debug('@@@ Bundles BundleIds: '+BundleIds);
        if(BundleIds!=null && BundleIds.size()>0){
            List<cscfga__Product_Configuration__c> allProductsFromBasketWithChild = new List<cscfga__Product_Configuration__c>();
            allProductsFromBasketWithChild = [Select Id,LG_BillingAccount__c,Site_Name__c,cscfga__originating_offer__c,cscfga__originating_offer__r.Name,Product_Category__c,Site_Id__c,Site_Address__c,cscfga__Product_Family__c,cscfga__Parent_Configuration__c from cscfga__Product_Configuration__c where cscfga__Parent_Configuration__c=:BundleIds];
            Map<string,csconta__Billing_Account__c> mPropositionSunIdUpdate = new Map<String,csconta__Billing_Account__c>();
             system.debug('@@@ allProductsFromBasketWithChild: '+allProductsFromBasketWithChild);
            if(allProductsFromBasketWithChild.size()>0){
                // If MIA = always RBM, else check for onnet/offnet to assign site id.
                for(cscfga__Product_Configuration__c eachPropChild : allProductsFromBasketWithChild){
                    if(!mPropositionSunIdUpdate.containsKey(eachPropChild.LG_BillingAccount__c)){
                        system.debug('@@@ cscfga__Product_Family__c: '+eachPropChild.cscfga__Product_Family__c);
                        if(eachPropChild.cscfga__Product_Family__c=='MIA' || 
                           eachPropChild.cscfga__Product_Family__c=='Business Broadband'||
                           eachPropChild.cscfga__Product_Family__c=='Voice'){
                               
                               
                               csconta__Billing_Account__c parentPro = new csconta__Billing_Account__c();
                               parentPro.id = eachPropChild.LG_BillingAccount__c;
                               
                               if(eachPropChild.cscfga__Product_Family__c=='MIA'){
                                   parentPro.LG_Type__c ='RBM';
                                   parentPro.LG_SiteAddress__c = 'RBM';
                                   parentPro.LG_SiteID__c = 'IRB';
                                   if(SiteIdAndSunIDMap.containsKey('IRB')){
                                       parentPro.LG_SUNID__c = SiteIdAndSunIDMap.get('IRB').name;
                                       parentPro.PDF_DD_Reference__c  = SiteIdAndSunIDMap.get('IRB').PDF_DD_Reference__c;
                                   }
                               }else{
                                    system.debug('@@@ Product_Category__c: '+eachPropChild.Product_Category__c);
                                   String cate = eachPropChild.Product_Category__c;
                                   if(cate != null && cate.endsWithIgnoreCase('On-Net')){
                                       parentPro.LG_Type__c ='ICOMS';
                                       if(uprnAddressMap.containsKey(eachPropChild.Site_Id__c))
                                           parentPro.LG_SiteAddress__c = uprnAddressMap.get(eachPropChild.Site_Id__c);
                                       if(SiteAddressAndSiteIdMap.containsKey(eachPropChild.Site_Id__c))        
                                           parentPro.LG_SiteID__c = SiteAddressAndSiteIdMap.get(eachPropChild.Site_Id__c);
                                       if(SiteIdAndSunIDMap.containsKey(eachPropChild.Site_Id__c)){
                                           parentPro.LG_SUNID__c = SiteIdAndSunIDMap.get(eachPropChild.Site_Id__c).name;
                                           parentPro.PDF_DD_Reference__c  = SiteIdAndSunIDMap.get(eachPropChild.Site_Id__c).PDF_DD_Reference__c;
                                       }
                                       if(eachPropChild.Site_Id__c !=null && SetEstimatedSites.contains(eachPropChild.Site_Id__c)){
                                           parentPro.LG_SiteIDType__c = 'Estimated';
                                       }else{
                                           parentPro.LG_SiteIDType__c = 'Actual';
                                       }
                                   }else{
                                        system.debug('@@@ RBM: ');
                                       parentPro.LG_Type__c ='RBM';
                                       parentPro.LG_SiteAddress__c = 'RBM';
                                       parentPro.LG_SiteID__c = 'IRB';
                                       if(SiteIdAndSunIDMap.containsKey('IRB')){
                                           parentPro.LG_SUNID__c = SiteIdAndSunIDMap.get('IRB').name;
                                           parentPro.PDF_DD_Reference__c  = SiteIdAndSunIDMap.get('IRB').PDF_DD_Reference__c;
                                       }
                                   }
                               }
                               mPropositionSunIdUpdate.put(eachPropChild.LG_BillingAccount__c, parentPro);
                           }  
                    }else{
                         system.debug('@@@ 2 cscfga__Product_Family__c: '+eachPropChild.cscfga__Product_Family__c);
                        if(eachPropChild.cscfga__Product_Family__c=='MIA'){
                            csconta__Billing_Account__c parentPro = mPropositionSunIdUpdate.get(eachPropChild.LG_BillingAccount__c);
                            parentPro.LG_Type__c ='RBM';
                            parentPro.LG_SiteAddress__c = 'RBM';
                            parentPro.LG_SiteID__c = 'IRB';
                            if(SiteIdAndSunIDMap.containsKey('IRB')){
                                parentPro.LG_SUNID__c = SiteIdAndSunIDMap.get('IRB').name;
                                parentPro.PDF_DD_Reference__c  = SiteIdAndSunIDMap.get('IRB').PDF_DD_Reference__c;
                            }
                            mPropositionSunIdUpdate.put(eachPropChild.LG_BillingAccount__c, parentPro);
                        }
                        
                    }
                }
                system.debug('@@@ 2 mPropositionSunIdUpdate: '+mPropositionSunIdUpdate);
                if( mPropositionSunIdUpdate.size()>0){
                    List<csconta__Billing_Account__c> updatePropositionBundle = new List<csconta__Billing_Account__c>();
                    for(String eachBundle : mPropositionSunIdUpdate.keySet()){
                        system.debug('@@@ 2 eachBundle: '+eachBundle);
                        updatePropositionBundle.add(mPropositionSunIdUpdate.get(eachBundle)); 
                    }
                    system.debug('updatePropositionBundle : '+updatePropositionBundle);
                    if(updatePropositionBundle.size()>0)
                        update updatePropositionBundle;
                } 
            }
        }
        
    } */
    // Below mehtod will build the query for Clone Billing Accounts
    public String cloneLogicalBillingAccountFields(Set<String> listOfLogicalBillingAccountsToBeClonedIds){
        String queryString = 'select id';
        for(Schema.FieldSetMember eachField :SObjectType.csconta__Billing_Account__c.FieldSets.LG_LogicalBillingAccountClone.getFields()) {
            queryString += ', ' + eachField.getFieldPath();
        }
        String val = '';
        for(String eachValue : listOfLogicalBillingAccountsToBeClonedIds){
            val+='\''+eachValue+'\',';
        }
        val = val.substring(0, val.length()-1);
        return queryString += ' from csconta__Billing_Account__c where Id IN ('+val+')';
    }
    public Map<id,csconta__Billing_Account__c> queryLogicalBillingAccounts(Set<String> listOfLogicalBillingAccountsToBeClonedIds){
        Map<id,csconta__Billing_Account__c> existingLogicalBillingAccountMap = new Map<id,csconta__Billing_Account__c>();
        String query = cloneLogicalBillingAccountFields(listOfLogicalBillingAccountsToBeClonedIds);
        List<csconta__Billing_Account__c> returnList = Database.query(query);
        for(csconta__Billing_Account__c each : returnList){
            existingLogicalBillingAccountMap.put(each.id, each);
        }
        return existingLogicalBillingAccountMap;
    }
    
    public class PropositionProperties{
        public String productCategory =''; //Voice or Broadband
        public String ProductFamily  = '';  //Onnet Vs Offnet
        public PropositionProperties( String productCategory,String ProductFamily){
            this.productCategory= productCategory;
            this.ProductFamily= ProductFamily;
        }
    }
}