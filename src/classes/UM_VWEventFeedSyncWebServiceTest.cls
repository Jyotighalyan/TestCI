@isTest
private class UM_VWEventFeedSyncWebServiceTest 
{
    static testMethod void testMethod1() 
    {
        UM_VW_Staging_Feed__c objFeed = new UM_VW_Staging_Feed__c();
                    
        objFeed.UM_VoiceworksAccountID__c = '12345678';
        objFeed.UM_AccountNumber__c = '12345678|abc1234';
        objFeed.UM_HeadOfficeNumber__c = '52452345';
        objFeed.UM_CustomerName__c = 'Admin Name';
        objFeed.UM_SubscriberID__c = '12344567';
        objFeed.UM_VoiceWorksObjectId__c = '1234567890';
        objFeed.UM_Description__c = '';
        objFeed.UM_ArticleName__c = 'product name';
        objFeed.UM_ArticleNumber__c = '7654321';
        objFeed.UM_Interval__c = '1';
        objFeed.UM_Startdate__c = Date.Today();
        objFeed.UM_Enddate__c = Date.Today().addYears(2);
        objFeed.UM_UnitPrice__c = 10.00;
        objFeed.UM_Quantity__c = 5;
        objFeed.UM_TotalPrice__c = 50.00;
        objFeed.UM_ExportType__c = 'Billing';
        objFeed.UM_Type__c = 'Feed';
        
        UM_VWEventFeedSyncWebService.loadEventFeedsToStaging(new list<UM_VW_Staging_Feed__c>{objFeed});
    }
    
    static testMethod void testMethod2() 
    {
        UM_VW_Staging_Feed__c objFeed = new UM_VW_Staging_Feed__c();
                    
        objFeed.UM_VoiceworksAccountID__c = '12345678';
        objFeed.UM_AccountNumber__c = '12345678|abc1234';
        objFeed.UM_HeadOfficeNumber__c = '52452345';
        objFeed.UM_CustomerName__c = 'Admin Name';
        objFeed.UM_SubscriberID__c = '12344567';
        objFeed.UM_VoiceWorksObjectId__c = '1234567890';
        objFeed.UM_Description__c = '';
        objFeed.UM_ArticleName__c = 'product name';
        objFeed.UM_ArticleNumber__c = '7654321';
        objFeed.UM_Interval__c = '1';
        objFeed.UM_Startdate__c = Date.Today();
        objFeed.UM_Enddate__c = null;
        objFeed.UM_UnitPrice__c = 10.00;
        objFeed.UM_Quantity__c = 5;
        objFeed.UM_TotalPrice__c = 50.00;
        objFeed.UM_ExportType__c = 'Billing';
        objFeed.UM_Type__c = 'Feed';
        
        UM_VWEventFeedSyncWebService.loadEventFeedsToStaging(new list<UM_VW_Staging_Feed__c>{objFeed});
    }
    
    static testMethod void testMethod3() 
    {
        UM_VW_Staging_Feed__c objFeed = new UM_VW_Staging_Feed__c();
                    
        objFeed.UM_StoreOrderNumber__c = '201707051001';
        objFeed.UM_Brand__c = 'Mitel';
        objFeed.UM_HardwareType__c = 'DeskPhone';
        objFeed.UM_MAC__c = '0D09520963';
        objFeed.UM_Model__c = '6867I';
        objFeed.UM_Serial__c = '101900142385';
        objFeed.UM_ShippingDate__c = Date.today();
        objFeed.UM_ExportType__c = 'Hardware';
        objFeed.UM_Type__c = 'Feed';
        
        UM_VWEventFeedSyncWebService.loadEventFeedsToStaging(new list<UM_VW_Staging_Feed__c>{objFeed});
    }
    
    static testMethod void testMethod4() 
    {
        UM_VWEventFeedSyncWebService.loadEventFeedsToStaging(new list<UM_VW_Staging_Feed__c>{null});
    }
}