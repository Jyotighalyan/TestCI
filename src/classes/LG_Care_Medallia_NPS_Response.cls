@RestResource(urlMapping ='/npsexport/*')
global with sharing class LG_Care_Medallia_NPS_Response{

    @HttpPost
    Global Static void NPSUpdate(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String Str = req.requestbody.toString();
        String sf_json;
        try{ 
        List<NPSWrapper> wrapperList =ParseResponse(str);
        NPS_Result__c NPSRecord = new NPS_Result__c();
        Case caseObj = new Case();
        Opportunity oppObj = new Opportunity();
        csord__Solution__c subOrderObj = new csord__Solution__c();
        Contact contObj= new Contact();
        NPS_Result__c NPSObj= new NPS_Result__c();
         
        if(wrapperList[0].surveyType == 'Help' && wrapperList[0].recordId != null){
            caseObj = [SELECT Id,CaseNumber,ContactId,AccountId from Case where CaseNumber =: wrapperList[0].recordId limit 1];
            NPSRecord.Case_ID__c = caseObj.Id;
            NPSRecord.Contact_Name__c = caseObj.ContactId;
            NPSRecord.Account_Name__c = caseObj.AccountId;
        }
        else if(wrapperList[0].surveyType == 'Buy' && wrapperList[0].recordId != null){
            oppObj = [SELECT Id,LG_PrimaryContact__c,AccountId from Opportunity where Opportunity_ID__c =: wrapperList[0].recordId limit 1];
            NPSRecord.Opportunity_ID__c = oppObj.Id;
            NPSRecord.Contact_Name__c = oppObj.LG_PrimaryContact__c;
            NPSRecord.Account_Name__c = oppObj.AccountId;
        }
        else if(wrapperList[0].surveyType == 'Install' && wrapperList[0].recordId != null){
            subOrderObj = [SELECT Id,LG_Address__r.LG_TechnicalContact__c,csord__Order__r.csord__Account__c from csord__Solution__c where Id =: wrapperList[0].recordId limit 1];
            NPSRecord.Sub_Order_ID__c = subOrderObj.Id;
            NPSRecord.Contact_Name__c = subOrderObj.LG_Address__r.LG_TechnicalContact__c;
            NPSRecord.Account_Name__c = subOrderObj.csord__Order__r.csord__Account__c;
        }
        else if(wrapperList[0].surveyType == 'Relationship' && wrapperList[0].custId != null){
            
            contObj = [SELECT Id,Email,Accountid,LG_Care_Survey_Opt_Out__c,B2B_Bounced_Category_pklst__c from Contact where Id =: wrapperList[0].custId limit 1];
            NPSRecord.Contact_Name__c = contObj.Id;
            NPSRecord.Account_Name__c = contObj.Accountid;
            
         }
       
        if(wrapperList[0].MedalliaId !=null)
        {
        List<NPS_Result__c> NPSObjTemp =[Select id,Medallia_URL__c,NPS_Score__c  from NPS_Result__c where Medallia_ID__c=:wrapperList[0].MedalliaId limit 1];
        NPSRecord.Medallia_ID__c=wrapperList[0].MedalliaId;
        if(NPSObjTemp.size() > 0)
        NPSRecord.Id = NPSObjTemp[0].Id;
        }
        
        Contact cnNps=[Select id,LG_Care_Survey_Opt_Out__c,B2B_Bounced_Category_pklst__c from Contact where id=: NPSRecord.Contact_Name__c];
        if(wrapperList[0].SurveyOpt=='Yes')
        {
        cnNps.LG_Care_Survey_Opt_Out__c=true;
        }
        else{
        cnNps.LG_Care_Survey_Opt_Out__c=false;
        }
        if(wrapperList[0].expirationdate!='null')NPSRecord.B2B_Care_Expiration_date__c=Datetime.valueof(wrapperList[0].expirationdate);
       
        cnNps.B2B_Bounced_Category_pklst__c=wrapperList[0].bouncedcategory;
      
        if(wrapperList[0].AlertStatus !='null')
        {
           if(wrapperList[0].AlertStatus=='New' || wrapperList[0].AlertStatus=='In progress' || wrapperList[0].AlertStatus=='Escalated' ||
               wrapperList[0].AlertStatus=='Overdue' || wrapperList[0].AlertStatus=='Closed')     
           {
               NPSRecord.B2B_Care_Alert_Status__c= wrapperList[0].AlertStatus;
           }
           else
           {
               NPSRecord.B2B_Care_Alert_Status__c='';
           }
           
        }  
        if(wrapperList[0].reminddate!='null')NPSRecord.B2B_Care_Reminded_date__c=Datetime.valueof(wrapperList[0].reminddate);
        NPSRecord.B2B_Care_Bounced_categories__c=wrapperList[0].bouncedcategory;
        NPSRecord.Customer_Email__c=wrapperList[0].Email;
        NPSRecord.Medallia_URL__c=wrapperList[0].MedalliaUrl;
        NPSRecord.NPS_Score__c=wrapperList[0].NPSScore;       
        if(wrapperList[0].ResponseDate!='null')NPSRecord.Response_Date__c=Datetime.valueOf(wrapperList[0].ResponseDate);       
        NPSRecord.Survey_Status__c=wrapperList[0].SurveyStatus;
        NPSRecord.Name = wrapperList[0].surveyType;
        if(NPSRecord != null){
                Update cnNps;
                Upsert NPSRecord;
                sf_json='{"response": {"success": "true"}}';
                res.statusCode = 200;
                res.responseBody =blob.valueof(sf_json);
                res.addHeader('Content-Type', 'application/json');
                return;
            }

        }
        Catch(Exception e){
        sf_json='{"response":{"success": "false","errorMessage": "'+e.getMessage()+'"}}';
        res.statusCode=500;
        res.responseBody =blob.valueof(sf_json);
        res.addHeader('Content-Type', 'application/json');
        LG_ServiceTechnicalFailure.createCalloutFailureResult(null,null,null,'Medallia System',null,sf_json, req.requestBody.toString(), null);
        return;
        
        }
    
    }
    

    
    public Static List<NPSWrapper> ParseResponse(String str) {
        List<NPSWrapper> NPSList= new List<NPSWrapper>();
        
        if(str!=null){
        
        
            NPSWrapper Wrappers = new NPSWrapper();
            JSONParser parser = JSON.createParser(str);
            while(parser.nexttoken() !=null){
          
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT){ 
                        
                            while (parser.nextToken() !=  null){ 
                                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'ACCOUNT_ID')){
                                    parser.nextToken();
                                    Wrappers.AccountName=parser.getText();
                                }
                                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'RECORD_ID')){
                                    parser.nextToken();
                                    Wrappers.recordId =parser.getText();
                                }
                                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'CUSTOMER_ID')){
                                    parser.nextToken();
                                    Wrappers.custId =parser.getText();
                                }
                    
                                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'Opted_out')){
                                    parser.nextToken();
                                    Wrappers.SurveyOpt=parser.getText();
                                }
                                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'CUSTOMER_EMAIL')){
                                    parser.nextToken();
                                
                                    Wrappers.Email=parser.getText();
                                }
                                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'Medallia_URL')){
                                    parser.nextToken();
                               
                                    Wrappers.MedalliaUrl=parser.getText();
                                }
                                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'Response_date')){
                                    parser.nextToken();
                                  
                                    Wrappers.ResponseDate=parser.getText();
                                }
                                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'Survey_status')){
                                    parser.nextToken();
                                    
                                    Wrappers.SurveyStatus=parser.getText();
                                }
                                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'NPS_score')){
                                    parser.nextToken();
                                  
                                    Wrappers.NPSScore=parser.getText();
                                } 
                                
                                
                                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'Auto_closed')){
                                    parser.nextToken();
                                  
                                    Wrappers.NPSScore=parser.getText();
                                } 
                                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'SURVEY_TYPE')){
                                    parser.nextToken();
                                   
                                    Wrappers.surveyType = parser.getText();
                                }
                                
                               else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'Bounced_categories')){
                                    parser.nextToken();
                                   
                                    Wrappers.bouncedcategory= parser.getText();
                                }
                               else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'Creation_date')){
                                    parser.nextToken();
                                   
                                    Wrappers.creationdate= parser.getText();
                                }
                               else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'Reminded_date')){
                                    parser.nextToken();
                                   
                                    Wrappers.reminddate= parser.getText();
                                }
                               else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'Expiration_date')){
                                    parser.nextToken();
                                   
                                    Wrappers.expirationdate= parser.getText();
                                }
                              else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'Medallia_Id')){
                                    parser.nextToken();
                                   
                                    Wrappers.MedalliaId= parser.getText();
                                }
                             else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'Alert_status')){
                                    parser.nextToken();
                                   
                                    Wrappers.AlertStatus= parser.getText();
                                }
                            }
                        }
                 
                
                
            }
            NPSList.add(Wrappers);
                    
        }
        return NPSList;
    }

    
    Public Class NPSWrapper{
        public String AccountName;
        public String ContactName;
        public String recordId;
        public String Email;
        public String MedalliaUrl;
        public String ResponseDate;
        public String SurveyStatus;
        public String NPSScore;
        public String surveyType;
        public String bouncedcategory;
        public String expirationdate;
        public String MedalliaId;
        public String reminddate;
        public String creationdate;
        public String AlertStatus;
        public String custId ;
        public String SurveyOpt;
        public String AutoClose;
       
    
}


}