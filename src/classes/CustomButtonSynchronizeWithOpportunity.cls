/**
* Used for the Product Basket 'Sync' with opportunity button'
*
* @author Tomislav Blazek
* @ticket SFDT-164 - fixed the bug in Sync button
* @since  29/1/2016
***********************************************************************************************************************
*
*@update: 22/11/2017 : Updated for validation of BDS Standort, Cloud Access & VPN Service products to prevent basket synchronization implementing BDS Sprint 5 stories.
*@update: 15/12/2017 : 1.Addition of business anywhere validation rule DGT-182, where Business Anywhere should be bundle bds site and access product
*                      2.Code re-factoring
* 
* Called From : Console(object)-> CustomButton->SynchronizeWithOpportunity (custom button on the basket page)
*
***********************************************************************************************************************
* Description : Class is called when sync button is clicked in product basket, it performs validation on the products added based on the business requirements 
*/ 
global with sharing class CustomButtonSynchronizeWithOpportunity extends csbb.CustomButtonExt { 
    
    public static final String errorMsg = '{"status":"error","title":"Error",'
        + '"text":"Basket must be in status Valid."}';
    /******************************************************************
* Description     : Throws error if the below conditions are met. 
* Input Parameter   : Current basket id
* Called From    : 
*******************************************************************/
    public String performAction (String basketId) {
        
        /* Variable declaration and initialization*/
        String action = '';
        
        Boolean isBGPPending = false;
        
        set<String> relConfIds = new Set<String>();
        Set<String> duplicateConnectionCheck = new Set<String>();
        set<String> persistentId = new Set<String>();
        Set<Id> standortToAccessLkup = new Set<Id>();
        Set<Id> BDSAccess = new Set<Id>();
        Set<Id> VDSLInbasket = new Set<Id>();
        set<String> configAddressId = new Set<String>();
        set<String> KudensetupAddressId = new Set<String>();
        
        Integer countOfConnectionInBasket=0;
        
        String businessAnywhere = Label.Business_Anywhere;
        String BDSsite = Label.BDS_Site;
        String VPNService = Label.VPN_services;
        String VPNConnection = Label.Company_VPN_Connection;
        //String companyFiber = Label.Company_Fiber;
        String companyCloudFiber = Label.Company_Cloud_Fiber;
        
        String CFAddOn = Label.CF_Service_Configuration;
        String companyCloudConnect = Label.Company_Cloud_Connect;
        String CCCOffnet = Label.CCC_Offnet;
        String CCCVdsl = Label.CCC_VDSL;
        
        //To pick Standort and VPN services - to be changed to One entry later
        List<String> BDSprodNames =  new List<String>{businessAnywhere,
            VPNConnection,companyCloudConnect,CFAddOn,CCCOffnet,CCCVdsl,BDSsite,VPNService};
                
                /*queries*/
                cscfga__Product_Basket__c basket = [SELECT Id, cscfga__Basket_Status__c, csordtelcoa__Change_Type__c,cscfga__Products_In_Basket__c,
                                                    csbb__Account__c,
                                                    csordtelcoa__Synchronised_with_Opportunity__c,
                                                    csbb__Synchronised_With_Opportunity__c,
                                                    cscfga__Opportunity__r.Id
                                                    FROM cscfga__Product_Basket__c
                                                    WHERE Id = :basketId];                                
        //list of Virtual voice PCs 
        
        if(basket.cscfga__Products_In_Basket__c != null && basket.cscfga__Products_In_Basket__c.contains('Virtual Voice'))
        {
            List<cscfga__Product_Configuration__c> listofhpbxInBasket = [select id, Name,LG_Address__c,LG_ProductDefinitionName__c from cscfga__Product_Configuration__c where cscfga__Product_Basket__c = :basketId and cscfga__Product_Definition__r.name like 'Virtual Voice%' order by LG_ProductDefinitionName__c];
            
            
            for (cscfga__Product_Configuration__c p : listofhpbxInBasket) {
                
                configAddressId.Add(p.LG_Address__c);
                
                
                if(p.Name=='Virtual Voice Kudensetup'){
                    KudensetupAddressId.Add(p.LG_Address__c);
                }
                
            }
            
            if(!configAddressId.containsAll(KudensetupAddressId))
            {
                configAddressId.removeAll(KudensetupAddressId);
            }
            
            for(Id AddressId:configAddressId)
            {
                List <csord__Service__c> lstService=[SELECT Id, Name,LG_Address__c,UM_ServiceStatus__c,csord__Subscription__r.csord__Account__c FROM csord__Service__c where UM_ServiceStatus__c='Active' and Name='Virtual Voice Kundensetup' and csord__Subscription__r.csord__Account__c =:basket.csbb__Account__c and LG_Address__c=:AddressId];
                
                if(lstService.size()!=0)
                {
                    
                    configAddressId.remove(AddressId);
                }
                
                
            }
            if(configAddressId.size()!=0)
            {
                //return  action = '{"status":"error","title":"Error",'
                  //  + '"text":"Virtual Voice Kundensetup Produkt is required."}'; 
            }
        }   
         
        
        //PC query : fetching all product configuration from current basket using BDSprodNames list filter 
        List<cscfga__Product_Configuration__c> listofBDSInBasket = [select id, name, LG_SecondaryAccess__c,LG_ChangeType__c,cscfga__Product_Family__c, LG_PlanningDetailsStatus__c, 
                                                                    LG_Persistent_Id__c, LG_From_Configuration__c, LG_To_Configuration__c,cscfga__Configuration_Status__c,LG_Address__c,
                                                                    LG_ProductDefinitionName__c,UM_DependsOnProductConfiguration__c,
                                                                    (select cscfga__Value__c from cscfga__Attributes__r where name='isCCFPresent' limit 1) 
                                                                    from cscfga__Product_Configuration__c where cscfga__Product_Basket__c = :basketId and cscfga__Product_Definition__r.name in :BDSprodNames];    
        
        if(basket.csordtelcoa__Change_Type__c == 'New'){
            
            Boolean isBAInBasket = false;            
            Set<Id> prodConfigIds = new Set<Id>();        
            List<cscfga__Attribute__c> StandortAccessPrimary = new List<cscfga__Attribute__c>();            
            
           
            /* Setting boolean values and creating list as per business requirements*/
            for(cscfga__Product_Configuration__c pc: listofBDSInBasket){
                 system.debug('starting>>>' + standortToAccessLkup);
                 system.debug('starting>>> pc' + pc);
                if(pc.cscfga__Configuration_Status__c!='Valid'){                 
                    return action = '{"status":"error","title":"Error",'+ '"text": "' + Label.Invalid_Configuration_Basket + '"}';
                }
                system.debug('pc.cscfga__Product_Family__c :::' + pc.cscfga__Product_Family__c +'::: '+ CFAddOn);
                if(pc.cscfga__Product_Family__c!=null && pc.LG_PlanningDetailsStatus__c!=null && pc.cscfga__Product_Family__c.equals(CFAddOn) && pc.LG_PlanningDetailsStatus__c.equals('Pending')){           
                    isBGPPending = true;
                    break;
                }    
                else if(pc.LG_ProductDefinitionName__c.equals(businessAnywhere)){                
                    isBAInBasket = true;
                }
                else if(pc.LG_ProductDefinitionName__c.equals(VPNConnection)){                
                    relConfIds.add(pc.LG_From_Configuration__c);
                    relConfIds.add(pc.LG_To_Configuration__c);
                    countOfConnectionInBasket++;
                    duplicateConnectionCheck.add(pc.LG_From_Configuration__c+pc.LG_To_Configuration__c);   
                }
                else if(pc.LG_ProductDefinitionName__c.equals(BDSsite)){
                     system.debug('1>>>' + standortToAccessLkup);
                    standortToAccessLkup.add(pc.UM_DependsOnProductConfiguration__c);
                    if(!String.isEmpty(pc.LG_SecondaryAccess__c)){
                    system.debug('2>>>' + standortToAccessLkup);
                        standortToAccessLkup.add(pc.LG_SecondaryAccess__c);
                    }                    
                    persistentId.add(pc.LG_Persistent_Id__c);
                    prodConfigIds.add(pc.id);
                    
                }
                else if(pc.LG_ProductDefinitionName__c.equals(VPNService)){                
                    persistentId.add(pc.LG_Persistent_Id__c);
                }
                else if(pc.LG_ProductDefinitionName__c.equals(CFAddOn) && pc.name.StartsWith(companyCloudFiber)){
                    
                        BDSAccess.add(pc.id);
                        
                }
                else if (pc.LG_ProductDefinitionName__c.equals(companyCloudConnect)) {                 
                    BDSAccess.add(pc.id);
                }
                else if(pc.LG_ProductDefinitionName__c.equals(CCCOffnet)){                
                    BDSAccess.add(pc.id);
                }
                /* VDSL product can be sold independently, however, if its is part of BDS standort, the product existence to be checked on basket / Account */
                else if(pc.LG_ProductDefinitionName__c.equals(CCCVdsl)){                 
                    VDSLInbasket.add(pc.id);    /* Adding it to a Temporary Set, which will be compared with standortToAccessLkup, to find if VDSL is part of BDSStandort. If yes, Consider for validation */
                    
                }
            }

            for(Id VDSLPc: VDSLInbasket){
                
                if(standortToAccessLkup.contains(VDSLPc)){                
                    BDSAccess.add(VDSLPc);            
                }
                
            }
            
            /* Service query : fetching all product definition of type 'BDS Standort' and the access products from current basket's account. If Access products are selected from Account in Standort product, the same would be added to BDSAccess map. */
            List<csord__Service__c> listofAccessInAccount = [select id, LG_Address__c,csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c, csordtelcoa__Product_Configuration__r.LG_Persistent_Id__c,csordtelcoa__Product_Configuration__c 
                                                             from csord__Service__c where csord__Subscription__r.csord__Account__c=:basket.csbb__Account__c and 
                                                             csord__Subscription__r.csord__Status__c = 'Active' and 
                                                             ((csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c =:BDSsite) OR (csordtelcoa__Product_Configuration__c in :standortToAccessLkup) OR (csordtelcoa__Product_Configuration__c in :relConfIds))];
            
            for(csord__Service__c serviceRec : listofAccessInAccount){   
                
                if(serviceRec.csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c.equals(BDSsite)){                
                    prodConfigIds.add(serviceRec.csordtelcoa__Product_Configuration__c);
                    if (relConfIds.contains(serviceRec.csordtelcoa__Product_Configuration__r.LG_Persistent_Id__c)) {
                        persistentId.add(serviceRec.csordtelcoa__Product_Configuration__r.LG_Persistent_Id__c);
                    }
                }
                else if (serviceRec.csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c.equals(VPNService)) {
                    persistentId.add(serviceRec.csordtelcoa__Product_Configuration__r.LG_Persistent_Id__c);
                }
                else{                    
                    BDSAccess.add(serviceRec.csordtelcoa__Product_Configuration__c);
                }
                
            }
            
            //Since long text area cannot be queried directly, the same is done to check the value and add it to MAP.
            for( cscfga__Attribute__c attrv: [select id, name, cscfga__Value__c from cscfga__Attribute__c where name ='Primary Access Type' and cscfga__Product_Configuration__c=:prodConfigIds ]){
                
                /* filltering product config's attribut based on Primary access type with value 'onnet' */
                if((attrv.name.equals('Primary Access Type')) && (attrv.cscfga__Value__c.contains('Onnet'))){                     
                    StandortAccessPrimary.add(attrv);
                }
                
            }
            
            if(isBGPPending == true) {
                return  action = '{"status":"error","title":"Error",'+ '"text":"' + Label.Pending_BGP_Details + '"}';
            }
            
            system.debug('standortToAccessLkup>>>>'+standortToAccessLkup); 
            system.debug('BDSAccess>>>>'+BDSAccess); 
            
            /* This checks if the access products selected in BDS Standort is part of the current basket or part of the account, and throws error if not. Also, CCC, CF+CCF and CCVDSL products are to be sold with Site.
If selected independently without SITE, it throws error. */
            if((standortToAccessLkup.size()!=BDSAccess.size() || !standortToAccessLkup.equals(BDSAccess))){ 
                
                /* if BDS site and access not bundled together */       
                return  action = '{"status":"error","title":"Error",'+ '"text":"' + Label.Site_Access_Dependecy + '"}';
            }
            else if(relConfIds.size()!= persistentId.size() ||!relConfIds.equals(persistentId)) {
                
                /*if site/network added but not used*/
                return action = '{"status":"error","title":"Error",'+ '"text":"' + Label.Connection_Site_VPN_Dependency + '"}';
            } 
            else if(duplicateConnectionCheck.size() != countOfConnectionInBasket)
            {                
                return  action = '{"status":"error","title":"Error",'+ '"text":"' + Label.Duplicate_Connection + '"}';                  
            }
            else if(isBAInBasket && (StandortAccessPrimary.isEmpty())){
                
                /*if business anywhere is added and no BDs site is found at account or basket level */
                return action = '{"status":"error","title":"Error",'+ '"text":"' + Label.Business_Anywhere_Validation + '"}';
            }
            
        }
        else if(basket.csordtelcoa__Change_Type__c == 'Change'){
            
            Set<Id> BDSPremiseInAccount = new Set<Id>();
            Map<Id, Id> CCFPremisetoPCInbasket = new Map<Id, Id>();            
            
            for(cscfga__Product_Configuration__c pc: listofBDSInBasket){
                
                if(pc.cscfga__Configuration_Status__c!='Valid'){                     
                    return action = '{"status":"error","title":"Error",'+ '"text": "' +Label.Invalid_Configuration_Basket+ '"}';
                }
                
                if(pc.cscfga__Product_Family__c!=null && pc.LG_PlanningDetailsStatus__c!=null && pc.cscfga__Product_Family__c.equals(CFAddOn) && pc.LG_PlanningDetailsStatus__c.equals('Pending')){             
                    isBGPPending = true;
                    break;
                }
                
                if((pc.LG_ProductDefinitionName__c.equals(CFAddOn)) && (pc.name.StartsWith(companyCloudFiber)) ){
                    
                    
                        //CFPremiseInBasket.add(pc.LG_Address__c);
                        CCFPremisetoPCInbasket.put(pc.LG_Address__c, pc.id);
                    
                    
                }
                else if(pc.LG_ProductDefinitionName__c.equals(VPNConnection) && pc.LG_ChangeType__c == 'New'){
                    
                    relConfIds.add(pc.LG_From_Configuration__c);
                    relConfIds.add(pc.LG_To_Configuration__c);
                    countOfConnectionInBasket++;
                    duplicateConnectionCheck.add(pc.LG_From_Configuration__c+pc.LG_To_Configuration__c);
                }
                else if(pc.LG_ProductDefinitionName__c.equals(BDSsite)){
                    
                    if(pc.LG_ChangeType__c == 'New'){
                        persistentId.add(pc.LG_Persistent_Id__c);
                    }
                    //adding Primary access                        
                    standortToAccessLkup.add(pc.UM_DependsOnProductConfiguration__c);
                    
                    //adding secondary access 
                    if(!String.isEmpty(pc.LG_SecondaryAccess__c)){
                        standortToAccessLkup.add(pc.LG_SecondaryAccess__c);
                    }
                        
                                   
                }
                else if(pc.LG_ProductDefinitionName__c.equals(VPNService) && pc.LG_ChangeType__c == 'New'){                    
                    persistentId.add(pc.LG_Persistent_Id__c);
                }
                
                else if (pc.LG_ProductDefinitionName__c.equals(companyCloudConnect) && pc.LG_ChangeType__c == 'New') {                    
                    BDSAccess.add(pc.id);
                }
                else if(pc.LG_ProductDefinitionName__c.equals(CCCOffnet) && pc.LG_ChangeType__c == 'New'){                    
                    BDSAccess.add(pc.id);
                }
                /* VDSL product can be sold independently, however, if its is part of BDS standort, the product existence to be checked on basket / Account */
                else if(pc.LG_ProductDefinitionName__c.equals(CCCVdsl) && pc.LG_ChangeType__c == 'New'){                     
                    VDSLInbasket.add(pc.id);    /* Adding it to a Temporary Set, which will be compared with standortToAccessLkup, to find if VDSL is part of BDSStandort. If yes, Consider for validation */                    
                }
            }
            
            for(Id VDSLPc: VDSLInbasket){
                
                if(standortToAccessLkup.contains(VDSLPc)){                    
                    BDSAccess.add(VDSLPc);                    
                }
                
            }            
            
            if(isBGPPending == true){
                return  action = '{"status":"error","title":"Error",'+ '"text":"' + Label.Pending_BGP_Details + '"}';
            }            
            
            //Service query : fetching all product definition of type 'BDS Standort' from current basket's account 
            List<csord__Service__c> listofBDSInAccount = [select id, csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c, csordtelcoa__Product_Configuration__c,LG_Address__c 
                                                          from csord__Service__c where csord__Subscription__r.csord__Account__c=:basket.csbb__Account__c and 
                                                          csord__Subscription__r.csord__Status__c = 'Active' and csordtelcoa__Product_Configuration__r.cscfga__Product_Family__c =:BDSsite and 
                                                          LG_Address__c in :CCFPremisetoPCInbasket.keySet()];
            
            for(csord__Service__c serviceRec : listofBDSInAccount){
                BDSPremiseInAccount.add(serviceRec.LG_Address__c);
            }
            
            for(Id premise: CCFPremisetoPCInbasket.keySet()){
                
                if(!BDSPremiseInAccount.contains(premise)){
                    BDSAccess.add(CCFPremisetoPCInbasket.get(premise));
                }                
            } 
            
            if(!BDSAccess.isEmpty() && (standortToAccessLkup.isEmpty() || !standortToAccessLkup.containsAll(BDSAccess))){                
                return  action = '{"status":"error","title":"Error",'+ '"text":"' + Label.Site_Access_Dependecy + '"}';                
            }
            else if(!relConfIds.containsAll(persistentId)) {  
                
                /*if site/network added but not used*/
                return action = '{"status":"error","title":"Error",'+ '"text":"' + Label.Connection_Site_VPN_Dependency + '"}';
            }
            else if(duplicateConnectionCheck.size() != countOfConnectionInBasket){                
                return  action = '{"status":"error","title":"Error",'+ '"text":"' + Label.Duplicate_Connection + '"}';                  
            }            
        }        
        
        if ('Valid'.equals(basket.cscfga__Basket_Status__c))   {
            
            Opportunity opp = basket.cscfga__Opportunity__r;
            
            //de-sync first and then synce again
            if (basket.csordtelcoa__Synchronised_with_Opportunity__c
                || basket.csbb__Synchronised_With_Opportunity__c) {
                    basket.csordtelcoa__Synchronised_with_Opportunity__c = false;
                    basket.csbb__Synchronised_With_Opportunity__c        = false;
                    update basket;
                }
            
            basket.csordtelcoa__Synchronised_with_Opportunity__c = true;
            basket.csbb__Synchronised_With_Opportunity__c        = true;
            update basket;
            
            PageReference oppPage = new ApexPages.StandardController(opp).view();
            
            action =  '{"status":"ok","redirectURL":"' + oppPage.getUrl() + '"}';
        } else
        {
            action = errorMsg;
        }
        return action; 
        
    }   
    
}