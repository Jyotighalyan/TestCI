/************************************************************************************************************************************
*        Class: LG_Care_getTopologyFromSBC 
*      Program: B2B CARE CATALYST PROGRAM
*  Description: The class is exposed as a webservice. It will capture the incoming bulk data from SBC and store it in SFDC.
*    Author(s): Abhisek Mishra (Infosys Limited)
* Created Date: 04-AUG-2017
*   Test Class: LG_Care_getTopologyFromSBCTest
*************************************************************************************************************************************/
@RestResource(urlmapping='/topologyfromsbc/*')
global class LG_Care_getTopologyFromSBC {
    static String sf_jsonResponse;
    @TestVisible static String outageId;
    
    @HttpPOST
    global static void getTopologyData() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<SBCdatas> sbcdataList = new List<SBCdatas>(); 
        if(req.requestBody != null) {
            System.debug('------------ '+req.requestBody.toString());
            //LG_ServiceTechnicalFailure.createCalloutFailureResult(null,null,null,'SBC System Temp',null,'', req.requestBody.toString(), null);
            JSONParser parser = JSON.createParser(req.requestBody.toString());
            sbcdataList = requestReaderJSON(parser);
            
            
            
            List<Service_Impacted__c> ListSerImp = null;
            
            if(sbcdataList.size() > 0 && sbcdataList != null) {
                Map<String,String> macMapServiceExtId = new Map<String,String>();
                List<String> allMacs = new List<String>();
                for(sbcdatas sbc :sbcdataList) {
                    if(sbc.macs != null && sbc.macs.size() > 0) {
                        allMacs.addAll(sbc.macs);
                    }
                }
                List<String> allCustomerNumber = new List<String>();
                for(sbcdatas sbc :sbcdataList) {
                    if(sbc.customer_number != null && sbc.customer_number != '') {
                        allCustomerNumber.add(sbc.customer_number);
                    }
                }
                for(Asset ass :[SELECT id, LG_MACAddress__c,csord__Service__r.LG_ServiceExternalId__c FROM Asset WHERE LG_MACAddress__c in :allMacs]) {
                    macMapServiceExtId.put(ass.LG_MACAddress__c, ass.csord__Service__r.LG_ServiceExternalId__c);
                }
                Set<String> remainingMacs = new Set<String>();
                for(String mac :allMacs) {
                    if(!macMapServiceExtId.containsKey(mac)) {
                        remainingMacs.add(mac);
                    }
                }
                Map<String,String> customerNumberMapServiceExtId = new Map<String,String>();
                for(csord__Service__c ser : [SELECT LG_ProvisioningAccountNo__c, id,LG_ServiceExternalId__c FROM csord__Service__c WHERE LG_ProvisioningAccountNo__c in :allCustomerNumber]) {
                    customerNumberMapServiceExtId.put(ser.LG_ProvisioningAccountNo__c, ser.LG_ServiceExternalId__c);
                }
                Case targetCase = [SELECT id FROM Case WHERE USMS_Ticket_ID__c = :outageId and B2B_Care_Created_Ticket_From_USMS__c = true limit 1];
                //Case targetCase = [SELECT id FROM Case WHERE USMS_Ticket_ID__c = 'INC0000003865'];
                if(targetCase != null) {
                    ListSerImp = new List<Service_Impacted__c>();
                    
                    for(sbcdatas sbc :sbcdataList) {
                        /*
if(sbc.macs != null && sbc.macs.size() > 0) {
for(String s :sbc.macs) {
Service_Impacted__c serImpSerId = new Service_Impacted__c();
serImpSerId.RecordTypeId = Schema.SObjectType.Service_Impacted__c.getRecordTypeInfosByName().get('Service Id').getRecordTypeId();
serImpSerId.B2B_Case_Number__c = targetCase.Id;
serImpSerId.B2B_Service_Id__c = macMapServiceExtId.get(s);

ListSerImp.add(serImpSerId);
}
}
else {

Service_Impacted__c serImpAdd = new Service_Impacted__c();
serImpAdd.RecordTypeId = Schema.SObjectType.Service_Impacted__c.getRecordTypeInfosByName().get('Address and Service Type').getRecordTypeId();
serImpAdd.B2B_Case_Number__c = targetCase.Id;

if(sbc.customer_number != null) {
serImpAdd.LG_Care_Customer_Number__c = sbc.customer_number;
}
if(sbc.customer_type != null) {
serImpAdd.LG_Care_Customer_Type__c = sbc.customer_type;
}
if(sbc.region != null) {
serImpAdd.LG_Care_Region__c = sbc.region;
}
if(sbc.street != null) {
serImpAdd.B2B_Street__c = sbc.street;
}
if(sbc.house_number != null) {
serImpAdd.LG_Care_House_Number__c = sbc.house_number;
}
if(sbc.house_number_addition != null) {
serImpAdd.LG_Care_House_Number_Extension__c = sbc.house_number_addition;
}
if(sbc.city != null) {
serImpAdd.B2B_City__c = sbc.city;
}
if(sbc.zip != null) {
serImpAdd.B2B_Postcode__c = sbc.zip;
}

ListSerImp.add(serImpAdd);
}*/
                        if(sbc.macs != null && sbc.macs.size() > 0 ) {
                            Integer macSize = sbc.macs.size();
                            for(String s :sbc.macs) {
                                Service_Impacted__c serImpAdd = new Service_Impacted__c();
                                serImpAdd.RecordTypeId = Schema.SObjectType.Service_Impacted__c.getRecordTypeInfosByName().get('Topology Data from SBC').getRecordTypeId();
                                serImpAdd.B2B_Case_Number__c = targetCase.Id;
                                
                                if(sbc.customer_number != null && sbc.customer_number != 'null') {
                                    serImpAdd.LG_Care_Customer_Number__c = sbc.customer_number;
                                }
                                if(sbc.customer_type != null && sbc.customer_type != 'null') {
                                    serImpAdd.LG_Care_Customer_Type__c = sbc.customer_type;
                                }
                                if(sbc.region != null && sbc.region != 'null') {
                                    serImpAdd.LG_Care_Region__c = sbc.region;
                                }
                                if(sbc.street != null && sbc.street != 'null') {
                                    serImpAdd.B2B_Street__c = sbc.street;
                                }
                                if(sbc.house_number != null && sbc.house_number != 'null') {
                                    serImpAdd.LG_Care_House_Number__c = sbc.house_number;
                                }
                                if(sbc.house_number_addition != null && sbc.house_number_addition != 'null') {
                                    serImpAdd.LG_Care_House_Number_Extension__c = sbc.house_number_addition;
                                }
                                if(sbc.city != null && sbc.city != 'null') {
                                    serImpAdd.B2B_City__c = sbc.city;
                                }
                                if(sbc.zip != null && sbc.zip != 'null') {
                                    serImpAdd.B2B_Postcode__c = sbc.zip;
                                }
                                
                                serImpAdd.LG_B2B_Care_Equipment_id__c = s;
                                if(macMapServiceExtId.containsKey(s)) {
                                    serImpAdd.B2B_Service_Id__c = macMapServiceExtId.get(s);
                                }
                                else if(customerNumberMapServiceExtId.containsKey(s)){
                                    serImpAdd.B2B_Service_Id__c = customerNumberMapServiceExtId.get(s);
                                }
                                else
                                    serImpAdd.B2B_Service_Id__c = '';
                                
                                ListSerImp.add(serImpAdd);
                            }
                        }
                        else {
                            Service_Impacted__c serImpAdd = new Service_Impacted__c();
                            serImpAdd.RecordTypeId = Schema.SObjectType.Service_Impacted__c.getRecordTypeInfosByName().get('Topology Data from SBC').getRecordTypeId();
                            serImpAdd.B2B_Case_Number__c = targetCase.Id;
                            
                            if(sbc.customer_number != null && sbc.customer_number != 'null') {
                                serImpAdd.LG_Care_Customer_Number__c = sbc.customer_number;
                            }
                            if(sbc.customer_type != null && sbc.customer_type != 'null') {
                                serImpAdd.LG_Care_Customer_Type__c = sbc.customer_type;
                            }
                            if(sbc.region != null && sbc.region != 'null') {
                                serImpAdd.LG_Care_Region__c = sbc.region;
                            }
                            if(sbc.street != null && sbc.street != 'null') {
                                serImpAdd.B2B_Street__c = sbc.street;
                            }
                            if(sbc.house_number != null && sbc.house_number != 'null') {
                                serImpAdd.LG_Care_House_Number__c = sbc.house_number;
                            }
                            if(sbc.house_number_addition != null && sbc.house_number_addition != 'null') {
                                serImpAdd.LG_Care_House_Number_Extension__c = sbc.house_number_addition;
                            }
                            if(sbc.city != null && sbc.city != 'null') {
                                serImpAdd.B2B_City__c = sbc.city;
                            }
                            if(sbc.zip != null && sbc.zip != 'null') {
                                serImpAdd.B2B_Postcode__c = sbc.zip;
                            }
                            ListSerImp.add(serImpAdd);
                        }
                    }
                    
                    List<Service_Impacted__c> listOfSimpacted = new List<Service_Impacted__c>();
                    listOfSimpacted = [SELECT id FROM Service_Impacted__c where B2B_Case_Number__c = :targetCase.Id LIMIT 9000];
                    if(listOfSimpacted.size() > 0 )
                        database.delete(listOfSimpacted);
                    
                    if(ListSerImp != null && ListSerImp.size() > 0) {
                        try{
                            Database.insert(ListSerImp);
                            sf_jsonResponse = '{"response": {"success": "true"}}';
                            res.statusCode = 200;
                            res.responseBody = blob.valueOf(sf_jsonResponse);
                            res.addHeader('Content-Type', 'application/json');
                        }
                        Catch(Exception e) {
                            sf_jsonResponse = '{"response": {"success": "false", "errorMessage": "'+e.getMessage()+'"}}';
                            res.statusCode = 500;
                            res.responseBody = blob.valueOf(sf_jsonResponse);
                            res.addHeader('Content-Type', 'application/json');
                            LG_ServiceTechnicalFailure.createCalloutFailureResult(null,null,null,'SBC System',null,sf_jsonResponse, req.requestBody.toString(), null);
                        }
                    }
                    
                }
            }
        }
        return;
    }
    
    public static List<SBCdatas> requestReaderJSON(JSONParser parser) {
        List<SBCdatas> sbcdataList = new List<SBCdatas>();
        SBCdatas sbcdata = null;
        Boolean flag = false; String text;
        JSONToken token; String value;
        while(parser.nextToken() != null) {
            
            token = parser.getCurrentToken();
            text = parser.getText();
            
            
            if(text.equalsIgnoreCase('outageId')) {
                parser.nextToken();
                value = parser.getText();
                outageId = value.trim();
                flag = true;
            }
            if(flag == true && text.equalsIgnoreCase('data')) {
                while(parser.nextToken() != null) {
                if(parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while(parser.nextToken() != JSONToken.END_ARRAY) {
                    sbcdata = JSONObjectParser(parser);
                    
                    if(sbcdata != null)
                        sbcdataList.add(sbcdata);
                }
                }
                }
            }
            
        }
        return sbcdataList;
    }
    
    public static SBCdatas JSONObjectParser(JSONParser parser) {
        SBCdatas sbcdata = new SBCdatas();
        String value;
        String text;
        JSONToken token;
        while(parser.nextToken() != JSONToken.END_OBJECT) {
            token = parser.getCurrentToken();
            text = parser.getText();
            
            if(token == JSONToken.FIELD_NAME && text.equalsIgnoreCase('customer-number')) {
                parser.nextToken();
                value = parser.getText();
                sbcdata.customer_number = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && text.equalsIgnoreCase('customer-type')) {
                parser.nextToken();
                value = parser.getText();
                sbcdata.customer_type = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && text.equalsIgnoreCase('region')) {
                parser.nextToken();
                value = parser.getText();
                sbcdata.region = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && text.equalsIgnoreCase('street')) {
                parser.nextToken();
                value = parser.getText();
                sbcdata.street = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && text.equalsIgnoreCase('house-number')) {
                parser.nextToken();
                value = parser.getText();
                sbcdata.house_number = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && text.equalsIgnoreCase('house-number-addition')) {
                parser.nextToken();
                value = parser.getText();
                sbcdata.house_number_addition = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && text.equalsIgnoreCase('city')) {
                parser.nextToken();
                value = parser.getText();
                sbcdata.city = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && text.equalsIgnoreCase('zip')) {
                parser.nextToken();
                value = parser.getText();
                sbcdata.zip = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && text.equalsIgnoreCase('macs') && parser.nextToken() == JSONToken.START_ARRAY) {
                while(parser.nextToken() != JSONToken.END_ARRAY) {
                    value = parser.getText();
                    sbcdata.macs.add(value);
                }
            }
        }
        return sbcdata;
    }
    
    public class SBCdatas {
        String customer_number;
        String customer_type;
        String region;
        String street;
        String house_number;
        String house_number_addition;
        String city;
        String zip;
        Set<String> macs = new Set<String>();
    }
}