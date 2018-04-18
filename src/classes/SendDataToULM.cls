global class SendDataToULM {
    
   webservice  static integer sendData(string ulmUserId){
        
       String contactMobilePhone;  
       String contactPhone;
       String contactSalutation;
       String contactUserId;
       String contactfirstName;
       String contactlastName;
       String contactULMUserId;
       String endpointURL;
       String substringURL;

       //query contact fields based on Contact ULM User Id field which is an email id 
       contact con = [SELECT LG_SalutationLocal__c, MobilePhone, B2B_ULM_User_Id__c, firstName, lastName, Phone FROM contact WHERE B2B_ULM_User_Id__c=:ulmUserId ];
       system.debug('ulmUserId'+ulmUserId);       
       
       if(con!=null){
           contactMobilePhone = con.MobilePhone;    //all contact field values are converted to string
           contactPhone = con.Phone;
           contactSalutation = con.LG_SalutationLocal__c;
           contactUserId = con.B2B_ULM_User_Id__c;
           contactfirstName = con.FirstName;
           contactlastName = con.LastName;
           //contactULMUserId = con.B2B_ULM_User_Id__c;
       }
           
       HttpRequest req = new HttpRequest();
     
     B2B_Akana_Oath__c oauthToken=LG_Care_Oath_Authentication_akana.CreateToken();    //AKANA class called to fetch token 
       system.debug('oauthToken value ===='+oauthToken);
       B2B_Care_Ext_Connections__c selfCareContactSync = B2B_Care_Ext_Connections__c.getInstance('Self Care Contact Sync'); //custom setting to set endpoint
       system.debug('selfCareContactSync===='+selfCareContactSync);
       endpointURL = selfCareContactSync.Connection_URL__c;
       system.debug('endpointURL is ==='+endpointURL);
       substringURL = endpointURL.replace('Username', contactUserId);
       system.debug('substringurl is +++'+substringURL);
       
     req.setEndpoint(substringURL);
       system.debug('akana-ulm connection url===='+selfCareContactSync.Connection_URL__c);

     req.setMethod('POST');                      //ULM accepts only POST request and since its update
     req.setHeader('Content-Type','text/json;charset=UTF-8');
       req.setHeader('Authorization', oauthToken.Access_Token__c );      //Pass akana token as input to ULM

     req.setBody(JSON.serialize(con));                  // Serialize JSON request
       system.debug('body =='+JSON.serialize(con));        
             
           JSONGenerator gen = JSON.createGenerator(true);            //create JSONGenerator to customize the requested structure
            gen.writeStartObject();
             gen.writeStringField('emailAddress', contactUserId);
             gen.writeFieldName('attributes');
             gen.writeStartArray();
       
           gen.writeStartObject();
            gen.writeStringField('name', 'user.LastName');
            gen.writeStringField('value', contactlastName);
            gen.writeEndObject();

            gen.writeStartObject();
           if(contactSalutation!=null){
      gen.writeStringField('name', 'user.Salutation');
           gen.writeStringField('value', contactSalutation);
            }
           else
           {      
             gen.writeStringField('name', 'user.Salutation');
           gen.writeStringField('value', '');
           }
            gen.writeEndObject();

           gen.writeStartObject();
           if(contactMobilePhone!=null){
            gen.writeStringField('name', 'user.MobileNumber');
           gen.writeStringField('value', contactMobilePhone);
            }
           else{
            gen.writeStringField('name', 'user.MobileNumber');
           gen.writeStringField('value', '');
           }
            gen.writeEndObject();

            gen.writeStartObject();
           if(contactfirstName!=null){
           gen.writeStringField('name', 'user.FirstName');
            gen.writeStringField('value', contactfirstName);
           }
           else{
            gen.writeStringField('name', 'user.FirstName');
            gen.writeStringField('value', '');
           }
           gen.writeEndObject();
       
           gen.writeStartObject();
           //if(contactPhone!=null){
           gen.writeStringField('name', 'user.BusinessPhone');
            gen.writeStringField('value',  contactPhone);
            //}
           //else{
            //gen.writeStringField('name', 'user.BusinessPhone');
            //gen.writeStringField('value',  '');
           //}
           gen.writeEndObject();

            
       gen.writeEndArray();
       gen.writeEndObject();
       system.debug('gen.getAsString() '+gen.getAsString());
       
       req.setBody(gen.getAsString());
       
       req.setBody(gen.getAsString());
       system.debug('Request body'+req.getBody());
       system.debug('Request is'+req);

        HttpResponse res = new Http().send(req);      //send request to ULM
        system.debug('response==='+res.getBody());
        return res.getStatusCode();
    }
}
