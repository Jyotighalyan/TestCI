/************************************************************
* File Name     :  CloseProductConfigurationController  
* Description   :  This class is created as part of QNT-441
=====================================================================
* Ver.    Date          Author                         Modification
-------------------------------------------------------------------------
* 1.0     27/11/2017    Debasish                File Created.
 
*************************************************************/

public class CloseProductConfigurationController {

  public boolean completed { get; set; }
  public  Map<String, String> warningMap = new Map<String, String>();
  public string siteId{get;set;}
  
  public string configID {
    get{
      return ApexPages.currentPage().getParameters().get('configId');
    }
    set;
  }

  public CloseProductConfigurationController() {
    //Check the Planning details status and the product configuration status

    try {
      List<cscfga__Product_Configuration__c> pcs = [SELECT Id,LG_Address__c, LG_PlanningDetailsStatus__c, cscfga__Configuration_Status__c,
                                                      cscfga__Product_Basket__r.Id
                                                      FROM cscfga__Product_Configuration__c
                                                      WHERE Id = : configID ];
      if (pcs.size() > 0) {
        if (pcs[0].LG_PlanningDetailsStatus__c == 'complete' && pcs[0].cscfga__Configuration_Status__c == 'valid') {
          completed = true;
          system.debug('completed --'+completed );
        } else {
          completed = false;
        }
        
        siteId = pcs[0].LG_Address__c;
      }
    }

    catch (Exception ex) {
      warningMap.put('PlanningDetailsConfirmation', 'Problem checking the planning detail status ' + ex.getMessage());
    }
  }
}