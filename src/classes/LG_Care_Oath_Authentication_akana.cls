/************************************************************************************************************************************
*        Class: LG_Care_Oath_Authentication_akana
*     Program : B2B CARE CATALYST PROGRAM
*  Description: Class Created for Generating Authentication Token when sending request to webservices
*    Author(s): Rishi Kapoor (Infosys Limited), Abhisek Mishra
* Created Date: 07-AUG-2017
*	Test Class: LG_Care_Oath_Authentication_akanaTest, LG_Care_akana_MockHttpResponseGenerator
*************************************************************************************************************************************/

Public Class LG_Care_Oath_Authentication_akana{
    
    public Static B2B_Akana_Oath__c CreateToken(){
        
        B2B_Akana_Oath__c  akanaOauth = B2B_Akana_Oath__c.getInstance('USMS Oath Akana');
        String ResCode;
        String accessToken;
        HttpRequest req;HTTPResponse res;
        
        try{
        if(akanaOauth.Token_Date__c == null || akanaOauth.Token_Date__c <= system.now()){
            akanaOauth.Access_Token__c = '';
            
            req = new HttpRequest();
            req.setEndpoint(akanaOauth.End_URL__c);
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setBody(akanaOauth.Authorization_Body__c);
            
            
            Http http = new Http();
            res = http.send(req);
            
            ResCode=res.getBody();
            
            JSONParser parser = JSON.createParser(ResCode);
            while(parser.nexttoken() !=null){
            
                if (parser.getCurrentToken() == JSONToken.START_OBJECT){ 
                                    
                    while (parser.nextToken() !=  null){ 
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'access_token')){
                            parser.nextToken();
                            akanaOauth.Access_Token__c = 'Bearer ' + parser.getText();
                        }
                        else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'expires_in')){
                            parser.nextToken();
                            Integer expiresIn = Integer.valueOf(parser.getText());
                            Datetime dt = Datetime.now();
                            akanaOauth.Token_Date__c= dt.addSeconds(expiresIn);
                        } 
                    }
                }
            
            }
            accessToken=akanaOauth.Access_Token__c;
            //Database.Update(akanaOauth);
        
        }
        else{
            accessToken=akanaOauth.Access_Token__c;
        }
        }
        catch(Exception e) {
            LG_ServiceTechnicalFailure.createCalloutFailureResult(null,null,null,'Akana System',null,e.getStackTraceString(), req.getBody(), res.getBody());
        }
        
        
        //return accessToken;
        return akanaOauth;
    
    }

}