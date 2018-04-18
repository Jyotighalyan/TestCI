/*******************************************************************************************************************************************
* File Name     :  LG_UpdateResultsOnDWHFeedRecords
* Description   :  This is the utility class for the class for updating the results on the processed DWH feed records. 

* @author       :   Shreyas
* Modification Log
===================================================================================================
* Ver.    Date          Author              Modification
---------------------------------------------------------------------------------------------------
* 1.0     2nd-Feb-16    Shreyas             Created the class for release R1*

********************************************************************************************************************************************/

global class LG_UpdateResultsOnDWHFeedRecords implements Database.Batchable<sObject>, Database.Stateful{

    public List<string> uniqueIdList = new List<string>();
    public map<string, string> exceptionMessageMap = new map<string, string>();
    public string failedStatus = 'Failed';  
    public string processedSuccessfullyStatus = 'Processed Successfully';
    public integer numberOfAccountsSynced = 0;
    public integer numberOfAccountsFailed = 0;

    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select Id, LG_TypeofRecord__c, LG_Status__c, LG_TransactionIdAccountId__c, LG_ErrorDate__c, LG_ErrorMessage__c, LG_ProcessedDate__c ';
               query = query + 'from LG_DWHFeedStagingTable__c where LG_TransactionIdAccountId__c IN: uniqueIdList'; 
        return Database.getQueryLocator(query); 

    }
    
    public void execute(Database.BatchableContext BC,List<LG_DWHFeedStagingTable__c> scope){
    
        List<LG_DWHFeedStagingTable__c> processedDWHRecordsUpdateList = new List<LG_DWHFeedStagingTable__c>();
        
        for(LG_DWHFeedStagingTable__c dwh: scope){
            if(exceptionMessageMap.containsKey(dwh.LG_TransactionIdAccountId__c)){
                if(dwh.LG_TypeofRecord__c == 'Account'){
                    dwh.LG_ErrorMessage__c = exceptionMessageMap.get(dwh.LG_TransactionIdAccountId__c);
                    numberOfAccountsFailed = numberOfAccountsFailed + 1;
                }
                dwh.LG_Status__c = failedStatus;
                dwh.LG_ProcessedDate__c = System.now();
                processedDWHRecordsUpdateList.add(dwh);
            }
            else{
                if(dwh.LG_TypeofRecord__c == 'Account'){
                    numberOfAccountsSynced = numberOfAccountsSynced + 1;
                }
                dwh.LG_Status__c = processedSuccessfullyStatus;
                dwh.LG_ProcessedDate__c = System.now();
                processedDWHRecordsUpdateList.add(dwh);
            }        
        }

        update processedDWHRecordsUpdateList;
    }
    
    
    public void finish(Database.BatchableContext bc){ 
    
         LG_DWHIntegrationVariables__c emailAddressSetting = LG_DWHIntegrationVariables__c.getValues('Email_Address_For_Sending_Results');
         string emailAddress = emailAddressSetting.LG_DisplayValue__c;
        
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         String[] toAddresses = new String[] {emailAddress};
         mail.setToAddresses(toAddresses);
         mail.setSubject('Status Of DWH Sync Batch ');
         mail.setPlainTextBody
           ('Number of Accounts Processed Successfully ' + numberOfAccountsSynced + '. ' + 
            'Number of Accounts Failed '+ numberOfAccountsFailed + '.');
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
         
    }

}