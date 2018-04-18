/************************************************************************************************************************************
*        Class: LG_Care_Medallia_Send_SurveyOptOut
*     Program : B2B CARE CATALYST PROGRAM
*  Description: This will send the optout request to Medallia
*    Author(s): Abhisek Mishra (Infosys Limited)
* Created Date: 12-FEB-2018
*   Test Class: LG_Care_Medallia_Send_SurveyOptOut_Test & LG_Care_Medallia_Send_SurveyOptout_Mock
*************************************************************************************************************************************/
public class LG_Care_Medallia_Send_SurveyOptOut {
    Static final B2B_Care_Ext_Connections__c medalliaConn = B2B_Care_Ext_Connections__c.getInstance('Medallia SurveyOptOut');
    @InvocableMethod(label='Send Optout')
    public static void medallia_SurveyOptout_JSON_Request(List<Id> conId) {
        
        Contact con = [SELECT id, email, LG_Care_Survey_Opt_Out__c FROM Contact WHERE id =:conId[0]];
        if(con.LG_Care_Survey_Opt_Out__c) {
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('Customer_email',con.Email);
            gen.writeEndObject();
            String jsonString = gen.getAsString();
            send_Request_to_Medallia(jsonString, con.id);
        }
    }
    
    @future(callout=true)
    public static void send_Request_to_Medallia(String body,id conId) {
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        try {
            req.setMethod('POST');
            req.setHeader('content-type', 'application/json');
            req.setEndpoint(medalliaConn.Connection_URL__c);
            req.setTimeout(120000);
            req.setBody(body);
            Double noOfTries = medalliaConn.UM_No_of_Tries__c;
            Http h = new Http();
            while(noOfTries > 0) {
                res = h.send(req); 
                if(res.getStatusCode() != 200){
                    noOfTries = noOfTries - 1; 
                }
                else
                    noOfTries = 0;
            }
            /*
            String result = res.getBody();
            if (!result.Contains('OK')) {
                Contact con = new Contact();
                con.LG_Care_Survey_Opt_Out__c = false;
                update con;
            } */
            
        }
        Catch(Exception e) {
            LG_ServiceTechnicalFailure.createCalloutFailureResult(null,null,null,'Medallia SurveyOptout System',null,e.getStackTraceString(), req.getBody(), res.getBody());
        }
    }
}