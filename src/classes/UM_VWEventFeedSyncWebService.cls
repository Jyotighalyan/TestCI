/*
Description:    
Author:    Omkar Jante (omkar_jante@infosys.com)
Date:    20th June 2017
*/

@RestResource(urlMapping='/UM_LoadVWEventFeeds/')
global class UM_VWEventFeedSyncWebService 
{
    @HttpPost
    webService static UM_WebserviceResponseHandler.VWEventFeedResponse loadEventFeedsToStaging(list<UM_VW_Staging_Feed__c> eventFeedData) 
    {
        UM_WebserviceResponseHandler.VWEventFeedResponse response = new UM_WebserviceResponseHandler.VWEventFeedResponse();
        
        try
        {
            if(!eventFeedData.isEmpty())
            {
                map<integer, string> recordIndexRowKeyMap = new map<integer, string>();
                integer recordIndex = 1;
                
                for(UM_VW_Staging_Feed__c feed : eventFeedData)
                {
                    if(feed.UM_ExportType__c.equalsIgnoreCase('Billing'))
                        recordIndexRowKeyMap.put(recordIndex,feed.UM_VoiceworksAccountID__c);
                    else if(feed.UM_ExportType__c.equalsIgnoreCase('Hardware'))
                        recordIndexRowKeyMap.put(recordIndex,feed.UM_Serial__c);
                    recordIndex++;
                }
                
                if(!eventFeedData.isEmpty()){
                    Database.SaveResult[] insertResultList = Database.insert(eventFeedData,FALSE);
                    
                    // Prepare record level response
                    response.result = UM_WebserviceResponseHandler.prepareResponseForLoadVWEventFeed(insertResultList,recordIndexRowKeyMap);
                }
                else
                    response.result = UM_WebserviceResponseHandler.prepareServiceResult('203'); // no records to process
            }
            else
                response.result = UM_WebserviceResponseHandler.prepareServiceResult('203'); // no data in request
        }
        catch(exception ex){
            system.debug('ex------->'+ex);
            response.result = UM_WebserviceResponseHandler.prepareServiceResult('204');
        }
        
        RETURN response;
    }
}