@isTest
public class LG_Care_PlannedMaintenanceCntrlTest {
    
    @TestSetUp static void setUpMethod() {
        
        User careAgent = LG_Care_TestRunAsUser.testRunAs();
        system.runas(careagent) {
            //To deactivate the service triggers
            No_Triggers__c noTriggers = No_Triggers__c.getInstance(UserInfo.getUserId());
            noTriggers.Flag__c = true;
            noTriggers.SetupOwnerId = UserInfo.getOrganizationId();
            upsert noTriggers;
            
            
            
            DateTime dateTimeInstance = DateTime.Now();
            Account acc = new Account();
            acc.Name = 'Planned Maintenance Account';
            acc.LG_VisitCountry__c = 'Germany';
            acc.LG_ChamberOfCommerceNumber__c = '7';
            acc.LG_Footprint__c = 'UPC';
            insert acc;
            
            csord__Subscription__c sub = new csord__Subscription__c();
            sub.Name = 'Business Broadband';
            sub.csord__Account__c = acc.id;
            sub.csord__Identification__c = 'Test Identification';
            insert sub;
            
            
            csord__Service__c serviceExtId = new csord__Service__c();
            serviceExtId.csord__Subscription__c = sub.id;
            serviceExtId.LG_ServiceExternalId__c = '1181902';
            serviceExtId.Name = 'Test Service';
            serviceExtId.LG_ServiceStatus__c = 'Active';
            serviceExtId.csord__Identification__c ='test Identification';
            serviceExtId.UM_ServiceStatus__c = 'Active';
            insert serviceExtId;
            csord__Service__c serviceExtId2 = new csord__Service__c();
            serviceExtId2.csord__Subscription__c = sub.id;
            serviceExtId2.LG_ServiceExternalId__c = '11819021';
            serviceExtId2.Name = 'Test Service';
            serviceExtId2.LG_ServiceStatus__c = 'Active';
            serviceExtId2.csord__Identification__c ='test Identification';
            serviceExtId2.UM_ServiceStatus__c = 'Active';
            insert serviceExtId2;
            
            csord__Service__c serviceRecordId = new csord__Service__c();
            serviceRecordId.csord__Subscription__c = sub.id;
            serviceRecordId.Name = 'Test Service';
            serviceRecordId.LG_ServiceStatus__c = 'Active';
            serviceRecordId.csord__Identification__c ='test Identification';
            serviceRecordId.UM_ServiceStatus__c = 'Active';
            insert serviceRecordId;
            csord__Service__c serviceRecordId2 = new csord__Service__c();
            serviceRecordId2.csord__Subscription__c = sub.id;
            serviceRecordId2.Name = 'Test Service';
            serviceRecordId2.LG_ServiceStatus__c = 'Active';
            serviceRecordId2.csord__Identification__c ='test Identification';
            serviceRecordId2.UM_ServiceStatus__c = 'Active';
            insert serviceRecordId2;
            
            csord__Service__c serviceCusNo = new csord__Service__c();
            serviceCusNo.csord__Subscription__c = sub.id;
            serviceCusNo.Name = 'Test Service';
            serviceCusNo.LG_ServiceStatus__c = 'Active';
            serviceCusNo.csord__Identification__c ='test Identification';
            serviceCusNo.UM_ServiceStatus__c = 'Active';
            serviceCusNo.LG_ProvisioningAccountNo__c = '777';
            insert serviceCusNo;
            csord__Service__c serviceCusNo2 = new csord__Service__c();
            serviceCusNo2.csord__Subscription__c = sub.id;
            serviceCusNo2.Name = 'Test Service';
            serviceCusNo2.LG_ServiceStatus__c = 'Active';
            serviceCusNo2.csord__Identification__c ='test Identification';
            serviceCusNo2.UM_ServiceStatus__c = 'Active';
            serviceCusNo2.LG_ProvisioningAccountNo__c = '7771';
            insert serviceCusNo2;
            
            csord__Service__c serviceMac = new csord__Service__c();
            serviceMac.csord__Subscription__c = sub.id;
            serviceMac.Name = 'Test Service';
            serviceMac.LG_ServiceStatus__c = 'Active';
            serviceMac.csord__Identification__c ='test Identification';
            serviceMac.UM_ServiceStatus__c = 'Active';
            insert serviceMac;
            Asset a = new Asset();
            a.accountId = acc.Id;
            a.csord__Service__c = serviceMac.Id;
            a.name = 'Planned Maintenance Asset';
            a.LG_MACAddress__c = 'a23bcdf6890';
            insert a;
            csord__Service__c serviceMac2 = new csord__Service__c();
            serviceMac2.csord__Subscription__c = sub.id;
            serviceMac2.Name = 'Test Service';
            serviceMac2.LG_ServiceStatus__c = 'Active';
            serviceMac2.csord__Identification__c ='test Identification';
            serviceMac2.UM_ServiceStatus__c = 'Active';
            insert serviceMac2;
            Asset a1 = new Asset();
            a1.accountId = acc.Id;
            a1.csord__Service__c = serviceMac2.Id;
            a1.name = 'Planned Maintenance Asset';
            a1.LG_MACAddress__c = 'a23bcdf68901';
            insert a1;
            
            csord__Service__c serviceHPBX = new csord__Service__c();
            serviceHPBX.csord__Subscription__c = sub.id;
            serviceHPBX.Name = 'Test Service';
            serviceHPBX.LG_ServiceStatus__c = 'Active';
            serviceHPBX.csord__Identification__c ='test Identification';
            serviceHPBX.UM_ServiceStatus__c = 'Active';
            serviceHPBX.LG_ProductFamily__c = 'Virtual Phone';
            insert serviceHPBX;
            
            RecordType pmRt = [SELECT id,DeveloperName FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Planned_Maintenance_Request_UM'];
            Case pmCase1 = new Case();
            pmCase1.RecordTypeId = pmRt.id;
            pmCase1.type = 'Service Down';
            pmCase1.LG_Case_Reason__c = 'Node';
            pmCase1.Description = 'Testing';
            dateTimeInstance = Datetime.now();
            dateTimeInstance = dateTimeInstance.addMinutes(182);
            pmCase1.LG_Estimated_Start_Time__c = dateTimeInstance;
            dateTimeInstance = dateTimeInstance.addDays(3);
            pmCase1.LG_Estimated_resolution_time__c = dateTimeInstance;
           // pmCase1.LG_Care_USMS_Service__c = 'Company Internet';
            insert pmCase1;
            
            Service_Impacted__c siSerExtId = new Service_Impacted__c();
            siSerExtId.B2B_Case_Number__c = pmCase1.id;
            siSerExtId.B2B_Service_Id__c = '1181902';
            insert siSerExtId;
            Service_Impacted__c siSerExtId2 = new Service_Impacted__c();
            siSerExtId2.B2B_Case_Number__c = pmCase1.id;
            siSerExtId2.B2B_Service_Id__c = '11819021';
            insert siSerExtId2;
            
            Service_Impacted__c siSerRecordId = new Service_Impacted__c();
            siSerRecordId.LG_Care_Service_Record_Id__c = serviceRecordId.id;
            siSerRecordId.B2B_Case_Number__c = pmCase1.id;
            insert siSerRecordId;
            Service_Impacted__c siSerRecordId2 = new Service_Impacted__c();
            siSerRecordId2.LG_Care_Service_Record_Id__c = serviceRecordId2.id;
            siSerRecordId2.B2B_Case_Number__c = pmCase1.id;
            insert siSerRecordId2;
            
            Service_Impacted__c siCusNo = new Service_Impacted__c();
            siCusNo.LG_Care_Customer_Number__c = '777';
            siCusNo.B2B_Case_Number__c = pmCase1.id;
            insert siCusNo;
            Service_Impacted__c siCusNo2 = new Service_Impacted__c();
            siCusNo2.LG_Care_Customer_Number__c = '7771';
            siCusNo2.B2B_Case_Number__c = pmCase1.id;
            insert siCusNo2;
            
            Service_Impacted__c siMac = new Service_Impacted__c();
            siMac.LG_B2B_Care_Equipment_id__c = 'a23bcdf6890';
            siMac.B2B_Case_Number__c = pmCase1.id;
            insert siMac;
            Service_Impacted__c siMac2 = new Service_Impacted__c();
            siMac2.LG_B2B_Care_Equipment_id__c = 'a23bcdf68901';
            siMac2.B2B_Case_Number__c = pmCase1.id;
            insert siMac2;
            
            RecordType rtOutage = [SELECT id FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Mass_Outage_Request_UM'];
            Case outage = new Case();
            outage.RecordTypeId = rtOutage.id;
            outage.type = 'Service Down';
            outage.LG_Case_Reason__c = 'Node';
            outage.Description = 'Testing';
            //outage.LG_Care_USMS_Service__c = 'Company Fiber';
            insert outage;
            
            
            //Case for HPBX Service
            Case pmCaseHPBX = new Case();
            pmCaseHPBX.RecordTypeId = pmRt.id;
            pmCaseHPBX.type = 'Service Down';
            pmCaseHPBX.LG_Case_Reason__c = 'Node';
            pmCaseHPBX.Description = 'Testing';
            dateTimeInstance = Datetime.now();
            dateTimeInstance = dateTimeInstance.addMinutes(182);
            pmCaseHPBX.LG_Estimated_Start_Time__c = dateTimeInstance;
            dateTimeInstance = dateTimeInstance.addDays(3);
            pmCaseHPBX.LG_Estimated_resolution_time__c = dateTimeInstance;
            pmCaseHPBX.LG_Care_USMS_Service__c = 'HPBX PROD DE';
            insert pmCaseHPBX;
            
            Case outageHPBX = new Case();
            outageHPBX.RecordTypeId = rtOutage.id;
            outageHPBX.type = 'Service Down';
            outageHPBX.LG_Case_Reason__c = 'Node';
            outageHPBX.Description = 'Testing';
            outage.LG_Care_USMS_Service__c = 'HPBX PROD DE';
            insert outageHPBX;
            
            //service.LG_ServiceStatus__c = 'Active';
            //update service;
            
            /*
            
            csord__Service__c ser = new csord__Service__c();
            ser.csord__Subscription__c = sub.id;
            ser.LG_ServiceExternalId__c = '11819021';
            ser.LG_Address__c = address.id;
            ser.Name = 'Test Service';
            ser.LG_ServiceStatus__c = 'Active';
            ser.csord__Order_Request__c = orderRequest.Id;
            ser.csord__Identification__c ='test Identification';
            ser.UM_ServiceStatus__c = 'Active';
            insert ser;
            
            //ser.LG_ServiceStatus__c = 'Active';
            //update ser;
            
            system.debug('Real madrid '+ser.Id);
            
            csord__Service__c ser2 = new csord__Service__c();
            ser2.csord__Subscription__c = sub.id;
            ser2.LG_ServiceExternalId__c = '11819022';
            ser2.LG_Address__c = address.id;
            ser2.Name = 'Test Service';
            ser2.LG_ServiceStatus__c = 'Active';
            ser2.csord__Order_Request__c = orderRequest.Id;
            ser2.csord__Identification__c ='test Identification';
            ser2.UM_ServiceStatus__c = 'Active';
            insert ser2;
            
            //ser2.LG_ServiceStatus__c = 'Active';
            //update ser2;
            
            //test.stoptest();
            
            csord__Service__c ser1 = new csord__Service__c();
            ser1.csord__Subscription__c = sub.id;
            ser1.LG_Address__c = address.id;
            ser1.Name = 'Test Service';
            ser1.LG_ServiceStatus__c = 'Active';
            ser1.csord__Order_Request__c = orderRequest.Id;
            ser1.csord__Identification__c ='test Identification';
            ser1.UM_ServiceStatus__c = 'Active';
            insert ser1;
            
            //ser1.LG_ServiceStatus__c = 'Active';
            //update ser1;
            
            csord__Service__c ser3 = new csord__Service__c();
            ser3.csord__Subscription__c = sub.id;
            ser3.LG_Address__c = address.id;
            ser3.Name = 'Test Service';
            ser3.LG_ServiceStatus__c = 'Active';
            ser3.csord__Order_Request__c = orderRequest.Id;
            ser3.csord__Identification__c ='test Identification';
            ser3.UM_ServiceStatus__c = 'Active';
            insert ser3;
            
            
            //ser3.LG_ServiceStatus__c = 'Active';
            //update ser3;
            
            Asset a = new Asset();
            a.accountId = acc.Id;
            a.csord__Service__c = ser1.Id;
            a.name = 'Planned Maintenance Asset';
            a.LG_MACAddress__c = 'a23bcdf6890';
            insert a;
            
            Asset a1 = new Asset();
            a1.accountId = acc.Id;
            a1.csord__Service__c = ser3.Id;
            a1.name = 'Planned Maintenance Asset';
            a1.LG_MACAddress__c = 'a23bcdf68901';
            insert a1;
            
            csord__Service__c service1 = new csord__Service__c();
            service1.csord__Subscription__c = sub.id;
            service1.LG_Address__c = address.id;
            service1.Name = 'Test Service';
            service1.LG_ServiceStatus__c = 'Active';
            service1.csord__Order_Request__c = orderRequest.Id;
            service1.csord__Identification__c ='test Identification';
            service1.LG_ProvisioningAccountNo__c = '117118';
            service1.UM_ServiceStatus__c = 'Active';
            insert service1;
            
            //service1.LG_ServiceStatus__c = 'Active';
            //update service1;
            
            
            
            csord__Service__c service2 = new csord__Service__c();
            service2.csord__Subscription__c = sub.id;
            service2.LG_Address__c = address.id;
            service2.Name = 'Test Service';
            service2.LG_ServiceStatus__c = 'Active';
            service2.csord__Order_Request__c = orderRequest.Id;
            service2.csord__Identification__c ='test Identification';
            service2.LG_ProvisioningAccountNo__c = '1171181';
            service2.UM_ServiceStatus__c = 'Active';
            insert service2;
            
            //service2.LG_ServiceStatus__c = 'Active';
            //update service2;
            
            csord__Service__c service7 = new csord__Service__c();
            service7.csord__Subscription__c = sub.id;
            service7.LG_Address__c = address.id;
            service7.Name = 'Test Service';
            service7.LG_ServiceStatus__c = 'Active';
            service7.csord__Order_Request__c = orderRequest.Id;
            service7.csord__Identification__c ='test Identification';
            service7.LG_ProvisioningAccountNo__c = '117117';
            service7.UM_ServiceStatus__c = 'Active';
            insert service7;
            
            //service7.LG_ServiceStatus__c = 'Active';
            //update service7;
            
            
            RecordType rt = [SELECT id,DeveloperName FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Planned_Maintenance_Request_UM'];
            Case plannedMaintenance = new Case();
            plannedMaintenance.RecordTypeId = rt.id;
            plannedMaintenance.type = 'Service Down';
            plannedMaintenance.LG_Case_Reason__c = 'Node';
            plannedMaintenance.Description = 'Testing';
            dateTimeInstance = Datetime.now();
            dateTimeInstance = dateTimeInstance.addMinutes(182);
            plannedMaintenance.LG_Estimated_Start_Time__c = dateTimeInstance;
            dateTimeInstance = dateTimeInstance.addDays(3);
            
            plannedMaintenance.LG_Estimated_resolution_time__c = dateTimeInstance;
            insert plannedMaintenance;
            
            Case plannedMaintenance1 = new Case();
            plannedMaintenance1.RecordTypeId = rt.id;
            plannedMaintenance1.type = 'Service Down';
            plannedMaintenance1.LG_Case_Reason__c = 'Node';
            plannedMaintenance1.Description = 'Testing';
            dateTimeInstance = Datetime.now();
            dateTimeInstance = dateTimeInstance.addMinutes(182);
            plannedMaintenance1.LG_Estimated_Start_Time__c = dateTimeInstance;
            dateTimeInstance = dateTimeInstance.addDays(3);
            
            plannedMaintenance1.LG_Estimated_resolution_time__c = dateTimeInstance;
            plannedMaintenance1.LG_Care_USMS_Service__c = 'HPBX PROD DE';
            insert plannedMaintenance1;
            
            
            RecordType rtOutage = [SELECT id FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Mass_Outage_Request_UM'];
            Case outage = new Case();
            outage.RecordTypeId = rtOutage.id;
            outage.type = 'Service Down';
            outage.LG_Case_Reason__c = 'Node';
            outage.Description = 'Testing';
            outage.LG_Care_USMS_Service__c = 'HPBX PROD DE';
            insert outage;
            
            RecordType rt1 = [SELECT id FROM RecordType WHERE DeveloperName = 'LG_Care_Topology_Data_from_SBC'];
            Service_Impacted__c si = new Service_Impacted__c();
            si.RecordTypeId = rt1.Id;
            si.LG_Care_Customer_Number__c = '117118';
            si.B2B_Case_Number__c = plannedMaintenance.id;
            insert si;
            
            Service_Impacted__c si5 = new Service_Impacted__c();
            si5.RecordTypeId = rt1.Id;
            si5.LG_Care_Customer_Number__c = '1171181';
            si5.B2B_Case_Number__c = plannedMaintenance.id;
            insert si5;
            
            Service_Impacted__c si2 = new Service_Impacted__c();
            si2.RecordTypeId = rt1.Id;
            si2.LG_B2B_Care_Equipment_id__c = 'a23bcdf6890';
            si2.B2B_Case_Number__c = plannedMaintenance.id;
            insert si2;
            
            Service_Impacted__c si4 = new Service_Impacted__c();
            si4.RecordTypeId = rt1.Id;
            si4.LG_B2B_Care_Equipment_id__c = 'a23bcdf68901';
            si4.B2B_Case_Number__c = plannedMaintenance.id;
            insert si4;
            
            Service_Impacted__c si6 = new Service_Impacted__c();
            si6.RecordTypeId = rt1.Id;
            si6.B2B_Service_Id__c = '11819021';
            si6.B2B_Case_Number__c = plannedMaintenance.id;
            insert si6;
            
            Service_Impacted__c si7 = new Service_Impacted__c();
            si7.RecordTypeId = rt1.Id;
            si7.B2B_Service_Id__c = '1181902';
            si7.B2B_Case_Number__c = plannedMaintenance.id;
            insert si7;
            
            Service_Impacted__c si3 = new Service_Impacted__c();
            si3.RecordTypeId = rt1.Id;
            si3.B2B_Service_Id__c = '1181902';
            si3.B2B_Case_Number__c = plannedMaintenance.id;
            insert si3;
            
            Service_Impacted__c si10 = new Service_Impacted__c();
            si10.RecordTypeId = rt1.Id;
            si10.LG_Care_Service_Record_Id__c = service7.id;
            si10.B2B_Case_Number__c = plannedMaintenance.id;
            insert si10;
            
            //csord__Service__c se = new csord__Service__c();
            //se = service7;
            Map<id,  csord__Service__c> m1 = new Map<id,  csord__Service__c>();            
            Service_Impacted__c si9 = new Service_Impacted__c();
            si9.RecordTypeId = rt1.Id;
            si9.B2B_Service_Id__c = '1181909';
            si9.LG_Care_Service_Record_Id__c = 'a3W6E000000XrluUAC';
            m1.put(service7.id, service7);
            si9.B2B_Case_Number__c = plannedMaintenance.id;
            insert si9; 
            
            
            system.debug('Real madrid '+service.Id);
            */
            
        }
    }
    @isTest static void mainMethod() {
        User u =  [SELECT Id from User where UserName='careagent.testuser@unityMediaorg.com' limit 1];
        system.runAs(u) {
            Test.startTest();
            Account acc = [SELECT id FROM Account LIMIT 1];
            
            ApexPages.StandardController sc = new ApexPages.StandardController(acc);
            LG_Care_PlannedMaintenanceStatusCntrl c = new LG_Care_PlannedMaintenanceStatusCntrl(sc);
            Test.stopTest();
        }
    }
    
}