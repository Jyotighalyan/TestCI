/*******************************************************************************************************************************************
* File Name     :  LG_ManuallySyncDataFromDWH
* Description   :  This class is used to manually sync a single set of related records from DWH staging table to SFDC objects. 

* @author       :   Shreyas
* Modification Log
===================================================================================================
* Ver.    Date          Author              Modification
---------------------------------------------------------------------------------------------------
* 1.0     7th-Mar-16    Shreyas             Created the class for release R1*

********************************************************************************************************************************************/

public class LG_ManuallySyncDataFromDWH{
 
    public static List<Account> createacc(){
	List<Account> acc = new List<Account>([SELECT CreatedbyID,Account.Name,(SELECT name,Contact.FirstName,Contact.Salutation, Contact.LastName FROM Account.Contacts) FROM Account]); 
       system.debug(acc);
     
        
         
     for (Account ac : acc) { 
     system.debug(ac); 
  }
    return acc;    
}
    
    
/*
    static string errorMessage = '';
    /*
        Name: syncManually
        Purpose: to manually sync a single set of related records from DWH staging table to SFDC objects. 
        Argument: string
        Return type: string
    */
    /*
    webservice static string syncManually(string uniqueId){
    
        string returnString = '';
        Savepoint sp = Database.setSavepoint();
        try{
            LG_CreateDataFromDWHFeedController controllerObj = new LG_CreateDataFromDWHFeedController();
            controllerObj.manualSync = true;
            controllerObj.uniqueIdForManualSync = uniqueId;
            map<string, List<map<string, List<LG_DWHFeedStagingTable__c>> > > feedMap = new map<string, List<map<string, List<LG_DWHFeedStagingTable__c>> > >();
            feedMap = controllerObj.createMapFromFeedRecords();
            controllerObj.processFeedRecords(uniqueId);
            returnString = 'Processed Successfully';
        } 
        catch(exception e){
            
            errorMessage = errorMessage + 'Message:-- ' + e.getMessage();
            errorMessage = errorMessage + '\nStack Trace:-- ' + e.getStackTraceString();
            returnString = errorMessage;
            Database.rollback(sp);
        }       
        return returnString;
    }
    
    /*
        Name: afterSyncAction
        Purpose: to update the status of processed records after manual sync
        Argument: string
        Return type: none
    */
    /*
    webservice static string afterSyncAction(string uniqueId, string status){
        
        string returnString = '';
        List<LG_DWHFeedStagingTable__c> dwhFetchedList = new List<LG_DWHFeedStagingTable__c>();
        List<LG_DWHFeedStagingTable__c> dwhUpdateList = new List<LG_DWHFeedStagingTable__c>();
        
        dwhFetchedList = [Select Id, LG_ProcessedDate__c, LG_Status__c, LG_AccountExternalId__c, LG_ErrorMessage__c, LG_TransactionIdAccountId__c, LG_TypeofRecord__c
                         from LG_DWHFeedStagingTable__c where LG_TransactionIdAccountId__c =: uniqueId];
                   
        
        for(LG_DWHFeedStagingTable__c dwh: dwhFetchedList){
            if(status == 'Processed Successfully'){
                dwh.LG_Status__c = status;
                dwh.LG_ErrorMessage__c = null;
            }
            else{
                 if(dwh.LG_TypeofRecord__c == 'Account'){
                    dwh.LG_ErrorMessage__c = status;    
                 }
                 dwh.LG_Status__c = 'Failed';
            }
            dwh.LG_ProcessedDate__c = System.now();
            dwhUpdateList.add(dwh);
        }
        
        if(dwhUpdateList.size() > 0){
            update dwhUpdateList;
        }
        
        return returnString;
    }
*/

}