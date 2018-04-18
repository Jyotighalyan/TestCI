global class UM_VWStagingFeedProcessBatch implements Database.Batchable<string>, Database.Stateful{
    global string query;
    global string processType;
    global list<string> transactionIdList;
    map<string, list<UM_VW_Staging_Feed__c>> idVWSDataMap = new map<string, list<UM_VW_Staging_Feed__c>>();
    
    UM_VWStagingFeedUtil objVWFeed = new UM_VWStagingFeedUtil();

    global list<string> start(Database.BatchableContext bc) {
        system.debug('batch query--------->'+query);
        if(processType != null && processType.equalsIgnoreCase('Subscriber'))
            idVWSDataMap = objVWFeed.collectSubscriberData(Database.Query(query));
        else if(processType != null && processType.equalsIgnoreCase('nonSubscriber'))
            idVWSDataMap = objVWFeed.collectNonSubscriberData(Database.Query(query));
        else if(processType != null && processType.equalsIgnoreCase('Hardware'))
            idVWSDataMap = objVWFeed.collectHardwareData(Database.Query(query));
        
        list<string> subIdList = new list<string>();
        if(!idVWSDataMap.isEmpty())
            subIdList.addAll(idVWSDataMap.keySet());

        return subIdList;
    }

    global void execute(Database.BatchableContext bc, list<string> genericIdList){
        if(genericIdList != null && !genericIdList.isEmpty()){
            for(string subId : genericIdList){
                System.enqueueJob(new UM_VWProcessRecords(idVWSDataMap.get(subId)));
            }
        }
    }

    global void finish(Database.BatchableContext bc){
    } 
}