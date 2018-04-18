/* Test class for UM_UpdateAllWorkOrders
* 
* New Version:
* @author Ankur Gupta
* @ticket SFOM-2225
* @since  13/12/2017
*/
@istest
public class UM_UpdateAllWorkOrdersTest
{
    @testsetup
    private static void setupTestData()
    {
        No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
        noTriggers.Flag__c = true;
        noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
        upsert noTriggers;
        
        Account acc = LG_GeneralTest.CreateAccount('AccountSFDT', '12345678', 'Ziggo', true);
        
        csconta__Billing_Account__c billingAcc = LG_GeneralTest.createBillingAccount('SFDT-59 Bill1', acc.Id, true, true);
        
        Opportunity opp = LG_GeneralTest.CreateOpportunity(acc, true);
        
        csord__Order_Request__c coreq = new csord__Order_Request__c(csord__Module_Name__c = 'Test', csord__Module_Version__c = '1.0');
        insert coreq;
        
        csord__Order__c  order = LG_GeneralTest.createOrder('Company Internet',acc,'In Progress',coreq, opp, true);
        
        csord__Solution__c sol = new csord__Solution__c();
        sol.Name='UM Company Internet';
        sol.csord__Account__c = acc.id;
        sol.csord__Order__c   = order.id;
        sol.csord__Status__c  = 'In Progress';
        sol.LG_Integration_Status__c = 'Work Order Created';
        sol.LG_Integration_Description__c = 'Success';
        sol.csord__Identification__c = 'UM Company Internet - 6912173';
        sol.LG_InstallationNeeded__c = true;
        sol.LG_TargetDate__c         = system.today();
        sol.csord__Order_Request__c  = coreq.id;
        sol.LG_InstallationWishDate__c  = System.today()+10;
        sol.LG_ProvisioningAccountNo__c = '10092870';
        sol.LG_ProvisioningWorkOrder__c = '2223';
        sol.LG_Provisioning_External_Id__c = '123';
        
        insert sol;
        
        cscrm__Address__c address = LG_GeneralTest.crateAddress('TestAddress', 'street', 'city', '5', '73', '2014GC', 'Netherlands', acc, true);
        
        csord__Subscription__c sub = new csord__Subscription__c(csord__Identification__c = 'TestIdent', csord__Order_Request__c = coreq.Id);
        sub.LG_Address__c      = address.Id;
        sub.csord__Account__c  = acc.Id;
        sub.csord__Order__c    = order.Id;
        sub.csord__Solution__c = sol.Id;
        sub.csconta__Billing_Account__c = billingAcc.id;
        insert sub;
        
        csord__Service__c service = new csord__Service__c(csord__Identification__c = 'TestService', csord__Subscription__c = sub.Id, csord__Order_Request__c = coreq.Id);
        service.LG_Address__c  = address.Id;
        service.LG_Suborder__c = sol.id;
        service.LG_ProductFamily__c = 'Company Internet';
        service.LG_ProvisioningAccountNo__c = '10092870';
        insert service;
        
        Asset assetRec = new Asset();
        assetRec.Name  = 'Sample';
        assetRec.AccountId = acc.id;
        assetRec.csord__Service__c = service.id;
        insert assetRec;
        
        noTriggers.Flag__c = False;
        upsert noTriggers;        
    }
    
    @isTest static void testStatusO()
    {
        String request ='<request><workOrderStatus><accountNumber>10092870</accountNumber><workOrderSummary><workOrderNumber>2223</workOrderNumber><status>O</status><scheduleDate>20171220</scheduleDate><startBillDate>20171220</startBillDate><errors></errors></workOrderSummary></workOrderStatus></request>';
        getRestContext(request);
        
        Test.startTest();
        UM_UpdateAllWorkOrders.updateAllWorkOrders();
        Test.stopTest();
        csord__solution__c solution = [SELECT Id FROM csord__solution__c WHERE Name = 'UM Company Internet'];
        LG_ScheduleAppointment__c appointment = [SELECT Id, Name, LG_Status__c, LG_Solution__c, LG_AgreedInstallDate__c 
                                                 FROM LG_ScheduleAppointment__c WHERE LG_Solution__c = :solution.id ];
        
        System.assertEquals(true, appointment != null);
        System.assertEquals(Date.valueOf('2017-12-20'), appointment.LG_AgreedInstallDate__c);
        System.assertEquals('Scheduled', appointment.LG_Status__c);
        System.assertEquals(true, appointment.Name.contains('Appointment'));
        
    }
    
    @isTest static void testStatusC()
    {
        String request ='<request><workOrderStatus><accountNumber>10092870</accountNumber><workOrderSummary><workOrderNumber>2223</workOrderNumber><status>C</status><scheduleDate>20171220</scheduleDate><errors></errors><startBillDate>20171220</startBillDate></workOrderSummary><customerEquipment><customerNumber>10092870</customerNumber><outletEquipmentList><OutletEquipment><outletId>1</outletId><internetOccurence>1</internetOccurence><telcoPort1Occurence>1</telcoPort1Occurence><telcoPort2Occurence>0</telcoPort2Occurence>' 
            + '<macAddressOccurence>F0F2491810E0</macAddressOccurence><macAddressDateOccurence>201610040000</macAddressDateOccurence><stbType>1777700</stbType><stbSerialNumber>215120002807</stbSerialNumber><stbLocation>LR01</stbLocation><stbDescription>HITRON MTA CGNV4  B2B</stbDescription><hardPair>N</hardPair><fritzBoxInstallDate>0</fritzBoxInstallDate><fritzBoxInternalOccurence>0</fritzBoxInternalOccurence><mtacmSerialNumber>215120002807</mtacmSerialNumber><mtaStaticIpAddress>92.50.64.152</mtaStaticIpAddress><mtaIpSolution>1</mtaIpSolution><mtaIpSolutionDesc>IPV4</mtaIpSolutionDesc><mobileLineOccurrence/><MTADescription>HITRON MTA CGNV4  B2B</MTADescription></OutletEquipment></outletEquipmentList></customerEquipment></workOrderStatus></request>';
        
        getRestContext(request);
        
        Test.startTest();
        UM_UpdateAllWorkOrders.updateAllWorkOrders();
        Test.stopTest();
        
        csord__solution__c solution = [SELECT Id,LG_Integration_Status__c, csord__Status__c FROM csord__solution__c WHERE Name = 'UM Company Internet'];
        
        System.assertEquals('Installation Complete', solution.LG_Integration_Status__c);
        System.assertEquals('Ready For Billing', solution.csord__Status__c);
        
        csord__service__c service = [SELECT Id, Name, csord__Activation_Date__c, LG_EffectiveDate__c 
                                     FROM csord__service__c WHERE LG_Suborder__c = :solution.id ];
        
        System.assertEquals(Date.valueOf('2017-12-20'), service.csord__Activation_Date__c);
        System.assertEquals(Date.valueOf('2017-12-20'), service.LG_EffectiveDate__c);
        
        Asset asset = [SELECT Id,LG_MACAddress__c, LG_IPAddress__c FROM Asset WHERE csord__Service__c = :service.Id];
        
        System.assertEquals('F0F2491810E0', asset.LG_MACAddress__c);
        System.assertEquals('92.50.64.152', asset.LG_IPAddress__c);
    }
    
    @isTest static void testStatusPOrX()
    {
        String request ='<request><workOrderStatus><accountNumber>10092870</accountNumber><workOrderSummary><workOrderNumber>2223</workOrderNumber><status>X</status><scheduleDate>20171220</scheduleDate><startBillDate>20171220</startBillDate><errors>ORDER_CANCELLATION_CODE(01)</errors></workOrderSummary></workOrderStatus></request>';
        getRestContext(request);
        
        Test.startTest();
        UM_UpdateAllWorkOrders.updateAllWorkOrders();
        Test.stopTest();
        
        csord__solution__c solution = [SELECT Id,LG_Integration_Status__c, LG_Integration_Description__c, LG_Jeopardy__c,
                                       Jeopardy_Reason__c, LG_JeopardyExplanation__c, csord__Status__c FROM csord__solution__c WHERE Name = 'UM Company Internet'];
        
        System.assertEquals('Cancellation Requested', solution.LG_Integration_Status__c);
        System.assertEquals('ORDER_CANCELLATION_CODE(01)', solution.LG_Integration_Description__c);
        System.assertEquals(true, solution.LG_Jeopardy__c);
        System.assertEquals('Order Cancellation', solution.Jeopardy_Reason__c);
        System.assertEquals('ORDER_CANCELLATION_CODE(01)', solution.LG_JeopardyExplanation__c);
    }
    
    @isTest static void testInstallationDetailsMissing1()
    {
        String request ='<request><workOrderStatus><accountNumber>10092870</accountNumber><workOrderSummary><workOrderNumber>2223</workOrderNumber><status>C</status><scheduleDate>20171220</scheduleDate><startBillDate>20171220</startBillDate><errors></errors></workOrderSummary></workOrderStatus></request>';
        getRestContext(request);
        
        Test.startTest();
        UM_UpdateAllWorkOrders.updateAllWorkOrders();
        Test.stopTest();
        
        csord__solution__c solution = [SELECT Id,LG_Integration_Status__c, LG_Integration_Description__c, LG_Jeopardy__c,
                                       Jeopardy_Reason__c, LG_JeopardyExplanation__c, csord__Status__c FROM csord__solution__c WHERE Name = 'UM Company Internet'];
        
        System.assertEquals('Installation Details Missing', solution.LG_Integration_Status__c);
        System.assertEquals('Invalid request received: Outlet Equipment details missing', solution.LG_Integration_Description__c);
        
    }
    
    @isTest static void testInstallationDetailsMissing2()
    {
        String request ='<request><workOrderStatus><accountNumber>10092870</accountNumber><workOrderSummary><workOrderNumber>2223</workOrderNumber><status>C</status><scheduleDate>20171220</scheduleDate><errors></errors><startBillDate></startBillDate></workOrderSummary><customerEquipment><customerNumber>10092870</customerNumber><outletEquipmentList><OutletEquipment><outletId>1</outletId><internetOccurence>1</internetOccurence><telcoPort1Occurence>1</telcoPort1Occurence><telcoPort2Occurence>0</telcoPort2Occurence>' 
            + '<macAddressOccurence>F0F2491810E0</macAddressOccurence><macAddressDateOccurence>201610040000</macAddressDateOccurence><stbType>1777700</stbType><stbSerialNumber>215120002807</stbSerialNumber><stbLocation>LR01</stbLocation><stbDescription>HITRON MTA CGNV4  B2B</stbDescription><hardPair>N</hardPair><fritzBoxInstallDate>0</fritzBoxInstallDate><fritzBoxInternalOccurence>0</fritzBoxInternalOccurence><mtacmSerialNumber>215120002807</mtacmSerialNumber><mtaStaticIpAddress>92.50.64.152</mtaStaticIpAddress><mtaIpSolution>1</mtaIpSolution><mtaIpSolutionDesc>IPV4</mtaIpSolutionDesc><mobileLineOccurrence/><MTADescription>HITRON MTA CGNV4  B2B</MTADescription></OutletEquipment></outletEquipmentList></customerEquipment></workOrderStatus></request>';
        getRestContext(request);
        
        Test.startTest();
        UM_UpdateAllWorkOrders.updateAllWorkOrders();
        Test.stopTest();
        
        csord__solution__c solution = [SELECT Id,LG_Integration_Status__c, LG_Integration_Description__c, LG_Jeopardy__c,
                                       Jeopardy_Reason__c, LG_JeopardyExplanation__c, csord__Status__c FROM csord__solution__c WHERE Name = 'UM Company Internet'];
        
        System.assertEquals('Installation Details Missing', solution.LG_Integration_Status__c);
        System.assertEquals('Invalid request received: startBillDate Missing', solution.LG_Integration_Description__c);
    }
    
    @isTest static void testException()
    {
        String request ='<request><workOrderStatus><accountNumber>10092870</accountNumber><workOrderSummary><workOrderNumber>2223</workOrderNumber><status>O</status><scheduleDate>2017.12.20</scheduleDate><startBillDate>2017.12.20</startBillDate><errors></errors></workOrderSummary></workOrderStatus></request>';
        getRestContext(request);
        
        Test.startTest();
        UM_UpdateAllWorkOrders.updateAllWorkOrders();
        Test.stopTest();
        
        csord__solution__c solution = [SELECT Id,LG_Integration_Status__c, LG_Integration_Description__c, LG_Jeopardy__c,
                                       Jeopardy_Reason__c, LG_JeopardyExplanation__c, csord__Status__c FROM csord__solution__c WHERE Name = 'UM Company Internet'];
        
        //Exception in parsing, suborder remains as it is.
        System.assertEquals('Work Order Created', solution.LG_Integration_Status__c);
        System.assertEquals('Success', solution.LG_Integration_Description__c);
    }
    
    @isTest static void testGeneralException()
    {
        csord__solution__c sol = [SELECT Id FROM csord__solution__c WHERE Name = 'UM Company Internet'];
        
        LG_ScheduleAppointment__c app = new LG_ScheduleAppointment__c();
        app.LG_AgreedInstallDate__c= System.today();
        app.Name='Appointment 123';
        app.LG_Status__c='Scheduled';
        app.LG_Solution__c=sol.id;
        insert app;
        
        String request ='<request><workOrderStatus><accountNumber>10092870</accountNumber><workOrderSummary><workOrderNumber>2223</workOrderNumber><status>O</status><scheduleDate>20171222</scheduleDate><startBillDate>20171222</startBillDate><errors></errors></workOrderSummary></workOrderStatus></request>';
        getRestContext(request);
        
        Test.startTest();
        UM_UpdateAllWorkOrders.updateAllWorkOrders();
        Test.stopTest();
        
        csord__solution__c solution = [SELECT Id,LG_Integration_Status__c, LG_Integration_Description__c, LG_Jeopardy__c,
                                       Jeopardy_Reason__c, LG_JeopardyExplanation__c, csord__Status__c FROM csord__solution__c WHERE Name = 'UM Company Internet'];
        
        System.assertEquals('SFDC failure', solution.LG_Integration_Status__c);
        System.assertEquals(Label.LG_JiraExceptionMsg +  ' Internal ' + Label.LG_JiraJeopardyError, solution.LG_Integration_Description__c);
        
        LG_ScheduleAppointment__c appointment = [SELECT Id, Name, LG_Status__c, LG_Solution__c, LG_AgreedInstallDate__c 
                                                 FROM LG_ScheduleAppointment__c WHERE LG_Solution__c = :solution.id ];
        
        System.assertEquals(true, appointment != null);
        System.assertEquals(Date.valueOf('2017-12-22'), appointment.LG_AgreedInstallDate__c);
        System.assertEquals('Scheduled', appointment.LG_Status__c);
        System.assertEquals(true, appointment.Name.contains('Appointment'));
        
        List<Note> notes = [SELECT Id FROM Note WHERE parentId = :solution.Id];
        
        System.assertEquals(1, notes.size());
    }
    
    private static void getRestContext(String jsonString){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/UM_UpdateAllWorkOrders'; 
        req.requestBody = Blob.valueof(jsonString);
        
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
    }
}