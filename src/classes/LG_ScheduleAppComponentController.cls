/******** Controller class for VF component ScheduleAppComponent****
 ***** Author: Neha Arora **********
*********SFOM - 122***********
 * ****************************************************************/

public class LG_ScheduleAppComponentController {
    public Id solId{get;set;}
    public String attribName{get;set;}
    
    public List<csord__Service_Line_Item__c> getserviceLineItems()
    {
        List<csord__Service_Line_Item__c> objs = [SELECT Id, Name, csord__Start_Date__c, csord__End_Date__c 
                                                  FROM csord__Service_Line_Item__c 
                                                  WHERE csord__Service__r.LG_Suborder__c = :solId];

        return objs;

        
    }
    
    //SFOM-2577 - Method to fetch the Service
    public csord__Service__c getProdConfDetails()
    {
        csord__Service__c objs = [SELECT Name, UM_DownloadSpeed__c FROM csord__Service__c WHERE LG_Suborder__c = :solId LIMIT 1];
                                
        return objs;
    }
    
    
}