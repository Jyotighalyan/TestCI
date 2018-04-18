@isTest
public class InstallationSiteDetailRemoterTest{

    static testmethod void testProductConfiguration(){
        cscfga__Product_Configuration__c pc = new cscfga__Product_Configuration__c();
        pc.Name='testPCName';
        pc.LG_PlanningDetailsStatus__c='Complete';
        pc.cscfga__Configuration_Status__c ='Valid';
        insert pc;
        
        LG_InstallationInformationController obj = new LG_InstallationInformationController();
        InstallationSiteDetailRemoter cntrl = new InstallationSiteDetailRemoter(obj);
        InstallationSiteDetailRemoter.getProductConfigurations(pc.Id);  
        
                
    }

}