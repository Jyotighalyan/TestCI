/************************************************************************************************************************************
*        Class: LG_Care_SendRequest_SBC
*     Program : B2B CARE CATALYST PROGRAM
*  Description: Sending Request to Spider .
*    Author(s): Rishi Kapoor (Infosys Limited)
* Created Date: 04-AUG-2017
*   Test Class: LG_Care_SendRequest_SBC_Test 
*************************************************************************************************************************************/

Global with Sharing Class LG_Care_SendRequest_SBC{
    
    Static String resp;
    public Static String Outage_id;
    Static String Customer_type;
    public static HTTPResponse res;
    public Static String JFile ;
    @InvocableMethod(label='SBC Send Request')
    Public static void TriggerSpider(List<id> CId){
        try{
          
            SendJSonSpider(CId);
           }
           Catch(Exception e) {
                   throw e;
           }
    }

    @future(Callout=true)
    public Static void SendJsonSpider(List<id> CId){
    try{
    Case cs =[Select id,USMS_Ticket_ID__c from Case where id=:CId[0]];
    Outage_id=cs.USMS_Ticket_ID__c;
    Customer_type='BN';
    SendReqSpider(Outage_id ,CId[0]);
    
    }
    catch(exception e)
    {}
    
    }

    Static void SendReqSpider(String outageId, String CaseId){
    B2B_Care_Ext_Connections__c SpiderCon = B2B_Care_Ext_Connections__c.getInstance('SBC Spider External System');
    HttpRequest req;
    try{
        
        
        String endUrlTemp = SpiderCon.Connection_URL__c;
        String endUrl = endUrlTemp.replace('outageid', outageId);
        
        req = new HttpRequest();
        req.setTimeout(120000);
        req.setEndpoint(endUrl); 
        req.setMethod('GET');
        req.setHeader('Authorization', SpiderCon.Authentication_Token__c);
        Double noOfTries = SpiderCon.UM_No_of_Tries__c;
        Http http = new Http();
        
        while(noOfTries != 0) {
        res = http.send(req);
        if(res.getStatusCode() != 200){
            noOfTries = noOfTries - 1;
        }
        else
        noOfTries = 0;
         }
        
       Case CsUpdate= New Case();
       CsUpdate.id=CaseId;
       JSONParser parser = JSON.createParser(res.getbody());
       while(parser.nexttoken() !=null){
          
           if (parser.getCurrentToken() == JSONToken.START_OBJECT){ 
                      
             while (parser.nextToken() !=  null){ 
                 if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'Status')){
                     CsUpdate.B2B_Success__c=Boolean.valueOf(parser.getText());
                     parser.nextToken();
              }
                 else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'message')){
                     CsUpdate.B2B_Error_Message__c=parser.getText();
                     parser.nextToken();
                } 
                 else if((parser.getCurrentToken()== JSONToken.FIELD_NAME) &&(parser.getText() =='Status-code')){  
                     CsUpdate.B2B_Error_Code__c=parser.getText();
                     parser.nextToken();
                     
                }
             } 
 
          }

     } 
}
        catch(Exception e) {
            LG_ServiceTechnicalFailure.createCalloutFailureResult(null,null,null,'SBC System',null,e.getStackTraceString(), req.getBody(), res.getBody());
        }

    }
}