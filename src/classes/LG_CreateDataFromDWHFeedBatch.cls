/*******************************************************************************************************************************************
* File Name     :  LG_CreateDataFromDWHFeedBatch
* Description   :  This is the utility class for creating the data from the staging table into the objects: Account, Contact, 
                   Subscription, Service, Premise, Billing Account, Attribute. 

* @author       :   Shreyas
* Modification Log
===================================================================================================
* Ver.    Date          Author              Modification
---------------------------------------------------------------------------------------------------
* 1.0     2nd-Feb-16    Shreyas             Created the class for release R1*
********************************************************************************************************************************************/

global class LG_CreateDataFromDWHFeedBatch implements Database.Batchable<sObject>{

     global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        String query = 'SELECT Id,Name FROM Account';
        
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Account> scope) 
    {
        for(Account a : scope)
        {
            a.Name = a.Name + 'Updated by Batch job';
        }
        update scope;
    }
    global void finish(Database.BatchableContext BC) {
    }
    
    
    /*List<string> uniqueIdList;
    
    global List<string> start(Database.BatchableContext bc) { 
        
        controllerObj.manualSync = false;
        map<string, List<map<string, List<LG_DWHFeedStagingTable__c>> > > feedMap = new map<string, List<map<string, List<LG_DWHFeedStagingTable__c>> > >();
        feedMap = controllerObj.createMapFromFeedRecords();
        system.debug('### feedMap in batch class: ' + feedMap);
        
        uniqueIdList = new List<string>();
        for(string s: feedMap.keyset()){
            uniqueIdList.add(s);
        }
        
        return uniqueIdList;
    }
    
    
    global void execute(Database.BatchableContext bc, List<string> uniqueIdList) {
        
        for(string s: uniqueIdList){
            Savepoint sp = Database.setSavepoint();
            try{
                controllerObj.processFeedRecords(s);
            } 
            
            catch(exception e){
                string errorMessage = '';
                errorMessage = errorMessage + 'Message:-- ' + e.getMessage();
                errorMessage = errorMessage + '\nStack Trace:-- ' + e.getStackTraceString();
                controllerObj.exceptionMessageMap.put(s, errorMessage);
                Database.rollback(sp);
            }
        }
     }
    
    global void finish(Database.BatchableContext bc) {
        
        LG_UpdateResultsOnDWHFeedRecords updateResults = new LG_UpdateResultsOnDWHFeedRecords();
        updateResults.uniqueIdList = uniqueIdList; 
        updateResults.exceptionMessageMap = controllerObj.exceptionMessageMap; 
        if(!Test.isRunningTest()){ 
            database.executebatch(updateResults,200);   
        }      
    } */
    
    
    
}