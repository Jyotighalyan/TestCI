/************************************************************
* File Name     :  InstallationSiteDetailRemoter
* Description   :  This class is created as part of QNT-441
=====================================================================
* Ver.    Date          Author                         Modification
-------------------------------------------------------------------------
* 1.0     30/11/2017    Debasish                File Created.
 
*************************************************************/

global class InstallationSiteDetailRemoter {
    public InstallationSiteDetailRemoter (LG_InstallationInformationController isdController) {}

    @RemoteAction
    global static List<cscfga__Product_Configuration__c> getProductConfigurations (String configID) {
        /*
        Long totalTime;
        Long startTime = DateTime.now().getTime();
        Long endTime = DateTime.now().getTime();
        totalTime = endTime - startTime;
        //System.debug('Execution Time getProductConfigurations: '+ (endTime - startTime));
        */
        List<cscfga__Product_Configuration__c> pcs = [SELECT Id,LG_Address__c, LG_PlanningDetailsStatus__c,cscfga__Configuration_Status__c FROM cscfga__Product_Configuration__c WHERE Id =: configID];
        return pcs;
    }
    
}