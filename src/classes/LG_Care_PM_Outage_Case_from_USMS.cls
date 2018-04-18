/************************************************************************************************************************************
*        Class: LG_Care_PM_Outage_Case_from_USMS 
*     Program : B2B CARE CATALYST PROGRAM
*  Description: It is a rest web service. it will create, update, close a case in SFDC based on the request received from USMS. 
*    Author(s): Abhisek Mishra (Infosys Limited)
* Created Date: 02-AUG-2017
*   Test Class: LG_Care_PM_Outage_Case_from_USMS_Test 
*************************************************************************************************************************************/

@RestResource(urlMapping='/ticketinsalesforce/*')
global class LG_Care_PM_Outage_Case_from_USMS {
    Static String sf_jsonResponse = '';
    
    @HttpPOST
    global static void create_Update_Case() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<CaseWrapperList> casesFromUSMS = null;
        if(req.requestBody != null){
            System.debug('------------------- response '+ req.requestBody.toString());
            //LG_ServiceTechnicalFailure.createCalloutFailureResult(null,null,null,'USMS Outage Temp',null,'', req.requestBody.toString(), null);
            JSONParser parser = JSON.createParser(req.requestBody.toString());
            casesFromUSMS = requestReaderJSON(parser);
            
            //XmlStreamReader reader = new XmlStreamReader(req.requestBody.toString());
            //casesFromUSMS = requestReader(reader);
        }
        if(casesFromUSMS != null && casesFromUSMS.size() > 0) {
            List<CaseWrapperList> casesToCreate = new List<CaseWrapperList>();
            List<CaseWrapperList> casesToUpdate = new List<CaseWrapperList>();
            List<CaseWrapperList> casesToClose = new List<CaseWrapperList>();
            List<CaseWrapperList> bdsCases = new List<CaseWrapperList>();
            Id caseId = null;
            for(CaseWrapperList c: casesFromUSMS) {
                if(c.action.equalsIgnoreCase('insert')) {
                    casesToCreate.add(c);
                }
                else if(c.action.equalsIgnoreCase('update')) {
                    casesToUpdate.add(c);
                }
                else if(c.action.equalsIgnoreCase('delete')) {
                    casesToClose.add(c);
                }
                if(c.service!=null && c.service.equalsIgnoreCase('B2B VPN DE PROD')) {
                    bdsCases.add(c);
                }
            }
            //Decided to query coz if we don't query then we have to use the recordtype name. If that changes in future then we have to modify it in everyplace.
            RecordType rtPlanned = [SELECT id,Name FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Planned_Maintenance_Request_UM']; 
            RecordType rtOutage = [SELECT id,Name FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Mass_Outage_Request_UM'];
            if(casesToCreate != null && casesToCreate.size() > 0) {
                List<case> createCases = new List<Case>();
                for(CaseWrapperList cwl: casesToCreate) {
                    Case c = new Case();
                    if(cwl.outageId.startsWithIgnoreCase('crq')) {
                        c.recordTypeId = rtPlanned.Id;
                    }
                    if(cwl.outageId.startsWithIgnoreCase('inc')) {
                        c.recordTypeId = rtOutage.Id;
                    }
                    c.USMS_Ticket_ID__c = cwl.outageId;
                    if(cwl.description != null) {
                        c.Description = cwl.description;
                    }
                    if(cwl.EstimatedStartDate != null && cwl.EstimatedStartDate != '') {
                        c.LG_Estimated_Start_Time__c = convertStringToDateTime(cwl.EstimatedStartDate);
                    }
                    if(cwl.EstimatedEndDate != null && cwl.EstimatedEndDate != '') {
                        c.LG_Estimated_resolution_time__c = convertStringToDateTime(cwl.EstimatedEndDate);
                    }
                    if(cwl.priority != null && cwl.priority != '') {
                        c.priority = cwl.priority;
                    }
                    if(cwl.status != null && cwl.status != '') {
                        c.status = cwl.status;//status mapping
                    }
                    if(cwl.elementId != null) {
                        c.B2B_Care_Element_Id__c = cwl.elementId;
                    }
                    if(cwl.affectedServices != null) {
                        c.B2B_Care_Affected_Services__c = cwl.affectedServices;
                    }
                    if(cwl.service != null && !cwl.service.equalsIgnoreCase('HPBX PROD DE') && !cwl.service.equalsIgnoreCase('B2B VPN DE PROD')) {
                        c.B2B_Care_Created_Ticket_From_USMS__c = true;
                    }
                    if(cwl.service != null) {
                        c.LG_Care_USMS_Service__c = cwl.service;
                    }
                    if(cwl.service!=null && cwl.service.equalsIgnoreCase('HPBX PROD DE')) {
                        c.Type = 'Service Performance';
                    }
                    else
                        c.Type = 'Service Down';
                    c.LG_Case_Reason__c = 'Node';
                    createCases.add(c);
                }
                try{
                    if(createCases != null && createCases.size() > 0) {
                        Database.insert(createCases);
                        caseId = createCases[0].Id;
                        sf_jsonResponse = '{"setIncidentResponse": {"success": "true"}}';
                        res.statusCode = 200;
                        res.responseBody = blob.valueOf(sf_jsonResponse);
                        res.addHeader('Content-Type', 'application/json');
                    }
                }
                catch (Exception e) {
                    
                    sf_jsonResponse = '{"setIncidentResponse": {"success": "false", "errorMessage": "'+e.getMessage()+'"}}';
                    res.statusCode = 500;
                    res.responseBody = blob.valueOf(sf_jsonResponse);
                    res.addHeader('Content-Type', 'application/json');
                    LG_ServiceTechnicalFailure.createCalloutFailureResult(null,null,null,'USMS System',null,sf_jsonResponse, req.requestBody.toString(), null);
                }
            }
            if(casesToUpdate != null && casesToUpdate.size() > 0) {
                List<case> updateCases = new List<Case>();
                List<String> outageIdsFromUSMS = new List<String>();
                for(CaseWrapperList cwl: casesToUpdate) {
                    outageidsFromUSMS.add(cwl.outageId);
                }
                for(Case c : [SELECT USMS_Ticket_ID__c,Description,LG_Estimated_Start_Time__c,LG_Estimated_resolution_time__c,priority,status,B2B_Care_Element_Id__c,B2B_Care_Affected_Services__c FROM Case WHERE USMS_Ticket_ID__c in :outageIdsFromUSMS]) {
                    for(CaseWrapperList cwl: casesToUpdate) {
                        caseId = c.Id;
                        if(c.USMS_Ticket_ID__c == cwl.outageId) {
                            if(cwl.description != null) {
                                c.Description = cwl.description;
                            }
                            if(cwl.EstimatedStartDate != null && cwl.EstimatedStartDate != '') {
                                c.LG_Estimated_Start_Time__c = convertStringToDateTime(cwl.EstimatedStartDate);
                            }
                            if(cwl.EstimatedEndDate != null && cwl.EstimatedStartDate != '') {
                                c.LG_Estimated_resolution_time__c = convertStringToDateTime(cwl.EstimatedEndDate);
                            }
                            if(cwl.priority != null && cwl.priority != '') {
                                c.priority = cwl.priority;
                            }
                            if(cwl.status != null && cwl.status != '') {
                                c.status = cwl.status; 
                            }
                            if(cwl.elementId != null) {
                                c.B2B_Care_Element_Id__c = cwl.elementId;
                            }
                            if(cwl.affectedServices != null) {
                                c.B2B_Care_Affected_Services__c = cwl.affectedServices;
                            }
                            if(cwl.service != null) {
                                c.LG_Care_USMS_Service__c = cwl.service;
                            }
                            updateCases.add(c);
                        }
                    }
                }
                try{
                    if(updateCases != null && updateCases.size() > 0) {
                        Database.update(updateCases);
                        sf_jsonResponse = '{"setIncidentResponse": {"success": "true"}}';
                        res.statusCode = 200;
                        res.responseBody = blob.valueOf(sf_jsonResponse);
                        res.addHeader('Content-Type', 'application/json');
                    }
                }
                catch (Exception e) {
                    sf_jsonResponse = '{"setIncidentResponse": {"success": "false", "errorMessage": "'+e.getMessage()+'"}}';
                    res.statusCode = 500;
                    res.responseBody = blob.valueOf(sf_jsonResponse);
                    res.addHeader('Content-Type', 'application/json');
                    LG_ServiceTechnicalFailure.createCalloutFailureResult(null,null,null,'USMS System',null,sf_jsonResponse, req.requestBody.toString(), null);
                }
            }
            if(casesToClose != null && casesToClose.size() > 0) {
                List<case> closeCases = new List<Case>();
                List<String> outageIdsFromUSMS = new List<String>();
                for(CaseWrapperList cwl: casesToClose) {
                    outageidsFromUSMS.add(cwl.outageId);
                }
                for(Case c : [SELECT USMS_Ticket_ID__c,status FROM Case WHERE USMS_Ticket_ID__c in :outageIdsFromUSMS]) {
                    for(CaseWrapperList cwl: casesToClose) {
                        if(c.USMS_Ticket_ID__c == cwl.outageId) {
                            c.status = 'Closed';
                            closeCases.add(c);
                        }
                    }
                }
                try{
                    if(closeCases != null && closeCases.size() > 0) {
                        
                        Database.update(closeCases);
                        sf_jsonResponse = '{"setIncidentResponse": {"success": "true"}}';
                        res.statusCode = 200;
                        res.responseBody = blob.valueOf(sf_jsonResponse);
                        res.addHeader('Content-Type', 'application/json');
                    }
                }
                catch (Exception e) {
                    sf_jsonResponse = '{"setIncidentResponse": {"success": "false", "errorMessage": "'+e.getMessage()+'"}}';
                    res.statusCode = 500;
                    res.responseBody = blob.valueOf(sf_jsonResponse);
                    res.addHeader('Content-Type', 'application/json');
                    LG_ServiceTechnicalFailure.createCalloutFailureResult(null,null,null,'USMS System',null,sf_jsonResponse, req.requestBody.toString(), null);
                }
            }
            // This method will be called for BDS services. As per the structure defined by USMS, only one case and it's related service impacted infos
            // shall be sent to SFDC. So we can attach the incoming service impacted records to the one case which has come. 
            // So we can use list_name[0].id to get the id of the parent case.
            if(bdsCases != null && bdsCases.size() > 0) {
                
                if(caseId != null && (!bdsCases[0].impactedServiceIds.isEmpty() || !bdsCases[0].impactedEquipmentIds.isEmpty())) {
                    attach_BDS_Services(bdsCases,caseId);
                }
                
            }
        }
    return;
    }
    /* This method will be executed only for BDS Services.
     * Service impacted records will be created using Ids (service ext id and equipment id) exempting the ids already present in the system.
     * while we create the service impacted records we will also capture the relevant service id of the BDS service. */
    public static void attach_BDS_Services(List<CaseWrapperList> bdsCases, Id caseId) {
        // only one case will come at a time
        CaseWrapperList bdsCase = bdsCases[0];
        
        Map<String,String> serviceExtIdMapServiceId = new Map<String,String>();
        Map<String,String> macIdMapServiceId = new Map<String,String>();
        
        Set<String> allMacs = new Set<String>();
        Set<String> allServiceExtIds = new Set<String>();
        if(!bdsCase.impactedServiceIds.isEmpty())
            allServiceExtIds.addAll(bdsCase.impactedServiceIds);
        if(!bdsCase.impactedEquipmentIds.isEmpty())
            allMacs.addAll(bdsCase.impactedEquipmentIds);
        //Set<csord__Service__c>
        for(csord__Service__c ser: [SELECT id,UM_ProvisioningServiceExternalId__c,UM_ESN__c FROM csord__Service__c WHERE UM_ESN__c in :allMacs OR UM_ProvisioningServiceExternalId__c in :allServiceExtIds]) {
            if(ser.UM_ProvisioningServiceExternalId__c != null || ser.UM_ProvisioningServiceExternalId__c != '' && allServiceExtIds.contains(ser.UM_ProvisioningServiceExternalId__c)) {
                serviceExtIdMapServiceId.put(ser.UM_ProvisioningServiceExternalId__c, ser.Id);
            }
            if(ser.UM_ESN__c != null || ser.UM_ESN__c != '' && allMacs.contains(ser.UM_ESN__c)) {
                macIdMapServiceId.put(ser.UM_ESN__c, ser.Id);
            }
        }
        List<Service_Impacted__c> servicesNew_or_Updated = new List<Service_Impacted__c>();
        List<Service_Impacted__c> serviceImpactedPresent = [SELECT LG_B2B_Care_Equipment_id__c,B2B_Service_Id__c,LG_Care_Service_Record_Id__c FROM Service_Impacted__c WHERE B2B_Case_Number__c = :caseId];      
        for(Service_Impacted__c s :serviceImpactedPresent){
            // test if bdsCase.serviceIds contains s.B2B_Service_Id__c then change remove it from a set/list
            Boolean flag = false;
            if(s.B2B_Service_Id__c != null && allServiceExtIds.contains(s.B2B_Service_Id__c)) {
                allServiceExtIds.remove(s.B2B_Service_Id__c);
                if(serviceExtIdMapServiceId.containsKey(s.B2B_Service_Id__c) && s.LG_Care_Service_Record_Id__c != serviceExtIdMapServiceId.get(s.B2B_Service_Id__c)) {
                    s.LG_Care_Service_Record_Id__c = serviceExtIdMapServiceId.get(s.B2B_Service_Id__c);
                    flag = true;
                }
            }
            if(s.LG_B2B_Care_Equipment_id__c != null && allMacs.contains(s.LG_B2B_Care_Equipment_id__c)) {
                allMacs.remove(s.LG_B2B_Care_Equipment_id__c);
                if(macIdMapServiceId.containsKey(s.LG_B2B_Care_Equipment_id__c) && s.LG_Care_Service_Record_Id__c != macIdMapServiceId.get(s.LG_B2B_Care_Equipment_id__c) ) {
                    s.LG_Care_Service_Record_Id__c = macIdMapServiceId.get(s.LG_B2B_Care_Equipment_id__c);
                    flag = true;
                }
            }
            if(flag) 
                servicesNew_or_Updated.add(s);
        }
        RecordType serImp = [SELECT id,Name FROM RecordType WHERE DeveloperName = 'LG_B2B_Care_Service_Id']; 
        //insert remaining service and equipment ids and use the map for macadress to service id mapping.
        //create a case for each service and equipment id.
        for(String s :allMacs) {
            Service_Impacted__c ser = new Service_Impacted__c();
            ser.RecordTypeId = serImp.Id;
            ser.B2B_Case_Number__c = caseId;
            ser.LG_B2B_Care_Equipment_id__c = s;
            if(macIdMapServiceId.containsKey(s))
                ser.LG_Care_Service_Record_Id__c = macIdMapServiceId.get(s);
            servicesNew_or_Updated.add(ser);
        }
        
        for(String s :allserviceextids) {
            Service_Impacted__c ser = new Service_Impacted__c();
            ser.RecordTypeId = serImp.Id;
            ser.B2B_Case_Number__c = caseId;
            ser.B2B_Service_Id__c = s;
            if(serviceExtIdMapServiceId.containsKey(s))
                ser.LG_Care_Service_Record_Id__c = serviceExtIdMapServiceId.get(s);
            servicesNew_or_Updated.add(ser);
        }
        Database.upsert(servicesNew_or_Updated);
    }
    
    public static List<CaseWrapperList> requestReaderJSON(JSONParser parser) {
        List<CaseWrapperList> casesFromUSMS = new List<CaseWrapperList>();
        CaseWrapperList case1 = null;
        while(parser.nextToken() != null) {
            if(parser.getCurrentToken() == JSONToken.START_OBJECT) {
                
                case1 = JSONObjectParser(parser);
                if(case1 != null) {
                    casesFromUSMS.add(case1);
                }
            }
            if(parser.nextToken() == JSONToken.END_ARRAY) {
                break;
            }
        }
        return casesFromUSMS;
    }
    
    public static CaseWrapperList JSONObjectParser(JSONParser parser) {
        CaseWrapperList cwl = new CaseWrapperList();
        String value;
        String text;
        JSONToken token;
        
        while(parser.nextToken() != JSONToken.END_OBJECT) {
            
            token = parser.getCurrentToken();
            text = parser.getText();
            
            if(token == JSONToken.FIELD_NAME && text == 'Action') {
                parser.nextToken();
                value = parser.getText();
                cwl.action = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && (text == 'Outage_Id' || text == 'IncidentId')) {
                parser.nextToken();
                value = parser.getText();
                cwl.outageId = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && (text == 'Description' || text == 'IncidentNotes')) {
                parser.nextToken();
                value = parser.getText();
                cwl.description = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && text == 'Estimated_start_time') {
                parser.nextToken();
                value = parser.getText();
                cwl.estimatedStartDate = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && (text == 'Estimated_end_time' || text == 'IncidentEndTime')) {
                parser.nextToken();
                value = parser.getText();
                cwl.EstimatedEndDate = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && text == 'priority') {
                parser.nextToken();
                value = parser.getText();
                cwl.priority = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && (text == 'status' || text == 'IncidentStatus')) {
                parser.nextToken();
                value = parser.getText();
                cwl.status = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && text == 'Element_id') {
                parser.nextToken();
                value = parser.getText();
                cwl.elementId = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && text == 'affected_services') {
                parser.nextToken();
                value = parser.getText();
                cwl.affectedServices = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && text.equalsIgnoreCase('service')) {
                parser.nextToken();
                value = parser.getText();
                cwl.service = value.trim();
                //system.debug('real madrid: '+cwl.service);
            }
            else if(token == JSONToken.FIELD_NAME && text.equalsIgnoreCase('Impacted_service_ids')) {
                parser.nextToken();
                List<String> value1 = parser.getText().split(',');
                for(String val :value1) {
                    cwl.impactedServiceIds.add(val.trim());
                }
            }
            else if(token == JSONToken.FIELD_NAME && text.equalsIgnoreCase('Impacted_equipment_ids')) {
                parser.nextToken();
                List<String> value1 = parser.getText().split(',');
                for(String val :value1) {
                    cwl.impactedEquipmentIds.add(val.trim());
                }
            }
        }
        return cwl;
    }
    
    public static DateTime convertStringToDateTime(String value) {
        String stringDateTimeValue = value.replace('T',' ');
        DateTime d = DateTime.valueOf(stringDateTimeValue);
        return d;
    }
    
    public class CaseWrapperList {
        public String action;
        public String outageId;
        public String Description;
        public String EstimatedStartDate;
        public String EstimatedEndDate;
        public String priority;
        public String status;
        public String elementId;
        public String affectedServices;
        public String service;
        public Set<String> impactedServiceIds = new Set<String>();
        public Set<String> impactedEquipmentIds = new Set<String>();
    }
}