/************************************************************************************************************************************
*        Class: LG_Care_UpdateChildCase_From_USMS 
*     Program : B2B CARE CATALYST PROGRAM
*  Description: This is an exposed rest web service. This will update the status, resolution time & description of a case. 
*               It will also create a case comment based on the attributes sent from USMS to SF.
*    Author(s): Abhisek Mishra (Infosys Limited)
* Created Date: 02-AUG-2017
*   Test Class: LG_Care_UpdateChildCase_From_USMSTest 
*************************************************************************************************************************************/
@RestResource(URLMapping='/updatechildcase/*')
global class LG_Care_UpdateChildCase_From_USMS {
    static string sf_jsonResponse = '';
    
    @HttpPOST
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        if(req.requestBody != null) {
            List<childClassWrapper> childCaseToUpdate = new List<childClassWrapper>();
            System.debug('-------------------- '+req.requestBody.toString());
            JSONParser parser = JSON.createParser(req.requestBody.toString());
            childCaseToUpdate = JSONRequestReader(parser);
           try{
            if(childCaseToUpdate != null && childCaseToUpdate.size() > 0) { 
                List<String> USMSTicketIds = new List<String>();
                List<Case> updateCases = new List<Case>();
                List<CaseComment> caseComments = new List<CaseComment>();
                
                for(childClassWrapper c: childCaseToUpdate) {
                    usmsTicketIds.add(c.usmsTicketId);
                }
                for(Case c: [SELECT id,USMS_Ticket_ID__c,Description,LG_Estimated_resolution_time__c,status FROM Case WHERE USMS_Ticket_ID__c in :USMSTicketIds]) {
                    for(childClassWrapper ccw: childCaseToUpdate) {
                        if(c.USMS_Ticket_ID__c == ccw.usmsTicketId) {
                            if(ccw.status != null) {
                                c.status = ccw.status;
                            }
                            if(ccw.EstimatedResolutionTime != null && ccw.EstimatedResolutionTime != '') {
                                c.LG_Estimated_resolution_time__c = convertStringToDateTime(ccw.EstimatedResolutionTime);
                            }
                            if(ccw.Description != null) {
                                c.description = c.description + '\n' + ccw.Description;
                            }
                            if(ccw.workInfoNotes != null && ccw.workInfoTypes != null) {
                                CaseComment cc = new CaseComment();
                                cc.CommentBody = ccw.workInfoTypes + ' - ' + ccw.workInfoNotes;
                                cc.IsPublished = true;
                                cc.ParentId = c.Id;
                                caseComments.add(cc);
                            }
                            updateCases.add(c);
                        }
                    }
                }
              
                    if(updateCases != null && updateCases.size() > 0) {
                        if(caseComments != null && caseComments.size() > 0) {
                            Database.insert(caseComments);
                        }
                        Database.update(updateCases);
                        sf_jsonResponse = '{"response": {"success": "true"}}';
                        res.statusCode = 200;
                        res.responseBody = blob.valueOf(sf_jsonResponse);
                        res.addHeader('Content-Type', 'application/json');
                    }
              }
             }
                Catch(Exception e) {
                    sf_jsonResponse = '{"response": {"success": "false", "errorMessage": "'+e.getMessage()+'"}}';
                    res.statusCode = 500;
                    res.responseBody = blob.valueOf(sf_jsonResponse);
                    res.addHeader('Content-Type', 'application/json');
                    LG_ServiceTechnicalFailure.createCalloutFailureResult(null,null,null,'USMS System',null,sf_jsonResponse, req.requestBody.toString(), null);
                }
            }
        
        return;
    }
    
    public static List<childClassWrapper> JSONRequestReader(JSONParser parser) {
        List<childClassWrapper> ccwCases = new List<childClassWrapper>();
        childClassWrapper ccw;
        While(parser.nextToken() != null) {
            if(parser.getCurrentToken() == JSONToken.START_OBJECT) {
                ccw = JSONObjectParser(parser); 
                if(ccw != null) {
                    ccwCases.add(ccw);
                }
            }
            if(parser.nextToken() == JSONToken.END_ARRAY) {
                break;
            }
        }
        return ccwCases;
    }
    
    public static childClassWrapper JSONObjectParser(JSONParser parser) {
        childClassWrapper ccw = new childClassWrapper();
        String text;
        String value;
        JSONToken token;
        while(parser.nextToken() != JSONToken.END_OBJECT) {
            token = parser.getCurrentToken();
            text = parser.getText();
            
            if(token == JSONToken.FIELD_NAME && text == 'IncidentId') {
                parser.nextToken();
                value = parser.getText();
                ccw.usmsTicketId = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && text == 'IncidentStatus') {
                parser.nextToken();
                value = parser.getText();
                ccw.status = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && text == 'IncidentEndTime') {
                parser.nextToken();
                value = parser.getText();
                ccw.EstimatedResolutionTime = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && text == 'IncidentNotes') {
                parser.nextToken();
                value = parser.getText();
                ccw.Description = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && text == 'WorkInfoNotes') {
                parser.nextToken();
                value = parser.getText();
                ccw.workInfoNotes = value.trim();
            }
            else if(token == JSONToken.FIELD_NAME && text == 'WorkInfoType') {
                parser.nextToken();
                value = parser.getText();
                ccw.workInfoTypes = value.trim();
            }
        }
        return ccw;
    }
    
    public static DateTime convertStringToDateTime(String value) {
        String stringDateTimeValue = value.replace('T',' ');
        DateTime d = DateTime.valueOf(stringDateTimeValue);
        return d;
    }
    
    public class childClassWrapper {
        String usmsTicketId;
        String status;
        String EstimatedResolutionTime;
        String Description;
        String workInfoNotes;
        String workInfoTypes;
    }
}