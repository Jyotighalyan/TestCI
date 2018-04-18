/************************************************************************************************************************************
*        Class: LG_OutageCaseTest
*     Program : B2B SELF CARE PROGRAM
*  Description: Test class for LG_OutageCase class
*    Author(s): Namrata Mehta (Infosys Limited)
* Created Date: 25-JAN-2018
*************************************************************************************************************************************/

@isTest(seeAllData=false)
global class LG_OutageCaseTest{
    
    global static testmethod void getOutages() {

        Datetime dateTimeInstance = Datetime.now();
        Account acc = new Account();
        acc.AccountNumber = '1234';
        acc.Name = 'Planned Maintenance Account';
        acc.LG_ChamberOfCommerceNumber__c='776879'; 
        acc.LG_VisitCountry__c = 'Germany';
        insert acc;

        Account acc1 = new Account();
        acc1.AccountNumber = '5678';
        acc1.Name = 'Planned Maintenance Account';
        acc1.LG_ChamberOfCommerceNumber__c='776870';    
        acc1.LG_VisitCountry__c = 'Germany';
        insert acc1;
        
        csord__Order_Request__c orderRequest = new csord__Order_Request__c();
        orderRequest.Name = 'Test Order Request';
        orderRequest.csord__Module_Name__c = 'Test Module';
        orderRequest.csord__Module_Version__c = 'Test v1.0';
        orderRequest.csord__Process_Status__c = 'Testing';
        orderRequest.csord__Request_DateTime__c = dateTimeInstance;
        insert orderRequest;
        
        csord__Order_Request__c orderRequest1 = new csord__Order_Request__c();
        orderRequest1.Name = 'Test Order Request1';
        orderRequest1.csord__Module_Name__c = 'Test Module 1';
        orderRequest1.csord__Module_Version__c = 'Test v1.0';
        orderRequest1.csord__Process_Status__c = 'Testing';
        orderRequest1.csord__Request_DateTime__c = dateTimeInstance;
        insert orderRequest1;
        
        csord__Subscription__c sub = new csord__Subscription__c();
        sub.Name = 'Business Broadband';
        sub.csord__Account__c = acc.id;
        sub.csord__Identification__c = 'Test Identification';
        sub.csord__Order_Request__c = orderRequest.id;
        insert sub;
        
        csord__Subscription__c sub1 = new csord__Subscription__c();
        sub1.Name = 'Business Broadband';
        sub1.csord__Account__c = acc1.id;
        sub1.csord__Identification__c = 'Test Identification';
        sub1.csord__Order_Request__c = orderRequest1.id;
        insert sub1;
        
        cscrm__Address__c address = new cscrm__Address__c();
        address.cscrm__Zip_Postal_Code__c = '411057';
        address.cscrm__City__c='pune';
        address.cscrm__Street__c='phase2';
        address.Name = 'Test Address';
        insert address;
        
        csord__Service__c service = new csord__Service__c();
        service.csord__Subscription__c = sub.id;
        service.LG_ServiceExternalId__c = '1122457';
        service.LG_ServiceStatus__c='Active';
        service.LG_Address__c = address.id;
        service.Name = 'Test Service';
        service.csord__Order_Request__c = orderRequest.Id;
        service.LG_ProvisioningAccountNo__c = '117117';        
        service.csord__Identification__c ='12345609';
        insert service;
        
        csord__Service__c service2 = new csord__Service__c();
            service2.csord__Subscription__c = sub1.id;
            service2.LG_Address__c = address.id;
            service2.Name = 'Test Service';
            service2.LG_ServiceStatus__c = 'Active';
            service2.csord__Order_Request__c = orderRequest1.Id;
            service2.csord__Identification__c ='test Identification';
            service2.LG_ProvisioningAccountNo__c = '117117';
            service2.UM_ServiceStatus__c = 'Active';
            service2.LG_ServiceExternalId__c = '1181909';
            insert service2;
        
        csord__Service__c service3 = new csord__Service__c();
            service3.csord__Subscription__c = sub1.id;
            service3.LG_Address__c = address.id;
            service3.Name = 'Test Service';
            service3.LG_ServiceStatus__c = 'Active';
            service3.csord__Order_Request__c = orderRequest1.Id;
            service3.csord__Identification__c ='test Identification';
            service3.LG_ProvisioningAccountNo__c = '117117';
            service3.UM_ServiceStatus__c = 'Active';
            service3.LG_ServiceExternalId__c = '1181900';
            insert service3;
            
        Asset a = new Asset();
            a.accountId = acc1.Id;
            a.csord__Service__c = service3.Id;
            a.name = 'Planned Maintenance Asset';
            a.LG_MACAddress__c = 'a23bcdf6890';
            insert a;
        
        Asset a1 = new Asset();
            a1.accountId = acc1.Id;
            a1.csord__Service__c = service.Id;
            a1.name = 'Planned Maintenance Asset';
            a1.LG_MACAddress__c = 'a23bcdf6880';
            insert a1;
        
        List<csord__Service__c> serList = [SELECT  LG_ServiceStatus__c , LG_ServiceExternalId__c,csordtelcoa__Service_Number__c,LG_Address__r.cscrm__Zip_Postal_Code__c,LG_Address__r.cscrm__City__c,LG_Address__r.cscrm__Street__c ,csord__Subscription__c FROM csord__Service__c WHERE csord__Subscription__c in (SELECT id FROM csord__Subscription__c WHERE csord__Account__r.LG_AccountNumber__c = :acc.LG_AccountNumber__c) ] ;
        
        
        RecordType rt = [SELECT id,DeveloperName FROM RecordType WHERE (DeveloperName = 'LG_B2B_Care_Planned_Maintenance_Request_UM' OR DeveloperName = 'LG_B2B_Care_Mass_Outage_Request_UM') and sObjectType='case' limit 1];
        Case outagecase = new Case();
        outagecase.RecordTypeId = rt.id;
        //system.debug('case rid=='+rt.id);
        outagecase.LG_Case_Reason__c = 'Node';
        outagecase.Description = 'Testing';
        outagecase.Status = 'In progress';
        outagecase.Origin = 'Phone';
        outagecase.Type = 'Service Intermittent';
        outagecase.Priority = 'Escalated';
        outagecase.Subject = 'Test Outage';
        dateTimeInstance = Datetime.now();
        dateTimeInstance = dateTimeInstance.addMinutes(182);
        outagecase.LG_Estimated_Start_Time__c = dateTimeInstance;
        dateTimeInstance = dateTimeInstance.addDays(3);
        outagecase.LG_Estimated_resolution_time__c = dateTimeInstance;
        insert outagecase;
        outagecase = [select id, casenumber from case where id = : outagecase.id];
        //system.debug('case number is '+outagecase.CaseNumber);
                
        RecordType rt1 = [SELECT id FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Address_and_Service_Type' and sobjectType='Service_Impacted__c'];
        Service_Impacted__c si = new Service_Impacted__c();
        si.RecordTypeId = rt1.Id;
        
        si.B2B_Case_Number__c = outagecase.id;
        //system.debug('B2B_Case_Number__c value +++++'+si.B2B_Case_Number__c);
        si.B2B_Service_Id__c = '1181909';
        si.LG_Care_Customer_Number__c = '117117';
        si.B2B_Service_Category__c = 'abc';
        si.LG_B2B_Care_Equipment_id__c = 'a23bcdf6880';
        si.LG_Care_Service_Record_Id__c = '1181900';
        insert si;
                 
            Map<id,  csord__Service__c> m2 = new Map<id,  csord__Service__c>();            
            Service_Impacted__c si2 = new Service_Impacted__c();
            si2.RecordTypeId = rt1.Id;
            si2.B2B_Service_Id__c = '1181900';
            si2.LG_Care_Customer_Number__c = '117117';
            si2.LG_Care_Service_Record_Id__c = 'a3W6E000000XrluUAC';
            si2.LG_B2B_Care_Equipment_id__c = 'a23bcdf6880';
            m2.put(service3.id, service3);
            si2.B2B_Case_Number__c = outagecase.id;
            insert si2; 
            //system.debug('care cust no=='+si2.LG_Care_Customer_Number__c);

        test.startTest();
        //Test.setMock(HttpCalloutMock.class, new Lg_OutageMockHttpResponseGenerator());
        //LG_OutageCase.getCaseOutage();
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        Account acct = [select id, LG_AccountNumber__c, AccountNumber from Account where id =:acc.id limit 1];
        request.requestUri ='/services/apexrest/outage/'+ acct.LG_AccountNumber__c;
        string requestIdTemp = request.requestUri.substring(request.requestUri.lastIndexOf('/')+1);
        //system.debug('requestIdTemp==='+requestIdTemp);
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = res;
        LG_OutageCase.getCaseOutage();
        
        /*RestRequest request1 = new RestRequest();
        RestResponse res1 = new RestResponse();
        system.debug('acc1 value--'+acc1.id);
        Account acct1 = [select id, LG_AccountNumber__c, AccountNumber from Account where id =:acc1.id limit 1];
        system.debug('acct1 list ='+acct1);
        request1.requestUri ='/services/apexrest/outage/'+ acct1.LG_AccountNumber__c;
        request1.addParameter('serviceId', service2.Id);
        system.debug('check the val++'+request1.params);
        string requestIdTemp1 = request1.requestUri.substring(request1.requestUri.lastIndexOf('/')+1);
        
        system.debug('requestIdTemp+++'+requestIdTemp1);
        system.debug('requestIdTemp+++'+request1.params);
        String service_id = request1.params.get('serviceId');
        service2.id= request1.params.get('serviceId');
        //system.debug('service value is++'+service2.id);
        //system.debug('service value is++'+service_id);
        
        
        request1.httpMethod = 'GET';
        RestContext.request = request1;
        RestContext.response = res1;
        LG_OutageCase.getCaseOutage();      */  
        test.stopTest();
    }
    
    global static testmethod void getOutages1(){
        
        Datetime dateTimeInstance = Datetime.now();
        Account acc1 = new Account();
        acc1.AccountNumber = '5678';
        acc1.Name = 'Planned Maintenance Account';
        acc1.LG_ChamberOfCommerceNumber__c='776870';    
        acc1.LG_VisitCountry__c = 'Germany';
        insert acc1;

        csord__Order_Request__c orderRequest1 = new csord__Order_Request__c();
        orderRequest1.Name = 'Test Order Request1';
        orderRequest1.csord__Module_Name__c = 'Test Module 1';
        orderRequest1.csord__Module_Version__c = 'Test v1.0';
        orderRequest1.csord__Process_Status__c = 'Testing';
        orderRequest1.csord__Request_DateTime__c = dateTimeInstance;
        insert orderRequest1;

        csord__Subscription__c sub1 = new csord__Subscription__c();
        sub1.Name = 'Business Broadband';
        sub1.csord__Account__c = acc1.id;
        sub1.csord__Identification__c = 'Test Identification';
        sub1.csord__Order_Request__c = orderRequest1.id;
        insert sub1;
        
        cscrm__Address__c address = new cscrm__Address__c();
        address.cscrm__Zip_Postal_Code__c = '411057';
        address.cscrm__City__c='pune';
        address.cscrm__Street__c='phase2';
        address.Name = 'Test Address';
        insert address;

        csord__Service__c service2 = new csord__Service__c();
            service2.csord__Subscription__c = sub1.id;
            service2.LG_Address__c = address.id;
            service2.Name = 'Test Service';
            service2.LG_ServiceStatus__c = 'Active';
            service2.csord__Order_Request__c = orderRequest1.Id;
            service2.csord__Identification__c ='test Identification';
            service2.LG_ProvisioningAccountNo__c = '117117';
            service2.UM_ServiceStatus__c = 'Active';
            service2.LG_ServiceExternalId__c = '1181900';
            insert service2;
        
        Asset a1 = new Asset();
            a1.accountId = acc1.Id;
            a1.csord__Service__c = service2.Id;
            a1.name = 'Planned Maintenance Asset';
            a1.LG_MACAddress__c = 'a23bcdf6880';
            insert a1;

        test.startTest();
        RestRequest request1 = new RestRequest();
        RestResponse res1 = new RestResponse();
        Account acct1 = [select id, LG_AccountNumber__c, AccountNumber from Account where id =:acc1.id limit 1];
        request1.requestUri ='/services/apexrest/outage/'+ acct1.LG_AccountNumber__c;
        request1.addParameter('serviceId', service2.Id);
        string requestIdTemp1 = request1.requestUri.substring(request1.requestUri.lastIndexOf('/')+1);
        //system.debug('requestIdTemp+++'+requestIdTemp1);
        String service_id = request1.params.get('serviceId');
        service2.id= request1.params.get('serviceId');
        
        RecordType rt1 = [SELECT id,DeveloperName FROM RecordType WHERE (DeveloperName = 'LG_B2B_Care_Planned_Maintenance_Request_UM' OR DeveloperName = 'LG_B2B_Care_Mass_Outage_Request_UM') and sObjectType='case' limit 1];
        Case outagecase = new Case();
        outagecase.RecordTypeId = rt1.id;
        outagecase.LG_Case_Reason__c = 'Node';
        outagecase.Description = 'Testing';
        outagecase.Status = 'In progress';
        outagecase.Origin = 'Phone';
        outagecase.Type = 'Service Intermittent';
        outagecase.Priority = 'Escalated';
        outagecase.Subject = 'Test Outage';
        dateTimeInstance = Datetime.now();
        dateTimeInstance = dateTimeInstance.addMinutes(182);
        outagecase.LG_Estimated_Start_Time__c = dateTimeInstance;
        dateTimeInstance = dateTimeInstance.addDays(3);
        outagecase.LG_Estimated_resolution_time__c = dateTimeInstance;
        //system.debug('case here=');
        insert outagecase;
        outagecase = [select id, casenumber from case where id = : outagecase.id];
        //system.debug('case number is '+outagecase.CaseNumber);

        
        RecordType rt = [SELECT id FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Address_and_Service_Type' and sobjectType='Service_Impacted__c'];

            Map<id,  csord__Service__c> m2 = new Map<id,  csord__Service__c>();            
            Service_Impacted__c si2 = new Service_Impacted__c();
            si2.RecordTypeId = rt.Id;
            si2.B2B_Service_Id__c = '1181900';
            si2.LG_Care_Customer_Number__c = '117117';
            si2.LG_Care_Service_Record_Id__c = '1181900';
            si2.LG_B2B_Care_Equipment_id__c = 'a23bcdf6880';
            m2.put(service2.id, service2);
            si2.B2B_Case_Number__c = outagecase.id;
            insert si2; 
            //system.debug('care cust no=='+si2.LG_Care_Customer_Number__c);
            
            csord__Service__c service3 = new csord__Service__c();
            service3.csord__Subscription__c = sub1.id;
            service3.LG_Address__c = address.id;
            service3.Name = 'Test Service';
            service3.LG_ServiceStatus__c = 'Active';
            service3.csord__Order_Request__c = orderRequest1.Id;
            service3.csord__Identification__c ='test Identification';
            service3.LG_ProvisioningAccountNo__c = '117117';
            service3.UM_ServiceStatus__c = 'Active';
            service3.LG_ServiceExternalId__c = '1181900';
            insert service3;

            Map<id,  csord__Service__c> m3 = new Map<id,  csord__Service__c>();           
            Service_Impacted__c si3 = new Service_Impacted__c();
            si3.RecordTypeId = rt.Id;
            si3.B2B_Service_Id__c = '';
            si3.LG_Care_Customer_Number__c = '117117';
            si3.LG_Care_Service_Record_Id__c = '1181900';
            si3.LG_B2B_Care_Equipment_id__c = '';
            m3.put(service3.id, service3);
            si3.B2B_Case_Number__c = outagecase.id;
            insert si3; 

        
        system.debug('300 line=='+[SELECT id,LG_Care_Customer_Number__c,LG_Care_Service_Record_Id__c,LG_B2B_Care_Equipment_id__c,B2B_Postcode__c,B2B_Case_Number__c,B2B_City__c,B2B_Service_Category__c,B2B_Service_Id__c,B2B_Street__c 
                                     FROM Service_Impacted__c
                                     WHERE B2B_Case_Number__c =:outagecase.id]);
        
        request1.httpMethod = 'GET';
        RestContext.request = request1;
        RestContext.response = res1;
        LG_OutageCase.getCaseOutage();        
        test.stopTest();

    }
    
        global static testmethod void getOutages2(){
        
        Datetime dateTimeInstance = Datetime.now();
        Account acc1 = new Account();
        acc1.AccountNumber = '5678';
        acc1.Name = 'Planned Maintenance Account';
        acc1.LG_ChamberOfCommerceNumber__c='776870';    
        acc1.LG_VisitCountry__c = 'Germany';
        insert acc1;

        csord__Order_Request__c orderRequest1 = new csord__Order_Request__c();
        orderRequest1.Name = 'Test Order Request1';
        orderRequest1.csord__Module_Name__c = 'Test Module 1';
        orderRequest1.csord__Module_Version__c = 'Test v1.0';
        orderRequest1.csord__Process_Status__c = 'Testing';
        orderRequest1.csord__Request_DateTime__c = dateTimeInstance;
        insert orderRequest1;

        csord__Subscription__c sub1 = new csord__Subscription__c();
        sub1.Name = 'Business Broadband';
        sub1.csord__Account__c = acc1.id;
        sub1.csord__Identification__c = 'Test Identification';
        sub1.csord__Order_Request__c = orderRequest1.id;
        insert sub1;
        
        cscrm__Address__c address = new cscrm__Address__c();
        address.cscrm__Zip_Postal_Code__c = '411057';
        address.cscrm__City__c='pune';
        address.cscrm__Street__c='phase2';
        address.Name = 'Test Address';
        insert address;

        csord__Service__c service2 = new csord__Service__c();
            service2.csord__Subscription__c = sub1.id;
            service2.LG_Address__c = address.id;
            service2.Name = 'Test Service';
            service2.LG_ServiceStatus__c = 'Active';
            service2.csord__Order_Request__c = orderRequest1.Id;
            service2.csord__Identification__c ='test Identification';
            service2.LG_ProvisioningAccountNo__c = '117117';
            service2.UM_ServiceStatus__c = 'Active';
            service2.LG_ServiceExternalId__c = '1181900';
            insert service2;
        
        Asset a1 = new Asset();
            a1.accountId = acc1.Id;
            a1.csord__Service__c = service2.Id;
            a1.name = 'Planned Maintenance Asset';
            a1.LG_MACAddress__c = 'a23bcdf6880';
            insert a1;

        test.startTest();
        RestRequest request1 = new RestRequest();
        RestResponse res1 = new RestResponse();
        Account acct1 = [select id, LG_AccountNumber__c, AccountNumber from Account where id =:acc1.id limit 1];
        request1.requestUri ='/services/apexrest/outage/'+ acct1.LG_AccountNumber__c;
        request1.addParameter('serviceId', service2.Id);
        string requestIdTemp1 = request1.requestUri.substring(request1.requestUri.lastIndexOf('/')+1);
        //system.debug('requestIdTemp+++'+requestIdTemp1);
        String service_id = request1.params.get('serviceId');
        service2.id= request1.params.get('serviceId');
        
        RecordType rt1 = [SELECT id,DeveloperName FROM RecordType WHERE (DeveloperName = 'LG_B2B_Care_Planned_Maintenance_Request_UM' OR DeveloperName = 'LG_B2B_Care_Mass_Outage_Request_UM') and sObjectType='case' limit 1];
        Case outagecase = new Case();
        outagecase.RecordTypeId = rt1.id;
        outagecase.LG_Case_Reason__c = 'Node';
        outagecase.Description = 'Testing';
        outagecase.Status = 'In progress';
        outagecase.Origin = 'Phone';
        outagecase.Type = 'Service Intermittent';
        outagecase.Priority = 'Escalated';
        outagecase.Subject = 'Test Outage';
        dateTimeInstance = Datetime.now();
        dateTimeInstance = dateTimeInstance.addMinutes(182);
        outagecase.LG_Estimated_Start_Time__c = dateTimeInstance;
        dateTimeInstance = dateTimeInstance.addDays(3);
        outagecase.LG_Estimated_resolution_time__c = dateTimeInstance;
        //system.debug('case here=');
        insert outagecase;
        outagecase = [select id, casenumber from case where id = : outagecase.id];
        //system.debug('case number is '+outagecase.CaseNumber);

        
        RecordType rt = [SELECT id FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Address_and_Service_Type' and sobjectType='Service_Impacted__c'];

            Map<id,  csord__Service__c> m2 = new Map<id,  csord__Service__c>();            
            Service_Impacted__c si2 = new Service_Impacted__c();
            si2.RecordTypeId = rt.Id;
            si2.B2B_Service_Id__c = '1181910';
            si2.LG_Care_Customer_Number__c = '117117';
            si2.LG_Care_Service_Record_Id__c = '1181910';
            si2.LG_B2B_Care_Equipment_id__c = 'a23bcdf6810';
            m2.put(service2.id, service2);
            si2.B2B_Case_Number__c = outagecase.id;
            insert si2; 
            //system.debug('care cust no=='+si2.LG_Care_Customer_Number__c);
            
            csord__Service__c service3 = new csord__Service__c();
            service3.csord__Subscription__c = sub1.id;
            service3.LG_Address__c = address.id;
            service3.Name = 'Test Service';
            service3.LG_ServiceStatus__c = 'Active';
            service3.csord__Order_Request__c = orderRequest1.Id;
            service3.csord__Identification__c ='test Identification';
            service3.LG_ProvisioningAccountNo__c = '117117';
            service3.UM_ServiceStatus__c = 'Active';
            service3.LG_ServiceExternalId__c = '1181900';
            insert service3;

            Map<id,  csord__Service__c> m3 = new Map<id,  csord__Service__c>();           
            Service_Impacted__c si3 = new Service_Impacted__c();
            si3.RecordTypeId = rt.Id;
            si3.B2B_Service_Id__c = '';
            si3.LG_Care_Customer_Number__c = '117117';
            si3.LG_Care_Service_Record_Id__c = '1181910';
            si3.LG_B2B_Care_Equipment_id__c = '';
            m3.put(service3.id, service3);
            si3.B2B_Case_Number__c = outagecase.id;
            insert si3; 

        
        system.debug('300 line=='+[SELECT id,LG_Care_Customer_Number__c,LG_Care_Service_Record_Id__c,LG_B2B_Care_Equipment_id__c,B2B_Postcode__c,B2B_Case_Number__c,B2B_City__c,B2B_Service_Category__c,B2B_Service_Id__c,B2B_Street__c 
                                     FROM Service_Impacted__c
                                     WHERE B2B_Case_Number__c =:outagecase.id]);
        
        request1.httpMethod = 'GET';
        RestContext.request = request1;
        RestContext.response = res1;
        LG_OutageCase.getCaseOutage();        
        test.stopTest();

    }

    
    
    }