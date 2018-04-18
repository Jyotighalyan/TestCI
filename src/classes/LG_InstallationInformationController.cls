/**
* Used as a controller for LG_InstallationInformation VF page.
*
* @author Tomislav Blazek
* @ticket SFDT-221
* @since  11/02/2016
*/
public with sharing class LG_InstallationInformationController {
    
    public cscfga__Product_Basket__c basket {get; set;}
    public List<cscrm__Address__c> sites {get; set;}
    public Map<Id, Integer> siteMinLeadTime {get; set;}
    public Map<Id, Date> siteMinInstallDate {get; set;}
    public Map<Id, String> siteWishDate {get; set;}
    public Map<Id, String> sitePlannedDate {get; set;}
    public String siteIdToPlannedDates {get; set;}
    public String siteIdToWishDates {get; set;}
    public Map<Id, String> siteMarketSegment {get; set;}
    public cscrm__Address__c dummyForTechContact {get; set;}
    private Id basketId;
    private Id returnId;
    private Id newContactId;
    private Map<Id, List<cscfga__Product_Configuration__c>> siteToProdConfs {get; set;}
    private Map<Id, Id> prodConfToSite {get; set;}
    
        
    //Updated as part of QNT-441
    public Map<String, String> productConfigNames { get; set; }
    
    //GG
    private List<SiteWrapper>  allSites {get; set;}
    public List<SiteWrapper> getAllSites(){
         return this.allSites;
    }

    public PageReference createNewContact() {
        PageReference newContactPage = new PageReference('/' + Contact.getSObjectType().getDescribe().getKeyPrefix() + '/e');
        String accFieledReference = LG_Util.getLookupFieldReferenceId(newContactPage,
                                        Account.getSObjectType().getDescribe().getKeyPrefix());

        newContactPage.getParameters().put('saveURL', '/apex/LG_InstallationInformation?basketId='+basketId);
        newContactPage.getParameters().put(accFieledReference, basket.csbb__Account__r.Name);
        newContactPage.getParameters().put(accFieledReference + '_lkid', basket.csbb__Account__r.Id);
        newContactPage.getParameters().put('retURL','/apex/LG_InstallationInformation?basketId='+basketId);
        return newContactPage;
    }
    
    public LG_InstallationInformationController() {
        basketId = ApexPages.currentPage().getParameters().get('basketId');
        returnId = ApexPages.currentPage().getParameters().get('returnId');
        newContactId = ApexPages.currentPage().getParameters().get('newid');

        sites = new List<cscrm__Address__c>();
        
        if (String.isBlank(returnId))
        {
            returnId = basketId;
        }

        if (basketId != null)
        {
            basket = [SELECT Id, csordtelcoa__Change_Type__c, Name,
                        csbb__Account__r.Name, csbb__Account__r.Id
                        FROM cscfga__Product_Basket__c
                        WHERE Id = :basketId];

            //fetch the product configuration - sites
            //Below query changed part of QNT-441. 
            //Added Name, cscfga__Product_Family__c, LG_ProductDefinitionName__c,LG_PlanningDetailsStatus__c,cscfga__Configuration_Status__c,cscfga__Parent_Configuration__c in inner query
            //Added Consulting_ID__c,GNV__c in outer select
            sites = [SELECT Id, LG_FullAddressDetails__c, cscrm__Account__c,
                            LG_COAXConnectionLocation__c,
                            LG_SharedOfficeBuilding__c, LG_TechnicalContact__c,
                            (SELECT Id,Name,cscfga__Product_Family__c,LG_ProductDefinitionName__c,cscfga__Parent_Configuration__c,
                                    LG_PlanningDetailsStatus__c,cscfga__Configuration_Status__c,
                                    LG_InstallationClass__c, LG_MarketSegment__c,
                                    LG_InstallationLeadTime__c, LG_InstallationNeeded__c,
                                    LG_InstallationWishDate__c, LG_InstallationPlannedDate__c
                                FROM Product_Configurations__r
                                WHERE cscfga__Product_Basket__r.Id = :basketId
                                //AND LG_InstallationNeeded__c = true
                                AND (LG_InstallationNeeded__c = true OR (Name LIKE 'BGP%'  AND cscfga__Parent_Configuration__r.LG_InstallationNeeded__c  = true AND 
                                cscfga__Parent_Configuration__r.cscfga__Product_Family__c = 'Company Fiber'))
                             )
                     FROM cscrm__Address__c
                     WHERE Id IN (SELECT LG_Address__c
                                    FROM cscfga__Product_Configuration__c
                                    WHERE cscfga__Product_Basket__r.Id = :basketId
                                    AND LG_InstallationNeeded__c = true
                                    AND LG_Address__c != null)
                     ORDER BY LG_FullAddressDetails__c];

            if (!sites.isEmpty())
            {
                dummyForTechContact = new cscrm__Address__c(Id = sites[0].Id, LG_TechnicalContact__c = null,
                                                            cscrm__Account__c = sites[0].cscrm__Account__c);

                if (String.isNotBlank(newContactId))
                {
                    dummyForTechContact.LG_TechnicalContact__c = newContactId;
                }
            }
            
            //GG
            Set<Id> siteIds = new Set<Id>();
            for(cscrm__Address__c site:sites){
                siteIds.add(site.Id);
            }
            
            Map<Id,Site_Survey__c> siteSurveyMap = getSiteSurveyDetails(siteIds);
            
            allSites = new List<SiteWrapper>();
            
            this.productConfigNames = new Map<String, String>(); // QNT-441
            for(cscrm__Address__c site:sites){
                SiteWrapper wrapper = new SiteWrapper();
                wrapper.site = site;
                if(siteSurveyMap.get(site.Id) == null){
                    wrapper.siteSurvey = new Site_Survey__c();
                }else{
                    wrapper.siteSurvey = siteSurveyMap.get(site.Id);
                }
                //wrapper.siteSurvey = siteSurveyMap.get(site.Id);
                
                //QNT-441
                system.debug('site.Product_Configurations__r'+site.Product_Configurations__r);
                for(cscfga__Product_Configuration__c pc:site.Product_Configurations__r){
                    
                    wrapper.productName = pc.Name;
                    // If product is company fiber then don't show certain fields like COAX Connection Location,Earliest possible wish date : & Planned Date
                    system.debug('pc.cscfga__Product_Family__c@@'+pc.cscfga__Product_Family__c);
                    if(!pc.cscfga__Product_Family__c.contains('Company Fiber') && pc.cscfga__Parent_Configuration__c ==null)
                    {
                        wrapper.displaySiteDetailFields=true;
                        wrapper.productFamily='NonCF'; // To make the site details flag green when there is a non CF product
                        system.debug('wrapper.productFamily'+wrapper.productFamily);
                        // To set site details flag green when there is a non Company Fiber product
                        wrapper.siteDetailsFlagValue='confirm32.png'; 
                    }
                    else if((pc.cscfga__Product_Family__c.contains('Company Fiber') || pc.cscfga__Product_Family__c.contains('Company Fiber Service Configuration')) && !wrapper.displaySiteDetailFields)
                    {
                        wrapper.displaySiteDetailFields=false;
                        wrapper.productFamily='CF';
                        system.debug('wrapper.productFamily1'+wrapper.productFamily);
                        // To set the site details flag value on page load.
                        if((wrapper.siteSurvey.UM_Consulting_ID__c!=null && wrapper.siteSurvey.UM_Consulting_ID__c!='') && (wrapper.siteSurvey.UM_GNV__c!=null && wrapper.siteSurvey.UM_GNV__c!=''))
                        {
                            wrapper.siteDetailsFlagValue='confirm32.png';
                        }
                        else
                        {
                            wrapper.siteDetailsFlagValue='error32.png';
                        }
                    }
                    //system.debug('wrapper.displaySiteDetailFields--'+wrapper.productName+'--'+wrapper.displaySiteDetailFields);
                    
                    // If prodcut is company fiber then only make consulting ID and GNV required
                    if(!pc.cscfga__Product_Family__c.contains('Company Fiber') && pc.cscfga__Parent_Configuration__c ==null)
                    {
                        // Fix to handle mandatory fields when there is atleast one CF product on a site -- 24th Feb                        
                        if(wrapper.requiredField)
                        {                            
                            wrapper.productFamily='CF';
                            system.debug('wrapper.productFamily2'+wrapper.productFamily);
                            // To set the site details flag value on page load when there is at least one CF product along with Non CF product and the fields are mandatory
                            if((wrapper.siteSurvey.UM_Consulting_ID__c!=null && wrapper.siteSurvey.UM_Consulting_ID__c!='') && (wrapper.siteSurvey.UM_GNV__c!=null && wrapper.siteSurvey.UM_GNV__c!=''))
                            {
                                wrapper.siteDetailsFlagValue='confirm32.png';
                            }
                            else
                            {
                                wrapper.siteDetailsFlagValue='error32.png';
                            }
                        }
                        else
                        {
                            wrapper.requiredField=false;
                            wrapper.productFamily='NonCF';
                            system.debug('wrapper.productFamily3'+wrapper.productFamily);
                        }
                        //end 
                    }
                    // Below && condition modified fo Fix to handle mandatory fields when there is atleast one CF product on a site -- 24th Feb
                    else if((pc.cscfga__Product_Family__c.contains('Company Fiber') || pc.cscfga__Product_Family__c.contains('Company Fiber Service Configuration')) && !wrapper.requiredField)
                    {
                        wrapper.requiredField=true;
                        wrapper.productFamily='CF'; // added 1 March 2018
                    }
                    //system.debug('wrapper.requiredField--'+wrapper.productName+'--'+wrapper.requiredField);
                    
                    
                    if(pc.Name.contains('BGP'))
                    {
                        wrapper.displayProducts=true; // If there is a BGP product in the list then show the products tab.
                        system.debug('wrapper.displayProducts--'+wrapper.displayProducts);
                        if(pc.LG_PlanningDetailsStatus__c == 'complete' && pc.cscfga__Configuration_Status__c == 'valid')
                        {
                            wrapper.productFlagValue='confirm32.png';
                        }
                        else
                        {
                            wrapper.productFlagValue='error32.png';
                        }
                        system.debug('wrapper.productFlagValue--'+wrapper.productFlagValue);
                        //break; // To stop searching in the product config list, once a BGP product is found
                    }
                    
                    // To set the site details flag value on page load.
                    /*if((wrapper.siteSurvey.UM_Consulting_ID__c!=null && wrapper.siteSurvey.UM_Consulting_ID__c!='') && (wrapper.siteSurvey.UM_GNV__c!=null && wrapper.siteSurvey.UM_GNV__c!=''))
                    {
                        wrapper.siteDetailsFlagValue='confirm32.png';
                    }
                    else
                    {
                        wrapper.siteDetailsFlagValue='error32.png';
                    }*/
                    
                    // To add elements to the Map productConfigNames and pass to screen flow on product button click:- 3-Jan-2018
                    String str = pc.Name;
                    str = str.replace('+', '%2B');
                    if (str.contains('BGP')) {
                    str = 'BGP' ;
                    }
                    this.productConfigNames.put(pc.Id, 'Inflight Configuration - ' + str);
                    //system.debug('productConfigNames--'+productConfigNames);
                }
                //end
                
                allSites.add(wrapper);
            }
            
            //GG

            siteMinLeadTime = new Map<Id, Integer>();
            siteMinInstallDate = new Map<Id, Date>();
            siteWishDate = new Map<Id, String>();
            sitePlannedDate = new Map<Id, String>();
            siteToProdConfs = new Map<Id, List<cscfga__Product_Configuration__c >>();
            prodConfToSite = new Map<Id, Id>();
            siteMarketSegment = new Map<Id, String>();
                                   
            system.debug('sites are:'+sites);
            for(cscrm__Address__c site : sites)
            {
                Map<String, Integer> classToLeadTime = new Map<String, Integer>();

                system.debug('site.Product_Configurations__r are:'+site.Product_Configurations__r);
                for(cscfga__Product_Configuration__c prodConf : site.Product_Configurations__r)
                {
                                       
                    //if there is no lead time, prod configuration is  not relevant
                    if (prodConf.LG_InstallationLeadTime__c == null)
                    {
                        continue;
                    }

                    String installClass = prodConf.LG_InstallationClass__c != null ? prodConf.LG_InstallationClass__c : '';
                    system.debug('installClass at 107 is:'+installClass);
                    if (classToLeadTime.containsKey(installClass))
                    {
                        //we want to catch the maximum Lead time in the same Installation class
                        if (prodConf.LG_InstallationLeadTime__c > classToLeadTime.get(installClass))
                        {
                            classToLeadTime.put(installClass, Integer.valueOf(prodConf.LG_InstallationLeadTime__c));
                        }
                    }
                    else
                    {
                        classToLeadTime.put(installClass, Integer.valueOf(prodConf.LG_InstallationLeadTime__c));
                    }
                }
                                
                Integer minLeadTime = 9999;
                String minInstallClass = '';

                for(String installationClass : classToLeadTime.keySet())
                {
                    //Integer installLeadTime = classToLeadTime.get(installationClass);
                    Integer installLeadTime = 0;

                    //We want to get the minimum lead time amongst all (max) lead time of all classes
                    if (installLeadTime < minLeadTime)
                    {
                        minLeadTime = installLeadTime;
                        minInstallClass = installationClass;
                    }
                }

                minLeadTime = minLeadTime != 9999 ? minLeadTime : 0;

                siteMinLeadTime.put(site.Id, minLeadTime);
                siteToProdConfs.put(site.Id, new List<cscfga__Product_Configuration__c>());
                String marketSegment = '';
                
                integer highestLeadTime = 0; //QNT-441
                for(cscfga__Product_Configuration__c prodConf : site.Product_Configurations__r)
                {
                    String installClass = prodConf.LG_InstallationClass__c != null ? prodConf.LG_InstallationClass__c : '';
                    system.debug('installClass at 147 is:'+installClass);
                    //group prod confs of the same class
                    
                    //QNT-441, to get the highest lead time from the prod configs per site
                    /*
                    system.debug('prodConf.LG_InstallationLeadTime__c--'+prodConf.LG_InstallationLeadTime__c);
                    integer installationLeadTime = Integer.valueOf(prodConf.LG_InstallationLeadTime__c);
                    system.debug('installationLeadTime--'+installationLeadTime);
                    if(highestLeadTime<installationLeadTime){
                        highestLeadTime=installationLeadTime;
                    }               
                    system.debug('highestLeadTime--'+highestLeadTime);
                    */
                    //end
                    
                    if (minInstallClass.equals(installClass))
                    {
                        system.debug('prodConf.LG_InstallationLeadTime__c--'+ prodConf.Id + '-' + prodConf.LG_InstallationLeadTime__c);
                        siteToProdConfs.get(site.Id).add(prodConf);
                        prodConfToSite.put(prodConf.Id, site.Id);
                        //story-SFOM-1916**Wish Date should be defaulted to Today() if empty**
                        if(prodConf.LG_InstallationWishDate__c==null)
                        {
                        //QNT-441, append the higest lead time per site with system date and assign to site wish date.
                        //siteWishDate.put(site.Id, getFormattedDate(date.today().addDays(highestLeadTime)));
                        siteWishDate.put(site.Id,getFormattedDate(date.today()));
                        system.debug('siteWishDate--'+siteWishDate);
                        }
                        else{
                        siteWishDate.put(site.Id, getFormattedDate(prodConf.LG_InstallationWishDate__c));
                        }
                        
                        sitePlannedDate.put(site.Id, getFormattedDate(prodConf.LG_InstallationPlannedDate__c));
                        marketSegment = prodConf.LG_MarketSegment__c;
                    }
                }
                
                siteMinInstallDate.put(site.Id, getMinInstallDate(minLeadTime, marketSegment));
                siteMarketSegment.put(site.Id, marketSegment != null ? marketSegment : '');
            }
            
        }
    }
    
    //GG
    private Map<Id,Site_Survey__c> getSiteSurveyDetails(Set<Id> siteIds){
        Map<Id,Site_Survey__c> siteSurveyMap = new Map<Id,Site_Survey__c>();
        List<Site_Survey__c> sitesurveyList = [SELECT Id, UM_GNV__c, UM_Consulting_ID__c, Address__c FROM Site_Survey__c WHERE Address__c IN : siteIds];
        
        for(Site_Survey__c siteSurvey : sitesurveyList){
            if(!siteSurveyMap.ContainsKey(siteSurvey.Address__c)){
                siteSurveyMap.put(siteSurvey.Address__c,siteSurvey);
            }
        }
        return siteSurveyMap;
    }

    // formats the date in the dd-mm-yyyy format
    private String getFormattedDate(Date value)
    {
        String formattedDate = '';

        if (value != null)
        {
            formattedDate = value.day() + '-' + value.month() + '-' + value.year();
        }

        return formattedDate;
    }

    //Calculates the minimum install date: today() + min lead time (in days).
    //if calculated date falls upon saturday or sunday, based on the market segment
    //return the next day /monday/
    private Date getMinInstallDate(Integer minLeadTime, String marketSegment)
    {
        Date minInstallDate = Date.today();
        minInstallDate = minInstallDate.addDays(minLeadTime);

        Boolean small = 'Small'.equals(marketSegment);

        DateTime dtMinDate = (DateTime) minInstallDate;
        String dayOfWeek = dtMinDate.format('EEE');

        if  (dayOfWeek.equals('Sat') && small)
        {
            minInstallDate = minInstallDate.addDays(2);
        }
        else if (dayOfWeek.equals('Sun'))
        {
            minInstallDate = minInstallDate.addDays(1);
        }

        return minInstallDate;
    }

    /**
     * Saves/Updates the Address/Site records with the Installation Information data
     *
     * @author Tomislav Blazek
     * @ticket SFDT-221
     * @since  11/02/2016
     */
    public PageReference save()
    {
        //GG
        List<Site_Survey__c> siteSurveyToInsert = new List<Site_Survey__c>();
        List<Site_Survey__c> siteSurveyToUpdate = new List<Site_Survey__c>();
        List<cscrm__Address__c> siteList = new List<cscrm__Address__c>();
        for(SiteWrapper wrapperSite: allSites){
            siteList.add(wrapperSite.site);
            
            if(wrapperSite.siteSurvey.Id == null){
                wrapperSite.siteSurvey.Address__c = wrapperSite.site.Id;
                siteSurveyToInsert.add(wrapperSite.siteSurvey);
            }else{
                siteSurveyToUpdate.add(wrapperSite.siteSurvey);
            }
            /*
            system.debug('UM_Consulting_ID__c@@@'+wrapperSite.siteSurvey.UM_Consulting_ID__c);
            if(wrapperSite.siteSurvey.UM_Consulting_ID__c == null || wrapperSite.siteSurvey.UM_Consulting_ID__c == ''){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please fill the mandatory fields'));  
                return null;
            }*/
            
            
        }
        try{
            update siteList;
            update siteSurveyToUpdate;
            insert siteSurveyToInsert;
        
        }catch(Exception e){
            System.debug('Error:'+e.getMessage());
        }
        //update sites;
        //GG

        saveWishPlannedDates();

        return redirectToReturnId();
    }

    //saves the wish date and planned dates on the product configurations of
    //the same class (and the same site) and saves the same dates on the related
    //product configuration attributes
    private void saveWishPlannedDates()
    {
        Set<Id> siteIds = new Set<Id>();
        Map<Id, Date> siteIdToWishDate = new Map<Id, Date>();
        Map<Id, Date> siteIdToPlannedDate = new Map<Id, Date>();


        for (String siteDate : siteIdToWishDates.split('#'))
        {
            if (String.isNotBlank(siteDate))
            {
                Id siteId = siteDate.split('~')[0];
                Date wishDate = null;

                if (siteDate.split('~').size() > 1)
                {
                    String wishDateStr = siteDate.split('~')[1];
                    //date is in dd-mm-yyyy format so we should create a new instance properly formatted
                    wishDate = Date.newInstance(Integer.valueOf(wishDateStr.split('-')[2]),
                                                Integer.valueOf(wishDateStr.split('-')[1]),
                                                Integer.valueOf(wishDateStr.split('-')[0]));
                }

                //take the site Id from the string
                siteIds.add(siteId);
                siteIdToWishDate.put(siteId, wishDate);
            }
        }

        for (String siteDate : siteIdToPlannedDates.split('#'))
        {
            if (String.isNotBlank(siteDate))
            {
                Id siteId = siteDate.split('~')[0];
                Date plannedDate = null;

                if (siteDate.split('~').size() > 1)
                {
                    String plannedDateStr = siteDate.split('~')[1];
                    //date is in dd-mm-yyyy format so we should create a new instance properly formatted
                    plannedDate = Date.newInstance(Integer.valueOf(plannedDateStr.split('-')[2]),
                                                Integer.valueOf(plannedDateStr.split('-')[1]),
                                                Integer.valueOf(plannedDateStr.split('-')[0]));
                }

                //take the site Id from the string
                siteIds.add(siteId);
                siteIdToPlannedDate.put(siteId, plannedDate);
            }
        }
        system.debug('siteIds are:'+siteIds+'siteToProdConfs are:'+siteToProdConfs);
        if (!siteIds.isEmpty())
        {
            Set<cscfga__Product_Configuration__c> prodConfsSet = new Set<cscfga__Product_Configuration__c>();

            for(Id siteId : siteIds)
            {
                if (siteToProdConfs.containsKey(siteId))
                {
                    prodConfsSet.addAll(siteToProdConfs.get(siteId));
                }
            }

            system.debug('prodConfsSet is:'+prodConfsSet);
            List<cscfga__Product_Configuration__c> prodConfs = [SELECT Id,LG_InstallationWishDate__c, LG_InstallationPlannedDate__c,
                                                                    LG_Address__c, csordtelcoa__Replaced_Subscription__c,
                                                                    (SELECT Name, cscfga__Value__c, cscfga__Display_Value__c
                                                                        FROM cscfga__Attributes__r
                                                                        WHERE Name IN ('Installation Planned Date', 'Installation Wish Date')
                                                                    )
                                                                FROM cscfga__Product_Configuration__c
                                                                WHERE Id IN :prodConfsSet];
            system.debug('prodConfs is:'+prodConfs);
            List<cscfga__Attribute__c> attributesToUpdate = new List<cscfga__Attribute__c>();
            List<cscfga__Product_Configuration__c> prodConfsToUpdate = new List<cscfga__Product_Configuration__c>();
            
            // added as part of QNT-441
            /*
            this.productConfigNames = new Map<String, String>();
            for (cscfga__Product_Configuration__c pc :prodConfs) {
                system.debug('prodConfs is:'+pc);
                String str = pc.Name;
                str = str.replace('+', '%2B');
                
                if (str.contains('BGP')) {
                str = 'BGP' ;
                }
                this.productConfigNames.put(pc.Id, 'Inflight Configuration - ' + str);
                system.debug('productConfigNames--'+productConfigNames);
            } */

            for(cscfga__Product_Configuration__c prodConf : prodConfs)
            {
                Id siteId = prodConfToSite.get(prodConf.Id);

                Date wishDate = siteIdToWishDate.get(siteId);
                Date plannedDate = siteIdToPlannedDate.get(siteId);

                if (prodConf.LG_InstallationWishDate__c != wishDate || prodConf.LG_InstallationPlannedDate__c != plannedDate)
                {
                    if (prodConf.LG_InstallationWishDate__c != wishDate)
                    {
                        prodConf.LG_InstallationWishDate__c = wishDate;
                    }
                    if (prodConf.LG_InstallationPlannedDate__c != plannedDate)
                    {
                        prodConf.LG_InstallationPlannedDate__c = plannedDate;
                    }
                    prodConfsToUpdate.add(prodConf);
                }

                for(cscfga__Attribute__c att : prodConf.cscfga__Attributes__r)
                {
                    boolean updateAtt = false;
                    String wishDateValue = wishDate != null ? wishDate.year() + '-' + wishDate.month() + '-' + wishDate.day()
                                                            : null;
                    String plannedDateValue = plannedDate != null ? plannedDate.year() + '-' + plannedDate.month() + '-' + plannedDate.day()
                                                            : null;

                    if (att.Name.equals('Installation Wish Date') && att.cscfga__Value__c != wishDateValue)
                    {
                        att.cscfga__Value__c = wishDateValue;
                        att.cscfga__Display_Value__c = wishDate != null ? getFormattedDate(wishDate) : null;
                        updateAtt = true;
                    }
                    if (att.Name.equals('Installation Planned Date') && att.cscfga__Value__c != plannedDateValue)
                    {
                        att.cscfga__Value__c = plannedDateValue;
                        att.cscfga__Display_Value__c = plannedDate != null ? getFormattedDate(plannedDate) : null;
                        updateAtt = true;
                    }
                    if (updateAtt)
                    {
                        attributesToUpdate.add(att);
                    }
                }
            }

            if (!attributesToUpdate.isEmpty())
            {
                update attributesToUpdate;
            }

            if (!prodConfsToUpdate.isEmpty())
            {
                update prodConfsToUpdate;

                if(LG_Util.getMigrateVarietyChangeTypes().contains(basket.csordtelcoa__Change_Type__c)
                    || basket.csordtelcoa__Change_Type__c == 'Move'
                    || basket.csordtelcoa__Change_Type__c == 'Terminate')
                {
                    saveWishDateOnJunctionObject(prodConfsToUpdate, basket.csordtelcoa__Change_Type__c);
                }
            }
        }
    }

    /**
     * Saves the wish date on the subscription_macdBasket junction object
     * for the related records (based on the subscription address and the product configuration
     * address)
     *
     * @param  List<cscfga__Product_Configuration__c> prodConfsToUpdate
     * @param  String changeType - MACD Scenario change type
     * @author Tomislav Blazek
     * @ticket SFDT-220
     * @since  17/3/2015
     */
    private void saveWishDateOnJunctionObject(List<cscfga__Product_Configuration__c> prodConfsToUpdate, String changeType)
    {
        Map<Id, csordtelcoa__Subscr_MACDProductBasket_Association__c> subBasketJuncsToUpdate
                                                        = new Map<Id, csordtelcoa__Subscr_MACDProductBasket_Association__c>();

        List<csordtelcoa__Subscr_MACDProductBasket_Association__c> subBasketJuncs = [SELECT csordtelcoa__Subscription__r.LG_Address__c,
                                                                                    LG_DeactivationWishDate__c, csordtelcoa__Subscription__c
                                                                                    FROM csordtelcoa__Subscr_MACDProductBasket_Association__c
                                                                                    WHERE csordtelcoa__Product_Basket__c = :basketId];

        for(csordtelcoa__Subscr_MACDProductBasket_Association__c junction : subBasketJuncs)
        {
            for(cscfga__Product_Configuration__c prodConf : prodConfsToUpdate)
            {
                if ((LG_Util.getMigrateVarietyChangeTypes().contains(changeType) && prodConf.LG_Address__c == junction.csordtelcoa__Subscription__r.LG_Address__c)
                    || (changeType.equals('Move') && prodConf.csordtelcoa__Replaced_Subscription__c == junction.csordtelcoa__Subscription__c)
                    || (changeType.equals('Terminate') && prodConf.csordtelcoa__Replaced_Subscription__c == junction.csordtelcoa__Subscription__c))
                {
                    junction.LG_DeactivationWishDate__c = prodConf.LG_InstallationWishDate__c;
                    subBasketJuncsToUpdate.put(junction.Id, junction);
                }
            }
        }

        if (!subBasketJuncsToUpdate.isEmpty())
        {
            update subBasketJuncsToUpdate.values();
        }
    }

    //back to return Id
    public PageReference redirectToReturnId() {
        system.debug('returnId--'+returnId);
        PageReference newocp = new PageReference(LG_Util.getSalesforceBaseUrl() + '/' + returnId);

        return newocp;
    }
    
    //GG
    public class SiteWrapper {
        public cscrm__Address__c site {get; set;}
        public Site_Survey__c siteSurvey{get; set;}
        
        //QNT-441
        public boolean displayProducts{get;set;}
        public string productFlagValue{get;set;}
        public string siteDetailsFlagValue{get;set;}
        public boolean displaySiteDetailFields{get;set;}
        public boolean requiredField{get;set;}
        //Default constructor to make Products tab invisible on page load if there is no BGP
        public SiteWrapper(){
            displayProducts=false;
            displaySiteDetailFields=false;
            //requiredField=true;
            requiredField=false; //Fix to handle mandatory fields when there is atleast one CF product on a site -- 24th Feb
            system.debug('requiredField--1'+requiredField);
        }
        public string productName{get;set;}
        public string productFamily{get;set;} // To make the site details flag green when there is a non CF product
        //end
    }
    
    
}