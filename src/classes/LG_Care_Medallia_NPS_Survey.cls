global class LG_Care_Medallia_NPS_Survey {    
    
    Static final B2B_Care_Ext_Connections__c medalliaConn = B2B_Care_Ext_Connections__c.getInstance('Medallia External System Info');
    public static HTTPResponse res;
    // arguments for NPS. 
    static String  account_id; 
    static String  record_id; 
    public Static String RqstFile;
    static string  customer_email; 
    static string  survey_type; 
    static string  brand; 
    
    static String  channel_id; 
    static string  product_family; 
    static string  product_description; 
    static string  case_record_type; 
    static string  case_type; 
    
    static string  case_reason; 
    static string  service_name;    
    static string  sf_user_role; 
    static string  caseowner;
    static string  account_name;
    static string  contact_name;
    
    
    public Static B2B_Care_Ext_Connections__c NPSConn;   
    
    //    public string  customerid;  this is not required in SFCTB-143
    //    public string  contact_role;   this is not required in SFCTB-143
    
        
    @InvocableMethod(label='NPS Transaction')
    public static void Create_Medallia_NPS_JSON_Request(List<Id> NPSCaseid) {
     
     try {
     
             service_name = '';
             product_family = '';
             product_description = '';
             channel_id = '';
             customer_email = '';
             brand = '';
             record_id = '';
             case_record_type = '';
             case_type = '';
             case_reason = '';
             caseowner = '';
             sf_user_role = '';
             account_name='';
             contact_name='';
             
             Case ca = [select id,Account.LG_AccountNumber__c,Account.Name  from case where id=: NPSCaseid[0] limit 1];
                          
            
            /* acclist = [Select ID, LG_AccountNumber__c from Account where Id =: ca.Account.id ];
             */
            List<Case> NPSCase=[Select id, ownerid, RecordType.Name, caseNumber, ContactEmail, Origin, type, LG_Case_Reason__c,   
                                B2B_Care_PE_Customer_Country_Info__c,LG_Service__c,Contact.Name from Case where id=:NPSCaseid[0] limit 1 ] ;
           
            account_id = ca.Account.LG_AccountNumber__c;
            account_name=ca.Account.Name;
            //survey_type = 'Help'; 
           
            if( NPSCase[0].Origin != null ) {  
                    channel_id = NPSCase[0].Origin;
                    }
                    
             if( NPSCase[0].caseNumber != null ) {  
                    record_id = NPSCase[0].caseNumber;
                    }
                    
             if( NPSCase[0].RecordType.Name != null ) {  
                  case_record_type = NPSCase[0].RecordType.Name;
                  }
                    
             if( NPSCase[0].type != null ) {  
                  case_type = NPSCase[0].type;
                  }
                    
             if( NPSCase[0].LG_Case_Reason__c != null ) {  
                  case_reason = NPSCase[0].LG_Case_Reason__c;
                  }    
                    
             if( NPSCase[0].ContactEmail != null ) {  
                  customer_email = NPSCase[0].ContactEmail;
                  }
                    
             if( NPSCase[0].ownerid != null ) {  
                  caseowner = NPSCase[0].ownerid;
                  }
                                                     
             if( NPSCase[0].Contact.Name!= null ) {  
                  contact_name= NPSCase[0].Contact.Name;
                  }  
            //channel_id = NPSCase[0].Origin;
            //record_id = NPSCase[0].caseNumber;
            //case_record_type = NPSCase[0].RecordType.Name; 
            //case_type = NPSCase[0].type;
            //case_reason = NPSCase[0].LG_Case_Reason__c;
            //customer_email = NPSCase[0].ContactEmail;
            //caseowner = NPSCase[0].ownerid;
            
            if (NPSCase[0].B2B_Care_PE_Customer_Country_Info__c != null){
                NPSConn = B2B_Care_Ext_Connections__c.getInstance(NPSCase[0].B2B_Care_PE_Customer_Country_Info__c); 
                brand = NPSConn.Brand__c; 
                
            }
                
            if( caseowner.startswith('005')){    
            User u = [Select UserRole.Name from user where id=: caseowner limit 1];  
            
            if( u.UserRole.Name != null ) {  
                  sf_user_role = u.UserRole.Name;
                  }
            }
            else {
            sf_user_role = '';
            }
            
         
            if(NPSCase[0].LG_Service__c != null){          
            for(csord__Service__c service : [SELECT Name, LG_ProductFamily__c, UM_ProductDescription__c FROM csord__Service__c WHERE id=: NPSCase[0].LG_Service__c limit 1] ) {
                
                if( service.Name != null ) {  
                    service_name = service.Name;
                    }                
                    
                 if( service.LG_ProductFamily__c != null ) {  
                    product_family = service.LG_ProductFamily__c;
                    }               
                    
                 if( service.UM_ProductDescription__c != null ) {  
                    product_description = service.UM_ProductDescription__c;
                    }
                  
            }
            }
               
            // create JSON request.
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            
            //gen.writeStartObject();
            
            gen.writeStringField('ACCOUNT_ID', account_id);
            gen.writeStringField('ACCOUNT_NAME', account_name);
            gen.writeStringField('RECORD_ID', record_id);
            gen.writeStringField('CUSTOMER_NAME', contact_name); 
            gen.writeStringField('CUSTOMER_EMAIL', customer_email);
            gen.writeStringField('SURVEY_TYPE', 'Help');
            gen.writeStringField('BRAND', brand);
            gen.writeStringField('CHANNEL_ID', channel_id);
            gen.writeStringField('Case_Origin', channel_id);
            gen.writeStringField('PRODUCT_FAMILY', product_family);
            gen.writeStringField('PRODUCT_DESCRIPTION', product_description);
            gen.writeStringField('CASE_RECORD_TYPE', case_record_type);
            gen.writeStringField('CASE_TYPE', case_type);
            gen.writeStringField('CASE_REASON', case_reason);
            gen.writeStringField('SERVICE_NAME', service_name);
            gen.writeStringField('SF_USER_ROLE',sf_user_role);
            
            gen.writeEndObject();
            
            RqstFile=gen.getAsString();
            LG_Care_Medallia_NPS_Survey.NPSRequest(RqstFile, NPSCase[0].id);

        } 
     catch(Exception e) {
        }
    
    }
    
@Future(callout =true)   
Public static void NPSRequest(string body, String CaseId){
  HttpRequest req;
  try{
           
     Case NPSCase= new Case();
     NPSCase.Id = CaseId;       
     system.debug('file'+ body);      
    req = new HttpRequest();
    req.setMethod('POST');
    req.setHeader('content-type', 'application/json');
   // req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId() );
    //req.setEndpoint( '<a href="https://libertyglobal.medallia.eu/libertyglobalb2b.feed?unitymediainvitation" target="_blank" rel="nofollow"'>https://libertyglobal.medallia.eu/libertyglobalb2b.feed?unitymediainvitation'</a>' );
    req.setEndpoint(medalliaConn.Connection_URL__c);//custom settings
    //req.setEndpoint('https://libertyglobal.medallia.eu/libertyglobalb2b.feed?unitymediainvitation');
       
    Double noOfTries = medalliaConn.UM_No_of_Tries__c;//custom settings
      
    req.setBody( body );
    
    Http http = new Http();
    req.setTimeout(120000); // timeout in milliseconds
    
     while(noOfTries != 0) {
        
        res = http.send(req);
       
        if(res.getStatusCode() != 200){
           noOfTries = noOfTries - 1; 
        }
        else
        noOfTries = 0;
        }
    
   
        String result = res.getBody();
        if (result.Contains('ok')) 
      {     
        NPSCase.B2B_Success__c = true;    
      }
                                      
      Database.Update(NPSCase);
            
     }
  catch(Exception e) {
     LG_ServiceTechnicalFailure.createCalloutFailureResult(null,null,null,'Medallia System',null,e.getStackTraceString(), req.getBody(), res.getBody());
     
   }
        }
    
    
}