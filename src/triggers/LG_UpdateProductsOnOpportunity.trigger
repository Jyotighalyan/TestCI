/*
* @Author: Radoslav Sladek
* @CreateDate: 2015-07-13
* @LastModify: Radoslav Sladek;2015-07-13
* @Description: Populates hidden field on Opportunity 'LG_ProductsInBasketHidden__c' which is used for email alert 'LG_SendOpportunityDetailsToOPT' in workflow 'LG_SendOrderRequestMail'
*/

trigger LG_UpdateProductsOnOpportunity on cscfga__Product_Basket__c (after update) {
    Set<Id> OpportunityId = new Set<Id>();
    Set<Id> prdBasketId= new Set<Id>();
    Map<Id, String> ProductMap = new Map<Id, String>();
    List<Opportunity> OpportunityToUpdate = new List<Opportunity>(); 
    Map<Id,Id> oppAndProductBasket=new Map<Id,Id>();
    No_Triggers__c notriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
    
    if (notriggers == null || !notriggers.Flag__c)
    {
        for(cscfga__Product_Basket__c cpb : Trigger.new){
            if (cpb.csordtelcoa__Synchronised_with_Opportunity__c == true && trigger.oldMap.get(cpb.id).csordtelcoa__Synchronised_with_Opportunity__c==false){
                prdBasketId.add(cpb.Id);
                OpportunityId.add(cpb.cscfga__Opportunity__c);
                ProductMap.put(cpb.cscfga__Opportunity__c, cpb.cscfga__Products_In_Basket__c);
                oppAndProductBasket.put(cpb.cscfga__Opportunity__c,cpb.Id);
            }
        }
        
        
        /*List<Opportunity> opportunityProducts = [SELECT Id, LG_ProductsInBasketHidden__c FROM Opportunity WHERE Id IN :OpportunityId];

for(Opportunity opp : opportunityProducts){
opp.LG_ProductsInBasketHidden__c = ProductMap.get(opp.id);
OpportunityToUpdate.add(opp);
}*/
        if(!prdBasketId.isEmpty()){
            List<cscfga__Product_Configuration__c> lpcs=[Select id,LG_Address__c from cscfga__Product_Configuration__c where cscfga__Product_Basket__c in :prdBasketId];
            Set<String> lgac=new Set<String>();
            for(cscfga__Product_Configuration__c lp:lpcs){
                lgac.add(lp.LG_Address__c);
            }
            
            if(!lgac.isEmpty()){
                Map<String,cscrm__Address__c> addresses=new Map<String,cscrm__Address__c>([Select LG_FullAddressDetails__c from cscrm__Address__c where Id in :lgac]);
                integer addressSize=addresses.size();
                //----to update product category on opportunity based on product name//
                //List<cscfga__Attribute__c> Attribute = [SELECT cscfga__Product_Configuration__c, cscfga__Product_Configuration__r.cscfga__Product_Basket__c, Name FROM cscfga__Attribute__c WHERE cscfga__Product_Configuration__r.cscfga__Product_Basket__c in :prdBasketId];
                set<string> myset = new set<string>();
                if(!prdBasketId.isEmpty()){ 
                    List<cscfga__Attribute__c> Attribute2 = [Select cscfga__Value__c from cscfga__Attribute__c where cscfga__Product_Configuration__r.cscfga__Product_Basket__c in :prdBasketId AND name='Estimated Price (CAPEX)'];
                    
                    //----update ends
                    for(ID loopVar : OpportunityId ) {
                        //to update product category on opportunity based on product name
                        String productName=ProductMap.get(loopVar);
                        String productCat='';
                        
                        productCat='Standard';
                        if(productName.contains('Fiber')){
                            productCat='Complex';
                        }
                        
                        for (cscfga__Attribute__c Obj : Attribute2 )
                        {
                            String check= Obj.cscfga__Value__c;
                            system.debug('TestPC2_Attribute'+check);
                            if (addressSize>1)
                            {
                                //system.debug('TestPC2_Attribute234'+check);
                                system.debug('Address size2'+addressSize);
                                productCat='Complex Plus';
                            }
                            else if (productName.contains('Fiber') || (check!=null))
                            { 
                                productCat='Complex';
                                system.debug('Address size'+addressSize);
                            }
                            
                        }
                        
                        
                        //----update ends
                        
                        OpportunityToUpdate.add(new Opportunity(ID = loopVar, LG_ProductsInBasketHidden__c = ProductMap.get(loopVar),
                                                                UM_Product_Categories__c=productCat,Product_Basket__c=oppAndProductBasket.get(loopVar)));
                    }
                    
                }
            }
        }
        if (OpportunityToUpdate != null && OpportunityToUpdate.size()>0){
            update OpportunityToUpdate;
        }
    }
}