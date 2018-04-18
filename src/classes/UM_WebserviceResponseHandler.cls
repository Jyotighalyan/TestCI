global class UM_WebserviceResponseHandler
{
    public static final string SUCCESS = 'Success';
    public static final string FAIL = 'Fail';
    
    global class VWEventFeedResponse
    {
        public WebserviceResult result{get;set;}
    }
    
    global class WebserviceResult
    {
        public string statusCode{get;set;}
        public string status{get;set;}
        public string errorMessage{get;set;}
        public list<RecordData> recordData{get;set;}
    }
    
    global class RecordData
    {
        public string status{get;set;}
        public string referenceId{get;set;}
        public string salesforceId{get;set;}
        public string errorMessage{get;set;}
    }
    
    public static WebserviceResult prepareResponseForLoadVWEventFeed(Database.SaveResult[] insertResultList, map<integer, string> recordIndexRowKeyMap)
    {
        WebserviceResult result = new WebserviceResult();
        list<RecordData> recordDataList = new list<RecordData>();
        
        integer recordIndex = 1;
        integer successCount = 0;
        
        for (Database.SaveResult sr : insertResultList) 
        {
            RecordData recordData = new RecordData();
            
            if (sr.isSuccess()) 
            {
                recordData.status = SUCCESS;
                if(recordIndexRowKeyMap!=NULL && recordIndexRowKeyMap.containsKey(recordIndex))
                    recordData.referenceId = recordIndexRowKeyMap.get(recordIndex);
                recordData.salesforceId = sr.getId();
                recordData.errorMessage = '';
                successCount++;
            }
            else 
            {
                string errorMsg = '';
                for(Database.Error err : sr.getErrors()) 
                {
                    errorMsg += err.getMessage();
                }
                
                recordData.status = FAIL;
                if(recordIndexRowKeyMap != NULL && recordIndexRowKeyMap.containsKey(recordIndex))
                    recordData.referenceId = recordIndexRowKeyMap.get(recordIndex);
                recordData.errorMessage = errorMsg;
            }
            
            recordDataList.add(recordData);
            recordIndex++;
        }
        
        if(successCount == insertResultList.size())
            result = prepareServiceResult('200');
        else if(successCount < insertResultList.size())
            result = prepareServiceResult('201');
        else if(successCount == 0)
            result = prepareServiceResult('202');
        
        result.recordData = recordDataList;
        
        RETURN result;
    }
    
    public static WebserviceResult prepareServiceResult(string statusCode)
    {
        WebserviceResult result = new WebserviceResult();
        map<string, UM_WebService_Status_Code__mdt> codeStatusCodeObjMap = new map<string, UM_WebService_Status_Code__mdt>();
        for(UM_WebService_Status_Code__mdt sc : [SELECT id, UM_Error_Message__c, UM_Status__c, UM_Status_Code__c 
                                                      FROM UM_WebService_Status_Code__mdt])
        {
            codeStatusCodeObjMap.put(sc.UM_Status_Code__c,sc);
        }
        
        if(!codeStatusCodeObjMap.isEmpty() && codeStatusCodeObjMap.containsKey(statusCode))
        {
            result.statusCode = codeStatusCodeObjMap.get(statusCode).UM_Status_Code__c;
            result.status = codeStatusCodeObjMap.get(statusCode).UM_Status__c;
            result.errorMessage = codeStatusCodeObjMap.get(statusCode).UM_Error_Message__c;
        }
        
        RETURN result;
    }
}